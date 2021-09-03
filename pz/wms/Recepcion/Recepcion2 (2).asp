<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%
	var sSQLRe = "SELECT * "
		sSQLRe += ", CONVERT(VARCHAR(20), IR_FechaEntrega, 103) AS IRFechaEntrega "
		sSQLRe += ", CONVERT(VARCHAR(20), IR_FechaEntregaTermina, 103) AS IRFechaEntregaTermina "
		sSQLRe += ", CONVERT(VARCHAR(8), IR_FechaEntrega, 108) AS IRHoraEntrega "
		sSQLRe += ", CONVERT(VARCHAR(10), IR_FechaEntregaTermina, 108) AS IRHoraEntregaTermina "
		sSQLRe += "FROM Inventario_Recepcion "
		sSQLRe += " WHERE IR_Habilitado = 1 "
		sSQLRe += " ORDER BY IR_FechaEntrega DESC "
		
		
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
		
	var sSQLRece = "SELECT TOP 1 * "
		sSQLRece += ", CONVERT(VARCHAR(17), getdate(), 103) AS Hoy "
		sSQLRece += ", CONVERT(VARCHAR(17), getdate()+1, 103) AS Maniana "
		sSQLRece += ", CONVERT(VARCHAR(17), IR_FechaEntrega, 113) AS IRFechaEntrega "
		sSQLRece += ", CONVERT(VARCHAR(17), IR_FechaEntregaTermina, 113) AS IRFechaEntregaTermina "
		sSQLRece += "FROM Inventario_Recepcion "
		sSQLRece += " WHERE IR_FechaEntrega > getdate()"
		sSQLRece += " ORDER BY IR_FechaEntrega ASC "
		
	var rsRece = AbreTabla(sSQLRece,1,0)
	if(!rsRece.EOF){
		var Fol = rsRece.Fields.Item("IR_Folio").Value
		var IRFechaEntrega = rsRece.Fields.Item("IRFechaEntrega").Value
		var IRFechaEntregaTermina = rsRece.Fields.Item("IRFechaEntregaTermina").Value
		var PuertaMasProx = rsRece.Fields.Item("IR_Puerta").Value
	}	
	
%>
<link href="/Template/inspina/css/plugins/iCheck/green.css" rel="stylesheet">
<link href="/Template/inspina/css/plugins/datapicker/datepicker3.css" rel="stylesheet">

