using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace dominio
{
    public class Ticket
    {
        public int Id { get; set; }
        public DateTime FechaInicio { get; set; }
        public DateTime? FechaFin { get; set; }
        public DateTime FechaEstimadaFin { get; set; }
        public string Descripcion { get; set; }
        public bool Activo { get; set; }
        public Prioridad Prioridad { get; set; }
        public Usuario Usuario { get; set; }
        public Estado Estado { get; set; }
        public Sprint Sprint { get; set; }
    }
}
