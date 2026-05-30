using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace negocio
{
    public class AccesoDatos
    {
        private SqlConnection conexion;
        private SqlCommand comando;
        private SqlDataReader lector;

        public SqlDataReader Lector
        {
            get { return lector; }
        }

        public AccesoDatos()
        {
            try
            {
                // conexion MSSQL
                //conexion = new SqlConnection("server=(localdb)\\MSSQLLocalDB; database=TiniDesk_Web; integrated security=true");
                //conexion sqlExpress
                conexion = new SqlConnection("server=.\\SQLEXPRESS; database=TiniDesk_Web; integrated security=true");
                comando = new SqlCommand();

            }
            catch (Exception ex)
            {

                throw ex;
            }
        }

        public void setearConsulta(string consulta)
        {
            comando.CommandType = System.Data.CommandType.Text;
            comando.CommandText = consulta;
        }

        public void ejecutarLectura()
        {
            comando.Connection = conexion;
            try
            {
                conexion.Open();
                lector = comando.ExecuteReader();
            }
            catch (Exception ex)
            {
                Console.WriteLine("Error al intentar ejecutar la lectura.");
                throw ex;
            }
        }

        public void cerrarConexion()
        {
            if (lector != null)
            {
                lector.Close();
                conexion.Close();
            }
        }

        internal void setearParametro(string nombre, object valor)
        {
            comando.Parameters.AddWithValue(nombre, valor);
        }

        internal void ejecutarAccion()
        {
            comando.Connection = conexion;
            try
            {
                conexion.Open();
                comando.ExecuteNonQuery();
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        internal int ejecutarScalar()
        {
            comando.Connection = conexion;
            try
            {
                conexion.Open();
                return Convert.ToInt32(comando.ExecuteScalar());
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


    }
}