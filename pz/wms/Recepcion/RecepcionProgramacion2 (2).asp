<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->

<%

var TA_ID = Parametro("TA_ID",-1)
var OC_ID = Parametro("OC_ID",1)
var Prov_ID = Parametro("Prov_ID",-1)


	var sSQLSer = "SELECT  * "
		sSQLSer += "FROM Inventario_Recepcion "
		
		bHayParametros = false
		ParametroCargaDeSQL(sSQLSer,0)
		
			var sSQLRec = "SELECT COUNT(IR_ID) as Citas "
		sSQLRec += ", CONVERT(VARCHAR(17), getdate(), 103) AS Hoy "
		sSQLRec += ", CONVERT(VARCHAR(17), getdate()+1, 103) AS Maniana "
		sSQLRec += "FROM Inventario_Recepcion "
		sSQLRec += " WHERE IR_EstatusCG62 = 1 "
		
	var rsRec = AbreTabla(sSQLRec,1,0)

	var NumCitas = 0
	if(!rsRec.EOF){
		var Hoy = rsRec.Fields.Item("Hoy").Value
		var Maniana = rsRec.Fields.Item("Maniana").Value
		NumCitas = rsRec.Fields.Item("Citas").Value
	}	
%>
<link href="/Template/inspina/css/plugins/clockpicker/clockpicker.css" rel="stylesheet">
<link href="/Template/inspina/css/plugins/datapicker/datepicker3.css" rel="stylesheet">
<link href="/Template/inspina/css/plugins/fullcalendar/fullcalendar.css" rel="stylesheet">
<link href="/Template/inspina/css/plugins/iCheck/green.css" rel="stylesheet">

<div class="wrapper wrapper-content" id="frmDatos">

    <div class="row animated fadeInDown">
        <div class="col-lg-3">
            <div class="ibox float-e-margins">
                <div class="ibox-title">
                           <span class="pull-right"> <a  class="text-muted btnImprimeRecep"><i class="fa fa-print"></i>&nbsp;<strong>Imprimir entregas de hoy</strong></a>&nbsp;|&nbsp;(<strong><%=NumCitas%></strong>) Citas</span>
                </div>
                <div class="ibox-content">
                    <div id='external-events'>
                        <p>Citas
                        
                        </p>
                        <p>&nbsp;</p>
                        <div class='external-event navy-bg' id="Folio">Folio: TA0001</div>
                           <div class='external-event navy-bg' id="Cita">Cita: 9:00 a.m.</div>
                    </div>
                    
                   
                    
              </div>
            </div>
        </div>

        <div class="col-lg-9">
            <div class="ibox float-e-margins" id="dvCita">
                <div class="ibox-title">
                    <h5>Calendario</h5>
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

