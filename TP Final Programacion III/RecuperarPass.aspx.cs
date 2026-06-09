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
    public partial class RecuperarPass : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                litMensaje.Text = "";
                txtNombreUsuario.Text = "";
            }
        }

        protected void btnEnviarRecuperacion_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtNombreUsuario.Text))
            {
                MostrarError("Ingresá tu usuario.");
                return;
            }

            try
            {
                UsuarioNegocio usuarioNegocio = new UsuarioNegocio();
                Usuario usuario = usuarioNegocio.BuscarPorNombreUsuario(txtNombreUsuario.Text.Trim());

                if (usuario != null && usuario.Activo && usuario.EmailVerificado)
                {
                    UsuarioTokenNegocio tokenNegocio = new UsuarioTokenNegocio();
                    tokenNegocio.InvalidarTokensPendientes(usuario.Id, "ResetPassword");

                    UsuarioToken token = tokenNegocio.CrearToken(usuario, "ResetPassword", 24);

                    string link = Request.Url.GetLeftPart(UriPartial.Authority)
                        + ResolveUrl("~/CrearPassword.aspx")
                        + "?token=" + Server.UrlEncode(token.Token);

                    string cuerpo = EmailTemplates.RecuperarPassword(usuario.Nombre, link);

                    EmailService email = new EmailService();
                    email.armarCorreo(usuario.Email, "Recuperar contraseña TinyDesk", cuerpo);
                    email.enviarEmail();
                }

                MostrarExito("Si el usuario existe y está activo, se enviará un correo para cambiar la contraseña.");
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                MostrarError("Ocurrió un error al solicitar el cambio de contraseña.");
            }
        }

        private void MostrarExito(string mensaje)
        {
            litMensaje.Text = $@"<div class='alert alert-success mb-3' role='alert'>
                                    {mensaje}
                                 </div>";
        }

        private void MostrarError(string mensaje)
        {
            litMensaje.Text = $@"<div class='alert alert-danger mb-3' role='alert'>
                                    {mensaje}
                                 </div>";
        }
    }
}