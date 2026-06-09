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
    public partial class CrearUsuario : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Seguridad.EsAdmin(Session["usuario"]))
            {
                Response.Redirect("Default.aspx");
                return;
            }
            if (!IsPostBack)
            {
                try
                {
                    txtNombreUsuario.Text = "";
                    txtNombre.Text = "";
                    txtApellido.Text = "";
                    chkPermisoEscritura.Checked = false;
                    chkEsAdmin.Checked = false;
                    litMensajeFormulario.Text = "";
                    int idEmpresa = ((Usuario)Session["usuario"]).Empresa.Id;

                    AreaNegocio areaNegocio = new AreaNegocio();
                    PuestoNegocio puestoNegocio = new PuestoNegocio();
                    SeniorityNegocio seniorityNegocio = new SeniorityNegocio();

                    ddlArea.DataSource = areaNegocio.listar(idEmpresa);
                    ddlArea.DataValueField = "Id";
                    ddlArea.DataTextField = "Nombre";
                    ddlArea.DataBind();
                    ddlArea.Items.Insert(0, new ListItem("Seleccione un área", ""));

                    ddlPuesto.DataSource = puestoNegocio.listar(idEmpresa);
                    ddlPuesto.DataValueField = "Id";
                    ddlPuesto.DataTextField = "Nombre";
                    ddlPuesto.DataBind();
                    ddlPuesto.Items.Insert(0, new ListItem("Seleccione un puesto", ""));

                    ddlSeniority.DataSource = seniorityNegocio.listar();
                    ddlSeniority.DataValueField = "Id";
                    ddlSeniority.DataTextField = "Nombre";
                    ddlSeniority.DataBind();
                    ddlSeniority.Items.Insert(0, new ListItem("Seleccione un seniority", ""));

                    if (Request.QueryString["id"] != null)
                    {
                        lblTituloFormularioUsuario.Text = "Modificar Usuario";
                        txtSubtitulo.Visible = false;
                        btnCrearUsuario.Text = "Guardar Cambios";

                        int idUsuario = int.Parse(Request.QueryString["id"]);
                        UsuarioNegocio negocio = new UsuarioNegocio();
                        Usuario usuarioEditar = negocio.BuscarPorId(idUsuario);
                        if (usuarioEditar != null)
                        {
                            txtNombreUsuario.Text = usuarioEditar.NombreUsuario;
                            txtEmail.Text = usuarioEditar.Email;
                            txtNombre.Text = usuarioEditar.Nombre;
                            txtApellido.Text = usuarioEditar.Apellido;

                            ddlArea.SelectedValue = usuarioEditar.Area.Id.ToString();
                            ddlPuesto.SelectedValue = usuarioEditar.Puesto.Id.ToString();

                            chkPermisoEscritura.Checked = usuarioEditar.PermisoEscritura;
                            chkEsAdmin.Checked = usuarioEditar.EsAdmin;

                            if (usuarioEditar.Seniority != null)
                            {
                                ddlSeniority.SelectedValue = usuarioEditar.Seniority.Id.ToString();
                            }
                            if (usuarioEditar.EmailVerificado)
                            {
                                pnlActivoUsuario.Visible = true;
                                chkActivo.Checked = usuarioEditar.Activo;
                            }
                            else
                            {
                                pnlActivoUsuario.Visible = false;
                            }
                            CargarEstadoInvitacion(usuarioEditar);
                        }
                    }
                }
                catch (Exception ex)
                {
                    Session.Add("error", ex.ToString());
                    MostrarErrorFormulario("Ocurrio un error al cargar el formulario.");
                    //Response.Redirect("Default.aspx", false);
                }
            }
        }
        protected void btnCrearUsuario_Click(object sender, EventArgs e)
        {
            LimpiarErroresFormulario();

            bool esEdicion = Request.QueryString["id"] != null;
            if (string.IsNullOrWhiteSpace(txtNombreUsuario.Text) || string.IsNullOrWhiteSpace(txtNombre.Text) ||
            string.IsNullOrWhiteSpace(txtApellido.Text) || string.IsNullOrWhiteSpace(ddlArea.SelectedValue) ||
            string.IsNullOrWhiteSpace(ddlPuesto.SelectedValue) || string.IsNullOrWhiteSpace(txtEmail.Text)
           )
            {
                MostrarErrorFormulario("Completá todos los campos obligatorios.");
                return;
            }

            try
            {
                UsuarioNegocio negocio = new UsuarioNegocio();
                Usuario nuevoUsuario = new Usuario();
                Usuario userLogueado = (Usuario)Session["usuario"];

                nuevoUsuario.NombreUsuario = txtNombreUsuario.Text;

                nuevoUsuario.Email = txtEmail.Text;
                nuevoUsuario.Nombre = txtNombre.Text;
                nuevoUsuario.Apellido = txtApellido.Text;
                nuevoUsuario.PermisoEscritura = chkPermisoEscritura.Checked;
                nuevoUsuario.EsAdmin = chkEsAdmin.Checked;

                nuevoUsuario.Area = new Area();
                nuevoUsuario.Area.Id = int.Parse(ddlArea.SelectedValue);

                nuevoUsuario.Puesto = new Puesto();
                nuevoUsuario.Puesto.Id = int.Parse(ddlPuesto.SelectedValue);

                nuevoUsuario.Empresa = new Empresa();
                nuevoUsuario.Empresa.Id = userLogueado.Empresa.Id;

                if (!string.IsNullOrEmpty(ddlSeniority.SelectedValue))
                {
                    nuevoUsuario.Seniority = new Seniority();
                    nuevoUsuario.Seniority.Id = int.Parse(ddlSeniority.SelectedValue);
                }
                else
                {
                    nuevoUsuario.Seniority = null;
                }


                if (esEdicion)
                {
                    nuevoUsuario.Id = int.Parse(Request.QueryString["id"]);
                    string duplicado = negocio.ObtenerDuplicadoUsuario(nuevoUsuario.NombreUsuario.Trim(), nuevoUsuario.Email.Trim(), nuevoUsuario.Id);

                    if (duplicado != null)
                    {
                        MostrarErrorDuplicado(duplicado);
                        return;
                    }
                    nuevoUsuario.Activo = false;
                    Usuario usuarioActual = negocio.BuscarPorId(nuevoUsuario.Id);
                    if (usuarioActual != null && usuarioActual.EmailVerificado)
                    {
                        nuevoUsuario.Activo = chkActivo.Checked;
                        if(nuevoUsuario.Id == userLogueado.Id && !nuevoUsuario.Activo)
                        {
                            MostrarErrorFormulario("No podés desactivar tu propio usaurio");
                            return;
                        }
                    }
                    if (negocio.Modificar(nuevoUsuario))
                    {
                        Response.Redirect("Usuarios.aspx", false);
                    }
                }
                else
                {
                    nuevoUsuario.Activo = false;
                    nuevoUsuario.EmailVerificado = false;
                    nuevoUsuario.PasswordHash = TokenHelper.GenerarToken();
                    string duplicado = negocio.ObtenerDuplicadoUsuario(txtNombreUsuario.Text.Trim(), txtEmail.Text.Trim());

                    if (duplicado != null)
                    {
                        MostrarErrorDuplicado(duplicado);
                        return;
                    }

                    int idUsuario = negocio.AgregarInvitado(nuevoUsuario);
                    if (idUsuario <= 0)
                    {
                        MostrarErrorFormulario("No se pudo generar el usuario.");
                        return;
                    }
                    nuevoUsuario.Id = idUsuario;
                    if (EnviarMailInvitacion(nuevoUsuario))
                    {
                        Response.Redirect("Usuarios.aspx", false);
                    }
                    else
                    {
                        MostrarErrorFormulario("No se pudo reenviar el mail de invitación.");
                    }
                }
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                //Response.Redirect("Default.aspx", false);
                MostrarErrorFormulario("Ocurrio un error al guardar el usuario.");
            }
        }
        private void LimpiarErroresFormulario()
        {
            litMensajeFormulario.Text = "";
            txtNombreUsuario.CssClass = "form-control";
            txtEmail.CssClass = "form-control";
        }

        private void MostrarErrorFormulario(string mensaje)
        {
            litMensajeFormulario.Text = $@"<div class='alert alert-danger mb-3' role='alert'>
                                            {mensaje}
                                        </div>";
        }
        private void CargarEstadoInvitacion(Usuario usuario)
        {
            pnlInvitacionVencida.Visible = false;
            if (usuario.EmailVerificado) return;

            UsuarioTokenNegocio tokenNegocio = new UsuarioTokenNegocio();
            EstadoTokenUsuario estado = tokenNegocio.ObtenerEstadoToken(usuario.Id, TipoTokenUsuario.CrearPassword);
            if (estado == EstadoTokenUsuario.Vencido || estado == EstadoTokenUsuario.NoExiste || estado == EstadoTokenUsuario.Usado)
            {
                pnlInvitacionVencida.Visible = true;
                lblInvitacionVencida.Text = "La invitación venció o el usuario aun no activo la cuenta.";
            }
        }
        private void MostrarErrorDuplicado(string tipoDuplicado)
        {
            LimpiarErroresFormulario();

            switch (tipoDuplicado)
            {
                case "usuario":
                    txtNombreUsuario.CssClass = "form-control is-invalid";
                    MostrarErrorFormulario("Ya existe un usuario con ese nombre de usuario.");
                    break;

                case "email":
                    txtEmail.CssClass = "form-control is-invalid";
                    MostrarErrorFormulario("Ya existe un usuario con ese correo electrónico.");
                    break;

                case "ambos":
                    txtNombreUsuario.CssClass = "form-control is-invalid";
                    txtEmail.CssClass = "form-control is-invalid";
                    MostrarErrorFormulario("Ya existe un usuario con ese nombre de usuario y ese correo electrónico.");
                    break;

                default:
                    txtNombreUsuario.CssClass = "form-control is-invalid";
                    txtEmail.CssClass = "form-control is-invalid";
                    MostrarErrorFormulario("Ya existe un usuario con ese nombre de usuario o correo electrónico.");
                    break;
            }
        }
        protected void btnReenviarInvitacion_Click(object sender, EventArgs e)
        {
            try
            {
                if (Request.QueryString["id"] == null)
                {
                    MostrarErrorFormulario("No se pudo identificar el usuario.");
                    return;
                }

                int idUsuario = int.Parse(Request.QueryString["id"]);

                UsuarioNegocio usuarioNegocio = new UsuarioNegocio();
                Usuario usuario = usuarioNegocio.BuscarPorId(idUsuario);

                if (usuario == null || usuario.EmailVerificado)
                {
                    MostrarErrorFormulario("No se puede reenviar la invitación para este usuario.");
                    return;
                }

                UsuarioTokenNegocio tokenNegocio = new UsuarioTokenNegocio();
                tokenNegocio.InvalidarTokensPendientes(usuario.Id, TipoTokenUsuario.CrearPassword);

                if (EnviarMailInvitacion(usuario))
                {
                    pnlInvitacionVencida.Visible = false;
                    litMensajeFormulario.Text = "<div class='alert alert-success mb-3'>Se reenvió la invitación correctamente.</div>";
                }
                else
                {
                    MostrarErrorFormulario("No se pudo reenviar la invitación.");
                }
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                MostrarErrorFormulario("Ocurrió un error al reenviar la invitación.");
            }
        }
        private bool EnviarMailInvitacion(Usuario usuario)
        {
            UsuarioTokenNegocio tokenNegocio = new UsuarioTokenNegocio();
            UsuarioToken usuarioToken = tokenNegocio.CrearToken(usuario, TipoTokenUsuario.CrearPassword, 24);

            string linkCrearPass = Request.Url.GetLeftPart(UriPartial.Authority)
                + ResolveUrl("~/CrearPassword.aspx")
                + "?token=" + Server.UrlEncode(usuarioToken.Token);

            string cuerpo = EmailTemplates.CrearPasswordEmpleado(usuario.Nombre, linkCrearPass);

            EmailService email = new EmailService();
            email.armarCorreo(usuario.Email, "Crea tu contraseña en TinyDesk", cuerpo);

            return email.enviarEmail();
        }
    }
}