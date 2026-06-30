<%@ Page Title="Contacto" Language="C#" AutoEventWireup="true" CodeBehind="Contacto.aspx.cs" Inherits="TP_Final_Programacion_III.Contacto" %>

<!DOCTYPE html>

<html lang="es">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta name="theme-color" content="#09232f" />

    <title>Contacto - TinyDesk</title>

    <link href="Content/bootstrap.min.css" rel="stylesheet" />
    <link href="Content/Site.css" rel="stylesheet" />
    <link href="favicon.ico" rel="shortcut icon" type="image/x-icon" />

    <style>
        :root {
            --contact-sky: #93c0de;
            --contact-mint: #b9e5e5;
            --contact-ink: #09232f;
            --contact-muted: #75797e;
            --contact-cloud: #e5e5e5;
            --contact-white: #ffffff;
            --contact-danger: #b13b49;
            --contact-radius: 28px;
            --contact-shadow: 0 26px 70px rgba(9, 35, 47, .13);
        }

        * {
            box-sizing: border-box;
        }

        html {
            scroll-behavior: smooth;
        }

        body.contact-page {
            min-width: 320px;
            margin: 0;
            color: var(--contact-ink);
            background: radial-gradient(circle at 8% 18%, rgba(185, 229, 229, .72), transparent 25rem), radial-gradient(circle at 92% 72%, rgba(147, 192, 222, .34), transparent 27rem), #f7f9fa;
            font-family: "Segoe UI Variable", "Segoe UI", system-ui, -apple-system, sans-serif;
            overflow-x: hidden;
        }

        .contact-page ::selection {
            color: var(--contact-ink);
            background: var(--contact-mint);
        }

        .contact-nav {
            position: relative;
            z-index: 20;
            border-bottom: 1px solid rgba(9, 35, 47, .08);
            background: rgba(255, 255, 255, .76);
            -webkit-backdrop-filter: blur(18px);
            backdrop-filter: blur(18px);
        }

        .contact-nav-inner {
            min-height: 78px;
        }

        .contact-brand {
            gap: .7rem;
            color: var(--contact-ink) !important;
            letter-spacing: -.035em;
            transition: transform .22s ease;
        }

            .contact-brand:hover {
                transform: translateY(-1px);
            }

        .contact-logo,
        .footer-logo {
            position: relative;
            display: inline-flex;
            flex: 0 0 auto;
            align-items: center;
            justify-content: center;
            overflow: visible;
            background: transparent;
        }

        .contact-logo {
            width: 62px;
            height: 62px;
        }

            .contact-logo::after {
                position: absolute;
                z-index: 0;
                right: 23%;
                bottom: 4px;
                left: 23%;
                height: 10px;
                border-radius: 50%;
                background: rgba(9, 35, 47, .25);
                content: "";
                filter: blur(5px);
                transform: translateY(8px);
            }

            .contact-logo img {
                position: absolute;
                top: 50%;
                left: 50%;
                width: 84px;
                height: 84px;
                max-width: none;
                z-index: 1;
                transform: translate(-50%, -50%);
            }

        .contact-brand-name {
            font-size: 1.35rem;
            font-weight: 780;
        }

        .contact-back {
            display: inline-flex;
            align-items: center;
            gap: .5rem;
            padding: .68rem 1rem;
            color: var(--contact-ink) !important;
            border: 1px solid rgba(9, 35, 47, .15);
            border-radius: 999px;
            background: rgba(255, 255, 255, .68);
            font-size: .85rem;
            font-weight: 700;
            box-shadow: none;
            transition: transform .2s ease, border-color .2s ease, background .2s ease, box-shadow .2s ease;
        }

            .contact-back:hover,
            .contact-back:focus {
                color: var(--contact-ink) !important;
                border-color: var(--contact-sky);
                background: var(--contact-white);
                box-shadow: 0 8px 24px rgba(9, 35, 47, .1);
                transform: translateY(-2px);
            }

            .contact-back svg {
                width: 17px;
                height: 17px;
                transition: transform .2s ease;
            }

            .contact-back:hover svg {
                transform: translateX(-3px);
            }

        .contact-main {
            position: relative;
            isolation: isolate;
            display: flex;
            align-items: center;
            padding-top: clamp(3.5rem, 7vw, 6.5rem);
            padding-bottom: clamp(4rem, 8vw, 7rem);
        }

        .contact-orb {
            position: absolute;
            z-index: -1;
            border-radius: 50%;
            pointer-events: none;
            filter: blur(1px);
        }

        .contact-orb-one {
            top: 5%;
            right: -8rem;
            width: 22rem;
            height: 22rem;
            border: 1px solid rgba(147, 192, 222, .42);
            box-shadow: inset 0 0 0 3.5rem rgba(147, 192, 222, .06);
        }

        .contact-orb-two {
            bottom: 7%;
            left: -7rem;
            width: 14rem;
            height: 14rem;
            background: rgba(185, 229, 229, .22);
        }

        .contact-intro {
            position: relative;
            max-width: 510px;
            padding-right: clamp(0rem, 3vw, 2.5rem);
        }

        .contact-eyebrow,
        .form-kicker {
            display: inline-flex;
            align-items: center;
            gap: .55rem;
            color: var(--contact-ink);
            font-size: .76rem;
            font-weight: 800;
            letter-spacing: .13em;
            text-transform: uppercase;
        }

        .contact-eyebrow-dot {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background: var(--contact-sky);
            box-shadow: 0 0 0 6px rgba(147, 192, 222, .2);
        }

        .contact-title {
            max-width: 9.5ch;
            margin: 1.15rem 0 1.25rem;
            font-size: clamp(3rem, 5.6vw, 5.45rem);
            font-weight: 790;
            line-height: .96;
            letter-spacing: -.065em;
        }

        .contact-title-accent {
            position: relative;
            display: inline-block;
            color: var(--contact-ink);
        }

            .contact-title-accent::after {
                position: absolute;
                z-index: -1;
                right: -.1em;
                bottom: .02em;
                left: -.06em;
                height: .24em;
                border-radius: 999px;
                background: var(--contact-mint);
                content: "";
                transform: rotate(-1.5deg);
            }

        .contact-lead {
            max-width: 43ch;
            margin: 0;
            color: var(--contact-muted);
            font-size: clamp(1rem, 1.5vw, 1.16rem);
            line-height: 1.72;
        }

        .contact-steps {
            display: grid;
            gap: 1rem;
            margin-top: 2.4rem;
        }

        .contact-step {
            display: grid;
            grid-template-columns: 42px 1fr;
            gap: .9rem;
            align-items: center;
        }

        .contact-step-number {
            display: grid;
            width: 42px;
            height: 42px;
            place-items: center;
            color: var(--contact-ink);
            border: 1px solid rgba(9, 35, 47, .09);
            border-radius: 14px;
            background: rgba(255, 255, 255, .64);
            font-size: .72rem;
            font-weight: 800;
            box-shadow: 0 8px 24px rgba(9, 35, 47, .06);
        }

        .contact-step strong {
            display: block;
            margin-bottom: .1rem;
            font-size: .92rem;
        }

        .contact-step span:last-child {
            color: var(--contact-muted);
            font-size: .8rem;
        }

        .contact-card-wrap {
            position: relative;
        }

            .contact-card-wrap::before {
                position: absolute;
                z-index: -1;
                inset: 1.2rem -1.1rem -1.1rem 1.4rem;
                border-radius: var(--contact-radius);
                background: linear-gradient(145deg, var(--contact-sky), var(--contact-mint));
                content: "";
                opacity: .48;
                transform: rotate(1.5deg);
            }

        .contact-card {
            overflow: hidden;
            border: 1px solid rgba(255, 255, 255, .85);
            border-radius: var(--contact-radius);
            background: rgba(255, 255, 255, .92);
            box-shadow: var(--contact-shadow);
            -webkit-backdrop-filter: blur(14px);
            backdrop-filter: blur(14px);
        }

        .contact-card-head {
            display: flex;
            justify-content: space-between;
            gap: 1rem;
            align-items: flex-start;
            padding: clamp(1.5rem, 4vw, 2.35rem) clamp(1.4rem, 4vw, 2.65rem) 1.1rem;
        }

            .contact-card-head h2 {
                margin: .45rem 0 0;
                font-size: clamp(1.45rem, 2.4vw, 1.9rem);
                font-weight: 760;
                letter-spacing: -.035em;
            }

        .form-kicker {
            color: #57717d;
            font-size: .68rem;
        }

        .form-status {
            display: inline-flex;
            flex: 0 0 auto;
            align-items: center;
            gap: .42rem;
            margin-top: .15rem;
            padding: .5rem .7rem;
            color: var(--contact-ink);
            border-radius: 999px;
            background: rgba(185, 229, 229, .45);
            font-size: .68rem;
            font-weight: 750;
        }

            .form-status::before {
                width: 7px;
                height: 7px;
                border-radius: 50%;
                background: #3b8e79;
                content: "";
                box-shadow: 0 0 0 4px rgba(59, 142, 121, .12);
            }

        .contact-card-body {
            padding: 1.2rem clamp(1.4rem, 4vw, 2.65rem) clamp(1.6rem, 4vw, 2.65rem);
        }

        .session-card {
            position: relative;
            margin-bottom: 1.35rem !important;
            padding: 1rem 1rem 1rem 3.6rem;
            color: var(--contact-ink);
            border: 1px solid rgba(147, 192, 222, .44) !important;
            border-radius: 18px;
            background: linear-gradient(135deg, rgba(185, 229, 229, .42), rgba(147, 192, 222, .12)) !important;
        }

            .session-card::before {
                position: absolute;
                top: 1.08rem;
                left: 1rem;
                display: grid;
                width: 34px;
                height: 34px;
                place-items: center;
                border-radius: 11px;
                background: var(--contact-white);
                box-shadow: 0 5px 14px rgba(9, 35, 47, .09);
                content: "✓";
                font-weight: 850;
            }

        .session-caption {
            color: #57717d;
            font-size: .73rem;
        }

        .session-name {
            margin-top: .08rem;
            font-size: .92rem;
            font-weight: 750;
        }

        .session-detail {
            color: var(--contact-muted);
            font-size: .75rem;
        }

        .field-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 1rem;
        }

        .contact-field {
            margin-bottom: 1.05rem;
        }

        .contact-label {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: .48rem;
            color: var(--contact-ink);
            font-size: .78rem;
            font-weight: 720;
        }

        .contact-optional {
            color: var(--contact-muted);
            font-size: .68rem;
            font-weight: 500;
        }

        .control-shell {
            position: relative;
        }

        .control-icon {
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

        .control-shell:focus-within .control-icon {
            color: var(--contact-ink);
            transform: translateY(-50%) scale(1.06);
        }

        .contact-control.form-control,
        .contact-control.form-select {
            min-height: 51px;
            padding: .78rem 1rem .78rem 3rem;
            color: var(--contact-ink);
            border: 1px solid rgba(9, 35, 47, .13);
            border-radius: 15px;
            background-color: #fbfcfc;
            font-size: .88rem;
            box-shadow: 0 0 0 0 rgba(147, 192, 222, 0);
            transition: border-color .2s ease, box-shadow .2s ease, background-color .2s ease, transform .2s ease;
        }

            .contact-control.form-control::placeholder {
                color: #9aa3a7;
            }

            .contact-control.form-control:focus,
            .contact-control.form-select:focus {
                color: var(--contact-ink);
                border-color: var(--contact-sky);
                outline: 0;
                background: var(--contact-white);
                box-shadow: 0 0 0 4px rgba(147, 192, 222, .2);
                transform: translateY(-1px);
            }

        .message-shell .control-icon {
            top: 1rem;
            transform: none;
        }

        .message-shell:focus-within .control-icon {
            transform: scale(1.06);
        }

        .contact-control.contact-message {
            min-height: 152px;
            padding-top: .9rem;
            resize: vertical;
            line-height: 1.55;
        }

        .field-help {
            display: flex;
            justify-content: space-between;
            gap: 1rem;
            margin-top: .45rem;
            color: var(--contact-muted);
            font-size: .7rem;
        }

        .word-counter {
            flex: 0 0 auto;
            color: #56717d;
            font-variant-numeric: tabular-nums;
            font-weight: 700;
        }

            .word-counter.is-near {
                color: #8d651f;
            }

            .word-counter.is-over {
                color: var(--contact-danger);
            }

        .contact-page .text-danger.small {
            display: block;
            margin-top: .38rem;
            color: var(--contact-danger) !important;
            font-size: .72rem !important;
            font-weight: 650;
        }

        .contact-page .alert-danger,
        .contact-page .alert-success {
            margin: 1rem 0;
            padding: .9rem 1rem;
            border-radius: 15px;
            font-size: .8rem;
        }

        .contact-page .alert-danger {
            color: #772632;
            border: 1px solid rgba(177, 59, 73, .25);
            background: rgba(255, 232, 235, .76);
        }

        .contact-page .alert-success {
            color: #245f52;
            border: 1px solid rgba(59, 142, 121, .24);
            background: rgba(222, 246, 239, .82);
        }

        .contact-submit.btn {
            position: relative;
            width: 100%;
            min-height: 54px;
            margin-top: .35rem;
            overflow: hidden;
            color: var(--contact-white);
            border: 0;
            border-radius: 16px;
            background: var(--contact-ink);
            font-size: .88rem;
            font-weight: 760;
            letter-spacing: .01em;
            box-shadow: 0 13px 28px rgba(9, 35, 47, .2);
            transition: transform .22s ease, box-shadow .22s ease, background .22s ease;
        }

            .contact-submit.btn:hover,
            .contact-submit.btn:focus {
                color: var(--contact-white);
                background: #123b4d;
                box-shadow: 0 17px 32px rgba(9, 35, 47, .25);
                transform: translateY(-2px);
            }

            .contact-submit.btn:active {
                transform: translateY(0);
            }

        .contact-submit.is-sending {
            cursor: wait;
            background-image: linear-gradient(100deg, var(--contact-ink) 20%, #19495d 48%, var(--contact-ink) 76%);
            background-size: 200% 100%;
            animation: contact-loading 1.2s linear infinite;
        }

        .form-note {
            display: flex;
            justify-content: center;
            gap: .45rem;
            align-items: center;
            margin: .85rem 0 0;
            color: var(--contact-muted);
            font-size: .68rem;
            text-align: center;
        }

            .form-note svg {
                width: 13px;
                height: 13px;
            }

        .contact-footer {
            position: relative;
            z-index: 4;
            border-top: 1px solid rgba(9, 35, 47, .08);
            background: rgba(255, 255, 255, .62);
        }

        .contact-footer-inner {
            min-height: 58px;
        }

        .footer-logo {
            width: 32px;
            height: 32px;
        }

            .footer-logo img {
                position: absolute;
                top: 50%;
                left: 50%;
                width: 46px;
                height: 46px;
                max-width: none;
                filter: drop-shadow(0 5px 5px rgba(9, 35, 47, .18));
                transform: translate(-50%, -50%);
            }

        .footer-copy,
        .contact-footer-link {
            color: var(--contact-muted) !important;
            font-size: .75rem;
        }

        .contact-footer-link {
            transition: color .2s ease;
        }

            .contact-footer-link:hover,
            .contact-footer-link:focus,
            .contact-footer-link.is-active {
                color: var(--contact-ink) !important;
            }

        @keyframes contact-loading {
            to {
                background-position: -200% 0;
            }
        }

        @keyframes contact-rise {
            from {
                opacity: 0;
                transform: translateY(18px);
            }

            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .contact-intro,
        .contact-card-wrap {
            animation: contact-rise .7s cubic-bezier(.2, .8, .2, 1) both;
        }

        .contact-card-wrap {
            animation-delay: .12s;
        }

        @media (max-width: 991.98px) {
            .contact-main {
                align-items: flex-start;
            }

            .contact-intro {
                max-width: 680px;
                margin: 0 auto 3rem;
                padding-right: 0;
                text-align: center;
            }

            .contact-title {
                max-width: 11ch;
                margin-right: auto;
                margin-left: auto;
            }

            .contact-lead {
                margin-right: auto;
                margin-left: auto;
            }

            .contact-steps {
                grid-template-columns: repeat(3, minmax(0, 1fr));
                gap: .75rem;
            }

            .contact-step {
                grid-template-columns: 1fr;
                justify-items: center;
                padding: 1rem .65rem;
                border: 1px solid rgba(9, 35, 47, .08);
                border-radius: 18px;
                background: rgba(255, 255, 255, .48);
                text-align: center;
            }

            .contact-card-wrap {
                max-width: 740px;
                margin: 0 auto;
            }
        }

        @media (max-width: 575.98px) {
            .contact-nav-inner {
                min-height: 68px;
            }

            .contact-logo {
                width: 54px;
                height: 54px;
            }

            .contact-brand-name {
                font-size: 1.15rem;
            }

            .contact-back {
                padding: .6rem .75rem;
                font-size: .75rem;
            }

            .contact-back-text {
                display: none;
            }

            .contact-main {
                padding-top: 2.8rem;
            }

            .contact-title {
                font-size: clamp(2.75rem, 14vw, 3.6rem);
            }

            .contact-steps {
                grid-template-columns: 1fr;
                max-width: 360px;
                margin-right: auto;
                margin-left: auto;
            }

            .contact-step {
                grid-template-columns: 42px 1fr;
                justify-items: stretch;
                padding: .65rem;
                text-align: left;
            }

            .contact-card-wrap::before {
                inset: .8rem -.35rem -.55rem .6rem;
            }

            .contact-card-head {
                align-items: center;
            }

            .form-status {
                width: 37px;
                height: 37px;
                justify-content: center;
                padding: 0;
                font-size: 0;
            }

            .field-grid {
                grid-template-columns: 1fr;
                gap: 0;
            }

            .contact-footer-inner {
                padding-top: .5rem;
                padding-bottom: .5rem;
            }
        }

        @media (prefers-reduced-motion: reduce) {
            html {
                scroll-behavior: auto;
            }

            *, *::before, *::after {
                scroll-behavior: auto !important;
                animation-duration: .01ms !important;
                animation-iteration-count: 1 !important;
                transition-duration: .01ms !important;
            }
        }
    </style>
</head>

<body class="contact-page">
    <form id="form1" runat="server" class="min-vh-100 d-flex flex-column">

        <header class="contact-nav">
            <div class="container contact-nav-inner d-flex justify-content-between align-items-center">

                <asp:LinkButton ID="btnInicio"
                    runat="server"
                    CausesValidation="false"
                    OnClick="btnInicio_Click"
                    CssClass="contact-brand d-inline-flex align-items-center text-decoration-none">

                    <span class="contact-logo" aria-hidden="true">
                        <img src="Images/LogoTD.png" alt="" />
                    </span>

                    <span class="contact-brand-name">TinyDesk</span>

                </asp:LinkButton>

                <asp:LinkButton ID="btnVolver"
                    runat="server"
                    CausesValidation="false"
                    OnClick="btnInicio_Click"
                    CssClass="contact-back btn text-decoration-none">

                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
                        <path d="M19 12H5M12 19l-7-7 7-7" />
                    </svg>
                    <span class="contact-back-text">Volver a TinyDesk</span>

                </asp:LinkButton>

            </div>
        </header>

        <main class="contact-main flex-grow-1">
            <span class="contact-orb contact-orb-one" aria-hidden="true"></span>
            <span class="contact-orb contact-orb-two" aria-hidden="true"></span>

            <div class="container">
                <div class="row g-5 align-items-center">

                    <div class="col-lg-5">
                        <section class="contact-intro" aria-labelledby="contactTitle">
                            <span class="contact-eyebrow">
                                <span class="contact-eyebrow-dot" aria-hidden="true"></span>
                                Estamos para ayudarte
                            </span>

                            <h1 id="contactTitle" class="contact-title">Hablemos de lo que <span class="contact-title-accent">necesitás.</span>
                            </h1>

                            <p class="contact-lead">
                                Elegí el motivo, contanos qué está pasando y vamos a orientar tu consulta al lugar correcto.
                           
                            </p>

                            <div class="contact-steps" aria-label="Cómo funciona el contacto">
                                <div class="contact-step">
                                    <span class="contact-step-number">01</span>
                                    <span>
                                        <strong>Completá</strong>
                                        <span>Solo los datos necesarios.</span>
                                    </span>
                                </div>

                                <div class="contact-step">
                                    <span class="contact-step-number">02</span>
                                    <span>
                                        <strong>Enviá</strong>
                                        <span>Tu consulta queda registrada.</span>
                                    </span>
                                </div>

                                <div class="contact-step">
                                    <span class="contact-step-number">03</span>
                                    <span>
                                        <strong>Te respondemos</strong>
                                        <span>Dentro de las próximas 24 horas.</span>
                                    </span>
                                </div>
                            </div>
                        </section>
                    </div>

                    <div class="col-lg-7">
                        <div class="contact-card-wrap">
                            <section class="contact-card" aria-labelledby="formTitle">
                                <div class="contact-card-head">
                                    <div>
                                        <span class="form-kicker">Mensaje nuevo</span>
                                        <h2 id="formTitle">¿Cómo podemos ayudarte?</h2>
                                    </div>
                                    <span class="form-status">Disponible</span>
                                </div>

                                <div class="contact-card-body">
                                    <asp:Panel ID="pnlDatosSesion"
                                        runat="server"
                                        Visible="false"
                                        CssClass="session-card">

                                        <span class="session-caption">Estás contactando como</span>

                                        <div class="session-name">
                                            <asp:Label ID="lblSesionNombre" runat="server" />
                                        </div>

                                        <div class="session-detail">
                                            <asp:Label ID="lblSesionDetalle" runat="server" />
                                        </div>

                                    </asp:Panel>

                                    <asp:Panel ID="pnlDatosPublicos" runat="server">
                                        <div class="field-grid">
                                            <div class="contact-field">
                                                <label class="contact-label" for="<%= txtNombre.ClientID %>">Nombre y apellido</label>
                                                <div class="control-shell">
                                                    <svg class="control-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" aria-hidden="true">
                                                        <circle cx="12" cy="8" r="4" />
                                                        <path d="M4.5 21a7.5 7.5 0 0 1 15 0" />
                                                    </svg>
                                                    <asp:TextBox ID="txtNombre"
                                                        runat="server"
                                                        CssClass="form-control contact-control"
                                                        autocomplete="name"
                                                        placeholder="Tu nombre" />
                                                </div>

                                                <asp:RequiredFieldValidator ID="rfvNombre"
                                                    runat="server"
                                                    ControlToValidate="txtNombre"
                                                    ValidationGroup="Contacto"
                                                    ErrorMessage="Ingresá tu nombre."
                                                    CssClass="text-danger small"
                                                    Display="Dynamic" />
                                            </div>

                                            <div class="contact-field">
                                                <label class="contact-label" for="<%= txtEmail.ClientID %>">Correo electrónico</label>
                                                <div class="control-shell">
                                                    <svg class="control-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" aria-hidden="true">
                                                        <rect x="3" y="5" width="18" height="14" rx="3" />
                                                        <path d="m4 7 8 6 8-6" />
                                                    </svg>
                                                    <asp:TextBox ID="txtEmail"
                                                        runat="server"
                                                        CssClass="form-control contact-control"
                                                        TextMode="Email"
                                                        autocomplete="email"
                                                        placeholder="nombre@correo.com" />
                                                </div>

                                                <asp:RequiredFieldValidator ID="rfvEmail"
                                                    runat="server"
                                                    ControlToValidate="txtEmail"
                                                    ValidationGroup="Contacto"
                                                    ErrorMessage="Ingresá tu correo electrónico."
                                                    CssClass="text-danger small"
                                                    Display="Dynamic" />

                                                <asp:RegularExpressionValidator ID="revEmail"
                                                    runat="server"
                                                    ControlToValidate="txtEmail"
                                                    ValidationGroup="Contacto"
                                                    ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$"
                                                    ErrorMessage="Ingresá un correo válido."
                                                    CssClass="text-danger small"
                                                    Display="Dynamic" />
                                            </div>
                                        </div>
                                    </asp:Panel>

                                    <div class="contact-field">
                                        <label class="contact-label" for="<%= ddlMotivo.ClientID %>">Motivo</label>
                                        <div class="control-shell">
                                            <svg class="control-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" aria-hidden="true">
                                                <path d="M4 5h16v12H7l-3 3V5Z" />
                                                <path d="M8 9h8M8 13h5" />
                                            </svg>
                                            <asp:DropDownList ID="ddlMotivo"
                                                runat="server"
                                                CssClass="form-select contact-control">

                                                <asp:ListItem Text="Seleccioná un motivo" Value="" />
                                                <asp:ListItem Text="Consulta general" Value="1" />
                                                <asp:ListItem Text="Problemas para ingresar" Value="2" />
                                                <asp:ListItem Text="Soporte técnico" Value="3" />
                                                <asp:ListItem Text="Planes y facturación" Value="4" />
                                                <asp:ListItem Text="Sugerencia" Value="5" />

                                            </asp:DropDownList>
                                        </div>

                                        <asp:RequiredFieldValidator ID="rfvMotivo"
                                            runat="server"
                                            ControlToValidate="ddlMotivo"
                                            InitialValue=""
                                            ValidationGroup="Contacto"
                                            ErrorMessage="Seleccioná un motivo."
                                            CssClass="text-danger small"
                                            Display="Dynamic" />
                                    </div>

                                    <div class="contact-field">
                                        <label class="contact-label" for="<%= txtMensaje.ClientID %>">
                                            Mensaje
                                           
                                            <span class="contact-optional">Sé tan específico como puedas</span>
                                        </label>

                                        <div class="control-shell message-shell">
                                            <svg class="control-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" aria-hidden="true">
                                                <path d="M4 20h4l11-11a2.8 2.8 0 0 0-4-4L4 16v4Z" />
                                                <path d="m13.5 6.5 4 4" />
                                            </svg>
                                            <asp:TextBox ID="txtMensaje"
                                                runat="server"
                                                CssClass="form-control contact-control contact-message"
                                                TextMode="MultiLine"
                                                Rows="7"
                                                placeholder="Contanos en qué podemos ayudarte..." />
                                        </div>

                                        <div class="field-help">
                                            <span>Máximo 200 palabras.</span>
                                            <span id="messageWordCount" class="word-counter" aria-live="polite">0 / 200</span>
                                        </div>

                                        <asp:RequiredFieldValidator ID="rfvMensaje"
                                            runat="server"
                                            ControlToValidate="txtMensaje"
                                            ValidationGroup="Contacto"
                                            ErrorMessage="Escribí un mensaje."
                                            CssClass="text-danger small"
                                            Display="Dynamic" />
                                    </div>

                                    <asp:ValidationSummary ID="vsContacto"
                                        runat="server"
                                        ValidationGroup="Contacto"
                                        CssClass="alert alert-danger"
                                        HeaderText="Revisá los siguientes datos:"
                                        DisplayMode="BulletList" />

                                    <asp:Panel ID="pnlResultado"
                                        runat="server"
                                        Visible="false"
                                        CssClass="alert">

                                        <asp:Label ID="lblResultado" runat="server" />

                                    </asp:Panel>

                                    <asp:Button ID="btnEnviar"
                                        runat="server"
                                        Text="Enviar mensaje"
                                        CssClass="btn contact-submit"
                                        ValidationGroup="Contacto"
                                        OnClick="btnEnviar_Click" />

                                    <p class="form-note">
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
                                            <rect x="5" y="10" width="14" height="11" rx="2" />
                                            <path d="M8 10V7a4 4 0 0 1 8 0v3" />
                                        </svg>
                                        Tus datos se usan únicamente para responder esta consulta.
                                   
                                    </p>
                                </div>
                            </section>
                        </div>
                    </div>

                </div>
            </div>
        </main>

        <footer class="contact-footer">
            <div class="container contact-footer-inner d-flex flex-column flex-sm-row justify-content-between align-items-center gap-2">
                <div class="d-flex align-items-center gap-2">
                    <span class="footer-logo" aria-hidden="true">
                        <img runat="server" src="~/Images/LogoTD.png" alt="" />
                    </span>
                    <span class="footer-copy">&copy; <%: DateTime.Now.Year %> TinyDesk</span>
                </div>

                <nav class="d-flex align-items-center gap-3" aria-label="Navegación del pie de página">
                    <asp:LinkButton ID="btnIrAbout"
                        runat="server"
                        CausesValidation="false"
                        OnClick="btnIrAbout_Click"
                        CssClass="btn btn-link text-decoration-none p-0 contact-footer-link">
                        Acerca de
                    </asp:LinkButton>

                    <asp:LinkButton ID="btnIrContacto"
                        runat="server"
                        CausesValidation="false"
                        OnClick="btnIrContacto_Click"
                        CssClass="btn btn-link text-decoration-none p-0 contact-footer-link is-active">
                        Contacto
                    </asp:LinkButton>
                </nav>
            </div>
        </footer>

    </form>

    <script>
        (function () {
            "use strict";

            var message = document.getElementById("<%= txtMensaje.ClientID %>");
            var counter = document.getElementById("messageWordCount");
            var form = document.getElementById("<%= form1.ClientID %>");
            var submit = document.getElementById("<%= btnEnviar.ClientID %>");
            var result = document.getElementById("<%= pnlResultado.ClientID %>");

            function countWords(value) {
                var clean = (value || "").trim();
                return clean ? clean.split(/\s+/).length : 0;
            }

            function updateCounter() {
                if (!message || !counter) return;

                var total = countWords(message.value);
                counter.textContent = total + " / 200";
                counter.classList.toggle("is-near", total >= 170 && total <= 200);
                counter.classList.toggle("is-over", total > 200);
            }

            if (message) {
                message.addEventListener("input", updateCounter);
                updateCounter();
            }

            if (form && submit) {
                form.addEventListener("submit", function () {
                    window.setTimeout(function () {
                        if (typeof window.Page_IsValid === "undefined" || window.Page_IsValid) {
                            submit.value = "Enviando mensaje...";
                            submit.classList.add("is-sending");
                            submit.setAttribute("aria-busy", "true");
                        }
                    }, 0);
                });
            }

            if (result && result.textContent.trim()) {
                result.setAttribute("role", "status");
                result.setAttribute("aria-live", "polite");
            }
        }());
    </script>
</body>
</html>
