<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2020-NOV-12 Movimiento: Creación de archivo

var urlBase = "/pz/wms/Almacen/"
var urlBaseTemplate = "/Template/inspina/";

%>
<link href="<%= urlBaseTemplate %>css/plugins/select2/select2.min.css" rel="stylesheet">

<!-- Select2 -->
<script src="<%= urlBaseTemplate %>js/plugins/select2/select2.full.min.js"></script>

<!-- Librerias-->
<script type="text/javascript" src="<%= urlBase %>Ubicacion/js/Ubicacion.js"></script>
<script type="text/javascript" src="<%= urlBase %>Ubicacion_Area/js/Ubicacion_Area.js"></script>
<script type="text/javascript">
 
    $(document).ready(function(){

        Ubicacion.ComboCargar();

        $("#selUbicacion")
            .select2();
    })

    var urlBase = "<%= urlBase %>";

    var Temporal = {
          LPNLimpiar: function(){

            $("#inpLPN").val("");
            $("#divUbicacion").html("");

        }
        , LPNListadoCargar: function(){

            var intUbi_ID = $("#selUbicacion").val();

            $.ajax({
                url: urlBase + "Temporal_movimiento_LPN_ajax.asp"
                , method: "post"
                , async: false
                , data: {
                    Tarea: 1
                    , Ubi_ID: intUbi_ID
                }
                , success: function(res){
                    $("#divLPN").html(res);
                }
            });

        }
        , LPNMover: function(){

            var intUbi_ID = $("#selUbicacion").val();
            var strLPN = $("#inpLPN").val();
            var intIDUsuario = $("#IDUsuario").val();

            var bolError = false;
            var arrError = [];

            if( intUbi_ID == ""){
                bolError = true;
                arrError.push("- Seleccionar la Ubicacion Destino")
            }

            if( strLPN == "" ){
                bolError = true;
                arrError.push("- Agregar el LPN")
            }

            if( bolError ){
                Avisa("warning", "Ubicacion", "Verificar Formulario<br>" + arrError.join("<br>"));
            } else {

                $.ajax({
                    url: urlBase + "Temporal_movimiento_LPN_ajax.asp"
                    , method: "post"
                    , async: false
                    , dataType: "json"
                    , data: {
                          Tarea: 3
                        , Ubi_ID: intUbi_ID
                        , LPN: strLPN
                        , IDUsuario: intIDUsuario
                    }
                    , success: function(res){

                        if(res.Error.Numero == 0){
                            Avisa("success", "Series", res.Error.Descripcion);

                           Temporal.LPNLimpiar();

                        } else {
                            Avisa("danger", "Series", res.Error.Descripcion);
                        }
                    }
                });
            }
        }
        , UbicacionComboCargar: function(){
            var intUbicacionArea = $("#selUbicacionArea").val();

            Ubicacion.ComboCargar({
                Contenedor: "selUbicacion"
                , Are_ID: intUbicacionArea
            })

        }
        , UbicacionListadoCargar: function(){

            var strLPN = $("#inpLPN").val();

            $.ajax({
                url: urlBase + "Temporal_movimiento_LPN_ajax.asp"
                , method: "post"
                , async: false
                , data: {
                    Tarea: 2
                    , LPN: strLPN
                }
                , success: function(res){
                    $("#divUbicacion").html(res);
                }
            });

        }
        , UbicacionPalletSeleccionar: function(){
            
            var prmJson = ( !(arguments[0] == undefined) ) ? arguments[0] : {};
            var intUbi_ID = ( !( prmJson.Ubi_ID == undefined ) ) ? prmJson.Ubi_ID: -1;
            var strUbi_Nombre = ( !( prmJson.Ubi_Nombre == undefined ) ) ? prmJson.Ubi_Nombre : "";

            $("#selUbicacion").val(intUbi_ID);
            $("#select2-selUbicacion-container").text(strUbi_Nombre);
           
        }

    }

</script>

<div id="wrapper">
    <div class="wrapper wrapper-content">    
        <div class="row">
            <div class="col-sm-9">
                <div class="ibox">
                    <div class="ibox-title">
                        <h5>Filtros de b&uacute;squeda</h5>
                        <div class="ibox-tools">
                            <button class="btn btn-success btn-sm" type="button" id="btnSurtir" onclick="Temporal.LPNMover()">
                                <i class="fa fa-share"></i> Mover LPN
                            </button>
                        </div>
                    </div>
                    <div class="ibox-content">
                        <div class="row"> 
                            <div class="col-sm-12 m-b-xs">  
                                
                                <div class="row">

                                    <label class="col-sm-1 control-label"> Buscar LPN:</label>    
                                    <div class="col-sm-3 m-b-xs">
                                        <input type="text" id="inpLPN" class="form-control" placeholder="LPN">
                                    </div>
                                    <div class="col-sm-2 m-b-xs">
                                        <button class="btn btn-success btn-sm" type="button" id="btnBusUbicacion" title="Buscar Ubicacion"
                                        onclick="Temporal.UbicacionListadoCargar()">
                                            <i class="fa fa-search"></i>
                                        </button>
                                        <button class="btn btn-white btn-sm" type="button" id="btnBusUbicacion" title="Ver Series"
                                        onclick="Temporal.SeriesListadoCargar()">
                                            <i class="fa fa-file-text-o"></i>
                                        </button>
                                    </div>

                                    <label class="col-sm-2 control-label">Seleccionar Ubicacion:</label>    
                                    <div class="col-sm-3 m-b-xs">
                                        <select id="selUbicacion" class="form-control">

                                        </select>
                                    </div>
                                    <div class="col-sm-1 m-b-xs">
                                         <button class="btn btn-success btn-sm" type="button" id="btnBusLPN" title="Buscar"
                                         onclick="Temporal.LPNListadoCargar()">
                                            <i class="fa fa-search"></i>
                                        </button>
                                    </div>
                                       
                                </div>      
                                <div class="row">
                                    
                                    <div class="col-sm-6 m-b-xs" id="divUbicacion">
                                        
                                    </div>
                                    <div class="col-sm-6 m-b-xs" id="divLPN">
                                        
                                    </div>
                                </div>
                                    
                            </div>
                        </div>
                    </div>
                </div>
                <div class="ibox" id="divSeriesCargadas">
                    
                </div>
            </div>
        </div>
    </div>
</div>


