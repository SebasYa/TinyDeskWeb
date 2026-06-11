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
</asp:Content>
