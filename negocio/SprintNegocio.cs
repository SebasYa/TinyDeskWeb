using dominio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace negocio
{
    public class SprintNegocio
    {
        public void Agregar(Sprint sprint)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta(@"
                    INSERT INTO SPRINT 
                    ( NumeroSprint, FechaInicio,FechaFin, FechaEstimadaFin, Activo, IdProyecto, IdEstado, IdArea)
                    VALUES (@NumeroSprint, @FechaInicio,@FechaFin, @FechaEstimadaFin, @Activo, @IdProyecto, @IdEstado, @IdArea)
                    SELECT SCOPE_IDENTITY();"
                );
                datos.setearParametro("@NumeroSprint", sprint.NumeroSprint);
                datos.setearParametro("@FechaInicio", sprint.FechaInicio);
                if (sprint.FechaFin.HasValue)
                {
                    datos.setearParametro("@FechaFin", sprint.FechaFin.Value);
                }
                else
                {
                    datos.setearParametro("@FechaFin", DBNull.Value);
                }
                datos.setearParametro("@FechaEstimadaFin", sprint.FechaEstimadaFin);
                datos.setearParametro("@Activo", sprint.Activo);
                datos.setearParametro("@IdProyecto", sprint.Proyecto.Id);
                datos.setearParametro("@IdEstado", sprint.Estado.Id);
                datos.setearParametro("@IdArea", sprint.Area.Id);

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
        public int ContarEnCurso(int idEmpresa)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta(@"
                    SELECT COUNT(*)
                    FROM SPRINT S
                    INNER JOIN ESTADO E ON S.IdEstado = E.Id
                    WHERE E.EsFinal = 0
                ");
                /*despues agregar idEmpresa en la bbdd de sprints y agregar este en la query  AND IdEmpresa = @idEmpresa*/
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

        public int ObtenerSiguienteNumeroSprint(int idProyecto)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                
                datos.setearConsulta("SELECT ISNULL(MAX(NumeroSprint), 0) + 1 AS Siguiente FROM SPRINT WHERE IdProyecto = @idProyecto");
                datos.setearParametro("@idProyecto", idProyecto);
                datos.ejecutarLectura();

                if (datos.Lector.Read())
                {
                    return (int)datos.Lector["Siguiente"];
                }

                return 1; 
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
