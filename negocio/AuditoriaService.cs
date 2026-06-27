using dominio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace negocio
{
    public class AuditoriaService
    {
        private AuditoriaNegocio auditoriaNegocio = new AuditoriaNegocio();

        public void Registrar(int idUsuario, string entidad, int entidadId, string accion,
                              string campo, string valorAnterior, string valorNuevo, string descripcion)
        {
            Auditoria log = new Auditoria();
            log.Usuario = new Usuario { Id = idUsuario };
            log.Entidad = entidad;
            log.EntidadId = entidadId;
            log.Accion = accion; // INSERT, UPDATE, DELETE
            log.CampoModificado = campo;
            log.ValorAnterior = valorAnterior;
            log.ValorNuevo = valorNuevo;
            log.Descripcion = descripcion;
            log.Fecha = DateTime.Now;

            auditoriaNegocio.Agregar(log);
        }
    }
}
