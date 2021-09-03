<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%

   
%>
    
    <link href="/Template/inspina/font-awesome/css/font-awesome.css" rel="stylesheet">
    <link href="/Template/inspina/css/plugins/iCheck/custom.css" rel="stylesheet">
    <link href="/Template/inspina/css/plugins/select2/select2.min.css" rel="stylesheet">    
    <link href="/Template/inspina/css/animate.css" rel="stylesheet">
    <link href="/Template/inspina/css/style.css" rel="stylesheet">
<link href="/Template/inspina/css/plugins/daterangepicker/daterangepicker-bs3.css" rel="stylesheet">
        
<div id="wrapper">
    <div class="wrapper wrapper-content">    
        <div class="row">
      <div class="col-lg-12">
        <div class="ibox float-e-margins">
          <div class="ibox-title">
            <h5>Filtros de b&uacute;squeda</h5>
            <div class="ibox-tools">
              <!--a class="collapse-link"><i class="fa fa-chevron-up"></i></a> <a class="dropdown-toggle" data-toggle="dropdown" href="#"><i class="fa fa-wrench"></i></a>
              <ul class="dropdown-menu dropdown-user">
                <li>
                  <a href="#">Config option 1</a>
                </li>
                <li>
                  <a href="#">Config option 2</a>
                </li>
              </ul><a class="close-link"><i class="fa fa-times"></i></a>
            </div-->
          </div>
          <div class="ibox-content">
            <div class="row"> 
                <div class="col-sm-12 m-b-xs">        
                    <div class="row">
                        <label class="col-sm-2 control-label">Cliente:</label>
                        <div class="col-sm-4 m-b-xs">
<% 
    var sEventos = " class='input-sm form-control'  style='width:200px'"
    var sCondicion = "" 

    CargaCombo("cbCli_ID", sEventos, "Cli_ID", "Cli_Nombre", "Cliente", "", "Cli_Nombre"
              , Parametro("Cli_ID",-1), 0, "No aplica", "Editar")
%>
                        </div>
                        <label class="col-sm-2 control-label">Folio interno:</label>    
                        <div class="col-sm-3 m-b-xs">
                            <input id="CliOC_Folio" class="input-sm form-control" type="text" value="" style="width:150px">
                        </div>
                        <div class="col-sm-1 m-b-xs" style="text-align: left;">  
                            <button class="btn btn-success btn-sm" type="button" id="btnBuscar"><i class="fa fa-search"></i>&nbsp;&nbsp;<span class="bold">Buscar</span></button>
                        </div> 
                    </div>    
                </div>
            </div>
            <div class="row">
                <div class="col-sm-12 m-b-xs">
                    <div class="row">

                        <label class="col-sm-2 control-label">Rango fechas:</label>
                        <div class="col-sm-4 m-b-xs" >
                            <input class="form-control date-picker date" id="FechaBusqueda" 
                                   placeholder="dd/mm/aaaa" type="text" value="" 
                                   style="width: 200px;float: left;" > 
                               <span class="input-group-addon" style="width: 37px;float: left;height: 34px;"><i class="fa fa-calendar"></i></span>
                            
                        </div>
                        <label class="col-sm-2 control-label">Folio cliente:</label>
                        <div class="col-sm-4 m-b-xs">
                            <input id="CliOC_NumeroOrdenCompra" class="input-sm form-control" type="text" value="" style="width:150px">
                        </div>
                        

                    </div>    
                </div>
            </div>
            <!-- div class="row">
                <div class="col-sm-12 m-b-xs">
                    <div class="row">
                        <label class="col-sm-2 control-label">Estatus:</label>
                        <div class="col-sm-4 m-b-xs">
                        </div>
                        <label class="col-sm-1 control-label"></label>
                        <div class="col-sm-3 m-b-xs">
                            
                        </div>

                    </div>    
                </div>
            </div -->
                    

            <div class="table-responsive" id="dvTablaClientes"></div>  
          </div>
        </div>
      </div>
    </div>
    </div>                  
