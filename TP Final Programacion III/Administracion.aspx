<%@ Page Title="Administración" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Administracion.aspx.cs" Inherits="TP_Final_Programacion_III.Administracion" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">

    <style>
        .admin-tabs {
            display: inline-flex;
            gap: 4px;
            padding: 5px;
            background: #f1f3f5;
            border: 1px solid #dee2e6;
            border-radius: 12px;
        }

            .admin-tabs .btn {
                border: 0;
                border-radius: 9px;
                color: #495057;
                font-weight: 600;
                padding: .55rem .85rem;
            }

                .admin-tabs .btn.active {
                    background: #212529;
                    color: #fff;
                }

        .admin-action {
            width: 34px;
            height: 34px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 8px;
            text-decoration: none;
        }
    </style>

    <asp:HiddenField ID="hfTipoActual" runat="server" Value="1" />

    <div class="container mt-4">
        <asp:Literal ID="litMensaje" runat="server"></asp:Literal>

        <div class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-3">
            <div class="admin-tabs">
                <asp:LinkButton ID="btnArea" runat="server" OnClick="btnArea_Click">
                    <i class="bi bi-diagram-3 me-1"></i>Area
                </asp:LinkButton>

                <asp:LinkButton ID="btnEstado" runat="server" OnClick="btnEstado_Click">
                    <i class="bi bi-check2-circle me-1"></i>Estado
                </asp:LinkButton>

                <asp:LinkButton ID="btnPuesto" runat="server" OnClick="btnPuesto_Click">
                    <i class="bi bi-person-badge me-1"></i>Puestos
                </asp:LinkButton>
            </div>

            <span class="badge bg-dark-subtle text-dark rounded-pill px-3 py-2">
                <asp:Label ID="lblCantidad" runat="server"></asp:Label>
            </span>
        </div>

        <div class="row">
            <div class="col-6">
                <div class="mb-3">
                    <asp:TextBox ID="txtFiltro" runat="server" CssClass="form-control" AutoPostBack="true" OnTextChanged="txtFiltro_TextChanged" />
                </div>
            </div>

            <div class="col-6 d-flex align-items-center flex-row-reverse">
                <asp:LinkButton ID="btnNuevo" runat="server" CssClass="btn btn-primary shadow-sm d-flex align-items-center gap-2" OnClick="btnNuevo_Click">
                    <i class="bi bi-plus-circle"></i>
                    <asp:Literal ID="litCrearTexto" runat="server"></asp:Literal>
                </asp:LinkButton>
            </div>
        </div>

        <asp:GridView ID="dgvCatalogo" runat="server"
            DataKeyNames="Id"
            CssClass="table table-hover align-middle bg-white border-0 shadow-sm rounded mb-0"
            AutoGenerateColumns="false"
            AllowPaging="True"
            PageSize="10"
            GridLines="None"
            OnRowCommand="dgvCatalogo_RowCommand"
            OnPageIndexChanging="dgvCatalogo_PageIndexChanging">

            <HeaderStyle CssClass="table-light text-secondary fw-semibold border-bottom" />

            <Columns>
                <asp:TemplateField HeaderText="Nombre">
                    <ItemTemplate>
                        <div class="fw-bold text-dark"><%# Eval("Nombre") %></div>
                        <small class="text-muted"><%# GetTipoTexto() %></small>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Origen">
                    <ItemTemplate>
                        <span class='<%# GetOrigenClass(Container.DataItem) %>'>
                            <%# GetOrigenTexto(Container.DataItem) %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Finaliza">
                    <ItemTemplate>
                        <span class='<%# GetEstadoFinalClass(Container.DataItem) %>'>
                            <%# GetEstadoFinalTexto(Container.DataItem) %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Acciones">
                    <ItemTemplate>
                        <asp:LinkButton ID="btnEditar" runat="server"
                            CommandName="EditarRegistro"
                            CommandArgument='<%# Eval("Id") %>'
                            Enabled='<%# PuedeEditarEliminar(Container.DataItem) %>'
                            CssClass='<%# GetBotonAccionClass(Container.DataItem, "edit") %>'>
                            <i class="bi bi-pencil"></i>
                        </asp:LinkButton>

                        <asp:LinkButton ID="btnEliminar" runat="server"
                            CommandName="EliminarRegistro"
                            CommandArgument='<%# Eval("Id") %>'
                            Enabled='<%# PuedeEditarEliminar(Container.DataItem) %>'
                            CssClass='<%# GetBotonAccionClass(Container.DataItem, "delete") %>'>
                            <i class="bi bi-trash"></i>
                        </asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </div>

    <div class="modal fade" id="adminModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-light">
                    <h5 class="modal-title fw-bold">
                        <asp:Label ID="lblModalTitulo" runat="server"></asp:Label>
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>

                <div class="modal-body">
                    <asp:HiddenField ID="hdnRegistroId" runat="server" />

                    <div class="mb-3">
                        <asp:Label runat="server" AssociatedControlID="txtNombre" CssClass="form-label fw-semibold" Text="Nombre"></asp:Label>
                        <asp:TextBox ID="txtNombre" runat="server" CssClass="form-control" MaxLength="50"></asp:TextBox>
                        <asp:Label ID="lblErrorModal" runat="server" CssClass="text-danger small mt-1 d-block" Visible="false"></asp:Label>
                    </div>

                    <div id="pnlEstadoExtra" runat="server" class="mt-3">
                        <div class="form-check form-switch ps-5 fs-6">
                            <input id="chkEsFinal" runat="server" type="checkbox" class="form-check-input" />
                            <label class="form-check-label fw-semibold ps-2" for="chkEsFinal">
                                Estado final
                            </label>
                        </div>
                    </div>
                </div>

                <div class="modal-footer bg-light">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <asp:Button ID="btnGuardar" runat="server" CssClass="btn btn-primary" Text="Guardar" OnClick="btnGuardar_Click" />
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="eliminarModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content border-danger">
                <div class="modal-header bg-danger-subtle">
                    <h5 class="modal-title fw-bold text-danger">Eliminar registro</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>

                <div class="modal-body">
                    <asp:HiddenField ID="hdnEliminarId" runat="server" />
                    <asp:HiddenField ID="hdnEliminarNombre" runat="server" />

                    <p class="mb-2">
                        Vas a eliminar <strong>
                            <asp:Label ID="lblEliminarNombre" runat="server"></asp:Label></strong>.
                    </p>

                    <p class="text-muted small mb-3">
                        Para confirmar, escribí el nombre en mayúscula:
                        <strong>
                            <asp:Literal ID="litNombreConfirmacion" runat="server"></asp:Literal></strong>
                    </p>

                    <asp:TextBox ID="txtConfirmarEliminar" runat="server" CssClass="form-control" autocomplete="off"></asp:TextBox>
                    <asp:Label ID="lblErrorEliminar" runat="server" CssClass="text-danger small mt-1 d-block" Visible="false"></asp:Label>
                </div>

                <div class="modal-footer bg-light">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                    <asp:Button ID="btnConfirmarEliminar" runat="server" CssClass="btn btn-danger" Text="Eliminar" OnClick="btnConfirmarEliminar_Click" />
                </div>
            </div>
        </div>
    </div>

</asp:Content>
