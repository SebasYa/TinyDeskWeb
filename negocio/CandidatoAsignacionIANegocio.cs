using dominio;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace negocio
{
    public class CandidatoAsignacionIANegocio
    {
        public List<CandidatoAsignacionIA> ListarCandidatos(int idEmpresa, int idArea, int idPuesto)
        {
            List<CandidatoAsignacionIA> lista = new List<CandidatoAsignacionIA>();
            AccesoDatos datos = new AccesoDatos();

            try
            {
                datos.setearConsulta(@"SELECT U.Id, U.NombreUsuario, U.Email, U.Nombre, U.Apellido,
                                              U.Activo, U.EmailVerificado,
                                              A.Id AS IdArea, A.Nombre AS NombreArea,
                                              PUE.Id AS IdPuesto, PUE.Nombre AS NombrePuesto,
                                              SEN.Id AS IdSeniority, SEN.Nombre AS NombreSeniority,
                                       
                                              (SELECT COUNT(*)
                                               FROM TICKET T
                                               INNER JOIN ESTADO E ON E.Id = T.IdEstado
                                               WHERE T.IdUsuario = U.Id
                                                 AND T.Activo = 0
                                                 AND E.EsFinal = 1) AS TicketsFinalizados,
                                       
                                              (SELECT COUNT(*)
                                               FROM TICKET T
                                               INNER JOIN ESTADO E ON E.Id = T.IdEstado
                                               WHERE T.IdUsuario = U.Id
                                                 AND T.Activo = 1
                                                 AND E.EsFinal = 0) AS TicketsAbiertos,
                                       
                                              (SELECT COUNT(*)
                                               FROM TICKET T
                                               INNER JOIN ESTADO E ON E.Id = T.IdEstado
                                               INNER JOIN PRIORIDAD PR ON PR.Id = T.IdPrioridad
                                               WHERE T.IdUsuario = U.Id
                                                 AND T.Activo = 1
                                                 AND E.EsFinal = 0
                                                 AND PR.Nombre = 'Alta') AS TicketsUrgentesAbiertos,
                                       
                                              (SELECT COUNT(*)
                                               FROM TICKET T
                                               INNER JOIN ESTADO E ON E.Id = T.IdEstado
                                               INNER JOIN PRIORIDAD PR ON PR.Id = T.IdPrioridad
                                               WHERE T.IdUsuario = U.Id
                                                 AND T.Activo = 0
                                                 AND E.EsFinal = 1
                                                 AND PR.Nombre = 'Alta') AS TicketsFinalizadosAlta
                                       
                                       FROM USUARIO U
                                       INNER JOIN AREA A ON A.Id = U.IdArea
                                       INNER JOIN PUESTO PUE ON PUE.Id = U.IdPuesto
                                       LEFT JOIN SENIORITY SEN ON SEN.Id = U.IdSeniority
                                       WHERE U.Activo = 1
                                         AND U.EmailVerificado = 1
                                         AND U.IdEmpresa = @IdEmpresa
                                         AND U.IdArea = @IdArea
                                         AND U.IdPuesto = @IdPuesto
                                         AND (SEN.Nombre IS NULL OR SEN.Nombre <> 'Lead')
                                       ORDER BY U.Apellido, U.Nombre"
                );

                datos.setearParametro("@IdEmpresa", idEmpresa);
                datos.setearParametro("@IdArea", idArea);
                datos.setearParametro("@IdPuesto", idPuesto);

                datos.ejecutarLectura();

                while (datos.Lector.Read())
                {
                    CandidatoAsignacionIA usuario = new CandidatoAsignacionIA();

                    usuario.Id = (int)datos.Lector["Id"];
                    usuario.NombreUsuario = (string)datos.Lector["NombreUsuario"];
                    usuario.Email = (string)datos.Lector["Email"];
                    usuario.Nombre = (string)datos.Lector["Nombre"];
                    usuario.Apellido = (string)datos.Lector["Apellido"];
                    usuario.Activo = (bool)datos.Lector["Activo"];
                    usuario.EmailVerificado = (bool)datos.Lector["EmailVerificado"];

                    usuario.Area = new Area();
                    usuario.Area.Id = (int)datos.Lector["IdArea"];
                    usuario.Area.Nombre = (string)datos.Lector["NombreArea"];

                    usuario.Puesto = new Puesto();
                    usuario.Puesto.Id = (int)datos.Lector["IdPuesto"];
                    usuario.Puesto.Nombre = (string)datos.Lector["NombrePuesto"];

                    if (datos.Lector["IdSeniority"] != DBNull.Value)
                    {
                        usuario.Seniority = new Seniority();
                        usuario.Seniority.Id = (int)datos.Lector["IdSeniority"];
                        usuario.Seniority.Nombre = (string)datos.Lector["NombreSeniority"];
                    }

                    usuario.TicketsFinalizados = (int)datos.Lector["TicketsFinalizados"];
                    usuario.TicketsAbiertos = (int)datos.Lector["TicketsAbiertos"];
                    usuario.TicketsUrgentesAbiertos = (int)datos.Lector["TicketsUrgentesAbiertos"];
                    usuario.TicketsFinalizadosAlta = (int)datos.Lector["TicketsFinalizadosAlta"];

                    lista.Add(usuario);
                }

                return lista;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                datos.cerrarConexion();
            }
        }
        public int CalcularUsuarioSugerido(string prioridad, List<CandidatoAsignacionIA> candidatos)
        {
            if (candidatos == null || candidatos.Count == 0) return 0;

            prioridad = prioridad.ToUpper();

            CandidatoAsignacionIA sugerido = null;

            if (prioridad == "ALTA")
            {
                sugerido = candidatos
                    .Where(x => x.TicketsFinalizadosAlta > 0 && x.TicketsUrgentesAbiertos <= 2)
                    .OrderByDescending(x => PuntajePrioridadAlta(x))
                    .ThenBy(x => x.TicketsUrgentesAbiertos)
                    .ThenBy(x => x.TicketsAbiertos)
                    .ThenByDescending(x => x.TicketsFinalizadosAlta)
                    .ThenByDescending(x => x.TicketsFinalizados)
                    .FirstOrDefault();
            }
            else if (prioridad == "MEDIA")
            {
                sugerido = candidatos
                    .OrderByDescending(x => PuntajePrioridadMedia(x))
                    .ThenByDescending(x => x.TicketsFinalizadosAlta)
                    .ThenByDescending(x => x.TicketsFinalizados)
                    .ThenBy(x => x.TicketsAbiertos)
                    .FirstOrDefault();
            }
            else if (prioridad == "BAJA")
            {
                sugerido = candidatos
                    .OrderByDescending(x => PuntajePrioridadBaja(x))
                    .ThenByDescending(x => x.TicketsFinalizadosAlta)
                    .ThenByDescending(x => x.TicketsFinalizados)
                    .ThenBy(x => x.TicketsAbiertos)
                    .FirstOrDefault();
            }

            if (sugerido == null)
            {
                sugerido = candidatos
                    .OrderByDescending(x => x.TicketsFinalizadosAlta)
                    .ThenByDescending(x => x.TicketsFinalizados)
                    .ThenBy(x => x.TicketsAbiertos)
                    .FirstOrDefault();
            }

            return sugerido != null ? sugerido.Id : 0;
        }
        public string ObtenerMotivoSugerencia(CandidatoAsignacionIA candidato)
        {
            if (candidato == null) return "Sin usuarios disponibles para esta área y puesto.";

            string seniority = candidato.Seniority != null ? candidato.Seniority.Nombre : "";

            return seniority +
                   " | Abiertos: " + candidato.TicketsAbiertos +
                   " | Urgentes abiertos: " + candidato.TicketsUrgentesAbiertos +
                   " | Finalizados: " + candidato.TicketsFinalizados;
        }
        private int PuntajePrioridadAlta(CandidatoAsignacionIA candidato)
        {
            if (candidato.Seniority == null) return 0;

            switch (candidato.Seniority.Nombre)
            {
                case "Senior": return 3;
                case "Semi Senior": return 2;
                case "Junior": return 1;
                default: return 0;
            }
        }

        private int PuntajePrioridadMedia(CandidatoAsignacionIA candidato)
        {
            if (candidato.Seniority == null) return 0;

            switch (candidato.Seniority.Nombre)
            {
                case "Semi Senior": return 3;
                case "Junior": return 2;
                case "Senior": return 1;
                default: return 0;
            }
        }

        private int PuntajePrioridadBaja(CandidatoAsignacionIA candidato)
        {
            if (candidato.Seniority == null) return 0;

            switch (candidato.Seniority.Nombre)
            {
                case "Junior": return 3;
                case "Semi Senior": return 2;
                case "Senior": return 1;
                default: return 0;
            }
        }
    }
}