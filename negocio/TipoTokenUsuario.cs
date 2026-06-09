using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace negocio
{
    public static class TipoTokenUsuario
    {
        public const string ValidarEmail = "ValidarEmail";
        public const string CrearPassword = "CrearPassword";
        public const string ResetPassword = "ResetPassword";
    }
    public enum EstadoTokenUsuario
    {
        NoExiste, Pendiente, Vencido, Usado
    }
}
