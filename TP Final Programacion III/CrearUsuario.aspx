<%@ Page Title="Crear Usuario" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CrearUsuario.aspx.cs" Inherits="TP_Final_Programacion_III.CrearUsuario" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container py-4">
        <div class="row justify-content-center align-items-center" style="min-height: 70vh;">
            <div class="col-12 col-sm-10 col-md-8 col-lg-6">

                <div class="card shadow-sm">
                    <div class="card-body p-4">

                        <h2 class="mb-1 text-center">Crear Usuario</h2>
                        <p class="text-muted text-center mb-4">Completá los datos para registrar un nuevo integrante</p>

                        <div class="mb-3">
                            <label for="txtNombre" class="form-label">Nombre</label>
                            <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control" placeholder="Ej: Juan"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvNombre" runat="server" ControlToValidate="txtNombre" ErrorMessage="El nombre es obligatorio." CssClass="text-danger text-validation-error" Display="Dynamic" />
                        </div>

                        <div class="mb-3">
                            <label for="txtApellido" class="form-label">Apellido</label>
                            <asp:TextBox ID="txtApellido" runat="server" CssClass="form-control" placeholder="Ej: Pérez"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvApellido" runat="server" ControlToValidate="txtApellido" ErrorMessage="El apellido es obligatorio." CssClass="text-danger text-validation-error" Display="Dynamic" />
                        </div>

                        <div class="mb-3">
                            <label for="txtNombreUsuario" class="form-label">Usuario</label>
                            <asp:TextBox ID="txtNombreUsuario" runat="server" CssClass="form-control" placeholder="Ej: jperez"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvNombreUsuario" runat="server" ControlToValidate="txtNombreUsuario" ErrorMessage="El usuario es obligatorio." CssClass="text-danger text-validation-error" Display="Dynamic" />
                        </div>


                        <div class="mb-3">
                            <label for="ddlArea" class="form-label">Área</label>
                            <asp:DropDownList ID="ddlArea" runat="server" CssClass="form-select">
                                <asp:ListItem Text="Seleccione un área..." Value="" />
                            </asp:DropDownList>
                            <asp:RequiredFieldValidator ID="rfvArea" runat="server" ControlToValidate="ddlArea" InitialValue="" ErrorMessage="Debe seleccionar un área." CssClass="text-danger text-validation-error" Display="Dynamic" />
                        </div>

                        <div class="mb-3">
                            <label for="ddlPuesto" class="form-label">Puesto Laboral</label>
                            <asp:DropDownList ID="ddlPuesto" runat="server" CssClass="form-select">
                                <asp:ListItem Text="Seleccione un puesto..." Value="" />
                            </asp:DropDownList>
                            <asp:RequiredFieldValidator ID="rfvPuesto" runat="server" ControlToValidate="ddlPuesto" InitialValue="" ErrorMessage="Debe seleccionar un puesto." CssClass="text-danger text-validation-error" Display="Dynamic" />
                        </div>

                        <div class="mb-3">
                            <asp:Label ID="lblPermisoEscritura" runat="server" AssociatedControlID="chkPermisoEscritura" CssClass="form-check-label">
                                Permiso Admin
                            </asp:Label>
                            <asp:CheckBox ID="chkPermisoEscritura" runat="server" />
                        </div>

                        <div class="mb-3">
                            <label for="txtPassword" class="form-label">Contraseña</label>
                            <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="txtPassword" ErrorMessage="La contraseña es obligatoria." CssClass="text-danger text-validation-error" Display="Dynamic" />
                        </div>

                        <div class="mb-4">
                            <label for="txtConfirmarPassword" class="form-label">Confirmar contraseña</label>
                            <asp:TextBox ID="txtConfirmarPassword" runat="server" CssClass="form-control" TextMode="Password"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvConfirmarPassword" runat="server" ControlToValidate="txtConfirmarPassword" ErrorMessage="Debe confirmar la contraseña." CssClass="text-danger text-validation-error" Display="Dynamic" />
                        </div>

                        <asp:Button ID="btnCrearUsuario" runat="server" Text="Crear usuario" CssClass="btn btn-primary w-100" OnClick="btnCrearUsuario_Click" />

                    </div>
                </div>

            </div>
        </div>
    </div>
    <script type="text/javascript">
        document.addEventListener("DOMContentLoaded", function () {
            if (typeof ValidatorUpdateDisplay === 'function') {
                var originalValidatorUpdateDisplay = ValidatorUpdateDisplay;
                ValidatorUpdateDisplay = function (val) {
                    originalValidatorUpdateDisplay(val);
                    var control = document.getElementById(val.controltovalidate);
                    if (control) {
                        var isValid = true;
                        for (var i = 0; i < Page_Validators.length; i++) {
                            var v = Page_Validators[i];
                            if (v.controltovalidate === val.controltovalidate && !v.isvalid) {
                                isValid = false;
                                break;
                            }
                        }
                        if (!isValid) {
                            control.classList.add('is-invalid');
                        } else {
                            control.classList.remove('is-invalid');
                        }
                    }
                };
            }
        });
    </script>
    <style>
        .form-control.is-invalid, .form-select.is-invalid {
            border-color: #dc3545 !important;
            box-shadow: 0 0 0 0.25rem rgba(220, 53, 69, 0.25) !important;
        }

        .text-validation-error {
            font-size: 0.875em;
            margin-top: 0.25rem;
            display: block;
        }
    </style>
</asp:Content>
