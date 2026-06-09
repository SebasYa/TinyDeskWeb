<%@ Page Title="Proyectos" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Proyectos.aspx.cs" Inherits="TP_Final_Programacion_III.Proyectos" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <asp:Literal ID="litMensaje" runat="server"></asp:Literal>

    <asp:Panel ID="pnlDetalleProyecto" runat="server" Visible="false" CssClass="container mt-4">

        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h2 class="mb-1">
                    <asp:Label ID="lblDetalleNombre" runat="server"></asp:Label>
                </h2>

                <span class="badge text-bg-primary">
                    <asp:Label ID="lblDetalleEstado" runat="server"></asp:Label>
                </span>
            </div>

            <div class="d-flex gap-2">
                <a href="Proyectos.aspx" class="btn btn-outline-secondary">
                    <i class="bi bi-arrow-left me-1"></i>Volver
                </a>

                <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#proyectoModal">
                    <i class="bi bi-pencil me-1"></i>Editar Proyecto
                </button>
            </div>
        </div>

        <div class="card shadow-sm mb-4">
            <div class="card-body">
                <h5 class="card-title mb-3">Detalle del proyecto</h5>

                <p class="mb-2">
                    <strong>Descripción:</strong>
                    <asp:Label ID="lblDetalleDescripcion" runat="server"></asp:Label>
                </p>

                <p class="mb-2">
                    <strong>Fecha Inicio:</strong>
                    <asp:Label ID="lblDetalleFechaInicio" runat="server"></asp:Label>
                </p>

                <p class="mb-2">
                    <strong>Fecha Estimada Fin:</strong>
                    <asp:Label ID="lblDetalleFechaEstimadaFin" runat="server"></asp:Label>
                </p>

                <p class="mb-2">
                    <strong>Fecha Fin:</strong>
                    <asp:Label ID="lblDetalleFechaFin" runat="server"></asp:Label>
                </p>

                <p class="mb-0">
                    <strong>Activo:</strong>
                    <asp:Label ID="lblDetalleActivo" runat="server"></asp:Label>
                </p>
            </div>
        </div>

        <h4 class="mb-3">Sprints del proyecto</h4>

        <asp:GridView ID="dgvSprintsProyecto" runat="server"
            AutoGenerateColumns="False"
            DataKeyNames="Id"
            CssClass="table table-hover table-bordered shadow-sm"
            EmptyDataText="Este proyecto todavía no tiene sprints cargados.">

            <Columns>
                <asp:TemplateField HeaderText="Sprint">
                    <ItemTemplate>
                        Sprint <%# Eval("NumeroSprint") %>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Estado">
                    <ItemTemplate>
                        <%# Eval("Estado.Nombre") %>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:BoundField DataField="FechaInicio" HeaderText="Inicio" DataFormatString="{0:dd/MM/yyyy}" />
                <asp:BoundField DataField="FechaEstimadaFin" HeaderText="Fin Estimada" DataFormatString="{0:dd/MM/yyyy}" />

                <asp:TemplateField HeaderText="Área">
                    <ItemTemplate>
                        <%# Eval("Area.Nombre") %>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:CommandField ShowSelectButton="True" SelectText="Ver" HeaderText="Detalle" />
            </Columns>
        </asp:GridView>

    </asp:Panel>

    <asp:Panel ID="pnlListadoProyectos" runat="server">

        <div class="col-12 col-md-auto mb-4">
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
                        <a class="card text-decoration-none text-dark mb-3 shadow-sm"
                            href='<%# "Proyectos.aspx?id=" + Eval("Id") %>'>

                            <div class="card-body">
                                <h5 class="card-title"><%# Eval("Nombre") %></h5>
                                <p class="card-text"><%# Eval("Descripcion") %></p>
                                <p>Estado: <%# Eval("Estado.Nombre") %></p>
                                <p>Inicio: <%# Eval("FechaInicio", "{0:dd/MM/yyyy}") %></p>
                                <p>Final Esperado: <%# Eval("FechaEstimadaFin", "{0:dd/MM/yyyy}") %></p>
                                <asp:Label ID="lblFechaFin" runat="server" CssClass="d-block" Visible="false"></asp:Label>
                            </div>

                        </a>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
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
                            <asp:TextBox ID="txtFechaInicioProyecto" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvFechaInicioProyecto" runat="server" ControlToValidate="txtFechaInicioProyecto" ErrorMessage="La fecha de inicio es obligatoria." CssClass="text-danger text-validation-error" Display="Dynamic" ValidationGroup="vgProyecto" />
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
