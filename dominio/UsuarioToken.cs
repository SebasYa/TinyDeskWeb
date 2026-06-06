using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace dominio
{
    public class UsuarioToken
    {
        public int Id { get; set; }
        public Usuario Usuario { get; set; }
        public string Token { get; set; }
        public string Tipo { get; set; }
        public DateTime FechaCreacion { get; set; }
        public DateTime FechaExpiracion { get; set; }
        public DateTime? FechaUso { get; set; }
        public bool Usado { get; set; }
    }
}
