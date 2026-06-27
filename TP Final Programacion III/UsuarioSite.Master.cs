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
    public partial class UsuarioSite : MasterPage
    {
        protected void Page_Init(object sender, EventArgs e)
        {
            if (!Seguridad.sessionActiva(Session["usuario"]))
            {
                Response.Redirect("Login.aspx", false);
                return;
            }
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Seguridad.sessionActiva(Session["usuario"]))
            {
                Response.Redirect("Login.aspx", false);
                return;
            }
            if (Seguridad.EsAdmin(Session["usuario"]) || Seguridad.PuedeEscribir(Session["usuario"]))
            {
                Response.Redirect("Default.aspx", false);
                return;
            }
            if (!IsPostBack)
            {
                Usuario usuario = (Usuario)Session["usuario"];
                lblUserWelcome.Text = usuario.Nombre;
                btnUserNav.Text = usuario.Nombre.Substring(0, 1).ToUpper();
                string rutaImagen = Session["imagenUsuario"] as string;
                if (!string.IsNullOrEmpty(rutaImagen))
                {
                    btnUserNav.Text = "";
                    btnUserNav.Style["background-image"] = "url('" + rutaImagen + "')";
                    btnUserNav.Style["background-size"] = "cover";
                    btnUserNav.Style["background-position"] = "center";
                    btnUserNav.Style["background-repeat"] = "no-repeat";
                }
                lblName_nav.Text = usuario.Nombre + " " + usuario.Apellido;
                lblEmpresa.Text = usuario.Empresa.Nombre;
                txtRol.Text = usuario.Area.Nombre;
                txtSenority.Text = usuario.Seniority != null ? usuario.Seniority.Nombre : "No asignado";
                pnlUserNav.Visible = false;
            }
        }
        protected void btnConfiguracionUsuario_Click(object sender, EventArgs e)
        {
            Response.Redirect("ConfiguracionUsuarioSinPermiso.aspx", false);
            Context.ApplicationInstance.CompleteRequest();
            return;
        }
        protected void btnUserNav_Click(object sender, EventArgs e)
        {
            if (pnlUserNav.Visible)
            {
                pnlUserNav.Visible = false;
            }
            else
            {
                pnlUserNav.Visible = true;
            }
        }
        protected void btnLogOut_Click(object sender, EventArgs e)
        {
            Session.Abandon();
            Response.Redirect("Login.aspx", false);
            Context.ApplicationInstance.CompleteRequest();
        }
    }
}