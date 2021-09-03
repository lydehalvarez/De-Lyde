<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
	
	var bDebug = false
	var Usu_ID = Parametro("IDUsuario",-1)
	 
	var sSQLEve = "SELECT Eve_ID, EveTip_ID, Eve_Titulo, Eve_Descripcion, Eve_FechaInicio, CONVERT(NVARCHAR(20),Eve_FechaInicio,103) AS FECHAINICIO, "
	 		sSQLEve += " Eve_HoraInicio, Eve_FechaFin, CONVERT(NVARCHAR(20),Eve_FechaFin,103) AS FECHAFIN, Eve_HoraFin, Eve_UsuarioAlta, "
	 		sSQLEve += " (SELECT ET.EveTip_Color FROM Evento_Tipo ET WHERE ET.EveTip_ID = Evento.EveTip_ID) AS COLORHEX, "
	 		sSQLEve += " (CAST(Eve_ID AS NVARCHAR(10)) + CAST(EveTip_ID AS NVARCHAR(10))) AS KEYUNICA "
	 		sSQLEve += " FROM Evento "
	 		sSQLEve += " WHERE Eve_UsuarioAlta = " + Usu_ID
	 		if(bDebug && Usu_ID == 20) { Response.Write(sSQLEve) }

	var sDefHexColor = "'#2f4050'" //Valor por default
	
	//var ArrHexColor = new Array(0)
	var sArrDefHexColor = ""
	
	var sSQLEveTipo = "SELECT EveTip_Color FROM Evento_Tipo "
	 
	var rsEvenTipo = AbreTabla(sSQLEveTipo,1,0) 
		 
		while (!rsEvenTipo.EOF){ 
	 
			if (sArrDefHexColor != "") { sArrDefHexColor += "," }
			sArrDefHexColor += "'" + rsEvenTipo.Fields.Item("EveTip_Color").Value + "'"
			rsEvenTipo.MoveNext() 
		}
		rsEvenTipo.Close()
	 
	 if(EsVacio(sArrDefHexColor)) {
	 		sArrDefHexColor = sDefHexColor
	 }

	//Response.Write(sArrDefHexColor) 
	 
	 
%>
	

<link href="/Template/inspina/css/plugins/fullcalendar/fullcalendar.css" rel="stylesheet">
<link href="/Template/inspina/css/plugins/fullcalendar/fullcalendar.print.css" rel='stylesheet' media='print'>

<link href="/Template/inspina/css/plugins/colorpicker/bootstrap-colorpicker.min.css" rel="stylesheet">
<link href="/Template/inspina/css/plugins/clockpicker/clockpicker.css" rel="stylesheet">

<!-- Mainly scripts -->
<script src="/Template/inspina/js/plugins/fullcalendar/moment.min.js"></script>
	
<!-- Full Calendar -->
<script src="/Template/inspina/js/plugins/fullcalendar/fullcalendar.min.js"></script>

<script src="/Template/inspina/js/plugins/i18next/es.js"></script>

<!-- Data picker -->
<script src="/Template/inspina/js/plugins/datapicker/bootstrap-datepicker.js"></script>
<link href="/Template/inspina/css/plugins/datapicker/datepicker3.css" rel="stylesheet">

<!-- Date range picker -->
<script src="/Template/inspina/js/plugins/daterangepicker/daterangepicker.js"></script>	
<link href="/Template/inspina/css/plugins/daterangepicker/daterangepicker-bs3.css" rel="stylesheet">

<script src="/Template/inspina/js/plugins/i18next/bootstrap-datepicker.es.min.js"></script>

<!-- Clock picker -->
<script src="/Template/inspina/js/plugins/clockpicker/clockpicker.js"></script>

	
<div class="row border-bottom white-bg dashboard-header">
	<div class="col-md-8" id="dvNotificaciones" style="display:none"></div>
    <div class="col-md-8" id="dvCalendario">


    <div class="ibox float-e-margins">
    <div class="ibox-title" style="border-style:none !important">
      <h2>Calendario de eventos&nbsp;&nbsp;<!--small class="m-l-sm"--><!--i class="fa fa-calendar-o"></i--><!--/small--></h2>
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
        </div>


    </div>
    <div class="col-md-4 white-bg " id="dvAvisos"></div>