<style>
.opciones{
	margin-left: 20px;	
}
</style>
<div class="wrapper wrapper-content animated fadeInRight">
	<div class="row">
        <div class="col-md-9">
            <div class="ibox">
                <div class="ibox-title">
                            <span class="pull-right"> <a  class="text-muted btnImprimeRecep"><i class="fa fa-print"></i>&nbsp;<strong>Imprimir entregas de hoy</strong></a>&nbsp;|&nbsp;(<strong><%=NumCitas%></strong>) Citas</span>
                    <h5>Citas en agenda   Linea: 1</h5>  
                    
                </div>
                <div style="overflow-y: scroll; height:655px; width: auto;">
                <%
					var rsRe = AbreTabla(sSQLRe,1,0)
	
					while (!rsRe.EOF){
						var IR_FechaEntrega = rsRe.Fields.Item("IRFechaEntrega").Value + " " + rsRe.Fields.Item("IRHoraEntrega").Value
						var IR_FechaEntregaTermina = rsRe.Fields.Item("IRFechaEntregaTermina").Value+ " " + rsRe.Fields.Item("IRHoraEntregaTermina").Value
						var IR_Folio = rsRe.Fields.Item("IR_Folio").Value
						var IR_EstatusCG62 = rsRe.Fields.Item("IR_EstatusCG62").Value
						var IR_Puerta = rsRe.Fields.Item("IR_Puerta").Value
						var IR_ID = rsRe.Fields.Item("IR_ID").Value
						 var TA_ID = rsRe.Fields.Item("TA_ID").Value

				%>
                    <div class="ibox-content" id="<%=IR_Folio%>">
                        <div class="table-responsive">
                            <table class="table shoping-cart-table">
                                <tbody>
                                <tr>
                                    <td width="90">
                                            <img src="/Img/wms/Logo_Izzi_2.jpg" title="Izzi" style="width:inherit;"/>
                                    </td>
                                    <td class="desc">
                                        <h4>
                                        Folio
                                        </h4>
                                      <h4>
                                        Fecha de recepci&oacute;n
                                        </h4>
                                        <h4>
                                        Cantidad de Palets
                                        </h4>
                                        <h4 class="text-navy">
                                        Puerta
                                        </h4>
                                          <h4 class="text-navy">
                                        Tipo veh&iacute;culo
                                        </h4>
                                         <h4 class="text-navy">
                                         Placas
                                        </h4>
                                         <h4 class="text-navy">
                                         Operador
                                        </h4>
                                    </td>
                                    <td class="desc" style="width:25%;">
                        
  <h3 class="text-navy">
                                        <a data-irid="<%=IR_ID%>" class="text-navy btnRecibir" ><%=IR_Folio%></a>
                                        </h3>
                                        <h4>
                                           <%=IR_FechaEntrega%>
                                        </h4>
                                        <h4>
                                         50
                                        </h4>
                                        <h4 class="text-navy">
                                           3<%=IR_Puerta%>
                                        </h4>
                                         <h4 class="text-navy">
                                          Torton
                                        </h4>
                                         <h4 class="text-navy">
                                          EIJ3834
                                        </h4>
                                         <h4 class="text-navy">
                                          Francisco Martinez
                                        </h4>
                                        </td>
                                        <div class="m-t-sm">
<%/*%>                                            <a data-irid="<%=IR_ID%>" class="text-muted btnRecibir"><i class="fa fa-inbox"></i>&nbsp;<strong>Recibir</strong></a>
<%*/%>                                          <a data-irid="<%=IR_ID%>" data-taid="<%=TA_ID%>" class="text-muted btnRecibir"><i class="fa fa-inbox"></i>&nbsp;<strong>Recibir</strong></a>
                                                           <span class="pull-right"> <a  data-irid="" data-folio="" class="text-muted btnImprimeRecep" id="Pallets"><i class="fa fa-pencil fa-fw"></i><strong>Capturar Pallets</strong></a></span>
             
                                            <a  href='pz/wms/Recepcion/RecepcionDocImpreso.asp?Tipo=3&IR_ID=41' data-irid="<%=IR_ID%>" data-folio="<%=IR_Folio%>" class="text-muted btnImprimeRecep"><i class="fa fa-print"></i>&nbsp;<strong>Impresi&oacute;n recepci&oacute;n</strong></a>
                                                 
                                                 <input type="button" value="Incidencias"  id="btnIncidencias" class="btn btn-info btnIncidencias"/>
                                            
                                        </div>
                                        
                                    </td>
                                   <td class="desc">
                                 <dl class="dl-horizontal">
                                   <h4> <dt>Estatus:</dt> <dd><span class="label label-primary">No entregado<%=Parametro("ESTATUS","")%></span></dd>
                               </h4>
                                </dl>
                                    </td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
					<%	
                        rsRe.MoveNext() 
                    }
                    rsRe.Close()   
                    %>
                </div>
            </div>
        </div>
        
        
        
        
        <div class="col-md-3">
            <div class="ibox">
                <div class="ibox-title">
               
                     <label class="control-label col-md-3"><strong>Buscar Fechas</strong></label>
            
                    <div class="input-group date">
                        <input class="form-control date-picker Fecha Robin agenda"
                        id="EndDate" placeholder="dd/mm/aaaa" type="text" autocomplete="off"
                        value="" data-esfecha="1"> 
                        <span class="input-group-addon"><i class="fa fa-calendar"></i></span>
                   
                </div>
                </div>
                
            </div>
            <div class="ibox">
                <div class="ibox-title">
                    <h5>Ayuda</h5>
                </div>
                <div class="ibox-content text-center">
                    <h3><i class="fa fa-phone"></i> +55 12 34 56 78</h3>
                    <span class="small">
                        Gerente de recepci&oacute;n
                    </span>
                </div>
            </div>
            <div class="ibox">
                <div class="ibox-content">
                    <p class="font-bold">
                    
                    </p>
                    <hr/>
                    <div>
                        <a href="#" class="product-name">  </a>
                        <div class="small m-t-xs">
                         
                        </div>
                        <div class="m-t text-righ">

                            <a href="#" class="btn btn-xs btn-outline btn-primary"> <i class="fa fa-long-arrow-right"></i> </a>
                        </div>
                    </div>
                    <hr/>
                    <div>
                        <a href="#" class="product-name"></a>
                        <div class="small m-t-xs">
                        
                        </div>
                        <div class="m-t text-righ">

                            <a href="#" class="btn btn-xs btn-outline btn-primary"> <i class="fa fa-long-arrow-right"></i> </a>
                        </div>
                    </div>
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
                <label class="control-label col-md-3"><strong>IZZI</strong></label>
            </div>
                <label class="control-label col-md-3"><strong> Productos </strong></label>
                    <div class="col-md-3">
                <label class="control-label col-md-3"><strong> Huawei Y9 </strong></label>
            </div>
              <label class="control-label col-md-3"><strong>Destino </strong></label>
                    <div class="col-md-3">
                <label class="control-label col-md-3"><strong>Monterrey </strong></label>
            </div>
     
              <label class="control-label col-md-3"><strong>Fecha registro </strong></label>
                    <div class="col-md-3">
                <label class="control-label col-md-3"><strong>07/07/2020 09:00 a.m. </strong></label>
            </div>
     
   <label class="control-label col-md-3"><strong>Estatus </strong></label>
                    <div class="col-md-3"> <span class="label label-primary"> No entregado<%=Parametro("ESTATUS","")%></span>
                    </div>
     
       <label class="control-label col-md-3"><strong> Cantidad solicitada</strong></label>
                    <div class="col-md-3">
                <label class="control-label col-md-3"><strong> 1000 </strong></label>
            </div>
       <label class="control-label col-md-3"><strong> Cantidad enviada </strong></label>
                    <div class="col-md-3">
                <label class="control-label col-md-3"><strong>500 </strong></label>
            </div>
        <div class="modal-footer">
        <button type="button" class="btn btn-primary" id="BtnRecibir">Recibir</button>
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cerrar</button>
      </div>
      </div>
      </div>
      </div>
    </div>
  </div>
