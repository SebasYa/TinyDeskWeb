using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using dominio;
using negocio;

namespace negocio
{
    public class UsuarioNegocio
    {
        public bool Login(Usuario usuario)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta(@"
                    SELECT Id, PasswordHash, NombreUsuario, PermisoEscritura
                    FROM USUARIO
                    WHERE NombreUsuario = @NombreUsuario AND PasswordHash = @PasswordHash
                ");
                datos.setearParametro("@NombreUsuario", usuario.NombreUsuario);
                datos.setearParametro("@PasswordHash", usuario.PasswordHash);
                datos.ejecutarLectura();
                if (datos.Lector.Read())
                {
                    usuario.Id = (int)datos.Lector["Id"];
                    usuario.PermisoEscritura = (bool)datos.Lector["PermisoEscritura"];
                    return true;
                }
                else
                {
                    return false;
                }
            }
            catch (Exception ex)
            {

                throw ex;
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        public bool RegistrarEmpresaYOwner(string nombreEmpresa, string username, string password, string nombre, string apellido)
        {
            int idEmpresa = 0;
            int idAreaOwner = 0;
            AccesoDatos datosEmpresa = new AccesoDatos();
            try
            {
                datosEmpresa.setearConsulta("INSERT INTO EMPRESA (Nombre) VALUES (@NombreEmpresa); SELECT SCOPE_IDENTITY();");
                datosEmpresa.setearParametro("@NombreEmpresa", nombreEmpresa);
                idEmpresa = datosEmpresa.ejecutarScalar();
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                datosEmpresa.cerrarConexion();
            }

            AccesoDatos datosArea = new AccesoDatos();
            try
            {
                datosArea.setearConsulta("SELECT Id FROM AREA WHERE Nombre = 'Owner'");
                idAreaOwner = datosArea.ejecutarScalar();
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                datosArea.cerrarConexion();
            }

            AccesoDatos datosUsuario = new AccesoDatos();
            try
            {
                datosUsuario.setearConsulta(@"
                                INSERT INTO USUARIO (NombreUsuario, PasswordHash, Nombre, Apellido, Activo, 
                                                     PermisoEscritura, IdEmpresa, IdArea, EsOwner)
                                VALUES (@Username, @Password, @Nombre, @Apellido, 1, 1, @IdEmpresa, @IdArea, 1)
        ");
                datosUsuario.setearParametro("@Username", username);
                datosUsuario.setearParametro("@Password", password);
                datosUsuario.setearParametro("@Nombre", nombre);
                datosUsuario.setearParametro("@Apellido", apellido);
                datosUsuario.setearParametro("@IdEmpresa", idEmpresa);
                datosUsuario.setearParametro("@IdArea", idAreaOwner);
                datosUsuario.ejecutarAccion();
                return true;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                datosUsuario.cerrarConexion();
            }
        }
    }
}
