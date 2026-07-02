<%@ Page Title="Gestión de Tickets" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Tickets.aspx.cs" Inherits="TP_Final_Programacion_III.Tickets" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container-fluid admin-tickets-workspace px-0 pt-2">

        <asp:Literal ID="litMensaje" runat="server"></asp:Literal>
        <asp:HiddenField ID="hdnIdTicket" runat="server" />

        <!-- ========================================= -->
        <!-- LISTADO -->
        <!-- ========================================= -->

        <asp:Panel ID="pnlListado" runat="server" CssClass="admin-ticket-list-view">

            <div class="admin-ticket-heading d-flex justify-content-between align-items-start flex-wrap gap-4 mb-4">
                <div class="admin-ticket-heading-copy">
                    <span class="admin-ticket-eyebrow"><i class="bi bi-ticket-perforated"></i>Gestión operativa</span>
                    <h1 class="h2 fw-bold mb-2">Tickets</h1>
                    <p class="mb-0">Administrá solicitudes, responsables, prioridades y vencimientos desde una única bandeja.</p>
                </div>
                <div class="admin-ticket-heading-actions d-flex align-items-center flex-wrap gap-3">
                    <div class="admin-ticket-context-chip"><i class="bi bi-inboxes"></i><span><strong>Bandeja central</strong><small>Seguimiento del equipo</small></span></div>
                    <button type="button" class="btn admin-ticket-primary-action d-flex align-items-center gap-2" data-bs-toggle="modal" data-bs-target="#ticketModal">
                        <i class="bi bi-plus-circle"></i>Crear ticket
                    </button>
                </div>
            </div>

            <div class="admin-ticket-toolbar row g-3 align-items-end mb-4">
                <div class="col-12 col-xl-5">
                    <label for="txtFiltroTickets" class="form-label fw-semibold">Buscar tickets</label>
                    <div class="input-group admin-ticket-search">
                        <span class="input-group-text"><i class="bi bi-search"></i></span>
                        <asp:TextBox runat="server" ID="txtFiltroTickets" CssClass="form-control" placeholder="Descripción o proyecto..." AutoPostBack="true" OnTextChanged="txtFiltroTickets_TextChanged" />
                    </div>
                </div>

                <div class="col-12 col-xl-7">
                    <label class="form-label fw-semibold">Vista rápida</label>
                    <div class="admin-ticket-toggle d-flex flex-wrap gap-2">
                        <asp:Button ID="btnMisTickets" runat="server" Text="Mis tickets" CssClass="btn btn-outline-primary" CausesValidation="false" OnClick="btnMisTickets_Click" />
                        <asp:Button ID="btnTicketsActivos" runat="server" Text="Activos" CssClass="btn btn-outline-success" CausesValidation="false" OnClick="btnTicketsActivos_Click" />
                        <asp:Button ID="btnTicketsFinalizados" runat="server" Text="Finalizados" CssClass="btn btn-outline-secondary" CausesValidation="false" OnClick="btnTicketsFinalizados_Click" />
                    </div>
                </div>
            </div>

            <!-- INICIO - CREAR TICKET MODAL -->

            <div class="modal fade" id="ticketModal" tabindex="-1" aria-labelledby="ticketModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
                    <div class="modal-content admin-ticket-modal-content">
                        <div class="modal-header admin-ticket-modal-header">
                            <span class="admin-ticket-modal-icon"><i class="bi bi-ticket-detailed"></i></span>
                            <div class="me-auto"><span class="admin-ticket-modal-kicker">Nueva solicitud</span><h5 class="modal-title fw-bold mb-0" id="ticketModalLabel">Crear ticket</h5>
                            </div>
                            <asp:LinkButton ID="btnCloseTicket" runat="server" CssClass="btn-close" OnClick="btnCancelarTicket_Click" aria-label="Cerrar"></asp:LinkButton>
                        </div>
                        <div class="modal-body p-4">
                            <div class="admin-ticket-modal-note mb-4"><i class="bi bi-info-circle"></i><span>Completá el contexto y elegí la persona responsable antes de guardar.</span></div>
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

                        <div class="modal-footer admin-ticket-modal-footer">
                            <asp:Button ID="btnCancelarTicket" runat="server" CssClass="btn btn-outline-secondary" Text="Cancelar" OnClick="btnCancelarTicket_Click" UseSubmitBehavior="false" />
                            <asp:Button ID="btnGuardarTicket" runat="server" CssClass="btn admin-ticket-save-button"
                                Text="Guardar Ticket" OnClick="btnGuardarTicket_Click" />
                        </div>
                    </div>
                </div>
            </div>

            <!-- FIN - CREAR TICKET MODAL -->

            <!-- GRILLA -->
            <div class="admin-ticket-list-heading d-flex justify-content-between align-items-end flex-wrap gap-3 mb-3">
                <div><span class="admin-ticket-section-label">Bandeja de trabajo</span><h2 class="h5 fw-bold mb-1">Listado de tickets</h2>
                    <p class="mb-0">Estado, prioridad, asignación y fecha estimada en una sola vista.</p>
                </div>
                <span class="admin-ticket-list-hint"><i class="bi bi-layout-text-window-reverse"></i>Detalle y edición rápida</span>
            </div>
            <div class="admin-ticket-table-card table-responsive">

                <asp:ListView
                    ID="lvTickets"
                    runat="server"
                    ItemPlaceholderID="itemPlaceholder"
                    OnItemCommand="lvTickets_ItemCommand"
                    OnPagePropertiesChanging="lvTickets_PagePropertiesChanging">

                    <LayoutTemplate>
                        <table class="table admin-ticket-table table-hover align-middle mb-0">

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
                        <tr data-admin-ticket-row="true">

                            <td class="admin-ticket-code-cell">
                                <span class="text-dark fw-bold">TK-<%# Eval("Id").ToString().PadLeft(3, '0') %>
                                </span>

                                <div class="text-muted small">
                                    <%# Eval("Descripcion") %>
                                </div>
                            </td>

                            <td class="admin-ticket-status-cell">
                                <span class='<%# GetClassEtiquetaEstado(Eval("Estado.Nombre")) %>'>
                                    <%# Eval("Estado.Nombre") %>
                                </span>
                            </td>

                            <td class="admin-ticket-priority-cell">
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
                                    CssClass="btn btn-sm admin-ticket-action action-edit"
                                    CausesValidation="false"
                                    ToolTip="Editar Ticket">

                        <i class="bi bi-pencil"></i>
                                </asp:LinkButton>
                            </td>

                            <td>
                                <asp:LinkButton
                                    ID="btnVerTicket"
                                    runat="server"
                                    CommandName="VerDetalle"
                                    CommandArgument='<%# Eval("Id") %>'
                                    CssClass="btn btn-sm admin-ticket-action action-view"
                                    CausesValidation="false"
                                    ToolTip="Ver Ticket">

                        <i class="bi bi-eye"></i>
                                </asp:LinkButton>
                            </td>

                        </tr>
                    </ItemTemplate>

                    <EmptyDataTemplate>
                        <div class="admin-ticket-empty-state"><i class="bi bi-ticket-detailed"></i><strong>No hay tickets para mostrar</strong><span>Probá cambiando la búsqueda o los filtros seleccionados.</span></div>
                    </EmptyDataTemplate>

                </asp:ListView>

            </div>

            <div class="admin-ticket-pagination d-flex justify-content-center mt-4">

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

        <asp:Panel ID="pnlDetalle" runat="server" Visible="false" CssClass="admin-ticket-detail-view">

            <div class="admin-ticket-detail-heading d-flex justify-content-between align-items-center flex-wrap gap-3 mb-4">
                <div>
                    <h2 class="mb-1 fw-bold text-dark">
                        <asp:Label ID="lblDetalleTituloTicket" runat="server" Text="Detalle de Ticket"></asp:Label>
                    </h2>
                    <span class="badge bg-primary-subtle text-primary px-3 py-2 rounded-pill fw-semibold">
                        <asp:Label ID="lblTicketSprintProyecto" runat="server" Text="Sprint / Proyecto"></asp:Label>
                    </span>
                </div>
                <div class="d-flex gap-2">
                    <a href="Tickets.aspx" class="btn admin-ticket-back-button d-flex align-items-center gap-2">
                        <i class="bi bi-arrow-left"></i>Volver al listado
                    </a>
                </div>
            </div>

            <div class="card admin-ticket-detail-card border-0 mb-5">
                <div class="card-body p-4">
                    <h5 class="fw-bold text-dark mb-4">Información del Ticket</h5>
                    <div class="row g-3">

                        <div class="col-12 col-md-6 admin-ticket-detail-field admin-ticket-description-field">
                            <span class="text-uppercase text-muted fw-semibold d-block"
                                style="font-size: 0.75rem; letter-spacing: 0.5px;">Descripción</span>
                            <strong class="text-dark fs-6">
                                <asp:Label ID="lblDetalleDescripcion" runat="server"></asp:Label>
                            </strong>
                        </div>

                        <div class="col-6 col-md-3 admin-ticket-detail-field admin-ticket-detail-status">
                            <span class="text-uppercase text-muted fw-semibold d-block"
                                style="font-size: 0.75rem; letter-spacing: 0.5px;">Estado</span>
                            <asp:Label ID="lblDetalleEstado" runat="server"
                                CssClass="badge text-uppercase border px-2"></asp:Label>
                        </div>

                        <div class="col-6 col-md-3 admin-ticket-detail-field admin-ticket-detail-priority">
                            <span class="text-uppercase text-muted fw-semibold d-block"
                                style="font-size: 0.75rem; letter-spacing: 0.5px;">Prioridad</span>
                            <asp:Label ID="lblDetallePrioridad" runat="server"
                                CssClass="badge text-uppercase border px-2"></asp:Label>
                        </div>

                        <div class="col-6 col-md-3 admin-ticket-detail-field">
                            <span class="text-uppercase text-muted fw-semibold d-block"
                                style="font-size: 0.75rem; letter-spacing: 0.5px;">Asignado a</span>
                            <strong class="text-dark fs-6">
                                <asp:Label ID="lblDetalleUsuario" runat="server"></asp:Label>
                            </strong>
                        </div>

                        <div class="col-6 col-md-3 admin-ticket-detail-field">
                            <span class="text-uppercase text-muted fw-semibold d-block"
                                style="font-size: 0.75rem; letter-spacing: 0.5px;">Fecha Inicio</span>
                            <strong class="text-dark fs-6">
                                <asp:Label ID="lblDetalleFechaInicio" runat="server"></asp:Label>
                            </strong>
                        </div>

                        <div class="col-6 col-md-3 admin-ticket-detail-field">
                            <span class="text-uppercase text-muted fw-semibold d-block"
                                style="font-size: 0.75rem; letter-spacing: 0.5px;">Fecha Estimada Fin</span>
                            <strong class="text-dark fs-6">
                                <asp:Label ID="lblDetalleFechaEstimadaFin" runat="server"></asp:Label>
                            </strong>
                        </div>

                        <div class="col-6 col-md-3 admin-ticket-detail-field">
                            <span class="text-uppercase text-muted fw-semibold d-block"
                                style="font-size: 0.75rem; letter-spacing: 0.5px;">Fecha Fin Real</span>
                            <strong class="text-dark fs-6">
                                <asp:Label ID="lblDetalleFechaFin" runat="server" Text="-"></asp:Label>
                            </strong>
                        </div>

                        <div class="col-6 col-md-3 admin-ticket-detail-field">
                            <span class="text-uppercase text-muted fw-semibold d-block"
                                style="font-size: 0.75rem; letter-spacing: 0.5px;">Sprint</span>
                            <strong class="text-dark fs-6">
                                <asp:Label ID="lblDetalleSprint" runat="server"></asp:Label>
                            </strong>
                        </div>

                        <div class="col-6 col-md-3 admin-ticket-detail-field">
                            <span class="text-uppercase text-muted fw-semibold d-block"
                                style="font-size: 0.75rem; letter-spacing: 0.5px;">Proyecto</span>
                            <strong class="text-dark fs-6">
                                <asp:Label ID="lblDetalleProyecto" runat="server"></asp:Label>
                            </strong>
                        </div>

                    </div>

                    <div class="mt-4">
                        <button type="button" class="btn admin-ticket-edit-detail d-flex align-items-center gap-2"
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
            <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
                <div class="modal-content admin-ticket-modal-content">
                    <div class="modal-header admin-ticket-modal-header">
                        <span class="admin-ticket-modal-icon"><i class="bi bi-pencil-square"></i></span>
                        <h5 class="modal-title fw-bold me-auto" id="ticketEditarModalLabel">
                            <asp:Label ID="lblModalEditarTitulo" runat="server" Text="Editar Ticket"></asp:Label>
                        </h5>
                        <button type="button" class="btn-close"
                            data-bs-dismiss="modal" aria-label="Cerrar">
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
                    <div class="modal-footer admin-ticket-modal-footer">
                        <button type="button" class="btn btn-outline-secondary"
                            data-bs-dismiss="modal">
                            Cancelar</button>
                        <asp:Button ID="btnBajaLogica" runat="server"
                            CssClass="btn btn-danger"
                            Text="Desactivar Ticket"
                            OnClick="btnBajaLogica_Click" />
                        <asp:Button ID="btnGuardarEdicion" runat="server"
                            CssClass="btn admin-ticket-save-button"
                            Text="Guardar Cambios"
                            OnClientClick="return validarSprintModal();"
                            OnClick="btnGuardarEdicion_Click" />
                    </div>
                </div>
            </div>
        </div>
        <!-- FIN MODAL EDITAR -->

    </div>

    <style>
        :root {
            --admin-ticket-sky: #93c0de;
            --admin-ticket-aqua: #b9e5e5;
            --admin-ticket-ink: #09232f;
            --admin-ticket-muted: #75797e;
            --admin-ticket-violet: #65479b;
            --admin-ticket-violet-soft: #eee7fa;
            --admin-ticket-violet-line: #cbbbe8;
            --admin-ticket-line: rgba(9, 35, 47, .1);
            --admin-ticket-shadow: 0 18px 44px rgba(9, 35, 47, .075);
        }

        .app-main.admin-tickets-surface {
            background: radial-gradient(circle at 93% 2%, rgba(147, 192, 222, .24), transparent 25rem), radial-gradient(circle at 10% 90%, rgba(185, 229, 229, .2), transparent 28rem), linear-gradient(180deg, #f8fafb 0%, #f2f7f8 100%);
        }

        .admin-tickets-workspace {
            width: 100%;
            max-width: 1580px;
            margin-inline: auto;
            color: var(--admin-ticket-ink);
        }

            .admin-tickets-workspace > .alert {
                border-radius: .9rem;
                box-shadow: 0 10px 24px rgba(9, 35, 47, .05);
            }

        .admin-ticket-heading,
        .admin-ticket-detail-heading {
            position: relative;
            overflow: hidden;
            padding: clamp(1.4rem, 2.5vw, 2.1rem);
            border: 1px solid rgba(147, 192, 222, .4);
            border-radius: 1.35rem;
            background: linear-gradient(112deg, rgba(255, 255, 255, .96), rgba(244, 251, 252, .88));
            box-shadow: 0 15px 38px rgba(9, 35, 47, .055);
            isolation: isolate;
        }

            .admin-ticket-heading::after,
            .admin-ticket-detail-heading::after {
                content: "";
                position: absolute;
                z-index: -1;
                width: 16rem;
                aspect-ratio: 1;
                top: -8.5rem;
                right: -5rem;
                border: 2.8rem solid rgba(185, 229, 229, .31);
                border-radius: 50%;
            }

        .admin-ticket-heading-copy {
            max-width: 50rem;
        }

            .admin-ticket-heading-copy h1,
            .admin-ticket-list-heading h2,
            .admin-ticket-detail-heading h2,
            .admin-tickets-workspace h5 {
                color: var(--admin-ticket-ink) !important;
                letter-spacing: -.025em;
            }

            .admin-ticket-heading-copy p,
            .admin-ticket-list-heading p {
                color: var(--admin-ticket-muted);
            }

        .admin-ticket-eyebrow,
        .admin-ticket-section-label,
        .admin-ticket-modal-kicker {
            display: inline-flex;
            align-items: center;
            gap: .45rem;
            margin-bottom: .55rem;
            color: #315f76;
            font-size: .7rem;
            font-weight: 850;
            letter-spacing: .1em;
            text-transform: uppercase;
        }

        .admin-ticket-heading-actions {
            position: relative;
            z-index: 1;
        }

        .admin-ticket-context-chip {
            display: flex;
            align-items: center;
            gap: .7rem;
            padding: .65rem .78rem;
            border: 1px solid rgba(147, 192, 222, .42);
            border-radius: .9rem;
            background: rgba(255, 255, 255, .78);
        }

            .admin-ticket-context-chip > i {
                display: grid;
                place-items: center;
                width: 2.35rem;
                height: 2.35rem;
                border-radius: .7rem;
                background: linear-gradient(145deg, rgba(147, 192, 222, .28), rgba(185, 229, 229, .4));
                color: #315f76;
                font-size: 1rem;
            }

            .admin-ticket-context-chip span {
                display: flex;
                flex-direction: column;
                line-height: 1.2;
            }

            .admin-ticket-context-chip strong {
                font-size: .8rem;
            }

            .admin-ticket-context-chip small {
                margin-top: .18rem;
                color: var(--admin-ticket-muted);
                font-size: .68rem;
            }

        .admin-ticket-primary-action,
        .admin-ticket-save-button {
            min-height: 44px;
            border: 1px solid var(--admin-ticket-ink) !important;
            border-radius: .75rem;
            background: var(--admin-ticket-ink) !important;
            color: #fff !important;
            font-weight: 700;
            box-shadow: 0 9px 20px rgba(9, 35, 47, .14);
        }

            .admin-ticket-primary-action:hover,
            .admin-ticket-save-button:hover {
                border-color: #17485d !important;
                background: #17485d !important;
                color: #fff !important;
                transform: translateY(-1px);
            }

        .admin-ticket-toolbar,
        .admin-ticket-detail-card,
        .admin-ticket-table-card {
            border: 1px solid rgba(9, 35, 47, .08) !important;
            border-radius: 1.2rem;
            background: rgba(255, 255, 255, .86);
            box-shadow: var(--admin-ticket-shadow);
            backdrop-filter: blur(12px);
        }

        .admin-ticket-toolbar {
            margin-inline: 0;
            padding: 1rem;
        }

            .admin-ticket-toolbar .form-label {
                margin-bottom: .5rem;
                color: #39515c;
                font-size: .76rem;
            }

        .admin-ticket-search .input-group-text,
        .admin-ticket-search .form-control,
        .admin-ticket-modal-content .form-control,
        .admin-ticket-modal-content .form-select {
            min-height: 44px;
            border-color: rgba(9, 35, 47, .14);
            background-color: rgba(255, 255, 255, .94);
        }

        .admin-ticket-search .input-group-text {
            border-right: 0;
            border-radius: .75rem 0 0 .75rem;
            color: #67808c;
        }

        .admin-ticket-search .form-control {
            border-left: 0;
            border-radius: 0 .75rem .75rem 0;
        }

        .admin-ticket-search:focus-within {
            border-radius: .76rem;
            box-shadow: 0 0 0 .22rem rgba(147, 192, 222, .2);
        }

            .admin-ticket-search:focus-within .input-group-text,
            .admin-ticket-search:focus-within .form-control {
                border-color: #75a9c9;
                box-shadow: none;
            }

        .admin-ticket-toggle {
            padding: .28rem;
            border: 1px solid var(--admin-ticket-line);
            border-radius: .9rem;
            background: #edf3f4;
        }

            .admin-ticket-toggle .btn {
                flex: 1 1 8rem;
                min-height: 40px;
                border-color: transparent !important;
                border-radius: .68rem !important;
                font-weight: 700;
                box-shadow: none !important;
            }

            .admin-ticket-toggle .btn-primary,
            .admin-ticket-toggle .btn-success {
                background: var(--admin-ticket-ink) !important;
                color: #fff !important;
            }

            .admin-ticket-toggle .btn-secondary {
                background: var(--admin-ticket-violet) !important;
                color: var(--admin-ticket-violet-soft) !important;
            }

            .admin-ticket-toggle .btn-outline-primary,
            .admin-ticket-toggle .btn-outline-success,
            .admin-ticket-toggle .btn-outline-secondary {
                background: transparent;
                color: #64747b;
            }

                .admin-ticket-toggle .btn-outline-primary:hover,
                .admin-ticket-toggle .btn-outline-success:hover {
                    background: rgba(185, 229, 229, .35);
                    color: var(--admin-ticket-ink);
                }

                .admin-ticket-toggle .btn-outline-secondary:hover {
                    background: rgba(203, 187, 232, .3);
                    color: var(--admin-ticket-violet);
                }

        .admin-ticket-list-heading {
            padding-inline: .2rem;
        }

            .admin-ticket-list-heading p {
                font-size: .84rem;
            }

        .admin-ticket-list-hint {
            display: inline-flex;
            align-items: center;
            gap: .45rem;
            padding: .46rem .72rem;
            border: 1px solid rgba(147, 192, 222, .42);
            border-radius: 999px;
            background: rgba(255, 255, 255, .72);
            color: #476878;
            font-size: .72rem;
            font-weight: 750;
        }

        .admin-ticket-table-card {
            overflow: hidden;
        }

        .admin-ticket-table {
            min-width: 1100px;
        }

            .admin-ticket-table thead th {
                padding: .9rem 1rem;
                border-bottom-color: rgba(9, 35, 47, .1);
                background: #eaf1f3;
                color: #526873;
                font-size: .68rem;
                font-weight: 850;
                letter-spacing: .06em;
                text-transform: uppercase;
                white-space: nowrap;
            }

            .admin-ticket-table tbody td {
                padding: 1rem;
                border-color: rgba(9, 35, 47, .07);
                color: #52646c;
                font-size: .83rem;
                vertical-align: middle;
            }

            .admin-ticket-table tbody tr {
                transition: background-color .18s ease, opacity .35s ease, transform .35s ease;
            }

                .admin-ticket-table tbody tr:hover {
                    background: rgba(185, 229, 229, .15);
                }

        .admin-tickets-js [data-admin-ticket-row] {
            opacity: 0;
            transform: translateY(6px);
        }

            .admin-tickets-js [data-admin-ticket-row].is-visible {
                opacity: 1;
                transform: none;
            }

        .admin-ticket-code-cell > span {
            color: var(--admin-ticket-ink) !important;
            letter-spacing: .02em;
        }

        .admin-ticket-code-cell > div {
            display: -webkit-box;
            overflow: hidden;
            max-width: 280px;
            margin-top: .25rem;
            line-height: 1.4;
            -webkit-box-orient: vertical;
            -webkit-line-clamp: 2;
        }

        .admin-ticket-table .badge,
        .admin-ticket-detail-card .badge {
            border: 1px solid transparent;
            border-radius: 999px;
            font-size: .68rem;
            font-weight: 800;
        }

        .admin-ticket-status-cell .text-bg-primary,
        .admin-ticket-detail-status .text-bg-primary {
            border-color: rgba(45, 132, 95, .18) !important;
            background: rgba(76, 175, 125, .14) !important;
            color: #237a55 !important;
        }

        .admin-ticket-status-cell .text-bg-success,
        .admin-ticket-detail-status .text-bg-success,
        .admin-tickets-workspace .status-final {
            border-color: var(--admin-ticket-violet-line) !important;
            background: var(--admin-ticket-violet) !important;
            color: var(--admin-ticket-violet-soft) !important;
        }

        .admin-ticket-status-cell .text-bg-warning,
        .admin-ticket-detail-status .text-bg-warning {
            border-color: rgba(177, 137, 36, .18) !important;
            background: rgba(216, 184, 91, .17) !important;
            color: #80651d !important;
        }

        .admin-ticket-status-cell .text-bg-dark {
            border-color: rgba(49, 95, 118, .16) !important;
            background: rgba(147, 192, 222, .2) !important;
            color: #315f76 !important;
        }

        .admin-ticket-priority-cell .text-bg-danger,
        .admin-ticket-detail-priority .text-bg-danger {
            border-color: rgba(184, 64, 77, .17) !important;
            background: rgba(224, 91, 105, .13) !important;
            color: #a23d49 !important;
        }

        .admin-ticket-priority-cell .text-bg-warning,
        .admin-ticket-detail-priority .text-bg-warning {
            border-color: rgba(177, 137, 36, .18) !important;
            background: rgba(216, 184, 91, .17) !important;
            color: #80651d !important;
        }

        .admin-ticket-priority-cell .text-bg-success,
        .admin-ticket-detail-priority .text-bg-success {
            border-color: rgba(45, 132, 95, .18) !important;
            background: rgba(76, 175, 125, .14) !important;
            color: #237a55 !important;
        }

        .admin-ticket-action {
            display: inline-grid;
            place-items: center;
            width: 2.25rem;
            height: 2.25rem;
            padding: 0;
            border: 1px solid rgba(49, 95, 118, .18);
            border-radius: .65rem;
            background: #f5f9fa;
            color: #476878;
        }

            .admin-ticket-action:hover {
                border-color: var(--admin-ticket-ink);
                background: var(--admin-ticket-ink);
                color: #fff;
            }

        .admin-ticket-empty-state {
            display: flex;
            min-height: 14rem;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            gap: .3rem;
            padding: 2rem;
            color: var(--admin-ticket-muted);
            text-align: center;
        }

            .admin-ticket-empty-state i {
                margin-bottom: .35rem;
                color: #5f91a9;
                font-size: 2rem;
            }

            .admin-ticket-empty-state strong {
                color: var(--admin-ticket-ink);
            }

            .admin-ticket-empty-state span {
                font-size: .82rem;
            }

        .admin-ticket-pagination .btn {
            border-radius: .65rem;
            font-weight: 650;
        }

        .admin-ticket-pagination .btn-primary {
            border-color: var(--admin-ticket-ink);
            background: var(--admin-ticket-ink);
            color: #fff;
        }

        .admin-ticket-back-button {
            border: 1px solid rgba(49, 95, 118, .3);
            border-radius: .72rem;
            background: rgba(255, 255, 255, .72);
            color: #315f76;
            font-weight: 700;
        }

            .admin-ticket-back-button:hover {
                border-color: var(--admin-ticket-ink);
                background: var(--admin-ticket-ink);
                color: #fff;
            }

        .admin-ticket-detail-card {
            overflow: hidden;
        }

        .admin-ticket-detail-field {
            position: relative;
            min-height: 92px;
            padding: 1rem 1.1rem;
        }

            .admin-ticket-detail-field::before {
                content: "";
                position: absolute;
                inset: .25rem;
                z-index: -1;
                border: 1px solid rgba(9, 35, 47, .08);
                border-radius: .82rem;
                background: linear-gradient(145deg, #fff, #f2f7f8);
            }

        .admin-ticket-description-field strong {
            display: -webkit-box;
            overflow: hidden;
            line-height: 1.5;
            -webkit-box-orient: vertical;
            -webkit-line-clamp: 3;
        }

        .admin-ticket-edit-detail {
            border: 1px solid rgba(49, 95, 118, .28);
            border-radius: .72rem;
            background: rgba(147, 192, 222, .15);
            color: #315f76;
            font-weight: 700;
        }

            .admin-ticket-edit-detail:hover {
                border-color: var(--admin-ticket-ink);
                background: var(--admin-ticket-ink);
                color: #fff;
            }

        .admin-ticket-modal-content {
            overflow: hidden;
            border: 1px solid rgba(9, 35, 47, .1);
            border-radius: 1.2rem;
            box-shadow: 0 30px 90px rgba(9, 35, 47, .24);
        }

        .admin-ticket-modal-header {
            padding: 1.1rem 1.25rem;
            border-bottom: 1px solid rgba(9, 35, 47, .08);
            background: linear-gradient(105deg, #f8fbfc, #edf6f7);
        }

        .admin-ticket-modal-icon {
            display: grid;
            flex: 0 0 auto;
            place-items: center;
            width: 2.65rem;
            height: 2.65rem;
            border-radius: .8rem;
            background: linear-gradient(145deg, rgba(147, 192, 222, .3), rgba(185, 229, 229, .42));
            color: #315f76;
            font-size: 1.1rem;
        }

        .admin-ticket-modal-kicker {
            display: block;
            margin-bottom: .12rem;
            font-size: .61rem;
        }

        .admin-ticket-modal-note {
            display: flex;
            align-items: center;
            gap: .65rem;
            padding: .82rem .95rem;
            border: 1px solid rgba(147, 192, 222, .3);
            border-radius: .85rem;
            background: rgba(147, 192, 222, .1);
            color: #526a75;
            font-size: .82rem;
        }

        .admin-ticket-modal-content h6 {
            color: #315f76 !important;
            letter-spacing: .08em;
        }

        .admin-ticket-modal-footer {
            padding: 1rem 1.25rem;
            border-top: 1px solid rgba(9, 35, 47, .08);
            background: #f2f7f8;
        }

            .admin-ticket-modal-footer .btn {
                min-height: 42px;
                border-radius: .7rem;
                font-weight: 700;
            }

        @media (max-width: 991.98px) {
            .admin-ticket-heading-actions {
                width: 100%;
            }
        }

        @media (max-width: 767.98px) {
            .admin-ticket-context-chip {
                display: none;
            }

            .admin-ticket-primary-action {
                width: 100%;
                justify-content: center;
            }

            .admin-ticket-list-hint {
                display: none;
            }

            .admin-ticket-table {
                min-width: 1020px;
            }

            .admin-ticket-detail-heading .admin-ticket-back-button {
                width: 100%;
                justify-content: center;
            }
        }

        @media (max-width: 575.98px) {
            .admin-ticket-heading,
            .admin-ticket-detail-heading {
                border-radius: 1rem;
            }

            .admin-ticket-toggle .btn {
                flex-basis: 100%;
            }

            .admin-ticket-modal-content {
                border-radius: 1rem;
            }

            .admin-ticket-modal-footer .btn,
            .admin-ticket-modal-footer input.btn {
                width: 100%;
                margin: 0;
            }
        }

        @media (prefers-reduced-motion: reduce) {
            .admin-tickets-js [data-admin-ticket-row],
            .admin-tickets-js [data-admin-ticket-row].is-visible {
                opacity: 1;
                transform: none;
                transition: none;
            }
        }
    </style>

    <script type="text/javascript">
        function validarSprintModal() {
            var modal = document.getElementById('ticketEditarModal');
            if (!modal || !modal.classList.contains('show')) return true;

            var requiredControls = [
                document.getElementById('<%= txtEditDescripcion.ClientID %>'),
                document.getElementById('<%= txtEditFechaEstimadaFin.ClientID %>'),
                document.getElementById('<%= ddlEditPrioridad.ClientID %>'),
                document.getElementById('<%= ddlEditEstado.ClientID %>'),
                document.getElementById('<%= ddlEditUsuario.ClientID %>'),
                document.getElementById('<%= ddlEditSprint.ClientID %>'),
                document.getElementById('<%= txtMotivoCambio.ClientID %>')
            ];

            var valid = true;
            requiredControls.forEach(function (control, index) {
                if (!control) return;
                var value = control.value.trim();
                var controlValid = value.length > 0 && (index !== 6 || value.length >= 5);
                control.classList.toggle('is-invalid', !controlValid);
                control.classList.toggle('is-valid', controlValid);
                if (!controlValid) valid = false;
            });
            return valid;
        }

        document.addEventListener('DOMContentLoaded', function () {
            var appMain = document.querySelector('.app-main');
            if (appMain && document.querySelector('.admin-tickets-workspace')) {
                appMain.classList.add('admin-tickets-surface', 'admin-tickets-js');
            }

            var rows = document.querySelectorAll('[data-admin-ticket-row]');
            var reducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
            if (!reducedMotion && 'IntersectionObserver' in window) {
                var observer = new IntersectionObserver(function (entries, currentObserver) {
                    entries.forEach(function (entry) {
                        if (entry.isIntersecting) {
                            entry.target.classList.add('is-visible');
                            currentObserver.unobserve(entry.target);
                        }
                    });
                }, { threshold: 0.08 });
                rows.forEach(function (row, index) {
                    row.style.transitionDelay = Math.min(index * 32, 190) + 'ms';
                    observer.observe(row);
                });
            } else {
                rows.forEach(function (row) { row.classList.add('is-visible'); });
            }

            document.querySelectorAll('.admin-ticket-detail-status .badge').forEach(function (badge) {
                var state = badge.textContent.trim().toLocaleLowerCase('es');
                if (state.indexOf('final') !== -1 || state.indexOf('complet') !== -1) badge.classList.add('status-final');
            });

            document.querySelectorAll('.admin-ticket-modal-content').forEach(function (modalContent) {
                modalContent.closest('.modal').addEventListener('shown.bs.modal', function () {
                    var field = modalContent.querySelector('textarea:not(:disabled), input:not([type="hidden"]):not(:disabled), select:not(:disabled)');
                    if (field) field.focus({ preventScroll: true });
                });
            });
        });
    </script>

</asp:Content>
