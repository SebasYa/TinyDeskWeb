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
    public partial class _Default : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            if (!IsPostBack)
            {
                try
                {
                    ProyectoNegocio proyectoNegocio = new ProyectoNegocio();
                    SprintNegocio sprintNegocio = new SprintNegocio();
                    TicketNegocio ticketNegocio = new TicketNegocio();
                    int idEmpresa = ((Usuario)Session["usuario"]).Empresa.Id;
                    lblProyectosActivos.Text = proyectoNegocio.ContarActivos(idEmpresa).ToString();
                    lblSprintsEnCurso.Text = sprintNegocio.ContarEnCurso(idEmpresa).ToString();
                    lblTicketsAbiertos.Text = ticketNegocio.ContarAbiertos(idEmpresa).ToString();

                    EstadoNegocio estadoNegocio = new EstadoNegocio();
                    ddlEstadoProyecto.DataSource = estadoNegocio.listar(idEmpresa);
                    ddlEstadoProyecto.DataValueField = "Id";
                    ddlEstadoProyecto.DataTextField = "Nombre";
                    ddlEstadoProyecto.DataBind();
                    ddlEstadoProyecto.Items.Insert(0, new ListItem("Seleccione Estado..", ""));

                    ddlEstado.DataSource = estadoNegocio.listar(idEmpresa);
                    ddlEstado.DataValueField = "Id";
                    ddlEstado.DataTextField = "Nombre";
                    ddlEstado.DataBind();
                    ddlEstado.Items.Insert(0, new ListItem("Seleccione Estado..", ""));

                    AreaNegocio areaNegocio = new AreaNegocio();
                    ddlArea.DataSource = areaNegocio.listar(idEmpresa);
                    ddlArea.DataValueField = "Id";
                    ddlArea.DataTextField = "Nombre";
                    ddlArea.DataBind();
                    ddlArea.Items.Insert(0, new ListItem("Seleccione un área...", ""));

                    ddlProyecto.DataSource = proyectoNegocio.listar(idEmpresa);
                    ddlProyecto.DataValueField = "Id";
                    ddlProyecto.DataTextField = "Nombre";
                    ddlProyecto.DataBind();
                    ddlProyecto.Items.Insert(0, new ListItem("Seleccione un puesto...", ""));

                }
                catch (Exception ex)
                {

                    throw ex;
                }
            }
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
                int idEmpresa = userLogueado.Empresa.Id;
                lblSprintsEnCurso.Text = sprintNegocio.ContarEnCurso(idEmpresa).ToString();

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

        protected void btnGuardarProyecto_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtNombreProyecto.Text) ||
                string.IsNullOrWhiteSpace(txtFechaInicioProyecto.Text) ||
                string.IsNullOrWhiteSpace(txtFechaEstimadaFinProyecto.Text) ||
                string.IsNullOrWhiteSpace(ddlEstadoProyecto.SelectedValue))
            {
                return;
            }
            try
            {
                ProyectoNegocio proyectoNegocio = new ProyectoNegocio();
                Proyecto nuevoProyecto = new Proyecto();
                Usuario userLogueado = (Usuario)Session["usuario"];

                nuevoProyecto.Nombre = txtNombreProyecto.Text;
                nuevoProyecto.Descripcion = txtDescripcionProyecto.Text;
                nuevoProyecto.FechaInicio = Convert.ToDateTime(txtFechaInicioProyecto.Text);
                nuevoProyecto.FechaEstimadaFin = Convert.ToDateTime(txtFechaEstimadaFinProyecto.Text);
                nuevoProyecto.Activo = true;

                nuevoProyecto.Estado = new Estado();
                nuevoProyecto.Estado.Id = int.Parse(ddlEstadoProyecto.SelectedValue);

                nuevoProyecto.Empresa = new Empresa();
                nuevoProyecto.Empresa.Id = userLogueado.Empresa.Id;

                proyectoNegocio.agregar(nuevoProyecto);

                // Actualizamos el contador de proyectos activos en el Dashboard
                int idEmpresa = userLogueado.Empresa.Id;
                lblProyectosActivos.Text = proyectoNegocio.ContarActivos(idEmpresa).ToString();

                litMensaje.Text = @"
                <div class='alert alert-success alert-dismissible fade show' role='alert'>
                    <strong>¡Éxito!</strong> El Proyecto se guardó perfectamente.
                    <button type='button' class='btn-close' data-bs-dismiss='alert' aria-label='Close'></button>
                </div>";

                txtNombreProyecto.Text = "";
                txtDescripcionProyecto.Text = "";
                txtFechaInicioProyecto.Text = "";
                txtFechaEstimadaFinProyecto.Text = "";
                ddlEstadoProyecto.SelectedIndex = 0;
            }
            catch (Exception ex)
            {
                litMensaje.Text = $@"
        <div class='alert alert-danger alert-dismissible fade show' role='alert'>
            <strong>Hubo un error:</strong> {ex.Message}
            <button type='button' class='btn-close' data-bs-dismiss='alert' aria-label='Close'></button>
        </div>";

                Session.Add("error", ex.ToString());
                //Response.Redirect("Default.aspx", false);
            }
        }
        protected void btnCancelarProyecto_Click(object sender, EventArgs e)
        {
            txtNombreProyecto.Text = "";
            txtDescripcionProyecto.Text = "";
            txtFechaInicioProyecto.Text = "";
            txtFechaEstimadaFinProyecto.Text = "";
            ddlEstadoProyecto.SelectedIndex = 0;
        }

        protected void btnGuardarTicket_Click(object sender, EventArgs e)
        {
            litMensaje.Text = @"
            <div class='alert alert-info alert-dismissible fade show' role='alert'>
            Funcionalidad de Tickets en desarrollo.
            <button type='button' class='btn-close' data-bs-dismiss='alert'></button>
            </div>";
        }
    }
}