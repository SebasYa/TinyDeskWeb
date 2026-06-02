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

        public List<Sprint> listar(int idEmpresa)
        {
            List<Sprint> lista = new List<Sprint>();
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta(@"
                    SELECT S.Id, S.NumeroSprint, S.FechaInicio, S.FechaEstimadaFin, S.FechaFin, S.Activo, 
                           P.Nombre AS NombreProyecto, E.Id AS IdEstado, E.Nombre AS NombreEstado, 
                           E.EsFinal, E.EsSistema, A.Nombre AS NombreArea,
                           CASE 
                                WHEN E.EsFinal = 1 THEN 100
                                WHEN GETDATE() < S.FechaInicio THEN 0
                                WHEN GETDATE() > S.FechaEstimadaFin THEN 100
                                ELSE (DATEDIFF(DAY, S.FechaInicio, GETDATE()) * 100) / NULLIF(DATEDIFF(DAY, S.FechaInicio, S.FechaEstimadaFin), 0)
                           END AS Progreso
                    FROM SPRINT S
                    INNER JOIN ESTADO E ON E.Id = S.IdEstado
                    INNER JOIN PROYECTO P ON P.Id = S.IdProyecto
                    INNER JOIN AREA A ON A.Id = S.IdArea
                    WHERE P.IdEmpresa = @IdEmpresa  
                ");
                datos.setearParametro("@IdEmpresa", idEmpresa);
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    Sprint aux = new Sprint();
                    aux.Id = (int)datos.Lector["Id"];
                    aux.NumeroSprint = (int)datos.Lector["NumeroSprint"];
                    aux.FechaInicio = (DateTime)datos.Lector["FechaInicio"];
                    aux.FechaEstimadaFin = (DateTime)datos.Lector["FechaEstimadaFin"];
                    if (datos.Lector["FechaFin"] != DBNull.Value)
                    {
                        aux.FechaFin = (DateTime)datos.Lector["FechaFin"];
                    }
                    aux.Activo = (bool)datos.Lector["Activo"];
                    aux.Estado = new Estado();
                    aux.Estado.Id = (int)datos.Lector["IdEstado"];
                    aux.Estado.Nombre = (string)datos.Lector["NombreEstado"];
                    aux.Estado.EsFinal = (bool)datos.Lector["EsFinal"];
                    aux.Estado.EsSistema = (bool)datos.Lector["EsSistema"];
                    aux.Proyecto = new Proyecto();
                    aux.Proyecto.Nombre = (string)datos.Lector["NombreProyecto"];
                    aux.Area = new Area();
                    aux.Area.Nombre = (string)datos.Lector["NombreArea"];
                    aux.Progreso = (int)datos.Lector["Progreso"];

                    lista.Add(aux);
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
