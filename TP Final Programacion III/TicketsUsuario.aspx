<%@ Page Title="" Language="C#" MasterPageFile="~/UsuarioSite.Master" AutoEventWireup="true" CodeBehind="TicketsUsuario.aspx.cs" Inherits="TP_Final_Programacion_III.TicketsUsuario" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="container mt-4">

        <asp:Literal ID="litMensaje" runat="server"></asp:Literal>
        <asp:HiddenField ID="hdnIdTicket" runat="server" />

        <asp:Panel ID="pnlListado" runat="server">
            <div class="mb-4">
                <h1 class="h2 fw-bold text-dark mb-1">Mis tickets</h1>
                <p class="text-muted mb-0">Consultá los tickets que tenés asignados y sus fechas de vencimiento.</p>
            </div>


            <!-- FILTRO RÁPIDO -->
            <div class="card border-0 shadow-sm mb-4">
                <div class="card-body">

                    <div class="row g-3 align-items-end">

                        <div class="col-12 col-lg-4">
                            <label class="form-label fw-semibold">Vista rápida</label>

                            <div class="d-flex gap-2">

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
                            <div class="bg-light border rounded-3 px-3 py-2">
                                <div class="small text-muted">
                                    Los períodos muestran tickets pendientes que vencen desde hoy.
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
                CssClass="card border-0 shadow-sm mb-4"
                DefaultButton="btnAplicarFiltros">

                <div class="card-body">

                    <div class="row g-3 align-items-end">

                        <div class="col-12 col-lg-5">
                            <label for="txtFiltro" class="form-label fw-semibold">
                                Buscar
                            </label>

                            <div class="input-group">
                                <span class="input-group-text bg-white">
                                    <i class="bi bi-search text-muted"></i>
                                </span>

                                <asp:TextBox
                                    ID="txtFiltro"
                                    runat="server"
                                    CssClass="form-control"
                                    placeholder="Número, descripción, proyecto o sprint..." />
                            </div>
                        </div>

                        <div class="col-12 col-md-5 col-lg-2">
                            <label for="ddlPrioridad" class="form-label fw-semibold">
                                Prioridad
                            </label>

                            <asp:DropDownList
                                ID="ddlPrioridad"
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
                                <asp:ListItem Text="Prioridad" Value="prioridad" />
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

            <!-- LISTADO -->
            <div class="table-responsive">

                <asp:ListView
                    ID="lvTickets"
                    runat="server"
                    ItemPlaceholderID="itemPlaceholder"
                    OnPagePropertiesChanging="lvTickets_PagePropertiesChanging">

                    <LayoutTemplate>

                        <table class="table table-hover align-middle bg-white border-0 shadow-sm rounded mb-0">

                            <thead class="table-light text-secondary fw-semibold">
                                <tr>
                                    <th>Ticket</th>
                                    <th>Proyecto / Sprint</th>
                                    <th>Estado</th>
                                    <th>Prioridad</th>
                                    <th>Fechas</th>
                                    <th>Vencimiento</th>
                                    <th>Detalle</th>
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
                                <div class="fw-bold text-dark">
                                    TK-<%# Eval("Id").ToString().PadLeft(3, '0') %>
                                </div>

                                <div class="small text-muted" style="max-width: 260px;">
                                    <%# Eval("Descripcion") %>
                                </div>
                            </td>

                            <td>
                                <div class="fw-semibold text-dark">
                                    <%# Eval("Sprint.Proyecto.Nombre") %>
                                </div>

                                <span class="badge bg-secondary-subtle text-secondary rounded-pill">Sprint <%# Eval("Sprint.NumeroSprint") %>
                                </span>
                            </td>

                            <td>
                                <span class='<%# GetClassEstado(Eval("Estado.Nombre"), Eval("Estado.EsFinal")) %>'>
                                    <%# Eval("Estado.Nombre") %>
                                </span>
                            </td>

                            <td>
                                <span class='<%# GetClassPrioridad(Eval("Prioridad.Nombre")) %>'>
                                    <%# Eval("Prioridad.Nombre") %>
                                </span>
                            </td>

                            <td>
                                <div class="small">
                                    <span class="text-muted">Inicio:</span>
                                    <%# Eval("FechaInicio", "{0:dd/MM/yyyy}") %>
                                </div>

                                <div class="small">
                                    <span class="text-muted">Estimado:</span>
                                    <%# Eval("FechaEstimadaFin", "{0:dd/MM/yyyy}") %>
                                </div>

                                <div class="small">
                                    <span class="text-muted">Fin:</span>
                                    <%# FormatearFechaFin(Eval("FechaFin")) %>
                                </div>
                            </td>

                            <td>
                                <span class='<%# GetClassVencimiento(Eval("FechaEstimadaFin"), Eval("Estado.EsFinal")) %>'>
                                    <%# GetTextoVencimiento(Eval("FechaEstimadaFin"), Eval("FechaFin"), Eval("Estado.EsFinal")) %>
                                </span>
                            </td>

                            <td>
                                <asp:LinkButton
                                    ID="btnVerTicket"
                                    runat="server"
                                    CssClass="btn btn-sm btn-outline-primary"
                                    CommandArgument='<%# Eval("Id") %>'
                                    CausesValidation="false"
                                    OnClick="btnVerTicket_Click">

                                <i class="bi bi-eye me-1"></i>
                                Ver

                                </asp:LinkButton>
                            </td>

                        </tr>

                    </ItemTemplate>

                    <EmptyDataTemplate>
                        <div class="alert alert-info">
                            No hay tickets que coincidan con los filtros seleccionados.
                        </div>
                    </EmptyDataTemplate>

                </asp:ListView>

            </div>

            <!-- PAGINACIÓN -->
            <div class="d-flex justify-content-center mt-4">

                <asp:DataPager
                    ID="dpTickets"
                    runat="server"
                    PagedControlID="lvTickets"
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
        </asp:Panel>
        <!-- DETALLE -->

        <asp:Panel ID="pnlDetalle" runat="server" Visible="false">

            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="mb-1 fw-bold text-dark">Detalle de Ticket</h2>

                    <span class="badge bg-primary-subtle text-primary px-3 py-2 rounded-pill fw-semibold">
                        <asp:Label ID="lblTicketSprintProyecto" runat="server"></asp:Label>
                    </span>
                </div>

                <a href="TicketsUsuario.aspx" class="btn btn-primary d-flex align-items-center gap-2">
                    <i class="bi bi-arrow-left"></i>
                    Volver al listado
                </a>
            </div>

            <div class="card border-0 shadow-sm mb-4" style="border-radius: 12px; border: 1px solid #f0f2f5 !important;">
                <div class="card-body p-4">

                    <h5 class="fw-bold text-dark mb-4">Información del Ticket</h5>

                    <div class="row g-3">

                        <div class="col-12">
                            <span class="text-uppercase text-muted fw-semibold d-block" style="font-size: 0.75rem; letter-spacing: 0.5px;">Descripción</span>

                            <strong class="text-dark fs-6">
                                <asp:Label ID="lblDetalleDescripcion" runat="server"></asp:Label>
                            </strong>
                        </div>

                        <div class="col-6 col-md-3">
                            <span class="text-uppercase text-muted fw-semibold d-block" style="font-size: 0.75rem; letter-spacing: 0.5px;">Estado</span>

                            <asp:Label ID="lblDetalleEstado" runat="server"></asp:Label>
                        </div>

                        <div class="col-6 col-md-3">
                            <span class="text-uppercase text-muted fw-semibold d-block" style="font-size: 0.75rem; letter-spacing: 0.5px;">Prioridad</span>

                            <asp:Label ID="lblDetallePrioridad" runat="server"></asp:Label>
                        </div>

                        <div class="col-6 col-md-3">
                            <span class="text-uppercase text-muted fw-semibold d-block" style="font-size: 0.75rem; letter-spacing: 0.5px;">Fecha Inicio</span>

                            <strong class="text-dark fs-6">
                                <asp:Label ID="lblDetalleFechaInicio" runat="server"></asp:Label>
                            </strong>
                        </div>

                        <div class="col-6 col-md-3">
                            <span class="text-uppercase text-muted fw-semibold d-block" style="font-size: 0.75rem; letter-spacing: 0.5px;">Fecha Estimada Fin</span>

                            <strong class="text-dark fs-6">
                                <asp:Label ID="lblDetalleFechaEstimadaFin" runat="server"></asp:Label>
                            </strong>
                        </div>

                        <div class="col-6 col-md-3">
                            <span class="text-uppercase text-muted fw-semibold d-block" style="font-size: 0.75rem; letter-spacing: 0.5px;">Fecha Fin Real</span>

                            <strong class="text-dark fs-6">
                                <asp:Label ID="lblDetalleFechaFin" runat="server"></asp:Label>
                            </strong>
                        </div>

                        <div class="col-6 col-md-3">
                            <span class="text-uppercase text-muted fw-semibold d-block" style="font-size: 0.75rem; letter-spacing: 0.5px;">Sprint</span>

                            <strong class="text-dark fs-6">
                                <asp:Label ID="lblDetalleSprint" runat="server"></asp:Label>
                            </strong>
                        </div>

                        <div class="col-6 col-md-3">
                            <span class="text-uppercase text-muted fw-semibold d-block" style="font-size: 0.75rem; letter-spacing: 0.5px;">Proyecto</span>

                            <strong class="text-dark fs-6">
                                <asp:Label ID="lblDetalleProyecto" runat="server"></asp:Label>
                            </strong>
                        </div>

                    </div>

                    <asp:PlaceHolder ID="phAccionesTicket" runat="server">

                        <hr class="my-4" />

                        <div class="row g-3 align-items-end">

                            <div class="col-12 col-md-5">
                                <label for="ddlEstadoTicket" class="form-label fw-semibold">Cambiar estado</label>

                                <asp:DropDownList ID="ddlEstadoTicket" runat="server" CssClass="form-select"></asp:DropDownList>
                            </div>

                            <div class="col-12 col-md-auto">
                                <asp:Button ID="btnCambiarEstado" runat="server" Text="Cambiar estado" CssClass="btn btn-primary" CausesValidation="false" OnClick="btnCambiarEstado_Click" />
                            </div>

                            <div class="col-12 col-md-auto">
                                <button type="button" class="btn btn-success" data-bs-toggle="modal" data-bs-target="#finalizarTicketModal">
                                    Finalizar ticket
                                </button>
                            </div>

                        </div>

                    </asp:PlaceHolder>

                </div>
            </div>

        </asp:Panel>
        <div class="modal fade" id="finalizarTicketModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content border-success">
                    <div class="modal-header bg-success-subtle">
                        <h5 class="modal-title fw-bold text-success">Finalizar ticket</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>

                    <div class="modal-body">
                        <p class="mb-2 text-black">¿Querés finalizar este ticket?</p>

                        <p class="text-danger small mb-0">
                            Se registrará la fecha de finalización y el ticket no podrá volver a abrirse.
                        </p>
                    </div>

                    <div class="modal-footer bg-light">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>

                        <asp:Button ID="btnFinalizarTicket" runat="server" CssClass="btn btn-success" Text="Finalizar" CausesValidation="false" OnClick="btnFinalizarTicket_Click" />
                    </div>

                </div>
            </div>
        </div>
    </div>

</asp:Content>
