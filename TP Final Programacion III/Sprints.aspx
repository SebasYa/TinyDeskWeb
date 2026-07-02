<%@ Page Title="Gestión de Sprints" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Sprints.aspx.cs" Inherits="TP_Final_Programacion_III.Sprints" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container-fluid sprints-workspace px-0 pt-2">
        <asp:Literal ID="litMensaje" runat="server"></asp:Literal>
        <asp:Panel ID="pnlListadoSprints" runat="server" CssClass="sprints-list-view">
            <div class="d-none" aria-hidden="true">
                <asp:TextBox runat="server" ID="txtFiltroSprints" CssClass="form-control" placeholder="Filtrar por Proyecto" AutoPostBack="true" OnTextChanged="txtFiltroSprints_TextChanged" />
            </div>
            <div class="sprint-page-heading d-flex justify-content-between align-items-start flex-wrap gap-4 mb-4">
                <div class="sprint-heading-copy">
                    <span class="sprint-eyebrow"><i class="bi bi-calendar-week"></i>Planificación operativa</span>
                    <h1 class="h2 fw-bold mb-2">Sprints</h1>
                    <p class="mb-0">Organizá ciclos de trabajo, controlá el avance y anticipá vencimientos.</p>
                </div>

                <div class="sprint-heading-actions d-flex align-items-center flex-wrap gap-3">
                    <div class="sprint-context-chip">
                        <i class="bi bi-kanban"></i>
                        <span><strong>Ritmo del equipo</strong><small>Seguimiento por ciclo</small></span>
                    </div>
                    <button type="button" class="btn sprint-primary-action d-flex align-items-center gap-2" data-bs-toggle="modal" data-bs-target="#sprintModal">
                        <i class="bi bi-plus-circle"></i>Crear sprint
                    </button>
                </div>
            </div>

            <div class="modal fade" id="sprintModal" tabindex="-1" aria-labelledby="sprintModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
                    <div class="modal-content sprint-modal-content">
                        <div class="modal-header sprint-modal-header">
                            <div class="d-flex align-items-center gap-3">
                                <span class="sprint-modal-icon"><i class="bi bi-calendar-plus"></i></span>
                                <div><span class="sprint-modal-kicker">Nuevo ciclo de trabajo</span><h5 class="modal-title fw-bold mb-0" id="sprintModalLabel">Crear sprint</h5>
                                </div>
                            </div>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                        </div>
                        <div class="modal-body p-4">
                            <div class="sprint-modal-note mb-4"><i class="bi bi-info-circle"></i><span>Definí el período, el proyecto y el área responsable del ciclo.</span></div>
                            <asp:Panel ID="pnlFormSprint" CssClass="row g-3" runat="server">



                                <div class="col-md-6">
                                    <label for="txtFechaInicio" class="form-label fw-semibold">Fecha Inicio</label>
                                    <asp:TextBox ID="txtFechaInicio" runat="server" CssClass="form-control" TextMode="Date" Enabled="false"></asp:TextBox>
                                    <div class="invalid-feedback">
                                        La fecha de inicio tiene que ser igual o mayor al día de hoy
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <label for="txtFechaEstimadaFin" class="form-label fw-semibold">Fecha Estimada Fin</label>
                                    <asp:TextBox ID="txtFechaEstimadaFin" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                                    <div class="invalid-feedback">
                                        La fecha Estimada fin tiene que ser igual o mayor a la fecha de inicio
                                    </div>
                                </div>

                                <div class="col-md-4">
                                    <label for="ddlProyecto" class="form-label fw-semibold">Proyecto</label>
                                    <asp:DropDownList ID="ddlProyecto" runat="server" CssClass="form-select">
                                        <asp:ListItem Text="Seleccione Proyecto..." Value="" />
                                    </asp:DropDownList>
                                    <div class="invalid-feedback">
                                        Debes elegir un Proyecto
                                    </div>
                                </div>

                                <div class="col-md-4">
                                    <label for="ddlEstado" class="form-label fw-semibold">Estado</label>
                                    <asp:DropDownList ID="ddlEstado" runat="server" CssClass="form-select">
                                        <asp:ListItem Text="Seleccione Estado..." Value="" />
                                    </asp:DropDownList>
                                    <div class="invalid-feedback">
                                        Debes elegir un Estado
                                    </div>
                                </div>

                                <div class="col-md-4">
                                    <label for="ddlArea" class="form-label fw-semibold">Área</label>
                                    <asp:DropDownList ID="ddlArea" runat="server" CssClass="form-select">
                                        <asp:ListItem Text="Seleccione Área..." Value="" />
                                    </asp:DropDownList>
                                    <div class="invalid-feedback">
                                        Debes elegir un Area
                                    </div>
                                </div>

                            </asp:Panel>
                        </div>
                        <div class="modal-footer sprint-modal-footer">
                            <asp:Button ID="btnCerrarSprint" runat="server" CssClass="btn btn-outline-secondary" Text="Cancelar" OnClick="btnCerrarSprint_Click" UseSubmitBehavior="false" />
                            <asp:Button ID="btnGuardarSprint" runat="server" CssClass="btn sprint-save-button" Text="Guardar Sprint" OnClientClick="return validarSprintModal();" OnClick="btnGuardarSprint_Click" />
                        </div>
                    </div>
                </div>
            </div>
            <!-- FIN MODAL -->
            <!-- FILTRO -->

            <div class="card ticket-filter-panel border-0 mb-4">
                <div class="card-body p-3 p-lg-4">

                    <div class="row g-3 align-items-end">

                        <div class="col-12 col-lg-4">
                            <label class="form-label fw-semibold">Vista rápida</label>

                            <div class="ticket-toggle d-flex gap-2">

                                <asp:Button
                                    ID="btnFiltroPendientes"
                                    runat="server"
                                    Text="Pendientes"
                                    CssClass="btn btn-outline-primary active flex-fill"
                                    CausesValidation="false"
                                    OnClick="btnFiltroPendientes_Click" />

                                <asp:Button
                                    ID="btnMostrarTodos"
                                    runat="server"
                                    Text="Todos"
                                    CssClass="btn btn-outline-secondary flex-fill"
                                    CausesValidation="false"
                                    OnClick="btnMostrarTodos_Click" />

                            </div>
                        </div>

                        <div class="col-12 col-md-6 col-lg-2">
                            <label for="ddlProximoVencimiento" class="form-label fw-semibold">
                                Vencimiento
                            </label>

                            <asp:DropDownList
                                ID="ddlProximoVencimiento"
                                runat="server"
                                CssClass="form-select"
                                AutoPostBack="true"
                                OnSelectedIndexChanged="ddlProximoVencimiento_SelectedIndexChanged">

                                <asp:ListItem Text="Todos" Value="0" />
                                <asp:ListItem Text="Próximos 7 días" Value="7" />
                                <asp:ListItem Text="Próximos 14 días" Value="14" />
                                <asp:ListItem Text="Próximos 30 días" Value="30" />

                            </asp:DropDownList>
                        </div>

                        <div class="col-12 col-md-6 col-lg-4">
                            <div class="ticket-filter-note rounded-3 px-3 py-2">
                                <div class="small text-muted">
                                    Los períodos muestran sprints pendientes que vencen desde hoy.
                                </div>
                            </div>
                        </div>

                        <div class="col-12 col-lg-2">
                            <asp:Button
                                ID="btnToggleFiltros"
                                runat="server"
                                Text="Mostrar filtros"
                                CssClass="btn btn-outline-secondary w-100"
                                CausesValidation="false"
                                OnClick="btnToggleFiltros_Click" />
                        </div>

                    </div>

                </div>
            </div>

            <!-- FILTROS -->
            <asp:Panel
                ID="pnlFiltros"
                runat="server"
                Visible="false"
                CssClass="card ticket-filter-panel ticket-advanced-filters border-0 mb-4"
                DefaultButton="btnAplicarFiltros">

                <div class="card-body p-3 p-lg-4">

                    <div class="row g-3 align-items-end">

                        <div class="col-12 col-lg-5">
                            <label for="txtFiltro" class="form-label fw-semibold">
                                Buscar
                            </label>

                            <div class="input-group ticket-search-group">
                                <span class="input-group-text bg-white">
                                    <i class="bi bi-search text-muted"></i>
                                </span>

                                <asp:TextBox
                                    ID="txtFiltro"
                                    runat="server"
                                    CssClass="form-control"
                                    placeholder="Número, proyecto, área..." />
                            </div>
                        </div>

                        <div class="col-12 col-md-5 col-lg-2">
                            <label for="ddlArea" class="form-label fw-semibold">
                                Area
                            </label>

                            <asp:DropDownList
                                ID="ddlareaFiltro"
                                runat="server"
                                CssClass="form-select">
                            </asp:DropDownList>
                        </div>

                        <div class="col-12 col-md-7 col-lg-3">
                            <label for="ddlOrden" class="form-label fw-semibold">
                                Ordenar
                            </label>

                            <asp:DropDownList ID="ddlOrden" runat="server" CssClass="form-select">
                                <asp:ListItem Text="Vencimiento próximo" Value="fecha_asc" />
                                <asp:ListItem Text="Vencimiento lejano" Value="fecha_desc" />
                                <asp:ListItem Text="Más recientes" Value="recientes" />
                            </asp:DropDownList>
                        </div>

                        <div class="col-12 col-lg-2 d-flex gap-2">

                            <asp:Button
                                ID="btnAplicarFiltros"
                                runat="server"
                                Text="Aplicar"
                                CssClass="btn btn-primary flex-fill"
                                OnClick="btnAplicarFiltros_Click" />

                            <asp:Button
                                ID="btnLimpiarFiltros"
                                runat="server"
                                Text="Limpiar"
                                CssClass="btn btn-outline-secondary flex-fill"
                                OnClick="btnLimpiarFiltros_Click" />

                        </div>

                    </div>

                </div>
            </asp:Panel>
            <!-- INICIO LISTVIEW -->
            <div class="sprint-list-heading d-flex justify-content-between align-items-end flex-wrap gap-3 mb-3">
                <div><span class="sprint-section-label">Cronograma</span><h2 class="h5 fw-bold mb-1">Ciclos de trabajo</h2>
                    <p class="mb-0">Estado, fechas, progreso y contexto de cada sprint.</p>
                </div>
                <span class="sprint-list-hint"><i class="bi bi-bar-chart-line"></i>Progreso por tickets</span>
            </div>
            <div class="sprint-table-card table-responsive">

                <asp:ListView ID="lvSprints" runat="server" ItemPlaceholderID="itemPlaceholder" OnItemCommand="lvSprints_ItemCommand" OnPagePropertiesChanging="lvSprints_PagePropertiesChanging">

                    <LayoutTemplate>
                        <table class="table sprint-table table-hover align-middle mb-0">

                            <thead class="table-light text-secondary fw-semibold border-bottom">
                                <tr>
                                    <th>Sprint</th>
                                    <th>Estado</th>
                                    <th>Fechas</th>
                                    <th>Progreso</th>
                                    <th>Proyecto / Área</th>
                                    <th>Acciones</th>
                                </tr>
                            </thead>

                            <tbody>
                                <asp:PlaceHolder ID="itemPlaceholder" runat="server" />
                            </tbody>

                        </table>
                    </LayoutTemplate>

                    <ItemTemplate>
                        <tr data-sprint-row="true">

                            <td class="sprint-id-cell">
                                <span class="text-dark fw-bold">Sprint <%# Eval("NumeroSprint") %></span>
                            </td>

                            <td class="sprint-status-cell">
                                <span class='<%# GetClassEtiquetaEstado(Eval("Estado.Nombre")) %>'>
                                    <%# Eval("Estado.Nombre") %>
                                </span>
                            </td>

                            <td>
                                <div class="text-dark small fw-medium">
                                    <%# Convert.ToDateTime(Eval("FechaInicio")).ToString("dd/MM/yyyy") %> -
                        <%# Convert.ToDateTime(Eval("FechaEstimadaFin")).ToString("dd/MM/yyyy") %>
                                </div>

                                <small class="text-muted text-xs d-block">
                                    <%# GetDiasRestantesTexto(Eval("FechaEstimadaFin"), Eval("Estado.EsFinal"), Eval("FechaFin")) %>
                                </small>
                            </td>

                            <td class="sprint-progress-cell">
                                <div class="d-flex flex-column gap-1">

                                    <div class="d-flex justify-content-between">
                                        <span class="text-xs text-muted">Tiempo: <%# Eval("ProgresoTiempo") %>%</span>
                                    </div>

                                    <span class="small fw-bold text-dark">Tickets: <%# Eval("ProgresoTickets") %>%
                            <span class="text-muted fw-normal" style="font-size: 0.75rem;">(<%# Eval("TicketsFinalizados") %>/<%# Eval("TicketsTotales") %>)
                            </span>
                                    </span>

                                    <div class="progress" style="height: 6px;">
                                        <div class='<%# GetClassBarraProgreso(Eval("Estado.Nombre")) %>' role="progressbar" style='width: <%# Eval("ProgresoTickets") %>%;'></div>
                                    </div>

                                </div>
                            </td>

                            <td>
                                <div class="fw-semibold text-dark text-sm"><%# Eval("Proyecto.Nombre") %></div>
                                <span class="badge bg-secondary-subtle text-secondary rounded-pill font-monospace"><%# Eval("Area.Nombre") %></span>
                            </td>

                            <td class="sprint-status-cell">
                                <div class="sprint-row-actions d-flex gap-2">

                                    <asp:LinkButton ID="btnVerSprint" runat="server" CommandName="VerDetalle" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-sm sprint-action-button action-view" ToolTip="Ver Sprint">
                            <i class="bi bi-eye"></i>
                                    </asp:LinkButton>

                                    <asp:LinkButton ID="btnEditarSprint" runat="server" CommandName="EditarSprint" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-sm sprint-action-button action-edit" ToolTip="Editar Sprint">
                            <i class="bi bi-pencil"></i>
                                    </asp:LinkButton>

                                    <asp:LinkButton ID="btnAbrirModalEliminar" runat="server" CssClass="btn btn-sm sprint-action-button action-delete" OnClientClick='<%# "abrirModalEliminar(" + Eval("Id") + "); return false;" %>' ToolTip="Eliminar Sprint">
                            <i class="bi bi-trash"></i>
                                    </asp:LinkButton>

                                    <asp:LinkButton ID="btnFinalizarSprint" runat="server" CommandName="Finalizar" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-sm sprint-action-button action-complete" ToolTip="Finalizar Sprint" Visible='<%# !(bool)Eval("Estado.EsFinal") %>'>
                            <i class="bi bi-check-circle"></i>
                                    </asp:LinkButton>
                                </div>
                            </td>

                        </tr>
                    </ItemTemplate>

                    <EmptyDataTemplate>
                        <div class="sprint-empty-state"><i class="bi bi-calendar2-x"></i><strong>No hay sprints para mostrar</strong><span>Probá ajustando los filtros o creando un nuevo ciclo.</span></div>
                    </EmptyDataTemplate>

                </asp:ListView>

            </div>
            <div class="sprint-pagination d-flex justify-content-center mt-4">
                <asp:DataPager ID="dpSprints" runat="server" PagedControlID="lvSprints" PageSize="7">
                    <Fields>
                        <asp:NextPreviousPagerField ShowPreviousPageButton="true" ShowNextPageButton="false" PreviousPageText="Anterior" ButtonCssClass="btn btn-outline-secondary me-1" />
                        <asp:NumericPagerField ButtonCount="5" NumericButtonCssClass="btn btn-outline-primary me-1" CurrentPageLabelCssClass="btn btn-primary me-1" />
                        <asp:NextPreviousPagerField ShowPreviousPageButton="false" ShowNextPageButton="true" NextPageText="Siguiente" ButtonCssClass="btn btn-outline-secondary" />
                    </Fields>
                </asp:DataPager>
            </div>

            <!--  ARRANCA MODAL EDITAR SPRINT -->
            <div class="modal fade" id="sprintEditarModal" tabindex="-1" aria-labelledby="sprintEditarModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
                    <div class="modal-content sprint-modal-content">
                        <div class="modal-header sprint-modal-header">
                            <span class="sprint-modal-icon"><i class="bi bi-pencil-square"></i></span>
                            <h5 class="modal-title fw-bold me-auto" id="sprintEditarModalLabel">
                                <asp:Label ID="lblModalEditarTitulo" runat="server" Text="Editar Sprint"></asp:Label>
                            </h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                        </div>
                        <div class="modal-body">
                            <div id="alertModalEdit" runat="server" class="alert alert-info border d-flex justify-content-between align-items-center mb-0" role="alert">
                                <div>
                                    <asp:Label ID="lblIconoModal" runat="server" CssClass="bi bi-info-circle-fill me-2"></asp:Label>
                                    <span class="fw-bold">Progreso:</span>
                                    <asp:Label ID="lblModalProgreso" runat="server" Text="0%"></asp:Label>
                                </div>
                                <div>
                                    <span class="fw-bold">Días:</span>
                                    <asp:Label ID="lblModalDiasRestantes" runat="server" Text="-"></asp:Label>
                                </div>
                            </div>

                            <asp:Panel ID="pnlFormEditSprint" CssClass="row g-3" runat="server">



                                <div class="col-md-4">
                                    <label for="txtEditFechaInicio" class="form-label fw-semibold">Fecha Inicio</label>
                                    <asp:TextBox ID="txtEditFechaInicio" runat="server" CssClass="form-control" TextMode="Date" ReadOnly="true"></asp:TextBox>
                                    <div class="invalid-feedback">
                                        La fecha de inicio tiene que ser igual o mayor al día de hoy
                                    </div>
                                </div>

                                <div class="col-md-4">
                                    <label for="txtEditFechaEstimadaFin" class="form-label fw-semibold">Fecha Estimada Fin</label>
                                    <asp:TextBox ID="txtEditFechaEstimadaFin" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                                    <div class="invalid-feedback">
                                        La fecha estimada de fin tiene que ser igual o mayor a la fecha de inicio
                                    </div>
                                </div>

                                <div class="col-md-4">
                                    <label for="txtEditFechaFin" class="form-label fw-semibold">Fecha Fin</label>
                                    <asp:TextBox ID="txtEditFechaFin" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                                    <div class="invalid-feedback">
                                        La fecha de fin tiene que ser igual o mayor a la fecha de inicio
                                    </div>
                                </div>

                                <div class="col-md-4">
                                    <label for="ddlEditProyecto" class="form-label fw-semibold">Proyecto</label>
                                    <asp:DropDownList ID="ddlEditProyecto" runat="server" CssClass="form-select">
                                        <asp:ListItem Text="Seleccione Proyecto..." Value="" />
                                    </asp:DropDownList>
                                    <div class="invalid-feedback">
                                        Debes elegir un Proyecto
                                    </div>
                                </div>

                                <div class="col-md-4">
                                    <label for="ddlEditEstado" class="form-label fw-semibold">Estado</label>
                                    <asp:DropDownList ID="ddlEditEstado" runat="server" CssClass="form-select">
                                        <asp:ListItem Text="Seleccione Estado..." Value="" />
                                    </asp:DropDownList>
                                    <div class="invalid-feedback">
                                        Debes elegir un Estado
                                    </div>
                                </div>

                                <div class="col-md-4">
                                    <label for="<%= ddlEditArea.ClientID %>" class="form-label fw-semibold">Área</label>
                                    <asp:DropDownList ID="ddlEditArea" runat="server" CssClass="form-select">
                                        <asp:ListItem Text="Seleccione Área..." Value="" />
                                    </asp:DropDownList>
                                    <div class="invalid-feedback">
                                        Debes elegir un Area
                                    </div>
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

                            </asp:Panel>
                        </div>
                        <div class="modal-footer sprint-modal-footer">
                            <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancelar</button>
                            <asp:Button ID="btnGuardarEdicion" runat="server" CssClass="btn sprint-save-button" Text="Guardar Sprint" OnClientClick="return validarSprintModal();" OnClick="btnGuardarEdicion_Click" />
                        </div>
                    </div>
                </div>
            </div>
        </asp:Panel>
        <asp:Panel ID="pnlDetalleSprint" runat="server" CssClass="sprint-detail-view">
            <div class="sprint-detail-heading d-flex justify-content-between align-items-center flex-wrap gap-3 mb-4">
                <div>
                    <h2 class="mb-1 fw-bold text-dark">
                        <asp:Label ID="lblDetalleTituloSprint" runat="server" Text="Detalle de Sprint"></asp:Label>
                    </h2>
                    <span class="badge bg-primary-subtle text-primary px-3 py-2 rounded-pill fw-semibold">
                        <asp:Label ID="lblSprintProyectoArea" runat="server" Text="Proyecto / Área"></asp:Label>
                    </span>
                </div>

                <div class="d-flex gap-2">
                    <a href="Sprints.aspx" class="btn sprint-back-button d-flex align-items-center gap-2">
                        <i class="bi bi-arrow-left"></i>Volver al listado
                    </a>
                </div>
            </div>

            <div class="card sprint-detail-card border-0 mb-5">
                <div class="card-body p-4">
                    <h5 class="fw-bold text-dark mb-4">Información del Sprint</h5>

                    <div class="row g-3">
                        <div class="col-6 col-md-3 sprint-detail-field">
                            <span class="text-uppercase text-muted fw-semibold d-block text-xs" style="font-size: 0.75rem; letter-spacing: 0.5px;">Fecha Inicio</span>
                            <strong class="text-dark fs-6">
                                <asp:Label ID="lblDetalleFechaInicio" runat="server"></asp:Label></strong>
                        </div>
                        <div class="col-6 col-md-3 sprint-detail-field">
                            <span class="text-uppercase text-muted fw-semibold d-block text-xs" style="font-size: 0.75rem; letter-spacing: 0.5px;">Fecha Estimada Fin</span>
                            <strong class="text-dark fs-6">
                                <asp:Label ID="lblDetalleFechaEstimadaFin" runat="server"></asp:Label></strong>
                        </div>
                        <div class="col-6 col-md-3 sprint-detail-field">
                            <span class="text-uppercase text-muted fw-semibold d-block text-xs" style="font-size: 0.75rem; letter-spacing: 0.5px;">Fecha Fin Real</span>
                            <strong class="text-dark fs-6">
                                <asp:Label ID="lblDetalleFechaFin" runat="server" Text="-"></asp:Label></strong>
                        </div>
                        <div class="col-6 col-md-3 sprint-detail-field sprint-detail-status">
                            <span class="text-uppercase text-muted fw-semibold d-block text-xs" style="font-size: 0.75rem; letter-spacing: 0.5px;">Estado General</span>
                            <asp:Label ID="lblDetalleEstado" runat="server" CssClass="badge text-uppercase border  px-2"></asp:Label>
                        </div>
                    </div>
                </div>
            </div>

            <div class="d-flex justify-content-between align-items-center mb-3">
                <h4 class="fw-bold text-dark mb-0">Tickets incluidos en el Sprint</h4>
                <span class="badge bg-light text-dark border fw-medium px-2 py-1">
                    <i class="bi bi-layers-half me-1 text-muted"></i>Total de tareas
                </span>
            </div>

            <div class="sprint-table-card overflow-hidden">

                <asp:ListView ID="lvTicketsDelSprint" runat="server" ItemPlaceholderID="itemPlaceholder" OnPagePropertiesChanging="lvTicketsDelSprint_PagePropertiesChanging">

                    <LayoutTemplate>
                        <div class="table-responsive">
                            <table class="table sprint-table sprint-ticket-table table-hover align-middle mb-0">

                                <thead class="table-light text-secondary fw-semibold border-bottom small">
                                    <tr>
                                        <th>ID</th>
                                        <th>Título</th>
                                        <th>Prioridad</th>
                                        <th>Estado</th>
                                        <th>Asignado a</th>
                                        <th>Creado el</th>
                                    </tr>
                                </thead>

                                <tbody>
                                    <asp:PlaceHolder ID="itemPlaceholder" runat="server" />
                                </tbody>

                            </table>
                        </div>
                    </LayoutTemplate>

                    <ItemTemplate>
                        <tr data-sprint-ticket-row="true">

                            <td>
                                <a href='Tickets.aspx?id=<%# Eval("Id") %>' class="text-primary fw-bold text-decoration-none">TK-<%# Eval("Id").ToString().PadLeft(3, '0') %>
                                </a>
                            </td>

                            <td>
                                <span class="text-dark"><%# Eval("Descripcion") %></span>
                            </td>

                            <td class="sprint-ticket-priority-cell">
                                <span class='<%# GetClassEtiquetaPrioridad(Eval("Prioridad.Nombre")) %>'><%# Eval("Prioridad.Nombre") %></span>
                            </td>

                            <td class="sprint-ticket-status-cell">
                                <span class='<%# GetClassEtiquetaEstado(Eval("Estado.Nombre")) %>'><%# Eval("Estado.Nombre") %></span>
                            </td>

                            <td>
                                <div class="d-flex align-items-center">
                                    <i class="bi bi-person text-muted me-2"></i>
                                    <span class="text-dark fw-medium text-sm"><%# Eval("Usuario.Nombre") %> <%# Eval("Usuario.Apellido") %></span>
                                </div>
                            </td>

                            <td>
                                <span class="text-muted small"><%# Eval("FechaInicio", "{0:dd/MM/yyyy}") %></span>
                            </td>

                        </tr>
                    </ItemTemplate>

                    <EmptyDataTemplate>
                        <div class="alert alert-info m-3">Este sprint todavía no tiene tickets asignados.</div>
                    </EmptyDataTemplate>

                </asp:ListView>

                <div class="d-flex justify-content-center my-4">
                    <asp:DataPager ID="dpTicketsDelSprint" runat="server" PagedControlID="lvTicketsDelSprint" PageSize="10">
                        <Fields>
                            <asp:NextPreviousPagerField ShowPreviousPageButton="true" ShowNextPageButton="false" PreviousPageText="Anterior" ButtonCssClass="btn btn-outline-secondary me-1" />
                            <asp:NumericPagerField ButtonCount="5" NumericButtonCssClass="btn btn-outline-primary me-1" CurrentPageLabelCssClass="btn btn-primary me-1" />
                            <asp:NextPreviousPagerField ShowPreviousPageButton="false" ShowNextPageButton="true" NextPageText="Siguiente" ButtonCssClass="btn btn-outline-secondary" />
                        </Fields>
                    </asp:DataPager>
                </div>

            </div>

        </asp:Panel>
    </div>
    <!--MODAL CONFIRMACION ELIMINAR -->
    <asp:HiddenField ID="hfIdSprintEliminar" runat="server" />
    <div class="modal fade" id="modalEliminarConfirm" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content sprint-modal-content sprint-delete-modal">
                <div class="modal-header sprint-delete-header">
                    <span class="sprint-modal-icon"><i class="bi bi-trash3"></i></span>
                    <h5 class="modal-title me-auto">Eliminar sprint</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                </div>
                <div class="modal-body">
                    <p>¿Estás seguro de que deseas eliminar este Sprint? Esta acción no se puede deshacer.</p>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Motivo de la eliminación:</label>
                        <asp:TextBox ID="txtMotivoEliminacion" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="2"></asp:TextBox>
                        <div id="errorEliminacion" class="text-danger small" style="display: none;">Debe ingresar un motivo.</div>
                    </div>
                </div>
                <div class="modal-footer sprint-modal-footer">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <asp:Button ID="btnConfirmarEliminacion" runat="server" CssClass="btn btn-danger" Text="Sí, eliminar" OnClick="btnEliminar_Click" OnClientClick="return validarEliminacion();" />
                </div>
            </div>
        </div>
    </div>
    <style>
        :root {
            --sprints-sky: #93c0de;
            --sprints-aqua: #b9e5e5;
            --sprints-ink: #09232f;
            --sprints-muted: #75797e;
            --sprints-violet: #65479b;
            --sprints-violet-soft: #eee7fa;
            --sprints-violet-line: #cbbbe8;
            --sprints-line: rgba(9, 35, 47, .1);
            --sprints-shadow: 0 18px 44px rgba(9, 35, 47, .075);
        }

        .app-main.sprints-app-surface {
            background: radial-gradient(circle at 93% 2%, rgba(147, 192, 222, .24), transparent 25rem), radial-gradient(circle at 10% 90%, rgba(185, 229, 229, .2), transparent 28rem), linear-gradient(180deg, #f8fafb 0%, #f2f7f8 100%);
        }

        .sprints-workspace {
            width: 100%;
            max-width: 1580px;
            margin-inline: auto;
            color: var(--sprints-ink);
        }

            .sprints-workspace > .alert {
                border-radius: .9rem;
                box-shadow: 0 10px 24px rgba(9, 35, 47, .05);
            }

        .sprint-page-heading,
        .sprint-detail-heading {
            position: relative;
            overflow: hidden;
            padding: clamp(1.4rem, 2.5vw, 2.1rem);
            border: 1px solid rgba(147, 192, 222, .4);
            border-radius: 1.35rem;
            background: linear-gradient(112deg, rgba(255, 255, 255, .96), rgba(244, 251, 252, .88));
            box-shadow: 0 15px 38px rgba(9, 35, 47, .055);
            isolation: isolate;
        }

            .sprint-page-heading::after,
            .sprint-detail-heading::after {
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

        .sprint-heading-copy {
            max-width: 48rem;
        }

            .sprint-heading-copy h1,
            .sprint-list-heading h2,
            .sprint-detail-heading h2,
            .sprints-workspace h4,
            .sprints-workspace h5 {
                color: var(--sprints-ink) !important;
                letter-spacing: -.025em;
            }

            .sprint-heading-copy p,
            .sprint-list-heading p {
                color: var(--sprints-muted);
            }

        .sprint-eyebrow,
        .sprint-section-label,
        .sprint-modal-kicker {
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

        .sprint-heading-actions {
            position: relative;
            z-index: 1;
        }

        .sprint-context-chip {
            display: flex;
            align-items: center;
            gap: .7rem;
            padding: .65rem .78rem;
            border: 1px solid rgba(147, 192, 222, .42);
            border-radius: .9rem;
            background: rgba(255, 255, 255, .78);
        }

            .sprint-context-chip > i {
                display: grid;
                place-items: center;
                width: 2.35rem;
                height: 2.35rem;
                border-radius: .7rem;
                background: linear-gradient(145deg, rgba(147, 192, 222, .28), rgba(185, 229, 229, .4));
                color: #315f76;
                font-size: 1rem;
            }

            .sprint-context-chip span {
                display: flex;
                flex-direction: column;
                line-height: 1.2;
            }

            .sprint-context-chip strong {
                font-size: .8rem;
            }

            .sprint-context-chip small {
                margin-top: .18rem;
                color: var(--sprints-muted);
                font-size: .68rem;
            }

        .sprint-primary-action,
        .sprint-save-button {
            min-height: 44px;
            border: 1px solid var(--sprints-ink) !important;
            border-radius: .75rem;
            background: var(--sprints-ink) !important;
            color: #fff !important;
            font-weight: 700;
            box-shadow: 0 9px 20px rgba(9, 35, 47, .14);
        }

            .sprint-primary-action:hover,
            .sprint-save-button:hover {
                border-color: #17485d !important;
                background: #17485d !important;
                color: #fff !important;
                transform: translateY(-1px);
            }

        .sprints-workspace .ticket-filter-panel,
        .sprint-detail-card,
        .sprint-table-card {
            border: 1px solid rgba(9, 35, 47, .08) !important;
            border-radius: 1.2rem;
            background: rgba(255, 255, 255, .86);
            box-shadow: var(--sprints-shadow);
            backdrop-filter: blur(12px);
        }

            .sprints-workspace .ticket-filter-panel .form-label {
                margin-bottom: .5rem;
                color: #39515c;
                font-size: .76rem;
            }

        .sprints-workspace .ticket-toggle {
            padding: .28rem;
            border: 1px solid var(--sprints-line);
            border-radius: .9rem;
            background: #edf3f4;
        }

            .sprints-workspace .ticket-toggle .btn {
                min-height: 40px;
                border-color: transparent;
                border-radius: .68rem !important;
                box-shadow: none;
                font-weight: 700;
            }

                .sprints-workspace .ticket-toggle .btn.active,
                .sprints-workspace .ticket-toggle .btn-secondary {
                    background: var(--sprints-ink);
                    color: #fff;
                }

        .sprints-workspace .ticket-filter-note {
            min-height: 44px;
            display: flex;
            align-items: center;
            border: 1px solid rgba(147, 192, 222, .26);
            background: rgba(147, 192, 222, .09);
        }

        .sprints-workspace .ticket-search-group .input-group-text,
        .sprints-workspace .ticket-search-group .form-control,
        .sprints-workspace .ticket-filter-panel .form-select,
        .sprint-modal-content .form-control,
        .sprint-modal-content .form-select {
            min-height: 44px;
            border-color: rgba(9, 35, 47, .14);
            background-color: rgba(255, 255, 255, .94);
        }

        .sprints-workspace .ticket-search-group .input-group-text {
            border-right: 0;
            border-radius: .75rem 0 0 .75rem;
        }

        .sprints-workspace .ticket-search-group .form-control {
            border-left: 0;
            border-radius: 0 .75rem .75rem 0;
        }

        .sprints-workspace .form-control:focus,
        .sprints-workspace .form-select:focus,
        .sprint-modal-content .form-control:focus,
        .sprint-modal-content .form-select:focus {
            border-color: #75a9c9;
            box-shadow: 0 0 0 .22rem rgba(147, 192, 222, .2);
        }

        .sprint-list-heading {
            padding-inline: .2rem;
        }

            .sprint-list-heading p {
                font-size: .84rem;
            }

        .sprint-list-hint {
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

        .sprint-table-card {
            overflow: hidden;
        }

        .sprint-table {
            min-width: 1050px;
        }

        .sprint-ticket-table {
            min-width: 920px;
        }

        .sprint-table thead th {
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

        .sprint-table tbody td {
            padding: 1rem;
            border-color: rgba(9, 35, 47, .07);
            color: #52646c;
            font-size: .83rem;
            vertical-align: middle;
        }

        .sprint-table tbody tr {
            transition: background-color .18s ease, opacity .35s ease, transform .35s ease;
        }

            .sprint-table tbody tr:hover {
                background: rgba(185, 229, 229, .15);
            }

        .sprints-js [data-sprint-row],
        .sprints-js [data-sprint-ticket-row] {
            opacity: 0;
            transform: translateY(6px);
        }

            .sprints-js [data-sprint-row].is-visible,
            .sprints-js [data-sprint-ticket-row].is-visible {
                opacity: 1;
                transform: none;
            }

        .sprint-id-cell > span {
            color: var(--sprints-ink) !important;
        }

        .sprint-progress-cell {
            width: 190px;
        }

            .sprint-progress-cell .progress {
                overflow: hidden;
                border-radius: 999px;
                background: #e6edef;
            }

            .sprint-progress-cell .progress-bar.bg-primary {
                background: #3f9c72 !important;
            }

            .sprint-progress-cell .progress-bar.bg-success {
                background: var(--sprints-violet) !important;
            }

        .sprint-status-cell .badge,
        .sprint-ticket-status-cell .badge,
        .sprint-ticket-priority-cell .badge,
        .sprint-detail-status .badge {
            border: 1px solid transparent;
            border-radius: 999px;
            font-size: .68rem;
            font-weight: 800;
        }

        .sprint-status-cell .text-bg-primary,
        .sprint-ticket-status-cell .text-bg-primary,
        .sprint-detail-status .text-bg-primary {
            border-color: rgba(45, 132, 95, .18) !important;
            background: rgba(76, 175, 125, .14) !important;
            color: #237a55 !important;
        }

        .sprint-status-cell .text-bg-success,
        .sprint-ticket-status-cell .text-bg-success,
        .sprint-detail-status .text-bg-success,
        .sprints-workspace .status-final {
            border-color: var(--sprints-violet-line) !important;
            background: var(--sprints-violet) !important;
            color: var(--sprints-violet-soft) !important;
        }

        .sprint-status-cell .text-bg-warning,
        .sprint-ticket-status-cell .text-bg-warning {
            border-color: rgba(177, 137, 36, .18) !important;
            background: rgba(216, 184, 91, .17) !important;
            color: #80651d !important;
        }

        .sprint-ticket-priority-cell .text-bg-danger {
            border-color: rgba(184, 64, 77, .17) !important;
            background: rgba(224, 91, 105, .13) !important;
            color: #a23d49 !important;
        }

        .sprint-ticket-priority-cell .text-bg-warning {
            border-color: rgba(177, 137, 36, .18) !important;
            background: rgba(216, 184, 91, .17) !important;
            color: #80651d !important;
        }

        .sprint-ticket-priority-cell .text-bg-success {
            border-color: rgba(45, 132, 95, .18) !important;
            background: rgba(76, 175, 125, .14) !important;
            color: #237a55 !important;
        }

        .sprint-row-actions {
            white-space: nowrap;
        }

        .sprint-action-button {
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

            .sprint-action-button:hover {
                border-color: var(--sprints-ink);
                background: var(--sprints-ink);
                color: #fff;
            }

            .sprint-action-button.action-delete {
                border-color: rgba(184, 64, 77, .15);
                background: rgba(224, 91, 105, .08);
                color: #a23d49;
            }

                .sprint-action-button.action-delete:hover {
                    border-color: #a23d49;
                    background: #a23d49;
                    color: #fff;
                }

            .sprint-action-button.action-complete {
                border-color: rgba(101, 71, 155, .2);
                background: rgba(203, 187, 232, .2);
                color: var(--sprints-violet);
            }

                .sprint-action-button.action-complete:hover {
                    border-color: var(--sprints-violet);
                    background: var(--sprints-violet);
                    color: #fff;
                }

        .sprint-empty-state {
            display: flex;
            min-height: 14rem;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            gap: .3rem;
            padding: 2rem;
            color: var(--sprints-muted);
            text-align: center;
        }

            .sprint-empty-state i {
                margin-bottom: .35rem;
                color: #5f91a9;
                font-size: 2rem;
            }

            .sprint-empty-state strong {
                color: var(--sprints-ink);
            }

            .sprint-empty-state span {
                font-size: .82rem;
            }

        .sprint-pagination .btn,
        .sprint-table-card + .d-flex .btn {
            border-radius: .65rem;
            font-weight: 650;
        }

        .sprint-pagination .btn-primary,
        .sprint-table-card + .d-flex .btn-primary {
            border-color: var(--sprints-ink);
            background: var(--sprints-ink);
            color: #fff;
        }

        .sprint-back-button {
            border: 1px solid rgba(49, 95, 118, .3);
            border-radius: .72rem;
            background: rgba(255, 255, 255, .72);
            color: #315f76;
            font-weight: 700;
        }

            .sprint-back-button:hover {
                border-color: var(--sprints-ink);
                background: var(--sprints-ink);
                color: #fff;
            }

        .sprint-detail-card {
            overflow: hidden;
        }

        .sprint-detail-field {
            position: relative;
            min-height: 86px;
            padding: 1rem 1.1rem;
        }

            .sprint-detail-field::before {
                content: "";
                position: absolute;
                inset: .25rem;
                z-index: -1;
                border: 1px solid rgba(9, 35, 47, .08);
                border-radius: .82rem;
                background: linear-gradient(145deg, #fff, #f2f7f8);
            }

        .sprint-modal-content {
            overflow: hidden;
            border: 1px solid rgba(9, 35, 47, .1);
            border-radius: 1.2rem;
            box-shadow: 0 30px 90px rgba(9, 35, 47, .24);
        }

        .sprint-modal-header {
            padding: 1.1rem 1.25rem;
            border-bottom: 1px solid rgba(9, 35, 47, .08);
            background: linear-gradient(105deg, #f8fbfc, #edf6f7);
        }

        .sprint-modal-icon {
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

        .sprint-modal-kicker {
            display: block;
            margin-bottom: .12rem;
            font-size: .61rem;
        }

        .sprint-modal-note {
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

        .sprint-modal-footer {
            padding: 1rem 1.25rem;
            border-top: 1px solid rgba(9, 35, 47, .08);
            background: #f2f7f8;
        }

            .sprint-modal-footer .btn {
                min-height: 42px;
                border-radius: .7rem;
                font-weight: 700;
            }

        #alertModalEdit {
            margin-bottom: 1.25rem !important;
            border-color: rgba(147, 192, 222, .3) !important;
            border-radius: .85rem;
            background: rgba(147, 192, 222, .1);
            color: #45616e;
        }

        .sprint-delete-header {
            padding: 1.1rem 1.25rem;
            border-bottom: 1px solid rgba(184, 64, 77, .12);
            background: rgba(224, 91, 105, .08);
            color: #8e3540;
        }

            .sprint-delete-header .sprint-modal-icon {
                background: rgba(224, 91, 105, .12);
                color: #a23d49;
            }

        @media (max-width: 991.98px) {
            .sprint-heading-actions {
                width: 100%;
            }
        }

        @media (max-width: 767.98px) {
            .sprint-context-chip {
                display: none;
            }

            .sprint-primary-action {
                width: 100%;
                justify-content: center;
            }

            .sprint-list-hint {
                display: none;
            }

            .sprint-table {
                min-width: 980px;
            }

            .sprint-detail-heading .sprint-back-button {
                width: 100%;
                justify-content: center;
            }
        }

        @media (max-width: 575.98px) {
            .sprint-page-heading,
            .sprint-detail-heading {
                border-radius: 1rem;
            }

            .sprint-modal-content {
                border-radius: 1rem;
            }

            .sprint-modal-footer .btn,
            .sprint-modal-footer input.btn {
                width: 100%;
                margin: 0;
            }
        }

        @media (prefers-reduced-motion: reduce) {
            .sprints-js [data-sprint-row],
            .sprints-js [data-sprint-ticket-row],
            .sprints-js [data-sprint-row].is-visible,
            .sprints-js [data-sprint-ticket-row].is-visible {
                opacity: 1;
                transform: none;
                transition: none;
            }
        }
    </style>

    <!-- CODIGO JS PARA VALIDACION DE CAMPOS MODAL -->
    <script type="text/javascript">
        function validarSprintModal() {
            let esValido = true;

            // --- 1. Obtención de elementos ---
            const txtEstFinCrear = document.getElementById('<%= txtFechaEstimadaFin.ClientID %>');
            const txtInicioCrear = document.getElementById('<%= txtFechaInicio.ClientID %>');
            const ddlProyectoCrear = document.getElementById('<%= ddlProyecto.ClientID %>');
            const ddlEstadoCrear = document.getElementById('<%= ddlEstado.ClientID %>');
            const ddlAreaCrear = document.getElementById('<%= ddlArea.ClientID %>');

            const txtInicio = document.getElementById('<%= txtEditFechaInicio.ClientID %>');
            const txtEstFin = document.getElementById('<%= txtEditFechaEstimadaFin.ClientID %>');
            const txtFinReal = document.getElementById('<%= txtEditFechaFin.ClientID %>');
            const ddlProyecto = document.getElementById('<%= ddlEditProyecto.ClientID %>');
            const ddlEstado = document.getElementById('<%= ddlEditEstado.ClientID %>');
            const ddlArea = document.getElementById('<%= ddlEditArea.ClientID %>');
            const txtDescripcionCambio = document.getElementById('<%= txtMotivoCambio.ClientID %>');

            // --- 2. Función auxiliar con LOG de error ---
            function setValidacion(control, condicion, nombreCampo) {
                if (!control) return;
                if (condicion) {
                    control.classList.remove('is-invalid');
                    control.classList.add('is-valid');
                } else {
                    control.classList.remove('is-valid');
                    control.classList.add('is-invalid');
                    console.warn("❌ FALLÓ LA VALIDACIÓN EN: " + (nombreCampo || "Desconocido"));
                    esValido = false;
                }
            }

            // --- 3. Detección de Modal ---
            const modalCrearVisible = document.getElementById('sprintModal').classList.contains('show');
            const modalEditarVisible = document.getElementById('sprintEditarModal').classList.contains('show');

            console.log("--- DEBUG DE VARIABLES ---");
            console.log("Modal Crear Visible:", modalCrearVisible);
            console.log("Modal Editar Visible:", modalEditarVisible);

            // --- 4. Validación de Combos ---
            if (modalEditarVisible) {
                setValidacion(ddlProyecto, ddlProyecto && ddlProyecto.value !== "", "Proyecto (Editar)");
                setValidacion(ddlEstado, ddlEstado && ddlEstado.value !== "", "Estado (Editar)");
                setValidacion(ddlArea, ddlArea && ddlArea.value !== "", "Area (Editar)");
            } else if (modalCrearVisible) {
                setValidacion(ddlProyectoCrear, ddlProyectoCrear && ddlProyectoCrear.value !== "", "Proyecto (Crear)");
                setValidacion(ddlEstadoCrear, ddlEstadoCrear && ddlEstadoCrear.value !== "", "Estado (Crear)");
                setValidacion(ddlAreaCrear, ddlAreaCrear && ddlAreaCrear.value !== "", "Area (Crear)");
            }

            // --- 5. Validación de Fechas ---
            const hoyStr = new Date().toISOString().split('T')[0];

            if (modalCrearVisible && txtInicioCrear && txtEstFinCrear) {
                setValidacion(txtInicioCrear, txtInicioCrear.value !== "" && txtInicioCrear.value >= hoyStr, "Fecha Inicio (Crear)");
                setValidacion(txtEstFinCrear, txtEstFinCrear.value !== "" && txtEstFinCrear.value >= txtInicioCrear.value, "Fecha Fin (Crear)");
            }

            if (modalEditarVisible && txtInicio && txtEstFin) {
                setValidacion(txtEstFin, txtEstFin.value !== "" && txtEstFin.value >= txtInicio.value, "Fecha Estimada Fin (Editar)");

                if (txtFinReal && txtFinReal.value !== "") {
                    setValidacion(txtFinReal, txtFinReal.value >= txtInicio.value, "Fecha Fin Real (Editar)");
                }
            }

            // --- 6. Validación Descripción Motivo ---
            if (modalEditarVisible && txtDescripcionCambio) {
                const motivoValido = txtDescripcionCambio.value.trim().length >= 5;
                setValidacion(txtDescripcionCambio, motivoValido, "Motivo Cambio");
            }

            console.log("RESULTADO FINAL ¿Es válido?:", esValido);
            console.log("--------------------------");

            return esValido;
        }

        function abrirModalEliminar(id) {
            document.getElementById('<%= hfIdSprintEliminar.ClientID %>').value = id;
            var myModal = new bootstrap.Modal(document.getElementById('modalEliminarConfirm'));
            myModal.show();
        }

        function validarEliminacion() {
            const txt = document.getElementById('<%= txtMotivoEliminacion.ClientID %>');
            const err = document.getElementById('errorEliminacion');
            if (txt.value.trim().length < 5) {
                err.style.display = 'block';
                return false;
            }
            return true;
        }

        document.addEventListener('DOMContentLoaded', function () {
            var appMain = document.querySelector('.app-main');
            if (appMain && document.querySelector('.sprints-workspace')) {
                appMain.classList.add('sprints-app-surface', 'sprints-js');
            }

            var rows = document.querySelectorAll('[data-sprint-row], [data-sprint-ticket-row]');
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

            document.querySelectorAll('.sprint-detail-status .badge').forEach(function (badge) {
                var state = badge.textContent.trim().toLocaleLowerCase('es');
                if (state.indexOf('final') !== -1 || state.indexOf('complet') !== -1) {
                    badge.classList.add('status-final');
                }
            });
        });
    </script>
</asp:Content>
