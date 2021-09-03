<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>

<!--#include file="../../../Includes/iqon.asp" -->  
<%
// HA ID: 1 2020-NOV-12 Movimiento: Creación de archivo

var urlBase = "/pz/wms/Almacen/"
var urlBaseTemplate = "/Template/inspina/";

%>
<link href="<%= urlBaseTemplate %>css/plugins/select2/select2.min.css" rel="stylesheet">

<!-- Select2 -->
<script src="<%= urlBaseTemplate %>js/plugins/select2/select2.full.min.js"></script>

<script src="<%= urlBaseTemplate %>js/plugins/metisMenu/jquery.metisMenu.js"></script>
<script src="<%= urlBaseTemplate %>js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
<script src="<%= urlBaseTemplate %>js/inspinia.js"></script>
<script src="<%= urlBaseTemplate %>js/plugins/pace/pace.min.js"></script>

<!-- Librerias-->
<script type="text/javascript" src="<%= urlBase %>Ubicacion/js/Ubicacion.js"></script>
<script type="text/javascript">
 
    $(document).ready(function(){

        Ubicacion.ComboCargar();
//        TemporalCargaInicialCantidad.LPNPorBuscarListadoCargar();

        $("#selUbicacion").select2();
        $(".select2").hide();
    })

    var urlBase = "<%= urlBase %>";

    var TemporalCargaInicialCantidad = {
          LPNCambiarConteoFisico: function(){
            
            var jsonPrm = ( !( arguments[0] == undefined ) ) ? arguments[0] : {};
            var intPT_ID = ( !( jsonPrm.PT_ID == undefined ) ) ? jsonPrm.PT_ID : -1;

            var intConteoFisico = $("#ConteoFisico_" + intPT_ID).val();

            var bolError = false;
            var arrError = [];

            if( !(intPT_ID > -1) ){
                bolError = true;
                arrError.push("-Seleccionar el identificador del Pallet");
            }

            if( !(parseInt(intConteoFisico) > 0) ){
                bolError = true;
                arrError.push("-Agregar Cantidad mayor a cero");
            }

            if( bolError ){
                Avisa("warning", "Carga Inicial", "Verificar Formulario<br>" + arrError.join("<br>"));
            } else {
                $.ajax({
                    url: urlBase + "Temporal_CargaInicialCantidad_ajax.asp"
                    , method: "post"
                    , async: false
                    , dataType: "json"
                    , data: {
                          Tarea: 5
                        , PT_ID: intPT_ID
                        , ConteoFisico: intConteoFisico
                    }
                    , success: function(res){
                        if( res.Error.Numero == 0 ){
                            Avisa("success", "Carga Inicial", res.Error.Descripcion);
                        } else {
                            Avisa("warning", "Carga Inicial", res.Error.Descripcion);
                        }
                    }
                });    
            }     
        }
        , LPNLimpiar: function(){

            $("#inpLPN").val("");
            $("#inpCantidadReal").val("");
            $("#divUbicacion").html("");
            $("#inpLPNUbicacion").val("");

        }
        , LPNListadoCargar: function(){

            var intUbi_ID = $("#selUbicacion").val();

            $("#loading").show('slow');

            $.ajax({
                url: urlBase + "Temporal_CargaInicialCantidad_ajax.asp"
                , method: "post"
                , async: false
                , data: {
                    Tarea: 3
                    , Ubi_ID: intUbi_ID
                }
                , success: function(res){
                    $("#loading").hide('slow');
                    $("#divLPN").html(res);
                }
            });

        }
        , LPNMover: function(){

            var strLPNUbicacion = $("#inpLPNUbicacion").val();

            var strLPN = $("#inpLPN").val();
            var intCantidadReal = $("#inpCantidadReal").val();
            var intIDUsuario = $("#IDUsuario").val();

            var bolError = false;
            var arrError = [];

            if( strLPNUbicacion == "" ){
                bolError = true;
                arrError.push("- Agregar la Ubicacion Destino");
            }

            if( strLPN == "" ){
                bolError = true;
                arrError.push("- Agregar el LPN");
            }

            if( !( parseInt(intCantidadReal) > 0) ){
                bolError = true;
                arrError.push("- Agregar la Cantidad");
            }

            if( bolError ){
                Avisa("warning", "Ubicacion", "Verificar Formulario<br>" + arrError.join("<br>"));
            } else {

                $.ajax({
                    url: urlBase + "Temporal_CargaInicialCantidad_ajax.asp"
                    , method: "post"
                    , async: false
                    , dataType: "json"
                    , data: {
                          Tarea: 1
                        , LPNUbicacion: strLPNUbicacion
                        , LPN: strLPN
                        , CantidadReal: intCantidadReal
                        , IDUsuario: intIDUsuario
                    }
                    , success: function(res){

                        if(res.Error.Numero == 0){
                            Avisa("success", "Series", res.Error.Descripcion);

                            TemporalCargaInicialCantidad.LPNLimpiar();
                            TemporalCargaInicialCantidad.LPNPorBuscarListadoCargar();
                            TemporalCargaInicialCantidad.LPNListadoCargar();

                        } else {
                            Avisa("warning", "Series", res.Error.Descripcion);
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
                    url: urlBase + "Temporal_CargaInicialCantidad_ajax.asp"
                    , method: "post"
                    , async: false
                    , dataType: "json"
                    , data: {
                        Tarea: 2
                        , PT_ID: intPT_ID
                    }
                    , success: function(res){
                        if( res.Error.Numero == 0 ){
                            Avisa("success", "LPN", res.Error.Descripcion);
                            TemporalCargaInicialCantidad.LPNPorBuscarListadoCargar();
                            TemporalCargaInicialCantidad.LPNListadoCargar();
                        } else {
                            Avisa("warning", "LPN", res.Error.Descripcion);
                        }
                    }
                });
            }
        }
        , LPNPorBuscarListadoCargar: function(){
            
            $.ajax({
                url: urlBase + "Temporal_CargaInicialCantidad_ajax.asp"
                , method: "post"
                , async: false
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
            var intCantidad = ( !(jsonPrm.Cantidad == undefined) ) ? jsonPrm.Cantidad : "";

            $("#inpLPN").val(intLPN);
            $("#inpCantidadReal").val(intCantidad);
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
                
                strUbicacion = strUbicacion.replace(/[\']/g, "-");

                $("#inpUbicacion").val(strUbicacion);
               
                var intUbi_ID = -1

                $("#selUbicacion").find("option").each(function(){
                    if( $(this).text().trim().toLowerCase() == strUbicacion.toLowerCase() ){
                    intUbi_ID = $(this).val();
                    }
                });

                $("#selUbicacion").val(intUbi_ID);
                $("#select2-selUbicacion-container").text(strUbicacion);

                TemporalCargaInicialCantidad.LPNListadoCargar();
                
            }

        }
        , UbicacionSeleccionarLimpiar: function(){
            $("#inpUbicacion").val("");
            $("#selUbicacion").val("");
            $("#select2-selUbicacion-container").text("TODOS");
        }
        , ImprimirLPN: function(){
            var jsonPrm = ( !(arguments[0] == undefined) ) ? arguments[0] : {};
            var intPT_ID = ( !(jsonPrm.PT_ID == undefined ) ) ? jsonPrm.PT_ID : -1;
            var url = "/pz/wms/Almacen/ImpresionLPN.asp?PT_ID="+intPT_ID+"";
        
            window.open(url, "Impresion Papeleta" );
        }
        , ImprimirAuditoria: function(){
            var jsonPrm = ( !(arguments[0] == undefined) ) ? arguments[0] : {};
            var intPT_ID = ( !(jsonPrm.PT_ID == undefined ) ) ? jsonPrm.PT_ID : -1;
            var url = "/pz/wms/Auditoria/Impresion_Papeleta2.asp?Aud_ID=1&PT_ID="+intPT_ID+"";
        
            window.open(url, "Impresion Papeleta" );
        }
        , SeriesModalAbrir: function(){

            var jsonPrm = ( !(arguments[0] == undefined) ) ? arguments[0] : {};
            var intPT_ID = ( !(jsonPrm.PT_ID == undefined ) ) ? jsonPrm.PT_ID : -1;
            var intUbi_ID = ( !(jsonPrm.Ubi_ID == undefined ) ) ? jsonPrm.Ubi_ID : -1; 
            var intPT_LPN = ( !(jsonPrm.PT_LPN == undefined ) ) ? jsonPrm.PT_LPN : "";
            var intUbi_Nombre = ( !(jsonPrm.Ubi_Nombre == undefined ) ) ? jsonPrm.Ubi_Nombre : ""; 

            this.SeriesModalLimpiar();

            $("#hidMdlCIUbi_ID").val(intUbi_ID);
            $("#hidMdlCIPT_ID").val(intPT_ID);
            $("#bMdlCIPT_LPN").text(intPT_LPN);
            $("#bMdlCIUbi_Nombre").text(intUbi_Nombre);

            $("#mdlCISerie").modal('show');

            this.SeriesModalListar();
        }
        , SeriesModalGuardarEscaner: function( prmEvent ){

            var tecla = (document.all) ? prmEvent.keyCode : prmEvent.which;

            if( tecla == 13 ){
                this.SeriesModalGuardar();
            }
        }
        , SeriesModalGuardar: function(){

            var strSerie = $("#inpMdlCISerie").val();
            var intPT_ID = $("#hidMdlCIPT_ID").val();
            var intUbi_ID = $("#hidMdlCIUbi_ID").val();

            var bolError = false;
            var arrError = [];

            if( !(intPT_ID > -1) && !(intUbi_ID > -1) ){
                bolError = true;
                arrError.push("Identificadores del Pallet y la ubicacion No Permitidos");
            }

            if(strSerie == ""){
                bolError = true;
                arrError.push("Escanear la Serie correcta");
            }

            if( bolError ){
                Avisa("warning", "Series Escaneadas", arrError.join("<br>"));
            } else {

                $.ajax({
                      url: urlBase + "Temporal_CargaInicialCantidad_ajax.asp"
                    , method: "post"
                    , async: true
                    , dataType: "json"
                    , data: {
                          Tarea: 2010
                        , PT_ID: intPT_ID
                        , Ubi_ID: intUbi_ID
                        , Serie: strSerie
                    }
                    , success: function( res ){
                        if( res.Error.Numero == 0){

                            Avisa("success", "Serie Escaneada", res.Error.Descripcion);

                            $("#lblMdlCITotal").text(res.Registro.ICIS_Total);

                            var color = ""
                            switch (parseInt(res.Registro.ICIS_ErrorNumero)) {
                                case 0:{
                                    color = "bg-info"  
                                } break;
                                case 1:{
                                    color = "bg-warning"
                                } break;
                                case -1:{
                                    color = "bg-danger"
                                } break;
                            
                                default:
                                    break;
                            }

                            $("<tr class='"+color+"'><td>"+res.Registro.Inv_Serie+"</td><td>"+res.Registro.ICIS_ErrorDescripcion+"</td></tr>").insertAfter( "#Encabezado");

                            TemporalCargaInicialCantidad.SeriesModalLimpiarSerie();

                        } else {
                            Avisa("warning", "Serie Escaneada", res.Error.Descripcion);
                        }
                    }
                });
            }

        }
        , SeriesModalListar: function(){

            var intPT_ID = $("#hidMdlCIPT_ID").val();
            var intUbi_ID = $("#hidMdlCIUbi_ID").val();

            var bolError = false;
            var arrError = [];

            if( !(intPT_ID > -1) && !(intUbi_UD > -1) ){
                bolError = true;
                arrError.push("Identificadores del Pallet y la ubicacion No Permitidos");
            }

            if( bolError ){
                Avisa("warning", "Series Escaneadas", arrError.join("<br>"));
            } else {

                $.ajax({
                      url: urlBase + "Temporal_CargaInicialCantidad_ajax.asp"
                    , method: "post"
                    , async: true
                    , data: {
                          Tarea: 1100
                        , PT_ID: intPT_ID
                        , Ubi_ID: intUbi_ID
                    }
                    , success: function( res ){
                        
                        $("#divMdlCIListado").html(res);

                    }
                });
            }

        }
        , SeriesModalLimpiar: function(){
            $("#hidMdlCIUbi_ID").val("");
            $("#hidMdlCIPT_ID").val("");
            $("#bMdlCIPT_LPN").text("");
            $("#bMdlCIUbi_Nombre").text("");
            $("#lblMdlCITotal").text("0");

            /*
            $("#divMdlCIListado tr").each(function(){
                if( $(this).prop("id") != "Encabezado" ){
                    $(this).remove();
                }
            })
            */
        }
        , SeriesModalCerrar: function(){
            this.SeriesModalListar();
            $("#mdlCISerie").modal('hide');
        }
        , SeriesModalLimpiarSerie: function(){
            $("#inpMdlCISerie").val("");
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
                            <button class="btn btn-white btn-xs" type="button" title="Limpiar Busqueda"
                                onclick="TemporalCargaInicialCantidad.UbicacionSeleccionarLimpiar();">
                                <i class="fa fa-eraser"></i> Limpiar
                            </button>
                            <button class="btn btn-success btn-xs Seleccion" type="button" id="btnBusLPN" title="Buscar"
                                onclick="TemporalCargaInicialCantidad.LPNListadoCargar()" style="display: none;">
                                <i class="fa fa-search"></i> Buscar
                            </button>
                        </div>
                    </div>
                    <div class="ibox-content">
                        <div class="row"> 
                            <div class="col-sm-12 m-b-xs">  
                               
                                <div class="row">
                                    <label class="col-sm-2 control-label">
                                        Ubicaci&oacute;n:
                                    </label>    
                                    <div class="col-sm-4 m-b-xs">
                                        <input type="text" id="inpUbicacion" class="form-control input-sm Escaneo" autocomplete="off" placeholder="Ubicaci&oacute;n"
                                         onkeypress="TemporalCargaInicialCantidad.UbicacionSeleccionar(event);">
                                        
                                        <select id="selUbicacion" class="Seleccion form-control input-sm" style="display: none;">

                                        </select>                                        
                                    </div>

                                    <div class="col-sm-6 m-b-xs">
                                        <input type="checkbox" id="chkUbicacion" value="0" onclick="TemporalCargaInicialCantidad.UbicacionSeleccionVisualizar()" title="Seleccionar la ubicaci&oacute;n">
                                         Seleccionar Ubicaci&oacute;n
                                    </div>
                                    
                                </div>
                                   
                            </div>
                        </div>
                    </div>
                </div>
                <div class="ibox">
                    <div class="ibox-title">
                        <h5>Mover LPN</h5>
                        <div class="ibox-tools">
                            <button class="btn btn-white btn-xs" type="button" onclick="TemporalCargaInicialCantidad.LPNLimpiar()">
                                <i class="fa fa-eraser"></i> Limpiar
                            </button>
                            <button class="btn btn-success btn-xs" type="button" onclick="TemporalCargaInicialCantidad.LPNMover()">
                                <i class="fa fa-share"></i> Mover LPN
                            </button>
                        </div>
                    </div>
                    <div class="ibox-content">
                        <div class="row"> 
                            <div class="col-sm-12 m-b-xs">  
                                <div class="row">
                                    <label class="col-sm-2 control-label">Ubicaci&oacute;n:</label>    
                                    <div class="col-sm-4 m-b-xs">
                                        <input type="text" id="inpLPNUbicacion" class="form-control input-sm" placeholder="Ubicaci&oacute;n" autocomplete="off">
                                    </div>
                                    <label class="col-sm-2 control-label"></label>    
                                    <div class="col-sm-4 m-b-xs">
                                        
                                    </div>
                                </div>

                                <div class="row">
                                    <label class="col-sm-2 control-label">LPN:</label>    
                                    <div class="col-sm-4 m-b-xs">
                                        <input type="text" id="inpLPN" class="form-control input-sm" placeholder="LPN" autocomplete="off">
                                    </div>

                                    <label class="col-sm-2 control-label">Cantidad:</label>    
                                    <div class="col-sm-4 m-b-xs">
                                        <input type="text" id="inpCantidadReal" class="form-control input-sm" placeholder="Cantidad" autocomplete="off">
                                    </div>

                                </div>   
                            </div>
                        </div>
                    </div>
                </div>
                <div>
                    <div class="text-center" id="loading" style="display: none;">
                        <div class="spiner-example">
                            <div class="sk-spinner sk-spinner-three-bounce">
                                <div class="sk-bounce1"></div>
                                <div class="sk-bounce2"></div>
                                <div class="sk-bounce3"></div>
                            </div>
                        </div>
                        <div>Cargando informaci&oacute;n, espere un momento...</div>
                    </div>
                    <div id="divLPN">

                    </div>
                </div>
            </div>
            <div class="col-sm-3" id="divPalletPerdidos">
                    
            </div>
        </div>
    </div>
</div>
<!--div id="GridSerieEscaneo" class="modal fade" tabindex="-1" data-width="1250" data-height="400" style="display: none;" aria-hidden="false"></div-->

 <div id="GridSerieEscaneo" class="modal fade">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <!-- Content will be loaded here from "remote.asp" file -->
          
        </div>
    </div>
</div> 
  
  
<div class="modal fade" id="mdlCISerie" tabindex="-1" role="dialog" aria-labelledby="divCISerie" aria-hidden="true" style="display: none;">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close" onclick="TemporalCargaInicialCantidad.SeriesModalCerrar()">
                    <span aria-hidden="true">&times;</span>
                </button>
                <h2 class="modal-title" id="divCISerie">
                    <i class="fa fa-file-text-o"></i> Escanear Series
                    <br />
                    <h3>
                        LPN: <b id="bMdlCIPT_LPN"> </b>
                        <br>
                        Ubicacion: <b id="bMdlCIUbi_Nombre"> </b>
                    </h3>
                </h2>
                
            </div>
            <div class="modal-body">

                <input type="hidden" id="hidMdlCIUbi_ID" value="">
                <input type="hidden" id="hidMdlCIPT_ID" value="">
                <div class="form-group row">
                    
                        <label class="col-sm-1 control-label">Serie: </label>    
                        <div class="col-sm-4 m-b-xs">
                            <input type="text" id="inpMdlCISerie" placeholder="Serie" class="form-control"
                            onkeypress="TemporalCargaInicialCantidad.SeriesModalGuardarEscaner( event );"
                            maxlength="50" autocomplete="off">
                        </div>

                        <div class="col-sm-2 m-b-xs">
                            <small>Total Series:</small>
                            <br>
                            <h3 class="text-success" id="lblMdlCITotal">

                            </h3>
                        </div>

                        <div class="col-sm-2 m-b-xs">
                            <a id="btnMdlCISerieGuardar" class="btn btn-sm btn-success"
                            onclick="TemporalCargaInicialCantidad.SeriesModalGuardar();">
                                <i class="fa fa-floppy-o"></i> Guardar
                            </a>
                        </div>
                       
                    
                </div>
               
                <div class="form-group row" id="divMdlCIListado" style="height: 250px; overflow: auto;">
                    <table class="table table">
                        <tr id="Encabezado">
                            <th class="col-sm-6">Serie</th>
                            <th class="col-sm-6">Error</th>
                        </tr>
                    </table>
                </div>
                             
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-secondary btn-seg" data-dismiss="modal" onclick="TemporalCargaInicialCantidad.SeriesModalCerrar();">
                    <i class="fa fa-times"></i> Cerrar
                </button>
            </div>
        </div>
    </div>
</div>
  
<script type="text/javascript" language="javascript">
  
  //$('#GridSerieEscaneo').modal();
  //$("#GridSerieEscaneo").modal('show');
    /*
		var $modal = $('#ajax-GridSerieEscaneo');
		$('.btnModalSeries').on('click', function () {
			//$('body').modalmanager('loading');
		var sDatos = "ParamI=3"
			//alert(sDatos);
			// create the backdrop and wait for next modal to be triggered
			//$('body').modalmanager('loading');
			setTimeout(function () {
				$modal.load('/pz/wms/Almacen/CargaSeriesEscaneo.asp?'+sDatos, '', function () {
					$modal.modal();
					
				});
			}, 1000);
		});  
  */
  
  
  
  
</script>  
  
  
  