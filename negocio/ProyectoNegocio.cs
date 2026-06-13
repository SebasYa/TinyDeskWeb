using dominio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace negocio
{
    public class ProyectoNegocio
    {
        public int agregarProyecto(Proyecto proyecto)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta(@"INSERT INTO PROYECTO 
                                              (Nombre, Descripcion, FechaInicio, FechaFin, 
                                               FechaEstimadaFin, Activo, IdEstado, IdEmpresa)
                                       VALUES (@Nombre, @Descripcion, @FechaInicio, @FechaFin,
                                               @FechaEstimadaFin, @Activo, @IdEstado, @IdEmpresa);
                                        SELECT CAST(SCOPE_IDENTITY() AS INT)"
                );
                datos.setearParametro("@Nombre", proyecto.Nombre);
                datos.setearParametro("@Descripcion", proyecto.Descripcion);
                datos.setearParametro("@FechaInicio", proyecto.FechaInicio);
                if (proyecto.FechaFin.HasValue)
                {
                   datos.setearParametro("@FechaFin", proyecto.FechaFin.Value);
                }
                else
                {
                    datos.setearParametro("@FechaFin", DBNull.Value);
                }
                datos.setearParametro("@FechaEstimadaFin", proyecto.FechaEstimadaFin);
                datos.setearParametro("@Activo", proyecto.Activo);
                datos.setearParametro("@IdEstado", proyecto.Estado.Id);
                datos.setearParametro("@IdEmpresa", proyecto.Empresa.Id);

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
        public void actualizar(Proyecto proyecto)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta(@"UPDATE PROYECTO 
                                       SET Nombre = @Nombre, Descripcion = @Descripcion, 
                                            FechaFin = @FechaFin, FechaEstimadaFin = @FechaEstimadaFin, 
                                            Activo = @Activo, IdEstado = @IdEstado
                                       WHERE Id = @Id AND IdEmpresa = @IdEmpresa"
                );

                datos.setearParametro("@Nombre", proyecto.Nombre);
                datos.setearParametro("@Descripcion", proyecto.Descripcion);
                if (proyecto.FechaFin.HasValue)
                {
                    datos.setearParametro("@FechaFin", proyecto.FechaFin.Value);
                }
                else
                {
                    datos.setearParametro("@FechaFin", DBNull.Value);
                }
                datos.setearParametro("@FechaEstimadaFin", proyecto.FechaEstimadaFin);
                datos.setearParametro("@Activo", proyecto.Activo);
                datos.setearParametro("@IdEstado", proyecto.Estado.Id);
                datos.setearParametro("@Id", proyecto.Id);
                datos.setearParametro("@IdEmpresa", proyecto.Empresa.Id);

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

        public List<Proyecto> listar(int idEmpresa)
        {
            List<Proyecto> lista = new List<Proyecto>();
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta(@"
                    Select P.Id, P.Nombre, P.Descripcion, P.FechaInicio, P.FechaFin, P.FechaEstimadaFin, 
                           P.Activo, E.Id AS IdEstado, E.Nombre AS NombreEstado, E.EsFinal, E.EsSistema
                    FROM PROYECTO P
                    INNER JOIN ESTADO E ON E.Id = P.IdEstado
                    WHERE P.IdEmpresa = @IdEmpresa  
                ");
                datos.setearParametro("@IdEmpresa", idEmpresa);
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    Proyecto proyecto = new Proyecto();
                    proyecto.Id = (int)datos.Lector["Id"];
                    proyecto.Nombre = (string)datos.Lector["Nombre"];
                    proyecto.Descripcion = (string)datos.Lector["Descripcion"];
                    proyecto.FechaInicio = (DateTime)datos.Lector["FechaInicio"];
                    proyecto.FechaEstimadaFin = (DateTime)datos.Lector["FechaEstimadaFin"];
                    if(datos.Lector["FechaFin"] != DBNull.Value)
                    {
                        proyecto.FechaFin = (DateTime)datos.Lector["FechaFin"];
                    }
                    proyecto.Activo = (bool)datos.Lector["Activo"];
                    proyecto.Estado = new Estado();
                    proyecto.Estado.Id = (int)datos.Lector["IdEstado"];
                    proyecto.Estado.Nombre = (string)datos.Lector["NombreEstado"];
                    proyecto.Estado.EsFinal = (bool)datos.Lector["EsFinal"];
                    proyecto.Estado.EsSistema = (bool)datos.Lector["EsSistema"];

                    lista.Add(proyecto);
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
        public void BajaLogica(int id)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta(@"
                    UPDATE PROYECTO
                    SET ACTIVO = 0
                    WHERE Id = @id
                ");

                datos.setearParametro("@Id", id);
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

        public int ContarActivos(int idEmpresa) {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta(@"
                    SELECT COUNT(*) 
                    FROM PROYECTO
                    WHERE activo = 1 AND IdEmpresa = @idEmpresa
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
        public Proyecto BuscarPorId(int idProyecto, int idEmpresa)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta(@"SELECT P.Id, P.Nombre, P.Descripcion, P.FechaInicio, P.FechaFin, P.FechaEstimadaFin, 
                                      P.Activo, P.IdEmpresa, E.Id AS IdEstado, E.Nombre AS NombreEstado, E.EsFinal, E.EsSistema
                               FROM PROYECTO P
                               INNER JOIN ESTADO E ON E.Id = P.IdEstado
                               WHERE P.Id = @IdProyecto
                                 AND P.IdEmpresa = @IdEmpresa");

                datos.setearParametro("@IdProyecto", idProyecto);
                datos.setearParametro("@IdEmpresa", idEmpresa);
                datos.ejecutarLectura();

                if (datos.Lector.Read())
                {
                    Proyecto proyecto = new Proyecto();
                    proyecto.Id = (int)datos.Lector["Id"];
                    proyecto.Nombre = (string)datos.Lector["Nombre"];
                    proyecto.Descripcion = (string)datos.Lector["Descripcion"];
                    proyecto.FechaInicio = (DateTime)datos.Lector["FechaInicio"];
                    proyecto.FechaEstimadaFin = (DateTime)datos.Lector["FechaEstimadaFin"];

                    if (datos.Lector["FechaFin"] != DBNull.Value)
                        proyecto.FechaFin = (DateTime)datos.Lector["FechaFin"];

                    proyecto.Activo = (bool)datos.Lector["Activo"];

                    proyecto.Empresa = new Empresa();
                    proyecto.Empresa.Id = (int)datos.Lector["IdEmpresa"];

                    proyecto.Estado = new Estado();
                    proyecto.Estado.Id = (int)datos.Lector["IdEstado"];
                    proyecto.Estado.Nombre = (string)datos.Lector["NombreEstado"];
                    proyecto.Estado.EsFinal = (bool)datos.Lector["EsFinal"];
                    proyecto.Estado.EsSistema = (bool)datos.Lector["EsSistema"];

                    return proyecto;
                }

                return null;
            }
            catch(Exception ex)
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

