using dominio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace negocio
{
    internal class PrioridadNegocio
    {
        public List<Prioridad> listar()
        {
            List<Prioridad> lista = new List<Prioridad>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta(@"SELECT Id, Nombre
                                       FROM PRIORIDAD
                                       ");

                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    Prioridad aux = new Prioridad();
                    aux.Id = (int)datos.Lector["Id"];
                    aux.Nombre = (string)datos.Lector["Nombre"];
                    lista.Add(aux);
                }

                return lista;
            }
            finally
            {
                datos.cerrarConexion();
            }
        }

        public Prioridad buscarPorId(int id)
        {
            return listar().Find(x => x.Id == id);
        }
    }
}