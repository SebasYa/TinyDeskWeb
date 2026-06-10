using System;
using System.Collections.Generic;
using System.Web.UI.WebControls;
using dominio;
using negocio;

namespace TP_Final_Programacion_III
{
    public partial class Proyectos : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try
                {
                     int idEmpresa = ((Usuario)Session["usuario"]).Empresa.Id;

                     CargarEstadosProyecto(idEmpresa);

                     if (Request.QueryString["id"] != null)
                     {
                         int idProyecto = int.Parse(Request.QueryString["id"]);
                         CargarDetalleProyecto(idProyecto, idEmpresa);
                     }
                     else
                     {
                         CargarListadoProyectos(idEmpresa);
                     }

                }
                catch(Exception ex)
                {
                    Session.Add("error", ex.ToString());
                    MostrarErrorProyecto("Ocurrio un error al cargar el formulario.");
                    //Response.Redirect("Proyectos.aspx", false);
                }
            }
        }

        private void CargarListadoProyectos(int idEmpresa)
        {
            pnlListadoProyectos.Visible = true;
            pnlDetalleProyecto.Visible = false;
            txtFechaInicioProyecto.Enabled = true;

            ProyectoNegocio negocio = new ProyectoNegocio();
            List<Proyecto> lista = negocio.listar(idEmpresa);

            repProyectos.DataSource = lista;
            repProyectos.DataBind();

            lblModalProyectoTitulo.Text = "Nuevo Proyecto";
            btnGuardarProyecto.Text = "Guardar Proyecto";
        }

        private void CargarDetalleProyecto(int idProyecto, int idEmpresa)
        {
            pnlListadoProyectos.Visible = false;
            pnlDetalleProyecto.Visible = true;

            ProyectoNegocio proyectoNegocio = new ProyectoNegocio();
            Proyecto proyecto = proyectoNegocio.BuscarPorId(idProyecto, idEmpresa);

            lblDetalleNombre.Text = proyecto.Nombre;
            lblDetalleEstado.Text = proyecto.Estado.Nombre;
            lblDetalleDescripcion.Text = proyecto.Descripcion;
            lblDetalleFechaInicio.Text = proyecto.FechaInicio.ToString("dd/MM/yyyy");
            lblDetalleFechaEstimadaFin.Text = proyecto.FechaEstimadaFin.ToString("dd/MM/yyyy");
            lblDetalleFechaFin.Text = proyecto.FechaFin.HasValue ? proyecto.FechaFin.Value.ToString("dd/MM/yyyy") : "-";
            lblDetalleActivo.Text = proyecto.Activo ? "Sí" : "No";

            txtNombreProyecto.Text = proyecto.Nombre;
            txtDescripcionProyecto.Text = proyecto.Descripcion;
            txtFechaInicioProyecto.Text = proyecto.FechaInicio.ToString("yyyy-MM-dd");
            txtFechaInicioProyecto.Enabled = false;
            txtFechaEstimadaFinProyecto.Text = proyecto.FechaEstimadaFin.ToString("yyyy-MM-dd");
            ddlEstadoProyecto.SelectedValue = proyecto.Estado.Id.ToString();

            lblModalProyectoTitulo.Text = "Editar Proyecto";
            btnGuardarProyecto.Text = "Guardar Cambios";

            SprintNegocio sprintNegocio = new SprintNegocio();
            dgvSprintsProyecto.DataSource = sprintNegocio.listarPorProyecto(idProyecto, idEmpresa);
            dgvSprintsProyecto.DataBind();
        }

        private void CargarEstadosProyecto(int idEmpresa)
        {
            EstadoNegocio estadoNegocio = new EstadoNegocio();

            ddlEstadoProyecto.DataSource = estadoNegocio.listar(idEmpresa);
            ddlEstadoProyecto.DataValueField = "Id";
            ddlEstadoProyecto.DataTextField = "Nombre";
            ddlEstadoProyecto.DataBind();
            ddlEstadoProyecto.Items.Insert(0, new ListItem("Seleccione Estado..", ""));
        }

        protected void btnGuardarProyecto_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtNombreProyecto.Text) ||
                string.IsNullOrWhiteSpace(txtFechaInicioProyecto.Text) ||
                string.IsNullOrWhiteSpace(txtFechaEstimadaFinProyecto.Text) ||
                string.IsNullOrWhiteSpace(ddlEstadoProyecto.SelectedValue))
            {
                MostrarErrorProyecto("Completá todos los campos obligatorios.");
                return;
            }
            bool esEdicion = Request.QueryString["id"] != null;
            DateTime fechaInicio;
            if (esEdicion)
            {
                int idProyecto = int.Parse(Request.QueryString["id"]);
                int idEmpresa = ((Usuario)Session["usuario"]).Empresa.Id;

                ProyectoNegocio negocioFecha = new ProyectoNegocio();
                Proyecto proyectoActual = negocioFecha.BuscarPorId(idProyecto, idEmpresa);

                if(proyectoActual == null)
                {
                    MostrarErrorProyecto("No se encontro el proyecto solicitado.");
                    return;
                }
                fechaInicio = proyectoActual.FechaInicio;
            }
            else
            {
               fechaInicio = Convert.ToDateTime(txtFechaInicioProyecto.Text);
            }

            DateTime fechaEstimadaFin = Convert.ToDateTime(txtFechaEstimadaFinProyecto.Text);
            DateTime fechaMaxima = fechaInicio.AddYears(10);

            if (fechaEstimadaFin.Date > fechaMaxima.Date)
            {
                MostrarErrorProyecto("La fecha estimada final no debe superar los 10 años desde la fecha inicial.");
                return;
            }

            if (fechaEstimadaFin.Date < fechaInicio.Date)
            {
                MostrarErrorProyecto("La fecha estimada final no puede ser anterior a la fecha de inicio.");
                return;
            }

            if (fechaInicio.Date < DateTime.Today && Request.QueryString["id"] == null)
            {
                MostrarErrorProyecto("La fecha inicial no puede ser anterior a la fecha de hoy.");
                return;
            }

            try
            {
                ProyectoNegocio proyectoNegocio = new ProyectoNegocio();
                Usuario userLogueado = (Usuario)Session["usuario"];

                Proyecto proyecto = new Proyecto();
                proyecto.Nombre = txtNombreProyecto.Text;
                proyecto.Descripcion = txtDescripcionProyecto.Text;
                proyecto.FechaInicio = fechaInicio;
                proyecto.FechaEstimadaFin = fechaEstimadaFin;

                proyecto.Estado = new Estado();
                proyecto.Estado.Id = int.Parse(ddlEstadoProyecto.SelectedValue);

                if (ddlEstadoProyecto.SelectedItem.Text == "Finalizado")
                {
                    proyecto.Activo = false;
                    proyecto.FechaFin = DateTime.Today;
                }
                else
                {
                    proyecto.Activo = true;
                    proyecto.FechaFin = null;
                }

                proyecto.Empresa = new Empresa();
                proyecto.Empresa.Id = userLogueado.Empresa.Id;

                if (Request.QueryString["id"] != null)
                {
                    proyecto.Id = int.Parse(Request.QueryString["id"]);
                    proyectoNegocio.actualizar(proyecto);

                    MostrarExitoProyecto("El Proyecto se modificó perfectamente.");
                    CargarDetalleProyecto(proyecto.Id, userLogueado.Empresa.Id);
                }
                else
                {
                    proyectoNegocio.agregar(proyecto);

                    MostrarExitoProyecto("El Proyecto se guardó perfectamente.");

                    txtNombreProyecto.Text = "";
                    txtDescripcionProyecto.Text = "";
                    txtFechaInicioProyecto.Text = "";
                    txtFechaEstimadaFinProyecto.Text = "";
                    ddlEstadoProyecto.SelectedIndex = 0;

                    CargarListadoProyectos(userLogueado.Empresa.Id);
                }
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                MostrarErrorProyecto("Ocurrió un error al guardar el proyecto.");
            }
        }
        protected void repProyectos_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                Proyecto proyecto = (Proyecto)e.Item.DataItem;

                Label lblFechaFin = (Label)e.Item.FindControl("lblFechaFin");

                if (lblFechaFin != null && proyecto.FechaFin.HasValue)
                {
                    lblFechaFin.Text = $"Fecha Fin: {proyecto.FechaFin.Value.ToString("dd/MM/yyyy")}";
                    lblFechaFin.Visible = true;
                }
            }
        }

        private void MostrarErrorProyecto(string mensaje)
        {
            litMensaje.Text = $@"<div class='alert alert-danger alert-dismissible fade show' role='alert'>
                                    <strong>Error:</strong> {mensaje}
                                    <button type='button' class='btn-close' data-bs-dismiss='alert' aria-label='Close'></button>
                                </div>";
        }

        private void MostrarExitoProyecto(string mensaje)
        {
            litMensaje.Text = $@"<div class='alert alert-success alert-dismissible fade show' role='alert'>
                                    <strong>¡Éxito!</strong> {mensaje}
                                    <button type='button' class='btn-close' data-bs-dismiss='alert' aria-label='Close'></button>
                                </div>";
        }
    }
}