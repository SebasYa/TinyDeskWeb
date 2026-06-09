<%@ Page Title="Usuarios" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Usuarios.aspx.cs" Inherits="TP_Final_Programacion_III.Usuarios" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1 class="h2 text-dark font-weight-bold">Gestión de Usuarios</h1>
            <a href="CrearUsuario.aspx" class="btn btn-success d-flex align-items-center gap-2 shadow-sm">Crear Usuario
            </a>
        </div>

        <asp:GridView ID="dgvUsuarios" runat="server" AutoGenerateColumns="False" DataKeyNames="Id" OnSelectedIndexChanged="dgvUsuarios_SelectedIndexChanged" OnPageIndexChanging="dgvUsuarios_PageIndexChanging" CssClass="table table-striped table-bordered shadow-sm">
            <Columns>
                <asp:BoundField DataField="Apellido" HeaderText="Apellido" />
                <asp:BoundField DataField="Nombre" HeaderText="Nombre" />
                <asp:BoundField DataField="NombreUsuario" HeaderText="Usuario" />
                <asp:BoundField DataField="Email" HeaderText="Correo Electrónico" />

                <asp:TemplateField HeaderText="Área">
                    <ItemTemplate>
                        <%# Eval("Area.Nombre") %>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Puesto">
                    <ItemTemplate>
                        <%# Eval("Puesto.Nombre") %>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Activo">
                    <ItemTemplate>
                        <span class='<%# (bool)Eval("Activo") ? "text-success" : "text-danger" %>'
                            title='<%# (bool)Eval("Activo") ? "Usuario activo" : "Usuario inactivo" %>'>
                            <i class='<%# (bool)Eval("Activo") ? "bi bi-check-circle-fill" : "bi bi-x-circle-fill" %>'></i>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Invitación">
                    <ItemTemplate>
                        <asp:Literal ID="litInvitacion" runat="server"
                            Mode="PassThrough"
                            Text='<%# ObtenerIconoInvitacion(Eval("Id"), Eval("EmailVerificado")) %>'>
                        </asp:Literal>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Editar">
                    <ItemTemplate>
                        <asp:LinkButton ID="btnEditarUsuario" runat="server" CommandName="Select"
                            CssClass="btn btn-link text-muted p-0 lh-1">
                            <i class="bi bi-pencil me-2 text-muted"></i>
                        </asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>

            </Columns>
        </asp:GridView>
    </div>
</asp:Content>
