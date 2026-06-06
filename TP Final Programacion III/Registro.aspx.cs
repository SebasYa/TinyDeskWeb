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
    public partial class Registro : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                txtPassword.Text = "";
                txtConfirmarPassword.Text = "";
            }
        }

        protected void btnCrearUsuario_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtNombreUsuario.Text) ||
                string.IsNullOrWhiteSpace(txtNombre.Text) ||
                string.IsNullOrWhiteSpace(txtApellido.Text) ||
                string.IsNullOrWhiteSpace(txtPassword.Text) ||
                string.IsNullOrWhiteSpace(txtConfirmarPassword.Text) ||
                string.IsNullOrWhiteSpace(txtNombreEmpresa.Text) ||
                string.IsNullOrWhiteSpace(txtEmail.Text) ||
                txtPassword.Text != txtConfirmarPassword.Text
                )
            {
                return;
            }

            try
            {
                UsuarioNegocio negocio = new UsuarioNegocio();

                int idUsuario = negocio.RegistrarEmpresaYOwner(
                    txtNombreEmpresa.Text,
                    txtNombreUsuario.Text,
                    txtPassword.Text,
                    txtNombre.Text,
                    txtApellido.Text,
                    txtEmail.Text);
                if(idUsuario <= 0)
                {
                    return;
                }

                Usuario usuario = new Usuario();
                usuario.Id = idUsuario;
                usuario.Nombre = txtNombre.Text;
                usuario.Email = txtEmail.Text;

                UsuarioTokenNegocio tokenNegocio = new UsuarioTokenNegocio();
                UsuarioToken usuarioToken = tokenNegocio.CrearToken(usuario, "ValidarEmail", 24);

                string linkValidacion = Request.Url.GetLeftPart(UriPartial.Authority) + ResolveUrl("~/ValidarEmail.aspx") + "?token=" + Server.UrlEncode(usuarioToken.Token);
                string cuerpo = EmailTemplates.ValidarCuenta(usuario.Nombre, linkValidacion);

                EmailService emailService = new EmailService();
                emailService.armarCorreo(usuario.Email, "Valida tu cuenta en TinyDesk", cuerpo);
                if(emailService.enviarEmail()) Response.Redirect("Login.aspx", false);

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}