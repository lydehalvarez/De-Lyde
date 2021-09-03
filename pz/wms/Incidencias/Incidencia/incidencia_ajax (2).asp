<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2020-OCT-06 Surtido: Creación de archivo

var cxnTipo = 0
var rqStrTarea = Parametro("Tarea", -1)

switch( parseInt( rqStrTarea ) ){
    //modal General
    case 700: {
%>
        <div class="modal fade" id="mdlIncGeneral" tabindex="-1" role="dialog" aria-labelledby="divIncGeneral" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                         <button type="button" class="close" data-dismiss="modal" aria-label="Close" onclick="Incidencia.GeneralModalCerrar();">
                            <span aria-hidden="true">&times;</span>
                        </button>
                        <h2 class="modal-title" id="divIncGeneral">
                            <i class="fa fa-bug"></i> Control de Incidencias 
                            <br />
                            <small>Nueva Incidencia</small>
                        </h2>
                       
                    </div>
                    <div class="modal-body">

                        <div class="form-group row">
                            
                            <label class="col-sm-2 control-label">Tipo de Incidencia: </label>
                            <div class="col-sm-4">
                                <select id="selTipoIncidencia" class="form-control">

                                </select>
                            </div>
                            <label class="col-sm-6 control-label">
                                
                            </label>
                        </div>
                        <div class="form-group row">

                        </div>
                        
                    </div>

                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary btn-seg" data-dismiss="modal" onclick="Incidencia.GeneralModalCerrar();">
                            <i class="fa fa-times"></i> Cerrar
                        </button>
                    </div>
                </div>
            </div>
        </div>
<%
    } break;
}
%>