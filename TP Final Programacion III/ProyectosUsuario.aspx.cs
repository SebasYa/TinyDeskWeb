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
    public partial class ProyectosUsuario : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try
                {
                    Usuario usuario = (Usuario)Session["usuario"];

                    if (Request.QueryString["id"] != null)
                    {
                        int idProyecto = int.Parse(Request.QueryString["id"]);
                        CargarDetalleProyecto(idProyecto, usuario);
                    }
                    else
                    {
                        CargarListadoProyectos(usuario.Empresa.Id);
                    }
                }
                catch (Exception ex)
                {
                    Session["error"] = ex.ToString();

                    MostrarError("Ocurrió un error al cargar los proyectos.");
                }
            }
        }
        private void CargarListadoProyectos(int idEmpresa)
        {
            pnlListadoProyectos.Visible = true;
            pnlDetalleProyecto.Visible = false;
            ProyectoNegocio negocio = new ProyectoNegocio();
            int idUsuario = ((Usuario)Session["usuario"]).Id;
            List<Proyecto> lista = negocio.listar(idEmpresa, idUsuario);

            bool mostrarFinalizados = false;

            if (Session["FiltroProyectosUsuarioFinalizados"] != null)
            {
                mostrarFinalizados = (bool)Session["FiltroProyectosUsuarioFinalizados"];
            }

            if (mostrarFinalizados)
            {
                lista = lista.FindAll(x => !x.Activo);

                btnFiltroActivos.CssClass = "btn btn-outline-primary";

                btnFiltroFinalizados.CssClass = "btn btn-secondary";
            }
            else
            {
                lista = lista.FindAll(x => x.Activo);

                btnFiltroActivos.CssClass = "btn btn-primary";

                btnFiltroFinalizados.CssClass = "btn btn-outline-secondary";
            }

            lvProyectos.DataSource = lista;
            lvProyectos.DataBind();

            dpProyectos.Visible = lista.Count > dpProyectos.PageSize;
        }
        private void CargarDetalleProyecto(int idProyecto, Usuario usuario)
        {
            pnlListadoProyectos.Visible = false;
            pnlDetalleProyecto.Visible = true;

            int idEmpresa = usuario.Empresa.Id;
            int idUsuario = usuario.Id;

            ProyectoNegocio proyectoNegocio = new ProyectoNegocio();

            List<Proyecto> proyectosAsignados = proyectoNegocio.listar(idEmpresa, idUsuario);

            bool tieneAcceso = proyectosAsignados.Exists(x => x.Id == idProyecto);

            if (!tieneAcceso)
            {
                Response.Redirect("ProyectosUsuario.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            Proyecto proyecto =
                proyectoNegocio.BuscarPorId(idProyecto, idEmpresa);

            if (proyecto == null)
            {
                Response.Redirect("ProyectosUsuario.aspx", false);
                Context.ApplicationInstance.CompleteRequest();
                return;
            }

            lblDetalleNombre.Text = proyecto.Nombre;

            lblDetalleEstado.Text = proyecto.Estado.Nombre;

            lblDetalleDescripcion.Text = proyecto.Descripcion;

            lblDetalleFechaInicio.Text = proyecto.FechaInicio.ToString("dd/MM/yyyy");

            lblDetalleFechaEstimadaFin.Text = proyecto.FechaEstimadaFin.ToString("dd/MM/yyyy");

            lblDetalleFechaFin.Text = proyecto.FechaFin.HasValue ? proyecto.FechaFin.Value.ToString("dd/MM/yyyy") : "-";

            lblDetalleActivo.Text = proyecto.Activo ? "Proyecto activo" : "Proyecto finalizado";

            lblDetalleActivo.CssClass = proyecto.Activo ? "badge rounded-pill bg-success-subtle text-success" : "badge rounded-pill bg-secondary-subtle text-secondary";

            SprintNegocio sprintNegocio = new SprintNegocio();

            List<Sprint> SprintsAsignados = sprintNegocio.listarPorProyecto(idProyecto, idEmpresa, idUsuario);
            List<Sprint> sprintsUsuario = SprintsAsignados.OrderByDescending(x => x.Activo)
                                                             .ThenBy(x => x.FechaInicio)
                                                             .ThenBy(x => x.FechaEstimadaFin)
                                                             .ThenBy(x => x.NumeroSprint)
                                                             .ToList();

            lvSprintsProyecto.DataSource = sprintsUsuario;
            lvSprintsProyecto.DataBind();
            dpSprintsProyecto.Visible = sprintsUsuario.Count > dpSprintsProyecto.PageSize;
        }
        protected void lvProyectos_ItemDataBound(object sender, ListViewItemEventArgs e)
        {
            if (e.Item.ItemType == ListViewItemType.DataItem)
            {
                ListViewDataItem item = (ListViewDataItem)e.Item;
                Proyecto proyecto = (Proyecto)item.DataItem;
                Literal litFechaFin = (Literal)e.Item.FindControl("litFechaFin");

                if (litFechaFin != null && proyecto.FechaFin.HasValue)
                {
                    litFechaFin.Text = "<div class='d-flex align-items-center text-muted small mb-2'>" + 
                        "<i class='bi bi-calendar-x me-2'></i>" +
                        "<span>Finalizado: " +
                        proyecto.FechaFin.Value.ToString("dd/MM/yyyy") +
                        "</span></div>";

                    litFechaFin.Visible = true;
                }
            }
        }
        protected void lvProyectos_PagePropertiesChanging(object sender, PagePropertiesChangingEventArgs e)
        {
            dpProyectos.SetPageProperties(e.StartRowIndex, e.MaximumRows, false);
            Usuario usuario = (Usuario)Session["usuario"];
            CargarListadoProyectos(usuario.Empresa.Id);
        }
        protected void lvSprintsProyecto_PagePropertiesChanging(object sender, PagePropertiesChangingEventArgs e)
        {
            dpSprintsProyecto.SetPageProperties(e.StartRowIndex, e.MaximumRows, false);
            int idProyecto = Convert.ToInt32(Request.QueryString["id"]);
            Usuario usuario = (Usuario)Session["usuario"];
            CargarDetalleProyecto(idProyecto, usuario);
        }
        protected void btnVerProyecto_Click(object sender, EventArgs e)
        {
            LinkButton boton = (LinkButton)sender;
            int idProyecto = Convert.ToInt32(boton.CommandArgument);
            Response.Redirect("ProyectosUsuario.aspx?id=" + idProyecto, false);
            Context.ApplicationInstance.CompleteRequest();
        }
        protected void btnVolverProyectos_Click(object sender, EventArgs e)
        {
            Response.Redirect("ProyectosUsuario.aspx", false);
            Context.ApplicationInstance.CompleteRequest();
        }
        protected void btnVerSprint_Click(object sender, EventArgs e)
        {
            LinkButton boton = (LinkButton)sender;
            int idSprint = Convert.ToInt32(boton.CommandArgument);
            Response.Redirect("SprintsUsuario.aspx?id=" + idSprint, false);
            Context.ApplicationInstance.CompleteRequest();
        }
        protected void btnFiltroActivos_Click(object sender, EventArgs e)
        {
            dpProyectos.SetPageProperties(0, 6, false);
            Session["FiltroProyectosUsuarioFinalizados"] = false;
            Usuario usuario = (Usuario)Session["usuario"];
            CargarListadoProyectos(usuario.Empresa.Id);
        }
        protected void btnFiltroFinalizados_Click(object sender, EventArgs e)
        {
            dpProyectos.SetPageProperties(0, 6, false);
            Session["FiltroProyectosUsuarioFinalizados"] = true;
            Usuario usuario = (Usuario)Session["usuario"];
            CargarListadoProyectos(usuario.Empresa.Id);
        }
        public string ObtenerIconoEstadoProyecto(object estadoObj)
        {
            string estado = estadoObj != null ? estadoObj.ToString() : "";
            string estadoMayuscula = estado.ToUpper();

            if (estadoMayuscula == "FINALIZADO")
            {
                return "<span class='badge rounded-pill bg-danger-subtle text-danger'>" + 
                    "<i class='bi bi-check-circle-fill me-1'></i>" +
                    estado +
                    "</span>";
            }

            if (estadoMayuscula == "PENDIENTE")
            {
                return "<span class='badge rounded-pill bg-warning-subtle text-warning'>" +
                    "<i class='bi bi-clock-fill me-1'></i>" +
                    estado +
                    "</span>";
            }

            if (estadoMayuscula == "EN PROGRESO")
            {
                return "<span class='badge rounded-pill bg-primary-subtle text-primary'>" +
                    "<i class='bi bi-play-circle-fill me-1'></i>" +
                    estado +
                    "</span>";
            }

            return "<span class='badge rounded-pill bg-info-subtle text-info'>" +
                "<i class='bi bi-tag-fill me-1'></i>" +
                estado +
                "</span>";
        }
        private void MostrarError(string mensaje)
        {
            litMensaje.Text =
                "<div class='alert alert-danger'>" +
                mensaje +
                "</div>";
        }
    }
}