</div>
              
    <!-- Mainly scripts -->
    <!-- script src="/Template/inspina/js/jquery-3.1.1.min.js"></script -->
    <!-- script src="/Template/inspina/js/bootstrap.min.js"></script -->
    <script src="/Template/inspina/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>

    <!-- Custom and plugin javascript -->
    <!--  script src="/Template/inspina/js/inspinia.js"></script -->
    <script src="/Template/inspina/js/plugins/pace/pace.min.js"></script>

    <!-- iCheck -->
    <script src="/Template/inspina/js/plugins/iCheck/icheck.min.js"></script>

    <!-- Select2 -->
    <script src="/Template/inspina/js/plugins/select2/select2.full.min.js"></script>
          
    <!-- MENU -->
    <!-- script src="/Template/inspina/js/plugins/metisMenu/jquery.metisMenu.js"></script -->
        
 <input type="hidden" name="Cli_ID" id="Cli_ID" value="">    
<input type="hidden" name="CliOC_ID" id="CliOC_ID" value="">    
<input id="inicio" type="hidden" value="" />
<input id="fin" type="hidden" value="" />
<!-- Date range use moment.js same as full calendar plugin -->
<script src="/Template/inspina/js/plugins/fullcalendar/moment.min.js"></script>

<!-- Date range picker -->
<script src="/Template/inspina/js/plugins/daterangepicker/daterangepicker.js"></script>

<script type="text/javascript">
        
$(document).ready(function(){
    
    $('#FechaBusqueda').daterangepicker({
			"showDropdowns": true,
			//"singleDatePicker": true,
			"firstDay": 7,	
			"startDate": moment().subtract(29, 'days'),
			"endDate": moment(),
			"ranges": {
			   'Al dia de hoy': [moment().startOf('month'), moment()],
			   'Este Mes': [moment().startOf('month'), moment().endOf('month')],
			   'Mes pasado': [moment().subtract(1, 'month').startOf('month')
			                , moment().subtract(1, 'month').endOf('month')],		   
			   //'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
			   '+- 7 Dias': [moment().subtract(6, 'days'), moment().add(7, 'days')],
			   '+- 30 Dias': [moment().subtract(29, 'days'), moment().add(30, 'days')],
			   'Siguientes 60 Dias': [moment().startOf('month'), moment().add(60, 'days')]
			},			
			"locale": {
				"format": "DD/MM/YYYY", 
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
				$("#inicio").val(moment.utc(start, 'DD/MM/YYYY').local().format('DD/MM/YYYY'))
				$("#fin").val(moment.utc(end, 'DD/MM/YYYY').local().format('DD/MM/YYYY'))
                $("#FechaBusqueda").val($("#inicio").val() + " - " + $("#fin").val())
            })

//    $('.i-checks').iCheck({
//        checkboxClass: 'icheckbox_square-green',
//        //radioClass: 'iradio_square-green',
//    });

//    $(".BusEqp_ID").select2({
//        /*placeholder: "Selecciona un equipo de ventas",
//        allowClear: false*/
//    });    
//
//    $(".BusAgt_ID").select2({
//        /*placeholder: "Selecciona un equipo de ventas",
//        allowClear: false*/
//    });        
//    
//    $(".BusCot_EstatusCG93").select2({
//        /*placeholder: "Selecciona un equipo de ventas",
//        allowClear: false*/
//    });    
    
    CargaGridInicial()



      $("#btnBuscar").click(function(event) {

            var dato = {}
            dato['Lpp'] = 1  //este parametro limpia el cache
            dato['Cli_ID'] = $('#cbCli_ID').val()
            dato['CliOC_Folio'] = $('#CliOC_Folio').val()
            dato['CliOC_NumeroOrdenCompra'] = $('#CliOC_NumeroOrdenCompra').val()
            dato['FechaInicio'] = $('#inicio').val()
            dato['FechaFin'] = $('#fin').val()

            $("#dvTablaClientes").load("/pz/wms/Documentos/B_DocClienteOC_Grid.asp",dato);
      
	   });
    
});    
    
    function CargaGridInicial(){

        $("#dvTablaClientes").load("/pz/wms/Documentos/B_DocClienteOC_Grid.asp");

    }
        
</script>