<div class="modal inmodal fade in" tabindex="-1" id="MyBatmanModal" role="dialog">
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content">
      <div class="modal-header bg-success">
        <div class="col-md-3">
            <h5 class="modal-title" style="color:#FFF">Asignar cita</h5>
        </div>
        <div class="col-md-9">
            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><i style="color:#FFF" class="fa fa-times"></i></button>
        </div>
      </div>
      <div class="modal-body">
        <div class="form-horizontal">
         
             <%
			 if(TA_ID > -1){
			var selecciona = "Transferencia"
			var ProvCli = "Cliente"
			var ssql = "SELECT * FROM TransferenciaAlmacen t" 
		     ssql += " INNER JOIN Cliente c ON c.Cli_ID=t.Cli_ID where TA_ID=" + TA_ID
			
			var rsCliente = AbreTabla(ssql,1,0)
			var Cli_ID = rsCliente.Fields.Item("Cli_ID").Value
			 var Cliente = rsCliente.Fields.Item("Cli_Nombre").Value
              var IR_Folio =  rsCliente.Fields.Item("TA_Folio").Value
		
				}else {
					var selecciona = "Orden de Compra"
					var  ProvCli = "Cliente"
		var ssql = "SELECT * FROM Cliente_OrdenCompra o"
		     ssql += " INNER JOIN Cliente c ON c.Cli_ID=o.Cli_ID where CliOC_ID=" + OC_ID
			
			var rsCliente = AbreTabla(ssql,1,0)
			var Cli_ID = rsCliente.Fields.Item("Cli_ID").Value
			 var Cliente = rsCliente.Fields.Item("Cli_Nombre").Value
             var IR_Folio =  rsCliente.Fields.Item("CliOC_Folio").Value

				}
				
			 ssql = "SELECT * FROM Almacen "
		     ssql += "  where Cli_ID=" + Cli_ID+" AND Alm_TipoCG84 =1"
			 var rsAlm = AbreTabla(ssql,1,0)
							 %>
             <div class="form-group">
                <label class="control-label col-md-3"><strong><%=selecciona%></strong></label>
                    <div class="col-md-3">
             
						   	  <label  class= "control-label col-md-3" ><strong><%=IR_Folio%></strong></label>
                               <input type="text" value="<%=OC_ID%>" class="objAco"  id="OC_ID">
                                <input type="text" value="<%=TA_ID%>" class="objAco"  id="TA_ID">
                               <input type="text" value="<%=Cli_ID%>" class="objAco"  id="Cli_ID">
                               <input type="text" value="<%=IR_Folio%>" class="objAco"  id="IR_Folio">
                    </div>
                <label class="control-label col-md-3"><strong><%=ProvCli%></strong></label>
                    <div class="col-md-3">
                <label class="control-label col-md-3"  value="<%=Cli_ID%>" id="Cli_ID"><strong><%=Cliente%></strong></label>
            </div>
            </div>
                 <div class="form-group">
               <label class="control-label col-md-3" ><strong>Nombre operador</strong></label>
                <div class="col-md-3">
                   <input class="form-control agenda" id="IR_Conductor" placeholder="Nombre completo" type="text" autocomplete="off" value=""/> 
               </div>
               <label class="control-label col-md-3"><strong>Placas del veh&iacute;culo</strong></label>
               <div class="col-md-3">
                   <input class="form-control agenda" id="IR_Placas" placeholder="Placas" type="text" autocomplete="off" value=""/> 
               </div>
               
            </div>
             <div class="form-group">
               <label class="control-label col-md-3"><strong>Tipo del veh&iacute;culo</strong></label>
                <div class="col-md-3">
                
						   <input class="form-control agenda" id="IR_DescripcionVehiculo" placeholder="Descripci&oacute;n de veh&iacute;culo" type="text" autocomplete="off" value=""></input>
				</div>
                      <label class="control-label col-md-3"><strong>Color</strong></label>
                <div class="col-md-3">
				<select id="IR_Color" class="form-control agenda">
                  <option value="Azul">Azul</option>
                  <option value="Rojo">Rojo</option>
                  <option value="Verde">Verde</option>
                  <option value="Morado">Morado</option>
                </select>
            </div>
            </div>
             <div class="form-group">
               <label class="control-label col-md-3"><strong>Almac&eacute;n</strong></label>
                <div class="col-md-3">
                	<select id="Alm_ID" class="form-control agenda">
                    <%
					 while (!rsAlm.EOF){
						 %>
                  <option value="<%=Alm_ID%>"><%=Alm_Nombre%></option>
				    <%	
				rsAlm.MoveNext() 
					}
                rsAlm.Close()  
		 
                %>
                  </select>
                </div>
                  <label class="control-label col-md-3"><strong>Puerta</strong></label>
                    <div class="col-md-3">
                    	<select id="IR_Puerta" class="form-control agenda">
				  <option value="18 - Basura">18 - Basura</option>
                  <option value="19 - Basura">19 - Basura</option>
                  <option value="20 - No activa">20 - No activa</option>
                  <option value="21 - Devolucion">21 - Devolucion</option>
                  <option value="22 - Activa">22 - Activa</option>
                  <option value="23 - Activa">23 - Activa</option>
                  <option value="24 - Activa">24 - Activa</option>
                     <option value="25 - No Activa">25 - No Activa</option>
						</select>
            </div>
           </div>
                    <div class="form-group">
               <label class="control-label col-md-3"><strong>D&iacute;a inicio</strong></label>
               <div class="col-md-3">
                    <div class="input-group date">
                        <input class="form-control date-picker Fecha Robin agenda"
                        id="IR_FechaEntrega" placeholder="dd/mm/aaaa" type="text" autocomplete="off"
                        value="" data-esfecha="1"> 
                        <span class="input-group-addon"><i class="fa fa-calendar"></i></span>
                    </div>
                </div>
               <label class="control-label col-md-3"><strong>Hora inicio</strong></label>
                        <div class="col-md-3">
                            <div class="input-group clockpicker" data-autoclose="true">
                                <input class="form-control Hora Robin agenda" id="IR_Horario" type="text" autocomplete="off" placeholder="Abrir reloj"
                                value="">
                                <span class="input-group-addon"><span class="fa fa-clock-o"></span></span>
                            </div>
                        </div>
            </div>
				
        </div>   
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-primary" id="BtnAgendar">Agendar</button>
        <button type="button" class="btn btn-danger" id="BtnQuitar">Limpiar</button>
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cerrar</button>
      </div>
      
      
      </div>
    </div>
  </div>
</div>

