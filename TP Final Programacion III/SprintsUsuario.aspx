<%@ Page Title="" Language="C#" MasterPageFile="~/UsuarioSite.Master" AutoEventWireup="true" CodeBehind="SprintsUsuario.aspx.cs" Inherits="TP_Final_Programacion_III.SprintsUsuario" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
   
    <div class="container-fluid tickets-workspace px-0 pt-2">
    
        <asp:Literal ID="litMensaje" runat="server"></asp:Literal>
        <asp:HiddenField ID="hdnIdTicket" runat="server" />

 <asp:Panel ID="pnlListado" runat="server" CssClass="tickets-list-view">
     <div class="ticket-page-heading d-flex justify-content-between align-items-start flex-wrap gap-3 mb-4">
         <div class="ticket-heading-copy">
             <span class="ticket-eyebrow"><i class="bi bi-ticket-perforated"></i>Espacio de trabajo</span>
             <h1 class="h2 fw-bold mb-1">Mis sprints</h1>
             <p class="mb-0">Consultá los sprints que tenés asignados y sus fechas de vencimiento.</p>
         </div>

         <div class="ticket-context-chip">
             <i class="bi bi-person-check"></i>
             <span><strong>Tu trabajo</strong><small>Seguimiento personal</small></span>
         </div>
     </div>


     <!-- FILTRO RÁPIDO -->
     <div class="card ticket-filter-panel border-0 mb-4">
         <div class="card-body p-3 p-lg-4">

             <div class="row g-3 align-items-end">

                 <div class="col-12 col-lg-4">
                     <label class="form-label fw-semibold">Vista rápida</label>

                     <div class="ticket-toggle d-flex gap-2">

                         <asp:Button
                             ID="btnFiltroPendientes"
                             runat="server"
                             Text="Pendientes"
                             CssClass="btn btn-outline-primary active flex-fill"
                             CausesValidation="false"
                             OnClick="btnFiltroPendientes_Click" />

                         <asp:Button
                             ID="btnMostrarTodos"
                             runat="server"
                             Text="Todos"
                             CssClass="btn btn-outline-secondary flex-fill"
                             CausesValidation="false"
                             OnClick="btnMostrarTodos_Click" />

                     </div>
                 </div>

                 <div class="col-12 col-md-6 col-lg-2">
                     <label for="ddlProximoVencimiento" class="form-label fw-semibold">
                         Vencimiento
                     </label>

                     <asp:DropDownList
                         ID="ddlProximoVencimiento"
                         runat="server"
                         CssClass="form-select"
                         AutoPostBack="true"
                         OnSelectedIndexChanged="ddlProximoVencimiento_SelectedIndexChanged">

                         <asp:ListItem Text="Todos" Value="0" />
                         <asp:ListItem Text="Próximos 7 días" Value="7" />
                         <asp:ListItem Text="Próximos 14 días" Value="14" />
                         <asp:ListItem Text="Próximos 30 días" Value="30" />

                     </asp:DropDownList>
                 </div>

                 <div class="col-12 col-md-6 col-lg-4">
                     <div class="ticket-filter-note rounded-3 px-3 py-2">
                         <div class="small text-muted">
                             Los períodos muestran sprints pendientes que vencen desde hoy.
                         </div>
                     </div>
                 </div>

                 <div class="col-12 col-lg-2">
                     <asp:Button
                         ID="btnToggleFiltros"
                         runat="server"
                         Text="Mostrar filtros"
                         CssClass="btn btn-outline-secondary w-100"
                         CausesValidation="false"
                         OnClick="btnToggleFiltros_Click" />
                 </div>

             </div>

         </div>
     </div>
    
     <!-- FILTROS -->
     <asp:Panel
         ID="pnlFiltros"
         runat="server"
         Visible="false"
         CssClass="card ticket-filter-panel ticket-advanced-filters border-0 mb-4"
         DefaultButton="btnAplicarFiltros">

         <div class="card-body p-3 p-lg-4">

             <div class="row g-3 align-items-end">

                 <div class="col-12 col-lg-5">
                     <label for="txtFiltro" class="form-label fw-semibold">
                         Buscar
                     </label>

                     <div class="input-group ticket-search-group">
                         <span class="input-group-text bg-white">
                             <i class="bi bi-search text-muted"></i>
                         </span>

                         <asp:TextBox
                             ID="txtFiltro"
                             runat="server"
                             CssClass="form-control"
                             placeholder="Número, proyecto, área..." />
                     </div>
                 </div>

                 <div class="col-12 col-md-5 col-lg-2">
                     <label for="ddlArea" class="form-label fw-semibold">
                         Area
                     </label>

                     <asp:DropDownList
                         ID="ddlArea"
                         runat="server"
                         CssClass="form-select">
                     </asp:DropDownList>
                 </div>

                 <div class="col-12 col-md-7 col-lg-3">
                     <label for="ddlOrden" class="form-label fw-semibold">
                         Ordenar
                     </label>

                     <asp:DropDownList ID="ddlOrden" runat="server" CssClass="form-select">
                         <asp:ListItem Text="Vencimiento próximo" Value="fecha_asc" />
                         <asp:ListItem Text="Vencimiento lejano" Value="fecha_desc" />
                         <asp:ListItem Text="Más recientes" Value="recientes" />
                     </asp:DropDownList>
                 </div>

                 <div class="col-12 col-lg-2 d-flex gap-2">

                     <asp:Button
                         ID="btnAplicarFiltros"
                         runat="server"
                         Text="Aplicar"
                         CssClass="btn btn-primary flex-fill"
                         OnClick="btnAplicarFiltros_Click" />

                     <asp:Button
                         ID="btnLimpiarFiltros"
                         runat="server"
                         Text="Limpiar"
                         CssClass="btn btn-outline-secondary flex-fill"
                         OnClick="btnLimpiarFiltros_Click" />

                 </div>

             </div>

         </div>
     </asp:Panel>

