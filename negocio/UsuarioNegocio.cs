using dominio;
using negocio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace negocio
{
    public class UsuarioNegocio
    {
        public bool Login(Usuario usuario)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta(@"SELECT U.Id, U.PasswordHash, U.NombreUsuario, 
                                              U.Nombre, U.Apellido, U.Email, U.PermisoEscritura, U.EsAdmin,
                                              U.IdEmpresa, E.Nombre AS NombreEmpresa, 
                                              U.IdPuesto, P.Nombre AS NombrePuesto, 
                                              U.IdArea, A.Nombre AS NombreArea,
                                              U.IdSeniority, S.Nombre AS NombreSeniority
                                       FROM USUARIO U
                                       INNER JOIN EMPRESA E ON U.IdEmpresa = E.Id
                                       INNER JOIN PUESTO P ON U.IdPuesto = P.Id
                                       INNER JOIN AREA A ON U.IdArea = A.Id
                                       LEFT JOIN SENIORITY S ON U.IdSeniority = S.Id
                                       WHERE U.NombreUsuario = @NombreUsuario 
                                         AND U.PasswordHash = @PasswordHash 
                                         AND U.EmailVerificado = 1 
                                         AND U.Activo = 1
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
                    usuario.EsAdmin = (bool)datos.Lector["EsAdmin"];

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
                    if (datos.Lector["IdSeniority"] != DBNull.Value)
                    {
                        usuario.Seniority = new Seniority();
                        usuario.Seniority.Id = (int)datos.Lector["IdSeniority"];
                        usuario.Seniority.Nombre = (string)datos.Lector["NombreSeniority"];
                    }
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
        public List<Usuario> listarAvanzado(int idEmpresa, int idArea, int idPuesto, int idSeniority, int estado, string permiso)
        {
            AccesoDatos datos = new AccesoDatos();
            List<Usuario> lista = new List<Usuario>();

            try
            {
                string consulta = @"SELECT U.Id, U.NombreUsuario, U.Email, U.Nombre, U.Apellido, U.EsAdmin,
                                           U.Activo, U.PermisoEscritura, U.EmailVerificado,
                                           U.IdPuesto, P.Nombre AS NombrePuesto,
                                           U.IdArea, A.Nombre AS NombreArea, U.IdEmpresa,
                                           U.IdSeniority, S.Nombre AS NombreSeniority
                                    FROM USUARIO U
                                    INNER JOIN PUESTO P ON U.IdPuesto = P.Id
                                    INNER JOIN AREA A ON U.IdArea = A.Id
                                    LEFT JOIN SENIORITY S ON U.IdSeniority = S.Id
                                    WHERE U.IdEmpresa = @IdEmpresa";

                if (idArea != 0)
                {
                    consulta += " AND U.IdArea = @IdArea";
                    datos.setearParametro("@IdArea", idArea);
                }

                if (idPuesto != 0)
                {
                    consulta += " AND U.IdPuesto = @IdPuesto";
                    datos.setearParametro("@IdPuesto", idPuesto);
                }

                if (idSeniority > 0)
                {
                    consulta += " AND U.IdSeniority = @IdSeniority";
                    datos.setearParametro("@IdSeniority", idSeniority);
                }
                else if(idSeniority == -1)
                {
                    consulta += " AND U.IdSeniority IS NULL";
                }

                if (estado != -1)
                {
                    consulta += " AND U.Activo = @Estado";
                    datos.setearParametro("@Estado", estado);
                }

                if (permiso == "admin")
                {
                    consulta += " AND U.EsAdmin = 1";
                }
                else if (permiso == "gestion")
                {
                    consulta += " AND U.PermisoEscritura = 1";
                }
                else if (permiso == "lectura")
                {
                    consulta += " AND U.EsAdmin = 0 AND U.PermisoEscritura = 0";
                }

                consulta += " ORDER BY U.Activo DESC, U.Apellido ASC, U.Nombre ASC";

                datos.setearConsulta(consulta);
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
                    usuario.EsAdmin = (bool)datos.Lector["EsAdmin"];
                    usuario.EmailVerificado = (bool)datos.Lector["EmailVerificado"];

                    usuario.Puesto = new Puesto();
                    usuario.Puesto.Id = (int)datos.Lector["IdPuesto"];
                    usuario.Puesto.Nombre = (string)datos.Lector["NombrePuesto"];

                    usuario.Area = new Area();
                    usuario.Area.Id = (int)datos.Lector["IdArea"];
                    usuario.Area.Nombre = (string)datos.Lector["NombreArea"];

                    usuario.Empresa = new Empresa();
                    usuario.Empresa.Id = (int)datos.Lector["IdEmpresa"];

                    if (datos.Lector["IdSeniority"] != DBNull.Value)
                    {
                        usuario.Seniority = new Seniority();
                        usuario.Seniority.Id = (int)datos.Lector["IdSeniority"];
                        usuario.Seniority.Nombre = (string)datos.Lector["NombreSeniority"];
                    }

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
                                             PermisoEscritura, EmailVerificado, IdPuesto, IdArea, IdEmpresa, EsAdmin, IdSeniority)
                        VALUES (@NombreUsuario, @Password, @Email, @Nombre, @Apellido, 0, 1, 0, @IdPuestoOwner, @IdAreaOwner, @IdEmpresa, 1, NULL);

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
        public Usuario BuscarPorId(int id)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta(@"SELECT U.Id, U.NombreUsuario, U.Email, U.Nombre, U.Apellido, 
                                              U.Activo, U.PermisoEscritura, U.EsAdmin, U.EmailVerificado,
                                              U.IdSeniority, S.Nombre AS NombreSeniority,
                                              U.IdPuesto, P.Nombre AS NombrePuesto,
                                              U.IdArea, A.Nombre AS NombreArea, U.IdEmpresa, E.Nombre as NombreEmpresa
                                       FROM USUARIO U
                                       INNER JOIN PUESTO P ON U.IdPuesto = P.Id
                                       INNER JOIN AREA A ON U.IdArea = A.Id
                                       INNER JOIN EMPRESA E ON U.IdEmpresa = E.id
                                       LEFT JOIN SENIORITY S ON U.IdSeniority = S.Id
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
                    usuario.EsAdmin = (bool)datos.Lector["EsAdmin"];
                    usuario.EmailVerificado = (bool)datos.Lector["EmailVerificado"];

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

                    if (datos.Lector["IdSeniority"] != DBNull.Value)
                    {
                        usuario.Seniority = new Seniority();
                        usuario.Seniority.Id = (int)datos.Lector["IdSeniority"];
                        usuario.Seniority.Nombre = (string)datos.Lector["NombreSeniority"];
                    }

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
                datos.setearConsulta(@"UPDATE USUARIO SET 
                                                    NombreUsuario = @NombreUsuario,
                                                    Email = @Email,
                                                    Nombre = @Nombre, 
                                                    Apellido = @Apellido, 
                                                    Activo = @Activo,
                                                    PermisoEscritura = @PermisoEscritura,
                                                    IdPuesto = @IdPuesto, 
                                                    IdArea = @IdArea,
                                                    EsAdmin = @EsAdmin,
                                                    IdSeniority = @IdSeniority
                                       WHERE Id = @Id");

                datos.setearParametro("@NombreUsuario", usuario.NombreUsuario);
                datos.setearParametro("@Email", usuario.Email);
                datos.setearParametro("@Nombre", usuario.Nombre);
                datos.setearParametro("@Apellido", usuario.Apellido);
                datos.setearParametro("@Activo", usuario.Activo);
                datos.setearParametro("@PermisoEscritura", usuario.PermisoEscritura);
                datos.setearParametro("@IdPuesto", usuario.Puesto.Id);
                datos.setearParametro("@IdArea", usuario.Area.Id);
                datos.setearParametro("@EsAdmin", usuario.EsAdmin);
                datos.setearParametro("@IdSeniority", usuario.Seniority != null ? (object)usuario.Seniority.Id : DBNull.Value);
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
        public List<Usuario> listar(int idEmpresa, int idArea = 0, string filtro = "")
        {
            AccesoDatos datos = new AccesoDatos();
            List<Usuario> lista = new List<Usuario>();
            try
            {
                if (idArea == 0 && filtro == "")
                {
                    datos.setearConsulta(@"SELECT U.Id, U.NombreUsuario, U.Email, U.Nombre, U.Apellido, U.EsAdmin, 
                                                  U.Activo, U.PermisoEscritura, U.EmailVerificado,
                                                  U.IdPuesto, P.Nombre AS NombrePuesto,
                                                  U.IdArea, A.Nombre AS NombreArea, U.IdEmpresa,
                                                  U.IdSeniority, S.Nombre AS NombreSeniority
                                           FROM USUARIO U
                                           INNER JOIN PUESTO P ON U.IdPuesto = P.Id
                                           INNER JOIN AREA A ON U.IdArea = A.Id
                                           LEFT JOIN SENIORITY S ON U.IdSeniority = S.Id
                                           WHERE U.IdEmpresa = @IdEmpresa
                                           ORDER BY U.Activo DESC, U.Apellido ASC, U.Nombre ASC"
                    );
                }
                else if (idArea != 0)
                {
                    datos.setearConsulta(@"SELECT U.Id, U.NombreUsuario, U.Email, U.Nombre, U.Apellido, U.EsAdmin,
                                                  U.Activo, U.PermisoEscritura, U.EmailVerificado,
                                                  U.IdPuesto, P.Nombre AS NombrePuesto,
                                                  U.IdArea, A.Nombre AS NombreArea, U.IdEmpresa,
                                                  U.IdSeniority, S.Nombre AS NombreSeniority
                                           FROM USUARIO U
                                           INNER JOIN PUESTO P ON U.IdPuesto = P.Id
                                           INNER JOIN AREA A ON U.IdArea = A.Id
                                           LEFT JOIN SENIORITY S ON U.IdSeniority = S.Id
                                           WHERE U.IdEmpresa = @IdEmpresa AND U.IdArea = @IdArea
                                           ORDER BY U.Activo DESC, U.Apellido ASC, U.Nombre ASC"
                    );
                    datos.setearParametro("@IdArea", idArea);
                }
                else
                {
                    datos.setearConsulta(@"SELECT U.Id, U.NombreUsuario, U.Email, U.Nombre, U.Apellido, U.EsAdmin,
                                                  U.Activo, U.PermisoEscritura, U.EmailVerificado,
                                                  U.IdPuesto, P.Nombre AS NombrePuesto,
                                                  U.IdArea, A.Nombre AS NombreArea, U.IdEmpresa,
                                                  U.IdSeniority, S.Nombre AS NombreSeniority
                                           FROM USUARIO U
                                           INNER JOIN PUESTO P ON U.IdPuesto = P.Id
                                           INNER JOIN AREA A ON U.IdArea = A.Id
                                           LEFT JOIN SENIORITY S ON U.IdSeniority = S.Id
                                           WHERE U.IdEmpresa = @IdEmpresa
                                           AND (U.Apellido LIKE @FiltroLike
                                                OR U.Nombre LIKE @FiltroLike
                                                OR U.NombreUsuario LIKE @FiltroLike
                                                OR U.Email LIKE @FiltroLike
                                                OR A.Nombre LIKE @FiltroLike
                                                OR P.Nombre LIKE @FiltroLike
                                                OR S.Nombre LIKE @FiltroLike)
                                           ORDER BY U.Activo DESC, U.Apellido ASC, U.Nombre ASC");
                    datos.setearParametro("@FiltroLike", "%" + filtro + "%");
                }

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
                    usuario.EsAdmin = (bool)datos.Lector["EsAdmin"];
                    usuario.EmailVerificado = (bool)datos.Lector["EmailVerificado"];

                    usuario.Puesto = new Puesto();
                    usuario.Puesto.Id = (int)datos.Lector["IdPuesto"];
                    usuario.Puesto.Nombre = (string)datos.Lector["NombrePuesto"];

                    usuario.Area = new Area();
                    usuario.Area.Id = (int)datos.Lector["IdArea"];
                    usuario.Area.Nombre = (string)datos.Lector["NombreArea"];

                    usuario.Empresa = new Empresa();
                    usuario.Empresa.Id = (int)datos.Lector["IdEmpresa"];

                    if (datos.Lector["IdSeniority"] != DBNull.Value)
                    {
                        usuario.Seniority = new Seniority();
                        usuario.Seniority.Id = (int)datos.Lector["IdSeniority"];
                        usuario.Seniority.Nombre = (string)datos.Lector["NombreSeniority"];
                    }

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
        public int AgregarInvitado(Usuario nuevoUsuario)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta(@" INSERT INTO USUARIO (NombreUsuario, PasswordHash, Email, Nombre, Apellido, Activo, 
                                                             PermisoEscritura, EmailVerificado, IdPuesto, IdArea, IdEmpresa,
                                                             EsAdmin, IdSeniority)
                                        VALUES (@NombreUsuario, @PasswordHash, @Email, @Nombre, @Apellido, 0, @PermisoEscritura, 0, 
                                                @IdPuesto, @IdArea, @IdEmpresa, @EsAdmin, @IdSeniority);
                                        SELECT CAST(SCOPE_IDENTITY() AS INT);
                ");

                datos.setearParametro("@NombreUsuario", nuevoUsuario.NombreUsuario);
                datos.setearParametro("@PasswordHash", nuevoUsuario.PasswordHash);
                datos.setearParametro("@Email", nuevoUsuario.Email);
                datos.setearParametro("@Nombre", nuevoUsuario.Nombre);
                datos.setearParametro("@Apellido", nuevoUsuario.Apellido);
                datos.setearParametro("@PermisoEscritura", nuevoUsuario.PermisoEscritura);
                datos.setearParametro("@IdPuesto", nuevoUsuario.Puesto.Id);
                datos.setearParametro("@IdArea", nuevoUsuario.Area.Id);
                datos.setearParametro("@IdEmpresa", nuevoUsuario.Empresa.Id);
                datos.setearParametro("@EsAdmin", nuevoUsuario.EsAdmin);
                datos.setearParametro("@IdSeniority", nuevoUsuario.Seniority != null ? (object)nuevoUsuario.Seniority.Id : DBNull.Value);

                return datos.ejecutarScalar();
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
        public void CrearPassInvitado(Usuario usuario, string pass)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta(@" UPDATE USUARIO SET PasswordHash = @PasswordHash, EmailVerificado = 1, Activo = 1
                                        WHERE Id = @Id
                ");

                datos.setearParametro("@PasswordHash", pass);
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
        public bool MailPendienteVerificacion(Usuario usuario)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta(@" SELECT COUNT(1) FROM USUARIO
                                        WHERE NombreUsuario = @NombreUsuario AND PasswordHash = @PasswordHash AND EmailVerificado = 0
                ");

                datos.setearParametro("@NombreUsuario", usuario.NombreUsuario);
                datos.setearParametro("@PasswordHash", usuario.PasswordHash);
                return datos.ejecutarScalar() > 0;

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
        public string ObtenerDuplicadoUsuario(string nombreUsuario, string email, int id = 0)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta(@"SELECT(SELECT COUNT(*) 
                                       FROM USUARIO 
                                       WHERE NombreUsuario = @NombreUsuario
                                         AND Id <> @Id) AS CoincidenciasUsuario,
                                       (SELECT COUNT(*) 
                                        FROM USUARIO 
                                        WHERE Email = @Email
                                          AND Id <> @Id) AS CoincidenciasEmail
        ");

                datos.setearParametro("@NombreUsuario", nombreUsuario);
                datos.setearParametro("@Email", email);
                datos.setearParametro("@Id", id);

                datos.ejecutarLectura();

                if (datos.Lector.Read())
                {
                    bool usuarioRepetido = (int)datos.Lector["CoincidenciasUsuario"] > 0;
                    bool emailRepetido = (int)datos.Lector["CoincidenciasEmail"] > 0;

                    if (usuarioRepetido && emailRepetido)
                        return "ambos";

                    if (usuarioRepetido)
                        return "usuario";

                    if (emailRepetido)
                        return "email";
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
        public Usuario BuscarPorNombreUsuarioOEmail(string nombreUsuario)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta(@"SELECT Id, NombreUsuario, Email, Nombre, Apellido, Activo, EmailVerificado
                                       FROM USUARIO
                                       WHERE NombreUsuario = @NombreUsuario
                                       OR Email = @NombreUsuario");

                datos.setearParametro("@NombreUsuario", nombreUsuario);
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
                    usuario.EmailVerificado = (bool)datos.Lector["EmailVerificado"];
                    return usuario;
                }

                return null;
            }
            finally
            {
                datos.cerrarConexion();
            }
        }
        public bool CambiarPasswordUsuarioActivo(Usuario usuario, string pass)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta(@"UPDATE USUARIO
                                       SET PasswordHash = @PasswordHash
                                       WHERE Id = @Id
                                         AND Activo = 1
                                         AND EmailVerificado = 1;
                                       SELECT @@ROWCOUNT;");

                datos.setearParametro("@PasswordHash", pass);
                datos.setearParametro("@Id", usuario.Id);

                return datos.ejecutarScalar() > 0;
            }
            finally
            {
                datos.cerrarConexion();
            }
        }
        public bool VerificarPasswordActual(int idUsuario, string passwordActual)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta(@"SELECT COUNT(1)
                                       FROM USUARIO
                                       WHERE Id = @Id
                                         AND PasswordHash = @PasswordActual"
                );
                datos.setearParametro("@Id", idUsuario);
                datos.setearParametro("@PasswordActual", passwordActual);
                return datos.ejecutarScalar() > 0;
            }
            finally
            {
                datos.cerrarConexion();
            }
        }
    }
}
