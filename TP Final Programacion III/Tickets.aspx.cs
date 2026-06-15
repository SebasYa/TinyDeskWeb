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
    public partial class Tickets : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            if (!Seguridad.sessionActiva(Session["usuario"]))
            {
                Response.Redirect("Login.aspx", false);
                return;
            }

            if (!IsPostBack)
            {
                try
                {
                    int idEmpresa = ((Usuario)Session["usuario"]).Empresa.Id;

                    if (Request.QueryString["id"] != null)
                    {
                        int idTicket = int.Parse(Request.QueryString["id"]);
                        CargarDetalleTicket(idTicket, idEmpresa);
                    }
                    else
                    {
                        CargarListado(idEmpresa);
                    }
                }
                catch (Exception ex)
                {
                    Session.Add("error", ex.ToString());
                    MostrarError("Ocurrió un error al cargar los tickets.");
                }
            }
        }

        private void CargarListado(int idEmpresa)
        {
            pnlListado.Visible = true;
            pnlDetalle.Visible = false;

            TicketNegocio negocio = new TicketNegocio();
            List<Ticket> lista = negocio.Listar(idEmpresa);

            Session["listaTickets"] = lista;
            dgvTickets.DataSource = lista;
            dgvTickets.DataBind();
        }

        private void CargarDetalleTicket(int idTicket, int idEmpresa)
        {
            pnlListado.Visible = false;
            pnlDetalle.Visible = true;

            TicketNegocio negocio = new TicketNegocio();
            Ticket ticket = negocio.BuscarPorId(idTicket);

            if (ticket == null)
            {
                Response.Redirect("Tickets.aspx", false);
                return;
            }

            lblDetalleDescripcion.Text = ticket.Descripcion;
            lblDetalleEstado.Text = ticket.Estado.Nombre;
            lblDetallePrioridad.Text = ticket.Prioridad.Nombre;
            lblDetalleUsuario.Text = ticket.Usuario.Nombre + " " + ticket.Usuario.Apellido;
            lblDetalleSprint.Text = "Sprint " + ticket.Sprint.NumeroSprint;
            lblDetalleProyecto.Text = ticket.Sprint.Proyecto.Nombre;
            lblDetalleFechaInicio.Text = ticket.FechaInicio.ToString("dd/MM/yyyy");
            lblDetalleFechaEstimadaFin.Text = ticket.FechaEstimadaFin.ToString("dd/MM/yyyy");
            lblDetalleFechaFin.Text = ticket.FechaFin.HasValue
                ? ticket.FechaFin.Value.ToString("dd/MM/yyyy") : "-";

            hdnIdTicket.Value = ticket.Id.ToString();
        }

        private void CargarDropdowns(int idEmpresa)
        {
            PrioridadNegocio prioridadNegocio = new PrioridadNegocio();
            var prioridades = prioridadNegocio.listar();

            ddlPrioridad.DataSource = prioridades;
            ddlPrioridad.DataValueField = "Id";
            ddlPrioridad.DataTextField = "Nombre";
            ddlPrioridad.DataBind();
            ddlPrioridad.Items.Insert(0, new ListItem("Seleccione prioridad...", ""));

            ddlEditPrioridad.DataSource = prioridades;
            ddlEditPrioridad.DataValueField = "Id";
            ddlEditPrioridad.DataTextField = "Nombre";
            ddlEditPrioridad.DataBind();
            ddlEditPrioridad.Items.Insert(0, new ListItem("Seleccione prioridad...", ""));

            EstadoNegocio estadoNegocio = new EstadoNegocio();
            var estados = estadoNegocio.listar(idEmpresa);
            Session["listaEstadosTicket"] = estados;

            ddlEstado.DataSource = estados;
            ddlEstado.DataValueField = "Id";
            ddlEstado.DataTextField = "Nombre";
            ddlEstado.DataBind();
            ddlEstado.Items.Insert(0, new ListItem("Seleccione estado...", ""));

            ddlEditEstado.DataSource = estados;
            ddlEditEstado.DataValueField = "Id";
            ddlEditEstado.DataTextField = "Nombre";
            ddlEditEstado.DataBind();
            ddlEditEstado.Items.Insert(0, new ListItem("Seleccione estado...", ""));

            UsuarioNegocio usuarioNegocio = new UsuarioNegocio();
            var usuarios = usuarioNegocio.listar(idEmpresa)
                .FindAll(u => u.Activo && u.EmailVerificado);

            ddlUsuario.DataSource = usuarios.Select(u => new
            {
                Id = u.Id,
                NombreCompleto = u.Nombre + " " + u.Apellido
            }).ToList();
            ddlUsuario.DataValueField = "Id";
            ddlUsuario.DataTextField = "NombreCompleto";
            ddlUsuario.DataBind();
            ddlUsuario.Items.Insert(0, new ListItem("Seleccione usuario...", ""));

            ddlEditUsuario.DataSource = usuarios.Select(u => new
            {
                Id = u.Id,
                NombreCompleto = u.Nombre + " " + u.Apellido
            }).ToList();
            ddlEditUsuario.DataValueField = "Id";
            ddlEditUsuario.DataTextField = "NombreCompleto";
            ddlEditUsuario.DataBind();
            ddlEditUsuario.Items.Insert(0, new ListItem("Seleccione usuario...", ""));

            SprintNegocio sprintNegocio = new SprintNegocio();
            var sprints = sprintNegocio.listar(idEmpresa);

            ddlSprint.DataSource = sprints.Select(s => new
            {
                Id = s.Id,
                Nombre = "Sprint " + s.NumeroSprint + " - " + s.Proyecto.Nombre
            }).ToList();
            ddlSprint.DataValueField = "Id";
            ddlSprint.DataTextField = "Nombre";
            ddlSprint.DataBind();
            ddlSprint.Items.Insert(0, new ListItem("Seleccione sprint...", ""));

            ddlEditSprint.DataSource = sprints.Select(s => new
            {
                Id = s.Id,
                Nombre = "Sprint " + s.NumeroSprint + " - " + s.Proyecto.Nombre
            }).ToList();
            ddlEditSprint.DataValueField = "Id";
            ddlEditSprint.DataTextField = "Nombre";
            ddlEditSprint.DataBind();
            ddlEditSprint.Items.Insert(0, new ListItem("Seleccione sprint...", ""));
        }

        protected void dgvTickets_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            dgvTickets.PageIndex = e.NewPageIndex;
            dgvTickets.DataSource = Session["listaTickets"];
            dgvTickets.DataBind();
        }

        protected void dgvTickets_SelectedIndexChanged(object sender, EventArgs e)
        {
            int idTicket = (int)dgvTickets.SelectedDataKey.Value;
            Response.Redirect("Tickets.aspx?id=" + idTicket, false);
        }

        private void MostrarError(string mensaje)
        {
            litMensaje.Text = $@"<div class='alert alert-danger alert-dismissible fade show' role='alert'>
                                    <strong>Error:</strong> {mensaje}
                                    <button type='button' class='btn-close' data-bs-dismiss='alert'></button>
                                  </div>";
        }

        private void MostrarExito(string mensaje)
        {
            litMensaje.Text = $@"<div class='alert alert-success alert-dismissible fade show' role='alert'>
                                    <strong>¡Éxito!</strong> {mensaje}
                                    <button type='button' class='btn-close' data-bs-dismiss='alert'></button>
                                  </div>";
        }

        protected void btnGuardarTicket_Click(object sender, EventArgs e)
        {


        }
        protected void btnGuardarEdicion_Click(object sender, EventArgs e)
        {
        }

        protected void btnDesactivar_Click(object sender, EventArgs e)
        {
        }
    }
}