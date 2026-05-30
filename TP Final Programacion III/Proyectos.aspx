<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Proyectos.aspx.cs" Inherits="TP_Final_Programacion_III.Proyectos" %>
<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <h1>Proyectos</h1>

    <div class="row">

        <div class="col-md-4">
            <asp:LinkButton 
                ID="btnProyectoDemo1" 
                runat="server" 
                CssClass="card text-decoration-none text-dark mb-3"
                OnClick="btnProyecto_Click"
                CommandArgument="1">

                <div class="card-body">
                    <h5 class="card-title">Proyecto Demo</h5>
                    <p class="card-text">Sistema interno de gestión.</p>
                    <p>Estado: Activo</p>
                    <p>Inicio: 01/06/2026</p>
                </div>

            </asp:LinkButton>
        </div>

        <div class="col-md-4">
            <asp:LinkButton 
                ID="btnProyectoDemo2" 
                runat="server" 
                CssClass="card text-decoration-none text-dark mb-3"
                OnClick="btnProyecto_Click"
                CommandArgument="2">

                <div class="card-body">
                    <h5 class="card-title">TinyDesk Web</h5>
                    <p class="card-text">Gestión de proyectos, sprints y tickets.</p>
                    <p>Estado: En progreso</p>
                    <p>Inicio: 10/06/2026</p>
                </div>

            </asp:LinkButton>
        </div>

    </div>

</asp:Content>
