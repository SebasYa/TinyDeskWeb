using dominio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace negocio
{
    public class AuditoriaNegocio
    {
        public void Agregar(Auditoria auditoria)
        {
            AccesoDatos datos = new AccesoDatos();
            try
            {

                datos.setearConsulta(@"
                    INSERT INTO auditoria 
                    ( UsuarioId, Entidad,EntidadId, Accion, CampoModificado, ValorAnterior, ValorNuevo, Descripcion,Fecha)
                    VALUES (@UsuarioId, @Entidad,@EntidadId, @Accion, @CampoModificado, @ValorAnterior, @ValorNuevo, @Descripcion,GETDATE())
                    "
                );
                datos.setearParametro("@UsuarioId", auditoria.Usuario.Id);
                datos.setearParametro("@Entidad", auditoria.Entidad);
                datos.setearParametro("@EntidadId", auditoria.EntidadId);
                datos.setearParametro("@Accion", auditoria.Accion);
                datos.setearParametro("@CampoModificado", auditoria.CampoModificado);
                datos.setearParametro("@ValorAnterior", auditoria.ValorAnterior);
                datos.setearParametro("@ValorNuevo", auditoria.ValorNuevo);
                datos.setearParametro("@Descripcion", auditoria.Descripcion);


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

        public List<Auditoria> ListarPorEntidad(string entidad, int entidadId)
        {
            List<Auditoria> lista = new List<Auditoria>();
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta(@"
                    SELECT A.IdAuditoria, A.UsuarioId, U.Nombre, U.Apellido, A.Entidad, A.EntidadId, A.Accion, A.CampoModificado, 
                           A.ValorAnterior, A.ValorNuevo, A.Descripcion, A.Fecha 
                    FROM Auditoria A
                    INNER JOIN USUARIO U ON A.UsuarioId == U.Id
                    WHERE Entidad = @Entidad AND EntidadId = @EntidadId 
                    ORDER BY Fecha DESC"); 

                datos.setearParametro("@Entidad", entidad);
                datos.setearParametro("@EntidadId", entidadId);
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    Auditoria aux = new Auditoria();

                    aux.IdAuditoria = (int)datos.Lector["IdAuditoria"];
                    aux.Usuario = new Usuario();
                    aux.Usuario.Id = (int)datos.Lector["UsuarioId"];
                    aux.Usuario.Nombre = (string)datos.Lector["Nombre"];
                    aux.Usuario.Apellido = (string)datos.Lector["Apellido"];
                    aux.Entidad = (string)datos.Lector["Entidad"];
                    aux.EntidadId = (int)datos.Lector["EntidadId"];
                    aux.Accion = (string)datos.Lector["Accion"];
                    aux.CampoModificado = (string)datos.Lector["CampoModificado"];
                    aux.ValorAnterior = datos.Lector["ValorAnterior"] != DBNull.Value ? (string)datos.Lector["ValorAnterior"] : null;
                    aux.ValorNuevo = datos.Lector["ValorNuevo"] != DBNull.Value ? (string)datos.Lector["ValorNuevo"] : null;
                    aux.Descripcion = datos.Lector["Descripcion"] != DBNull.Value ? (string)datos.Lector["Descripcion"] : null;
                    aux.Fecha = (DateTime)datos.Lector["Fecha"];
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

        public List<Auditoria> ListarPorUsuario(int usuarioId)
        {
            List<Auditoria> lista = new List<Auditoria>();
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta(@"
                        SELECT A.IdAuditoria, A.UsuarioId, U.Nombre, U.Apellido, A.Entidad, A.EntidadId, 
                               A.Accion, A.CampoModificado, A.ValorAnterior, A.ValorNuevo, A.Descripcion, A.Fecha 
                        FROM Auditoria A
                        INNER JOIN USUARIO U ON A.UsuarioId = U.Id
                        WHERE A.UsuarioId = @UsuarioId 
                        ORDER BY Fecha DESC");

                datos.setearParametro("@UsuarioId", usuarioId);
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    Auditoria aux = new Auditoria();
                    aux.IdAuditoria = (int)datos.Lector["IdAuditoria"];
                    aux.Usuario = new Usuario();
                    aux.Usuario.Id = (int)datos.Lector["UsuarioId"];
                    aux.Usuario.Nombre = (string)datos.Lector["Nombre"];
                    aux.Usuario.Apellido = (string)datos.Lector["Apellido"];                   
                    aux.Entidad = (string)datos.Lector["Entidad"];
                    aux.EntidadId = (int)datos.Lector["EntidadId"];
                    aux.Accion = (string)datos.Lector["Accion"];
                    aux.CampoModificado = (string)datos.Lector["CampoModificado"];
                    aux.ValorAnterior = datos.Lector["ValorAnterior"] != DBNull.Value ? (string)datos.Lector["ValorAnterior"] : null;
                    aux.ValorNuevo = datos.Lector["ValorNuevo"] != DBNull.Value ? (string)datos.Lector["ValorNuevo"] : null;
                    aux.Descripcion = datos.Lector["Descripcion"] != DBNull.Value ? (string)datos.Lector["Descripcion"] : null;
                    aux.Fecha = (DateTime)datos.Lector["Fecha"];

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

        public List<Auditoria> ListarRecientes(int cantidad)
        {
            List<Auditoria> lista = new List<Auditoria>();
            AccesoDatos datos = new AccesoDatos();
            try
            {
                datos.setearConsulta(@"
                        SELECT TOP (@Cantidad) A.IdAuditoria, A.UsuarioId, U.Nombre, U.Apellido, A.Entidad, A.EntidadId, 
                               A.Accion, A.CampoModificado, A.ValorAnterior, A.ValorNuevo, A.Descripcion, A.Fecha 
                        FROM Auditoria A
                        INNER JOIN USUARIO U ON A.UsuarioId = U.Id
                        ORDER BY A.Fecha DESC");

                datos.setearParametro("@Cantidad", cantidad);
                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    Auditoria aux = new Auditoria();
                    aux.IdAuditoria = (int)datos.Lector["IdAuditoria"];
                    aux.Usuario = new Usuario();
                    aux.Usuario.Id = (int)datos.Lector["UsuarioId"];
                    aux.Usuario.Nombre = (string)datos.Lector["Nombre"];
                    aux.Usuario.Apellido = (string)datos.Lector["Apellido"];
                    aux.Entidad = (string)datos.Lector["Entidad"];
                    aux.EntidadId = (int)datos.Lector["EntidadId"];
                    aux.Accion = (string)datos.Lector["Accion"];
                    aux.CampoModificado = (string)datos.Lector["CampoModificado"];
                    aux.ValorAnterior = (string)datos.Lector["ValorAnterior"];
                    aux.ValorNuevo = (string)datos.Lector["ValorNuevo"];
                    aux.Descripcion = (string)datos.Lector["Descripcion"];
                    aux.Fecha = (DateTime)datos.Lector["Fecha"];

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
