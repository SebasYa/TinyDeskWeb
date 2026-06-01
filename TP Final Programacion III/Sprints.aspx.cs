using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using dominio;
using negocio;


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

                    ddlArea.DataSource = areaNegocio.listar(userLogueado.Empresa.Id);
                    ddlArea.DataValueField = "Id";
                    ddlArea.DataTextField = "Nombre";
                    ddlArea.DataBind();
                    ddlArea.Items.Insert(0, new ListItem("Seleccione un área...", ""));

                    ddlEstado.DataSource = estadoNegocio.listar();
                    ddlEstado.DataValueField = "Id";
                    ddlEstado.DataTextField = "Nombre";
                    ddlEstado.DataBind();
                    ddlEstado.Items.Insert(0, new ListItem("Seleccione un puesto...", ""));

                    ddlProyecto.DataSource = proyectoNegocio.listar(userLogueado.Empresa.Id);
                    ddlProyecto.DataValueField = "Id";
                    ddlProyecto.DataTextField = "Nombre";
                    ddlProyecto.DataBind();
                    ddlProyecto.Items.Insert(0, new ListItem("Seleccione un puesto...", ""));
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

        protected void ddlProyecto_SelectedIndexChanged(object sender, EventArgs e)
        {
        }

        protected void dgvSprints_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {

        }

        protected void dgvSprints_SelectedIndexChanged(object sender, EventArgs e)
        {

        }
    }


}
    
