using dominio;
using negocio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TP_Final_Programacion_III
{
    public partial class Administracion : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Seguridad.EsAdmin(Session["usuario"]))
            {
                Response.Redirect("Default.aspx", false);
                return;
            }

            litMensaje.Text = "";

            if (!IsPostBack)
            {
                try
                {
                    SetearTipoActual(TipoCatalogoAdmin.Area);
                    CargarAreas();

                }
                catch (Exception ex)
                {
                    Session.Add("error", ex.ToString());
                    MostrarMensaje("danger", "Error Inesperado.");
                }
            }
        }

        protected void btnArea_Click(object sender, EventArgs e)
        {
            try
            {
                SetearTipoActual(TipoCatalogoAdmin.Area);
                txtFiltro.Text = "";
                dgvCatalogo.PageIndex = 0;
                CargarAreas();
            }
            catch(Exception ex)
            {
                Session.Add("error", ex.ToString());
                MostrarMensaje("danger", "Ocurrio un error al cargar las areas.");
            }
        }

        protected void btnEstado_Click(object sender, EventArgs e)
        {
            try
            {
                SetearTipoActual(TipoCatalogoAdmin.Estado);
                txtFiltro.Text = "";
                dgvCatalogo.PageIndex = 0;
                CargarEstados();
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                MostrarMensaje("danger", "Ocurrio un error al cargar los estados.");
            }
            
        }

        protected void btnPuesto_Click(object sender, EventArgs e)
        {
            try
            {
                SetearTipoActual(TipoCatalogoAdmin.Puesto);
                txtFiltro.Text = "";
                dgvCatalogo.PageIndex = 0;
                CargarPuestos();
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                MostrarMensaje("danger", "Ocurrio un error al cargar los puestos.");
            }
        }

        protected void btnNuevo_Click(object sender, EventArgs e)
        {
            try
            {
                LimpiarErroresModal();

                hdnRegistroId.Value = "";
                txtNombre.Text = "";
                chkEsFinal.Checked = false;

                ConfigurarPantalla();
                lblModalTitulo.Text = "Crear " + GetNombreClases();
                btnGuardar.Text = "Guardar";

                AbrirModal("adminModal");
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                MostrarMensaje("danger", "Ocurrio un error al preparar el formulario.");
            }
            
        }

        protected void txtFiltro_TextChanged(object sender, EventArgs e)
        {
            try
            {
                dgvCatalogo.PageIndex = 0;

                TipoCatalogoAdmin tipo = ObtenerTipoActual();

                switch (tipo)
                {
                    case TipoCatalogoAdmin.Area:
                        FiltrarAreas();
                        break;
                    case TipoCatalogoAdmin.Estado:
                        FiltrarEstados();
                        break;
                    case TipoCatalogoAdmin.Puesto:
                        FiltrarPuestos();
                        break;
                }
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                MostrarMensaje("danger", "Ocurrio un problemas al filtrar.");
            }
        }

        protected void dgvCatalogo_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            try
            {
                dgvCatalogo.PageIndex = e.NewPageIndex;

                TipoCatalogoAdmin tipo = ObtenerTipoActual();

                switch (tipo)
                {
                    case TipoCatalogoAdmin.Area:
                        FiltrarAreas();
                        break;
                    case TipoCatalogoAdmin.Estado:
                        FiltrarEstados();
                        break;
                    case TipoCatalogoAdmin.Puesto:
                        FiltrarPuestos();
                        break;
                }
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                MostrarMensaje("danger", "Ocurrio un error al cambiar de pagina.");
            }
        }

        protected void dgvCatalogo_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            try
            {
                if (e.CommandName != "EditarRegistro" && e.CommandName != "EliminarRegistro")
                    return;

                LimpiarErroresModal();

                int id = int.Parse(e.CommandArgument.ToString());
                object item = ObtenerItemActual(id);

                if (item == null)
                {
                    MostrarMensaje("danger", "No se encontró el registro.");
                    return;
                }

                if (!PuedeEditarEliminar(item))
                {
                    MostrarMensaje("warning", "Este registro es parte del sistema y no se puede modificar ni eliminar.");
                    return;
                }

                if (e.CommandName == "EditarRegistro")
                {
                    hdnRegistroId.Value = id.ToString();
                    txtNombre.Text = ObtenerNombreItem(item);

                    if (item is Estado)
                        chkEsFinal.Checked = ((Estado)item).EsFinal;
                    else
                        chkEsFinal.Checked = false;

                    ConfigurarPantalla();
                    lblModalTitulo.Text = "Editar " + GetNombreClases();
                    btnGuardar.Text = "Guardar cambios";

                    AbrirModal("adminModal");
                }
                else if (e.CommandName == "EliminarRegistro")
                {
                    string nombre = ObtenerNombreItem(item);

                    hdnEliminarId.Value = id.ToString();
                    hdnEliminarNombre.Value = nombre;
                    lblEliminarNombre.Text = nombre;
                    litNombreConfirmacion.Text = Server.HtmlEncode(nombre.ToUpper());
                    txtConfirmarEliminar.Text = "";

                    AbrirModal("eliminarModal");
                }
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                MostrarMensaje("danger", "Ocurrio un error inesperado.");
            }
            
        }

        protected void btnGuardar_Click(object sender, EventArgs e)
        {
            try
            {
                LimpiarErroresModal();

                if (string.IsNullOrWhiteSpace(txtNombre.Text))
                {
                    lblErrorModal.Text = "Ingresá un nombre.";
                    lblErrorModal.Visible = true;
                    txtNombre.CssClass = "form-control is-invalid";
                    AbrirModal("adminModal");
                    return;
                }

                TipoCatalogoAdmin tipo = ObtenerTipoActual();
                Usuario usuario = (Usuario)Session["usuario"];

                bool editando = hdnRegistroId.Value != "";
                int id = editando ? int.Parse(hdnRegistroId.Value) : 0;

                if (tipo == TipoCatalogoAdmin.Area)
                {
                    Area area = new Area();
                    area.Id = id;
                    area.Nombre = txtNombre.Text.Trim();
                    area.Empresa = usuario.Empresa;

                    AreaNegocio negocioArea = new AreaNegocio();

                    if (editando)
                        negocioArea.actualizar(area);
                    else
                        negocioArea.agregar(area);

                    CargarAreas();
                }
                else if (tipo == TipoCatalogoAdmin.Estado)
                {
                    Estado estado = new Estado();
                    estado.Id = id;
                    estado.Nombre = txtNombre.Text.Trim();
                    estado.EsFinal = chkEsFinal.Checked;
                    estado.Empresa = usuario.Empresa;

                    EstadoNegocio negocioEstado = new EstadoNegocio();

                    if (editando)
                        negocioEstado.actualizar(estado);
                    else
                        negocioEstado.agregar(estado);

                    CargarEstados();
                }
                else if (tipo == TipoCatalogoAdmin.Puesto)
                {
                    Puesto puesto = new Puesto();
                    puesto.Id = id;
                    puesto.Nombre = txtNombre.Text.Trim();
                    puesto.Empresa = usuario.Empresa;

                    PuestoNegocio negocioPuesto = new PuestoNegocio();

                    if (editando)
                        negocioPuesto.actualizar(puesto);
                    else
                        negocioPuesto.agregar(puesto);

                    CargarPuestos();
                }

                MostrarMensaje("success", editando ? "Registro modificado correctamente." : "Registro creado correctamente.");

                hdnRegistroId.Value = "";
                txtNombre.Text = "";
                chkEsFinal.Checked = false;
            }
            catch (Exception ex)
            {
                lblErrorModal.Text = ex.Message;
                lblErrorModal.Visible = true;
                txtNombre.CssClass = "form-control is-invalid";
                AbrirModal("adminModal");
            }
        }

        protected void btnConfirmarEliminar_Click(object sender, EventArgs e)
        {
            try
            {
                LimpiarErroresModal();

                int id = int.Parse(hdnEliminarId.Value);
                object item = ObtenerItemActual(id);

                if (item == null)
                {
                    MostrarMensaje("danger", "No se encontró el registro.");
                    return;
                }

                if (!PuedeEditarEliminar(item))
                {
                    MostrarMensaje("warning", "Este registro es parte del sistema y no se puede eliminar.");
                    return;
                }

                string nombreEsperado = ObtenerNombreItem(item).ToUpper();
                string nombreIngresado = txtConfirmarEliminar.Text.Trim();

                if (nombreIngresado != nombreEsperado)
                {
                    lblErrorEliminar.Text = "El texto no coincide con el nombre en mayúscula.";
                    lblErrorEliminar.Visible = true;
                    txtConfirmarEliminar.CssClass = "form-control is-invalid";
                    AbrirModal("eliminarModal");
                    return;
                }

                TipoCatalogoAdmin tipo = ObtenerTipoActual();

                switch (tipo)
                {
                    case TipoCatalogoAdmin.Area:
                        AreaNegocio negocioArea = new AreaNegocio();
                        negocioArea.eliminar((Area)item);
                        CargarAreas();
                        break;

                    case TipoCatalogoAdmin.Estado:
                        EstadoNegocio negocioEstado = new EstadoNegocio();
                        negocioEstado.eliminar((Estado)item);
                        CargarEstados();
                        break;

                    case TipoCatalogoAdmin.Puesto:
                        PuestoNegocio negocioPuesto = new PuestoNegocio();
                        negocioPuesto.eliminar((Puesto)item);
                        CargarPuestos();
                        break;
                }

                MostrarMensaje("success", "Registro eliminado correctamente.");
            }
            catch (Exception ex)
            {
                MostrarMensaje("danger", ex.Message);
            }
        }

        private void CargarAreas()
        {
            Usuario usuario = (Usuario)Session["usuario"];
            AreaNegocio negocio = new AreaNegocio();

            List<Area> lista = negocio.listar(usuario.Empresa.Id);
            Session["listaAreasAdmin"] = lista;

            ConfigurarPantalla();
            BindGrid(lista, lista.Count);
        }

        private void CargarEstados()
        {
            Usuario usuario = (Usuario)Session["usuario"];
            EstadoNegocio negocio = new EstadoNegocio();

            List<Estado> lista = negocio.listar(usuario.Empresa.Id);
            Session["listaEstadosAdmin"] = lista;

            ConfigurarPantalla();
            BindGrid(lista, lista.Count);
        }

        private void CargarPuestos()
        {
            Usuario usuario = (Usuario)Session["usuario"];
            PuestoNegocio negocio = new PuestoNegocio();

            List<Puesto> lista = negocio.listar(usuario.Empresa.Id);
            Session["listaPuestosAdmin"] = lista;

            ConfigurarPantalla();
            BindGrid(lista, lista.Count);
        }

        private void FiltrarAreas()
        {
            List<Area> lista = (List<Area>)Session["listaAreasAdmin"];
            string filtro = txtFiltro.Text.Trim().ToUpper();

            List<Area> filtrada = lista.FindAll(x => x.Nombre.ToUpper().Contains(filtro));
            BindGrid(filtrada, filtrada.Count);
        }

        private void FiltrarEstados()
        {
            List<Estado> lista = (List<Estado>)Session["listaEstadosAdmin"];
            string filtro = txtFiltro.Text.Trim().ToUpper();

            List<Estado> filtrada = lista.FindAll(x => x.Nombre.ToUpper().Contains(filtro));
            BindGrid(filtrada, filtrada.Count);
        }

        private void FiltrarPuestos()
        {
            List<Puesto> lista = (List<Puesto>)Session["listaPuestosAdmin"];
            string filtro = txtFiltro.Text.Trim().ToUpper();

            List<Puesto> filtrada = lista.FindAll(x => x.Nombre.ToUpper().Contains(filtro));
            BindGrid(filtrada, filtrada.Count);
        }

        private void BindGrid(object lista, int cantidad)
        {
            dgvCatalogo.Columns[2].Visible = ObtenerTipoActual() == TipoCatalogoAdmin.Estado;
            dgvCatalogo.DataSource = lista;
            dgvCatalogo.DataBind();

            lblCantidad.Text = cantidad == 1 ? "1 registro" : cantidad + " registros";
        }

        private object ObtenerItemActual(int id)
        {
            TipoCatalogoAdmin tipo = ObtenerTipoActual();

            switch (tipo)
            {
                case TipoCatalogoAdmin.Area:
                    List<Area> lista = (List<Area>)Session["listaAreasAdmin"];
                    return lista.Find(x => x.Id == id);

                case TipoCatalogoAdmin.Estado:
                    List<Estado> listaEstado = (List<Estado>)Session["listaEstadosAdmin"];
                    return listaEstado.Find(x => x.Id == id);

                case TipoCatalogoAdmin.Puesto:
                    List<Puesto> listaPuestos = (List<Puesto>)Session["listaPuestosAdmin"];
                    return listaPuestos.Find(x => x.Id == id);
            }

            return null;
        }

        private void ConfigurarPantalla()
        {
            TipoCatalogoAdmin tipo = ObtenerTipoActual();

            btnArea.CssClass = tipo == TipoCatalogoAdmin.Area ? "btn active" : "btn";
            btnEstado.CssClass = tipo == TipoCatalogoAdmin.Estado ? "btn active" : "btn";
            btnPuesto.CssClass = tipo == TipoCatalogoAdmin.Puesto ? "btn active" : "btn";

            pnlEstadoExtra.Visible = tipo == TipoCatalogoAdmin.Estado;

            switch (tipo)
            {
                case TipoCatalogoAdmin.Area:
                    txtFiltro.Attributes["placeholder"] = "Filtrar por Area";
                    litCrearTexto.Text = "Crear Area";
                    txtNombre.MaxLength = 30;
                    break;

                case TipoCatalogoAdmin.Estado:
                    txtFiltro.Attributes["placeholder"] = "Filtrar por Estado";
                    litCrearTexto.Text = "Crear Estado";
                    txtNombre.MaxLength = 30;
                    break;

                case TipoCatalogoAdmin.Puesto:
                    txtFiltro.Attributes["placeholder"] = "Filtrar por Puesto";
                    litCrearTexto.Text = "Crear Puesto";
                    txtNombre.MaxLength = 50;
                    break;
            }
        }

        private TipoCatalogoAdmin ObtenerTipoActual()
        {
            return (TipoCatalogoAdmin)int.Parse(hfTipoActual.Value);
        }

        private void SetearTipoActual(TipoCatalogoAdmin tipo)
        {
            hfTipoActual.Value = ((int)tipo).ToString();
        }

        private string ObtenerNombreItem(object item)
        {
            if (item is Area)
                return ((Area)item).Nombre;

            if (item is Estado)
                return ((Estado)item).Nombre;

            if (item is Puesto)
                return ((Puesto)item).Nombre;

            return "";
        }

        public bool PuedeEditarEliminar(object item)
        {
            if (item is Area)
                return ((Area)item).Empresa != null;

            if (item is Estado)
                return ((Estado)item).Empresa != null;

            if (item is Puesto)
                return ((Puesto)item).Empresa != null;

            return false;
        }

        public string GetOrigenTexto(object item)
        {
            return PuedeEditarEliminar(item) ? "Empresa" : "Sistema";
        }

        public string GetOrigenClass(object item)
        {
            if (PuedeEditarEliminar(item))
                return "badge text-bg-primary px-3 py-2 fw-semibold";

            return "badge text-bg-secondary px-3 py-2 fw-semibold";
        }

        public string GetEstadoFinalTexto(object item)
        {
            if (item is Estado && ((Estado)item).EsFinal)
                return "Sí";

            return "No";
        }

        public string GetEstadoFinalClass(object item)
        {
            if (item is Estado && ((Estado)item).EsFinal)
                return "badge text-bg-success px-3 py-2 fw-semibold";

            return "badge text-bg-light text-secondary px-3 py-2 fw-semibold border";
        }

        public string GetBotonAccionClass(object item, string accion)
        {
            if (!PuedeEditarEliminar(item))
                return "admin-action text-muted opacity-25";

            if (accion == "delete")
                return "admin-action text-danger";

            return "admin-action text-muted";
        }

        public string GetTipoTexto()
        {
            return GetNombreClases();
        }

        private string GetNombreClases()
        {
            TipoCatalogoAdmin clase = ObtenerTipoActual();

            switch (clase)
            {
                case TipoCatalogoAdmin.Area: return "Area";

                case TipoCatalogoAdmin.Estado: return "Estado";

                case TipoCatalogoAdmin.Puesto: return "Puesto";

                default: return "Registro";
            }
        }

        private void LimpiarErroresModal()
        {
            lblErrorModal.Visible = false;
            lblErrorModal.Text = "";
            txtNombre.CssClass = "form-control";

            lblErrorEliminar.Visible = false;
            lblErrorEliminar.Text = "";
            txtConfirmarEliminar.CssClass = "form-control";
        }

        private void MostrarMensaje(string tipo, string mensaje)
        {
            litMensaje.Text = $@"
                <div class='alert alert-{tipo} alert-dismissible fade show' role='alert'>
                    {Server.HtmlEncode(mensaje)}
                    <button type='button' class='btn-close' data-bs-dismiss='alert'></button>
                </div>";
        }

        private void AbrirModal(string idModal)
        {
            string script = $@"
                document.addEventListener('DOMContentLoaded', function () {{
                    var modalElement = document.getElementById('{idModal}');
                    var modal = new bootstrap.Modal(modalElement);
                    modal.show();
                }});";

            ScriptManager.RegisterStartupScript(this, GetType(), "AbrirModal" + idModal, script, true);
        }
    }
}