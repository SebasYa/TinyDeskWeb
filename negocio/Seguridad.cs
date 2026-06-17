using dominio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace negocio
{
    public static class Seguridad
    {
        public static bool sessionActiva(object user)
        {
            Usuario usuario = user != null ? (Usuario)user : null;
            if (usuario != null && usuario.Id != 0)
            {
                return true;
            }
            return false;
            
        }
        public static bool EsAdmin(object user)
        {
            Usuario usuario = user != null ? (Usuario)user : null;
            if (usuario != null && usuario.Id != 0 && usuario.EsAdmin)
            {
                return true;
            }
            return false;
            
        }
        public static bool PuedeEscribir(object user)
        {
            Usuario usuario = user != null ? (Usuario)user : null;
            if (usuario != null && usuario.Id != 0 && (usuario.PermisoEscritura))
            {
                return true;
            }
            return false;
        }
    }
}
