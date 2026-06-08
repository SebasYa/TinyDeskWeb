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
    public partial class Usuarios : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Seguridad.EsAdmin(Session["usuario"]))
            {
                Response.Redirect("Default.aspx", false);
                return;
            }
            if (!IsPostBack)
            {
                try
                {
                    int userLogueado = ((Usuario)Session["usuario"]).Empresa.Id;
                    UsuarioNegocio negocio = new UsuarioNegocio();
                    dgvUsuarios.DataSource = negocio.listar(userLogueado);
                    dgvUsuarios.DataBind();
                }
                catch (Exception ex)
                {
                    Session.Add("error", ex.ToString());
                    Response.Redirect("Default.aspx", false);
                }
            }
        }

        protected void dgvUsuarios_PageIndexChanging(object obj, GridViewPageEventArgs e)
        {
            dgvUsuarios.PageIndex = e.NewPageIndex;
            dgvUsuarios.DataBind();
        } 

        protected void dgvUsuarios_SelectedIndexChanged(object obj, EventArgs e)
        {
            string id = dgvUsuarios.SelectedDataKey.Value.ToString();
            Response.Redirect("CrearUsuario.aspx?id=" + id);
        }
    }
}