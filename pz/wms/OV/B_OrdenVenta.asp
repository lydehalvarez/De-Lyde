<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%

   
%>
    
<!-- link href="/Template/inspina/font-awesome/css/font-awesome.css" rel="stylesheet" -->
<!-- link href="/Template/inspina/css/plugins/iCheck/custom.css" rel="stylesheet" -->
<link href="/Template/inspina/css/plugins/select2/select2.min.css" rel="stylesheet">    
<link href="/Template/inspina/css/animate.css" rel="stylesheet">
<!-- link href="/Template/inspina/css/style.css" rel="stylesheet" -->
<link href="/Template/inspina/css/plugins/daterangepicker/daterangepicker-bs3.css" rel="stylesheet">
        
<div id="wrapper">
    <div class="wrapper wrapper-content">
        <div class="row">
          <div class="col-lg-12">
            <div class="ibox float-e-margins">
              <div class="ibox-title">
                <h5>
                  Filtros de b&uacute;squeda
                </h5>
                <div class="ibox-tools"></div>
                <div class="ibox-content">
                  <div class="col-sm-12 m-b-xs">
                    <div class="row">
                      <!-- div class="row" -->
                      <label class="col-sm-2 control-label">Folio Orden Venta:</label>
                      <div class="col-sm-4 m-b-xs">
                          <input class="input-sm form-control" id="Folio" style="width:200px" type="text" value="" placeholder="Orden de servicio">
                          <span class="help-block m-b-none"><i class="fa fa-question-circle"></i>&nbsp;Folio LYDE</span>
                      </div>
                      <label class="col-sm-2 control-label">Gu&iacute;a:</label>
                      <div class="col-sm-3 m-b-xs">
                        <input class="input-sm form-control" id="Guia" style="width:200px" type="text" value="" placeholder="Guia del transportista">
                      </div>
                      <div class="col-sm-1 m-b-xs" style="text-align: left;">
                        <button class="btn btn-success btn-sm" id="btnBuscar" type="button"><i class="fa fa-search"></i>&nbsp;&nbsp;<span class="bold">Buscar</span></button>
                      </div>
                    </div>
                    <div class="row">
                      <!-- div class="row" -->
                      <label class="col-sm-2 control-label">Folio Cliente:</label>
                      <div class="col-sm-4 m-b-xs">
                        <input class="input-sm form-control" id="OV_CUSTOMER_SO" style="width:150px" type="text" value=""><span class="help-block m-b-none"><i class="fa fa-question-circle"></i>&nbsp;Folio del cliente</span>
                      </div>
                      <label class="col-sm-2 control-label">Nombre cliente:</label>
                      <div class="col-sm-3 m-b-xs">
                        <input class="input-sm form-control" id="OV_CUSTOMER_NAME" style="width:200px" type="text" value="" placeholder="Nombre del cliente"><span class="help-block m-b-none"><i class="fa fa-question-circle"></i>&nbsp;Destinatario final</span>
                      </div>                        
                    </div>
                    <div class="row">
                      <label class="col-sm-2 control-label">Rango fechas:</label>
                      <div class="col-sm-4 m-b-xs">
                        <input type="text" class="form-control date-picker date" id="FechaBusqueda" placeholder="dd/mm/aaaa" style="width: 200px;float: left;" autocomplete="off" value=""> <span class="input-group-addon" style="width: 37px;float: left;height: 34px;"><i class="fa fa-calendar"></i></span>
                      </div>
                    </div>
                  </div>
                </div>
                <div class="row">
                  <div class="col-sm-12 m-b-xs">
                    <!-- div class="pull-right">
                      <div class="btn-group" data-toggle="buttons">
                        <label class="btn btn-sm btn-white"><input class="TipoR" id="option1" type="radio" value="1"> <i class="fa fa-area-chart"></i> Datos</label> <label class="btn btn-sm btn-white active"><input class="TipoR" id="option2" type="radio" value="2"> <i class="fa fa-book"></i> Detalle</label> <label class="btn btn-sm btn-white"><input class="TipoR" id="option3" type="radio" value="3"> <i class="fa fa-tasks"></i> Resumido</label>
                      </div>
                    </div  -->
                  </div>
                </div>
                <div class="table-responsive" id="dvTablaOrdenVenta">
                </div>
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
<!-- script src="/Template/inspina/js/plugins/iCheck/icheck.min.js"></script -->

