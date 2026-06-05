<%@ Page Title="Gestión de Sprints" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Sprints.aspx.cs" Inherits="TP_Final_Programacion_III.Sprints" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
        <div class="container mt-4">
        <asp:Literal ID="litMensaje" runat="server"></asp:Literal>
       
        <div class="row">
            <div class="col-6">
                <div class="mb-3">
                    <!--<asp:Label Text="Filtrar" runat="server" />-->
                    <asp:TextBox runat="server" ID="txtFiltroSprints" CssClass="form-control" placeholder="Filtrar por Proyecto" AutoPostBack="true" OnTextChanged="txtFiltroSprints_TextChanged" />
                </div>
            </div>
   
            <div class="col-6 d-flex align-items-center flex-row-reverse">
                <button type="button" class="btn btn-primary shadow-sm d-flex align-items-center gap-2" data-bs-toggle="modal" data-bs-target="#sprintModal">
                    <i class="bi bi-plus-circle"></i> Crear Sprint
                </button>
            </div>
            
        </div>

        <div class="modal fade" id="sprintModal" tabindex="-1" aria-labelledby="sprintModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg"> <div class="modal-content">
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
                                <asp:DropDownList ID="ddlProyecto" runat="server" CssClass="form-select" >
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
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                        <asp:Button ID="btnGuardarSprint" runat="server" CssClass="btn btn-primary" Text="Guardar Sprint" OnClick="btnGuardarSprint_Click" />
                    </div>
                </div>
            </div>
        </div>
        <!-- FIN MODAL -->
        <!-- INICIO GRIDVIEW -->

    <asp:GridView ID="dgvSprints" runat="server" DataKeyNames="Id"
        CssClass="table table-hover align-middle bg-white border-0 shadow-sm rounded mb-0" 
        AutoGenerateColumns="false"
        OnSelectedIndexChanged="dgvSprints_SelectedIndexChanged"
        OnPageIndexChanging="dgvSprints_PageIndexChanging"
        AllowPaging="True" PageSize="10" GridLines="None">
    
        <HeaderStyle CssClass="table-light text-secondary fw-semibold border-bottom" />
    
        <Columns>
        
            <asp:TemplateField HeaderText="Sprint">
                <ItemTemplate>
                    <span class="text-dark fw-bold">Sprint <%# Eval("NumeroSprint") %></span>
                </ItemTemplate>
            </asp:TemplateField>

            <asp:TemplateField HeaderText="Estado">
                <ItemTemplate>
                    <span class='<%# GetClassEtiquetaEstado(Eval("Estado.Nombre")) %>'>
                        <%# Eval("Estado.Nombre") %>
                    </span>
                </ItemTemplate>
            </asp:TemplateField>

            <asp:TemplateField HeaderText="Fechas">
                <ItemTemplate>
                    <div class="text-dark small fw-medium">
                        <%# Convert.ToDateTime(Eval("FechaInicio")).ToString("dd/MM/yyyy") %> - 
                        <%# Convert.ToDateTime(Eval("FechaEstimadaFin")).ToString("dd/MM/yyyy") %>
                    </div>
                    <small class="text-muted text-xs d-block">
                        <%# GetDiasRestantesTexto(Eval("FechaEstimadaFin"), Eval("Estado.EsFinal")) %>
                    </small>
                </ItemTemplate>
            </asp:TemplateField>

            <asp:TemplateField HeaderText="Progreso" ItemStyle-Width="150px">
                <ItemTemplate>
                    <div class="d-flex flex-column">
                        <span class="small fw-bold text-dark mb-1"><%# Eval("Progreso") %>%</span>
                        <div class="progress" style="height: 6px;">
                            <div class='<%# GetClassBarraProgreso(Eval("Estado.Nombre")) %>' 
                                 role="progressbar" 
                                 style='width: <%# Eval("Progreso") %>%;' 
                                 aria-valuenow='<%# Eval("Progreso") %>' 
                                 aria-valuemin="0" 
                                 aria-valuemax="100">
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:TemplateField>

            <asp:TemplateField HeaderText="Proyecto / Área">
                <ItemTemplate>
                    <div class="fw-semibold text-dark text-sm"><%# Eval("Proyecto.Nombre") %></div>
                    <span class="badge bg-secondary-subtle text-secondary rounded-pill font-monospace" style="font-size: 0.75rem;"><%# Eval("Area.Nombre") %></span>
                </ItemTemplate>
            </asp:TemplateField>

            <asp:TemplateField HeaderText="Editar">
                <ItemTemplate>
                    <div class="fw-semibold text-dark text-sm">
                        <asp:LinkButton ID="btnEditarSprint" runat="server" CommandName="Select" CssClass="btn btn-link text-muted p-0 lh-1" title="Editar Sprint">
                            <i class="bi bi-pencil me-2 text-muted"></i>
                        </asp:LinkButton>
                    </div>
                </ItemTemplate>
            </asp:TemplateField>

        </Columns>
    </asp:GridView>

    <!--  ARRANCA MODAL EDITAR SPRINT -->
    <div class="modal fade" id="sprintEditarModal" tabindex="-1" aria-labelledby="sprintEditarModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg"> <div class="modal-content">
                    <div class="modal-header bg-light">
                        <h5 class="modal-title fw-bold" id="sprintEditarModalLabel">
                            <asp:Label ID="lblModalEditarTitulo" runat="server" Text="Editar Sprint"></asp:Label>
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <asp:Panel ID="pnlFormEditSprint" CssClass="row g-3" runat="server">



                            <div class="col-md-4">
                                <label for="txtEditFechaInicio" class="form-label fw-semibold">Fecha Inicio</label>
                                <asp:TextBox ID="txtEditFechaInicio" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                            </div>

                            <div class="col-md-4">
                                <label for="txtEditFechaEstimadaFin" class="form-label fw-semibold">Fecha Estimada Fin</label>
                                <asp:TextBox ID="txtEditFechaEstimadaFin" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                            </div>

                            <div class="col-md-4">
                                <label for="txtEditFechaFin" class="form-label fw-semibold">Fecha Fin</label>
                                <asp:TextBox ID="txtEditFechaFin" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                            </div>

                            <div class="col-md-4">
                                <label for="ddlEditProyecto" class="form-label fw-semibold">Proyecto</label>
                                <asp:DropDownList ID="ddlEditProyecto" runat="server" CssClass="form-select" >
                                    <asp:ListItem Text="Seleccione Proyecto..." Value="" />
                                </asp:DropDownList>
                            </div>

                            <div class="col-md-4">
                                <label for="ddlEditEstado" class="form-label fw-semibold">Estado</label>
                                <asp:DropDownList ID="ddlEditEstado" runat="server" CssClass="form-select">
                                    <asp:ListItem Text="Seleccione Estado..." Value="" />
                                </asp:DropDownList>
                            </div>

                            <div class="col-md-4">
                                <label for="ddlEditArea" class="form-label fw-semibold">Área</label>
                                <asp:DropDownList ID="ddlEditArea" runat="server" CssClass="form-select">
                                    <asp:ListItem Text="Seleccione Área..." Value="" />
                                </asp:DropDownList>
                            </div>

                        </asp:Panel>
                    </div>
                    <div class="modal-footer bg-light">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                        <asp:Button ID="btnEliminar" runat="server" CssClass="btn btn-danger" Text="Eliminar Sprint" onClick="btnEliminar_Click"/>
                        <asp:Button ID="btnGuardarEdicion" runat="server" CssClass="btn btn-primary" Text="Guardar Sprint" OnClick="btnGuardarEdicion_Click" />
                    </div>
                </div>
            </div>
      </div>

    </div>
</asp:Content>
