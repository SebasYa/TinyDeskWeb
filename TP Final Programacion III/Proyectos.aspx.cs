using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using dominio;
using negocio;

namespace TP_Final_Programacion_III
{
    public partial class Proyectos : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                int idEmpresa = ((Usuario)Session["Usuario"]).Empresa.Id;
                ProyectoNegocio negocio = new ProyectoNegocio();
                List<Proyecto> lista = negocio.listar(idEmpresa);
                repProyectos.DataSource = lista;
                repProyectos.DataBind();
            }
        }

        protected void btnProyecto_Click(object sender, EventArgs e)
        {

        }
    }
}