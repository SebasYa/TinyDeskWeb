<%@ Page Title="Contacto" Language="C#" AutoEventWireup="true" CodeBehind="Contacto.aspx.cs" Inherits="TP_Final_Programacion_III.Contacto" %>

<!DOCTYPE html>

<html lang="es">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    <title>Contacto - TinyDesk</title>

    <link href="Content/bootstrap.min.css" rel="stylesheet" />
    <link href="Content/Site.css" rel="stylesheet" />
    <link href="favicon.ico" rel="shortcut icon" type="image/x-icon" />
</head>

<body class="bg-light">
    <form id="form1" runat="server"
        class="min-vh-100 d-flex flex-column">

        <header class="bg-white border-bottom">
            <div class="container py-3 d-flex justify-content-between align-items-center">

                <asp:LinkButton ID="btnInicio"
                    runat="server"
                    CausesValidation="false"
                    OnClick="btnInicio_Click"
                    CssClass="d-flex align-items-center text-decoration-none text-dark">

                    <span class="position-relative overflow-hidden me-2"
                        style="width: 42px; height: 42px;">

                        <img src="Images/LogoTD.png"
                            alt="TinyDesk"
                            style="position: absolute;
                                   width: 58px;
                                   height: 58px;
                                   max-width: none;
                                   top: 50%;
                                   left: 50%;
                                   transform: translate(-50%, -50%);" />
                    </span>

                    <span class="fw-bold fs-4">TinyDesk</span>

                </asp:LinkButton>

                <asp:LinkButton ID="btnVolver"
                    runat="server"
                    CausesValidation="false"
                    OnClick="btnInicio_Click"
                    CssClass="btn btn-outline-primary btn-sm">

                    Volver a TinyDesk

                </asp:LinkButton>

            </div>
        </header>

        <main class="container flex-grow-1 py-5">

            <div class="row justify-content-center">
                <div class="col-lg-8 col-xl-7">

                    <div class="text-center mb-4">
                        <h1 class="fw-bold">Contactanos</h1>

                        <p class="text-muted">
                            Seleccioná el motivo y contanos cómo podemos ayudarte.
                        </p>
                    </div>

                    <div class="card border-0 shadow-sm">
                        <div class="card-body p-4 p-md-5">

                            <asp:Panel ID="pnlDatosSesion"
                                runat="server"
                                Visible="false"
                                CssClass="alert alert-light border mb-4">

                                <span class="text-muted small">Estás contactando como
                                </span>

                                <div class="fw-bold">
                                    <asp:Label ID="lblSesionNombre"
                                        runat="server" />
                                </div>

                                <div class="text-muted small">
                                    <asp:Label ID="lblSesionDetalle"
                                        runat="server" />
                                </div>

                            </asp:Panel>

                            <asp:Panel ID="pnlDatosPublicos"
                                runat="server">

                                <div class="mb-3">
                                    <label class="form-label">
                                        Nombre y apellido
                                    </label>

                                    <asp:TextBox ID="txtNombre"
                                        runat="server"
                                        CssClass="form-control" />

                                    <asp:RequiredFieldValidator ID="rfvNombre"
                                        runat="server"
                                        ControlToValidate="txtNombre"
                                        ValidationGroup="Contacto"
                                        ErrorMessage="Ingresá tu nombre."
                                        CssClass="text-danger small"
                                        Display="Dynamic" />
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">
                                        Correo electrónico
                                    </label>

                                    <asp:TextBox ID="txtEmail"
                                        runat="server"
                                        CssClass="form-control"
                                        TextMode="Email" />

                                    <asp:RequiredFieldValidator ID="rfvEmail"
                                        runat="server"
                                        ControlToValidate="txtEmail"
                                        ValidationGroup="Contacto"
                                        ErrorMessage="Ingresá tu correo electrónico."
                                        CssClass="text-danger small"
                                        Display="Dynamic" />

                                    <asp:RegularExpressionValidator ID="revEmail"
                                        runat="server"
                                        ControlToValidate="txtEmail"
                                        ValidationGroup="Contacto"
                                        ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$"
                                        ErrorMessage="Ingresá un correo válido."
                                        CssClass="text-danger small"
                                        Display="Dynamic" />
                                </div>

                            </asp:Panel>

                            <div class="mb-3">
                                <label class="form-label">Motivo</label>

                                <asp:DropDownList ID="ddlMotivo"
                                    runat="server"
                                    CssClass="form-select">

                                    <asp:ListItem
                                        Text="Seleccioná un motivo"
                                        Value="" />

                                    <asp:ListItem
                                        Text="Consulta general"
                                        Value="1" />

                                    <asp:ListItem
                                        Text="Problemas para ingresar"
                                        Value="2" />

                                    <asp:ListItem
                                        Text="Soporte técnico"
                                        Value="3" />

                                    <asp:ListItem
                                        Text="Planes y facturación"
                                        Value="4" />

                                    <asp:ListItem
                                        Text="Sugerencia"
                                        Value="5" />

                                </asp:DropDownList>

                                <asp:RequiredFieldValidator ID="rfvMotivo"
                                    runat="server"
                                    ControlToValidate="ddlMotivo"
                                    InitialValue=""
                                    ValidationGroup="Contacto"
                                    ErrorMessage="Seleccioná un motivo."
                                    CssClass="text-danger small"
                                    Display="Dynamic" />
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Mensaje</label>

                                <asp:TextBox ID="txtMensaje"
                                    runat="server"
                                    CssClass="form-control"
                                    TextMode="MultiLine"
                                    Rows="7" />

                                <div class="form-text">
                                    Máximo 200 palabras.
                                </div>

                                <asp:RequiredFieldValidator ID="rfvMensaje"
                                    runat="server"
                                    ControlToValidate="txtMensaje"
                                    ValidationGroup="Contacto"
                                    ErrorMessage="Escribí un mensaje."
                                    CssClass="text-danger small"
                                    Display="Dynamic" />
                            </div>

                            <asp:ValidationSummary ID="vsContacto"
                                runat="server"
                                ValidationGroup="Contacto"
                                CssClass="alert alert-danger"
                                HeaderText="Revisá los siguientes datos:"
                                DisplayMode="BulletList" />

                            <asp:Panel ID="pnlResultado"
                                runat="server"
                                Visible="false"
                                CssClass="alert">

                                <asp:Label ID="lblResultado"
                                    runat="server" />

                            </asp:Panel>

                            <div class="d-grid">
                                <asp:Button ID="btnEnviar"
                                    runat="server"
                                    Text="Enviar mensaje"
                                    CssClass="btn btn-primary"
                                    ValidationGroup="Contacto"
                                    OnClick="btnEnviar_Click" />
                            </div>

                        </div>
                    </div>

                </div>
            </div>

        </main>

        <footer class="bg-white border-top">
            <div class="container py-3 d-flex flex-column flex-sm-row
                        justify-content-between align-items-center gap-2">

                <div class="d-flex align-items-center gap-1">

                    <span style="width: 22px; height: 22px; overflow: hidden; position: relative; flex: 0 0 22px;">

                        <img runat="server"
                            src="~/Images/LogoTD.png"
                            alt="TinyDesk"
                            style="width: 32px; height: 32px; position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); filter: grayscale(1) brightness(0); opacity: .55;" />

                    </span>

                    <span class="text-muted small">&copy; <%: DateTime.Now.Year %> TinyDesk
                    </span>

                </div>

                <nav class="d-flex align-items-center gap-3">

                    <asp:LinkButton ID="btnIrAbout"
                        runat="server"
                        CausesValidation="false"
                        OnClick="btnIrAbout_Click"
                        CssClass="btn btn-link text-muted text-decoration-none small p-0">
                        Acerca de
                    </asp:LinkButton>

                    <asp:LinkButton ID="btnIrContacto"
                        runat="server"
                        CausesValidation="false"
                        OnClick="btnIrContacto_Click"
                        CssClass="btn btn-link text-muted text-decoration-none small p-0">
                        Contacto
                    </asp:LinkButton>

                </nav>

            </div>
        </footer>

    </form>
</body>
</html>
