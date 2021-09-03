<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../../Includes/iqon.asp" -->
<link href="/Template/inspina/css/plugins/select2/select2.min.css" rel="stylesheet"/>    
<link href="/Template/inspina/css/animate.css" rel="stylesheet"/>
<link href="/Template/inspina/css/plugins/daterangepicker/daterangepicker-bs3.css" rel="stylesheet"/>

<div id="wrapper">
    <div class="wrapper wrapper-content">   
        <div class="row">
            <div class="col-lg-12">
                <div class="ibox float-e-margins">
                    <div class="ibox-title">
                        <h5>Filtros de b&uacute;squeda</h5>
                        <div class="ibox-tools">
                        </div>
                        <div class="ibox-content">
                            <div class="col-sm-12 m-b-xs" id="ciclicAuditsFilters">    
                                <div class="row"> 
                                    <label class="col-sm-2 control-label">Cliente:</label>
                                    <div class="col-sm-4 m-b-xs">
                                        <% 
                                            var sEventos = " class='input-sm form-control cbo2'  style='width:200px'";
                                            var sCondicion = "";
                                            CargaCombo("cbCli_ID", sEventos, "Cli_ID", "Cli_Nombre", "Cliente", "", "Cli_Nombre", Parametro("Cli_ID",-1), 0, "Todos", "Editar");
                                        %>
                                    </div>
                                    <label class="col-sm-1 control-label">SKU:</label>    
                                    <div class="col-sm-3 m-b-xs">
<% 
//                                            var sEventos = " class='input-sm form-control cbo2'  style='width:200px'";
//                                            var sCondicion = " Sec_ID = 140 ";
//                                            CargaCombo("cbAudType", sEventos, "Cat_ID", "Cat_Nombre", "Cat_Catalogo", sCondicion, "Cat_Orden", -1, 0, "Todos", "Editar");
%>
                 							<input type="text" class="form-control Pro_SKU" autocomplete="off" placeholder="SKU"></input>
                                    </div>
                                    <div class="col-sm-1 m-b-xs" style="text-align: left;">  
                                        <button class="btn btn-success btn-sm" type="button" id="btnBuscar"><i class="fa fa-search"></i>&nbsp;&nbsp;<span class="bold">Buscar</span></button>
                                    </div>
                                </div>    
                                <div class="row">
                                    <label class="col-sm-2 control-label">N&uacute;mero tienda:</label>    
                                    <div class="col-sm-4 m-b-xs">
                                        <input id="FolioTienda" placeholder="No disponible" class="input-sm form-control" type="text" value="" style="width:200px">
                                    </div>
                                    <label class="col-sm-1 control-label">Estatus:</label>
                                    <div class="col-sm-4 m-b-xs">
                                        <% 
                                            var sEventos = " class='input-sm form-control cbo2'  style='width:200px'";
                                            var sCondicion = " Sec_ID = 51 and Cat_Tipo = 1 ";
                                            CargaCombo("cbEstatus", sEventos, "Cat_ID", "Cat_Nombre", "Cat_Catalogo", sCondicion, "Cat_Orden", -1, 0, "Todos", "Editar");
                                        %>
                                    </div>
                                </div>
                                <div class="row">
                                    <label class="col-sm-2 control-label">Rango fechas:</label>
                                    <div class="col-sm-4 m-b-xs" >
                                        <input class="form-control date-picker date" data-input-ids="inicio,fin" id="FechaBusqueda" 
                                                placeholder="dd/mm/aaaa" type="text" value="" 
                                                style="width: 200px;float: left;" /> 
                                            <span class="input-group-addon" style="width: 37px;float: left;height: 34px;"><i class="fa fa-calendar"></i></span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-12 m-b-xs">
                                <div class="pull-right">
                                    <div data-toggle="buttons" class="btn-group">
                                        <label class="btn btn-sm btn-white TipoR active"> 
                                            <input type="radio" id="option1" value="/pz/wms/Almacen/Inventario/Surtido_Diario.asp"/> <i class="fa fa-area-chart"></i> D&iacute;a </label>
                                        <label class="btn btn-sm btn-white TipoR "> 
                                            <input type="radio" id="option2" value="/pz/wms/Almacen/Inventario/Surtido_Documento.asp"/> 
                                            <i class="fa fa-book"></i> Documento </label>
                                       <!-- <label class="btn btn-sm btn-white TipoR"> 
                                            <input type="radio" id="option3" value="/pz/wms/Almacen/Inventario/Surtido_Completo.asp"/> 
                                            <i class="fa fa-tasks"></i>Completo</label>-->
                                    </div> 
                                </div>
                            </div>
                        </div>
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
                         <div class="table-responsive" id="dvTablaDisponible"></div>  
                        <div class="table-responsive" id="dvTablaSurtido"></div>  
                    </div>
                </div>
            </div>
        </div>
    </div>                  
</div>

<script src="/Template/inspina/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
<script src="/Template/inspina/js/plugins/pace/pace.min.js"></script>
<script src="/Template/inspina/js/plugins/select2/select2.full.min.js"></script>
<input id="inicio" type="hidden" value="" />
<input id="fin" type="hidden" value="" />
<input id="Aud_ID" name="Aud_ID" type="hidden" value="-1" />            
<!-- Date range use moment.js same as full calendar plugin -->
<script src="/Template/inspina/js/plugins/fullcalendar/moment.min.js"></script>

