<%@ Page Title="Proyectos" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Proyectos.aspx.cs" Inherits="TP_Final_Programacion_III.Proyectos" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">


    <asp:Literal ID="litMensaje" runat="server"></asp:Literal>
    <div class="col-12 col-md-auto">
        <div class="d-flex flex-wrap gap-2">
            <button type="button" class="btn btn-primary shadow-sm d-flex align-items-center gap-2" data-bs-toggle="modal" data-bs-target="#proyectoModal">
                <i class="bi bi-plus-circle"></i>Nuevo Proyecto
            </button>
        </div>
    </div>

    <div class="row">
        <asp:Repeater ID="repProyectos" runat="server" OnItemDataBound="repProyectos_ItemDataBound">
            <ItemTemplate>
                <div class="col-md-4">
                    <a
                        class="card text-decoration-none text-dark mb-3"
                        href='<%# "Default.aspx" %>'>

                        <div class="card-body">
                            <h5 class="card-title"><%# Eval("Nombre") %></h5>
                            <p class="card-text"><%# Eval("Descripcion") %></p>
                            <p>Estado: <%# Eval("Estado.Nombre") %></p>
                            <p>Inicio: <%# Eval("FechaInicio", "{0:dd/MM/yyyy}") %> </p>
                            <p>Final Esperado: <%# Eval("FechaEstimadaFin", "{0:dd/MM/yyyy}") %> </p>
                            <asp:Label ID="lblFechaFin" runat="server" CssClass="d-block" Visible="false"></asp:Label>
                        </div>

                    </a>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>

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
                            <asp:TextBox ID="txtNombreProyecto" runat="server" CssClass="form-control" placeholder="Ej: Rediseño Web"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvNombreProyecto" runat="server" ControlToValidate="txtNombreProyecto" ErrorMessage="El nombre del proyecto es obligatorio." CssClass="text-danger text-validation-error" Display="Dynamic" ValidationGroup="vgProyecto" />
                        </div>
                        <div class="col-md-12">
                            <label for="txtDescripcionProyecto" class="form-label fw-semibold">Descripción</label>
                            <asp:TextBox ID="txtDescripcionProyecto" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" placeholder="Ingresá una descripción breve..."></asp:TextBox>
                        </div>
                        <div class="col-md-6">
                            <label for="txtFechaInicioProyecto" class="form-label fw-semibold">Fecha Inicio</label>
                            <asp:TextBox ID="txtFechaInicioProyecto" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvFechaInicioProyecto" runat="server" ControlToValidate="txtFechaInicioProyecto" ErrorMessage="La fecha de inicio es obligatoria." CssClass="text-danger text-validation-error" Display="Dynamic" ValidationGroup="vgProyecto" />
                        </div>
                        <div class="col-md-6">
                            <label for="txtFechaEstimadaFinProyecto" class="form-label fw-semibold">Fecha Estimada Fin</label>
                            <asp:TextBox ID="txtFechaEstimadaFinProyecto" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvFechaFinProyecto" runat="server" ControlToValidate="txtFechaEstimadaFinProyecto" ErrorMessage="La fecha estimada de fin es obligatoria." CssClass="text-danger text-validation-error" Display="Dynamic" ValidationGroup="vgProyecto" />
                        </div>
                        <div class="col-md-6">
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
