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
    public partial class UsuarioDefault : System.Web.UI.Page
    {
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
                CargarDatosUsuario(usuario);
            }
        }
        protected void btnSprintsActivosUsuario_Click(object sender, EventArgs e)
        {

        }
        protected void btnSprintsNoActivosUsuario_Click(object sender, EventArgs e)
        {

        }
        private void CargarDatosUsuario(Usuario usuario)
        {
            int hora = DateTime.Now.Hour;
            string saludo;
            if (hora >= 6 && hora < 12) saludo = "Buen Día";
            else if (hora >= 12 && hora < 19) saludo = "Buenas Tardes";
            else saludo = "Buenas Noches";

            lblBienvenida.Text = saludo + ": " + usuario.Nombre + " " + usuario.Apellido;
            lblAreaUsuario.Text = usuario.Area.Nombre;
            lblRolUsuario.Text = usuario.Puesto.Nombre;
            lblSeniorityUsuario.Text = usuario.Seniority != null ? usuario.Seniority.Nombre : "-";
        }
    }
}