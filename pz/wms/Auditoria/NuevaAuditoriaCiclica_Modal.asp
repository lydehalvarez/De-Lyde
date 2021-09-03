<!--#include file="./NuevaAuditoriaCiclica_Modal-js.asp" -->
<%
//HA ID: 2 2021-JUL-14 Ajustes de Auditorias: Actualización de campos de auditoria
%>
<div class="modal inmodal" id="newModal" tabindex="-1" role="dialog" aria-hidden="true" style="display: none;">
    <div class="modal-dialog" style="width: 900px;">
    <div class="modal-content animated bounceInRight">
            <div class="modal-header" style="padding: 10px 5px">
                <h3 class="m-t-none m-b" style="margin-bottom:5px;">Nueva Auditor&iacute;a</h3>
            </div>
            <div class="modal-body">
                <div class="alert alert-danger" id="newAuditRequiredData" style="display: none;">
                    Favor de llenar todos los campos requeridos.
                </div>
                <form id = "newAuditForm" method="get" class="form-horizontal">
                    
                    <div class="form-group">
                        <label class="col-sm-3 control-label">
                            T&iacute;tulo de la auditor&iacute;a
                        </label>
                        <div class="col-sm-9">
                            <input type="text" class="input-sm form-control request-input" style='width:600px' name="newAuditName" id="newAuditName" data-type="text" data-required="true"/>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label class="col-sm-3 control-label">
                            Auditor responsable
                        </label>
                        <div class="col-sm-6">
                            <%   //style='width:200px'
                                var sEventos = " class='input-sm form-control request-input'   data-type='select' data-required='true'";
                                var sCondicion = " Usu_Habilitado = 1 AND Usu_EsAuditor = 1 ";
                                CargaCombo("newAuditResponsableAuditor", sEventos, "Usu_ID", "Usu_Nombre", "Usuario"
                                           , sCondicion, "Usu_Nombre", -1, 0, "Todos", "Editar");
                            %>
                        </div>
                    </div>                                       
                     
                    <div class="form-group">
                        <label class="col-sm-2 control-label">
                            Cliente
                        </label>
                        <div class="col-sm-4 m-b-xs">
                            <% 
                                var sEventos = " class='input-sm form-control request-input'  style='width:200px;' data-type='select' data-required='true'";
                                var sCondicion = "";
                                CargaCombo("newAuditClient", sEventos, "Cli_ID", "Cli_Nombre", "Cliente", "", "Cli_Nombre"
                                           , Parametro("Cli_ID",-1), 0, "Seleccione un cliente", "Editar");
                            %>
                        </div>
                            
                        <label class="col-sm-2 control-label">
                            Fecha Inicio
                        </label>
                        <div class="col-sm-4">
                            <input class="form-control date-picker date" data-input-ids="newAuditInitDate" id="InitialDate" 
                                    placeholder="dd/mm/aaaa" type="text" value="" 
                                    style="width: 200px;float: left;"/> 
                                <span class="input-group-addon" style="width: 37px; float: left; height: 34px;"><i class="fa fa-calendar"></i></span>
                        </div>
                        <input id="newAuditInitDate" class="request-input" type="hidden" value="" data-type="date" data-required="true" /> 
                            
                            
                    </div>    
                        
                    <div class="form-group">

                        <label class="col-sm-2 control-label">
                            Es ciega
                        </label>
                        <div class="col-sm-8">

                            <input type="radio" name="rdCiego" id="rdCiegoSI" value="1" checked>
                            <label for="rdCiegoSI">
                                No se pueden ver cantidades
                            </label>
                            <br>
                            <input type="radio" name="rdCiego" id="rdCiegoNO" value="0" >
                            <label for="rdCiegoNO">
                                Si se mostraran las cantidades
                            </label>
                        </div>

                    </div> 
                        
                    <div class="form-group">

                        <label class="col-sm-2 control-label">
                            Conteos continuos
                        </label>
                        <div class="col-sm-10">

                            <input type="radio" name="rdContinua" id="rdContinuaSI" value="1" checked>
                            <label for="rdContinuaSI">
                                Si, los conteos se incrementan autom&aacute;ticamente y puede haber distintos conteos a la vez
                            </label>
                            <br>
                            <input type="radio" name="rdContinua" id="rdContinuaNO" value="0" >
                            <label for="rdContinuaNO">
                                No, se debe indicar cuando inicia un nuevo conteo
                            </label>
                        </div>

                    </div> 
                        
                    <div class="form-group">

                        <label class="col-sm-2 control-label">
                            Conteos externos
                        </label>
                        <div class="col-sm-10">

                            <input type="radio" name="rdExterno" id="rdExternoSI" value="1" checked>
                            <label for="rdExternoSI">
                                Si habr&aacute; auditores externos
                            </label>
                            <br>
                            <input type="radio" name="rdExterno" id="rdExternoNO" value="0" >
                            <label for="rdExternoNO">
                                No habr&aacute; auditores externos
                            </label>
                        </div>

                    </div>                    
<%
//HA ID: 2  INI Se elimina el bloque y se agrega campo de tipo hidden
%>
<!--
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
-->
                    <input type="hidden" id="newAuditType" value="2" class="form-control request-input"> <% //Manual(2) %>
<%
//HA ID: 2  FIN
//HA ID: 2  INI Se elimina el bloque y se agrega campo de tipo hidden
%>
<!--
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
-->
                    <input type="hidden" id="newAuditTypeWork" value="1" class="form-control request-input"> <% //SKU(1) %>
<%
//HA ID: 2  INI Se elimina el bloque y se agrega campo de tipo hidden
%>

                    <div class="form-group">
                        <label class="col-sm-2 control-label">
                            Descripci&oacute;n
                        </label>
                        <div class="col-sm-10">
                            <textarea class="input-sm form-control request-input" rows="3" name="newAuditDescription" id="newAuditDescription" 
                                      style="resize: none; width:600px; " data-type="text" data-required="true"/>
                        </div>
                    </div>
                </form>
                <span>Todos los campos son requeridos</span>    
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-white" id="clear-form-new-audit" data-dismiss="modal">Cancelar</button>
                <button type="button" class="btn btn-primary" id="save-form-new-audit" data-target="#newAuditForm">Guardar</button>
            </div>
        </div>
    </div>
</div>