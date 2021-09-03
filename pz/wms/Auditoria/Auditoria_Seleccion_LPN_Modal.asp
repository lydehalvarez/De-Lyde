<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 3     2021-JUL-07 Agregado de Botón para seleccion de todos los SKUs en los objetivos
// HA ID: 4     2021-JUL-13 Cambio de Modal: Metodo de Seleccion por listado
%>

    <div class="modal fade" id="mdlAudSelLPN" tabindex="-1" role="dialog" aria-labelledby="divMdlAudSelLPN" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close" onclick="AuditoriaSeleccionLPN.Cerrar();">
                        <span aria-hidden="true">&times;</span>
                    </button>


                    <h2 class="modal-title" id="divMdlAudSelLPN">
                        <i class="fa fa-file-text-o"></i> Auditoria - Seleccion - LPN
                        <br />
                        <small>Seleccion de Objetivos para la auditoria</small>
                    </h2>
                </div>
                <div class="modal-body">

                    <input type="hidden" id="hidMdlAudSelLPNAud_ID">

                    <div class="form-group row">

                        <div class="ibox">

                            <div class="ibox-title">

                                <h5>Buscar</h5>

                                <div class="ibox-tools">

                                    <button type="button" class="btn btn-white" id="btnMdlAudSelLpnLimpiar"
                                    onclick="AuditoriaSeleccionLPN.Buscador.FiltrosLimpiar();">
                                        <i class="fa fa-trash-o"></i> Limpiar
                                    </button>
                                    <button type="button" class="btn btn-success" id="btnMdlAudSelLpnBuscar"
                                    onclick="AuditoriaSeleccionLPN.Buscador.Filtrar();">
                                        <i class="fa fa-search"></i> Buscar
                                    </button>

                                </div>
                            </div>

                            <div class="ibox-content">

                                <div class="form-group row">

                                    <label class="col-sm-2 control-label">
                                        Tipo Busqueda
                                    </label>
                                    <div class="col-sm-4">
                                        <div class="form-check form-check-inline">
                                          <input class="form-check-input" checked="checked" type="radio" name="radMdlAudSelLpnTipBus" id="radMdlAudSelLpnTipBusSKU" value="1">
                                          <label class="form-check-label" for="radMdlAudSelLpnTipBusSKU">SKU</label>
                                        </div>
                                        <div class="form-check form-check-inline">
                                          <input class="form-check-input" type="radio" name="radMdlAudSelLpnTipBus" id="radMdlAudSelLpnTipBusUbi" value="2">
                                          <label class="form-check-label" for="radMdlAudSelLpnTipBusSKU">Ubicaci&oacute;n</label>
                                        </div>
                                        <div class="form-check form-check-inline">
                                          <input class="form-check-input" type="radio" name="radMdlAudSelLpnTipBus" id="radMdlAudSelLpnTipBusLPN" value="3">
                                          <label class="form-check-label" for="radMdlAudSelLpnTipBusSKU">LPN</label>
                                        </div>
                                    
                                    

                                       <!-- <input type="radio" name="radMdlAudSelLpnTipBus" id="radMdlAudSelLpnTipBusSKU" value="1"
                                        >
                                        <label for="radMdlAudSelLpnTipBusSKU">
                                            SKU
                                        </label>
                                        <input type="radio" name="radMdlAudSelLpnTipBus" id="radMdlAudSelLpnTipBusUbi" value="2"
                                        >
                                        <label for="radMdlAudSelLpnTipBusUbi">
                                            Ubicaci&oacute;n
                                        </label>
                                        <input type="radio" name="radMdlAudSelLpnTipBus" id="radMdlAudSelLpnTipBusLPN" vlaue="3"
                                        >
                                        <label for="radMdlAudSelLpnTipBusLPN">
                                            LPN
                                        </label>-->
                                        
                                    </div>
                                    <label class="col-sm-2 control-label">
                                        Texto
                                    </label>
                                    <div class="col-sm-4">
                                        <input type="text" id="inpMdlAudSelLpnTex" class="form-control" automplete="off" maxlength="50"
                                        onkeyup="AuditoriaSeleccionLPN.Buscador.Escanear(event, this)">
                                    </div>
                                </div>

                                <br>

                                <div class="form-group row">

                                    <div class="col-sm-6">
                                        <div class="ibox">
                                            <div class="ibox-title">
                                                <label class="pull-right form-group">
                                                    <span class="text-success" id="lblMdlAudSelLpnLisBusTotReg"></span> Registros
                                                </label>
                                                <h5>Registros Encontrados</h5>
                                            </div>
                                            <div class="ibox-content">
                                                <div class="form-group row">
                                                    <div class="col-sm-1">
                                                        <input type="checkbox" id="chbMdlAudSelLpnLisBusTodos" 
                                                        onclick="AuditoriaSeleccionLPN.ListadoObjetivosBuscados.TodosSeleccionar()">
                                                    </div>
                                                    <label class="col-sm-8 control-label">
                                                        Todos
                                                    </label>
                                                    <div class="col-sm-2">
                                                        <button type="button" class="btn btn-success btn-xs" 
                                                        onclick="AuditoriaSeleccionLPN.ListadoObjetivosBuscados.SeleccionAgregar();">
                                                            <i class="fa fa-plus"></i> Agregar
                                                        </button>
                                                    </div>
                                                </div>
                                                <div class="form-group row">
                                                    <ul id="ulMdlAudSelLpnLisBus" class="sortable-list connectList agile-list ui-sortable"
                                                    style="overflow-y: auto; overflow-x: hidden; max-height: 300px;">

                                                    </ul>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="col-sm-6" >
                                        <div class="ibox">
                                            <div class="ibox-title">
                                                <label class="pull-right form-group">
                                                    <span class="text-success" id="lblMdlAudSelLpnLisSelTotReg"></span> Registros
                                                </label>
                                                <h5>Registros Seleccionados</h5>
                                            </div>
                                            <div class="ibox-content">
                                                <div class="form-group row">
                                                    <div class="col-sm-1">
                                                        <input type="checkbox" id="chbMdlAudSelLpnLisSelTodos" 
                                                        onclick="AuditoriaSeleccionLPN.ListadoObjetivosSeleccionados.TodosSeleccionar()">
                                                    </div>
                                                    <label class="col-sm-8 control-label">
                                                        Todos
                                                    </label>
                                                    <div class="col-sm-2">
                                                        <button type="button" class="btn btn-danger btn-xs" 
                                                        onclick="AuditoriaSeleccionLPN.ListadoObjetivosSeleccionados.SeleccionEliminar();">
                                                            <i class="fa fa-times"></i> Eliminar
                                                        </button>
                                                    </div>
                                                </div>
                                                <div class="form-group row">
                                                    <ul id="ulMdlAudSelLpnLisSel" class="sortable-list connectList agile-list ui-sortable"
                                                    style="overflow-y: auto; overflow-x: hidden; max-height: 300px;">

                                                    </ul>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                </div>

                            </div>

                        </div>
                                                                     
                    </div>          
                    
                </div>

                <div class="modal-footer">

                    <button type="button" class="btn btn-warning" onclick="AuditoriaSeleccionLPN.TodosSeleccionar();">
                        <i class="fa fa-snowflake-o"></i> Congelar Todos SKUs (Wall to wall)
                    </button>

                    <button type="button" class="btn btn-danger btn-seg" data-dismiss="modal" onclick="AuditoriaSeleccionLPN.Cerrar();">
                        <i class="fa fa-times"></i> Cancelar
                    </button>

                    <button type="button" class="btn btn-primary btn-seg" onclick="AuditoriaSeleccionLPN.Congelar()">
                        <i class="fa fa-snowflake-o"></i> Congelar (Seleccionados)
                    </button>
<%
// HA ID: 3 INI Agregado de botón para guardar todos los SKUs
%>
<%
// HA ID: 3 FIN
%>
                </div>
            </div>
        </div>
    </div>
