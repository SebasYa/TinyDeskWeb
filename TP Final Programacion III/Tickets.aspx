<%@ Page Title="Gestión de Tickets" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Tickets.aspx.cs" Inherits="TP_Final_Programacion_III.Tickets" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-4">

        <asp:Literal ID="litMensaje" runat="server"></asp:Literal>
        <asp:HiddenField ID="hdnIdTicket" runat="server" />

        <!-- ========================================= -->
        <!-- LISTADO -->
        <!-- ========================================= -->

        <asp:Panel ID="pnlListado" runat="server">

            <div class="row">
                <div class="col-6">
                    <div class="mb-3">
                        <asp:TextBox runat="server" ID="txtFiltroTickets"
                            CssClass="form-control"
                            placeholder="Filtrar por descripción o proyecto"
                            AutoPostBack="true"
                            OnTextChanged="txtFiltroTickets_TextChanged" />
                    </div>
                </div>
                <div class="col-6 d-flex align-items-center flex-row-reverse">
                    <button type="button"
                        class="btn btn-primary shadow-sm d-flex align-items-center gap-2"
                        data-bs-toggle="modal"
                        data-bs-target="#ticketModal">
                        <i class="bi bi-plus-circle"></i>Crear Ticket
                    </button>
                </div>
            </div>

            <!-- MODAL NUEVO TICKET -->
            <div class="modal fade" id="ticketModal" tabindex="-1"
                aria-labelledby="ticketModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <div class="modal-header bg-light">
                            <h5 class="modal-title fw-bold" id="ticketModalLabel">Nuevo Ticket</h5>
                            <button type="button" class="btn-close"
                                data-bs-dismiss="modal" aria-label="Close">
                            </button>
                        </div>
                        <div class="modal-body">
                            <div class="row g-3">

                                <div class="col-12">
                                    <label class="form-label fw-semibold">Descripción</label>
                                    <asp:TextBox ID="txtDescripcion" runat="server"
                                        CssClass="form-control"
                                        TextMode="MultiLine" Rows="3" />
                                    <div class="invalid-feedback">
                                        La descripción es obligatoria.
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">Fecha Estimada Fin</label>
                                    <asp:TextBox ID="txtFechaEstimadaFin" runat="server"
                                        CssClass="form-control" TextMode="Date" />
                                    <div class="invalid-feedback">
                                        La fecha estimada de fin es obligatoria.
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <label class="form-label fw-semibold">Prioridad</label>
                                    <asp:DropDownList ID="ddlPrioridad" runat="server" CssClass="form-select">
                                        <asp:ListItem Text="Seleccione Prioridad..." Value="" />
                                    </asp:DropDownList>
                                    <div class="invalid-feedback">Debes elegir una Prioridad.</div>
                                </div>

                                <div class="col-md-4">
                                    <label class="form-label fw-semibold">Estado</label>
                                    <asp:DropDownList ID="ddlEstado" runat="server" CssClass="form-select">
                                        <asp:ListItem Text="Seleccione Estado..." Value="" />
                                    </asp:DropDownList>
                                    <div class="invalid-feedback">Debes elegir un Estado.</div>
                                </div>

                                <div class="col-md-4">
                                    <label class="form-label fw-semibold">Usuario</label>
                                    <asp:DropDownList ID="ddlUsuario" runat="server" CssClass="form-select">
                                        <asp:ListItem Text="Seleccione Usuario..." Value="" />
                                    </asp:DropDownList>
                                    <div class="invalid-feedback">Debes elegir un Usuario.</div>
                                </div>

                                <div class="col-md-4">
                                    <label class="form-label fw-semibold">Sprint</label>
                                    <asp:DropDownList ID="ddlSprint" runat="server" CssClass="form-select">
                                        <asp:ListItem Text="Seleccione Sprint..." Value="" />
                                    </asp:DropDownList>
                                    <div class="invalid-feedback">Debes elegir un Sprint.</div>
                                </div>

                            </div>
                        </div>
                        <div class="modal-footer bg-light">
                            <button type="button" class="btn btn-secondary"
                                data-bs-dismiss="modal">
                                Cancelar</button>
                            <asp:Button ID="btnGuardarTicket" runat="server"
                                CssClass="btn btn-primary"
                                Text="Guardar Ticket"
                                OnClick="btnGuardarTicket_Click" />
                        </div>
                    </div>
                </div>
            </div>
            <!-- FIN MODAL NUEVO -->

            <!-- GRILLA -->
            <asp:GridView ID="dgvTickets" runat="server"
                DataKeyNames="Id"
                CssClass="table table-hover align-middle bg-white border-0 shadow-sm rounded mb-0"
                AutoGenerateColumns="false"
                OnSelectedIndexChanged="dgvTickets_SelectedIndexChanged"
                OnPageIndexChanging="dgvTickets_PageIndexChanging"
                OnRowCommand="dgvTickets_RowCommand"
                AllowPaging="true" PageSize="10" GridLines="None">

                <HeaderStyle CssClass="table-light text-secondary fw-semibold border-bottom" />

                <Columns>

                    <asp:TemplateField HeaderText="Ticket">
                        <ItemTemplate>
                            <span class="text-dark fw-bold">TK-<%# Eval("Id").ToString().PadLeft(3, '0') %>
                            </span>
                            <div class="text-muted small"><%# Eval("Descripcion") %></div>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Estado">
                        <ItemTemplate>
                            <span class='<%# GetClassEtiquetaEstado(Eval("Estado.Nombre")) %>'>
                                <%# Eval("Estado.Nombre") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Prioridad">
                        <ItemTemplate>
                            <span class='<%# GetClassEtiquetaPrioridad(Eval("Prioridad.Nombre")) %>'>
                                <%# Eval("Prioridad.Nombre") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Sprint / Proyecto">
                        <ItemTemplate>
                            <div class="fw-semibold text-dark text-sm">
                                <%# Eval("Sprint.Proyecto.Nombre") %>
                            </div>
                            <span class="badge bg-secondary-subtle text-secondary rounded-pill font-monospace"
                                style="font-size: 0.75rem;">Sprint <%# Eval("Sprint.NumeroSprint") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Asignado a">
                        <ItemTemplate>
                            <div class="d-flex align-items-center">
                                <i class="bi bi-person text-muted me-2"></i>
                                <span class="text-dark fw-medium text-sm">
                                    <%# Eval("Usuario.Nombre") %> <%# Eval("Usuario.Apellido") %>
                                </span>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Fecha Est. Fin" ItemStyle-Width="120px">
                        <ItemTemplate>
                            <span class="text-muted small">
                                <%# Convert.ToDateTime(Eval("FechaEstimadaFin")).ToString("dd/MM/yyyy") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Editar">
                        <ItemTemplate>
                            <asp:LinkButton ID="btnEditarTicket" runat="server"
                                CommandName="AbrirEditar"
                                CommandArgument='<%# Eval("Id") %>'
                                CssClass="btn btn-link text-muted p-0 lh-1"
                                title="Editar Ticket">
                            <i class="bi bi-pencil me-2 text-muted"></i>
                            </asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="Ver">
                        <ItemTemplate>
                            <asp:LinkButton ID="btnVerTicket" runat="server"
                                CommandName="VerDetalle"
                                CommandArgument='<%# Eval("Id") %>'
                                CssClass="btn btn-link text-muted p-0 lh-1"
                                title="Ver Ticket">
                            <i class="bi bi-eye me-2 text-primary"></i>
                            </asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>

                </Columns>
            </asp:GridView>

        </asp:Panel>
        <!-- FIN PANEL LISTADO -->

        <!-- ========================================= -->
        <!-- DETALLE -->
        <!-- ========================================= -->

        <asp:Panel ID="pnlDetalle" runat="server" Visible="false">

            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="mb-1 fw-bold text-dark">
                        <asp:Label ID="lblDetalleTituloTicket" runat="server" Text="Detalle de Ticket"></asp:Label>
                    </h2>
                    <span class="badge bg-primary-subtle text-primary px-3 py-2 rounded-pill fw-semibold">
                        <asp:Label ID="lblTicketSprintProyecto" runat="server" Text="Sprint / Proyecto"></asp:Label>
                    </span>
                </div>
                <div class="d-flex gap-2">
                    <a href="Tickets.aspx" class="btn btn-primary d-flex align-items-center gap-2">
                        <i class="bi bi-arrow-left"></i>Volver al listado
                    </a>
                </div>
            </div>

            <div class="card border-0 shadow-sm mb-5"
                style="border-radius: 12px; border: 1px solid #f0f2f5 !important;">
                <div class="card-body p-4">
                    <h5 class="fw-bold text-dark mb-4">Información del Ticket</h5>
                    <div class="row g-3">

                        <div class="col-6 col-md-3">
                            <span class="text-uppercase text-muted fw-semibold d-block"
                                style="font-size: 0.75rem; letter-spacing: 0.5px;">Descripción</span>
                            <strong class="text-dark fs-6">
                                <asp:Label ID="lblDetalleDescripcion" runat="server"></asp:Label>
                            </strong>
                        </div>

                        <div class="col-6 col-md-3">
                            <span class="text-uppercase text-muted fw-semibold d-block"
                                style="font-size: 0.75rem; letter-spacing: 0.5px;">Estado</span>
                            <asp:Label ID="lblDetalleEstado" runat="server"
                                CssClass="badge text-uppercase border px-2"></asp:Label>
                        </div>

                        <div class="col-6 col-md-3">
                            <span class="text-uppercase text-muted fw-semibold d-block"
                                style="font-size: 0.75rem; letter-spacing: 0.5px;">Prioridad</span>
                            <asp:Label ID="lblDetallePrioridad" runat="server"
                                CssClass="badge text-uppercase border px-2"></asp:Label>
                        </div>

                        <div class="col-6 col-md-3">
                            <span class="text-uppercase text-muted fw-semibold d-block"
                                style="font-size: 0.75rem; letter-spacing: 0.5px;">Asignado a</span>
                            <strong class="text-dark fs-6">
                                <asp:Label ID="lblDetalleUsuario" runat="server"></asp:Label>
                            </strong>
                        </div>

                        <div class="col-6 col-md-3">
                            <span class="text-uppercase text-muted fw-semibold d-block"
                                style="font-size: 0.75rem; letter-spacing: 0.5px;">Fecha Inicio</span>
                            <strong class="text-dark fs-6">
                                <asp:Label ID="lblDetalleFechaInicio" runat="server"></asp:Label>
                            </strong>
                        </div>

                        <div class="col-6 col-md-3">
                            <span class="text-uppercase text-muted fw-semibold d-block"
                                style="font-size: 0.75rem; letter-spacing: 0.5px;">Fecha Estimada Fin</span>
                            <strong class="text-dark fs-6">
                                <asp:Label ID="lblDetalleFechaEstimadaFin" runat="server"></asp:Label>
                            </strong>
                        </div>

                        <div class="col-6 col-md-3">
                            <span class="text-uppercase text-muted fw-semibold d-block"
                                style="font-size: 0.75rem; letter-spacing: 0.5px;">Fecha Fin Real</span>
                            <strong class="text-dark fs-6">
                                <asp:Label ID="lblDetalleFechaFin" runat="server" Text="-"></asp:Label>
                            </strong>
                        </div>

                        <div class="col-6 col-md-3">
                            <span class="text-uppercase text-muted fw-semibold d-block"
                                style="font-size: 0.75rem; letter-spacing: 0.5px;">Sprint</span>
                            <strong class="text-dark fs-6">
                                <asp:Label ID="lblDetalleSprint" runat="server"></asp:Label>
                            </strong>
                        </div>

                        <div class="col-6 col-md-3">
                            <span class="text-uppercase text-muted fw-semibold d-block"
                                style="font-size: 0.75rem; letter-spacing: 0.5px;">Proyecto</span>
                            <strong class="text-dark fs-6">
                                <asp:Label ID="lblDetalleProyecto" runat="server"></asp:Label>
                            </strong>
                        </div>

                    </div>

                    <div class="mt-4">
                        <button type="button" class="btn btn-warning d-flex align-items-center gap-2"
                            data-bs-toggle="modal" data-bs-target="#ticketEditarModal">
                            <i class="bi bi-pencil"></i>Editar Ticket
                        </button>
                    </div>

                </div>
            </div>

        </asp:Panel>
        <!-- FIN PANEL DETALLE -->

        <!-- ========================================= -->
        <!-- MODAL EDITAR TICKET (fuera de los paneles) -->
        <!-- ========================================= -->
        <div class="modal fade" id="ticketEditarModal" tabindex="-1"
            aria-labelledby="ticketEditarModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header bg-light">
                        <h5 class="modal-title fw-bold" id="ticketEditarModalLabel">
                            <asp:Label ID="lblModalEditarTitulo" runat="server" Text="Editar Ticket"></asp:Label>
                        </h5>
                        <button type="button" class="btn-close"
                            data-bs-dismiss="modal" aria-label="Close">
                        </button>
                    </div>
                    <div class="modal-body">
                        <div class="row g-3">

                            <div class="col-12">
                                <label class="form-label fw-semibold">Descripción</label>
                                <asp:TextBox ID="txtEditDescripcion" runat="server"
                                    CssClass="form-control"
                                    TextMode="MultiLine" Rows="3" />
                                <div class="invalid-feedback">La descripción es obligatoria.</div>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Fecha Estimada Fin</label>
                                <asp:TextBox ID="txtEditFechaEstimadaFin" runat="server"
                                    CssClass="form-control" TextMode="Date" />
                                <div class="invalid-feedback">La fecha estimada de fin es obligatoria.</div>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label fw-semibold">Prioridad</label>
                                <asp:DropDownList ID="ddlEditPrioridad" runat="server" CssClass="form-select">
                                    <asp:ListItem Text="Seleccione Prioridad..." Value="" />
                                </asp:DropDownList>
                                <div class="invalid-feedback">Debes elegir una Prioridad.</div>
                            </div>

                            <div class="col-md-4">
                                <label class="form-label fw-semibold">Estado</label>
                                <asp:DropDownList ID="ddlEditEstado" runat="server" CssClass="form-select">
                                    <asp:ListItem Text="Seleccione Estado..." Value="" />
                                </asp:DropDownList>
                                <div class="invalid-feedback">Debes elegir un Estado.</div>
                            </div>

                            <div class="col-md-4">
                                <label class="form-label fw-semibold">Usuario</label>
                                <asp:DropDownList ID="ddlEditUsuario" runat="server" CssClass="form-select">
                                    <asp:ListItem Text="Seleccione Usuario..." Value="" />
                                </asp:DropDownList>
                                <div class="invalid-feedback">Debes elegir un Usuario.</div>
                            </div>

                            <div class="col-md-4">
                                <label class="form-label fw-semibold">Sprint</label>
                                <asp:DropDownList ID="ddlEditSprint" runat="server" CssClass="form-select">
                                    <asp:ListItem Text="Seleccione Sprint..." Value="" />
                                </asp:DropDownList>
                                <div class="invalid-feedback">Debes elegir un Sprint.</div>
                            </div>

                        </div>
                    </div>
                    <div class="modal-footer bg-light">
                        <button type="button" class="btn btn-secondary"
                            data-bs-dismiss="modal">
                            Cancelar</button>
                        <asp:Button ID="btnBajaLogica" runat="server"
                            CssClass="btn btn-danger"
                            Text="Desactivar Ticket"
                            OnClick="btnBajaLogica_Click" />
                        <asp:Button ID="btnGuardarEdicion" runat="server"
                            CssClass="btn btn-primary"
                            Text="Guardar Cambios"
                            OnClick="btnGuardarEdicion_Click" />
                    </div>
                </div>
            </div>
        </div>
        <!-- FIN MODAL EDITAR -->

    </div>
</asp:Content>
