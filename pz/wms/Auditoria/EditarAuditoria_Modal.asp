<!--#include file="./EditarAuditoria_Modal-js.asp" -->
<% var model2 = getAuditInformation(); %>
<div class="modal inmodal" id="editModal" tabindex="-1" role="dialog" aria-hidden="true" style="display: none;">
    <div class="modal-dialog">
    <div class="modal-content animated bounceInRight">
            <div class="modal-header">
                <h3 class="m-t-none m-b">Editar Auditoria</h3>
            </div>
            <div class="modal-body">
                <div class="alert alert-danger" id="newAuditRequiredData" style="display: none;">
                    Favor de llenar todos los campos requeridos.
                </div>
                <form id = "newAuditForm" method="get" class="form-horizontal">
                    <div class="form-group">
                        <label class="col-sm-4 control-label">
                            Creada por:
                        </label>
                        <div class="col-sm-4">
                            <%=model2.Creator%>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-4 control-label">
                            Auditor Responsable:
                        </label>
                        <div class="col-sm-4">
                            <% 
                                var sEventos = " class='input-sm form-control request-input'  style='width:200px' data-type='select' data-required='true'";
                                var sCondicion = " Usu_Habilitado = 1 AND Usu_EsAuditor = 1 ";
                                CargaCombo("newAuditResponsableAuditor", sEventos, "Usu_ID", "Usu_Nombre", "Usuario", sCondicion, "Usu_ID", model2.ResponsableId, 0, "Todos", "Editar");
                            %>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-4 control-label">
                            Messages:
                        </label>
                        <div class="col-sm-4">
                            <%=model2.Messages%>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-4 control-label">
                            Cliente:
                        </label>
                        <div class="col-sm-4"><a href="#" class="text-navy">
                                <%=model2.Client%>
                            </a> 
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-4 control-label">
                            Tipo:
                        </label>
                        <div class="col-sm-4">
                            <%=model2.Type%>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-4 control-label">
                            Forma de trabajarse:
                        </label>
                        <div class="col-sm-4">
                            <%=model2.WorkType%>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-4 control-label">
                            Ultima actualizaci&oacute;n:
                        </label>
                        <div class="col-sm-4">
                            <%=model2.RegisterLastUpdateDate%>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-4 control-label">
                            Creada:
                        </label>
                        <div class="col-sm-4">
                            <%=model2.RegisterDate%>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-4 control-label">
                            Fecha inicio:
                        </label>
                        <div class="col-sm-4">
                            <%=model2.RegisterStartDate%>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-4 control-label">
                            Fecha terminaci&oacute;n:
                        </label>
                        <div class="col-sm-4">
                            <%=model2.RegisterLastUpdateDate%>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-4 control-label">
                            Participantes:
                        </label>
                        <div class="col-sm-4 project-people">
                            <% var auditors=model2.Auditors; for(var count=0; count < auditors.length;
                                count++){ var auditor=auditors[count]; if(auditor.url !=undefined) { %>
                                <span><img title="<%=auditor.name%>" class="img-circle"
                                        src="<%=auditor.url%>"/></span>
                                <% } else { %>
                                    <span title="<%=auditor.name%>"><span
                                            class="fa fa-user-circle"></span>
                                        <%=auditor.name.substring(0,1)%>
                                    </span>
                                    <% } } %>
                        </div>
                    </div>

                    <!--    old  forms      -->

                    <div class="form-group">
                        <label class="col-sm-4 control-label">
                            Cliente*
                        </label>
                        <div class="col-sm-4 m-b-xs">
                            <% 
                                var sEventos = " class='input-sm form-control request-input'  style='width:200px;' data-type='select' data-required='true'";
                                var sCondicion = "";
                                CargaCombo("newAuditClient", sEventos, "Cli_ID", "Cli_Nombre", "Cliente", "", "Cli_Nombre", Parametro("Cli_ID",-1), 0, "No aplica", "Editar");
                            %>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-4 control-label">
                            Auditor Responsable*
                        </label>
                        <div class="col-sm-4">
                            <% 
                                var sEventos = " class='input-sm form-control request-input'  style='width:200px' data-type='select' data-required='true'";
                                var sCondicion = " Usu_Habilitado = 1 AND Usu_EsAuditor = 1 ";
                                CargaCombo("newAuditResponsableAuditor", sEventos, "Usu_ID", "Usu_Nombre", "Usuario", sCondicion, "Usu_ID", -1, 0, "Todos", "Editar");
                            %>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-4 control-label">
                            Tipo de Auditor&iacute;a*
                        </label>
                        <div class="col-sm-4">
                            <% 
                                var sEventos = " class='input-sm form-control request-input'  style='width:200px' data-type='select' data-required='true'";
                                var sCondicion = " Sec_ID = 140 and Cat_ID <> 1";
                                CargaCombo("newAuditType", sEventos, "Cat_ID", "Cat_Nombre", "Cat_Catalogo", sCondicion, "Cat_Orden", -1, 0, "Todos", "Editar");
                            %>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-4 control-label">
                            Forma de Conteo*
                        </label>
                        <div class="col-sm-4">
                            <% 
                                var sEventos = " class='input-sm form-control request-input'  style='width:200px' data-type='select' data-required='true'";
                                var sCondicion = " Sec_ID = 143";
                                CargaCombo("newAuditTypeWork", sEventos, "Cat_ID", "Cat_Nombre", "Cat_Catalogo", sCondicion, "Cat_Orden", -1, 0, "Todos", "Editar");
                            %>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-4 control-label">
                            Fecha Inicio*
                        </label>
                        <div class="col-sm-6">
                            <input class="form-control date-picker date" data-input-ids="newAuditInitDate" id="InitialDate" 
                                    placeholder="dd/mm/aaaa" type="text" value="" 
                                    style="width: 200px;float: left;"/> 
                                <span class="input-group-addon" style="width: 37px; float: left; height: 34px;"><i class="fa fa-calendar"></i></span>
                        </div>
                        <input id="newAuditInitDate" class="request-input" type="hidden" value="" data-type="date" data-required="true" />
                    </div>
                    <div class="form-group">
                        <label class="col-sm-4 control-label">
                            Titulo de auditoria*
                        </label>
                        <div class="col-sm-4">
                            <input type="text" class="input-sm form-control request-input"  name="newAuditName" id="newAuditName" style="width:200px" data-type="text" data-required="true"/>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-sm-4 control-label">
                            Descripcion*
                        </label>
                        <div class="col-sm-4">
                            <textarea class="input-sm form-control request-input" rows="4" name="newAuditDescription" id="newAuditDescription" style="resize: none; width:200px; " data-type="text" data-required="true"/>
                        </div>
                    </div>
                </form>
                <span>*Campos requeridos</span>    
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-white" id="clear-form-new-audit" data-dismiss="modal">Cancelar</button>
                <button type="button" class="btn btn-primary" id="save-form-new-audit" data-target="#newAuditForm">Guardar</button>
            </div>
        </div>
    </div>
</div>
