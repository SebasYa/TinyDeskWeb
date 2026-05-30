<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="TP_Final_Programacion_III._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <h1>Dashboard</h1>

    <section>
        <h2>Accesos rápidos</h2>

        <asp:Button ID="btnNuevoProyecto" runat="server" Text="Nuevo Proyecto" OnClick="btnNuevoProyecto_Click" />
        <asp:Button ID="btnNuevoSprint" runat="server" Text="Nuevo Sprint" OnClick="btnNuevoSprint_Click" />
        <asp:Button ID="btnNuevoTicket" runat="server" Text="Nuevo Ticket" OnClick="btnNuevoTicket_Click" />
    </section>

    <section class="mt-4">
        <h2 class="mb-3">Reportes</h2>
        <div class="row g-3">
            <!-- Ficha Proyectos Activos -->
            <div class="col-6 col-md-4 col-lg-3">
                <div class="card border-primary shadow-sm h-100">
                    <div class="card-body p-3 text-center">
                        <h6 class="card-subtitle mb-2 text-muted text-uppercase font-monospace small">Proyectos Activos</h6>
                        <h2 class="card-title mb-0 display-6 fw-bold text-primary">
                            <asp:Label ID="lblProyectosActivos" runat="server" Text=""></asp:Label>
                        </h2>
                    </div>
                </div>
            </div>
            <!-- Ficha Sprints en Curso -->
            <div class="col-6 col-md-4 col-lg-3">
                <div class="card border-success shadow-sm h-100">
                    <div class="card-body p-3 text-center">
                        <h6 class="card-subtitle mb-2 text-muted text-uppercase font-monospace small">Sprints en Curso</h6>
                        <h2 class="card-title mb-0 display-6 fw-bold text-success">
                            <asp:Label ID="lblSprintsEnCurso" runat="server" Text=""></asp:Label>
                        </h2>
                    </div>
                </div>
            </div>
            <!-- Ficha Tickets Abiertos -->
            <div class="col-6 col-md-4 col-lg-3">
                <div class="card border-warning shadow-sm h-100">
                    <div class="card-body p-3 text-center">
                        <h6 class="card-subtitle mb-2 text-muted text-uppercase font-monospace small">Tickets Abiertos</h6>
                        <h2 class="card-title mb-0 display-6 fw-bold text-warning">
                            <asp:Label ID="lblTicketsAbiertos" runat="server" Text=""></asp:Label>
                        </h2>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section>
        <h2>Alertas</h2>

        <div>
            No hay alerta por ahora...
        </div>
    </section>


</asp:Content>
