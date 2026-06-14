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
                    Usuario usuario = (Usuario)Session["usuario"];
                    int idEmpresa = usuario.Empresa.Id;

                    TicketNegocio ticketNegocio = new TicketNegocio();
                    List<Ticket> lista = ticketNegocio.ListarAsignadosUsuariosDesactivados(idEmpresa);

                    Session["listaTicketsUsuariosDesactivados"] = lista;
                    dgvTickets.DataSource = lista;
                    dgvTickets.DataBind();

                    if (lista.Count == 0)
                    {
                        litMensaje.Text = @"<div class='alert alert-success shadow-sm'>
                                                No hay tickets asignados a usuarios desactivados.
                                            </div>";
                    }
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
    }
}