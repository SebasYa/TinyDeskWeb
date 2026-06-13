<%@ Page Title="Dashboard" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="TP_Final_Programacion_III._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <asp:Literal ID="litMensaje" runat="server"></asp:Literal>
    <section>
        <div class="row align-items-center mb-4">


            <div class="col-12 col-md-auto">
                <div class="d-flex flex-wrap gap-2">
                    <button type="button" class="btn btn-primary shadow-sm d-flex align-items-center gap-2" data-bs-toggle="modal" data-bs-target="#proyectoModal">
                        <i class="bi bi-plus-circle"></i>Nuevo Proyecto
                    </button>

                    <button type="button" class="btn btn-primary shadow-sm d-flex align-items-center gap-2" data-bs-toggle="modal" data-bs-target="#sprintModal">
                        <i class="bi bi-plus-circle"></i>Crear Sprint
                    </button>

                    <button type="button" class="btn btn-primary shadow-sm d-flex align-items-center gap-2" data-bs-toggle="modal" data-bs-target="#ticketModal">
                        <i class="bi bi-plus-circle"></i>Nuevo Ticket
                    </button>
                </div>
            </div>
        </div>
    </section>

    <!-- INICIO - CREAR TICKET MODAL -->

    <div class="modal fade" id="ticketModal" tabindex="-1" aria-labelledby="ticketModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header bg-light">
                    <h5 class="modal-title fw-bold" id="ticketModalLabel">Nuevo Ticket</h5>
                    <asp:LinkButton ID="btnCloseTicket" runat="server" CssClass="btn-close" OnClick="btnCancelarTicket_Click" aria-label="Close"></asp:LinkButton>
                </div>
                <div class="modal-body">
                    <asp:UpdatePanel ID="upTicketModal" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                            <asp:Panel ID="pnlFormTicket" CssClass="row g-3" runat="server">

                                <div class="col-12">
                                    <div class="border-bottom pb-2 mb-1">
                                        <h6 class="text-uppercase text-muted fw-bold mb-0" style="font-size: .75rem;">Detalle del ticket</h6>
                                    </div>
                                </div>

                                <div class="col-md-12">
                                    <label for="txtDescripcionTicket" class="form-label fw-semibold">Descripción</label>
                                    <asp:TextBox ID="txtDescripcionTicket" runat="server" CssClass="form-control w-100 mw-100"
                                        TextMode="MultiLine" Rows="3" MaxLength="150"
                                        placeholder="Ingresá una descripción breve..."></asp:TextBox>
                                </div>

                                <div class="col-md-4">
                                    <label for="txtFechaInicioTicket" class="form-label fw-semibold">Fecha Inicio</label>
                                    <asp:TextBox ID="txtFechaInicioTicket" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                                </div>

                                <div class="col-md-4">
                                    <label for="txtFechaEstimadaTicket" class="form-label fw-semibold">Fecha Estimada Fin</label>
                                    <asp:TextBox ID="txtFechaEstimadaTicket" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                                </div>

                                <div class="col-md-4">
                                    <label for="ddlPrioridadTicket" class="form-label fw-semibold">Prioridad</label>
                                    <asp:DropDownList ID="ddlPrioridadTicket" runat="server" CssClass="form-select">
                                    </asp:DropDownList>
                                </div>

                                <div class="col-12 mt-3">
                                    <div class="border-bottom pb-2 mb-1">
                                        <h6 class="text-uppercase text-muted fw-bold mb-0" style="font-size: .75rem;">Proyecto y sprint</h6>
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <label for="ddlProyectoTicket" class="form-label fw-semibold">Proyecto</label>
                                    <asp:DropDownList ID="ddlProyectoTicket" runat="server" CssClass="form-select"
                                        AutoPostBack="true" OnSelectedIndexChanged="ddlProyectoTicket_SelectedIndexChanged">
                                    </asp:DropDownList>
                                </div>

                                <div class="col-md-6">
                                    <label for="ddlSprintTicket" class="form-label fw-semibold">Sprint</label>
                                    <asp:DropDownList ID="ddlSprintTicket" runat="server" CssClass="form-select">
                                    </asp:DropDownList>
                                </div>

                                <div class="col-12 mt-3">
                                    <div class="border-bottom pb-2 mb-1">
                                        <h6 class="text-uppercase text-muted fw-bold mb-0" style="font-size: .75rem;">Asignación</h6>
                                    </div>
                                </div>

                                <div class="col-md-4">
                                    <label for="ddlAreaTicket" class="form-label fw-semibold">Area</label>
                                    <asp:DropDownList ID="ddlAreaTicket" runat="server" CssClass="form-select"
                                        AutoPostBack="true" OnSelectedIndexChanged="ddlFiltroUsuarioTicket_SelectedIndexChanged">
                                    </asp:DropDownList>
                                </div>

                                <div class="col-md-4">
                                    <label for="ddlPuestoTicket" class="form-label fw-semibold">Puesto</label>
                                    <asp:DropDownList ID="ddlPuestoTicket" runat="server" CssClass="form-select"
                                        AutoPostBack="true" OnSelectedIndexChanged="ddlFiltroUsuarioTicket_SelectedIndexChanged">
                                    </asp:DropDownList>
                                </div>

                                <div class="col-md-4">
                                    <label for="ddlSeniorityTicket" class="form-label fw-semibold">Seniority</label>
                                    <asp:DropDownList ID="ddlSeniorityTicket" runat="server" CssClass="form-select"
                                        AutoPostBack="true" OnSelectedIndexChanged="ddlFiltroUsuarioTicket_SelectedIndexChanged">
                                    </asp:DropDownList>
                                </div>

                                <div class="col-md-8">
                                    <label for="ddlUsuarioTicket" class="form-label fw-semibold">Usuario</label>
                                    <asp:DropDownList ID="ddlUsuarioTicket" runat="server" CssClass="form-select"
                                        AutoPostBack="true" OnSelectedIndexChanged="ddlUsuarioTicket_SelectedIndexChanged">
                                    </asp:DropDownList>
                                </div>

                                <div class="col-md-4">
                                    <label for="ddlEstadoTicket" class="form-label fw-semibold">Estado</label>
                                    <asp:DropDownList ID="ddlEstadoTicket" runat="server" CssClass="form-select">
                                    </asp:DropDownList>
                                </div>

                            </asp:Panel>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>

                <div class="modal-footer bg-light">
                    <asp:Button ID="btnCancelarTicket" runat="server" CssClass="btn btn-secondary" Text="Cancelar" OnClick="btnCancelarTicket_Click" UseSubmitBehavior="false" />
                    <asp:Button ID="btnGuardarTicket" runat="server" CssClass="btn btn-primary"
                        Text="Guardar Ticket" OnClick="btnGuardarTicket_Click" />
                </div>
            </div>
        </div>
    </div>

    <!-- FIN - CREAR TICKET MODAL -->

    <!-- INICIO - CREAR SPRINT MODAL -->
    <div class="modal fade" id="sprintModal" tabindex="-1" aria-labelledby="sprintModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header bg-light">
                    <h5 class="modal-title fw-bold" id="sprintModalLabel">Nuevo Sprint</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <asp:Panel ID="pnlFormSprint" CssClass="row g-3" runat="server">


                        <div class="col-md-6">
                            <label for="txtFechaInicio" class="form-label fw-semibold">Fecha Inicio</label>
                            <asp:TextBox ID="txtFechaInicio" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                        </div>

                        <div class="col-md-6">
                            <label for="txtFechaEstimadaFin" class="form-label fw-semibold">Fecha Estimada Fin</label>
                            <asp:TextBox ID="txtFechaEstimadaFin" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                        </div>

                        <div class="col-md-4">
                            <label for="ddlProyecto" class="form-label fw-semibold">Proyecto</label>
                            <asp:DropDownList ID="ddlProyecto" runat="server" CssClass="form-select">
                                <asp:ListItem Text="Seleccione Proyecto..." Value="" />
                            </asp:DropDownList>
                        </div>

                        <div class="col-md-4">
                            <label for="ddlEstado" class="form-label fw-semibold">Estado</label>
                            <asp:DropDownList ID="ddlEstado" runat="server" CssClass="form-select">
                                <asp:ListItem Text="Seleccione Estado..." Value="" />
                            </asp:DropDownList>
                        </div>

                        <div class="col-md-4">
                            <label for="ddlArea" class="form-label fw-semibold">Área</label>
                            <asp:DropDownList ID="ddlArea" runat="server" CssClass="form-select">
                                <asp:ListItem Text="Seleccione Área..." Value="" />
                            </asp:DropDownList>
                        </div>

                    </asp:Panel>
                </div>
                <div class="modal-footer bg-light">
                    <asp:Button ID="btnCerrarSprint" runat="server" CssClass="btn btn-secondary" Text="Cancelar" OnClick="btnCerrarSprint_Click" UseSubmitBehavior="false" />
                    <asp:Button ID="btnGuardarSprint" runat="server" CssClass="btn btn-primary" Text="Guardar Sprint" OnClick="btnGuardarSprint_Click" />
                </div>
            </div>
        </div>
    </div>

    <!-- FIN - CREAR SPRINT MODAL -->

    <!-- INICIO - CREAR PROYECTO MODAL -->
    <div class="modal fade" id="proyectoModal" tabindex="-1" aria-labelledby="proyectoModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header bg-light">
                    <h5 class="modal-title fw-bold" id="proyectoModalLabel">Nuevo Proyecto</h5>
                    <asp:LinkButton ID="btnCloseProyecto" runat="server" CssClass="btn-close" OnClick="btnCancelarProyecto_Click" aria-label="Close"></asp:LinkButton>
                </div>
                <div class="modal-body">
                    <asp:Panel ID="pnlFormProyecto" CssClass="row g-3" runat="server">
                        <div class="col-md-12">
                            <label for="txtNombreProyecto" class="form-label fw-semibold">Nombre del Proyecto</label>
                            <asp:TextBox ID="txtNombreProyecto" runat="server" CssClass="form-control w-100 mw-100" placeholder="Ej: Rediseño Web"></asp:TextBox>
                        </div>
                        <div class="col-md-12">
                            <label for="txtDescripcionProyecto" class="form-label fw-semibold">Descripción</label>
                            <asp:TextBox ID="txtDescripcionProyecto" runat="server" CssClass="form-control w-100 mw-100" TextMode="MultiLine" Rows="3" placeholder="Ingresá una descripción breve..."></asp:TextBox>
                        </div>
                        <div class="col-md-4">
                            <label for="txtFechaInicioProyecto" class="form-label fw-semibold">Fecha Inicio</label>
                            <asp:TextBox ID="txtFechaInicioProyecto" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvFechaInicioProyecto" runat="server" ControlToValidate="txtFechaInicioProyecto" ErrorMessage="La fecha de inicio es obligatoria." CssClass="text-danger text-validation-error" Display="Dynamic" ValidationGroup="vgProyecto" />
                        </div>
                        <div class="col-md-4">
                            <label for="txtFechaEstimadaFinProyecto" class="form-label fw-semibold">Fecha Estimada Fin</label>
                            <asp:TextBox ID="txtFechaEstimadaFinProyecto" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvFechaFinProyecto" runat="server" ControlToValidate="txtFechaEstimadaFinProyecto" ErrorMessage="La fecha estimada de fin es obligatoria." CssClass="text-danger text-validation-error" Display="Dynamic" ValidationGroup="vgProyecto" />
                        </div>
                        <div class="col-md-4">
                            <label for="ddlEstadoProyecto" class="form-label fw-semibold">Estado Inicial</label>
                            <asp:DropDownList ID="ddlEstadoProyecto" runat="server" CssClass="form-select">
                                <asp:ListItem Text="Seleccione Estado..." Value="" />
                            </asp:DropDownList>
                            <asp:RequiredFieldValidator ID="rfvEstadoProyecto" runat="server" ControlToValidate="ddlEstadoProyecto" InitialValue="" ErrorMessage="Debe seleccionar un estado." CssClass="text-danger text-validation-error" Display="Dynamic" ValidationGroup="vgProyecto" />
                        </div>
                    </asp:Panel>
                </div>
                <div class="modal-footer bg-light">
                    <asp:Button ID="btnCancelarProyecto" runat="server" CssClass="btn btn-secondary" Text="Cancelar" OnClick="btnCancelarProyecto_Click" UseSubmitBehavior="false" />
                    <asp:Button ID="btnGuardarProyecto" runat="server" CssClass="btn btn-primary" Text="Guardar Proyecto" OnClick="btnGuardarProyecto_Click" ValidationGroup="vgProyecto" />
                </div>
            </div>
        </div>
    </div>
    <!-- FIN - CREAR PROYECTO MODAL -->

    <section class="mt-4">
        <div class="row g-3">
            <!-- Ficha Proyectos Activos -->
            <div class="col-6 col-md-4 col-lg-3">
                <div class="card border-primary shadow-sm h-100">
                    <div class="card-body p-3 text-center">
                        <h6 class="card-subtitle mb-2 text-muted text-uppercase font-monospace small">Proyectos Activos</h6>
                        <h2 class="card-title mb-0 display-6 fw-bold text-primary">
                            <asp:Label ID="lblProyectosActivos" runat="server" Text=""></asp:Label>
                        </h2>
                    </div>
                </div>
            </div>
            <!-- Ficha Sprints en Curso -->
            <div class="col-6 col-md-4 col-lg-3">
                <div class="card border-success shadow-sm h-100">
                    <div class="card-body p-3 text-center">
                        <h6 class="card-subtitle mb-2 text-muted text-uppercase font-monospace small">Sprints en Curso</h6>
                        <h2 class="card-title mb-0 display-6 fw-bold text-success">
                            <asp:Label ID="lblSprintsEnCurso" runat="server" Text=""></asp:Label>
                        </h2>
                    </div>
                </div>
            </div>
            <!-- Ficha Tickets Abiertos -->
            <div class="col-6 col-md-4 col-lg-3">
                <div class="card border-warning shadow-sm h-100">
                    <div class="card-body p-3 text-center">
                        <h6 class="card-subtitle mb-2 text-muted text-uppercase font-monospace small">Tickets Abiertos</h6>
                        <h2 class="card-title mb-0 display-6 fw-bold text-warning">
                            <asp:Label ID="lblTicketsAbiertos" runat="server" Text=""></asp:Label>
                        </h2>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section class="mt-4">
        <h2>Alertas</h2>

        <asp:Panel ID="pnlTicketsUsuariosDesactivados" runat="server"
            Visible="false"
            CssClass="alert alert-warning shadow-sm d-flex justify-content-between align-items-center"
            Style="cursor: pointer;"
            onclick="window.location.href='TicketsUsuariosDesactivados.aspx';">

            <div>
                <i class="bi bi-exclamation-triangle-fill me-2"></i>
                <strong>Revisión requerida:</strong>
                <asp:Label ID="lblTicketsUsuariosDesactivados" runat="server"></asp:Label>
                <span>Revisá estas asignaciones para evitar demoras operativas.</span>
            </div>

            <i class="bi bi-chevron-right"></i>
        </asp:Panel>

        <asp:Panel ID="pnlSinAlertas" runat="server"
            Visible="false"
            CssClass="alert alert-success shadow-sm">
            <i class="bi bi-check-circle-fill me-2"></i>
            No hay alertas pendientes.
        </asp:Panel>
    </section>

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
