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
    public partial class Proyectos : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                int idEmpresa = ((Usuario)Session["usuario"]).Empresa.Id;
                ProyectoNegocio negocio = new ProyectoNegocio();
                List<Proyecto> lista = negocio.listar(idEmpresa);
                repProyectos.DataSource = lista;
                repProyectos.DataBind();

                EstadoNegocio estadoNegocio = new EstadoNegocio();
                ddlEstadoProyecto.DataSource = estadoNegocio.listar(idEmpresa);
                ddlEstadoProyecto.DataValueField = "Id";
                ddlEstadoProyecto.DataTextField = "Nombre";
                ddlEstadoProyecto.DataBind();
                ddlEstadoProyecto.Items.Insert(0, new ListItem("Seleccione Estado..", ""));
            }
        }

        protected void btnProyecto_Click(object sender, EventArgs e)
        {

        }
        protected void btnGuardarProyecto_Click(object sender, EventArgs e)
        {
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
    }
}