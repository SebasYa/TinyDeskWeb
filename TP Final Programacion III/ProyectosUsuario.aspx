<%@ Page Title="" Language="C#" MasterPageFile="~/UsuarioSite.Master" AutoEventWireup="true" CodeBehind="ProyectosUsuario.aspx.cs" Inherits="TP_Final_Programacion_III.ProyectosUsuario" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <asp:Literal ID="litMensaje" runat="server"></asp:Literal>

    <!-- DETALLE DEL PROYECTO -->
    <asp:Panel
        ID="pnlDetalleProyecto"
        runat="server"
        Visible="false"
        CssClass="container-fluid projects-workspace projects-detail-view px-0 pt-2">

        <div class="project-page-heading project-detail-heading d-flex justify-content-between align-items-start flex-wrap gap-3 mb-4">

            <div class="project-heading-copy">
                <span class="project-eyebrow"><i class="bi bi-folder2-open"></i>Mis proyectos</span>
                <div class="d-flex align-items-center flex-wrap gap-2 mb-2">

                    <h1 class="h2 fw-bold text-dark mb-0">
                        <asp:Label ID="lblDetalleNombre" runat="server"></asp:Label>
                    </h1>

                    <span class="badge project-status-badge rounded-pill">
                        <asp:Label ID="lblDetalleEstado" runat="server"></asp:Label>
                    </span>

                </div>

                <p class="text-muted mb-0">
                    Información general y sprints donde tenés tickets asignados.
                </p>
            </div>

            <asp:LinkButton
                ID="btnVolverProyectos"
                runat="server"
                CssClass="btn btn-outline-secondary"
                CausesValidation="false"
                OnClick="btnVolverProyectos_Click">

                <i class="bi bi-arrow-left me-1"></i>
                Volver

            </asp:LinkButton>

        </div>

        <!-- INFORMACIÓN -->
        <div class="card project-detail-card border-0 mb-4">

            <div class="card-header project-card-header p-4">
                <h2 class="h5 fw-bold mb-1">Detalle del proyecto</h2>

                <p class="text-muted small mb-0">
                    Descripción, fechas y estado actual.
                </p>
            </div>

            <div class="card-body p-4 border-top">

                <div class="mb-4">

                    <div class="text-uppercase text-muted small fw-semibold mb-2">
                        Descripción
                    </div>

                    <div class="text-dark">
                        <asp:Label ID="lblDetalleDescripcion" runat="server"></asp:Label>
                    </div>

                </div>

                <div class="row g-3">

                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="project-metric p-3 h-100">

                            <div class="d-flex align-items-center gap-2 text-muted small mb-2">
                                <i class="bi bi-calendar-event text-primary"></i>
                                Fecha de inicio
                            </div>

                            <div class="fw-semibold text-dark">
                                <asp:Label ID="lblDetalleFechaInicio" runat="server"></asp:Label>
                            </div>

                        </div>
                    </div>

                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="project-metric p-3 h-100">

                            <div class="d-flex align-items-center gap-2 text-muted small mb-2">
                                <i class="bi bi-calendar-check text-primary"></i>
                                Fin estimado
                            </div>

                            <div class="fw-semibold text-dark">
                                <asp:Label ID="lblDetalleFechaEstimadaFin" runat="server"></asp:Label>
                            </div>

                        </div>
                    </div>

                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="project-metric p-3 h-100">

                            <div class="d-flex align-items-center gap-2 text-muted small mb-2">
                                <i class="bi bi-calendar-x text-primary"></i>
                                Fecha de finalización
                            </div>

                            <div class="fw-semibold text-dark">
                                <asp:Label ID="lblDetalleFechaFin" runat="server"></asp:Label>
                            </div>

                        </div>
                    </div>

                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="project-metric p-3 h-100">

                            <div class="d-flex align-items-center gap-2 text-muted small mb-2">
                                <i class="bi bi-activity text-primary"></i>
                                Estado del registro
                            </div>

                            <asp:Label ID="lblDetalleActivo" runat="server"></asp:Label>

                        </div>
                    </div>

                </div>

            </div>

        </div>

        <!-- SPRINTS -->
        <div class="card project-table-card border-0">

            <div class="card-header project-card-header p-4">

                <div class="d-flex align-items-center gap-3">

                    <div class="project-section-icon rounded-3 p-2">
                        <i class="bi bi-kanban fs-4"></i>
                    </div>

                    <div>
                        <h2 class="h5 fw-bold mb-1">Tus sprints</h2>

                        <p class="text-muted small mb-0">
                            Sprints donde tenés al menos un ticket asignado.
                        </p>
                    </div>

                </div>

            </div>

            <div class="card-body p-0 border-top">

                <asp:ListView
                    ID="lvSprintsProyecto"
                    runat="server"
                    ItemPlaceholderID="itemPlaceholder"
                    OnPagePropertiesChanging="lvSprintsProyecto_PagePropertiesChanging">

                    <LayoutTemplate>

                        <div class="table-responsive">

                            <table class="table project-table table-hover align-middle mb-0">

                                <thead class="table-light">
                                    <tr>
                                        <th>Sprint</th>
                                        <th>Estado</th>
                                        <th>Inicio</th>
                                        <th>Fin estimada</th>
                                        <th>Área</th>
                                        <th>Detalle</th>
                                    </tr>
                                </thead>

                                <tbody>
                                    <asp:PlaceHolder
                                        ID="itemPlaceholder"
                                        runat="server" />
                                </tbody>

                            </table>

                        </div>

                    </LayoutTemplate>

                    <ItemTemplate>

                        <tr>

                            <td>
                                <span class="fw-semibold text-dark">Sprint <%# Eval("NumeroSprint") %>
                                </span>
                            </td>

                            <td>
                                <span class="badge project-status-badge rounded-pill">
                                    <%# Eval("Estado.Nombre") %>
                                </span>
                            </td>

                            <td>
                                <%# Eval("FechaInicio", "{0:dd/MM/yyyy}") %>
                            </td>

                            <td>
                                <%# Eval("FechaEstimadaFin", "{0:dd/MM/yyyy}") %>
                            </td>

                            <td>
                                <i class="bi bi-people me-1 text-muted"></i>
                                <%# Eval("Area.Nombre") %>
                            </td>

                            <td>

                                <asp:LinkButton
                                    ID="btnVerSprint"
                                    runat="server"
                                    Text="Ver sprint"
                                    CssClass="btn btn-sm btn-outline-primary"
                                    CommandArgument='<%# Eval("Id") %>'
                                    CausesValidation="false"
                                    OnClick="btnVerSprint_Click" />

                            </td>

                        </tr>

                    </ItemTemplate>

                    <EmptyDataTemplate>
                        <div class="project-empty-state m-4">
                            <i class="bi bi-kanban"></i>
                            <strong>Sin sprints asignados</strong>
                            <span>No tenés tickets asignados en los sprints de este proyecto.</span>
                        </div>
                    </EmptyDataTemplate>

                </asp:ListView>

                <div class="d-flex justify-content-center my-4">

                    <asp:DataPager
                        ID="dpSprintsProyecto"
                        runat="server"
                        PagedControlID="lvSprintsProyecto"
                        PageSize="5">

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

            </div>

        </div>

    </asp:Panel>

    <!-- LISTADO DE PROYECTOS -->
    <asp:Panel
        ID="pnlListadoProyectos"
        runat="server"
        CssClass="container-fluid projects-workspace projects-list-view px-0 pt-2">

        <div class="project-page-heading d-flex justify-content-between align-items-start flex-wrap gap-3 mb-4">

            <div class="project-heading-copy">
                <span class="project-eyebrow"><i class="bi bi-grid-1x2"></i>Espacio de trabajo</span>
                <h1 class="h2 fw-bold mb-1">Proyectos</h1>
                <p class="mb-0">Consultá los proyectos de la empresa y revisá su avance.</p>
            </div>

            <div class="project-context-chip">
                <i class="bi bi-person-workspace"></i>
                <span><strong>Tu portafolio</strong><small>Vista de proyectos</small></span>
            </div>

        </div>

        <div class="card project-filter-panel border-0 mb-4">

            <div class="card-body d-flex justify-content-between align-items-center flex-wrap gap-3 p-3 p-lg-4">

                <div>
                    <h5 class="fw-semibold mb-1">Estado de los proyectos
                    </h5>

                    <small class="text-muted">Alterná entre proyectos activos y proyectos finalizados.
                    </small>
                </div>

                <div class="project-status-toggle d-flex gap-2">

                    <asp:Button
                        ID="btnFiltroActivos"
                        runat="server"
                        Text="Activos"
                        CssClass="btn btn-primary"
                        CausesValidation="false"
                        OnClick="btnFiltroActivos_Click" />

                    <asp:Button
                        ID="btnFiltroFinalizados"
                        runat="server"
                        Text="Finalizados"
                        CssClass="btn btn-outline-secondary"
                        CausesValidation="false"
                        OnClick="btnFiltroFinalizados_Click" />

                </div>

            </div>

        </div>

        <div class="project-list-label d-flex align-items-center justify-content-between flex-wrap gap-2 mb-3">
            <div>
                <h2 class="h5 fw-bold mb-1">Proyectos disponibles</h2>
                <p class="mb-0">Entrá a un proyecto para revisar sus fechas y tus sprints relacionados.</p>
            </div>
            <span class="project-list-hint"><i class="bi bi-arrow-up-right-square"></i>Vista detallada</span>
        </div>

        <asp:ListView
            ID="lvProyectos"
            runat="server"
            ItemPlaceholderID="itemPlaceholder"
            OnItemDataBound="lvProyectos_ItemDataBound"
            OnPagePropertiesChanging="lvProyectos_PagePropertiesChanging">

            <LayoutTemplate>

                <div class="row g-3 g-xl-4 project-grid">
                    <asp:PlaceHolder
                        ID="itemPlaceholder"
                        runat="server" />
                </div>

            </LayoutTemplate>

            <ItemTemplate>

                <div class="col-12 col-lg-6 col-xxl-4 project-grid-item">

                    <asp:LinkButton
                        ID="btnVerProyecto"
                        runat="server"
                        CssClass="card project-card h-100 border-0 text-decoration-none"
                        data-project-card="true"
                        CommandArgument='<%# Eval("Id") %>'
                        CausesValidation="false"
                        OnClick="btnVerProyecto_Click">

                        <div class="card-body d-flex flex-column p-4">

                            <div class="d-flex justify-content-between align-items-start gap-2 mb-3">

                                <div class="d-flex align-items-start gap-3 pe-2">

                                    <span class="project-folder-mark"><i class="bi bi-folder2-open"></i></span>

                                    <div>

                                        <h5 class="card-title fw-bold mb-1">
                                            <%# Eval("Nombre") %>
                                        </h5>

                                        <small class="project-card-kicker">Proyecto</small>

                                    </div>

                                </div>

                                <asp:Literal
                                    ID="litEstadoProyecto"
                                    runat="server"
                                    Mode="PassThrough"
                                    Text='<%# ObtenerIconoEstadoProyecto(Eval("Estado.Nombre")) %>'>
                                </asp:Literal>

                            </div>

                            <p class="card-text project-description mb-4">
                                <%# Eval("Descripcion") %>
                            </p>

                            <div class="mt-auto">

                                <div class="project-date-row d-flex align-items-center small mb-2">
                                    <i class="bi bi-calendar-event me-2"></i>

                                    <span>Inicio:
                                        <%# Eval("FechaInicio", "{0:dd/MM/yyyy}") %>
                                    </span>
                                </div>

                                <div class="project-date-row d-flex align-items-center small mb-2">
                                    <i class="bi bi-calendar-check me-2"></i>

                                    <span>Fin estimado:
                                        <%# Eval("FechaEstimadaFin", "{0:dd/MM/yyyy}") %>
                                    </span>
                                </div>

                                <asp:Literal
                                    ID="litFechaFin"
                                    runat="server"
                                    Visible="false">
                                </asp:Literal>

                                <div class="project-card-action d-flex justify-content-between align-items-center pt-3 mt-3">

                                    <span class="small text-primary fw-semibold">Ver proyecto
                                    </span>

                                    <i class="bi bi-arrow-right-circle text-primary fs-5"></i>

                                </div>

                            </div>

                        </div>

                    </asp:LinkButton>

                </div>

            </ItemTemplate>

            <EmptyDataTemplate>
                <div class="project-empty-state py-5">
                    <i class="bi bi-folder-x"></i>
                    <strong>No hay proyectos para mostrar</strong>
                    <span>Probá alternando el estado de los proyectos.</span>
                </div>
            </EmptyDataTemplate>

        </asp:ListView>

        <div class="project-pagination d-flex justify-content-center mt-4">

            <asp:DataPager
                ID="dpProyectos"
                runat="server"
                PagedControlID="lvProyectos"
                PageSize="6">

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

    <style>
        :root {
            --projects-sky: #93c0de;
            --projects-aqua: #b9e5e5;
            --projects-ink: #09232f;
            --projects-muted: #75797e;
            --projects-cloud: #e5e5e5;
            --projects-surface: #f3f7f8;
            --projects-line: rgba(9, 35, 47, .11);
            --projects-shadow: 0 18px 45px rgba(9, 35, 47, .075);
        }

        .app-main.projects-app-surface {
            background: radial-gradient(circle at 93% 2%, rgba(147, 192, 222, .23), transparent 25rem), radial-gradient(circle at 18% 88%, rgba(185, 229, 229, .18), transparent 30rem), linear-gradient(180deg, #f7f9fa 0%, var(--projects-surface) 100%);
        }

        .projects-workspace {
            width: 100%;
            max-width: 1540px;
            margin-inline: auto;
            color: var(--projects-ink);
        }

        .project-page-heading {
            position: relative;
            overflow: hidden;
            padding: clamp(1.35rem, 2.4vw, 2rem);
            border: 1px solid rgba(147, 192, 222, .38);
            border-radius: 1.35rem;
            background: linear-gradient(110deg, rgba(255, 255, 255, .94), rgba(245, 251, 252, .86));
            box-shadow: 0 14px 36px rgba(9, 35, 47, .055);
            isolation: isolate;
        }

            .project-page-heading::after {
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

        .project-heading-copy {
            max-width: 48rem;
        }

            .project-heading-copy h1,
            .project-list-label h2,
            .projects-workspace h2,
            .projects-workspace h5 {
                color: var(--projects-ink);
                letter-spacing: -.025em;
            }

            .project-heading-copy > p,
            .project-list-label p {
                color: var(--projects-muted);
            }

        .project-eyebrow {
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

        .project-context-chip {
            display: flex;
            align-items: center;
            gap: .75rem;
            padding: .68rem .85rem;
            border: 1px solid rgba(147, 192, 222, .45);
            border-radius: .9rem;
            background: rgba(255, 255, 255, .78);
            color: #315f76;
        }

            .project-context-chip > i {
                display: grid;
                place-items: center;
                width: 2.45rem;
                height: 2.45rem;
                border-radius: .72rem;
                background: linear-gradient(145deg, rgba(147, 192, 222, .3), rgba(185, 229, 229, .4));
                font-size: 1.1rem;
            }

            .project-context-chip span {
                display: flex;
                flex-direction: column;
                line-height: 1.2;
            }

            .project-context-chip strong {
                color: var(--projects-ink);
                font-size: .82rem;
            }

            .project-context-chip small {
                margin-top: .18rem;
                color: var(--projects-muted);
                font-size: .68rem;
            }

        .projects-workspace .btn-primary {
            --bs-btn-bg: var(--projects-ink);
            --bs-btn-border-color: var(--projects-ink);
            --bs-btn-hover-bg: #123d4f;
            --bs-btn-hover-border-color: #123d4f;
            --bs-btn-active-bg: #061a23;
            --bs-btn-active-border-color: #061a23;
            border-radius: .72rem;
            box-shadow: 0 8px 18px rgba(9, 35, 47, .12);
            font-weight: 650;
        }

            .projects-workspace .btn-primary:hover,
            .projects-workspace .btn-primary:focus {
                color: #fff !important;
            }

        .projects-workspace .btn-outline-primary {
            --bs-btn-color: #315a70;
            --bs-btn-border-color: rgba(49, 90, 112, .32);
            --bs-btn-hover-bg: var(--projects-ink);
            --bs-btn-hover-border-color: var(--projects-ink);
            --bs-btn-active-bg: var(--projects-ink);
            border-radius: .68rem;
        }

        .projects-workspace .btn-outline-secondary {
            --bs-btn-color: #58646a;
            --bs-btn-border-color: rgba(88, 100, 106, .3);
            --bs-btn-hover-bg: #e7eef0;
            --bs-btn-hover-color: var(--projects-ink);
            --bs-btn-hover-border-color: #cbd8dc;
            border-radius: .68rem;
        }

        .project-detail-heading .btn-outline-secondary:hover,
        .project-detail-heading .btn-outline-secondary:focus {
            border-color: var(--projects-ink);
            background: var(--projects-ink);
            color: #fff;
        }

        .project-filter-panel,
        .project-detail-card,
        .project-table-card {
            border-radius: 1.25rem;
            background: rgba(255, 255, 255, .83);
            box-shadow: var(--projects-shadow);
            backdrop-filter: blur(12px);
        }

        .project-filter-panel,
        .project-detail-card,
        .project-table-card {
            border: 1px solid rgba(9, 35, 47, .08) !important;
        }

            .project-filter-panel h5 {
                font-size: .95rem;
            }

        .project-status-toggle {
            padding: .28rem;
            border: 1px solid var(--projects-line);
            border-radius: .9rem;
            background: #edf3f4;
        }

            .project-status-toggle .btn {
                min-width: 120px;
                min-height: 40px;
                border-radius: .68rem !important;
                border-color: transparent;
                box-shadow: none;
                font-weight: 700;
            }

            .project-status-toggle .btn-primary,
            .project-status-toggle .btn-secondary {
                background: var(--projects-ink);
                color: #fff;
            }

            .project-status-toggle .btn-outline-primary,
            .project-status-toggle .btn-outline-secondary {
                background: transparent;
                color: #64747b;
            }

                .project-status-toggle .btn-outline-primary:hover,
                .project-status-toggle .btn-outline-secondary:hover {
                    background: rgba(255, 255, 255, .75);
                    color: var(--projects-ink);
                }

        .project-list-label {
            padding-inline: .2rem;
        }

            .project-list-label p {
                font-size: .86rem;
            }

        .project-list-hint {
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

        .projects-js .project-grid-item {
            opacity: 0;
            transform: translateY(10px);
        }

            .projects-js .project-grid-item.is-visible {
                opacity: 1;
                transform: none;
                transition: opacity .42s ease, transform .42s ease;
            }

        .project-card {
            position: relative;
            overflow: hidden;
            min-height: 325px;
            color: var(--projects-ink) !important;
            border: 1px solid rgba(9, 35, 47, .09) !important;
            border-radius: 1.2rem;
            background: radial-gradient(circle 15rem at var(--pointer-x, 100%) var(--pointer-y, 0%), rgba(185, 229, 229, .28), transparent 52%), rgba(255, 255, 255, .9);
            box-shadow: 0 10px 28px rgba(9, 35, 47, .06);
            transition: transform .25s ease, box-shadow .25s ease, border-color .25s ease;
        }

            .project-card::before {
                content: "";
                position: absolute;
                inset: 0 auto 0 0;
                width: 4px;
                background: linear-gradient(180deg, var(--projects-sky), var(--projects-aqua));
            }

            .project-card:hover,
            .project-card:focus-visible {
                transform: translateY(-4px);
                border-color: rgba(147, 192, 222, .58) !important;
                box-shadow: 0 20px 42px rgba(9, 35, 47, .11);
            }

            .project-card:focus-visible {
                outline: 3px solid rgba(147, 192, 222, .48);
                outline-offset: 3px;
            }

        .project-folder-mark {
            display: inline-grid;
            place-items: center;
            flex: 0 0 auto;
            width: 2.75rem;
            height: 2.75rem;
            border-radius: .85rem;
            background: linear-gradient(145deg, rgba(147, 192, 222, .3), rgba(185, 229, 229, .42));
            color: #25586f;
            font-size: 1.15rem;
        }

        .project-card .card-title {
            color: var(--projects-ink);
            font-size: 1.08rem;
            line-height: 1.3;
        }

        .project-card .badge,
        .project-detail-heading .badge {
            padding: .48rem .68rem;
            border: 1px solid transparent;
            font-size: .7rem;
            font-weight: 750;
        }

        .project-card .bg-primary-subtle,
        .project-detail-heading .bg-primary-subtle {
            border-color: rgba(49, 95, 118, .18);
            background: rgba(147, 192, 222, .22) !important;
            color: #315f76 !important;
        }

        .project-card .bg-danger-subtle {
            border-color: rgba(35, 134, 91, .18);
            background: rgba(76, 175, 125, .14) !important;
            color: #237a55 !important;
        }

        .project-card .bg-warning-subtle {
            border-color: rgba(177, 137, 36, .17);
            background: rgba(216, 184, 91, .14) !important;
            color: #80651d !important;
        }

        .project-card .bg-info-subtle {
            border-color: rgba(105, 91, 161, .16);
            background: rgba(130, 149, 217, .16) !important;
            color: #584d91 !important;
        }

        .projects-workspace .project-status-badge {
            padding: .48rem .68rem;
            border: 1px solid transparent;
            font-size: .7rem;
            font-weight: 750;
        }

        .projects-workspace .badge.status-final {
            border-color: #cbbbe8;
            background: #65479b !important;
            color: #eee7fa !important;
        }

        .projects-workspace .badge.status-pending {
            border-color: rgba(177, 137, 36, .17);
            background: rgba(216, 184, 91, .16) !important;
            color: #80651d !important;
        }

        .projects-workspace .badge.status-progress {
            border-color: rgba(35, 134, 91, .18);
            background: rgba(76, 175, 125, .14) !important;
            color: #237a55 !important;
        }

        .projects-workspace .badge.status-custom {
            border-color: rgba(105, 91, 161, .16);
            background: rgba(130, 149, 217, .16) !important;
            color: #584d91 !important;
        }

        .project-card-kicker {
            color: #708087;
            font-size: .7rem;
            font-weight: 800;
            letter-spacing: .08em;
            text-transform: uppercase;
        }

        .project-description {
            display: -webkit-box;
            overflow: hidden;
            min-height: 4.65rem;
            color: #68777e;
            font-size: .86rem;
            line-height: 1.55;
            -webkit-box-orient: vertical;
            -webkit-line-clamp: 3;
        }

        .project-date-row {
            padding: .42rem .55rem;
            border-radius: .58rem;
            color: #607078;
            background: rgba(229, 229, 229, .42);
        }

        .project-card .d-flex.align-items-center.text-muted.small.mb-2 {
            padding: .42rem .55rem;
            border-radius: .58rem;
            background: rgba(229, 229, 229, .42);
        }

        .project-date-row i {
            width: 1.2rem;
            color: #4c83a0;
        }

        .project-card-action {
            border-top: 1px solid var(--projects-line);
        }

            .project-card-action .text-primary,
            .project-card .text-primary {
                color: #315f76 !important;
            }

            .project-card-action i {
                transition: transform .22s ease;
            }

        .project-card:hover .project-card-action i {
            transform: translateX(4px);
        }

        .project-card-header {
            border-bottom: 1px solid rgba(9, 35, 47, .08);
            background: rgba(255, 255, 255, .84);
        }

        .project-detail-card > .card-body > .mb-4 {
            padding: 1rem 1.1rem;
            border-left: 3px solid var(--projects-sky);
            border-radius: 0 .8rem .8rem 0;
            background: rgba(147, 192, 222, .09);
        }

        .project-metric {
            border: 1px solid rgba(9, 35, 47, .09);
            border-radius: .9rem;
            background: linear-gradient(145deg, rgba(255, 255, 255, .94), rgba(237, 245, 247, .84));
        }

            .project-metric i {
                color: #4b89a7 !important;
            }

        .project-table-card {
            overflow: hidden;
        }

        .project-section-icon {
            display: grid;
            place-items: center;
            min-width: 2.75rem;
            background: linear-gradient(145deg, rgba(147, 192, 222, .3), rgba(185, 229, 229, .36));
            color: #315f76;
        }

        .project-table thead th {
            padding: .85rem 1rem;
            border-bottom-color: rgba(9, 35, 47, .1);
            background: #edf3f5;
            color: #5d7079;
            font-size: .7rem;
            font-weight: 800;
            letter-spacing: .06em;
            text-transform: uppercase;
            white-space: nowrap;
        }

        .project-table tbody td {
            padding: 1rem;
            border-color: rgba(9, 35, 47, .07);
            color: #52646c;
            font-size: .86rem;
        }

        .project-table tbody tr:hover {
            background: rgba(185, 229, 229, .13);
        }

        .project-empty-state {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            gap: .3rem;
            width: 100%;
            min-height: 11rem;
            border: 1px dashed rgba(49, 95, 118, .26);
            border-radius: 1rem;
            background: rgba(255, 255, 255, .58);
            color: var(--projects-muted);
            text-align: center;
        }

            .project-empty-state i {
                margin-bottom: .35rem;
                color: #5f91a9;
                font-size: 2rem;
            }

            .project-empty-state strong {
                color: var(--projects-ink);
            }

            .project-empty-state span {
                font-size: .84rem;
            }

        .project-pagination .btn,
        .project-table-card .btn {
            border-radius: .65rem;
        }

        @media (max-width: 767.98px) {
            .project-context-chip {
                display: none;
            }

            .project-filter-panel .card-body,
            .project-status-toggle {
                width: 100%;
            }

                .project-status-toggle .btn {
                    flex: 1 1 50%;
                    min-width: 0;
                }
        }

        @media (max-width: 575.98px) {
            .project-page-heading {
                border-radius: 1rem;
            }

            .project-detail-heading > a {
                width: 100%;
                text-align: center;
            }

            .project-list-hint {
                display: none;
            }

            .project-card .card-body {
                padding: 1.25rem !important;
            }

            .project-description {
                min-height: auto;
            }
        }

        @media (prefers-reduced-motion: reduce) {
            .project-grid-item,
            .project-grid-item.is-visible,
            .project-card,
            .project-card-action i {
                opacity: 1;
                transform: none;
                transition: none;
            }
        }
    </style>

    <script type="text/javascript">
        document.addEventListener('DOMContentLoaded', function () {
            var appMain = document.querySelector('.app-main');
            if (appMain && document.querySelector('.projects-workspace')) {
                appMain.classList.add('projects-app-surface', 'projects-js');
            }

            var gridItems = document.querySelectorAll('.project-grid-item');
            var reducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

            if (!reducedMotion && 'IntersectionObserver' in window) {
                var revealObserver = new IntersectionObserver(function (entries, observer) {
                    entries.forEach(function (entry) {
                        if (entry.isIntersecting) {
                            entry.target.classList.add('is-visible');
                            observer.unobserve(entry.target);
                        }
                    });
                }, { threshold: 0.12 });

                gridItems.forEach(function (item, index) {
                    item.style.transitionDelay = Math.min(index * 55, 275) + 'ms';
                    revealObserver.observe(item);
                });
            } else {
                gridItems.forEach(function (item) {
                    item.classList.add('is-visible');
                });
            }

            document.querySelectorAll('[data-project-card]').forEach(function (card) {
                card.addEventListener('pointermove', function (event) {
                    var bounds = card.getBoundingClientRect();
                    card.style.setProperty('--pointer-x', (event.clientX - bounds.left) + 'px');
                    card.style.setProperty('--pointer-y', (event.clientY - bounds.top) + 'px');
                });
            });

            document.querySelectorAll('.project-status-badge, .project-card .badge').forEach(function (badge) {
                var state = badge.textContent.trim().toLocaleLowerCase('es');
                var semanticClass = state.indexOf('final') !== -1 || state.indexOf('complet') !== -1
                    ? 'status-final'
                    : state.indexOf('pendiente') !== -1
                        ? 'status-pending'
                        : state.indexOf('progreso') !== -1 || state.indexOf('curso') !== -1
                            ? 'status-progress'
                            : 'status-custom';
                badge.classList.add(semanticClass);
            });
        });
    </script>

</asp:Content>
