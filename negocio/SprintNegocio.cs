using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace negocio
{
    public class SprintNegocio
    {
        public int ContarEnCurso()
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta(@"
                    SELECT COUNT(*)
                    FROM SPRINT S
                    INNER JOIN ESTADO E ON S.IdEstado = E.Id
                    WHERE E.EsFinal = 0
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