<div class="modal inmodal fade in" tabindex="-1" id="FormDatosGen" role="dialog">
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content">
      <div class="modal-header bg-success">
        <div class="col-md-3">
            <h5 class="modal-title" style="color:#FFF">Datos generales</h5>
        </div>
        <div class="col-md-9">
            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><i style="color:#FFF" class="fa fa-times"></i></button>
        </div>
      </div>
      <div class="modal-body">
        <div class="form-horizontal">
             <div class="form-group">
                <label class="control-label col-md-3"><strong>Proveedor o cliente</strong></label>
                    <div class="col-md-3">
                <label class="control-label col-md-3"><strong></strong></label>
            </div>
                <label class="control-label col-md-3"><strong> Productos </strong></label>
                    <div class="col-md-3">
                <label class="control-label col-md-3"><strong> </strong></label>
            </div>
              <label class="control-label col-md-3"><strong>Destino </strong></label>
                    <div class="col-md-3">
                <label class="control-label col-md-3"><strong> </strong></label>
            </div>
                <label class="control-label col-md-3"><strong>Fecha registro </strong></label>
                    <div class="col-md-3">
                <label class="control-label col-md-3"><strong> </strong></label>
            </div>
     
      <label class="control-label col-md-3"><strong>Estatus</strong></label>
                    <div class="col-md-3"> <span class="label label-primary"> No entregado<%=Parametro("ESTATUS")%></span>
                    </div>
     
       <label class="control-label col-md-3"><strong>Cantidad solicitada</strong></label>
                    <div class="col-md-3">
                <label class="control-label col-md-3"><strong></strong></label>
            </div>
       <label class="control-label col-md-3"><strong> Cantidad enviada </strong></label>
                    <div class="col-md-3">
                <label class="control-label col-md-3"><strong> </strong></label>
            </div>
      
      
      </div>
    </div>
  </div>exacto
</div>

<input type="hidden" id="Event_ID" value=""/>



<input type="hidden" id="Event_ID" value=""/>




<script src="/Template/inspina/js/plugins/jquery-ui/jquery-ui.min.js"></script>
<script src="/Template/inspina/js/plugins/fullcalendar/moment.min.js"></script>
<script src="/Template/inspina/js/plugins/fullcalendar/fullcalendar.min.js"></script>
<script src="/Template/inspina/js/plugins/fullcalendar/locale-all.js"></script>

<script src="/Template/inspina/js/plugins/clockpicker/clockpicker.js"></script>
<script src="/Template/inspina/js/plugins/datapicker/bootstrap-datepicker.js"></script>


<script src="/Template/inspina/js/plugins/iCheck/icheck.min.js"></script>


<script type="application/javascript">

$(document).ready(function() {
	     $("#OC_ID").hide();
		 $("#TA_ID").hide();
		 $("#Cli_ID").hide();
		  $("#IR_Folio").hide();
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
        datoAgenda['Cli_ID'] = $('#Cli_ID').val()
		datoAgenda['CliOC_ID'] = $('#OC_ID').val()
		datoAgenda['TA_ID'] = $('#TA_ID').val()
		datoAgenda['IR_Folio'] = $('#IR_Folio').val()
	    datoAgenda['IR_Conductor'] = $('#IR_Conductor').val()
		datoAgenda['IR_Placas'] = $('#IR_Placas').val()
		datoAgenda['IR_DescripcionVehiculo'] = $('#IR_DescripcionVehiculo').val()
		datoAgenda['Alm_ID'] = $('#Alm_ID').val()
		datoAgenda['IR_Color'] = $('#IR_Color').val()
		datoAgenda['IR_FechaEntrega'] = $('#IR_FechaEntrega').val()
		datoAgenda['IR_Horario'] = $('#IR_Horario').val()
		datoAgenda['IR_Puerta'] = $('#IR_Puerta').val()
			
		GuardaCita(datoAgenda)
		$('#MyBatmanModal').modal('hide') 
		//$('.agenda').val("")
    });
	
	$('#Folio').click(function(e) {
	$('.Robin').attr('disabled',false)
				$('#FormDatosGen').modal('show')  

});
$('#Cita').click(function(e) {
	$('.Robin').attr('disabled',false)
				$('#MyBatmanModal').modal('show')  
});
		$('.btnImprimeRecep').click(function(e) {
		e.preventDefault()
		var f=new Date();
		
		var m = Number(f.getMonth());
		if (m<10){
			m = m+1
			m = m.toString();
		m="0"+m
	     }
        f= (f.getDate() + "/" + m + "/" + f.getFullYear());
      RecepImprime(f,3)
	});
	function RecepImprime(d,v){
		var newWin=window.open("http://qawms.lyde.com.mx/pz/wms/Recepcion/RecepcionDocImpreso2.asp?Dia="+d+"&Tipo="+v);
}

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
				$('#IR_FechaEntrega').val(start.format('MM/DD/YYYY'))
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
				$('#IR_FechaEntrega').val(event.start.format('MM/DD/YYYY'))
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
		$('#IR_FechaEntrega').val("")
		$('#EndDate').val("")
		$('#StartHour').val("")
		$('#EndHour').val("")	
	})	
	
function GuardaCita(Evento){
			$("#dvCita").load("/pz/wms/Recepcion/Recepcion_Ajax.asp",Evento
    , function(data){
	
			sTipo = "info";
			sMensaje = "El registro se ha guardado correctamente ";
			
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


</script>
