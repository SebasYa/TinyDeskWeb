using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace negocio
{
    public class TicketNegocio
    {
        public int ContarAbiertos()
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta(@"
                    SELECT COUNT(*)
                    FROM TICKET T
                    INNER JOIN ESTADO E ON T.IdEstado = E.Id
                    WHERE T.Activo = 1 AND E.EsFinal = 0
                ");
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
    }
}
