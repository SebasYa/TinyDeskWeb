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

        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            Usuario usuario = new Usuario();
            UsuarioNegocio negocio = new UsuarioNegocio();
            try
            {
                usuario.NombreUsuario = txtNombreUsuario.Text;
                usuario.PasswordHash = txtPassword.Text;

                if (negocio.Login(usuario))
                {
                    Session.Add("usuario", usuario);
                    Response.Redirect("Default.aspx", false);
                    txtNombreUsuario.Text = "";
                    txtPassword.Text = "";

                }
                else
                {
                    Session.Remove("usuario");
                    Session.Add("error", "User o pass incorrectos");
                    txtPassword.Text = "";
                }
            }
            catch (Exception ex)
            {

                throw ex;
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
                else
                {
                    txtNombreUsuario.Text = "";
                    txtPassword.Text = "";
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}