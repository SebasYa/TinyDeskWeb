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
    public partial class _Default : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try
                {
                    ProyectoNegocio proyectoNegocio = new ProyectoNegocio();
                    SprintNegocio sprintNegocio = new SprintNegocio();
                    TicketNegocio ticketNegocio = new TicketNegocio();
                    int idEmpresa = ((Usuario)Session["usuario"]).Empresa.Id;
                    lblProyectosActivos.Text = proyectoNegocio.ContarActivos(idEmpresa).ToString();
                    lblSprintsEnCurso.Text = sprintNegocio.ContarEnCurso(idEmpresa).ToString();
                    lblTicketsAbiertos.Text = ticketNegocio.ContarAbiertos(idEmpresa).ToString();

                    CargarCombosProyecto(idEmpresa);
                    CargarCombosSprint(idEmpresa);
                    CargarCombosTicket(idEmpresa);
                    lblTicketsAbiertos.Text = ticketNegocio.ContarAbiertos(idEmpresa).ToString();

                    int ticketsUsuariosDesactivados = ticketNegocio.ContarAsignadosUsuariosDesactivados(idEmpresa);
                    pnlTicketsUsuariosDesactivados.Visible = ticketsUsuariosDesactivados > 0;
                    pnlSinAlertas.Visible = ticketsUsuariosDesactivados == 0;

                    if (ticketsUsuariosDesactivados == 1) lblTicketsUsuariosDesactivados.Text = "Hay 1 ticket asignado a un usuario desactivado.";
                    else lblTicketsUsuariosDesactivados.Text = "Hay " + ticketsUsuariosDesactivados + " tickets asignados a usuarios desactivados.";

                }
                catch (Exception ex)
                {
                    Session.Add("error", ex.ToString());
                    litMensaje.Text = @"<div class='alert alert-danger alert-dismissible fade show' role='alert'>
                                            <strong>Hubo un error</strong> Ocurrio un error al cargar el Dashboard.
                                            <button type='button' class='btn-close' data-bs-dismiss='alert'></button>
                                        </div>";
                }
            }
        }
        protected void btnGuardarSprint_Click(object sender, EventArgs e)
        {

            try
            {
                SprintNegocio sprintNegocio = new SprintNegocio();
                Sprint nuevoSprint = new Sprint();
                Usuario userLogueado = (Usuario)Session["usuario"];

                int idProyectoSeleccionado = int.Parse(ddlProyecto.SelectedValue);
                nuevoSprint.NumeroSprint = sprintNegocio.ObtenerSiguienteNumeroSprint(idProyectoSeleccionado);
                nuevoSprint.FechaInicio = Convert.ToDateTime(txtFechaInicio.Text);
                nuevoSprint.FechaEstimadaFin = Convert.ToDateTime(txtFechaEstimadaFin.Text);
                nuevoSprint.Area = new Area();
                nuevoSprint.Area.Id = int.Parse(ddlArea.SelectedValue);
                nuevoSprint.Estado = new Estado();
                nuevoSprint.Estado.Id = int.Parse(ddlEstado.SelectedValue);
                nuevoSprint.Proyecto = new Proyecto();
                nuevoSprint.Proyecto.Id = int.Parse(ddlProyecto.SelectedValue);
                nuevoSprint.Activo = true;

                sprintNegocio.Agregar(nuevoSprint);
                int idEmpresa = userLogueado.Empresa.Id;
                lblSprintsEnCurso.Text = sprintNegocio.ContarEnCurso(idEmpresa).ToString();

                litMensaje.Text = @"<div class='alert alert-success alert-dismissible fade show' role='alert'>
                                        <strong>¡Éxito!</strong> El Sprint se guardó perfectamente.
                                        <button type='button' class='btn-close' data-bs-dismiss='alert' aria-label='Close'></button>
                                    </div>";


                txtFechaInicio.Text = "";
                txtFechaEstimadaFin.Text = "";
                ddlArea.SelectedIndex = 0;
                ddlEstado.SelectedIndex = 0;
                ddlProyecto.SelectedIndex = 0;



            }
            catch (Exception ex)
            {
                litMensaje.Text = $@"<div class='alert alert-danger alert-dismissible fade show' role='alert'>
                                         <strong>Hubo un error:</strong> {ex.Message}
                                         <button type='button' class='btn-close' data-bs-dismiss='alert' aria-label='Close'></button>
                                     </div>";
                Session.Add("error", ex.ToString());
                Response.Redirect("Default.aspx", false);
            }
        }
        protected void btnGuardarProyecto_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtNombreProyecto.Text) ||
                string.IsNullOrWhiteSpace(txtFechaEstimadaFinProyecto.Text) ||
                string.IsNullOrWhiteSpace(ddlEstadoProyecto.SelectedValue))
            {
                return;
            }
            try
            {
                ProyectoNegocio proyectoNegocio = new ProyectoNegocio();
                Proyecto nuevoProyecto = new Proyecto();
                Usuario userLogueado = (Usuario)Session["usuario"];

                nuevoProyecto.Nombre = txtNombreProyecto.Text;
                nuevoProyecto.Descripcion = txtDescripcionProyecto.Text;
                nuevoProyecto.FechaInicio = DateTime.Today;
                nuevoProyecto.FechaEstimadaFin = Convert.ToDateTime(txtFechaEstimadaFinProyecto.Text);
                nuevoProyecto.Activo = true;

                nuevoProyecto.Estado = new Estado();
                nuevoProyecto.Estado.Id = int.Parse(ddlEstadoProyecto.SelectedValue);

                nuevoProyecto.Empresa = new Empresa();
                nuevoProyecto.Empresa.Id = userLogueado.Empresa.Id;

                proyectoNegocio.agregarProyecto(nuevoProyecto);

                // Actualizamos el contador de proyectos activos en el Dashboard
                int idEmpresa = userLogueado.Empresa.Id;
                lblProyectosActivos.Text = proyectoNegocio.ContarActivos(idEmpresa).ToString();

                litMensaje.Text = @"<div class='alert alert-success alert-dismissible fade show' role='alert'>
                                        <strong>¡Éxito!</strong> El Proyecto se guardó perfectamente.
                                        <button type='button' class='btn-close' data-bs-dismiss='alert' aria-label='Close'></button>
                                    </div>";

                txtNombreProyecto.Text = "";
                txtDescripcionProyecto.Text = "";
                txtFechaInicioProyecto.Text = DateTime.Today.ToString("yyyy-MM-dd");
                txtFechaEstimadaFinProyecto.Text = "";
                ddlEstadoProyecto.SelectedIndex = 0;
            }
            catch (Exception ex)
            {
                litMensaje.Text = $@"<div class='alert alert-danger alert-dismissible fade show' role='alert'>
                                         <strong>Hubo un error:</strong> {ex.Message}
                                         <button type='button' class='btn-close' data-bs-dismiss='alert' aria-label='Close'></button>
                                     </div>";

                Session.Add("error", ex.ToString());
            }
        }
        protected void btnCancelarProyecto_Click(object sender, EventArgs e)
        {
            txtNombreProyecto.Text = "";
            txtDescripcionProyecto.Text = "";
            txtFechaInicioProyecto.Text = DateTime.Today.ToString("yyyy-MM-dd");
            txtFechaEstimadaFinProyecto.Text = "";
            ddlEstadoProyecto.SelectedIndex = 0;
        }
        protected void btnGuardarTicket_Click(object sender, EventArgs e)
        {
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

                Usuario userLogueado = (Usuario)Session["usuario"];
                lblTicketsAbiertos.Text = ticketNegocio.ContarAbiertos(userLogueado.Empresa.Id).ToString();

                //Limpiar Campos
                LimpiarCamposTicket();
            }
            catch (Exception ex)
            {

                litMensaje.Text = @"<div class='alert alert-danger alert-dismissible fade show' role='alert'>
                                        Ocurrió un error al guardar el ticket.
                                        <button type='button' class='btn-close' data-bs-dismiss='alert'></button>
                                    </div>";
                Session.Add("error", ex.ToString());
            }
        }
        protected void btnCerrarSprint_Click(object sender, EventArgs e)
        {
            txtFechaInicio.Text = "";
            txtFechaEstimadaFin.Text = "";
            ddlArea.SelectedIndex = 0;
            ddlEstado.SelectedIndex = 0;
            ddlProyecto.SelectedIndex = 0;
        }
        public void btnCancelarTicket_Click(object sender, EventArgs e)
        {
            LimpiarCamposTicket();
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

                List<Sprint> listaSprints = sprintNegocio.listarPorProyecto(int.Parse(ddlProyectoTicket.SelectedValue), userLogueado.Empresa.Id);

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
        private void CargarCombosSprint(int idEmpresa)
        {
            EstadoNegocio estadoNegocio = new EstadoNegocio();
            AreaNegocio areaNegocio = new AreaNegocio();
            ProyectoNegocio proyectoNegocio = new ProyectoNegocio();

            CargarLista(
                ddlEstado,
                estadoNegocio.listar(idEmpresa),
                "Id",
                "Nombre",
                "Seleccione Estado..."
            );

            CargarLista(
                ddlArea,
                areaNegocio.listar(idEmpresa),
                "Id",
                "Nombre",
                "Seleccione un área..."
            );

            CargarLista(
                ddlProyecto,
                proyectoNegocio.listar(idEmpresa),
                "Id",
                "Nombre",
                "Seleccione Proyecto..."
            );
        }
        private void CargarCombosProyecto(int idEmpresa)
        {
            EstadoNegocio estadoNegocio = new EstadoNegocio();

            CargarLista(
                ddlEstadoProyecto,
                estadoNegocio.listar(idEmpresa).FindAll(x => !x.EsFinal),
                "Id",
                "Nombre",
                "Seleccione Estado..."
            );
            txtFechaInicioProyecto.Text = DateTime.Today.ToString("yyyy-MM-dd");
            txtFechaInicioProyecto.Enabled = false;
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

            CargarLista(ddlProyectoTicket, proyectoNegocio.listar(idEmpresa), "Id", "Nombre", "Seleccione Proyecto...");
            CargarLista(ddlEstadoTicket, estadoNegocio.listar(idEmpresa), "Id", "Nombre", "Seleccione Estado...");
            CargarLista(ddlPrioridadTicket, prioridadNegocio.listar(), "Id", "Nombre", "Seleccione Prioridad...");
            CargarLista(ddlAreaTicket, areaNegocio.listar(idEmpresa), "Id", "Nombre", "Seleccione Área...");
            CargarLista(ddlPuestoTicket, puestoNegocio.listar(idEmpresa), "Id", "Nombre", "Seleccione Puesto...");
            CargarLista(ddlSeniorityTicket, seniorityNegocio.listar(), "Id", "Nombre", "Seleccione Seniority...");

            ddlSprintTicket.Items.Clear();
            ddlSprintTicket.Items.Insert(0, new ListItem("Seleccione Sprint...", ""));

            Session.Add("listaUsuariosTicket", usuarioNegocio.listar(idEmpresa));

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