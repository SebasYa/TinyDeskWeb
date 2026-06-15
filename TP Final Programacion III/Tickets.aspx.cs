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
                    CargarListado(idEmpresa);
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

    }
}