<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="TP_Final_Programacion_III.Login" %>

<!DOCTYPE html>

<html lang="es">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    <title>Iniciar sesión - TinyDesk</title>

    <link href="Content/bootstrap.min.css" rel="stylesheet" />
    <style>
        .form-control.is-invalid {
            border-color: #dc3545 !important;
            padding-right: calc(1.5em + 0.75rem);
        }

            .form-control.is-invalid:focus {
                border-color: #dc3545 !important;
                box-shadow: 0 0 0 0.25rem rgba(220, 53, 69, 0.25) !important;
            }

        .text-validation-error {
            font-size: 0.875em;
            margin-top: 0.25rem;
            display: block;
        }
    </style>
</head>
<body class="bg-light">
    <form id="form1" runat="server">

        <div class="container">
            <div class="row justify-content-center align-items-center" style="min-height: 100vh;">
                <div class="col-12 col-sm-8 col-md-5 col-lg-4">

                    <div class="card shadow-sm">
                        <div class="card-body p-4">
                            <div class="text-center">
                                <img runat="server"
                                    src="~/Images/LogoTD.png"
                                    alt="Logo TinyDesk"
                                    style="width: 120px; height: 120px; object-fit: contain; display: block; margin: -30px auto -22px; transform: translateX(5px);" />
                                <p class="text-muted text-center mb-0">TinyDesk</p>
                            </div>
                            <h2 class="mt-0 mb-1 text-center">Iniciar Sesión</h2>
                            

                            <div class="mb-3">
                                <label for="txtNombreUsuario" class="form-label">Usuario</label>
                                <asp:TextBox ID="txtNombreUsuario" runat="server" CssClass="form-control"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvUsuario" runat="server"
                                    ControlToValidate="txtNombreUsuario"
                                    ErrorMessage="Ingrese un usuario válido."
                                    CssClass="text-danger text-validation-error"
                                    Display="Dynamic" />
                                <asp:Label ID="lblErrorUsuario" runat="server"
                                    CssClass="alert alert-danger text-center d-block py-2 mb-3"
                                    Visible="false"
                                    Style="font-size: 0.9em;"></asp:Label>
                            </div>

                            <div class="mb-3">
                                <label for="txtPassword" class="form-label">Contraseña</label>
                                <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvPassword" runat="server"
                                    ControlToValidate="txtPassword"
                                    ErrorMessage="Ingrese una contraseña válida."
                                    CssClass="text-danger text-validation-error"
                                    Display="Dynamic" />
                                <asp:Label ID="lblErrorPass" runat="server"
                                    CssClass="alert alert-danger text-center d-block py-2 mb-3"
                                    Visible="false"
                                    Style="font-size: 0.9em;"></asp:Label>
                            </div>

                            <asp:Button ID="btnMockLogin" runat="server"
                                Text="Ingresar sin contraseña (Mock)"
                                CssClass="btn btn-outline-secondary w-100 mb-3"
                                OnClick="btnLoginFantasmin_Click"
                                CausesValidation="false" />

                            <asp:Button ID="btnLogin" runat="server"
                                Text="Iniciar Sesión"
                                CssClass="btn btn-primary w-100"
                                OnClick="btnLogin_Click"
                                OnClientClick="clearErrors();" />

                            <asp:Panel ID="pnlReenvioValidacion" runat="server" Visible="false" CssClass="alert alert-warning mt-3">
                                <asp:Label ID="lblReenvioValidacion" runat="server"></asp:Label>

                                <asp:Button ID="btnReenviarValidacion" runat="server"
                                    Text="Reenviar correo de validación"
                                    CssClass="btn btn-outline-warning w-100 mt-2"
                                    CausesValidation="false"
                                    OnClick="btnReenviarValidacion_Click" />
                            </asp:Panel>

                            <div class="text-center mt-2">
                                <a href="RecuperarPass.aspx" class="text-decoration-none">¿Te olvidaste la contraseña?</a>
                            </div>

                            <div class="text-center mt-3">
                                <span class="text-muted">¿No tenés cuenta?</span>
                                <a href="Registro.aspx" class="text-decoration-none">Crear usuario</a>
                            </div>

                        </div>
                    </div>

                </div>
            </div>
        </div>

    </form>

    <script type="text/javascript">
        function clearErrors() {
            document.getElementById("lblErrorUsuario")?.remove();
            document.getElementById("lblErrorPass")?.remove();

            document.getElementById("txtNombreUsuario")?.classList.remove("is-invalid");
            document.getElementById("txtPassword")?.classList.remove("is-invalid");
        }
    </script>
</body>
</html>
