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
                UsuarioToken usuarioToken = tokenNegocio.BuscarTokenValido(token, "ValidarEmail");

                if (usuarioToken == null)
                {
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
            litRedireccion.Text = "";
        }
    }
}