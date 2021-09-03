<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2021-MAR-30 Factura por Autorizar: Creación de archivo

var cxnTipo = 0

var urlBase = "/pz/wms/Proveedor/"
var urlBaseTemplate = "/Template/inspina/";

var rqIntProv_ID = Parametro("Prov_ID", -1)

var bolEsTransportista = ( rqIntProv_ID > -1 )
%>

<link href="<%= urlBaseTemplate %>css/plugins/select2/select2.min.css" rel="stylesheet">
<link href="<%= urlBaseTemplate %>css/plugins/daterangepicker/daterangepicker-bs3.css" rel="stylesheet">

<!-- Select2 -->
<script src="<%= urlBaseTemplate %>js/plugins/select2/select2.full.min.js"></script>
<!-- Loading -->
<script src="<%= urlBaseTemplate %>js/loading.js"></script>
<!-- Date range use moment.js same as full calendar plugin -->
<script src="<%= urlBaseTemplate %>js/plugins/fullcalendar/moment.min.js"></script>
<!-- Date range picker -->
<script src="<%= urlBaseTemplate %>js/plugins/daterangepicker/daterangepicker.js"></script>

<script type="text/javascript">

    $(document).ready(function(){
 
        $(".select2").select2();

        $("#btnLimpiar").on("click", function(){
            Proveedor.FiltrosLimpiar();
        });
        
        $("#btnBuscar").on("click", function(){
            Proveedor.ListadoBuscar();
        });

        $('#inpProFacPorAutBusFechaBusqueda').daterangepicker({
			"showDropdowns": true,
			//"singleDatePicker": true,
			"firstDay": 7,	
			"startDate":moment().startOf('month'),
			"endDate": moment(),
           // "setDate": Today,
            "autoApply": true,
			"ranges": {
               'Hoy': [moment(), moment()],
			   'Al dia de hoy': [moment().startOf('month'), moment()],
			   'Este Mes': [moment().startOf('month'), moment().endOf('month')],
			   'Mes pasado': [moment().subtract(1, 'month').startOf('month')
			                , moment().subtract(1, 'month').endOf('month')],		   
			   //'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
                
			   '7 Dias': [moment().subtract(6, 'days'), moment()],
               '15 Dias': [moment().subtract(15, 'days'), moment()],
			   '30 Dias': [moment().subtract(29, 'days'), moment()],
			},			
			"locale": {
				"format": "MM/DD/YYYY", 
				"separator": " - ",
				"applyLabel": "Aplicar",
				"cancelLabel": "Cancelar",
				"fromLabel": "Desde",
				"toLabel": "Hasta",
				"customRangeLabel": "Personalizado",
				"weekLabel": "W",
				"daysOfWeek": ["Do","Lu","Ma","Mi","Ju","Vi","Sa"],
				"monthNames": [ "Enero","Febrero","Marzo","April","Mayo","Junio","Julio","Agosto","Septimbre","Octubre","Novimbre","Dicimbre"]
			//"alwaysShowCalendars": true,	
		}}, function(start, end, label) {
            $("#inpProFacPorAutBusFechaInicial").val(moment.utc(start, 'MM/DD/YYYY').local().format('MM/DD/YYYY'))
            $("#inpProFacPorAutBusFechaFinal").val(moment.utc(end, 'MM/DD/YYYY').local().format('MM/DD/YYYY'))
            $("#inpProFacPorAutBusFechaBusqueda").val((moment.utc(start, 'DD/MM/YYYY').local().format('DD/MM/YYYY')) + " - " + (moment.utc(end, 'DD/MM/YYYY').local().format('DD/MM/YYYY')))
        });


    });

    var Proveedor = {
        url: "/pz/wms/Proveedor/"
        , RegistrosPagina: 10
        , Filtros: {
              Proveedor: -1
            , Folio: ""
            , Manifiesto: ""
            , Guia: ""
            , FechaInicial: ""
            , FechaFinal: ""
        }
        , FiltrosLimpiar: function(){
            $("#inpProFacPorAutBusFolio").val("");
            $("#inpProFacPorAutBusMan_Folio").val("");
            $("#inpProFacPorAutBusGuia").val("");

            $("#inpProFacPorAutBusFechaBusqueda").val("");
            $("#inpProFacPorAutBusFechaInicial").val("");
            $("#inpProFacPorAutBusFechaFinal").val("");

            $("#objProFacPorAutBusProv_ID").val("-1");
            $("#select2-objProFacPorAutBusProv_ID-container").text("TODOS");

            var bolEsProveedor = ($("#objProFacPorAutBusProv_ID").data("esproveedor") == 1 );

            if( !(bolEsProveedor) ) {
                Proveedor.Filtros.Proveedor = -1
            }
            Proveedor.Filtros.Folio = "";
            Proveedor.Filtros.Manifiesto = "";
            Proveedor.Filtros.Guia = "";
            Proveedor.Filtros.FechaInicial = "";
            Proveedor.Filtros.FechaFinal = "";
        }
        , ListadoBuscar: function(){
            var strFolio = $("#inpProFacPorAutBusFolio").val();
            var strMan_Folio = $("#inpProFacPorAutBusMan_Folio").val();
            var strGuia = $("#inpProFacPorAutBusGuia").val();

            var dateFechaInicial = $("#inpProFacPorAutBusFechaInicial").val();
            var dateFechaFinal = $("#inpProFacPorAutBusFechaFinal").val();
            var intProv_ID = $("#objProFacPorAutBusProv_ID").val();
            var bolEsProveedor = ($("#objProFacPorAutBusProv_ID").data("esproveedor") == 1 );

            var bolError = false;

            if( strFolio == "" && strMan_Folio == "" && strGuia == "" &&  dateFechaInicial == "" && dateFechaFinal == "" && ( bolEsProveedor || ( !(bolEsProveedor) && intProv_ID == "-1"))){
                bolError = true;
            }

            if( bolError ){
                Avisa("warning", "Entregas", "Seleccionar al menos un filtro");
            } else {

                Proveedor.Filtros.Proveedor = intProv_ID;
                Proveedor.Filtros.Folio = strFolio;
                Proveedor.Filtros.Manifiesto = strMan_Folio;
                Proveedor.Filtros.Guia = strGuia;
                Proveedor.Filtros.FechaInicial = dateFechaInicial;
                Proveedor.Filtros.FechaFinal = dateFechaFinal;

                Proveedor.ListadoCargar( true );
            }

        }
        , ListadoCargar: function( prmBolIniciaBusqueda ){

            var intRegistros =  $("#divProFacPorAutBusListado").children().length;
            var intIDUsuario = $("#IDUsuario").val();
            var intSiguienteRegistro = ( prmBolIniciaBusqueda ) ? 0 : intRegistros;
            var intRegistrosPagina = $("#inpRegPag").val();

            var intRegPag = (intRegistrosPagina == "") ? Proveedor.RegistrosPagina : intRegistrosPagina;

            if( prmBolIniciaBusqueda ){
                $("#divProFacPorAutBusListado").html("");
                $("#divProFacPorAutBusTotalRegistros").text("");
            } 
            
            Procesando.Visualizar({Contenedor: "divProFacPorAutBusCargando"})

            $.ajax({
                url: Proveedor.url + "Proveedor_FacturaPorAutorizar_Listado.asp"
                , method: "post"
                , async: true
                , data: {
                      Prov_ID: Proveedor.Filtros.Proveedor
                    , Guia: Proveedor.Filtros.Guia
                    , Folio: Proveedor.Filtros.Folio 
                    , Man_Folio: Proveedor.Filtros.Manifiesto
                    , FechaInicial: Proveedor.Filtros.FechaInicial
                    , FechaFinal: Proveedor.Filtros.FechaFinal
                    , IDUsuario: intIDUsuario
                    , SiguienteRegistro: intSiguienteRegistro
                    , RegistrosPagina: intRegPag
                }
                , success: function(res){
                    Procesando.Ocultar();
                    
                    if(prmBolIniciaBusqueda){
                        $("#divProFacPorAutBusListado").html( res );    
                    } else {
                        $("#divProFacPorAutBusListado").append( res );
                    }

                    var objMas = "";
                    if( res != ""){
                        var objMas = "<div class='row'>"
                                + "<div class='col-sm-9'>"
                                    + "<button type='button' class='btn btn-white btn-block' onClick='Proveedor.ListadoCargar()'>"
                                        + "<i class='fa fa-arrow-down'></i> Ver mas"
                                    + "</button>" 
                                + "</div>"
                                + "<div class='col-sm-2 input-group'>"
                                    + "<input type='number' id='inpRegPag' class='form-control text-right' placeholder='10' min='10' max='100' steep='10' value='10' maxlength='3' >"
                                    + "<span class='input-group-addon'> Reg/Pag </span>"
                                + "</div>"
                            + "</div>"

                        
                    } else if( prmBolIniciaBusqueda ) {
                        objMas = "<i class='fa fa-exclamation-circle fa-lg text-success'></i> No hay Registros"
                    }

                    $("#divProFacPorAutBusCargando").html(objMas);

                    Proveedor.ListadoRegistrosContar();
                
                }
                , error: function(){

                    Procesando.Ocultar();
                    Avisa("error","Proveedor Entregas", "No se puede cargar el listado de Entregas")
                    
                }
            });
            
        }
        , ListadoRegistrosContar: function(){
           var intRegistros = $("#divProFacPorAutBusListado").children().length;

           $("#divProFacPorAutBusTotalRegistros").text(intRegistros);
        }
         , Ver: function(){
            var jsonPrm = ( !(arguments[0] == undefined) ) ? arguments[0] : {};
            var intProv_ID = ( !(jsonPrm.Prov_ID == undefined) ) ? jsonPrm.Prov_ID: -1;
            var intProG_ID = ( !(jsonPrm.ProG_ID == undefined) ) ? jsonPrm.ProG_ID: -1;

            $("#Prov_ID").val(intProv_ID);
            $("#ProG_ID").val(intProG_ID);

            CambiaSiguienteVentana();
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
                            
                            <button class="btn btn-white btn-sm" type="button" id="btnLimpiar">
                                <i class="fa fa-trash-o"></i> Limpiar
                            </button>

                            <button class="btn btn-success btn-sm" type="button" id="btnBuscar">
                                <i class="fa fa-search"></i> Buscar
                            </button>

                        </div>
                    </div>
                    <div class="ibox-content">
                        <div class="row"> 

                            <div class="col-sm-12 m-b-xs">

                                <div class="form-group row">
<%  
    if( bolEsTransportista ){             
%>                       
                                    <input id="objProFacPorAutBusProv_ID" type="hidden" data-esproveedor='1' value="<%= rqIntProv_ID %>" />
<%
    } else {             
%>                                  
                                    <label class="col-sm-2 control-label">Transportista:</label>
                                    <div class="col-sm-4 m-b-xs">                                
<%
        CargaCombo("objProFacPorAutBusProv_ID", "class='form-control select2' data-esproveedor='0'", "Prov_ID", "Prov_Nombre", "Proveedor", "Prov_Habilitado = 1 AND Prov_EsPaqueteria = 1", "Prov_Nombre ASC", "", cxnTipo, "TODOS", "")
%>
                                    </div>

                                    <div class="col-sm-6 m-b-xs">                                
                                        
                                    </div>
<%  }
%>                                      
                                </div>

                                <div class="form-group row">

                                    <label class="col-sm-2 control-label">Guia:</label>
                                    <div class="col-sm-4 m-b-xs">
                                        <input type="text" id="inpProFacPorAutBusGuia" class="form-control" placeholder="Gu&iacute;a"
                                         autocomplete="off" maxlength="30">
                                    </div>

                                    <label class="col-sm-2 control-label">Folio:</label>    
                                    <div class="col-sm-4 m-b-xs">
                                        <input type="text" id="inpProFacPorAutBusFolio" class="form-control" placeholder="Folio SO o TA"
                                         autocomplete="off" maxlength="30">
                                    </div>
                                      
                                </div>

                                <div class="form-group row">

                                    <label class="col-sm-2 control-label">Rango fechas:</label>
                                    <div class="col-sm-4 m-b-xs">
                                        <div class="input-group">
                                            <input class="form-control date-picker date" id="inpProFacPorAutBusFechaBusqueda" 
                                                placeholder="dd/mm/aaaa - dd/mm/aaaa" type="text" value="" autocomplete="off" > 
                                            <span class="input-group-addon">
                                                <i class="fa fa-calendar"></i>
                                            </span>
                                        </div>
                                    </div>
                                    <input id="inpProFacPorAutBusFechaInicial" type="hidden" value="" />
                                    <input id="inpProFacPorAutBusFechaFinal" type="hidden" value="" />
                                    
                                    <label class="col-sm-2 control-label">Folio de  Manifiesto:</label>    
                                    <div class="col-sm-4 m-b-xs">
                                        <input type="text" id="inpProFacPorAutBusMan_Folio" class="form-control" placeholder="Folio Manifiesto"
                                        autocomplete="off" maxlength="30">
                                    </div> 
              
                                </div>
<%
    if ( !(bolEsTransportista) ){
%>
                                <input type="hidden" name="Prov_ID" id="Prov_ID" value="-1">
<%
    }
%>
                                <input type="hidden" name="ProG_ID" id="ProG_ID" value="-1">

                            </div>
                        </div>
                    </div>
                </div>
            
            </div>

            <div class="col-sm-12">
                <div class="ibox">
                    <div class="ibox-title">
                        <h5>Resultados</h5>
                        <div class="ibox-tools">

                            <label class="pull-right form-group">
                                <span class="text-success" id="divProFacPorAutBusTotalRegistros">

                                </span> Registros
                            </label>

                        </div>
                    </div>
                    <div class="ibox-content">
                        <table class="table table-hover">
                            <tbody id="divProFacPorAutBusListado">

                            </tbody>
                            <tfoot id="divProFacPorAutBusCargando">
                                
                            </tfoot>
                        </table>
                    </div>
                </div>
                    
            </div>

        </div>
    </div>
</div>

