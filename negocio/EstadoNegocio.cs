using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using dominio;

namespace negocio
{
    internal class EstadoNegocio
    {
        public int agregar(Estado estado)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta(
                    "INSERT INTO Clientes (Nombre, EsFinal) " +
                    "VALUES (@Nombre, @EsFinal); " +
                    "SELECT SCOPE_IDENTITY();"
                );
                datos.setearParametro("@Nombre", estado.Nombre);
                datos.setearParametro("@EsFinal", estado.EsFinal);

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

        public void actualizar(Estado estado)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta(
                    "UPDATE Clientes SET Nombre = @nombre, EsFinal = @EsFinal, " +
                    "WHERE Id = @id AND EsSistema = 0"
                );
                
                datos.setearParametro("@nombre", estado.Nombre);
                datos.setearParametro("@EsFinal", estado.EsFinal);

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

        public List<Estado> listar()
        {
            List<Estado> lista = new List<Estado>();
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta("SELECT Id, EsFinal, EsSistema Descripcion FROM ESTADO");
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    Estado aux = new Estado();
                    aux.Id = (int)datos.Lector["Id"];
                    aux.Nombre = (string)datos.Lector["Nombre"];
                    aux.EsFinal = (bool)datos.Lector["EsFinal"];
                    aux.EsSistema = (bool)datos.Lector["EsSistema"];
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
