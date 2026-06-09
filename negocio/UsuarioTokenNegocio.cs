using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using dominio;

namespace negocio
{
    public class UsuarioTokenNegocio
    {
        public UsuarioToken CrearToken(Usuario usuario, string tipo, int horasDuracion)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                UsuarioToken usuarioToken = new UsuarioToken();
                usuarioToken.Usuario = usuario;
                usuarioToken.Token = TokenHelper.GenerarToken();
                usuarioToken.Tipo = tipo;
                usuarioToken.FechaCreacion = DateTime.Now;
                usuarioToken.FechaExpiracion = DateTime.Now.AddHours(horasDuracion);
                usuarioToken.Usado = false;
                datos.setearConsulta(@"INSERT INTO USUARIO_TOKEN
                                       (IdUsuario, Token, Tipo, FechaCreacion, FechaExpiracion, Usado)
                                       VALUES (@IdUsuario, @Token, @Tipo, @FechaCreacion, @FechaExpiracion, @Usado)              
                ");
                datos.setearParametro("@IdUsuario", usuarioToken.Usuario.Id);
                datos.setearParametro("@Token", usuarioToken.Token);
                datos.setearParametro("@Tipo", usuarioToken.Tipo);
                datos.setearParametro("@FechaCreacion", usuarioToken.FechaCreacion);
                datos.setearParametro("@FechaExpiracion", usuarioToken.FechaExpiracion);
                datos.setearParametro("@Usado", usuarioToken.Usado);

                datos.ejecutarAccion();
                return usuarioToken;

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

        public UsuarioToken BuscarTokenValido(string token, string tipo)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta(@"
                    SELECT 
                        UT.Id,
                        UT.Token,
                        UT.Tipo,
                        UT.FechaCreacion,
                        UT.FechaExpiracion,
                        UT.FechaUso,
                        UT.Usado,
                        U.Id AS IdUsuario,
                        U.NombreUsuario,
                        U.Email,
                        U.Nombre,
                        U.Apellido
                    FROM USUARIO_TOKEN UT
                    INNER JOIN USUARIO U ON UT.IdUsuario = U.Id
                    WHERE UT.Token = @Token
                    AND UT.Tipo = @Tipo
                    AND UT.Usado = 0
                    AND UT.FechaExpiracion > GETDATE()
                ");

                datos.setearParametro("@Token", token);
                datos.setearParametro("@Tipo", tipo);

                datos.ejecutarLectura();

                if (datos.Lector.Read())
                {
                    Usuario usuario = new Usuario();
                    usuario.Id = (int)datos.Lector["IdUsuario"];
                    usuario.NombreUsuario = (string)datos.Lector["NombreUsuario"];
                    usuario.Email = (string)datos.Lector["Email"];
                    usuario.Nombre = (string)datos.Lector["Nombre"];
                    usuario.Apellido = (string)datos.Lector["Apellido"];

                    UsuarioToken usuarioToken = new UsuarioToken();
                    usuarioToken.Id = (int)datos.Lector["Id"];
                    usuarioToken.Usuario = usuario;
                    usuarioToken.Token = (string)datos.Lector["Token"];
                    usuarioToken.Tipo = (string)datos.Lector["Tipo"];
                    usuarioToken.FechaCreacion = (DateTime)datos.Lector["FechaCreacion"];
                    usuarioToken.FechaExpiracion = (DateTime)datos.Lector["FechaExpiracion"];
                    usuarioToken.Usado = (bool)datos.Lector["Usado"];

                    return usuarioToken;
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

        public void MarcarComoUsado(UsuarioToken usuarioToken)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta(@"
                    UPDATE USUARIO_TOKEN
                    SET Usado = 1,
                        FechaUso = GETDATE()
                    WHERE Id = @Id
                ");

                datos.setearParametro("@Id", usuarioToken.Id);
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

        public string ObtenerEstadoInvitacion(int idUsuario, bool emailVerificado)
        {
            if (emailVerificado)
                return "Ok";

            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta(@"SELECT TOP 1 FechaExpiracion, Usado
                                       FROM USUARIO_TOKEN
                                       WHERE IdUsuario = @IdUsuario
                                         AND Tipo = 'CrearPassword'
                                       ORDER BY FechaCreacion DESC, Id DESC"
                                    );

                datos.setearParametro("@IdUsuario", idUsuario);
                datos.ejecutarLectura();

                if (datos.Lector.Read())
                {
                    bool usado = (bool)datos.Lector["Usado"];
                    DateTime fechaExpiracion = (DateTime)datos.Lector["FechaExpiracion"];

                    if (!usado && fechaExpiracion > DateTime.Now)
                        return "Pendiente";
                }

                return "Vencida";
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
        public void InvalidarTokensPendientes(int idUsuario, string tipo)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta(@"UPDATE USUARIO_TOKEN
                                       SET Usado = 1,
                                           FechaUso = GETDATE()
                                       WHERE IdUsuario = @IdUsuario
                                         AND Tipo = @Tipo
                                         AND Usado = 0"
                );

                datos.setearParametro("@IdUsuario", idUsuario);
                datos.setearParametro("@Tipo", tipo);
                datos.ejecutarAccion();
            }
            finally
            {
                datos.cerrarConexion();
            }
        }
    }
}
