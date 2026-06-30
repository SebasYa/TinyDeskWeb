<%@ Page Title="Acerca de TinyDesk" Language="C#" AutoEventWireup="true" CodeBehind="About.aspx.cs" Inherits="TP_Final_Programacion_III.About" %>

<!DOCTYPE html>

<html lang="es">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    <title>Acerca de TinyDesk</title>

    <link href="Content/bootstrap.min.css" rel="stylesheet" />
    <link href="Content/Site.css" rel="stylesheet" />
    <link href="favicon.ico" rel="shortcut icon" type="image/x-icon" />
</head>

<body class="bg-light">
    <form id="form1" runat="server"
        class="min-vh-100 d-flex flex-column">

        <header class="bg-white border-bottom">
            <div class="container py-3 d-flex justify-content-between align-items-center">

                <asp:LinkButton ID="btnInicio"
                    runat="server"
                    CausesValidation="false"
                    OnClick="btnInicio_Click"
                    CssClass="d-flex align-items-center text-decoration-none text-dark">

                    <span class="position-relative overflow-hidden me-2"
                        style="width: 42px; height: 42px;">

                        <img src="Images/LogoTD.png"
                            alt="TinyDesk"
                            style="position: absolute;
                                   width: 58px;
                                   height: 58px;
                                   max-width: none;
                                   top: 50%;
                                   left: 50%;
                                   transform: translate(-50%, -50%);" />
                    </span>

                    <span class="fw-bold fs-4">TinyDesk</span>

                </asp:LinkButton>

                <asp:LinkButton ID="btnVolver"
                    runat="server"
                    CausesValidation="false"
                    OnClick="btnInicio_Click"
                    CssClass="btn btn-outline-primary btn-sm">

                    Volver a TinyDesk

                </asp:LinkButton>

            </div>
        </header>

        <main class="container flex-grow-1 py-5">

            <section class="text-center mb-5">
                <span class="badge bg-primary mb-3">Gestión de trabajo
                </span>

                <h1 class="display-5 fw-bold">Trabajo claro. Equipos alineados.
                </h1>

                <p class="lead text-muted mx-auto"
                    style="max-width: 760px;">
                    TinyDesk es una plataforma SaaS para organizar proyectos,
                    planificar sprints, administrar tickets y conectar el
                    trabajo de todas las personas de una organización.

                </p>
            </section>

            <section class="row g-4 mb-5">

                <div class="col-md-6">
                    <article class="card border-0 shadow-sm h-100">
                        <div class="card-body p-4">

                            <h2 class="h4">Nuestra misión</h2>

                            <p class="text-muted mb-0">
                                Simplificar la coordinación del trabajo para que
                                los equipos conviertan sus objetivos en avances
                                claros, visibles y medibles.
                            </p>

                        </div>
                    </article>
                </div>

                <div class="col-md-6">
                    <article class="card border-0 shadow-sm h-100">
                        <div class="card-body p-4">

                            <h2 class="h4">Nuestra visión</h2>

                            <p class="text-muted mb-0">
                                Ser una plataforma accesible y confiable que
                                acompañe a las organizaciones desde sus primeros
                                proyectos hasta una operación colaborativa y
                                escalable.
                            </p>

                        </div>
                    </article>
                </div>

            </section>

            <section class="card border-0 shadow-sm mb-5">
                <div class="card-body p-4 p-md-5">

                    <h2 class="h3 text-center mb-4">Todo el trabajo en un solo lugar
                    </h2>

                    <div class="row g-4 text-center">

                        <div class="col-sm-6 col-lg-3">
                            <h3 class="h5">Proyectos</h3>
                            <p class="text-muted small mb-0">
                                Objetivos, equipos, fechas y seguimiento.
                            </p>
                        </div>

                        <div class="col-sm-6 col-lg-3">
                            <h3 class="h5">Sprints</h3>
                            <p class="text-muted small mb-0">
                                Planificación del trabajo en ciclos organizados.
                            </p>
                        </div>

                        <div class="col-sm-6 col-lg-3">
                            <h3 class="h5">Tickets</h3>
                            <p class="text-muted small mb-0">
                                Prioridades, responsables, estados y entregas.
                            </p>
                        </div>

                        <div class="col-sm-6 col-lg-3">
                            <h3 class="h5">Equipos</h3>
                            <p class="text-muted small mb-0">
                                Empresas, áreas, puestos y permisos.
                            </p>
                        </div>

                    </div>

                </div>
            </section>

            <section class="bg-white border rounded-3 p-4 text-center">
                <h2 class="h4">Nuestros valores</h2>

                <p class="text-muted mb-0">
                    Claridad · Colaboración · Responsabilidad · Mejora continua
                </p>
            </section>

        </main>

        <footer class="bg-white border-top">
            <div class="container py-3 d-flex flex-column flex-sm-row
                        justify-content-between align-items-center gap-2">

                <div class="d-flex align-items-center gap-1">

                    <span style="width: 22px; height: 22px; overflow: hidden; position: relative; flex: 0 0 22px;">

                        <img runat="server"
                            src="~/Images/LogoTD.png"
                            alt="TinyDesk"
                            style="width: 32px; height: 32px; position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); filter: grayscale(1) brightness(0); opacity: .55;" />

                    </span>

                    <span class="text-muted small">&copy; <%: DateTime.Now.Year %> TinyDesk
                    </span>

                </div>

                <nav class="d-flex align-items-center gap-3">

                    <asp:LinkButton ID="btnIrAbout"
                        runat="server"
                        CausesValidation="false"
                        OnClick="btnIrAbout_Click"
                        CssClass="btn btn-link text-muted text-decoration-none small p-0">
                        Acerca de
                    </asp:LinkButton>

                    <asp:LinkButton ID="btnIrContacto"
                        runat="server"
                        CausesValidation="false"
                        OnClick="btnIrContacto_Click"
                        CssClass="btn btn-link text-muted text-decoration-none small p-0">
                        Contacto
                    </asp:LinkButton>

                </nav>

            </div>
        </footer>

    </form>
</body>
</html>
