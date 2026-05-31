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
                datos.setearConsulta("SELECT Id, Nombre FROM AREA WHERE IdEmpresa = @IdEmpresa OR IdEmpresa IS NULL");
                datos.setearParametro("@IdEmpresa", idEmpresa);
                datos.ejecutarLectura();
                while (datos.Lector.Read())
                {
                    Area aux = new Area();
                    aux.Id = (int)datos.Lector["Id"];
                    aux.Nombre = (string)datos.Lector["Nombre"];
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