</div>
<!--Ventana para colocar el evento a manejar {start} -->
<div class="modal inmodal cssWModal" id="myModal2" tabindex="-1" role="dialog" aria-hidden="true">
		<div class="modal-dialog">
				<div class="modal-content animated flipInY">
						<div class="modal-header">
								<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
								<i class="fa fa-clock-o modal-icon"></i>
								<h3 class="modal-title">Evento<input type="hidden" name="Eve_ID" id="Eve_ID" value="-1"></h3>
								<small class="font-bold">&nbsp;</small>
						</div>
						<div class="modal-body">
								<div class="form-horizontal" id="form">	
									<div class="form-group">
										<div class="col-md-12">
											<div class="row">
												<label class="col-md-offset-0 col-md-2 control-label">Tipo de evento</label>
												<div class="col-md-10"><%CargaCombo("EveTip_ID"," class='form-control input-sm' ","EveTip_ID","EveTip_Nombre","Evento_Tipo","","EveTip_Nombre",Parametro("EveTip_ID",-1),0,"Selecciona","Editar")%><!--span class="help-block m-b-none"><i class="fa fa-question-circle"></i>&nbsp;A block of help text that breaks onto a new line and may extend beyond one line.</span></div-->
												</div>
										  </div>
									  </div>
									</div>
									<div class="form-group">
										<div class="col-md-12">
											<div class="row">
												<label class="col-md-offset-0 col-md-2 control-label">T&iacute;tulo</label>
												<div class="col-md-10"><input type="text" placeholder="T&iacute;tulo" class="form-control input-sm" id="Eve_Titulo"><!--span class="help-block m-b-none"><i class="fa fa-question-circle"></i>&nbsp;A block of help text that breaks onto a new line and may extend beyond one line.</span></div-->
												</div>
										  </div>
									  </div>
									</div>
									<div class="form-group">
										<div class="col-md-12">
											<div class="row">
												<label class="col-md-offset-0 col-md-2 control-label">Descripci&oacute;n</label>
												<div class="col-md-10"><textarea class="form-control input-sm" id="Eve_Descripcion" rows="3" placeholder="Descripci&oacute;n del evento..."></textarea><!--span class="help-block m-b-none"><i class="fa fa-question-circle"></i>&nbsp;A block of help text that breaks onto a new line and may extend beyond one line.</span--></div>
											</div>
										</div>
									</div>
									<div class="form-group">
										<div class="col-md-12">
											<div class="row">
												<label class="col-md-offset-0 col-md-2 control-label">Comienza</label>
												<div class="col-md-4" id="data_1">
													<div class="input-group date">
														<span class="input-group-addon"><i class="fa fa-calendar"></i></span><input type="text" class="form-control input-sm" id="Eve_FechaInicio">
													</div>
												</div>
												<label class="control-label col-xs-3" id="lblEve_FechaInicio"><strong>Hora inicio</strong></label>
												<div class="col-xs-3">
														<div class="input-group clockpicker" data-autoclose="true">
																<input class="form-control input-sm cssHrInicio" id="Eve_HoraInicio" type="text" value="">
																<span class="input-group-addon"><span class="fa fa-clock-o"></span>
																</span>
														</div>
												</div>												
											</div>
									  </div>
								  </div>
									<div class="form-group">
										<div class="col-md-12">
											<div class="row">
												<label class="col-md-offset-0 col-md-2 control-label">Termina</label>
												<div class="col-md-4" id="data_2">
													<div class="input-group date">
														<span class="input-group-addon"><i class="fa fa-calendar"></i></span><input type="text" class="form-control input-sm" id="Eve_FechaFin">
													</div>
												</div>
												<label class="control-label col-xs-3" id="lblEve_HoraFin"><strong>Hora termina</strong></label>
												<div class="col-xs-3">
														<div class="input-group clockpicker" data-autoclose="true">
																<input class="form-control input-sm cssVolado" id="Eve_HoraFin" type="text" value="">
																<span class="input-group-addon"><span class="fa fa-clock-o"></span>
																</span>
														</div>
												</div>												
											</div>
									  </div>
								  </div>
									
							  </div>
						</div>
						<div class="modal-footer">
								<button type="button" class="btn btn-info dim" data-dismiss="modal">Cerrar</button>
								<button type="button" class="btn btn-primary dim btnGuardar">Guardar</button>
								<button type="button" class="btn btn-danger dim btnBorrar">Borrar</button>
						</div>
				</div>
		</div>
</div>
	
