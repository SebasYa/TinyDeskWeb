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

                if (usuario == null)
                {
                    MostrarExito("Se envio un correo para cambiar la contraseña correctamente.");
                    return;
                }

                UsuarioTokenNegocio tokenNegocio = new UsuarioTokenNegocio();

                if (!usuario.EmailVerificado)
                {
                    EstadoTokenUsuario estadoValidacion = tokenNegocio.ObtenerEstadoToken(usuario.Id, TipoTokenUsuario.ValidarEmail);

                    if (estadoValidacion == EstadoTokenUsuario.Pendiente)
                    {
                        MostrarAviso("Tu cuenta todavía no está validada. Ya tenés un correo de validación vigente.");
                        return;
                    }

                    if (estadoValidacion == EstadoTokenUsuario.Vencido)
                    {
                        MostrarAviso("Tu link de validación venció. Entrá desde ese link vencido para pedir un nuevo correo.");
                        return;
                    }

                    EstadoTokenUsuario estadoInvitacion = tokenNegocio.ObtenerEstadoToken(usuario.Id, TipoTokenUsuario.CrearPassword);

                    if (estadoInvitacion == EstadoTokenUsuario.Pendiente)
                    {
                        MostrarAviso("Tu usuario todavía no está activado. Ya tenés una invitación vigente para crear tu contraseña.");
                        return;
                    }

                    if (estadoInvitacion == EstadoTokenUsuario.Vencido || estadoInvitacion == EstadoTokenUsuario.Usado || estadoInvitacion == EstadoTokenUsuario.NoExiste)
                    {
                        MostrarAviso("Tu usuario todavía no está activado y la invitación no está vigente. Pedile a un administrador que te reenvíe la invitación.");
                        return;
                    }

                    MostrarAviso("Tu usuario todavía no está activado.");
                    return;
                }

                if (!usuario.Activo)
                {
                    MostrarError("Este usuario está dado de baja. No se puede recuperar la contraseña.");
                    return;
                }

                tokenNegocio.InvalidarTokensPendientes(usuario.Id, TipoTokenUsuario.ResetPassword);

                UsuarioToken token = tokenNegocio.CrearToken(usuario, TipoTokenUsuario.ResetPassword, 24);

                string link = Request.Url.GetLeftPart(UriPartial.Authority)
                    + ResolveUrl("~/CrearPassword.aspx")
                    + "?token=" + Server.UrlEncode(token.Token);

                string cuerpo = EmailTemplates.RecuperarPassword(usuario.Nombre, link);

                EmailService email = new EmailService();
                email.armarCorreo(usuario.Email, "Recuperar contraseña TinyDesk", cuerpo);

                if (email.enviarEmail())
                    MostrarExito("Se envió un correo para cambiar la contraseña.");
                else
                    MostrarError("No se pudo enviar el correo de recuperación.");
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
        private void MostrarAviso(string mensaje)
        {
            litMensaje.Text = $@"<div class='alert alert-danger mb-3' role='alert'>
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