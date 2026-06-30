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
    public partial class About : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }
        protected void btnInicio_Click(object sender, EventArgs e)
        {
            Response.Redirect("Login.aspx", false);
            Context.ApplicationInstance.CompleteRequest();
            return;
        }
        protected void btnIrAbout_Click(object sender, EventArgs e)
        {
            Response.Redirect("About.aspx", false);
            Context.ApplicationInstance.CompleteRequest();
        }
        protected void btnIrContacto_Click(object sender, EventArgs e)
        {
            Response.Redirect("Contacto.aspx", false);
            Context.ApplicationInstance.CompleteRequest();
        }
    }
}