<!-- Date range picker -->
<script src="/Template/inspina/js/plugins/daterangepicker/daterangepicker.js"></script>
<script type="text/javascript">
    
    $("#loading").hide();
    var loading = '<div class="spiner-example">'
                        +'<div class="sk-spinner sk-spinner-three-bounce">'
                            +'<div class="sk-bounce1"></div>'
                            +'<div class="sk-bounce2"></div>'
                            +'<div class="sk-bounce3"></div>'
                        +'</div>'
                    +'</div>'
    var dato = {};    
    
    
    $(document).ready(function() {
        

		$('.TipoR').click(function(e){
            $("#loading").show('slow');
            $("#dvTablaSurtido").empty();
            e.preventDefault();
            var sDatos  = "?Cli_ID=" + $('#cbCli_ID').val()
                sDatos += "&Estatus=" + $('#cbEstatus').val()
                sDatos += "&Pro_SKU=" + $('.Pro_SKU').val()
                sDatos += "&Folio_Tienda=" + $('.Folio_Tienda').val()
                sDatos += "&FechaInicio="+ $('#inicio').val()
                sDatos += "&FechaFin="+$('#fin').val()
            
            var tab = $(this).find('input').val();
            
            $("#dvTablaSurtido").load(tab+sDatos, function() {
                $("#loading").hide('slow');
                $("#dvTablaSurtido").show('slow');
            });
		
    });
        $('.cbo2').select2();
        
        $('#FechaBusqueda').daterangepicker(
            {
               "showDropdowns": true,
               "firstDay": 7,	
               "startDate":moment().startOf('month'),
               "endDate": moment(),
               "autoApply": true,
               "format": "DD/MM/YYYY", 
               "ranges": {
                   'Hoy': [moment(), moment()],
                   'Al dia de hoy': [moment().startOf('month'), moment()],
                   'Este Mes': [moment().startOf('month'), moment().endOf('month')],
                   'Mes pasado': [moment().subtract(1, 'month').startOf('month')
                               , moment().subtract(1, 'month').endOf('month')],
                   'Ultimos 7 Dias': [moment().subtract(6, 'days'), moment()],
                   'Ultimos 15 Dias': [moment().subtract(14, 'days'), moment()],
                   'Ultimos 30 Dias': [moment(), moment().subtract(29, 'days')],
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
                }}, 
                function(start, end, label) {
                   $("#inicio").val(moment.utc(start, 'DD/MM/YYYY').local().format('DD/MM/YYYY'))
                   $("#fin").val(moment.utc(end, 'DD/MM/YYYY').local().format('DD/MM/YYYY'))
                    $("#FechaBusqueda").val($("#inicio").val() + " - " + $("#fin").val())
        });

        $('#InitialDate').daterangepicker(
            {
                "minDate": moment(),
                "maxDate": moment().add(1,'years'),
                "singleDatePicker": true,
                "showDropdowns": true,
                "autoApply": true,
                "minYear": parseInt(moment().format('YYYY'),2020),
                "maxYear": 1
                },
                function(start, end, label) {
                    $("#newAuditInitDate").val(moment.utc(start, 'DD/MM/YYYY').local().format('DD/MM/YYYY'))
                    $("#InitialDate").val($("#newAuditInitDate").val())
            });

           // CargaGridInicial();

        $("#btnBuscar").click(function(event) {
            $("#loading").show('slow');
            $("#dvTablaSurtido").empty();
            var tab = $("div.btn-group .active").find('input').val();
            CargarGrid(tab);
            CargarDisponible();
        });
       
    });
    
    function CargarGrid(tab) {
        $("#dvTablaSurtido").empty();
		
			var sDatos = "?Cli_ID=" + $('#cbCli_ID').val()
				sDatos += "&Estatus=" + $('#cbEstatus').val()
				sDatos += "&Pro_SKU=" + $('.Pro_SKU').val()
				sDatos += "&Folio_Tienda=" + $('#FolioTienda').val()
				sDatos += "&FechaInicio="+ $('#inicio').val()
				sDatos += "&FechaFin="+$('#fin').val()
				
            $("#dvTablaSurtido").load(tab+sDatos, function() {
                $("#dvTablaSurtido").show('slow');
            });
		
    }
    
    function CargarDisponible() {
        $("#dvTablaDisponible").empty();
		
		var sDatos  = "?Cli_ID=" + $('#cbCli_ID').val()
            sDatos += "&Pro_SKU=" + $('.Pro_SKU').val()
				
		$("#dvTablaDisponible").load("/pz/wms/Almacen/Inventario/Inventario_SKU.asp"+sDatos, function() {
            $("#loading").hide('slow');
            $("#dvTablaDisponible").show('slow');
        });
		
    }

		
 //       dato['Lpp'] = 1;  //este parametro limpia el cache
//        dato['Cli_ID'] = $('#cbCli_ID').val();
//        dato['AuditType'] = $('#cbAudType').val();
//        dato['FechaInicio'] = $('#inicio').val();
//        dato['FechaFin'] = $('#fin').val();
//        dato['AuditEstatus'] = $('#cbEstatus').val();
//        dato['Auditor'] = $('#cbAuditor').val();
//        $("#dvTablaSurtido").load(tab,dato);
    
    
    function CargaGridInicial() {
        $("#loading").show('slow');
        $("#dvTablaSurtido").empty();
        $("#dvTablaSurtido").load("/pz/wms/Almacen/Inventario/Surtido_Diario.asp", function() {
			$("#loading").hide('slow');
			$("#dvTablaSurtido").show('slow');
		});
    }
</script>
