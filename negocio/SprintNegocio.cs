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

        public bool Modificar(Sprint sprint)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                string consulta = @"UPDATE SPRINT SET 
                                        NumeroSprint = @NumeroSprint , 
                                        --FechaInicio = @FechaInicio,
                                        FechaFin = @FechaFin, 
                                        FechaEstimadaFin = @FechaEstimadaFin, 
                                        Activo = @Activo, 
                                        IdProyecto = @IdProyecto, 
                                        IdEstado = @IdEstado, 
                                        IdArea = @IdArea";

                consulta += " WHERE Id = @Id";
                datos.setearConsulta(consulta);

                datos.setearParametro("@NumeroSprint", sprint.NumeroSprint);
                //datos.setearParametro("@FechaInicio", sprint.FechaInicio);
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
                datos.setearParametro("@Id", sprint.Id);

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

        public bool Desactivar(Sprint sprint)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                string consulta = @"UPDATE SPRINT SET  
                                        Activo = 0 
                                        WHERE Id = @Id";
                datos.setearConsulta(consulta);
                datos.setearParametro("@Activo", sprint.Activo);
                datos.setearParametro("@Id", sprint.Id);

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

        public List<Sprint> listar(int idEmpresa)
        {
            List<Sprint> lista = new List<Sprint>();
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta(@"
                    SELECT S.Id, S.NumeroSprint, S.FechaInicio, S.FechaEstimadaFin, S.FechaFin, S.Activo, 
                           P.Nombre AS NombreProyecto,P.Id AS IdProyecto, E.Id AS IdEstado, E.Nombre AS NombreEstado, 
                           E.EsFinal, E.EsSistema, A.Nombre AS NombreArea, A.Id AS IdArea,
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
                    WHERE P.IdEmpresa = @IdEmpresa  AND S.Activo = 1
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
                    aux.Proyecto.Id = (int)datos.Lector["IdProyecto"];
                    aux.Proyecto.Nombre = (string)datos.Lector["NombreProyecto"];
                    aux.Area = new Area();
                    aux.Area.Id = (int)datos.Lector["IdArea"];
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
                    INNER JOIN PROYECTO P ON S.IdProyecto = P.Id
                    INNER JOIN EMPRESA E ON P.IdEmpresa = E.Id
                    WHERE S.Activo = 1 AND P.IdEmpresa = @IdEmpresa
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
        public List<Sprint> listarPorProyecto(int idProyecto, int idEmpresa, int idUsuario = 0)
        {
            List<Sprint> lista = new List<Sprint>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                if (idUsuario == 0)
                {
                    datos.setearConsulta(@"SELECT S.Id, S.NumeroSprint, S.FechaInicio, S.FechaEstimadaFin, S.FechaFin, S.Activo, 
                                              P.Nombre AS NombreProyecto, P.Id AS IdProyecto,
                                              E.Id AS IdEstado, E.Nombre AS NombreEstado, E.EsFinal, E.EsSistema,
                                              A.Nombre AS NombreArea, A.Id AS IdArea
                                       FROM SPRINT S
                                       INNER JOIN ESTADO E ON E.Id = S.IdEstado
                                       INNER JOIN PROYECTO P ON P.Id = S.IdProyecto
                                       INNER JOIN AREA A ON A.Id = S.IdArea
                                       WHERE P.Id = @IdProyecto
                                         AND P.IdEmpresa = @IdEmpresa");

                    datos.setearParametro("@IdProyecto", idProyecto);
                    datos.setearParametro("@IdEmpresa", idEmpresa);
                    datos.ejecutarLectura();

                    while (datos.Lector.Read())
                    {
                        Sprint sprint = new Sprint();
                        sprint.Id = (int)datos.Lector["Id"];
                        sprint.NumeroSprint = (int)datos.Lector["NumeroSprint"];
                        sprint.FechaInicio = (DateTime)datos.Lector["FechaInicio"];
                        sprint.FechaEstimadaFin = (DateTime)datos.Lector["FechaEstimadaFin"];

                        if (datos.Lector["FechaFin"] != DBNull.Value)
                            sprint.FechaFin = (DateTime)datos.Lector["FechaFin"];

                        sprint.Activo = (bool)datos.Lector["Activo"];

                        sprint.Proyecto = new Proyecto();
                        sprint.Proyecto.Id = (int)datos.Lector["IdProyecto"];
                        sprint.Proyecto.Nombre = (string)datos.Lector["NombreProyecto"];

                        sprint.Estado = new Estado();
                        sprint.Estado.Id = (int)datos.Lector["IdEstado"];
                        sprint.Estado.Nombre = (string)datos.Lector["NombreEstado"];
                        sprint.Estado.EsFinal = (bool)datos.Lector["EsFinal"];
                        sprint.Estado.EsSistema = (bool)datos.Lector["EsSistema"];

                        sprint.Area = new Area();
                        sprint.Area.Id = (int)datos.Lector["IdArea"];
                        sprint.Area.Nombre = (string)datos.Lector["NombreArea"];

                        lista.Add(sprint);
                    }
                }
                else
                {
                    datos.setearConsulta(@"SELECT DISTINCT
                                                  S.Id,
                                                  S.NumeroSprint,
                                                  S.FechaInicio,
                                                  S.FechaEstimadaFin,
                                                  S.FechaFin,
                                                  S.Activo,
                                                  P.Nombre AS NombreProyecto,
                                                  P.Id AS IdProyecto,
                                                  E.Id AS IdEstado,
                                                  E.Nombre AS NombreEstado,
                                                  E.EsFinal,
                                                  E.EsSistema,
                                                  A.Nombre AS NombreArea,
                                                  A.Id AS IdArea
                                           FROM SPRINT S
                                           INNER JOIN ESTADO E ON E.Id = S.IdEstado
                                           INNER JOIN PROYECTO P ON P.Id = S.IdProyecto
                                           INNER JOIN AREA A ON A.Id = S.IdArea
                                           INNER JOIN TICKET T ON T.IdSprint = S.Id
                                           WHERE S.IdProyecto = @IdProyecto
                                             AND P.IdEmpresa = @IdEmpresa
                                             AND T.IdUsuario = @IdUsuario
        ");

                    datos.setearParametro("@IdProyecto", idProyecto);
                    datos.setearParametro("@IdEmpresa", idEmpresa);
                    datos.setearParametro("@IdUsuario", idUsuario);

                    datos.ejecutarLectura();

                    while (datos.Lector.Read())
                    {
                        Sprint sprint = new Sprint();
                        sprint.Id = (int)datos.Lector["Id"];
                        sprint.NumeroSprint = (int)datos.Lector["NumeroSprint"];
                        sprint.FechaInicio = (DateTime)datos.Lector["FechaInicio"];
                        sprint.FechaEstimadaFin = (DateTime)datos.Lector["FechaEstimadaFin"];

                        if (datos.Lector["FechaFin"] != DBNull.Value)
                            sprint.FechaFin = (DateTime)datos.Lector["FechaFin"];

                        sprint.Activo = (bool)datos.Lector["Activo"];

                        sprint.Proyecto = new Proyecto();
                        sprint.Proyecto.Id = (int)datos.Lector["IdProyecto"];
                        sprint.Proyecto.Nombre = (string)datos.Lector["NombreProyecto"];

                        sprint.Estado = new Estado();
                        sprint.Estado.Id = (int)datos.Lector["IdEstado"];
                        sprint.Estado.Nombre = (string)datos.Lector["NombreEstado"];
                        sprint.Estado.EsFinal = (bool)datos.Lector["EsFinal"];
                        sprint.Estado.EsSistema = (bool)datos.Lector["EsSistema"];

                        sprint.Area = new Area();
                        sprint.Area.Id = (int)datos.Lector["IdArea"];
                        sprint.Area.Nombre = (string)datos.Lector["NombreArea"];

                        lista.Add(sprint);
                    }
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

        public void ModificarSprintConAuditoria(Sprint editarSprint, Sprint original,string accion, int idUsuario, string motivo)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                
                datos.iniciarTransaccion();

                Modificar(editarSprint);
                

                AuditoriaService auditoriaService = new AuditoriaService();

                if (original.FechaInicio.Date != editarSprint.FechaInicio.Date)
                    auditoriaService.Registrar(idUsuario, "Sprint", editarSprint.Id, accion,
                        "FechaInicio", original.FechaInicio.ToString(), editarSprint.FechaInicio.ToString(), motivo);

                if (original.FechaEstimadaFin.Date != editarSprint.FechaEstimadaFin.Date)
                    auditoriaService.Registrar(idUsuario, "Sprint", editarSprint.Id, accion,
                        "FechaEstimadaFin", original.FechaEstimadaFin.ToString(), editarSprint.FechaEstimadaFin.ToString(), motivo);

                if (original.Estado.Id != editarSprint.Estado.Id)
                    auditoriaService.Registrar(idUsuario, "Sprint", editarSprint.Id, accion,
                        "Estado", original.Estado.Nombre, editarSprint.Estado.Nombre, motivo);


                datos.confirmarTransaccion(); // COMMIT
            }
            catch (Exception)
            {
                datos.cancelarTransaccion(); // ROLLBACK
                throw;
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        public void EliminarSprintConAuditoria(Sprint eliminarSprint, string accion, int idUsuario, string motivo)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {

                datos.iniciarTransaccion();

                Desactivar(eliminarSprint);


                AuditoriaService auditoriaService = new AuditoriaService();

                auditoriaService.Registrar(idUsuario, "Sprint", eliminarSprint.Id, accion,
                        "btn Eliminar", motivo);


                datos.confirmarTransaccion(); // COMMIT
            }
            catch (Exception)
            {
                datos.cancelarTransaccion(); // ROLLBACK
                throw;
            }
            finally
            {
                datos.cerrarConexion();
            }
        }
    }
}
