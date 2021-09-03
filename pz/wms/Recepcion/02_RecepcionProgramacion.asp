<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->

<%

var TA_ID = Parametro("TA_ID",-1)
var CliOC_ID = Parametro("CliOC_ID",-1)
var OC_ID = Parametro("OC_ID",-1)
var Prov_ID = Parametro("Prov_ID",-1)
var CliEnt_ID = Parametro("CliEnt_ID", -1)
var ProvEnt_ID = Parametro("ProvEnt_ID", -1)
var Cli_ID = Parametro("Cli_ID", -1)


%>
<link href="/Template/inspina/css/plugins/clockpicker/clockpicker.css" rel="stylesheet">
<link href="/Template/inspina/css/plugins/datapicker/datepicker3.css" rel="stylesheet">
<link href="/Template/inspina/css/plugins/fullcalendar/fullcalendar.css" rel="stylesheet">
<link href="/Template/inspina/css/plugins/iCheck/green.css" rel="stylesheet">

<div class="wrapper wrapper-content">
    <div class="row animated fadeInDown">
        <div class="col-lg-12">
            <div class="ibox float-e-margins" id="dvCita">
                <div class="ibox-title">
                	<div class="row">
                    	<div class="col-md-6">
                            <h3>Calendario</h3>
                        </div>
                    	<div class="col-md-6 text-right">
                        	<button type="button" class="btn btn-primary"><i class="fa fa-plus"></i>&nbsp;&nbsp;Nueva cita</button>
                        </div>
                    </div>
                </div>
                <div class="ibox-content">
                    <div class='text-center' id="loading">
                        <span id='loading'>Cargando...</span>
                    </div>
                    <div id="calendar"></div>
                </div>
            </div>
        </div>
    </div>
</div>





<div class="modal fade" tabindex="-1" id="modalCalendario" role="dialog">
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h2 class="modal-title"><strong id="titleCita"></strong></h2>
      </div>
      <div class="modal-body" id="bodyModal">
      </div>
      <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-dismiss="modal">Cerrar</button>
      </div>
    </div>
  </div>
</div>


<input type="hidden" id="IR_ID" value=""/>
<script src="/Template/inspina/js/plugins/fullcalendar/moment.min.js"></script>
<script src="/Template/inspina/js/plugins/fullcalendar/fullcalendar.min.js"></script>
<script src="/Template/inspina/js/plugins/fullcalendar/locale-all.js"></script>
<script src="/Template/inspina/js/plugins/clockpicker/clockpicker.js"></script>
<script src="/Template/inspina/js/plugins/datapicker/bootstrap-datepicker.js"></script>
<script src="/Template/inspina/js/plugins/iCheck/icheck.min.js"></script>


<script type="application/javascript">

$(document).ready(function() {


	var Calendar = $('#calendar').fullCalendar({
            header: {
                left: 'prev,next today',
                center: 'title',
                right: 'month,agendaWeek,agendaDay'
            },
			themeSystem: 'bootstrap3',
			lang: 'es',
			timeFormat: 'H(:mm)',
			//contentHeight:"auto",
            droppable: true,
			firstDay: 1,
			editable: true,
			eventLimit: true,
			selectable: true,
			selectHelper: true,
            drop: function() {
                // is the "remove after drop" checkbox checked?
                    // if so, remove the element from the "Draggable Events" list
                    $(this).remove();
					//console.log($(this))

            },
			//eventDrop: function(event, delta, revertFunc) {
//				console.log(event.start.format())
//				console.log(event.id)
//				console.log(event)
//				var terminar = event.end
//				if(terminar == null){
//					terminar = event._start
//				}
//
//				if (!confirm("Seguro deseas cambiar la cita a "+event.start.format()+"?")) {
//					revertFunc()
//				}else{
//					UpdateCita(event.start.format(),terminar.format(),event.id)
//				}
//			},
//			eventResize: function(info) {	
//				console.log(info.start.format())
//				console.log(info.id)
//				if (!confirm("Seguro?")) {
//					revertFunc();
//				}else{
//					UpdateCita(info.start.format(),info.end.format(),info.id)
//				}
//			},
			select: function(start, end) {
				$('#modalCalendario').modal('show') 
				$('#titleCita').html('Nueva cita')
				$('#IR_ID').val(-1)
			},
			eventClick: function(event, jsEvent, view) {
				$('#IR_ID').val(event.id)
				$('#titleCita').html('Cita '+event.title)
				$('#modalCalendario').modal('show')  
				
//				console.log(event)
//				var terminar = event.end
//				if(terminar == null){
//					terminar = event._start
//				}
				
//				$('#EndDate').val(terminar.format('MM/DD/YYYY'))
//				$('#StartHour').val(event.start.format('HH:mm'))
//				$('#EndHour').val(terminar.format('HH:mm'))	
//				$('#Event_ID').val(event.id)	
			},
			events: {
				url: '/pz/wms/Recepcion/RecepcionEventos.asp',
				error: function() {
					
				}
			},
			loading: function(bool) {
				$('#loading').toggle(bool);
			},
			eventRender: function(eventObj, $el) {
			  $el.popover({
				title: eventObj.title,
				content: eventObj.description,
				trigger: 'hover',
				placement: 'top',
				container: 'body'
			  });
			}
	  });


});
	
	$('#modalCalendario').on('shown.bs.modal', function () {
	  	AgendaFunciones.CargaContenido();
	})

