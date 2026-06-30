<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="TP_Final_Programacion_III.Login" %>

<!DOCTYPE html>

<html lang="es">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    <title>Iniciar sesión - TinyDesk</title>

    <link href="Content/bootstrap.min.css" rel="stylesheet" />
    <style>
        :root {
            --login-sky: #93c0de;
            --login-mint: #b9e5e5;
            --login-ink: #09232f;
            --login-muted: #75797e;
            --login-cloud: #e5e5e5;
            --login-white: #ffffff;
            --login-danger: #b13b49;
        }

        * {
            box-sizing: border-box;
        }

        body.login-page {
            min-width: 320px;
            margin: 0;
            color: var(--login-ink);
            background:
                radial-gradient(circle at 8% 16%, rgba(185, 229, 229, .78), transparent 25rem),
                radial-gradient(circle at 92% 74%, rgba(147, 192, 222, .42), transparent 28rem),
                linear-gradient(145deg, #f9fbfb, #f2f5f6);
            font-family: "Segoe UI Variable", "Segoe UI", system-ui, -apple-system, sans-serif;
            overflow-x: hidden;
        }

        .login-page ::selection {
            color: var(--login-ink);
            background: var(--login-mint);
        }

        .login-main {
            position: relative;
            isolation: isolate;
            display: flex;
            align-items: center;
            padding: clamp(2.4rem, 6vw, 5rem) 0;
            overflow: hidden;
        }

        .login-orb,
        .login-ring,
        .login-dots {
            position: absolute;
            z-index: -1;
            pointer-events: none;
        }

        .login-orb {
            top: 8%;
            left: -7rem;
            width: 18rem;
            height: 18rem;
            border-radius: 50%;
            background: rgba(185, 229, 229, .28);
            filter: blur(1px);
        }

        .login-ring {
            right: -8rem;
            bottom: 5%;
            width: 23rem;
            height: 23rem;
            border: 1px solid rgba(147, 192, 222, .38);
            border-radius: 50%;
            box-shadow: inset 0 0 0 4rem rgba(147, 192, 222, .055);
        }

        .login-dots {
            top: 12%;
            right: 8%;
            width: 74px;
            height: 74px;
            opacity: .22;
            background-image: radial-gradient(var(--login-ink) 1.2px, transparent 1.2px);
            background-size: 12px 12px;
        }

        .login-card-wrap {
            position: relative;
            max-width: 490px;
            margin: 0 auto;
        }

        .login-card-wrap::before {
            position: absolute;
            z-index: -1;
            inset: 1rem -1rem -1rem 1rem;
            border-radius: 30px;
            background: linear-gradient(145deg, var(--login-sky), var(--login-mint));
            content: "";
            opacity: .5;
            transform: rotate(1.3deg);
        }

        .login-card {
            position: relative;
            overflow: hidden;
            border: 1px solid rgba(255, 255, 255, .9);
            border-radius: 30px;
            background: rgba(255, 255, 255, .93);
            box-shadow: 0 28px 72px rgba(9, 35, 47, .14);
            -webkit-backdrop-filter: blur(16px);
            backdrop-filter: blur(16px);
            animation: login-rise .7s cubic-bezier(.2, .8, .2, 1) both;
        }

        .login-card-body {
            padding: clamp(1.8rem, 5vw, 3rem);
        }

        .login-brand {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: .65rem;
            margin-bottom: 1.5rem;
        }

        .login-logo {
            position: relative;
            display: inline-flex;
            width: 72px;
            height: 72px;
            flex: 0 0 72px;
            align-items: center;
            justify-content: center;
            overflow: visible;
            background: transparent;
        }

        .login-logo::after {
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

        .login-logo img {
            position: absolute;
            top: 50%;
            left: 50%;
            width: 98px;
            height: 98px;
            max-width: none;
            z-index: 1;
            transform: translate(-50%, -50%);
        }

        .login-wordmark {
            color: var(--login-ink);
            font-size: 1.32rem;
            font-weight: 800;
            letter-spacing: -.04em;
        }

        .login-heading {
            margin-bottom: 1.8rem;
            text-align: center;
        }

        .login-heading h1 {
            margin: 0;
            color: var(--login-ink);
            font-size: clamp(1.75rem, 5vw, 2.2rem);
            font-weight: 790;
            letter-spacing: -.045em;
        }

        .login-heading p {
            margin: .55rem 0 0;
            color: var(--login-muted);
            font-size: .84rem;
        }

        .login-field {
            margin-bottom: 1.05rem;
        }

        .login-label {
            display: block;
            margin-bottom: .48rem;
            color: var(--login-ink);
            font-size: .76rem;
            font-weight: 730;
        }

        .login-control-wrap {
            position: relative;
        }

        .login-control-icon {
            position: absolute;
            z-index: 2;
            top: 50%;
            left: 1rem;
            width: 18px;
            height: 18px;
            color: #6d8791;
            pointer-events: none;
            transform: translateY(-50%);
            transition: color .2s ease, transform .2s ease;
        }

        .login-control-wrap:focus-within .login-control-icon {
            color: var(--login-ink);
            transform: translateY(-50%) scale(1.06);
        }

        .login-control-wrap .form-control {
            min-height: 52px;
            padding: .8rem 1rem .8rem 3rem;
            color: var(--login-ink);
            border: 1px solid rgba(9, 35, 47, .13);
            border-radius: 15px;
            background: #fbfcfc;
            font-size: .88rem;
            box-shadow: 0 0 0 0 rgba(147, 192, 222, 0);
            transition: border-color .2s ease, box-shadow .2s ease, background .2s ease, transform .2s ease;
        }

        .login-control-wrap .form-control::placeholder {
            color: #9ca5a9;
        }

        .login-control-wrap:has(.password-toggle) .form-control {
            padding-right: 3.25rem;
        }

        .login-control-wrap .form-control:focus {
            color: var(--login-ink);
            border-color: var(--login-sky);
            outline: 0;
            background: var(--login-white);
            box-shadow: 0 0 0 4px rgba(147, 192, 222, .2);
            transform: translateY(-1px);
        }

        .login-control-wrap .form-control.is-invalid {
            padding-right: 3rem;
            border-color: rgba(177, 59, 73, .68) !important;
            background-image: none;
        }

        .login-control-wrap .form-control.is-invalid:focus {
            border-color: var(--login-danger) !important;
            box-shadow: 0 0 0 4px rgba(177, 59, 73, .13) !important;
        }

        .password-toggle {
            position: absolute;
            z-index: 3;
            top: 50%;
            right: .65rem;
            display: grid;
            width: 36px;
            height: 36px;
            padding: 0;
            place-items: center;
            color: var(--login-muted);
            border: 0;
            border-radius: 11px;
            background: transparent;
            transform: translateY(-50%);
            transition: color .2s ease, background .2s ease;
        }

        .password-toggle:hover,
        .password-toggle:focus {
            color: var(--login-ink);
            outline: 0;
            background: rgba(185, 229, 229, .35);
        }

        .password-toggle svg {
            width: 18px;
            height: 18px;
        }

        .password-toggle .eye-off,
        .password-toggle.is-visible .eye-on {
            display: none;
        }

        .password-toggle.is-visible .eye-off {
            display: block;
        }

        .text-validation-error {
            display: block;
            margin-top: .38rem;
            color: var(--login-danger) !important;
            font-size: .72rem;
            font-weight: 650;
        }

        .login-card .alert {
            margin: .7rem 0 0 !important;
            padding: .8rem .9rem !important;
            border-radius: 14px;
            font-size: .76rem !important;
            line-height: 1.45;
        }

        .login-card .alert-danger {
            color: #772632;
            border: 1px solid rgba(177, 59, 73, .24);
            background: rgba(255, 232, 235, .78);
        }

        .login-card .alert-warning {
            color: #715515;
            border: 1px solid rgba(164, 124, 28, .22);
            background: rgba(255, 248, 221, .88);
        }

        .login-card .alert-success {
            color: #245f52;
            border: 1px solid rgba(59, 142, 121, .24);
            background: rgba(222, 246, 239, .84);
        }

        .login-primary.btn {
            min-height: 52px;
            color: var(--login-white);
            border: 0;
            border-radius: 15px;
            background: var(--login-ink);
            font-size: .86rem;
            font-weight: 760;
            box-shadow: 0 13px 27px rgba(9, 35, 47, .2);
            transition: transform .22s ease, box-shadow .22s ease, background .22s ease;
        }

        .login-primary.btn:hover,
        .login-primary.btn:focus {
            color: var(--login-white);
            background: #123b4d;
            box-shadow: 0 17px 31px rgba(9, 35, 47, .25);
            transform: translateY(-2px);
        }

        .login-primary.is-loading {
            cursor: wait;
            background-image: linear-gradient(100deg, var(--login-ink) 20%, #19495d 48%, var(--login-ink) 76%);
            background-size: 200% 100%;
            animation: login-loading 1.2s linear infinite;
        }

        .login-separator {
            display: flex;
            gap: .75rem;
            align-items: center;
            margin: 1rem 0;
            color: var(--login-muted);
            font-size: .65rem;
            text-transform: uppercase;
            letter-spacing: .08em;
        }

        .login-separator::before,
        .login-separator::after {
            height: 1px;
            flex: 1 1 auto;
            background: rgba(9, 35, 47, .1);
            content: "";
        }

        .login-mock.btn {
            min-height: 47px;
            color: #48616d;
            border: 1px solid rgba(9, 35, 47, .13);
            border-radius: 14px;
            background: rgba(229, 229, 229, .34);
            font-size: .75rem;
            font-weight: 700;
            transition: color .2s ease, background .2s ease, border-color .2s ease, transform .2s ease;
        }

        .login-mock.btn:hover,
        .login-mock.btn:focus {
            color: var(--login-ink);
            border-color: var(--login-sky);
            background: rgba(185, 229, 229, .34);
            transform: translateY(-1px);
        }

        .resend-button.btn {
            min-height: 42px;
            color: #715515;
            border-color: rgba(113, 85, 21, .35);
            border-radius: 11px;
            font-size: .72rem;
            font-weight: 700;
        }

        .login-links {
            margin-top: 1.25rem;
            text-align: center;
        }

        .login-link {
            color: #446978;
            font-size: .78rem;
            font-weight: 680;
            text-underline-offset: 3px;
            transition: color .2s ease;
        }

        .login-link:hover,
        .login-link:focus {
            color: var(--login-ink);
        }

        .login-register {
            margin-top: .85rem;
            padding-top: 1rem;
            border-top: 1px solid rgba(9, 35, 47, .08);
            color: var(--login-muted);
            font-size: .77rem;
            text-align: center;
        }

        .login-footer {
            border-top: 1px solid rgba(9, 35, 47, .08);
            background: rgba(255, 255, 255, .62);
        }

        .login-footer-inner {
            min-height: 70px;
        }

        .login-footer-logo {
            position: relative;
            display: inline-flex;
            width: 32px;
            height: 32px;
            flex: 0 0 32px;
            align-items: center;
            justify-content: center;
            overflow: visible;
            background: transparent;
        }

        .login-footer-logo img {
            position: absolute;
            top: 50%;
            left: 50%;
            width: 46px;
            height: 46px;
            max-width: none;
            filter: drop-shadow(0 5px 5px rgba(9, 35, 47, .18));
            transform: translate(-50%, -50%);
        }

        .login-footer-copy,
        .login-footer-link {
            color: var(--login-muted) !important;
            font-size: .75rem;
        }

        .login-footer-link:hover,
        .login-footer-link:focus {
            color: var(--login-ink) !important;
        }

        @keyframes login-rise {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @keyframes login-loading {
            to { background-position: -200% 0; }
        }

        @media (max-width: 575.98px) {
            .login-main {
                align-items: flex-start;
                padding: 1.5rem 0 2.5rem;
            }

            .login-card-wrap::before {
                inset: .75rem -.35rem -.55rem .55rem;
            }

            .login-card,
            .login-card-wrap::before {
                border-radius: 24px;
            }

            .login-card-body {
                padding: 1.55rem 1.25rem 1.65rem;
            }

            .login-brand {
                margin-bottom: 1.15rem;
            }

            .login-footer-inner {
                padding-top: 1rem;
                padding-bottom: 1rem;
            }
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
<body class="login-page">
    <form id="form1" runat="server" class="min-vh-100 d-flex flex-column">

        <main class="login-main flex-grow-1">
            <span class="login-orb" aria-hidden="true"></span>
            <span class="login-ring" aria-hidden="true"></span>
            <span class="login-dots" aria-hidden="true"></span>

            <div class="container">
                <div class="row justify-content-center">
                    <div class="col-12 col-sm-10 col-md-7 col-lg-5 col-xl-4">
                        <div class="login-card-wrap">
                            <section class="login-card" aria-labelledby="loginTitle">
                                <div class="login-card-body">

                                    <div class="login-brand" aria-label="TinyDesk">
                                        <span class="login-logo" aria-hidden="true">
                                            <img runat="server" src="~/Images/LogoTD.png" alt="" />
                                        </span>
                                        <span class="login-wordmark">TinyDesk</span>
                                    </div>

                                    <header class="login-heading">
                                        <h1 id="loginTitle">Iniciar sesión</h1>
                                        <p>Volvé a tu espacio de trabajo.</p>
                                    </header>

                                    <div class="login-field">
                                        <label for="<%= txtNombreUsuario.ClientID %>" class="login-label">Usuario</label>

                                        <div class="login-control-wrap">
                                            <svg class="login-control-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" aria-hidden="true">
                                                <circle cx="12" cy="8" r="4" />
                                                <path d="M4.5 21a7.5 7.5 0 0 1 15 0" />
                                            </svg>

                                            <asp:TextBox ID="txtNombreUsuario"
                                                runat="server"
                                                CssClass="form-control"
                                                autocomplete="username"
                                                placeholder="Ingresá tu usuario"></asp:TextBox>
                                        </div>

                                        <asp:RequiredFieldValidator ID="rfvUsuario" runat="server"
                                            ControlToValidate="txtNombreUsuario"
                                            ErrorMessage="Ingrese un usuario válido."
                                            CssClass="text-danger text-validation-error"
                                            Display="Dynamic" />

                                        <asp:Label ID="lblErrorUsuario" runat="server"
                                            CssClass="alert alert-danger text-center d-block"
                                            Visible="false"></asp:Label>
                                    </div>

                                    <div class="login-field">
                                        <label for="<%= txtPassword.ClientID %>" class="login-label">Contraseña</label>

                                        <div class="login-control-wrap">
                                            <svg class="login-control-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" aria-hidden="true">
                                                <rect x="5" y="10" width="14" height="11" rx="2" />
                                                <path d="M8 10V7a4 4 0 0 1 8 0v3" />
                                            </svg>

                                            <asp:TextBox ID="txtPassword"
                                                runat="server"
                                                CssClass="form-control"
                                                TextMode="Password"
                                                autocomplete="current-password"
                                                placeholder="Ingresá tu contraseña"></asp:TextBox>

                                            <button id="passwordToggle"
                                                class="password-toggle"
                                                type="button"
                                                aria-label="Mostrar contraseña"
                                                aria-pressed="false">

                                                <svg class="eye-on" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" aria-hidden="true">
                                                    <path d="M2.5 12s3.5-6 9.5-6 9.5 6 9.5 6-3.5 6-9.5 6-9.5-6-9.5-6Z" />
                                                    <circle cx="12" cy="12" r="2.7" />
                                                </svg>

                                                <svg class="eye-off" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" aria-hidden="true">
                                                    <path d="m3 3 18 18M10.6 6.2A10.7 10.7 0 0 1 12 6c6 0 9.5 6 9.5 6a17 17 0 0 1-2.2 2.8M6.5 6.7C3.9 8.5 2.5 12 2.5 12s3.5 6 9.5 6a10 10 0 0 0 3-.4M9.8 9.8a3 3 0 0 0 4.4 4.4" />
                                                </svg>
                                            </button>
                                        </div>

                                        <asp:RequiredFieldValidator ID="rfvPassword" runat="server"
                                            ControlToValidate="txtPassword"
                                            ErrorMessage="Ingrese una contraseña válida."
                                            CssClass="text-danger text-validation-error"
                                            Display="Dynamic" />

                                        <asp:Label ID="lblErrorPass" runat="server"
                                            CssClass="alert alert-danger text-center d-block"
                                            Visible="false"></asp:Label>
                                    </div>

                                    <asp:Button ID="btnLogin" runat="server"
                                        Text="Iniciar Sesión"
                                        CssClass="btn login-primary w-100"
                                        OnClick="btnLogin_Click"
                                        OnClientClick="clearErrors();" />

                                    <div class="login-separator">Acceso de prueba</div>

                                    <asp:Button ID="btnMockLogin" runat="server"
                                        Text="Ingresar sin contraseña (Mock)"
                                        CssClass="btn login-mock w-100"
                                        OnClick="btnLoginFantasmin_Click"
                                        CausesValidation="false" />

                                    <asp:Panel ID="pnlReenvioValidacion" runat="server" Visible="false" CssClass="alert alert-warning mt-3">
                                        <asp:Label ID="lblReenvioValidacion" runat="server"></asp:Label>

                                        <asp:Button ID="btnReenviarValidacion" runat="server"
                                            Text="Reenviar correo de validación"
                                            CssClass="btn btn-outline-warning resend-button w-100 mt-2"
                                            CausesValidation="false"
                                            OnClick="btnReenviarValidacion_Click" />
                                    </asp:Panel>

                                    <div class="login-links">
                                        <a href="RecuperarPass.aspx" class="login-link text-decoration-none">¿Te olvidaste la contraseña?</a>
                                    </div>

                                    <div class="login-register">
                                        <span>¿No tenés cuenta?</span>
                                        <a href="Registro.aspx" class="login-link text-decoration-none ms-1">Crear usuario</a>
                                    </div>

                                </div>
                            </section>
                        </div>
                    </div>
                </div>
            </div>
        </main>

        <footer class="login-footer">
            <div class="container login-footer-inner d-flex flex-column flex-sm-row justify-content-between align-items-center gap-2">
                <div class="d-flex align-items-center gap-2">
                    <span class="login-footer-logo" aria-hidden="true">
                        <img runat="server" src="~/Images/LogoTD.png" alt="" />
                    </span>
                    <span class="login-footer-copy">&copy; <%: DateTime.Now.Year %> TinyDesk</span>
                </div>

                <nav class="d-flex align-items-center gap-3" aria-label="Navegación del pie de página">
                    <asp:LinkButton ID="btnFooterAbout"
                        runat="server"
                        CausesValidation="false"
                        OnClick="btnFooterAbout_Click"
                        CssClass="btn btn-link text-decoration-none p-0 login-footer-link">
                        Acerca de
                    </asp:LinkButton>

                    <asp:LinkButton ID="btnFooterContacto"
                        runat="server"
                        CausesValidation="false"
                        OnClick="btnFooterContacto_Click"
                        CssClass="btn btn-link text-decoration-none p-0 login-footer-link">
                        Contacto
                    </asp:LinkButton>
                </nav>
            </div>
        </footer>
    </form>

    <script type="text/javascript">
        function clearErrors() {
            var userError = document.getElementById("<%= lblErrorUsuario.ClientID %>");
            var passwordError = document.getElementById("<%= lblErrorPass.ClientID %>");
            var userInput = document.getElementById("<%= txtNombreUsuario.ClientID %>");
            var passwordInput = document.getElementById("<%= txtPassword.ClientID %>");

            if (userError) userError.style.display = "none";
            if (passwordError) passwordError.style.display = "none";
            if (userInput) userInput.classList.remove("is-invalid");
            if (passwordInput) passwordInput.classList.remove("is-invalid");
        }

        (function () {
            "use strict";

            var password = document.getElementById("<%= txtPassword.ClientID %>");
            var toggle = document.getElementById("passwordToggle");
            var form = document.getElementById("<%= form1.ClientID %>");
            var loginButton = document.getElementById("<%= btnLogin.ClientID %>");

            if (password && toggle) {
                toggle.addEventListener("click", function () {
                    var showPassword = password.type === "password";
                    password.type = showPassword ? "text" : "password";
                    toggle.classList.toggle("is-visible", showPassword);
                    toggle.setAttribute("aria-pressed", showPassword ? "true" : "false");
                    toggle.setAttribute("aria-label", showPassword ? "Ocultar contraseña" : "Mostrar contraseña");
                    password.focus();
                });
            }

            if (form && loginButton) {
                form.addEventListener("submit", function (event) {
                    if (event.submitter && event.submitter !== loginButton) return;

                    window.setTimeout(function () {
                        if (typeof window.Page_IsValid === "undefined" || window.Page_IsValid) {
                            loginButton.value = "Ingresando...";
                            loginButton.classList.add("is-loading");
                            loginButton.setAttribute("aria-busy", "true");
                        }
                    }, 0);
                });
            }
        }());
    </script>
</body>
</html>
