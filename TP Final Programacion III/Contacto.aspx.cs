using dominio;
using negocio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Mail;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TP_Final_Programacion_III
{
    public partial class Contacto : System.Web.UI.Page
    {
        private const string EmailDestinoContacto = "tinydesk.oficial@hotmail.com";
        private class SolicitudContacto
        {
            public Usuario Usuario { get; set; }
            public string NombreVisitante { get; set; }
            public string EmailVisitante { get; set; }
            public string Motivo { get; set; }
            public string Mensaje { get; set; }
            public string NombreRemitente
            {
                get
                {
                    if (Usuario != null)
                    {
                        return ((Usuario.Nombre ?? "") + " " + (Usuario.Apellido ?? "")).Trim();
                    }
                    return NombreVisitante;
                }
            }
            public string EmailRemitente
            {
                get
                {
                    if (Usuario != null)
                    {
                        return Usuario.Email;
                    }
                    return EmailVisitante;
                }
            }
            public string EmpresaRemitente
            {
                get
                {
                    if (Usuario != null && Usuario.Empresa != null)
                    {
                        return Usuario.Empresa.Nombre;
                    }
                    return "No informada";
                }
            }
            public int? IdUsuario
            {
                get
                {
                    if (Usuario != null)
                    {
                        return Usuario.Id;
                    }

                    return null;
                }
            }
            public string Origen
            {
                get
                {
                    return Usuario != null ? "Usuario autenticado" : "Página pública";
                }
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            Usuario usuario = ObtenerUsuarioActual();

            ConfigurarFormulario(usuario);

            if (!IsPostBack)
            {
                pnlResultado.Visible = false;
            }
        }
        protected void btnEnviar_Click(object sender, EventArgs e)
        {
            try
            {
                int minutosRestantes = 0;
                if (!PuedeEnviarMensaje(ref minutosRestantes))
                {
                    MostrarResultado("Podés enviar otro mensaje dentro de " + minutosRestantes + " minuto(s).", false);
                    return;
                }
                    pnlResultado.Visible = false;
                Page.Validate("Contacto");
                if (!Page.IsValid) return;

                SolicitudContacto solicitud = CrearSolicitudContacto();
                string error = ValidarSolicitud(solicitud);
                if (error != null)
                {
                    MostrarResultado(error, false);
                    return;
                }

                string asunto = "[Contacto TinyDesk] " + solicitud.Motivo;
                string cuerpo = ArmarCuerpoCorreo(solicitud);
                EmailService emailService = new EmailService();
                bool enviado = emailService.EnviarCorreoContacto(EmailDestinoContacto, solicitud.EmailRemitente, asunto, cuerpo);
                if (!enviado)
                {
                    Session["error"] = emailService.UltimoError;
                    MostrarResultado("No pudimos enviar el mensaje. Intentá nuevamente más tarde.", false);
                    return;
                }
                Session["UltimoEnvioContacto"] = DateTime.UtcNow;
                LimpiarFormulario(solicitud.Usuario == null);
                MostrarResultado("Tu mensaje fue enviado correctamente.", true);
            }
            catch (Exception ex)
            {
                Session["error"] = ex.ToString();
                MostrarResultado("Ocurrió un error al enviar el mensaje.", false);
            }
        }
        protected void btnInicio_Click(object sender, EventArgs e)
        {
            RedirigirAlInicioCorrespondiente();
        }
        protected void btnIrAbout_Click(object sender, EventArgs e)
        {
            Redirigir("About.aspx");
        }
        protected void btnIrContacto_Click(object sender, EventArgs e)
        {
            Redirigir("Contacto.aspx");
        }
        private SolicitudContacto CrearSolicitudContacto()
        {
            SolicitudContacto solicitud = new SolicitudContacto();

            solicitud.Usuario = ObtenerUsuarioActual();
            solicitud.Motivo = ObtenerMotivoSeleccionado();
            solicitud.Mensaje = txtMensaje.Text.Trim();

            if (solicitud.Usuario == null)
            {
                solicitud.NombreVisitante = txtNombre.Text.Trim();
                solicitud.EmailVisitante = txtEmail.Text.Trim();
            }
            return solicitud;
        }
        private string ObtenerMotivoSeleccionado()
        {
            switch (ddlMotivo.SelectedValue)
            {
                case "1":
                    return "Consulta general";

                case "2":
                    return "Problemas para ingresar";

                case "3":
                    return "Soporte técnico";

                case "4":
                    return "Planes y facturación";

                case "5":
                    return "Sugerencia";

                default:
                    return null;
            }
        }
        private string ValidarSolicitud(SolicitudContacto solicitud)
        {
            if (string.IsNullOrWhiteSpace(solicitud.NombreRemitente))
            {
                return "El nombre es obligatorio.";
            }

            if (!EmailValido(solicitud.EmailRemitente))
            {
                return "El correo electrónico no es válido.";
            }

            if (string.IsNullOrWhiteSpace(solicitud.Motivo))
            {
                return "El motivo seleccionado no es válido.";
            }

            if (string.IsNullOrWhiteSpace(solicitud.Mensaje))
            {
                return "El mensaje es obligatorio.";
            }

            if (ContarPalabras(solicitud.Mensaje) > 200)
            {
                return "El mensaje no puede superar las 200 palabras.";
            }

            return null;
        }
        private int ContarPalabras(string texto)
        {
            if (string.IsNullOrWhiteSpace(texto)) return 0;

            string[] palabras = texto.Split(
                new char[] { ' ', '\r', '\n', '\t' },
                StringSplitOptions.RemoveEmptyEntries
            );
            return palabras.Length;
        }
        private string ArmarCuerpoCorreo(SolicitudContacto solicitud)
        {
            string mensajeSeguro = HttpUtility.HtmlEncode(solicitud.Mensaje)
                .Replace("\r\n", "<br />")
                .Replace("\n", "<br />");

            StringBuilder cuerpo = new StringBuilder();
            cuerpo.Append("<h2>Nuevo mensaje de contacto</h2>");
            cuerpo.Append("<p><b>Motivo:</b> " + HttpUtility.HtmlEncode(solicitud.Motivo) + "</p>");
            cuerpo.Append("<p><b>Origen:</b> " + HttpUtility.HtmlEncode(solicitud.Origen) + "</p>");

            if (solicitud.IdUsuario.HasValue)
            {
                cuerpo.Append("<p><b>ID de usuario:</b> " + solicitud.IdUsuario.Value + "</p>");
            }

            cuerpo.Append("<p><b>Nombre:</b> " + HttpUtility.HtmlEncode(solicitud.NombreRemitente) + "</p>");
            cuerpo.Append("<p><b>Email:</b> " + HttpUtility.HtmlEncode(solicitud.EmailRemitente) + "</p>");
            cuerpo.Append("<p><b>Empresa:</b> " + HttpUtility.HtmlEncode(solicitud.EmpresaRemitente) + "</p>");
            cuerpo.Append("<hr />");
            cuerpo.Append("<p><b>Mensaje:</b></p>");
            cuerpo.Append("<p>" + mensajeSeguro + "</p>");

            return cuerpo.ToString();
        }
        private Usuario ObtenerUsuarioActual()
        {
            Usuario usuario = Session["usuario"] as Usuario;

            if (usuario == null || !Seguridad.sessionActiva(usuario))
            {
                return null;
            }

            return usuario;
        }
        private void ConfigurarFormulario(Usuario usuario)
        {
            bool tieneSesion = usuario != null;
            pnlDatosSesion.Visible = tieneSesion;
            pnlDatosPublicos.Visible = !tieneSesion;
            rfvNombre.Enabled = !tieneSesion;
            rfvEmail.Enabled = !tieneSesion;
            revEmail.Enabled = !tieneSesion;

            if (!tieneSesion) return;

            string nombreCompleto = ((usuario.Nombre ?? "") + " " + (usuario.Apellido ?? "")).Trim();
            string empresa = usuario.Empresa != null ? usuario.Empresa.Nombre : "Sin empresa";
            lblSesionNombre.Text = HttpUtility.HtmlEncode(nombreCompleto);
            lblSesionDetalle.Text = HttpUtility.HtmlEncode((usuario.Email ?? "") + " · " + empresa);
        }
        private bool EmailValido(string email)
        {
            if (string.IsNullOrWhiteSpace(email)) return false;

            try
            {
                MailAddress direccion = new MailAddress(email);

                return string.Equals(direccion.Address, email, StringComparison.OrdinalIgnoreCase);
            }
            catch
            {
                return false;
            }
        }
        private void LimpiarFormulario(bool limpiarDatosPublicos)
        {
            ddlMotivo.SelectedIndex = 0;
            txtMensaje.Text = "";

            if (limpiarDatosPublicos)
            {
                txtNombre.Text = "";
                txtEmail.Text = "";
            }
        }
        private void MostrarResultado(string mensaje, bool exitoso)
        {
            pnlResultado.Visible = true;
            pnlResultado.CssClass = exitoso ? "alert alert-success" : "alert alert-danger";
            lblResultado.Text = HttpUtility.HtmlEncode(mensaje);
        }
        private void RedirigirAlInicioCorrespondiente()
        {
            Usuario usuario = ObtenerUsuarioActual();

            if (usuario == null)
            {
                Redirigir("Login.aspx");
                return;
            }

            if (Seguridad.EsAdmin(usuario) || Seguridad.PuedeEscribir(usuario))
            {
                Redirigir("Default.aspx");
                return;
            }

            Redirigir("UsuarioDefault.aspx");
        }
        private void Redirigir(string pagina)
        {
            Response.Redirect(pagina, false);
            Context.ApplicationInstance.CompleteRequest();
        }
        private bool PuedeEnviarMensaje(ref int minutosRestantes)
        {
            minutosRestantes = 0;

            if (Session["UltimoEnvioContacto"] == null) return true;
            DateTime ultimoEnvio = (DateTime)Session["UltimoEnvioContacto"];
            DateTime proximoEnvio = ultimoEnvio.AddMinutes(10);
            if (DateTime.UtcNow >= proximoEnvio) return true;
            TimeSpan tiempoRestante = proximoEnvio - DateTime.UtcNow;
            minutosRestantes = (int)Math.Ceiling(tiempoRestante.TotalMinutes);

            return false;
        }
    }
}