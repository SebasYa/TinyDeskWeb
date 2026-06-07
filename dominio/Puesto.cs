using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace dominio
{
    public class Puesto
    {
        public int Id { get; set; }
        public string Nombre { get; set; }
        public Empresa Empresa { get; set; }
    }
}
