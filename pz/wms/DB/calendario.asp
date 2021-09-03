<script src="/Template/inspina/js/plugins/jquery-ui/jquery-ui.min.js"></script>
<script src="/Template/inspina/js/plugins/fullcalendar/moment.min.js"></script>
<script src="/Template/inspina/js/plugins/fullcalendar/fullcalendar.min.js"></script>
<script src="/Template/inspina/js/plugins/fullcalendar/locale-all.js"></script>
<script src="/Template/inspina/js/plugins/clockpicker/clockpicker.js"></script>
<script src="/Template/inspina/js/plugins/datapicker/bootstrap-datepicker.js"></script>
<script src="/Template/inspina/js/plugins/iCheck/icheck.min.js"></script>
<div class="row">
	<div class="form-group">
   		<label class="control-label col-lg-3"><strong>Día inicio</strong></label>
   		<div class="col-lg-3">
      		<div class="input-group date">
         		<input class="form-control date-picker Fecha Robin agenda" id="StartDate" placeholder="dd/mm/aaaa" type="text" autocomplete="off" value=""                 data-esfecha="1"> 
         		<span class="input-group-addon"><i class="fa fa-calendar"></i></span>
      		</div>
   		</div>
	</div>
    <div class="form-group">
   		<label class="control-label col-lg-3"><strong>Día termino</strong></label>
   		<div class="col-lg-3">
      		<div class="input-group date">
         		<input class="form-control date-picker Fecha Robin agenda" id="EndDate" placeholder="dd/mm/aaaa" type="text" autocomplete="off" value=""                data-esfecha="1"> 
         		<span class="input-group-addon"><i class="fa fa-calendar"></i></span>
      		</div>
   		</div>
	</div>
