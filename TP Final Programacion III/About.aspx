<%@ Page Title="Acerca de TinyDesk" Language="C#" AutoEventWireup="true" CodeBehind="About.aspx.cs" Inherits="TP_Final_Programacion_III.About" %>

<!DOCTYPE html>

<html lang="es">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta name="theme-color" content="#3f0c0c" />

    <title>Acerca de TinyDesk</title>

    <link href="Content/bootstrap.min.css" rel="stylesheet" />
    <link href="Content/Site.css" rel="stylesheet" />
    <link href="favicon.ico" rel="shortcut icon" type="image/x-icon" />

    <style>
        :root {
            --about-wine: #3f0c0c;
            --about-olive: #48400f;
            --about-blue: #8295d9;
            --about-lavender: #ded3ea;
            --about-cloud: #f3f3f3;
            --about-white: #ffffff;
            --about-ink: #231d23;
            --about-muted: #716b71;
            --about-radius: 30px;
        }

        * {
            box-sizing: border-box;
        }

        html {
            scroll-behavior: smooth;
        }

        body.about-page {
            min-width: 320px;
            margin: 0;
            color: var(--about-ink);
            background: var(--about-cloud);
            font-family: "Segoe UI Variable", "Segoe UI", system-ui, -apple-system, sans-serif;
            overflow-x: hidden;
        }

        .about-page ::selection {
            color: var(--about-wine);
            background: var(--about-lavender);
        }

        .reading-progress {
            position: fixed;
            z-index: 100;
            top: 0;
            left: 0;
            width: 0;
            height: 3px;
            background: linear-gradient(90deg, var(--about-blue), var(--about-wine));
            pointer-events: none;
        }

        .about-nav {
            position: relative;
            z-index: 30;
            border-bottom: 1px solid rgba(63, 12, 12, .08);
            background: rgba(243, 243, 243, .78);
            -webkit-backdrop-filter: blur(18px);
            backdrop-filter: blur(18px);
        }

        .about-nav-inner {
            min-height: 80px;
        }

        .about-brand {
            gap: .7rem;
            color: var(--about-wine) !important;
            letter-spacing: -.035em;
            transition: transform .2s ease;
        }

        .about-brand:hover {
            transform: translateY(-1px);
        }

        .about-logo,
        .about-footer-logo {
            position: relative;
            display: inline-flex;
            flex: 0 0 auto;
            align-items: center;
            justify-content: center;
            overflow: visible;
            background: transparent;
        }

        .about-logo {
            width: 62px;
            height: 62px;
        }

        .about-logo::after {
            position: absolute;
            z-index: 0;
            right: 23%;
            bottom: 4px;
            left: 23%;
            height: 10px;
            border-radius: 50%;
            background: rgba(63, 12, 12, .22);
            content: "";
            filter: blur(5px);
            transform: translateY(8px);
        }

        .about-logo img {
            position: absolute;
            top: 50%;
            left: 50%;
            width: 84px;
            height: 84px;
            max-width: none;
            z-index: 1;
            transform: translate(-50%, -50%);
        }

        .about-brand-name {
            font-size: 1.35rem;
            font-weight: 800;
        }

        .about-back {
            display: inline-flex;
            align-items: center;
            gap: .5rem;
            padding: .68rem 1.05rem;
            color: var(--about-wine) !important;
            border: 1px solid rgba(63, 12, 12, .18);
            border-radius: 999px;
            background: rgba(255, 255, 255, .48);
            font-size: .84rem;
            font-weight: 750;
            transition: color .2s ease, transform .2s ease, background .2s ease, box-shadow .2s ease;
        }

        .about-back:hover,
        .about-back:focus {
            color: var(--about-white) !important;
            background: var(--about-wine);
            box-shadow: 0 10px 25px rgba(63, 12, 12, .18);
            transform: translateY(-2px);
        }

        .about-back svg {
            width: 17px;
            height: 17px;
            transition: transform .2s ease;
        }

        .about-back:hover svg {
            transform: translateX(-3px);
        }

        .about-main {
            flex: 1 0 auto;
        }

        .about-hero {
            position: relative;
            isolation: isolate;
            min-height: min(850px, calc(100vh - 80px));
            display: flex;
            align-items: center;
            padding: clamp(4.5rem, 9vw, 8rem) 0 clamp(5rem, 10vw, 8rem);
            overflow: hidden;
        }

        .about-hero::before {
            position: absolute;
            z-index: -2;
            top: -18rem;
            right: -14rem;
            width: 46rem;
            height: 46rem;
            border-radius: 50%;
            background: radial-gradient(circle, rgba(222, 211, 234, .9), rgba(130, 149, 217, .08) 55%, transparent 70%);
            content: "";
        }

        .about-hero::after {
            position: absolute;
            z-index: -2;
            bottom: -12rem;
            left: -9rem;
            width: 30rem;
            height: 30rem;
            border: 1px solid rgba(72, 64, 15, .15);
            border-radius: 50%;
            box-shadow: inset 0 0 0 5rem rgba(72, 64, 15, .025);
            content: "";
        }

        .hero-copy {
            position: relative;
            z-index: 3;
            max-width: 680px;
        }

        .about-eyebrow,
        .section-kicker {
            display: inline-flex;
            align-items: center;
            gap: .55rem;
            color: var(--about-wine);
            font-size: .73rem;
            font-weight: 850;
            letter-spacing: .14em;
            text-transform: uppercase;
        }

        .about-eyebrow {
            padding: .6rem .85rem;
            border: 1px solid rgba(63, 12, 12, .1);
            border-radius: 999px;
            background: rgba(255, 255, 255, .54);
        }

        .about-eyebrow::before {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background: var(--about-blue);
            content: "";
            box-shadow: 0 0 0 5px rgba(130, 149, 217, .16);
        }

        .hero-title {
            max-width: 10ch;
            margin: 1.45rem 0 1.35rem;
            color: var(--about-wine);
            font-size: clamp(3.55rem, 7vw, 7.15rem);
            font-weight: 820;
            line-height: .89;
            letter-spacing: -.072em;
        }

        .hero-title-accent {
            position: relative;
            display: inline-block;
            color: var(--about-olive);
        }

        .hero-title-accent::after {
            position: absolute;
            z-index: -1;
            right: -.06em;
            bottom: -.02em;
            left: -.04em;
            height: .25em;
            border-radius: 999px;
            background: var(--about-lavender);
            content: "";
            transform: rotate(-1deg);
        }

        .hero-lead {
            max-width: 56ch;
            margin: 0;
            color: var(--about-muted);
            font-size: clamp(1rem, 1.55vw, 1.2rem);
            line-height: 1.75;
        }

        .hero-actions {
            display: flex;
            flex-wrap: wrap;
            gap: .8rem;
            margin-top: 2rem;
        }

        .hero-primary,
        .hero-secondary {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: .6rem;
            min-height: 50px;
            padding: .75rem 1.15rem;
            border-radius: 15px;
            font-size: .82rem;
            font-weight: 760;
            text-decoration: none;
            transition: transform .22s ease, box-shadow .22s ease, background .22s ease;
        }

        .hero-primary {
            color: var(--about-white);
            background: var(--about-wine);
            box-shadow: 0 14px 30px rgba(63, 12, 12, .18);
        }

        .hero-primary:hover,
        .hero-primary:focus {
            color: var(--about-white);
            background: #551515;
            box-shadow: 0 18px 34px rgba(63, 12, 12, .23);
            transform: translateY(-2px);
        }

        .hero-secondary {
            color: var(--about-wine);
            border: 1px solid rgba(63, 12, 12, .14);
            background: rgba(255, 255, 255, .52);
        }

        .hero-secondary:hover,
        .hero-secondary:focus {
            color: var(--about-wine);
            background: var(--about-white);
            transform: translateY(-2px);
        }

        .hero-primary svg,
        .hero-secondary svg {
            width: 17px;
            height: 17px;
        }

        .hero-modules {
            display: flex;
            flex-wrap: wrap;
            gap: .55rem;
            margin-top: 2.2rem;
        }

        .hero-module {
            display: inline-flex;
            align-items: center;
            gap: .42rem;
            color: var(--about-muted);
            font-size: .72rem;
            font-weight: 650;
        }

        .hero-module:not(:last-child)::after {
            width: 4px;
            height: 4px;
            margin-left: .15rem;
            border-radius: 50%;
            background: var(--about-blue);
            content: "";
        }

        .hero-visual-column {
            position: relative;
            display: grid;
            min-height: 560px;
            place-items: center;
        }

        .product-stage {
            position: relative;
            z-index: 2;
            width: min(112%, 690px);
            height: 510px;
        }

        .stage-orbit {
            position: absolute;
            z-index: -1;
            inset: 4% 1%;
            border: 1px solid rgba(130, 149, 217, .32);
            border-radius: 50%;
            transform: rotate(-12deg);
        }

        .stage-orbit::before,
        .stage-orbit::after {
            position: absolute;
            border-radius: 50%;
            content: "";
        }

        .stage-orbit::before {
            top: 10%;
            left: 8%;
            width: 15px;
            height: 15px;
            background: var(--about-blue);
            box-shadow: 0 0 0 8px rgba(130, 149, 217, .14);
        }

        .stage-orbit::after {
            right: 5%;
            bottom: 13%;
            width: 11px;
            height: 11px;
            background: var(--about-olive);
            box-shadow: 0 0 0 7px rgba(72, 64, 15, .1);
        }

        .dashboard-window {
            position: absolute;
            top: 54px;
            right: 8px;
            bottom: 28px;
            left: 8px;
            overflow: hidden;
            border: 1px solid rgba(63, 12, 12, .11);
            border-radius: 26px;
            background: var(--about-white);
            box-shadow: 0 34px 72px rgba(63, 12, 12, .15);
            text-rendering: optimizeLegibility;
            -webkit-font-smoothing: antialiased;
        }

        .dashboard-topbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            height: 58px;
            padding: 0 1.25rem;
            border-bottom: 1px solid rgba(63, 12, 12, .07);
            background: rgba(243, 243, 243, .72);
        }

        .window-dots {
            display: flex;
            gap: 6px;
        }

        .window-dots i {
            display: block;
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background: var(--about-lavender);
        }

        .window-dots i:nth-child(2) { background: var(--about-blue); }
        .window-dots i:nth-child(3) { background: var(--about-olive); }

        .dashboard-brand {
            display: flex;
            align-items: center;
            gap: .45rem;
            color: var(--about-wine);
            font-size: .76rem;
            font-weight: 800;
        }

        .dashboard-brand-logo {
            position: relative;
            display: inline-flex;
            width: 27px;
            height: 27px;
            flex: 0 0 27px;
            align-items: center;
            justify-content: center;
            overflow: visible;
            background: transparent;
        }

        .dashboard-brand-logo::after {
            position: absolute;
            z-index: 0;
            right: 22%;
            bottom: 1px;
            left: 22%;
            height: 4px;
            border-radius: 50%;
            background: rgba(63, 12, 12, .22);
            content: "";
            filter: blur(2px);
            transform: translateY(4px);
        }

        .dashboard-brand-logo img {
            position: absolute;
            top: 50%;
            left: 50%;
            width: 38px;
            height: 38px;
            max-width: none;
            z-index: 1;
            transform: translate(-50%, -50%);
        }

        .dashboard-avatar {
            display: grid;
            width: 31px;
            height: 31px;
            place-items: center;
            color: var(--about-white);
            border-radius: 9px;
            background: var(--about-blue);
            font-size: .66rem;
            font-weight: 800;
        }

        .dashboard-body {
            display: grid;
            grid-template-columns: 82px 1fr;
            min-height: 100%;
        }

        .dashboard-side {
            padding: 1.15rem .8rem;
            background: var(--about-wine);
        }

        .side-logo,
        .side-line {
            border-radius: 999px;
            background: rgba(255, 255, 255, .18);
        }

        .side-logo {
            width: 30px;
            height: 30px;
            margin: 0 auto 1.2rem;
            border-radius: 10px;
            background: var(--about-lavender);
        }

        .side-line {
            width: 100%;
            height: 6px;
            margin-bottom: .75rem;
        }

        .side-line.is-active {
            background: var(--about-blue);
        }

        .dashboard-content {
            padding: 1.45rem 1.55rem;
            background: linear-gradient(145deg, #ffffff, #f7f5f8);
        }

        .dash-heading {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.25rem;
        }

        .dash-heading-title {
            color: var(--about-wine);
            font-size: 1.02rem;
            font-weight: 820;
        }

        .dash-heading-chip {
            padding: .4rem .65rem;
            color: var(--about-olive);
            border-radius: 7px;
            background: rgba(222, 211, 234, .7);
            font-size: .62rem;
            font-weight: 800;
        }

        .dashboard-columns {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: .75rem;
        }

        .dash-column {
            min-height: 205px;
            padding: .75rem;
            border: 1px solid rgba(63, 12, 12, .06);
            border-radius: 12px;
            background: rgba(243, 243, 243, .65);
        }

        .dash-column-title {
            display: flex;
            align-items: center;
            gap: .3rem;
            margin-bottom: .6rem;
            color: var(--about-muted);
            font-size: .6rem;
            font-weight: 820;
            text-transform: uppercase;
        }

        .dash-column-title::before {
            width: 5px;
            height: 5px;
            border-radius: 50%;
            background: var(--about-blue);
            content: "";
        }

        .dash-column:nth-child(2) .dash-column-title::before { background: var(--about-olive); }
        .dash-column:nth-child(3) .dash-column-title::before { background: var(--about-wine); }

        .task-card {
            margin-bottom: .6rem;
            padding: .68rem;
            border-radius: 9px;
            background: var(--about-white);
            box-shadow: 0 5px 14px rgba(63, 12, 12, .06);
        }

        .task-card strong {
            display: block;
            margin-bottom: .42rem;
            color: var(--about-wine);
            font-size: .62rem;
        }

        .task-progress {
            display: block;
            width: 100%;
            height: 4px;
            overflow: hidden;
            border-radius: 99px;
            background: var(--about-cloud);
        }

        .task-progress::after {
            display: block;
            width: 58%;
            height: 100%;
            border-radius: inherit;
            background: var(--about-blue);
            content: "";
        }

        .task-card:nth-child(3) .task-progress::after {
            width: 82%;
            background: var(--about-olive);
        }

        .stage-chip {
            position: absolute;
            z-index: 6;
            display: flex;
            align-items: center;
            gap: .65rem;
            padding: .7rem .9rem;
            border: 1px solid rgba(63, 12, 12, .08);
            border-radius: 15px;
            background: rgba(255, 255, 255, .91);
            box-shadow: 0 16px 30px rgba(63, 12, 12, .12);
            font-size: .75rem;
            font-weight: 760;
        }

        .stage-chip-icon {
            display: grid;
            width: 31px;
            height: 31px;
            place-items: center;
            color: var(--about-white);
            border-radius: 10px;
            background: var(--about-blue);
        }

        .stage-chip-icon svg {
            width: 15px;
            height: 15px;
        }

        .stage-chip-one {
            top: 18px;
            left: 5px;
            color: var(--about-wine);
            animation: stage-float 4.8s ease-in-out infinite;
        }

        .stage-chip-two {
            right: 0;
            bottom: 8px;
            color: var(--about-olive);
            animation: stage-float 5.4s .7s ease-in-out infinite reverse;
        }

        .stage-chip-two .stage-chip-icon {
            background: var(--about-olive);
        }

        .story-section {
            position: relative;
            padding: clamp(5rem, 9vw, 8.5rem) 0;
            background: var(--about-white);
        }

        .section-heading {
            max-width: 760px;
            margin-bottom: clamp(2.5rem, 5vw, 4rem);
        }

        .section-title {
            margin: .8rem 0 0;
            color: var(--about-wine);
            font-size: clamp(2.15rem, 4.4vw, 4.2rem);
            font-weight: 810;
            line-height: 1.02;
            letter-spacing: -.055em;
        }

        .section-subtitle {
            max-width: 54ch;
            margin: 1rem 0 0;
            color: var(--about-muted);
            line-height: 1.7;
        }

        .story-card {
            position: relative;
            display: flex;
            min-height: 370px;
            flex-direction: column;
            overflow: hidden;
            padding: clamp(2rem, 4vw, 3.25rem);
            border-radius: var(--about-radius);
            transition: transform .35s cubic-bezier(.2, .8, .2, 1), box-shadow .35s ease;
        }

        .mission-card {
            color: var(--about-white);
            background: var(--about-wine);
            box-shadow: 0 26px 55px rgba(63, 12, 12, .2);
        }

        .vision-card {
            color: var(--about-wine);
            border: 1px solid rgba(63, 12, 12, .08);
            background: linear-gradient(145deg, var(--about-lavender), #e9e2ef);
            box-shadow: 0 22px 48px rgba(63, 12, 12, .08);
        }

        .story-card:hover {
            transform: translateY(-7px);
        }

        .mission-card:hover {
            box-shadow: 0 32px 65px rgba(63, 12, 12, .25);
        }

        .vision-card:hover {
            box-shadow: 0 30px 58px rgba(63, 12, 12, .13);
        }

        .story-meta {
            position: relative;
            z-index: 2;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .story-index {
            display: inline-grid;
            width: 48px;
            height: 48px;
            place-items: center;
            border: 1px solid currentColor;
            border-radius: 15px;
            font-size: .76rem;
            font-weight: 800;
            opacity: .72;
        }

        .story-caption {
            font-size: .66rem;
            font-weight: 820;
            letter-spacing: .13em;
            text-transform: uppercase;
            opacity: .58;
        }

        .story-content {
            position: relative;
            z-index: 2;
            margin-top: clamp(2.15rem, 3vw, 3rem);
        }

        .story-card h2 {
            max-width: 9ch;
            margin: 0 0 1rem;
            font-size: clamp(2rem, 4vw, 3.4rem);
            font-weight: 810;
            line-height: 1;
            letter-spacing: -.05em;
        }

        .story-card p {
            max-width: 45ch;
            margin: 0;
            font-size: 1rem;
            line-height: 1.72;
            opacity: .8;
        }

        .story-shape {
            position: absolute;
            right: -4rem;
            bottom: -5rem;
            width: 15rem;
            height: 15rem;
            border: 1px solid currentColor;
            border-radius: 50%;
            opacity: .12;
            transition: transform .7s cubic-bezier(.2, .8, .2, 1);
        }

        .story-shape::after {
            position: absolute;
            inset: 2.6rem;
            border: 1px solid currentColor;
            border-radius: 50%;
            content: "";
        }

        .story-card:hover .story-shape {
            transform: translate(-1rem, -1rem) rotate(20deg) scale(1.08);
        }

        .ecosystem-section {
            position: relative;
            padding: clamp(5rem, 9vw, 8.5rem) 0;
            background:
                radial-gradient(circle at 92% 10%, rgba(130, 149, 217, .17), transparent 23rem),
                var(--about-cloud);
        }

        .feature-card {
            position: relative;
            height: 100%;
            min-height: 285px;
            overflow: hidden;
            padding: 1.5rem;
            border: 1px solid rgba(63, 12, 12, .08);
            border-radius: 24px;
            background: rgba(255, 255, 255, .78);
            box-shadow: 0 16px 40px rgba(63, 12, 12, .055);
            transition: transform .3s cubic-bezier(.2, .8, .2, 1), box-shadow .3s ease, border-color .3s ease;
            -webkit-backdrop-filter: blur(10px);
            backdrop-filter: blur(10px);
        }

        .feature-card:hover {
            z-index: 2;
            border-color: rgba(130, 149, 217, .5);
            box-shadow: 0 24px 50px rgba(63, 12, 12, .11);
            transform: translateY(-9px) rotate(-.6deg);
        }

        .feature-icon {
            display: grid;
            width: 52px;
            height: 52px;
            margin-bottom: 3.8rem;
            place-items: center;
            color: var(--about-wine);
            border-radius: 17px;
            background: var(--about-lavender);
            transition: transform .3s ease;
        }

        .feature-card:hover .feature-icon {
            transform: rotate(-7deg) scale(1.06);
        }

        .feature-icon svg {
            width: 24px;
            height: 24px;
        }

        .ecosystem-section .row > div:nth-child(2) .feature-icon { color: var(--about-white); background: var(--about-blue); }
        .ecosystem-section .row > div:nth-child(3) .feature-icon { color: var(--about-white); background: var(--about-olive); }
        .ecosystem-section .row > div:nth-child(4) .feature-icon { color: var(--about-white); background: var(--about-wine); }

        .feature-number {
            position: absolute;
            top: 1.45rem;
            right: 1.45rem;
            color: var(--about-muted);
            font-size: .65rem;
            font-weight: 800;
            opacity: .55;
        }

        .feature-card h3 {
            margin-bottom: .65rem;
            color: var(--about-wine);
            font-size: 1.2rem;
            font-weight: 800;
            letter-spacing: -.03em;
        }

        .feature-card p {
            margin: 0;
            color: var(--about-muted);
            font-size: .83rem;
            line-height: 1.65;
        }

        .workflow {
            --workflow-progress: 0%;
            position: relative;
            margin-top: clamp(3rem, 6vw, 5rem);
            padding: clamp(1rem, 2vw, 1.4rem);
            border: 1px solid rgba(63, 12, 12, .08);
            border-radius: 28px;
            background: rgba(255, 255, 255, .62);
            box-shadow: 0 18px 42px rgba(63, 12, 12, .05);
        }

        .workflow-line {
            position: absolute;
            z-index: 1;
            top: 50%;
            right: 13.5%;
            left: 13.5%;
            height: 3px;
            overflow: hidden;
            border-radius: 999px;
            background: rgba(130, 149, 217, .2);
            transform: translateY(-50%);
        }

        .workflow-line span {
            display: block;
            width: var(--workflow-progress);
            height: 100%;
            border-radius: inherit;
            background: linear-gradient(90deg, var(--about-blue), var(--about-olive));
            transition: width .65s cubic-bezier(.2, .8, .2, 1);
        }

        .workflow-step {
            position: relative;
            z-index: 2;
            display: flex;
            min-height: 152px;
            flex-direction: column;
            justify-content: space-between;
            padding: 1.35rem;
            overflow: hidden;
            color: var(--about-wine);
            border: 1px solid rgba(63, 12, 12, .07);
            border-radius: 21px;
            background: var(--about-white);
            box-shadow: 0 8px 20px rgba(63, 12, 12, .05);
            cursor: default;
            transition: transform .35s cubic-bezier(.2, .8, .2, 1), border-color .3s ease, box-shadow .3s ease, background .3s ease;
        }

        .workflow-step::after {
            position: absolute;
            top: -34px;
            right: -34px;
            width: 92px;
            height: 92px;
            border-radius: 50%;
            background: var(--about-lavender);
            content: "";
            opacity: .32;
            transform: scale(.75);
            transition: transform .45s ease, opacity .35s ease;
        }

        .workflow-number {
            display: grid;
            width: 48px;
            height: 48px;
            margin-bottom: 1.3rem;
            place-items: center;
            color: var(--about-blue);
            border: 1px solid rgba(130, 149, 217, .3);
            border-radius: 15px;
            background: rgba(222, 211, 234, .35);
            font-size: .84rem;
            font-weight: 850;
            letter-spacing: .08em;
            transition: color .3s ease, background .3s ease, border-color .3s ease, transform .35s ease;
        }

        .workflow-copy {
            position: relative;
            z-index: 2;
        }

        .workflow-step strong {
            display: block;
            margin-bottom: .32rem;
            color: var(--about-wine);
            font-size: 1.08rem;
            letter-spacing: -.025em;
        }

        .workflow-step small {
            display: block;
            color: var(--about-muted);
            font-size: .76rem;
            line-height: 1.45;
        }

        .workflow-step:hover,
        .workflow-step:focus-visible,
        .workflow-step.is-active {
            border-color: rgba(130, 149, 217, .58);
            outline: 0;
            background: linear-gradient(145deg, var(--about-white), #f4f1f8);
            box-shadow: 0 20px 38px rgba(63, 12, 12, .11);
            transform: translateY(-7px);
        }

        .workflow-step:hover::after,
        .workflow-step:focus-visible::after,
        .workflow-step.is-active::after {
            opacity: .7;
            transform: scale(1.15);
        }

        .workflow-step:hover .workflow-number,
        .workflow-step:focus-visible .workflow-number,
        .workflow-step.is-active .workflow-number {
            color: var(--about-white);
            border-color: var(--about-wine);
            background: var(--about-wine);
            transform: rotate(-4deg) scale(1.05);
        }

        .values-section {
            position: relative;
            isolation: isolate;
            padding: clamp(4.5rem, 8vw, 7rem) 0;
            overflow: hidden;
            color: var(--about-wine);
            border-top: 1px solid rgba(63, 12, 12, .08);
            border-bottom: 1px solid rgba(63, 12, 12, .08);
            background:
                radial-gradient(circle at 8% 100%, rgba(130, 149, 217, .34), transparent 26rem),
                radial-gradient(circle at 94% 0%, rgba(255, 255, 255, .68), transparent 22rem),
                var(--about-lavender);
        }

        .values-section::before {
            position: absolute;
            z-index: -1;
            top: -10rem;
            right: 15%;
            width: 24rem;
            height: 24rem;
            border: 1px solid rgba(63, 12, 12, .09);
            border-radius: 50%;
            box-shadow: inset 0 0 0 4rem rgba(255, 255, 255, .08);
            content: "";
        }

        .values-panel {
            display: grid;
            grid-template-columns: .85fr 1.15fr;
            gap: clamp(2rem, 6vw, 6rem);
            align-items: center;
        }

        .values-section .section-kicker {
            color: var(--about-olive);
        }

        .values-title {
            max-width: 9ch;
            margin: .8rem 0 0;
            font-size: clamp(2.3rem, 5vw, 4.7rem);
            font-weight: 810;
            line-height: .98;
            letter-spacing: -.055em;
        }

        .values-title span {
            color: var(--about-olive);
        }

        .values-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: .8rem;
        }

        .value-pill {
            position: relative;
            min-height: 126px;
            overflow: hidden;
            padding: 1.25rem;
            color: var(--about-wine);
            border: 1px solid rgba(63, 12, 12, .1);
            border-radius: 20px;
            background: rgba(255, 255, 255, .47);
            box-shadow: 0 14px 30px rgba(63, 12, 12, .055);
            transition: background .25s ease, transform .25s ease, border-color .25s ease, box-shadow .25s ease;
        }

        .value-pill:hover {
            border-color: rgba(130, 149, 217, .58);
            background: rgba(255, 255, 255, .8);
            box-shadow: 0 19px 36px rgba(63, 12, 12, .09);
            transform: translateY(-4px);
        }

        .value-pill span {
            display: block;
            margin-bottom: 1.35rem;
            color: var(--about-blue);
            font-size: .62rem;
            font-weight: 850;
        }

        .value-pill strong {
            font-size: 1rem;
            letter-spacing: -.02em;
        }

        .about-footer {
            border-top: 1px solid rgba(63, 12, 12, .09);
            background: rgba(255, 255, 255, .62);
        }

        .about-footer-inner {
            min-height: 72px;
        }

        .about-footer-logo {
            width: 32px;
            height: 32px;
        }

        .about-footer-logo img {
            position: absolute;
            top: 50%;
            left: 50%;
            width: 46px;
            height: 46px;
            max-width: none;
            filter: drop-shadow(0 5px 5px rgba(9, 35, 47, .18));
            transform: translate(-50%, -50%);
        }

        .about-footer-copy,
        .about-footer-link {
            color: #75797e !important;
            font-size: .75rem;
        }

        .about-footer-link {
            transition: color .2s ease;
        }

        .about-footer-link:hover,
        .about-footer-link:focus,
        .about-footer-link.is-active {
            color: #09232f !important;
        }

        .reveal-ready [data-reveal] {
            opacity: 0;
            transform: translateY(28px);
            transition: opacity .75s ease, transform .75s cubic-bezier(.2, .8, .2, 1);
        }

        .reveal-ready [data-reveal="left"] {
            transform: translateX(-28px);
        }

        .reveal-ready [data-reveal="right"] {
            transform: translateX(28px);
        }

        .reveal-ready [data-reveal].is-visible {
            opacity: 1;
            transform: translate(0, 0);
        }

        @keyframes stage-float {
            0%, 100% { margin-top: 0; }
            50% { margin-top: -13px; }
        }

        @keyframes hero-enter {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .hero-copy > * {
            animation: hero-enter .7s cubic-bezier(.2, .8, .2, 1) both;
        }

        .hero-copy > *:nth-child(2) { animation-delay: .08s; }
        .hero-copy > *:nth-child(3) { animation-delay: .15s; }
        .hero-copy > *:nth-child(4) { animation-delay: .22s; }
        .hero-copy > *:nth-child(5) { animation-delay: .28s; }

        @media (max-width: 991.98px) {
            .about-hero {
                min-height: auto;
                padding-bottom: 4rem;
            }

            .hero-copy {
                max-width: 760px;
                margin: 0 auto;
                text-align: center;
            }

            .hero-title {
                max-width: 11ch;
                margin-right: auto;
                margin-left: auto;
            }

            .hero-lead {
                margin-right: auto;
                margin-left: auto;
            }

            .hero-actions,
            .hero-modules {
                justify-content: center;
            }

            .hero-visual-column {
                min-height: 540px;
                margin-top: 2rem;
            }

            .product-stage {
                width: min(96%, 680px);
            }

            .values-panel {
                grid-template-columns: 1fr;
            }

            .workflow-line {
                display: none;
            }

            .values-title {
                max-width: 12ch;
            }
        }

        @media (max-width: 575.98px) {
            .about-nav-inner {
                min-height: 68px;
            }

            .about-logo {
                width: 54px;
                height: 54px;
            }

            .about-brand-name {
                font-size: 1.15rem;
            }

            .about-back {
                padding: .6rem .75rem;
            }

            .about-back-text {
                display: none;
            }

            .about-hero {
                padding-top: 3.5rem;
            }

            .hero-title {
                font-size: clamp(3.25rem, 17vw, 4.6rem);
            }

            .hero-actions {
                flex-direction: column;
            }

            .hero-primary,
            .hero-secondary {
                width: 100%;
            }

            .hero-modules {
                gap: .75rem;
            }

            .hero-module:not(:last-child)::after {
                display: none;
            }

            .hero-visual-column {
                min-height: 390px;
                margin-top: 1rem;
            }

            .product-stage {
                width: 108%;
                height: 360px;
            }

            .dashboard-window {
                top: 50px;
                right: 14px;
                bottom: 28px;
                left: 14px;
            }

            .dashboard-body {
                grid-template-columns: 48px 1fr;
            }

            .dashboard-side {
                padding-right: .45rem;
                padding-left: .45rem;
            }

            .dashboard-content {
                padding: .85rem;
            }

            .dash-column {
                min-height: 135px;
                padding: .4rem;
            }

            .task-card {
                padding: .4rem;
            }

            .stage-chip {
                padding: .55rem .65rem;
                font-size: .58rem;
            }

            .stage-chip-icon {
                width: 26px;
                height: 26px;
            }

            .story-card {
                min-height: 310px;
            }

            .values-grid {
                grid-template-columns: 1fr;
            }

            .about-footer-inner {
                padding-top: 1rem;
                padding-bottom: 1rem;
            }
        }

        @media (prefers-reduced-motion: reduce) {
            html { scroll-behavior: auto; }
            *, *::before, *::after {
                scroll-behavior: auto !important;
                animation-duration: .01ms !important;
                animation-iteration-count: 1 !important;
                transition-duration: .01ms !important;
            }
        }
    </style>
</head>

<body class="about-page">
    <div id="readingProgress" class="reading-progress" aria-hidden="true"></div>

    <form id="form1" runat="server" class="min-vh-100 d-flex flex-column">

        <header class="about-nav">
            <div class="container about-nav-inner d-flex justify-content-between align-items-center">

                <asp:LinkButton ID="btnInicio"
                    runat="server"
                    CausesValidation="false"
                    OnClick="btnInicio_Click"
                    CssClass="about-brand d-inline-flex align-items-center text-decoration-none">

                    <span class="about-logo" aria-hidden="true">
                        <img src="Images/LogoTD.png" alt="" />
                    </span>
                    <span class="about-brand-name">TinyDesk</span>

                </asp:LinkButton>

                <asp:LinkButton ID="btnVolver"
                    runat="server"
                    CausesValidation="false"
                    OnClick="btnInicio_Click"
                    CssClass="about-back btn text-decoration-none">

                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
                        <path d="M19 12H5M12 19l-7-7 7-7" />
                    </svg>
                    <span class="about-back-text">Volver a TinyDesk</span>

                </asp:LinkButton>

            </div>
        </header>

        <main class="about-main">
            <section class="about-hero" aria-labelledby="aboutTitle">
                <div class="container">
                    <div class="row align-items-center g-5">
                        <div class="col-lg-6">
                            <div class="hero-copy">
                                <span class="about-eyebrow">Gestión de trabajo</span>

                                <h1 id="aboutTitle" class="hero-title">
                                    Trabajo claro. <span class="hero-title-accent">Equipos alineados.</span>
                                </h1>

                                <p class="hero-lead">
                                    TinyDesk es una plataforma para organizar proyectos, planificar sprints, administrar tickets y conectar el trabajo de todas las personas de una organización.
                                </p>

                                <div class="hero-actions">
                                    <a class="hero-primary" href="#ecosistema">
                                        Explorar la plataforma
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
                                            <path d="M5 12h14M13 6l6 6-6 6" />
                                        </svg>
                                    </a>
                                    <a class="hero-secondary" href="#historia">
                                        Nuestra esencia
                                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true">
                                            <path d="m7 10 5 5 5-5" />
                                        </svg>
                                    </a>
                                </div>

                                <div class="hero-modules" aria-label="Módulos de TinyDesk">
                                    <span class="hero-module">Proyectos</span>
                                    <span class="hero-module">Sprints</span>
                                    <span class="hero-module">Tickets</span>
                                    <span class="hero-module">Equipos</span>
                                </div>
                            </div>
                        </div>

                        <div class="col-lg-6">
                            <div class="hero-visual-column" aria-hidden="true">
                                <div id="productStage" class="product-stage">
                                    <span class="stage-orbit"></span>

                                    <div class="dashboard-window">
                                        <div class="dashboard-topbar">
                                            <span class="window-dots"><i></i><i></i><i></i></span>
                                            <span class="dashboard-brand">
                                                <span class="dashboard-brand-logo">
                                                    <img src="Images/LogoTD.png" alt="" />
                                                </span>
                                                TinyDesk
                                            </span>
                                            <span class="dashboard-avatar">TD</span>
                                        </div>

                                        <div class="dashboard-body">
                                            <aside class="dashboard-side">
                                                <span class="side-logo"></span>
                                                <span class="side-line is-active"></span>
                                                <span class="side-line"></span>
                                                <span class="side-line"></span>
                                                <span class="side-line"></span>
                                            </aside>

                                            <div class="dashboard-content">
                                                <div class="dash-heading">
                                                    <span class="dash-heading-title">Sprint actual</span>
                                                    <span class="dash-heading-chip">En progreso</span>
                                                </div>

                                                <div class="dashboard-columns">
                                                    <div class="dash-column">
                                                        <div class="dash-column-title">Por hacer</div>
                                                        <div class="task-card">
                                                            <strong>Definir alcance</strong>
                                                            <span class="task-progress"></span>
                                                        </div>
                                                        <div class="task-card">
                                                            <strong>Revisar flujo</strong>
                                                            <span class="task-progress"></span>
                                                        </div>
                                                    </div>

                                                    <div class="dash-column">
                                                        <div class="dash-column-title">En curso</div>
                                                        <div class="task-card">
                                                            <strong>Diseñar interfaz</strong>
                                                            <span class="task-progress"></span>
                                                        </div>
                                                    </div>

                                                    <div class="dash-column">
                                                        <div class="dash-column-title">Listo</div>
                                                        <div class="task-card">
                                                            <strong>Crear proyecto</strong>
                                                            <span class="task-progress"></span>
                                                        </div>
                                                        <div class="task-card">
                                                            <strong>Asignar equipo</strong>
                                                            <span class="task-progress"></span>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="stage-chip stage-chip-one">
                                        <span class="stage-chip-icon">
                                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                <path d="M4 19V9M10 19V5M16 19v-7M22 19H2" />
                                            </svg>
                                        </span>
                                        Avance visible
                                    </div>

                                    <div class="stage-chip stage-chip-two">
                                        <span class="stage-chip-icon">
                                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                                <circle cx="9" cy="8" r="3" />
                                                <circle cx="17" cy="10" r="2" />
                                                <path d="M3 20a6 6 0 0 1 12 0M14 16a5 5 0 0 1 7 4" />
                                            </svg>
                                        </span>
                                        Equipo conectado
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <section id="historia" class="story-section" aria-labelledby="storyTitle">
                <div class="container">
                    <header class="section-heading" data-reveal>
                        <span class="section-kicker">El porqué de TinyDesk</span>
                        <h2 id="storyTitle" class="section-title">Convertir objetivos en avances que todos puedan ver.</h2>
                    </header>

                    <div class="row g-4">
                        <div class="col-12 col-lg-6" data-reveal="left">
                            <article class="story-card mission-card h-100">
                                <div class="story-meta">
                                    <span class="story-index">01</span>
                                    <span class="story-caption">Propósito</span>
                                </div>

                                <div class="story-content">
                                    <h2>Nuestra misión</h2>
                                    <p>
                                        Simplificar la coordinación del trabajo para que los equipos conviertan sus objetivos en avances claros, visibles y medibles.
                                    </p>
                                </div>

                                <span class="story-shape" aria-hidden="true"></span>
                            </article>
                        </div>

                        <div class="col-12 col-lg-6" data-reveal="right">
                            <article class="story-card vision-card h-100">
                                <div class="story-meta">
                                    <span class="story-index">02</span>
                                    <span class="story-caption">Futuro</span>
                                </div>

                                <div class="story-content">
                                    <h2>Nuestra visión</h2>
                                    <p>
                                        Ser una plataforma accesible y confiable que acompañe a las organizaciones desde sus primeros proyectos hasta una operación colaborativa y escalable.
                                    </p>
                                </div>

                                <span class="story-shape" aria-hidden="true"></span>
                            </article>
                        </div>
                    </div>
                </div>
            </section>

            <section id="ecosistema" class="ecosystem-section" aria-labelledby="ecosystemTitle">
                <div class="container">
                    <header class="section-heading" data-reveal>
                        <span class="section-kicker">Un ecosistema conectado</span>
                        <h2 id="ecosystemTitle" class="section-title">Todo el trabajo en un solo lugar.</h2>
                        <p class="section-subtitle">
                            Cada módulo comparte el mismo contexto para que planificar, ejecutar y hacer seguimiento se sienta como un único flujo.
                        </p>
                    </header>

                    <div class="row g-3">
                        <div class="col-sm-6 col-xl-3" data-reveal>
                            <article class="feature-card">
                                <span class="feature-number">01</span>
                                <span class="feature-icon">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" aria-hidden="true">
                                        <path d="M4 5h6l2 2h8v12H4V5Z" />
                                        <path d="M8 12h8M8 15h5" />
                                    </svg>
                                </span>
                                <h3>Proyectos</h3>
                                <p>Objetivos, equipos, fechas y seguimiento con una mirada compartida.</p>
                            </article>
                        </div>

                        <div class="col-sm-6 col-xl-3" data-reveal>
                            <article class="feature-card">
                                <span class="feature-number">02</span>
                                <span class="feature-icon">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" aria-hidden="true">
                                        <path d="M4 7h16M7 3v4M17 3v4M5 5h14v15H5V5Z" />
                                        <path d="m9 14 2 2 4-5" />
                                    </svg>
                                </span>
                                <h3>Sprints</h3>
                                <p>Planificación del trabajo en ciclos concretos, ordenados y alcanzables.</p>
                            </article>
                        </div>

                        <div class="col-sm-6 col-xl-3" data-reveal>
                            <article class="feature-card">
                                <span class="feature-number">03</span>
                                <span class="feature-icon">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" aria-hidden="true">
                                        <path d="M5 4h14v16H5V4Z" />
                                        <path d="M8 9h8M8 13h8M8 17h5" />
                                    </svg>
                                </span>
                                <h3>Tickets</h3>
                                <p>Prioridades, responsables, estados y entregas siempre a la vista.</p>
                            </article>
                        </div>

                        <div class="col-sm-6 col-xl-3" data-reveal>
                            <article class="feature-card">
                                <span class="feature-number">04</span>
                                <span class="feature-icon">
                                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" aria-hidden="true">
                                        <circle cx="9" cy="8" r="3" />
                                        <circle cx="17" cy="10" r="2" />
                                        <path d="M3 20a6 6 0 0 1 12 0M14 16a5 5 0 0 1 7 4" />
                                    </svg>
                                </span>
                                <h3>Equipos</h3>
                                <p>Empresas, áreas, puestos y permisos conectados con el trabajo real.</p>
                            </article>
                        </div>
                    </div>

                    <div id="workflow" class="workflow" data-reveal aria-label="Flujo de trabajo de TinyDesk">
                        <span class="workflow-line" aria-hidden="true"><span></span></span>

                        <div class="row g-3 position-relative">
                            <div class="col-12 col-sm-6 col-lg-3">
                                <article class="workflow-step is-active h-100" data-workflow-step tabindex="0" aria-current="step">
                                    <span class="workflow-number">01</span>
                                    <span class="workflow-copy">
                                        <strong>Proyecto</strong>
                                        <small>Define el objetivo compartido.</small>
                                    </span>
                                </article>
                            </div>

                            <div class="col-12 col-sm-6 col-lg-3">
                                <article class="workflow-step h-100" data-workflow-step tabindex="0">
                                    <span class="workflow-number">02</span>
                                    <span class="workflow-copy">
                                        <strong>Sprint</strong>
                                        <small>Ordena el próximo ciclo.</small>
                                    </span>
                                </article>
                            </div>

                            <div class="col-12 col-sm-6 col-lg-3">
                                <article class="workflow-step h-100" data-workflow-step tabindex="0">
                                    <span class="workflow-number">03</span>
                                    <span class="workflow-copy">
                                        <strong>Ticket</strong>
                                        <small>Convierte el plan en acción.</small>
                                    </span>
                                </article>
                            </div>

                            <div class="col-12 col-sm-6 col-lg-3">
                                <article class="workflow-step h-100" data-workflow-step tabindex="0">
                                    <span class="workflow-number">04</span>
                                    <span class="workflow-copy">
                                        <strong>Avance</strong>
                                        <small>Hace visible el resultado.</small>
                                    </span>
                                </article>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <section id="valores" class="values-section" aria-labelledby="valuesTitle">
                <div class="container">
                    <div class="values-panel">
                        <header data-reveal="left">
                            <span class="section-kicker">Lo que nos guía</span>
                            <h2 id="valuesTitle" class="values-title">Valores que se vuelven <span>producto.</span></h2>
                        </header>

                        <div class="values-grid" data-reveal="right">
                            <div class="value-pill"><span>01</span><strong>Claridad</strong></div>
                            <div class="value-pill"><span>02</span><strong>Colaboración</strong></div>
                            <div class="value-pill"><span>03</span><strong>Responsabilidad</strong></div>
                            <div class="value-pill"><span>04</span><strong>Mejora continua</strong></div>
                        </div>
                    </div>
                </div>
            </section>
        </main>

        <footer class="about-footer">
            <div class="container about-footer-inner d-flex flex-column flex-sm-row justify-content-between align-items-center gap-2">
                <div class="d-flex align-items-center gap-2">
                    <span class="about-footer-logo" aria-hidden="true">
                        <img runat="server" src="~/Images/LogoTD.png" alt="" />
                    </span>
                    <span class="about-footer-copy">&copy; <%: DateTime.Now.Year %> TinyDesk</span>
                </div>

                <nav class="d-flex align-items-center gap-3" aria-label="Navegación del pie de página">
                    <asp:LinkButton ID="btnIrAbout"
                        runat="server"
                        CausesValidation="false"
                        OnClick="btnIrAbout_Click"
                        CssClass="btn btn-link text-decoration-none p-0 about-footer-link is-active">
                        Acerca de
                    </asp:LinkButton>

                    <asp:LinkButton ID="btnIrContacto"
                        runat="server"
                        CausesValidation="false"
                        OnClick="btnIrContacto_Click"
                        CssClass="btn btn-link text-decoration-none p-0 about-footer-link">
                        Contacto
                    </asp:LinkButton>
                </nav>
            </div>
        </footer>

    </form>

    <script>
        (function () {
            "use strict";

            var reduceMotion = window.matchMedia && window.matchMedia("(prefers-reduced-motion: reduce)").matches;
            var revealItems = document.querySelectorAll("[data-reveal]");
            var progress = document.getElementById("readingProgress");
            var workflow = document.getElementById("workflow");
            var workflowSteps = workflow ? workflow.querySelectorAll("[data-workflow-step]") : [];
            var workflowIndex = 0;
            var workflowTimer = null;

            if (!reduceMotion && "IntersectionObserver" in window) {
                document.body.classList.add("reveal-ready");

                var observer = new IntersectionObserver(function (entries) {
                    entries.forEach(function (entry) {
                        if (entry.isIntersecting) {
                            entry.target.classList.add("is-visible");
                            observer.unobserve(entry.target);
                        }
                    });
                }, { threshold: 0.14, rootMargin: "0px 0px -45px" });

                revealItems.forEach(function (item, index) {
                    item.style.transitionDelay = (index % 4) * 70 + "ms";
                    observer.observe(item);
                });
            } else {
                revealItems.forEach(function (item) {
                    item.classList.add("is-visible");
                });
            }

            function activateWorkflowStep(index) {
                if (!workflow || !workflowSteps.length) return;

                workflowIndex = (index + workflowSteps.length) % workflowSteps.length;

                workflowSteps.forEach(function (step, stepIndex) {
                    var isActive = stepIndex === workflowIndex;
                    step.classList.toggle("is-active", isActive);

                    if (isActive) {
                        step.setAttribute("aria-current", "step");
                    } else {
                        step.removeAttribute("aria-current");
                    }
                });

                var progressValue = workflowSteps.length > 1
                    ? (workflowIndex / (workflowSteps.length - 1)) * 100
                    : 100;

                workflow.style.setProperty("--workflow-progress", progressValue + "%");
            }

            function stopWorkflowAnimation() {
                if (!workflowTimer) return;
                window.clearInterval(workflowTimer);
                workflowTimer = null;
            }

            function startWorkflowAnimation() {
                if (reduceMotion || document.hidden || workflowSteps.length < 2) return;

                stopWorkflowAnimation();
                workflowTimer = window.setInterval(function () {
                    activateWorkflowStep(workflowIndex + 1);
                }, 1900);
            }

            if (workflow && workflowSteps.length) {
                activateWorkflowStep(0);

                workflowSteps.forEach(function (step, index) {
                    step.addEventListener("mouseenter", function () {
                        stopWorkflowAnimation();
                        activateWorkflowStep(index);
                    });

                    step.addEventListener("focus", function () {
                        stopWorkflowAnimation();
                        activateWorkflowStep(index);
                    });
                });

                workflow.addEventListener("mouseleave", startWorkflowAnimation);
                workflow.addEventListener("focusout", function (event) {
                    if (!workflow.contains(event.relatedTarget)) {
                        startWorkflowAnimation();
                    }
                });

                if (!reduceMotion && "IntersectionObserver" in window) {
                    var workflowObserver = new IntersectionObserver(function (entries) {
                        entries.forEach(function (entry) {
                            if (entry.isIntersecting) {
                                startWorkflowAnimation();
                            } else {
                                stopWorkflowAnimation();
                            }
                        });
                    }, { threshold: .35 });

                    workflowObserver.observe(workflow);
                } else if (!reduceMotion) {
                    startWorkflowAnimation();
                }

                document.addEventListener("visibilitychange", function () {
                    if (document.hidden) {
                        stopWorkflowAnimation();
                    } else {
                        startWorkflowAnimation();
                    }
                });
            }

            function updateProgress() {
                if (!progress) return;

                var documentHeight = document.documentElement.scrollHeight - window.innerHeight;
                var percentage = documentHeight > 0 ? (window.scrollY / documentHeight) * 100 : 0;
                progress.style.width = Math.min(100, Math.max(0, percentage)) + "%";
            }

            window.addEventListener("scroll", updateProgress, { passive: true });
            updateProgress();
        }());
    </script>
</body>
</html>
