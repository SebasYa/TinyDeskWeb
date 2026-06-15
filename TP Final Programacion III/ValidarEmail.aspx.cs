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
    public partial class ValidarEmail : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack)
                return;

            string token = Request.QueryString["token"];

            if (string.IsNullOrWhiteSpace(token))
            {
                MostrarError("El link de validación es inválido.");
                return;
            }

            try
            {
                UsuarioTokenNegocio tokenNegocio = new UsuarioTokenNegocio();
                UsuarioToken usuarioToken = tokenNegocio.BuscarToken(token, TipoTokenUsuario.ValidarEmail, true);

                if (usuarioToken == null)
                {
                    UsuarioToken tokenVencido = tokenNegocio.BuscarToken(token, TipoTokenUsuario.ValidarEmail);
                    if (tokenVencido != null && !tokenVencido.Usado && tokenVencido.FechaExpiracion <= DateTime.Now && !tokenVencido.Usuario.EmailVerificado)
                    {
                        MostrarReenvio(token);
                        return;
                    }
                    MostrarError("El link de validación expiró o ya fue utilizado.");
                    return;
                }

                UsuarioNegocio usuarioNegocio = new UsuarioNegocio();
                usuarioNegocio.VerificarMail(usuarioToken.Usuario);

                tokenNegocio.MarcarComoUsado(usuarioToken);

                MostrarExito("Tu cuenta fue validada correctamente.");
            }
            catch
            {
                MostrarError("Ocurrió un error al validar la cuenta. Intente nuevamente más tarde.");
            }
        }

        private void MostrarExito(string mensaje)
        {
            lblMensaje.Text = mensaje;
            lblMensaje.CssClass = "d-block mb-3 text-success";
            pnlReenvio.Visible = false;
            pnlCargando.Visible = true;

            litRedireccion.Text = @"
                <script>
                    setTimeout(function () {
                        window.location.href = 'Login.aspx';
                    }, 3000);
                </script>";
        }

        private void MostrarError(string mensaje)
        {
            lblMensaje.Text = mensaje;
            lblMensaje.CssClass = "d-block mb-3 text-danger";
            pnlCargando.Visible = false;
            pnlReenvio.Visible = false;
            litRedireccion.Text = "";
        }
        protected void btnReenviarValidacion_Click(object sender, EventArgs e)
        {
            try
            {
                UsuarioTokenNegocio tokenNegocio = new UsuarioTokenNegocio();
                UsuarioToken tokenVencido = tokenNegocio.BuscarToken(hfTokenReenvio.Value, TipoTokenUsuario.ValidarEmail);

                if (tokenVencido == null || tokenVencido.Usado || tokenVencido.Usuario.EmailVerificado)
                {
                    MostrarError("No se puede reenviar la validación para este link.");
                    return;
                }

                Usuario usuario = tokenVencido.Usuario;

                tokenNegocio.InvalidarTokensPendientes(usuario.Id, TipoTokenUsuario.ValidarEmail);

                UsuarioToken nuevoToken = tokenNegocio.CrearToken(usuario, TipoTokenUsuario.ValidarEmail, 24);

                string linkValidacion = LinkHelper.GenerarLink(this, "ValidarEmail.aspx", "token", Server.UrlEncode(nuevoToken.Token));
                string cuerpo = EmailTemplates.ValidarCuenta(usuario.Nombre, linkValidacion);

                EmailService email = new EmailService();
                email.armarCorreo(usuario.Email, "Valida tu cuenta en TinyDesk", cuerpo);

                if (email.enviarEmail())
                    MostrarExito("Se envió un nuevo correo de validación.");
                else
                    MostrarError("No se pudo enviar el nuevo correo de validación.");
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                MostrarError("Ocurrió un error al reenviar el correo de validación.");
            }
        }

        private void MostrarReenvio(string token)
        {
            lblMensaje.Text = "El link de validación venció. Podés pedir un nuevo correo para activar tu cuenta.";
            lblMensaje.CssClass = "d-block mb-3 text-danger";

            hfTokenReenvio.Value = token;

            pnlReenvio.Visible = true;
            pnlCargando.Visible = false;
            litRedireccion.Text = "";
        }
    }
}