<%@ Page Title="Configuración" Language="C#" MasterPageFile="~/UsuarioSite.Master" AutoEventWireup="true" CodeBehind="ConfiguracionUsuarioSinPermiso.aspx.cs" Inherits="TP_Final_Programacion_III.ConfiguracionUsuarioSinPermiso" %>

<asp:Content
    ID="BodyContent"
    ContentPlaceHolderID="MainContent"
    runat="server">

    <div class="container-fluid config-workspace px-0 pt-2">

        <asp:Literal
            ID="litMensaje"
            runat="server">
        </asp:Literal>

        <!-- ENCABEZADO -->
        <div class="config-hero d-flex justify-content-between align-items-start flex-wrap gap-3 mb-4">
            <div class="config-hero-copy">
                <span class="config-eyebrow"><i class="bi bi-stars"></i>Espacio personal</span>
                <h1 class="h3 fw-bold mb-1">Configuración de cuenta</h1>
                <p class="mb-0">Consultá tus datos, personalizá tu perfil y administrá la seguridad.</p>
            </div>

            <div class="config-security-chip">
                <i class="bi bi-shield-check"></i>
                <span><strong>Cuenta protegida</strong><small>Acceso de consulta</small></span>
            </div>
        </div>

        <div class="row g-4 config-layout align-items-start">

            <!-- NAVEGACIÓN INTERNA -->
            <div class="col-12 col-lg-3 config-nav-column">
                <div class="list-group config-nav">

                    <div class="config-nav-heading">
                        <span class="config-nav-mark"><i class="bi bi-person-circle"></i></span>
                        <div><strong>Tu cuenta</strong><small>Preferencias y seguridad</small></div>
                    </div>

                    <asp:LinkButton
                        ID="btnPerfil"
                        runat="server"
                        CssClass="list-group-item list-group-item-action"
                        CausesValidation="false"
                        OnClick="btnPerfil_Click">

                        <i class="bi bi-person me-2"></i>
                        Mi perfil

                    </asp:LinkButton>

                    <asp:LinkButton
                        ID="btnInformacionLaboral"
                        runat="server"
                        CssClass="list-group-item list-group-item-action"
                        CausesValidation="false"
                        OnClick="btnInformacionLaboral_Click">

                        <i class="bi bi-briefcase me-2"></i>
                        Información laboral

                    </asp:LinkButton>

                    <asp:LinkButton
                        ID="btnSeguridad"
                        runat="server"
                        CssClass="list-group-item list-group-item-action"
                        CausesValidation="false"
                        OnClick="btnSeguridad_Click">

                        <i class="bi bi-shield-lock me-2"></i>
                        Seguridad

                    </asp:LinkButton>

                    <asp:LinkButton
                        ID="btnPreferencias"
                        runat="server"
                        CssClass="list-group-item list-group-item-action"
                        CausesValidation="false"
                        OnClick="btnPreferencias_Click">

                        <i class="bi bi-sliders me-2"></i>
                        Imagen de Perfil
                    </asp:LinkButton>

                </div>
            </div>

            <!-- CONTENIDO -->
            <div class="col-12 col-lg-9 config-content">

                <!-- PERFIL -->
                <asp:Panel
                    ID="pnlPerfil"
                    runat="server"
                    data-config-panel="true">

                    <div class="card border-0 shadow-sm config-card">

                        <div class="card-header bg-white p-4">
                            <div class="d-flex align-items-center gap-3">

                                <asp:Panel
                                    ID="pnlAvatarPerfil"
                                    runat="server"
                                    CssClass="config-avatar">

                                    <asp:Label
                                        ID="lblIniciales"
                                        runat="server">
                                    </asp:Label>
                                </asp:Panel>

                                <div>
                                    <h2 class="h5 fw-bold mb-1">Mi perfil
                                    </h2>

                                    <p class="text-muted mb-0">
                                        Información personal asociada a tu cuenta.
                                    </p>
                                </div>

                            </div>
                        </div>

                        <div class="card-body p-4 border-top">
                            <div class="row g-4">

                                <div class="col-md-6">
                                    <span class="config-label">Nombre
                                    </span>

                                    <div class="config-readonly">
                                        <asp:Label
                                            ID="lblNombre"
                                            runat="server">
                                        </asp:Label>

                                        <i class="bi bi-lock-fill text-muted ms-auto"></i>
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <span class="config-label">Apellido
                                    </span>

                                    <div class="config-readonly">
                                        <asp:Label
                                            ID="lblApellido"
                                            runat="server">
                                        </asp:Label>

                                        <i class="bi bi-lock-fill text-muted ms-auto"></i>
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <span class="config-label">Nombre de usuario
                                    </span>

                                    <div class="config-readonly">
                                        <asp:Label
                                            ID="lblNombreUsuario"
                                            runat="server">
                                        </asp:Label>

                                        <i class="bi bi-lock-fill text-muted ms-auto"></i>
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <span class="config-label">Correo electrónico
                                    </span>

                                    <div class="config-readonly">
                                        <asp:Label
                                            ID="lblEmail"
                                            runat="server">
                                        </asp:Label>

                                        <i class="bi bi-lock-fill text-muted ms-auto"></i>
                                    </div>
                                </div>

                                <div class="col-12">
                                    <div class="alert alert-light border mb-0">
                                        <div class="d-flex align-items-start gap-2">

                                            <i class="bi bi-info-circle-fill text-primary mt-1"></i>

                                            <div>
                                                <div class="fw-semibold">
                                                    Información administrada por la organización
                                                </div>

                                                <div class="small text-muted mt-1">
                                                    Para modificar tu nombre, apellido,
                                                    correo electrónico o nombre de usuario,
                                                    comunicate con un administrador.
                                                </div>
                                            </div>

                                        </div>
                                    </div>
                                </div>

                            </div>
                        </div>

                    </div>

                </asp:Panel>

                <!-- INFORMACIÓN LABORAL -->
                <asp:Panel
                    ID="pnlInformacionLaboral"
                    runat="server"
                    data-config-panel="true"
                    Visible="false">

                    <div class="card border-0 shadow-sm config-card">

                        <div class="card-header bg-white p-4">
                            <div class="d-flex justify-content-between align-items-start gap-3">

                                <div>
                                    <h2 class="h5 fw-bold mb-1">Información laboral
                                    </h2>

                                    <p class="text-muted mb-0">
                                        Información de tu posición dentro de la organización.
                                    </p>
                                </div>

                            </div>
                        </div>

                        <div class="card-body p-4 border-top">
                            <div class="row g-3">

                                <div class="col-md-6">
                                    <div class="laboral-card">

                                        <div class="laboral-icon">
                                            <i class="bi bi-building"></i>
                                        </div>

                                        <div>
                                            <span class="config-label">Empresa
                                            </span>

                                            <div class="fw-semibold">
                                                <asp:Label
                                                    ID="lblEmpresa"
                                                    runat="server">
                                                </asp:Label>
                                            </div>
                                        </div>

                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="laboral-card">

                                        <div class="laboral-icon">
                                            <i class="bi bi-diagram-3"></i>
                                        </div>

                                        <div>
                                            <span class="config-label">Área
                                            </span>

                                            <div class="fw-semibold">
                                                <asp:Label
                                                    ID="lblArea"
                                                    runat="server">
                                                </asp:Label>
                                            </div>
                                        </div>

                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="laboral-card">

                                        <div class="laboral-icon">
                                            <i class="bi bi-person-badge"></i>
                                        </div>

                                        <div>
                                            <span class="config-label">Puesto
                                            </span>

                                            <div class="fw-semibold">
                                                <asp:Label
                                                    ID="lblPuesto"
                                                    runat="server">
                                                </asp:Label>
                                            </div>
                                        </div>

                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="laboral-card">

                                        <div class="laboral-icon">
                                            <i class="bi bi-award"></i>
                                        </div>

                                        <div>
                                            <span class="config-label">Seniority
                                            </span>

                                            <div class="fw-semibold">
                                                <asp:Label
                                                    ID="lblSeniority"
                                                    runat="server">
                                                </asp:Label>
                                            </div>
                                        </div>

                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="laboral-card">

                                        <div class="laboral-icon">
                                            <i class="bi bi-key"></i>
                                        </div>

                                        <div>
                                            <span class="config-label">Tipo de acceso
                                            </span>

                                            <div class="d-flex flex-wrap gap-2">
                                                <asp:Label
                                                    ID="lblTipoAcceso"
                                                    runat="server"
                                                    CssClass="badge rounded-pill">
                                                </asp:Label>
                                            </div>
                                        </div>

                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <div class="laboral-card">

                                        <div class="laboral-icon">
                                            <i class="bi bi-person-check"></i>
                                        </div>

                                        <div>
                                            <span class="config-label">Estado de la cuenta
                                            </span>

                                            <asp:Label
                                                ID="lblEstadoCuenta"
                                                runat="server"
                                                CssClass="badge rounded-pill">
                                            </asp:Label>
                                        </div>

                                    </div>
                                </div>

                                <div class="col-12 mt-4">
                                    <div class="alert alert-light border mb-0">

                                        <i class="bi bi-info-circle-fill text-primary me-2"></i>

                                        Esta información solo puede ser modificada por
                                        un administrador de tu organización.

                                    </div>
                                </div>

                            </div>
                        </div>

                    </div>

                </asp:Panel>

                <!-- SEGURIDAD -->
                <asp:Panel
                    ID="pnlSeguridad"
                    runat="server"
                    data-config-panel="true"
                    Visible="false">

                    <div class="card border-0 shadow-sm config-card">

                        <div class="card-header bg-white p-4">
                            <h2 class="h5 fw-bold mb-1">Seguridad
                            </h2>

                            <p class="text-muted mb-0">
                                Actualizá la contraseña utilizada para ingresar a TinyDesk.
                            </p>
                        </div>

                        <div class="card-body p-4 border-top">
                            <div class="row g-4">

                                <div class="col-12 col-xl-7">

                                    <div class="mb-3">
                                        <label
                                            for="<%= txtPasswordActual.ClientID %>"
                                            class="form-label fw-semibold">
                                            Contraseña actual

                                        </label>

                                        <asp:TextBox
                                            ID="txtPasswordActual"
                                            runat="server"
                                            CssClass="form-control config-input"
                                            TextMode="Password">
                                        </asp:TextBox>

                                        <asp:RequiredFieldValidator
                                            ID="rfvPasswordActual"
                                            runat="server"
                                            ControlToValidate="txtPasswordActual"
                                            ValidationGroup="CambiarPassword"
                                            Display="Dynamic"
                                            CssClass="text-danger small mt-1"
                                            ErrorMessage="Ingresá tu contraseña actual.">
                                        </asp:RequiredFieldValidator>
                                    </div>

                                    <div class="mb-3">
                                        <label
                                            for="<%= txtPasswordNueva.ClientID %>"
                                            class="form-label fw-semibold">
                                            Nueva contraseña

                                        </label>

                                        <asp:TextBox
                                            ID="txtPasswordNueva"
                                            runat="server"
                                            CssClass="form-control config-input"
                                            TextMode="Password">
                                        </asp:TextBox>

                                        <asp:RequiredFieldValidator
                                            ID="rfvPasswordNueva"
                                            runat="server"
                                            ControlToValidate="txtPasswordNueva"
                                            ValidationGroup="CambiarPassword"
                                            Display="Dynamic"
                                            CssClass="text-danger small mt-1"
                                            ErrorMessage="Ingresá una nueva contraseña.">
                                        </asp:RequiredFieldValidator>
                                    </div>

                                    <div class="mb-4">
                                        <label
                                            for="<%= txtConfirmarPassword.ClientID %>"
                                            class="form-label fw-semibold">
                                            Confirmar nueva contraseña

                                        </label>

                                        <asp:TextBox
                                            ID="txtConfirmarPassword"
                                            runat="server"
                                            CssClass="form-control config-input"
                                            TextMode="Password">
                                        </asp:TextBox>

                                        <asp:RequiredFieldValidator
                                            ID="rfvConfirmarPassword"
                                            runat="server"
                                            ControlToValidate="txtConfirmarPassword"
                                            ValidationGroup="CambiarPassword"
                                            Display="Dynamic"
                                            CssClass="text-danger small mt-1"
                                            ErrorMessage="Confirmá la nueva contraseña.">
                                        </asp:RequiredFieldValidator>

                                        <asp:CompareValidator
                                            ID="cvPassword"
                                            runat="server"
                                            ControlToValidate="txtConfirmarPassword"
                                            ControlToCompare="txtPasswordNueva"
                                            ValidationGroup="CambiarPassword"
                                            Display="Dynamic"
                                            CssClass="text-danger small mt-1"
                                            ErrorMessage="Las contraseñas no coinciden.">
                                        </asp:CompareValidator>
                                    </div>

                                    <asp:Button
                                        ID="btnActualizarPassword"
                                        runat="server"
                                        Text="Actualizar contraseña"
                                        CssClass="btn btn-primary"
                                        ValidationGroup="CambiarPassword"
                                        OnClick="btnActualizarPassword_Click" />

                                </div>

                                <div class="col-12 col-xl-5">

                                    <div class="security-help">
                                        <h3 class="h6 fw-bold mb-3">

                                            <i class="bi bi-shield-check text-primary me-2"></i>
                                            Recomendaciones

                                        </h3>

                                        <ul class="small text-muted ps-3 mb-0">
                                            <li class="mb-2">Utilizá al menos 8 caracteres.
                                            </li>

                                            <li class="mb-2">Combiná letras y números.
                                            </li>

                                            <li class="mb-2">Evitá reutilizar contraseñas.
                                            </li>

                                            <li>No compartas tus credenciales.
                                            </li>
                                        </ul>
                                    </div>

                                </div>

                            </div>
                        </div>
                    </div>
                </asp:Panel>

                <!-- PREFERENCIAS -->
                <asp:Panel
                    ID="pnlPreferencias"
                    runat="server"
                    data-config-panel="true"
                    Visible="false">

                    <div class="card border-0 shadow-sm config-card">

                        <div class="card-header bg-white p-4">
                            <h2 class="h5 fw-bold mb-1">Imagen de perfil</h2>

                            <p class="text-muted mb-0">
                                Elegí la imagen que se mostrará en tu cuenta.
                            </p>
                        </div>

                        <div class="card-body p-4 border-top">

                            <div class="row align-items-center g-4">

                                <div class="col-12 col-md-auto">
                                    <div style="width: 180px; height: 180px;">

                                        <asp:Image
                                            ID="imgPerfilActual"
                                            runat="server"
                                            ImageUrl="https://efectocolibri.com/wp-content/uploads/2021/01/placeholder.png"
                                            AlternateText="Imagen de perfil"
                                            Width="180px"
                                            Height="180px"
                                            Style="display: block; object-fit: cover; object-position: center center; border-radius: 50%; border: 4px solid #e9ecef; background-color: #f8f9fa;" />

                                    </div>
                                </div>

                                <div class="col-12 col-md">

                                    <label class="form-label fw-semibold">
                                        Seleccionar imagen
                                    </label>

                                    <asp:FileUpload
                                        ID="fuImagenPerfil"
                                        runat="server"
                                        CssClass="form-control"
                                        Style="width: 500px; max-width: 100%;"
                                        accept="image/jpeg,image/png"
                                        onchange="previsualizarImagen(this);" />

                                    <div class="form-text mt-2">
                                        Formatos admitidos: JPG o PNG.
                                    </div>

                                    <div class="mt-4">
                                        <asp:Button
                                            ID="btnGuardarImagenPerfil"
                                            runat="server"
                                            Text="Guardar imagen"
                                            CssClass="btn btn-primary"
                                            CausesValidation="false"
                                            OnClick="btnGuardarImagenPerfil_Click" />
                                    </div>

                                </div>

                            </div>

                        </div>

                    </div>

                </asp:Panel>
            </div>
        </div>
    </div>

    <style>
        .config-card {
            border: 1px solid #e5e7eb !important;
            border-radius: 12px;
            overflow: hidden;
        }

        .config-nav {
            border-radius: 10px;
            overflow: hidden;
        }

            .config-nav .list-group-item {
                border: 0;
                padding: .9rem 1rem;
                color: #495057;
            }

                .config-nav .list-group-item.active {
                    background-color: #e9f2ff;
                    color: #0d6efd;
                    border-left: 4px solid #0d6efd;
                    font-weight: 600;
                }

        .config-avatar {
            width: 64px;
            height: 64px;
            border-radius: 14px;
            background-color: #0d6efd;
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
            font-size: 1.4rem;
            font-weight: 700;
            overflow: hidden;
            position: relative;
        }

        .config-label {
            display: block;
            color: #6c757d;
            font-size: .75rem;
            font-weight: 700;
            letter-spacing: .04em;
            text-transform: uppercase;
            margin-bottom: .35rem;
        }

        .config-readonly {
            min-height: 45px;
            padding: .65rem .8rem;
            background-color: #f8f9fa;
            border: 1px solid #dee2e6;
            border-radius: 8px;
            display: flex;
            align-items: center;
        }

        .laboral-card {
            min-height: 105px;
            height: 100%;
            padding: 1rem;
            border: 1px solid #e5e7eb;
            border-radius: 10px;
            display: flex;
            align-items: flex-start;
            gap: .85rem;
        }

        .laboral-icon {
            width: 38px;
            height: 38px;
            border-radius: 8px;
            background-color: #e9f2ff;
            color: #0d6efd;
            display: flex;
            justify-content: center;
            align-items: center;
            flex-shrink: 0;
        }

        .security-help {
            padding: 1rem;
            background-color: #f8f9fa;
            border: 1px solid #e5e7eb;
            border-radius: 10px;
        }

        .config-input {
            max-width: 100%;
        }

        .preference-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 1rem;
            padding: 1rem 0;
            border-bottom: 1px solid #e5e7eb;
        }

        @media (max-width: 575.98px) {
            .preference-item {
                flex-direction: column;
                align-items: flex-start;
            }
        }
    </style>

    <style>
        .config-workspace {
            --config-sky: #93c0de;
            --config-aqua: #b9e5e5;
            --config-ink: #09232f;
            --config-muted: #75797e;
            width: 100%;
            max-width: 1540px;
            margin-inline: auto;
            color: var(--config-ink);
        }

        .app-main.config-app-surface {
            background: radial-gradient(circle at 88% 8%, rgba(147, 192, 222, .22), transparent 26rem), radial-gradient(circle at 12% 82%, rgba(185, 229, 229, .2), transparent 30rem), linear-gradient(180deg, #f6f9fa, #eef4f5);
        }

        .config-hero {
            position: relative;
            overflow: hidden;
            padding: clamp(1.45rem, 2.8vw, 2.25rem);
            border: 1px solid rgba(185, 229, 229, .15);
            border-radius: 1.4rem;
            background: linear-gradient(118deg, #09232f 0%, #123f52 64%, #1a586a 100%);
            box-shadow: 0 20px 48px rgba(9, 35, 47, .17);
            color: #fff;
            isolation: isolate;
        }

            .config-hero::before {
                content: "";
                position: absolute;
                z-index: -1;
                width: 18rem;
                height: 18rem;
                right: -5rem;
                top: -11rem;
                border: 3.2rem solid rgba(185, 229, 229, .13);
                border-radius: 50%;
            }

        .config-hero-copy h1 {
            color: #fff;
            letter-spacing: -.03em;
        }

        .config-hero-copy p {
            color: rgba(255, 255, 255, .7);
        }

        .config-eyebrow {
            display: inline-flex;
            align-items: center;
            gap: .45rem;
            margin-bottom: .65rem;
            color: var(--config-aqua);
            font-size: .71rem;
            font-weight: 800;
            letter-spacing: .11em;
            text-transform: uppercase;
        }

        .config-security-chip {
            display: flex;
            align-items: center;
            gap: .7rem;
            padding: .65rem .8rem;
            border: 1px solid rgba(255, 255, 255, .15);
            border-radius: .9rem;
            background: rgba(255, 255, 255, .08);
            backdrop-filter: blur(8px);
        }

            .config-security-chip > i {
                display: grid;
                place-items: center;
                width: 2.45rem;
                height: 2.45rem;
                border-radius: .72rem;
                background: rgba(185, 229, 229, .16);
                color: var(--config-aqua);
            }

            .config-security-chip span,
            .config-nav-heading > div {
                display: flex;
                flex-direction: column;
            }

            .config-security-chip strong {
                color: #fff;
                font-size: .8rem;
            }

            .config-security-chip small {
                color: rgba(255, 255, 255, .62);
                font-size: .68rem;
            }

        .config-layout {
            max-width: 1350px;
            margin-inline: auto;
        }

        .config-nav-column {
            position: sticky;
            top: 1rem;
        }

        .config-nav {
            padding: .75rem;
            border: 1px solid rgba(9, 35, 47, .08);
            border-radius: 1.15rem;
            background: rgba(255, 255, 255, .86);
            box-shadow: 0 16px 38px rgba(9, 35, 47, .075);
            backdrop-filter: blur(10px);
        }

        .config-nav-heading {
            display: flex;
            align-items: center;
            gap: .7rem;
            margin-bottom: .65rem;
            padding: .35rem .25rem .9rem;
            border-bottom: 1px solid rgba(9, 35, 47, .08);
        }

        .config-nav-mark {
            display: grid;
            place-items: center;
            width: 2.55rem;
            height: 2.55rem;
            flex: 0 0 auto;
            border-radius: .78rem;
            background: linear-gradient(145deg, rgba(147, 192, 222, .28), rgba(185, 229, 229, .4));
            color: #315f76;
        }

        .config-nav-heading strong {
            color: var(--config-ink);
            font-size: .86rem;
        }

        .config-nav-heading small {
            color: var(--config-muted);
            font-size: .67rem;
        }

        .config-nav .list-group-item {
            display: flex;
            align-items: center;
            margin: .15rem 0;
            padding: .76rem .8rem;
            border: 0;
            border-radius: .72rem !important;
            background: transparent;
            color: #607078;
            font-size: .83rem;
            font-weight: 650;
        }

            .config-nav .list-group-item:hover {
                background: rgba(147, 192, 222, .12);
                color: var(--config-ink);
            }

            .config-nav .list-group-item.active {
                border: 0;
                background: var(--config-ink);
                color: #fff;
                box-shadow: 0 8px 18px rgba(9, 35, 47, .14);
            }

                .config-nav .list-group-item.active i {
                    color: var(--config-aqua);
                }

        .config-content {
            min-width: 0;
        }

        .config-card {
            border: 1px solid rgba(9, 35, 47, .08) !important;
            border-radius: 1.25rem;
            background: rgba(255, 255, 255, .88);
            box-shadow: 0 20px 48px rgba(9, 35, 47, .085) !important;
            backdrop-filter: blur(12px);
        }

            .config-card > .card-header {
                border-bottom-color: rgba(9, 35, 47, .08);
                background: linear-gradient(120deg, rgba(255, 255, 255, .96), rgba(237, 247, 249, .88)) !important;
            }

            .config-card h2 {
                color: var(--config-ink);
                letter-spacing: -.02em;
            }

        .config-avatar {
            width: 72px;
            height: 72px;
            border: 4px solid rgba(255, 255, 255, .92);
            border-radius: 1.15rem;
            background: linear-gradient(145deg, #315f76, #09232f);
            box-shadow: 0 10px 22px rgba(9, 35, 47, .17);
        }

        .config-readonly {
            min-height: 48px;
            border-color: rgba(9, 35, 47, .1);
            border-radius: .72rem;
            background: linear-gradient(145deg, rgba(255, 255, 255, .95), rgba(237, 245, 247, .78));
            color: var(--config-ink);
        }

        .laboral-card {
            min-height: 112px;
            border-color: rgba(9, 35, 47, .08);
            border-radius: .9rem;
            background: linear-gradient(145deg, rgba(255, 255, 255, .95), rgba(241, 247, 248, .78));
            transition: transform .2s ease, box-shadow .2s ease;
        }

            .laboral-card:hover {
                transform: translateY(-2px);
                box-shadow: 0 12px 24px rgba(9, 35, 47, .07);
            }

        .laboral-icon {
            width: 42px;
            height: 42px;
            border-radius: .78rem;
            background: linear-gradient(145deg, rgba(147, 192, 222, .27), rgba(185, 229, 229, .4));
            color: #315f76;
        }

        .config-workspace .badge {
            padding: .46rem .66rem;
            border: 1px solid transparent;
        }

        .config-workspace .bg-success-subtle {
            background: rgba(76, 175, 125, .14) !important;
            color: #237a55 !important;
        }

        .config-workspace .bg-primary-subtle {
            background: rgba(147, 192, 222, .22) !important;
            color: #315f76 !important;
        }

        .config-workspace .bg-secondary-subtle {
            background: rgba(130, 149, 217, .16) !important;
            color: #584d91 !important;
        }

        .config-workspace .form-control {
            min-height: 44px;
            border-color: rgba(9, 35, 47, .14);
            border-radius: .72rem;
        }

            .config-workspace .form-control:focus {
                border-color: #75a9c9;
                box-shadow: 0 0 0 .23rem rgba(147, 192, 222, .22);
            }

        .config-workspace .btn-primary {
            border-color: var(--config-ink);
            border-radius: .72rem;
            background: var(--config-ink);
            color: #fff;
            font-weight: 700;
        }

            .config-workspace .btn-primary:hover {
                border-color: #123d4f;
                background: #123d4f;
                color: #fff !important;
            }

        .security-help {
            border-color: rgba(147, 192, 222, .2);
            border-radius: .9rem;
            background: linear-gradient(145deg, rgba(147, 192, 222, .1), rgba(185, 229, 229, .1));
        }

        .config-card img {
            border: 5px solid rgba(185, 229, 229, .48) !important;
            box-shadow: 0 16px 34px rgba(9, 35, 47, .15);
        }

        .config-card input[type="file"] {
            width: 100% !important;
            max-width: 620px !important;
        }

        .config-js [data-config-panel] {
            animation: configReveal .35s ease both;
        }

        @keyframes configReveal {
            from {
                opacity: 0;
                transform: translateY(8px);
            }

            to {
                opacity: 1;
                transform: none;
            }
        }

        @media (max-width: 991.98px) {
            .config-nav-column {
                position: static;
            }

            .config-nav {
                display: grid;
                grid-template-columns: repeat(4, minmax(145px, 1fr));
                overflow-x: auto;
                gap: .3rem;
            }

            .config-nav-heading {
                display: none;
            }

            .config-nav .list-group-item {
                justify-content: center;
                margin: 0;
                white-space: nowrap;
            }
        }

        @media (max-width: 575.98px) {
            .config-hero {
                border-radius: 1rem;
            }

            .config-security-chip {
                display: none;
            }

            .config-card .card-body, .config-card .card-header {
                padding: 1.2rem !important;
            }

            .config-nav {
                grid-template-columns: repeat(4, minmax(135px, 1fr));
            }
        }

        @media (prefers-reduced-motion: reduce) {
            .config-js [data-config-panel], .laboral-card {
                animation: none;
                transform: none;
                transition: none;
            }
        }
    </style>

    <script>
        function previsualizarImagen(input) {
            if (!input.files || !input.files[0]) return;

            const imagen = document.getElementById(
            '<%= imgPerfilActual.ClientID %>'
            );

            imagen.src = URL.createObjectURL(input.files[0]);
        }
    </script>

    <script type="text/javascript">
        document.addEventListener('DOMContentLoaded', function () {
            var appMain = document.querySelector('.app-main');
            if (appMain && document.querySelector('.config-workspace')) {
                appMain.classList.add('config-app-surface', 'config-js');
            }
        });
    </script>

</asp:Content>

