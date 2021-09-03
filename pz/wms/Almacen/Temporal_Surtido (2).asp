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

<!-- Librerias-->
<script type="text/javascript" src="<%= urlBase %>Ubicacion/js/Ubicacion.js"></script>
<script type="text/javascript" src="<%= urlBase %>Ubicacion_Area/js/Ubicacion_Area.js"></script>
<script type="text/javascript">
 
    $(document).ready(function(){

        Ubicacion.ComboCargar({Are_ID: 0});
        UbicacionArea.ComboCargar({
            Contenedor: "selUbicacionArea"
        });
        
        $("#btnSurtir")
            .on("click", function(){Temporal.SeriesCargar();})
        
        $("#selUbicacionArea")
            .on("change", function(){Temporal.UbicacionComboCargar();})
            .select2();

        $("#selUbicacion")
            .select2();
    })

    var Temporal = {
        UbicacionComboCargar: function(){
            var intUbicacionArea = $("#selUbicacionArea").val();

            Ubicacion.ComboCargar({
                Contenedor: "selUbicacion"
                , Are_ID: intUbicacionArea
            })

        }
        , Limpiar: function(){
            $("#selUbicacion").val("");
            $("#select2-selUbicacion-container").text("TODOS");
            $("#selUbicacionArea").val("");
            $("#select2-selUbicacionArea-container").text("TODOS");
            $("#txaSeries").val("");
            $("#lblCantidadCargada").text("0")
        }
        , SeriesCargar: function(){

            var strSeries = $("#txaSeries").val();
            var arrSeries = strSeries.split("\n");
            var intUbi_ID = $("#selUbicacion").val();
            var intIDUsuario = $("#IDUsuario").val();

            var bolError = false;
            var arrError = [];

            if( intUbi_ID == ""){
                bolError = true;
                arrError.push("- Seleccionar la Ubicacion Destino")
            }

            if( strSeries == "" ){
                bolError = true;
                arrError.push("- Agregar las Series")
            }

            if( bolError ){
                Avisa("warning", "Surtido", "Verificar Formulario<br>" + arrError.join("<br>"));
            } else {
                $.ajax({
                    url: "<%= urlBase %>" + "Temporal_Surtido_ajax.asp"
                    , method: "post"
                    , async: false
                    , dataType: "json"
                    , data: {
                          Tarea: 1 
                        , Ubi_ID: intUbi_ID
                        , Series: arrSeries.join(",")
                        , IDUsuario: intIDUsuario
                    }
                    , success: function(res){
                        if(res.Error.Numero == 0){
                            Avisa("success", "Series", res.Error.Descripcion);
                            Temporal.SeriesListar({
                                Lot_ID: res.Registro.Lot_ID
                            });

                            Temporal.Limpiar();
                            Ubicacion.ComboCargar({
                                Contenedor: "selUbicacion"
                                , Are_ID: 0
                            })
                        } else {
                            Avisa("danger", "Series", res.Error.Descripcion);
                        }
                    }
                });
            }
        }
        , SeriesListar: function(){

            var prmJson = ( !( arguments[0] == undefined ) ) ? arguments[0] : {};
            var intLot_ID = ( !( prmJson.Lot_ID == undefined ) ) ? prmJson.Lot_ID : -1; 

            if( parseInt(intLot_ID) > -1){

                $.ajax({
                      url: "<%= urlBase %>" + "Temporal_Surtido_ajax.asp"
                    , method: "post"
                    , async: false
                    , data: {
                          Tarea: 2 
                        , Lot_ID: intLot_ID
                    }
                    , success: function(res){
                        $("#divSeriesCargadas").html(res);
                        $("#lblCantidadCargada").text( $(".clsRegistros").length );
                    }
                });

            } else {
                Avisa("warning", "series", "No se cargaron las Series")
            }
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
                            <button class="btn btn-success btn-sm" type="button" id="btnSurtir">
                                <i class="fa fa-dropbox"></i> Surtir
                            </button>
                        </div>
                    </div>
                    <div class="ibox-content">
                        <div class="row"> 
                            <div class="col-sm-12 m-b-xs">  
                                <div class="row">
                                    <label class="col-sm-1 control-label">Area:</label>    
                                    <div class="col-sm-3 m-b-xs">
                                        <select id="selUbicacionArea" class="form-control">

                                        </select>
                                    </div>
                                    
                                    <label class="col-sm-1 control-label">Ubicacion Destino:</label>    
                                    <div class="col-sm-3 m-b-xs">
                                        <select id="selUbicacion" class="form-control">

                                        </select>
                                    </div>
                                    <label class="col-sm-1 control-label">Cantidad Cargada:</label>    
                                    <label class="col-sm-3 control-label" id="lblCantidadCargada">
                                        0
                                    </label>    
                                </div>      
                                <div class="row">
                                    <label class="col-sm-1 control-label">Series:</label>
                                    <div class="col-sm-11 m-b-xs">
                                        <textarea id="txaSeries" class="form-control" rows="5"
                                        placeholder="Series"></textarea>
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


