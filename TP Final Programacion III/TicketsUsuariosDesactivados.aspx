<%@ Page Title="Reasignar tickets" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="TicketsUsuariosDesactivados.aspx.cs" Inherits="TP_Final_Programacion_III.TicketsUsuariosDesactivados" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-4">
        <asp:Literal ID="litMensajeAccion" runat="server"></asp:Literal>
        <asp:Literal ID="litMensajeEstado" runat="server"></asp:Literal>

        <div class="d-flex justify-content-between align-items-center mb-3">
            <div>
                <h4 class="mb-0">Tickets asignados a usuarios desactivados</h4>
            </div>

            <asp:Button ID="btnReasignarConIA" runat="server" CssClass="btn btn-success" Text="Reasignar con IA" OnClick="btnReasignarConIA_Click" />
        </div>

        <asp:ListView
            ID="lvTickets"
            runat="server"
            ItemPlaceholderID="itemPlaceholder"
            OnPagePropertiesChanging="lvTickets_PagePropertiesChanging">

            <LayoutTemplate>
                <table class="table table-hover align-middle bg-white border-0 shadow-sm rounded mb-0">
                    <thead class="table-light text-secondary fw-semibold border-bottom">
                        <tr>
                            <th>Ticket</th>
                            <th>Usuario desactivado</th>
                            <th>Area / Puesto</th>
                            <th>Proyecto / Sprint</th>
                            <th>Prioridad</th>
                            <th>Estado</th>
                            <th>Fechas</th>
                            <th>Reasignar</th>
                        </tr>
                    </thead>

                    <tbody>
                        <asp:PlaceHolder
                            ID="itemPlaceholder"
                            runat="server" />
                    </tbody>
                </table>
            </LayoutTemplate>

            <ItemTemplate>
                <tr>
                    <td>
                        <div class="fw-bold text-dark">
                            #<%# Eval("Id") %>
                        </div>
                    </td>

                    <td>
                        <div class="fw-semibold text-dark">
                            <%# Eval("Usuario.Nombre") %>
                            <%# Eval("Usuario.Apellido") %>
                        </div>

                        <small class="text-muted">
                            <%# Eval("Usuario.Email") %>
                        </small>
                    </td>

                    <td>
                        <span class="badge bg-secondary-subtle text-secondary rounded-pill">
                            <%# Eval("Usuario.Area.Nombre") %>
                        </span>

                        <div class="small text-muted mt-1">
                            <%# Eval("Usuario.Puesto.Nombre") %>
                            <%# Eval("Usuario.Seniority") != null
                            ? Eval("Usuario.Seniority.Nombre")
                            : "" %>
                        </div>
                    </td>

                    <td>
                        <div class="fw-semibold">
                            <%# Eval("Sprint.Proyecto.Nombre") %>
                        </div>

                        <small class="text-muted">Sprint <%# Eval("Sprint.NumeroSprint") %>
                        </small>
                    </td>

                    <td>
                        <span class='<%# GetClassPrioridad(Eval("Prioridad.Nombre")) %>'>
                            <%# Eval("Prioridad.Nombre") %>
                        </span>
                    </td>

                    <td>
                        <span class='<%# GetClassEstado(Eval("Estado.Nombre")) %>'>
                            <%# Eval("Estado.Nombre") %>
                        </span>
                    </td>

                    <td>
                        <div class="small">
                            <%# Convert.ToDateTime(Eval("FechaInicio")).ToString("dd/MM/yyyy") %>
                    -
                    <%# Convert.ToDateTime(Eval("FechaEstimadaFin")).ToString("dd/MM/yyyy") %>
                        </div>
                    </td>

                    <td>
                        <asp:LinkButton
                            ID="btnReasignarTicket"
                            runat="server"
                            CssClass="btn btn-sm btn-primary"
                            CommandArgument='<%# Eval("Id") %>'
                            CausesValidation="false"
                            OnClick="btnReasignarTicket_Click">

                    Reasignar
                        </asp:LinkButton>
                    </td>
                </tr>
            </ItemTemplate>
        </asp:ListView>

        <div class="d-flex justify-content-center mt-4">
            <asp:DataPager
                ID="dpTickets"
                runat="server"
                PagedControlID="lvTickets"
                PageSize="8">

                <Fields>
                    <asp:NextPreviousPagerField
                        ShowPreviousPageButton="true"
                        ShowNextPageButton="false"
                        PreviousPageText="Anterior"
                        ButtonCssClass="btn btn-outline-secondary me-1" />

                    <asp:NumericPagerField
                        ButtonCount="5"
                        NumericButtonCssClass="btn btn-outline-primary me-1"
                        CurrentPageLabelCssClass="btn btn-primary me-1" />

                    <asp:NextPreviousPagerField
                        ShowPreviousPageButton="false"
                        ShowNextPageButton="true"
                        NextPageText="Siguiente"
                        ButtonCssClass="btn btn-outline-secondary" />
                </Fields>
            </asp:DataPager>
        </div>

        <div class="modal fade" id="reasignarTicketModal" tabindex="-1" aria-labelledby="reasignarTicketModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header bg-light">
                        <h5 class="modal-title fw-bold" id="reasignarTicketModalLabel">
                            <asp:Label ID="lblTituloReasignar" runat="server" Text="Reasignar Ticket"></asp:Label>
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>

                    <div class="modal-body">
                        <asp:HiddenField ID="hfIdTicketReasignar" runat="server" />

                        <asp:Literal ID="litDetalleReasignacion" runat="server"></asp:Literal>

                        <div class="mt-3">
                            <label for="ddlNuevoUsuario" class="form-label fw-semibold">Nuevo usuario asignado</label>
                            <asp:DropDownList ID="ddlNuevoUsuario" runat="server" CssClass="form-select" Style="min-width: 100%;">
                            </asp:DropDownList>
                        </div>
                    </div>

                    <div class="modal-footer bg-light">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>

                        <asp:Button ID="btnConfirmarReasignacion" runat="server"
                            CssClass="btn btn-primary"
                            Text="Guardar reasignación"
                            OnClick="btnConfirmarReasignacion_Click" />
                    </div>
                </div>
            </div>
        </div>

        <div class="modal fade" id="modalReasignarConIA" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-xl">
                <div class="modal-content">
                    <div class="modal-header bg-light">
                        <h5 class="modal-title fw-bold">Reasignación con IA</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>

                    <div class="alert alert-info">
                        Se confirmarán todas las páginas. Revisa todo antes de guardar.   
                    </div>

                    <div class="modal-body">
                        <asp:UpdatePanel
                            ID="upVistaPreviaIA"
                            runat="server"
                            UpdateMode="Conditional">

                            <ContentTemplate>
                                <asp:ListView
                                    ID="lvVistaPreviaIA"
                                    runat="server"
                                    ItemPlaceholderID="itemPlaceholder"
                                    OnItemDataBound="lvVistaPreviaIA_ItemDataBound"
                                    OnPagePropertiesChanging="lvVistaPreviaIA_PagePropertiesChanging">

                                    <LayoutTemplate>
                                        <table class="table table-hover align-middle">
                                            <thead>
                                                <tr>
                                                    <th>Ticket</th>
                                                    <th>Prioridad</th>
                                                    <th>Usuario actual</th>
                                                    <th>Usuario sugerido</th>
                                                </tr>
                                            </thead>

                                            <tbody>
                                                <asp:PlaceHolder
                                                    ID="itemPlaceholder"
                                                    runat="server" />
                                            </tbody>
                                        </table>
                                    </LayoutTemplate>

                                    <ItemTemplate>
                                        <tr>
                                            <td>
                                                <asp:HiddenField
                                                    ID="hfIdTicketIA"
                                                    runat="server"
                                                    Value='<%# Eval("IdTicket") %>' />

                                                <%# Eval("IdTicket") %>
                                            </td>

                                            <td>
                                                <span class='<%# GetClassPrioridad(Eval("Prioridad")) %>'>
                                                    <%# Eval("Prioridad") %>
                                                </span>
                                            </td>

                                            <td>
                                                <div class="fw-semibold">
                                                    <%# Eval("UsuarioActual") %>
                                                </div>

                                                <small class="text-muted">
                                                    <%# Eval("Area") %> | <%# Eval("Puesto") %>
                                                </small>
                                            </td>

                                            <td>
                                                <asp:DropDownList
                                                    ID="ddlUsuarioIA"
                                                    runat="server"
                                                    CssClass="form-select ddl-usuario-ia">
                                                </asp:DropDownList>

                                                <asp:Label
                                                    ID="lblMotivoIA"
                                                    runat="server"
                                                    CssClass="small text-muted d-block mt-1 motivo-ia">
                                                </asp:Label>
                                            </td>
                                        </tr>
                                    </ItemTemplate>
                                </asp:ListView>

                                <div class="d-flex justify-content-center mt-3">
                                    <asp:DataPager
                                        ID="dpVistaPreviaIA"
                                        runat="server"
                                        PagedControlID="lvVistaPreviaIA"
                                        PageSize="7">

                                        <Fields>
                                            <asp:NextPreviousPagerField
                                                ShowPreviousPageButton="true"
                                                ShowNextPageButton="false"
                                                PreviousPageText="Anterior"
                                                ButtonCssClass="btn btn-outline-secondary me-1" />

                                            <asp:NumericPagerField
                                                ButtonCount="5"
                                                NumericButtonCssClass="btn btn-outline-primary me-1"
                                                CurrentPageLabelCssClass="btn btn-primary me-1" />

                                            <asp:NextPreviousPagerField
                                                ShowPreviousPageButton="false"
                                                ShowNextPageButton="true"
                                                NextPageText="Siguiente"
                                                ButtonCssClass="btn btn-outline-secondary" />
                                        </Fields>
                                    </asp:DataPager>
                                </div>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </div>

                    <div class="modal-footer bg-light">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>

                        <asp:Button ID="btnConfirmarReasignacionIA" runat="server"
                            CssClass="btn btn-primary"
                            Text="Confirmar reasignaciones"
                            OnClick="btnConfirmarReasignacionIA_Click" />
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
