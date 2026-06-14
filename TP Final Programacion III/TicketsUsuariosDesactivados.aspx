<%@ Page Title="Tickets con usuarios desactivados" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="TicketsUsuariosDesactivados.aspx.cs" Inherits="TP_Final_Programacion_III.TicketsUsuariosDesactivados" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-4">
        <asp:Literal ID="litMensaje" runat="server"></asp:Literal>

        <asp:GridView ID="dgvTickets" runat="server"
            CssClass="table table-hover align-middle bg-white border-0 shadow-sm rounded mb-0"
            AutoGenerateColumns="false"
            AllowPaging="true"
            PageSize="10"
            GridLines="None"
            OnPageIndexChanging="dgvTickets_PageIndexChanging">

            <HeaderStyle CssClass="table-light text-secondary fw-semibold border-bottom" />

            <Columns>
                <asp:TemplateField HeaderText="Ticket">
                    <ItemTemplate>
                        <div class="fw-bold text-dark">#<%# Eval("Id") %></div>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Usuario desactivado">
                    <ItemTemplate>
                        <div class="fw-semibold text-dark">
                            <%# Eval("Usuario.Nombre") %> <%# Eval("Usuario.Apellido") %>
                        </div>
                        <small class="text-muted"><%# Eval("Usuario.Email") %></small>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Área / Puesto">
                    <ItemTemplate>
                        <span class="badge bg-secondary-subtle text-secondary rounded-pill">
                            <%# Eval("Usuario.Area.Nombre") %>
                        </span>
                        <div class="small text-muted mt-1"><%# Eval("Usuario.Puesto.Nombre") %> <%# Eval("Usuario.Seniority") != null ? Eval("Usuario.Seniority.Nombre") : "" %></div>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Proyecto / Sprint">
                    <ItemTemplate>
                        <div class="fw-semibold"><%# Eval("Sprint.Proyecto.Nombre") %></div>
                        <small class="text-muted">Sprint <%# Eval("Sprint.NumeroSprint") %></small>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Prioridad">
                    <ItemTemplate>
                        <span class='<%# GetClassPrioridad(Eval("Prioridad.Nombre")) %>'>
                            <%# Eval("Prioridad.Nombre") %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Estado">
                    <ItemTemplate>
                        <span class='<%# GetClassEstado(Eval("Estado.Nombre")) %>'>
                            <%# Eval("Estado.Nombre") %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Fechas">
                    <ItemTemplate>
                        <div class="small">
                            <%# Convert.ToDateTime(Eval("FechaInicio")).ToString("dd/MM/yyyy") %> -
                            <%# Convert.ToDateTime(Eval("FechaEstimadaFin")).ToString("dd/MM/yyyy") %>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>
</asp:Content>
