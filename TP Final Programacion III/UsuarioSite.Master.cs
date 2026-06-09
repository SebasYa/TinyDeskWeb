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
                Response.Redirect("Login.aspx", true);
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
                lblUserWelcome.Text = $"{usuario.Nombre}";
            }
        }
    }
}