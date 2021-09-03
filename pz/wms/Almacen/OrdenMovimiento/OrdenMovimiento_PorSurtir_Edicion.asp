<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>

<%
// HA ID: 1 2020-OCT-20 Orden Movimiento: Creación de archivo
%>
<div class="modal fade" id="mdlIOMSurEdicion" tabindex="-1" role="dialog" aria-labelledby="divMdlIOMSurEdicion" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"
                    onclick="OrdenMovimientoPorSurtido.EdicionModalCerrar();"> 
                    <span aria-hidden="true">&times;</span>
                </button>
                <h2 class="modal-title" id="divMdlIOMSurEdicion">
                    <i class="fa fa-pencil-square-o"></i> Edicion - Orden de Movimiento - Surtido
                    <br />
                    <small>
                        Editar la Orden de Movimiento por Surtido y agregar los productos a surtir.
                    </small>
                </h2>
                
            </div>
            <div class="modal-body">

                <input type="hidden" id="hidMdlIOMSurIOM_ID" value="">
                <div class="form-group row">
                    
                    <label class="col-sm-2 control-label">Folio:</label>    
                    <label class="col-sm-4 control-label">
                        <h3 class="text-success" id="lblMdlIOMSurIOM_Folio">

                        </h3>
                    </label>
                    
                    <label class="col-sm-2 control-label" for=""> Es Prioritario </label>    
                    <label class="col-sm-4 control-label">
                        <input type="checkbox" id="chbMdlIOMSurIOM_Prioridad" value="1">
                    </label> 
                    
                </div>

                <div class="form-group row">   

                    <div class="ibox">

                        <div class="ibox-title">
                            <h5>Agregar Productos</h5>

                            <div class="ibox-tools">
                                <button type="button" class="btn btn-success" onclick="OrdenMovimientoPorSurtido.ProductoAgregar();">
                                    <i class="fa fa-plus"></i> Agregar
                                </button>
                            </div>

                        </div>
                        <div class="ibox-content">

                            <div class="form-group row">
                                <div id="divMdlIOMSurProductoEdicionListado" style="height: 200px; overflow-y: scroll;">

                                </div>
                            </div>

                        </div>

                    </div>

                </div>

            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-secondary btn-seg" data-dismiss="modal" onclick="OrdenMovimientoPorSurtido.EdicionModalCerrar();">
                    <i class="fa fa-times"></i> Cerrar
                </button>
                <button type="button" class="btn btn-primary btn-seg" onclick="OrdenMovimientoPorSurtido.Guardar();">
                    <i class="fa fa-floppy-o"></i> Guardar
                </button>
            </div>
        </div>
    </div>
</div>
