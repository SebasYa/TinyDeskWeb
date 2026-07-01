<%@ Page Title="Usuarios" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Usuarios.aspx.cs" Inherits="TP_Final_Programacion_III.Usuarios" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container-fluid users-workspace px-0 pt-2">
        <div class="users-page-heading d-flex justify-content-between align-items-start flex-wrap gap-3 mb-4">
            <div class="users-heading-copy">
                <span class="users-eyebrow"><i class="bi bi-people"></i>Equipo y accesos</span>
                <h1 class="h2 fw-bold mb-1">Gestión de usuarios</h1>
                <p class="mb-0">Administrá perfiles, permisos e invitaciones de tu organización.</p>
            </div>
            <a href="CrearUsuario.aspx" class="btn users-primary-action d-flex align-items-center gap-2">
                <i class="bi bi-person-plus"></i>Crear usuario
            </a>
        </div>
        <asp:Panel ID="pnlFiltroSimple" runat="server" CssClass="card users-filter-panel border-0 mb-3" DefaultButton="btnBuscarUsuario">
            <div class="card-body p-3 p-lg-4">
                <div class="row g-3 align-items-end">

                    <div class="col-12 col-lg-7">
                        <label for="txtFiltroSimple" class="form-label fw-semibold">
                            Buscar usuario
                        </label>

                        <div class="input-group users-search-group">
                            <span class="input-group-text bg-white">
                                <i class="bi bi-search text-muted"></i>
                            </span>

                            <asp:TextBox
                                ID="txtFiltroSimple"
                                runat="server"
                                CssClass="form-control"
                                placeholder="Buscar..." />
                        </div>
                    </div>

                    <div class="col-12 col-lg-2">
                        <div class="form-check form-switch ps-5 fs-6 mb-2">
                            <input
                                class="form-check-input"
                                type="checkbox"
                                id="chkFiltroAvanzado"
                                runat="server"
                                clientidmode="Static"
                                onserverchange="chkFiltroAvanzado_ServerChange"
                                onchange="this.form.submit();" />

                            <label class="form-check-label fw-semibold ps-2" for="chkFiltroAvanzado">
                                Filtro avanzado
                            </label>
                        </div>
                    </div>

                    <div class="col-12 col-lg-3 d-flex gap-2 justify-content-lg-end">
                        <asp:Button
                            ID="btnBuscarUsuario"
                            runat="server"
                            Text="Buscar"
                            CssClass="btn btn-primary px-4"
                            OnClick="btnBuscarUsuario_Click" />

                        <asp:Button
                            ID="btnLimpiarFiltro"
                            runat="server"
                            Text="Limpiar"
                            CssClass="btn btn-outline-secondary px-4"
                            OnClick="btnLimpiarFiltro_Click" />
                    </div>

                </div>
            </div>
        </asp:Panel>

        <asp:Panel ID="pnlFiltroAvanzado" runat="server" Visible="false" CssClass="card users-filter-panel users-advanced-filter border-0 mb-4">
            <div class="card-body p-3 p-lg-4">
                <h5 class="users-filter-title border-bottom pb-2 mb-3">
                    <i class="bi bi-funnel-fill me-2"></i>Filtro avanzado
                </h5>

                <div class="row g-3">
                    <div class="col-12 col-md-4">
                        <label for="ddlFiltroArea" class="form-label fw-semibold">Área</label>
                        <asp:DropDownList ID="ddlFiltroArea" runat="server" CssClass="form-select"></asp:DropDownList>
                    </div>

                    <div class="col-12 col-md-4">
                        <label for="ddlFiltroPuesto" class="form-label fw-semibold">Puesto</label>
                        <asp:DropDownList ID="ddlFiltroPuesto" runat="server" CssClass="form-select"></asp:DropDownList>
                    </div>

                    <div class="col-12 col-md-4">
                        <label for="ddlFiltroSeniority" class="form-label fw-semibold">Seniority</label>
                        <asp:DropDownList ID="ddlFiltroSeniority" runat="server" CssClass="form-select"></asp:DropDownList>
                    </div>

                    <div class="col-12 col-md-4">
                        <label for="ddlFiltroEstado" class="form-label fw-semibold">Estado</label>
                        <asp:DropDownList ID="ddlFiltroEstado" runat="server" CssClass="form-select">
                            <asp:ListItem Text="Todos" Value="-1" />
                            <asp:ListItem Text="Activos" Value="1" />
                            <asp:ListItem Text="Inactivos" Value="0" />
                        </asp:DropDownList>
                    </div>

                    <div class="col-12 col-md-4">
                        <label for="ddlFiltroPermiso" class="form-label fw-semibold">Permiso</label>
                        <asp:DropDownList ID="ddlFiltroPermiso" runat="server" CssClass="form-select">
                            <asp:ListItem Text="Todos" Value="" />
                            <asp:ListItem Text="Administrador" Value="admin" />
                            <asp:ListItem Text="Gestión habilitada" Value="gestion" />
                            <asp:ListItem Text="Solo lectura" Value="lectura" />
                        </asp:DropDownList>
                    </div>

                    <div class="col-12 col-md-4 d-flex align-items-end gap-2 justify-content-md-end">
                        <asp:Button
                            ID="btnAplicarFiltroAvanzado"
                            runat="server"
                            Text="Aplicar"
                            CssClass="btn btn-primary px-4"
                            OnClick="btnAplicarFiltroAvanzado_Click" />

                        <asp:Button
                            ID="btnLimpiarFiltroAvanzado"
                            runat="server"
                            Text="Limpiar"
                            CssClass="btn btn-outline-secondary px-4"
                            OnClick="btnLimpiarFiltroAvanzado_Click" />
                    </div>
                </div>
            </div>
        </asp:Panel>

        <div class="users-list-label d-flex align-items-center justify-content-between flex-wrap gap-2 mb-3 mt-4">
            <div>
                <h2 class="h5 fw-bold mb-1">Directorio de usuarios</h2>
                <p class="mb-0">Información laboral, acceso e invitación en una sola vista.</p>
            </div>
            <span class="users-list-hint"><i class="bi bi-shield-check"></i>Gestión de acceso</span>
        </div>

        <div class="users-table-card table-responsive">
            <asp:ListView
                ID="lvUsuarios"
                runat="server"
                ItemPlaceholderID="itemPlaceholder"
                OnPagePropertiesChanging="lvUsuarios_PagePropertiesChanging">

                <LayoutTemplate>
                    <table class="table users-table table-hover align-middle mb-0">
                        <thead>
                            <tr>
                                <th>Apellido</th>
                                <th>Nombre</th>
                                <th>Usuario</th>
                                <th>Correo Electrónico</th>
                                <th>Área</th>
                                <th>Puesto</th>
                                <th>Seniority</th>
                                <th>Permiso</th>
                                <th>Activo</th>
                                <th>Invitación</th>
                                <th>Editar</th>
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
                    <tr data-user-row="true">
                        <td><%# Eval("Apellido") %></td>

                        <td><%# Eval("Nombre") %></td>

                        <td><%# Eval("NombreUsuario") %></td>

                        <td><%# Eval("Email") %></td>

                        <td><%# Eval("Area.Nombre") %></td>

                        <td><%# Eval("Puesto.Nombre") %></td>

                        <td><%# Eval("Seniority.Nombre") %></td>

                        <td>
                            <asp:Literal
                                ID="litPermisoUsuario"
                                runat="server"
                                Mode="PassThrough"
                                Text='<%# ObtenerIconoPermiso(Eval("EsAdmin"), Eval("PermisoEscritura")) %>'>
                            </asp:Literal>
                        </td>

                        <td>
                            <span
                                class='<%# "user-state-indicator " + ((bool)Eval("Activo") ? "text-success" : "text-danger") %>'
                                title='<%# (bool)Eval("Activo") ? "Usuario activo" : "Usuario inactivo" %>'>

                                <i class='<%# (bool)Eval("Activo") ? "bi bi-check-circle-fill" : "bi bi-x-circle-fill" %>'></i>
                            </span>
                        </td>

                        <td>
                            <asp:Literal
                                ID="litInvitacion"
                                runat="server"
                                Mode="PassThrough"
                                Text='<%# ObtenerIconoInvitacion(Eval("Id"), Eval("EmailVerificado")) %>'>
                            </asp:Literal>
                        </td>

                        <td>
                            <asp:LinkButton
                                ID="btnEditarUsuario"
                                runat="server"
                                CssClass="user-edit-action btn btn-link p-0 lh-1"
                                CommandArgument='<%# Eval("Id") %>'
                                CausesValidation="false"
                                OnClick="btnEditarUsuario_Click">

                        <i class="bi bi-pencil text-muted"></i>
                            </asp:LinkButton>
                        </td>
                    </tr>
                </ItemTemplate>

                <EmptyDataTemplate>
                    <div class="users-empty-state py-5">
                        <i class="bi bi-people"></i>
                        <strong>No hay usuarios para mostrar</strong>
                        <span>Probá modificando los criterios de búsqueda.</span>
                    </div>
                </EmptyDataTemplate>

            </asp:ListView>
        </div>

        <div class="users-pagination d-flex justify-content-center mt-4">
            <asp:DataPager
                ID="dpUsuarios"
                runat="server"
                PagedControlID="lvUsuarios"
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
    </div>

    <style>
        :root {
            --users-sky: #93c0de;
            --users-aqua: #b9e5e5;
            --users-ink: #09232f;
            --users-muted: #75797e;
            --users-surface: #f3f7f8;
            --users-line: rgba(9, 35, 47, .11);
            --users-shadow: 0 18px 45px rgba(9, 35, 47, .075);
        }

        .app-main.users-app-surface {
            background: radial-gradient(circle at 92% 3%, rgba(147, 192, 222, .23), transparent 25rem), radial-gradient(circle at 15% 88%, rgba(185, 229, 229, .18), transparent 30rem), linear-gradient(180deg, #f7f9fa 0%, var(--users-surface) 100%);
        }

        .users-workspace {
            width: 100%;
            max-width: 1540px;
            margin-inline: auto;
            color: var(--users-ink);
        }

        .users-page-heading {
            position: relative;
            overflow: hidden;
            padding: clamp(1.35rem, 2.4vw, 2rem);
            border: 1px solid rgba(147, 192, 222, .38);
            border-radius: 1.35rem;
            background: linear-gradient(110deg, rgba(255, 255, 255, .94), rgba(245, 251, 252, .86));
            box-shadow: 0 14px 36px rgba(9, 35, 47, .055);
            isolation: isolate;
        }

            .users-page-heading::after {
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

        .users-heading-copy h1,
        .users-list-label h2,
        .users-workspace h5 {
            color: var(--users-ink);
            letter-spacing: -.025em;
        }

        .users-heading-copy p,
        .users-list-label p {
            color: var(--users-muted);
        }

        .users-eyebrow {
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

        .users-primary-action,
        .users-workspace .btn-primary {
            border-color: var(--users-ink);
            border-radius: .78rem;
            background: var(--users-ink);
            color: #fff;
            box-shadow: 0 8px 18px rgba(9, 35, 47, .14);
            font-weight: 700;
        }

        .users-primary-action {
            padding: .72rem 1.05rem;
        }

            .users-primary-action:hover,
            .users-primary-action:focus,
            .users-workspace .btn-primary:hover,
            .users-workspace .btn-primary:focus {
                border-color: #123d4f;
                background: #123d4f;
                color: #fff !important;
            }

        .users-workspace .btn-outline-primary {
            --bs-btn-color: #315a70;
            --bs-btn-border-color: rgba(49, 90, 112, .32);
            --bs-btn-hover-bg: var(--users-ink);
            --bs-btn-hover-border-color: var(--users-ink);
            border-radius: .68rem;
        }

        .users-workspace .btn-outline-secondary {
            --bs-btn-color: #58646a;
            --bs-btn-border-color: rgba(88, 100, 106, .3);
            --bs-btn-hover-bg: var(--users-ink);
            --bs-btn-hover-border-color: var(--users-ink);
            --bs-btn-hover-color: #fff;
            border-radius: .68rem;
        }

        .users-filter-panel,
        .users-table-card {
            border: 1px solid rgba(9, 35, 47, .08) !important;
            border-radius: 1.2rem;
            background: rgba(255, 255, 255, .84);
            box-shadow: var(--users-shadow);
            backdrop-filter: blur(12px);
        }

            .users-filter-panel .form-label {
                color: #39515c;
                font-size: .78rem;
                letter-spacing: .025em;
            }

            .users-search-group .input-group-text,
            .users-search-group .form-control,
            .users-filter-panel .form-select {
                min-height: 44px;
                border-color: rgba(9, 35, 47, .14);
                background-color: rgba(255, 255, 255, .92);
            }

        .users-search-group .input-group-text {
            border-radius: .75rem 0 0 .75rem;
            border-right: 0;
        }

        .users-search-group .form-control {
            border-left: 0;
            border-radius: 0 .75rem .75rem 0;
        }

        .users-search-group:focus-within {
            border-radius: .78rem;
            box-shadow: 0 0 0 .23rem rgba(147, 192, 222, .22);
        }

            .users-search-group:focus-within .input-group-text,
            .users-search-group:focus-within .form-control,
            .users-filter-panel .form-select:focus {
                border-color: #75a9c9;
                box-shadow: none;
            }

        .users-filter-title {
            border-color: rgba(9, 35, 47, .09) !important;
            color: #315f76;
            font-size: .95rem;
        }

        .users-workspace .form-check-input:checked {
            border-color: var(--users-ink);
            background-color: var(--users-ink);
        }

        .users-workspace .form-check-input:focus {
            border-color: #75a9c9;
            box-shadow: 0 0 0 .22rem rgba(147, 192, 222, .2);
        }

        .users-list-label {
            padding-inline: .2rem;
        }

            .users-list-label p {
                font-size: .86rem;
            }

        .users-list-hint {
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

        .users-table-card {
            overflow: hidden;
        }

        .users-table {
            min-width: 1250px;
        }

            .users-table thead th {
                padding: .88rem .9rem;
                border-bottom-color: rgba(9, 35, 47, .1);
                background: #eaf1f3;
                color: #526873;
                font-size: .68rem;
                font-weight: 800;
                letter-spacing: .055em;
                text-transform: uppercase;
                white-space: nowrap;
            }

            .users-table tbody td {
                padding: .95rem .9rem;
                border-color: rgba(9, 35, 47, .07);
                color: #52646c;
                font-size: .82rem;
                vertical-align: middle;
            }

            .users-table tbody tr {
                transition: background-color .18s ease;
            }

        .users-js .users-table tbody tr {
            opacity: 0;
            transform: translateY(6px);
        }

            .users-js .users-table tbody tr.is-visible {
                opacity: 1;
                transform: none;
                transition: opacity .35s ease, transform .35s ease, background-color .18s ease;
            }

        .users-table tbody tr:hover {
            background: rgba(185, 229, 229, .14);
        }

        .users-table td:nth-child(3),
        .users-table td:nth-child(4) {
            color: var(--users-ink);
            font-weight: 600;
        }

        .users-table td .text-primary,
        .users-table td .text-info,
        .users-table td .text-secondary,
        .users-table td .text-success,
        .users-table td .text-warning,
        .users-table td .text-danger,
        .user-state-indicator,
        .user-edit-action {
            display: inline-grid;
            place-items: center;
            width: 2rem;
            height: 2rem;
            margin-right: .2rem;
            border-radius: .65rem;
            background: rgba(147, 192, 222, .14);
            color: #315f76 !important;
            font-size: .92rem;
            text-decoration: none;
        }

            .users-table td .text-success,
            .user-state-indicator.text-success {
                background: rgba(76, 175, 125, .14);
                color: #237a55 !important;
            }

        .users-table td .text-warning {
            background: rgba(216, 184, 91, .16);
            color: #80651d !important;
        }

        .users-table td .text-danger,
        .user-state-indicator.text-danger {
            background: rgba(224, 91, 105, .13);
            color: #a23d49 !important;
        }

        .users-table td .text-secondary {
            background: rgba(130, 149, 217, .14);
            color: #584d91 !important;
        }

        .user-edit-action:hover,
        .user-edit-action:focus {
            background: var(--users-ink);
            color: #fff !important;
        }

        .users-empty-state {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            gap: .3rem;
            min-height: 12rem;
            border: 1px dashed rgba(49, 95, 118, .26);
            border-radius: 1rem;
            background: rgba(255, 255, 255, .58);
            color: var(--users-muted);
            text-align: center;
        }

            .users-empty-state i {
                margin-bottom: .35rem;
                color: #5f91a9;
                font-size: 2rem;
            }

            .users-empty-state strong {
                color: var(--users-ink);
            }

            .users-empty-state span {
                font-size: .84rem;
            }

        .users-pagination .btn {
            border-radius: .65rem;
        }

        @media (max-width: 767.98px) {
            .users-page-heading .users-primary-action {
                min-height: 44px;
            }

            .users-filter-panel .btn {
                flex: 1 1 auto;
            }
        }

        @media (max-width: 575.98px) {
            .users-page-heading {
                border-radius: 1rem;
            }

            .users-primary-action {
                width: 100%;
                justify-content: center;
            }

            .users-list-hint {
                display: none;
            }
        }

        @media (prefers-reduced-motion: reduce) {
            .users-js .users-table tbody tr,
            .users-js .users-table tbody tr.is-visible {
                opacity: 1;
                transform: none;
                transition: none;
            }
        }
    </style>

    <script type="text/javascript">
        document.addEventListener('DOMContentLoaded', function () {
            var appMain = document.querySelector('.app-main');
            if (appMain && document.querySelector('.users-workspace')) {
                appMain.classList.add('users-app-surface', 'users-js');
            }

            var rows = document.querySelectorAll('[data-user-row]');
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
                    row.style.transitionDelay = Math.min(index * 30, 180) + 'ms';
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
