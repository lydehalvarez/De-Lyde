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
            <div class="col-sm-12 m-b-xs">    
            <div class="row"> 
                      
                    <!-- div class="row" -->
                        <label class="col-sm-2 control-label">Cliente:</label>
                        <div class="col-sm-4 m-b-xs">
<% 
    var sEventos = " class='input-sm form-control cbo2'  style='width:200px'"
    var sCondicion = "" 

    CargaCombo("cbCli_ID", sEventos, "Cli_ID", "Cli_Nombre", "Cliente", "", "Cli_Nombre", Parametro("Cli_ID",-1), 0, "No aplica", "Editar")
%>
                        </div>
                        <label class="col-sm-2 control-label">Folio tra:</label>    
                        <div class="col-sm-3 m-b-xs">
                            <input id="TA_Folio" class="input-sm form-control" type="text" value="" style="width:150px">
                        </div>
                        <div class="col-sm-1 m-b-xs" style="text-align: left;">  
                            <button class="btn btn-success btn-sm" type="button" id="btnBuscar"><i class="fa fa-search"></i>&nbsp;&nbsp;<span class="bold">Buscar</span></button>
                        </div> 
                    </div>    
            <div class="row"> 
                      
                    <!-- div class="row" -->
                        <label class="col-sm-2 control-label">Estatus:</label>
                        <div class="col-sm-4 m-b-xs">
<% 
    var sEventos = " class='input-sm form-control cbo2'  style='width:200px'"
    var sCondicion = " Sec_ID = 51 and Cat_Tipo = 1 " 

    CargaCombo("TA_EstatusCG51", sEventos, "Cat_ID", "Cat_Nombre", "Cat_Catalogo", sCondicion, "Cat_Orden", -1, 0, "Todos", "Editar")
%>
                        </div>
                        <label class="col-sm-2 control-label">Remisi&oacute;n:</label>    
                        <div class="col-sm-4 m-b-xs">
                            <input id="Remision" class="input-sm form-control" type="text" value="" style="width:150px">
                        </div>
                    </div>    
            
                <div class="row">
                                <div class="col-sm-12 m-b-xs">

                    <!-- div class="col-sm-12 m-b-xs"  -->
                        <!-- div class="row" -->

                            <label class="col-sm-2 control-label">Rango fechas:</label>
                            <div class="col-sm-4 m-b-xs" >
                                <input class="form-control date-picker date" id="FechaBusqueda" 
                                       placeholder="dd/mm/aaaa" type="text" value="" 
                                       style="width: 200px;float: left;" > 
                                   <span class="input-group-addon" style="width: 37px;float: left;height: 34px;"><i class="fa fa-calendar"></i></span>

                            </div>
                            <label class="col-sm-2 control-label">Folio cliente:</label>
                            <div class="col-sm-4 m-b-xs">
                                <input id="TA_FolioCliente" class="input-sm form-control" type="text" value="" style="width:150px">
                            </div>

						</div>
                        <!-- /div  -->    
                    </div>
                <!-- /div  --> 
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

            <div class="row">
                <div class="col-sm-12 m-b-xs">
                    <div class="pull-right">
                        <!-- div class="col-sm-9 m-b-xs" -->
                            <div data-toggle="buttons" class="btn-group">
                                <label class="btn btn-sm btn-white"> 
                                    <input type="radio" id="option1" class="TipoR" value="1"> <i class="fa fa-area-chart"></i> Datos </label>
                                <label class="btn btn-sm btn-white active"> 
                                    <input type="radio" id="option2" class="TipoR" value="2"> <i class="fa fa-book"></i> Detalle </label>
                                <label class="btn btn-sm btn-white"> 
                                    <input type="radio" id="option3" class="TipoR" value="3"> <i class="fa fa-tasks"></i> Resumido </label>
                            <!-- /div -->
                        </div> 
                        <!-- div class="tooltip-demo">
                            <button class="btn btn-white btn-xs btnTipo" data-toggle="tooltip" data-placement="left" 
                                    data-tp="1"
                                    title="informaci&oacute;n estad&iacute;stica"><i class="fa fa-area-chart"></i> Datos</button>
                            
                            <button class="btn btn-success btn-xs btnTipo" data-toggle="tooltip" data-placement="top" 
                                    data-tp="2"
                                    title="" data-original-title="Lista con datos detallados"><i class="fa fa-book"></i> Detalle</button>
                            
                            <button class="btn btn-white btn-xs btnTipo" data-toggle="tooltip" data-placement="top" 
                                    data-tp="2"
                                    title="" data-original-title="Lista sencilla"><i class="fa fa-tasks"></i> Resumido</button>

                        </div -->
                    </div>
                    <!-- div class="small text-muted">
                        <i class="fa fa-clock-o"></i> Monday, 21 May 2014, 10:32 am
                    </div  -->
                </div>
           </div> 
          
 
            <div class="table-responsive" id="dvTablaTranferencias"></div>  
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
    
   $('.cbo2').select2()
    
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
				               ,"Julio","Agosto","Septimbre","Octubre","Novimbre","Dicimbre"]
			//"alwaysShowCalendars": true,	
			}}, function(start, end, label) {
				$("#inicio").val(moment.utc(start, 'DD/MM/YYYY').local().format('DD/MM/YYYY'))
				$("#fin").val(moment.utc(end, 'DD/MM/YYYY').local().format('DD/MM/YYYY'))
                $("#FechaBusqueda").val($("#inicio").val() + " - " + $("#fin").val())
            })

   
    
   // CargaGridInicial()


      $("#btnBuscar").click(function(event) {

          
            $("#dvTablaTranferencias").empty()
            var dato = {}
                dato['Lpp'] = 1  //este parametro limpia el cache
                dato['Cli_ID'] = $('#cbCli_ID').val()
                dato['TA_Folio'] = $('#TA_Folio').val()
                dato['TA_FolioCliente'] = $('#TA_FolioCliente').val()
                dato['FechaInicio'] = $('#inicio').val()
                dato['FechaFin'] = $('#fin').val()
                dato['TA_EstatusCG51'] = $('#TA_EstatusCG51').val()
                dato['Remision'] = $('#Remision').val()
                dato['SistemaActual'] = $('#SistemaActual').val()
                dato['iqCli_ID'] = $('#iqCli_ID').val()

            $("#dvTablaTranferencias").load("/pz/wms/Transferencia/B_Transferencia_Grid.asp",dato);

	   });
    
});    
    
    function CargaGridInicial(){

        $("#dvTablaTranferencias").load("/pz/wms/Transferencia/B_Transferencia_Grid.asp");

    }
        
</script>



