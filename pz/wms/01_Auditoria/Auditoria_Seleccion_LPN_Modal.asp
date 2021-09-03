<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->

    <div class="modal fade" id="mdlAudSelLPN" tabindex="-1" role="dialog" aria-labelledby="divMdlAudSelLPN" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close" onclick="AuditoriaSeleccionLPN.Cerrar();">
                        <span aria-hidden="true">&times;</span>
                    </button>

                    <h2 class="modal-title" id="divMdlAudSelLPN">
                        <i class="fa fa-file-text-o"></i> Auditoria Seleccion - LPN
                        <br />
                        <small>Seleccion de Objetivos para la auditoria</small>
                    </h2>

                </div>
                <div class="modal-body">

                    <input type="hidden" id="hidMdlAudSelLPNAud_ID">

                    <div class="form-group row">
                        
                        <label class="col-sm-2 control-label">Buscar</label>    
                                               

                    </div>

                    <div class="form-group row">
                        
                        <label class="col-sm-2 control-label">SKU</label>
                        <div class="col-sm-10 m-b-xs">
                            <textarea id="txtMdlAudSelLPNSKU" placeholder="SKUs" class="form-control"></textarea>
                        </div>                        

                    </div>

                    <div class="form-group row">
                        
                        <label class="col-sm-2 control-label">Ubicaciones</label>    
                        <div class="col-sm-10 m-b-xs">
                            <textarea id="txtMdlAudSelLPNUbicacion" placeholder="Ubicaciones" class="form-control"></textarea>
                        </div>                        
                        
                    </div>

                    <div class="form-group row">
                        
                        <label class="col-sm-2 control-label">LPNs</label>    
                        <div class="col-sm-10 m-b-xs">
                            <textarea id="txtMdlAudSelLPNLPN" placeholder="LPNs" class="form-control"></textarea>
                        </div>                        
                        
                    </div>
                    <div class="form-group row">
                   		 <div class="col-sm-11">
                         	<div class="row pull-right">
                            
                                <a class="btn btn-white" onclick="AuditoriaSeleccionLPN.LimpiarFormulario();">
                                    <i class="fa fa-trash-o"></i> Limpiar
                                </a>
                                <a class="btn btn-success" onclick="AuditoriaSeleccionLPN.Listar();">
                                    <i class="fa fa-search"></i> Buscar
                                </a>

                            </div>
                        </div> 
                     </div> 
                    
                    <div class="form-group row" id="divMdlAudSelLPNListado" style="overflow-y: auto; max-height: 300px;">

                    </div>
                    
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-white btn-seg" data-dismiss="modal" onclick="AuditoriaSeleccionLPN.Cerrar();">
                        <i class="fa fa-times"></i> Cerrar
                    </button>

                    <button type="button" class="btn btn-primary btn-seg" onclick="AuditoriaSeleccionLPN.Congelar()">
                        <i class="fa fa-snowflake-o"></i> Congelar 
                    </button>
                </div>
            </div>
        </div>
    </div>
