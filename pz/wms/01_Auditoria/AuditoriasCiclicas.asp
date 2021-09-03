<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<link href="/Template/inspina/css/plugins/select2/select2.min.css" rel="stylesheet"/>    
<link href="/Template/inspina/css/animate.css" rel="stylesheet"/>
<link href="/Template/inspina/css/plugins/daterangepicker/daterangepicker-bs3.css" rel="stylesheet"/>
<!--#include file="./NuevaAuditoriaCiclica_Modal.asp" -->
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
                                    <label class="col-sm-1 control-label">Cliente:</label>
                                    <div class="col-sm-4 m-b-xs">
                                        <% 
                                            var sEventos = " class='input-sm form-control cbo2'  style='width:200px'";
                                            var sCondicion = "";
                                            CargaCombo("cbCli_ID", sEventos, "Cli_ID", "Cli_Nombre", "Cliente", "", "Cli_Nombre", Parametro("Cli_ID",-1), 0, "No aplica", "Editar");
                                        %>
                                    </div>
                                    <label class="col-sm-1 control-label">Tipo de auditor&iacute;a:</label>    
                                    <div class="col-sm-4 m-b-xs">
                                        <% 
                                            var sEventos = " class='input-sm form-control cbo2'  style='width:200px'";
                                            var sCondicion = " Sec_ID = 140 ";
                                            CargaCombo("cbAudType", sEventos, "Cat_ID", "Cat_Nombre", "Cat_Catalogo", sCondicion, "Cat_Orden", -1, 0, "Todos", "Editar");
                                        %>
                                    </div>
                                    <div class="col-sm-1 m-b-xs" style="text-align: left;">  
                                        <button class="btn btn-primary btn-sm" type="button" id="btnNew" data-toggle="modal" data-target="#newModal"><i class="fa fa-plus"></i>&nbsp;&nbsp;<span class="bold">Nuevo</span></button>
                                    </div>
                                    <div class="col-sm-1 m-b-xs" style="text-align: left;">  
                                        <button class="btn btn-success btn-sm" type="button" id="btnBuscar"><i class="fa fa-search"></i>&nbsp;&nbsp;<span class="bold">Buscar</span></button>
                                    </div>
                                </div>    
                                <div class="row">
                                    <label class="col-sm-1 control-label">Auditor:</label>    
                                    <div class="col-sm-4 m-b-xs">
                                        <% 
                                            var sEventos = " class='input-sm form-control cbo2'  style='width:200px'";
                                            var sCondicion = "Usu_Habilitado = 1";
                                            CargaCombo("cbAuditor", sEventos, "Usu_ID", "Usu_Nombre", "Usuario", sCondicion, "Usu_ID", -1, 0, "Todos", "Editar");
                                        %>
                                    </div>
                                    <label class="col-sm-1 control-label">Estatus:</label>
                                    <div class="col-sm-4 m-b-xs">
                                        <% 
                                            var sEventos = " class='input-sm form-control cbo2'  style='width:200px'";
                                            var sCondicion = " Sec_ID = 141 ";
                                            CargaCombo("cbEstatus", sEventos, "Cat_ID", "Cat_Nombre", "Cat_Catalogo", sCondicion, "Cat_Orden", -1, 0, "Todos", "Editar");
                                        %>
                                    </div>
                                </div>
                                <div class="row">
                                    <label class="col-sm-1 control-label">Rango fechas:</label>
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
                                        <label class="btn btn-sm btn-white TipoR"> 
                                            <input type="radio" id="option1" value="/pz/wms/Auditoria/AuditoriasCiclicas_GridDatos.asp"/> <i class="fa fa-area-chart"></i> Datos </label>
                                        <label class="btn btn-sm btn-white TipoR active"> 
                                            <input type="radio" id="option2" value="/pz/wms/Auditoria/AuditoriasCiclicas_Grid.asp"/> <i class="fa fa-book"></i> Detalle </label>
                                        <label class="btn btn-sm btn-white TipoR"> 
                                            <input type="radio" id="option3" value="/pz/wms/Auditoria/AuditoriasCiclicas_GridResumido.asp"/> <i class="fa fa-tasks"></i> Resumido </label>
                                    </div> 
                                </div>
                            </div>
                        </div>
                        <div class="table-responsive" id="dvTablaAuditorias"></div>  
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
<!-- Date range use moment.js same as full calendar plugin -->
<script src="/Template/inspina/js/plugins/fullcalendar/moment.min.js"></script>

<!-- Date range picker -->
<script src="/Template/inspina/js/plugins/daterangepicker/daterangepicker.js"></script>
<script type="text/javascript">
    var dato = {};    
    $(document).ready(function() {
		$('#Aud_ID').val("")
        $('.TipoR').click(function(e){
            e.preventDefault();
            var tab = $(this).find('input').val();
            $("#dvTablaAuditorias").load(tab,dato);
        });   
        $('.cbo2').select2();
        $('#FechaBusqueda').daterangepicker(
            {
               "showDropdowns": true,
               "firstDay": 7,	
               "startDate":moment().startOf('month'),
               "endDate": moment(),
                "autoApply": true,
               "ranges": {
                    'Hoy': [moment(), moment()],
                   'Al dia de hoy': [moment().startOf('month'), moment()],
                   'Este Mes': [moment().startOf('month'), moment().endOf('month')],
                   'Mes pasado': [moment().subtract(1, 'month').startOf('month')
                               , moment().subtract(1, 'month').endOf('month')],
                   '+-7 Dias': [moment().subtract(7, 'days') , moment().subtract(-6, 'days')],
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
                "minYear": parseInt(moment().format('YYYY'),1900),
                "maxYear": 1
                },
                function(start, end, label) {
                    $("#newAuditInitDate").val(moment.utc(start, 'DD/MM/YYYY').local().format('DD/MM/YYYY'))
                    $("#InitialDate").val($("#newAuditInitDate").val())
            });

        CargaGridInicial();
        $("#btnBuscar").click(function(event) {
            var tab = $("div.btn-group .active").find('input').val();
            CargarGrid(tab);
        });
       
    });
    
    function CargarGrid(tab) {
        $("#dvTablaAuditorias").empty();
        dato['Lpp'] = 1;  //este parametro limpia el cache
        dato['Cli_ID'] = $('#cbCli_ID').val();
        dato['AuditType'] = $('#cbAudType').val();
        dato['FechaInicio'] = $('#inicio').val();
        dato['FechaFin'] = $('#fin').val();
        dato['AuditEstatus'] = $('#cbEstatus').val();
        dato['Auditor'] = $('#cbAuditor').val();
        $("#dvTablaAuditorias").load(tab,dato);
    }
    
    function CargaGridInicial() {
        var tab = $("div.btn-group .active").find('input').val();
        $("#dvTablaAuditorias").load("/pz/wms/Auditoria/AuditoriasCiclicas_Grid.asp");
    }
</script>
