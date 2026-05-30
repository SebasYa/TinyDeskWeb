<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="TP_Final_Programacion_III.Login" %>

<!DOCTYPE html>

<html lang="es">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    <title>Iniciar sesión - TinyDesk</title>

    <link href="Content/bootstrap.min.css" rel="stylesheet" />
</head>
<body class="bg-light">
    <form id="form1" runat="server">

        <div class="container">
            <div class="row justify-content-center align-items-center" style="min-height: 100vh;">
                <div class="col-12 col-sm-8 col-md-5 col-lg-4">

                    <div class="card shadow-sm">
                        <div class="card-body p-4">

                            <h2 class="mb-1 text-center">Iniciar Sesión</h2>
                            <p class="text-muted text-center mb-4">Ingrese las credenciales para continuar</p>

                            <div class="mb-3">
                                <label for="txtDni" class="form-label">Usuario</label>
                                <asp:TextBox ID="txtNombreUsuario" runat="server" CssClass="form-control"></asp:TextBox>
                            </div>

                            <div class="mb-3">
                                <label for="txtPassword" class="form-label">Contraseña</label>
                                <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password"></asp:TextBox>
                            </div>

                            <a href="Default.aspx" class="btn btn-primary w-100 mb-3">Ingresa sin contraseña
                            </a>
                            <asp:Button ID="btnLogin" runat="server" Text="Iniciar Sesión" CssClass="btn btn-primary w-100" OnClick="btnLogin_Click" />

                        </div>
                    </div>

                </div>
            </div>
        </div>

    </form>
</body>
</html>