<!-- Select2 -->
<script src="/Template/inspina/js/plugins/select2/select2.full.min.js"></script>

<!-- MENU -->
<!-- script src="/Template/inspina/js/plugins/metisMenu/jquery.metisMenu.js"></script -->
   
<input id="inicio" type="hidden" value="" />
<input id="fin" type="hidden" value="" />
<!-- Date range use moment.js same as full calendar plugin -->
<script src="/Template/inspina/js/plugins/fullcalendar/moment.min.js"></script>

<!-- Date range picker -->
<script src="/Template/inspina/js/plugins/daterangepicker/daterangepicker.js"></script>

<script type="text/javascript">

var loading = '<div class="spiner-example">'+
				'<div class="sk-spinner sk-spinner-three-bounce">'+
					'<div class="sk-bounce1"></div>'+
					'<div class="sk-bounce2"></div>'+
					'<div class="sk-bounce3"></div>'+
				'</div>'+
			'</div>'+
			'<div>Cargando informaci&oacute;n, espere un momento...</div>'    
    
$(document).ready(function(){
    
    var Today= new Date();
        Today.setDate(Today.getDate() ); 
    
   $('.btnTipo').click(function(e){
       e.preventDefault()
       $('.btnTipo').removeClass("btn-success")
       $(this).addClass("btn-success")
     
   })
    
   $('.TipoR').click(function(e){
       e.preventDefault()
       
     
   })    
    
   $('.cbo2').select2();
    
    $('#FechaBusqueda').daterangepicker({
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
				               ,"Julio","Agosto","Septiembre","Octubre","Noviembre","Diciembre"]
			//"alwaysShowCalendars": true,	
			}}, function(start, end, label) {
				$("#inicio").val(moment.utc(start, 'DD/MM/YYYY').local().format('DD/MM/YYYY'))
				$("#fin").val(moment.utc(end, 'DD/MM/YYYY').local().format('DD/MM/YYYY'))
                $("#FechaBusqueda").val($("#inicio").val() + " - " + $("#fin").val())
            })



      $("#btnBuscar").click(function(event) {
          
            $("#dvTablaOrdenVenta").empty();
            var dato = {}
                dato['Lpp'] = 1;  //este parametro limpia el cache
                dato['Cli_ID'] = $('#Cli_ID').val();
                dato['Folio'] = $('#Folio').val();
                dato['Guia'] = $('#Guia').val();
                dato['OV_CUSTOMER_SO'] = $('#OV_CUSTOMER_SO').val();
                dato['OV_CUSTOMER_NAME'] = $('#OV_CUSTOMER_NAME').val();        
                dato['FechaInicio'] = $('#inicio').val();
                dato['FechaFin'] = $('#fin').val();
                dato['SistemaActual'] = $('#SistemaActual').val();
                dato['iqCli_ID'] = $('#iqCli_ID').val();
                /* Folio,Guia,OV_CUSTOMER_SO,OV_CUSTOMER_NAME*/
                console.log("FechaBusqueda: " + $("#FechaBusqueda").val() + " | " + "FechaInicio: " + $('#inicio').val() + " | FechaFin: " + $('#fin').val());
                $('#dvTablaOrdenVenta').hide('slow');
                $("#dvTablaOrdenVenta").html(loading);
                $("#dvTablaOrdenVenta").load("/pz/wms/OV/B_OrdenVenta_Grid.asp",dato);
                $("#dvTablaOrdenVenta").show('slow');

	   });
    
});    

        
</script>



