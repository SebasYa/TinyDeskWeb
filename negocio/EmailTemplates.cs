using dominio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace negocio
{
    internal class EmailTemplates
    {
        public static string ValidarCuenta(string nombre, string linkValidacion)
        {
            return "<h2>Bienvenido a TinyDesk, " + nombre + "</h2>" +
                   "<p>Gracias por registrarte.</p>" +
                   "<p>Para activar tu cuenta, haz click en el siguiente enlace:</p>" +
                   "<p><a href='" + linkValidacion + "'>Validar mi cuenta</a></p>" +
                   "<p>Si no creaste esta cuenta, podes ignorar este mensaje.</p>";
        }

        public static string CrearPasswordEmpleado(string nombre, string linkCrearPassword)
        {
            return "<h2>Hola " + nombre + "</h2>" +
                   "<p>Fuiste invitado a TinyDesk como usuario interno.</p>" +
                   "<p>Para activar tu usuario, crea tu contraseña desde el siguiente enlace:</p>" +
                   "<p><a href='" + linkCrearPassword + "'>Crear contraseña</a></p>";
        }

        public static string TicketAsignado(string nombreUsuario, Ticket ticket, string area, string linkTicket)
        {
            return "<h2>Nuevo ticket asignado</h2>" +
                   "<p>Hola " + nombreUsuario + ", se te asigno un nuevo ticket.</p>" +
                   "<p><b>Descripcion:</b> " + ticket.Descripcion + "</p>" +
                   "<p><b>Prioridad:</b> " + ticket.Prioridad.Nombre + "</p>" +
                   "<p><b>Area:</b> " + area + "</p>" +
                   "<p><a href='" + linkTicket + "'>Ver ticket</a></p>";
        }
    }
}
