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



    <asp:Panel ID="pnlDetalle" runat="server" Visible="false">
        <div class="row mb-4">
            <div class="col-12">
                <h2 class="fw-bold">Detalle del Ticket</h2>
            </div>
        </div>

        <table class="table table-bordered">
            <tr>
                <th>Descripción</th>
                <td>
                    <asp:Label ID="lblDetalleDescripcion" runat="server" /></td>
            </tr>
            <tr>
                <th>Estado</th>
                <td>
                    <asp:Label ID="lblDetalleEstado" runat="server" /></td>
            </tr>
            <tr>
                <th>Prioridad</th>
                <td>
                    <asp:Label ID="lblDetallePrioridad" runat="server" /></td>
            </tr>
            <tr>
                <th>Usuario</th>
                <td>
                    <asp:Label ID="lblDetalleUsuario" runat="server" /></td>
            </tr>
            <tr>
                <th>Sprint</th>
                <td>
                    <asp:Label ID="lblDetalleSprint" runat="server" /></td>
            </tr>
            <tr>
                <th>Proyecto</th>
                <td>
                    <asp:Label ID="lblDetalleProyecto" runat="server" /></td>
            </tr>
            <tr>
                <th>Fecha Inicio</th>
                <td>
                    <asp:Label ID="lblDetalleFechaInicio" runat="server" /></td>
            </tr>
            <tr>
                <th>Fecha Estimada Fin</th>
                <td>
                    <asp:Label ID="lblDetalleFechaEstimadaFin" runat="server" /></td>
            </tr>
            <tr>
                <th>Fecha Fin</th>
                <td>
                    <asp:Label ID="lblDetalleFechaFin" runat="server" /></td>
            </tr>
        </table>

        <div class="mb-3">
            <button type="button" class="btn btn-warning"
                data-bs-toggle="modal" data-bs-target="#modalEditarTicket">
                Editar Ticket
           
            </button>
            <a href="Tickets.aspx" class="btn btn-secondary">Volver</a>
        </div>
    </asp:Panel>

    <!-- MODAL NUEVO TICKET -->
    <div class="modal fade" id="modalNuevoTicket" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Nuevo Ticket</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="row g-3">
                        <div class="col-12">
                            <label class="form-label">Descripción</label>
                            <asp:TextBox ID="txtDescripcion" runat="server"
                                CssClass="form-control" TextMode="MultiLine" Rows="4" />
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Fecha estimada fin</label>
                            <asp:TextBox ID="txtFechaEstimadaFin" runat="server"
                                CssClass="form-control" TextMode="Date" />
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Prioridad</label>
                            <asp:DropDownList ID="ddlPrioridad" runat="server" CssClass="form-select" />
                        </div>
                        <div class="col-md-4">
                            <label class="form-label">Estado</label>
                            <asp:DropDownList ID="ddlEstado" runat="server" CssClass="form-select" />
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Usuario</label>
                            <asp:DropDownList ID="ddlUsuario" runat="server" CssClass="form-select" />
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Sprint</label>
                            <asp:DropDownList ID="ddlSprint" runat="server" CssClass="form-select" />
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <asp:Button ID="btnGuardarTicket" runat="server"
                        Text="Guardar Ticket" CssClass="btn btn-primary"
                        OnClick="btnGuardarTicket_Click" />
                </div>
            </div>
        </div>
    </div>

    <!-- MODAL EDITAR TICKET (controles necesarios para que compile) -->
    <div class="modal fade" id="modalEditarTicket" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Editar Ticket</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <asp:TextBox ID="txtEditDescripcion" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="4" />
                    <asp:TextBox ID="txtEditFechaEstimadaFin" runat="server" CssClass="form-control" TextMode="Date" />
                    <asp:DropDownList ID="ddlEditPrioridad" runat="server" CssClass="form-select" />
                    <asp:DropDownList ID="ddlEditEstado" runat="server" CssClass="form-select" />
                    <asp:DropDownList ID="ddlEditUsuario" runat="server" CssClass="form-select" />
                    <asp:DropDownList ID="ddlEditSprint" runat="server" CssClass="form-select" />
                </div>
                <div class="modal-footer">
                    <asp:Button ID="btnDesactivar" runat="server" Text="Desactivar"
                        CssClass="btn btn-danger" OnClick="btnDesactivar_Click" />
                    <asp:Button ID="btnGuardarEdicion" runat="server" Text="Guardar Cambios"
                        CssClass="btn btn-success" OnClick="btnGuardarEdicion_Click" />
                </div>
            </div>
        </div>
    </div>

</asp:Content>
