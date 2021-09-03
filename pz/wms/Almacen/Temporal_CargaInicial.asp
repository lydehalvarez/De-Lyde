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
<script type="text/javascript">
 
    $(document).ready(function(){

        Ubicacion.ComboCargar();
        Temporal.LPNPorBuscarListadoCargar();

        $("#selUbicacion").select2();
        $(".select2").hide();
    })

    var urlBase = "<%= urlBase %>";

    var Temporal = {
          LPNLimpiar: function(){

            $("#inpLPN").val("");
            $("#divUbicacion").html("");

        }
        , LPNListadoCargar: function(){

            var intUbi_ID = $("#selUbicacion").val();
            var sUbicacion = "" 
    
            if ( $("#inpUbicacion").is(':visible') ) {
               sUbicacion = $("#inpUbicacion").val()
            } else { 
              // sUbicacion = $("#select2-selUbicacion-container :selected").text()
               sUbicacion = document.getElementById("select2-selUbicacion-container").innerHTML;
            }

            $.ajax({
                url: urlBase + "Temporal_CargaInicial_ajax.asp"
                , method: "post"
                , async: true 
                , data: {
                    Tarea: 3
                    , Ubi_ID: $("#Ubi_ID").val()
                    , Ubi_Nombre: sUbicacion
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
            
            if( intUbi_ID == "" ){
               intUbi_ID = $("#Ubi_ID").val();
               if( intUbi_ID == -1 ){
                   intUbi_ID = ""
               } 
            }            
            
            if( intUbi_ID == "" ){
                bolError = true;
                arrError.push("- Seleccionar la Ubicacion Destino");
            }

            if( strLPN == "" ){
                bolError = true;
                arrError.push("- Agregar el LPN");
            }

            if( bolError ){
                Avisa("warning", "Ubicacion", "Verificar Formulario<br>" + arrError.join("<br>"));
            } else {

                $.ajax({
                    url: urlBase + "Temporal_CargaInicial_ajax.asp"
                    , method: "post"
                    , async: true
                    , dataType: "json"
                    , data: {
                          Tarea: 1
                        , Ubi_ID: intUbi_ID
                        , LPN: strLPN
                        , IDUsuario: intIDUsuario
                    }
                    , success: function(res){

                        if(res.Error.Numero == 0){
                            Avisa("success", "Series", res.Error.Descripcion);

                            Temporal.LPNLimpiar();
                            Temporal.LPNPorBuscarListadoCargar();
                            Temporal.LPNListadoCargar();

                        } else {
                            Avisa("danger", "Series", res.Error.Descripcion);
                        }
                    }
                });
            }
        }
        , LPNPorBuscarPoner: function(){
            
            var jsonPrm = ( !( arguments[0] == undefined ) ) ? arguments[0] : {};
            var intPT_ID = ( !( jsonPrm.PT_ID == undefined ) ) ? jsonPrm.PT_ID : -1;

            var arrError = [];
            var bolError = false;

            if( !(intPT_ID > - 1) ){
                bolError = true;
                arrError.push("- Seleccionar el LPN que estará por buscar");
            }

            if( bolError ){
                Avisa("warning", "LPN", "Verificar el formulario<br>" + arrError.join("<br>"));
            } else {

                $.ajax({
                    url: urlBase + "Temporal_CargaInicial_ajax.asp"
                    , method: "post"
                    , async: true
                    , dataType: "json"
                    , data: {
                        Tarea: 2
                        , PT_ID: intPT_ID
                    }
                    , success: function(res){
                        if( res.Error.Numero == 0 ){
                            Avisa("success", "LPN", res.Error.Descripcion);
                            Temporal.LPNPorBuscarListadoCargar();
                            Temporal.LPNListadoCargar();
                        } else {
                            Avisa("warning", "LPN", res.Error.Descripcion);
                        }
                    }
                });
            }
        }
        , LPNPorBuscarListadoCargar: function(){
            
            $.ajax({
                url: urlBase + "Temporal_CargaInicial_ajax.asp"
                , method: "post"
                , async: true
                , data: {
                    Tarea: 4
                }
                , success: function(res){
                    $("#divPalletPerdidos").html(res);
                }
            });

        }
        , LPNSeleccionar: function(){
            var jsonPrm = ( !(arguments[0] == undefined) ) ? arguments[0] : {};
            var intLPN = ( !(jsonPrm.LPN == undefined ) ) ? jsonPrm.LPN : "";

            $("#inpLPN").val(intLPN);
        }
        , UbicacionSeleccionVisualizar: function(){
            var bolVisualiza = $("#chkUbicacion").is(":checked");

            if( bolVisualiza ){
                $(".Seleccion").show();
                $(".select2").show();
                $(".Escaneo").hide();
            } else {
                $(".Seleccion").hide();
                $(".select2").hide();
                $(".Escaneo").show();
            }
        }
        , UbicacionSeleccionar: function( e ){

            tecla = (document.all) ? e.keyCode : e.which;

            if( tecla == 13 ){

                var strUbicacion = $("#inpUbicacion").val();
                    strUbicacion = strUbicacion.toUpperCase()
                var intUbi_ID = -1

                $("#selUbicacion").find("option").each(function(){
                    if( $(this).text().trim().toUpperCase() == strUbicacion ){
                        strUbicacion = $(this).text().trim()
                        intUbi_ID = $(this).val();
                    }
                });

                $("#selUbicacion").val(intUbi_ID);
                $("#select2-selUbicacion-container").text(strUbicacion);
                
                $("#Ubi_ID").val(intUbi_ID);

                Temporal.LPNListadoCargar();
                
                $("#inpUbicacion").val("");
                $("#selUbicacion").val("");
                $("#select2-selUbicacion-container").text("TODOS");
            }

        }
    }

</script>

<div id="wrapper">
    <div class="wrapper wrapper-content">    
        <div class="row">
            <div class="col-sm-8">
                <div class="ibox">
                    <div class="ibox-title">
                        <h5>Filtros de b&uacute;squeda</h5>
                        <div class="ibox-tools">
    
                        </div>
                    </div>
                    <div class="ibox-content">
                        <div class="row"> 
                            <div class="col-sm-12 m-b-xs">  
                               
                                <div class="row">
                                    <label class="col-sm-2 control-label">
                                        Ubicaci&oacute;n:
                                    </label>    
                                    <div class="col-sm-1 m-b-xs">
                                        <input type="checkbox" id="chkUbicacion" value="0" onclick="Temporal.UbicacionSeleccionVisualizar()" title="Seleccionar la ubicaci&oacute;n">
                                    </div>
                                    <div class="col-sm-4 m-b-xs">
                                        <input type="text" id="inpUbicacion" class="form-control Escaneo" autocomplete="off" placeholder="Ubicaci&oacute;n"
                                         onkeypress="Temporal.UbicacionSeleccionar(event);">
                                        
                                        <select id="selUbicacion" class="Seleccion form-control" style="display: none;">

                                        </select>
                                        
                                    </div>
                                    <div class="col-sm-3 m-b-xs">
                                         <button class="btn btn-success btn-sm Seleccion" type="button" id="btnBusLPN" title="Buscar"
                                         onclick="Temporal.LPNListadoCargar()" style="display: none;">
                                            <i class="fa fa-search"></i> Buscar
                                        </button>
                                    </div>
                                </div>
                                <div class="row">
                                    <label class="col-sm-3 control-label">LPN:</label>    
                                    <div class="col-sm-4 m-b-xs">
                                        <input type="text" id="inpLPN" class="form-control" placeholder="LPN" autocomplete="off">
                                    </div>
                                    <div class="col-sm-3 m-b-xs">
                                        <button class="btn btn-success btn-sm" type="button" id="btnSurtir" onclick="Temporal.LPNMover()">
                                            <i class="fa fa-share"></i> Mover LPN
                                        </button>
                                    </div>
                                       
                                </div>      
                                <div class="row">
                                    <div class="col-sm-12 m-b-xs" id="divLPN">
                                        
                                    </div>
                                </div>
                                    
                            </div>
                        </div>
                    </div>
                </div>
                <div id="divLPN">
                    
                </div>
            </div>
            <div class="col-sm-4" id="divPalletPerdidos">
                    
            </div>
        </div>
    </div>
</div>
<input type="hidden" name="Ubi_ID" id="Ubi_ID" value="-1">

