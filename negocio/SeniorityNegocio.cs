using dominio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace negocio
{
    public class SeniorityNegocio
    {
        public List<Seniority> listar()
        {
            AccesoDatos datos = new AccesoDatos();
            List<Seniority> lista = new List<Seniority>();
            try
            {
                datos.setearConsulta("SELECT Id, Nombre FROM SENIORITY ORDER BY Id");
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    Seniority seniority = new Seniority();
                    seniority.Id = (int)datos.Lector["Id"];
                    seniority.Nombre = (string)datos.Lector["Nombre"];
                    lista.Add(seniority);
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
