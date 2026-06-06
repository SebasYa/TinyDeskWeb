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
    public partial class CrearPassword : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack)
                return;

            string token = Request.QueryString["token"];

            if (string.IsNullOrWhiteSpace(token))
            {
                MostrarError("El link para crear la contraseña es inválido.");
                return;
            }

            UsuarioTokenNegocio tokenNegocio = new UsuarioTokenNegocio();
            UsuarioToken usuarioToken = tokenNegocio.BuscarTokenValido(token, "CrearPassword");

            if (usuarioToken == null)
            {
                MostrarError("El link para crear la contraseña expiró o ya fue utilizado.");
                return;
            }

            lblMensaje.Text = "Hola " + usuarioToken.Usuario.Nombre + ", ingresá tu nueva contraseña.";
            lblMensaje.CssClass = "d-block mb-3 text-center text-muted";
        }

        protected void btnCrearPassword_Click(object sender, EventArgs e)
        {
            string token = Request.QueryString["token"];

            if (string.IsNullOrWhiteSpace(token))
            {
                MostrarError("El link para crear la contraseña es inválido.");
                return;
            }

            if (string.IsNullOrWhiteSpace(txtPassword.Text) ||
                string.IsNullOrWhiteSpace(txtConfirmarPassword.Text))
            {
                MostrarError("Debe ingresar y confirmar la contraseña.");
                return;
            }

            if (txtPassword.Text != txtConfirmarPassword.Text)
            {
                MostrarError("Las contraseñas no coinciden.");
                return;
            }

            try
            {
                UsuarioTokenNegocio tokenNegocio = new UsuarioTokenNegocio();
                UsuarioToken usuarioToken = tokenNegocio.BuscarTokenValido(token, "CrearPassword");

                if (usuarioToken == null)
                {
                    MostrarError("El link para crear la contraseña expiró o ya fue utilizado.");
                    return;
                }

                UsuarioNegocio usuarioNegocio = new UsuarioNegocio();
                usuarioNegocio.CrearPassInvitado(usuarioToken.Usuario, txtPassword.Text);

                tokenNegocio.MarcarComoUsado(usuarioToken);

                MostrarExito("Tu contraseña fue creada correctamente.");
            }
            catch (Exception)
            {
                MostrarError("Ocurrió un error al crear la contraseña. Intente nuevamente más tarde.");
            }
        }

        private void MostrarExito(string mensaje)
        {
            lblMensaje.Text = mensaje;
            lblMensaje.CssClass = "d-block mb-3 text-center text-success";

            pnlFormulario.Visible = false;
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
            lblMensaje.CssClass = "d-block mb-3 text-center text-danger";

            pnlFormulario.Visible = false;
            pnlCargando.Visible = false;
            litRedireccion.Text = "";
        }
    }
}