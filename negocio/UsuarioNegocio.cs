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
                    SELECT U.Id, U.PasswordHash, U.NombreUsuario, U.PermisoEscritura, 
                           U.IdEmpresa, E.Nombre AS NombreEmpresa, 
                           U.IdPuesto, P.Nombre AS NombrePuesto, 
                           U.IdArea, A.Nombre AS NombreArea
                    FROM USUARIO U
                    INNER JOIN EMPRESA E ON U.IdEmpresa = E.Id
                    INNER JOIN PUESTO P ON U.IdPuesto = P.Id
                    INNER JOIN AREA A ON U.IdArea = A.Id
                    WHERE U.NombreUsuario = @NombreUsuario AND U.PasswordHash = @PasswordHash
        ");
                datos.setearParametro("@NombreUsuario", usuario.NombreUsuario);
                datos.setearParametro("@PasswordHash", usuario.PasswordHash);
                datos.ejecutarLectura();
                if (datos.Lector.Read())
                {
                    usuario.Id = (int)datos.Lector["Id"];
                    usuario.PermisoEscritura = (bool)datos.Lector["PermisoEscritura"];

                    usuario.Empresa = new Empresa();
                    usuario.Empresa.Id = (int)datos.Lector["IdEmpresa"];
                    usuario.Empresa.Nombre = (string)datos.Lector["NombreEmpresa"];

                    usuario.Puesto = new Puesto();
                    usuario.Puesto.Id = (int)datos.Lector["IdPuesto"];
                    usuario.Puesto.Nombre = (string)datos.Lector["NombrePuesto"];

                    usuario.Area = new Area();
                    usuario.Area.Id = (int)datos.Lector["IdArea"];
                    usuario.Area.Nombre = (string)datos.Lector["NombreArea"];
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

        public bool RegistrarEmpresaYOwner(string nombreEmpresa, string nombreUsuario, string password, string nombre, string apellido)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta(@"
                    BEGIN TRANSACTION;
                    BEGIN TRY
                        -- 1. Insertamos Empresa y guardamos su ID
                        INSERT INTO EMPRESA (Nombre) VALUES (@NombreEmpresa);
                        DECLARE @IdEmpresa INT = SCOPE_IDENTITY();

                        -- 2. Obtenemos el ID del Area Direccion 
                        DECLARE @IdAreaOwner INT;
                        SELECT @IdAreaOwner = Id FROM AREA WHERE Nombre = 'Direccion';

                        -- 3. Obtenemos el ID del PUESTO Owner 
                        DECLARE @IdPuestoOwner INT;
                        SELECT @IdPuestoOwner = Id FROM PUESTO WHERE Nombre = 'Owner';

                        -- 4. Insertamos Usuario
                        INSERT INTO USUARIO (NombreUsuario, PasswordHash, Nombre, Apellido, Activo, 
                                             PermisoEscritura, IdPuesto, IdArea, IdEmpresa)
                        VALUES (@NombreUsuario, @Password, @Nombre, @Apellido, 1, 1, @IdPuestoOwner, @IdAreaOwner, @IdEmpresa);

                        -- Si todo fue exitoso, confirmamos los cambios
                        COMMIT TRANSACTION;
                    END TRY
                    BEGIN CATCH
                        -- Si algo fallo, revertimos todo y levantamos la excepción
                        IF @@TRANCOUNT > 0
                            ROLLBACK TRANSACTION;
                        THROW;
                    END CATCH
                ");

                datos.setearParametro("@NombreEmpresa", nombreEmpresa);
                datos.setearParametro("@NombreUsuario", nombreUsuario);
                datos.setearParametro("@Password", password);
                datos.setearParametro("@Nombre", nombre);
                datos.setearParametro("@Apellido", apellido);


                datos.ejecutarAccion();
                return true;
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
    }
}
