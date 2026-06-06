<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ValidarEmail.aspx.cs" Inherits="TP_Final_Programacion_III.ValidarEmail" %>

<!DOCTYPE html>
<html lang="es">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Validar cuenta - TinyDesk</title>
    <link href="Content/bootstrap.min.css" rel="stylesheet" />
</head>
<body class="bg-light">
    <form id="form1" runat="server">
        <div class="container">
            <div class="row justify-content-center align-items-center" style="min-height: 100vh;">
                <div class="col-12 col-sm-10 col-md-6 col-lg-5">
                    <div class="card shadow-sm">
                        <div class="card-body p-4 text-center">
                            <h2 class="mb-3">Validación de cuenta</h2>

                            <asp:Label ID="lblMensaje" runat="server" CssClass="d-block mb-3"></asp:Label>

                            <asp:Panel ID="pnlCargando" runat="server" Visible="false">
                                <div class="spinner-border text-primary mb-3" role="status">
                                    <span class="visually-hidden">Cargando...</span>
                                </div>

                                <p class="text-muted mb-0">
                                    Aguarde unos instantes. Será redirigido al inicio de sesión.
                                </p>
                            </asp:Panel>
                            <asp:Literal ID="litRedireccion" runat="server"></asp:Literal>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>

</body>
</html>
