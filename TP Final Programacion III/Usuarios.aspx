<%@ Page Title="Usuarios" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Usuarios.aspx.cs" Inherits="TP_Final_Programacion_III.Usuarios" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1 class="h2 text-dark font-weight-bold">Gestión de Usuarios</h1>
            <a href="CrearUsuario.aspx" class="btn btn-success d-flex align-items-center gap-2 shadow-sm">Crear Usuario
            </a>
        </div>

        <asp:GridView ID="dgvUsuarios" runat="server" AutoGenerateColumns="False" CssClass="table table-striped table-bordered shadow-sm">
            <Columns>
                <asp:BoundField DataField="Apellido" HeaderText="Apellido" />
                <asp:BoundField DataField="Nombre" HeaderText="Nombre" />
                <asp:BoundField DataField="NombreUsuario" HeaderText="Usuario" />

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
                <asp:CheckBoxField DataField="Activo" HeaderText="Activo" />
            </Columns>
        </asp:GridView>
    </div>
</asp:Content>
