<%@ Page Title="Usuarios" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Usuarios.aspx.cs" Inherits="TP_Final_Programacion_III.Usuarios" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1 class="h2 text-dark font-weight-bold">Gestión de Usuarios</h1>
            <a href="CrearUsuario.aspx" class="btn btn-success d-flex align-items-center gap-2 shadow-sm">Crear Usuario
            </a>
        </div>
        <asp:Panel ID="pnlFiltroSimple" runat="server" CssClass="card border-0 shadow-sm mb-3" DefaultButton="btnBuscarUsuario">
            <div class="card-body">
                <div class="row g-3 align-items-end">

                    <div class="col-12 col-lg-7">
                        <label for="txtFiltroSimple" class="form-label fw-semibold">
                            Buscar usuario
                        </label>

                        <div class="input-group">
                            <span class="input-group-text bg-white">
                                <i class="bi bi-search text-muted"></i>
                            </span>

                            <asp:TextBox
                                ID="txtFiltroSimple"
                                runat="server"
                                CssClass="form-control"
                                placeholder="Buscar..." />
                        </div>
                    </div>

                    <div class="col-12 col-lg-2">
                        <div class="form-check form-switch ps-5 fs-6 mb-2">
                            <input
                                class="form-check-input"
                                type="checkbox"
                                id="chkFiltroAvanzado"
                                runat="server"
                                clientidmode="Static"
                                onserverchange="chkFiltroAvanzado_ServerChange"
                                onchange="this.form.submit();" />

                            <label class="form-check-label fw-semibold ps-2" for="chkFiltroAvanzado">
                                Filtro avanzado
                            </label>
                        </div>
                    </div>

                    <div class="col-12 col-lg-3 d-flex gap-2 justify-content-lg-end">
                        <asp:Button
                            ID="btnBuscarUsuario"
                            runat="server"
                            Text="Buscar"
                            CssClass="btn btn-primary px-4"
                            OnClick="btnBuscarUsuario_Click" />

                        <asp:Button
                            ID="btnLimpiarFiltro"
                            runat="server"
                            Text="Limpiar"
                            CssClass="btn btn-outline-secondary px-4"
                            OnClick="btnLimpiarFiltro_Click" />
                    </div>

                </div>
            </div>
        </asp:Panel>

        <asp:Panel ID="pnlFiltroAvanzado" runat="server" Visible="false" CssClass="card border-0 shadow-sm mb-3">
            <div class="card-body">
                <h5 class="text-primary border-bottom pb-2 mb-3">
                    <i class="bi bi-funnel-fill me-2"></i>Filtro avanzado
                </h5>

                <div class="row g-3">
                    <div class="col-12 col-md-4">
                        <label for="ddlFiltroArea" class="form-label fw-semibold">Área</label>
                        <asp:DropDownList ID="ddlFiltroArea" runat="server" CssClass="form-select"></asp:DropDownList>
                    </div>

                    <div class="col-12 col-md-4">
                        <label for="ddlFiltroPuesto" class="form-label fw-semibold">Puesto</label>
                        <asp:DropDownList ID="ddlFiltroPuesto" runat="server" CssClass="form-select"></asp:DropDownList>
                    </div>

                    <div class="col-12 col-md-4">
                        <label for="ddlFiltroSeniority" class="form-label fw-semibold">Seniority</label>
                        <asp:DropDownList ID="ddlFiltroSeniority" runat="server" CssClass="form-select"></asp:DropDownList>
                    </div>

                    <div class="col-12 col-md-4">
                        <label for="ddlFiltroEstado" class="form-label fw-semibold">Estado</label>
                        <asp:DropDownList ID="ddlFiltroEstado" runat="server" CssClass="form-select">
                            <asp:ListItem Text="Todos" Value="-1" />
                            <asp:ListItem Text="Activos" Value="1" />
                            <asp:ListItem Text="Inactivos" Value="0" />
                        </asp:DropDownList>
                    </div>

                    <div class="col-12 col-md-4">
                        <label for="ddlFiltroPermiso" class="form-label fw-semibold">Permiso</label>
                        <asp:DropDownList ID="ddlFiltroPermiso" runat="server" CssClass="form-select">
                            <asp:ListItem Text="Todos" Value="" />
                            <asp:ListItem Text="Administrador" Value="admin" />
                            <asp:ListItem Text="Gestión habilitada" Value="gestion" />
                            <asp:ListItem Text="Solo lectura" Value="lectura" />
                        </asp:DropDownList>
                    </div>

                    <div class="col-12 col-md-4 d-flex align-items-end gap-2 justify-content-md-end">
                        <asp:Button
                            ID="btnAplicarFiltroAvanzado"
                            runat="server"
                            Text="Aplicar"
                            CssClass="btn btn-primary px-4"
                            OnClick="btnAplicarFiltroAvanzado_Click" />

                        <asp:Button
                            ID="btnLimpiarFiltroAvanzado"
                            runat="server"
                            Text="Limpiar"
                            CssClass="btn btn-outline-secondary px-4"
                            OnClick="btnLimpiarFiltroAvanzado_Click" />
                    </div>
                </div>
            </div>
        </asp:Panel>

        <div class="table-responsive">
            <asp:ListView
                ID="lvUsuarios"
                runat="server"
                ItemPlaceholderID="itemPlaceholder"
                OnPagePropertiesChanging="lvUsuarios_PagePropertiesChanging">

                <LayoutTemplate>
                    <table class="table table-striped table-bordered shadow-sm align-middle">
                        <thead>
                            <tr>
                                <th>Apellido</th>
                                <th>Nombre</th>
                                <th>Usuario</th>
                                <th>Correo Electrónico</th>
                                <th>Área</th>
                                <th>Puesto</th>
                                <th>Seniority</th>
                                <th>Permiso</th>
                                <th>Activo</th>
                                <th>Invitación</th>
                                <th>Editar</th>
                            </tr>
                        </thead>

                        <tbody>
                            <asp:PlaceHolder
                                ID="itemPlaceholder"
                                runat="server" />
                        </tbody>
                    </table>
                </LayoutTemplate>

                <ItemTemplate>
                    <tr>
                        <td><%# Eval("Apellido") %></td>

                        <td><%# Eval("Nombre") %></td>

                        <td><%# Eval("NombreUsuario") %></td>

                        <td><%# Eval("Email") %></td>

                        <td><%# Eval("Area.Nombre") %></td>

                        <td><%# Eval("Puesto.Nombre") %></td>

                        <td><%# Eval("Seniority.Nombre") %></td>

                        <td>
                            <asp:Literal
                                ID="litPermisoUsuario"
                                runat="server"
                                Mode="PassThrough"
                                Text='<%# ObtenerIconoPermiso(Eval("EsAdmin"), Eval("PermisoEscritura")) %>'>
                            </asp:Literal>
                        </td>

                        <td>
                            <span
                                class='<%# (bool)Eval("Activo") ? "text-success" : "text-danger" %>'
                                title='<%# (bool)Eval("Activo") ? "Usuario activo" : "Usuario inactivo" %>'>

                                <i class='<%# (bool)Eval("Activo") ? "bi bi-check-circle-fill" : "bi bi-x-circle-fill" %>'></i>
                            </span>
                        </td>

                        <td>
                            <asp:Literal
                                ID="litInvitacion"
                                runat="server"
                                Mode="PassThrough"
                                Text='<%# ObtenerIconoInvitacion(Eval("Id"), Eval("EmailVerificado")) %>'>
                            </asp:Literal>
                        </td>

                        <td>
                            <asp:LinkButton
                                ID="btnEditarUsuario"
                                runat="server"
                                CssClass="btn btn-link text-muted p-0 lh-1"
                                CommandArgument='<%# Eval("Id") %>'
                                CausesValidation="false"
                                OnClick="btnEditarUsuario_Click">

                        <i class="bi bi-pencil text-muted"></i>
                            </asp:LinkButton>
                        </td>
                    </tr>
                </ItemTemplate>

                <EmptyDataTemplate>
                    <div class="alert alert-info">
                        No hay usuarios para mostrar.
                    </div>
                </EmptyDataTemplate>

            </asp:ListView>
        </div>

        <div class="d-flex justify-content-center mt-4">
            <asp:DataPager
                ID="dpUsuarios"
                runat="server"
                PagedControlID="lvUsuarios"
                PageSize="10">

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
</asp:Content>
