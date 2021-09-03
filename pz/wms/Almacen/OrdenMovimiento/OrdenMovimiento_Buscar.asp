<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2020-OCT-06 Movimiento: Creación de archivo

var urlBase = "/pz/wms/Almacen/"
var urlBaseTemplate = "/Template/inspina/";

%>
<link href="<%= urlBaseTemplate %>css/plugins/select2/select2.min.css" rel="stylesheet">
<link href="<%= urlBaseTemplate %>css/plugins/daterangepicker/daterangepicker-bs3.css" rel="stylesheet">

<!-- Date range use moment.js same as full calendar plugin -->
<script src="<%= urlBaseTemplate %>js/plugins/fullcalendar/moment.min.js"></script>

<!-- Date range picker -->
<script src="<%= urlBaseTemplate %>js/plugins/daterangepicker/daterangepicker.js"></script>

<!-- Select2 -->
<script src="<%= urlBaseTemplate %>js/plugins/select2/select2.full.min.js"></script>
<!-- Loading -->
<script src="<%= urlBaseTemplate %>js/loading.js"></script>
<!-- Lateral Flotante -->
<script src="<%= urlBaseTemplate %>js/lateralflotante.js"></script>

<!-- Librerias-->
<!-- <script type="text/javascript" src="<%= urlBase %>OrdenMovimiento/js/OrdenMovimiento.js"></script> -->
<script type="text/javascript" src="<%= urlBase %>OrdenMovimientoCorte/js/OrdenMovimientoCorte.js"></script>
<script type="text/javascript" src="<%= urlBase %>Cliente/js/Cliente.js"></script>
<script type="text/javascript" src="<%= urlBase %>Catalogo/js/Catalogo.js"></script>
<script type="text/javascript" src="<%= urlBase %>Ubicacion/js/Ubicacion.js"></script>

