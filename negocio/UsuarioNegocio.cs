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
                           U.Nombre, U.Apellido, U.Email, U.PermisoEscritura, 
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
                    usuario.Email = (string)datos.Lector["Email"];
                    usuario.Nombre = (string)datos.Lector["Nombre"];
                    usuario.Apellido = (string)datos.Lector["Apellido"];
                    usuario.PermisoEscritura = (bool)datos.Lector["PermisoEscritura"];

                    usuario.Empresa = new Empresa()
                    {
                        Id = (int)datos.Lector["IdEmpresa"],
                        Nombre = (string)datos.Lector["NombreEmpresa"] 
                    };

                    usuario.Puesto = new Puesto()
                    {
                        Id = (int)datos.Lector["IdPuesto"],
                        Nombre = (string)datos.Lector["NombrePuesto"]
                    };

                    usuario.Area = new Area()
                    {
                        Id = (int)datos.Lector["IdArea"],
                        Nombre = (string)datos.Lector["NombreArea"]
                    };
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

        public int RegistrarEmpresaYOwner(string nombreEmpresa, string nombreUsuario, string password, string nombre, string apellido, string email)
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
                        INSERT INTO USUARIO (NombreUsuario, PasswordHash, Email, Nombre, Apellido, Activo, 
                                             PermisoEscritura, IdPuesto, IdArea, IdEmpresa)
                        VALUES (@NombreUsuario, @Password, @Email, @Nombre, @Apellido, 1, 1, @IdPuestoOwner, @IdAreaOwner, @IdEmpresa);

                        -- Si todo fue exitoso, confirmamos los cambios
                        SELECT CAST(SCOPE_IDENTITY() AS INT)
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
                datos.setearParametro("@Email", email);
                datos.setearParametro("@Password", password);
                datos.setearParametro("@Nombre", nombre);
                datos.setearParametro("@Apellido", apellido);


                int idUsuario = datos.ejecutarScalar();
                return idUsuario;
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
                                       NombreUsuario, PasswordHash, Email, Nombre, Apellido, Activo,
                                       PermisoEscritura, IdPuesto, IdArea, IdEmpresa)
                                       VALUES (@NombreUsuario, @PasswordHash, @Email, @Nombre, @Apellido, @Activo, 
                                               @PermisoEscritura, @IdPuesto, @IdArea, @IdEmpresa)
        ");
                datos.setearParametro("@NombreUsuario", nuevoUsuario.NombreUsuario);
                datos.setearParametro("@PasswordHash", nuevoUsuario.PasswordHash);
                datos.setearParametro("@Email", nuevoUsuario.Email);
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
                datos.setearConsulta(@"SELECT U.Id, U.NombreUsuario, U.Email, U.Nombre, U.Apellido, 
                                              U.Activo, U.PermisoEscritura,
                                              U.IdPuesto, P.Nombre AS NombrePuesto,
                                              U.IdArea, A.Nombre AS NombreArea, U.IdEmpresa, E.Nombre as NombreEmpresa
                                       FROM USUARIO U
                                       INNER JOIN PUESTO P ON U.IdPuesto = P.Id
                                       INNER JOIN AREA A ON U.IdArea = A.Id
                                       INNER JOIN EMPRESA E ON U.IdEmpresa = E.id
                                       WHERE U.Id = @Id"
                );
                datos.setearParametro("@Id", id);
                datos.ejecutarLectura();

                if (datos.Lector.Read())
                {
                    Usuario usuario = new Usuario();
                    usuario.Id = (int)datos.Lector["Id"];
                    usuario.NombreUsuario = (string)datos.Lector["NombreUsuario"];
                    usuario.Email = (string)datos.Lector["Email"];
                    usuario.Nombre = (string)datos.Lector["Nombre"];
                    usuario.Apellido = (string)datos.Lector["Apellido"];
                    usuario.Activo = (bool)datos.Lector["Activo"];
                    usuario.PermisoEscritura = (bool)datos.Lector["PermisoEscritura"];

                    usuario.Empresa = new Empresa()
                    {
                        Id = (int)datos.Lector["IdEmpresa"],
                        Nombre = (string)datos.Lector["NombreEmpresa"]
                    };

                    usuario.Puesto = new Puesto()
                    {
                        Id = (int)datos.Lector["IdPuesto"],
                        Nombre = (string)datos.Lector["NombrePuesto"]
                    };

                    usuario.Area = new Area()
                    {
                        Id = (int)datos.Lector["IdArea"],
                        Nombre = (string)datos.Lector["NombreArea"]
                    }; ;

                    return usuario;
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
                string consulta = @"UPDATE USUARIO SET 
                                        NombreUsuario = @NombreUsuario,
                                        Email = @Email,
                                        Nombre = @Nombre, 
                                        Apellido = @Apellido, 
                                        PermisoEscritura = @PermisoEscritura, 
                                        IdPuesto = @IdPuesto, 
                                        IdArea = @IdArea";
                if (!string.IsNullOrWhiteSpace(usuario.PasswordHash))
                {
                    consulta += ", passwordHash = @PasswordHash";
                }
                consulta += " WHERE Id = @Id";
                datos.setearConsulta(consulta);

                datos.setearParametro("@NombreUsuario", usuario.NombreUsuario);
                datos.setearParametro("@Email", usuario.Email);
                datos.setearParametro("@Nombre", usuario.Nombre);
                datos.setearParametro("@Apellido", usuario.Apellido);
                datos.setearParametro("@PermisoEscritura", usuario.PermisoEscritura);
                datos.setearParametro("@IdPuesto", usuario.Puesto.Id);
                datos.setearParametro("@IdArea", usuario.Area.Id);
                datos.setearParametro("@Id", usuario.Id);

                if (!string.IsNullOrWhiteSpace(usuario.PasswordHash))
                {
                    datos.setearParametro("@PasswordHash", usuario.PasswordHash);
                }

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
                datos.setearConsulta(@"SELECT U.Id, U.NombreUsuario, U.Email, U.Nombre, U.Apellido, 
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
                    Usuario usuario = new Usuario();
                    usuario.Id = (int)datos.Lector["Id"];
                    usuario.NombreUsuario = (string)datos.Lector["NombreUsuario"];
                    usuario.Email = (string)datos.Lector["Email"];
                    usuario.Nombre = (string)datos.Lector["Nombre"];
                    usuario.Apellido = (string)datos.Lector["Apellido"];
                    usuario.Activo = (bool)datos.Lector["Activo"];
                    usuario.PermisoEscritura = (bool)datos.Lector["PermisoEscritura"];

                    usuario.Puesto = new Puesto();
                    usuario.Puesto.Id = (int)datos.Lector["IdPuesto"];
                    usuario.Puesto.Nombre = (string)datos.Lector["NombrePuesto"];

                    usuario.Area = new Area();
                    usuario.Area.Id = (int)datos.Lector["IdArea"];
                    usuario.Area.Nombre = (string)datos.Lector["NombreArea"];

                    usuario.Empresa = new Empresa();
                    usuario.Empresa.Id = (int)datos.Lector["IdEmpresa"];

                    lista.Add(usuario);
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

        public void VerificarMail(Usuario usuario)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta(@" UPDATE USUARIO SET EmailVerificado = 1, Activo = 1
                                        WHERE Id = @Id
                ");

                datos.setearParametro("@Id", usuario.Id);
                datos.ejecutarAccion();
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
