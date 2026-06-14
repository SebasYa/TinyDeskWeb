using dominio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace negocio
{
    public class TicketNegocio
    {
        public int ContarAbiertos(int idEmpresa)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta(@"SELECT COUNT(*)
                                       FROM TICKET T
                                       INNER JOIN ESTADO E ON T.IdEstado = E.Id
                                       INNER JOIN SPRINT S ON T.IdSprint = S.Id
                                       INNER JOIN PROYECTO P ON S.IdProyecto = P.Id
                                       WHERE T.Activo = 1 
                                         AND E.EsFinal = 0 
                                         AND P.IdEmpresa = @idEmpresa
                ");
                datos.setearParametro("@idEmpresa", idEmpresa);
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
        public int ContarAsignadosUsuariosDesactivados(int idEmpresa)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta(@"SELECT COUNT(*)
                                       FROM TICKET T
                                       INNER JOIN USUARIO U ON T.IdUsuario = U.Id
                                       INNER JOIN SPRINT S ON T.IdSprint = S.Id
                                       INNER JOIN PROYECTO P ON S.IdProyecto = P.Id
                                       WHERE T.Activo = 1 
                                         AND U.Activo = 0 
                                         AND U.EmailVerificado = 1
                                         AND P.IdEmpresa = @idEmpresa
                "); ;
                datos.setearParametro("@idEmpresa", idEmpresa);
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
        public int AgregarTicket(Ticket ticket)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta(@"INSERT INTO TICKET(FechaInicio, FechaEstimadaFin, Descripcion, Activo, IdPrioridad, IdUsuario, IdEstado, IdSprint)
                                       VALUES(@FechaInicio, @FechaEstimadaFin, @Descripcion, @Activo, @IdPrioridad, @IdUsuario, @IdEstado, @IdSprint);
                                       SELECT CAST(SCOPE_IDENTITY() AS INT);
                                    ");

                datos.setearParametro("@FechaInicio", ticket.FechaInicio);
                datos.setearParametro("@FechaEstimadaFin", ticket.FechaEstimadaFin);
                datos.setearParametro("@Descripcion", ticket.Descripcion);
                datos.setearParametro("@Activo", ticket.Activo);
                datos.setearParametro("@IdPrioridad", ticket.Prioridad.Id);
                datos.setearParametro("@IdUsuario", ticket.Usuario.Id);
                datos.setearParametro("@IdEstado", ticket.Estado.Id);
                datos.setearParametro("@IdSprint", ticket.Sprint.Id);

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
        public List<Ticket> ListarAsignadosUsuariosDesactivados(int idEmpresa)
        {
            List<Ticket> lista = new List<Ticket>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta(@"SELECT T.Id, T.FechaInicio, T.FechaFin, T.FechaEstimadaFin, T.Descripcion, T.Activo,
                                              PR.Id AS IdPrioridad, PR.Nombre AS NombrePrioridad,
                                              U.Id AS IdUsuario, U.Nombre AS NombreUsuario, U.Apellido AS ApellidoUsuario,
                                              U.NombreUsuario AS UserName, U.Email,
                                              A.Id AS IdArea, A.Nombre AS NombreArea,
                                              PUE.Id AS IdPuesto, PUE.Nombre AS NombrePuesto,
                                              SEN.Id AS IdSeniority, SEN.Nombre AS NombreSeniority,
                                              E.Id AS IdEstado, E.Nombre AS NombreEstado, E.EsFinal, E.EsSistema,
                                              S.Id AS IdSprint, S.NumeroSprint,
                                              PRO.Id AS IdProyecto, PRO.Nombre AS NombreProyecto
                                       FROM TICKET T
                                       INNER JOIN PRIORIDAD PR ON PR.Id = T.IdPrioridad
                                       INNER JOIN USUARIO U ON U.Id = T.IdUsuario
                                       INNER JOIN AREA A ON A.Id = U.IdArea
                                       INNER JOIN PUESTO PUE ON PUE.Id = U.IdPuesto
                                       INNER JOIN ESTADO E ON E.Id = T.IdEstado
                                       INNER JOIN SPRINT S ON S.Id = T.IdSprint
                                       INNER JOIN PROYECTO PRO ON PRO.Id = S.IdProyecto
                                       LEFT JOIN SENIORITY SEN ON SEN.Id = U.IdSeniority
                                       WHERE T.Activo = 1
                                         AND U.Activo = 0
                                         AND U.EmailVerificado = 1
                                         AND PRO.IdEmpresa = @IdEmpresa
                                       ORDER BY T.FechaEstimadaFin ASC
                ");

                datos.setearParametro("@IdEmpresa", idEmpresa);
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    Ticket ticket = new Ticket();

                    ticket.Id = (int)datos.Lector["Id"];
                    ticket.FechaInicio = (DateTime)datos.Lector["FechaInicio"];
                    ticket.FechaEstimadaFin = (DateTime)datos.Lector["FechaEstimadaFin"];

                    if (datos.Lector["FechaFin"] != DBNull.Value)
                        ticket.FechaFin = (DateTime)datos.Lector["FechaFin"];

                    ticket.Descripcion = (string)datos.Lector["Descripcion"];
                    ticket.Activo = (bool)datos.Lector["Activo"];

                    ticket.Prioridad = new Prioridad();
                    ticket.Prioridad.Id = (int)datos.Lector["IdPrioridad"];
                    ticket.Prioridad.Nombre = (string)datos.Lector["NombrePrioridad"];

                    ticket.Usuario = new Usuario();
                    ticket.Usuario.Id = (int)datos.Lector["IdUsuario"];
                    ticket.Usuario.Nombre = (string)datos.Lector["NombreUsuario"];
                    ticket.Usuario.Apellido = (string)datos.Lector["ApellidoUsuario"];
                    ticket.Usuario.NombreUsuario = (string)datos.Lector["UserName"];
                    ticket.Usuario.Email = (string)datos.Lector["Email"];

                    ticket.Usuario.Area = new Area();
                    ticket.Usuario.Area.Id = (int)datos.Lector["IdArea"];
                    ticket.Usuario.Area.Nombre = (string)datos.Lector["NombreArea"];

                    ticket.Usuario.Puesto = new Puesto();
                    ticket.Usuario.Puesto.Id = (int)datos.Lector["IdPuesto"];
                    ticket.Usuario.Puesto.Nombre = (string)datos.Lector["NombrePuesto"];

                    if (datos.Lector["IdSeniority"] != DBNull.Value)
                    {
                        ticket.Usuario.Seniority = new Seniority();
                        ticket.Usuario.Seniority.Id = (int)datos.Lector["IdSeniority"];
                        ticket.Usuario.Seniority.Nombre = (string)datos.Lector["NombreSeniority"];
                    }

                    ticket.Estado = new Estado();
                    ticket.Estado.Id = (int)datos.Lector["IdEstado"];
                    ticket.Estado.Nombre = (string)datos.Lector["NombreEstado"];
                    ticket.Estado.EsFinal = (bool)datos.Lector["EsFinal"];
                    ticket.Estado.EsSistema = (bool)datos.Lector["EsSistema"];

                    ticket.Sprint = new Sprint();
                    ticket.Sprint.Id = (int)datos.Lector["IdSprint"];
                    ticket.Sprint.NumeroSprint = (int)datos.Lector["NumeroSprint"];

                    ticket.Sprint.Proyecto = new Proyecto();
                    ticket.Sprint.Proyecto.Id = (int)datos.Lector["IdProyecto"];
                    ticket.Sprint.Proyecto.Nombre = (string)datos.Lector["NombreProyecto"];

                    lista.Add(ticket);
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
        public void ReasignarUsuario(int idTicket, int idUsuario)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta(@"UPDATE TICKET
                                       SET IdUsuario = @IdUsuario
                                       WHERE Id = @IdTicket
                                         AND EXISTS (
                                             SELECT 1
                                             FROM USUARIO
                                             WHERE Id = @IdUsuario
                                               AND Activo = 1
                                               AND EmailVerificado = 1)"
                );

                datos.setearParametro("@IdUsuario", idUsuario);
                datos.setearParametro("@IdTicket", idTicket);

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

        public List<Ticket> Listar(int idEmpresa)
        {
            List<Ticket> lista = new List<Ticket>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta(@"
            SELECT T.Id, T.FechaInicio, T.FechaFin, T.FechaEstimadaFin, T.Descripcion, T.Activo,
                   PR.Id AS IdPrioridad, PR.Nombre AS NombrePrioridad,
                   U.Id AS IdUsuario, U.Nombre AS NombreUsuario, U.Apellido AS ApellidoUsuario,
                   E.Id AS IdEstado, E.Nombre AS NombreEstado, E.EsFinal, E.EsSistema,
                   S.Id AS IdSprint, S.NumeroSprint,
                   P.Id AS IdProyecto, P.Nombre AS NombreProyecto
            FROM TICKET T
            INNER JOIN PRIORIDAD PR ON PR.Id = T.IdPrioridad
            INNER JOIN USUARIO U ON U.Id = T.IdUsuario
            INNER JOIN ESTADO E ON E.Id = T.IdEstado
            INNER JOIN SPRINT S ON S.Id = T.IdSprint
            INNER JOIN PROYECTO P ON P.Id = S.IdProyecto
            WHERE P.IdEmpresa = @IdEmpresa AND T.Activo = 1
            ORDER BY T.FechaEstimadaFin ASC
        ");

                datos.setearParametro("@IdEmpresa", idEmpresa);
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    Ticket ticket = new Ticket();
                    ticket.Id = (int)datos.Lector["Id"];
                    ticket.FechaInicio = (DateTime)datos.Lector["FechaInicio"];
                    ticket.FechaEstimadaFin = (DateTime)datos.Lector["FechaEstimadaFin"];

                    if (datos.Lector["FechaFin"] != DBNull.Value)
                        ticket.FechaFin = (DateTime)datos.Lector["FechaFin"];

                    ticket.Descripcion = (string)datos.Lector["Descripcion"];
                    ticket.Activo = (bool)datos.Lector["Activo"];

                    ticket.Prioridad = new Prioridad();
                    ticket.Prioridad.Id = (int)datos.Lector["IdPrioridad"];
                    ticket.Prioridad.Nombre = (string)datos.Lector["NombrePrioridad"];

                    ticket.Usuario = new Usuario();
                    ticket.Usuario.Id = (int)datos.Lector["IdUsuario"];
                    ticket.Usuario.Nombre = (string)datos.Lector["NombreUsuario"];
                    ticket.Usuario.Apellido = (string)datos.Lector["ApellidoUsuario"];

                    ticket.Estado = new Estado();
                    ticket.Estado.Id = (int)datos.Lector["IdEstado"];
                    ticket.Estado.Nombre = (string)datos.Lector["NombreEstado"];
                    ticket.Estado.EsFinal = (bool)datos.Lector["EsFinal"];
                    ticket.Estado.EsSistema = (bool)datos.Lector["EsSistema"];

                    ticket.Sprint = new Sprint();
                    ticket.Sprint.Id = (int)datos.Lector["IdSprint"];
                    ticket.Sprint.NumeroSprint = (int)datos.Lector["NumeroSprint"];
                    ticket.Sprint.Proyecto = new Proyecto();
                    ticket.Sprint.Proyecto.Id = (int)datos.Lector["IdProyecto"];
                    ticket.Sprint.Proyecto.Nombre = (string)datos.Lector["NombreProyecto"];

                    lista.Add(ticket);
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
