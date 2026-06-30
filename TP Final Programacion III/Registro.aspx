<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Registro.aspx.cs" Inherits="TP_Final_Programacion_III.Registro" %>

<!DOCTYPE html>

<html lang="es">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    <title>Crear usuario - TinyDesk</title>

    <link href="Content/bootstrap.min.css" rel="stylesheet" />

    <style>
        :root {
            --auth-sky: #93c0de;
            --auth-mint: #b9e5e5;
            --auth-ink: #09232f;
            --auth-muted: #75797e;
            --auth-white: #ffffff;
            --auth-danger: #b13b49;
        }

        * { box-sizing: border-box; }

        body.auth-page {
            min-width: 320px;
            margin: 0;
            color: var(--auth-ink);
            background:
                radial-gradient(circle at 8% 16%, rgba(185, 229, 229, .78), transparent 25rem),
                radial-gradient(circle at 92% 74%, rgba(147, 192, 222, .42), transparent 28rem),
                linear-gradient(145deg, #f9fbfb, #f2f5f6);
            font-family: "Segoe UI Variable", "Segoe UI", system-ui, -apple-system, sans-serif;
            overflow-x: hidden;
        }

        .auth-page ::selection {
            color: var(--auth-ink);
            background: var(--auth-mint);
        }

        .auth-main {
            position: relative;
            isolation: isolate;
            display: flex;
            align-items: center;
            padding: clamp(2.4rem, 6vw, 5rem) 0;
            overflow: hidden;
        }

        .auth-orb,
        .auth-ring,
        .auth-dots {
            position: absolute;
            z-index: -1;
            pointer-events: none;
        }

        .auth-orb {
            top: 8%;
            left: -7rem;
            width: 18rem;
            height: 18rem;
            border-radius: 50%;
            background: rgba(185, 229, 229, .28);
        }

        .auth-ring {
            right: -8rem;
            bottom: 5%;
            width: 23rem;
            height: 23rem;
            border: 1px solid rgba(147, 192, 222, .38);
            border-radius: 50%;
            box-shadow: inset 0 0 0 4rem rgba(147, 192, 222, .055);
        }

        .auth-dots {
            top: 12%;
            right: 8%;
            width: 74px;
            height: 74px;
            opacity: .22;
            background-image: radial-gradient(var(--auth-ink) 1.2px, transparent 1.2px);
            background-size: 12px 12px;
        }

        .register-card-wrap {
            position: relative;
            max-width: 790px;
            margin: 0 auto;
        }

        .register-card-wrap::before {
            position: absolute;
            z-index: -1;
            inset: 1rem -1rem -1rem 1rem;
            border-radius: 30px;
            background: linear-gradient(145deg, var(--auth-sky), var(--auth-mint));
            content: "";
            opacity: .5;
            transform: rotate(1deg);
        }

        .register-card {
            overflow: hidden;
            border: 1px solid rgba(255, 255, 255, .9);
            border-radius: 30px;
            background: rgba(255, 255, 255, .93);
            box-shadow: 0 28px 72px rgba(9, 35, 47, .14);
            -webkit-backdrop-filter: blur(16px);
            backdrop-filter: blur(16px);
            animation: auth-rise .7s cubic-bezier(.2, .8, .2, 1) both;
        }

        .register-card-body {
            padding: clamp(1.8rem, 5vw, 3rem);
        }

        .auth-brand {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: .65rem;
            margin-bottom: 1.35rem;
        }

        .auth-logo {
            position: relative;
            display: inline-flex;
            width: 72px;
            height: 72px;
            flex: 0 0 72px;
            overflow: visible;
            background: transparent;
        }

        .auth-logo::after {
            position: absolute;
            z-index: 0;
            right: 22%;
            bottom: 6px;
            left: 22%;
            height: 12px;
            border-radius: 50%;
            background: rgba(9, 35, 47, .26);
            content: "";
            filter: blur(6px);
            transform: translateY(9px);
        }

        .auth-logo img {
            position: absolute;
            top: 50%;
            left: 50%;
            width: 98px;
            height: 98px;
            max-width: none;
            z-index: 1;
            transform: translate(-50%, -50%);
        }

        .auth-wordmark {
            font-size: 1.32rem;
            font-weight: 800;
            letter-spacing: -.04em;
        }

        .auth-heading {
            margin-bottom: 1.8rem;
            text-align: center;
        }

        .auth-heading h1 {
            margin: 0;
            font-size: clamp(1.75rem, 5vw, 2.25rem);
            font-weight: 790;
            letter-spacing: -.045em;
        }

        .auth-heading p {
            margin: .55rem 0 0;
            color: var(--auth-muted);
            font-size: .84rem;
        }

        .auth-field { margin-bottom: 1rem; }

        .auth-label {
            display: block;
            min-height: 1.15rem;
            margin-bottom: .45rem;
            font-size: .75rem;
            font-weight: 730;
        }

        .auth-control-wrap { position: relative; }

        .auth-control-icon {
            position: absolute;
            z-index: 2;
            top: 50%;
            left: .95rem;
            width: 18px;
            height: 18px;
            color: #6d8791;
            pointer-events: none;
            transform: translateY(-50%);
            transition: color .2s ease, transform .2s ease;
        }

        .auth-control-wrap:focus-within .auth-control-icon {
            color: var(--auth-ink);
            transform: translateY(-50%) scale(1.06);
        }

        .auth-control-wrap .form-control {
            min-height: 51px;
            padding: .78rem 1rem .78rem 2.9rem;
            color: var(--auth-ink);
            border: 1px solid rgba(9, 35, 47, .13);
            border-radius: 15px;
            background: #fbfcfc;
            font-size: .86rem;
            transition: border-color .2s ease, box-shadow .2s ease, background .2s ease, transform .2s ease;
        }

        .auth-control-wrap:has(.password-toggle) .form-control { padding-right: 3.25rem; }
        .auth-control-wrap .form-control::placeholder { color: #9ca5a9; }

        .auth-control-wrap .form-control:focus {
            color: var(--auth-ink);
            border-color: var(--auth-sky);
            outline: 0;
            background: var(--auth-white);
            box-shadow: 0 0 0 4px rgba(147, 192, 222, .2);
            transform: translateY(-1px);
        }

        .auth-control-wrap .form-control.is-invalid {
            border-color: rgba(177, 59, 73, .68) !important;
            background-image: none;
        }

        .auth-control-wrap .form-control.is-invalid:focus {
            border-color: var(--auth-danger) !important;
            box-shadow: 0 0 0 4px rgba(177, 59, 73, .13) !important;
        }

        .password-toggle {
            position: absolute;
            z-index: 3;
            top: 50%;
            right: .6rem;
            display: grid;
            width: 36px;
            height: 36px;
            padding: 0;
            place-items: center;
            color: var(--auth-muted);
            border: 0;
            border-radius: 11px;
            background: transparent;
            transform: translateY(-50%);
            transition: color .2s ease, background .2s ease;
        }

        .password-toggle:hover,
        .password-toggle:focus {
            color: var(--auth-ink);
            outline: 0;
            background: rgba(185, 229, 229, .35);
        }

        .password-toggle svg { width: 18px; height: 18px; }
        .password-toggle .eye-off,
        .password-toggle.is-visible .eye-on { display: none; }
        .password-toggle.is-visible .eye-off { display: block; }

        .text-validation-error {
            display: block;
            margin-top: .35rem;
            color: var(--auth-danger) !important;
            font-size: .7rem;
            font-weight: 650;
        }

        .register-card .alert {
            padding: .85rem .95rem;
            border-radius: 14px;
            font-size: .77rem;
            line-height: 1.5;
        }

        .register-card .alert-danger {
            color: #772632;
            border: 1px solid rgba(177, 59, 73, .24);
            background: rgba(255, 232, 235, .78);
        }

        .register-card .alert-success {
            color: #245f52;
            border: 1px solid rgba(59, 142, 121, .24);
            background: rgba(222, 246, 239, .84);
        }

        .auth-primary.btn {
            min-height: 52px;
            color: var(--auth-white);
            border: 0;
            border-radius: 15px;
            background: var(--auth-ink);
            font-size: .86rem;
            font-weight: 760;
            box-shadow: 0 13px 27px rgba(9, 35, 47, .2);
            transition: transform .22s ease, box-shadow .22s ease, background .22s ease;
        }

        .auth-primary.btn:hover,
        .auth-primary.btn:focus {
            color: var(--auth-white);
            background: #123b4d;
            box-shadow: 0 17px 31px rgba(9, 35, 47, .25);
            transform: translateY(-2px);
        }

        .auth-primary.is-loading {
            cursor: wait;
            background-image: linear-gradient(100deg, var(--auth-ink) 20%, #19495d 48%, var(--auth-ink) 76%);
            background-size: 200% 100%;
            animation: auth-loading 1.2s linear infinite;
        }

        .auth-back {
            display: inline-flex;
            align-items: center;
            gap: .4rem;
            margin-top: 1.15rem;
            color: #446978;
            font-size: .78rem;
            font-weight: 680;
            transition: color .2s ease;
        }

        .auth-back:hover,
        .auth-back:focus { color: var(--auth-ink); }
        .auth-back svg { width: 15px; height: 15px; }

        .auth-footer {
            border-top: 1px solid rgba(9, 35, 47, .08);
            background: rgba(255, 255, 255, .62);
        }

        .auth-footer-inner { min-height: 70px; }

        .auth-footer-logo {
            position: relative;
            display: inline-flex;
            width: 32px;
            height: 32px;
            flex: 0 0 32px;
            overflow: visible;
            background: transparent;
        }

        .auth-footer-logo img {
            position: absolute;
            top: 50%;
            left: 50%;
            width: 46px;
            height: 46px;
            max-width: none;
            filter: drop-shadow(0 5px 5px rgba(9, 35, 47, .18));
            transform: translate(-50%, -50%);
        }

        .auth-footer-copy,
        .auth-footer a { color: var(--auth-muted); font-size: .75rem; }
        .auth-footer a:hover { color: var(--auth-ink); }

        @keyframes auth-rise {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @keyframes auth-loading { to { background-position: -200% 0; } }

        @media (max-width: 575.98px) {
            .auth-main { align-items: flex-start; padding: 1.5rem 0 2.5rem; }
            .register-card-wrap::before { inset: .75rem -.35rem -.55rem .55rem; }
            .register-card, .register-card-wrap::before { border-radius: 24px; }
            .register-card-body { padding: 1.55rem 1.25rem 1.65rem; }
            .auth-footer-inner { padding-top: 1rem; padding-bottom: 1rem; }
        }

        @media (prefers-reduced-motion: reduce) {
            *, *::before, *::after {
                animation-duration: .01ms !important;
                animation-iteration-count: 1 !important;
                transition-duration: .01ms !important;
            }
        }
    </style>
</head>
<body class="auth-page">
    <form id="form1" runat="server" class="min-vh-100 d-flex flex-column">
        <main class="auth-main flex-grow-1">
            <span class="auth-orb" aria-hidden="true"></span>
            <span class="auth-ring" aria-hidden="true"></span>
            <span class="auth-dots" aria-hidden="true"></span>

            <div class="container">
                <div class="row justify-content-center">
                    <div class="col-12 col-lg-10 col-xl-8">
                        <div class="register-card-wrap">
                            <section class="register-card" aria-labelledby="registerTitle">
                                <div class="register-card-body">
                                    <div class="auth-brand" aria-label="TinyDesk">
                                        <span class="auth-logo" aria-hidden="true">
                                            <img runat="server" src="~/Images/LogoTD.png" alt="" />
                                        </span>
                                        <span class="auth-wordmark">TinyDesk</span>
                                    </div>

                                    <header class="auth-heading">
                                        <h1 id="registerTitle">Crear usuario</h1>
                                        <p>Completá tus datos para empezar a organizar el trabajo de tu equipo.</p>
                                    </header>

                                    <asp:Literal ID="litMensaje" runat="server"></asp:Literal>

                                    <div class="row g-3">
                                        <div class="col-12 col-md-6">
                                            <div class="auth-field">
                                                <label for="<%= txtNombre.ClientID %>" class="auth-label">Nombre</label>
                                                <div class="auth-control-wrap">
                                                    <svg class="auth-control-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" aria-hidden="true">
                                                        <circle cx="12" cy="8" r="4" /><path d="M4.5 21a7.5 7.5 0 0 1 15 0" />
                                                    </svg>
                                                    <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control" autocomplete="given-name" placeholder="Tu nombre"></asp:TextBox>
                                                </div>
                                                <asp:RequiredFieldValidator ID="rfvNombre" runat="server" ControlToValidate="txtNombre" ErrorMessage="El nombre es obligatorio." CssClass="text-danger text-validation-error" Display="Dynamic" />
                                            </div>
                                        </div>

                                        <div class="col-12 col-md-6">
                                            <div class="auth-field">
                                                <label for="<%= txtApellido.ClientID %>" class="auth-label">Apellido</label>
                                                <div class="auth-control-wrap">
                                                    <svg class="auth-control-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" aria-hidden="true">
                                                        <circle cx="12" cy="8" r="4" /><path d="M4.5 21a7.5 7.5 0 0 1 15 0" />
                                                    </svg>
                                                    <asp:TextBox ID="txtApellido" runat="server" CssClass="form-control" autocomplete="family-name" placeholder="Tu apellido"></asp:TextBox>
                                                </div>
                                                <asp:RequiredFieldValidator ID="rfvApellido" runat="server" ControlToValidate="txtApellido" ErrorMessage="El apellido es obligatorio." CssClass="text-danger text-validation-error" Display="Dynamic" />
                                            </div>
                                        </div>

                                        <div class="col-12 col-md-6">
                                            <div class="auth-field">
                                                <label for="<%= txtEmail.ClientID %>" class="auth-label">Correo electrónico</label>
                                                <div class="auth-control-wrap">
                                                    <svg class="auth-control-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" aria-hidden="true">
                                                        <rect x="3" y="5" width="18" height="14" rx="3" /><path d="m4 7 8 6 8-6" />
                                                    </svg>
                                                    <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="info@empresa.com" TextMode="Email" autocomplete="email"></asp:TextBox>
                                                </div>
                                                <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ControlToValidate="txtEmail" ErrorMessage="El correo electrónico es obligatorio." CssClass="text-danger text-validation-error" Display="Dynamic" />
                                                <asp:RegularExpressionValidator ID="revEmail" runat="server" ControlToValidate="txtEmail" ErrorMessage="El formato del correo es inválido." CssClass="text-danger text-validation-error" Display="Dynamic" ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$" />
                                            </div>
                                        </div>

                                        <div class="col-12 col-md-6">
                                            <div class="auth-field">
                                                <label for="<%= txtNombreEmpresa.ClientID %>" class="auth-label">Empresa u organización</label>
                                                <div class="auth-control-wrap">
                                                    <svg class="auth-control-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" aria-hidden="true">
                                                        <path d="M4 21V5h10v16M14 10h6v11M8 9h2M8 13h2M8 17h2M17 14h1M17 17h1M2 21h20" />
                                                    </svg>
                                                    <asp:TextBox ID="txtNombreEmpresa" runat="server" CssClass="form-control" placeholder="Mi Empresa S.A." autocomplete="organization"></asp:TextBox>
                                                </div>
                                                <asp:RequiredFieldValidator ID="rfvNombreEmpresa" runat="server" ControlToValidate="txtNombreEmpresa" ErrorMessage="El nombre de empresa es obligatorio." CssClass="text-danger text-validation-error" Display="Dynamic" />
                                            </div>
                                        </div>

                                        <div class="col-12">
                                            <div class="auth-field">
                                                <label for="<%= txtNombreUsuario.ClientID %>" class="auth-label">Usuario</label>
                                                <div class="auth-control-wrap">
                                                    <svg class="auth-control-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" aria-hidden="true">
                                                        <circle cx="12" cy="8" r="4" /><path d="M4.5 21a7.5 7.5 0 0 1 15 0" />
                                                    </svg>
                                                    <asp:TextBox ID="txtNombreUsuario" runat="server" CssClass="form-control" autocomplete="username" placeholder="Elegí un nombre de usuario"></asp:TextBox>
                                                </div>
                                                <asp:RequiredFieldValidator ID="rfvNombreUsuario" runat="server" ControlToValidate="txtNombreUsuario" ErrorMessage="El usuario es obligatorio." CssClass="text-danger text-validation-error" Display="Dynamic" />
                                            </div>
                                        </div>

                                        <div class="col-12 col-md-6">
                                            <div class="auth-field">
                                                <label for="<%= txtPassword.ClientID %>" class="auth-label">Contraseña</label>
                                                <div class="auth-control-wrap">
                                                    <svg class="auth-control-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" aria-hidden="true">
                                                        <rect x="5" y="10" width="14" height="11" rx="2" /><path d="M8 10V7a4 4 0 0 1 8 0v3" />
                                                    </svg>
                                                    <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" autocomplete="new-password" placeholder="Creá una contraseña"></asp:TextBox>
                                                    <button id="passwordToggle" class="password-toggle" type="button" aria-label="Mostrar contraseña" aria-pressed="false">
                                                        <svg class="eye-on" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" aria-hidden="true"><path d="M2.5 12s3.5-6 9.5-6 9.5 6 9.5 6-3.5 6-9.5 6-9.5-6-9.5-6Z" /><circle cx="12" cy="12" r="2.7" /></svg>
                                                        <svg class="eye-off" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" aria-hidden="true"><path d="m3 3 18 18M10.6 6.2A10.7 10.7 0 0 1 12 6c6 0 9.5 6 9.5 6a17 17 0 0 1-2.2 2.8M6.5 6.7C3.9 8.5 2.5 12 2.5 12s3.5 6 9.5 6a10 10 0 0 0 3-.4M9.8 9.8a3 3 0 0 0 4.4 4.4" /></svg>
                                                    </button>
                                                </div>
                                                <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ControlToValidate="txtPassword" ErrorMessage="La contraseña es obligatoria." CssClass="text-danger text-validation-error" Display="Dynamic" />
                                            </div>
                                        </div>

                                        <div class="col-12 col-md-6">
                                            <div class="auth-field">
                                                <label for="<%= txtConfirmarPassword.ClientID %>" class="auth-label">Confirmar contraseña</label>
                                                <div class="auth-control-wrap">
                                                    <svg class="auth-control-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" aria-hidden="true">
                                                        <rect x="5" y="10" width="14" height="11" rx="2" /><path d="M8 10V7a4 4 0 0 1 8 0v3" />
                                                    </svg>
                                                    <asp:TextBox ID="txtConfirmarPassword" runat="server" CssClass="form-control" TextMode="Password" autocomplete="new-password" placeholder="Repetí la contraseña"></asp:TextBox>
                                                    <button id="confirmPasswordToggle" class="password-toggle" type="button" aria-label="Mostrar confirmación" aria-pressed="false">
                                                        <svg class="eye-on" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" aria-hidden="true"><path d="M2.5 12s3.5-6 9.5-6 9.5 6 9.5 6-3.5 6-9.5 6-9.5-6-9.5-6Z" /><circle cx="12" cy="12" r="2.7" /></svg>
                                                        <svg class="eye-off" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" aria-hidden="true"><path d="m3 3 18 18M10.6 6.2A10.7 10.7 0 0 1 12 6c6 0 9.5 6 9.5 6a17 17 0 0 1-2.2 2.8M6.5 6.7C3.9 8.5 2.5 12 2.5 12s3.5 6 9.5 6a10 10 0 0 0 3-.4M9.8 9.8a3 3 0 0 0 4.4 4.4" /></svg>
                                                    </button>
                                                </div>
                                                <asp:RequiredFieldValidator ID="rfvConfirmarPassword" runat="server" ControlToValidate="txtConfirmarPassword" ErrorMessage="Debe confirmar la contraseña." CssClass="text-danger text-validation-error" Display="Dynamic" />
                                            </div>
                                        </div>
                                    </div>

                                    <asp:Button ID="btnCrearUsuario" runat="server" Text="Crear usuario" CssClass="btn auth-primary w-100 mt-1" OnClick="btnCrearUsuario_Click" />

                                    <div class="text-center">
                                        <a href="Login.aspx" class="auth-back text-decoration-none">
                                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true"><path d="M19 12H5M12 19l-7-7 7-7" /></svg>
                                            Volver a iniciar sesión
                                        </a>
                                    </div>
                                </div>
                            </section>
                        </div>
                    </div>
                </div>
            </div>
        </main>

        <footer class="auth-footer">
            <div class="container auth-footer-inner d-flex flex-column flex-sm-row justify-content-between align-items-center gap-2">
                <div class="d-flex align-items-center gap-2">
                    <span class="auth-footer-logo" aria-hidden="true"><img runat="server" src="~/Images/LogoTD.png" alt="" /></span>
                    <span class="auth-footer-copy">&copy; <%: DateTime.Now.Year %> TinyDesk</span>
                </div>
                <nav class="d-flex align-items-center gap-3" aria-label="Navegación del pie de página">
                    <a href="About.aspx" class="text-decoration-none">Acerca de</a>
                    <a href="Contacto.aspx" class="text-decoration-none">Contacto</a>
                </nav>
            </div>
        </footer>
    </form>

    <script>
        (function () {
            "use strict";

            function bindPasswordToggle(inputId, toggleId) {
                var input = document.getElementById(inputId);
                var toggle = document.getElementById(toggleId);
                if (!input || !toggle) return;

                toggle.addEventListener("click", function () {
                    var showPassword = input.type === "password";
                    input.type = showPassword ? "text" : "password";
                    toggle.classList.toggle("is-visible", showPassword);
                    toggle.setAttribute("aria-pressed", showPassword ? "true" : "false");
                    toggle.setAttribute("aria-label", showPassword ? "Ocultar contraseña" : "Mostrar contraseña");
                    input.focus();
                });
            }

            bindPasswordToggle("<%= txtPassword.ClientID %>", "passwordToggle");
            bindPasswordToggle("<%= txtConfirmarPassword.ClientID %>", "confirmPasswordToggle");

            var form = document.getElementById("<%= form1.ClientID %>");
            var submit = document.getElementById("<%= btnCrearUsuario.ClientID %>");

            if (form && submit) {
                form.addEventListener("submit", function (event) {
                    if (event.submitter && event.submitter !== submit) return;

                    window.setTimeout(function () {
                        if (typeof window.Page_IsValid === "undefined" || window.Page_IsValid) {
                            submit.value = "Creando usuario...";
                            submit.classList.add("is-loading");
                            submit.setAttribute("aria-busy", "true");
                        }
                    }, 0);
                });
            }
        }());
    </script>
</body>
</html>