</div>
<script type="application/javascript">
   $(document).ready(function() {
   	
   	$('#BtnAgendar').click(function(e) {
           e.preventDefault()
   		//console.log($('.StartCall').text())
   		//console.log($('.EndCall').text())
   //		eventData = {
   //			start: $('#StartDate').val(),
   //			end: $('#EndDate').val(),
   //			hourStart:$('#StartHour').val(),
   //			hourEnd:$('#EndHour').val(),
   //			Prov_ID:$('#Prov_ID').val(),
   //			Cli_ID:$('#Cli_ID').val()
   //		}
   		var datoAgenda = {}
   		$('.agenda').each(function(index, element) {
               datoAgenda[$(this).attr('id')] = $(this).val()
           });
   		datoAgenda['Tarea'] = 1
   		datoAgenda['IDUsuario'] = $('#IDUsuario').val()
   
   		console.log(datoAgenda)
   		GuardaCita(datoAgenda)
   		$('#MyBatmanModal').modal('hide') 
   		//$('.agenda').val("")
       });
   	
   	$('#BtnQuitar').click(function(e) {
           e.preventDefault()
   		$('#MyBatmanModal').modal('hide') 
   		BorraEvento($('#Event_ID').val())
   		$('#calendar').fullCalendar('removeEvents', $('#Event_ID').val());
       });
    			
   	$('.Fecha').datepicker({
   		todayBtn: "linked", 
   		language: "es",
   		todayHighlight: true,
   		autoclose: true
   	});
   	$('#btnPruebaRapida').click(function(e) {
           e.preventDefault()
   		MandaSO()
       });
   	$('.Hora').clockpicker({
   		autoclose: true,
   		twentyfourhour: true,
   	});
   	$('#cbTipo90_ID').change(function(e) {
           e.preventDefault()
   		AsignarA($(this).val())
       });
   	
   	$('#Alm_ID').change(function(e) {
           e.preventDefault()
   		AlmPuerta($(this).val())
       });
   	
   	var Renglon = 0;
   		$('#btnAddCal').click(function(e) {
   			Renglon++
               e.preventDefault()
   			var NewTask = "<div class='external-event navy-bg'>Hola "+Renglon+".</div>"
   			
   			
   			$('#external-events').append(NewTask)
           });
   
   	var Calendar = $('#calendar').fullCalendar({
               header: {
                   left: 'prev,next today',
                   center: 'title',
                   right: 'month,agendaWeek,agendaDay'
               },
   			themeSystem: 'bootstrap3',
   			lang: 'es',
   			timeFormat: 'H(:mm)',
   			contentHeight:"auto",
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
   			eventDrop: function(event, delta, revertFunc) {
   				console.log(event.start.format())
   				console.log(event.id)
   				console.log(event)
   				var terminar = event.end
   				if(terminar == null){
   					terminar = event._start
   				}
   
   				if (!confirm("Seguro deseas cambiar la cita a "+event.start.format()+"?")) {
   					revertFunc()
   				}else{
   					UpdateCita(event.start.format(),terminar.format(),event.id)
   				}
   			},
   			eventResize: function(info) {	
   				console.log(info.start.format())
   				console.log(info.id)
   				if (!confirm("Seguro?")) {
   					revertFunc();
   				}else{
   					UpdateCita(info.start.format(),info.end.format(),info.id)
   				}
   			},
   			select: function(start, end) {
   				$('.Robin').attr('disabled',false)
   				$('#MyBatmanModal').modal('show')  
   				$('#TitleCall').text()
   				$('#StartDate').val(start.format('MM/DD/YYYY'))
   				$('#EndDate').val(start.format('MM/DD/YYYY'))
   				
   			},
   			eventClick: function(event, jsEvent, view) {
   				$('.Robin').attr('disabled',true)
   				$('#MyBatmanModal').modal('show')  
   				
   				console.log(event)
   				var terminar = event.end
   				if(terminar == null){
   					terminar = event._start
   				}
   				$('#StartDate').val(event.start.format('MM/DD/YYYY'))
   				$('#EndDate').val(terminar.format('MM/DD/YYYY'))
   				$('#StartHour').val(event.start.format('HH:mm'))
   				$('#EndHour').val(terminar.format('HH:mm'))	
   				$('#Event_ID').val(event.id)	
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
   	
   	$("#frmDatos").on("click", ".external-event", function(){
               // store data so the calendar knows to render an event upon drop
               $(this).data('event', {
                   title: $.trim($(this).text()), // use the element's text as the event title
                   stick: true // maintain when user navigates (see docs on the renderEvent method)
               });
   
               // make the event draggable using jQuery UI
               $(this).draggable({
                   zIndex: 1111999,
                   revert: true,      // will cause the event to go back to its
                   revertDuration: 0  //  original position after the drag
               });
   
   	});
   	
   	$('#MyBatmanModal').on('hidden.bs.modal', function (e) {
   		$('#StartDate').val("")
   		$('#EndDate').val("")
   		$('#StartHour').val("")
   		$('#EndHour').val("")	
   	})	
   	
   function GuardaCita(Evento){
   	$.post("/pz/wms/Recepcion/Recepcion_Ajax.asp",Evento
       , function(data){
   		var obj = JSON.parse(data)
   		if (obj.id > -1) {
   			sTipo = "info";
   			sMensaje = "El registro se ha guardado correctamente ";
   			$('#calendar').fullCalendar('renderEvent', obj, false);
   			
   		} else {
   			sTipo = "warning";
   			sMensaje = "Ocurrio un error al realizar el guardado";
   			
   		}
   		Avisa(sTipo,"Aviso",sMensaje);
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
   		if (data == 1) {
   			sTipo = "info";
   			sMensaje = "El registro se ha guardado correctamente ";
   			
   		} else {
   			sTipo = "warning";
   			sMensaje = "Ocurrio un error al realizar el guardado";
   			
   		}
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
   			//url: "http://198.38.94.238:1117/lyde/api/OrdenVenta",
   			success: function(data){
   				console.log(data)			
   			}
   		});
   				
   	}
   }
   
   
</script>