using Antlr.Runtime.Misc;
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


        //CARGA DE DATOS


        private void CargarListado(int idEmpresa)
        {
            pnlListado.Visible = true;
            pnlDetalle.Visible = false;

            TicketNegocio negocio = new TicketNegocio();
            List<Ticket> lista = negocio.Listar(idEmpresa);

            Session["listaTickets"] = lista;
            Session["listaTicketsFiltrados"] = lista;

            dpTickets.SetPageProperties(
                0,
                dpTickets.PageSize,
                false
            );

            lvTickets.DataSource = lista;
            lvTickets.DataBind();

            dpTickets.Visible = lista.Count > dpTickets.PageSize;
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
            CargarCombosTicket(idEmpresa);
            // Prioridades
            PrioridadNegocio prioridadNegocio = new PrioridadNegocio();
            var prioridades = prioridadNegocio.listar();
            CargarLista(ddlEditPrioridad, prioridades, "Id", "Nombre", "Seleccione Prioridad...");

            // Estados
            EstadoNegocio estadoNegocio = new EstadoNegocio();
            var estados = estadoNegocio.listar(idEmpresa);
            Session["listaEstadosTicket"] = estados;
            CargarLista(ddlEditEstado, estados, "Id", "Nombre", "Seleccione Estado...");

            // Usuarios activos de la empresa
            UsuarioNegocio usuarioNegocio = new UsuarioNegocio();
            var usuarios = usuarioNegocio.listar(idEmpresa)
                .FindAll(u => u.Activo && u.EmailVerificado);

            ddlEditUsuario.DataSource = usuarios.Select(u => new
            {
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

        
        //CREAR TICKET
        

        protected void btnGuardarTicket_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtDescripcionTicket.Text) ||
                string.IsNullOrWhiteSpace(txtFechaEstimadaTicket.Text) ||
                string.IsNullOrWhiteSpace(ddlPrioridadTicket.SelectedValue) ||
                string.IsNullOrWhiteSpace(ddlProyectoTicket.SelectedValue) ||
                string.IsNullOrWhiteSpace(ddlSprintTicket.SelectedValue) ||
                string.IsNullOrWhiteSpace(ddlUsuarioTicket.SelectedValue) ||
                string.IsNullOrWhiteSpace(ddlEstadoTicket.SelectedValue))
            {
                MostrarError("Completá todos los campos obligatorios.");
                return;
            }
            int idEmpresa = ((Usuario)Session["usuario"]).Empresa.Id;

            try
            {
                // Creacion del ticket
                TicketNegocio ticketNegocio = new TicketNegocio();
                Ticket nuevoTicket = new Ticket();

                DateTime fechaInicio = DateTime.Today;
                DateTime fechaEstimadaFin = Convert.ToDateTime(txtFechaEstimadaTicket.Text);
                if (fechaEstimadaFin.Date < fechaInicio.Date)
                {
                    litMensaje.Text = @" <div class='alert alert-warning alert-dismissible fade show' role='alert'>
                                             La fecha estimada de fin no puede ser anterior a la fecha de inicio.
                                             <button type='button' class='btn-close' data-bs-dismiss='alert'></button>
                                         </div>";
                    return;
                }

                nuevoTicket.Descripcion = txtDescripcionTicket.Text;
                nuevoTicket.FechaInicio = fechaInicio;
                nuevoTicket.FechaEstimadaFin = fechaEstimadaFin;
                nuevoTicket.Activo = true;

                nuevoTicket.Prioridad = new Prioridad();
                nuevoTicket.Prioridad.Id = int.Parse(ddlPrioridadTicket.SelectedValue);
                nuevoTicket.Prioridad.Nombre = ddlPrioridadTicket.SelectedItem.Text;

                nuevoTicket.Usuario = new Usuario();
                nuevoTicket.Usuario.Id = int.Parse(ddlUsuarioTicket.SelectedValue);

                nuevoTicket.Estado = new Estado();
                nuevoTicket.Estado.Id = int.Parse(ddlEstadoTicket.SelectedValue);

                nuevoTicket.Sprint = new Sprint();
                nuevoTicket.Sprint.Id = int.Parse(ddlSprintTicket.SelectedValue);

                int idTicket = ticketNegocio.AgregarTicket(nuevoTicket);
                nuevoTicket.Id = idTicket;

                // Enviar mail al usuario asignado
                EmailService emailService = new EmailService();
                string linkTicket = LinkHelper.GenerarLink(this, "Tickets.aspx", "id", nuevoTicket.Id.ToString());

                bool mailEnviado = emailService.EnviarMailTicketAsignado(nuevoTicket.Usuario.Id, nuevoTicket, linkTicket);

                if (mailEnviado)
                {
                    litMensaje.Text = @"<div class='alert alert-success alert-dismissible fade show' role='alert'>
                                            El ticket fue creado y se notificó al usuario asignado.
                                            <button type='button' class='btn-close' data-bs-dismiss='alert'></button>
                                        </div>";
                }
                else
                {
                    litMensaje.Text = @"<div class='alert alert-warning alert-dismissible fade show' role='alert'>
                                            El ticket fue creado, pero no se pudo enviar el mail al usuario asignado.
                                            <button type='button' class='btn-close' data-bs-dismiss='alert'></button>
                                        </div>";
                }

                //Limpiar Campos y recargar grilla
                CargarListado(idEmpresa);
                CargarCombosTicket(idEmpresa);
                LimpiarCamposTicket();
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                MostrarError("Ocurrió un error al crear el ticket.");
            }
        }
        
        //MODIFICAR TICKET     
        protected void btnGuardarEdicion_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtEditDescripcion.Text) ||
                string.IsNullOrWhiteSpace(txtEditFechaEstimadaFin.Text) ||
                string.IsNullOrWhiteSpace(ddlEditPrioridad.SelectedValue) ||
                string.IsNullOrWhiteSpace(ddlEditEstado.SelectedValue) ||
                string.IsNullOrWhiteSpace(ddlEditUsuario.SelectedValue) ||
                string.IsNullOrWhiteSpace(ddlEditSprint.SelectedValue) ||
                string.IsNullOrWhiteSpace(txtMotivoCambio.Text))
            {
                MostrarError("Completá todos los campos obligatorios.");
                return;
            }

            try
            {
                AuditoriaService auditoriaService = new AuditoriaService();
                Ticket ticket = new Ticket();
                UsuarioNegocio usuarioNegocio = new UsuarioNegocio();
                Usuario userLogueado = (Usuario)Session["usuario"];
                SprintNegocio sprintNegocio = new SprintNegocio();


                ticket.Id = int.Parse(hdnIdTicket.Value);
                //ticket.Id = (int)Session["IdTicket"];

                List<Ticket> listaTickets = (List<Ticket>)Session["listaTickets"];
                Ticket original = listaTickets.Find(x => x.Id == ticket.Id);


                ticket.Descripcion = txtEditDescripcion.Text;
                ticket.FechaEstimadaFin = Convert.ToDateTime(txtEditFechaEstimadaFin.Text);

                ticket.Prioridad = new Prioridad();
                ticket.Prioridad.Id = int.Parse(ddlEditPrioridad.SelectedValue);
                ticket.Prioridad.Nombre = ddlEditPrioridad.SelectedItem.Text;

                // Si el estado es final, cerrar el ticket
                List<Estado> estados = (List<Estado>)Session["listaEstadosTicket"];
                Estado estadoSeleccionado = estados.Find(x => x.Id == int.Parse(ddlEditEstado.SelectedValue));
                ticket.Estado = estadoSeleccionado ?? new Estado { Id = int.Parse(ddlEditEstado.SelectedValue) };
                ticket.Estado.Nombre = ddlEditEstado.SelectedItem.Text;

                ticket.Usuario = new Usuario();
                ticket.Usuario.Id = int.Parse(ddlEditUsuario.SelectedValue);
                List<Usuario> listaUsuarios = (List<Usuario>)usuarioNegocio.listar(userLogueado.Empresa.Id);
                Usuario usuarioCompleto = listaUsuarios.FirstOrDefault(u => u.Id == ticket.Usuario.Id);
                ticket.Usuario = usuarioCompleto;

                ticket.Sprint = new Sprint();
                ticket.Sprint.Id = int.Parse(ddlEditSprint.SelectedValue);
                List<Sprint> listaSprints = (List<Sprint>)sprintNegocio.listar(userLogueado.Empresa.Id);
                Sprint sprintCompleto = listaSprints.FirstOrDefault(s => s.Id == ticket.Sprint.Id);
                ticket.Sprint = sprintCompleto;



                string motivo = txtMotivoCambio.Text;
                string accion = "UPDATE";

                TicketNegocio negocio = new TicketNegocio();
                negocio.ModificarTicketConAuditoria(ticket, original, accion, userLogueado.Id, motivo);
                //negocio.Modificar(ticket);

                MostrarExito("Ticket modificado correctamente.");
                CargarDetalleTicket(ticket.Id, ((Usuario)Session["usuario"]).Empresa.Id);
                
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                MostrarError("Ocurrió un error al modificar el ticket.");
            }
        }
        protected void btnCancelarTicket_Click(object sender, EventArgs e)
        {
            int idEmpresa = ((Usuario)Session["usuario"]).Empresa.Id;
            CargarCombosTicket(idEmpresa);
            LimpiarCamposTicket();
        }

        //BAJA LÓGICA
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


        // GRILLA 
        protected void lvTickets_PagePropertiesChanging(object sender, PagePropertiesChangingEventArgs e)
        {
            dpTickets.SetPageProperties(e.StartRowIndex, e.MaximumRows, false);
            List<Ticket> lista = Session["listaTicketsFiltrados"] as List<Ticket> ?? Session["listaTickets"] as List<Ticket> ?? new List<Ticket>();
            lvTickets.DataSource = lista;
            lvTickets.DataBind();
            dpTickets.Visible = lista.Count > dpTickets.PageSize;
        }

        
        // HELPERS
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

        protected void lvTickets_ItemCommand(object sender, ListViewCommandEventArgs e)
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
                ddlEditUsuario.DataSource = usuarios.Select(u => new
                {
                    Id = u.Id,
                    NombreCompleto = u.Nombre + " " + u.Apellido
                }).ToList();
                ddlEditUsuario.DataValueField = "Id";
                ddlEditUsuario.DataTextField = "NombreCompleto";
                ddlEditUsuario.DataBind();
                ddlEditUsuario.Items.Insert(0, new ListItem("Seleccione Usuario...", ""));

                SprintNegocio sprintNegocio = new SprintNegocio();
                var sprints = sprintNegocio.listar(idEmpresa);
                ddlEditSprint.DataSource = sprints.Select(s => new
                {
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
        protected void txtFiltroTickets_TextChanged(object sender, EventArgs e)
        {
            string filtro = txtFiltroTickets.Text.Trim();
            List<Ticket> lista = Session["listaTickets"] as List<Ticket>;

            if (lista == null)
            {
                int idEmpresa = ((Usuario)Session["usuario"]).Empresa.Id;
                CargarListado(idEmpresa);
                return;
            }

            List<Ticket> filtrada;

            if (string.IsNullOrWhiteSpace(filtro))
            {
                filtrada = lista;
            }
            else
            {
                filtrada = lista.Where(t =>
                    (!string.IsNullOrWhiteSpace(t.Descripcion) && t.Descripcion.IndexOf(filtro, StringComparison.OrdinalIgnoreCase) >= 0) ||
                    (t.Sprint?.Proyecto != null && !string.IsNullOrWhiteSpace(t.Sprint.Proyecto.Nombre) && t.Sprint.Proyecto.Nombre.IndexOf(filtro, StringComparison.OrdinalIgnoreCase) >= 0) ||
                    (t.Usuario != null && !string.IsNullOrWhiteSpace(t.Usuario.Nombre) && t.Usuario.Nombre.IndexOf(filtro, StringComparison.OrdinalIgnoreCase) >= 0) ||
                    (t.Usuario != null && !string.IsNullOrWhiteSpace(t.Usuario.Apellido) && t.Usuario.Apellido.IndexOf(filtro, StringComparison.OrdinalIgnoreCase) >= 0) ||
                    (t.Estado != null && !string.IsNullOrWhiteSpace(t.Estado.Nombre) && t.Estado.Nombre.IndexOf(filtro, StringComparison.OrdinalIgnoreCase) >= 0) ||
                    (t.Prioridad != null && !string.IsNullOrWhiteSpace(t.Prioridad.Nombre) && t.Prioridad.Nombre.IndexOf(filtro, StringComparison.OrdinalIgnoreCase) >= 0)
                ).ToList();
            }

            Session["listaTicketsFiltrados"] = filtrada;

            dpTickets.SetPageProperties(0, dpTickets.PageSize, false);
            lvTickets.DataSource = filtrada;
            lvTickets.DataBind();
            dpTickets.Visible = filtrada.Count > dpTickets.PageSize;
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
        private void CargarLista<T>(DropDownList ddl, List<T> lista, string valueField, string textField, string textoInicial)
        {
            ddl.DataSource = lista;
            ddl.DataValueField = valueField;
            ddl.DataTextField = textField;
            ddl.DataBind();
            ddl.Items.Insert(0, new ListItem(textoInicial, ""));
        }
        protected void ddlProyectoTicket_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                ddlSprintTicket.Items.Clear();

                if (string.IsNullOrWhiteSpace(ddlProyectoTicket.SelectedValue))
                {
                    ddlSprintTicket.Items.Insert(0, new ListItem("Seleccione Sprint...", ""));
                    return;
                }

                Usuario userLogueado = (Usuario)Session["usuario"];
                SprintNegocio sprintNegocio = new SprintNegocio();

                List<Sprint> listaSprints = sprintNegocio.listarPorProyecto(int.Parse(ddlProyectoTicket.SelectedValue), userLogueado.Empresa.Id).FindAll(x => x.Activo);

                ddlSprintTicket.DataSource = listaSprints.Select(x => new
                {
                    Id = x.Id,
                    Nombre = "Sprint " + x.NumeroSprint + " (" +
                             x.FechaInicio.ToString("dd/MM/yyyy") + " al " +
                             x.FechaEstimadaFin.ToString("dd/MM/yyyy") + ")"
                }).ToList();

                ddlSprintTicket.DataValueField = "Id";
                ddlSprintTicket.DataTextField = "Nombre";
                ddlSprintTicket.DataBind();
                ddlSprintTicket.Items.Insert(0, new ListItem("Seleccione Sprint...", ""));
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
            }
        }
        protected void ddlUsuarioTicket_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                if (string.IsNullOrWhiteSpace(ddlUsuarioTicket.SelectedValue))
                    return;

                List<Usuario> listaUsuarios = (List<Usuario>)Session["listaUsuariosTicket"];
                Usuario usuario = listaUsuarios.Find(x => x.Id == int.Parse(ddlUsuarioTicket.SelectedValue));

                if (usuario == null)
                    return;

                if (ddlAreaTicket.Items.FindByValue(usuario.Area.Id.ToString()) != null)
                    ddlAreaTicket.SelectedValue = usuario.Area.Id.ToString();

                if (ddlPuestoTicket.Items.FindByValue(usuario.Puesto.Id.ToString()) != null)
                    ddlPuestoTicket.SelectedValue = usuario.Puesto.Id.ToString();

                if (usuario.Seniority != null && ddlSeniorityTicket.Items.FindByValue(usuario.Seniority.Id.ToString()) != null)
                    ddlSeniorityTicket.SelectedValue = usuario.Seniority.Id.ToString();
                else
                    ddlSeniorityTicket.SelectedIndex = 0;
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
            }
        }
        protected void ddlFiltroUsuarioTicket_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                string idAreaSeleccionada = ddlAreaTicket.SelectedValue;
                string idPuestoSeleccionado = ddlPuestoTicket.SelectedValue;
                string idSenioritySeleccionado = ddlSeniorityTicket.SelectedValue;
                string idUsuarioSeleccionado = ddlUsuarioTicket.SelectedValue;

                List<Usuario> listaUsuarios = (List<Usuario>)Session["listaUsuariosTicket"];
                listaUsuarios = listaUsuarios.FindAll(x => x.Activo && x.EmailVerificado);

                List<Usuario> usuariosFiltrados = listaUsuarios;
                if (!string.IsNullOrWhiteSpace(idAreaSeleccionada))
                    usuariosFiltrados = usuariosFiltrados.FindAll(x => x.Area.Id == int.Parse(idAreaSeleccionada));
                if (!string.IsNullOrWhiteSpace(idPuestoSeleccionado))
                    usuariosFiltrados = usuariosFiltrados.FindAll(x => x.Puesto.Id == int.Parse(idPuestoSeleccionado));
                if (!string.IsNullOrWhiteSpace(idSenioritySeleccionado))
                    usuariosFiltrados = usuariosFiltrados.FindAll(x => x.Seniority != null && x.Seniority.Id == int.Parse(idSenioritySeleccionado));

                List<Usuario> usuariosParaAreas = listaUsuarios;
                if (!string.IsNullOrWhiteSpace(idPuestoSeleccionado))
                    usuariosParaAreas = usuariosParaAreas.FindAll(x => x.Puesto.Id == int.Parse(idPuestoSeleccionado));
                if (!string.IsNullOrWhiteSpace(idSenioritySeleccionado))
                    usuariosParaAreas = usuariosParaAreas.FindAll(x => x.Seniority != null && x.Seniority.Id == int.Parse(idSenioritySeleccionado));

                List<Usuario> usuariosParaPuestos = listaUsuarios;
                if (!string.IsNullOrWhiteSpace(idAreaSeleccionada))
                    usuariosParaPuestos = usuariosParaPuestos.FindAll(x => x.Area.Id == int.Parse(idAreaSeleccionada));
                if (!string.IsNullOrWhiteSpace(idSenioritySeleccionado))
                    usuariosParaPuestos = usuariosParaPuestos.FindAll(x => x.Seniority != null && x.Seniority.Id == int.Parse(idSenioritySeleccionado));

                List<Usuario> usuariosParaSeniorities = listaUsuarios;
                if (!string.IsNullOrWhiteSpace(idAreaSeleccionada))
                    usuariosParaSeniorities = usuariosParaSeniorities.FindAll(x => x.Area.Id == int.Parse(idAreaSeleccionada));
                if (!string.IsNullOrWhiteSpace(idPuestoSeleccionado))
                    usuariosParaSeniorities = usuariosParaSeniorities.FindAll(x => x.Puesto.Id == int.Parse(idPuestoSeleccionado));

                List<Area> areasDisponibles = usuariosParaAreas
                    .Where(x => x.Area != null)
                    .Select(x => x.Area)
                    .GroupBy(x => x.Id)
                    .Select(x => x.First())
                    .ToList();

                List<Puesto> puestosDisponibles = usuariosParaPuestos
                    .Where(x => x.Puesto != null)
                    .Select(x => x.Puesto)
                    .GroupBy(x => x.Id)
                    .Select(x => x.First())
                    .ToList();

                List<Seniority> senioritiesDisponibles = usuariosParaSeniorities
                    .Where(x => x.Seniority != null)
                    .Select(x => x.Seniority)
                    .GroupBy(x => x.Id)
                    .Select(x => x.First())
                    .ToList();

                CargarLista(ddlAreaTicket, areasDisponibles, "Id", "Nombre", "Seleccione Área...");
                CargarLista(ddlPuestoTicket, puestosDisponibles, "Id", "Nombre", "Seleccione Puesto...");
                CargarLista(ddlSeniorityTicket, senioritiesDisponibles, "Id", "Nombre", "Seleccione Seniority...");

                ddlUsuarioTicket.DataSource = usuariosFiltrados.Select(x => new
                {
                    Id = x.Id,
                    Nombre = x.Nombre + " " + x.Apellido + " (" + x.NombreUsuario + ")"
                }).ToList();

                ddlUsuarioTicket.DataValueField = "Id";
                ddlUsuarioTicket.DataTextField = "Nombre";
                ddlUsuarioTicket.DataBind();
                ddlUsuarioTicket.Items.Insert(0, new ListItem("Seleccione Usuario...", ""));

                if (!string.IsNullOrWhiteSpace(idAreaSeleccionada) && ddlAreaTicket.Items.FindByValue(idAreaSeleccionada) != null)
                    ddlAreaTicket.SelectedValue = idAreaSeleccionada;

                if (!string.IsNullOrWhiteSpace(idPuestoSeleccionado) && ddlPuestoTicket.Items.FindByValue(idPuestoSeleccionado) != null)
                    ddlPuestoTicket.SelectedValue = idPuestoSeleccionado;

                if (!string.IsNullOrWhiteSpace(idSenioritySeleccionado) && ddlSeniorityTicket.Items.FindByValue(idSenioritySeleccionado) != null)
                    ddlSeniorityTicket.SelectedValue = idSenioritySeleccionado;

                if (!string.IsNullOrWhiteSpace(idUsuarioSeleccionado) && ddlUsuarioTicket.Items.FindByValue(idUsuarioSeleccionado) != null)
                    ddlUsuarioTicket.SelectedValue = idUsuarioSeleccionado;
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
            }
        }
        private void LimpiarCamposTicket()
        {
            txtDescripcionTicket.Text = "";
            txtFechaInicioTicket.Text = DateTime.Today.ToString("yyyy-MM-dd");
            txtFechaInicioTicket.Enabled = false;
            txtFechaEstimadaTicket.Text = "";

            ddlProyectoTicket.SelectedIndex = 0;

            ddlSprintTicket.Items.Clear();
            ddlSprintTicket.Items.Insert(0, new ListItem("Seleccione Sprint...", ""));

            ddlEstadoTicket.SelectedIndex = 0;
            ddlPrioridadTicket.SelectedIndex = 0;
            ddlAreaTicket.SelectedIndex = 0;
            ddlPuestoTicket.SelectedIndex = 0;
            ddlSeniorityTicket.SelectedIndex = 0;
            ddlUsuarioTicket.SelectedIndex = 0;
        }
        private void CargarCombosTicket(int idEmpresa)
        {
            ProyectoNegocio proyectoNegocio = new ProyectoNegocio();
            EstadoNegocio estadoNegocio = new EstadoNegocio();
            PrioridadNegocio prioridadNegocio = new PrioridadNegocio();
            AreaNegocio areaNegocio = new AreaNegocio();
            PuestoNegocio puestoNegocio = new PuestoNegocio();
            SeniorityNegocio seniorityNegocio = new SeniorityNegocio();
            UsuarioNegocio usuarioNegocio = new UsuarioNegocio();

            txtFechaInicioTicket.Text = DateTime.Today.ToString("yyyy-MM-dd");
            txtFechaInicioTicket.Enabled = false;

            CargarLista(ddlProyectoTicket, proyectoNegocio.listar(idEmpresa).FindAll(x => x.Activo), "Id", "Nombre", "Seleccione Proyecto...");
            CargarLista(ddlEstadoTicket, estadoNegocio.listar(idEmpresa).FindAll(x => !x.EsFinal), "Id", "Nombre", "Seleccione Estado...");
            CargarLista(ddlPrioridadTicket, prioridadNegocio.listar(), "Id", "Nombre", "Seleccione Prioridad...");
            CargarLista(ddlAreaTicket, areaNegocio.listar(idEmpresa), "Id", "Nombre", "Seleccione Área...");
            CargarLista(ddlPuestoTicket, puestoNegocio.listar(idEmpresa), "Id", "Nombre", "Seleccione Puesto...");
            CargarLista(ddlSeniorityTicket, seniorityNegocio.listar(), "Id", "Nombre", "Seleccione Seniority...");

            ddlSprintTicket.Items.Clear();
            ddlSprintTicket.Items.Insert(0, new ListItem("Seleccione Sprint...", ""));

            Session["listaUsuariosTicket"] = usuarioNegocio.listar(idEmpresa);

            List<Usuario> listaUsuarios = ((List<Usuario>)Session["listaUsuariosTicket"]).FindAll(x => x.Activo && x.EmailVerificado);
            ddlUsuarioTicket.DataSource = listaUsuarios.Select(x => new
            {
                Id = x.Id,
                Nombre = x.Nombre + " " + x.Apellido + " (" + x.NombreUsuario + ")"
            }).ToList();

            ddlUsuarioTicket.DataValueField = "Id";
            ddlUsuarioTicket.DataTextField = "Nombre";
            ddlUsuarioTicket.DataBind();
            ddlUsuarioTicket.Items.Insert(0, new ListItem("Seleccione Usuario...", ""));
        }
    }
}