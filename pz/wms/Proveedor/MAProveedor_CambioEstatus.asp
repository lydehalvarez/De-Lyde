<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2020-ENE-05 Surtido: Creación de archivo

var cxnTipo = 0

var rqIntID = Parametro("ID", -1)
%>
                <input type="hidden" id="hidID" value="<%= rqIntID %>">

                <div class="row">
                    <h3 class="col-sm-12 control-label "><label class="text-danger">Cambio de Estatus:</label><h3>    
                </div>
                
                <div class="row">

                    <label class="col-sm-2 control-label">Estatus:</label>    
                    <div class="col-sm-4 m-b-xs">
<%
    CargaCombo("selEstatus", "class='form-control' onchange='Proveedor.EstatusCambiarEstatusCambiar();'", "CAT_ID", "CAT_Nombre", "CAT_Catalogo", "CAT_ID IN (6,7,8,10,22) AND SEC_ID = 51", "CAT_Nombre DESC", "", cxnTipo, "SELECCIONAR","")
%>
                    </div>
                    <label class="col-sm-6 control-label"></label>  
                </div>

                <div class="row">
                    <label class="col-sm-2 control-label">Fecha</label>  
                    <div class="col-sm-4 m-b-xs">
                        <div class="input-group date">
                            <span class="input-group-addon">
                                <i class="fa fa-calendar"></i>
                            </span>
                            <input type="text" id="inpFecha"  class="form-control" value="" readonly>
                        </div>
                    </div>

                    <div class="col-sm-4 m-b-xs">
                        <div class="input-group clockpicker" data-autoclose="true">
                            <input type="text" class="form-control" id="inpHora" value="" readonly>
                            <span class="input-group-addon">
                                <span class="fa fa-clock-o"></span>
                            </span>
                        </div>
                    </div>

                </div>

                <div class="row clsComentario" style="display: none;">

                    <label class="col-sm-2 control-label">Comentario:</label>    
                    <div class="col-sm-10 m-b-xs">
                        <textarea id="txaComentario" class="form-control" placeholder="Comentario"
                        ></textarea>
                    </div>
                    
                </div>
                <div class="row clsRecibio" style="display: none;">

                    <label class="col-sm-2 control-label">Persona que recibio:</label>    
                    <div class="col-sm-10 m-b-xs">
                        <input type="text" id="inpRecibio" class="form-control" placeholder="Persona que Recibio" autocomplete="off" maxlength="150">
                    </div>
                    
                </div>

                <div class="row clsRecibio" style="display: none;">

                    <label class="col-sm-2 control-label">Evidencia 1:</label>    
                    <div class="col-sm-10 m-b-xs">
                        <input type="file" id="inpArchivoEvidencia1" acept=".doc,.docx,.pdf,image/*"
                        class="form-control" placeholder="Evidencia 1" autocomplete="off" multiple>
                    </div>
                    
                </div>

                <div class="row clsRecibio" style="display: none;">

                    <label class="col-sm-2 control-label">Evidencia 2:</label>    
                    <div class="col-sm-10 m-b-xs">
                        <input type="file" id="inpArchivoEvidencia2" acept=".doc,.docx,.pdf,image/*"
                        class="form-control" placeholder="Evidencia 2" autocomplete="off" multiple>
                    </div>
                    
                </div>

                <div class="row">
                    <div class="col-sm-12 m-b-xs">
                        <hr>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-8 m-b-xs">

                    </div>
                    <div class="col-sm-4 m-b-xs">
                        <button type="button" class="btn btn-secondary btn-seg" data-dismiss="modal" onclick="Proveedor.EstatusCambiarCerrar();">
                            <i class="fa fa-times"></i> Cerrar
                        </button>
                        <button type="button" class="btn btn-primary btn-seg" onclick="Proveedor.EstatusCambiarGuardar();">
                            <i class="fa fa-floppy-o"></i> Guardar
                        </button>
                    </div>    
                </div>