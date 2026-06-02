using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using dominio;

namespace negocio
{
    public class EstadoNegocio
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

        public List<Estado> listar(int idEmpresa)
        {
            List<Estado> lista = new List<Estado>();
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta("SELECT Id, Nombre, EsFinal, EsSistema FROM ESTADO WHERE idEmpresa = @IdEmpresa OR idEmpresa IS NULL");
                datos.setearParametro("@idEmpresa", idEmpresa);
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    Estado nuevoEstado = new Estado();
                    nuevoEstado.Id = (int)datos.Lector["Id"];
                    nuevoEstado.Nombre = (string)datos.Lector["Nombre"];
                    nuevoEstado.EsFinal = (bool)datos.Lector["EsFinal"];
                    nuevoEstado.EsSistema = (bool)datos.Lector["EsSistema"];
                    lista.Add(nuevoEstado);
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
