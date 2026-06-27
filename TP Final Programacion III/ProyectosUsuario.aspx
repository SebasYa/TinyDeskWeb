<%@ Page Title="" Language="C#" MasterPageFile="~/UsuarioSite.Master" AutoEventWireup="true" CodeBehind="ProyectosUsuario.aspx.cs" Inherits="TP_Final_Programacion_III.ProyectosUsuario" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <asp:Literal ID="litMensaje" runat="server"></asp:Literal>

    <!-- DETALLE DEL PROYECTO -->
    <asp:Panel
        ID="pnlDetalleProyecto"
        runat="server"
        Visible="false"
        CssClass="container mt-4">

        <div class="d-flex justify-content-between align-items-start flex-wrap gap-3 mb-4">

            <div>
                <div class="d-flex align-items-center flex-wrap gap-2 mb-2">

                    <h1 class="h2 fw-bold text-dark mb-0">
                        <asp:Label ID="lblDetalleNombre" runat="server"></asp:Label>
                    </h1>

                    <span class="badge rounded-pill bg-primary-subtle text-primary">
                        <asp:Label ID="lblDetalleEstado" runat="server"></asp:Label>
                    </span>

                </div>

                <p class="text-muted mb-0">
                    Información general y sprints donde tenés tickets asignados.
                </p>
            </div>

            <asp:LinkButton
                ID="btnVolverProyectos"
                runat="server"
                CssClass="btn btn-outline-secondary"
                CausesValidation="false"
                OnClick="btnVolverProyectos_Click">

                <i class="bi bi-arrow-left me-1"></i>
                Volver

            </asp:LinkButton>

        </div>

        <!-- INFORMACIÓN -->
        <div class="card border-0 shadow-sm mb-4">

            <div class="card-header bg-white p-4">
                <h2 class="h5 fw-bold mb-1">Detalle del proyecto</h2>

                <p class="text-muted small mb-0">
                    Descripción, fechas y estado actual.
                </p>
            </div>

            <div class="card-body p-4 border-top">

                <div class="mb-4">

                    <div class="text-uppercase text-muted small fw-semibold mb-2">
                        Descripción
                    </div>

                    <div class="text-dark">
                        <asp:Label ID="lblDetalleDescripcion" runat="server"></asp:Label>
                    </div>

                </div>

                <div class="row g-3">

                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="bg-light border rounded-3 p-3 h-100">

                            <div class="d-flex align-items-center gap-2 text-muted small mb-2">
                                <i class="bi bi-calendar-event text-primary"></i>
                                Fecha de inicio
                            </div>

                            <div class="fw-semibold text-dark">
                                <asp:Label ID="lblDetalleFechaInicio" runat="server"></asp:Label>
                            </div>

                        </div>
                    </div>

                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="bg-light border rounded-3 p-3 h-100">

                            <div class="d-flex align-items-center gap-2 text-muted small mb-2">
                                <i class="bi bi-calendar-check text-primary"></i>
                                Fin estimado
                            </div>

                            <div class="fw-semibold text-dark">
                                <asp:Label ID="lblDetalleFechaEstimadaFin" runat="server"></asp:Label>
                            </div>

                        </div>
                    </div>

                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="bg-light border rounded-3 p-3 h-100">

                            <div class="d-flex align-items-center gap-2 text-muted small mb-2">
                                <i class="bi bi-calendar-x text-primary"></i>
                                Fecha de finalización
                            </div>

                            <div class="fw-semibold text-dark">
                                <asp:Label ID="lblDetalleFechaFin" runat="server"></asp:Label>
                            </div>

                        </div>
                    </div>

                    <div class="col-12 col-sm-6 col-xl-3">
                        <div class="bg-light border rounded-3 p-3 h-100">

                            <div class="d-flex align-items-center gap-2 text-muted small mb-2">
                                <i class="bi bi-activity text-primary"></i>
                                Estado del registro
                            </div>

                            <asp:Label ID="lblDetalleActivo" runat="server"></asp:Label>

                        </div>
                    </div>

                </div>

            </div>

        </div>

        <!-- SPRINTS -->
        <div class="card border-0 shadow-sm">

            <div class="card-header bg-white p-4">

                <div class="d-flex align-items-center gap-3">

                    <div class="bg-primary-subtle text-primary rounded-3 p-2">
                        <i class="bi bi-kanban fs-4"></i>
                    </div>

                    <div>
                        <h2 class="h5 fw-bold mb-1">Tus sprints</h2>

                        <p class="text-muted small mb-0">
                            Sprints donde tenés al menos un ticket asignado.
                        </p>
                    </div>

                </div>

            </div>

            <div class="card-body p-0 border-top">

                <asp:ListView
                    ID="lvSprintsProyecto"
                    runat="server"
                    ItemPlaceholderID="itemPlaceholder"
                    OnPagePropertiesChanging="lvSprintsProyecto_PagePropertiesChanging">

                    <LayoutTemplate>

                        <div class="table-responsive">

                            <table class="table table-hover align-middle mb-0">

                                <thead class="table-light">
                                    <tr>
                                        <th>Sprint</th>
                                        <th>Estado</th>
                                        <th>Inicio</th>
                                        <th>Fin estimada</th>
                                        <th>Área</th>
                                        <th>Detalle</th>
                                    </tr>
                                </thead>

                                <tbody>
                                    <asp:PlaceHolder
                                        ID="itemPlaceholder"
                                        runat="server" />
                                </tbody>

                            </table>

                        </div>

                    </LayoutTemplate>

                    <ItemTemplate>

                        <tr>

                            <td>
                                <span class="fw-semibold text-dark">
                                    Sprint <%# Eval("NumeroSprint") %>
                                </span>
                            </td>

                            <td>
                                <span class="badge bg-light text-dark border">
                                    <%# Eval("Estado.Nombre") %>
                                </span>
                            </td>

                            <td>
                                <%# Eval("FechaInicio", "{0:dd/MM/yyyy}") %>
                            </td>

                            <td>
                                <%# Eval("FechaEstimadaFin", "{0:dd/MM/yyyy}") %>
                            </td>

                            <td>
                                <i class="bi bi-people me-1 text-muted"></i>
                                <%# Eval("Area.Nombre") %>
                            </td>

                            <td>

                                <asp:LinkButton
                                    ID="btnVerSprint"
                                    runat="server"
                                    Text="Ver sprint"
                                    CssClass="btn btn-sm btn-outline-primary"
                                    CommandArgument='<%# Eval("Id") %>'
                                    CausesValidation="false"
                                    OnClick="btnVerSprint_Click" />

                            </td>

                        </tr>

                    </ItemTemplate>

                    <EmptyDataTemplate>
                        <div class="alert alert-info m-4">
                            No tenés tickets asignados en los sprints de este proyecto.
                        </div>
                    </EmptyDataTemplate>

                </asp:ListView>

                <div class="d-flex justify-content-center my-4">

                    <asp:DataPager
                        ID="dpSprintsProyecto"
                        runat="server"
                        PagedControlID="lvSprintsProyecto"
                        PageSize="5">

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

        </div>

    </asp:Panel>

    <!-- LISTADO DE PROYECTOS -->
    <asp:Panel
        ID="pnlListadoProyectos"
        runat="server"
        CssClass="container mt-4">

        <div class="mb-4">

            <h1 class="h2 text-dark fw-bold mb-1">
                Proyectos
            </h1>

            <p class="text-muted mb-0">
                Consultá los proyectos de la empresa y revisá su avance.
            </p>

        </div>

        <div class="card border-0 shadow-sm mb-4">

            <div class="card-body d-flex justify-content-between align-items-center flex-wrap gap-3">

                <div>
                    <h5 class="fw-semibold mb-1">
                        Estado de los proyectos
                    </h5>

                    <small class="text-muted">
                        Alterná entre proyectos activos y proyectos finalizados.
                    </small>
                </div>

                <div class="d-flex flex-wrap gap-2">

                    <asp:Button
                        ID="btnFiltroActivos"
                        runat="server"
                        Text="Activos"
                        CssClass="btn btn-primary"
                        CausesValidation="false"
                        OnClick="btnFiltroActivos_Click" />

                    <asp:Button
                        ID="btnFiltroFinalizados"
                        runat="server"
                        Text="Finalizados"
                        CssClass="btn btn-outline-secondary"
                        CausesValidation="false"
                        OnClick="btnFiltroFinalizados_Click" />

                </div>

            </div>

        </div>

        <asp:ListView
            ID="lvProyectos"
            runat="server"
            ItemPlaceholderID="itemPlaceholder"
            OnItemDataBound="lvProyectos_ItemDataBound"
            OnPagePropertiesChanging="lvProyectos_PagePropertiesChanging">

            <LayoutTemplate>

                <div class="row g-3">
                    <asp:PlaceHolder
                        ID="itemPlaceholder"
                        runat="server" />
                </div>

            </LayoutTemplate>

            <ItemTemplate>

                <div class="col-12 col-md-6 col-xl-4">

                    <asp:LinkButton
                        ID="btnVerProyecto"
                        runat="server"
                        CssClass="card h-100 border-0 shadow-sm text-decoration-none text-dark"
                        CommandArgument='<%# Eval("Id") %>'
                        CausesValidation="false"
                        OnClick="btnVerProyecto_Click">

                        <div class="card-body d-flex flex-column">

                            <div class="d-flex justify-content-between align-items-start gap-2 mb-3">

                                <div class="pe-2">

                                    <h5 class="card-title fw-bold mb-1">
                                        <%# Eval("Nombre") %>
                                    </h5>

                                    <small class="text-muted">
                                        <i class="bi bi-folder2-open me-1"></i>
                                        Proyecto
                                    </small>

                                </div>

                                <asp:Literal
                                    ID="litEstadoProyecto"
                                    runat="server"
                                    Mode="PassThrough"
                                    Text='<%# ObtenerIconoEstadoProyecto(Eval("Estado.Nombre")) %>'>
                                </asp:Literal>

                            </div>

                            <p class="card-text text-muted small mb-4">
                                <%# Eval("Descripcion") %>
                            </p>

                            <div class="mt-auto">

                                <div class="d-flex align-items-center text-muted small mb-2">
                                    <i class="bi bi-calendar-event me-2"></i>

                                    <span>
                                        Inicio:
                                        <%# Eval("FechaInicio", "{0:dd/MM/yyyy}") %>
                                    </span>
                                </div>

                                <div class="d-flex align-items-center text-muted small mb-2">
                                    <i class="bi bi-calendar-check me-2"></i>

                                    <span>
                                        Fin estimado:
                                        <%# Eval("FechaEstimadaFin", "{0:dd/MM/yyyy}") %>
                                    </span>
                                </div>

                                <asp:Literal
                                    ID="litFechaFin"
                                    runat="server"
                                    Visible="false">
                                </asp:Literal>

                                <div class="d-flex justify-content-between align-items-center border-top pt-3 mt-3">

                                    <span class="small text-primary fw-semibold">
                                        Ver proyecto
                                    </span>

                                    <i class="bi bi-arrow-right-circle text-primary fs-5"></i>

                                </div>

                            </div>

                        </div>

                    </asp:LinkButton>

                </div>

            </ItemTemplate>

            <EmptyDataTemplate>
                <div class="alert alert-info">
                    No hay proyectos para mostrar.
                </div>
            </EmptyDataTemplate>

        </asp:ListView>

        <div class="d-flex justify-content-center mt-4">

            <asp:DataPager
                ID="dpProyectos"
                runat="server"
                PagedControlID="lvProyectos"
                PageSize="6">

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

    </asp:Panel>

</asp:Content>