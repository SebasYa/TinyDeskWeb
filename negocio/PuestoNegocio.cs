using dominio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace negocio
{
    public class PuestoNegocio
    {
        public List<Puesto> listar(int idEmpresa)
        {
            List<Puesto> lista = new List<Puesto>();
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta(@"SELECT P.Id, P.Nombre, P.IdEmpresa, P.Nombre AS NombreEmpresa FROM PUESTO P
                                       LEFT JOIN EMPRESA E ON E.Id = P.IdEmpresa
                                       WHERE IdEmpresa = @IdEmpresa OR IdEmpresa IS NULL");
                datos.setearParametro("@IdEmpresa", idEmpresa);
                datos.ejecutarLectura();
                while (datos.Lector.Read())
                {
                    Puesto puesto = new Puesto();
                    puesto.Id = (int)datos.Lector["Id"];
                    puesto.Nombre = (string)datos.Lector["Nombre"];
                    if (datos.Lector["IdEmpresa"] != DBNull.Value)
                    {
                        puesto.Empresa = new Empresa();
                        puesto.Empresa.Id = (int)datos.Lector["IdEmpresa"];
                        puesto.Empresa.Nombre = (string)datos.Lector["NombreEmpresa"];
                    }
                    lista.Add(puesto);
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
        public Puesto buscarPorId(int id, int idEmpresa)
        {
            return listar(idEmpresa).Find(x => x.Id == id);
        }
        public void agregar(Puesto puesto)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta("INSERT INTO PUESTO (Nombre, IdEmpresa) VALUES (@Nombre, @IdEmpresa)");
                datos.setearParametro("@Nombre", puesto.Nombre);
                datos.setearParametro("@IdEmpresa", puesto.Empresa.Id);
                datos.ejecutarAccion();
            }
            finally
            {
                datos.cerrarConexion();
            }
        }
        private void validarEditable(Puesto puesto)
        {
            if (puesto == null)
                throw new Exception("No se encontró el puesto.");

            if (puesto.Empresa == null)
                throw new Exception("Este puesto es parte del sistema y no se puede modificar ni eliminar.");
        }
        private int contarReferencias(int id)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta("SELECT COUNT(*) FROM USUARIO WHERE IdPuesto = @Id");
                datos.setearParametro("@Id", id);
                return datos.ejecutarScalar();
            }
            finally
            {
                datos.cerrarConexion();
            }
        }
        public void actualizar(Puesto puesto)
        {
            validarEditable(puesto);

            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta("UPDATE PUESTO SET Nombre = @Nombre WHERE Id = @Id AND IdEmpresa = @IdEmpresa");
                datos.setearParametro("@Nombre", puesto.Nombre);
                datos.setearParametro("@Id", puesto.Id);
                datos.setearParametro("@IdEmpresa", puesto.Empresa.Id);
                datos.ejecutarAccion();
            }
            finally
            {
                datos.cerrarConexion();
            }
        }
        public void eliminar(Puesto puesto)
        {
            Puesto actual = buscarPorId(puesto.Id, puesto.Empresa.Id);

            validarEditable(actual);
            if (contarReferencias(actual.Id) > 0) throw new Exception("No se puede eliminar porque el puesto está en uso.");

            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta("DELETE FROM PUESTO WHERE Id = @Id AND IdEmpresa = @IdEmpresa");
                datos.setearParametro("@Id", actual.Id);
                datos.setearParametro("@IdEmpresa", actual.Empresa.Id);
                datos.ejecutarAccion();
            }
            finally
            {
                datos.cerrarConexion();
            }
        }
    }
}
