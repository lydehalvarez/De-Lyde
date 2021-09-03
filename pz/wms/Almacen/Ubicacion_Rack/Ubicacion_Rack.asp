<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2020-OCT-06 Surtido: Creación de archivo

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
<script type="text/javascript" src="<%= urlBase %>Catalogo/js/Catalogo.js"></script>
<script type="text/javascript" src="<%= urlBase %>Ubicacion/js/Ubicacion.js"></script>
<script type="text/javascript" src="<%= urlBase %>Ubicacion_Area/js/Ubicacion_Area.js"></script>
<script type="text/javascript" src="<%= urlBase %>Ubicacion_Inmueble/js/Ubicacion_Inmueble.js"></script>
<script type="text/javascript" src="<%= urlBase %>Ubicacion_Rack/js/Ubicacion_Rack.js"></script>


<script type="text/javascript">

    $(document).ready(function(){
        Catalogo.ComboCargar({
              SEC_ID: 92
            , Contenedor: "selTipoRack"
        });
        
        UbicacionArea.ComboCargar();
        UbicacionInmueble.ComboCargar();
        UbicacionRack.BusquedaListadoCargar();

        $("#selTipoRack").select2();
        $("#selUbicacionArea").select2();
        $("#selUbicacionInmueble").select2();
        
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
                            
                            <button class="btn btn-primary btn-sm" type="button" id="btnCrear" onClick="UbicacionRack.Crear();">
                                <i class="fa fa-plus"></i> Nuevo
                            </button>

                            <button class="btn btn-success btn-sm" type="button" id="btnBuscar" onClick="UbicacionRack.BusquedaListadoCargar();">
                                <i class="fa fa-search"></i> Buscar
                            </button>

                        </div>
                    </div>
                    <div class="ibox-content">
                        <div class="row"> 
                            <div class="col-sm-12 m-b-xs">        
                                <div class="row">
                                    <label class="col-sm-2 control-label">Inmueble:</label>
                                    <div class="col-sm-4 m-b-xs">
                                        <select id="selUbicacionInmueble" class="form-control">

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
                                    <label class="col-sm-6 control-label"></label>    
                                   
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="ibox" id="divUbicacionRackTabla">
                   
                </div>
            </div>
            <div class="col-sm-3" id="divLateral">
                
            </div>
        </div>
    </div>
</div>

