<%@ Page Title="Proyectos" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Proyectos.aspx.cs" Inherits="TP_Final_Programacion_III.Proyectos" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <asp:Literal ID="litMensaje" runat="server"></asp:Literal>

    <asp:Panel
        ID="pnlDetalleProyecto"
        runat="server"
        Visible="false"
        CssClass="container mt-4">

        <!-- ENCABEZADO -->
        <div class="d-flex justify-content-between align-items-start flex-wrap gap-3 mb-4">

            <div>

                <div class="d-flex align-items-center flex-wrap gap-2 mb-2">

                    <h1 class="h2 fw-bold text-dark mb-0">
                        <asp:Label
                            ID="lblDetalleNombre"
                            runat="server">
                        </asp:Label>
                    </h1>

                    <span class="badge rounded-pill bg-primary-subtle text-primary">

                        <asp:Label
                            ID="lblDetalleEstado"
                            runat="server">
                        </asp:Label>

                    </span>

                </div>

                <p class="text-muted mb-0">
                    Información general y sprints asociados al proyecto.
                </p>

            </div>

            <div class="d-flex flex-wrap gap-2">

                <a
                    href="Proyectos.aspx"
                    class="btn btn-outline-secondary">

                    <i class="bi bi-arrow-left me-1"></i>
                    Volver

                </a>

                <button
                    type="button"
                    class="btn btn-primary"
                    data-bs-toggle="modal"
                    data-bs-target="#proyectoModal">

                    <i class="bi bi-pencil me-1"></i>
                    Editar proyecto

                </button>

                <asp:PlaceHolder
                    ID="phFinalizarProyecto"
                    runat="server">

                    <button
                        type="button"
                        class="btn btn-outline-danger"
                        data-bs-toggle="modal"
                        data-bs-target="#finalizarProyectoModal">

                        <i class="bi bi-check-circle me-1"></i>
                        Finalizar

                    </button>

                </asp:PlaceHolder>

            </div>

        </div>

        <!-- INFORMACIÓN DEL PROYECTO -->
        <div class="card border-0 shadow-sm mb-4">

            <div class="card-body p-4 border-top">

                <div class="mb-4">

                    <div class="text-uppercase text-muted small fw-semibold mb-2">
                        Descripción
                    </div>

                    <div class="text-dark">
                        <asp:Label
                            ID="lblDetalleDescripcion"
                            runat="server">
                        </asp:Label>
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
                                <asp:Label
                                    ID="lblDetalleFechaInicio"
                                    runat="server">
                                </asp:Label>
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
                                <asp:Label
                                    ID="lblDetalleFechaEstimadaFin"
                                    runat="server">
                                </asp:Label>
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
                                <asp:Label
                                    ID="lblDetalleFechaFin"
                                    runat="server">
                                </asp:Label>
                            </div>

                        </div>

                    </div>

                    <div class="col-12 col-sm-6 col-xl-3">

                        <div class="bg-light border rounded-3 p-3 h-100">

                            <div class="d-flex align-items-center gap-2 text-muted small mb-2">
                                <i class="bi bi-activity text-primary"></i>
                                Estado del registro
                            </div>

                            <asp:Label
                                ID="lblDetalleActivo"
                                runat="server">
                            </asp:Label>

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

                        <h2 class="h5 fw-bold mb-1">Sprints del proyecto
                        </h2>

                        <p class="text-muted small mb-0">
                            Consultá los sprints asociados y accedé a su detalle.
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
                                <span class="fw-semibold text-dark">Sprint <%# Eval("NumeroSprint") %>
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
                            Este proyecto todavía no tiene sprints cargados.
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

    <asp:Panel ID="pnlListadoProyectos" runat="server" CssClass="container mt-4">

        <div class="d-flex justify-content-between align-items-start flex-wrap gap-3 mb-4">
            <div>
                <h1 class="h2 text-dark fw-bold mb-1">Proyectos</h1>
                <p class="text-muted mb-0">Gestioná los proyectos de la empresa y revisá su avance.</p>
            </div>

            <button type="button" class="btn btn-primary shadow-sm d-flex align-items-center gap-2"
                data-bs-toggle="modal" data-bs-target="#proyectoModal">
                <i class="bi bi-plus-circle"></i>
                Nuevo Proyecto
            </button>
        </div>

        <asp:Panel
            ID="pnlFiltroProyectos"
            runat="server"
            CssClass="card border-0 shadow-sm mb-4 mx-auto"
            Style="max-width: 1100px;"
            DefaultButton="btnBuscarProyecto">

            <div class="card-body p-3">

                <div class="row g-3 align-items-end">

                    <!-- BÚSQUEDA -->
                    <div class="col-12 col-lg-8">

                        <label for="txtFiltroProyecto" class="form-label fw-semibold mb-2">
                            Buscar proyecto
                        </label>

                        <div class="row g-2">

                            <div class="col-12 col-md-8">
                                <div class="input-group">

                                    <span class="input-group-text bg-white">
                                        <i class="bi bi-search text-muted"></i>
                                    </span>

                                    <asp:TextBox
                                        ID="txtFiltroProyecto"
                                        runat="server"
                                        CssClass="form-control"
                                        placeholder="Nombre o descripción..." />

                                </div>
                            </div>

                            <div class="col-6 col-md-2">
                                <asp:Button
                                    ID="btnBuscarProyecto"
                                    runat="server"
                                    Text="Buscar"
                                    CssClass="btn btn-primary w-100"
                                    OnClick="btnBuscarProyecto_Click" />
                            </div>

                            <div class="col-6 col-md-2">
                                <asp:Button
                                    ID="btnLimpiarFiltroProyecto"
                                    runat="server"
                                    Text="Limpiar"
                                    CssClass="btn btn-outline-secondary w-100"
                                    OnClick="btnLimpiarFiltroProyecto_Click" />
                            </div>

                        </div>
                    </div>

                    <!-- ESTADO -->
                    <div class="col-8 col-lg-4">
                         <div class="w-100 ms-lg-auto" style="max-width: 280px;">

                        <label class="form-label fw-semibold mb-2">
                            Estado de los proyectos
                        </label>

                        <div class="row g-4">

                            <div class="col-4">
                                <asp:Button
                                    ID="btnFiltroActivos"
                                    runat="server"
                                    Text="Activos"
                                    CssClass="btn btn-primary w-100"
                                    OnClick="btnFiltroActivos_Click" />
                            </div>

                            <div class="col-4">
                                <asp:Button
                                    ID="btnFiltroFinalizados"
                                    runat="server"
                                    Text="Finalizados"
                                    CssClass="btn btn-outline-secondary w-100"
                                    OnClick="btnFiltroFinalizados_Click" />
                            </div>

                        </div>
                    </div>

                </div>
            </div>
        </asp:Panel>

        <asp:ListView ID="lvProyectos" runat="server" ItemPlaceholderID="itemPlaceholder" OnItemDataBound="lvProyectos_ItemDataBound" OnPagePropertiesChanging="lvProyectos_PagePropertiesChanging">
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
                                    <span>Inicio:
                                <%# Eval("FechaInicio", "{0:dd/MM/yyyy}") %>
                                    </span>
                                </div>

                                <div class="d-flex align-items-center text-muted small mb-2">
                                    <i class="bi bi-calendar-check me-2"></i>
                                    <span>Fin estimado:
                                <%# Eval("FechaEstimadaFin", "{0:dd/MM/yyyy}") %>
                                    </span>
                                </div>

                                <asp:Literal
                                    ID="litFechaFin"
                                    runat="server"
                                    Visible="false">
                                </asp:Literal>

                                <div class="d-flex justify-content-between align-items-center border-top pt-3 mt-3">

                                    <span class="small text-primary fw-semibold">Ver proyecto
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

    <div class="modal fade" id="proyectoModal" tabindex="-1" aria-labelledby="proyectoModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header bg-light">
                    <h5 class="modal-title fw-bold" id="proyectoModalLabel">
                        <asp:Label ID="lblModalProyectoTitulo" runat="server" Text="Nuevo Proyecto"></asp:Label>
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>

                <div class="modal-body">
                    <asp:Panel ID="pnlFormProyecto" CssClass="row g-3" runat="server">
                        <div class="col-md-12">
                            <label for="txtNombreProyecto" class="form-label fw-semibold">Nombre del Proyecto</label>
                            <asp:TextBox ID="txtNombreProyecto" runat="server" CssClass="form-control" placeholder="Ej: Rediseño Web"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvNombreProyecto" runat="server" ControlToValidate="txtNombreProyecto" ErrorMessage="El nombre del proyecto es obligatorio." CssClass="text-danger text-validation-error" Display="Dynamic" ValidationGroup="vgProyecto" />
                        </div>

                        <div class="col-md-12">
                            <label for="txtDescripcionProyecto" class="form-label fw-semibold">Descripción</label>
                            <asp:TextBox ID="txtDescripcionProyecto" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" placeholder="Ingresá una descripción breve..."></asp:TextBox>
                        </div>

                        <div class="col-md-6">
                            <label for="txtFechaInicioProyecto" class="form-label fw-semibold">Fecha Inicio</label>
                            <asp:TextBox ID="txtFechaInicioProyecto" runat="server" CssClass="form-control" TextMode="Date" Enabled="false"></asp:TextBox>
                        </div>

                        <div class="col-md-6">
                            <label for="txtFechaEstimadaFinProyecto" class="form-label fw-semibold">Fecha Estimada Fin</label>
                            <asp:TextBox ID="txtFechaEstimadaFinProyecto" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvFechaFinProyecto" runat="server" ControlToValidate="txtFechaEstimadaFinProyecto" ErrorMessage="La fecha estimada de fin es obligatoria." CssClass="text-danger text-validation-error" Display="Dynamic" ValidationGroup="vgProyecto" />
                        </div>

                        <div class="col-md-6">
                            <label for="ddlEstadoProyecto" class="form-label fw-semibold">Estado</label>
                            <asp:DropDownList ID="ddlEstadoProyecto" runat="server" CssClass="form-select">
                                <asp:ListItem Text="Seleccione Estado..." Value="" />
                            </asp:DropDownList>
                            <asp:RequiredFieldValidator ID="rfvEstadoProyecto" runat="server" ControlToValidate="ddlEstadoProyecto" InitialValue="" ErrorMessage="Debe seleccionar un estado." CssClass="text-danger text-validation-error" Display="Dynamic" ValidationGroup="vgProyecto" />
                        </div>
                    </asp:Panel>
                </div>

                <div class="modal-footer bg-light">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <asp:Button ID="btnGuardarProyecto" runat="server" CssClass="btn btn-primary" Text="Guardar Proyecto" OnClick="btnGuardarProyecto_Click" ValidationGroup="vgProyecto" />
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="finalizarProyectoModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content border-danger">
                <div class="modal-header bg-danger-subtle">
                    <h5 class="modal-title fw-bold text-danger">Finalizar proyecto</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>

                <div class="modal-body">
                    <p class="mb-2">
                        Vas a finalizar <strong>
                            <asp:Label ID="lblFinalizarProyectoNombre" runat="server"></asp:Label></strong>.
                    </p>

                    <p class="text-muted small mb-3">
                        Al continuar se finalizarán también los sprints y tickets activos de este proyecto.
                    </p>

                    <p class="text-muted small mb-3">
                        Para confirmar, escribí el nombre en mayúscula:
                    <strong>
                        <asp:Literal ID="litFinalizarProyectoConfirmacion" runat="server"></asp:Literal></strong>
                    </p>

                    <asp:TextBox ID="txtConfirmarFinalizarProyecto" runat="server" CssClass="form-control" autocomplete="off"></asp:TextBox>
                </div>

                <div class="modal-footer bg-light">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <asp:Button ID="btnConfirmarFinalizarProyecto" runat="server" CssClass="btn btn-danger" Text="Finalizar" OnClick="btnConfirmarFinalizarProyecto_Click" />
                </div>
            </div>
        </div>
    </div>

    <style>
        .form-control.is-invalid, .form-select.is-invalid {
            border-color: #dc3545 !important;
            box-shadow: 0 0 0 0.25rem rgba(220, 53, 69, 0.25) !important;
        }

        .text-validation-error {
            font-size: 0.875em;
            margin-top: 0.25rem;
            display: block;
        }
    </style>

    <script type="text/javascript">
        document.addEventListener("DOMContentLoaded", function () {
            if (typeof ValidatorUpdateDisplay === 'function') {
                var originalValidatorUpdateDisplay = ValidatorUpdateDisplay;
                ValidatorUpdateDisplay = function (val) {
                    originalValidatorUpdateDisplay(val);
                    var control = document.getElementById(val.controltovalidate);
                    if (control) {
                        var isValid = true;
                        for (var i = 0; i < Page_Validators.length; i++) {
                            var v = Page_Validators[i];
                            if (v.controltovalidate === val.controltovalidate && !v.isvalid) {
                                isValid = false;
                                break;
                            }
                        }
                        if (!isValid) {
                            control.classList.add('is-invalid');
                        } else {
                            control.classList.remove('is-invalid');
                        }
                    }
                };
            }
        });
    </script>

</asp:Content>
