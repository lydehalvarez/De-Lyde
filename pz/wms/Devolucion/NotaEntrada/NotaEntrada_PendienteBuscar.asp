<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2021-ENE-26 Devoulcion Decisión: Archivo Nuevo

var urlBase = "/pz/wms/Devolucion/"
var urlBaseTemplate = "/Template/inspina/";

%>
<link href="<%= urlBaseTemplate %>css/plugins/select2/select2.min.css" rel="stylesheet">
<link href="<%= urlBaseTemplate %>css/plugins/daterangepicker/daterangepicker-bs3.css" rel="stylesheet">

<!-- Select2 -->
<script src="<%= urlBaseTemplate %>js/plugins/select2/select2.full.min.js"></script>

<!-- Loading -->
<script src="<%= urlBaseTemplate %>js/loading.js"></script>
<!-- Lateral Flotante -->
<script src="<%= urlBaseTemplate %>js/lateralflotante.js"></script>

<!-- Date range use moment.js same as full calendar plugin -->
<script src="<%= urlBaseTemplate %>js/plugins/fullcalendar/moment.min.js"></script>

<!-- Date range picker -->
<script src="<%= urlBaseTemplate %>js/plugins/daterangepicker/daterangepicker.js"></script>

<!-- Librerias-->
<script type="text/javascript" src="/pz/wms/Almacen/Cliente/js/Cliente.js"></script>
<script type="text/javascript" src="/pz/wms/Devolucion/NotaEntrada/js/NotaEntrada_PendienteBuscar.js"></script>

<script type="text/javascript">

    $(document).ready(function(){

        Cliente.ComboCargar({
            Contenedor: "selNEPBCliente"
            , UsaNotaEntrada: 1
        });

        $("#selNEPBCliente").select2();

        $('#inpNEPBFechaBusqueda').daterangepicker({
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
				"monthNames": [ "Enero","Febrero","Marzo","April","Mayo","Junio"
				               ,"Julio","Agosto","Septimbre","Octubre","Novimbre","Dicimbre"]
			//"alwaysShowCalendars": true,	
			}}, function(start, end, label) {
				$("#inpNEPBFechaInicial").val(moment.utc(start, 'MM/DD/YYYY').local().format('MM/DD/YYYY'))
				$("#inpNEPBFechaFinal").val(moment.utc(end, 'MM/DD/YYYY').local().format('MM/DD/YYYY'))
                $("#inpNEPBFechaBusqueda").val($("#inpNEPBFechaInicial").val() + " - " + $("#inpNEPBFechaFinal").val())
            })
    });
    
</script>

<div id="wrapper">
    <div class="wrapper wrapper-content">    
        <div class="row">
            <div class="col-sm-12">
                <div class="ibox">
                    <div class="ibox-title">
                        <h5>Filtros de b&uacute;squeda</h5>
                        <div class="ibox-tools">
                            
                            <button class="btn btn-success btn-sm" type="button" id="btnBuscar" onClick="NotaEntradaPendienteBuscar.ListadoCargar();">
                                <i class="fa fa-search"></i> Buscar
                            </button>

                        </div>
                    </div>
                    <div class="ibox-content">
                        <div class="row"> 
                            <div class="col-sm-12 m-b-xs">        
                                <div class="row">
                                    <label class="col-sm-2 control-label" title="Transferencia/Orden de Venta">Tra. /Ord Vta.:</label>
                                    <div class="col-sm-4 m-b-xs">
                                        <input type="text" id="inpNEPBTAOVFolio" class="form-control" placeholder="Folio"
                                         autocomplete="off">
                                    </div>
                                    <label class="col-sm-2 control-label">Producto(SKU)</label>    
                                    <div class="col-sm-4 m-b-xs">
                                        <input type="text" id="inpNEPBPro_SKU" class="form-control" placeholder="SKU"
                                         autocomplete="off">
                                    </div>   
                                </div>
                                <div class="row form-group">
                                    <label class="col-sm-2 control-label">Rango fechas:</label>
                                    <div class="col-sm-4 m-b-xs">
                                        <div class="input-group">
                                            <input class="form-control date-picker date" id="inpNEPBFechaBusqueda" 
                                                placeholder="mm/dd/aaaa" type="text" value="" autocomplete="off" > 
                                            <span class="input-group-addon">
                                                <i class="fa fa-calendar"></i>
                                            </span>
                                        </div>
                                    </div>
                                    <input id="inpNEPBFechaInicial" type="hidden" value="" />
                                    <input id="inpNEPBFechaFinal" type="hidden" value="" />
                                    <label class="col-sm-2 control-label">Cliente</label>    
                                    <div class="col-sm-4 m-b-xs">
                                        <select id="selNEPBCliente" class="form-control">
                                                
                                        </select>
                                    </div>
                                    
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div id="divNEPBListado">
                    
                </div>
            </div>
            <!--
            <div class="col-sm-3" id="divLateral" >
                
            </div>
            -->
        </div>
    </div>
</div>

