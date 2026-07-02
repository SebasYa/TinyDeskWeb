<%@ Page Title="Gestión de Sprints" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Sprints.aspx.cs" Inherits="TP_Final_Programacion_III.Sprints" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-4">
        <asp:Literal ID="litMensaje" runat="server"></asp:Literal>
        <asp:Panel ID="pnlListadoSprints" runat="server">
            <div class="row">
                <!--<div class="col-6">
                    <div class="mb-3">
                        <!--<asp:Label Text="Filtrar" runat="server" />
                        <asp:TextBox runat="server" ID="txtFiltroSprints" CssClass="form-control" placeholder="Filtrar por Proyecto" AutoPostBack="true" OnTextChanged="txtFiltroSprints_TextChanged" />
                    </div>
                </div>-->
                <div class="ticket-page-heading d-flex justify-content-between align-items-start flex-wrap gap-3 mb-4">
                    <div class="ticket-heading-copy">
                        <span class="ticket-eyebrow"><i class="bi bi-ticket-perforated"></i>Espacio de trabajo</span>
                        <h1 class="h2 fw-bold mb-1">Mis sprints</h1>
                        <p class="mb-0">Consultá los sprints que tenés asignados y sus fechas de vencimiento.</p>
                    </div>

                    <div class="ticket-context-chip">
                        <i class="bi bi-person-check"></i>
                        <span><strong>Tu trabajo</strong><small>Seguimiento personal</small></span>
                    </div>
                </div>
                <div class="col-6 d-flex align-items-center flex-row-reverse">
                    <button type="button" class="btn btn-primary shadow-sm d-flex align-items-center gap-2" data-bs-toggle="modal" data-bs-target="#sprintModal">
                        <i class="bi bi-plus-circle"></i>Crear Sprint
                    </button>
                </div>

            </div>

            <div class="modal fade" id="sprintModal" tabindex="-1" aria-labelledby="sprintModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <div class="modal-header bg-light">
                            <h5 class="modal-title fw-bold" id="sprintModalLabel">Nuevo Sprint</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
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
                        <div class="modal-footer bg-light">
                            <asp:Button ID="btnCerrarSprint" runat="server" CssClass="btn btn-secondary" Text="Cancelar" OnClick="btnCerrarSprint_Click" UseSubmitBehavior="false" />
                            <asp:Button ID="btnGuardarSprint" runat="server" CssClass="btn btn-primary" Text="Guardar Sprint" OnClientClick="return validarSprintModal();" OnClick="btnGuardarSprint_Click" />
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
            <div class="table-responsive">

                <asp:ListView ID="lvSprints" runat="server" ItemPlaceholderID="itemPlaceholder" OnItemCommand="lvSprints_ItemCommand" OnPagePropertiesChanging="lvSprints_PagePropertiesChanging">

                    <LayoutTemplate>
                        <table class="table table-hover align-middle bg-white border-0 shadow-sm rounded mb-0">

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
                        <tr>

                            <td>
                                <span class="text-dark fw-bold">Sprint <%# Eval("NumeroSprint") %></span>
                            </td>

                            <td>
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

                            <td style="width: 180px;">
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

                            <td>
                                <div class="d-flex gap-2">

                                    <asp:LinkButton ID="btnVerSprint" runat="server" CommandName="VerDetalle" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-sm btn-outline-primary" ToolTip="Ver Sprint">
                            <i class="bi bi-eye"></i>
                                    </asp:LinkButton>

                                    <asp:LinkButton ID="btnEditarSprint" runat="server" CommandName="EditarSprint" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-sm btn-outline-secondary" ToolTip="Editar Sprint">
                            <i class="bi bi-pencil"></i>
                                    </asp:LinkButton>

                                    <asp:LinkButton ID="btnAbrirModalEliminar" runat="server" CssClass="btn btn-sm btn-outline-danger" OnClientClick='<%# "abrirModalEliminar(" + Eval("Id") + "); return false;" %>' ToolTip="Eliminar Sprint">
                            <i class="bi bi-trash"></i>
                                    </asp:LinkButton>

                                    <asp:LinkButton ID="btnFinalizarSprint" runat="server" CommandName="Finalizar" CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-sm btn-outline-success" ToolTip="Finalizar Sprint" Visible='<%# !(bool)Eval("Estado.EsFinal") %>'>
                            <i class="bi bi-check-circle"></i>
                                    </asp:LinkButton>
                                </div>
                            </td>

                        </tr>
                    </ItemTemplate>

                    <EmptyDataTemplate>
                        <div class="alert alert-info">No hay sprints para mostrar.</div>
                    </EmptyDataTemplate>

                </asp:ListView>

            </div>
            <div class="d-flex justify-content-center mt-4">
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
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <div class="modal-header bg-light">
                            <h5 class="modal-title fw-bold" id="sprintEditarModalLabel">
                                <asp:Label ID="lblModalEditarTitulo" runat="server" Text="Editar Sprint"></asp:Label>
                            </h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
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
                        <div class="modal-footer bg-light">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                            <asp:Button ID="btnGuardarEdicion" runat="server" CssClass="btn btn-primary" Text="Guardar Sprint" OnClientClick="return validarSprintModal();" OnClick="btnGuardarEdicion_Click" />
                        </div>
                    </div>
                </div>
            </div>
        </asp:Panel>
        <asp:Panel ID="pnlDetalleSprint" runat="server">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="mb-1 fw-bold text-dark">
                        <asp:Label ID="lblDetalleTituloSprint" runat="server" Text="Detalle de Sprint"></asp:Label>
                    </h2>
                    <span class="badge bg-primary-subtle text-primary px-3 py-2 rounded-pill fw-semibold">
                        <asp:Label ID="lblSprintProyectoArea" runat="server" Text="Proyecto / Área"></asp:Label>
                    </span>
                </div>

                <div class="d-flex gap-2">
                    <a href="Sprints.aspx" class="btn btn-primary d-flex align-items-center gap-2">
                        <i class="bi bi-arrow-left"></i>Volver al listado
                    </a>
                </div>
            </div>

            <div class="card border-0 shadow-sm mb-5" style="border-radius: 12px; border: 1px solid #f0f2f5 !important;">
                <div class="card-body p-4">
                    <h5 class="fw-bold text-dark mb-4">Información del Sprint</h5>

                    <div class="row g-3">
                        <div class="col-6 col-md-3">
                            <span class="text-uppercase text-muted fw-semibold d-block text-xs" style="font-size: 0.75rem; letter-spacing: 0.5px;">Fecha Inicio</span>
                            <strong class="text-dark fs-6">
                                <asp:Label ID="lblDetalleFechaInicio" runat="server"></asp:Label></strong>
                        </div>
                        <div class="col-6 col-md-3">
                            <span class="text-uppercase text-muted fw-semibold d-block text-xs" style="font-size: 0.75rem; letter-spacing: 0.5px;">Fecha Estimada Fin</span>
                            <strong class="text-dark fs-6">
                                <asp:Label ID="lblDetalleFechaEstimadaFin" runat="server"></asp:Label></strong>
                        </div>
                        <div class="col-6 col-md-3">
                            <span class="text-uppercase text-muted fw-semibold d-block text-xs" style="font-size: 0.75rem; letter-spacing: 0.5px;">Fecha Fin Real</span>
                            <strong class="text-dark fs-6">
                                <asp:Label ID="lblDetalleFechaFin" runat="server" Text="-"></asp:Label></strong>
                        </div>
                        <div class="col-6 col-md-3">
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

            <div class="bg-white rounded-3 shadow-sm border-0 overflow-hidden" style="border: 1px solid #f0f2f5 !important;">

                <asp:ListView ID="lvTicketsDelSprint" runat="server" ItemPlaceholderID="itemPlaceholder" OnPagePropertiesChanging="lvTicketsDelSprint_PagePropertiesChanging">

                    <LayoutTemplate>
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">

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
                        <tr>

                            <td>
                                <a href='Tickets.aspx?id=<%# Eval("Id") %>' class="text-primary fw-bold text-decoration-none">TK-<%# Eval("Id").ToString().PadLeft(3, '0') %>
                                </a>
                            </td>

                            <td>
                                <span class="text-dark"><%# Eval("Descripcion") %></span>
                            </td>

                            <td>
                                <span class='<%# GetClassEtiquetaPrioridad(Eval("Prioridad.Nombre")) %>'><%# Eval("Prioridad.Nombre") %></span>
                            </td>

                            <td>
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
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title">Confirmar Eliminación</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p>¿Estás seguro de que deseas eliminar este Sprint? Esta acción no se puede deshacer.</p>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Motivo de la eliminación:</label>
                        <asp:TextBox ID="txtMotivoEliminacion" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="2"></asp:TextBox>
                        <div id="errorEliminacion" class="text-danger small" style="display: none;">Debe ingresar un motivo.</div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <asp:Button ID="btnConfirmarEliminacion" runat="server" CssClass="btn btn-danger" Text="Sí, eliminar" OnClick="btnEliminar_Click" OnClientClick="return validarEliminacion();" />
                </div>
            </div>
        </div>
    </div>
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
    </script>
</asp:Content>
