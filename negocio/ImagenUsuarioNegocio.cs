using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using dominio;

namespace negocio
{
    public class ImagenUsuarioNegocio
    {
        public void Guardar(ImagenUsuario imagenUsuario)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta(@"UPDATE IMAGEN_USUARIO
                                       SET Imagen = @Imagen
                                       WHERE IdUsuario = @IdUsuario;
                                       
                                       IF @@ROWCOUNT = 0
                                       BEGIN
                                           INSERT INTO IMAGEN_USUARIO
                                           (IdUsuario, Imagen)
                                           VALUES (@IdUsuario, @Imagen);
                                       END"
                );

                datos.setearParametro("@IdUsuario", imagenUsuario.IdUsuario);
                datos.setearParametro("@Imagen", imagenUsuario.ImagenURL);

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
        public ImagenUsuario BuscarPorIdUsuario(int idUsuario)
        {
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta(@"SELECT IdUsuario, Imagen
                                       FROM IMAGEN_USUARIO
                                       WHERE IdUsuario = @IdUsuario"
                );

                datos.setearParametro("@IdUsuario", idUsuario);
                datos.ejecutarLectura();

                if (datos.Lector.Read())
                {
                    ImagenUsuario imagenUsuario = new ImagenUsuario();

                    imagenUsuario.IdUsuario = (int)datos.Lector["IdUsuario"];
                    imagenUsuario.ImagenURL =  (string)datos.Lector["Imagen"];

                    return imagenUsuario;
                }

                return null;
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
