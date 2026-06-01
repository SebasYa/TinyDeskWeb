<%@ Page Title="" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Sprints.aspx.cs" Inherits="TP_Final_Programacion_III.Sprints" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
        <div class="container mt-4">
        <asp:Literal ID="litMensaje" runat="server"></asp:Literal>
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h1 class="h2 text-dark fw-bold">Sprints</h1>
            
            <button type="button" class="btn btn-primary shadow-sm d-flex align-items-center gap-2" data-bs-toggle="modal" data-bs-target="#sprintModal">
                <i class="bi bi-plus-circle"></i> Crear Sprint
            </button>
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
                                <asp:DropDownList ID="ddlProyecto" runat="server" CssClass="form-select" required="required">
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
     CssClass="table" AutoGenerateColumns="false"
     OnSelectedIndexChanged="dgvSprints_SelectedIndexChanged"
     OnPageIndexChanging="dgvSprints_PageIndexChanging"
     AllowPaging="True" PageSize="5">
<Columns>
    <asp:BoundField HeaderText="Numero Sprint" DataField="NumeroSprint" />
    <asp:BoundField HeaderText="Inicio" DataField="FechaInicio" />
    <asp:BoundField HeaderText="Fin" DataField="FechaEstimadaFin" />
    <asp:BoundField HeaderText="Finalizado" DataField="FechaFin" />
    <asp:BoundField HeaderText="Proyecto" DataField="Proyecto" />
    <asp:BoundField HeaderText="Area" DataField="Area" />
    <asp:BoundField HeaderText="Estado" DataField="Estado" />
    <asp:CheckBoxField HeaderText="Activo" DataField="Activo" />
    <asp:CommandField HeaderText="Editar" ShowSelectButton="true" SelectText="✍" />
</Columns>
</asp:GridView>

    </div>
</asp:Content>
