<%@ Page Title="Administración" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Administracion.aspx.cs" Inherits="TP_Final_Programacion_III.Administracion" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        .admin-tabs {
            display: inline-flex;
            gap: 4px;
            padding: 5px;
            background: #f1f3f5;
            border: 1px solid #dee2e6;
            border-radius: 12px;
        }

            .admin-tabs .btn {
                border: 0;
                border-radius: 9px;
                color: #495057;
                font-weight: 600;
                padding: .55rem .85rem;
            }

                .admin-tabs .btn.active {
                    background: #212529;
                    color: #fff;
                }

        .admin-action {
            width: 34px;
            height: 34px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 8px;
            text-decoration: none;
        }
    </style>

    <asp:HiddenField ID="hfTipoActual" runat="server" Value="1" />

    <div class="container-fluid admin-workspace px-0 pt-2">
        <asp:Literal ID="litMensaje" runat="server"></asp:Literal>

        <div class="admin-page-heading d-flex justify-content-between align-items-start flex-wrap gap-3 mb-4">
            <div class="admin-heading-copy">
                <span class="admin-eyebrow"><i class="bi bi-sliders"></i>Configuración operativa</span>
                <h1 class="h2 fw-bold mb-1">Administración</h1>
                <p class="mb-0">Gestioná los catálogos que organizan el trabajo de tu empresa.</p>
            </div>

            <div class="admin-context-chip">
                <i class="bi bi-gear"></i>
                <span><strong>Catálogos</strong><small>Áreas, estados y puestos</small></span>
            </div>
        </div>

        <div class="row g-4 admin-catalog-layout align-items-start">
            <div class="col-12 col-lg-3">
                <aside class="admin-catalog-sidebar">
                    <div class="admin-sidebar-heading">
                        <span class="admin-sidebar-icon"><i class="bi bi-collection"></i></span>
                        <div>
                            <strong>Tipo de catálogo</strong>
                            <small>Elegí qué querés administrar</small>
                        </div>
                    </div>

                    <div class="admin-section-toolbar d-flex flex-column align-items-stretch gap-3">
                        <div class="admin-tabs">
                            <asp:LinkButton ID="btnArea" runat="server" OnClick="btnArea_Click">
                    <i class="bi bi-diagram-3 me-1"></i>Area
                            </asp:LinkButton>

                            <asp:LinkButton ID="btnEstado" runat="server" OnClick="btnEstado_Click">
                    <i class="bi bi-check2-circle me-1"></i>Estado
                            </asp:LinkButton>

                            <asp:LinkButton ID="btnPuesto" runat="server" OnClick="btnPuesto_Click">
                    <i class="bi bi-person-badge me-1"></i>Puestos
                            </asp:LinkButton>
                        </div>

                        <span class="admin-count-badge badge rounded-pill px-3 py-2">
                            <asp:Label ID="lblCantidad" runat="server"></asp:Label>
                        </span>
                    </div>

                    <div class="admin-sidebar-note">
                        <i class="bi bi-info-circle"></i>
                        <p>Los registros de sistema son globales y están protegidos. Los de tu empresa se pueden editar.</p>
                    </div>
                </aside>
            </div>

            <div class="col-12 col-lg-9">
                <section class="admin-catalog-main">

                    <div class="admin-filter-panel row g-3 align-items-center mb-4">
                        <div class="col-12 col-md-7 col-lg-8">
                            <div class="admin-search-group input-group">
                                <span class="input-group-text"><i class="bi bi-search"></i></span>
                                <asp:TextBox ID="txtFiltro" runat="server" CssClass="form-control" AutoPostBack="true" OnTextChanged="txtFiltro_TextChanged" />
                            </div>
                        </div>

                        <div class="col-12 col-md-5 col-lg-4 d-flex justify-content-md-end">
                            <asp:LinkButton ID="btnNuevo" runat="server" CssClass="btn admin-primary-action d-flex align-items-center justify-content-center gap-2" OnClick="btnNuevo_Click">
                                <i class="bi bi-plus-circle"></i>
                                <asp:Literal ID="litCrearTexto" runat="server"></asp:Literal>
                            </asp:LinkButton>
                        </div>
                    </div>

                    <div class="admin-list-label d-flex align-items-center justify-content-between flex-wrap gap-2 mb-3">
                        <div>
                            <h2 class="h5 fw-bold mb-1">Registros del catálogo</h2>
                            <p class="mb-0">Los registros del sistema son protegidos; los de empresa se pueden administrar.</p>
                        </div>
                        <span class="admin-list-hint"><i class="bi bi-shield-lock"></i>Origen identificado</span>
                    </div>

                    <div class="admin-table-card table-responsive">
                        <asp:ListView
                            ID="lvCatalogo"
                            runat="server"
                            ItemPlaceholderID="itemPlaceholder"
                            OnItemCommand="lvCatalogo_ItemCommand"
                            OnPagePropertiesChanging="lvCatalogo_PagePropertiesChanging">

                            <LayoutTemplate>
                                <table class="table admin-table table-hover align-middle mb-0">
                                    <thead class="table-light text-secondary fw-semibold border-bottom">
                                        <tr>
                                            <th>Nombre</th>
                                            <th>Origen</th>

                                            <asp:PlaceHolder
                                                ID="phFinalizaHeader"
                                                runat="server">

                                                <th>Finaliza</th>
                                            </asp:PlaceHolder>

                                            <th>Acciones</th>
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
                                <tr data-admin-row="true">
                                    <td>
                                        <div class="fw-bold text-dark">
                                            <%# Eval("Nombre") %>
                                        </div>

                                        <small class="text-muted">
                                            <%# GetTipoTexto() %>
                                        </small>
                                    </td>

                                    <td>
                                        <span class='<%# GetOrigenClass(Container.DataItem) %>'>
                                            <%# GetOrigenTexto(Container.DataItem) %>
                                        </span>
                                    </td>

                                    <asp:PlaceHolder
                                        ID="phFinalizaItem"
                                        runat="server"
                                        Visible='<%# MostrarColumnaFinaliza() %>'>

                                        <td>
                                            <span class='<%# GetEstadoFinalClass(Container.DataItem) %>'>
                                                <%# GetEstadoFinalTexto(Container.DataItem) %>
                                            </span>
                                        </td>
                                    </asp:PlaceHolder>

                                    <td>
                                        <asp:LinkButton
                                            ID="btnEditar"
                                            runat="server"
                                            CommandName="EditarRegistro"
                                            CommandArgument='<%# Eval("Id") %>'
                                            Enabled='<%# PuedeEditarEliminar(Container.DataItem) %>'
                                            CssClass='<%# GetBotonAccionClass(Container.DataItem, "edit") %>'>

                        <i class="bi bi-pencil"></i>
                                        </asp:LinkButton>

                                        <asp:LinkButton
                                            ID="btnEliminar"
                                            runat="server"
                                            CommandName="EliminarRegistro"
                                            CommandArgument='<%# Eval("Id") %>'
                                            Enabled='<%# PuedeEditarEliminar(Container.DataItem) %>'
                                            CssClass='<%# GetBotonAccionClass(Container.DataItem, "delete") %>'>

                        <i class="bi bi-trash"></i>
                                        </asp:LinkButton>
                                    </td>
                                </tr>
                            </ItemTemplate>

                            <EmptyDataTemplate>
                                <div class="admin-empty-state py-5">
                                    <i class="bi bi-inboxes"></i>
                                    <strong>No hay registros para mostrar</strong>
                                    <span>Probá con otro filtro o creá un registro nuevo.</span>
                                </div>
                            </EmptyDataTemplate>

                        </asp:ListView>
                    </div>

                    <div class="admin-pagination d-flex justify-content-center mt-4">
                        <asp:DataPager
                            ID="dpCatalogo"
                            runat="server"
                            PagedControlID="lvCatalogo"
                            PageSize="10">

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
            </div>
        </div>
    </div>

    <div class="modal fade" id="adminModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content admin-modal-content">
                <div class="modal-header admin-modal-header">
                    <h5 class="modal-title fw-bold">
                        <asp:Label ID="lblModalTitulo" runat="server"></asp:Label>
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>

                <div class="modal-body">
                    <asp:HiddenField ID="hdnRegistroId" runat="server" />

                    <div class="mb-3">
                        <asp:Label runat="server" AssociatedControlID="txtNombre" CssClass="form-label fw-semibold" Text="Nombre"></asp:Label>
                        <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control" MaxLength="50"></asp:TextBox>
                        <asp:Label ID="lblErrorModal" runat="server" CssClass="text-danger small mt-1 d-block" Visible="false"></asp:Label>
                    </div>

                    <div id="pnlEstadoExtra" runat="server" class="mt-3">
                        <div class="form-check form-switch ps-5 fs-6">
                            <input id="chkEsFinal" runat="server" type="checkbox" class="form-check-input" />
                            <label class="form-check-label fw-semibold ps-2" for="chkEsFinal">
                                Estado final
                            </label>
                        </div>
                    </div>
                </div>

                <div class="modal-footer admin-modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <asp:Button ID="btnGuardar" runat="server" CssClass="btn btn-primary" Text="Guardar" OnClick="btnGuardar_Click" />
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="eliminarModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content admin-modal-content admin-danger-modal">
                <div class="modal-header bg-danger-subtle">
                    <h5 class="modal-title fw-bold text-danger">Eliminar registro</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>

                <div class="modal-body">
                    <asp:HiddenField ID="hdnEliminarId" runat="server" />
                    <asp:HiddenField ID="hdnEliminarNombre" runat="server" />

                    <p class="mb-2">
                        Vas a eliminar <strong>
                            <asp:Label ID="lblEliminarNombre" runat="server"></asp:Label></strong>.
                    </p>

                    <p class="text-muted small mb-3">
                        Para confirmar, escribí el nombre en mayúscula:
                        <strong>
                            <asp:Literal ID="litNombreConfirmacion" runat="server"></asp:Literal></strong>
                    </p>

                    <asp:TextBox ID="txtConfirmarEliminar" runat="server" CssClass="form-control" autocomplete="off"></asp:TextBox>
                    <asp:Label ID="lblErrorEliminar" runat="server" CssClass="text-danger small mt-1 d-block" Visible="false"></asp:Label>
                </div>

                <div class="modal-footer admin-modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <asp:Button ID="btnConfirmarEliminar" runat="server" CssClass="btn btn-danger" Text="Eliminar" OnClick="btnConfirmarEliminar_Click" />
                </div>
            </div>
        </div>
    </div>

    <style>
        :root {
            --admin-sky: #93c0de;
            --admin-aqua: #b9e5e5;
            --admin-ink: #09232f;
            --admin-muted: #75797e;
            --admin-surface: #f3f7f8;
            --admin-line: rgba(9, 35, 47, .11);
            --admin-shadow: 0 18px 45px rgba(9, 35, 47, .075);
        }

        .app-main.admin-app-surface {
            background: radial-gradient(circle at 92% 3%, rgba(147, 192, 222, .23), transparent 25rem), radial-gradient(circle at 15% 88%, rgba(185, 229, 229, .18), transparent 30rem), linear-gradient(180deg, #f7f9fa 0%, var(--admin-surface) 100%);
        }

        .admin-workspace {
            width: 100%;
            max-width: 1540px;
            margin-inline: auto;
            color: var(--admin-ink);
        }

        .admin-page-heading {
            position: relative;
            overflow: hidden;
            padding: clamp(1.15rem, 2vw, 1.6rem);
            border: 1px solid rgba(147, 192, 222, .38);
            border-radius: 1.35rem;
            background: linear-gradient(110deg, rgba(255, 255, 255, .94), rgba(245, 251, 252, .86));
            box-shadow: 0 14px 36px rgba(9, 35, 47, .055);
            isolation: isolate;
        }

            .admin-page-heading::after {
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

        .admin-heading-copy h1,
        .admin-list-label h2,
        .admin-workspace h5 {
            color: var(--admin-ink);
            letter-spacing: -.025em;
        }

        .admin-heading-copy p,
        .admin-list-label p {
            color: var(--admin-muted);
        }

        .admin-eyebrow {
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

        .admin-context-chip {
            display: flex;
            align-items: center;
            gap: .75rem;
            padding: .68rem .85rem;
            border: 1px solid rgba(147, 192, 222, .45);
            border-radius: .9rem;
            background: rgba(255, 255, 255, .78);
        }

            .admin-context-chip > i {
                display: grid;
                place-items: center;
                width: 2.45rem;
                height: 2.45rem;
                border-radius: .72rem;
                background: linear-gradient(145deg, rgba(147, 192, 222, .3), rgba(185, 229, 229, .4));
                color: #315f76;
                font-size: 1.1rem;
            }

            .admin-context-chip span {
                display: flex;
                flex-direction: column;
                line-height: 1.2;
            }

            .admin-context-chip strong {
                color: var(--admin-ink);
                font-size: .82rem;
            }

            .admin-context-chip small {
                margin-top: .18rem;
                color: var(--admin-muted);
                font-size: .68rem;
            }

        .admin-section-toolbar,
        .admin-filter-panel,
        .admin-table-card {
            border: 1px solid rgba(9, 35, 47, .08);
            border-radius: 1.15rem;
            background: rgba(255, 255, 255, .84);
            box-shadow: var(--admin-shadow);
            backdrop-filter: blur(12px);
        }

        .admin-catalog-layout {
            max-width: 1320px;
            margin-inline: auto;
        }

        .admin-catalog-sidebar {
            position: sticky;
            top: 1rem;
            overflow: hidden;
            padding: 1rem;
            border: 1px solid rgba(9, 35, 47, .08);
            border-radius: 1.2rem;
            background: linear-gradient(155deg, rgba(255, 255, 255, .94), rgba(237, 245, 247, .88));
            box-shadow: var(--admin-shadow);
        }

        .admin-sidebar-heading {
            display: flex;
            align-items: center;
            gap: .75rem;
            padding: .25rem .2rem 1rem;
            border-bottom: 1px solid rgba(9, 35, 47, .08);
        }

        .admin-sidebar-icon {
            display: grid;
            place-items: center;
            width: 2.6rem;
            height: 2.6rem;
            flex: 0 0 auto;
            border-radius: .78rem;
            background: linear-gradient(145deg, rgba(147, 192, 222, .3), rgba(185, 229, 229, .42));
            color: #315f76;
        }

        .admin-sidebar-heading > div {
            display: flex;
            min-width: 0;
            flex-direction: column;
        }

        .admin-sidebar-heading strong {
            color: var(--admin-ink);
            font-size: .88rem;
        }

        .admin-sidebar-heading small {
            margin-top: .15rem;
            color: var(--admin-muted);
            font-size: .7rem;
        }

        .admin-sidebar-note {
            display: flex;
            align-items: flex-start;
            gap: .55rem;
            margin-top: 1rem;
            padding: .8rem;
            border: 1px solid rgba(147, 192, 222, .22);
            border-radius: .8rem;
            background: rgba(147, 192, 222, .09);
            color: #60737c;
        }

            .admin-sidebar-note i {
                color: #3f7894;
            }

            .admin-sidebar-note p {
                margin: 0;
                font-size: .72rem;
                line-height: 1.5;
            }

        .admin-catalog-main {
            min-width: 0;
        }

        .admin-section-toolbar {
            margin-top: .9rem;
            padding: 0;
            border: 0;
            background: transparent;
            box-shadow: none;
            backdrop-filter: none;
        }

        .admin-tabs {
            display: flex;
            width: 100%;
            flex-direction: column;
            gap: .25rem;
            padding: .3rem;
            border: 1px solid var(--admin-line);
            border-radius: .9rem;
            background: #edf3f4;
        }

            .admin-tabs .btn {
                display: flex;
                align-items: center;
                width: 100%;
                border: 0;
                border-radius: .68rem;
                background: transparent;
                color: #64747b;
                font-weight: 700;
                padding: .58rem .85rem;
                text-align: left;
            }

                .admin-tabs .btn:hover,
                .admin-tabs .btn:focus {
                    background: rgba(255, 255, 255, .75);
                    color: var(--admin-ink);
                }

                .admin-tabs .btn.active {
                    background: var(--admin-ink);
                    color: #fff;
                    box-shadow: 0 7px 16px rgba(9, 35, 47, .14);
                }

        .admin-count-badge {
            align-self: flex-start;
            border: 1px solid rgba(147, 192, 222, .35);
            background: rgba(147, 192, 222, .16);
            color: #315f76;
        }

        .admin-filter-panel {
            margin-inline: 0;
            padding: 1rem;
        }

        .admin-search-group .input-group-text,
        .admin-search-group .form-control,
        #adminModal .form-control,
        #eliminarModal .form-control {
            min-height: 44px;
            border-color: rgba(9, 35, 47, .14);
            background: rgba(255, 255, 255, .92);
        }

        .admin-search-group .input-group-text {
            border-radius: .75rem 0 0 .75rem;
            border-right: 0;
            color: #527080;
        }

        .admin-search-group .form-control {
            border-left: 0;
            border-radius: 0 .75rem .75rem 0;
        }

        .admin-search-group:focus-within {
            border-radius: .78rem;
            box-shadow: 0 0 0 .23rem rgba(147, 192, 222, .22);
        }

            .admin-search-group:focus-within .input-group-text,
            .admin-search-group:focus-within .form-control,
            #adminModal .form-control:focus,
            #eliminarModal .form-control:focus {
                border-color: #75a9c9;
                box-shadow: none;
            }

        .admin-primary-action,
        .admin-workspace .btn-primary,
        #adminModal .btn-primary {
            border-color: var(--admin-ink);
            border-radius: .75rem;
            background: var(--admin-ink);
            color: #fff;
            box-shadow: 0 8px 18px rgba(9, 35, 47, .14);
            font-weight: 700;
        }

        .admin-primary-action {
            padding: .7rem 1rem;
        }

            .admin-primary-action:hover,
            .admin-primary-action:focus,
            .admin-workspace .btn-primary:hover,
            .admin-workspace .btn-primary:focus,
            #adminModal .btn-primary:hover,
            #adminModal .btn-primary:focus {
                border-color: #123d4f;
                background: #123d4f;
                color: #fff !important;
            }

        .admin-workspace .btn-outline-primary {
            --bs-btn-color: #315a70;
            --bs-btn-border-color: rgba(49, 90, 112, .32);
            --bs-btn-hover-bg: var(--admin-ink);
            --bs-btn-hover-border-color: var(--admin-ink);
            border-radius: .68rem;
        }

        .admin-workspace .btn-outline-secondary {
            --bs-btn-color: #58646a;
            --bs-btn-border-color: rgba(88, 100, 106, .3);
            --bs-btn-hover-bg: var(--admin-ink);
            --bs-btn-hover-border-color: var(--admin-ink);
            --bs-btn-hover-color: #fff;
            border-radius: .68rem;
        }

        .admin-list-label {
            width: 100%;
            max-width: none;
            margin-inline: auto;
            padding-inline: .2rem;
        }

            .admin-list-label p {
                font-size: .86rem;
            }

        .admin-list-hint {
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

        .admin-table-card {
            width: 100%;
            max-width: none;
            margin-inline: auto;
            overflow: hidden;
        }

        .admin-table {
            min-width: 620px;
            table-layout: fixed;
        }

            .admin-table th:first-child {
                width: 50%;
            }

            .admin-table th:nth-child(2) {
                width: 25%;
            }

            .admin-table th:last-child {
                width: 25%;
            }

            .admin-table:has(th:nth-child(4)) th:first-child {
                width: 42%;
            }

            .admin-table:has(th:nth-child(4)) th:nth-child(2) {
                width: 22%;
            }

            .admin-table:has(th:nth-child(4)) th:nth-child(3) {
                width: 18%;
            }

            .admin-table:has(th:nth-child(4)) th:last-child {
                width: 18%;
            }

            .admin-table thead th {
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

            .admin-table tbody td {
                padding: 1rem;
                border-color: rgba(9, 35, 47, .07);
                color: #52646c;
                font-size: .85rem;
            }

            .admin-table tbody tr {
                transition: background-color .18s ease;
            }

        .admin-js .admin-table tbody tr {
            opacity: 0;
            transform: translateY(6px);
        }

            .admin-js .admin-table tbody tr.is-visible {
                opacity: 1;
                transform: none;
                transition: opacity .35s ease, transform .35s ease, background-color .18s ease;
            }

        .admin-table tbody tr:hover {
            background: rgba(185, 229, 229, .14);
        }

        .admin-table .badge {
            border: 1px solid transparent;
            border-radius: 999px;
        }

        .admin-table .text-bg-primary {
            border-color: rgba(105, 91, 161, .16);
            background: rgba(130, 149, 217, .16) !important;
            color: #584d91 !important;
        }

        .admin-table .text-bg-secondary {
            border-color: rgba(49, 95, 118, .17);
            background: rgba(147, 192, 222, .2) !important;
            color: #315f76 !important;
        }

        .admin-table .text-bg-success {
            border-color: rgba(35, 134, 91, .18);
            background: rgba(76, 175, 125, .14) !important;
            color: #237a55 !important;
        }

        .admin-table .text-bg-light {
            border-color: rgba(177, 137, 36, .17) !important;
            background: rgba(216, 184, 91, .14) !important;
            color: #80651d !important;
        }

        .admin-action {
            width: 2.15rem;
            height: 2.15rem;
            margin-right: .25rem;
            border-radius: .65rem;
            background: rgba(147, 192, 222, .14);
            color: #315f76 !important;
            transition: background-color .18s ease, color .18s ease;
        }

            .admin-action.text-danger {
                background: rgba(224, 91, 105, .11);
                color: #a23d49 !important;
            }

            .admin-action:not(.opacity-25):hover,
            .admin-action:not(.opacity-25):focus {
                background: var(--admin-ink);
                color: #fff !important;
            }

        .admin-empty-state {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            gap: .3rem;
            min-height: 12rem;
            border: 1px dashed rgba(49, 95, 118, .26);
            border-radius: 1rem;
            background: rgba(255, 255, 255, .58);
            color: var(--admin-muted);
            text-align: center;
        }

            .admin-empty-state i {
                margin-bottom: .35rem;
                color: #5f91a9;
                font-size: 2rem;
            }

            .admin-empty-state strong {
                color: var(--admin-ink);
            }

            .admin-empty-state span {
                font-size: .84rem;
            }

        .admin-pagination .btn {
            border-radius: .65rem;
        }

        .admin-modal-content {
            overflow: hidden;
            border: 1px solid rgba(9, 35, 47, .1);
            border-radius: 1.15rem;
            box-shadow: 0 28px 80px rgba(9, 35, 47, .24);
        }

        .admin-modal-header,
        .admin-modal-footer {
            border-color: rgba(9, 35, 47, .08);
            background: #f2f7f8;
        }

        .admin-danger-modal {
            border-color: rgba(220, 53, 69, .2);
        }

        #adminModal .form-check-input:checked {
            border-color: var(--admin-ink);
            background-color: var(--admin-ink);
        }

        @media (max-width: 767.98px) {
            .admin-context-chip {
                display: none;
            }

            .admin-section-toolbar,
            .admin-tabs {
                width: 100%;
            }

                .admin-tabs .btn {
                    flex: 1 1 auto;
                }

            .admin-count-badge {
                margin-left: auto;
            }

            .admin-primary-action {
                width: 100%;
            }
        }

        @media (max-width: 575.98px) {
            .admin-page-heading {
                border-radius: 1rem;
            }

            .admin-list-hint {
                display: none;
            }
        }

        @media (max-width: 991.98px) {
            .admin-catalog-sidebar {
                position: static;
            }

            .admin-tabs {
                flex-direction: row;
            }

                .admin-tabs .btn {
                    justify-content: center;
                    text-align: center;
                }

            .admin-sidebar-note {
                display: none;
            }
        }

        @media (prefers-reduced-motion: reduce) {
            .admin-js .admin-table tbody tr,
            .admin-js .admin-table tbody tr.is-visible {
                opacity: 1;
                transform: none;
                transition: none;
            }
        }
    </style>

    <script type="text/javascript">
        document.addEventListener('DOMContentLoaded', function () {
            var appMain = document.querySelector('.app-main');
            if (appMain && document.querySelector('.admin-workspace')) {
                appMain.classList.add('admin-app-surface', 'admin-js');
            }

            var rows = document.querySelectorAll('[data-admin-row]');
            var reducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

            if (!reducedMotion && 'IntersectionObserver' in window) {
                var observer = new IntersectionObserver(function (entries, rowObserver) {
                    entries.forEach(function (entry) {
                        if (entry.isIntersecting) {
                            entry.target.classList.add('is-visible');
                            rowObserver.unobserve(entry.target);
                        }
                    });
                }, { threshold: 0.08 });

                rows.forEach(function (row, index) {
                    row.style.transitionDelay = Math.min(index * 35, 210) + 'ms';
                    observer.observe(row);
                });
            } else {
                rows.forEach(function (row) {
                    row.classList.add('is-visible');
                });
            }
        });
    </script>

</asp:Content>
