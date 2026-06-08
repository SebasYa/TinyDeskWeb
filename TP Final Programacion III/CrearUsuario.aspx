<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CrearUsuario.aspx.cs" Inherits="TP_Final_Programacion_III.CrearUsuario" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container py-4">
        <div class="row justify-content-center">
            <div class="col-12 col-md-10 col-lg-8">
                <div class="card border-0 shadow">
                    <!-- Cabecera del Formulario -->
                    <div class="card-header bg-primary text-white py-3 text-center rounded-top">
                        <h3 class="mb-1 fw-bold">
                            <asp:Label ID="lblTituloFormularioUsuario" runat="server" Text="Crear Usuario"></asp:Label>
                        </h3>
                        <p class="text-white-50 mb-0">
                            <asp:Label ID="txtSubtitulo" runat="server" Visible="true" Text="Completá los datos para registrar un nuevo integrante del equipo"></asp:Label>
                        </p>
                    </div>
                    <div class="card-body p-4">
                        <!-- Sección 1: Datos Personales -->
                        <div class="mb-4">
                            <h5 class="text-primary border-bottom pb-2 mb-3">
                                <i class="bi bi-person-fill me-2"></i>1. Datos Personales
                            </h5>
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label for="txtNombre" class="form-label fw-semibold">Nombre</label>
                                    <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control" placeholder="Ej: Juan"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvNombre" runat="server" ControlToValidate="txtNombre" ErrorMessage="El nombre es obligatorio." CssClass="text-danger text-validation-error" Display="Dynamic" />
                                </div>
                                <div class="col-md-6">
                                    <label for="txtApellido" class="form-label fw-semibold">Apellido</label>
                                    <asp:TextBox ID="txtApellido" runat="server" CssClass="form-control" placeholder="Ej: Pérez"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvApellido" runat="server" ControlToValidate="txtApellido" ErrorMessage="El apellido es obligatorio." CssClass="text-danger text-validation-error" Display="Dynamic" />
                                </div>
                                <div class="col-12">
                                    <label for="txtEmail" class="form-label fw-semibold">Correo Electrónico</label>
                                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="Ej: juan.perez@empresa.com" TextMode="Email"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail" ErrorMessage="El correo electrónico es obligatorio." CssClass="text-danger text-validation-error" Display="Dynamic" />
                                    <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtEmail" ErrorMessage="El formato del correo es inválido." CssClass="text-danger text-validation-error" Display="Dynamic" ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$" />
                                </div>
                            </div>
                        </div>
                        <!-- Sección 2: Asignación Laboral -->
                        <!--  <div class="mb-4">
                            <h5 class="text-primary border-bottom pb-2 mb-3">
                                <i class="bi bi-briefcase-fill me-2"></i>2. Asignación Laboral
                            </h5>
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label for="ddlArea" class="form-label fw-semibold">Área</label>
                                    <asp:DropDownList ID="ddlArea" runat="server" CssClass="form-select">
                                        <asp:ListItem Text="Seleccione un área..." Value="" />
                                    </asp:DropDownList>
                                    <asp:RequiredFieldValidator ID="rfvArea" runat="server" ControlToValidate="ddlArea" InitialValue="" ErrorMessage="Debe seleccionar un área." CssClass="text-danger text-validation-error" Display="Dynamic" />
                                </div>
                                <div class="col-md-6">
                                    <label for="ddlPuesto" class="form-label fw-semibold">Puesto Laboral</label>
                                    <asp:DropDownList ID="ddlPuesto" runat="server" CssClass="form-select">
                                        <asp:ListItem Text="Seleccione un puesto..." Value="" />
                                    </asp:DropDownList>
                                    <asp:RequiredFieldValidator ID="rfvPuesto" runat="server" ControlToValidate="ddlPuesto" InitialValue="" ErrorMessage="Debe seleccionar un puesto." CssClass="text-danger text-validation-error" Display="Dynamic" />
                                </div>
                                <div class="col-12 mt-3">
                                    <div class="form-check form-switch ps-5 fs-6">
                                        <input class="form-check-input" type="checkbox" id="chkPermisoEscritura" runat="server" clientidmode="Static" />
                                        <label class="form-check-label fw-semibold ps-2" for="chkPermisoEscritura">Asignar Permiso de Administrador</label>
                                    </div>
                                </div>
                            </div>
                        </div>  -->
                        <div class="mb-4">
                            <h5 class="text-primary border-bottom pb-2 mb-3">
                                <i class="bi bi-briefcase-fill me-2"></i>2. Asignación Laboral
                            </h5>
                            <div class="row g-3">
                                <div class="col-md-4">
                                    <label for="ddlArea" class="form-label fw-semibold">Área</label>
                                    <asp:DropDownList ID="ddlArea" runat="server" CssClass="form-select">
                                        <asp:ListItem Text="Seleccione un área..." Value="" />
                                    </asp:DropDownList>
                                    <asp:RequiredFieldValidator ID="rfvArea" runat="server" ControlToValidate="ddlArea" InitialValue="" ErrorMessage="Debe seleccionar un área." CssClass="text-danger text-validation-error" Display="Dynamic" />
                                </div>

                                <div class="col-md-4">
                                    <label for="ddlPuesto" class="form-label fw-semibold">Puesto Laboral</label>
                                    <asp:DropDownList ID="ddlPuesto" runat="server" CssClass="form-select">
                                        <asp:ListItem Text="Seleccione un puesto..." Value="" />
                                    </asp:DropDownList>
                                    <asp:RequiredFieldValidator ID="rfvPuesto" runat="server" ControlToValidate="ddlPuesto" InitialValue="" ErrorMessage="Debe seleccionar un puesto." CssClass="text-danger text-validation-error" Display="Dynamic" />
                                </div>

                                <div class="col-md-4">
                                    <label for="ddlSeniority" class="form-label fw-semibold">Seniority</label>
                                    <asp:DropDownList ID="ddlSeniority" runat="server" CssClass="form-select">
                                        <asp:ListItem Text="Seleccione un seniority..." Value="" />
                                    </asp:DropDownList>
                                    <asp:RequiredFieldValidator ID="rfvSeniority" runat="server" ControlToValidate="ddlSeniority" InitialValue="" ErrorMessage="Debe seleccionar un seniority." CssClass="text-danger text-validation-error" Display="Dynamic" />
                                </div>

                                <div class="col-12 mt-3">
                                    <div class="form-check form-switch ps-5 fs-6">
                                        <input class="form-check-input" type="checkbox" id="chkPermisoEscritura" runat="server" clientidmode="Static" />
                                        <label class="form-check-label fw-semibold ps-2" for="chkPermisoEscritura">Permitir crear y gestionar tickets</label>
                                    </div>
                                </div>

                                <div class="col-12 mt-2">
                                    <div class="form-check form-switch ps-5 fs-6">
                                        <input class="form-check-input" type="checkbox" id="chkEsAdmin" runat="server" clientidmode="Static" />
                                        <label class="form-check-label fw-semibold ps-2" for="chkEsAdmin">Permiso administrador</label>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- Sección 3: Credenciales de Acceso -->
                        <div class="mb-4">
                            <h5 class="text-primary border-bottom pb-2 mb-3">
                                <i class="bi bi-key-fill me-2"></i>3. Credenciales de Acceso
                            </h5>
                            <div class="row g-3">
                                <div class="col-12">
                                    <label for="txtNombreUsuario" class="form-label fw-semibold">Nombre de Usuario</label>
                                    <asp:TextBox ID="txtNombreUsuario" runat="server" CssClass="form-control" placeholder="Ej: jperez"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvNombreUsuario" runat="server" ControlToValidate="txtNombreUsuario" ErrorMessage="El usuario es obligatorio." CssClass="text-danger text-validation-error" Display="Dynamic" />
                                </div>
                                <!-- 
                                <div class="col-md-6">
                                    <label for="txtPassword" class="form-label fw-semibold">Contraseña</label>
                                    <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder=""></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="txtPassword" ErrorMessage="La contraseña es obligatoria." CssClass="text-danger text-validation-error" Display="Dynamic" />
                                </div>
                                <div class="col-md-6">
                                    <label for="txtConfirmarPassword" class="form-label fw-semibold">Confirmar contraseña</label>
                                    <asp:TextBox ID="txtConfirmarPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder=""></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvConfirmarPassword" runat="server" ControlToValidate="txtConfirmarPassword" ErrorMessage="Debe confirmar la contraseña." CssClass="text-danger text-validation-error" Display="Dynamic" />
                                    <asp:CompareValidator ID="cvConfirmarPassword" runat="server" ControlToValidate="txtConfirmarPassword" ControlToCompare="txtPassword" ErrorMessage="Las contraseñas no coinciden." CssClass="text-danger text-validation-error" Display="Dynamic" />
                                </div>
                                    -->
                            </div>
                        </div>
                        <!-- Botón de Guardado -->
                        <div class="mt-4 pt-2">
                            <asp:Button ID="btnCrearUsuario" runat="server" Text="Crear usuario" CssClass="btn btn-primary w-100 py-2 fw-semibold fs-5 shadow-sm" OnClick="btnCrearUsuario_Click" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
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
