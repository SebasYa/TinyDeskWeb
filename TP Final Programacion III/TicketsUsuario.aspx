<%@ Page Title="" Language="C#" MasterPageFile="~/UsuarioSite.Master" AutoEventWireup="true" CodeBehind="TicketsUsuario.aspx.cs" Inherits="TP_Final_Programacion_III.TicketsUsuario" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <div class="container-fluid tickets-workspace px-0 pt-2">

        <asp:Literal ID="litMensaje" runat="server"></asp:Literal>
        <asp:HiddenField ID="hdnIdTicket" runat="server" />

        <asp:Panel ID="pnlListado" runat="server" CssClass="tickets-list-view">
            <div class="ticket-page-heading d-flex justify-content-between align-items-start flex-wrap gap-3 mb-4">
                <div class="ticket-heading-copy">
                    <span class="ticket-eyebrow"><i class="bi bi-ticket-perforated"></i>Espacio de trabajo</span>
                    <h1 class="h2 fw-bold mb-1">Mis tickets</h1>
                    <p class="mb-0">Consultá los tickets que tenés asignados y sus fechas de vencimiento.</p>
                </div>

                <div class="ticket-context-chip">
                    <i class="bi bi-person-check"></i>
                    <span><strong>Tu trabajo</strong><small>Seguimiento personal</small></span>
                </div>
            </div>


            <!-- FILTRO RÁPIDO -->
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
            <div class="ticket-list-label d-flex align-items-center justify-content-between flex-wrap gap-2 mb-3">
                <div>
                    <h2 class="h5 fw-bold mb-1">Bandeja de tickets</h2>
                    <p class="mb-0">Prioridades, fechas y estado actual en una sola vista.</p>
                </div>
                <span class="ticket-list-hint"><i class="bi bi-arrows-angle-expand"></i>Detalle por ticket</span>
            </div>

            <div class="ticket-table-card table-responsive">

                <asp:ListView
                    ID="lvTickets"
                    runat="server"
                    ItemPlaceholderID="itemPlaceholder"
                    OnPagePropertiesChanging="lvTickets_PagePropertiesChanging">

                    <LayoutTemplate>

                        <table class="table ticket-table table-hover align-middle mb-0">

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

                        <tr data-ticket-row="true">

                            <td>
                                <div class="ticket-code fw-bold">
                                    TK-<%# Eval("Id").ToString().PadLeft(3, '0') %>
                                </div>

                                <div class="ticket-description small">
                                    <%# Eval("Descripcion") %>
                                </div>
                            </td>

                            <td>
                                <div class="ticket-project-name fw-semibold">
                                    <%# Eval("Sprint.Proyecto.Nombre") %>
                                </div>

                                <span class="badge bg-secondary-subtle text-secondary rounded-pill">Sprint <%# Eval("Sprint.NumeroSprint") %>
                                </span>
                            </td>

                            <td class="ticket-status-cell">
                                <span class='<%# GetClassEstado(Eval("Estado.Nombre"), Eval("Estado.EsFinal")) %>'>
                                    <%# Eval("Estado.Nombre") %>
                                </span>
                            </td>

                            <td class="ticket-priority-cell">
                                <span class='<%# GetClassPrioridad(Eval("Prioridad.Nombre")) %>'>
                                    <%# Eval("Prioridad.Nombre") %>
                                </span>
                            </td>

                            <td class="ticket-date-cell">
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

                            <td class="ticket-deadline-cell">
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
                        <div class="ticket-empty-state py-5">
                            <i class="bi bi-ticket-detailed"></i>
                            <strong>No hay tickets para mostrar</strong>
                            <span>No encontramos tickets que coincidan con los filtros seleccionados.</span>
                        </div>
                    </EmptyDataTemplate>

                </asp:ListView>

            </div>

            <!-- PAGINACIÓN -->
            <div class="ticket-pagination d-flex justify-content-center mt-4">

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

        <asp:Panel ID="pnlDetalle" runat="server" Visible="false" CssClass="ticket-detail-view">

            <div class="ticket-page-heading ticket-detail-heading d-flex justify-content-between align-items-center flex-wrap gap-3 mb-4">
                <div class="ticket-heading-copy">
                    <span class="ticket-eyebrow"><i class="bi bi-ticket-detailed"></i>Información del ticket</span>
                    <h2 class="mb-2 fw-bold">Detalle de ticket</h2>

                    <span class="badge bg-primary-subtle text-primary px-3 py-2 rounded-pill fw-semibold">
                        <asp:Label ID="lblTicketSprintProyecto" runat="server"></asp:Label>
                    </span>
                </div>

                <a href="TicketsUsuario.aspx" class="btn btn-outline-secondary ticket-back-action d-flex align-items-center justify-content-center gap-2">
                    <i class="bi bi-arrow-left"></i>
                    Volver al listado
                </a>
            </div>

            <div class="card ticket-detail-card border-0 mb-4">
                <div class="card-body p-4">

                    <h5 class="fw-bold text-dark mb-4">Información del Ticket</h5>

                    <div class="row g-3">

                        <div class="col-12">
                            <div class="ticket-description-panel">
                                <span class="text-uppercase text-muted fw-semibold d-block" style="font-size: 0.75rem; letter-spacing: 0.5px;">Descripción</span>

                                <strong class="text-dark fs-6">
                                    <asp:Label ID="lblDetalleDescripcion" runat="server"></asp:Label>
                                </strong>
                            </div>
                        </div>

                        <div class="col-6 col-md-3 ticket-detail-field ticket-detail-status">
                            <span class="text-uppercase text-muted fw-semibold d-block" style="font-size: 0.75rem; letter-spacing: 0.5px;">Estado</span>

                            <asp:Label ID="lblDetalleEstado" runat="server"></asp:Label>
                        </div>

                        <div class="col-6 col-md-3 ticket-detail-field ticket-detail-priority">
                            <span class="text-uppercase text-muted fw-semibold d-block" style="font-size: 0.75rem; letter-spacing: 0.5px;">Prioridad</span>

                            <asp:Label ID="lblDetallePrioridad" runat="server"></asp:Label>
                        </div>

                        <div class="col-6 col-md-3 ticket-detail-field">
                            <span class="text-uppercase text-muted fw-semibold d-block" style="font-size: 0.75rem; letter-spacing: 0.5px;">Fecha Inicio</span>

                            <strong class="text-dark fs-6">
                                <asp:Label ID="lblDetalleFechaInicio" runat="server"></asp:Label>
                            </strong>
                        </div>

                        <div class="col-6 col-md-3 ticket-detail-field">
                            <span class="text-uppercase text-muted fw-semibold d-block" style="font-size: 0.75rem; letter-spacing: 0.5px;">Fecha Estimada Fin</span>

                            <strong class="text-dark fs-6">
                                <asp:Label ID="lblDetalleFechaEstimadaFin" runat="server"></asp:Label>
                            </strong>
                        </div>

                        <div class="col-6 col-md-3 ticket-detail-field">
                            <span class="text-uppercase text-muted fw-semibold d-block" style="font-size: 0.75rem; letter-spacing: 0.5px;">Fecha Fin Real</span>

                            <strong class="text-dark fs-6">
                                <asp:Label ID="lblDetalleFechaFin" runat="server"></asp:Label>
                            </strong>
                        </div>

                        <div class="col-6 col-md-3 ticket-detail-field">
                            <span class="text-uppercase text-muted fw-semibold d-block" style="font-size: 0.75rem; letter-spacing: 0.5px;">Sprint</span>

                            <strong class="text-dark fs-6">
                                <asp:Label ID="lblDetalleSprint" runat="server"></asp:Label>
                            </strong>
                        </div>

                        <div class="col-6 col-md-3 ticket-detail-field">
                            <span class="text-uppercase text-muted fw-semibold d-block" style="font-size: 0.75rem; letter-spacing: 0.5px;">Proyecto</span>

                            <strong class="text-dark fs-6">
                                <asp:Label ID="lblDetalleProyecto" runat="server"></asp:Label>
                            </strong>
                        </div>

                    </div>

                    <asp:PlaceHolder ID="phAccionesTicket" runat="server">

                        <hr class="my-4" />

                        <div class="ticket-actions-panel row g-3 align-items-end">

                            <div class="col-12 col-md-5">
                                <label for="ddlEstadoTicket" class="form-label fw-semibold">Cambiar estado</label>

                                <asp:DropDownList ID="ddlEstadoTicket" runat="server" CssClass="form-select"></asp:DropDownList>
                            </div>

                            <div class="col-12 col-md-auto">
                                <asp:Button ID="btnCambiarEstado" runat="server" Text="Cambiar estado" CssClass="btn btn-primary" CausesValidation="false" OnClick="btnCambiarEstado_Click" />
                            </div>

                            <div class="col-12 col-md-auto">
                                <button type="button" class="btn ticket-finalize-action" data-bs-toggle="modal" data-bs-target="#finalizarTicketModal">
                                    <i class="bi bi-check2-circle me-1"></i>Finalizar ticket
                                </button>
                            </div>

                        </div>

                    </asp:PlaceHolder>

                </div>
            </div>

        </asp:Panel>
        <div class="modal fade" id="finalizarTicketModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content ticket-modal-content">
                    <div class="modal-header ticket-finalize-header">
                        <span class="ticket-finalize-icon"><i class="bi bi-check2-circle"></i></span>
                        <div class="me-auto"><span class="ticket-finalize-kicker">Cerrar ciclo de trabajo</span><h5 class="modal-title fw-bold mb-0">Finalizar ticket</h5>
                        </div>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                    </div>

                    <div class="modal-body p-4">
                        <div class="ticket-finalize-copy"><strong>¿Querés finalizar este ticket?</strong><span>Se registrará la fecha de finalización y el ticket no podrá volver a abrirse.</span></div>
                    </div>

                    <div class="modal-footer ticket-modal-footer">
                        <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancelar</button>

                        <asp:Button ID="btnFinalizarTicket" runat="server" CssClass="btn ticket-finalize-confirm" Text="Finalizar" CausesValidation="false" OnClick="btnFinalizarTicket_Click" />
                    </div>

                </div>
            </div>
        </div>
    </div>

    <style>
        :root {
            --tickets-sky: #93c0de;
            --tickets-aqua: #b9e5e5;
            --tickets-ink: #09232f;
            --tickets-muted: #75797e;
            --tickets-cloud: #e5e5e5;
            --tickets-violet: #65479b;
            --tickets-violet-soft: #eee7fa;
            --tickets-violet-line: #cbbbe8;
            --tickets-surface: #f3f7f8;
            --tickets-line: rgba(9, 35, 47, .11);
            --tickets-shadow: 0 18px 45px rgba(9, 35, 47, .075);
        }

        .app-main.tickets-app-surface {
            background: radial-gradient(circle at 92% 3%, rgba(147, 192, 222, .23), transparent 25rem), radial-gradient(circle at 15% 88%, rgba(185, 229, 229, .18), transparent 30rem), linear-gradient(180deg, #f7f9fa 0%, var(--tickets-surface) 100%);
        }

        .tickets-workspace {
            width: 100%;
            max-width: 1540px;
            margin-inline: auto;
            color: var(--tickets-ink);
        }

        .ticket-page-heading {
            position: relative;
            overflow: hidden;
            padding: clamp(1.35rem, 2.4vw, 2rem);
            border: 1px solid rgba(147, 192, 222, .38);
            border-radius: 1.35rem;
            background: linear-gradient(110deg, rgba(255, 255, 255, .94), rgba(245, 251, 252, .86));
            box-shadow: 0 14px 36px rgba(9, 35, 47, .055);
            isolation: isolate;
        }

            .ticket-page-heading::after {
                content: "";
                position: absolute;
                z-index: -1;
                width: 15rem;
                aspect-ratio: 1;
                right: -5rem;
                top: -8rem;
                border: 2.7rem solid rgba(185, 229, 229, .32);
                border-radius: 50%;
            }

        .ticket-heading-copy {
            max-width: 48rem;
        }

            .ticket-heading-copy h1,
            .ticket-heading-copy h2,
            .ticket-list-label h2,
            .tickets-workspace h5 {
                color: var(--tickets-ink) !important;
                letter-spacing: -.025em;
            }

            .ticket-heading-copy > p,
            .ticket-list-label p {
                color: var(--tickets-muted);
            }

        .ticket-eyebrow {
            display: inline-flex;
            align-items: center;
            gap: .45rem;
            margin-bottom: .65rem;
            color: #315a70;
            font-size: .72rem;
            font-weight: 800;
            letter-spacing: .1em;
            text-transform: uppercase;
        }

        .ticket-context-chip {
            display: flex;
            align-items: center;
            gap: .75rem;
            padding: .68rem .85rem;
            border: 1px solid rgba(147, 192, 222, .45);
            border-radius: .9rem;
            background: rgba(255, 255, 255, .78);
            color: #315f76;
        }

            .ticket-context-chip > i {
                display: grid;
                place-items: center;
                width: 2.45rem;
                height: 2.45rem;
                border-radius: .72rem;
                background: linear-gradient(145deg, rgba(147, 192, 222, .3), rgba(185, 229, 229, .4));
                font-size: 1.1rem;
            }

            .ticket-context-chip span {
                display: flex;
                flex-direction: column;
                line-height: 1.2;
            }

            .ticket-context-chip strong {
                color: var(--tickets-ink);
                font-size: .82rem;
            }

            .ticket-context-chip small {
                margin-top: .18rem;
                color: var(--tickets-muted);
                font-size: .68rem;
            }

        .tickets-workspace .btn {
            border-radius: .7rem;
            font-weight: 650;
        }

        .tickets-workspace .btn-primary {
            --bs-btn-bg: var(--tickets-ink);
            --bs-btn-border-color: var(--tickets-ink);
            --bs-btn-hover-bg: #123d4f;
            --bs-btn-hover-border-color: #123d4f;
            --bs-btn-active-bg: #061a23;
            --bs-btn-active-border-color: #061a23;
            color: #fff;
            box-shadow: 0 8px 18px rgba(9, 35, 47, .13);
        }

            .tickets-workspace .btn-primary:hover,
            .tickets-workspace .btn-primary:focus {
                color: #fff !important;
            }

        .tickets-workspace .btn-outline-primary {
            --bs-btn-color: #315a70;
            --bs-btn-border-color: rgba(49, 90, 112, .32);
            --bs-btn-hover-bg: var(--tickets-ink);
            --bs-btn-hover-border-color: var(--tickets-ink);
            --bs-btn-active-bg: var(--tickets-ink);
            --bs-btn-active-border-color: var(--tickets-ink);
        }

        .tickets-workspace .btn-outline-secondary {
            --bs-btn-color: #58646a;
            --bs-btn-border-color: rgba(88, 100, 106, .3);
            --bs-btn-hover-bg: var(--tickets-ink);
            --bs-btn-hover-border-color: var(--tickets-ink);
            --bs-btn-hover-color: #fff;
            --bs-btn-active-bg: var(--tickets-ink);
            --bs-btn-active-border-color: var(--tickets-ink);
        }

        .ticket-back-action:hover,
        .ticket-back-action:focus {
            border-color: var(--tickets-ink) !important;
            background: var(--tickets-ink) !important;
            color: #fff !important;
        }

        .ticket-filter-panel,
        .ticket-table-card,
        .ticket-detail-card {
            border: 1px solid rgba(9, 35, 47, .08) !important;
            border-radius: 1.25rem;
            background: rgba(255, 255, 255, .84);
            box-shadow: var(--tickets-shadow);
            backdrop-filter: blur(12px);
        }

            .ticket-filter-panel .form-label {
                margin-bottom: .55rem;
                color: #39515c;
                font-size: .78rem;
                letter-spacing: .025em;
            }

        .ticket-toggle {
            padding: .28rem;
            border: 1px solid var(--tickets-line);
            border-radius: .9rem;
            background: #edf3f4;
        }

            .ticket-toggle .btn {
                min-height: 40px;
                border-color: transparent;
                border-radius: .68rem !important;
                box-shadow: none;
            }

                .ticket-toggle .btn.active {
                    border-color: var(--tickets-ink);
                    background: var(--tickets-ink);
                    color: #fff;
                }

        .ticket-filter-note {
            min-height: 44px;
            display: flex;
            align-items: center;
            border: 1px solid rgba(147, 192, 222, .26);
            background: rgba(147, 192, 222, .09);
        }

        .ticket-search-group .input-group-text,
        .ticket-search-group .form-control,
        .ticket-filter-panel .form-select,
        .ticket-detail-card .form-select {
            min-height: 44px;
            border-color: rgba(9, 35, 47, .14);
            background-color: rgba(255, 255, 255, .92);
        }

        .ticket-search-group .input-group-text {
            border-radius: .75rem 0 0 .75rem;
            border-right: 0;
        }

        .ticket-search-group .form-control {
            border-left: 0;
            border-radius: 0 .75rem .75rem 0;
        }

        .ticket-search-group:focus-within {
            border-radius: .78rem;
            box-shadow: 0 0 0 .23rem rgba(147, 192, 222, .22);
        }

            .ticket-search-group:focus-within .input-group-text,
            .ticket-search-group:focus-within .form-control,
            .ticket-filter-panel .form-select:focus,
            .ticket-detail-card .form-select:focus {
                border-color: #75a9c9;
                box-shadow: none;
            }

        .ticket-list-label {
            padding-inline: .2rem;
        }

            .ticket-list-label p {
                font-size: .86rem;
            }

        .ticket-list-hint {
            display: inline-flex;
            align-items: center;
            gap: .45rem;
            padding: .48rem .72rem;
            border: 1px solid rgba(147, 192, 222, .42);
            border-radius: 999px;
            background: rgba(255, 255, 255, .72);
            color: #476878;
            font-size: .75rem;
            font-weight: 700;
        }

        .ticket-table-card {
            overflow: hidden;
        }

        .ticket-table {
            min-width: 1050px;
        }

            .ticket-table thead th {
                padding: .88rem 1rem;
                border-bottom-color: rgba(9, 35, 47, .1);
                background: #eaf1f3;
                color: #526873;
                font-size: .69rem;
                font-weight: 800;
                letter-spacing: .06em;
                text-transform: uppercase;
                white-space: nowrap;
            }

            .ticket-table tbody td {
                padding: 1rem;
                border-color: rgba(9, 35, 47, .07);
                color: #52646c;
                font-size: .85rem;
                vertical-align: middle;
            }

            .ticket-table tbody tr {
                transition: background-color .18s ease, transform .18s ease;
            }

        .tickets-js .ticket-table tbody tr {
            opacity: 0;
            transform: translateY(6px);
        }

            .tickets-js .ticket-table tbody tr.is-visible {
                opacity: 1;
                transform: none;
                transition: opacity .35s ease, transform .35s ease, background-color .18s ease;
            }

        .ticket-table tbody tr:hover {
            background: rgba(185, 229, 229, .14);
        }

        .ticket-code {
            color: var(--tickets-ink);
            letter-spacing: .02em;
        }

        .ticket-description {
            display: -webkit-box;
            overflow: hidden;
            max-width: 270px;
            margin-top: .25rem;
            color: #718087;
            line-height: 1.45;
            -webkit-box-orient: vertical;
            -webkit-line-clamp: 2;
        }

        .ticket-project-name {
            max-width: 210px;
            color: var(--tickets-ink);
        }

        .ticket-table .badge,
        .ticket-detail-card .badge {
            padding: .48rem .68rem;
            border: 1px solid transparent;
            font-size: .7rem;
            font-weight: 750;
            letter-spacing: .01em;
        }

        .tickets-workspace .bg-success-subtle {
            border-color: rgba(35, 134, 91, .18) !important;
            background: rgba(76, 175, 125, .14) !important;
            color: #237a55 !important;
        }

        .tickets-workspace .bg-primary-subtle {
            border-color: rgba(49, 95, 118, .18) !important;
            background: rgba(147, 192, 222, .22) !important;
            color: #315f76 !important;
        }

        .tickets-workspace .bg-warning-subtle {
            border-color: rgba(177, 137, 36, .17) !important;
            background: rgba(216, 184, 91, .16) !important;
            color: #80651d !important;
        }

        .tickets-workspace .bg-danger-subtle {
            border-color: rgba(184, 64, 77, .17) !important;
            background: rgba(224, 91, 105, .13) !important;
            color: #a23d49 !important;
        }

        .tickets-workspace .bg-secondary-subtle {
            border-color: rgba(105, 91, 161, .16) !important;
            background: rgba(130, 149, 217, .16) !important;
            color: #584d91 !important;
        }

        .ticket-status-cell .bg-primary-subtle,
        .ticket-detail-status .bg-primary-subtle {
            border-color: rgba(45, 132, 95, .18) !important;
            background: rgba(76, 175, 125, .14) !important;
            color: #237a55 !important;
        }

        .ticket-status-cell .bg-success-subtle,
        .ticket-detail-status .bg-success-subtle,
        .ticket-deadline-cell .bg-success-subtle {
            border-color: var(--tickets-violet-line) !important;
            background: var(--tickets-violet) !important;
            color: var(--tickets-violet-soft) !important;
        }

        .ticket-table .bg-light.text-secondary {
            border-color: rgba(66, 140, 153, .15) !important;
            background: rgba(185, 229, 229, .24) !important;
            color: #36727c !important;
        }

        .ticket-table .bg-warning.text-dark {
            border-color: rgba(177, 137, 36, .2) !important;
            background: #e8c96f !important;
            color: #4d3c0b !important;
        }

        .ticket-empty-state {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            gap: .3rem;
            min-height: 12rem;
            border: 1px dashed rgba(49, 95, 118, .26);
            border-radius: 1rem;
            background: rgba(255, 255, 255, .58);
            color: var(--tickets-muted);
            text-align: center;
        }

            .ticket-empty-state i {
                margin-bottom: .35rem;
                color: #5f91a9;
                font-size: 2rem;
            }

            .ticket-empty-state strong {
                color: var(--tickets-ink);
            }

            .ticket-empty-state span {
                font-size: .84rem;
            }

        .ticket-detail-card {
            overflow: hidden;
        }

        .ticket-description-panel {
            padding: 1.05rem 1.1rem;
            border-left: 3px solid var(--tickets-sky);
            border-radius: 0 .8rem .8rem 0;
            background: rgba(147, 192, 222, .09);
        }

            .ticket-description-panel strong {
                display: block;
                margin-top: .3rem;
                line-height: 1.55;
            }

        .ticket-detail-field {
            position: relative;
        }

            .ticket-detail-field::before {
                content: "";
                position: absolute;
                inset: 0 .75rem;
                z-index: -1;
                border: 1px solid rgba(9, 35, 47, .08);
                border-radius: .82rem;
                background: linear-gradient(145deg, rgba(255, 255, 255, .95), rgba(237, 245, 247, .82));
            }

            .ticket-detail-field > span,
            .ticket-detail-field > strong {
                display: block;
                margin: .9rem 1rem;
            }

                .ticket-detail-field > span + span,
                .ticket-detail-field > span + strong {
                    margin-top: -.48rem;
                }

        .ticket-actions-panel {
            margin: 0;
            padding: 1rem;
            border: 1px solid rgba(147, 192, 222, .24);
            border-radius: .95rem;
            background: rgba(185, 229, 229, .1);
        }

        .ticket-finalize-action {
            border: 1px solid rgba(101, 71, 155, .34);
            border-radius: .7rem;
            background: rgba(238, 231, 250, .72);
            color: var(--tickets-violet);
            font-weight: 700;
        }

            .ticket-finalize-action:hover,
            .ticket-finalize-action:focus {
                border-color: var(--tickets-violet);
                background: var(--tickets-violet);
                color: var(--tickets-violet-soft);
            }

        .ticket-pagination .btn {
            border-radius: .65rem;
        }

        .ticket-modal-content {
            overflow: hidden;
            border: 1px solid rgba(9, 35, 47, .1) !important;
            border-radius: 1.15rem;
            box-shadow: 0 28px 80px rgba(9, 35, 47, .24);
        }

        .ticket-modal-footer {
            border-color: rgba(9, 35, 47, .08);
            background: #f2f7f8;
        }

            .ticket-modal-footer .btn {
                min-height: 42px;
                border-radius: .7rem;
                font-weight: 700;
            }

        .ticket-finalize-header {
            padding: 1.1rem 1.25rem;
            border-bottom: 1px solid rgba(101, 71, 155, .14);
            background: linear-gradient(105deg, #faf8fd, var(--tickets-violet-soft));
        }

        .ticket-finalize-icon {
            display: grid;
            flex: 0 0 auto;
            place-items: center;
            width: 2.65rem;
            height: 2.65rem;
            margin-right: .75rem;
            border: 1px solid rgba(101, 71, 155, .18);
            border-radius: .8rem;
            background: rgba(101, 71, 155, .12);
            color: var(--tickets-violet);
            font-size: 1.15rem;
        }

        .ticket-finalize-kicker {
            display: block;
            margin-bottom: .12rem;
            color: #765aa6;
            font-size: .62rem;
            font-weight: 850;
            letter-spacing: .09em;
            text-transform: uppercase;
        }

        .ticket-finalize-copy {
            display: flex;
            flex-direction: column;
            gap: .3rem;
            padding: 1rem;
            border: 1px solid rgba(101, 71, 155, .14);
            border-radius: .9rem;
            background: rgba(238, 231, 250, .42);
        }

            .ticket-finalize-copy strong {
                color: var(--tickets-ink);
            }

            .ticket-finalize-copy span {
                color: #6d6872;
                font-size: .82rem;
                line-height: 1.5;
            }

        .ticket-finalize-confirm {
            border-color: var(--tickets-violet) !important;
            background: var(--tickets-violet) !important;
            color: var(--tickets-violet-soft) !important;
            box-shadow: 0 8px 18px rgba(101, 71, 155, .18);
        }

            .ticket-finalize-confirm:hover,
            .ticket-finalize-confirm:focus {
                border-color: #52377f !important;
                background: #52377f !important;
                color: #fff !important;
            }

        @media (max-width: 767.98px) {
            .ticket-context-chip {
                display: none;
            }

            .ticket-filter-panel .btn,
            .ticket-detail-heading .ticket-back-action {
                min-height: 42px;
            }

            .ticket-table {
                min-width: 980px;
            }

            .ticket-detail-field {
                min-height: 96px;
            }
        }

        @media (max-width: 575.98px) {
            .ticket-page-heading {
                border-radius: 1rem;
            }

            .ticket-detail-heading .ticket-back-action {
                width: 100%;
            }

            .ticket-list-hint {
                display: none;
            }

            .ticket-detail-card .card-body {
                padding: 1.25rem !important;
            }

            .ticket-detail-field {
                min-height: 104px;
            }
        }

        @media (prefers-reduced-motion: reduce) {
            .tickets-js .ticket-table tbody tr,
            .tickets-js .ticket-table tbody tr.is-visible {
                opacity: 1;
                transform: none;
                transition: none;
            }
        }
    </style>

    <script type="text/javascript">
        document.addEventListener('DOMContentLoaded', function () {
            var appMain = document.querySelector('.app-main');
            if (appMain && document.querySelector('.tickets-workspace')) {
                appMain.classList.add('tickets-app-surface', 'tickets-js');
            }

            var rows = document.querySelectorAll('[data-ticket-row]');
            var reducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

            if (!reducedMotion && 'IntersectionObserver' in window) {
                var rowObserver = new IntersectionObserver(function (entries, observer) {
                    entries.forEach(function (entry) {
                        if (entry.isIntersecting) {
                            entry.target.classList.add('is-visible');
                            observer.unobserve(entry.target);
                        }
                    });
                }, { threshold: 0.08 });

                rows.forEach(function (row, index) {
                    row.style.transitionDelay = Math.min(index * 35, 210) + 'ms';
                    rowObserver.observe(row);
                });
            } else {
                rows.forEach(function (row) {
                    row.classList.add('is-visible');
                });
            }
        });
    </script>

</asp:Content>
