<%@ Page Title="Dashboard" Language="C#" MasterPageFile="~/UsuarioSite.Master" AutoEventWireup="true" CodeBehind="UsuarioDefault.aspx.cs" Inherits="TP_Final_Programacion_III.UsuarioDefault" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

    <asp:Literal ID="litMensaje" runat="server"></asp:Literal>

    <section class="mb-4">
        <div class="card shadow-sm border-0">
            <div class="card-body">
                <h2 class="mb-3">
                    <asp:Label ID="lblBienvenida" runat="server"></asp:Label>
                </h2>

                <div class="row g-3">
                    <div class="col-12 col-md-4">
                        <div class="border rounded p-3 h-100">
                            <div class="text-muted small text-uppercase">Area</div>
                            <div class="fw-semibold">
                                <asp:Label ID="lblAreaUsuario" runat="server"></asp:Label>
                            </div>
                        </div>
                    </div>

                    <div class="col-12 col-md-4">
                        <div class="border rounded p-3 h-100">
                            <div class="text-muted small text-uppercase">Rol</div>
                            <div class="fw-semibold">
                                <asp:Label ID="lblRolUsuario" runat="server"></asp:Label>
                            </div>
                        </div>
                    </div>

                    <div class="col-12 col-md-4">
                        <div class="border rounded p-3 h-100">
                            <div class="text-muted small text-uppercase">Seniority</div>
                            <div class="fw-semibold">
                                <asp:Label ID="lblSeniorityUsuario" runat="server"></asp:Label>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
    <section>
    <div class="row g-4">

        <div class="col-12 col-md-4">
            <asp:Panel ID="pnlMisTicketsVencidos" runat="server" CssClass="card border-0 shadow-sm h-100" Style="border-radius: 12px;">
                <div class="card-body p-4">

                    <div class="d-flex justify-content-between align-items-start">
                        <div>
                            <span class="text-muted fw-semibold small">Mis tickets vencidos</span>

                            <h2 class="fw-bold text-dark display-5 my-2">
                                <asp:Label ID="lblMisTicketsVencidos" runat="server"></asp:Label>
                            </h2>

                            <span class="small text-muted">Tareas que requieren atención.</span>
                        </div>

                        <div class="text-danger bg-danger-subtle rounded-3 p-2 d-flex align-items-center justify-content-center" style="width: 48px; height: 48px;">
                            <i class="bi bi-exclamation-triangle-fill fs-3"></i>
                        </div>
                    </div>

                </div>
            </asp:Panel>
        </div>

        <div class="col-12 col-md-8">
            <div class="card border-0 shadow-sm h-100" style="border-radius: 12px;">
                <div class="card-body p-4">

                    <asp:Panel ID="pnlProximaTarea" runat="server">
                        <div class="d-flex justify-content-between align-items-start gap-3">

                            <div>
                                <span class="text-muted fw-semibold small">Tu próxima tarea</span>

                                <h4 class="fw-bold text-dark my-2">
                                    <asp:Label ID="lblProximaTareaDescripcion" runat="server"></asp:Label>
                                </h4>

                                <div class="d-flex flex-wrap gap-2 align-items-center">
                                    <asp:Label ID="lblProximaTareaNumero" runat="server" CssClass="badge bg-primary-subtle text-primary"></asp:Label>
                                    <asp:Label ID="lblProximaTareaPrioridad" runat="server"></asp:Label>
                                    <asp:Label ID="lblProximaTareaVencimiento" runat="server" CssClass="small fw-semibold text-danger"></asp:Label>
                                </div>
                            </div>

                            <asp:HyperLink ID="lnkProximaTarea" runat="server" CssClass="btn btn-outline-primary">
                                Ver ticket
                            </asp:HyperLink>

                        </div>
                    </asp:Panel>

                    <asp:Panel ID="pnlSinTareas" runat="server" Visible="false">
                        <div class="d-flex align-items-center gap-3">

                            <div class="text-success bg-success-subtle rounded-3 p-2 d-flex align-items-center justify-content-center" style="width: 48px; height: 48px;">
                                <i class="bi bi-check-circle-fill fs-3"></i>
                            </div>

                            <div>
                                <h4 class="fw-bold text-dark mb-1">No tenés tareas pendientes</h4>
                                <span class="text-muted small">Todos tus tickets se encuentran finalizados.</span>
                            </div>

                        </div>
                    </asp:Panel>

                </div>
            </div>
        </div>

    </div>
</section>

</asp:Content>
