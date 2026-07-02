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
                CargarDatosMenuUsuario(usuario);
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
        private void CargarDatosMenuUsuario(Usuario usuario)
        {
            lblUserWelcome.Text = usuario.Nombre;
            lblName_nav.Text = usuario.Nombre + " " + usuario.Apellido;
            lblNombreUsuarioNav.Text = "@" + usuario.NombreUsuario;
            lblEmpresa.Text = ObtenerEmpresaYArea(usuario);
            txtRol.Text = (string)(ObtenerPuestoYSeniority(usuario));
            lblEstadoUsuarioNav.Text = "Activo";
            ConfigurarImagenUsuario(usuario);
        }
        private void ConfigurarImagenUsuario(Usuario usuario)
        {
            string inicial = ObtenerInicialUsuario(usuario);
            string rutaImagen = Session["imagenUsuario"] as string;
            btnUserNav.Text = inicial;
            lblInicialUsuarioMenu.Text = inicial;

            if (!string.IsNullOrWhiteSpace(rutaImagen))
            {
                ConfigurarImagenBoton(rutaImagen);
                imgUsuarioMenu.ImageUrl = rutaImagen;
                imgUsuarioMenu.Visible = true;
                lblInicialUsuarioMenu.Visible = false;
            }
            else
            {
                LimpiarImagenBoton();
                imgUsuarioMenu.Visible = false;
                lblInicialUsuarioMenu.Visible = true;
            }
        }
        private void ConfigurarImagenBoton(string rutaImagen)
        {
            btnUserNav.Text = "";
            btnUserNav.Style["background-image"] = "url('" + rutaImagen + "')";
            btnUserNav.Style["background-size"] = "cover";
            btnUserNav.Style["background-position"] = "center";
            btnUserNav.Style["background-repeat"] = "no-repeat";
        }
        private void LimpiarImagenBoton()
        {
            btnUserNav.Style.Remove("background-image");
            btnUserNav.Style.Remove("background-size");
            btnUserNav.Style.Remove("background-position");
            btnUserNav.Style.Remove("background-repeat");
        }
        private string ObtenerInicialUsuario(Usuario usuario)
        {
            if (usuario == null || string.IsNullOrWhiteSpace(usuario.Nombre)) return "?";
            return usuario.Nombre.Substring(0, 1).ToUpper();
        }
        private string ObtenerEmpresaYArea(Usuario usuario)
        {
            string empresa = usuario.Empresa != null ? usuario.Empresa.Nombre : "Sin empresa";

            string area = usuario.Area != null ? usuario.Area.Nombre : "";

            if (string.IsNullOrWhiteSpace(area)) return empresa;
            return empresa + " · " + area;
        }
        private string ObtenerPuestoYSeniority(Usuario usuario)
        {
            string puesto = usuario.Puesto != null ? usuario.Puesto.Nombre : "Sin puesto";

            string seniority = usuario.Seniority != null ? usuario.Seniority.Nombre : "";

            if (string.IsNullOrWhiteSpace(seniority)) return puesto;
            return puesto + " · " + seniority;
        }
        protected void btnFooterAbout_Click(object sender, EventArgs e)
        {
            Response.Redirect("About.aspx", false);
            Context.ApplicationInstance.CompleteRequest();
        }
        protected void btnFooterContacto_Click(object sender, EventArgs e)
        {
            Response.Redirect("Contacto.aspx", false);
            Context.ApplicationInstance.CompleteRequest();
        }
    }
}