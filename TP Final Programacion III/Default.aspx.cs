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
    public partial class _Default : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            if (!IsPostBack)
            {
                try
                {
                    ProyectoNegocio proyectoNegocio = new ProyectoNegocio();
                    SprintNegocio sprintNegocio = new SprintNegocio();
                    TicketNegocio ticketNegocio = new TicketNegocio();
                    int idEmpresa = ((Usuario)Session["Usuario"]).Empresa.Id;
                    lblProyectosActivos.Text = proyectoNegocio.ContarActivos(idEmpresa).ToString();
                    lblSprintsEnCurso.Text = sprintNegocio.ContarEnCurso(idEmpresa).ToString();
                    lblTicketsAbiertos.Text = ticketNegocio.ContarAbiertos(idEmpresa).ToString();

                }
                catch (Exception ex)
                {

                    throw ex;
                }
            }
        }

        protected void btnNuevoProyecto_Click(object sender, EventArgs e)
        {

        }
        protected void btnNuevoSprint_Click(object sender, EventArgs e)
        {

        }
        protected void btnNuevoTicket_Click(object sender, EventArgs e)
        {

        }

        

            
    }
}