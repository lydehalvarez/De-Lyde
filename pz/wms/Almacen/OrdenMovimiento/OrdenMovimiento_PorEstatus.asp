<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2020-OCT-06 Movimiento: Creación de archivo

var urlBase = "/pz/wms/Almacen/"
var urlBaseTemplate = "/Template/inspina/";

%>
<link href="<%= urlBaseTemplate %>css/plugins/select2/select2.min.css" rel="stylesheet">

<!-- Select2 -->
<script src="<%= urlBaseTemplate %>js/plugins/select2/select2.full.min.js"></script>
<!-- Loading -->
<script src="<%= urlBaseTemplate %>js/loading.js"></script>
<!-- Lateral Flotante -->
<script src="<%= urlBaseTemplate %>js/lateralflotante.js"></script>

<!-- Librerias-->
<script type="text/javascript" src="<%= urlBase %>OrdenMovimiento/js/OrdenMovimiento.js"></script>
<script type="text/javascript" src="<%= urlBase %>OrdenMovimientoCorte/js/OrdenMovimientoCorte.js"></script>
<script type="text/javascript" src="<%= urlBase %>Cliente/js/Cliente.js"></script>
<script type="text/javascript" src="<%= urlBase %>Catalogo/js/Catalogo.js"></script>
<script type="text/javascript" src="<%= urlBase %>Ubicacion/js/Ubicacion.js"></script>
<script type="text/javascript" src="<%= urlBase %>Inventario/js/Inventario.js"></script>
<script type="text/javascript">
 
    $(document).ready(function(){

        Cliente.ComboCargar();
        Ubicacion.ComboCargar({Habilitado: 1});
        Catalogo.ComboCargar({
              SEC_ID: 80
            , Contenedor: "selEstatus"
        });

        OrdenMovimientoPorEstatus.ListadoPrincipalCargar();

        $("#selCliente").select2();
        $("#selUbicacion").select2();
        $("#selEstatus").select2();
    })
    
</script>

<div id="wrapper">
    <div class="wrapper wrapper-content">    
        <div class="row">
            <div class="col-sm-9">
                <div class="ibox">
                    <div class="ibox-title">
                        <h5>Filtros de b&uacute;squeda</h5>
                        <div class="ibox-tools">
                            
                            <button class="btn btn-primary btn-sm" type="button" id="btnOrdenMovimientoNuevo" onClick="OrdenMovimientoPorEstatus.Crear();">
                                <i class="fa fa-plus"></i> Nuevo
                            </button>
                            <button class="btn btn-info btn-sm" type="button" title="Realizar Corte de Orden de Movimiento" 
                             id="btnOrdenMovimientoCorteCrear" onClick="OrdenMovimientoCorte.Crear();">
                                <i class="fa fa-dropbox"></i> Nuevo Corte
                            </button>
                            <button class="btn btn-success btn-sm" type="button" id="btnBuscar" onClick="OrdenMovimientoPorEstatus.ListadoPrincipalCargar();">
                                <i class="fa fa-search"></i> Buscar
                            </button>
                            
                        </div>
                    </div>
                    <div class="ibox-content">
                        <div class="row"> 
                            <div class="col-sm-12 m-b-xs">        
                                <div class="row">
                                    <label class="col-sm-2 control-label">Cliente:</label>
                                    <div class="col-sm-4 m-b-xs">
                                        <select id="selCliente" class="form-control">

                                        </select>
                                    </div>

                                    <label class="col-sm-2 control-label">Ubicacion Destino:</label>    
                                    <div class="col-sm-4 m-b-xs">
                                        <select id="selUbicacion" class="form-control">

                                        </select>
                                    </div>
                                </div>
                                <div class="row">
                                    <label class="col-sm-2 control-label">SKU Producto:</label>    
                                    <div class="col-sm-4 m-b-xs">
                                        <input id="inpProductoSku" class="input-sm form-control" type="text" value="" style="width:150px">
                                    </div>

                                    <label class="col-sm-2 control-label">Estatus:</label>    
                                    <div class="col-sm-4 m-b-xs">
                                        <select id="selEstatus" class="form-control">

                                        </select>
                                    </div>
                                </div>    
                            </div>
                        </div>
                    </div>
                </div>
                <div class="ibox">
                    <div class="ibox-content">
                        <div class="row"> 
                            <div id="divIOMListadoTabla">

                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-sm-3" id="divLateral">

            </div>
        </div>
    </div>
</div>


