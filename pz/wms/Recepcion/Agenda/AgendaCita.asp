<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../../Includes/iqon.asp" -->

<%

				
%>
<link href="/Template/inspina/js/plugins/fullcalendar-5.3.2/lib/fullcalendar-5.3.2.min.css" rel="stylesheet">

<style>
.EventoNice{
	color:#FFF;
	background:#9fffe921;
	font-size:14px;	
	border-radius: 12px;
}
body.modal-open {
  height: 100vh;
  overflow-y: hidden;
}

</style>


<div class="wrapper wrapper-content" id="frmDatos">
    <div class="col-lg-12">
        <div class="ibox float-e-margins">
            <div class="ibox-title">
                <h5>Calendario</h5>
            </div>
            <div class="ibox-content" style="height: 535px;">
                <div id='calendar'></div>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="myModalLabel">Modal title</h4>
      </div>
      <div class="modal-body">
        <div class="spiner-example" id="loading">
            <div class="sk-spinner sk-spinner-wandering-cubes">
                <div class="sk-cube1"></div>
                <div class="sk-cube2"></div>
        	</div>
        </div>
        <div  id="modalBody"></div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
        <button type="button" class="btn btn-primary">Save changes</button>
      </div>
    </div>
  </div>
</div>

<script src="/Template/inspina/js/plugins/fullcalendar-5.3.2/lib/fullcalendar-5.3.2.min.js"></script>
<script src="/Template/inspina/js/plugins/fullcalendar-5.3.2/lib/locales-all.js"></script>

<script type="application/javascript">
$('#loading').hide()
	$(document).ready(function() {
		var calendarEl = document.getElementById('calendar');
	
		var calendar = new FullCalendar.Calendar(calendarEl, {
		  headerToolbar: {
			left: 'prev,next today',
			center: 'title',
			right: 'dayGridMonth,timeGridWeek,timeGridDay'
		  },
			businessHours: [
			  {
				daysOfWeek: [ 1, 2, 3 ,4 ,5], // L a V
				startTime: '08:00', // 8am
				endTime: '19:00' // 6pm
			  },
			  {
				daysOfWeek: [ 6 ], // Sabados
				startTime: '10:00', // 10am
				endTime: '14:00' // 2pm
			  }
			],
		  themeSystem: 'bootstrap',
		  locale: 'es',
		  weekNumbers: true,
		  height: '100%',
		  navLinks: true, // can click day/week names to navigate views
		  dateClick: function(info) {
			$('#myModal').modal('show')	
			FunctionCalendario.GetInfoModal(1)
		  },
			select: function(arg) {
			  
			$('#myModal').modal('show')	
			FunctionCalendario.GetInfoModal(1)
			calendar.unselect()
		  },
		  eventClick: function(arg) {
			$('#myModal').modal('show')	
			FunctionCalendario.GetInfoModal(1)
		  },
		  editable: true,
		  events: '/pz/wms/Recepcion/RecepcionEventos.asp'
		});
	
		calendar.render();
	});
  
	$('#myModal').on('shown.bs.modal', function (e) {
		
	});

	var FunctionCalendario = {
	  GetInfoModal:function(Ag_ID){
		$('#loading').show('slow')
		$.post("/pz/wms/Recepcion/Agenda/AgendaCita_Modal.asp",
		{
			Ag_ID:Ag_ID
		},function(data){
			$('#loading').hide('slow')
			$('#modalBody').html(data)
		});
	  }
	  
	}
	  

</script>