<!-- FIN -->
     <asp:Panel ID="pnlListadoSprints" runat="server" CssClass="container-fluid projects-workspace projects-list-view px-0 pt-2">

   
    <asp:ListView ID="lvSprints" runat="server" 
        ItemPlaceholderID="itemPlaceholder"
        OnPagePropertiesChanging="lvSprints_PagePropertiesChanging"
        OnItemCommand="lvSprints_ItemCommand">

        <LayoutTemplate>
            <div class="row g-3 g-xl-4 project-grid">
                <asp:PlaceHolder ID="itemPlaceholder" runat="server" />
            </div>
        </LayoutTemplate>

        <ItemTemplate>
            <div class="col-12 col-lg-6 col-xxl-4 project-grid-item">
                <div class="card project-card h-100 border-0 shadow-sm p-4">
                    
                    <div class="d-flex justify-content-between align-items-start mb-3">
                        <div>
                            <h5 class="card-title fw-bold mb-1">Sprint <%# Eval("NumeroSprint") %></h5>
                            <span class='<%# GetClassEtiquetaEstado(Eval("Estado.Nombre")) %>'><%# Eval("Estado.Nombre") %></span>
                        </div>
                        <div class="text-end">
                            <div class="fw-semibold text-dark"><%# Eval("Proyecto.Nombre") %></div>
                            <span class="badge bg-secondary-subtle text-secondary rounded-pill font-monospace" style="font-size: 0.75rem;"><%# Eval("Area.Nombre") %></span>
                        </div>
                    </div>

                    <div class="mb-3">
                        <div class="text-dark small fw-medium">
                            <i class="bi bi-calendar-range me-1"></i>
                            <%# Convert.ToDateTime(Eval("FechaInicio")).ToString("dd/MM/yyyy") %> - 
                            <%# Convert.ToDateTime(Eval("FechaEstimadaFin")).ToString("dd/MM/yyyy") %>
                        </div>
                        <small class="text-muted d-block mt-1">
                            <%# GetDiasRestantesTexto(Eval("FechaEstimadaFin"), Eval("Estado.EsFinal"), Eval("FechaFin")) %>
                        </small>
                    </div>

                    <div class="d-flex flex-column gap-1 mb-4">
                        <div class="d-flex justify-content-between">
                            <span class="text-xs text-muted">Tiempo: <%# Eval("ProgresoTiempo") %>%</span>
                            <span class="text-xs text-muted">Tickets: <%# Eval("ProgresoTickets") %>%</span>
                        </div>
                        <div class="progress" style="height: 6px;">
                            <div class='<%# GetClassBarraProgreso(Eval("Estado.Nombre")) %>' 
                                 role="progressbar" 
                                 style='width: <%# Eval("ProgresoTickets") %>%;'>
                            </div>
                        </div>
                        <span class="text-muted" style="font-size: 0.75rem;">
                            Finalizados: <%# Eval("TicketsFinalizados") %>/<%# Eval("TicketsTotales") %>
                        </span>
                    </div>

                    <div class="d-flex gap-2 mt-auto pt-3 border-top">
                        <asp:LinkButton ID="btnVerSprint" runat="server" CommandName="VerDetalle" 
                            CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-sm btn-outline-primary flex-fill" title="Ver">
                            <i class="bi bi-eye"></i> Detalle
                        </asp:LinkButton>
                        

                    </div>

                </div>
            </div>
        </ItemTemplate>
    </asp:ListView>

    <div class="project-pagination d-flex justify-content-center mt-4">
        <asp:DataPager ID="dpSprints" runat="server" PagedControlID="lvSprints" PageSize="6">
            <Fields>
                <asp:NextPreviousPagerField ShowPreviousPageButton="true" ShowNextPageButton="false" PreviousPageText="Anterior" ButtonCssClass="btn btn-outline-secondary me-1" />
                <asp:NumericPagerField ButtonCount="5" NumericButtonCssClass="btn btn-outline-primary me-1" CurrentPageLabelCssClass="btn btn-primary me-1" />
                <asp:NextPreviousPagerField ShowPreviousPageButton="false" ShowNextPageButton="true" NextPageText="Siguiente" ButtonCssClass="btn btn-outline-secondary" />
            </Fields>
        </asp:DataPager>
    </div>

