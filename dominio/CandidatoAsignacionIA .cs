using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace dominio
{
    public class CandidatoAsignacionIA: Usuario
    {
        public int TicketsFinalizados { get; set; }
        public int TicketsAbiertos { get; set; }
        public int TicketsUrgentesAbiertos { get; set; }
        public int TicketsFinalizadosAlta { get; set; }
    }
}
