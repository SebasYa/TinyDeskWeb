<%@ Page Title="Gestión de Sprints" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Sprints.aspx.cs" Inherits="TP_Final_Programacion_III.Sprints" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
        <div class="container mt-4">
        <asp:Literal ID="litMensaje" runat="server"></asp:Literal>
        <asp:Panel ID="pnlListadoSprints" runat="server">
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
                                <div class="invalid-feedback">
                                  La fecha de inicio tiene que ser igual o mayor al día de hoy
                                </div>
                                </div>

                                <div class="col-md-6">
                                    <label for="txtFechaEstimadaFin" class="form-label fw-semibold">Fecha Estimada Fin</label>
                                    <asp:TextBox ID="txtFechaEstimadaFin" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                                    <div class="invalid-feedback">
                                      La fecha Estimada fin tiene que ser igual o mayor a la fecha de inicio
                                    </div>
                                </div>

                                <div class="col-md-4">
                                    <label for="ddlProyecto" class="form-label fw-semibold">Proyecto</label>
                                    <asp:DropDownList ID="ddlProyecto" runat="server" CssClass="form-select" >
                                        <asp:ListItem Text="Seleccione Proyecto..." Value="" />
                                    </asp:DropDownList>
                                    <div class="invalid-feedback">
                                      Debes elegir un Proyecto
                                    </div>
                                </div>

                                <div class="col-md-4">
                                    <label for="ddlEstado" class="form-label fw-semibold">Estado</label>
                                    <asp:DropDownList ID="ddlEstado" runat="server" CssClass="form-select">
                                        <asp:ListItem Text="Seleccione Estado..." Value="" />
                                    </asp:DropDownList>
                                    <div class="invalid-feedback">
                                      Debes elegir un Estado
                                    </div>
                                </div>

                                <div class="col-md-4">
                                    <label for="ddlArea" class="form-label fw-semibold">Área</label>
                                    <asp:DropDownList ID="ddlArea" runat="server" CssClass="form-select">
                                        <asp:ListItem Text="Seleccione Área..." Value="" />
                                    </asp:DropDownList>
                                    <div class="invalid-feedback">
                                      Debes elegir un Area
                                    </div>
                                </div>

                            </asp:Panel>
                        </div>
                        <div class="modal-footer bg-light">
                             <asp:Button ID="btnCerrarSprint" runat="server" CssClass="btn btn-secondary" Text="Cancelar" OnClick="btnCerrarSprint_Click" UseSubmitBehavior="false" />
                            <asp:Button ID="btnGuardarSprint" runat="server" CssClass="btn btn-primary" Text="Guardar Sprint" OnClientClick="return validarSprintModal();" OnClick="btnGuardarSprint_Click" />
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
            OnRowCommand="dgvSprints_RowCommand"
            OnRowCreated="dgvSprints_RowCreated"
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
                            <%# GetDiasRestantesTexto(Eval("FechaEstimadaFin"), Eval("Estado.EsFinal"), Eval("FechaFin")) %>
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

                <asp:TemplateField HeaderText="Acciones" ItemStyle-Width="120px">
                    <ItemTemplate>
                        <div class="d-flex gap-2">
                            <asp:LinkButton ID="btnVerSprint" runat="server" CommandName="VerDetalle" 
                                CommandArgument='<%# Eval("Id") %>' CssClass="btn btn-sm btn-outline-primary" title="Ver Sprint">
                                <i class="bi bi-eye"></i>
                            </asp:LinkButton>

                            <asp:LinkButton ID="btnEditarSprint" runat="server" CommandName="Select" 
                                CssClass="btn btn-sm btn-outline-secondary" title="Editar Sprint">
                                <i class="bi bi-pencil"></i>
                            </asp:LinkButton>

                            <asp:LinkButton ID="btnAbrirModalEliminar" runat="server" 
                                CssClass="btn btn-sm btn-outline-danger" 
                                OnClientClick='<%# "abrirModalEliminar(" + Eval("Id") + "); return false;" %>' title="Eliminar Sprint">
                                <i class="bi bi-trash"></i>
                            </asp:LinkButton>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>

            </Columns>
            <PagerSettings 
                Mode="NumericFirstLast" 
                FirstPageText="Primero" 
                LastPageText="Último" 
                NextPageText="Sig" 
                PreviousPageText="Ant" />
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
                            <div id="alertModalEdit" runat="server" class="alert alert-info border d-flex justify-content-between align-items-center mb-0" role="alert">
                                <div>
                                    <asp:Label ID="lblIconoModal" runat="server" CssClass="bi bi-info-circle-fill me-2"></asp:Label>
                                    <span class="fw-bold">Progreso:</span> 
                                    <asp:Label ID="lblModalProgreso" runat="server" Text="0%"></asp:Label>
                                </div>
                                <div>
                                    <span class="fw-bold">Días:</span> 
                                    <asp:Label ID="lblModalDiasRestantes" runat="server" Text="-"></asp:Label>
                                </div>
                            </div>
    
                            <asp:Panel ID="pnlFormEditSprint" CssClass="row g-3" runat="server">



                                <div class="col-md-4">
                                    <label for="txtEditFechaInicio" class="form-label fw-semibold">Fecha Inicio</label>
                                    <asp:TextBox ID="txtEditFechaInicio" runat="server" CssClass="form-control" TextMode="Date" ReadOnly="true"></asp:TextBox>
                                    <div class="invalid-feedback">
                                      La fecha de inicio tiene que ser igual o mayor al día de hoy
                                    </div>
                                </div>

                                <div class="col-md-4">
                                    <label for="txtEditFechaEstimadaFin" class="form-label fw-semibold">Fecha Estimada Fin</label>
                                    <asp:TextBox ID="txtEditFechaEstimadaFin" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                                    <div class="invalid-feedback">
                                          La fecha estimada de fin tiene que ser igual o mayor a la fecha de inicio
                                    </div>
                                </div>

                                <div class="col-md-4">
                                    <label for="txtEditFechaFin" class="form-label fw-semibold">Fecha Fin</label>
                                    <asp:TextBox ID="txtEditFechaFin" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                                <div class="invalid-feedback">
                                  La fecha de fin tiene que ser igual o mayor a la fecha de inicio
                                </div>
                                </div>

                                <div class="col-md-4">
                                    <label for="ddlEditProyecto" class="form-label fw-semibold">Proyecto</label>
                                    <asp:DropDownList ID="ddlEditProyecto" runat="server" CssClass="form-select" >
                                        <asp:ListItem Text="Seleccione Proyecto..." Value="" />
                                    </asp:DropDownList>
                                    <div class="invalid-feedback">
                                      Debes elegir un Proyecto
                                    </div>
                                </div>

                                <div class="col-md-4">
                                    <label for="ddlEditEstado" class="form-label fw-semibold">Estado</label>
                                    <asp:DropDownList ID="ddlEditEstado" runat="server" CssClass="form-select">
                                        <asp:ListItem Text="Seleccione Estado..." Value="" />
                                    </asp:DropDownList>
                                    <div class="invalid-feedback">
                                      Debes elegir un Estado
                                    </div>
                                </div>

                                <div class="col-md-4">
                                    <label for="<%= ddlEditArea.ClientID %>" class="form-label fw-semibold">Área</label>
                                    <asp:DropDownList ID="ddlEditArea" runat="server" CssClass="form-select">
                                        <asp:ListItem Text="Seleccione Área..." Value="" />
                                    </asp:DropDownList>
                                    <div class="invalid-feedback">
                                      Debes elegir un Area
                                    </div>
                                </div>
                                <div class="col-12 position-relative">
                                    <label for="txtMotivoCambio" class="form-label fw-semibold">Motivo del cambio</label>
    
                                    <asp:TextBox ID="txtMotivoCambio" runat="server" 
                                                 CssClass="form-control w-100" 
                                                 TextMode="MultiLine" Rows="2" 
                                                 placeholder="Explique por qué realiza esta modificación...">
                                    </asp:TextBox>

                                    <div class="invalid-feedback">
                                        Por favor, ingrese un motivo para realizar el cambio.
                                    </div>
                                </div>

                            </asp:Panel>
                        </div>
                        <div class="modal-footer bg-light">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                            <asp:Button ID="btnGuardarEdicion" runat="server" CssClass="btn btn-primary" Text="Guardar Sprint" OnClientClick="return validarSprintModal();" OnClick="btnGuardarEdicion_Click" />
                        </div>
                    </div>
                </div>
          </div>
        </asp:Panel>
        <asp:Panel ID="pnlDetalleSprint" runat="server">
             <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="mb-1 fw-bold text-dark">
                <asp:Label ID="lblDetalleTituloSprint" runat="server" Text="Detalle de Sprint"></asp:Label>
            </h2>
            <span class="badge bg-primary-subtle text-primary px-3 py-2 rounded-pill fw-semibold">
                <asp:Label ID="lblSprintProyectoArea" runat="server" Text="Proyecto / Área"></asp:Label>
            </span>
        </div>

        <div class="d-flex gap-2">
            <a href="Sprints.aspx" class="btn btn-primary d-flex align-items-center gap-2">
                <i class="bi bi-arrow-left"></i> Volver al listado
            </a>
        </div>
    </div>

    <div class="card border-0 shadow-sm mb-5" style="border-radius: 12px; border: 1px solid #f0f2f5 !important;">
        <div class="card-body p-4">
            <h5 class="fw-bold text-dark mb-4">Información del Sprint</h5>
            
            <div class="row g-3">
                <div class="col-6 col-md-3">
                    <span class="text-uppercase text-muted fw-semibold d-block text-xs" style="font-size: 0.75rem; letter-spacing: 0.5px;">Fecha Inicio</span>
                    <strong class="text-dark fs-6"><asp:Label ID="lblDetalleFechaInicio" runat="server"></asp:Label></strong>
                </div>
                <div class="col-6 col-md-3">
                    <span class="text-uppercase text-muted fw-semibold d-block text-xs" style="font-size: 0.75rem; letter-spacing: 0.5px;">Fecha Estimada Fin</span>
                    <strong class="text-dark fs-6"><asp:Label ID="lblDetalleFechaEstimadaFin" runat="server"></asp:Label></strong>
                </div>
                <div class="col-6 col-md-3">
                    <span class="text-uppercase text-muted fw-semibold d-block text-xs" style="font-size: 0.75rem; letter-spacing: 0.5px;">Fecha Fin Real</span>
                    <strong class="text-dark fs-6"><asp:Label ID="lblDetalleFechaFin" runat="server" Text="-"></asp:Label></strong>
                </div>
                <div class="col-6 col-md-3">
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

    <div class="bg-white rounded-3 shadow-sm border-0 overflow-hidden" style="border: 1px solid #f0f2f5 !important;">
        <asp:GridView ID="dgvTicketsDelSprint" runat="server"
            AutoGenerateColumns="False"
            DataKeyNames="Id"
            CssClass="table table-hover align-middle mb-0"
            GridLines="None"
            AllowPaging="true" 
            PageSize="10"
            OnPageIndexChanging="dgvTicketsDelSprint_PageIndexChanging"
            EmptyDataText="Este sprint todavía no tiene tickets asignados.">

            <HeaderStyle CssClass="table-light text-secondary fw-semibold border-bottom small" />

            <Columns>

                <asp:TemplateField HeaderText="ID" ItemStyle-Width="100px">
                    <ItemTemplate>
                        <a href='Tickets?idTicket=<%# Eval("Id") %>' class="text-primary fw-bold text-decoration-none">
                            TK-<%# Eval("Id").ToString().PadLeft(3, '0') %>
                        </a>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Título">
                    <ItemTemplate>
                        <span class="text-dark"><%# Eval("Descripcion") %></span>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Prioridad" ItemStyle-Width="110px">
                    <ItemTemplate>
                        <span class='<%# GetClassEtiquetaPrioridad(Eval("Prioridad.Nombre")) %>'>
                            <%# Eval("Prioridad.Nombre") %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Estado" ItemStyle-Width="130px">
                    <ItemTemplate>
                        <span class='<%# GetClassEtiquetaEstado(Eval("Estado.Nombre")) %>'>
                            <%# Eval("Estado.Nombre") %>
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>

                <asp:TemplateField HeaderText="Asignado a">
                    <ItemTemplate>
                        <div class="d-flex align-items-center">
                            <i class="bi bi-person text-muted me-2"></i>
                            <span class="text-dark fw-medium text-sm"><%# string.Format("{0} {1}", Eval("Usuario.Nombre"), Eval("Usuario.Apellido")) %></span>
                        </div>
                    </ItemTemplate>
                </asp:TemplateField>

                 <asp:TemplateField HeaderText="Creado el" ItemStyle-Width="120px">
                     <ItemTemplate>
                         <span class="text-muted small">
                             <%# Convert.ToDateTime(Eval("FechaInicio")).ToString("dd/MM/yyyy") %>
                         </span>
                     </ItemTemplate>
                 </asp:TemplateField>

            </Columns>
        </asp:GridView>
    </div>
        </asp:Panel>
    </div>
    <!--MODAL CONFIRMACION ELIMINAR -->
    <asp:HiddenField ID="hfIdSprintEliminar" runat="server" />
    <div class="modal fade" id="modalEliminarConfirm" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
                    <div class="modal-header bg-danger text-white">
                        <h5 class="modal-title">Confirmar Eliminación</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <p>¿Estás seguro de que deseas eliminar este Sprint? Esta acción no se puede deshacer.</p>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Motivo de la eliminación:</label>
                            <asp:TextBox ID="txtMotivoEliminacion" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="2"></asp:TextBox>
                            <div id="errorEliminacion" class="text-danger small" style="display:none;">Debe ingresar un motivo.</div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancelar</button>
                        <asp:Button ID="btnConfirmarEliminacion" runat="server" CssClass="btn btn-danger" Text="Sí, eliminar" OnClick="btnEliminar_Click" OnClientClick="return validarEliminacion();" />
                    </div>
                </div>
            </div>
        </div>
   <!-- CODIGO JS PARA VALIDACION DE CAMPOS MODAL -->
    <script type="text/javascript">
    function validarSprintModal() {
        let esValido = true;

        // --- 1. Obtención de elementos ---
        const txtEstFinCrear = document.getElementById('<%= txtFechaEstimadaFin.ClientID %>');
        const txtInicioCrear = document.getElementById('<%= txtFechaInicio.ClientID %>');
        const ddlProyectoCrear = document.getElementById('<%= ddlProyecto.ClientID %>');
        const ddlEstadoCrear = document.getElementById('<%= ddlEstado.ClientID %>');
        const ddlAreaCrear = document.getElementById('<%= ddlArea.ClientID %>');

        const txtInicio = document.getElementById('<%= txtEditFechaInicio.ClientID %>');
        const txtEstFin = document.getElementById('<%= txtEditFechaEstimadaFin.ClientID %>');
        const txtFinReal = document.getElementById('<%= txtEditFechaFin.ClientID %>');
        const ddlProyecto = document.getElementById('<%= ddlEditProyecto.ClientID %>');
        const ddlEstado = document.getElementById('<%= ddlEditEstado.ClientID %>');
        const ddlArea = document.getElementById('<%= ddlEditArea.ClientID %>');
        const txtDescripcionCambio = document.getElementById('<%= txtMotivoCambio.ClientID %>');

        // --- 2. Función auxiliar con LOG de error ---
        function setValidacion(control, condicion, nombreCampo) {
            if (!control) return;
            if (condicion) {
                control.classList.remove('is-invalid');
                control.classList.add('is-valid');
            } else {
                control.classList.remove('is-valid');
                control.classList.add('is-invalid');
                console.warn("❌ FALLÓ LA VALIDACIÓN EN: " + (nombreCampo || "Desconocido"));
                esValido = false;
            }
        }

        // --- 3. Detección de Modal ---
        const modalCrearVisible = document.getElementById('sprintModal').classList.contains('show');
        const modalEditarVisible = document.getElementById('sprintEditarModal').classList.contains('show');

        console.log("--- DEBUG DE VARIABLES ---");
        console.log("Modal Crear Visible:", modalCrearVisible);
        console.log("Modal Editar Visible:", modalEditarVisible);

        // --- 4. Validación de Combos ---
        if (modalEditarVisible) {
            setValidacion(ddlProyecto, ddlProyecto && ddlProyecto.value !== "", "Proyecto (Editar)");
            setValidacion(ddlEstado, ddlEstado && ddlEstado.value !== "", "Estado (Editar)");
            setValidacion(ddlArea, ddlArea && ddlArea.value !== "", "Area (Editar)");
        } else if (modalCrearVisible) {
            setValidacion(ddlProyectoCrear, ddlProyectoCrear && ddlProyectoCrear.value !== "", "Proyecto (Crear)");
            setValidacion(ddlEstadoCrear, ddlEstadoCrear && ddlEstadoCrear.value !== "", "Estado (Crear)");
            setValidacion(ddlAreaCrear, ddlAreaCrear && ddlAreaCrear.value !== "", "Area (Crear)");
        }

        // --- 5. Validación de Fechas ---
        const hoyStr = new Date().toISOString().split('T')[0];

        if (modalCrearVisible && txtInicioCrear && txtEstFinCrear) {
            setValidacion(txtInicioCrear, txtInicioCrear.value !== "" && txtInicioCrear.value >= hoyStr, "Fecha Inicio (Crear)");
            setValidacion(txtEstFinCrear, txtEstFinCrear.value !== "" && txtEstFinCrear.value >= txtInicioCrear.value, "Fecha Fin (Crear)");
        }

        if (modalEditarVisible && txtInicio && txtEstFin) {
            setValidacion(txtEstFin, txtEstFin.value !== "" && txtEstFin.value >= txtInicio.value, "Fecha Estimada Fin (Editar)");

            if (txtFinReal && txtFinReal.value !== "") {
                setValidacion(txtFinReal, txtFinReal.value >= txtInicio.value, "Fecha Fin Real (Editar)");
            }
        }

        // --- 6. Validación Descripción Motivo ---
        if (modalEditarVisible && txtDescripcionCambio) {
            const motivoValido = txtDescripcionCambio.value.trim().length >= 5;
            setValidacion(txtDescripcionCambio, motivoValido, "Motivo Cambio");
        }

        console.log("RESULTADO FINAL ¿Es válido?:", esValido);
        console.log("--------------------------");

        return esValido;
    }

        function abrirModalEliminar(id) {
            document.getElementById('<%= hfIdSprintEliminar.ClientID %>').value = id;
            var myModal = new bootstrap.Modal(document.getElementById('modalEliminarConfirm'));
            myModal.show();
        }

        function validarEliminacion() {
            const txt = document.getElementById('<%= txtMotivoEliminacion.ClientID %>');
            const err = document.getElementById('errorEliminacion');
            if (txt.value.trim().length < 5) {
                err.style.display = 'block';
                return false;
            }
            return true;
        }
    </script>
</asp:Content>
