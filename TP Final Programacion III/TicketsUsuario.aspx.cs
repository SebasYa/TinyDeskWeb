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
    public partial class TicketsUsuario : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try
                {
                    Usuario usuario = (Usuario)Session["usuario"];

                    if (Request.QueryString["id"] != null)
                    {
                        int idTicket = int.Parse(Request.QueryString["id"]);
                        CargarDetalleTicket(idTicket, usuario);
                    }
                    else
                    {
                        Session["TicketsUsuarioSoloPendientes"] = true;
                        FiltrosVisibles = false;
                        CargarFiltros();
                        CargarListado(usuario);
                        ActualizarVisibilidadFiltros();
                    }
                }
                catch (Exception ex)
                {
                    Session["error"] = ex.ToString();
                    MostrarError("Ocurrió un error al cargar tus tickets.");
                }
            }
        }
        private void CargarFiltros()
        {
            PrioridadNegocio prioridadNegocio = new PrioridadNegocio();

            ddlPrioridad.DataSource = prioridadNegocio.listar();
            ddlPrioridad.DataValueField = "Id";
            ddlPrioridad.DataTextField = "Nombre";
            ddlPrioridad.DataBind();
            ddlPrioridad.Items.Insert(0, new ListItem("Todas", ""));
        }
        private void CargarListado(Usuario usuario)
        {
            pnlListado.Visible = true;
            pnlDetalle.Visible = false;
            TicketNegocio negocio = new TicketNegocio();
            List<Ticket> lista = negocio.Listar(usuario.Empresa.Id, usuario.Id);
            Session["listaTicketsUsuario"] = lista;
            AplicarFiltros(true);
        }
        private void CargarDetalleTicket(int idTicket, Usuario usuario)
        {
            pnlListado.Visible = false;
            pnlDetalle.Visible = true;

            TicketNegocio negocio = new TicketNegocio();
            List<Ticket> ticketsUsuario = negocio.Listar(usuario.Empresa.Id, usuario.Id);
            Ticket ticket = ticketsUsuario.Find(x => x.Id == idTicket);

            if (ticket == null)
            {
                Response.Redirect("TicketsUsuario.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            lblDetalleDescripcion.Text = ticket.Descripcion;
            lblDetalleEstado.Text = ticket.Estado.Nombre;
            lblDetalleEstado.CssClass = GetClassEstado(ticket.Estado.Nombre, ticket.Estado.EsFinal);
            lblDetallePrioridad.Text = ticket.Prioridad.Nombre;
            lblDetallePrioridad.CssClass = GetClassPrioridad(ticket.Prioridad.Nombre);
            lblDetalleFechaInicio.Text = ticket.FechaInicio.ToString("dd/MM/yyyy");
            lblDetalleFechaEstimadaFin.Text = ticket.FechaEstimadaFin.ToString("dd/MM/yyyy");
            lblDetalleFechaFin.Text = ticket.FechaFin.HasValue ? ticket.FechaFin.Value.ToString("dd/MM/yyyy") : "-";
            lblDetalleSprint.Text = "Sprint " + ticket.Sprint.NumeroSprint;
            lblDetalleProyecto.Text = ticket.Sprint.Proyecto.Nombre;
            lblTicketSprintProyecto.Text = "Sprint " + ticket.Sprint.NumeroSprint + " / " + ticket.Sprint.Proyecto.Nombre;
            hdnIdTicket.Value = ticket.Id.ToString();

            phAccionesTicket.Visible = ticket.Activo && !ticket.Estado.EsFinal;

            if (phAccionesTicket.Visible)
            {
                EstadoNegocio estadoNegocio = new EstadoNegocio();
                List<Estado> estados = estadoNegocio.listar(usuario.Empresa.Id).FindAll(x => !x.EsFinal);

                ddlEstadoTicket.DataSource = estados;
                ddlEstadoTicket.DataValueField = "Id";
                ddlEstadoTicket.DataTextField = "Nombre";
                ddlEstadoTicket.DataBind();
                ddlEstadoTicket.SelectedValue = ticket.Estado.Id.ToString();
            }
        }
        private void AplicarFiltros(bool reiniciarPagina)
        {
            List<Ticket> lista = Session["listaTicketsUsuario"] as List<Ticket> ?? new List<Ticket>();
            bool soloPendientes = Session["TicketsUsuarioSoloPendientes"] == null || (bool)Session["TicketsUsuarioSoloPendientes"];

            if (soloPendientes) lista = lista.Where(x => x.Activo && !x.Estado.EsFinal).ToList();

            int dias = int.Parse(ddlProximoVencimiento.SelectedValue);

            if (soloPendientes && dias > 0)
            {
                DateTime hoy = DateTime.Today;
                DateTime limite = hoy.AddDays(dias);
                lista = lista.Where(x => x.FechaEstimadaFin.Date >= hoy && x.FechaEstimadaFin.Date <= limite).ToList();
            }

            string filtro = txtFiltro.Text.Trim();

            if (!string.IsNullOrWhiteSpace(filtro))
            {
                lista = lista.Where(x =>
                    x.Id.ToString().Contains(filtro) ||
                    (!string.IsNullOrWhiteSpace(x.Descripcion) && x.Descripcion.IndexOf(filtro, StringComparison.OrdinalIgnoreCase) >= 0) ||
                    (x.Sprint?.Proyecto != null && !string.IsNullOrWhiteSpace(x.Sprint.Proyecto.Nombre) && x.Sprint.Proyecto.Nombre.IndexOf(filtro, StringComparison.OrdinalIgnoreCase) >= 0) ||
                    (x.Sprint != null && x.Sprint.NumeroSprint.ToString().Contains(filtro))
                ).ToList();
            }

            if (!string.IsNullOrWhiteSpace(ddlPrioridad.SelectedValue))
            {
                int idPrioridad = int.Parse(ddlPrioridad.SelectedValue);
                lista = lista.Where(x => x.Prioridad != null && x.Prioridad.Id == idPrioridad).ToList();
            }

            switch (ddlOrden.SelectedValue)
            {
                case "fecha_desc":
                    lista = lista.OrderBy(x => x.Activo && !x.Estado.EsFinal ? 0 : 1).ThenByDescending(x => x.FechaEstimadaFin).ToList();
                    break;

                case "prioridad":
                    lista = lista.OrderBy(x => x.Activo && !x.Estado.EsFinal ? 0 : 1).ThenBy(x => ObtenerOrdenPrioridad(x.Prioridad?.Nombre)).ThenBy(x => x.FechaEstimadaFin).ToList();
                    break;

                case "recientes":
                    lista = lista.OrderBy(x => x.Activo && !x.Estado.EsFinal ? 0 : 1).ThenByDescending(x => x.FechaInicio).ThenByDescending(x => x.Id).ToList();
                    break;

                default:
                    lista = lista.OrderBy(x => x.Activo && !x.Estado.EsFinal ? 0 : 1).ThenBy(x => x.FechaEstimadaFin).ToList();
                    break;
            }

            Session["listaTicketsUsuarioFiltrada"] = lista;

            if (reiniciarPagina) dpTickets.SetPageProperties(0, dpTickets.PageSize, false);

            lvTickets.DataSource = lista;
            lvTickets.DataBind();
            dpTickets.Visible = lista.Count > dpTickets.PageSize;

            ActualizarControlesFiltroRapido(soloPendientes);
        }
        protected void btnToggleFiltros_Click(object sender, EventArgs e)
        {
            FiltrosVisibles = !FiltrosVisibles;
            ActualizarVisibilidadFiltros();
        }
        private void ActualizarVisibilidadFiltros()
        {
            pnlFiltros.Visible = FiltrosVisibles;
            btnToggleFiltros.Text = FiltrosVisibles ? "Ocultar filtros" : "Mostrar filtros";
            btnToggleFiltros.CssClass = FiltrosVisibles ? "btn btn-secondary w-100" : "btn btn-outline-secondary w-100";
        }
        private void ActualizarControlesFiltroRapido(bool soloPendientes)
        {
            List<Ticket> listaCompleta = Session["listaTicketsUsuario"] as List<Ticket> ?? new List<Ticket>();
            int cantidadPendientes = listaCompleta.Count(x => x.Activo && !x.Estado.EsFinal);

            btnFiltroPendientes.Text = "Pendientes (" + cantidadPendientes + ")";
            btnMostrarTodos.Text = "Todos";
            btnFiltroPendientes.CssClass = "btn btn-outline-primary flex-fill" + (soloPendientes ? " active" : "");
            btnMostrarTodos.CssClass = "btn btn-outline-secondary flex-fill" + (!soloPendientes ? " active" : "");
            ddlProximoVencimiento.Enabled = soloPendientes;
        }
        protected void btnFiltroPendientes_Click(object sender, EventArgs e)
        {
            Session["TicketsUsuarioSoloPendientes"] = true;
            AplicarFiltros(true);
        }
        protected void btnMostrarTodos_Click(object sender, EventArgs e)
        {
            Session["TicketsUsuarioSoloPendientes"] = false;
            ddlProximoVencimiento.SelectedValue = "0";
            AplicarFiltros(true);
        }
        protected void ddlProximoVencimiento_SelectedIndexChanged(object sender, EventArgs e)
        {
            Session["TicketsUsuarioSoloPendientes"] = true;
            AplicarFiltros(true);
        }
        private bool FiltrosVisibles
        {
            get { return ViewState["FiltrosVisibles"] != null && (bool)ViewState["FiltrosVisibles"]; }
            set { ViewState["FiltrosVisibles"] = value; }
        }
        protected void btnAplicarFiltros_Click(object sender, EventArgs e)
        {
            AplicarFiltros(true);
        }
        protected void btnLimpiarFiltros_Click(object sender, EventArgs e)
        {
            txtFiltro.Text = "";
            ddlPrioridad.SelectedValue = "";
            ddlOrden.SelectedValue = "fecha_asc";
            ddlProximoVencimiento.SelectedValue = "0";
            Session["TicketsUsuarioSoloPendientes"] = true;
            AplicarFiltros(true);
        }
        protected void lvTickets_PagePropertiesChanging(object sender, PagePropertiesChangingEventArgs e)
        {
            List<Ticket> lista = Session["listaTicketsUsuarioFiltrada"] as List<Ticket> ?? new List<Ticket>();

            dpTickets.SetPageProperties(e.StartRowIndex, e.MaximumRows, false);
            lvTickets.DataSource = lista;
            lvTickets.DataBind();
            dpTickets.Visible = lista.Count > dpTickets.PageSize;
        }
        protected void btnVerTicket_Click(object sender, EventArgs e)
        {
            LinkButton boton = (LinkButton)sender;
            int idTicket = Convert.ToInt32(boton.CommandArgument);

            Response.Redirect("TicketsUsuario.aspx?id=" + idTicket, false);
            Context.ApplicationInstance.CompleteRequest();
        }
        protected void btnCambiarEstado_Click(object sender, EventArgs e)
        {
            try
            {
                Usuario usuario = (Usuario)Session["usuario"];
                int idTicket = int.Parse(hdnIdTicket.Value);

                TicketNegocio negocio = new TicketNegocio();
                List<Ticket> ticketsUsuario = negocio.Listar(usuario.Empresa.Id, usuario.Id);
                Ticket ticket = ticketsUsuario.Find(x => x.Id == idTicket);

                if (ticket == null || !ticket.Activo || ticket.Estado.EsFinal)
                {
                    Response.Redirect("TicketsUsuario.aspx", false);
                    Context.ApplicationInstance.CompleteRequest();
                    return;
                }

                EstadoNegocio estadoNegocio = new EstadoNegocio();
                Estado estado = estadoNegocio.listar(usuario.Empresa.Id).Find(x => x.Id == int.Parse(ddlEstadoTicket.SelectedValue) && !x.EsFinal);

                if (estado == null)
                {
                    MostrarError("El estado seleccionado no es válido.");
                    CargarDetalleTicket(idTicket, usuario);
                    return;
                }

                ticket.Estado = estado;
                negocio.Modificar(ticket);

                MostrarExito("Estado actualizado correctamente.");
                CargarDetalleTicket(idTicket, usuario);
            }
            catch (Exception ex)
            {
                Session["error"] = ex.ToString();
                MostrarError("Ocurrió un error al cambiar el estado.");
            }
        }
        protected void btnFinalizarTicket_Click(object sender, EventArgs e)
        {
            try
            {
                Usuario usuario = (Usuario)Session["usuario"];
                int idTicket = int.Parse(hdnIdTicket.Value);

                TicketNegocio negocio = new TicketNegocio();
                List<Ticket> ticketsUsuario = negocio.Listar(usuario.Empresa.Id, usuario.Id);
                Ticket ticket = ticketsUsuario.Find(x => x.Id == idTicket);

                if (ticket == null || !ticket.Activo || ticket.Estado.EsFinal)
                {
                    Response.Redirect("TicketsUsuario.aspx", false);
                    Context.ApplicationInstance.CompleteRequest();
                    return;
                }

                EstadoNegocio estadoNegocio = new EstadoNegocio();
                Estado estadoFinal = estadoNegocio.listar(usuario.Empresa.Id).Find(x => x.EsFinal && x.Nombre.ToUpper() == "FINALIZADO");

                if (estadoFinal == null)
                {
                    MostrarError("No se encontró el estado finalizado.");
                    CargarDetalleTicket(idTicket, usuario);
                    return;
                }

                ticket.Estado = estadoFinal;
                negocio.Modificar(ticket);

                MostrarExito("Ticket finalizado correctamente.");
                CargarDetalleTicket(idTicket, usuario);
            }
            catch (Exception ex)
            {
                Session["error"] = ex.ToString();
                MostrarError("Ocurrió un error al finalizar el ticket.");
            }
        }
        private void MostrarExito(string mensaje)
        {
            litMensaje.Text = "<div class='alert alert-success alert-dismissible fade show' role='alert'><strong>Correcto:</strong> " 
                              + mensaje + "<button type='button' class='btn-close' data-bs-dismiss='alert'></button></div>";
        }
        private int ObtenerOrdenPrioridad(string prioridad)
        {
            string nombre = prioridad != null ? prioridad.ToUpper() : "";

            if (nombre == "ALTA") return 1;
            if (nombre == "MEDIA") return 2;
            if (nombre == "BAJA") return 3;

            return 4;
        }
        public string GetClassEstado(object nombreEstado, object esFinal)
        {
            if ((bool)esFinal) return "badge bg-success-subtle text-success rounded-pill";
            if (nombreEstado != null && nombreEstado.ToString().ToUpper() == "EN PROGRESO") return "badge bg-primary-subtle text-primary rounded-pill";
            if (nombreEstado != null && nombreEstado.ToString().ToUpper() == "PENDIENTE") return "badge bg-warning-subtle text-warning rounded-pill";

            return "badge bg-secondary-subtle text-secondary rounded-pill";
        }
        public string GetClassPrioridad(object prioridad)
        {
            string nombre = prioridad != null ? prioridad.ToString().ToUpper() : "";

            if (nombre == "ALTA") return "badge bg-danger-subtle text-danger rounded-pill";
            if (nombre == "MEDIA") return "badge bg-warning-subtle text-warning rounded-pill";
            if (nombre == "BAJA") return "badge bg-success-subtle text-success rounded-pill";

            return "badge bg-secondary-subtle text-secondary rounded-pill";
        }
        public string GetClassVencimiento(object fechaEstimada, object esFinal)
        {
            if ((bool)esFinal) return "badge bg-success-subtle text-success rounded-pill";

            DateTime fecha = Convert.ToDateTime(fechaEstimada).Date;
            int dias = (fecha - DateTime.Today).Days;

            if (dias < 0) return "badge bg-danger-subtle text-danger rounded-pill";
            if (dias == 0) return "badge bg-warning text-dark rounded-pill";
            if (dias <= 7) return "badge bg-warning-subtle text-warning rounded-pill";

            return "badge bg-light text-secondary border rounded-pill";
        }
        public string GetTextoVencimiento(object fechaEstimada, object fechaFin, object esFinal)
        {
            if ((bool)esFinal)
            {
                if (fechaFin != null && fechaFin != DBNull.Value) return "Finalizado " + Convert.ToDateTime(fechaFin).ToString("dd/MM/yyyy");
                return "Finalizado";
            }

            DateTime fecha = Convert.ToDateTime(fechaEstimada).Date;
            int dias = (fecha - DateTime.Today).Days;

            if (dias < 0) return "Vencido hace " + Math.Abs(dias) + (Math.Abs(dias) == 1 ? " día" : " días");
            if (dias == 0) return "Vence hoy";
            if (dias == 1) return "Vence mañana";

            return "Faltan " + dias + " días";
        }
        public string FormatearFechaFin(object fechaFin)
        {
            if (fechaFin == null || fechaFin == DBNull.Value) return "-";
            return Convert.ToDateTime(fechaFin).ToString("dd/MM/yyyy");
        }
        private void MostrarError(string mensaje)
        {
            litMensaje.Text = "<div class='alert alert-danger alert-dismissible fade show' role='alert'><strong>Error:</strong> " + mensaje + "<button type='button' class='btn-close' data-bs-dismiss='alert'></button></div>";
        }
    }
}