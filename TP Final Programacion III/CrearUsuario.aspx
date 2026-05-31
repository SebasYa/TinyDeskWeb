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
                        </div>

                        <div class="mb-3">
                            <label for="txtApellido" class="form-label">Apellido</label>
                            <asp:TextBox ID="txtApellido" runat="server" CssClass="form-control" placeholder="Ej: Pérez"></asp:TextBox>
                        </div>

                        <div class="mb-3">
                            <label for="txtNombreUsuario" class="form-label">Usuario</label>
                            <asp:TextBox ID="txtNombreUsuario" runat="server" CssClass="form-control" placeholder="Ej: jperez"></asp:TextBox>
                        </div>


                        <div class="mb-3">
                            <label for="ddlArea" class="form-label">Área</label>
                            <asp:DropDownList ID="ddlArea" runat="server" CssClass="form-select">
                                <asp:ListItem Text="Seleccione un área..." Value="" />
                            </asp:DropDownList>
                        </div>

                        <div class="mb-3">
                            <label for="ddlPuesto" class="form-label">Puesto Laboral</label>
                            <asp:DropDownList ID="ddlPuesto" runat="server" CssClass="form-select">
                                <asp:ListItem Text="Seleccione un puesto..." Value="" />
                            </asp:DropDownList>
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
                        </div>

                        <div class="mb-4">
                            <label for="txtConfirmarPassword" class="form-label">Confirmar contraseña</label>
                            <asp:TextBox ID="txtConfirmarPassword" runat="server" CssClass="form-control" TextMode="Password"></asp:TextBox>
                        </div>

                        <asp:Button ID="btnCrearUsuario" runat="server" Text="Crear usuario" CssClass="btn btn-primary w-100" OnClick="btnCrearUsuario_Click" />

                    </div>
                </div>

            </div>
        </div>
    </div>
</asp:Content>
