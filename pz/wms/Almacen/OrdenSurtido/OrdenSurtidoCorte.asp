<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2020-OCT-06 Surtido: Creación de archivo

var urlBase = "/pz/wms/Almacen/OrdenSurtido/"
var urlBaseTemplate = "/Template/inspina/";

%>
<link href="<%= urlBaseTemplate %>css/plugins/select2/select2.min.css" rel="stylesheet">

<!-- Select2 -->
<script src="<%= urlBaseTemplate %>js/plugins/select2/select2.full.min.js"></script>

<!-- Librerias-->
<script type="text/javascript" src="<%= urlBase %>js/OrdenSurtido.js"></script>
<script type="text/javascript">
    var urlBase = "<%= urlBase %>"

    $(document).ready(function(){
        OrdenSurtidoCorte.ListadoPrincipalCargar();
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
                            
                            <button class="btn btn-primary btn-sm" type="button" id="btnOrdenSurtidoNuevo" onClick="OrdenSurtido.Crear();">
                                <i class="fa fa-plus"></i> Nuevo
                            </button>
                            <button class="btn btn-info btn-sm" type="button" title="Realizar Corte de Orden de Surtido" 
                             id="btnOrdenSurtirCorteCrear" onClick="OrdenSurtidoCorte.Crear();">
                                <i class="fa fa-dropbox"></i> Nuevo Corte
                            </button>
                            <button class="btn btn-success btn-sm" type="button" id="btnBuscar" onClick="OrdenSurtido.ListadoPrincipalCargar();">
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

                                    <label class="col-sm-2 control-label">Ubicaciones:</label>    
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
                    <div class="ibox-title">
                        <h5>Resultados</h5>
                    </div>
                    <div class="ibox-content">
                        <div class="row"> 
                            <div id="divOrdenSurtidoCorteTabla">

                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-sm-3" id="divDetalle" style="display: none;">
                <div class="ibox">
                    <div class="ibox-content">
                        <div id="divRecepcionSeries">

                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>