</div>
<div class="modal fade" id="ModalImprimir" tabindex="-1" role="dialog" aria-labelledby="ModalImprimir" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">Imprimir</h5><button type="button" class="close" data-dismiss="modal" aria-label="Close" onclick="pz/wms/Recepcion/RecepcionDocImpreso2.asp?Tipo=3&IR_ID=41"><span aria-hidden="true">&times;</span></button>
      </div>
      <div class="modal-body">
        <div class="form-horizontal">
            <div class="form-group">
                <label class="control-label col-md-3">D&iacute;a requerido:</label>
                <div class="i-checks">
                    <label class="control-label opciones"><input type="radio" value="<%=Hoy%>" checked="checked" name="gpo1"/>&nbsp;Hoy (<%=Hoy%>)</label>
                    <label class="control-label opciones"><input type="radio" value="<%=Maniana%>" name="gpo1"/>&nbsp;Ma&ntilde;ana (<%=Maniana%>)</label>
                </div>
            </div>     
            
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-danger" data-dismiss="modal">Cerrar</button>
        <button type="button" class="btn btn-primary btnImprimeConfig" onclick ="location.href='http://qawms.lyde.com.mx//pz/wms/Recepcion/RecepcionDocImpreso2.asp?Tipo=3&IR_ID=41';">Imprimir</button>
      </div>
    </div>
<script src="/Template/inspina/js/plugins/datapicker/bootstrap-datepicker.js"></script>
<script src="/Template/inspina/js/plugins/iCheck/icheck.min.js"></script>
<script type="application/javascript">

$(document).ready(function(){
		
		
	$('.i-checks').iCheck({ radioClass: 'iradio_square-green' }); 
		
});	
$('.btnRecibir').click(function(e) {
		e.preventDefault()
		
		var Params = "?TA_ID=" + $(this).data("taid")
		    Params += "&IR_ID=" + $(this).data("irid")
		    Params += "&Pro_ID=3"
	        Params += "&IDUsuario=" + $("#IDUsuario").val()	

		$("#Contenido").load("/pz/wms/BPM/BPM_Recepciones.asp" + Params)
	});
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
				$('#EndDate').val(event.format('MM/DD/YYYY'))
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



	$('.Fecha').datepicker({
		todayBtn: "linked", 
		language: "es",
		todayHighlight: true,
		autoclose: true
	});
			
					
	$('.btnRecibir').click(function(e) {
		e.preventDefault()
		console.log($(this).data("irid"))
		
	});
	$('.btnImprimeRecep').click(function(e) {
		e.preventDefault()
		RecepImprime($(this).data("irid"),3)
	});
	
	$('.btnImprimeConfig').click(function(e) {
		e.preventDefault()
		RecepImprimeTodos($("input[name='gpo1']:checked"). val(),$("input[name='gpo2']:checked"). val())
	});
		
function Enfasis(Folio){
    var Fol = Folio.attr('id');
	$('#'+Fol).addClass('bg-warning')
	setTimeout(function(){
	$('#'+Fol).removeClass('bg-warning')	
	},5000)	
}
function RecepImprime(f,t){
		var newWin=window.open("http://wms.lyde.com.mx/pz/wms/Recepcion/RecepcionDocImpreso.asp?Tipo="+t+"&IR_ID="+f);
}
function RecepImprimeTodos(d,v){
		var newWin=window.open("http://wms.lyde.com.mx/pz/wms/Recepcion/RecepcionDocImpreso.asp?IR_ID=-1&Dia="+d+"&Tipo="+v);
}
function CargaProductos(){
	/*	var sDatos  = "?TA_ID="+$("#TA_ID").val();*/ 
		$("#Pallets").load("/pz/wms/Recepcion/RecepcionPallet.asp");
	}    
</script>
