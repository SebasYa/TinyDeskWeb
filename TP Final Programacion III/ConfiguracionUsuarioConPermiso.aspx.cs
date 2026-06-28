using Antlr.Runtime.Misc;
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
    public partial class ConfiguracionUsuarioConPermiso : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try
                {
                    Usuario usuarioSesion = (Usuario)Session["usuario"];
                    UsuarioNegocio negocio = new UsuarioNegocio();
                    Usuario usuario = negocio.BuscarPorId(usuarioSesion.Id);

                    if (usuario == null)
                    {
                        MostrarError("No se pudieron cargar tus datos.");
                        return;
                    }

                    lblIniciales.Text = ObtenerIniciales(usuario.Nombre, usuario.Apellido);
                    lblNombre.Text = usuario.Nombre;
                    lblApellido.Text = usuario.Apellido;
                    lblNombreUsuario.Text = usuario.NombreUsuario;
                    lblEmail.Text = usuario.Email;

                    string rutaImagen = Session["imagenUsuario"] as string;
                    if (!string.IsNullOrEmpty(rutaImagen))
                    {
                        pnlAvatarPerfil.Style["background-image"] = "url('" + rutaImagen + "')";
                        pnlAvatarPerfil.Style["background-size"] = "cover";
                        pnlAvatarPerfil.Style["background-position"] = "center";
                        pnlAvatarPerfil.Style["background-repeat"] = "no-repeat";

                        lblIniciales.Visible = false;
                        imgPerfilActual.ImageUrl = rutaImagen;
                    }
                    else
                    {
                        pnlAvatarPerfil.Style.Remove("background-image");
                        lblIniciales.Visible = true;
                    }

                    CargarInformacionLaboral(usuario);
                    MostrarSeccion("perfil");
                }
                catch (Exception ex)
                {
                    Session["error"] = ex.ToString();
                    MostrarError("Ocurrió un error al cargar la configuración.");
                }
            }
        }
        protected void btnPerfil_Click(object sender, EventArgs e)
        {
            MostrarSeccion("perfil");
        }
        protected void btnInformacionLaboral_Click(object sender, EventArgs e)
        {
            MostrarSeccion("laboral");
        }
        protected void btnSeguridad_Click(object sender, EventArgs e)
        {
            MostrarSeccion("seguridad");
        }
        protected void btnPreferencias_Click(object sender, EventArgs e)
        {
            MostrarSeccion("preferencias");
        }
        private void MostrarSeccion(string seccion)
        {
            pnlPerfil.Visible = seccion == "perfil";
            pnlInformacionLaboral.Visible = seccion == "laboral";
            pnlSeguridad.Visible = seccion == "seguridad";
            pnlPreferencias.Visible = seccion == "preferencias";


            btnPerfil.CssClass = ObtenerClaseNavegacion(seccion == "perfil");
            btnInformacionLaboral.CssClass = ObtenerClaseNavegacion(seccion == "laboral");
            btnSeguridad.CssClass = ObtenerClaseNavegacion(seccion == "seguridad");
            btnPreferencias.CssClass = ObtenerClaseNavegacion(seccion == "preferencias");
        }
        private string ObtenerClaseNavegacion(bool activo)
        {
            return activo ? "list-group-item list-group-item-action active" : "list-group-item list-group-item-action";
        }
        private void CargarInformacionLaboral(Usuario usuario)
        {
            lblEmpresa.Text = usuario.Empresa.Nombre;
            lblArea.Text = usuario.Area.Nombre;
            lblPuesto.Text = usuario.Puesto.Nombre;
            lblSeniority.Text = usuario.Seniority != null ? usuario.Seniority.Nombre : "No asignado";
            lblEstadoCuenta.Text = "Cuenta activa";
            lblEstadoCuenta.CssClass = "badge rounded-pill bg-success-subtle text-success";

            if(usuario.EsAdmin && usuario.PermisoEscritura)
            {
                lblTipoAcceso.Text = "Administrador";
                lblTipoAcceso.CssClass = "badge rounded-pill bg-primary-subtle text-primary";

                lblTipoAccesoSecundario.Visible = true;
                lblTipoAccesoSecundario.Text = "Gestión habilitada";
                lblTipoAccesoSecundario.CssClass = "badge rounded-pill bg-info-subtle text-success";
            }
            else if(usuario.EsAdmin)
            {
                lblTipoAcceso.Text = "Administrador";
                lblTipoAcceso.CssClass = "badge rounded-pill bg-primary-subtle text-primary";
                lblTipoAccesoSecundario.Visible = true;
            }
            else if(usuario.PermisoEscritura)
            {
                lblTipoAcceso.Text = "Gestión habilitada";
                lblTipoAcceso.CssClass = "badge rounded-pill bg-info-subtle text-info";
                lblTipoAccesoSecundario.Visible = true;
            }
        }
        protected void btnActualizarPassword_Click(object sender, EventArgs e)
        {
            MostrarSeccion("seguridad");
            litMensaje.Text = "";
            string passwordNueva = txtPasswordNueva.Text;
            string passwordActual = txtPasswordActual.Text;
            if (string.IsNullOrWhiteSpace(txtConfirmarPassword.Text) || string.IsNullOrWhiteSpace(passwordActual) || string.IsNullOrWhiteSpace(passwordNueva))
            {
                MostrarError("Completá todos los campos.");
                return;
            }
            if(passwordNueva.Length < 8)
            {
                MostrarError("La nueva contraseña debe tener al menos 8 caracteres.");
                return;
            }
            if(passwordNueva != txtConfirmarPassword.Text)
            {
                MostrarError("La confirmación de la contraseña no coincide.");
                return;
            }

            try
            {
                Usuario usuario = (Usuario)Session["usuario"];
                UsuarioNegocio negocio = new UsuarioNegocio();
                bool passActCorrecta = negocio.VerificarPasswordActual(usuario.Id, passwordActual);
                if (!passActCorrecta)
                {
                    MostrarError("La contraseña actual es incorrecta.");
                    txtPasswordActual.Text = "";
                    txtPasswordNueva.Text = "";
                    txtConfirmarPassword.Text = "";
                    return;
                }
                if (passwordActual == passwordNueva)
                {
                    MostrarError("La nueva contraseña debe ser diferente de la contraseña actual.");
                    txtPasswordNueva.Text = "";
                    txtConfirmarPassword.Text = "";
                    return;
                }

                bool actualizado = negocio.CambiarPasswordUsuarioActivo(usuario, passwordNueva);
                if(!actualizado)
                {
                    MostrarError("Hubo un error al intentar cambiar la contraseña.");
                    txtPasswordActual.Text = "";
                    txtPasswordNueva.Text = "";
                    txtConfirmarPassword.Text = "";
                    return;
                }

                txtPasswordActual.Text = "";
                txtPasswordNueva.Text = "";
                txtConfirmarPassword.Text = "";
                MostrarExito("La contraseña se actualizó correctamente.");
            }
            catch (Exception ex)
            {
                Session["error"] = ex.ToString();
                MostrarError("Ocurrió un error al actualizar la contraseña.");
            }
        }
        protected void btnGuardarImagenPerfil_Click(object sender, EventArgs e)
        {
            try
            {
                if (!fuImagenPerfil.HasFile)
                {
                    MostrarError("Selecciona una imagen para poder guardarla.");
                    return;
                }

                ImagenUsuarioNegocio negocio = new ImagenUsuarioNegocio();
                ImagenUsuario imagenUsuario = new ImagenUsuario();
                imagenUsuario.IdUsuario = ((Usuario)Session["usuario"]).Id;

                //Escribir img si se cargo algo
                if (fuImagenPerfil.PostedFile.FileName != "")
                {
                    string ruta = Server.MapPath("./Images/");
                    fuImagenPerfil.PostedFile.SaveAs(ruta + "perfil-" + imagenUsuario.IdUsuario + ".jpg");
                    imagenUsuario.ImagenURL = "perfil-" + imagenUsuario.IdUsuario + ".jpg";

                    //Guardar datos
                    negocio.Guardar(imagenUsuario);

                    //Leer img
                    string rutaImagen =  ResolveUrl("~/Images/" + imagenUsuario.ImagenURL) + "?v=" + Guid.NewGuid();
                    Button botonUsuario = (Button)Master.FindControl("btnUserNav");

                    botonUsuario.Text = "";
                    botonUsuario.Style["background-image"] = "url('" + rutaImagen + "')";
                    botonUsuario.Style["background-size"] = "cover";
                    botonUsuario.Style["background-position"] = "center";
                    botonUsuario.Style["background-repeat"] = "no-repeat";

                    Session["imagenUsuario"] = rutaImagen;
                    imgPerfilActual.ImageUrl = rutaImagen;

                    pnlAvatarPerfil.Style["background-image"] = "url('" + rutaImagen + "')";
                    pnlAvatarPerfil.Style["background-size"] = "cover";
                    pnlAvatarPerfil.Style["background-position"] = "center";
                    pnlAvatarPerfil.Style["background-repeat"] = "no-repeat";

                    lblIniciales.Visible = false;
                    MostrarExito("Imagen guardada exitosamente!");
                }

            }
            catch
            {
                MostrarError("Hubo un problema al guardar tu imagen de perfil");
            }            
        }
        private string ObtenerIniciales(string nombre, string apellido)
        {
            string inicialNombre = "";
            string inicialApellido = "";

            if (!string.IsNullOrWhiteSpace(nombre))
            {
                inicialNombre = nombre.Substring(0, 1).ToUpper();
            }

            if (!string.IsNullOrWhiteSpace(apellido))
            {
                inicialApellido = apellido.Substring(0, 1).ToUpper();
            }

            return inicialNombre + inicialApellido;
        }
        private void MostrarExito(string mensaje)
        {
            litMensaje.Text =
                "<div class='alert alert-success " +
                "alert-dismissible fade show'>" +
                mensaje +
                "<button type='button' " +
                "class='btn-close' " +
                "data-bs-dismiss='alert'></button>" +
                "</div>";
        }
        private void MostrarError(string mensaje)
        {
            litMensaje.Text =
                "<div class='alert alert-danger " +
                "alert-dismissible fade show'>" +
                mensaje +
                "<button type='button' " +
                "class='btn-close' " +
                "data-bs-dismiss='alert'></button>" +
                "</div>";
        }
    }
}