var AgendaFunciones = {
	CargaContenido:function(){
		$.post("/pz/wms/Recepcion/Agenda/Agenda_Contenido.asp",{
			IR_ID:$('#IR_ID').val()
		}
		, function(data){
			$("#bodyModal").html(data)
		});
	}
	
	
	
}
	
	
	
	
function GuardaCita(Evento){
			$("#dvCita").load("/pz/wms/Recepcion/Recepcion_Ajax.asp",Evento
    , function(data){
	
			sTipo = "info";
			sMensaje = "El registro se ha guardado correctamente ";
			
				Avisa(sTipo,"Aviso",sMensaje);
				$("#Contenido").load("/pz/wms/Recepcion/RecepcionProgramacion.asp")
	});
}
function UpdateCita(start,end,id){
	$.post("/pz/wms/Recepcion/Recepcion_Ajax.asp",{
		Tarea:2
		,DateStart:start
		,DateEnd:end
		,IR_ID:id
		,IDUsuario:$("#IDUsuario").val()
	}
    , function(data){
		
			sTipo = "info";
			sMensaje = "El registro se ha guardado correctamente ";
	
		Avisa(sTipo,"Aviso",sMensaje);
	});
}
function BorraEvento(id){
	$.post("/pz/wms/Recepcion/Recepcion_Ajax.asp",{
		Tarea:4
		,IR_ID:id
		,IDUsuario:$("#IDUsuario").val()
	}
    , function(data){
		if (data == 1) {
			sTipo = "info";
			sMensaje = "El registro borrado exitosamente";
			$('#Event_ID').val("")
			
		} else {
			sTipo = "warning";
			sMensaje = "Ocurrio un error al realizar el guardado";
			
		}
		Avisa(sTipo,"Aviso",sMensaje);
	});
}
function AsignarA(id){
	$.get("/pz/wms/Recepcion/Recepcion_Ajax.asp",{
		Tarea:3
		,cbTipo_ID:id
	}
    , function(data){
		if (data != "") {
			$('#AsignarA').html(data)
		} else {
			sTipo = "warning";
			sMensaje = "Ocurrio un error al realizar el guardado";
			Avisa(sTipo,"Aviso",sMensaje);
		}
	});
}

function AlmPuerta(id){
	$.get("/pz/wms/Recepcion/Recepcion_Ajax.asp",{
		Tarea:5
		,Alm_ID:id
	}
    , function(data){
		if (data != "") {
			$('#AlmP_Puerta').html(data)
		} else {
			$('#AlmP_Puerta').html(data)
		}
	});
}


function MandaSO(){
	for(var i = 1; i<=3; i++){
		
		var STAT5 = 1
		if(i == 3){
			STAT5  = 2
		}
		var data = {
			"CORID":3,
			"CUSTOMER_SO":"121564689",
			"PART_NUMBER":"28010",
			"SHIPPING_ADDRESS":"Hola Pa",
			"SHIPPIED_QTY":1,
			"TEXTO":"N/A",
			"STAT5":STAT5
		}
			
	var myJSON = JSON.stringify(data);
		
		$.ajax({
			type: 'post',
			contentType:'application/json',
			data: myJSON,
			url: "http://198.38.94.238:1117/lyde/api/OrdenVenta",
			success: function(data){
				console.log(data)			
			}
		});
				
	}
}

	function CargaDatos(irid,conductor,placas,vehiculo,almacen,color,fecha,horario,puerta, minutos)	{
				$('#IR_ID').val(irid)
				$('#IR_Conductor').val(conductor)
				$('#IR_Placas').val(placas)
				 $('#IR_DescripcionVehiculo').val(vehiculo)
				$('#Alm_ID').val(almacen)
				$('#IR_Color').val(color)
				$('#IR_Puerta').val(puerta)
				$('#IR_FechaEntrega').val(fecha)	
				HorasDisp($('#IR_Puerta').val(),minutos,fecha)
				$('#IR_Horario').val(horario)
				$('#MyBatmanModal').modal('show')  
			   $("#BtnActualizar").show();
				$("#BtnCancelar").show();
				$("#BtnAgendar").hide();
		}
		function HorasDisp(puerta, minPallet, fecha){
	$.get("/pz/wms/Recepcion/Recepcion_Ajax.asp",{
		Tarea:5
		,IR_Puerta:puerta
		,TiempoPallet:minPallet
		,IR_FechaEntrega:fecha
	}
 , function(data){
		if (data != "") {
			$('#dvHora').html(data)
			}
		});
}
</script>