<!--Ventana para colocar el evento a manejar {end} -->
<script language="javascript" type="text/javascript">

    $(document).ready(function() {
    
 /* initialize the calendar
    ---------------------------------------*/
        var date = new Date();
        var d = date.getDate();
        var m = date.getMonth();
        var y = date.getFullYear();

       $('#calendario').fullCalendar({
					header: {
							left: 'prev,next today',
							center: 'title',
							right: 'month,agendaWeek,agendaDay,listWeek'
						  //'month,agendaWeek,basicWeek,agendaDay,basicDay'
					},
				 	lang: 'es',
				 	//dayClick: function(start, end) {
						//alert(start);	//alert(date.getDate());  //LevantaEvento("dayClick " + start);
						//alert();	//alert(formatDate(start,'DD/MM/YYYY')
					//},
				  /*eventRender: function(event, element) {
						
							var el = element.html();
						
							element.html("<div style='width:90%;float:left;'>"+el+"</div><div style='text-align:right;'><button aria-hidden='true' data-dismiss='alert' class='close' type='button'>×</button></div>");
							
							element.find(".close").click(function(){
									alert(event.id + " - " + event.evetipid);
							});
						
					},*/
				 	weekNumbers: true, 
				  editable: true, //Drag and drop
					eventDrop: function(event, delta, revertFunc) {
							/*
							console.log("eveid - " + event.id + " - evetipid - " + event.evetipid + " - title - " + event.title + " - description - " + event.description + " - fechainicio - " + event.fechainicio + " - horainicio - " + event.horainicio + " - fechafin - " + event.fechafin + " - horafin - " + event.horafin);
							
							console.log(" fecha nueva inicio " + event.start + " fecha nueva inicio [formato] " + event.start.format() + " -DD/MM/YYYY- " + moment(event.start).format('DD/MM/YYYY') + " -HH- " + moment(event.start).format('HH') + " -mm- " + moment(event.start).format('mm'));
							
							console.log(" fecha termino fin " + event.end + " fecha termino fin [formato] " + event.end.format() + " -DD/MM/YYYY- " + moment(event.end).format('DD/MM/YYYY') + " -HH- " + moment(event.end).format('HH') + " -mm- " + moment(event.end).format('mm'));
							
							var iMes = parseInt(moment().month(event.startDate)) + 1;
							console.log("moment().getUTCDate() " + moment().getUTCDate(event.startDate) + " moment().month() " + iMes + " moment().year() " + moment().year(event.startDate));
							
							console.log(" fecha nueva " + moment(event.start).format('DD/MM/YYYY') + " Horas Minutos " +  moment(event.start).format('hh:mm'));
							
							console.log(" DD " + moment(event.start).format('DD') + " MM " + moment(event.start).format('MM') + " YYYY " + moment(event.start).format('YYYY'));
							
							console.log(" hh " + moment(event.start).format('hh') + " mm " + moment(event.start).format('mm'));
							*/
							//console.log("eveid - " + event.id + " - evetipid - " + event.evetipid + " - title - " + event.title + " - description - " + event.description + " - fechainicio - " + moment(event.start).format('DD/MM/YYYY') + " - horainicio - " + moment(event.start).format('HH') + ":" + moment(event.start).format('mm') + " - fechafin - " + moment(event.end).format('DD/MM/YYYY') + " - horafin - " + moment(event.end).format('HH') + ":" + moment(event.end).format('mm'));
							//var iTarea = 2;
							//GuardarEditarEvento(Eve_ID,EveTip_ID,Eve_Titulo,Eve_Descripcion,Eve_FechaInicio,Eve_HoraInicio,Eve_FechaFin,Eve_HoraFin);
							GuardarEditarEvento(event.eveid,event.evetipid,event.title,event.description,moment(event.start).format('DD/MM/YYYY'),moment(event.start).format('HH') + ":" + moment(event.start).format('mm'),moment(event.end).format('DD/MM/YYYY'),moment(event.end).format('HH') + ":" + moment(event.end).format('mm'),$("#IDUsuario").val(),true);
							/*if (!confirm("Are you sure about this change?")) {
								revertFunc();
							}*/
					},
				  droppable: true,
				 	/*drop: function(date){ alert("dropped" + date.format()); },*/
				  selectable: true,
				  eventRender: function(event, element) {
							/*
							var el = element.html();
							element.html("<div style='width:90%;float:left;'>"+el+"</div><div style='text-align:right;'><i class='fa fa-times cssclose'></i></div>");
							element.find(".cssclose").click(function(){
									alert(event.id + " - " + event.evetipid);
							});						
							*/	
							//element.attr('class','tooltip-demo');	//element.attr('data-toggle','tooltip');	//element.attr('data-placement','top');
							element.attr('title',event.description);
							element.addClass('cssSeleccEveID');
							element.attr('data-eveid',event.eveid);
							element.attr('data-evetipid',event.evetipid);
							//element.attr('data-idunica',event.id+event.evetipid);
							element.attr('data-title',event.title);
							element.attr('data-descripcion',event.description);
							element.attr('data-fechainicio',event.fechainicio);
							element.attr('data-horainicio',event.horainicio);
							element.attr('data-fechafin',event.fechafin);
							element.attr('data-horafin',event.horafin);						
						
        	},
				 	selectHelper: true,
					select: function(startDate,endDate) {
							/* alert('selected ' + startDate + ' to ' + endDate);	alert(ui);	alert(startDate);	alert(endDate);	alert(startDate.format());
							alert(endDate.format());	alert(startDate.format(startDate,"YYYY-MM-DD[T]HH:mm:ss"));	alert(endDate.format(endDate,"YYYY-MM-DD[T]HH:mm:ss"));
							alert(startDate.format(startDate,"YYYY-MM-DD"));	alert(startDate.format(endDate,"YYYY-MM-DD"));  alert(startDate.getDay());	alert(startDate);*/
							//var sFechaInicio = 'selected:' + startDate; //alert(sFechaInicio); //var sFechaFin = 'to:' + endDate;	//alert(sFechaFin);						
							//alert(event.id);	//alert(startDate);	//var dateI = new Date(startDate);
							//alert('selected ' + startDate.format(startDate,"DD-MM-YYYY") + ' to ' + endDate.format(endDate,"DD-MM-YYYY"));
							//alert('selected ' + startDate.format(startDate,"YYYY-MM-DD[T]HH:mm:ss") + ' to ' + endDate.format(endDate,"YYYY-MM-DD[T]HH:mm:ss"));
							//alert(ui);	//alert(title);
							//$('#calendario').fullCalendar('refetchEvents');
							/*var title = prompt('Event Title:');*/
							//alert('selected:' + startDate + 'to:' + endDate);
							LevantaEventoNvo('selected:' + startDate,'to:' + endDate);
					},
				 	//eventLimit: true, // allow "more" link when too many events
				 	businessHours: true, // display business hours
				 	events: [
						
						<% 
							var rsEventos = AbreTabla(sSQLEve,1,0) 
								while (!rsEventos.EOF){ 
								//var sLlaveUnica = "'" + rsEventos.Fields.Item("Eve_ID").Value + rsEventos.Fields.Item("EveTip_ID").Value + "'" alert(sLlaveUnica);
						%>
						{
						
								id: '<%=rsEventos.Fields.Item("KEYUNICA").Value%>', //id para el objeto fullcalendar
								eveid: '<%=rsEventos.Fields.Item("Eve_ID").Value%>', // Evento
								evetipid: '<%=rsEventos.Fields.Item("EveTip_ID").Value%>',	//Tipo de evento
								title: '<%=rsEventos.Fields.Item("Eve_Titulo").Value%>',	//Título del evento 
								description: '<%=rsEventos.Fields.Item("Eve_Descripcion").Value%>',
								tooltip: '<%=rsEventos.Fields.Item("Eve_Descripcion").Value%>',
								start: '<%=rsEventos.Fields.Item("Eve_FechaInicio").Value%>T<%=rsEventos.Fields.Item("Eve_HoraInicio").Value%>', //Fecha de inicio
								end: '<%=rsEventos.Fields.Item("Eve_FechaFin").Value%>T<%=rsEventos.Fields.Item("Eve_HoraFin").Value%>', //Fecha de termino
							  color: '<%=rsEventos.Fields.Item("COLORHEX").Value%>', //Color
								allDay: false,
							  url: '#', //http://www.google.com/
								fechainicio: '<%=rsEventos.Fields.Item("FECHAINICIO").Value%>',	//Fecha de inicio
								horainicio:	'<%=rsEventos.Fields.Item("Eve_HoraInicio").Value%>',	//Hora de inicio
								fechafin:	'<%=rsEventos.Fields.Item("FECHAFIN").Value%>',	//Fecha de termino
								horafin:	'<%=rsEventos.Fields.Item("Eve_HoraFin").Value%>'	//Hora de termino						
						},
						
						<%
							rsEventos.MoveNext() 
							}
							rsEventos.Close()   
						%>  
					]
				 
        });

			  function LevantaEventoNvo(jsfechaHrInicio, jsfechaHrFin) {
					
						//======== - manejo de la fecha de inicio - {start}
						var sFechIni = jsfechaHrInicio.toString();
						//alert(sFechIni);
						var txtTmpIni = sFechIni.substring(sFechIni.indexOf(":")+1);
						//alert(txtTmpIni);
						var iFecIni = parseInt(txtTmpIni);
						var objFechaInicio = new Date(iFecIni);

						var iDiaIni = objFechaInicio.getUTCDate();
						var iMesIni = objFechaInicio.getUTCMonth()+1;
						var iAnoIni = objFechaInicio.getUTCFullYear();
						
						//Agregar cero 0 a la izquierda
						var sDiaIniTmp = iDiaIni.toString();
						if (parseInt(sDiaIniTmp.length) == 1) { sDiaIniTmp = "0"+sDiaIniTmp }
						//alert(sDiaIniTmp);
						
						//Agregar cero 0 a la izquierda
						var sMesIniTmp = iMesIni.toString();
						if (parseInt(sMesIniTmp.length) == 1) { sMesIniTmp = "0"+sMesIniTmp }					
					
						var sJQFechaIni = sDiaIniTmp + "/" + sMesIniTmp + "/" + iAnoIni;
						
						var iHrIni = objFechaInicio.getUTCHours();
						var iMinIni = objFechaInicio.getUTCMinutes();
						var iSecIni = objFechaInicio.getUTCSeconds();
					
						//Agregar cero 0 a la izquierda
						var sHrTmp = iHrIni.toString();
						if (parseInt(sHrTmp.length) == 1) { sHrTmp = "0"+sHrTmp }					
						
						//Agregar cero 0 a la izquierda
						var sMinTmp = iMinIni.toString();
						if (parseInt(sMinTmp.length) == 1) { sMinTmp = "0"+sMinTmp }	
					
						var sJQHoraIni = sHrTmp + ":" + sMinTmp; //+ ":" + iSecIni;

						//alert(iDiaIni + "/" + iMesIni + "/" + iAnoIni);
						//alert(iHrIni+ ":" + iMinIni + ":" + iSecIni);
						//======== - manejo de la fecha de inicio - {end}
						//======== - manejo de la fecha de fin - {start}
						var sFechFin = jsfechaHrFin.toString();
						//alert(sFechFin);
						var txtTmpFin = sFechFin.substring(sFechFin.indexOf(":")+1);
						//alert(txtTmpFin);
						var iFecFin = parseInt(txtTmpFin);
						var objFechaFin = new Date(iFecFin);
						var iDiaFin = objFechaFin.getUTCDate();
						var iMesFin = objFechaFin.getUTCMonth()+1;
						var iAnoFin = objFechaFin.getUTCFullYear();
					
							//Agregar cero 0 a la izquierda
						var sDiaFinTmp = iDiaFin.toString();
						if (parseInt(sDiaFinTmp.length) == 1) { sDiaFinTmp = "0"+sDiaFinTmp }
						//alert(sDiaFinTmp);
						
						//Agregar cero 0 a la izquierda
						var sMesFinTmp = iMesFin.toString();
						if (parseInt(sMesFinTmp.length) == 1) { sMesFinTmp = "0"+sMesFinTmp }						
					
						var sJQFechaFin = sDiaFinTmp + "/" + sMesFinTmp + "/" + iAnoFin;

						var iHrFin = objFechaFin.getUTCHours();
						var iMinFin = objFechaFin.getUTCMinutes();
						var iSecFin = objFechaFin.getUTCSeconds();

						//Agregar cero 0 a la izquierda
						var sHrFinTmp = iHrFin.toString();
						if (parseInt(sHrFinTmp.length) == 1) { sHrFinTmp = "0"+sHrFinTmp }					
						
						//Agregar cero 0 a la izquierda
						var sMinFinTmp = iMinFin.toString();
						if (parseInt(sMinFinTmp.length) == 1) { sMinFinTmp = "0"+sMinFinTmp }	
						
						var sJQHoraFin = sHrFinTmp + ":" + sMinFinTmp; //+ ":" + iSecFin;

						//alert(iDiaFin + "/" + iMesFin + "/" + iAnoFin);
						//alert(iHrFin+ ":" + iMinFin + ":" + iSecFin);

						//var dia = sfecha.getDate();
						//alert(sfecha);
						$("#myModal2").modal("show");
						$("#Eve_ID").val(-1);
						$("#EveTip_ID").val(-1);
						$("#EveTip_ID").focus();
						$("#Eve_Titulo").val("");
						$("#Eve_Descripcion").val("");
						$("#Eve_FechaInicio").val(sJQFechaIni);
						$("#Eve_HoraInicio").val(sJQHoraIni);
						$("#Eve_FechaFin").val(sJQFechaFin);
						$("#Eve_HoraFin").val(sJQHoraFin);					
					
				}	
			
				$('#data_1 .input-group.date').datepicker({
					format: "dd/mm/yyyy",
					todayBtn: "linked",
					language: "es",
					todayHighlight: true,
					autoclose: true
				});

				$('#Eve_HoraInicio').clockpicker({
					placement: 'top',
    			align: 'left',
					autoclose: true
				});
			
				$('#data_2 .input-group.date').datepicker({
					format: "dd/mm/yyyy",
					todayBtn: "linked",
					language: "es",
					todayHighlight: true,
					autoclose: true
				});
			
				$('#Eve_HoraFin').clockpicker({
					placement: 'top',
					align: 'left',					
					autoclose: true
				});

				$(".btnGuardar").click(function() {
					
						var Eve_ID = $("#Eve_ID").val();
						var EveTip_ID = $("#EveTip_ID").val();
						var Eve_Titulo = $("#Eve_Titulo").val();
						var Eve_Descripcion = $("#Eve_Descripcion").val(); 
						var Eve_FechaInicio = $("#Eve_FechaInicio").val(); 
						var Eve_HoraInicio = $("#Eve_HoraInicio").val();  
						var Eve_FechaFin = $("#Eve_FechaFin").val(); 
						var Eve_HoraFin = $("#Eve_HoraFin").val();
						//console.log("Eve_ID " + $("#Eve_ID").val() + " Eve_FechaInicio " + $("#Eve_FechaInicio").val());
						//if (ValidaParaGuardar()) {
							GuardarEditarEvento(Eve_ID,EveTip_ID,Eve_Titulo,Eve_Descripcion,Eve_FechaInicio,Eve_HoraInicio,Eve_FechaFin,Eve_HoraFin,$("#IDUsuario").val(),false);
						//}
						
				});

				$(".btnBorrar").click(function() {
				
						var ijqEve_ID = $("#Eve_ID").val();
						var ijqEveTip_ID = $("#EveTip_ID").val();						
						var iTarea = 3;

						var sMensaje = "";
						var sTitulo = "Aviso";	
						var sTipo = "success";				
					
						var sDatos = "Tarea=" + iTarea;
								sDatos += "&Eve_ID=" + ijqEve_ID + "&EveTip_ID=" + ijqEveTip_ID;
					
						var sLlaveUnica = "" + ijqEve_ID.toString() + ijqEveTip_ID.toString() + "";
						//alert(sLlaveUnica);
						var eventsDatas;
					
						$.ajax({
								url: "/pz/agt/Home/Evento_Ajax.asp?"+sDatos,
								//data: data,
								//cache: false,
								contentType: 'multipart/form-data',
								//processData: false,
								type:"POST",
								//dataType: 'json',
								success: function(data) {
										 //alert(data);
											var sNomArch = ""
											var sTmp = String(data); 
													arrDatos = sTmp.split("|");
											//alert(arrDatos[0] + " - " + arrDatos[1]);
											eventsDatas = {
												
													id: "" + sLlaveUnica + "",
													eveid: "" + arrDatos[0] + "", //??
													evetipid: "" + arrDatos[1] + "",	//Tipo de evento
													
											}
											//alert("eventsDatas.idunica - " + eventsDatas.id);
											$('#calendario').fullCalendar('removeEvents',eventsDatas.id);

											sMensaje = "El registro fue eliminado correctamente";
											sTipo = "success";

											CerrarModal();
								},  
								error: function(XMLHttpRequest, textStatus, errorThrown) {

											sMensaje = "Ocurrio un error al guardar el registro";
											sTipo = "error";
									
								}
							
						});

						Avisa(sTipo,sTitulo,sMensaje);					
			
				});
			
			
				function GuardarEditarEvento(ijqEveID,ijqEveTipID,sjqEveTitulo,sjqEveDescripcion,sjqEveFechaInicio,sjqEveHoraInicio,sjqEveFechaFin,sjqEveHoraFin,iUsuAlta,bjqArrastre) {
					
						var bArrastre = bjqArrastre;
						var iEveID = ijqEveID;
						var sAccion = "New";
						var iTarea = 1;
						if(iEveID > -1) {
								sAccion = "Edit";
								iTarea = 2;
						}
					
						var sMensaje = "";
						var sTitulo = "Aviso";	
						var sTipo = "success";
					
						var sDatos = "Tarea=" + iTarea;
								sDatos += "&Eve_ID=" + iEveID + "&EveTip_ID=" + ijqEveTipID + "&Eve_Titulo=" + encodeURIComponent(sjqEveTitulo);
								sDatos += "&Eve_Descripcion=" + encodeURIComponent(sjqEveDescripcion) + "&Eve_FechaInicio=" + sjqEveFechaInicio;
								sDatos += "&Eve_HoraInicio=" + sjqEveHoraInicio + "&Eve_FechaFin=" + sjqEveFechaFin;
								sDatos += "&Eve_HoraFin=" + sjqEveHoraFin + "&Eve_UsuarioAlta=" + iUsuAlta;
								//alert(sDatos);
						/* Esto se hace porque debemos de manejar para el fullcalendar las fechas con el formato YYYY-MM-DD */	
						var sFechaIniForm = sjqEveFechaInicio;
								sFechaIniForm = sFechaIniForm.split('/');
								sFechaIniForm = sFechaIniForm[2]+'-'+sFechaIniForm[1]+'-'+sFechaIniForm[0];	
						/*
						fechaI=fechaI.split('/');
						fechaI=fechaI[1]+'/'+fechaI[0]+'/'+fechaI[2];
						*/
						//alert(sFechaIniForm);
						var sFechaFinForm = sjqEveFechaFin;
								sFechaFinForm = sFechaFinForm.split('/');
								sFechaFinForm = sFechaFinForm[2]+'-'+sFechaFinForm[1]+'-'+sFechaFinForm[0];
						//alert(sFechaFinForm);
						//var sASPaJS = toString();
						var ArrColorHEXA = new Array(<%=sArrDefHexColor%>);
								//ArrColorHEXA = "[<%=sArrDefHexColor%>]";
								/*var i;
								for(i = 0; i < ArrColorHEXA.length ; i++) { // listando los elementos del array
									console.log('En la posición: ' + i + ' esta el elemento: ' +  ArrColorHEXA[i]);
								}*/
						//alert(sAccion);
						var events;
						$.ajax({
							url: "/pz/agt/Home/Evento_Ajax.asp?"+sDatos,
							//data: data,
							//cache: false,
							contentType: 'multipart/form-data',
							//processData: false,
							type:"POST",
							//dataType: 'json',
							success: function(data) {
									 //alert(data);
										var sNomArch = ""
										var sTmp = String(data); 
												arrDatos = sTmp.split("|");
											//alert(ijqEveTipID);
										var i = ijqEveTipID;		
										var sColorSelec = ArrColorHEXA[i];
										var sLlaveUnica = "" + arrDatos[0].toString() + arrDatos[1].toString() + "";
										//alert(sLlaveUnica);
										var sTitle = "" + $("#Eve_Titulo").val() + ""; 
												if(bArrastre) { 
														sTitle = "" + sjqEveTitulo + ""; 
												} 
										var sDescrip = "" + $("#Eve_Descripcion").val() + ""; 
												if(bArrastre) { 
														sDescrip = "" + sjqEveDescripcion + ""; 
												} 
							
							
										events = {
												id: "" + sLlaveUnica + "",	//id llave única para el fullcalendar
												eveid: "" + arrDatos[0] + "", //Evento
												evetipid: "" + arrDatos[1] + "",	//Tipo de evento
												title: sTitle,	//Título del evento;
												description: "" + sDescrip + "",
												tooltip: "" + sDescrip + "",
												//start: "'" + sjqEveFechaInicio + "'", //Fecha de inicio
												//end: "'" + sjqEveFechaFin + "'", //Fecha de termino
												start: "" + sFechaIniForm + "T" + sjqEveHoraInicio, //Fecha de inicio
												end: "" + sFechaFinForm + "T" + sjqEveHoraFin, //Fecha de termino
												color: "" + sColorSelec + "", //Color
												//backgroundColor: "'" + sColorSelec + "'",
												//color: "'#FF5733'",
												allDay: false,
												url: '#', //http://www.google.com/
												fechainicio: "" + sjqEveFechaInicio + "",	//Fecha de inicio
												horainicio:	"" + sjqEveHoraInicio + "",	//Hora de inicio
												fechafin:	"" + sjqEveFechaFin + "",	//Fecha de termino
												horafin: "" + sjqEveHoraFin + ""	//Hora de termino												
										};
							
										if(sAccion == "New") {
											//alert(sAccion);
											$('#calendario').fullCalendar('renderEvent', events, true);
										}
							
										if(sAccion == "Edit") {
											//alert(sAccion);
											//$('#calendario').fullCalendar('updateEvent', events, true);
											//$('#calendar').fullCalendar('updateEvent', event);
											//$('#calendario').fullCalendar('updateEvent', events, true);
											$('#calendario').fullCalendar('removeEvents',events.id);
											$('#calendario').fullCalendar('renderEvent',events,true);
											//$('#calendario').fullCalendar('events', events, true);
										}
							
										$('#calendario').fullCalendar('refetchEvents', true);
										$('#calendario').fullCalendar('refresh', true);
							
										//var event={id:1 , title: 'New event', start:  new Date()};
										//$('#calendar').fullCalendar( 'renderEvent', event, true);
										//$('#calendar').fullCalendar('updateEvent', event);
										/*$('#calendario').fullCalendar( 'renderEvent', eventsData , 'stick');
										$('#calendario').fullCalendar('addEventSource', eventsData);*/
										
										//$('#calendario').fullCalendar('unselect');
										sMensaje = "El registro fue guardado correctamente";
										sTipo = "success";

										CerrarModal();
							},  
							error: function(XMLHttpRequest, textStatus, errorThrown) {
								/*if(XMLHttpRequest.readyState == 0 || XMLHttpRequest.status == 0) {
									alert(" it's not really an error");
								} else {
									if (XMLHttpRequest.status == 500) {
										alert("Error HTTP 500 Internal server error (Error interno del servidor)");
									} else {
										alert(textStatus);
										alert("Error " + errorThrown);
									}
								}*/
										sMensaje = "Ocurrio un error al guardar el registro";
										sTipo = "error";
							}	
					});

					Avisa(sTipo,sTitulo,sMensaje);
			
					$('#calendario').fullCalendar('unselect');
						return true;

				}

				function PintarEvento(ifCEveID,ifCEveTipID,sfCEveTitulo,sfCEveDescripcion,sfCEveFechaInicio,sfCEveHoraInicio,sfCEveFechaFin,sfCEveHoraFin) {
								
						//console.log("Pintamos el Evento!!");
						$('#calendario').fullCalendar('renderEvent', {
							
							idunica: "" + ifCEveID + ifCEveTipID + "",
							eveid: "'" + ifCEveID + "'", //??
							evetipid: "'" + ifCEveTipID + "'",	//Tipo de evento
							title: "" + sfCEveTitulo + "",	//Título del evento 
							description: "" + sfCEveDescripcion + "",	//Descripción del evento
							tooltip: "" + sfCEveDescripcion + "",
							start: "'" + sfCEveFechaInicio + "'", //Fecha de inicio
							end: "'" + sfCEveFechaFin + "'", //Fecha de termino
							color: "'" + sfCEveHoraFin + "'", //Color
							allDay: false,
							//url: '#', //http://www.google.com/
							fechainicio: '01/06/2018',	//Fecha de inicio
							horainicio:	'00:00',	//Hora de inicio
							fechafin:	'02/06/2018',	//Fecha de termino
							horafin:	'00:00'	//Hora de termino
							
            }, 'stick');
					
						//$('#calendario').fullCalendar('refetchEvents');
					
						//$('#calendario').fullCalendar('unselect');
					
						/*
						var events;
					
								events = {
					
									id: "'" + ifCEveID + "'", //??
									evetipid: "'" + ifCEveTipID + "'",	//Tipo de evento
									title: "'" + sfCEveTitulo + "'",	//Título del evento 
									description: "'" + sfCEveDescripcion + "'",
									tooltip: "'" + sfCEveDescripcion + "'",
									start: "'" + sfCEveFechaInicio + "'", //Fecha de inicio
									end: "'" + sfCEveFechaFin + "'", //Fecha de termino
									color: "'" + sfCEveHoraFin + "'", //Color
									allDay: false,
									url: '#' //http://www.google.com/					
									
								}
								//$calendar.fullCalendar("renderEvent", events, true);
								//$calendar.fullCalendar("unselect");
								$('#calendario').fullCalendar('renderEvent', events, true);
								$('#calendario').fullCalendar('addEventSource', events);
								$('#calendario').fullCalendar('refetchEvents', events);
								//$('#calendario').fullCalendar("unselect", events);
								*/
				}
			
				$("#frmDatos").on("click", ".cssSeleccEveID", function(e){
				//$(".cssSeleccEveID").unbind("click").click(function(e) {
						e.preventDefault();			
						var Obj = $(this);
						//alert(Obj.data("eveid"));
					  //alert("Eve_ID " + Obj.data("eveid") + " EveTip_ID " + Obj.data("evetipid"));
						$("#myModal2").modal("show");
						$("#Eve_ID").val(Obj.data("eveid"));
						$("#EveTip_ID").val(Obj.data("evetipid"));
						$("#Eve_Titulo").val(Obj.data("title"));
						$("#Eve_Descripcion").val(Obj.data("descripcion"));
						$("#Eve_FechaInicio").val(Obj.data("fechainicio"));
						$("#Eve_HoraInicio").val(Obj.data("horainicio"));
						$("#Eve_FechaFin").val(Obj.data("fechafin"));
						$("#Eve_HoraFin").val(Obj.data("horafin"));						
						
				});
			
				function CerrarModal() {
					$('#myModal2').modal('hide');
				}      	

			
			
				$("#dvAvisos").load("/pz/agt/Inicio/Avisos.asp?Usu_ID=" + $("#IDUsuario").val() )
	    
 });

</script>