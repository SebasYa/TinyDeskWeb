using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace dominio
{
    internal class Sprint
    {
        public int Id { get; set; }
        public int NumeroSprint { get; set; }
        public DateTime FechaInicio { get; set; }
        public DateTime FechaFin { get; set; }
        public DateTime FechaEstimadaFin { get; set; }
        public bool Activo { get; set; }
        public Proyecto Proyecto { get; set; }
        public Estado Estado { get; set; }
        public Area Area { get; set; }

    }
}
