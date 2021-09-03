<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%

%>

    <div class="modal fade" id="mdlAudLPNSel" tabindex="-1" role="dialog" aria-labelledby="divMdlAudLPNSel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content modal-lg">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close" onclick="AuditoriaLPNSeleccion.Cerrar();">
                        <span aria-hidden="true">&times;</span>
                    </button>

                    <h2 class="modal-title" id="divMdlAudLPNSel">
                        <i class="fa fa-file-text-o"></i> Auditoria Ubicaciones
                        <br />
                        <small>Objetivos de la Auditoria</small>
                    </h2>

                </div>
                <div class="modal-body">
                    <input type="hidden" id="hidMdlAudLPNSelAud_ID">
                    <input type="hidden" id="hidMdlAudLPNSelVisita">
                   
                    <div class="form-group row" id="divMdlAudLPNSelListado" style="overflow-y: auto; max-height: 250px;">

                    </div>
                    
                </div>

                <div class="modal-footer">
                    
                    <button type="button" class="btn btn-white btn-seg" data-dismiss="modal" onclick="AuditoriaLPNSeleccion.Cerrar();">
                        <i class="fa fa-times"></i> Cerrar
                    </button>

                </div>
            </div>
        </div>
    </div>
