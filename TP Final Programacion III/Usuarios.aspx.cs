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
                string estado = tokenNegocio.ObtenerEstadoToken(idUsuario, "CrearPassword");

                if (estado == "Pendiente")
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
            dgvUsuarios.PageIndex = e.NewPageIndex;
            int userLogueado = ((Usuario)Session["usuario"]).Empresa.Id;
            UsuarioNegocio negocio = new UsuarioNegocio();
            dgvUsuarios.DataSource = negocio.listar(userLogueado);
            dgvUsuarios.DataBind();
        }

        protected void dgvUsuarios_SelectedIndexChanged(object obj, EventArgs e)
        {
            string id = dgvUsuarios.SelectedDataKey.Value.ToString();
            Response.Redirect("CrearUsuario.aspx?id=" + id, false);
        }
    }
}