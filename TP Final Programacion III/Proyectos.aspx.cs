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
                /*
                ProyectoNegocio negocio = new ProyectoNegocio();
                List<Proyecto> lista = negocio.listar();
                repProyectos.DataSource = lista;
                repProyectos.DataBind();
                */
                List<Proyecto> lista = new List<Proyecto>();

                Proyecto proyecto = new Proyecto();
                proyecto.Id = 1;
                proyecto.Nombre = "TinyDesk Web";
                proyecto.Descripcion = "Proyecto de ejemplo para mostrar la ficha.";
                proyecto.FechaInicio = DateTime.Now;
                proyecto.FechaEstimadaFin = DateTime.Now;
                proyecto.FechaFin = null;
                proyecto.Activo = true;

                Estado estado = new Estado();
                estado.Id = 1;
                estado.Nombre = "En progreso";
                estado.EsFinal = false;
                estado.EsSistema = true;

                proyecto.Estado = estado;

                lista.Add(proyecto);

                repProyectos.DataSource = lista;
                repProyectos.DataBind();
            }
        }

        protected void btnProyecto_Click(object sender, EventArgs e)
        {

        }
    }
}