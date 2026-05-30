<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Registro.aspx.cs" Inherits="TP_Final_Programacion_III.Registro" %>

<!DOCTYPE html>

<html lang="es">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    <title>Crear usuario - TinyDesk</title>

    <link href="Content/bootstrap.min.css" rel="stylesheet" />
</head>
<body class="bg-light">
    <form id="form1" runat="server">

        <div class="container">
            <div class="row justify-content-center align-items-center" style="min-height: 100vh;">
                <div class="col-12 col-sm-10 col-md-6 col-lg-5">

                    <div class="card shadow-sm">
                        <div class="card-body p-4">

                            <h2 class="mb-1 text-center">Crear usuario</h2>
                            <p class="text-muted text-center mb-4">Completá tus datos para registrarte</p>

                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label for="txtNombre" class="form-label">Nombre</label>
                                    <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control"></asp:TextBox>
                                </div>

                                <div class="col-md-6 mb-3">
                                    <label for="txtApellido" class="form-label">Apellido</label>
                                    <asp:TextBox ID="txtApellido" runat="server" CssClass="form-control"></asp:TextBox>
                                </div>
                            </div>
                            <div class="mb-3">
                                <label for="txtNombreEmpresa" class="form-label">Nombre de tu Empresa / Organización</label>
                                <asp:TextBox ID="txtNombreEmpresa" runat="server" CssClass="form-control" placeholder="Ej: Mi Empresa S.A."></asp:TextBox>
                            </div>
                            <div class="mb-3">
                                <label for="txtNombreUsuario" class="form-label">Usuario</label>
                                <asp:TextBox ID="txtNombreUsuario" runat="server" CssClass="form-control"></asp:TextBox>
                            </div>


                            <div class="mb-3">
                                <label for="txtPassword" class="form-label">Contraseña</label>
                                <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password"></asp:TextBox>
                            </div>

                            <div class="mb-4">
                                <label for="txtConfirmarPassword" class="form-label">Confirmar contraseña</label>
                                <asp:TextBox ID="txtConfirmarPassword" runat="server" CssClass="form-control" TextMode="Password"></asp:TextBox>
                            </div>

                            <asp:Button ID="btnCrearUsuario" runat="server" Text="Crear usuario" CssClass="btn btn-primary w-100" OnClick="btnCrearUsuario_Click" />

                            <div class="text-center mt-3">
                                <a href="Login.aspx" class="text-decoration-none">Volver a iniciar sesión</a>
                            </div>

                        </div>
                    </div>

                </div>
            </div>
        </div>

    </form>
</body>
</html>
