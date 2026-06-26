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
                    CargarFiltrosAvanzados();
                    int idEmpresa = ((Usuario)Session["usuario"]).Empresa.Id;
                    UsuarioNegocio negocio = new UsuarioNegocio();
                    List<Usuario> lista = negocio.listar(idEmpresa);
                    Session["listaUsuarios"] = lista;
                    dgvUsuarios.DataSource = lista;
                    dgvUsuarios.DataBind();
                }
                catch (Exception ex)
                {
                    Session.Add("error", ex.ToString());
                    Response.Redirect("Default.aspx", false);
                }
            }
        }
        public string ObtenerIconoInvitacion(object idObj, object emailVerificadoObj)
        {
            try
            {
                int idUsuario = Convert.ToInt32(idObj);
                bool emailVerificado = Convert.ToBoolean(emailVerificadoObj);
                if (emailVerificado)
                {
                    return "<span class='text-success' title='Invitación aceptada'>" +
                           "<i class='bi bi-check-circle-fill'></i>" +
                           "</span>";
                }
                UsuarioTokenNegocio tokenNegocio = new UsuarioTokenNegocio();
                EstadoTokenUsuario estado = tokenNegocio.ObtenerEstadoToken(idUsuario, TipoTokenUsuario.CrearPassword);

                if (estado == EstadoTokenUsuario.Pendiente)
                {
                    return "<span class='text-warning' title='Invitación pendiente. El usuario todavía no creó su contraseña.'>" +
                           "<i class='bi bi-hourglass-split'></i>" +
                           "</span>";
                }

                return "<a href='CrearUsuario.aspx?id=" + idUsuario + "' class='text-danger' title='La invitación venció. Entrá para reenviarla.'>" +
                       "<i class='bi bi-exclamation-circle-fill'></i>" +
                       "</a>";
            }
            catch
            {
                return "<span class='text-muted' title='No se pudo verificar la invitación'>" +
                       "<i class='bi bi-question-circle-fill'></i>" +
                       "</span>";
            }
        }
        protected void dgvUsuarios_PageIndexChanging(object obj, GridViewPageEventArgs e)
        {
            try
            {
                dgvUsuarios.PageIndex = e.NewPageIndex;
                dgvUsuarios.DataSource = Session["listaUsuarios"];
                dgvUsuarios.DataBind();
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                Response.Redirect("Usuarios.aspx", false);
            }
        }
        protected void dgvUsuarios_SelectedIndexChanged(object obj, EventArgs e)
        {
            try
            {
                string id = dgvUsuarios.SelectedDataKey.Value.ToString();
                Response.Redirect("CrearUsuario.aspx?id=" + id, false);
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                Response.Redirect("Usuarios.aspx", false);
            }
        }
        protected void btnBuscarUsuario_Click(object sender, EventArgs e)
        {
            try
            {
                int idEmpresa = ((Usuario)Session["usuario"]).Empresa.Id;
                UsuarioNegocio negocio = new UsuarioNegocio();
                List<Usuario> lista = negocio.listar(idEmpresa, 0, txtFiltroSimple.Text);

                Session["listaUsuarios"] = lista;
                dgvUsuarios.PageIndex = 0;
                dgvUsuarios.DataSource = lista;
                dgvUsuarios.DataBind();

                pnlFiltroAvanzado.Visible = chkFiltroAvanzado.Checked;
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                Response.Redirect("Usuarios.aspx", false);
            }
        }
        protected void btnLimpiarFiltro_Click(object sender, EventArgs e)
        {
            try
            {
                txtFiltroSimple.Text = "";
                int idEmpresa = ((Usuario)Session["usuario"]).Empresa.Id;
                UsuarioNegocio negocio = new UsuarioNegocio();
                List<Usuario> lista = negocio.listar(idEmpresa);

                Session["listaUsuarios"] = lista;
                dgvUsuarios.PageIndex = 0;
                dgvUsuarios.DataSource = lista;
                dgvUsuarios.DataBind();
                pnlFiltroAvanzado.Visible = chkFiltroAvanzado.Checked;
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                Response.Redirect("Usuarios.aspx", false);
            }
        }
        protected void chkFiltroAvanzado_ServerChange(object sender, EventArgs e)
        {
            bool avanzadoActivo = chkFiltroAvanzado.Checked;

            if (avanzadoActivo)
            {
                txtFiltroSimple.Text = "";
                txtFiltroSimple.CssClass = "form-control bg-secondary-subtle text-secondary border-secondary-subtle";
            }
            else
            {
                txtFiltroSimple.CssClass = "form-control";
            }
            txtFiltroSimple.Enabled = !avanzadoActivo;
            pnlFiltroAvanzado.Visible = avanzadoActivo;
            btnBuscarUsuario.Visible = !avanzadoActivo;
            btnLimpiarFiltro.Visible = !avanzadoActivo;

        }
        protected void btnAplicarFiltroAvanzado_Click(object sender, EventArgs e)
        {
            try
            {
                txtFiltroSimple.Text = "";

                int idEmpresa = ((Usuario)Session["usuario"]).Empresa.Id;

                int idArea = int.Parse(ddlFiltroArea.SelectedValue);
                int idPuesto = int.Parse(ddlFiltroPuesto.SelectedValue);
                int idSeniority = int.Parse(ddlFiltroSeniority.SelectedValue);
                int estado = int.Parse(ddlFiltroEstado.SelectedValue);
                string permiso = ddlFiltroPermiso.SelectedValue;
                if (idArea == 0 && idPuesto == 0 && idSeniority == 0 && estado == -1 && permiso == "") return;

                UsuarioNegocio negocio = new UsuarioNegocio();
                List<Usuario> lista = negocio.listarAvanzado(idEmpresa, idArea, idPuesto, idSeniority, estado, permiso);

                Session["listaUsuarios"] = lista;

                dgvUsuarios.PageIndex = 0;
                dgvUsuarios.DataSource = lista;
                dgvUsuarios.DataBind();

                chkFiltroAvanzado.Checked = true;
                pnlFiltroAvanzado.Visible = true;
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                Response.Redirect("Usuarios.aspx", false);
            }
        }
        protected void btnLimpiarFiltroAvanzado_Click(object sender, EventArgs e)
        {
            try
            {
                txtFiltroSimple.Text = "";
                ddlFiltroArea.SelectedValue = "0";
                ddlFiltroPuesto.SelectedValue = "0";
                ddlFiltroSeniority.SelectedValue = "0";
                ddlFiltroEstado.SelectedValue = "-1";
                ddlFiltroPermiso.SelectedValue = "";

                int idEmpresa = ((Usuario)Session["usuario"]).Empresa.Id;

                UsuarioNegocio negocio = new UsuarioNegocio();

                List<Usuario> lista = negocio.listar(idEmpresa);

                Session["listaUsuarios"] = lista;

                dgvUsuarios.PageIndex = 0;
                dgvUsuarios.DataSource = lista;
                dgvUsuarios.DataBind();

                chkFiltroAvanzado.Checked = true;
                pnlFiltroAvanzado.Visible = true;
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                Response.Redirect("Usuarios.aspx", false);
            }
        }
        private void CargarFiltrosAvanzados()
        {
            Usuario usuario = (Usuario)Session["usuario"];
            int idEmpresa = usuario.Empresa.Id;

            AreaNegocio areaNegocio = new AreaNegocio();
            PuestoNegocio puestoNegocio = new PuestoNegocio();
            SeniorityNegocio seniorityNegocio = new SeniorityNegocio();

            ddlFiltroArea.DataSource = areaNegocio.listar(idEmpresa);
            ddlFiltroArea.DataValueField = "Id";
            ddlFiltroArea.DataTextField = "Nombre";
            ddlFiltroArea.DataBind();
            ddlFiltroArea.Items.Insert(0, new ListItem("Todas", "0"));

            ddlFiltroPuesto.DataSource = puestoNegocio.listar(idEmpresa);
            ddlFiltroPuesto.DataValueField = "Id";
            ddlFiltroPuesto.DataTextField = "Nombre";
            ddlFiltroPuesto.DataBind();
            ddlFiltroPuesto.Items.Insert(0, new ListItem("Todos", "0"));

            ddlFiltroSeniority.DataSource = seniorityNegocio.listar();
            ddlFiltroSeniority.DataValueField = "Id";
            ddlFiltroSeniority.DataTextField = "Nombre";
            ddlFiltroSeniority.DataBind();
            ddlFiltroSeniority.Items.Insert(0, new ListItem("Todos", "0"));
            ddlFiltroSeniority.Items.Insert(1, new ListItem("Sin seniority", "-1"));
        }
        public string ObtenerIconoPermiso(object esAdminObj, object permisoEscrituraObj)
        {
            bool esAdmin = Convert.ToBoolean(esAdminObj);
            bool permisoEscritura = Convert.ToBoolean(permisoEscrituraObj);

            if (esAdmin && permisoEscritura)
            {
                return "<span class='text-primary me-2' title='Administrador'>" +
                       "<i class='bi bi-shield-lock-fill'></i>" +
                       "</span>" +
                       "<span class='text-info' title='Gestión habilitada'>" +
                       "<i class='bi bi-pencil-square'></i>" +
                       "</span>";
            }
            if (esAdmin)
            {
                return "<span class='text-primary' title='Administrador'>" +
                       "<i class='bi bi-shield-lock-fill'></i>" +
                       "</span>";
            }
            if (permisoEscritura)
            {
                return "<span class='text-info' title='Gestión habilitada'>" +
                       "<i class='bi bi-pencil-square'></i>" +
                       "</span>";
            }

            return "<span class='text-secondary' title='Solo lectura'>" +
                   "<i class='bi bi-lock-fill'></i>" +
                   "</span>";
        }
    }
}