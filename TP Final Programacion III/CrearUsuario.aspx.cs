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
            if (!IsPostBack)
            {
                try
                {
                    txtNombreUsuario.Text = "";
                    txtPassword.Text = "";
                    txtNombre.Text = "";
                    txtApellido.Text = "";
                    chkPermisoEscritura.Checked = false;
                    int idEmpresa = ((Usuario)Session["usuario"]).Empresa.Id;

                    AreaNegocio areaNegocio = new AreaNegocio();
                    PuestoNegocio puestoNegocio = new PuestoNegocio();

                    ddlArea.DataSource = areaNegocio.listar(idEmpresa);
                    ddlArea.DataValueField = "Id";
                    ddlArea.DataTextField = "Nombre";
                    ddlArea.DataBind();
                    ddlArea.Items.Insert(0, new ListItem("Seleccione un área", ""));

                    ddlPuesto.DataSource = puestoNegocio.listar();
                    ddlPuesto.DataValueField = "Id";
                    ddlPuesto.DataTextField = "Nombre";
                    ddlPuesto.DataBind();
                    ddlPuesto.Items.Insert(0, new ListItem("Seleccione un puesto", ""));

                    //Configuracion si estamos modificando
                    if (Request.QueryString["id"] != null)
                    {
                        lblTituloFormularioUsuario.Text = "Modificar Usuario";
                        btnCrearUsuario.Text = "Guardar Cambios";

                        int idUsuario = int.Parse(Request.QueryString["id"]);
                        UsuarioNegocio negocio = new UsuarioNegocio();
                        Usuario usuarioEditar = negocio.BuscarPorId(idUsuario);
                        if(usuarioEditar != null)
                        {
                            txtNombreUsuario.Text = usuarioEditar.NombreUsuario;
                            txtEmail.Text = usuarioEditar.Email;
                            txtNombre.Text = usuarioEditar.Nombre;
                            txtApellido.Text = usuarioEditar.Apellido;

                            ddlArea.SelectedValue = usuarioEditar.Area.Id.ToString();
                            ddlPuesto.SelectedValue = usuarioEditar.Puesto.Id.ToString();

                            chkPermisoEscritura.Checked = usuarioEditar.PermisoEscritura;

                            txtPassword.Text = "";
                            txtConfirmarPassword.Text = "";

                            rfvPassword.Enabled = false;
                            rfvConfirmarPassword.Enabled = false;
                            cvConfirmarPassword.Enabled = false;

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
            string.IsNullOrWhiteSpace(ddlPuesto.SelectedValue) || string.IsNullOrWhiteSpace(txtPassword.Text) || 
            string.IsNullOrWhiteSpace(txtEmail.Text) || (!esEdicion && txtPassword.Text != txtConfirmarPassword.Text) ||
           (!esEdicion && string.IsNullOrWhiteSpace(txtPassword.Text))
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
                nuevoUsuario.Activo = true;
                nuevoUsuario.PermisoEscritura = chkPermisoEscritura.Checked;

                nuevoUsuario.Area = new Area();
                nuevoUsuario.Area.Id = int.Parse(ddlArea.SelectedValue);

                nuevoUsuario.Puesto = new Puesto();
                nuevoUsuario.Puesto.Id = int.Parse(ddlPuesto.SelectedValue);

                nuevoUsuario.Empresa = new Empresa();
                nuevoUsuario.Empresa.Id = userLogueado.Empresa.Id;

                if (esEdicion)
                {
                    if (!string.IsNullOrWhiteSpace(txtPassword.Text))
                    {
                        if(txtPassword.Text == txtConfirmarPassword.Text)
                        {
                            nuevoUsuario.PasswordHash = txtPassword.Text;
                        }
                        else
                        {
                            return;
                        }
                    }
                    nuevoUsuario.Id = int.Parse(Request.QueryString["id"]);
                    if (negocio.Modificar(nuevoUsuario))
                    {
                        Response.Redirect("Usuarios.aspx", false);
                    }
                }
                else
                {
                    nuevoUsuario.PasswordHash = txtPassword.Text;
                    if (negocio.Agregar(nuevoUsuario))
                    {

                        Response.Redirect("Usuarios.aspx", false);
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
}