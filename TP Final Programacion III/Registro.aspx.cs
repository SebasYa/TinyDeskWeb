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

                if (negocio.RegistrarEmpresaYOwner(
                    txtNombreEmpresa.Text,
                    txtNombreUsuario.Text,
                    txtPassword.Text,
                    txtNombre.Text,
                    txtApellido.Text,
                    txtEmail.Text))
                {
                    Response.Redirect("Login.aspx", false);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}