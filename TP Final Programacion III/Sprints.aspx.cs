using dominio;
using Microsoft.Ajax.Utilities;
using negocio;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;


namespace TP_Final_Programacion_III
{
    public partial class Sprints : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            litMensaje.Text = "";
            if (!IsPostBack)
            {
                try
                {

                    Usuario userLogueado = (Usuario)Session["usuario"];
                    int idEmpresa = userLogueado.Empresa.Id;
                    AreaNegocio areaNegocio = new AreaNegocio();
                    EstadoNegocio estadoNegocio = new EstadoNegocio();
                    ProyectoNegocio proyectoNegocio = new ProyectoNegocio();
                    SprintNegocio sprintNegocio = new SprintNegocio();

                    if (Session["usuario"] == null)
                    {
                        Session.Add("error", "Debes iniciar sesión para acceder a esta pantalla.");
                        Response.Redirect("Login.aspx", false);
                        return;
                    }

                    if (userLogueado.Empresa == null)
                    {
                        Session.Add("error", "El usuario no tiene una empresa asignada.");
                        Response.Redirect("Default.aspx", false);
                        return;
                    }

                    ddlArea.DataSource = areaNegocio.listar(idEmpresa);
                    ddlArea.DataValueField = "Id";
                    ddlArea.DataTextField = "Nombre";
                    ddlArea.DataBind();
                    ddlArea.Items.Insert(0, new ListItem("Seleccione un área...", ""));

                    ddlEstado.DataSource = estadoNegocio.listar(idEmpresa);
                    ddlEstado.DataValueField = "Id";
                    ddlEstado.DataTextField = "Nombre";
                    ddlEstado.DataBind();
                    ddlEstado.Items.Insert(0, new ListItem("Seleccione un puesto...", ""));

                    ddlProyecto.DataSource = proyectoNegocio.listar(idEmpresa);
                    ddlProyecto.DataValueField = "Id";
                    ddlProyecto.DataTextField = "Nombre";
                    ddlProyecto.DataBind();
                    ddlProyecto.Items.Insert(0, new ListItem("Seleccione un puesto...", ""));


                    ddlEditArea.DataSource = areaNegocio.listar(idEmpresa);
                    ddlEditArea.DataValueField = "Id";
                    ddlEditArea.DataTextField = "Nombre";
                    ddlEditArea.DataBind();
                    ddlEditArea.Items.Insert(0, new ListItem("Seleccione un área...", ""));

                    ddlEditEstado.DataSource = estadoNegocio.listar(idEmpresa);
                    ddlEditEstado.DataValueField = "Id";
                    ddlEditEstado.DataTextField = "Nombre";
                    ddlEditEstado.DataBind();
                    ddlEditEstado.Items.Insert(0, new ListItem("Seleccione un puesto...", ""));

                    ddlEditProyecto.DataSource = proyectoNegocio.listar(idEmpresa);
                    ddlEditProyecto.DataValueField = "Id";
                    ddlEditProyecto.DataTextField = "Nombre";
                    ddlEditProyecto.DataBind();
                    ddlEditProyecto.Items.Insert(0, new ListItem("Seleccione un puesto...", ""));


                    //Datagrid View de Sprints
                    Session.Add("listaSprints", sprintNegocio.listar(userLogueado.Empresa.Id));
                    dgvSprints.DataSource = Session["listaSprints"];
                    dgvSprints.DataBind();

                    if (Request.QueryString["id"] != null)
                    {
                        int idSprint = int.Parse(Request.QueryString["id"]);

                        pnlListadoSprints.Visible = false;
                        pnlDetalleSprint.Visible = true;
                        CargarDetalleDelSprint(idSprint);
                    }
                    else
                    {
                        pnlListadoSprints.Visible = true;
                        pnlDetalleSprint.Visible = false;
                    }
                }
                catch (Exception ex)
                {
                    Session.Add("error", ex.ToString());
                    
                }
            }

        }

        protected void Unnamed_Click(object sender, EventArgs e)
        {

        }

        protected void btnCrearSprint_Click(object sender, EventArgs e)
        {

        }

        protected void btnGuardarSprint_Click(object sender, EventArgs e)
        {

            try
            {
                SprintNegocio sprintNegocio = new SprintNegocio();
                Sprint nuevoSprint = new Sprint();
                Usuario userLogueado = (Usuario)Session["usuario"];

                int idProyectoSeleccionado = int.Parse(ddlProyecto.SelectedValue);
                nuevoSprint.NumeroSprint = sprintNegocio.ObtenerSiguienteNumeroSprint(idProyectoSeleccionado);
                DateTime fechaInicio = Convert.ToDateTime(txtFechaInicio.Text);
                DateTime fechaEstimadaFin = Convert.ToDateTime(txtFechaEstimadaFin.Text);

                DateTime hoy = DateTime.Today;

                 if (fechaInicio.Date < hoy)
                 {
                   MostrarErrorValidacion("La nueva fecha de inicio no puede ser anterior al día de hoy.");
                   return;
                 }

                // (FechaEstimadaFin >= FechaInicio)
                if (fechaEstimadaFin.Date <= fechaInicio.Date)
                {
                    MostrarErrorValidacion("La fecha estimada de fin no puede ser anterior a la fecha de inicio.");
                    return;
                }

                nuevoSprint.FechaInicio = Convert.ToDateTime(txtFechaInicio.Text);
                nuevoSprint.FechaEstimadaFin = Convert.ToDateTime(txtFechaEstimadaFin.Text);
                nuevoSprint.Area = new Area();
                nuevoSprint.Area.Id = int.Parse(ddlArea.SelectedValue);
                nuevoSprint.Estado = new Estado();
                nuevoSprint.Estado.Id = int.Parse(ddlEstado.SelectedValue);
                nuevoSprint.Proyecto = new Proyecto();
                nuevoSprint.Proyecto.Id = int.Parse(ddlProyecto.SelectedValue);
                nuevoSprint.Activo = true;

                sprintNegocio.Agregar(nuevoSprint);

                litMensaje.Text = @"
                <div class='alert alert-success alert-dismissible fade show' role='alert'>
                    <strong>¡Éxito!</strong> El Sprint se guardó perfectamente.
                    <button type='button' class='btn-close' data-bs-dismiss='alert' aria-label='Close'></button>
                </div>";


                txtFechaInicio.Text = "";
                txtFechaEstimadaFin.Text = "";
                ddlArea.SelectedIndex = 0;
                ddlEstado.SelectedIndex = 0;
                ddlProyecto.SelectedIndex = 0;

                Session.Add("listaSprints", sprintNegocio.listar(userLogueado.Empresa.Id));
                dgvSprints.DataSource = Session["listaSprints"];
                dgvSprints.DataBind();


            }
            catch (Exception ex)
            {
                litMensaje.Text = $@"
                <div class='alert alert-danger alert-dismissible fade show' role='alert'>
                    <strong>Hubo un error:</strong> {ex.Message}
                    <button type='button' class='btn-close' data-bs-dismiss='alert' aria-label='Close'></button>
                </div>";
                Session.Add("error", ex.ToString());
                Response.Redirect("Default.aspx", false);
            }
        }

        public string GetClassEtiquetaEstado(object estadoNombre)
        {
            if (estadoNombre == null) return "badge text-bg-secondary";

            string estado = estadoNombre.ToString().ToLower().Trim();

            switch (estado)
            {
                case "en progreso":
                    return "badge text-bg-primary px-3 py-2 fw-semibold";
                case "finalizado":
                    return "badge text-bg-success px-3 py-2 fw-semibold";
                case "pendiente":
                    return "badge text-bg-warning px-3 py-2 fw-semibold";
                default:
                    return "badge text-bg-dark px-3 py-2 fw-semibold border";
            }
        }


        public string GetClassBarraProgreso(object estadoNombre)
        {
            if (estadoNombre == null) return "progress-bar bg-secondary";
            string estado = estadoNombre.ToString().ToLower().Trim();

            if (estado == "finalizado") return "progress-bar-striped bg-success";
            if (estado == "pendiente" ) return "progress-bar-striped bg-light";
            return "progress-bar-striped bg-primary"; 
        }

        
        public string GetDiasRestantesTexto(object fechaFinEstimada, object esFinal, object fechaFin = null)
        {
            DateTime fechaFinalizado = Convert.ToDateTime(fechaFin);
            if (esFinal != null && (bool)esFinal) return "Sprint cerrado - "+ fechaFinalizado.ToString("dd/MM/yyyy");
            if (fechaFinEstimada == null) return "";

            DateTime fin = Convert.ToDateTime(fechaFinEstimada);
            TimeSpan diferencia = fin - DateTime.Today;

            if (diferencia.Days > 0)
                return $"({diferencia.Days} días restantes)";
            if (diferencia.Days == 0)
                return "(Termina hoy)";

            return $"({Math.Abs(diferencia.Days)} días de retraso)";
        }

        protected void ddlProyecto_SelectedIndexChanged(object sender, EventArgs e)
        {
        }

        protected void dgvSprints_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            dgvSprints.PageIndex = e.NewPageIndex;
            dgvSprints.DataSource = Session["listaSprints"];
            dgvSprints.DataBind();

        }

        protected void dgvSprints_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                litMensaje.Text = "";
                int idSeleccionado = (int)(dgvSprints.SelectedDataKey.Value);

                List<Sprint> listaSprints = (List<Sprint>)Session["listaSprints"];

                Sprint sprintAEditar = listaSprints.Find(x => x.Id == idSeleccionado);

                if (sprintAEditar != null)
                {
                    Session["IdSprintEditar"] = sprintAEditar.Id;
                    lblModalEditarTitulo.Text = $"Editar Sprint {sprintAEditar.NumeroSprint}";

                    txtEditFechaInicio.Text = sprintAEditar.FechaInicio.ToString("yyyy-MM-dd");
                    txtEditFechaInicio.Enabled = false;
                    txtEditFechaEstimadaFin.Text = sprintAEditar.FechaEstimadaFin.ToString("yyyy-MM-dd");

                    if (sprintAEditar.FechaFin != null)
                    {
                        txtEditFechaFin.Text = ((DateTime)sprintAEditar.FechaFin).ToString("yyyy-MM-dd");
                    }
                    else
                    {
                        txtEditFechaFin.Text = ""; 
                    }

                   
                    if (ddlEditProyecto.Items.FindByValue( sprintAEditar.Proyecto.Id.ToString()) != null)
                        ddlEditProyecto.SelectedValue = sprintAEditar.Proyecto.Id.ToString();

                    if (ddlEditEstado.Items.FindByValue(sprintAEditar.Estado.Id.ToString()) != null)
                        ddlEditEstado.SelectedValue = sprintAEditar.Estado.Id.ToString();

                    if (ddlEditArea.Items.FindByValue( sprintAEditar.Area.Id.ToString()) != null)
                        ddlEditArea.SelectedValue = sprintAEditar.Area.Id.ToString();


                    string scriptOpen = @"
                        document.addEventListener('DOMContentLoaded', function () {
                            var modalElement = document.getElementById('sprintEditarModal');
                            var myModal = new bootstrap.Modal(modalElement);
                            myModal.show();
                        });";

                    ScriptManager.RegisterStartupScript(this, this.GetType(), "OpenEditModal", scriptOpen, true);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        protected void txtFiltroSprints_TextChanged(object sender, EventArgs e)
        {
            List<Sprint> lista = (List<Sprint>)Session["listaSprints"];
            List<Sprint> listaFiltrada = lista.FindAll(x => x.Proyecto.Nombre.ToUpper().Contains(txtFiltroSprints.Text.ToUpper()));
            dgvSprints.DataSource = listaFiltrada;
            dgvSprints.DataBind();
        }

        protected void btnGuardarEdicion_Click(object sender, EventArgs e)
        {

            try
            {
                if (Session["IdSprintEditar"] == null)
                {
                    litMensaje.Text = "<div class='alert alert-danger'>Error: No se pudo identificar el Sprint a editar.</div>";
                    return;
                }

                SprintNegocio sprintNegocio = new SprintNegocio();
                Sprint editarSprint = new Sprint();
                AuditoriaService auditoriaService = new AuditoriaService();
                Usuario userLogueado = (Usuario)Session["usuario"];

                editarSprint.Id = (int)Session["IdSprintEditar"];

                List<Sprint> listaSprints = (List<Sprint>)Session["listaSprints"];
                Sprint original = listaSprints.Find(x => x.Id == editarSprint.Id);

                if (original != null)
                {
                    editarSprint.NumeroSprint = original.NumeroSprint; 
                }
                DateTime fechaInicio = Convert.ToDateTime(txtEditFechaInicio.Text);
                DateTime fechaEstimadaFin = Convert.ToDateTime(txtEditFechaEstimadaFin.Text);

                DateTime hoy = DateTime.Today;

                // (FechaEstimadaFin >= FechaInicio)
                if (fechaEstimadaFin.Date <= fechaInicio.Date)
                {
                    MostrarErrorValidacion("La fecha estimada de fin no puede ser anterior a la fecha de inicio.");
                    return;
                }

                // (FechaFin IS NULL OR FechaFin >= FechaInicio)
                if (!string.IsNullOrEmpty(txtEditFechaFin.Text))
                {
                    DateTime fechaFinReal = Convert.ToDateTime(txtEditFechaFin.Text);
                    if (fechaFinReal.Date < fechaInicio.Date)
                    {
                        MostrarErrorValidacion("La fecha de finalización real no puede ser anterior a la fecha de inicio.");
                        return;
                    }
                    editarSprint.FechaFin = fechaFinReal;
                }
                else
                {
                    editarSprint.FechaFin = null;
                }

                editarSprint.FechaInicio = fechaInicio;
                editarSprint.FechaEstimadaFin = fechaEstimadaFin;

                editarSprint.Area = new Area();
                editarSprint.Area.Id = int.Parse(ddlEditArea.SelectedValue);
                editarSprint.Estado = new Estado();
                editarSprint.Estado.Id = int.Parse(ddlEditEstado.SelectedValue);
                editarSprint.Estado.Nombre = ddlEditEstado.SelectedItem.Text;
                editarSprint.Proyecto = new Proyecto();
                editarSprint.Proyecto.Id = int.Parse(ddlEditProyecto.SelectedValue);
                editarSprint.Activo = true;

                string motivo = txtMotivoCambio.Text;
                string accion = "UPDATE";

                sprintNegocio.ModificarSprintConAuditoria(editarSprint, original, accion, userLogueado.Id, motivo);

                litMensaje.Text = @"
                <div class='alert alert-success alert-dismissible fade show' role='alert'>
                    <strong>¡Éxito!</strong> El Sprint se modificó perfectamente.
                    <button type='button' class='btn-close' data-bs-dismiss='alert' aria-label='Close'></button>
                </div>";


                txtFechaInicio.Text = "";
                txtFechaEstimadaFin.Text = "";
                ddlArea.SelectedIndex = 0;
                ddlEstado.SelectedIndex = 0;
                ddlProyecto.SelectedIndex = 0;

                Session.Add("listaSprints", sprintNegocio.listar(userLogueado.Empresa.Id));
                dgvSprints.DataSource = Session["listaSprints"];
                dgvSprints.DataBind();


            }
            catch (Exception ex)
            {
                litMensaje.Text = $@"
                <div class='alert alert-danger alert-dismissible fade show' role='alert'>
                    <strong>Hubo un error al modificar:</strong> {ex.Message}
                    <button type='button' class='btn-close' data-bs-dismiss='alert' aria-label='Close'></button>
                </div>";
                Session.Add("error", ex.ToString());
                
            }
        }

        protected void btnEliminar_Click(object sender, EventArgs e)
        {
            try
            {
                if (Session["IdSprintEditar"] == null)
                {
                    litMensaje.Text = "<div class='alert alert-danger'>Error: No se pudo identificar el Sprint a editar.</div>";
                    return;
                }

                SprintNegocio sprintNegocio = new SprintNegocio();
                Sprint eliminarSprint = new Sprint();
                Usuario userLogueado = (Usuario)Session["usuario"];

                eliminarSprint.Id = (int)Session["IdSprintEditar"];

                List<Sprint> listaSprints = (List<Sprint>)Session["listaSprints"];
                Sprint original = listaSprints.Find(x => x.Id == eliminarSprint.Id);

                eliminarSprint.Id = original.Id;

                string motivo = txtMotivoCambio.Text;
                string accion = "DELETE";

                sprintNegocio.EliminarSprintConAuditoria(eliminarSprint, accion, userLogueado.Id, motivo);

                sprintNegocio.Desactivar(eliminarSprint);

                litMensaje.Text = @"
                <div class='alert alert-success alert-dismissible fade show' role='alert'>
                    <strong>¡Éxito!</strong> El Sprint se eliminó perfectamente.
                    <button type='button' class='btn-close' data-bs-dismiss='alert' aria-label='Close'></button>
                </div>";


                Session.Add("listaSprints", sprintNegocio.listar(userLogueado.Empresa.Id));
                dgvSprints.DataSource = Session["listaSprints"];
                dgvSprints.DataBind();


            }
            catch (Exception ex)
            {
                litMensaje.Text = $@"
                <div class='alert alert-danger alert-dismissible fade show' role='alert'>
                    <strong>Hubo un error al modificar:</strong> {ex.Message}
                    <button type='button' class='btn-close' data-bs-dismiss='alert' aria-label='Close'></button>
                </div>";
                Session.Add("error", ex.ToString());

            }
        }

        private void MostrarErrorValidacion(string mensaje)
        {
            litMensaje.Text = $@"
        <div class='alert alert-danger alert-dismissible fade show' role='alert'>
            <strong>Error de Validación:</strong> {mensaje}
            <button type='button' class='btn-close' data-bs-dismiss='alert' aria-label='Close'></button>
        </div>";

            // Reabrimos el modal de edición usando ScriptManager para que el usuario no pierda lo que escribió
            string scriptOpen = @"
        document.addEventListener('DOMContentLoaded', function () {
            var modalElement = document.getElementById('sprintEditarModal');
            var myModal = bootstrap.Modal.getInstance(modalElement) || new bootstrap.Modal(modalElement);
            myModal.show();
        });";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "KeepOpenEditValidationError", scriptOpen, true);
        }

        protected void btnCerrarSprint_Click(object sender, EventArgs e)
        {
            txtFechaInicio.Text = "";
            txtFechaEstimadaFin.Text = "";
            ddlArea.SelectedIndex = 0;
            ddlEstado.SelectedIndex = 0;
            ddlProyecto.SelectedIndex = 0;
        }

        protected void dgvSprints_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "VerDetalle")
            {
                // Recuperamos el ID que enviamos en el CommandArgument
                string idSprint = e.CommandArgument.ToString();

                // Redirigimos a la misma página pasando el ID por parámetro en la URL
                Response.Redirect($"Sprints.aspx?id={idSprint}");
            }
        }

        private void CargarDetalleDelSprint(int idSprint)
        {
            List<Sprint> listaSprints = (List<Sprint>)Session["listaSprints"];
            Sprint sprint = listaSprints?.Find(x => x.Id == idSprint);

            if (sprint != null)
            {
                lblDetalleTituloSprint.Text = $"Detalle de Sprint {sprint.NumeroSprint}";
                lblSprintProyectoArea.Text = $"{sprint.Proyecto.Nombre} / {sprint.Area.Nombre}";
                lblDetalleFechaInicio.Text = sprint.FechaInicio.ToString("dd/MM/yyyy");
                lblDetalleFechaEstimadaFin.Text = sprint.FechaEstimadaFin.ToString("dd/MM/yyyy");
                lblDetalleFechaFin.Text = sprint.FechaFin != null ? ((DateTime)sprint.FechaFin).ToString("dd/MM/yyyy") : "-";
                lblDetalleEstado.Text = sprint.Estado.Nombre;
                lblDetalleEstado.CssClass += " " + GetClassEtiquetaEstado(sprint.Estado.Nombre);


                // 3. Enlazamos la lista falsa al GridView
                TicketNegocio ticketNegocio = new TicketNegocio();
                dgvTicketsDelSprint.DataSource = ticketNegocio.listarPorSprint(idSprint);

                //dgvTicketsDelSprint.DataSource = listaMockupTickets;
                dgvTicketsDelSprint.DataBind();
            }
        }

        

        public string GetClassEtiquetaPrioridad(object prioridad)
        {
            if (prioridad == null) return "badge text-bg-secondary text-uppercase";

            string p = prioridad.ToString().ToUpper().Trim();

            switch (p)
            {
                case "ALTA":
                    return "badge text-bg-danger text-uppercase px-3 py-2 fw-semibold";
                case "MEDIA":
                    return "badge text-bg-warning text-uppercase px-3 py-2 fw-semibold";
                case "BAJA":
                    return "badge text-bg-success text-uppercase px-3 py-2 fw-semibold";
                default:
                    return "badge text-bg-dark text-uppercase px-3 py-2 fw-semibold border";
            }
        }

        protected void dgvTicketsDelSprint_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {

            dgvTicketsDelSprint.PageIndex = e.NewPageIndex;

            dgvTicketsDelSprint.DataSource = Session["listaSprints"];
            dgvTicketsDelSprint.DataBind();
        }

        protected void dgvTicketsDelSprint_PageIndexChanging1(object sender, GridViewPageEventArgs e)
        {
           
        }

        protected void dgvSprints_RowCreated(object sender, GridViewRowEventArgs e)
        {
            // Verificamos si la fila creada es la del paginador
            if (e.Row.RowType == DataControlRowType.Pager)
            {
                e.Row.Cells[0].Attributes.Add("class", "pagination-container");

                if (e.Row.Cells[0].Controls.Count > 0)
                {
                    Table pagerTable = (Table)e.Row.Cells[0].Controls[0];

                    pagerTable.Attributes.Add("class", "pagination pagination-sm justify-content-center my-3");

                    foreach (TableCell cell in pagerTable.Rows[0].Cells)
                    {
                        foreach (Control ctrl in cell.Controls)
                        {
                            if (ctrl is LinkButton)
                            {
                                ((LinkButton)ctrl).CssClass = "page-link";
                            }
                            else if (ctrl is Label) // Este es el número de página actual
                            {
                                ((Label)ctrl).CssClass = "page-link active";
                            }
                        }
                    }
                }
            }
        }

        protected void dgvSprints_PageIndexChanging1(object sender, GridViewPageEventArgs e)
        {

        }
    }



}
    
