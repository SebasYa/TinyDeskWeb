<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="CrearUsuario.aspx.cs" Inherits="TP_Final_Programacion_III.CrearUsuario" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container-fluid user-form-workspace px-0 pt-2">
        <div class="row justify-content-center">
            <div class="col-12 col-xl-10 col-xxl-8">
                <div class="card user-form-card border-0">
                    <!-- Cabecera del Formulario -->
                    <div class="card-header user-form-header d-flex align-items-center justify-content-between flex-wrap gap-3">
                        <div class="user-form-heading">
                            <span class="user-form-eyebrow"><i class="bi bi-person-gear"></i>Gestión de equipo</span>
                            <h1 class="h3 mb-1 fw-bold">
                                <asp:Label ID="lblTituloFormularioUsuario" runat="server" Text="Crear Usuario"></asp:Label>
                            </h1>
                            <p class="mb-0">
                                <asp:Label ID="txtSubtitulo" runat="server" Visible="true" Text="Completá los datos para registrar un nuevo integrante del equipo"></asp:Label>
                            </p>
                        </div>
                        <div>
                            <a href="Usuarios.aspx" class="btn btn-outline-secondary user-form-back">
                                <i class="bi bi-arrow-left me-1"></i>Volver
                            </a>
                        </div>
                    </div>
                    <div class="card-body p-3 p-md-4 p-xl-5">
                        <asp:Literal ID="litMensajeFormulario" runat="server"></asp:Literal>
                        <!-- Sección 1: Datos Personales -->
                        <div class="user-form-section mb-4" data-form-section="true">
                            <h5 class="user-form-section-title border-bottom pb-2 mb-3">
                                <i class="bi bi-person-fill me-2"></i>1. Datos Personales
                            </h5>
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <label for="txtNombre" class="form-label fw-semibold">Nombre</label>
                                    <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control" placeholder="Ej: Juan"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvNombre" runat="server" ControlToValidate="txtNombre" ErrorMessage="El nombre es obligatorio." CssClass="text-danger text-validation-error" Display="Dynamic" />
                                </div>
                                <div class="col-md-6">
                                    <label for="txtApellido" class="form-label fw-semibold">Apellido</label>
                                    <asp:TextBox ID="txtApellido" runat="server" CssClass="form-control" placeholder="Ej: Pérez"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvApellido" runat="server" ControlToValidate="txtApellido" ErrorMessage="El apellido es obligatorio." CssClass="text-danger text-validation-error" Display="Dynamic" />
                                </div>
                                <div class="col-12">
                                    <label for="txtEmail" class="form-label fw-semibold">Correo Electrónico</label>
                                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="Ej: juan.perez@empresa.com" TextMode="Email"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail" ErrorMessage="El correo electrónico es obligatorio." CssClass="text-danger text-validation-error" Display="Dynamic" />
                                    <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtEmail" ErrorMessage="El formato del correo es inválido." CssClass="text-danger text-validation-error" Display="Dynamic" ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$" />
                                </div>
                            </div>
                        </div>
                        <!-- Sección 1: Datos Labolares -->
                        <asp:Panel ID="pnlAsignacionLaboral" runat="server" CssClass="user-form-section mb-4" data-form-section="true">

                            <h5 class="user-form-section-title border-bottom pb-2 mb-3">
                                <i class="bi bi-briefcase-fill me-2"></i>2. Asignación Laboral
                            </h5>
                            <div class="row g-3">
                                <div class="col-md-4">
                                    <label for="ddlArea" class="form-label fw-semibold">Área</label>
                                    <asp:DropDownList ID="ddlArea" runat="server" CssClass="form-select">
                                        <asp:ListItem Text="Seleccione un área..." Value="" />
                                    </asp:DropDownList>
                                    <asp:RequiredFieldValidator ID="rfvArea" runat="server" ControlToValidate="ddlArea" InitialValue="" ErrorMessage="Debe seleccionar un área." CssClass="text-danger text-validation-error" Display="Dynamic" />
                                </div>

                                <div class="col-md-4">
                                    <label for="ddlPuesto" class="form-label fw-semibold">Puesto Laboral</label>
                                    <asp:DropDownList ID="ddlPuesto" runat="server" CssClass="form-select">
                                        <asp:ListItem Text="Seleccione un puesto..." Value="" />
                                    </asp:DropDownList>
                                    <asp:RequiredFieldValidator ID="rfvPuesto" runat="server" ControlToValidate="ddlPuesto" InitialValue="" ErrorMessage="Debe seleccionar un puesto." CssClass="text-danger text-validation-error" Display="Dynamic" />
                                </div>

                                <div class="col-md-4">
                                    <label for="ddlSeniority" class="form-label fw-semibold">Seniority</label>
                                    <asp:DropDownList ID="ddlSeniority" runat="server" CssClass="form-select">
                                        <asp:ListItem Text="Seleccione un seniority..." Value="" />
                                    </asp:DropDownList>
                                </div>

                                <div class="col-12 col-lg-6 mt-3">
                                    <div class="user-permission-option form-check form-switch ps-5 fs-6">
                                        <input class="form-check-input" type="checkbox" id="chkPermisoEscritura" runat="server" clientidmode="Static" />
                                        <label class="form-check-label fw-semibold ps-2" for="chkPermisoEscritura">Permitir crear y gestionar tickets</label>
                                    </div>
                                </div>

                                <div class="col-12 col-lg-6 mt-3">
                                    <div class="user-permission-option form-check form-switch ps-5 fs-6">
                                        <input class="form-check-input" type="checkbox" id="chkEsAdmin" runat="server" clientidmode="Static" />
                                        <label class="form-check-label fw-semibold ps-2" for="chkEsAdmin">Permiso administrador</label>
                                    </div>
                                </div>
                            </div>
                        </asp:Panel>
                        <!-- Sección 3: Credenciales de Acceso -->
                        <div class="user-form-section mb-4" data-form-section="true">
                            <h5 class="user-form-section-title border-bottom pb-2 mb-3">
                                <i class="bi bi-key-fill me-2"></i>3. Credenciales de Acceso
                            </h5>
                            <div class="row g-3">
                                <div class="col-12">
                                    <label for="txtNombreUsuario" class="form-label fw-semibold">Nombre de Usuario</label>
                                    <asp:TextBox ID="txtNombreUsuario" runat="server" CssClass="form-control" placeholder="Ej: jperez"></asp:TextBox>
                                    <asp:RequiredFieldValidator ID="rfvNombreUsuario" runat="server" ControlToValidate="txtNombreUsuario" ErrorMessage="El usuario es obligatorio." CssClass="text-danger text-validation-error" Display="Dynamic" />
                                </div>
                            </div>
                        </div>
                        <asp:Panel ID="pnlActivoUsuario" runat="server" Visible="false" CssClass="user-active-panel col-12 mt-2">
                            <div class="form-check form-switch ps-5 fs-6">
                                <input class="form-check-input" type="checkbox" id="chkActivo" runat="server" clientidmode="Static" />
                                <label class="form-check-label fw-semibold ps-2" for="chkActivo">Usuario activo</label>
                            </div>
                        </asp:Panel>
                        <asp:Panel ID="pnlInvitacionVencida" runat="server" Visible="false" CssClass="user-invitation-alert alert alert-danger mt-3">
                            <div class="d-flex align-items-start gap-2">
                                <i class="bi bi-exclamation-circle-fill fs-5"></i>

                                <div class="flex-grow-1">
                                    <asp:Label ID="lblInvitacionVencida" runat="server"></asp:Label>

                                    <div class="mt-2">
                                        <asp:Button ID="btnReenviarInvitacion" runat="server"
                                            Text="Reenviar invitación"
                                            CssClass="btn btn-outline-danger btn-sm"
                                            CausesValidation="false"
                                            OnClick="btnReenviarInvitacion_Click" />
                                    </div>
                                </div>
                            </div>
                        </asp:Panel>
                        <!-- Botón de Guardado -->
                        <div class="user-form-submit mt-4 pt-2">
                            <asp:Button ID="btnCrearUsuario" runat="server" Text="Crear usuario" CssClass="btn user-submit-button w-100 py-2 fw-semibold" OnClick="btnCrearUsuario_Click" />
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <style>
        :root {
            --user-form-sky: #93c0de;
            --user-form-aqua: #b9e5e5;
            --user-form-ink: #09232f;
            --user-form-muted: #75797e;
            --user-form-surface: #f3f7f8;
            --user-form-line: rgba(9, 35, 47, .11);
        }

        .app-main.user-form-app-surface {
            background: radial-gradient(circle at 92% 3%, rgba(147, 192, 222, .23), transparent 25rem), radial-gradient(circle at 15% 88%, rgba(185, 229, 229, .18), transparent 30rem), linear-gradient(180deg, #f7f9fa 0%, var(--user-form-surface) 100%);
        }

        .user-form-workspace {
            width: 100%;
            max-width: 1540px;
            margin-inline: auto;
            color: var(--user-form-ink);
        }

        .user-form-card {
            overflow: hidden;
            border: 1px solid rgba(9, 35, 47, .08) !important;
            border-radius: 1.35rem;
            background: rgba(255, 255, 255, .86);
            box-shadow: 0 22px 58px rgba(9, 35, 47, .09);
            backdrop-filter: blur(12px);
        }

        .user-form-header {
            position: relative;
            overflow: hidden;
            padding: clamp(1.35rem, 2.4vw, 2rem);
            border-bottom: 1px solid rgba(9, 35, 47, .08);
            background: linear-gradient(110deg, rgba(255, 255, 255, .96), rgba(237, 247, 249, .9));
            isolation: isolate;
        }

            .user-form-header::after {
                content: "";
                position: absolute;
                z-index: -1;
                width: 13rem;
                aspect-ratio: 1;
                right: -4rem;
                top: -7rem;
                border: 2.4rem solid rgba(185, 229, 229, .34);
                border-radius: 50%;
            }

        .user-form-heading {
            max-width: 46rem;
        }

            .user-form-heading h1 {
                color: var(--user-form-ink);
                letter-spacing: -.025em;
            }

            .user-form-heading p {
                color: var(--user-form-muted);
            }

        .user-form-eyebrow {
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

        .user-form-back {
            --bs-btn-color: #58646a;
            --bs-btn-border-color: rgba(88, 100, 106, .3);
            border-radius: .72rem;
            background: rgba(255, 255, 255, .58);
            font-weight: 650;
        }

            .user-form-back:hover,
            .user-form-back:focus {
                border-color: var(--user-form-ink);
                background: var(--user-form-ink);
                color: #fff;
            }

        .user-form-section {
            position: relative;
            padding: clamp(1rem, 2vw, 1.35rem);
            border: 1px solid rgba(9, 35, 47, .08);
            border-radius: 1rem;
            background: linear-gradient(145deg, rgba(255, 255, 255, .92), rgba(241, 247, 248, .78));
        }

        .user-form-js .user-form-section {
            opacity: 0;
            transform: translateY(8px);
        }

            .user-form-js .user-form-section.is-visible {
                opacity: 1;
                transform: none;
                transition: opacity .38s ease, transform .38s ease;
            }

        .user-form-section-title {
            border-color: rgba(9, 35, 47, .09) !important;
            color: var(--user-form-ink);
            font-size: .98rem;
            letter-spacing: -.01em;
        }

            .user-form-section-title i {
                display: inline-grid;
                place-items: center;
                width: 2rem;
                height: 2rem;
                border-radius: .62rem;
                background: linear-gradient(145deg, rgba(147, 192, 222, .25), rgba(185, 229, 229, .36));
                color: #315f76;
            }

        .user-form-workspace .form-label {
            color: #39515c;
            font-size: .79rem;
            letter-spacing: .02em;
        }

        .user-form-workspace .form-control,
        .user-form-workspace .form-select {
            min-height: 45px;
            border-color: rgba(9, 35, 47, .14);
            border-radius: .72rem;
            background-color: rgba(255, 255, 255, .94);
            color: var(--user-form-ink);
        }

            .user-form-workspace .form-control:focus,
            .user-form-workspace .form-select:focus {
                border-color: #75a9c9;
                box-shadow: 0 0 0 .23rem rgba(147, 192, 222, .22);
            }

            .user-form-workspace .form-control:disabled,
            .user-form-workspace .form-select:disabled {
                background: #edf2f3;
                color: #718087;
            }

        .user-permission-option,
        .user-active-panel {
            min-height: 62px;
            display: flex;
            align-items: center;
            padding-top: .8rem;
            padding-right: 1rem;
            padding-bottom: .8rem;
            border: 1px solid rgba(147, 192, 222, .22);
            border-radius: .85rem;
            background: rgba(185, 229, 229, .11);
        }

        .user-active-panel {
            padding-left: 0;
        }

        .user-form-workspace .form-check-input:checked {
            border-color: var(--user-form-ink);
            background-color: var(--user-form-ink);
        }

        .user-form-workspace .form-check-input:focus {
            border-color: #75a9c9;
            box-shadow: 0 0 0 .22rem rgba(147, 192, 222, .2);
        }

        .user-invitation-alert {
            border: 1px solid rgba(184, 64, 77, .18);
            border-radius: .9rem;
            background: rgba(224, 91, 105, .09);
            color: #813841;
        }

            .user-invitation-alert .btn-outline-danger {
                border-radius: .65rem;
            }

        .user-submit-button {
            min-height: 48px;
            border: 1px solid var(--user-form-ink);
            border-radius: .8rem;
            background: var(--user-form-ink);
            color: #fff;
            box-shadow: 0 10px 22px rgba(9, 35, 47, .15);
        }

            .user-submit-button:hover,
            .user-submit-button:focus {
                border-color: #123d4f;
                background: #123d4f;
                color: #fff !important;
            }

        .user-form-workspace .alert-success,
        .user-form-workspace .alert-danger {
            border-radius: .85rem;
        }

        .form-control.is-invalid, .form-select.is-invalid {
            border-color: #dc3545 !important;
            box-shadow: 0 0 0 0.25rem rgba(220, 53, 69, 0.25) !important;
        }

        .text-validation-error {
            font-size: 0.875em;
            margin-top: 0.25rem;
            display: block;
        }

        @media (max-width: 575.98px) {
            .user-form-card {
                border-radius: 1rem;
            }

            .user-form-back {
                width: 100%;
            }

            .user-form-header > div:last-child {
                width: 100%;
            }

            .user-form-section {
                padding: 1rem;
            }
        }

        @media (prefers-reduced-motion: reduce) {
            .user-form-js .user-form-section,
            .user-form-js .user-form-section.is-visible {
                opacity: 1;
                transform: none;
                transition: none;
            }
        }
    </style>

    <script type="text/javascript">
        document.addEventListener('DOMContentLoaded', function () {
            var appMain = document.querySelector('.app-main');
            if (appMain && document.querySelector('.user-form-workspace')) {
                appMain.classList.add('user-form-app-surface', 'user-form-js');
            }

            var sections = document.querySelectorAll('[data-form-section]');
            var reducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

            if (!reducedMotion && 'IntersectionObserver' in window) {
                var observer = new IntersectionObserver(function (entries, sectionObserver) {
                    entries.forEach(function (entry) {
                        if (entry.isIntersecting) {
                            entry.target.classList.add('is-visible');
                            sectionObserver.unobserve(entry.target);
                        }
                    });
                }, { threshold: 0.08 });

                sections.forEach(function (section, index) {
                    section.style.transitionDelay = Math.min(index * 65, 195) + 'ms';
                    observer.observe(section);
                });
            } else {
                sections.forEach(function (section) {
                    section.classList.add('is-visible');
                });
            }
        });
    </script>
</asp:Content>