<script type="text/javascript">
 
    $(document).ready(function(){

        Cliente.ComboCargar({
            Contenedor: "selIOMCliente"
        });
        
        Ubicacion.ComboCargar({
            Contenedor: "selIOMUbicacion"
            , Habilitado: 1
        });

        //Estatus de Ordenes de Movimiento
        Catalogo.ComboCargar({
              SEC_ID: 80
            , Contenedor: "selIOMEstatus"
        });

        //Tipo de Ordenes de Movimiento
        Catalogo.ComboCargar({
              SEC_ID: 86
            , Contenedor: "selIOMTipo"
        })

       // OrdenMovimientoPorEstatus.ListadoCargar();

        $("#selIOMCliente").select2();
        $("#selIOMUbicacion").select2();
        $("#selIOMEstatus").select2();
        $("#selIOMTipo").select2();

        $('#inpIOMFechaBusqueda').daterangepicker({
			"showDropdowns": true,
			//"singleDatePicker": true,
			"firstDay": 7,	
			"startDate":moment().startOf('month'),
			"endDate": moment(),
            //"setDate": Today,
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
				$("#inpIOMFechaInicial").val(moment.utc(start, 'MM/DD/YYYY').local().format('MM/DD/YYYY'))
				$("#inpIOMFechaFinal").val(moment.utc(end, 'MM/DD/YYYY').local().format('MM/DD/YYYY'))
                $("#inpIOMFechaBusqueda").val($("#inpIOMFechaInicial").val() + " - " + $("#inpIOMFechaFinal").val())
            })
    });

    var OrdenMovimiento = {
        url: "/pz/wms/Almacen/OrdenMovimiento/"
        , Tipo: {
            Surtido: 1
            , Estatus: 2
            , Reacomodo: 3
        }
        , Estatus: {
            Auditada: 7
            , Cancelada: 5
            , EnAuditoria: 6
            , EnProceso: 3
            , Nuevo: 1
            , Pendiente: 2
            , Terminada: 4
        }  
        , Crear: function(){
            var prmJson = ( !(arguments[0] == undefined) ) ? arguments[0] : {};
            var intTOM_ID = ( !(prmJson.TOM_ID == undefined) ) ? prmJson.TOM_ID : -1;

            switch(parseInt(intTOM_ID)){
                case this.Tipo.Surtido: {
                    OrdenMovimientoPorSurtido.Crear();
                    
                } break;

            }
        }
        , ListadoCargar: function(){
            Cargando.Iniciar();

            var strIOM_Folio = $("#inpIOMOM_Folio").val();
            var strPro_SKU = $("#inpIOMPro_SKU").val();
            var intCli_ID = $("#selIOMCliente").val();
            var intUbi_ID_Destino = $("#selIOMUbicacion").val();
            var intEst_ID = $("#selIOMEstatus").val();
            var intTOM_ID = $("#selIOMTipo").val();
            var dateFechaInicial = $("#inpIOMFechaInicial").val();
            var dateFechaFinal = $("#inpIOMFechaFinal").val();
            var intIOM_Prioridad = $("#selIOMPrioridad").val();

            $.ajax({
                url: this.url + "OrdenMovimiento_Listado.asp"
                , method: "post"
                , async: true
                , data: {
                    Tarea: 1000
                    , IOM_Folio: strIOM_Folio
                    , Pro_SKU: strPro_SKU
                    , Cli_ID: intCli_ID
                    , Ubi_ID_Destino: intUbi_ID_Destino
                    , Est_ID: intEst_ID
                    , TOM_ID: intTOM_ID
                    , FechaInicial: dateFechaInicial
                    , FechaFinal: dateFechaFinal
                    , IOM_Prioridad: intIOM_Prioridad
                }  
                , success: function(res){
                    $("#divIOMListado").html(res);
                    Cargando.Finalizar();
                }
                , error: function(){
                    Avisa("error", "Orden Movimiento - Panel", "No se puede cargar el Listado")
                    Cargando.Finalizar();
                }
            }) 
        }
        , ProductoVer: function(){
            var jsonPrm = ( !( arguments[0] == undefined ) ) ? arguments[0] : {};
            var intIOM_ID = ( !( jsonPrm.IOM_ID == undefined ) ) ? jsonPrm.IOM_ID : -1;
            
            Cargando.Iniciar();

            $.ajax({
                url: OrdenMovimiento.url + "OrdenMovimiento_ProductoListado.asp"
                , method: "post"
                , async: true
                , data: {
                    IOM_ID: intIOM_ID
                }
                , success: function( res ){
                    
                    var obj = "<tr id='IOM_PRO_"+intIOM_ID+"'>"
                            +"<td id='PRO_"+intIOM_ID+"' colspan='10'>"+res+"</td>"
                        +"</tr>";
                    
                    console.log(obj);

                    $("#IOM_"+intIOM_ID).after(obj);

                    $('.IOM_'+intIOM_ID+'_ver').hide(); 
                    $('.IOM_'+intIOM_ID+'_ocultar').show();
                    Cargando.Finalizar();
                    
                }
                , error: function(){
                    Avisa("error","Orden de Movimiento - Productos", "No se puede cargar los productos");
                    Cargando.Finalizar();
                }
            });
            
        }
        , ProductoOcultar: function(){

            var jsonPrm = ( !( arguments[0] == undefined ) ) ? arguments[0] : {};
            var intIOM_ID = ( !( jsonPrm.IOM_ID == undefined ) ) ? jsonPrm.IOM_ID : -1;

             Cargando.Iniciar();

            $("#IOM_PRO_"+intIOM_ID).remove();

            $('.IOM_'+intIOM_ID+'_ver').show(); 
            $('.IOM_'+intIOM_ID+'_ocultar').hide();

             Cargando.Finalizar();
            
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
                            
                            <div class="btn-group">
                                <button data-toggle="dropdown" class="btn btn-primary btn-sm dropdown-toggle" aria-expanded="false">
                                    Nuevo <span class="caret"></span>
                                </button>
                                <ul class="dropdown-menu">
                                    <li>
                                        <a onclick="OrdenMovimiento.Crear({TOM_ID: OrdenMovimiento.Tipo.Surtido});">
                                            <i class="fa fa-share"></i> Surtido
                                        </a>
                                    </li>
                                    <li>
                                        <a>
                                            <i class="fa fa-exclamation-circle"></i> Por Estatus
                                        </a>
                                    </li>
                                </ul>
                            </div>

                            <button class="btn btn-info btn-sm" type="button" title="Realizar Corte de Orden de Movimiento" 
                             id="btnOrdenMovimientoCorteCrear" onClick="OrdenMovimientoCorte.Crear();">
                                <i class="fa fa-dropbox"></i> Nuevo Corte
                            </button>
                            <button class="btn btn-success btn-sm" type="button" id="btnBuscar" onClick="OrdenMovimiento.ListadoCargar();">
                                <i class="fa fa-search"></i> Buscar
                            </button>
                            
                        </div>
                    </div>
                    <div class="ibox-content">
                        <div class="row"> 
                            <div class="col-sm-12 m-b-xs">      
                                <div class="row">
                                    <label class="col-sm-2 control-label">Folio Ord. Mov.:</label>    
                                    <div class="col-sm-4 m-b-xs">
                                        <input id="inpIOMOM_Folio" class="input-sm form-control" type="text" value=""
                                        placeholder="Folio Ord. Mov." maxlenth="30" autocoplete="off">
                                    </div>
                                    <label class="col-sm-2 control-label">SKU Producto:</label>    
                                    <div class="col-sm-4 m-b-xs">
                                        <input id="inpIOMPro_SKU" class="input-sm form-control" type="text" value="" 
                                        placeholder="SKU"  maxlenth="30" autocoplete="off">
                                    </div>
                                </div>
                                <div class="row">
                                    <label class="col-sm-2 control-label">Cliente:</label>
                                    <div class="col-sm-4 m-b-xs">
                                        <select id="selIOMCliente" class="form-control">

                                        </select>
                                    </div>

                                    <label class="col-sm-2 control-label">Ubicacion Destino:</label>    
                                    <div class="col-sm-4 m-b-xs">
                                        <select id="selIOMUbicacion" class="form-control">

                                        </select>
                                    </div>
                                </div>
                                <div class="row">

                                    <label class="col-sm-2 control-label">Estatus:</label>    
                                    <div class="col-sm-4 m-b-xs">
                                        <select id="selIOMEstatus" class="form-control">

                                        </select>
                                    </div>

                                    <label class="col-sm-2 control-label">Tipo de Ord. de Mov.:</label>    
                                    <div class="col-sm-4 m-b-xs">
                                        <select id="selIOMTipo" class="form-control">

                                        </select>
                                    </div>

                                </div>    
                                
                                <div class="row">

                                    <label class="col-sm-2 control-label">Rango fechas:</label>
                                    <div class="col-sm-4 m-b-xs">
                                        <div class="input-group">
                                            <input class="form-control date-picker date" id="inpIOMFechaBusqueda" 
                                                placeholder="mm/dd/aaaa" type="text" value="" autocomplete="off" > 
                                            <span class="input-group-addon">
                                                <i class="fa fa-calendar"></i>
                                            </span>
                                        </div>
                                    </div>
                                    <input id="inpIOMFechaInicial" type="hidden" value="" />
                                    <input id="inpIOMFechaFinal" type="hidden" value="" />

                                    <label class="col-sm-2 control-label">Prioridad</label>    
                                    <div class="col-sm-4 m-b-xs">
                                        <select id="selIOMPrioridad" class="form-control">
                                            <option value="" selected>TODOS</option>
                                            <option value="0">NO</option>
                                            <option value="1">SI</option>
                                        </select>
                                    </div>

                                </div>    

                            </div>
                        </div>
                    </div>
                </div>
                <div id="divIOMListado">
                    
                </div>
            </div>
        </div>
    </div>
</div>


