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
    public partial class CrearUsuario : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Seguridad.EsAdmin(Session["usuario"]))
            {
                Response.Redirect("Default.aspx");
            }
            if (!IsPostBack)
            {
                try
                {
                    txtNombreUsuario.Text = "";
                    txtNombre.Text = "";
                    txtApellido.Text = "";
                    chkPermisoEscritura.Checked = false;
                    chkEsAdmin.Checked = false;
                    int idEmpresa = ((Usuario)Session["usuario"]).Empresa.Id;

                    AreaNegocio areaNegocio = new AreaNegocio();
                    PuestoNegocio puestoNegocio = new PuestoNegocio();
                    SeniorityNegocio seniorityNegocio = new SeniorityNegocio();

                    ddlArea.DataSource = areaNegocio.listar(idEmpresa);
                    ddlArea.DataValueField = "Id";
                    ddlArea.DataTextField = "Nombre";
                    ddlArea.DataBind();
                    ddlArea.Items.Insert(0, new ListItem("Seleccione un área", ""));

                    ddlPuesto.DataSource = puestoNegocio.listar(idEmpresa);
                    ddlPuesto.DataValueField = "Id";
                    ddlPuesto.DataTextField = "Nombre";
                    ddlPuesto.DataBind();
                    ddlPuesto.Items.Insert(0, new ListItem("Seleccione un puesto", ""));

                    ddlSeniority.DataSource = seniorityNegocio.listar();
                    ddlSeniority.DataValueField = "Id";
                    ddlSeniority.DataTextField = "Nombre";
                    ddlSeniority.DataBind();
                    ddlSeniority.Items.Insert(0, new ListItem("Seleccione un seniority", ""));

                    if (Request.QueryString["id"] != null)
                    {
                        lblTituloFormularioUsuario.Text = "Modificar Usuario";
                        txtSubtitulo.Visible = false;
                        btnCrearUsuario.Text = "Guardar Cambios";

                        int idUsuario = int.Parse(Request.QueryString["id"]);
                        UsuarioNegocio negocio = new UsuarioNegocio();
                        Usuario usuarioEditar = negocio.BuscarPorId(idUsuario);
                        if (usuarioEditar != null)
                        {
                            txtNombreUsuario.Text = usuarioEditar.NombreUsuario;
                            txtEmail.Text = usuarioEditar.Email;
                            txtNombre.Text = usuarioEditar.Nombre;
                            txtApellido.Text = usuarioEditar.Apellido;

                            ddlArea.SelectedValue = usuarioEditar.Area.Id.ToString();
                            ddlPuesto.SelectedValue = usuarioEditar.Puesto.Id.ToString();

                            chkPermisoEscritura.Checked = usuarioEditar.PermisoEscritura;
                            chkEsAdmin.Checked = usuarioEditar.EsAdmin;

                            if(usuarioEditar.Seniority != null)
                            {
                                ddlSeniority.SelectedValue = usuarioEditar.Seniority.Id.ToString();
                            }

                        }
                    }
                }
                catch (Exception ex)
                {
                    Session.Add("error", ex.ToString());
                    Response.Redirect("Default.aspx", false);
                }
            }
        }

        protected void btnCrearUsuario_Click(object sender, EventArgs e)
        {
            bool esEdicion = Request.QueryString["id"] != null;
            if (string.IsNullOrWhiteSpace(txtNombreUsuario.Text) || string.IsNullOrWhiteSpace(txtNombre.Text) ||
            string.IsNullOrWhiteSpace(txtApellido.Text) || string.IsNullOrWhiteSpace(ddlArea.SelectedValue) ||
            string.IsNullOrWhiteSpace(ddlPuesto.SelectedValue) || string.IsNullOrWhiteSpace(txtEmail.Text)
           )
            {
                return;
            }

            try
            {
                UsuarioNegocio negocio = new UsuarioNegocio();
                Usuario nuevoUsuario = new Usuario();
                Usuario userLogueado = (Usuario)Session["usuario"];

                nuevoUsuario.NombreUsuario = txtNombreUsuario.Text;

                nuevoUsuario.Email = txtEmail.Text;
                nuevoUsuario.Nombre = txtNombre.Text;
                nuevoUsuario.Apellido = txtApellido.Text;
                nuevoUsuario.PermisoEscritura = chkPermisoEscritura.Checked;
                nuevoUsuario.EsAdmin = chkEsAdmin.Checked;

                nuevoUsuario.Area = new Area();
                nuevoUsuario.Area.Id = int.Parse(ddlArea.SelectedValue);

                nuevoUsuario.Puesto = new Puesto();
                nuevoUsuario.Puesto.Id = int.Parse(ddlPuesto.SelectedValue);

                nuevoUsuario.Empresa = new Empresa();
                nuevoUsuario.Empresa.Id = userLogueado.Empresa.Id;

                if (!string.IsNullOrEmpty(ddlSeniority.SelectedValue))
                {
                    nuevoUsuario.Seniority = new Seniority();
                    nuevoUsuario.Seniority.Id = int.Parse(ddlSeniority.SelectedValue);
                }
                else
                {
                    nuevoUsuario.Seniority = null;
                }


                if (esEdicion)
                {
                    nuevoUsuario.Id = int.Parse(Request.QueryString["id"]);
                    if (negocio.Modificar(nuevoUsuario))
                    {
                        Response.Redirect("Usuarios.aspx", false);
                    }
                }
                else
                {
                    nuevoUsuario.Activo = false;
                    nuevoUsuario.EmailVerificado = false;
                    nuevoUsuario.PasswordHash = TokenHelper.GenerarToken();
                    int idUsuario = negocio.AgregarInvitado(nuevoUsuario);
                    if (idUsuario <= 0)
                    {
                        return;
                    }
                    nuevoUsuario.Id = idUsuario;
                    UsuarioTokenNegocio tokenNegocio = new UsuarioTokenNegocio();
                    UsuarioToken usuarioToken = tokenNegocio.CrearToken(nuevoUsuario, "CrearPassword", 24);

                    string linkCrearPass = Request.Url.GetLeftPart(UriPartial.Authority) + ResolveUrl("~/CrearPassword.aspx") + "?token=" + Server.UrlEncode(usuarioToken.Token);
                    string cuerpo = EmailTemplates.CrearPasswordEmpleado(nuevoUsuario.Nombre, linkCrearPass);

                    EmailService email = new EmailService();

                    email.armarCorreo(nuevoUsuario.Email, "Crea tu contraseña en TinyDesk", cuerpo);
                    if (email.enviarEmail()) Response.Redirect("Usuarios.aspx", false);
                }
            }
            catch (Exception ex)
            {
                Session.Add("error", ex.ToString());
                Response.Redirect("Default.aspx", false);
            }
        }

    }
}