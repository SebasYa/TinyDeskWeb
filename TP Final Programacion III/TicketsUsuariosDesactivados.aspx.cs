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
    public partial class TicketsUsuariosDesactivados : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try
                {
                    CargarTickets();
                }
                catch (Exception ex)
                {
                    Session.Add("error", ex.ToString());
                    Response.Redirect("Default.aspx", false);
                }
            }
        }
        protected void dgvTickets_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            dgvTickets.PageIndex = e.NewPageIndex;
            dgvTickets.DataSource = Session["listaTicketsUsuariosDesactivados"];
            dgvTickets.DataBind();
        }
        public string GetClassPrioridad(object prioridadNombre)
        {
            if (prioridadNombre == null) return "badge text-bg-secondary px-3 py-2";

            string prioridad = prioridadNombre.ToString().ToLower();

            if (prioridad == "alta") return "badge text-bg-danger px-3 py-2";
            if (prioridad == "media") return "badge text-bg-warning px-3 py-2";
            if (prioridad == "baja") return "badge text-bg-success px-3 py-2";

            return "badge text-bg-secondary px-3 py-2";
        }
        public string GetClassEstado(object estadoNombre)
        {
            if (estadoNombre == null) return "badge text-bg-secondary px-3 py-2";

            string estado = estadoNombre.ToString().ToLower();

            if (estado == "en progreso") return "badge text-bg-primary px-3 py-2";
            if (estado == "finalizado") return "badge text-bg-success px-3 py-2";
            if (estado == "pendiente") return "badge text-bg-warning px-3 py-2";

            return "badge text-bg-dark px-3 py-2";
        }
        private void CargarTickets()
        {
            Usuario userLogueado = (Usuario)Session["usuario"];
            int idEmpresa = userLogueado.Empresa.Id;

            TicketNegocio ticketNegocio = new TicketNegocio();
            List<Ticket> lista = ticketNegocio.ListarAsignadosUsuariosDesactivados(idEmpresa);

            Session["listaTicketsUsuariosDesactivados"] = lista;
            dgvTickets.DataSource = lista;
            dgvTickets.DataBind();

            if (lista.Count == 0)
            {
                litMensajeEstado.Text = @"<div class='alert alert-success shadow-sm'>
                                    No hay tickets asignados a usuarios desactivados.
                                    </div>";
            }
            else
            {
                litMensajeEstado.Text = "";
            }
        }
        protected void dgvTickets_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                int idTicket = (int)dgvTickets.SelectedDataKey.Value;

                List<Ticket> listaTickets = (List<Ticket>)Session["listaTicketsUsuariosDesactivados"];
                Ticket ticket = listaTickets.Find(x => x.Id == idTicket);

                if (ticket == null)
                    return;

                hfIdTicketReasignar.Value = ticket.Id.ToString();
                lblTituloReasignar.Text = "Reasignar Ticket #" + ticket.Id;

                Usuario userLogueado = (Usuario)Session["usuario"];
                int idEmpresa = userLogueado.Empresa.Id;

                UsuarioNegocio usuarioNegocio = new UsuarioNegocio();
                List<Usuario> usuarios = usuarioNegocio.listar(idEmpresa);

                usuarios = usuarios.FindAll(x =>
                    x.Activo &&
                    x.EmailVerificado &&
                    x.Area.Id == ticket.Usuario.Area.Id &&
                    x.Puesto.Id == ticket.Usuario.Puesto.Id
                );

                ddlNuevoUsuario.DataSource = usuarios.Select(x => new
                {
                    Id = x.Id,
                    Nombre = x.Nombre + " " + x.Apellido + " | " +
                             x.Puesto.Nombre + " | " +
                            (x.Seniority != null ? x.Seniority.Nombre : "")
                }).ToList();

                ddlNuevoUsuario.DataValueField = "Id";
                ddlNuevoUsuario.DataTextField = "Nombre";
                ddlNuevoUsuario.DataBind();
                ddlNuevoUsuario.Items.Insert(0, new ListItem("Seleccione usuario...", ""));

                string seniorityActual = ticket.Usuario.Seniority != null ? ticket.Usuario.Seniority.Nombre : "";

                litDetalleReasignacion.Text = "<div class='alert alert-info mb-0'>" +
                                              "<strong>Usuario actual:</strong> " + ticket.Usuario.Nombre + " " + ticket.Usuario.Apellido + "<br/>" +
                                              "<strong>Área:</strong> " + ticket.Usuario.Area.Nombre + "<br/>" +
                                              "<strong>Puesto:</strong> " + ticket.Usuario.Puesto.Nombre + "<br/>" +
                                              "<strong>Seniority:</strong> " + seniorityActual +
                                              "</div>";

                btnConfirmarReasignacion.Enabled = usuarios.Count > 0;

                if (usuarios.Count == 0)
                {
                    litDetalleReasignacion.Text += "<div class='alert alert-danger mt-3 mb-0'>No hay usuarios activos disponibles para esa área y puesto.</div>";
                }

                string scriptOpen = @"document.addEventListener('DOMContentLoaded', function () {
                                      var modalElement = document.getElementById('reasignarTicketModal');
                                      var myModal = new bootstrap.Modal(modalElement);
                                      myModal.show();
                });";

                ScriptManager.RegisterStartupScript(this, this.GetType(), "OpenReasignarModal", scriptOpen, true);
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
            }
        }
        protected void btnConfirmarReasignacion_Click(object sender, EventArgs e)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(hfIdTicketReasignar.Value) ||
                    string.IsNullOrWhiteSpace(ddlNuevoUsuario.SelectedValue))
                {
                    litMensajeAccion.Text = @"<div class='alert alert-danger'>
                                                  Seleccioná un usuario para reasignar el ticket.
                                             </div>";
                    return;
                }

                int idTicket = int.Parse(hfIdTicketReasignar.Value);
                int idUsuario = int.Parse(ddlNuevoUsuario.SelectedValue);

                List<Ticket> listaTickets = (List<Ticket>)Session["listaTicketsUsuariosDesactivados"];
                Ticket ticket = listaTickets.Find(x => x.Id == idTicket);

                if (ticket == null)
                {
                    litMensajeAccion.Text = @"<div class='alert alert-danger'>
                                                  No se encontró el ticket seleccionado.
                                             </div>";
                    return;
                }

                TicketNegocio ticketNegocio = new TicketNegocio();
                ticketNegocio.ReasignarUsuario(idTicket, idUsuario);

                EmailService emailService = new EmailService();
                string linkTicket = LinkHelper.GenerarLink(this, "Tickets.aspx", "id", idTicket.ToString());

                bool mailEnviado = emailService.EnviarMailTicketAsignado(idUsuario, ticket, linkTicket);

                if (!mailEnviado)
                {
                    litMensajeAccion.Text = @"<div class='alert alert-danger'>
                                                 No se pudo enviar el mail al usuario asignado.
                                             </div>";
                    return;
                }

                litMensajeAccion.Text = @"<div id='mensajeReasignacionExitosa' class='alert alert-success alert-dismissible fade show' role='alert'>
                                               El ticket fue reasignado correctamente.
                                         <button type='button' class='btn-close' data-bs-dismiss='alert'></button>
                                         </div>";

                ScriptManager.RegisterStartupScript(this, this.GetType(), "OcultarMensajeReasignacion",
                    "setTimeout(function(){ var mensaje = document.getElementById('mensajeReasignacionExitosa'); if (mensaje) { mensaje.style.display = 'none'; } }, 5000);",
                    true);

                CargarTickets();
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                litMensajeAccion.Text = @"<div class='alert alert-danger'>
                                              Ocurrió un error al reasignar el ticket.
                                          </div>";
            }
        }
    }
}