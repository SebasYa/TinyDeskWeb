<%@ Page Title="Reasignar tickets" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="TicketsUsuariosDesactivados.aspx.cs" Inherits="TP_Final_Programacion_III.TicketsUsuariosDesactivados" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container-fluid inactive-tickets-workspace px-0 pt-2">
        <div class="inactive-ticket-messages" aria-live="polite">
            <asp:Literal ID="litMensajeAccion" runat="server"></asp:Literal>
            <asp:Literal ID="litMensajeEstado" runat="server"></asp:Literal>
        </div>

        <section class="inactive-hero d-flex justify-content-between align-items-start flex-wrap gap-4 mb-4">
            <div class="inactive-hero-copy">
                <span class="inactive-eyebrow"><i class="bi bi-shield-exclamation"></i>Continuidad operativa</span>
                <h1 class="h2 fw-bold mb-2">Tickets pendientes de reasignación</h1>
                <p class="mb-0">Resolvé asignaciones interrumpidas y mantené el trabajo de cada proyecto en movimiento.</p>
            </div>

            <div class="inactive-hero-actions d-flex align-items-center flex-wrap gap-3">
                <div class="inactive-context-chip">
                    <span class="inactive-context-icon"><i class="bi bi-person-x"></i></span>
                    <span><strong>Revisión requerida</strong><small>Usuarios desactivados</small></span>
                </div>

                <div class="ai-action-wrap">
                    <i class="bi bi-stars" aria-hidden="true"></i>
                    <asp:Button ID="btnReasignarConIA" runat="server" CssClass="btn inactive-ai-button" Text="Reasignar con IA" OnClick="btnReasignarConIA_Click" />
                </div>
            </div>
        </section>

        <section class="inactive-guidance row g-3 mb-4" aria-label="Proceso de reasignación">
            <div class="col-12 col-md-4">
                <div class="inactive-guidance-item h-100">
                    <span class="inactive-guidance-number">01</span>
                    <span><strong>Detectá el bloqueo</strong><small>Identificá el ticket y su contexto actual.</small></span>
                </div>
            </div>
            <div class="col-12 col-md-4">
                <div class="inactive-guidance-item h-100">
                    <span class="inactive-guidance-number">02</span>
                    <span><strong>Elegí un responsable</strong><small>Asigná manualmente o revisá la sugerencia.</small></span>
                </div>
            </div>
            <div class="col-12 col-md-4">
                <div class="inactive-guidance-item h-100">
                    <span class="inactive-guidance-number">03</span>
                    <span><strong>Restablecé el flujo</strong><small>La persona elegida recibe la notificación.</small></span>
                </div>
            </div>
        </section>

        <section class="inactive-list-section">
            <div class="inactive-list-heading d-flex align-items-end justify-content-between flex-wrap gap-3 mb-3">
                <div>
                    <span class="inactive-section-label">Bandeja de revisión</span>
                    <h2 class="h5 fw-bold mb-1">Asignaciones que requieren atención</h2>
                    <p class="mb-0">Revisá responsable, proyecto, prioridad, estado y fechas antes de reasignar.</p>
                </div>
                <span class="inactive-list-hint"><i class="bi bi-arrow-repeat"></i>Acción individual o asistida</span>
            </div>

            <div class="inactive-table-card table-responsive">
                <asp:ListView
                    ID="lvTickets"
                    runat="server"
                    ItemPlaceholderID="itemPlaceholder"
                    OnPagePropertiesChanging="lvTickets_PagePropertiesChanging">

                    <LayoutTemplate>
                        <table class="table inactive-ticket-table table-hover align-middle mb-0">
                            <thead>
                                <tr>
                                    <th>Ticket</th>
                                    <th>Usuario desactivado</th>
                                    <th>Área / Puesto</th>
                                    <th>Proyecto / Sprint</th>
                                    <th>Prioridad</th>
                                    <th>Estado</th>
                                    <th>Fechas</th>
                                    <th class="text-end">Acción</th>
                                </tr>
                            </thead>
                            <tbody>
                                <asp:PlaceHolder ID="itemPlaceholder" runat="server" />
                            </tbody>
                        </table>
                    </LayoutTemplate>

                    <ItemTemplate>
                        <tr data-inactive-ticket-row="true">
                            <td>
                                <span class="inactive-ticket-code">TK-<%# Eval("Id").ToString().PadLeft(3, '0') %></span>
                                <small class="inactive-ticket-caption">Pendiente de responsable</small>
                            </td>

                            <td>
                                <div class="inactive-user-cell">
                                    <span class="inactive-user-avatar"><i class="bi bi-person-x"></i></span>
                                    <span>
                                        <strong><%# Eval("Usuario.Nombre") %> <%# Eval("Usuario.Apellido") %></strong>
                                        <small><%# Eval("Usuario.Email") %></small>
                                    </span>
                                </div>
                            </td>

                            <td>
                                <span class="inactive-area-badge"><i class="bi bi-diagram-3"></i><%# Eval("Usuario.Area.Nombre") %></span>
                                <small class="inactive-role-copy"><%# Eval("Usuario.Puesto.Nombre") %><%# Eval("Usuario.Seniority") != null ? " · " + Eval("Usuario.Seniority.Nombre") : "" %></small>
                            </td>

                            <td>
                                <strong class="inactive-project-name"><%# Eval("Sprint.Proyecto.Nombre") %></strong>
                                <small class="inactive-sprint-copy">Sprint <%# Eval("Sprint.NumeroSprint") %></small>
                            </td>

                            <td class="priority-cell">
                                <span class='<%# GetClassPrioridad(Eval("Prioridad.Nombre")) %>'><%# Eval("Prioridad.Nombre") %></span>
                            </td>

                            <td class="status-cell">
                                <span class='<%# GetClassEstado(Eval("Estado.Nombre")) %>'><%# Eval("Estado.Nombre") %></span>
                            </td>

                            <td>
                                <span class="inactive-date-range"><i class="bi bi-calendar3"></i><%# Convert.ToDateTime(Eval("FechaInicio")).ToString("dd/MM/yyyy") %></span>
                                <small class="inactive-date-end">Hasta <%# Convert.ToDateTime(Eval("FechaEstimadaFin")).ToString("dd/MM/yyyy") %></small>
                            </td>

                            <td class="text-end">
                                <asp:LinkButton
                                    ID="btnReasignarTicket"
                                    runat="server"
                                    CssClass="btn btn-sm inactive-reassign-button"
                                    CommandArgument='<%# Eval("Id") %>'
                                    CausesValidation="false"
                                    OnClick="btnReasignarTicket_Click">
                                    <i class="bi bi-person-gear me-1"></i>Reasignar
                                </asp:LinkButton>
                            </td>
                        </tr>
                    </ItemTemplate>

                    <EmptyDataTemplate>
                        <div class="inactive-empty-state">
                            <span class="inactive-empty-icon"><i class="bi bi-check2-circle"></i></span>
                            <strong>No hay asignaciones pendientes</strong>
                            <span>Todos los tickets tienen una persona activa responsable.</span>
                        </div>
                    </EmptyDataTemplate>
                </asp:ListView>
            </div>

            <div class="inactive-pagination d-flex justify-content-center mt-4">
                <asp:DataPager ID="dpTickets" runat="server" PagedControlID="lvTickets" PageSize="8">
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
        </section>

        <div class="modal fade inactive-modal" id="reasignarTicketModal" tabindex="-1" aria-labelledby="reasignarTicketModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
                <div class="modal-content">
                    <div class="modal-header inactive-modal-header">
                        <div class="d-flex align-items-center gap-3">
                            <span class="inactive-modal-icon"><i class="bi bi-person-gear"></i></span>
                            <div>
                                <span class="inactive-modal-kicker">Reasignación individual</span>
                                <h2 class="modal-title h5 fw-bold mb-0" id="reasignarTicketModalLabel">
                                    <asp:Label ID="lblTituloReasignar" runat="server" Text="Reasignar Ticket"></asp:Label>
                                </h2>
                            </div>
                        </div>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                    </div>

                    <div class="modal-body p-4 p-lg-5">
                        <asp:HiddenField ID="hfIdTicketReasignar" runat="server" />

                        <div class="inactive-modal-intro mb-4">
                            <i class="bi bi-info-circle"></i>
                            <p class="mb-0">Elegí una persona activa del mismo ámbito de trabajo para recuperar la continuidad del ticket.</p>
                        </div>

                        <div class="inactive-current-user mb-4">
                            <span class="inactive-block-label">Asignación actual</span>
                            <asp:Literal ID="litDetalleReasignacion" runat="server"></asp:Literal>
                        </div>

                        <div class="inactive-select-panel">
                            <label for="ddlNuevoUsuario" class="form-label fw-bold">Nuevo usuario asignado</label>
                            <p class="small mb-3">Solo se muestran personas activas compatibles con el área y el puesto del ticket.</p>
                            <asp:DropDownList ID="ddlNuevoUsuario" runat="server" CssClass="form-select form-select-lg inactive-user-select">
                            </asp:DropDownList>
                        </div>
                    </div>

                    <div class="modal-footer inactive-modal-footer">
                        <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancelar</button>
                        <asp:Button ID="btnConfirmarReasignacion" runat="server"
                            CssClass="btn inactive-confirm-button"
                            Text="Guardar reasignación"
                            OnClick="btnConfirmarReasignacion_Click" />
                    </div>
                </div>
            </div>
        </div>

        <div class="modal fade inactive-modal inactive-ai-modal" id="modalReasignarConIA" tabindex="-1" aria-labelledby="modalReasignarConIALabel" aria-hidden="true">
            <div class="modal-dialog modal-xl modal-dialog-centered modal-dialog-scrollable">
                <div class="modal-content">
                    <div class="modal-header inactive-modal-header inactive-ai-modal-header">
                        <div class="d-flex align-items-center gap-3">
                            <span class="inactive-modal-icon inactive-ai-icon"><i class="bi bi-stars"></i></span>
                            <div>
                                <span class="inactive-modal-kicker">Asistencia inteligente</span>
                                <h2 class="modal-title h5 fw-bold mb-0" id="modalReasignarConIALabel">Vista previa de reasignaciones</h2>
                            </div>
                        </div>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Cerrar"></button>
                    </div>

                    <div class="modal-body p-3 p-lg-4">
                        <div class="inactive-ai-summary d-flex align-items-start gap-3 mb-4">
                            <span><i class="bi bi-lightbulb"></i></span>
                            <div>
                                <strong>La sugerencia es un punto de partida</strong>
                                <p class="mb-0">Revisá cada responsable antes de confirmar. La selección se conserva al navegar entre páginas.</p>
                            </div>
                        </div>

                        <div class="inactive-ai-steps row g-2 mb-4">
                            <div class="col-12 col-md-4"><span><b>1</b>Analizamos compatibilidad</span></div>
                            <div class="col-12 col-md-4"><span><b>2</b>Proponemos responsables</span></div>
                            <div class="col-12 col-md-4"><span><b>3</b>Vos revisás y confirmás</span></div>
                        </div>

                        <asp:UpdatePanel ID="upVistaPreviaIA" runat="server" UpdateMode="Conditional">
                            <ContentTemplate>
                                <div class="inactive-ai-table-wrap table-responsive">
                                    <asp:ListView
                                        ID="lvVistaPreviaIA"
                                        runat="server"
                                        ItemPlaceholderID="itemPlaceholder"
                                        OnItemDataBound="lvVistaPreviaIA_ItemDataBound"
                                        OnPagePropertiesChanging="lvVistaPreviaIA_PagePropertiesChanging">

                                        <LayoutTemplate>
                                            <table class="table inactive-ai-table align-middle mb-0">
                                                <thead>
                                                    <tr>
                                                        <th>Ticket</th>
                                                        <th>Prioridad</th>
                                                        <th>Usuario actual</th>
                                                        <th>Responsable sugerido</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <asp:PlaceHolder ID="itemPlaceholder" runat="server" />
                                                </tbody>
                                            </table>
                                        </LayoutTemplate>

                                        <ItemTemplate>
                                            <tr data-ai-ticket-row="true">
                                                <td>
                                                    <asp:HiddenField ID="hfIdTicketIA" runat="server" Value='<%# Eval("IdTicket") %>' />
                                                    <span class="inactive-ticket-code">TK-<%# Eval("IdTicket").ToString().PadLeft(3, '0') %></span>
                                                </td>
                                                <td class="priority-cell">
                                                    <span class='<%# GetClassPrioridad(Eval("Prioridad")) %>'><%# Eval("Prioridad") %></span>
                                                </td>
                                                <td>
                                                    <strong class="inactive-current-name"><%# Eval("UsuarioActual") %></strong>
                                                    <small class="inactive-current-role"><%# Eval("Area") %> · <%# Eval("Puesto") %></small>
                                                </td>
                                                <td>
                                                    <asp:DropDownList
                                                        ID="ddlUsuarioIA"
                                                        runat="server"
                                                        CssClass="form-select ddl-usuario-ia inactive-ai-select">
                                                    </asp:DropDownList>
                                                    <asp:Label
                                                        ID="lblMotivoIA"
                                                        runat="server"
                                                        CssClass="motivo-ia inactive-ai-reason d-block mt-2">
                                                    </asp:Label>
                                                </td>
                                            </tr>
                                        </ItemTemplate>
                                    </asp:ListView>
                                </div>

                                <div class="inactive-pagination d-flex justify-content-center mt-3">
                                    <asp:DataPager ID="dpVistaPreviaIA" runat="server" PagedControlID="lvVistaPreviaIA" PageSize="7">
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

                    <div class="modal-footer inactive-modal-footer">
                        <span class="inactive-footer-note me-auto"><i class="bi bi-shield-check"></i>Confirmá solo cuando hayas revisado todas las páginas.</span>
                        <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Cancelar</button>
                        <asp:Button ID="btnConfirmarReasignacionIA" runat="server"
                            CssClass="btn inactive-confirm-button"
                            Text="Confirmar reasignaciones"
                            OnClick="btnConfirmarReasignacionIA_Click" />
                    </div>
                </div>
            </div>
        </div>
    </div>

    <style>
        :root {
            --inactive-sky: #93c0de;
            --inactive-aqua: #b9e5e5;
            --inactive-ink: #09232f;
            --inactive-muted: #75797e;
            --inactive-cloud: #e5e5e5;
            --inactive-surface: #f2f7f8;
            --inactive-line: rgba(9, 35, 47, .1);
            --inactive-shadow: 0 18px 44px rgba(9, 35, 47, .075);
        }

        .app-main.inactive-tickets-surface {
            background: radial-gradient(circle at 94% 2%, rgba(147, 192, 222, .25), transparent 25rem), radial-gradient(circle at 8% 88%, rgba(185, 229, 229, .2), transparent 28rem), linear-gradient(180deg, #f8fafb 0%, var(--inactive-surface) 100%);
        }

        .inactive-tickets-workspace {
            width: 100%;
            max-width: 1580px;
            margin-inline: auto;
            color: var(--inactive-ink);
        }

        .inactive-ticket-messages .alert {
            margin-bottom: 1rem;
            padding: .9rem 1rem;
            border-width: 1px;
            border-radius: .9rem;
            box-shadow: 0 10px 26px rgba(9, 35, 47, .06) !important;
        }

        .inactive-hero {
            position: relative;
            overflow: hidden;
            padding: clamp(1.4rem, 2.6vw, 2.15rem);
            border: 1px solid rgba(147, 192, 222, .42);
            border-radius: 1.35rem;
            background: linear-gradient(112deg, rgba(255, 255, 255, .96), rgba(244, 251, 252, .88));
            box-shadow: 0 15px 38px rgba(9, 35, 47, .055);
            isolation: isolate;
        }

            .inactive-hero::after {
                content: "";
                position: absolute;
                z-index: -1;
                width: 17rem;
                aspect-ratio: 1;
                right: -5.5rem;
                top: -9.2rem;
                border: 2.9rem solid rgba(185, 229, 229, .32);
                border-radius: 50%;
            }

        .inactive-hero-copy {
            max-width: 49rem;
        }

            .inactive-hero-copy h1,
            .inactive-list-heading h2 {
                color: var(--inactive-ink);
                letter-spacing: -.03em;
            }

            .inactive-hero-copy p,
            .inactive-list-heading p {
                color: var(--inactive-muted);
            }

        .inactive-eyebrow,
        .inactive-section-label,
        .inactive-modal-kicker,
        .inactive-block-label {
            display: inline-flex;
            align-items: center;
            gap: .45rem;
            margin-bottom: .55rem;
            color: #315f76;
            font-size: .7rem;
            font-weight: 800;
            letter-spacing: .1em;
            text-transform: uppercase;
        }

        .inactive-hero-actions {
            position: relative;
            z-index: 1;
        }

        .inactive-context-chip {
            display: flex;
            align-items: center;
            gap: .7rem;
            padding: .65rem .78rem;
            border: 1px solid rgba(147, 192, 222, .42);
            border-radius: .9rem;
            background: rgba(255, 255, 255, .78);
        }

        .inactive-context-icon {
            display: grid;
            place-items: center;
            width: 2.35rem;
            height: 2.35rem;
            border-radius: .7rem;
            background: rgba(147, 192, 222, .2);
            color: #315f76;
            font-size: 1.05rem;
        }

        .inactive-context-chip > span:last-child {
            display: flex;
            flex-direction: column;
            line-height: 1.2;
        }

        .inactive-context-chip strong {
            font-size: .8rem;
        }

        .inactive-context-chip small {
            margin-top: .18rem;
            color: var(--inactive-muted);
            font-size: .68rem;
        }

        .ai-action-wrap {
            position: relative;
        }

            .ai-action-wrap > i {
                position: absolute;
                z-index: 2;
                top: 50%;
                left: 1rem;
                color: #fff;
                transform: translateY(-50%);
                pointer-events: none;
            }

        .inactive-ai-button,
        .inactive-confirm-button,
        .inactive-reassign-button {
            border-color: var(--inactive-ink) !important;
            background: var(--inactive-ink) !important;
            color: #fff !important;
            font-weight: 700;
            box-shadow: 0 9px 20px rgba(9, 35, 47, .14);
        }

        .inactive-ai-button {
            min-height: 46px;
            padding-inline: 2.6rem 1.15rem;
            border-radius: .78rem;
        }

            .inactive-ai-button:hover,
            .inactive-ai-button:focus,
            .inactive-confirm-button:hover,
            .inactive-confirm-button:focus,
            .inactive-reassign-button:hover,
            .inactive-reassign-button:focus {
                border-color: #17485d !important;
                background: #17485d !important;
                color: #fff !important;
                transform: translateY(-1px);
            }

        .inactive-guidance-item {
            display: flex;
            align-items: center;
            gap: .85rem;
            padding: .9rem 1rem;
            border: 1px solid rgba(9, 35, 47, .075);
            border-radius: 1rem;
            background: rgba(255, 255, 255, .72);
            box-shadow: 0 10px 26px rgba(9, 35, 47, .04);
        }

        .inactive-guidance-number {
            display: grid;
            flex: 0 0 auto;
            place-items: center;
            width: 2.35rem;
            height: 2.35rem;
            border-radius: .72rem;
            background: linear-gradient(145deg, rgba(147, 192, 222, .26), rgba(185, 229, 229, .38));
            color: #315f76;
            font-size: .72rem;
            font-weight: 850;
        }

        .inactive-guidance-item > span:last-child {
            display: flex;
            flex-direction: column;
        }

        .inactive-guidance-item strong {
            font-size: .82rem;
        }

        .inactive-guidance-item small {
            margin-top: .14rem;
            color: var(--inactive-muted);
            font-size: .72rem;
        }

        .inactive-list-heading {
            padding-inline: .2rem;
        }

            .inactive-list-heading p {
                font-size: .84rem;
            }

        .inactive-list-hint {
            display: inline-flex;
            align-items: center;
            gap: .45rem;
            padding: .46rem .72rem;
            border: 1px solid rgba(147, 192, 222, .42);
            border-radius: 999px;
            background: rgba(255, 255, 255, .72);
            color: #476878;
            font-size: .73rem;
            font-weight: 700;
        }

        .inactive-table-card,
        .inactive-ai-table-wrap {
            overflow: hidden;
            border: 1px solid rgba(9, 35, 47, .08);
            border-radius: 1.2rem;
            background: rgba(255, 255, 255, .86);
            box-shadow: var(--inactive-shadow);
            backdrop-filter: blur(12px);
        }

        .inactive-ticket-table {
            min-width: 1180px;
        }

            .inactive-ticket-table thead th,
            .inactive-ai-table thead th {
                padding: .9rem 1rem;
                border-bottom: 1px solid rgba(9, 35, 47, .09);
                background: #eaf1f3;
                color: #526873;
                font-size: .68rem;
                font-weight: 850;
                letter-spacing: .06em;
                text-transform: uppercase;
                white-space: nowrap;
            }

            .inactive-ticket-table tbody td,
            .inactive-ai-table tbody td {
                padding: 1rem;
                border-color: rgba(9, 35, 47, .07);
                color: #52646c;
                font-size: .83rem;
                vertical-align: middle;
            }

            .inactive-ticket-table tbody tr,
            .inactive-ai-table tbody tr {
                transition: background-color .18s ease, opacity .35s ease, transform .35s ease;
            }

        .inactive-tickets-js [data-inactive-ticket-row],
        .inactive-tickets-js [data-ai-ticket-row] {
            opacity: 0;
            transform: translateY(6px);
        }

            .inactive-tickets-js [data-inactive-ticket-row].is-visible,
            .inactive-tickets-js [data-ai-ticket-row].is-visible {
                opacity: 1;
                transform: none;
            }

        .inactive-ticket-table tbody tr:hover,
        .inactive-ai-table tbody tr:hover {
            background: rgba(185, 229, 229, .15);
        }

        .inactive-ticket-code {
            display: block;
            color: var(--inactive-ink);
            font-weight: 850;
            letter-spacing: .025em;
            white-space: nowrap;
        }

        .inactive-ticket-caption,
        .inactive-role-copy,
        .inactive-sprint-copy,
        .inactive-date-end,
        .inactive-current-role {
            display: block;
            margin-top: .2rem;
            color: #7b888e;
            font-size: .7rem;
            white-space: nowrap;
        }

        .inactive-user-cell {
            display: flex;
            align-items: center;
            gap: .65rem;
            min-width: 220px;
        }

        .inactive-user-avatar {
            display: grid;
            flex: 0 0 auto;
            place-items: center;
            width: 2.25rem;
            height: 2.25rem;
            border: 1px solid rgba(181, 70, 79, .13);
            border-radius: .68rem;
            background: rgba(224, 91, 105, .1);
            color: #a23d49;
        }

        .inactive-user-cell > span:last-child {
            min-width: 0;
        }

        .inactive-user-cell strong,
        .inactive-user-cell small {
            display: block;
        }

        .inactive-user-cell strong,
        .inactive-project-name,
        .inactive-current-name {
            color: var(--inactive-ink);
            font-weight: 750;
        }

        .inactive-user-cell small {
            overflow: hidden;
            max-width: 205px;
            margin-top: .14rem;
            color: #7a878d;
            font-size: .69rem;
            text-overflow: ellipsis;
        }

        .inactive-area-badge {
            display: inline-flex;
            align-items: center;
            gap: .35rem;
            padding: .4rem .58rem;
            border: 1px solid rgba(130, 149, 217, .16);
            border-radius: 999px;
            background: rgba(130, 149, 217, .14);
            color: #584d91;
            font-size: .69rem;
            font-weight: 750;
        }

        .inactive-project-name {
            display: block;
            max-width: 180px;
        }

        .inactive-date-range {
            display: flex;
            align-items: center;
            gap: .4rem;
            color: #3f5965;
            font-weight: 700;
            white-space: nowrap;
        }

            .inactive-date-range i {
                color: #5f91a9;
            }

        .inactive-ticket-table .badge,
        .inactive-ai-table .badge {
            border: 1px solid transparent;
            border-radius: 999px;
            font-size: .68rem;
            font-weight: 800;
        }

        .priority-cell .text-bg-danger {
            border-color: rgba(184, 64, 77, .17) !important;
            background: rgba(224, 91, 105, .13) !important;
            color: #a23d49 !important;
        }

        .priority-cell .text-bg-warning {
            border-color: rgba(177, 137, 36, .18) !important;
            background: rgba(216, 184, 91, .17) !important;
            color: #80651d !important;
        }

        .priority-cell .text-bg-success {
            border-color: rgba(45, 132, 95, .18) !important;
            background: rgba(76, 175, 125, .14) !important;
            color: #237a55 !important;
        }

        .status-cell .text-bg-primary,
        .status-cell .text-bg-success {
            border-color: rgba(45, 132, 95, .18) !important;
            background: rgba(76, 175, 125, .14) !important;
            color: #237a55 !important;
        }

        .status-cell .text-bg-warning {
            border-color: rgba(177, 137, 36, .18) !important;
            background: rgba(216, 184, 91, .17) !important;
            color: #80651d !important;
        }

        .status-cell .text-bg-dark,
        .status-cell .text-bg-secondary,
        .priority-cell .text-bg-secondary {
            border-color: rgba(49, 95, 118, .16) !important;
            background: rgba(147, 192, 222, .2) !important;
            color: #315f76 !important;
        }

        .inactive-reassign-button {
            min-width: 105px;
            padding: .5rem .7rem;
            border-radius: .68rem;
        }

        .inactive-pagination .btn {
            border-radius: .65rem;
            font-weight: 650;
        }

        .inactive-pagination .btn-primary {
            border-color: var(--inactive-ink);
            background: var(--inactive-ink);
            color: #fff;
        }

        .inactive-pagination .btn-outline-primary,
        .inactive-pagination .btn-outline-secondary {
            border-color: rgba(49, 95, 118, .28);
            color: #315f76;
        }

            .inactive-pagination .btn-outline-primary:hover,
            .inactive-pagination .btn-outline-secondary:hover {
                border-color: var(--inactive-ink);
                background: var(--inactive-ink);
                color: #fff;
            }

        .inactive-empty-state {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            gap: .3rem;
            min-height: 16rem;
            padding: 2.5rem 1rem;
            background: rgba(255, 255, 255, .72);
            color: var(--inactive-muted);
            text-align: center;
        }

        .inactive-empty-icon {
            display: grid;
            place-items: center;
            width: 3.4rem;
            height: 3.4rem;
            margin-bottom: .5rem;
            border-radius: 1rem;
            background: rgba(76, 175, 125, .13);
            color: #237a55;
            font-size: 1.6rem;
        }

        .inactive-empty-state strong {
            color: var(--inactive-ink);
            font-size: 1rem;
        }

        .inactive-empty-state > span:last-child {
            font-size: .82rem;
        }

        .inactive-modal .modal-content {
            overflow: hidden;
            border: 1px solid rgba(9, 35, 47, .1);
            border-radius: 1.25rem;
            box-shadow: 0 30px 90px rgba(9, 35, 47, .25);
        }

        .inactive-modal-header {
            padding: 1.15rem 1.35rem;
            border-bottom: 1px solid rgba(9, 35, 47, .08);
            background: linear-gradient(105deg, #f8fbfc, #edf6f7);
        }

            .inactive-modal-header .btn-close {
                padding: .7rem;
                border-radius: .6rem;
                background-color: rgba(255, 255, 255, .8);
                box-shadow: 0 4px 12px rgba(9, 35, 47, .08);
            }

        .inactive-modal-icon {
            display: grid;
            flex: 0 0 auto;
            place-items: center;
            width: 2.75rem;
            height: 2.75rem;
            border-radius: .82rem;
            background: linear-gradient(145deg, rgba(147, 192, 222, .3), rgba(185, 229, 229, .42));
            color: #315f76;
            font-size: 1.15rem;
        }

        .inactive-modal-kicker {
            margin-bottom: .18rem;
            font-size: .62rem;
        }

        .inactive-modal-intro,
        .inactive-ai-summary {
            display: flex;
            padding: .9rem 1rem;
            border: 1px solid rgba(147, 192, 222, .3);
            border-radius: .9rem;
            background: rgba(147, 192, 222, .1);
            color: #47606c;
            font-size: .84rem;
            line-height: 1.5;
        }

        .inactive-modal-intro {
            gap: .7rem;
        }

            .inactive-modal-intro i {
                color: #4e8199;
                font-size: 1rem;
            }

        .inactive-current-user > .alert {
            margin: 0;
            padding: 1rem 1.1rem;
            border: 1px solid rgba(9, 35, 47, .08);
            border-left: 3px solid var(--inactive-sky);
            border-radius: .85rem;
            background: #f7fafb;
            color: #51656f;
            line-height: 1.65;
        }

            .inactive-current-user > .alert strong {
                color: var(--inactive-ink);
            }

        .inactive-current-user > .alert-danger {
            margin-top: .75rem !important;
            border-color: rgba(184, 64, 77, .15);
            border-left-color: #c15a65;
            background: rgba(224, 91, 105, .09);
            color: #943943;
        }

        .inactive-select-panel {
            padding: 1.1rem;
            border: 1px solid rgba(9, 35, 47, .08);
            border-radius: .95rem;
            background: linear-gradient(145deg, #fff, #f4f9fa);
        }

            .inactive-select-panel .form-label {
                color: var(--inactive-ink);
            }

            .inactive-select-panel p {
                color: var(--inactive-muted);
            }

        .inactive-user-select,
        .inactive-ai-select {
            min-height: 46px;
            border-color: rgba(9, 35, 47, .15);
            border-radius: .75rem;
            background-color: #fff;
            color: var(--inactive-ink);
            font-size: .88rem;
        }

            .inactive-user-select:focus,
            .inactive-ai-select:focus {
                border-color: #75a9c9;
                box-shadow: 0 0 0 .22rem rgba(147, 192, 222, .2);
            }

        .inactive-modal-footer {
            padding: 1rem 1.35rem;
            border-top: 1px solid rgba(9, 35, 47, .08);
            background: #f2f7f8;
        }

            .inactive-modal-footer .btn {
                min-height: 42px;
                padding-inline: 1rem;
                border-radius: .7rem;
                font-weight: 700;
            }

            .inactive-modal-footer .btn-outline-secondary {
                border-color: rgba(49, 95, 118, .28);
                color: #3e5d6a;
            }

                .inactive-modal-footer .btn-outline-secondary:hover {
                    border-color: var(--inactive-ink);
                    background: var(--inactive-ink);
                    color: #fff;
                }

        .inactive-confirm-button:disabled {
            border-color: #c8d2d6 !important;
            background: #dbe3e6 !important;
            color: #77868c !important;
            box-shadow: none;
        }

        .inactive-ai-modal .modal-content {
            min-height: min(780px, calc(100vh - 3.5rem));
        }

        .inactive-ai-modal-header {
            background: linear-gradient(105deg, #f7f9fd, #edf4fb);
        }

        .inactive-ai-icon {
            background: linear-gradient(145deg, rgba(130, 149, 217, .2), rgba(185, 229, 229, .42));
            color: #5668a7;
        }

        .inactive-ai-summary > span {
            display: grid;
            flex: 0 0 auto;
            place-items: center;
            width: 2.35rem;
            height: 2.35rem;
            border-radius: .7rem;
            background: rgba(255, 255, 255, .76);
            color: #4e8199;
            font-size: 1rem;
        }

        .inactive-ai-summary strong {
            display: block;
            margin-bottom: .2rem;
            color: var(--inactive-ink);
        }

        .inactive-ai-summary p {
            color: #61737b;
            font-size: .78rem;
        }

        .inactive-ai-steps span {
            display: flex;
            align-items: center;
            gap: .55rem;
            height: 100%;
            padding: .62rem .75rem;
            border: 1px solid rgba(9, 35, 47, .07);
            border-radius: .78rem;
            background: #f7f9fa;
            color: #536873;
            font-size: .74rem;
            font-weight: 700;
        }

        .inactive-ai-steps b {
            display: grid;
            flex: 0 0 auto;
            place-items: center;
            width: 1.55rem;
            height: 1.55rem;
            border-radius: .5rem;
            background: rgba(147, 192, 222, .22);
            color: #315f76;
            font-size: .65rem;
        }

        .inactive-ai-table-wrap {
            box-shadow: 0 12px 30px rgba(9, 35, 47, .06);
        }

        .inactive-ai-table {
            min-width: 920px;
        }

            .inactive-ai-table th:last-child {
                width: 42%;
            }

        .inactive-current-name,
        .inactive-current-role {
            display: block;
        }

        .inactive-ai-reason {
            position: relative;
            min-height: 1.2rem;
            padding-left: 1.15rem;
            color: #697a82;
            font-size: .7rem;
            line-height: 1.4;
        }

            .inactive-ai-reason::before {
                content: "\F46B";
                position: absolute;
                left: 0;
                top: .02rem;
                color: #6d83c4;
                font-family: "bootstrap-icons";
            }

        .inactive-ai-select.has-selection {
            border-color: rgba(76, 175, 125, .4);
            background-color: rgba(240, 250, 245, .9);
        }

        .inactive-ai-select.no-selection {
            border-color: rgba(216, 184, 91, .42);
            background-color: rgba(255, 250, 235, .9);
        }

        .inactive-footer-note {
            display: inline-flex;
            align-items: center;
            gap: .45rem;
            color: #63777f;
            font-size: .72rem;
        }

            .inactive-footer-note i {
                color: #47826a;
            }

        @media (max-width: 991.98px) {
            .inactive-hero-actions {
                width: 100%;
            }

            .inactive-ai-table th:last-child {
                width: auto;
            }
        }

        @media (max-width: 767.98px) {
            .inactive-context-chip {
                display: none;
            }

            .ai-action-wrap,
            .inactive-ai-button {
                width: 100%;
            }

            .inactive-list-hint,
            .inactive-footer-note {
                display: none;
            }

            .inactive-ticket-table {
                min-width: 1080px;
            }

            .inactive-modal-footer .btn,
            .inactive-modal-footer input.btn {
                flex: 1 1 auto;
            }
        }

        @media (max-width: 575.98px) {
            .inactive-hero {
                border-radius: 1rem;
            }

            .inactive-guidance-item {
                padding: .75rem .85rem;
            }

            .inactive-modal .modal-dialog {
                margin: .6rem;
            }

            .inactive-modal .modal-content {
                border-radius: 1rem;
            }

            .inactive-modal-header,
            .inactive-modal-footer {
                padding: .9rem 1rem;
            }

            .inactive-modal-footer {
                gap: .6rem;
            }

                .inactive-modal-footer .btn,
                .inactive-modal-footer input.btn {
                    width: 100%;
                    margin: 0;
                }
        }

        @media (prefers-reduced-motion: reduce) {
            .inactive-tickets-js [data-inactive-ticket-row],
            .inactive-tickets-js [data-ai-ticket-row],
            .inactive-tickets-js [data-inactive-ticket-row].is-visible,
            .inactive-tickets-js [data-ai-ticket-row].is-visible {
                opacity: 1;
                transform: none;
                transition: none;
            }
        }
    </style>

    <script type="text/javascript">
        (function () {
            function revealRows(root) {
                var scope = root || document;
                var rows = scope.querySelectorAll('[data-inactive-ticket-row]:not(.is-observed), [data-ai-ticket-row]:not(.is-observed)');
                var reducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

                rows.forEach(function (row, index) {
                    row.classList.add('is-observed');
                    row.style.transitionDelay = Math.min(index * 32, 190) + 'ms';
                });

                if (reducedMotion || !('IntersectionObserver' in window)) {
                    rows.forEach(function (row) { row.classList.add('is-visible'); });
                    return;
                }

                var observer = new IntersectionObserver(function (entries, currentObserver) {
                    entries.forEach(function (entry) {
                        if (entry.isIntersecting) {
                            entry.target.classList.add('is-visible');
                            currentObserver.unobserve(entry.target);
                        }
                    });
                }, { threshold: 0.08 });

                rows.forEach(function (row) { observer.observe(row); });
            }

            function updateSelectState(select) {
                if (!select || !select.classList.contains('inactive-ai-select')) return;
                select.classList.toggle('has-selection', Boolean(select.value));
                select.classList.toggle('no-selection', !select.value);
            }

            function enhanceDynamicContent(root) {
                revealRows(root || document);
                (root || document).querySelectorAll('.inactive-ai-select').forEach(updateSelectState);
            }

            document.addEventListener('DOMContentLoaded', function () {
                var appMain = document.querySelector('.app-main');
                if (appMain && document.querySelector('.inactive-tickets-workspace')) {
                    appMain.classList.add('inactive-tickets-surface', 'inactive-tickets-js');
                }

                enhanceDynamicContent(document);

                document.addEventListener('change', function (event) {
                    updateSelectState(event.target);
                });

                document.querySelectorAll('.inactive-modal').forEach(function (modal) {
                    modal.addEventListener('shown.bs.modal', function () {
                        var firstField = modal.querySelector('select:not(:disabled)');
                        if (firstField) firstField.focus({ preventScroll: true });
                        enhanceDynamicContent(modal);
                    });
                });

                if (window.Sys && Sys.WebForms && Sys.WebForms.PageRequestManager) {
                    Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function () {
                        enhanceDynamicContent(document);
                    });
                }
            });
        })();
    </script>
</asp:Content>
