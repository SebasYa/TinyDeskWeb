using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace dominio
{
    public class Usuario
    {
        public int Id { get; set; }
        public string NombreUsuario { get; set; }
        public string PasswordHash { get; set; }
        public string Nombre { get; set; }
        public string Apellido { get; set; }
        public bool Activo { get; set; }
        public bool PermisoEscritura { get; set; }
        public bool EsOwner { get; set; }
        public Empresa Empresa { get; set; }
        public Area Area { get; set; }
    }
}
