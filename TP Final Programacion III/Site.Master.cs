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
    public partial class SiteMaster : MasterPage
    {
        protected void Page_Init(object sender, EventArgs e)
        {
            if (!Seguridad.sessionActiva(Session["usuario"]))
            {
                Response.Redirect("Login.aspx", true);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }
            /*if (!Seguridad.EsAdmin(Session["usuario"]) || !Seguridad.PuedeEscribir(Session["usuario"]))
            {
                Response.Redirect("UsuarioDefault.aspx", true);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }*/
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            
            if (!Seguridad.sessionActiva(Session["usuario"]))
            {
                Response.Redirect("Login.aspx", false);
                return;
            }
            bool esAdmin = Seguridad.EsAdmin(Session["usuario"]);
                liAdminTitulo.Visible = esAdmin;
                liNavCatalogos.Visible = esAdmin;
                liNavUsuarios.Visible = esAdmin;

            if (!IsPostBack)
            {
                Usuario usuario = new Usuario();
                usuario = (Usuario)Session["usuario"];
                lblUserWelcome.Text = $"{usuario.Nombre}";
                btnUserNav.Text = firstLetter_usuario(usuario.Nombre);
                lblName_nav.Text = usuario.Nombre+" "+usuario.Apellido;
                lblEmpresa.Text = usuario.Empresa.Nombre;
                txtRol.Text = usuario.Area.Nombre;
                pnlUserNav.Visible = false;
            }
        }

        private string firstLetter_usuario(string usuario) 
        {
            string firstLetter = usuario.Substring(0, 1).ToUpper();
            return firstLetter;
        }

        protected void btnUserNav_Click(object sender, EventArgs e)
        {
            pnlUserNav.Visible = !pnlUserNav.Visible;

        }

        protected void btnLogOut_Click(object sender, EventArgs e)
        {
            Session.Abandon();
            Response.Redirect("Login.aspx", true);
        }
    }
}