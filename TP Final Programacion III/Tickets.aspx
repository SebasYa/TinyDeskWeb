<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Tickets.aspx.cs" Inherits="TP_Final_Programacion_III.Tickets" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <h1>Tickets</h1>
    ---------------
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

    <asp:Panel ID="pnlDetalle" runat="server" Visible="false">
    </asp:Panel>
    --------------------------


</asp:Content>
