<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="TP_Final_Programacion_III._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <h1>Dashboard</h1>

    <section>
        <h2>Accesos rápidos</h2>

        <asp:Button ID="btnNuevoProyecto" runat="server" Text="Nuevo Proyecto" OnClick="btnNuevoProyecto_Click" />
        <asp:Button ID="btnNuevoSprint" runat="server" Text="Nuevo Sprint" OnClick="btnNuevoSprint_Click" />
        <asp:Button ID="btnNuevoTicket" runat="server" Text="Nuevo Ticket" OnClick="btnNuevoTicket_Click" />
    </section>

    <section>
        <h2>Reportes</h2>

        <div>
            <h3>Proyectos Activos</h3>
            <p>0</p>
        </div>

        <div>
             <h3>Sprints en curso</h3>
             <p>0</p>
        </div>

        <div>
            <h3>Tickets abiertos</h3>
            <p>0</p>
       </div>
    </section>

    <section>
        <h2>Alertas</h2>

        <div>
            No hay alerta por ahora...
        </div>
    </section>


</asp:Content>
