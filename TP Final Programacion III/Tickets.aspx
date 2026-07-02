<%@ Page Title="Gestión de Tickets" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Tickets.aspx.cs" Inherits="TP_Final_Programacion_III.Tickets" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-4">

        <asp:Literal ID="litMensaje" runat="server"></asp:Literal>
        <asp:HiddenField ID="hdnIdTicket" runat="server" />

        <!-- ========================================= -->
        <!-- LISTADO -->
        <!-- ========================================= -->

        <asp:Panel ID="pnlListado" runat="server">

            <div class="row g-3 align-items-end mb-3">
                <div class="col-lg-4">
                    <asp:TextBox runat="server" ID="txtFiltroTickets" CssClass="form-control" placeholder="Filtrar por descripción o proyecto" AutoPostBack="true" OnTextChanged="txtFiltroTickets_TextChanged" />
                </div>

                <div class="col-lg-5">
                    <div class="d-flex flex-wrap gap-2">
                        <asp:Button ID="btnMisTickets" runat="server" Text="Mis tickets" CssClass="btn btn-outline-primary" CausesValidation="false" OnClick="btnMisTickets_Click" />
                        <asp:Button ID="btnTicketsActivos" runat="server" Text="Activos" CssClass="btn btn-outline-success" CausesValidation="false" OnClick="btnTicketsActivos_Click" />
                        <asp:Button ID="btnTicketsFinalizados" runat="server" Text="Finalizados" CssClass="btn btn-outline-secondary" CausesValidation="false" OnClick="btnTicketsFinalizados_Click" />
                    </div>
                </div>

                <div class="col-lg-3 d-flex justify-content-lg-end">
                    <button type="button" class="btn btn-primary shadow-sm d-flex align-items-center gap-2" data-bs-toggle="modal" data-bs-target="#ticketModal">
                        <i class="bi bi-plus-circle"></i>Crear Ticket
                    </button>
                </div>
            </div>

            <!-- INICIO - CREAR TICKET MODAL -->

            <div class="modal fade" id="ticketModal" tabindex="-1" aria-labelledby="ticketModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <div class="modal-header bg-light">
                            <h5 class="modal-title fw-bold" id="ticketModalLabel">Nuevo Ticket</h5>
                            <asp:LinkButton ID="btnCloseTicket" runat="server" CssClass="btn-close" OnClick="btnCancelarTicket_Click" aria-label="Close"></asp:LinkButton>
                        </div>
                        <div class="modal-body">
                            <asp:UpdatePanel ID="upTicketModal" runat="server" UpdateMode="Conditional">
                                <ContentTemplate>
                                    <asp:Panel ID="pnlFormTicket" CssClass="row g-3" runat="server">

                                        <div class="col-12">
                                            <div class="border-bottom pb-2 mb-1">
                                                <h6 class="text-uppercase text-muted fw-bold mb-0" style="font-size: .75rem;">Detalle del ticket</h6>
                                            </div>
                                        </div>

                                        <div class="col-md-12">
                                            <label for="txtDescripcionTicket" class="form-label fw-semibold">Descripción</label>
                                            <asp:TextBox ID="txtDescripcionTicket" runat="server" CssClass="form-control w-100 mw-100"
                                                TextMode="MultiLine" Rows="3" MaxLength="150"
                                                placeholder="Ingresá una descripción breve..."></asp:TextBox>
                                        </div>

                                        <div class="col-md-4">
                                            <label for="txtFechaInicioTicket" class="form-label fw-semibold">Fecha Inicio</label>
                                            <asp:TextBox ID="txtFechaInicioTicket" runat="server" CssClass="form-control" TextMode="Date" Enabled="false"></asp:TextBox>
                                        </div>

                                        <div class="col-md-4">
                                            <label for="txtFechaEstimadaTicket" class="form-label fw-semibold">Fecha Estimada Fin</label>
                                            <asp:TextBox ID="txtFechaEstimadaTicket" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                                        </div>

                                        <div class="col-md-4">
                                            <label for="ddlPrioridadTicket" class="form-label fw-semibold">Prioridad</label>
                                            <asp:DropDownList ID="ddlPrioridadTicket" runat="server" CssClass="form-select">
                                            </asp:DropDownList>
                                        </div>

                                        <div class="col-12 mt-3">
                                            <div class="border-bottom pb-2 mb-1">
                                                <h6 class="text-uppercase text-muted fw-bold mb-0" style="font-size: .75rem;">Proyecto y sprint</h6>
                                            </div>
                                        </div>

                                        <div class="col-md-6">
                                            <label for="ddlProyectoTicket" class="form-label fw-semibold">Proyecto</label>
                                            <asp:DropDownList ID="ddlProyectoTicket" runat="server" CssClass="form-select"
                                                AutoPostBack="true" OnSelectedIndexChanged="ddlProyectoTicket_SelectedIndexChanged">
                                            </asp:DropDownList>
                                        </div>

                                        <div class="col-md-6">
                                            <label for="ddlSprintTicket" class="form-label fw-semibold">Sprint</label>
                                            <asp:DropDownList ID="ddlSprintTicket" runat="server" CssClass="form-select">
                                            </asp:DropDownList>
                                        </div>

                                        <div class="col-12 mt-3">
                                            <div class="border-bottom pb-2 mb-1">
                                                <h6 class="text-uppercase text-muted fw-bold mb-0" style="font-size: .75rem;">Asignación</h6>
                                            </div>
                                        </div>

                                        <div class="col-md-4">
                                            <label for="ddlAreaTicket" class="form-label fw-semibold">Area</label>
                                            <asp:DropDownList ID="ddlAreaTicket" runat="server" CssClass="form-select"
                                                AutoPostBack="true" OnSelectedIndexChanged="ddlFiltroUsuarioTicket_SelectedIndexChanged">
                                            </asp:DropDownList>
                                        </div>

                                        <div class="col-md-4">
                                            <label for="ddlPuestoTicket" class="form-label fw-semibold">Puesto</label>
                                            <asp:DropDownList ID="ddlPuestoTicket" runat="server" CssClass="form-select"
                                                AutoPostBack="true" OnSelectedIndexChanged="ddlFiltroUsuarioTicket_SelectedIndexChanged">
                                            </asp:DropDownList>
                                        </div>

                                        <div class="col-md-4">
                                            <label for="ddlSeniorityTicket" class="form-label fw-semibold">Seniority</label>
                                            <asp:DropDownList ID="ddlSeniorityTicket" runat="server" CssClass="form-select"
                                                AutoPostBack="true" OnSelectedIndexChanged="ddlFiltroUsuarioTicket_SelectedIndexChanged">
                                            </asp:DropDownList>
                                        </div>

                                        <div class="col-md-8">
                                            <label for="ddlUsuarioTicket" class="form-label fw-semibold">Usuario</label>
                                            <asp:DropDownList ID="ddlUsuarioTicket" runat="server" CssClass="form-select"
                                                AutoPostBack="true" OnSelectedIndexChanged="ddlUsuarioTicket_SelectedIndexChanged">
                                            </asp:DropDownList>
                                        </div>

                                        <div class="col-md-4">
                                            <label for="ddlEstadoTicket" class="form-label fw-semibold">Estado</label>
                                            <asp:DropDownList ID="ddlEstadoTicket" runat="server" CssClass="form-select">
                                            </asp:DropDownList>
                                        </div>

                                    </asp:Panel>
                                </ContentTemplate>
                            </asp:UpdatePanel>
                        </div>

                        <div class="modal-footer bg-light">
                            <asp:Button ID="btnCancelarTicket" runat="server" CssClass="btn btn-secondary" Text="Cancelar" OnClick="btnCancelarTicket_Click" UseSubmitBehavior="false" />
                            <asp:Button ID="btnGuardarTicket" runat="server" CssClass="btn btn-primary"
                                Text="Guardar Ticket" OnClick="btnGuardarTicket_Click" />
                        </div>
                    </div>
                </div>
            </div>

            <!-- FIN - CREAR TICKET MODAL -->

            <!-- GRILLA -->
            <div class="table-responsive">

                <asp:ListView
                    ID="lvTickets"
                    runat="server"
                    ItemPlaceholderID="itemPlaceholder"
                    OnItemCommand="lvTickets_ItemCommand"
                    OnPagePropertiesChanging="lvTickets_PagePropertiesChanging">

                    <LayoutTemplate>
                        <table class="table table-hover align-middle bg-white border-0 shadow-sm rounded mb-0">

                            <thead class="table-light text-secondary fw-semibold border-bottom">
                                <tr>
                                    <th>Ticket</th>
                                    <th>Estado</th>
                                    <th>Prioridad</th>
                                    <th>Sprint / Proyecto</th>
                                    <th>Asignado a</th>
                                    <th>Fecha Est. Fin</th>
                                    <th>Editar</th>
                                    <th>Ver</th>
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
                                <span class="text-dark fw-bold">TK-<%# Eval("Id").ToString().PadLeft(3, '0') %>
                                </span>

                                <div class="text-muted small">
                                    <%# Eval("Descripcion") %>
                                </div>
                            </td>

                            <td>
                                <span class='<%# GetClassEtiquetaEstado(Eval("Estado.Nombre")) %>'>
                                    <%# Eval("Estado.Nombre") %>
                                </span>
                            </td>

                            <td>
                                <span class='<%# GetClassEtiquetaPrioridad(Eval("Prioridad.Nombre")) %>'>
                                    <%# Eval("Prioridad.Nombre") %>
                                </span>
                            </td>

                            <td>
                                <div class="fw-semibold text-dark">
                                    <%# Eval("Sprint.Proyecto.Nombre") %>
                                </div>

                                <span class="badge bg-secondary-subtle text-secondary rounded-pill font-monospace">Sprint <%# Eval("Sprint.NumeroSprint") %>
                                </span>
                            </td>

                            <td>
                                <div class="d-flex align-items-center">
                                    <i class="bi bi-person text-muted me-2"></i>

                                    <span class="text-dark fw-medium">
                                        <%# Eval("Usuario.Nombre") %>
                                        <%# Eval("Usuario.Apellido") %>
                                    </span>
                                </div>
                            </td>

                            <td>
                                <span class="text-muted small">
                                    <%# Eval("FechaEstimadaFin", "{0:dd/MM/yyyy}") %>
                                </span>
                            </td>

                            <td>
                                <asp:LinkButton
                                    ID="btnEditarTicket"
                                    runat="server"
                                    Visible='<%# Convert.ToBoolean(Eval("Activo")) %>'
                                    CommandName="AbrirEditar"
                                    CommandArgument='<%# Eval("Id") %>'
                                    CssClass="btn btn-link text-muted p-0 lh-1"
                                    CausesValidation="false"
                                    ToolTip="Editar Ticket">

                        <i class="bi bi-pencil text-muted"></i>
                                </asp:LinkButton>
                            </td>

                            <td>
                                <asp:LinkButton
                                    ID="btnVerTicket"
                                    runat="server"
                                    CommandName="VerDetalle"
                                    CommandArgument='<%# Eval("Id") %>'
                                    CssClass="btn btn-link text-primary p-0 lh-1"
                                    CausesValidation="false"
                                    ToolTip="Ver Ticket">

                        <i class="bi bi-eye text-primary"></i>
                                </asp:LinkButton>
                            </td>

                        </tr>
                    </ItemTemplate>

                    <EmptyDataTemplate>
                        <div class="alert alert-info">
                            No hay tickets para mostrar.
                        </div>
                    </EmptyDataTemplate>

                </asp:ListView>

            </div>

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

        </asp:Panel>
        <!-- FIN PANEL LISTADO -->

        <!-- ========================================= -->
        <!-- DETALLE -->
        <!-- ========================================= -->

        <asp:Panel ID="pnlDetalle" runat="server" Visible="false">

            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="mb-1 fw-bold text-dark">
                        <asp:Label ID="lblDetalleTituloTicket" runat="server" Text="Detalle de Ticket"></asp:Label>
                    </h2>
                    <span class="badge bg-primary-subtle text-primary px-3 py-2 rounded-pill fw-semibold">
                        <asp:Label ID="lblTicketSprintProyecto" runat="server" Text="Sprint / Proyecto"></asp:Label>
                    </span>
                </div>
                <div class="d-flex gap-2">
                    <a href="Tickets.aspx" class="btn btn-primary d-flex align-items-center gap-2">
                        <i class="bi bi-arrow-left"></i>Volver al listado
                    </a>
                </div>
            </div>

            <div class="card border-0 shadow-sm mb-5"
                style="border-radius: 12px; border: 1px solid #f0f2f5 !important;">
                <div class="card-body p-4">
                    <h5 class="fw-bold text-dark mb-4">Información del Ticket</h5>
                    <div class="row g-3">

                        <div class="col-6 col-md-3">
                            <span class="text-uppercase text-muted fw-semibold d-block"
                                style="font-size: 0.75rem; letter-spacing: 0.5px;">Descripción</span>
                            <strong class="text-dark fs-6">
                                <asp:Label ID="lblDetalleDescripcion" runat="server"></asp:Label>
                            </strong>
                        </div>

                        <div class="col-6 col-md-3">
                            <span class="text-uppercase text-muted fw-semibold d-block"
                                style="font-size: 0.75rem; letter-spacing: 0.5px;">Estado</span>
                            <asp:Label ID="lblDetalleEstado" runat="server"
                                CssClass="badge text-uppercase border px-2"></asp:Label>
                        </div>

                        <div class="col-6 col-md-3">
                            <span class="text-uppercase text-muted fw-semibold d-block"
                                style="font-size: 0.75rem; letter-spacing: 0.5px;">Prioridad</span>
                            <asp:Label ID="lblDetallePrioridad" runat="server"
                                CssClass="badge text-uppercase border px-2"></asp:Label>
                        </div>

                        <div class="col-6 col-md-3">
                            <span class="text-uppercase text-muted fw-semibold d-block"
                                style="font-size: 0.75rem; letter-spacing: 0.5px;">Asignado a</span>
                            <strong class="text-dark fs-6">
                                <asp:Label ID="lblDetalleUsuario" runat="server"></asp:Label>
                            </strong>
                        </div>

                        <div class="col-6 col-md-3">
                            <span class="text-uppercase text-muted fw-semibold d-block"
                                style="font-size: 0.75rem; letter-spacing: 0.5px;">Fecha Inicio</span>
                            <strong class="text-dark fs-6">
                                <asp:Label ID="lblDetalleFechaInicio" runat="server"></asp:Label>
                            </strong>
                        </div>

                        <div class="col-6 col-md-3">
                            <span class="text-uppercase text-muted fw-semibold d-block"
                                style="font-size: 0.75rem; letter-spacing: 0.5px;">Fecha Estimada Fin</span>
                            <strong class="text-dark fs-6">
                                <asp:Label ID="lblDetalleFechaEstimadaFin" runat="server"></asp:Label>
                            </strong>
                        </div>

                        <div class="col-6 col-md-3">
                            <span class="text-uppercase text-muted fw-semibold d-block"
                                style="font-size: 0.75rem; letter-spacing: 0.5px;">Fecha Fin Real</span>
                            <strong class="text-dark fs-6">
                                <asp:Label ID="lblDetalleFechaFin" runat="server" Text="-"></asp:Label>
                            </strong>
                        </div>

                        <div class="col-6 col-md-3">
                            <span class="text-uppercase text-muted fw-semibold d-block"
                                style="font-size: 0.75rem; letter-spacing: 0.5px;">Sprint</span>
                            <strong class="text-dark fs-6">
                                <asp:Label ID="lblDetalleSprint" runat="server"></asp:Label>
                            </strong>
                        </div>

                        <div class="col-6 col-md-3">
                            <span class="text-uppercase text-muted fw-semibold d-block"
                                style="font-size: 0.75rem; letter-spacing: 0.5px;">Proyecto</span>
                            <strong class="text-dark fs-6">
                                <asp:Label ID="lblDetalleProyecto" runat="server"></asp:Label>
                            </strong>
                        </div>

                    </div>

                    <div class="mt-4">
                        <button type="button" class="btn btn-warning d-flex align-items-center gap-2"
                            data-bs-toggle="modal" data-bs-target="#ticketEditarModal">
                            <i class="bi bi-pencil"></i>Editar Ticket
                        </button>
                    </div>

                </div>
            </div>

        </asp:Panel>
        <!-- FIN PANEL DETALLE -->

        <!-- ========================================= -->
        <!-- MODAL EDITAR TICKET (fuera de los paneles) -->
        <!-- ========================================= -->
        <div class="modal fade" id="ticketEditarModal" tabindex="-1"
            aria-labelledby="ticketEditarModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header bg-light">
                        <h5 class="modal-title fw-bold" id="ticketEditarModalLabel">
                            <asp:Label ID="lblModalEditarTitulo" runat="server" Text="Editar Ticket"></asp:Label>
                        </h5>
                        <button type="button" class="btn-close"
                            data-bs-dismiss="modal" aria-label="Close">
                        </button>
                    </div>
                    <div class="modal-body">
                        <div class="row g-3">

                            <div class="col-12">
                                <label class="form-label fw-semibold">Descripción</label>
                                <asp:TextBox ID="txtEditDescripcion" runat="server"
                                    CssClass="form-control"
                                    TextMode="MultiLine" Rows="3" />
                                <div class="invalid-feedback">La descripción es obligatoria.</div>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Fecha Estimada Fin</label>
                                <asp:TextBox ID="txtEditFechaEstimadaFin" runat="server"
                                    CssClass="form-control" TextMode="Date" />
                                <div class="invalid-feedback">La fecha estimada de fin es obligatoria.</div>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Prioridad</label>
                                <asp:DropDownList ID="ddlEditPrioridad" runat="server" CssClass="form-select">
                                    <asp:ListItem Text="Seleccione Prioridad..." Value="" />
                                </asp:DropDownList>
                                <div class="invalid-feedback">Debes elegir una Prioridad.</div>
                            </div>

                            <div class="col-md-4">
                                <label class="form-label fw-semibold">Estado</label>
                                <asp:DropDownList ID="ddlEditEstado" runat="server" CssClass="form-select">
                                    <asp:ListItem Text="Seleccione Estado..." Value="" />
                                </asp:DropDownList>
                                <div class="invalid-feedback">Debes elegir un Estado.</div>
                            </div>

                            <div class="col-md-4">
                                <label class="form-label fw-semibold">Usuario</label>
                                <asp:DropDownList ID="ddlEditUsuario" runat="server" CssClass="form-select">
                                    <asp:ListItem Text="Seleccione Usuario..." Value="" />
                                </asp:DropDownList>
                                <div class="invalid-feedback">Debes elegir un Usuario.</div>
                            </div>

                            <div class="col-md-4">
                                <label class="form-label fw-semibold">Sprint</label>
                                <asp:DropDownList ID="ddlEditSprint" runat="server" CssClass="form-select">
                                    <asp:ListItem Text="Seleccione Sprint..." Value="" />
                                </asp:DropDownList>
                                <div class="invalid-feedback">Debes elegir un Sprint.</div>
                            </div>
                            <div class="col-12 position-relative">
                                <label for="txtMotivoCambio" class="form-label fw-semibold">Motivo del cambio</label>

                                <asp:TextBox ID="txtMotivoCambio" runat="server"
                                    CssClass="form-control w-100"
                                    TextMode="MultiLine" Rows="2"
                                    placeholder="Explique por qué realiza esta modificación...">
                                </asp:TextBox>

                                <div class="invalid-feedback">
                                    Por favor, ingrese un motivo para realizar el cambio.
                                </div>
                            </div>

                        </div>
                    </div>
                    <div class="modal-footer bg-light">
                        <button type="button" class="btn btn-secondary"
                            data-bs-dismiss="modal">
                            Cancelar</button>
                        <asp:Button ID="btnBajaLogica" runat="server"
                            CssClass="btn btn-danger"
                            Text="Desactivar Ticket"
                            OnClick="btnBajaLogica_Click" />
                        <asp:Button ID="btnGuardarEdicion" runat="server"
                            CssClass="btn btn-primary"
                            Text="Guardar Cambios"
                            OnClientClick="return validarSprintModal();"
                            OnClick="btnGuardarEdicion_Click" />
                    </div>
                </div>
            </div>
        </div>
        <!-- FIN MODAL EDITAR -->

    </div>

</asp:Content>
