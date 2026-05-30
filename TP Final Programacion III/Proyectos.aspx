<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Proyectos.aspx.cs" Inherits="TP_Final_Programacion_III.Proyectos" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <h1>Proyectos</h1>

    <div class="row">
        <asp:Repeater ID="repProyectos" runat="server">
            <ItemTemplate>
                <div class="col-md-4">
                    <a
                        class="card text-decoration-none text-dark mb-3"
                        href='<%# "Default.aspx" %>'>

                        <div class="card-body">
                            <h5 class="card-title"><%# Eval("Nombre") %></h5>
                            <p class="card-text"><%# Eval("Descripcion") %></p>
                            <p>Estado: <%# Eval("Estado.Nombre") %></p>
                            <p>Inicio: <%# Eval("FechaInicio", "{0:dd/MM/yyyy}") %> </p>
                            <p>Final Esperado: <%# Eval("FechaEstimadaFin", "{0:dd/MM/yyyy}") %> </p>
                        </div>

                    </a>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>

</asp:Content>
