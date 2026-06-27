using dominio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace negocio
{
    public class AuditoriaNegocio
    {
        public void Agregar(Auditoria auditoria)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {

                datos.setearConsulta(@"
                    INSERT INTO auditoria 
                    ( UsuarioId, Entidad,EntidadId, Accion, CampoModificado, ValorAnterior, ValorNuevo, Descripcion,Fecha)
                    VALUES (@UsuarioId, @Entidad,@EntidadId, @Accion, @CampoModificado, @ValorAnterior, @ValorNuevo, @Descripcion,GETDATE())
                    "
                );
                datos.setearParametro("@UsuarioId", auditoria.Usuario.Id);
                datos.setearParametro("@Entidad", auditoria.Entidad);
                datos.setearParametro("@EntidadId", auditoria.EntidadId);
                datos.setearParametro("@Accion", auditoria.Accion);
                datos.setearParametro("@CampoModificado", auditoria.CampoModificado);
                datos.setearParametro("@ValorAnterior", auditoria.ValorAnterior);
                datos.setearParametro("@ValorNuevo", auditoria.ValorNuevo);
                datos.setearParametro("@Descripcion", auditoria.Descripcion);


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

    }
}
