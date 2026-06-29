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
            public int IdUsuarioSeleccionado { get; set; }
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
        private void CargarTickets()
        {
            Usuario userLogueado = (Usuario)Session["usuario"];
            int idEmpresa = userLogueado.Empresa.Id;

            TicketNegocio ticketNegocio = new TicketNegocio();
            List<Ticket> lista = ticketNegocio.ListarAsignadosUsuariosDesactivados(idEmpresa);

            Session["listaTicketsUsuariosDesactivados"] = lista;
            dpTickets.SetPageProperties(0, dpTickets.PageSize, false);
            lvTickets.DataSource = lista;
            lvTickets.DataBind();
            dpTickets.Visible = lista.Count > dpTickets.PageSize;

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
        protected void lvTickets_PagePropertiesChanging(object sender, PagePropertiesChangingEventArgs e)
        {
            List<Ticket> lista = (List<Ticket>)Session["listaTicketsUsuariosDesactivados"];
            dpTickets.SetPageProperties(e.StartRowIndex, e.MaximumRows, false);
            lvTickets.DataSource = lista;
            lvTickets.DataBind();
            dpTickets.Visible = lista.Count > dpTickets.PageSize;
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
        protected void btnReasignarTicket_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton boton = (LinkButton)sender;
                int idTicket = Convert.ToInt32(boton.CommandArgument);

                List<Ticket> listaTickets = (List<Ticket>)Session["listaTicketsUsuariosDesactivados"];
                Ticket ticket = listaTickets.Find(x => x.Id == idTicket);

                if (ticket == null) return;

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
                    "setTimeout(function(){ var mensaje = document.getElementById('mensajeReasignacionExitosa'); if (mensaje) { mensaje.style.display = 'none'; } }, 10000);",
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
                    List<CandidatoAsignacionIA> candidatos = candidatoNegocio.ListarCandidatos(idEmpresa, ticket.Usuario.Area.Id, ticket.Usuario.Puesto.Id);

                    int idUsuarioSugerido = candidatoNegocio.CalcularUsuarioSugerido(ticket.Prioridad.Nombre, candidatos);
                    CandidatoAsignacionIA usuarioSugerido = candidatos.Find(x => x.Id == idUsuarioSugerido);

                    VistaPreviaAsignacionIA item = new VistaPreviaAsignacionIA();
                    item.IdTicket = ticket.Id;
                    item.Prioridad = ticket.Prioridad.Nombre;
                    item.UsuarioActual = ticket.Usuario.Nombre + " " + ticket.Usuario.Apellido;
                    item.Area = ticket.Usuario.Area.Nombre;
                    item.Puesto = ticket.Usuario.Puesto.Nombre;
                    item.IdUsuarioSugerido = idUsuarioSugerido;
                    item.IdUsuarioSeleccionado = idUsuarioSugerido;
                    item.Candidatos = candidatos;

                    vistaPrevia.Add(item);
                }

                Session["vistaPreviaAsignacionIA"] = vistaPrevia;

                dpVistaPreviaIA.SetPageProperties(0, dpVistaPreviaIA.PageSize, false);
                lvVistaPreviaIA.DataSource = vistaPrevia;
                lvVistaPreviaIA.DataBind();
                dpVistaPreviaIA.Visible = vistaPrevia.Count > dpVistaPreviaIA.PageSize;

                RegistrarScriptMotivoIA();

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
        protected void lvVistaPreviaIA_ItemDataBound(object sender, ListViewItemEventArgs e)
        {
            if (e.Item.ItemType != ListViewItemType.DataItem) return;

            VistaPreviaAsignacionIA item = (VistaPreviaAsignacionIA)((ListViewDataItem)e.Item).DataItem;
            DropDownList ddlUsuarioIA = (DropDownList)e.Item.FindControl("ddlUsuarioIA");
            Label lblMotivoIA = (Label)e.Item.FindControl("lblMotivoIA");

            ddlUsuarioIA.DataSource = item.Candidatos.Select(x => new
            {
                Id = x.Id,
                Nombre = x.Nombre + " " + x.Apellido
            }).ToList();

            ddlUsuarioIA.DataValueField = "Id";
            ddlUsuarioIA.DataTextField = "Nombre";
            ddlUsuarioIA.DataBind();

            ddlUsuarioIA.Items.Insert(0, new ListItem("Sin usuario asignado", ""));
            ddlUsuarioIA.Items[0].Attributes["data-motivo"] = "No se reasignará este ticket.";

            CandidatoAsignacionIANegocio negocio = new CandidatoAsignacionIANegocio();

            foreach (ListItem opcion in ddlUsuarioIA.Items)
            {
                if (!string.IsNullOrWhiteSpace(opcion.Value))
                {
                    CandidatoAsignacionIA candidato = item.Candidatos.Find(x => x.Id.ToString() == opcion.Value);

                    if (candidato != null) opcion.Attributes["data-motivo"] = negocio.ObtenerMotivoSugerencia(candidato);
                }
            }

            if (item.IdUsuarioSeleccionado > 0 && ddlUsuarioIA.Items.FindByValue(item.IdUsuarioSeleccionado.ToString()) != null)
                ddlUsuarioIA.SelectedValue = item.IdUsuarioSeleccionado.ToString();

            ddlUsuarioIA.Enabled = item.Candidatos.Count > 0;
            if(item.IdUsuarioSeleccionado == 0)
            {
                lblMotivoIA.Text = "No se reasignará este ticket.";
            }
            else
            {
                CandidatoAsignacionIA candidatoSeleccionado = item.Candidatos.Find(x => x.Id == item.IdUsuarioSeleccionado);
                lblMotivoIA.Text = negocio.ObtenerMotivoSugerencia(candidatoSeleccionado);
            }
        }
        protected void lvVistaPreviaIA_PagePropertiesChanging(object sender, PagePropertiesChangingEventArgs e)
        {
            GuardarSeleccionPaginaActualIA();

            dpVistaPreviaIA.SetPageProperties(e.StartRowIndex, e.MaximumRows, false);
            List<VistaPreviaAsignacionIA> vistaPrevia = (List<VistaPreviaAsignacionIA>)Session["vistaPreviaAsignacionIA"];
            lvVistaPreviaIA.DataSource = vistaPrevia;
            lvVistaPreviaIA.DataBind();
            dpVistaPreviaIA.Visible = vistaPrevia.Count > dpVistaPreviaIA.PageSize;

            RegistrarScriptMotivoIA();
        }
        protected void btnConfirmarReasignacionIA_Click(object sender, EventArgs e)
        {
            try
            {
                GuardarSeleccionPaginaActualIA();
                TicketNegocio ticketNegocio = new TicketNegocio();
                List<Ticket> listaTickets = (List<Ticket>)Session["listaTicketsUsuariosDesactivados"];
                List<VistaPreviaAsignacionIA> vistaPrevia = (List<VistaPreviaAsignacionIA>)Session["vistaPreviaAsignacionIA"];

                int total = vistaPrevia.Count;
                int reasignados = 0;
                int noReasignados = 0;
                int mailsNoEnviados = 0;
                string erroresMail = "";
                bool yaSeEnvioUnMail = false;

                foreach (VistaPreviaAsignacionIA item in vistaPrevia)
                {
                    int idTicket = item.IdTicket;
                    int idUsuario = item.IdUsuarioSeleccionado;

                    if (idUsuario == 0)
                    {
                        noReasignados++;
                        continue;
                    }

                    try
                    {
                        ticketNegocio.ReasignarUsuario(idTicket, idUsuario);

                        Ticket ticket = listaTickets.Find(x => x.Id == idTicket);

                        if (ticket != null)
                        {
                            try
                            {
                                // se agregan 11 segundos entre envio de mail y otro. Mailtrap gratuito concede 1 mail cada 10 seg.
                                if (yaSeEnvioUnMail) System.Threading.Thread.Sleep(11000);

                                EmailService emailService = new EmailService();
                                string linkTicket = LinkHelper.GenerarLink(this, "Tickets.aspx", "id", idTicket.ToString());

                                bool mailEnviado = emailService.EnviarMailTicketAsignado(idUsuario, ticket, linkTicket);

                                if (!mailEnviado)
                                {
                                    mailsNoEnviados++;
                                    erroresMail += " Ticket #" + idTicket + ": " + emailService.UltimoError;
                                }
                                yaSeEnvioUnMail = true;
                            }
                            catch (Exception ex)
                            {
                                mailsNoEnviados++;
                                erroresMail += " Ticket #" + idTicket + ": " + ex.Message;
                                yaSeEnvioUnMail = true;
                            }
                        }
                        else
                        {
                            mailsNoEnviados++;
                        }

                        reasignados++;
                    }
                    catch
                    {
                        noReasignados++;
                    }
                }

                string mensajeMail = mailsNoEnviados > 0
                    ? " " + mailsNoEnviados + " reasignación/es no pudieron notificarse por mail."
                    : "";

                litMensajeAccion.Text = @"<div id='mensajeReasignacionIA' class='alert alert-success alert-dismissible fade show' role='alert'>
                                              Se reasignaron " + reasignados + " de " + total + @" tickets.
                                              Quedaron " + noReasignados + @" para revisar manualmente." + mensajeMail + erroresMail + @"
                                              <button type='button' class='btn-close' data-bs-dismiss='alert'></button>
                                          </div>";

                ScriptManager.RegisterStartupScript(this, this.GetType(), "OcultarMensajeReasignacionIA",
                    "setTimeout(function(){ var mensaje = document.getElementById('mensajeReasignacionIA'); if (mensaje) { mensaje.style.display = 'none'; } }, 10000);",
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
        private void GuardarSeleccionPaginaActualIA()
        {
            List<VistaPreviaAsignacionIA> vistaPrevia = (List<VistaPreviaAsignacionIA>)Session["vistaPreviaAsignacionIA"];

            if (vistaPrevia == null) return;

            foreach (ListViewDataItem fila in lvVistaPreviaIA.Items)
            {
                HiddenField hfIdTicketIA = (HiddenField)fila.FindControl("hfIdTicketIA");
                DropDownList ddlUsuarioIA = (DropDownList)fila.FindControl("ddlUsuarioIA");

                int idTicket = Convert.ToInt32(hfIdTicketIA.Value);
                VistaPreviaAsignacionIA item = vistaPrevia.Find(x => x.IdTicket == idTicket);

                if (item != null)
                {
                    if (string.IsNullOrWhiteSpace(ddlUsuarioIA.SelectedValue)) item.IdUsuarioSeleccionado = 0;
                    else item.IdUsuarioSeleccionado = int.Parse(ddlUsuarioIA.SelectedValue);
                }
            }

            Session["vistaPreviaAsignacionIA"] = vistaPrevia;
        }
        private void RegistrarScriptMotivoIA()
        {
            string script = @"document.addEventListener('change', function(e) {
                                  if (e.target && e.target.classList.contains('ddl-usuario-ia')) {
                                      var ddl = e.target;
                                      var opcion = ddl.options[ddl.selectedIndex];
                                      var motivo = opcion ? opcion.getAttribute('data-motivo') : '';
                                      var celda = ddl.closest('td');
                                      var label = celda ? celda.querySelector('.motivo-ia') : null;
                          
                                      if (label) {
                                          label.innerText = motivo || 'No se reasignará este ticket.';
                                      }
                                  }
                              }); ";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "ScriptMotivoIA", script, true);
        }
    }
}