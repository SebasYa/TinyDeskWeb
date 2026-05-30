using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace dominio
{
    public class Estado
    {
        public int Id { get; set; }
        public String Nombre { get; set; }
        public bool EsFinal { get; set; }
        public bool EsSistema { get; set; }
    }
}
