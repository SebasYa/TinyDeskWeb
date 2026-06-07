using dominio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace negocio
{
    public class AreaNegocio
    {
        public List<Area> listar(int idEmpresa)
        {
            List<Area> lista = new List<Area>();
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta(@"SELECT A.Id, A.Nombre, A.IdEmpresa, E.Nombre AS NombreEmpresa 
                                       FROM AREA A
                                       LEFT JOIN EMPRESA E ON E.Id = A.IdEmpresa
                                       WHERE IdEmpresa = @IdEmpresa OR IdEmpresa IS NULL");
                datos.setearParametro("@IdEmpresa", idEmpresa);
                datos.ejecutarLectura();
                while (datos.Lector.Read())
                {
                    Area area = new Area();
                    area.Id = (int)datos.Lector["Id"];
                    area.Nombre = (string)datos.Lector["Nombre"];
                    if (datos.Lector["IdEmpresa"] != DBNull.Value)
                    {
                        area.Empresa = new Empresa();
                        area.Empresa.Id = (int)datos.Lector["IdEmpresa"];
                        area.Empresa.Nombre = (string)datos.Lector["NombreEmpresa"];
                    }
                    lista.Add(area);
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

        public Area buscarPorId(int id, int idEmpresa)
        {
            return listar(idEmpresa).Find(x => x.Id == id);
        }
        private void validarEditable(Area area)
        {
            if (area.Empresa == null)
                throw new Exception("Esta área es parte del sistema y no se puede modificar ni eliminar.");
        }

        private int contarReferencias(int id)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta(@"SELECT (SELECT COUNT(*) FROM USUARIO WHERE IdArea = @Id) +
                                              (SELECT COUNT(*) FROM SPRINT WHERE IdArea = @Id)");

                datos.setearParametro("@Id", id);
                return datos.ejecutarScalar();
            }
            finally
            {
                datos.cerrarConexion();
            }
        }
        public void agregar(Area area)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta("INSERT INTO AREA (Nombre, IdEmpresa) VALUES (@Nombre, @IdEmpresa)");
                datos.setearParametro("@Nombre", area.Nombre);
                datos.setearParametro("@IdEmpresa", area.Empresa.Id);
                datos.ejecutarAccion();
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        public void actualizar(Area area)
        {
            
            validarEditable(area);

            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta("UPDATE AREA SET Nombre = @Nombre WHERE Id = @Id AND IdEmpresa = @IdEmpresa");
                datos.setearParametro("@Nombre", area.Nombre);
                datos.setearParametro("@Id", area.Id);
                datos.setearParametro("@IdEmpresa", area.Empresa.Id);
                datos.ejecutarAccion();
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        public void eliminar(Area area)
        {
            Area actual = buscarPorId(area.Id, area.Empresa.Id);
            validarEditable(actual);

            if (contarReferencias(area.Id) > 0)
                throw new Exception("No se puede eliminar porque el área está en uso.");

            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta("DELETE FROM AREA WHERE Id = @Id AND IdEmpresa = @IdEmpresa");
                datos.setearParametro("@Id", area.Id);
                datos.setearParametro("@IdEmpresa", area.Empresa.Id);
                datos.ejecutarAccion();
            }
            finally
            {
                datos.cerrarConexion();
            }
        }
    }
}
