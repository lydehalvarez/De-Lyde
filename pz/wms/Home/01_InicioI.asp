<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->

	

<link href="/Template/inspina/css/plugins/fullcalendar/fullcalendar.css" rel="stylesheet">
<link href="/Template/inspina/css/plugins/fullcalendar/fullcalendar.print.css" rel='stylesheet' media='print'>
<!-- Mainly scripts -->
<script src="/Template/inspina/js/plugins/fullcalendar/moment.min.js"></script>
	
<!-- Full Calendar -->
<script src="/Template/inspina/js/plugins/fullcalendar/fullcalendar.min.js"></script>

<script src="/Template/inspina/js/plugins/i18next/es.js"></script>
	
<div class="wrapper wrapper-content animated fadeIn">
	<div class="row">
		<div class="col-md-8">
			<div class="ibox float-e-margins">
			<div class="ibox-title">
					<h5>Calendario de eventos&nbsp;&nbsp;<!--small class="m-l-sm"--><!--i class="fa fa-calendar-o"></i--><!--/small--></h5>
					<div class="ibox-tools">
							<a class="collapse-link">
									<i class="fa fa-chevron-up"></i>
							</a>
							<a class="dropdown-toggle" data-toggle="dropdown" href="#">
									<i class="fa fa-wrench"></i>
							</a>
							<ul class="dropdown-menu dropdown-user">
									<li><a href="#">Servicios</a></li>
									<li><a href="#">Control veh&iacute;cular</a></li>
							</ul>
							<!--a class="close-link">
									<i class="fa fa-times"></i>
							</a-->
					</div>
			</div>
			<div class="ibox-content">
					<!--span class="text-muted small pull-right">&Uacute;ltima modificaci&oacute;n: <i class="fa fa-clock-o"></i> 10:10 pm - 06.06.2018</span-->
						<!--div class="ibox-content"-->
							<div id="calendario"></div>
						<!--/div-->
			</div>
			<!--div class="ibox-footer">
					<span class="pull-right">
						<i class="fa fa-copyright"></i>
					</span>
					AG
			</div-->
		</div>
		
		
		</div>
		<div class="col-md-4">
			<div class="ibox-title">
				<h5>Avisos&nbsp;&nbsp;<i class="fa fa-bell"></i></h5>
				<div class="ibox-tools">
						<!--a class="collapse-link">
								<i class="fa fa-chevron-up"></i>
						</a>
						<a class="close-link">
								<i class="fa fa-times"></i>
						</a-->
				</div>
			</div>			
			<div class="ibox-content">
			<table class="table table-hover no-margins">
				<thead>
				<tr>
						<th>Status</th>
						<th>Date</th>
						<th>User</th>
						<th>Value</th>
				</tr>
				</thead>
				<tbody>
				<tr>
						<td><small>Pending...</small></td>
						<td><i class="fa fa-clock-o"></i> 11:20pm</td>
						<td>Samantha</td>
						<td class="text-navy"> <i class="fa fa-level-up"></i> 24% </td>
				</tr>
				<tr>
						<td><span class="label label-warning">Canceled</span> </td>
						<td><i class="fa fa-clock-o"></i> 10:40am</td>
						<td>Monica</td>
						<td class="text-navy"> <i class="fa fa-level-up"></i> 66% </td>
				</tr>
				<tr>
						<td><small>Pending...</small> </td>
						<td><i class="fa fa-clock-o"></i> 01:30pm</td>
						<td>John</td>
						<td class="text-navy"> <i class="fa fa-level-up"></i> 54% </td>
				</tr>
				<tr>
						<td><small>Pending...</small> </td>
						<td><i class="fa fa-clock-o"></i> 02:20pm</td>
						<td>Agnes</td>
						<td class="text-navy"> <i class="fa fa-level-up"></i> 12% </td>
				</tr>
				<tr>
						<td><small>Pending...</small> </td>
						<td><i class="fa fa-clock-o"></i> 09:40pm</td>
						<td>Janet</td>
						<td class="text-navy"> <i class="fa fa-level-up"></i> 22% </td>
				</tr>
				<tr>
						<td><span class="label label-primary">Completed</span> </td>
						<td><i class="fa fa-clock-o"></i> 04:10am</td>
						<td>Amelia</td>
						<td class="text-navy"> <i class="fa fa-level-up"></i> 66% </td>
				</tr>
				<tr>
						<td><small>Pending...</small> </td>
						<td><i class="fa fa-clock-o"></i> 12:08am</td>
						<td>Damian</td>
						<td class="text-navy"> <i class="fa fa-level-up"></i> 23% </td>
				</tr>
				</tbody>
			</table>
		</div>		
			
		</div>	
	</div>
</div>
<!--Ventana para colocar el evento a manejar {start} -->
<div class="modal inmodal" id="myModal2" tabindex="-1" role="dialog" aria-hidden="true">
		<div class="modal-dialog">
				<div class="modal-content animated flipInY">
						<div class="modal-header">
								<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
								<i class="fa fa-clock-o modal-icon"></i>
								<h4 class="modal-title">Modal title</h4>
								<small class="font-bold">Lorem Ipsum is simply dummy text of the printing and typesetting industry.</small>
						</div>
						<div class="modal-body">
								<p><strong>Lorem Ipsum is simply dummy</strong> text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown
										printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting,
										remaining essentially unchanged.</p>
						</div>
						<div class="modal-footer">
								<button type="button" class="btn btn-white" data-dismiss="modal">Close</button>
								<button type="button" class="btn btn-primary">Save changes</button>
						</div>
				</div>
		</div>
</div>
	
<!--Ventana para colocar el evento a manejar {end} -->
<script language="javascript" type="text/javascript">

	
	$(document).ready(function() {
	
			/* initialize the calendar 	-----------------------------------------------------------------*/
			var date = new Date();
			var d = date.getDate();
			var m = date.getMonth();
			var y = date.getFullYear();

       $('#calendario').fullCalendar({
					header: {
							left: 'prev,next today',
							center: 'title',
							right: 'month,agendaWeek,agendaDay'
						  //'month,agendaWeek,basicWeek,agendaDay,basicDay'
					},
				 	lang: 'es',
					dayClick: function (date, jsEvent, view) {
						//alert("Day Clicked");myModal2
						/*alert("Fecha: " + date);
						alert("Evento: " + jsEvent);
						alert("view: " + view);*/
						$("#myModal2").modal("show");
					}
				 
				 
				 
				 
        });
	
		
	});
	
</script>
	
	