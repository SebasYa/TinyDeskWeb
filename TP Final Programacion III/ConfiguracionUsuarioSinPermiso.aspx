<%@ Page Title="Configuración" Language="C#" MasterPageFile="~/UsuarioSite.Master" AutoEventWireup="true" CodeBehind="ConfiguracionUsuarioSinPermiso.aspx.cs" Inherits="TP_Final_Programacion_III.ConfiguracionUsuarioSinPermiso" %>

<asp:Content
    ID="BodyContent"
    ContentPlaceHolderID="MainContent"
    runat="server">

    <div class="container-fluid px-0">

        <asp:Literal
            ID="litMensaje"
            runat="server">
        </asp:Literal>

        <!-- ENCABEZADO -->
        <div class="mb-4">
            <h1 class="h3 fw-bold text-dark mb-1">Configuración de cuenta
            </h1>

            <p class="text-muted mb-0">
                Consultá los datos de tu cuenta y administrá su seguridad.
            </p>
        </div>

        <div class="row g-4">

            <!-- NAVEGACIÓN INTERNA -->
            <div class="col-12 col-lg-3">
                <div class="list-group shadow-sm config-nav">

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
            <div class="col-12 col-lg-9">

                <!-- PERFIL -->
                <asp:Panel
                    ID="pnlPerfil"
                    runat="server">

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

    <script>
        function previsualizarImagen(input) {
            if (!input.files || !input.files[0]) return;

            const imagen = document.getElementById(
            '<%= imgPerfilActual.ClientID %>'
        );

            imagen.src = URL.createObjectURL(input.files[0]);
        }
    </script>

</asp:Content>

