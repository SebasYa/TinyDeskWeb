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
        public class VistaPreviaAsignacionIA
        {
            public int IdTicket { get; set; }
            public string Prioridad { get; set; }
            public string UsuarioActual { get; set; }
            public string Area { get; set; }
            public string Puesto { get; set; }
            public int IdUsuarioSugerido { get; set; }
            public string Motivo { get; set; }
            public List<CandidatoAsignacionIA> Candidatos { get; set; }
        }
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
        protected void btnReasignarConIA_Click(object sender, EventArgs e)
        {
            try
            {
                Usuario userLogueado = (Usuario)Session["usuario"];
                int idEmpresa = userLogueado.Empresa.Id;

                List<Ticket> listaTickets = (List<Ticket>)Session["listaTicketsUsuariosDesactivados"];

                if (listaTickets == null || listaTickets.Count == 0)
                {
                    litMensajeAccion.Text = @"<div class='alert alert-success'>
                                                  No hay tickets para reasignar.
                                              </div>";
                    return;
                }

                CandidatoAsignacionIANegocio candidatoNegocio = new CandidatoAsignacionIANegocio();
                List<VistaPreviaAsignacionIA> vistaPrevia = new List<VistaPreviaAsignacionIA>();

                foreach (Ticket ticket in listaTickets)
                {
                    List<CandidatoAsignacionIA> candidatos = candidatoNegocio.ListarCandidatos(
                        idEmpresa,
                        ticket.Usuario.Area.Id,
                        ticket.Usuario.Puesto.Id
                    );

                    int idUsuarioSugerido = candidatoNegocio.CalcularUsuarioSugerido(ticket.Prioridad.Nombre, candidatos);
                    CandidatoAsignacionIA usuarioSugerido = candidatos.Find(x => x.Id == idUsuarioSugerido);

                    VistaPreviaAsignacionIA item = new VistaPreviaAsignacionIA();
                    item.IdTicket = ticket.Id;
                    item.Prioridad = ticket.Prioridad.Nombre;
                    item.UsuarioActual = ticket.Usuario.Nombre + " " + ticket.Usuario.Apellido;
                    item.Area = ticket.Usuario.Area.Nombre;
                    item.Puesto = ticket.Usuario.Puesto.Nombre;
                    item.IdUsuarioSugerido = idUsuarioSugerido;
                    item.Motivo = candidatoNegocio.ObtenerMotivoSugerencia(usuarioSugerido);
                    item.Candidatos = candidatos;

                    vistaPrevia.Add(item);
                }

                Session["vistaPreviaAsignacionIA"] = vistaPrevia;

                dgvVistaPreviaIA.DataSource = vistaPrevia;
                dgvVistaPreviaIA.DataBind();

                string scriptOpen = @"document.addEventListener('DOMContentLoaded', function () {
                      var modalElement = document.getElementById('modalReasignarConIA');
                      var myModal = new bootstrap.Modal(modalElement);
                      myModal.show();
                });";
                ScriptManager.RegisterStartupScript(this, this.GetType(), "OpenModalReasignarConIA", scriptOpen, true);
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                litMensajeAccion.Text = @"<div class='alert alert-danger'>
                                              Ocurrió un error al preparar la reasignación con IA.
                                          </div>";
            }
        }
        protected void dgvVistaPreviaIA_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType != DataControlRowType.DataRow)
                return;

            VistaPreviaAsignacionIA item = (VistaPreviaAsignacionIA)e.Row.DataItem;

            DropDownList ddlUsuarioIA = (DropDownList)e.Row.FindControl("ddlUsuarioIA");
            Label lblMotivoIA = (Label)e.Row.FindControl("lblMotivoIA");

            ddlUsuarioIA.DataSource = item.Candidatos.Select(x => new
            {
                Id = x.Id,
                Nombre = x.Nombre + " " + x.Apellido
            }).ToList();

            ddlUsuarioIA.DataValueField = "Id";
            ddlUsuarioIA.DataTextField = "Nombre";
            ddlUsuarioIA.DataBind();

            ddlUsuarioIA.Items.Insert(0, new ListItem("Sin usuario asignado", ""));

            if (item.IdUsuarioSugerido > 0 && ddlUsuarioIA.Items.FindByValue(item.IdUsuarioSugerido.ToString()) != null)
                ddlUsuarioIA.SelectedValue = item.IdUsuarioSugerido.ToString();

            ddlUsuarioIA.Enabled = item.Candidatos.Count > 0;
            lblMotivoIA.Text = item.Motivo;
        }
        protected void btnConfirmarReasignacionIA_Click(object sender, EventArgs e)
        {
            try
            {
                TicketNegocio ticketNegocio = new TicketNegocio();
                EmailService emailService = new EmailService();

                List<Ticket> listaTickets = (List<Ticket>)Session["listaTicketsUsuariosDesactivados"];

                int total = dgvVistaPreviaIA.Rows.Count;
                int reasignados = 0;
                int noReasignados = 0;
                int mailsNoEnviados = 0;

                foreach (GridViewRow row in dgvVistaPreviaIA.Rows)
                {
                    DropDownList ddlUsuarioIA = (DropDownList)row.FindControl("ddlUsuarioIA");

                    int idTicket = int.Parse(dgvVistaPreviaIA.DataKeys[row.RowIndex].Value.ToString());

                    if (string.IsNullOrWhiteSpace(ddlUsuarioIA.SelectedValue))
                    {
                        noReasignados++;
                        continue;
                    }

                    int idUsuario = int.Parse(ddlUsuarioIA.SelectedValue);

                    ticketNegocio.ReasignarUsuario(idTicket, idUsuario);

                    Ticket ticket = listaTickets.Find(x => x.Id == idTicket);
                    string linkTicket = LinkHelper.GenerarLink(this, "Tickets.aspx", "id", idTicket.ToString());

                    bool mailEnviado = emailService.EnviarMailTicketAsignado(idUsuario, ticket, linkTicket);

                    if (!mailEnviado)
                        mailsNoEnviados++;

                    reasignados++;
                }

                string mensajeMail = mailsNoEnviados > 0
                    ? " " + mailsNoEnviados + " reasignación/es no pudieron notificarse por mail."
                    : "";

                litMensajeAccion.Text = @"<div id='mensajeReasignacionIA' class='alert alert-success alert-dismissible fade show' role='alert'>
                                              Se reasignaron " + reasignados + " de " + total + @" tickets.
                                              Quedaron " + noReasignados + @" para revisar manualmente." + mensajeMail + @"
                                              <button type='button' class='btn-close' data-bs-dismiss='alert'></button>
                                          </div>";

                ScriptManager.RegisterStartupScript(this, this.GetType(), "OcultarMensajeReasignacionIA",
                    "setTimeout(function(){ var mensaje = document.getElementById('mensajeReasignacionIA'); if (mensaje) { mensaje.style.display = 'none'; } }, 5000);",
                    true);

                CargarTickets();
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                litMensajeAccion.Text = @"<div class='alert alert-danger'>
                                              Ocurrió un error al confirmar las reasignaciones con IA.
                                          </div>";
            }
        }
    }
}