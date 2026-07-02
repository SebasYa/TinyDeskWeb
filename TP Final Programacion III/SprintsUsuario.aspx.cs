using dominio;
using negocio;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace TP_Final_Programacion_III
{
    public partial class SprintsUsuario : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            litMensaje.Text = "";
            if (!IsPostBack)
            {
                try
                {

                     Usuario userLogueado = (Usuario)Session["usuario"];
                     int idEmpresa = userLogueado.Empresa.Id;
                     AreaNegocio areaNegocio = new AreaNegocio();
                     EstadoNegocio estadoNegocio = new EstadoNegocio();
                     ProyectoNegocio proyectoNegocio = new ProyectoNegocio();
                     SprintNegocio sprintNegocio = new SprintNegocio();


                     if (Session["usuario"] == null)
                     {
                         Session.Add("error", "Debes iniciar sesión para acceder a esta pantalla.");
                         Response.Redirect("Login.aspx", false);
                         return;
                     }

                     if (userLogueado.Empresa == null)
                     {
                         Session.Add("error", "El usuario no tiene una empresa asignada.");
                         Response.Redirect("Default.aspx", false);
                         return;
                     }

                    CargarFiltros();
                    Session["SprintsSoloPendientes"] = true;
                    FiltrosVisibles = false;


                     //ListView View de Sprints
                     Session.Add("listaSprints", sprintNegocio.listar(userLogueado.Empresa.Id, userLogueado.Id));
                     lvSprints.DataSource = Session["listaSprints"];
                     lvSprints.DataBind();

                     if (Request.QueryString["id"] != null)
                     {
                         int idSprint = int.Parse(Request.QueryString["id"]);
                         Session["listaSprintsOriginal"] = sprintNegocio.listar(userLogueado.Empresa.Id, userLogueado.Id);
                         AplicarFiltrosSprints(true);

                         pnlListadoSprints.Visible = false;
                         pnlDetalleSprint.Visible = true;
                         pnlListado.Visible = false;
                         pnlFiltros.Visible = false;
                         Session["SprintsSoloPendientes"] = true;
                         FiltrosVisibles = false;
                         CargarFiltros();
                         CargarListado(userLogueado);
                         ActualizarVisibilidadFiltros();
                         CargarDetalleDelSprint(idSprint);
                         
                     }
                     else
                     {
                        CargarListado(userLogueado);
                        pnlListadoSprints.Visible = true;
                        pnlDetalleSprint.Visible = false;
                    }
                   
                }
                catch (Exception ex)
                {
                    Session.Add("error", ex.ToString());

                }
            }
        
        }

        private void CargarFiltros()
        {
            Usuario userLogueado = (Usuario)Session["usuario"];
            int idEmpresa = userLogueado.Empresa.Id;
            AreaNegocio areaNegocio = new AreaNegocio();

            ddlArea.DataSource = areaNegocio.listar(idEmpresa);
            ddlArea.DataValueField = "Id";
            ddlArea.DataTextField = "Nombre";
            ddlArea.DataBind();
            ddlArea.Items.Insert(0, new ListItem("Todas", ""));
        }

        private void CargarListado(Usuario usuario)
        {
            
            SprintNegocio negocio = new SprintNegocio();
            List<Sprint> lista = negocio.listar(usuario.Empresa.Id, usuario.Id);
            Session["listaSprintsOriginal"] = lista;
            AplicarFiltrosSprints(true);
        }


        private void AplicarFiltrosSprints(bool reiniciarPagina)
        {
            List<Sprint> lista = Session["listaSprintsOriginal"] as List<Sprint> ?? new List<Sprint>(); //aca trae 0 registros -- problema 

            bool soloPendientes = (bool)(Session["SprintsSoloPendientes"] ?? true);
            if (soloPendientes)
            {
                lista = lista.Where(x => x.Activo && !x.Estado.EsFinal).ToList();
            }

            if (!string.IsNullOrEmpty(ddlArea.SelectedValue) && ddlArea.SelectedValue != "0")
            {
                int idArea = int.Parse(ddlArea.SelectedValue);
                lista = lista.Where(x => x.Area.Id == idArea).ToList();
            }

            string filtro = txtFiltro.Text.Trim();

            if (!string.IsNullOrWhiteSpace(filtro)) lista = lista.Where(x => x.NumeroSprint.ToString().Contains(filtro) || 
                                                            (x.Proyecto != null && !string.IsNullOrWhiteSpace(x.Proyecto.Nombre) && 
                                                            x.Proyecto.Nombre.IndexOf(filtro, StringComparison.OrdinalIgnoreCase) >= 0) ||
                                                            (x.Area != null && !string.IsNullOrWhiteSpace(x.Area.Nombre) &&
                                                            x.Area.Nombre.IndexOf(filtro, StringComparison.OrdinalIgnoreCase) >= 0)).ToList();

            int dias = int.Parse(ddlProximoVencimiento.SelectedValue);

            if (soloPendientes && dias > 0)
            {
                DateTime hoy = DateTime.Today;
                DateTime limite = hoy.AddDays(dias);
                lista = lista.Where(x => x.FechaEstimadaFin.Date >= hoy && x.FechaEstimadaFin.Date <= limite).ToList();
            }

            lista = lista.OrderByDescending(x => x.FechaInicio).ToList();

            if (reiniciarPagina) dpSprints.SetPageProperties(0, dpSprints.PageSize, false);


            Session["listaSprintFiltrada"] = lista;
            dpSprints.Visible = lista.Count > dpSprints.PageSize;
            ActualizarControlesFiltroRapido(soloPendientes);
            lvSprints.DataSource = lista;
            lvSprints.DataBind();
        }
        protected void btnToggleFiltros_Click(object sender, EventArgs e)
        {
            FiltrosVisibles = !FiltrosVisibles;
            ActualizarVisibilidadFiltros();
        }
        private void ActualizarVisibilidadFiltros()
        {
            pnlFiltros.Visible = FiltrosVisibles;
            btnToggleFiltros.Text = FiltrosVisibles ? "Ocultar filtros" : "Mostrar filtros";
            btnToggleFiltros.CssClass = FiltrosVisibles ? "btn btn-secondary w-100" : "btn btn-outline-secondary w-100";
        }
        private void ActualizarControlesFiltroRapido(bool soloPendientes)
        {;
            List<Sprint> listaCompleta = Session["listaSprintsOriginal"] as List<Sprint> ?? new List<Sprint>();
            int cantidadPendientes = listaCompleta.Count(x => x.Activo && !x.Estado.EsFinal);

            btnFiltroPendientes.Text = "Pendientes (" + cantidadPendientes + ")";
            btnMostrarTodos.Text = "Todos";
            btnFiltroPendientes.CssClass = "btn btn-outline-primary flex-fill" + (soloPendientes ? " active" : "");
            btnMostrarTodos.CssClass = "btn btn-outline-secondary flex-fill" + (!soloPendientes ? " active" : "");
            ddlProximoVencimiento.Enabled = soloPendientes;
        }
        protected void btnFiltroPendientes_Click(object sender, EventArgs e)
        {
            Session["SprintsSoloPendientes"] = true; 
            AplicarFiltrosSprints(true);
        }
        protected void btnMostrarTodos_Click(object sender, EventArgs e)
        {
            Session["SprintsSoloPendientes"] = false;
            ddlProximoVencimiento.SelectedValue = "0";
            ddlArea.SelectedValue = ""; 
            AplicarFiltrosSprints(true);
        }
        protected void ddlProximoVencimiento_SelectedIndexChanged(object sender, EventArgs e)
        {
            Session["SprintsSoloPendientes"] = true;
            AplicarFiltrosSprints(true);
        }
        private bool FiltrosVisibles
        {
            get { return ViewState["FiltrosVisibles"] != null && (bool)ViewState["FiltrosVisibles"]; }
            set { ViewState["FiltrosVisibles"] = value; }
        }
        protected void btnAplicarFiltros_Click(object sender, EventArgs e)
        {
            AplicarFiltrosSprints(true);
        }
        protected void btnLimpiarFiltros_Click(object sender, EventArgs e)
        {
            txtFiltro.Text = "";
            ddlArea.SelectedValue = "";
            ddlOrden.SelectedValue = "fecha_asc";
            ddlProximoVencimiento.SelectedValue = "0";
            Session["SprintsSoloPendientes"] = true;
            AplicarFiltrosSprints(true);
        }


        public string GetClassEtiquetaEstado(object estadoNombre)
        {
            if (estadoNombre == null) return "badge text-bg-secondary";

            string estado = estadoNombre.ToString().ToLower().Trim();

            switch (estado)
            {
                case "en progreso":
                    return "badge text-bg-primary px-3 py-2 fw-semibold";
                case "finalizado":
                    return "badge text-bg-success px-3 py-2 fw-semibold";
                case "pendiente":
                    return "badge text-bg-warning px-3 py-2 fw-semibold";
                default:
                    return "badge text-bg-dark px-3 py-2 fw-semibold border";
            }
        }


        public string GetClassBarraProgreso(object estadoNombre)
        {
            if (estadoNombre == null) return "progress-bar bg-secondary";
            string estado = estadoNombre.ToString().ToLower().Trim();

            if (estado == "finalizado") return "progress-bar-striped bg-success";
            if (estado == "pendiente") return "progress-bar-striped bg-light";
            return "progress-bar-striped bg-primary";
        }


        public string GetDiasRestantesTexto(object fechaFinEstimada, object esFinal, object fechaFin = null)
        {
            DateTime fechaFinalizado = Convert.ToDateTime(fechaFin);
            if (esFinal != null && (bool)esFinal) return "Sprint cerrado - " + fechaFinalizado.ToString("dd/MM/yyyy");
            if (fechaFinEstimada == null) return "";

            DateTime fin = Convert.ToDateTime(fechaFinEstimada);
            TimeSpan diferencia = fin - DateTime.Today;

            if (diferencia.Days > 0)
                return $"({diferencia.Days} días restantes)";
            if (diferencia.Days == 0)
                return "(Termina hoy)";

            return $"({Math.Abs(diferencia.Days)} días de retraso)";
        }

        protected void ddlProyecto_SelectedIndexChanged(object sender, EventArgs e)
        {
        }

        protected void lvSprints_PagePropertiesChanging(object sender, PagePropertiesChangingEventArgs e)
        {

            dpSprints.SetPageProperties(e.StartRowIndex, e.MaximumRows, false);
            AplicarFiltrosSprints(false);
            
        }
        protected void txtFiltroSprints_TextChanged(object sender, EventArgs e)
        {
            AplicarFiltrosSprints(true);
        }


        /* protected void txtFiltroSprints_TextChanged(object sender, EventArgs e)
         {
             List<Sprint> lista = (List<Sprint>)Session["listaSprints"];
             List<Sprint> listaFiltrada = lista.FindAll(x => x.Proyecto.Nombre.ToUpper().Contains(txtFiltroSprints.Text.ToUpper()));

             lvSprints.DataSource = listaFiltrada;
             lvSprints.DataBind();
         }*/



        protected void lvSprints_ItemCommand(object sender, ListViewCommandEventArgs e)
        {
            if (e.CommandName == "VerDetalle")
            {
                string idSprint = e.CommandArgument.ToString();
                Response.Redirect($"SprintsUsuario.aspx?id={idSprint}");
            }


        }


        private void CargarDetalleDelSprint(int idSprint)
        {
            Usuario userLogueado = (Usuario)Session["usuario"];
            List<Sprint> listaSprints = (List<Sprint>)Session["listaSprints"];
            Sprint sprint = listaSprints?.Find(x => x.Id == idSprint);

            if (sprint != null)
            {
                //lblDetalleTituloSprint.Text = $"Detalle de Sprint {sprint.NumeroSprint}";
                //lblSprintProyectoArea.Text = $"{sprint.Proyecto.Nombre} / {sprint.Area.Nombre}";
                lblDetalleFechaInicio.Text = sprint.FechaInicio.ToString("dd/MM/yyyy");
                lblDetalleFechaEstimadaFin.Text = sprint.FechaEstimadaFin.ToString("dd/MM/yyyy");
                lblDetalleFechaFin.Text = sprint.FechaFin != null ? ((DateTime)sprint.FechaFin).ToString("dd/MM/yyyy") : "-";
                lblDetalleEstado.Text = sprint.Estado.Nombre;
                lblDetalleEstado.CssClass += " " + GetClassEtiquetaEstado(sprint.Estado.Nombre);


                TicketNegocio ticketNegocio = new TicketNegocio();
                Session["listaTicketsDelSprint"] = ticketNegocio.listarPorSprint(idSprint, userLogueado.Id );

                dpTicketsDelSprint.SetPageProperties(0, dpTicketsDelSprint.MaximumRows, false);

                lvTicketsDelSprint.DataSource = Session["listaTicketsDelSprint"];
                lvTicketsDelSprint.DataBind();
            }
        }

        protected void lvTicketsDelSprint_PagePropertiesChanging(object sender, PagePropertiesChangingEventArgs e)
        {

            dpTicketsDelSprint.SetPageProperties(e.StartRowIndex, e.MaximumRows, false);
            lvTicketsDelSprint.DataSource = Session["listaTicketsDelSprint"];
            lvTicketsDelSprint.DataBind();
        }



        public string GetClassEtiquetaPrioridad(object prioridad)
        {
            if (prioridad == null) return "badge text-bg-secondary text-uppercase";

            string p = prioridad.ToString().ToUpper().Trim();

            switch (p)
            {
                case "ALTA":
                    return "badge text-bg-danger text-uppercase px-3 py-2 fw-semibold";
                case "MEDIA":
                    return "badge text-bg-warning text-uppercase px-3 py-2 fw-semibold";
                case "BAJA":
                    return "badge text-bg-success text-uppercase px-3 py-2 fw-semibold";
                default:
                    return "badge text-bg-dark text-uppercase px-3 py-2 fw-semibold border";
            }
        }

  






    }



}
    
    
