<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2020-NOV-12 Movimiento: Creación de archivo

var urlBase = "/pz/wms/Almacen/"
var urlBaseTemplate = "/Template/inspina/";

var cxnTipo = 0

%>
<link href="<%= urlBaseTemplate %>css/plugins/select2/select2.min.css" rel="stylesheet">

<!-- Loading -->
<script src="<%= urlBaseTemplate %>js/loading.js"></script>

<!-- Select2 -->
<script src="<%= urlBaseTemplate %>js/plugins/select2/select2.full.min.js"></script>
<script src="<%= urlBaseTemplate %>js/loading.js"></script>
<script src="/Template/inspina/js/plugins/sheetJs/xlsx.full.min.js"></script>

<script type="text/javascript" src="<%= urlBase %>Ubicacion/js/Ubicacion.js"></script>

<script type="text/javascript">
    
    $(document).ready(function(){

        Ubicacion.ComboCargar();
        Catalogo.ComboCargar({
              SEC_ID: 83
            , Cat_Maximo: 1
            , Contenedor: "selTipoMovimiento"
        });

        $("#selUbicacion").select2();
        $("#selTipoMovimiento").select2();
    })

    var urlBase = "<%= urlBase %>";

    var Temporal = {
        Buscar: function(){

            
            var strBuscar = $("#txaBuscar").val();
            var intTipoSeleccion = $("input[name=TipoSeleccion]:checked").val()

            var arrBuscar = strBuscar.trim().split("\n");

            var arrError = [];
            var bolError = false;

            if( arrBuscar.length == 0 ){
                arrError.push("- Agregar la Serie o LPN a buscar");
                bolError = true;
            }

            if( !(intTipoSeleccion > 0) ){
                arrError.push("- Seleccionar la opcion a buscar");
                bolError = true;
            }

            if( bolError ){
                Avisa("warning", "Movimientos", "Verificar el Formulario<br>" + arrError.join("<br>"));
            } else {
                
                Cargando.Iniciar();
                $("#btnBuscar").prop("disabled", true);

                this.BuscadosLimpiar();
                this.MovidosLimpiar();

                $.ajax({
                    url: urlBase + "Temporal_movimiento_ajax.asp"
                    , method: "post"
                    , async: true
                    , cache: false
                    , data: {
                        Tarea: 1
                        , Buscar: arrBuscar.join(",")
                        , TipoSeleccion: intTipoSeleccion
                    }
                    , success: function( res ){
                        $("#Lot_ID").val("");
                        $("#divBuscados").html(res);
                        Temporal.SeleccionadosContar();
                        Cargando.Finalizar();
                        $("#btnBuscar").prop("disabled", false);
                    }
                })
            }
        }
        , BuscadosLimpiar: function(){
            $("#divBuscados").html("");
        }
        , LPNImprimir: function(){
            var intPT_ID = $("#PT_ID").val();

            window.open("/pz/wms/Almacen/ImpresionLPN.asp?PT_ID="+intPT_ID+"&Tipo=2" );
        }
        , Limpiar: function(){
            $("#txaBuscar").val("");
            $("input[name=TipoSeleccion]").prop("checked", false);
        }
        , Mover: function(){
            var arrError = [];
            var bolError = false;

            var arrSeries = [];

            var intUbi_ID = $("#selUbicacion").val();
            var intIDUsuario = $("#IDUsuario").val();
            var intTipoMovimiento = $("#selTipoMovimiento").val();
            var intPermanece = ( $("#chbAgrupar").is(":checked") ) ? 0 : 1;

            $(".Serie:checked").each(function(){
                arrSeries.push( $(this).val() );
            });

            if( arrSeries.length == 0 ){
                arrError.push("- Seleccionar las Series a mover");
                bolError = true;
            }

            if( intUbi_ID == "" ){
                arrError.push("- Seleccionar la ubicacion a mover");
                bolError = true;
            }

            if( intTipoMovimiento == "" ){
                arrError.push("- Seleccionar el Tipo de Movimiento");
                bolError = true;
            }

            if( bolError ){
                Avisa("warning", "Series", "Verificar el formulario <br>" + arrError.join("<br>"));
            } else {

                Cargando.Iniciar();
                $("#btnMover").prop("disabled", true);

                $.ajax({
                    url: urlBase + "Temporal_Movimiento_ajax.asp"
                    , method: "post"
                    , async: true
                    , dataType: "json"
                    , data: {
                        Tarea: 2
                        , Ubi_ID: intUbi_ID
                        , Series: arrSeries.join(",")
                        , TipoMovimiento: intTipoMovimiento
                        , Permanece: intPermanece
                        , IDUsuario: intIDUsuario
                    }
                    , success: function(res){
                        if(res.Error.Numero == 0){
                            Avisa("success", "Movimiento", res.Error.Descripcion);

                            $("#PT_ID").val(res.Datos.PT_ID);
                            $("#Lot_ID").val(res.Datos.Lot_ID);

                            Cargando.Finalizar();

                            Temporal.BuscadosLimpiar();
                            Temporal.SeriesListar();
                            $("#btnMover").prop("disabled", false);

                        } else {
                            Avisa("danger", "Movimiento", res.Error.Descripcion);
                            Cargando.Finalizar();
                        }
                    }
                });

            }
        }
        , MovidosExportar: function(){
            var strLote = $("#Lot_ID").val();

            $.ajax({
                url: urlBase + "Temporal_Movimiento_ajax.asp"
                , method: "post"
                , asyn: true
                , dataType: "json"
                , data: {
                    Tarea: 4
                    , Lot_IDs: strLote
                }
                , success: function(res){
                    var xlsData = XLSX.utils.json_to_sheet( res );
                    var xlsBook = XLSX.utils.book_new(); 

                    XLSX.utils.book_append_sheet(xlsBook, xlsData, "SeriesMovidas");

                    XLSX.writeFile(xlsBook, "SeriesMovidas.xlsx");
                }
            });
        }
        , MovidosLimpiar: function(){
            $("#divMovidos").html("");
        }
        , SeleccionadosContar: function(){
            
            var intTotSel = $(".Serie:checked").length;

            $("#selTotalBuscados").text(intTotSel);
        }
        , SeriesListar: function(){
            var strLote = $("#Lot_ID").val();

            $.ajax({
                url: urlBase + "Temporal_Movimiento_ajax.asp"
                , method: "post"
                , asyn: true
                , data: {
                    Tarea: 3
                    , Lot_IDs: strLote
                }
                , success: function(res){
                    $("#divMovidos").html(res);
                }
            });
        }
        , SeleccionarTodos: function(prmObjeto){

            var bolCheck = $(prmObjeto).is(':checked');

            $(".Todos").prop("checked", bolCheck);

            Temporal.SeleccionadosContar();
        }
        , SeleccionarPallet: function(prmObjeto){
            var bolCheck = $(prmObjeto).is(':checked');
            var intPT_ID = $(prmObjeto).val();

            $(".Todos").each(function(){
                if( $(this).data("pt_id") == intPT_ID){
                    $(this).prop("checked", bolCheck);
                }
            })

             Temporal.SeleccionadosContar();

        }
        , SeleccionarMasterBox: function(prmObjeto){
            var bolCheck = $(prmObjeto).is(':checked');
            var intPT_ID = $(prmObjeto).data("pt_id");
            var intMB_ID = $(prmObjeto).val();

            var totPT = 0;
            var totPTChe = 0;

            //abajo
            $(".Serie").each(function(){
                if( $(this).data("pt_id") == intPT_ID &&  $(this).data("mb_id") == intMB_ID){
                    $(this).prop("checked", bolCheck);
                }
            })

            //arriba Pallet
            $(".MasterBox").each(function(){
                if( $(this).data("pt_id") == intPT_ID){
                    totPT++;
                    if( $(this).is(":checked") ){
                        totPTChe++;
                    }
                }
            })

            var bolPallet = (totPT == totPTChe)

            $(".Pallet").each(function(){

                if( $(this).val() == intPT_ID){
                    $(this).prop("checked", bolPallet);
                }
            })

             Temporal.SeleccionadosContar();

        }
        , SeleccionarSerie: function(prmObjeto){
            var bolCheck = $(prmObjeto).is(':checked');

            var intPT_ID = $(prmObjeto).data("pt_id");
            var intMB_ID = $(prmObjeto).data("mb_id");

            var totMB = 0;
            var totMBChe = 0;
                
            var totPT = 0;
            var totPTChe = 0;

            //Arriba Series
            $(".Serie").each(function(){
                if( $(this).data("pt_id") == intPT_ID && $(this).data("mb_id") == intMB_ID){
                    totMB++;
                    if( $(this).is(":checked") ){
                        totMBChe++;
                    }
                }
            })

            var bolMasterBox = (totMB == totMBChe)
            
            $(".MasterBox").each(function(){
                if( $(this).data("pt_id") == intPT_ID && $(this).val() == intMB_ID ){
                    $(this).prop("checked", bolMasterBox);
                }
            })

            //Arriba MasterBox
            $(".MasterBox").each(function(){
                if( $(this).data("pt_id") == intPT_ID){
                    totPT++;
                    if( $(this).is(":checked") ){
                        totPTChe++;
                    }
                }
            })

            var bolPallet = (totPT == totPTChe)

            $(".Pallet").each(function(){
                if( $(this).val() == intPT_ID){
                    $(this).prop("checked", bolPallet);
                }
            })
            
            Temporal.SeleccionadosContar();

        }
    }