</asp:Panel>
    <!--   FIN--> 
     </asp:Panel>
     <asp:Panel ID="pnlDetalleSprint" runat="server"  Visible="false" CssClass="ticket-detail-view">
      

 <div class="ticket-page-heading ticket-detail-heading d-flex justify-content-between align-items-center flex-wrap gap-3 mb-4">
     <div class="ticket-heading-copy">
         <span class="ticket-eyebrow"><i class="bi bi-ticket-detailed"></i>Información del sprint</span>
         <h2 class="mb-2 fw-bold">Detalle de sprint</h2>

         <span class="badge bg-primary-subtle text-primary px-3 py-2 rounded-pill fw-semibold">
             <asp:Label ID="lblTicketSprintProyecto" runat="server"></asp:Label>
         </span>
     </div>

     <a href="SprintsUsuario.aspx" class="btn btn-outline-secondary ticket-back-action d-flex align-items-center justify-content-center gap-2">
         <i class="bi bi-arrow-left"></i>
         Volver al listado
     </a>
 </div>

 <div class="card ticket-detail-card border-0 mb-4" >
     <div class="card-body p-4">
         <h5 class="fw-bold text-dark mb-4">Información del Sprint</h5>
         
         <div class="row g-3">
             <div class="col-6 col-md-3 ticket-detail-field">
                 <span class="text-uppercase text-muted fw-semibold d-block text-xs" style="font-size: 0.75rem; letter-spacing: 0.5px;">Fecha Inicio</span>
                 <strong class="text-dark fs-6"><asp:Label ID="lblDetalleFechaInicio" runat="server"></asp:Label></strong>
             </div>
             <div class="col-6 col-md-3 ticket-detail-field">
                 <span class="text-uppercase text-muted fw-semibold d-block text-xs" style="font-size: 0.75rem; letter-spacing: 0.5px;">Fecha Estimada Fin</span>
                 <strong class="text-dark fs-6"><asp:Label ID="lblDetalleFechaEstimadaFin" runat="server"></asp:Label></strong>
             </div>
             <div class="col-6 col-md-3 ticket-detail-field">
                 <span class="text-uppercase text-muted fw-semibold d-block text-xs" style="font-size: 0.75rem; letter-spacing: 0.5px;">Fecha Fin Real</span>
                 <strong class="text-dark fs-6"><asp:Label ID="lblDetalleFechaFin" runat="server" Text="-"></asp:Label></strong>
             </div>
             <div class="col-6 col-md-3 ticket-detail-field">
                 <span class="text-uppercase text-muted fw-semibold d-block text-xs" style="font-size: 0.75rem; letter-spacing: 0.5px;">Estado General</span>
                 <asp:Label ID="lblDetalleEstado" runat="server" CssClass="badge text-uppercase border  px-2"></asp:Label>
             </div>
         </div>
     </div>
 </div>

 <div class="d-flex justify-content-between align-items-center mb-3">
     <h4 class="fw-bold text-dark mb-0">Tickets incluidos en el Sprint</h4>
     <span class="badge bg-light text-dark border fw-medium px-2 py-1">
         <i class="bi bi-layers-half me-1 text-muted"></i> Total de tareas
     </span>
 </div>


       <div class="card project-table-card border-0">
    <div class="card-header project-card-header p-4">
        <div class="d-flex align-items-center gap-3">
            <div class="project-section-icon rounded-3 p-2">
                <i class="bi bi-layers-half fs-4"></i>
            </div>
            <div>
                <h2 class="h5 fw-bold mb-1">Tickets incluidos en el Sprint</h2>
                <p class="text-muted small mb-0">Listado de tareas asignadas a este sprint.</p>
            </div>
        </div>
    </div>

    <div class="ticket-table-card table-responsive">
        <asp:ListView ID="lvTicketsDelSprint" runat="server"
            ItemPlaceholderID="itemPlaceholder"
            OnPagePropertiesChanging="lvTicketsDelSprint_PagePropertiesChanging">

            <LayoutTemplate>
                <div class="table-responsive">
                    <table class="table  table-hover align-middle mb-0"> <!--ticket-table-->
                        <thead class="table-light text-secondary fw-semibold">
                            <tr>
                                <th>ID</th>
                                <th>Título</th>
                                <th>Prioridad</th>
                                <th>Estado</th>
                                <th>Asignado a</th>
                                <th>Creado el</th>
                            </tr>
                        </thead>
                        <tbody>
                            <asp:PlaceHolder ID="itemPlaceholder" runat="server" />
                        </tbody>
                    </table>
                </div>
            </LayoutTemplate>

            <ItemTemplate>
                <tr>
                    <td>
                        <a href='TicketsUsuario.aspx?id=<%# Eval("Id") %>' class="text-primary fw-bold text-decoration-none">
                            TK-<%# Eval("Id").ToString().PadLeft(3, '0') %>
                        </a>
                    </td>
                    <td>
                        <span class="text-dark"><%# Eval("Descripcion") %></span>
                    </td>
                    <td>
                        <span class='<%# GetClassEtiquetaPrioridad(Eval("Prioridad.Nombre")) %>'>
                            <%# Eval("Prioridad.Nombre") %>
                        </span>
                    </td>
                    <td>
                        <span class='<%# GetClassEtiquetaEstado(Eval("Estado.Nombre")) %>'>
                            <%# Eval("Estado.Nombre") %>
                        </span>
                    </td>
                    <td>
                        <div class="d-flex align-items-center">
                            <i class="bi bi-person text-muted me-2"></i>
                            <span class="text-dark fw-medium text-sm"><%# string.Format("{0} {1}", Eval("Usuario.Nombre"), Eval("Usuario.Apellido")) %></span>
                        </div>
                    </td>
                    <td>
                        <span class="text-muted small">
                            <%# Convert.ToDateTime(Eval("FechaInicio")).ToString("dd/MM/yyyy") %>
                        </span>
                    </td>
                </tr>
            </ItemTemplate>

            <EmptyDataTemplate>
                <div class="project-empty-state m-4 text-center">
                    <i class="bi bi-layers-half fs-1 text-muted"></i>
                    <p class="mt-2"><strong>Sin tickets asignados</strong></p>
                    <span class="text-muted">Este sprint todavía no tiene tickets asignados.</span>
                </div>
            </EmptyDataTemplate>

        </asp:ListView>

        <div class="d-flex justify-content-center my-4">
            <asp:DataPager ID="dpTicketsDelSprint" runat="server"
                PagedControlID="lvTicketsDelSprint" PageSize="10">
                <Fields>
                    <asp:NextPreviousPagerField ShowPreviousPageButton="true" ShowNextPageButton="false"
                        PreviousPageText="Anterior" ButtonCssClass="btn btn-outline-secondary me-1" />
                    <asp:NumericPagerField ButtonCount="5" NumericButtonCssClass="btn btn-outline-primary me-1"
                        CurrentPageLabelCssClass="btn btn-primary me-1" />
                    <asp:NextPreviousPagerField ShowPreviousPageButton="false" ShowNextPageButton="true"
                        NextPageText="Siguiente" ButtonCssClass="btn btn-outline-secondary" />
                </Fields>
            </asp:DataPager>
        </div>
    </div>
