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
    public partial class Login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["usuario"] != null && ( Seguridad.EsAdmin(Session["usuario"]) || Seguridad.PuedeEscribir(Session["usuario"])) )
            {
                Response.Redirect("Default.aspx", false);
                return;
            }
            if (Session["usuario"] != null && (!Seguridad.EsAdmin(Session["usuario"]) || !Seguridad.PuedeEscribir(Session["usuario"])))
            {
                Response.Redirect("UsuarioDefault.aspx", false);
                return;
            }
            lblErrorUsuario.Visible = false;
            lblErrorPass.Visible = false;
            if (!IsPostBack)
            {
                pnlReenvioValidacion.Visible = false;
                Session.Remove("idUsuarioReenvioValidacion");
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            Usuario usuario = new Usuario();
            UsuarioNegocio negocio = new UsuarioNegocio();
            try
            {
                pnlReenvioValidacion.Visible = false;
                Session.Remove("idUsuarioReenvioValidacion");
                if (string.IsNullOrWhiteSpace(txtNombreUsuario.Text) || string.IsNullOrWhiteSpace(txtPassword.Text))
                {
                    return;
                }
                usuario.NombreUsuario = txtNombreUsuario.Text;
                usuario.PasswordHash = txtPassword.Text;

                if (negocio.Login(usuario))
                {
                    Session.Add("usuario", usuario);
                    txtNombreUsuario.Text = "";
                    txtPassword.Text = "";
                    if (Seguridad.EsAdmin(Session["usuario"]) || Seguridad.PuedeEscribir(Session["usuario"]))
                    {
                        Response.Redirect("Default.aspx", false);
                    }
                    else
                    {
                        Response.Redirect("UsuarioDefault.aspx", false);
                    }
                }
                else if (negocio.MailPendienteVerificacion(usuario))
                {
                    Usuario usuarioPendiente = negocio.BuscarPorNombreUsuarioOEmail(usuario.NombreUsuario.Trim());
                    Session.Remove("usuario");
                    txtPassword.Text = "";

                    lblErrorUsuario.Text = "Tu cuenta está pendiente de verificación. Revisá tu correo electrónico para poder iniciar sesión.";
                    lblErrorUsuario.Visible = true;

                    lblErrorPass.Text = "";
                    lblErrorPass.Visible = false;

                    txtNombreUsuario.CssClass = "form-control is-invalid";
                    txtPassword.CssClass = "form-control";

                    if (usuarioPendiente != null)
                    {
                        Session["idUsuarioReenvioValidacion"] = usuarioPendiente.Id;
                        pnlReenvioValidacion.Visible = true;
                        btnReenviarValidacion.Visible = true;
                        lblReenvioValidacion.Text = "Si no te llegó el correo de validación, podés pedir uno nuevo.";
                    }
                    return;
                }
                else
                {
                    Session.Remove("usuario");
                    txtPassword.Text = "";
                    lblErrorUsuario.Text = "Usuario incorrecto.";
                    lblErrorUsuario.Visible = true;
                    lblErrorPass.Text = "Contraseña incorrecta.";
                    lblErrorPass.Visible = true;
                    txtNombreUsuario.CssClass = "form-control is-invalid";
                    txtPassword.CssClass = "form-control is-invalid";
                }
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                Session.Remove("usuario");
                txtPassword.Text = "";
                lblErrorUsuario.Text = "Ocurrio un error al iniciar sesion. Intentelo nuevamente";
                lblErrorUsuario.Visible = true;
                lblErrorPass.Text = "";
                lblErrorPass.Visible = false;
                pnlReenvioValidacion.Visible = false;
            }
        }
        protected void btnLoginFantasmin_Click(object sender, EventArgs e)
        {
            Usuario usuario = new Usuario();
            usuario.NombreUsuario = "phantom_user";
            usuario.PasswordHash = "123";

            UsuarioNegocio negocio = new UsuarioNegocio();

            try
            {
                if (negocio.Login(usuario))
                {
                    Session.Add("usuario", usuario);
                    Response.Redirect("Default.aspx", false);
                    txtNombreUsuario.Text = "";
                    txtPassword.Text = "";
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        protected void btnReenviarValidacion_Click(object sender, EventArgs e)
        {
            try
            {
                if (Session["idUsuarioReenvioValidacion"] == null)
                {
                    pnlReenvioValidacion.Visible = true;
                    lblReenvioValidacion.Text = "No se pudo identificar el usuario para reenviar la validación.";
                    return;
                }

                int idUsuario = Convert.ToInt32(Session["idUsuarioReenvioValidacion"]);

                UsuarioNegocio usuarioNegocio = new UsuarioNegocio();
                Usuario usuario = usuarioNegocio.BuscarPorId(idUsuario);

                if (usuario == null || usuario.EmailVerificado)
                {
                    pnlReenvioValidacion.Visible = true;
                    lblReenvioValidacion.Text = "No se puede reenviar la validación para este usuario.";
                    return;
                }

                UsuarioTokenNegocio tokenNegocio = new UsuarioTokenNegocio();
                tokenNegocio.InvalidarTokensPendientes(usuario.Id, TipoTokenUsuario.ValidarEmail);

                UsuarioToken nuevoToken = tokenNegocio.CrearToken(usuario, TipoTokenUsuario.ValidarEmail, 24);

                string linkValidacion = LinkHelper.GenerarLink(this, "ValidarEmail.aspx", "token", Server.UrlEncode(nuevoToken.Token));
                string cuerpo = EmailTemplates.ValidarCuenta(usuario.Nombre, linkValidacion);

                EmailService email = new EmailService();
                email.armarCorreo(usuario.Email, "Valida tu cuenta en TinyDesk", cuerpo);

                pnlReenvioValidacion.Visible = true;

                if (email.enviarEmail())
                {
                    pnlReenvioValidacion.CssClass = "alert alert-success mt-3";
                    lblReenvioValidacion.Text = "Se envió un nuevo correo de validación.";
                    btnReenviarValidacion.Visible = false;
                    Session.Remove("idUsuarioReenvioValidacion");
                }
                else
                {
                    pnlReenvioValidacion.CssClass = "alert alert-danger mt-3";
                    lblReenvioValidacion.Text = "No se pudo enviar el correo de validación.";
                }
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());

                pnlReenvioValidacion.Visible = true;
                pnlReenvioValidacion.CssClass = "alert alert-danger mt-3";
                lblReenvioValidacion.Text = "Ocurrió un error al reenviar el correo de validación.";
            }
        }
    }
}