using dominio;
using negocio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI.WebControls;

namespace TP_Final_Programacion_III
{
    public partial class Proyectos : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try
                {
                    int idEmpresa = ((Usuario)Session["usuario"]).Empresa.Id;

                    CargarEstadosProyecto(idEmpresa);

                    if (Request.QueryString["id"] != null)
                    {
                        int idProyecto = int.Parse(Request.QueryString["id"]);
                        CargarDetalleProyecto(idProyecto, idEmpresa);
                    }
                    else
                    {
                        CargarListadoProyectos(idEmpresa);
                    }
                }
                catch (Exception ex)
                {
                    Session.Add("error", ex.ToString());
                    MostrarErrorProyecto("Ocurrio un error al cargar el formulario.");
                }
            }
        }
        private void CargarListadoProyectos(int idEmpresa)
        {
            pnlListadoProyectos.Visible = true;
            pnlDetalleProyecto.Visible = false;
            txtFechaInicioProyecto.Text = DateTime.Today.ToString("yyyy-MM-dd");
            txtFechaInicioProyecto.Enabled = false;

            ProyectoNegocio negocio = new ProyectoNegocio();
            List<Proyecto> lista = negocio.listar(idEmpresa);
            bool mostrarFinalizados = false;

            if (Session["FiltroProyectosFinalizados"] != null)
            {
                mostrarFinalizados = (bool)Session["FiltroProyectosFinalizados"];
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

            string filtro = txtFiltroProyecto.Text.Trim();
            if (!string.IsNullOrWhiteSpace(filtro))
            {
                lista = lista.Where(x =>
                    (!string.IsNullOrWhiteSpace(x.Nombre) && x.Nombre.IndexOf(filtro, StringComparison.OrdinalIgnoreCase) >= 0) ||
                    (!string.IsNullOrWhiteSpace(x.Descripcion) && x.Descripcion.IndexOf(filtro, StringComparison.OrdinalIgnoreCase) >= 0)
                ).ToList();
            }
            lvProyectos.DataSource = lista;
            lvProyectos.DataBind();
            dpProyectos.Visible = lista.Count > dpProyectos.PageSize;

            lblModalProyectoTitulo.Text = "Nuevo Proyecto";
            btnGuardarProyecto.Text = "Guardar Proyecto";
        }
        private void CargarDetalleProyecto(int idProyecto, int idEmpresa)
        {
            pnlListadoProyectos.Visible = false;
            pnlDetalleProyecto.Visible = true;

            ProyectoNegocio proyectoNegocio = new ProyectoNegocio();
            Proyecto proyecto = proyectoNegocio.BuscarPorId(idProyecto, idEmpresa);
            if (proyecto == null)
            {
                Response.Redirect("Proyectos.aspx", false);
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
            phFinalizarProyecto.Visible = proyecto.Activo;
            lblFinalizarProyectoNombre.Text = proyecto.Nombre;
            litFinalizarProyectoConfirmacion.Text = proyecto.Nombre.ToUpper();
            txtConfirmarFinalizarProyecto.Text = "";

            txtNombreProyecto.Text = proyecto.Nombre;
            txtDescripcionProyecto.Text = proyecto.Descripcion;
            txtFechaInicioProyecto.Text = proyecto.FechaInicio.ToString("yyyy-MM-dd");
            txtFechaInicioProyecto.Enabled = false;
            txtFechaEstimadaFinProyecto.Text = proyecto.FechaEstimadaFin.ToString("yyyy-MM-dd");
            if (ddlEstadoProyecto.Items.FindByValue(proyecto.Estado.Id.ToString()) != null)
            {
                ddlEstadoProyecto.SelectedValue = proyecto.Estado.Id.ToString();
            }
            else
            {
                ddlEstadoProyecto.SelectedIndex = 0;
            }
            lblModalProyectoTitulo.Text = "Editar Proyecto";
            btnGuardarProyecto.Text = "Guardar Cambios";

            SprintNegocio sprintNegocio = new SprintNegocio();
            List<Sprint> sprints = sprintNegocio.listarPorProyecto(idProyecto, idEmpresa).OrderByDescending(x => x.Activo)
                                                                                         .ThenBy(x => x.FechaInicio)
                                                                                         .ThenBy(x => x.FechaEstimadaFin)
                                                                                         .ThenBy(x => x.NumeroSprint)
                                                                                         .ToList();

            lvSprintsProyecto.DataSource = sprints;
            lvSprintsProyecto.DataBind();
            dpSprintsProyecto.Visible = sprints.Count > dpSprintsProyecto.PageSize;
        }
        private void CargarEstadosProyecto(int idEmpresa)
        {
            EstadoNegocio estadoNegocio = new EstadoNegocio();
            List<Estado> estados = estadoNegocio.listar(idEmpresa);
            Session["listaEstadosProyecto"] = estados;
            ddlEstadoProyecto.DataSource = estados.FindAll(x => !x.EsFinal);
            ddlEstadoProyecto.DataValueField = "Id";
            ddlEstadoProyecto.DataTextField = "Nombre";
            ddlEstadoProyecto.DataBind();
            ddlEstadoProyecto.Items.Insert(0, new ListItem("Seleccione Estado..", ""));
        }
        protected void btnGuardarProyecto_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtNombreProyecto.Text) ||
                string.IsNullOrWhiteSpace(txtFechaEstimadaFinProyecto.Text) ||
                string.IsNullOrWhiteSpace(ddlEstadoProyecto.SelectedValue))
            {
                MostrarErrorProyecto("Completá todos los campos obligatorios.");
                return;
            }
            bool esEdicion = Request.QueryString["id"] != null;
            int idProyecto = esEdicion ? int.Parse(Request.QueryString["id"]) : 0;
            DateTime fechaInicio;

            if (esEdicion)
            {
                int idEmpresa = ((Usuario)Session["usuario"]).Empresa.Id;

                ProyectoNegocio negocioFecha = new ProyectoNegocio();
                Proyecto proyectoActual = negocioFecha.BuscarPorId(idProyecto, idEmpresa);

                if (proyectoActual == null)
                {
                    MostrarErrorProyecto("No se encontro el proyecto solicitado.");
                    return;
                }

                fechaInicio = proyectoActual.FechaInicio;
            }
            else
            {
                fechaInicio = DateTime.Today;
            }

            DateTime fechaEstimadaFin = Convert.ToDateTime(txtFechaEstimadaFinProyecto.Text);
            DateTime fechaMaxima = fechaInicio.AddYears(10);

            if (fechaEstimadaFin.Date > fechaMaxima.Date)
            {
                MostrarErrorProyecto("La fecha estimada final no debe superar los 10 años desde la fecha inicial.");
                return;
            }

            if (fechaEstimadaFin.Date < fechaInicio.Date)
            {
                MostrarErrorProyecto("La fecha estimada final no puede ser anterior a la fecha de inicio.");
                return;
            }

            try
            {
                ProyectoNegocio proyectoNegocio = new ProyectoNegocio();
                Usuario userLogueado = (Usuario)Session["usuario"];

                Proyecto proyecto = new Proyecto();
                proyecto.Nombre = txtNombreProyecto.Text;
                proyecto.Descripcion = txtDescripcionProyecto.Text;
                proyecto.FechaInicio = fechaInicio;
                proyecto.FechaEstimadaFin = fechaEstimadaFin;

                proyecto.Estado = new Estado();
                proyecto.Estado.Id = int.Parse(ddlEstadoProyecto.SelectedValue);


                proyecto.Activo = true;
                proyecto.FechaFin = null;
                proyecto.Empresa = new Empresa();
                proyecto.Empresa.Id = userLogueado.Empresa.Id;

                if (esEdicion)
                {
                    proyecto.Id = idProyecto;
                    proyectoNegocio.actualizar(proyecto);

                    MostrarExitoProyecto("El Proyecto se modificó perfectamente.");
                    CargarDetalleProyecto(proyecto.Id, userLogueado.Empresa.Id);
                }
                else
                {
                    proyectoNegocio.agregarProyecto(proyecto);

                    MostrarExitoProyecto("El Proyecto se guardó perfectamente.");

                    txtNombreProyecto.Text = "";
                    txtDescripcionProyecto.Text = "";
                    txtFechaInicioProyecto.Text = DateTime.Today.ToString("yyyy-MM-dd");
                    txtFechaEstimadaFinProyecto.Text = "";
                    ddlEstadoProyecto.SelectedIndex = 0;

                    CargarListadoProyectos(userLogueado.Empresa.Id);
                }
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                MostrarErrorProyecto("Ocurrió un error al guardar el proyecto.");
            }
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
            dpSprintsProyecto.SetPageProperties( e.StartRowIndex, e.MaximumRows, false);
            int idProyecto = int.Parse(Request.QueryString["id"]);
            Usuario usuario = (Usuario)Session["usuario"];
            CargarDetalleProyecto(idProyecto, usuario.Empresa.Id);
        }
        private void MostrarErrorProyecto(string mensaje)
        {
            litMensaje.Text = $@"<div class='alert alert-danger alert-dismissible fade show' role='alert'>
                                    <strong>Error:</strong> {mensaje}
                                    <button type='button' class='btn-close' data-bs-dismiss='alert' aria-label='Close'></button>
                                </div>";
        }
        private void MostrarExitoProyecto(string mensaje)
        {
            litMensaje.Text = $@"<div class='alert alert-success alert-dismissible fade show' role='alert'>
                                    <strong>¡Éxito!</strong> {mensaje}
                                    <button type='button' class='btn-close' data-bs-dismiss='alert' aria-label='Close'></button>
                                </div>";
        }
        protected void btnConfirmarFinalizarProyecto_Click(object sender, EventArgs e)
        {
            try
            {
                if (Request.QueryString["id"] == null)
                {
                    MostrarErrorProyecto("No se encontró el proyecto solicitado.");
                    return;
                }

                int idProyecto = int.Parse(Request.QueryString["id"]);
                Usuario userLogueado = (Usuario)Session["usuario"];

                ProyectoNegocio proyectoNegocio = new ProyectoNegocio();
                Proyecto proyecto = proyectoNegocio.BuscarPorId(idProyecto, userLogueado.Empresa.Id);

                if (proyecto == null)
                {
                    MostrarErrorProyecto("No se encontró el proyecto solicitado.");
                    return;
                }

                string nombreEsperado = proyecto.Nombre.ToUpper();
                string nombreIngresado = txtConfirmarFinalizarProyecto.Text.Trim();

                if (nombreIngresado != nombreEsperado)
                {
                    MostrarErrorProyecto("El nombre ingresado no coincide. El proyecto no fue finalizado.");
                    CargarDetalleProyecto(idProyecto, userLogueado.Empresa.Id);
                    return;
                }

                proyectoNegocio.BajaLogica(idProyecto);

                MostrarExitoProyecto("El proyecto, sus sprints y sus tickets activos se finalizaron correctamente.");
                CargarDetalleProyecto(idProyecto, userLogueado.Empresa.Id);
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                MostrarErrorProyecto("Ocurrió un error al finalizar el proyecto.");
            }
        }
        protected void btnFiltroActivos_Click(object sender, EventArgs e)
        {
            dpProyectos.SetPageProperties(0, 6, false);
            Session["FiltroProyectosFinalizados"] = false;
            Usuario userLogueado = (Usuario)Session["usuario"];
            CargarListadoProyectos(userLogueado.Empresa.Id);
        }
        protected void btnFiltroFinalizados_Click(object sender, EventArgs e)
        {
            dpProyectos.SetPageProperties(0, 6, false);
            Session["FiltroProyectosFinalizados"] = true;
            Usuario userLogueado = (Usuario)Session["usuario"];
            CargarListadoProyectos(userLogueado.Empresa.Id);
        }
        protected void btnVerProyecto_Click(object sender, EventArgs e)
        {
            LinkButton boton = (LinkButton)sender;
            int idProyecto = Convert.ToInt32(boton.CommandArgument);
            Response.Redirect("Proyectos.aspx?id=" + idProyecto, false);
            Context.ApplicationInstance.CompleteRequest();
        }
        protected void btnVerSprint_Click(object sender, EventArgs e)
        {
            LinkButton boton = (LinkButton)sender;
            int idSprint = Convert.ToInt32(boton.CommandArgument);
            Response.Redirect("Sprints.aspx?id=" + idSprint, false);
            Context.ApplicationInstance.CompleteRequest();
        }
        public string ObtenerIconoEstadoProyecto(object estadoObj)
        {
            string estado = estadoObj != null ? estadoObj.ToString() : "";
            string estadoMayuscula = estado.ToUpper();

            if (estadoMayuscula == "FINALIZADO")
            {
                return "<span class='badge rounded-pill bg-danger-subtle text-danger'>" +
                       "<i class='bi bi-check-circle-fill me-1'></i>" + estado +
                       "</span>";
            }

            if (estadoMayuscula == "PENDIENTE")
            {
                return "<span class='badge rounded-pill bg-warning-subtle text-warning'>" +
                       "<i class='bi bi-clock-fill me-1'></i>" + estado +
                       "</span>";
            }

            if (estadoMayuscula == "EN PROGRESO")
            {
                return "<span class='badge rounded-pill bg-primary-subtle text-primary'>" +
                       "<i class='bi bi-play-circle-fill me-1'></i>" + estado +
                       "</span>";
            }

            return "<span class='badge rounded-pill bg-info-subtle text-info'>" +
                   "<i class='bi bi-tag-fill me-1'></i>" + estado +
                   "</span>";
        }
        protected void btnBuscarProyecto_Click(object sender, EventArgs e)
        {
            dpProyectos.SetPageProperties(0, dpProyectos.PageSize, false);
            Usuario usuario = (Usuario)Session["usuario"];
            CargarListadoProyectos(usuario.Empresa.Id);
        }
        protected void btnLimpiarFiltroProyecto_Click(object sender, EventArgs e)
        {
            txtFiltroProyecto.Text = "";
            dpProyectos.SetPageProperties(0, dpProyectos.PageSize, false);
            Usuario usuario = (Usuario)Session["usuario"];
            CargarListadoProyectos(usuario.Empresa.Id);
        }
    }
}