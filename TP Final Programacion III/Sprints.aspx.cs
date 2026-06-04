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

                    //Datagrid View de Sprints
                    Session.Add("listaSprints", sprintNegocio.listar(userLogueado.Empresa.Id));
                    dgvSprints.DataSource = Session["listaSprints"];
                    dgvSprints.DataBind();
                }
                catch (Exception ex)
                {
                    Session.Add("error", ex.ToString());
                    Response.Redirect("Default.aspx", false);
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

        
        public string GetDiasRestantesTexto(object fechaFinEstimada, object esFinal)
        {
            if (esFinal != null && (bool)esFinal) return "Sprint cerrado";
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

        }

        protected void dgvSprints_SelectedIndexChanged(object sender, EventArgs e)
        {

        }

        protected void txtFiltroSprints_TextChanged(object sender, EventArgs e)
        {
            List<Sprint> lista = (List<Sprint>)Session["listaSprints"];
            List<Sprint> listaFiltrada = lista.FindAll(x => x.Proyecto.Nombre.ToUpper().Contains(txtFiltroSprints.Text.ToUpper()));
            dgvSprints.DataSource = listaFiltrada;
            dgvSprints.DataBind();
        }
    }


}
    
