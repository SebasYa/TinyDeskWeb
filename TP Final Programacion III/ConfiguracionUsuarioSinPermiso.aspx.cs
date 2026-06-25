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
    public partial class ConfiguracionUsuarioSinPermiso : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try
                {
                    Usuario usuarioSesion = (Usuario)Session["usuario"];
                    UsuarioNegocio negocio =  new UsuarioNegocio();
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

                    CargarInformacionLaboral(usuario);
                    MostrarSeccion("perfil");
                }
                catch (Exception ex)
                {
                    Session["error"] = ex.ToString();

                    MostrarError(
                        "Ocurrió un error al cargar la configuración.");
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
            btnSeguridad.CssClass =  ObtenerClaseNavegacion(seccion == "seguridad");
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

            lblTipoAcceso.Text = "Solo lectura";
            lblTipoAcceso.CssClass = "badge rounded-pill bg-secondary-subtle text-secondary";

            if (usuario.Activo)
            {
                lblEstadoCuenta.Text = "Cuenta activa";
                lblEstadoCuenta.CssClass = "badge rounded-pill bg-success-subtle text-success";
            }
        }
        protected void btnActualizarPassword_Click(object sender, EventArgs e)
        {
            MostrarSeccion("seguridad");
            litMensaje.Text = "";
            string passwordNueva = txtPasswordNueva.Text;

            if (string.IsNullOrWhiteSpace(txtPasswordActual.Text) || string.IsNullOrWhiteSpace(passwordNueva) || string.IsNullOrWhiteSpace(txtConfirmarPassword.Text))
            {
                MostrarError("Completá todos los campos.");
                return;
            }

            if (passwordNueva.Length < 8)
            {
                MostrarError("La nueva contraseña debe tener al menos 8 caracteres.");
                return;
            }

            if (passwordNueva != txtConfirmarPassword.Text)
            {
                MostrarError("Las nuevas contraseñas no coinciden.");
                return;
            }

            if (txtPasswordActual.Text == passwordNueva)
            {
                MostrarError("La nueva contraseña debe ser diferente de la contraseña actual.");
                return;
            }

            try
            {
                Usuario usuario = (Usuario)Session["usuario"];
                UsuarioNegocio negocio = new UsuarioNegocio();
                bool actualizado = negocio.CambiarPasswordUsuarioActivo(usuario, passwordNueva);

                if (!actualizado)
                {
                    MostrarError("La contraseña actual es incorrecta.");
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