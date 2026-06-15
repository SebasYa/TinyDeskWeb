using dominio;
using negocio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;

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
                    CargarDropdowns(idEmpresa);

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

        // -------------------------------------------------------
        // CARGA DE DATOS
        // -------------------------------------------------------

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

            // Mostrar datos en pantalla
            lblDetalleDescripcion.Text = ticket.Descripcion;
            lblDetalleEstado.Text = ticket.Estado.Nombre;
            lblDetalleEstado.CssClass = GetClassEtiquetaEstado(ticket.Estado.Nombre) + " text-uppercase";

            lblDetallePrioridad.Text = ticket.Prioridad.Nombre;
            lblDetallePrioridad.CssClass = GetClassEtiquetaPrioridad(ticket.Prioridad.Nombre) + " text-uppercase";
            lblDetalleUsuario.Text = ticket.Usuario.Nombre + " " + ticket.Usuario.Apellido;
            lblDetalleSprint.Text = "Sprint " + ticket.Sprint.NumeroSprint;
            lblDetalleProyecto.Text = ticket.Sprint.Proyecto.Nombre;
            lblDetalleFechaInicio.Text = ticket.FechaInicio.ToString("dd/MM/yyyy");
            lblDetalleFechaEstimadaFin.Text = ticket.FechaEstimadaFin.ToString("dd/MM/yyyy");
            lblDetalleFechaFin.Text = ticket.FechaFin.HasValue
                ? ticket.FechaFin.Value.ToString("dd/MM/yyyy") : "-";

            // Precargar formulario de edición
            txtEditDescripcion.Text = ticket.Descripcion;
            txtEditFechaEstimadaFin.Text = ticket.FechaEstimadaFin.ToString("yyyy-MM-dd");
            ddlEditPrioridad.SelectedValue = ticket.Prioridad.Id.ToString();
            ddlEditEstado.SelectedValue = ticket.Estado.Id.ToString();
            ddlEditUsuario.SelectedValue = ticket.Usuario.Id.ToString();
            ddlEditSprint.SelectedValue = ticket.Sprint.Id.ToString();

            hdnIdTicket.Value = ticket.Id.ToString();
        }

        private void CargarDropdowns(int idEmpresa)
        {
            // Prioridades
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

            // Estados
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

            // Usuarios activos de la empresa
            UsuarioNegocio usuarioNegocio = new UsuarioNegocio();
            var usuarios = usuarioNegocio.listar(idEmpresa)
                .FindAll(u => u.Activo && u.EmailVerificado);

            ddlUsuario.DataSource = usuarios.Select(u => new {
                Id = u.Id,
                NombreCompleto = u.Nombre + " " + u.Apellido
            }).ToList();
            ddlUsuario.DataValueField = "Id";
            ddlUsuario.DataTextField = "NombreCompleto";
            ddlUsuario.DataBind();
            ddlUsuario.Items.Insert(0, new ListItem("Seleccione usuario...", ""));

            ddlEditUsuario.DataSource = usuarios.Select(u => new {
                Id = u.Id,
                NombreCompleto = u.Nombre + " " + u.Apellido
            }).ToList();
            ddlEditUsuario.DataValueField = "Id";
            ddlEditUsuario.DataTextField = "NombreCompleto";
            ddlEditUsuario.DataBind();
            ddlEditUsuario.Items.Insert(0, new ListItem("Seleccione usuario...", ""));

            // Sprints activos de la empresa
            SprintNegocio sprintNegocio = new SprintNegocio();
            var sprints = sprintNegocio.listar(idEmpresa);

            ddlSprint.DataSource = sprints.Select(s => new {
                Id = s.Id,
                Nombre = "Sprint " + s.NumeroSprint + " - " + s.Proyecto.Nombre
            }).ToList();
            ddlSprint.DataValueField = "Id";
            ddlSprint.DataTextField = "Nombre";
            ddlSprint.DataBind();
            ddlSprint.Items.Insert(0, new ListItem("Seleccione sprint...", ""));

            ddlEditSprint.DataSource = sprints.Select(s => new {
                Id = s.Id,
                Nombre = "Sprint " + s.NumeroSprint + " - " + s.Proyecto.Nombre
            }).ToList();
            ddlEditSprint.DataValueField = "Id";
            ddlEditSprint.DataTextField = "Nombre";
            ddlEditSprint.DataBind();
            ddlEditSprint.Items.Insert(0, new ListItem("Seleccione sprint...", ""));
        }

        // -------------------------------------------------------
        // CREAR TICKET
        // -------------------------------------------------------

        protected void btnGuardarTicket_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtDescripcion.Text) ||
                string.IsNullOrWhiteSpace(txtFechaEstimadaFin.Text) ||
                string.IsNullOrWhiteSpace(ddlPrioridad.SelectedValue) ||
                string.IsNullOrWhiteSpace(ddlEstado.SelectedValue) ||
                string.IsNullOrWhiteSpace(ddlUsuario.SelectedValue) ||
                string.IsNullOrWhiteSpace(ddlSprint.SelectedValue))
            {
                MostrarError("Completá todos los campos obligatorios.");
                return;
            }

            try
            {
                Ticket ticket = new Ticket();
                ticket.Descripcion = txtDescripcion.Text;
                ticket.FechaInicio = DateTime.Today;
                ticket.FechaEstimadaFin = Convert.ToDateTime(txtFechaEstimadaFin.Text);
                ticket.Activo = true;

                ticket.Prioridad = new Prioridad();
                ticket.Prioridad.Id = int.Parse(ddlPrioridad.SelectedValue);

                ticket.Estado = new Estado();
                ticket.Estado.Id = int.Parse(ddlEstado.SelectedValue);

                ticket.Usuario = new Usuario();
                ticket.Usuario.Id = int.Parse(ddlUsuario.SelectedValue);

                ticket.Sprint = new Sprint();
                ticket.Sprint.Id = int.Parse(ddlSprint.SelectedValue);

                TicketNegocio negocio = new TicketNegocio();
                negocio.AgregarTicket(ticket);

                int idEmpresa = ((Usuario)Session["usuario"]).Empresa.Id;
                MostrarExito("Ticket creado correctamente.");
                CargarListado(idEmpresa);
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                MostrarError("Ocurrió un error al crear el ticket.");
            }
        }

        // -------------------------------------------------------
        // MODIFICAR TICKET
        // -------------------------------------------------------

        protected void btnGuardarEdicion_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtEditDescripcion.Text) ||
                string.IsNullOrWhiteSpace(txtEditFechaEstimadaFin.Text) ||
                string.IsNullOrWhiteSpace(ddlEditPrioridad.SelectedValue) ||
                string.IsNullOrWhiteSpace(ddlEditEstado.SelectedValue) ||
                string.IsNullOrWhiteSpace(ddlEditUsuario.SelectedValue) ||
                string.IsNullOrWhiteSpace(ddlEditSprint.SelectedValue))
            {
                MostrarError("Completá todos los campos obligatorios.");
                return;
            }

            try
            {
                Ticket ticket = new Ticket();
                ticket.Id = int.Parse(hdnIdTicket.Value);
                ticket.Descripcion = txtEditDescripcion.Text;
                ticket.FechaEstimadaFin = Convert.ToDateTime(txtEditFechaEstimadaFin.Text);

                ticket.Prioridad = new Prioridad();
                ticket.Prioridad.Id = int.Parse(ddlEditPrioridad.SelectedValue);

                // Si el estado es final, cerrar el ticket
                List<Estado> estados = (List<Estado>)Session["listaEstadosTicket"];
                Estado estadoSeleccionado = estados.Find(x => x.Id == int.Parse(ddlEditEstado.SelectedValue));
                ticket.Estado = estadoSeleccionado ?? new Estado { Id = int.Parse(ddlEditEstado.SelectedValue) };

                ticket.Usuario = new Usuario();
                ticket.Usuario.Id = int.Parse(ddlEditUsuario.SelectedValue);

                ticket.Sprint = new Sprint();
                ticket.Sprint.Id = int.Parse(ddlEditSprint.SelectedValue);

                TicketNegocio negocio = new TicketNegocio();
                negocio.Modificar(ticket);

                MostrarExito("Ticket modificado correctamente.");
                CargarDetalleTicket(ticket.Id, ((Usuario)Session["usuario"]).Empresa.Id);
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                MostrarError("Ocurrió un error al modificar el ticket.");
            }
        }

        // -------------------------------------------------------
        // BAJA LÓGICA
        // -------------------------------------------------------

        protected void btnBajaLogica_Click(object sender, EventArgs e)
        {
            try
            {
                int idTicket = int.Parse(hdnIdTicket.Value);
                TicketNegocio negocio = new TicketNegocio();
                negocio.BajaLogica(idTicket);

                int idEmpresa = ((Usuario)Session["usuario"]).Empresa.Id;
                MostrarExito("Ticket desactivado correctamente.");
                CargarListado(idEmpresa);
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                MostrarError("Ocurrió un error al desactivar el ticket.");
            }
        }

        // -------------------------------------------------------
        // GRILLA — paginación y selección
        // -------------------------------------------------------

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

        // -------------------------------------------------------
        // HELPERS
        // -------------------------------------------------------

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

        protected void dgvTickets_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "VerDetalle")
            {
                int idTicket = int.Parse(e.CommandArgument.ToString());
                Response.Redirect("Tickets.aspx?id=" + idTicket, false);
            }

            if (e.CommandName == "AbrirEditar")
            {
                int idTicket = int.Parse(e.CommandArgument.ToString());
                int idEmpresa = ((Usuario)Session["usuario"]).Empresa.Id;

                TicketNegocio negocio = new TicketNegocio();
                Ticket ticket = negocio.BuscarPorId(idTicket);

                if (ticket == null) return;

                // Recargar los dropdowns de edición
                PrioridadNegocio prioridadNegocio = new PrioridadNegocio();
                var prioridades = prioridadNegocio.listar();
                ddlEditPrioridad.DataSource = prioridades;
                ddlEditPrioridad.DataValueField = "Id";
                ddlEditPrioridad.DataTextField = "Nombre";
                ddlEditPrioridad.DataBind();
                ddlEditPrioridad.Items.Insert(0, new ListItem("Seleccione Prioridad...", ""));

                EstadoNegocio estadoNegocio = new EstadoNegocio();
                var estados = estadoNegocio.listar(idEmpresa);
                Session["listaEstadosTicket"] = estados;
                ddlEditEstado.DataSource = estados;
                ddlEditEstado.DataValueField = "Id";
                ddlEditEstado.DataTextField = "Nombre";
                ddlEditEstado.DataBind();
                ddlEditEstado.Items.Insert(0, new ListItem("Seleccione Estado...", ""));

                UsuarioNegocio usuarioNegocio = new UsuarioNegocio();
                var usuarios = usuarioNegocio.listar(idEmpresa)
                    .FindAll(u => u.Activo && u.EmailVerificado);
                ddlEditUsuario.DataSource = usuarios.Select(u => new {
                    Id = u.Id,
                    NombreCompleto = u.Nombre + " " + u.Apellido
                }).ToList();
                ddlEditUsuario.DataValueField = "Id";
                ddlEditUsuario.DataTextField = "NombreCompleto";
                ddlEditUsuario.DataBind();
                ddlEditUsuario.Items.Insert(0, new ListItem("Seleccione Usuario...", ""));

                SprintNegocio sprintNegocio = new SprintNegocio();
                var sprints = sprintNegocio.listar(idEmpresa);
                ddlEditSprint.DataSource = sprints.Select(s => new {
                    Id = s.Id,
                    Nombre = "Sprint " + s.NumeroSprint + " - " + s.Proyecto.Nombre
                }).ToList();
                ddlEditSprint.DataValueField = "Id";
                ddlEditSprint.DataTextField = "Nombre";
                ddlEditSprint.DataBind();
                ddlEditSprint.Items.Insert(0, new ListItem("Seleccione Sprint...", ""));

                // Precargar los datos del ticket
                hdnIdTicket.Value = ticket.Id.ToString();
                lblModalEditarTitulo.Text = "Editar Ticket #" + ticket.Id;
                txtEditDescripcion.Text = ticket.Descripcion;
                txtEditFechaEstimadaFin.Text = ticket.FechaEstimadaFin.ToString("yyyy-MM-dd");
                ddlEditPrioridad.SelectedValue = ticket.Prioridad.Id.ToString();
                ddlEditEstado.SelectedValue = ticket.Estado.Id.ToString();
                ddlEditUsuario.SelectedValue = ticket.Usuario.Id.ToString();
                ddlEditSprint.SelectedValue = ticket.Sprint.Id.ToString();

                // Abrir el modal
                //ScriptManager.RegisterStartupScript(this, this.GetType(), "AbrirModalEditar",
                //    "var modal = new bootstrap.Modal(document.getElementById('ticketEditarModal')); modal.show();",
                //    true);
                string script = @"
                    setTimeout(function() {
                        var el = document.getElementById('ticketEditarModal');
                        if (el) {
                            var modal = new bootstrap.Modal(el);
                            modal.show();
                        }
                    }, 200);";

                ScriptManager.RegisterStartupScript(this, this.GetType(), "AbrirModalEditar", script, true);
            }
        }
        public string GetClassEtiquetaEstado(object estadoNombre)
        {
            if (estadoNombre == null) return "badge text-bg-secondary px-3 py-2";
            string estado = estadoNombre.ToString().ToLower();
            if (estado == "en progreso") return "badge text-bg-primary px-3 py-2";
            if (estado == "finalizado") return "badge text-bg-success px-3 py-2";
            if (estado == "pendiente") return "badge text-bg-warning px-3 py-2";
            return "badge text-bg-dark px-3 py-2";
        }
        public string GetClassEtiquetaPrioridad(object prioridadNombre)
        {
            if (prioridadNombre == null) return "badge text-bg-secondary px-3 py-2";
            string prioridad = prioridadNombre.ToString().ToLower();
            if (prioridad == "alta") return "badge text-bg-danger px-3 py-2";
            if (prioridad == "media") return "badge text-bg-warning px-3 py-2";
            if (prioridad == "baja") return "badge text-bg-success px-3 py-2";
            return "badge text-bg-secondary px-3 py-2";
        }
    }
}