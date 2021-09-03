<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2021-FEB-15 Auditoria Pallet - Auditoria: Creación de archivo
var cxnTipo = 0
%>

<div class="modal fade" id="mdlAUUEdi" tabindex="-1" role="dialog" aria-labelledby="divAUUEdi" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close" onclick="AuditoriasUbicacion.EdicionModalCerrar()">
                    <span aria-hidden="true">&times;</span>
                </button>
                <h2 class="modal-title" id="divAUUEdi">
                    <i class="fa fa-file-text-o"></i> Nueva Auditoria
                </h2>
                <small>
                    Nueva Visita de Auditoria
                </small>
                
            </div>
            <div class="modal-body">

                <input type="hidden" id="hidMdlAUUEdiAud_ID" value="">
                <input type="hidden" id="hidMdlAUUEdiPT_ID" value="">

                <div class="form-group row">
                    
                    <label class="col-sm-4 control-label">Tipo Auditoria: </label>    
                    <div class="col-sm-8 m-b-xs">
                        <select id="selMdlAUUEdiTPA_ID" class="form-control">

                        </select>
                    </div>

                </div>

                <div class="form-group row">

                    <label class="col-sm-4 control-label">Asignar Auditor Interno: </label>    
                    <div class="col-sm-8 m-b-xs">
                        <select id="selMdlAUUEdiADT_ID_Int" class="form-control">
                            
                        </select>
                    </div>
                </div>

                <div class="form-group row">
                    <label class="col-sm-4 control-label">Asignar Auditor Externo: </label>    
                    <div class="col-sm-8 m-b-xs">
                        <select id="selMdlAUUEdiADT_ID_Ext" class="form-control">
                            
                        </select>
                    </div>
                    
                </div>
                                          
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-secondary btn-seg" data-dismiss="modal" onclick="AuditoriasUbicacion.EdicionModalCerrar();">
                    <i class="fa fa-times"></i> Cerrar
                </button>
                <button type="button" class="btn btn-success btn-seg" data-dismiss="modal" onclick="AuditoriasUbicacion.EdicionModalGuardar();">
                    <i class="fa fa-plus"></i> Crear
                </button>
            </div>
        </div>
    </div>
</div>