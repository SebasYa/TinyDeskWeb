using dominio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Text;
using System.Threading.Tasks;

namespace negocio
{
    public class EmailService
    {
        private MailMessage email;
        private SmtpClient server;
        public string UltimoError { get; set; }

        public EmailService()
        {
            server = new SmtpClient();
            server.Credentials = new NetworkCredential("2055d56a9a6612", "3038227a580d0f");
            server.EnableSsl = true;
            server.Port = 2525;
            server.Host = "sandbox.smtp.mailtrap.io";
        }
        public void armarCorreo(string emailDestino, string asunto, string cuerpo, string mailOrigen = "noresponder@tinydesk.com")
        {
            email = new MailMessage();
            email.From = new MailAddress(mailOrigen);
            email.To.Add(emailDestino);
            email.Subject = asunto;
            email.IsBodyHtml = true;
            email.Body = cuerpo;

        }
        public bool enviarEmail()
        {
            try
            {
                server.Send(email);
                return true;
            }
            catch (Exception ex)
            {
                UltimoError = ex.Message;
                return false;
            }
        }
        public bool EnviarMailTicketAsignado(int idUsuario, Ticket ticket, string linkTicket)
        {
            UsuarioNegocio usuarioNegocio = new UsuarioNegocio();
            Usuario usuarioAsignado = usuarioNegocio.BuscarPorId(idUsuario);

            if (usuarioAsignado == null || !usuarioAsignado.Activo || !usuarioAsignado.EmailVerificado) return false;

            string area = usuarioAsignado.Area != null ? usuarioAsignado.Area.Nombre : "";
            string cuerpo = EmailTemplates.TicketAsignado(usuarioAsignado.Nombre, ticket, area, linkTicket);

            armarCorreo(usuarioAsignado.Email, "Nuevo ticket asignado en TinyDesk", cuerpo);
            return enviarEmail();
        }
        public bool EnviarCorreoContacto(string emailDestino, string emailRemitente, string asunto, string cuerpo)
        {
            try
            {
                armarCorreo(
                    emailDestino,
                    LimpiarCabecera(asunto),
                    cuerpo,
                    emailRemitente
                );

                return enviarEmail();
            }
            catch (Exception ex)
            {
                UltimoError = ex.Message;
                return false;
            }
        }

        private string LimpiarCabecera(string texto)
        {
            return (texto ?? "")
                .Replace("\r", " ")
                .Replace("\n", " ")
                .Trim();
        }
    }
}