</script>
<div id="wrapper">
    <div class="wrapper wrapper-content">    
        <div class="row">
            <div class="col-sm-12">
                <div class="ibox">
                    <div class="ibox-title">
                        <h5>Filtros de b&uacute;squeda</h5>
                        <div class="ibox-tools">
                            <button class="btn btn-white btn-sm" type="button" id="btnLimpiar" onclick="Temporal.Limpiar()">
                                <i class="fa fa-eraser"></i> Limpiar
                            </button>
                            <button class="btn btn-success btn-sm" type="button" id="btnBuscar" onclick="Temporal.Buscar()">
                                <i class="fa fa-search"></i> Buscar
                            </button>

                        </div>
                    </div>
                    <div class="ibox-content">

                        <div class="row">

                            <label class="col-sm-3 control-label">
                                Tipo de Seleccion:
                            </label>
                            <label class="col-sm-2 control-label">
                                <input type="radio" name="TipoSeleccion" value="1"> Serie
                            </label>
                            <label class="col-sm-2 control-label">
                                <input type="radio" name="TipoSeleccion" value="2"> MasterBox
                            </label>
                            <label class="col-sm-2 control-label">
                                <input type="radio" name="TipoSeleccion" value="3"> LPN
                            </label>
                            <label class="col-sm-2 control-label">
                                <input type="radio" name="TipoSeleccion" value="4"> SKU
                            </label>

                        </div>

                        <div class="row">

                            <label class="col-sm-3 control-label"> 
                                Buscar:
                            </label>    
                            <div class="col-sm-3 m-b-xs">
                                <textarea id="txaBuscar" class="form-control" placeholder="Series/LPN"></textarea>
                            </div>
                            <div class="col-sm-3 m-b-xs">
                              
                            </div>    
                            <div class="col-sm-3 m-b-xs"> 
                                
                            </div>
                        
                        </div>

                    </div>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-sm-12">
                <div class="ibox">
                    <div class="ibox-title">
                        <h5>Resultados de la Busqueda</h5>
                        <div class="ibox-tools">
                            <button class="btn btn-success btn-sm" type="button" id="btnMover" onclick="Temporal.Mover()">
                                <i class="fa fa-share"></i> Mover
                            </button>
                            <input type="hidden" id="PT_ID" value="">
                            <input type="hidden" id="Lot_ID" value="">
                        </div>
                    </div>
                    <div class="ibox-content">
                        <div class="row">
                            <label class="col-sm-3 control-label"> 
                                Ubicacion:
                            </label>    
                            <div class="col-sm-3 m-b-xs">
                               <select id="selUbicacion" class="form-control">

                               </select>
                            </div>
                            <label class="col-sm-3 control-label">
                                Tipo de Movimiento
                            </label>    
                            <div class="col-sm-3 m-b-xs"> 
                                <select id="selTipoMovimiento" class="form-control">

                                </select>
                            </div>
                        </div>
                        <div class="row">
                            <label class="col-sm-3 control-label"> 
                                Agrupar el LPN
                            </label>    
                            <div class="col-sm-3 m-b-xs">
                               <input type="checkbox" id="chbAgrupar">
                            </div>
                            
                        </div>
                        <div class="row">
                            <label class="col-sm-6 m-b-xs">
                                Series Buscadas
                            </label>
                            <label class="col-sm-3 m-b-xs">
                                Series Movidas
                            </label>
                            <div class="col-sm-3 m-b-xs text-right"> 
                               
                                <a class="btn btn-info btn-sm" onclick="Temporal.MovidosExportar()">
                                    <i class="fa fa-file-excel-o"></i> Exportar
                                </a>

                            </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-6 m-b-xs" id="divBuscados">
                                
                            </div>
                            <div class="col-sm-6 m-b-xs" id="divMovidos">

                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>