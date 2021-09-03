<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../../Includes/iqon.asp" -->

    
    <!-- link href="/Template/inspina/font-awesome/css/font-awesome.css" rel="stylesheet" -->
    <!-- link href="/Template/inspina/css/plugins/iCheck/custom.css" rel="stylesheet" -->
    <link href="/Template/inspina/css/plugins/select2/select2.min.css" rel="stylesheet">    
    <link href="/Template/inspina/css/animate.css" rel="stylesheet">
    <!-- link href="/Template/inspina/css/style.css" rel="stylesheet" -->
<link href="/Template/inspina/css/plugins/daterangepicker/daterangepicker-bs3.css" rel="stylesheet">
        
<div class="form-horizontal" id="toPrint">
    <div class="wrapper wrapper-content  animated fadeInRight">
        <div class="row">
            <div class="col-lg-12">
                <div class="ibox">
                    <div class="ibox-title">
                        <h5>Filtros de busqueda</h5>
                        <div class="ibox-tools">
                            <a href="#" class="btn btn-primary btnBuscar"><i class="fa fa-search"></i>&nbsp;&nbsp;Buscar</a>
                        </div>
                    </div>
                    <div class="ibox-content">
                        <div class="row">
                            <div class="col-sm-12 m-b-xs">
      					 <label class="col-sm-2 control-label">Monto:</label>
                        <div class="col-sm-4 m-b-xs">
                            <input id="Pag_Monto" class="input-sm form-control" type="text" value="" style="width:150px">
                        </div>
                        <label class="col-sm-2 control-label">Referencia bancaria:</label>    
                        <div class="col-sm-3 m-b-xs">
                            <input id="Pag_ReferenciaBancaria" class="input-sm form-control" type="text" value="" style="width:150px">
                        </div>
                                    </div>  
                            </div>
                        <div class="row">
                            <div class="col-sm-12 m-b-xs">
        				  <label class="col-sm-2 control-label">Estatus:</label>
                        <div class="col-sm-4 m-b-xs">
<% 
    var sEventos = " class='input-sm form-control cbo2'  style='width:200px'"
    var sCondicion = " Sec_ID = 150  " 

    CargaCombo("Pag_AplicadoCG150", sEventos, "Cat_ID", "Cat_Nombre", "Cat_Catalogo", sCondicion, "Cat_Orden", -1, 0, "Todos", "Editar")
%>
                        </div>
                            <label class="col-sm-2 control-label">Fechas de Pago:</label>
                            <div class="col-sm-4 m-b-xs" >
                                <input class="form-control date-picker date" id="FechaBusqueda" 
                                       placeholder="dd/mm/aaaa" type="text" value="" 
                                       style="width: 200px;float: left;" > 
                                   <span class="input-group-addon" style="width: 37px;float: left;height: 34px;"><i class="fa fa-calendar"></i></span>

                            </div>

                            </div>
                        </div>                    
                        <!-- div class="row">
                            <div class="col-sm-12 m-b-xs">
                                    <label class="col-sm-2 control-label">Master box:</label>
                                    <div class="col-sm-3 m-b-xs">
										<input type="text" class="form-control" autocomplete="off" placeholder="Masterbox del Pallet" />
                                    </div>
                                    <label class="col-sm-2 control-label">LPN:</label>
                                    <div class="col-sm-3 m-b-xs">
										<input type="text" class="form-control" autocomplete="off" placeholder="LPN de Pallet" />
                                    </div>
                            </div>
                        </div -->                     
                                            
<!--                        <div class="m-b-lg">
                            <div class="m-t-md">
                                <div class="pull-right">
                                    <button type="button" class="btn btn-sm btn-white"> <i class="fa fa-comments"></i> </button>
                                    <button type="button" class="btn btn-sm btn-white"> <i class="fa fa-user"></i> </button>
                                    <button type="button" class="btn btn-sm btn-white"> <i class="fa fa-list"></i> </button>
                                    <button type="button" class="btn btn-sm btn-white"> <i class="fa fa-pencil"></i> </button>
                                    <button type="button" class="btn btn-sm btn-white"> <i class="fa fa-print"></i> </button>
                                    <button type="button" class="btn btn-sm btn-white"> <i class="fa fa-cogs"></i> </button>
                                </div>
                                <strong> 61 incidencias encontradas.</strong>
                            </div>
                        </div>
-->                     
                        <div class="text-center" id="loading">
                            <div class="spiner-example">
                                <div class="sk-spinner sk-spinner-three-bounce">
                                    <div class="sk-bounce1"></div>
                                    <div class="sk-bounce2"></div>
                                    <div class="sk-bounce3"></div>
                                </div>
                            </div>
                            <div>Cargando informaci&oacute;n, espere un momento...</div>
                        </div>
                        <div class="table-responsive" id="dvTablaPagos">
                        </div>
                      </div>                    

                    </div>

                </div>
            </div>
        </div>
    </div>
</div>
               <input type= "hidden" id="Pag_ID" name="Pag_ID" class="input-sm form-control" value="0" style="width:150px"></input>

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
    
     $('#loading').hide()
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

   
    
    CargaGridInicial()


      $(".btnBuscar").click(function(event) {

          
            $("#dvTablaPagos").empty()
            var dato = {}
                dato['Lpp'] = 1  //este parametro limpia el cache
                dato['Pag_Monto'] = $('#Pag_Monto').val()
                dato['Pag_ReferenciaBancaria'] = $('#Pag_ReferenciaBancaria').val()
                dato['Prov_ID'] = $('#Prov_ID').val()
                dato['FechaInicio'] = $('#inicio').val()
                dato['FechaFin'] = $('#fin').val()
                dato['Pag_AplicadoCG150'] = $('#Pag_AplicadoCG150').val()

        $("#dvTablaPagos").load("/pz/wms/Proveedor/Facturacion/B_Facturacion_Pagos_Grid.asp",dato);

	   });
    
});    
    
    function CargaGridInicial(){

            var Prov_ID = $('#Prov_ID').val()
        $("#dvTablaPagos").load("/pz/wms/Proveedor/Facturacion/B_Facturacion_Pagos_Grid.asp?Prov_ID="+Prov_ID);

    }
        
</script>



