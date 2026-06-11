<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RecuperarPass.aspx.cs" Inherits="TP_Final_Programacion_III.RecuperarPass" %>

<!DOCTYPE html>
<html lang="es">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Recuperar contraseña - TinyDesk</title>
    <link href="Content/bootstrap.min.css" rel="stylesheet" />
</head>
<body class="bg-light">
    <form id="form1" runat="server">
        <div class="container">
            <div class="row justify-content-center align-items-center" style="min-height: 100vh;">
                <div class="col-12 col-sm-10 col-md-6 col-lg-5">
                    <div class="card shadow-sm">
                        <div class="card-body p-4">
                            <h2 class="mb-1 text-center">Recuperar contraseña</h2>
                            <p class="text-muted text-center mb-4">Ingresá tu usuario o email para recibir un link de cambio de contraseña en tu casilla de correo electronico.</p>

                            <asp:Literal ID="litMensaje" runat="server"></asp:Literal>

                            <div class="mb-3">
                                <label for="txtNombreUsuario" class="form-label">Usuario/Email</label>
                                <asp:TextBox ID="txtNombreUsuario" runat="server" CssClass="form-control"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvUsuario" runat="server"
                                    ControlToValidate="txtNombreUsuario"
                                    ErrorMessage="Ingrese un usuario/email válido."
                                    CssClass="text-danger text-validation-error"
                                    Display="Dynamic" />
                            </div>

                            <asp:Button ID="btnEnviarRecuperacion" runat="server"
                                Text="Enviar correo"
                                CssClass="btn btn-primary w-100"
                                OnClick="btnEnviarRecuperacion_Click" />

                            <div class="text-center mt-3">
                                <a href="Login.aspx" class="text-decoration-none">Volver a iniciar sesión</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <style>
            .text-validation-error {
                font-size: 0.875em;
                margin-top: 0.25rem;
                display: block;
            }
        </style>
    </form>
</body>
</html>
