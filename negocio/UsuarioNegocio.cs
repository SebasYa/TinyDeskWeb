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
                    SELECT U.Id, U.PasswordHash, U.NombreUsuario, 
                           U.Nombre, U.Apellido, U.PermisoEscritura, 
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
                    usuario.NombreUsuario = (string)datos.Lector["NombreUsuario"];
                    usuario.Nombre = (String)datos.Lector["Nombre"];
                    usuario.Apellido = (string)datos.Lector["Apellido"];
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

        public bool Agregar(Usuario nuevoUsuario)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta(@"INSERT INTO USUARIO (
                                       NombreUsuario, PasswordHash, Nombre, Apellido, Activo,
                                       PermisoEscritura, IdPuesto, IdArea, IdEmpresa)
                                       VALUES (@NombreUsuario, @PasswordHash, @Nombre, @Apellido, @Activo, 
                                               @PermisoEscritura, @IdPuesto, @IdArea, @IdEmpresa)
        ");
                datos.setearParametro("@NombreUsuario", nuevoUsuario.NombreUsuario);
                datos.setearParametro("@PasswordHash", nuevoUsuario.PasswordHash);
                datos.setearParametro("@Nombre", nuevoUsuario.Nombre);
                datos.setearParametro("@Apellido", nuevoUsuario.Apellido);
                datos.setearParametro("@Activo", nuevoUsuario.Activo);
                datos.setearParametro("@PermisoEscritura", nuevoUsuario.PermisoEscritura);
                datos.setearParametro("@IdPuesto", nuevoUsuario.Puesto.Id);
                datos.setearParametro("@IdArea", nuevoUsuario.Area.Id);
                datos.setearParametro("@IdEmpresa", nuevoUsuario.Empresa.Id);
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
        public Usuario BuscarPorId(int id)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta(@"SELECT U.Id, U.NombreUsuario, U.Nombre, U.Apellido, 
                                              U.Activo, U.PermisoEscritura,
                                              U.IdPuesto, P.Nombre AS NombrePuesto,
                                              U.IdArea, A.Nombre AS NombreArea, U.IdEmpresa
                                       FROM USUARIO U
                                       INNER JOIN PUESTO P ON U.IdPuesto = P.Id
                                       INNER JOIN AREA A ON U.IdArea = A.Id
                                       WHERE U.Id = @Id"
                );
                datos.setearParametro("@Id", id);
                datos.ejecutarLectura();

                if (datos.Lector.Read())
                {
                    Usuario aux = new Usuario();
                    aux.Id = (int)datos.Lector["Id"];
                    aux.NombreUsuario = (string)datos.Lector["NombreUsuario"];
                    aux.Nombre = (string)datos.Lector["Nombre"];
                    aux.Apellido = (string)datos.Lector["Apellido"];
                    aux.Activo = (bool)datos.Lector["Activo"];
                    aux.PermisoEscritura = (bool)datos.Lector["PermisoEscritura"];

                    aux.Puesto = new Puesto();
                    aux.Puesto.Id = (int)datos.Lector["IdPuesto"];
                    aux.Puesto.Nombre = (string)datos.Lector["NombrePuesto"];

                    aux.Area = new Area();
                    aux.Area.Id = (int)datos.Lector["IdArea"];
                    aux.Area.Nombre = (string)datos.Lector["NombreArea"];

                    aux.Empresa = new Empresa();
                    aux.Empresa.Id = (int)datos.Lector["IdEmpresa"];

                    return aux;
                }
                return null;
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

        public bool Modificar(Usuario usuario)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta(@"UPDATE USUARIO SET 
                                        NombreUsuario = @NombreUsuario, 
                                        Nombre = @Nombre, 
                                        Apellido = @Apellido, 
                                        PermisoEscritura = @PermisoEscritura, 
                                        IdPuesto = @IdPuesto, 
                                        IdArea = @IdArea 
                                    WHERE Id = @Id"
                );

                datos.setearParametro("@NombreUsuario", usuario.NombreUsuario);
                datos.setearParametro("@Nombre", usuario.Nombre);
                datos.setearParametro("@Apellido", usuario.Apellido);
                datos.setearParametro("@PermisoEscritura", usuario.PermisoEscritura);
                datos.setearParametro("@IdPuesto", usuario.Puesto.Id);
                datos.setearParametro("@IdArea", usuario.Area.Id);
                datos.setearParametro("@Id", usuario.Id);

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

        public List<Usuario> listar(int idEmpresa)
        {
            AccesoDatos datos = new AccesoDatos();
            List<Usuario> lista = new List<Usuario>();
            try
            {
                datos.setearConsulta(@"SELECT U.Id, U.NombreUsuario, U.Nombre, U.Apellido, 
                                              U.Activo, U.PermisoEscritura,
                                              U.IdPuesto, P.Nombre AS NombrePuesto,
                                              U.IdArea, A.Nombre AS NombreArea, U.IdEmpresa
                                       FROM USUARIO U
                                       INNER JOIN PUESTO P ON U.IdPuesto = P.Id
                                       INNER JOIN AREA A ON U.IdArea = A.Id
                                       WHERE U.IdEmpresa = @IdEmpresa"
                );
                datos.setearParametro("@IdEmpresa", idEmpresa);
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    Usuario usuarioNuevo = new Usuario();
                    usuarioNuevo.Id = (int)datos.Lector["Id"];
                    usuarioNuevo.NombreUsuario = (string)datos.Lector["NombreUsuario"];
                    usuarioNuevo.Nombre = (string)datos.Lector["Nombre"];
                    usuarioNuevo.Apellido = (string)datos.Lector["Apellido"];
                    usuarioNuevo.Activo = (bool)datos.Lector["Activo"];
                    usuarioNuevo.PermisoEscritura = (bool)datos.Lector["PermisoEscritura"];

                    usuarioNuevo.Puesto = new Puesto();
                    usuarioNuevo.Puesto.Id = (int)datos.Lector["IdPuesto"];
                    usuarioNuevo.Puesto.Nombre = (string)datos.Lector["NombrePuesto"];

                    usuarioNuevo.Area = new Area();
                    usuarioNuevo.Area.Id = (int)datos.Lector["IdArea"];
                    usuarioNuevo.Area.Nombre = (string)datos.Lector["NombreArea"];

                    usuarioNuevo.Empresa = new Empresa();
                    usuarioNuevo.Empresa.Id = (int)datos.Lector["IdEmpresa"];

                    lista.Add(usuarioNuevo);
                }
                return lista;
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