</div>



     </asp:Panel>
 </div>
    <style>
    :root {
        --tickets-sky: #93c0de;
        --tickets-aqua: #b9e5e5;
        --tickets-ink: #09232f;
        --tickets-muted: #75797e;
        --tickets-cloud: #e5e5e5;
        --tickets-surface: #f3f7f8;
        --tickets-line: rgba(9, 35, 47, .11);
        --tickets-shadow: 0 18px 45px rgba(9, 35, 47, .075);
    }

    .app-main.tickets-app-surface {
        background: radial-gradient(circle at 92% 3%, rgba(147, 192, 222, .23), transparent 25rem), radial-gradient(circle at 15% 88%, rgba(185, 229, 229, .18), transparent 30rem), linear-gradient(180deg, #f7f9fa 0%, var(--tickets-surface) 100%);
    }

    .tickets-workspace {
        width: 100%;
        max-width: 1540px;
        margin-inline: auto;
        color: var(--tickets-ink);
    }

    .ticket-page-heading {
        position: relative;
        overflow: hidden;
        padding: clamp(1.35rem, 2.4vw, 2rem);
        border: 1px solid rgba(147, 192, 222, .38);
        border-radius: 1.35rem;
        background: linear-gradient(110deg, rgba(255, 255, 255, .94), rgba(245, 251, 252, .86));
        box-shadow: 0 14px 36px rgba(9, 35, 47, .055);
        isolation: isolate;
    }

        .ticket-page-heading::after {
            content: "";
            position: absolute;
            z-index: -1;
            width: 15rem;
            aspect-ratio: 1;
            right: -5rem;
            top: -8rem;
            border: 2.7rem solid rgba(185, 229, 229, .32);
            border-radius: 50%;
        }

    .ticket-heading-copy {
        max-width: 48rem;
    }

        .ticket-heading-copy h1,
        .ticket-heading-copy h2,
        .ticket-list-label h2,
        .tickets-workspace h5 {
            color: var(--tickets-ink) !important;
            letter-spacing: -.025em;
        }

        .ticket-heading-copy > p,
        .ticket-list-label p {
            color: var(--tickets-muted);
        }

    .ticket-eyebrow {
        display: inline-flex;
        align-items: center;
        gap: .45rem;
        margin-bottom: .65rem;
        color: #315a70;
        font-size: .72rem;
        font-weight: 800;
        letter-spacing: .1em;
        text-transform: uppercase;
    }

    .ticket-context-chip {
        display: flex;
        align-items: center;
        gap: .75rem;
        padding: .68rem .85rem;
        border: 1px solid rgba(147, 192, 222, .45);
        border-radius: .9rem;
        background: rgba(255, 255, 255, .78);
        color: #315f76;
    }

        .ticket-context-chip > i {
            display: grid;
            place-items: center;
            width: 2.45rem;
            height: 2.45rem;
            border-radius: .72rem;
            background: linear-gradient(145deg, rgba(147, 192, 222, .3), rgba(185, 229, 229, .4));
            font-size: 1.1rem;
        }

        .ticket-context-chip span {
            display: flex;
            flex-direction: column;
            line-height: 1.2;
        }

        .ticket-context-chip strong {
            color: var(--tickets-ink);
            font-size: .82rem;
        }

        .ticket-context-chip small {
            margin-top: .18rem;
            color: var(--tickets-muted);
            font-size: .68rem;
        }

    .tickets-workspace .btn {
        border-radius: .7rem;
        font-weight: 650;
    }

    .tickets-workspace .btn-primary {
        --bs-btn-bg: var(--tickets-ink);
        --bs-btn-border-color: var(--tickets-ink);
        --bs-btn-hover-bg: #123d4f;
        --bs-btn-hover-border-color: #123d4f;
        --bs-btn-active-bg: #061a23;
        --bs-btn-active-border-color: #061a23;
        color: #fff;
        box-shadow: 0 8px 18px rgba(9, 35, 47, .13);
    }

        .tickets-workspace .btn-primary:hover,
        .tickets-workspace .btn-primary:focus {
            color: #fff !important;
        }

    .tickets-workspace .btn-outline-primary {
        --bs-btn-color: #315a70;
        --bs-btn-border-color: rgba(49, 90, 112, .32);
        --bs-btn-hover-bg: var(--tickets-ink);
        --bs-btn-hover-border-color: var(--tickets-ink);
        --bs-btn-active-bg: var(--tickets-ink);
        --bs-btn-active-border-color: var(--tickets-ink);
    }

    .tickets-workspace .btn-outline-secondary {
        --bs-btn-color: #58646a;
        --bs-btn-border-color: rgba(88, 100, 106, .3);
        --bs-btn-hover-bg: var(--tickets-ink);
        --bs-btn-hover-border-color: var(--tickets-ink);
        --bs-btn-hover-color: #fff;
        --bs-btn-active-bg: var(--tickets-ink);
        --bs-btn-active-border-color: var(--tickets-ink);
    }

    .ticket-back-action:hover,
    .ticket-back-action:focus {
        border-color: var(--tickets-ink) !important;
        background: var(--tickets-ink) !important;
        color: #fff !important;
    }

    .ticket-filter-panel,
    .ticket-table-card,
    .ticket-detail-card {
        border: 1px solid rgba(9, 35, 47, .08) !important;
        border-radius: 1.25rem;
        background: rgba(255, 255, 255, .84);
        box-shadow: var(--tickets-shadow);
        backdrop-filter: blur(12px);
    }

        .ticket-filter-panel .form-label {
            margin-bottom: .55rem;
            color: #39515c;
            font-size: .78rem;
            letter-spacing: .025em;
        }

    .ticket-toggle {
        padding: .28rem;
        border: 1px solid var(--tickets-line);
        border-radius: .9rem;
        background: #edf3f4;
    }

        .ticket-toggle .btn {
            min-height: 40px;
            border-color: transparent;
            border-radius: .68rem !important;
            box-shadow: none;
        }

            .ticket-toggle .btn.active {
                border-color: var(--tickets-ink);
                background: var(--tickets-ink);
                color: #fff;
            }

    .ticket-filter-note {
        min-height: 44px;
        display: flex;
        align-items: center;
        border: 1px solid rgba(147, 192, 222, .26);
        background: rgba(147, 192, 222, .09);
    }

    .ticket-search-group .input-group-text,
    .ticket-search-group .form-control,
    .ticket-filter-panel .form-select,
    .ticket-detail-card .form-select {
        min-height: 44px;
        border-color: rgba(9, 35, 47, .14);
        background-color: rgba(255, 255, 255, .92);
    }

    .ticket-search-group .input-group-text {
        border-radius: .75rem 0 0 .75rem;
        border-right: 0;
    }

    .ticket-search-group .form-control {
        border-left: 0;
        border-radius: 0 .75rem .75rem 0;
    }

    .ticket-search-group:focus-within {
        border-radius: .78rem;
        box-shadow: 0 0 0 .23rem rgba(147, 192, 222, .22);
    }

        .ticket-search-group:focus-within .input-group-text,
        .ticket-search-group:focus-within .form-control,
        .ticket-filter-panel .form-select:focus,
        .ticket-detail-card .form-select:focus {
            border-color: #75a9c9;
            box-shadow: none;
        }

    .ticket-list-label {
        padding-inline: .2rem;
    }

        .ticket-list-label p {
            font-size: .86rem;
        }

    .ticket-list-hint {
        display: inline-flex;
        align-items: center;
        gap: .45rem;
        padding: .48rem .72rem;
        border: 1px solid rgba(147, 192, 222, .42);
        border-radius: 999px;
        background: rgba(255, 255, 255, .72);
        color: #476878;
        font-size: .75rem;
        font-weight: 700;
    }

    .ticket-table-card {
        overflow: hidden;
    }

    .ticket-table {
        min-width: 1050px;
    }

        .ticket-table thead th {
            padding: .88rem 1rem;
            border-bottom-color: rgba(9, 35, 47, .1);
            background: #eaf1f3;
            color: #526873;
            font-size: .69rem;
            font-weight: 800;
            letter-spacing: .06em;
            text-transform: uppercase;
            white-space: nowrap;
        }

        .ticket-table tbody td {
            padding: 1rem;
            border-color: rgba(9, 35, 47, .07);
            color: #52646c;
            font-size: .85rem;
            vertical-align: middle;
        }

        .ticket-table tbody tr {
            transition: background-color .18s ease, transform .18s ease;
        }

    .tickets-js .ticket-table tbody tr {
        opacity: 0;
        transform: translateY(6px);
    }

        .tickets-js .ticket-table tbody tr.is-visible {
            opacity: 1;
            transform: none;
            transition: opacity .35s ease, transform .35s ease, background-color .18s ease;
        }

    .ticket-table tbody tr:hover {
        background: rgba(185, 229, 229, .14);
    }

    .ticket-code {
        color: var(--tickets-ink);
        letter-spacing: .02em;
    }

    .ticket-description {
        display: -webkit-box;
        overflow: hidden;
        max-width: 270px;
        margin-top: .25rem;
        color: #718087;
        line-height: 1.45;
        -webkit-box-orient: vertical;
        -webkit-line-clamp: 2;
    }

    .ticket-project-name {
        max-width: 210px;
        color: var(--tickets-ink);
    }

    .ticket-table .badge,
    .ticket-detail-card .badge {
        padding: .48rem .68rem;
        border: 1px solid transparent;
        font-size: .7rem;
        font-weight: 750;
        letter-spacing: .01em;
    }

    .tickets-workspace .bg-success-subtle {
        border-color: rgba(35, 134, 91, .18) !important;
        background: rgba(76, 175, 125, .14) !important;
        color: #237a55 !important;
    }

    .tickets-workspace .bg-primary-subtle {
        border-color: rgba(49, 95, 118, .18) !important;
        background: rgba(147, 192, 222, .22) !important;
        color: #315f76 !important;
    }

    .tickets-workspace .bg-warning-subtle {
        border-color: rgba(177, 137, 36, .17) !important;
        background: rgba(216, 184, 91, .16) !important;
        color: #80651d !important;
    }

    .tickets-workspace .bg-danger-subtle {
        border-color: rgba(184, 64, 77, .17) !important;
        background: rgba(224, 91, 105, .13) !important;
        color: #a23d49 !important;
    }

    .tickets-workspace .bg-secondary-subtle {
        border-color: rgba(105, 91, 161, .16) !important;
        background: rgba(130, 149, 217, .16) !important;
        color: #584d91 !important;
    }

    .ticket-table .bg-light.text-secondary {
        border-color: rgba(66, 140, 153, .15) !important;
        background: rgba(185, 229, 229, .24) !important;
        color: #36727c !important;
    }

    .ticket-table .bg-warning.text-dark {
        border-color: rgba(177, 137, 36, .2) !important;
        background: #e8c96f !important;
        color: #4d3c0b !important;
    }

    .ticket-empty-state {
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        gap: .3rem;
        min-height: 12rem;
        border: 1px dashed rgba(49, 95, 118, .26);
        border-radius: 1rem;
        background: rgba(255, 255, 255, .58);
        color: var(--tickets-muted);
        text-align: center;
    }

        .ticket-empty-state i {
            margin-bottom: .35rem;
            color: #5f91a9;
            font-size: 2rem;
        }

        .ticket-empty-state strong {
            color: var(--tickets-ink);
        }

        .ticket-empty-state span {
            font-size: .84rem;
        }

    .ticket-detail-card {
        overflow: hidden;
    }

    .ticket-description-panel {
        padding: 1.05rem 1.1rem;
        border-left: 3px solid var(--tickets-sky);
        border-radius: 0 .8rem .8rem 0;
        background: rgba(147, 192, 222, .09);
    }

        .ticket-description-panel strong {
            display: block;
            margin-top: .3rem;
            line-height: 1.55;
        }

    .ticket-detail-field {
        position: relative;
    }

        .ticket-detail-field::before {
            content: "";
            position: absolute;
            inset: 0 .75rem;
            z-index: -1;
            border: 1px solid rgba(9, 35, 47, .08);
            border-radius: .82rem;
            background: linear-gradient(145deg, rgba(255, 255, 255, .95), rgba(237, 245, 247, .82));
        }

        .ticket-detail-field > span,
        .ticket-detail-field > strong {
            display: block;
            margin: .9rem 1rem;
        }

            .ticket-detail-field > span + span,
            .ticket-detail-field > span + strong {
                margin-top: -.48rem;
            }

    .ticket-actions-panel {
        margin: 0;
        padding: 1rem;
        border: 1px solid rgba(147, 192, 222, .24);
        border-radius: .95rem;
        background: rgba(185, 229, 229, .1);
    }

    .ticket-pagination .btn {
        border-radius: .65rem;
    }

    .ticket-modal-content {
        overflow: hidden;
        border: 1px solid rgba(9, 35, 47, .1) !important;
        border-radius: 1.15rem;
        box-shadow: 0 28px 80px rgba(9, 35, 47, .24);
    }

    .ticket-modal-footer {
        border-color: rgba(9, 35, 47, .08);
        background: #f2f7f8;
    }

    @media (max-width: 767.98px) {
        .ticket-context-chip {
            display: none;
        }

        .ticket-filter-panel .btn,
        .ticket-detail-heading .ticket-back-action {
            min-height: 42px;
        }

        .ticket-table {
            min-width: 980px;
        }

        .ticket-detail-field {
            min-height: 96px;
        }
    }

    @media (max-width: 575.98px) {
        .ticket-page-heading {
            border-radius: 1rem;
        }

        .ticket-detail-heading .ticket-back-action {
            width: 100%;
        }

        .ticket-list-hint {
            display: none;
        }

        .ticket-detail-card .card-body {
            padding: 1.25rem !important;
        }

        .ticket-detail-field {
            min-height: 104px;
        }
    }

    @media (prefers-reduced-motion: reduce) {
        .tickets-js .ticket-table tbody tr,
        .tickets-js .ticket-table tbody tr.is-visible {
            opacity: 1;
            transform: none;
            transition: none;
        }
    }
</style>

<script type="text/javascript">
    document.addEventListener('DOMContentLoaded', function () {
        var appMain = document.querySelector('.app-main');
        if (appMain && document.querySelector('.tickets-workspace')) {
            appMain.classList.add('tickets-app-surface', 'tickets-js');
        }

        var rows = document.querySelectorAll('[data-ticket-row]');
        var reducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

        if (!reducedMotion && 'IntersectionObserver' in window) {
            var rowObserver = new IntersectionObserver(function (entries, observer) {
                entries.forEach(function (entry) {
                    if (entry.isIntersecting) {
                        entry.target.classList.add('is-visible');
                        observer.unobserve(entry.target);
                    }
                });
            }, { threshold: 0.08 });

            rows.forEach(function (row, index) {
                row.style.transitionDelay = Math.min(index * 35, 210) + 'ms';
                rowObserver.observe(row);
            });
        } else {
            rows.forEach(function (row) {
                row.classList.add('is-visible');
            });
        }
    });
</script>
 
</asp:Content>
