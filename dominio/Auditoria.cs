using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace dominio
{
    public class Auditoria
    {
        public int IdAuditoria { get; set; }
        public Usuario Usuario { get; set; }
        public string Entidad { get; set; } //'Proyecto', 'Sprint', 'Ticket'
        public int EntidadId { get; set; } //ID del objeto afectado
        public string Accion { get; set; } //'INSERT', 'UPDATE', 'DELETE'
        public string CampoModificado { get; set; } //Nombre de la propiedad o campo
        public string ValorAnterior { get; set; }
        public string ValorNuevo { get; set; }
        public string Descripcion { get; set; } //Justificación del cambio
        public DateTime Fecha { get; set; }
    }
}
