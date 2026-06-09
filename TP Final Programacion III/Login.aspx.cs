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
            lblErrorUsuario.Visible = false;
            lblErrorPass.Visible = false;
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            Usuario usuario = new Usuario();
            UsuarioNegocio negocio = new UsuarioNegocio();
            try
            {
                if (string.IsNullOrWhiteSpace(txtNombreUsuario.Text) || string.IsNullOrWhiteSpace(txtPassword.Text)) 
                {
                    return; 
                }
                usuario.NombreUsuario = txtNombreUsuario.Text;
                usuario.PasswordHash = txtPassword.Text;

                if (negocio.Login(usuario))
                {
                    Session.Add("usuario", usuario);
                    txtNombreUsuario.Text = "";
                    txtPassword.Text = "";
                    if (Seguridad.EsAdmin(Session["usuario"]) || Seguridad.PuedeEscribir(Session["usuario"]))
                    {
                        Response.Redirect("Default.aspx", false);
                    }
                    else
                    {
                        Response.Redirect("Default.aspx", false);
                    }
                }
                else if (negocio.MailPendienteVerificacion(usuario))
                {
                    Session.Remove("usuario");
                    txtPassword.Text = "";

                    lblErrorUsuario.Text = "Tu cuenta está pendiente de verificación. Revisá tu correo electrónico para poder iniciar sesión.";
                    lblErrorUsuario.Visible = true;

                    lblErrorPass.Text = "";
                    lblErrorPass.Visible = false;

                    txtNombreUsuario.CssClass = "form-control is-invalid";
                    txtPassword.CssClass = "form-control";
                }
                else
                {
                    Session.Remove("usuario");
                    txtPassword.Text = "";
                    lblErrorUsuario.Text = "Usuario incorrecto.";
                    lblErrorUsuario.Visible = true;
                    lblErrorPass.Text = "Contraseña incorrecta.";
                    lblErrorPass.Visible = true;
                    txtNombreUsuario.CssClass = "form-control is-invalid";
                    txtPassword.CssClass = "form-control is-invalid";
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
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}