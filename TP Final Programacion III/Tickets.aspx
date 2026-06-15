<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Tickets.aspx.cs" Inherits="TP_Final_Programacion_III.Tickets" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <h1>Tickets</h1>

    <asp:Literal ID="litMensaje" runat="server"></asp:Literal>
    <asp:HiddenField ID="hdnIdTicket" runat="server" />

    <asp:Panel ID="pnlListado" runat="server">
        <div class="row mb-4">
            <div class="col-12">
                <h2 class="fw-bold">Tickets</h2>
            </div>
        </div>

        <asp:GridView ID="dgvTickets"
            runat="server"
            CssClass="table table-striped table-hover"
            AutoGenerateColumns="false"
            DataKeyNames="Id"
            AllowPaging="true"
            PageSize="10"
            OnPageIndexChanging="dgvTickets_PageIndexChanging"
            OnSelectedIndexChanged="dgvTickets_SelectedIndexChanged">
            <Columns>
                <asp:BoundField DataField="Id" HeaderText="ID" />
                <asp:BoundField DataField="Descripcion" HeaderText="Descripción" />
                <asp:BoundField DataField="FechaInicio" HeaderText="Fecha Inicio"
                    DataFormatString="{0:dd/MM/yyyy}" />
                <asp:CommandField ShowSelectButton="true" SelectText="Ver Detalle" />
            </Columns>
        </asp:GridView>
    </asp:Panel>

   

    <asp:Panel ID="pnlDetalle"
    runat="server"
    Visible="false">

    <div class="row mb-4">

        <div class="col-12">

            <h2 class="fw-bold">
                Detalle del Ticket
            </h2>

        </div>

    </div>

    <table class="table table-bordered">

        <tr>
            <th>Descripción</th>
            <td>
                <asp:Label ID="lblDetalleDescripcion"
                    runat="server" />
            </td>
        </tr>

        <tr>
            <th>Estado</th>
            <td>
                <asp:Label ID="lblDetalleEstado"
                    runat="server" />
            </td>
        </tr>

        <tr>
            <th>Prioridad</th>
            <td>
                <asp:Label ID="lblDetallePrioridad"
                    runat="server" />
            </td>
        </tr>

        <tr>
            <th>Usuario</th>
            <td>
                <asp:Label ID="lblDetalleUsuario"
                    runat="server" />
            </td>
        </tr>

        <tr>
            <th>Sprint</th>
            <td>
                <asp:Label ID="lblDetalleSprint"
                    runat="server" />
            </td>
        </tr>

        <tr>
            <th>Proyecto</th>
            <td>
                <asp:Label ID="lblDetalleProyecto"
                    runat="server" />
            </td>
        </tr>

        <tr>
            <th>Fecha Inicio</th>
            <td>
                <asp:Label ID="lblDetalleFechaInicio"
                    runat="server" />
            </td>
        </tr>

        <tr>
            <th>Fecha Estimada Fin</th>
            <td>
                <asp:Label ID="lblDetalleFechaEstimadaFin"
                    runat="server" />
            </td>
        </tr>

        <tr>
            <th>Fecha Fin</th>
            <td>
                <asp:Label ID="lblDetalleFechaFin"
                    runat="server" />
            </td>
        </tr>

    </table>

    <div class="mb-3">

        <button type="button"
            class="btn btn-warning"
            data-bs-toggle="modal"
            data-bs-target="#modalEditarTicket">

            Editar Ticket
        </button>

        <a href="Tickets.aspx"
            class="btn btn-secondary">

            Volver
        </a>

    </div>

</asp:Panel>

</asp:Content>
