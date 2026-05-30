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
        public int agregar(Proyecto proyecto)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta(@"
                    INSERT INTO PROYECTO 
                    (Nombre, Descripcion, FechaInicio, FechaFin, FechaEstimadaFin, Activo, IdEstado)
                    VALUES (@Nombre, @Descripcio, @FechaInicio, @FechaFin, @FechaEstimadaFin, @Activo, @IdEstado)
                    SELECT SCOPE_IDENTITY();"
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
                datos.setearConsulta(@"
                    UPDATE PROYECTO 
                    SET (Nombre = @Nombre, Descripcion = @Descripcion, FechaInicio = @FechaInicio, 
                         FechaFin = @FechaFin, FechaEstimadaFin = @FechaEstimadaFin, Activo = @Activo, 
                         IdEstado = @IdEstado)
                    WHERE Id = @Id"
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
                datos.setearParametro("@Id", proyecto.Id);

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

        public List<Proyecto> listar()
        {
            List<Proyecto> lista = new List<Proyecto>();
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta(@"
                    Select P.Id, P.Nombre, P.Descripcion, P.FechaInicio, P.FechaFin, P.FechaEstimadaFin, 
                           P.Activo, E.Id AS IdEstado, E.Nombre AS NombreEstado, E.EsFinal, E.EsSistema
                    FROM PROYECTO P
                    INNER JOIN ESTADO E ON E.Id = P.IdEstado"
                );
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    Proyecto aux = new Proyecto();
                    aux.Id = (int)datos.Lector["Id"];
                    aux.Nombre = (string)datos.Lector["Nombre"];
                    aux.Descripcion = (string)datos.Lector["Descripcion"];
                    aux.FechaInicio = (DateTime)datos.Lector["FechaInicio"];
                    aux.FechaEstimadaFin = (DateTime)datos.Lector["FechaEstimadaFin"];
                    if(datos.Lector["FechaFin"] != DBNull.Value)
                    {
                       aux.FechaFin = (DateTime)datos.Lector["FechaFin"];
                    }
                    aux.Activo = (bool)datos.Lector["Activo"];
                    aux.Estado = new Estado();
                    aux.Estado.Id = (int)datos.Lector["IdEstado"];
                    aux.Estado.Nombre = (string)datos.Lector["NombreEstado"];
                    aux.Estado.EsFinal = (bool)datos.Lector["EsFinal"];
                    aux.Estado.EsSistema = (bool)datos.Lector["EsSistema"];

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
    }
}

