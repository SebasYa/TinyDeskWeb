<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Proyectos.aspx.cs" Inherits="TP_Final_Programacion_III.Proyectos" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <h1>Proyectos</h1>
    <asp:Literal ID="litMensaje" runat="server"></asp:Literal>
    <div class="col-12 col-md-auto">
    <div class="d-flex flex-wrap gap-2">
        <button type="button" class="btn btn-primary shadow-sm d-flex align-items-center" data-bs-toggle="modal" data-bs-target="#proyectoModal">
            <i class="bi bi-plus-circle"></i>Nuevo Proyecto
        </button>
    </div>
</div>

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

     <!-- INICIO - CREAR PROYECTO MODAL -->
 <div class="modal fade" id="proyectoModal" tabindex="-1" aria-labelledby="proyectoModalLabel" aria-hidden="true">
     <div class="modal-dialog modal-lg">
         <div class="modal-content">
             <div class="modal-header bg-light">
                 <h5 class="modal-title fw-bold" id="proyectoModalLabel">Nuevo Proyecto</h5>
                 <!-- Botón cruz de ASP.NET -->
                 <asp:LinkButton ID="btnCloseProyecto" runat="server" CssClass="btn-close" OnClick="btnCancelarProyecto_Click" aria-label="Close"></asp:LinkButton>
             </div>
             <div class="modal-body">
                 <asp:Panel ID="pnlFormProyecto" CssClass="row g-3" runat="server">
                     <div class="col-md-12">
                         <label for="txtNombreProyecto" class="form-label fw-semibold">Nombre del Proyecto</label>
                         <asp:TextBox ID="txtNombreProyecto" runat="server" CssClass="form-control" placeholder="Ej: Rediseño Web"></asp:TextBox>
                     </div>
                     <div class="col-md-12">
                         <label for="txtDescripcionProyecto" class="form-label fw-semibold">Descripción</label>
                         <asp:TextBox ID="txtDescripcionProyecto" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" placeholder="Ingresá una descripción breve..."></asp:TextBox>
                     </div>
                     <div class="col-md-6">
                         <label for="txtFechaInicioProyecto" class="form-label fw-semibold">Fecha Inicio</label>
                         <asp:TextBox ID="txtFechaInicioProyecto" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                     </div>
                     <div class="col-md-6">
                         <label for="txtFechaEstimadaFinProyecto" class="form-label fw-semibold">Fecha Estimada Fin</label>
                         <asp:TextBox ID="txtFechaEstimadaFinProyecto" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                     </div>
                     <div class="col-md-6">
                         <label for="ddlEstadoProyecto" class="form-label fw-semibold">Estado Inicial</label>
                         <asp:DropDownList ID="ddlEstadoProyecto" runat="server" CssClass="form-select">
                             <asp:ListItem Text="Seleccione Estado..." Value="" />
                         </asp:DropDownList>
                     </div>
                 </asp:Panel>
             </div>
             <div class="modal-footer bg-light">
                 <!-- Botón Cancelar de ASP.NET -->
                 <asp:Button ID="btnCancelarProyecto" runat="server" CssClass="btn btn-secondary" Text="Cancelar" OnClick="btnCancelarProyecto_Click" UseSubmitBehavior="false" />
                 <asp:Button ID="btnGuardarProyecto" runat="server" CssClass="btn btn-primary" Text="Guardar Proyecto" OnClick="btnGuardarProyecto_Click" />
             </div>
         </div>
     </div>
 </div>
 <!-- FIN - CREAR PROYECTO MODAL -->
</asp:Content>
