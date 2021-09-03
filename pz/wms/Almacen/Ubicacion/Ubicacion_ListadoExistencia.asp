<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2020-OCT-06 Surtido: Creación de archivo
// HA ID: 2 2020-DIC-07 Ubicacion: Se agrega la opcion de filtrasr des de antes por sku

var urlBase = "/pz/wms/Almacen/"
var urlBaseTemplate = "/Template/inspina/";

// HA ID: 2 
var strSku = Parametro("SKU", "")

%>
<link href="<%= urlBaseTemplate %>css/plugins/select2/select2.min.css" rel="stylesheet">

<!-- Select2 -->
<script src="<%= urlBaseTemplate %>js/plugins/select2/select2.full.min.js"></script>
<script src="<%= urlBaseTemplate %>js/loading.js"></script>
<script src="<%= urlBaseTemplate %>js/lateralflotante.js"></script>

<script src="/Template/inspina/js/plugins/sheetJs/xlsx.full.min.js"></script>

<!-- Librerias-->
<script type="text/javascript" src="<%= urlBase %>Catalogo/js/Catalogo.js"></script>
<script type="text/javascript" src="<%= urlBase %>Cliente/js/Cliente.js"></script>
<script type="text/javascript" src="<%= urlBase %>Inventario/js/Inventario.js"></script>
<script type="text/javascript" src="<%= urlBase %>Ubicacion/js/Ubicacion.js"></script>
<script type="text/javascript" src="<%= urlBase %>Ubicacion_Area/js/Ubicacion_Area.js"></script>
<script type="text/javascript" src="<%= urlBase %>Ubicacion_Inmueble/js/Ubicacion_Inmueble.js"></script>
<script type="text/javascript" src="<%= urlBase %>Ubicacion_Rack/js/Ubicacion_Rack.js"></script>

<script type="text/javascript">

    $(document).ready(function(){  

        UbicacionArea.ComboCargar();
        Catalogo.ComboCargar({
              SEC_ID: 92
            , Contenedor: "selTipoRack"
        });
        Cliente.ComboCargar();
        UbicacionRack.ComboCargar();

        $("#selCliente").select2();
        $("#selUbicacionArea").select2();
        $("#selTipoRack").select2();
        $("#selUbicacionRack").select2();

        $("#btnExportar").click(function(){
            var intAre_ID = $("#selUbicacionArea").val();

            if( intAre_ID == "" ){
                Avisa("warning", "Exportar", "Seleccionar el Area de Exportacion");
            } else {
                Ubicacion.Exportar({
                    Are_ID: intAre_ID
                })
            }
        })
       
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
                            
                            <button class="btn btn-success btn-sm" type="button" id="btnBuscar" onClick="Ubicacion.ListadoExistenciaCargar();">
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
                                    <label class="col-sm-2 control-label">Area:</label>    
                                    <div class="col-sm-4 m-b-xs">
                                        <select id="selUbicacionArea" class="form-control">

                                        </select>
                                    </div>
                                </div>
                                <div class="row">
                                    <label class="col-sm-2 control-label">Tipo de Rack:</label>    
                                    <div class="col-sm-4 m-b-xs">
                                        <select id="selTipoRack" class="form-control">

                                        </select>
                                    </div>
                                    <label class="col-sm-2 control-label">Rack:</label>    
                                    <div class="col-sm-4 m-b-xs">
                                        <select id="selUbicacionRack" class="form-control">

                                        </select>
                                    </div>
                                </div>
                                <div class="row">
                                    <label class="col-sm-2 control-label">SKU Producto:</label>    
                                    <div class="col-sm-4 m-b-xs">
                                        <input type="text" id="inpProductoSku" class="input-sm form-control" value="<%= strSku %>" placeholder="SKU"
                                          autocomplete="off">
                                    </div> 
                                    <label class="col-sm-2 control-label">Nombre Ubicaci&oacute;n</label>    
                                    <div class="col-sm-4 m-b-xs">
                                        <input type="text" id="inpNombre" class="input-sm form-control" value="" autocomplete="off"
                                        placeholder="Ubicaci&oacute;n">
                                    </div> 
                                </div>
                                <div class="row">

                                    <label class="col-sm-2 control-label">LPN:</label>    
                                    <div class="col-sm-4 m-b-xs">
                                        <input type="text" id="inpLPN" class="input-sm form-control" value="" placeholder="LPN"
                                          autocomplete="off">
                                    </div>

                                    <div class="col-sm-6 m-b-xs">
                                        <div class="pull-right">
                                            <a class="btn btn-white btn-sm" type="button" id="btnExportar">
                                                <i class="fa fa-file-excel-o"></i> Exportar Area
                                            </a>
                                        </div>
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
                            <div id="divUbicacionTabla">

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
