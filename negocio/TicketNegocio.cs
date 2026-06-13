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
    }
}
