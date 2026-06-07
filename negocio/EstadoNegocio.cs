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
                datos.setearConsulta(@"
                    INSERT INTO ESTADO (Nombre, EsFinal, EsSistema, IdEmpresa)
                    VALUES (@Nombre, @EsFinal, 0, @IdEmpresa);
                    SELECT SCOPE_IDENTITY();");

                datos.setearParametro("@Nombre", estado.Nombre);
                datos.setearParametro("@EsFinal", estado.EsFinal);
                datos.setearParametro("@IdEmpresa", estado.Empresa.Id);

                return datos.ejecutarScalar();
            }
            finally
            {
                datos.cerrarConexion();
            }
        }
        private void validarEditable(Estado estado)
        {
            if (estado.Empresa == null)
                throw new Exception("Este estado es parte del sistema y no se puede modificar ni eliminar.");
        }

        private int contarReferencias(int id)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta(@"
                    SELECT
                        (SELECT COUNT(*) FROM PROYECTO WHERE IdEstado = @Id) +
                        (SELECT COUNT(*) FROM SPRINT WHERE IdEstado = @Id) +
                        (SELECT COUNT(*) FROM TICKET WHERE IdEstado = @Id)");

                datos.setearParametro("@Id", id);
                return datos.ejecutarScalar();
            }
            finally
            {
                datos.cerrarConexion();
            }
        }
        public void actualizar(Estado estado)
        {
            Estado actual = buscarPorId(estado.Id, estado.Empresa.Id);
            validarEditable(actual);

            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta(@"
                    UPDATE ESTADO
                    SET Nombre = @Nombre, EsFinal = @EsFinal
                    WHERE Id = @Id AND IdEmpresa = @IdEmpresa");

                datos.setearParametro("@Nombre", estado.Nombre);
                datos.setearParametro("@EsFinal", estado.EsFinal);
                datos.setearParametro("@Id", estado.Id);
                datos.setearParametro("@IdEmpresa", estado.Empresa.Id);

                datos.ejecutarAccion();
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
                datos.setearConsulta(@"
                    SELECT Id, Nombre, EsFinal, EsSistema, IdEmpresa
                    FROM ESTADO
                    WHERE IdEmpresa = @IdEmpresa OR IdEmpresa IS NULL
                    ");

                datos.setearParametro("@IdEmpresa", idEmpresa);
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    Estado aux = new Estado();
                    aux.Id = (int)datos.Lector["Id"];
                    aux.Nombre = (string)datos.Lector["Nombre"];
                    aux.EsFinal = (bool)datos.Lector["EsFinal"];
                    aux.EsSistema = (bool)datos.Lector["EsSistema"];

                    if (datos.Lector["IdEmpresa"] != DBNull.Value)
                    {
                        aux.Empresa = new Empresa();
                        aux.Empresa.Id = (int)datos.Lector["IdEmpresa"];
                    }

                    lista.Add(aux);
                }

                return lista;
            }
            finally
            {
                datos.cerrarConexion();
            }
        }
        public Estado buscarPorId(int id, int idEmpresa)
        {
            return listar(idEmpresa).Find(x => x.Id == id);
        }
        public void eliminar(Estado estado)
        {
            validarEditable(estado);

            if (contarReferencias(estado.Id) > 0)
                throw new Exception("No se puede eliminar porque el estado está en uso.");

            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta("DELETE FROM ESTADO WHERE Id = @Id AND IdEmpresa = @IdEmpresa");
                datos.setearParametro("@Id", estado.Id);
                datos.setearParametro("@IdEmpresa", estado.Empresa.Id);
                datos.ejecutarAccion();
            }
            finally
            {
                datos.cerrarConexion();
            }
        }
    }
}
