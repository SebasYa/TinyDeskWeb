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
    public partial class UsuarioDefault : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Seguridad.sessionActiva(Session["usuario"]))
            {
                Response.Redirect("Login.aspx", false);
                return;
            }

            if (Seguridad.EsAdmin(Session["usuario"]) || Seguridad.PuedeEscribir(Session["usuario"]))
            {
                Response.Redirect("Default.aspx", false);
                return;
            }

            if (!IsPostBack)
            {
                Usuario usuario = (Usuario)Session["usuario"];
                CargarDatosUsuario(usuario);
                CargarResumenTickets(usuario);
            }
        }
        protected void btnSprintsActivosUsuario_Click(object sender, EventArgs e)
        {

        }
        protected void btnSprintsNoActivosUsuario_Click(object sender, EventArgs e)
        {

        }
        private void CargarDatosUsuario(Usuario usuario)
        {
            int hora = DateTime.Now.Hour;
            string saludo;
            if (hora >= 6 && hora < 12) saludo = "Buen Día";
            else if (hora >= 12 && hora < 19) saludo = "Buenas Tardes";
            else saludo = "Buenas Noches";

            lblBienvenida.Text = saludo + ": " + usuario.Nombre + " " + usuario.Apellido;
            lblAreaUsuario.Text = usuario.Area.Nombre;
            lblRolUsuario.Text = usuario.Puesto.Nombre;
            lblSeniorityUsuario.Text = usuario.Seniority != null ? usuario.Seniority.Nombre : "-";
        }

        private void CargarResumenTickets(Usuario usuario)
        {
            TicketNegocio ticketNegocio = new TicketNegocio();
            List<Ticket> tickets = ticketNegocio.Listar(usuario.Empresa.Id, usuario.Id);
            List<Ticket> pendientes = tickets.FindAll(x => x.Activo && !x.Estado.EsFinal);
            List<Ticket> vencidos = pendientes.FindAll(x => x.FechaEstimadaFin.Date < DateTime.Today);

            lblMisTicketsVencidos.Text = vencidos.Count.ToString();
            pnlMisTicketsVencidos.CssClass = ObtenerClaseTarjetaVencidos(vencidos.Count);

            Ticket proximaTarea = pendientes.OrderBy(x => x.FechaEstimadaFin).ThenBy(x => x.Id).FirstOrDefault();

            if (proximaTarea == null)
            {
                pnlProximaTarea.Visible = false;
                pnlSinTareas.Visible = true;
                return;
            }

            pnlProximaTarea.Visible = true;
            pnlSinTareas.Visible = false;

            lblProximaTareaDescripcion.Text = proximaTarea.Descripcion;
            lblProximaTareaNumero.Text = "TK-" + proximaTarea.Id.ToString().PadLeft(3, '0');
            lblProximaTareaPrioridad.Text = proximaTarea.Prioridad.Nombre;
            lblProximaTareaPrioridad.CssClass = ObtenerClasePrioridad(proximaTarea.Prioridad.Nombre);
            lblProximaTareaVencimiento.Text = ObtenerTextoVencimiento(proximaTarea.FechaEstimadaFin);
            lnkProximaTarea.NavigateUrl = "TicketsUsuario.aspx?id=" + proximaTarea.Id;
        }

        private string ObtenerClaseTarjetaVencidos(int cantidad)
        {
            string claseBase = "card border-0 shadow-sm h-100 ";

            if (cantidad == 0) return claseBase + "bg-light";
            if (cantidad <= 2) return claseBase + "bg-danger bg-opacity-10";
            if (cantidad <= 5) return claseBase + "bg-danger bg-opacity-25";

            return claseBase + "bg-danger bg-opacity-50";
        }

        private string ObtenerClasePrioridad(string prioridad)
        {
            if (prioridad.ToUpper() == "ALTA") return "badge bg-danger-subtle text-danger";
            if (prioridad.ToUpper() == "MEDIA") return "badge bg-warning-subtle text-warning";
            if (prioridad.ToUpper() == "BAJA") return "badge bg-success-subtle text-success";

            return "badge bg-secondary-subtle text-secondary";
        }

        private string ObtenerTextoVencimiento(DateTime fechaEstimada)
        {
            int dias = (fechaEstimada.Date - DateTime.Today).Days;

            if (dias < 0) return "Vencido hace " + Math.Abs(dias) + (Math.Abs(dias) == 1 ? " día" : " días");
            if (dias == 0) return "Vence hoy";
            if (dias == 1) return "Vence mañana";

            return "Faltan " + dias + " días";
        }

    }
}