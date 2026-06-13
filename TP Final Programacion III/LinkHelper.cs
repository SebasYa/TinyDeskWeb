using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;

namespace TP_Final_Programacion_III
{
    public class LinkHelper
    {
        public static string GenerarLink(Page pagina, string destino, string parametro, string valor)
        {
            return pagina.Request.Url.GetLeftPart(UriPartial.Authority)
                + pagina.ResolveUrl("~/" + destino)
                + "?" + parametro + "=" + valor;
        }
    }
}