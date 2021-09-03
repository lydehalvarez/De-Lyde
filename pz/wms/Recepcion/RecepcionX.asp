<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%
   

    var IDUsuario = Parametro("IDUsuario",-1) 
    var UsuarioRol = -1
    var Maniana =""
    var Hoy ""

    var sSQLRol = "select dbo.fn_BPM_DameRolUsuario(" + IDUsuario + ",3)"
    var rsRol = AbreTabla(sSQLRol,1,0)
	if(!rsRol.EOF){
		UsuarioRol = rsRol.Fields.Item(0).Value
	}    
    rsRol.CLose()
		

%>
<!-- link href="/Template/inspina/css/plugins/iCheck/green.css" rel="stylesheet" -->

<link href="/Template/inspina/font-awesome/css/font-awesome.css" rel="stylesheet">
<link href="/Template/inspina/css/plugins/iCheck/custom.css" rel="stylesheet">
<link href="/Template/inspina/css/plugins/select2/select2.min.css" rel="stylesheet">    
<link href="/Template/inspina/css/animate.css" rel="stylesheet">
<!-- link href="/Template/inspina/css/style.css" rel="stylesheet"  -->
<link href="/Template/inspina/css/plugins/daterangepicker/daterangepicker-bs3.css" rel="stylesheet">
<style type="text/css">
    
    .opciones{
        margin-left: 20px;	
    }
 
	.Caja-Flotando {
		position: fixed;
		top: 10px;
        /*right: 20px;*/
        width: 260px;
	  }
    .Cita-Datos {
        font-size: 14px;
        font-weight: 600;
    }
 
</style> 


	<div class="row">
        <div class="col-md-3" > 
            <div class="ibox" id="dvFiltros">
                <div class="ibox-title">
                    <h5>Filtros de b&uacute;squeda</h5>
                </div>      
                <div class="ibox-title">
                    <a href="#" class="btn btn-danger btn-sm pull-right" id="btnBuscarFecha">
                        <i class="fa fa-calendar"></i>&nbsp;&nbsp;Buscar</a>
                </div>
                <div class="ibox-content">
                    <h4 class="font-bold">
                        Puerta: 
                    </h4>
                    <select name="IR_Puerta" class="form-control agenda" id="IR_Puerta">
                      <option value="-1">Todas</option>
                      <%
					 var sSQL = "select InmP_ID, InmP_Nombre "
                         sSQL += " FROM Ubicacion_Inmueble_Posicion "
                         sSQL += " WHERE Alm_TipoCG88 = 5 "
                         sSQL += " AND Inm_ID = 1 "
                         
			         var rsPta = AbreTabla(sSQL,1,0)
					 while (!rsPta.EOF){ 
%>
                      <option value='<%=rsPta.Fields.Item("InmP_ID").Value%>'>
                          <%=rsPta.Fields.Item("InmP_Nombre").Value%></option>
                          
<%	                      rsPta.MoveNext() 
					}
                    rsPta.Close()  
%>
                    </select>
                    <h4 class="font-bold">
                        Estatus: 
                    </h4>
                    <select name="IR_Puerta" class="form-control agenda" id="IR_Puerta">
                      <option value="-1">Todas</option>
                      <%
					 var sSQL = "select InmP_ID, InmP_Nombre "
                         sSQL += " FROM Ubicacion_Inmueble_Posicion "
                         sSQL += " WHERE Alm_TipoCG88 = 5 "
                         sSQL += " AND Inm_ID = 1 "
                         
			         var rsPta = AbreTabla(sSQL,1,0)
					 while (!rsPta.EOF){ 
%>
                      <option value='<%=rsPta.Fields.Item("InmP_ID").Value%>'>
                          <%=rsPta.Fields.Item("InmP_Nombre").Value%></option>
                          
<%	                      rsPta.MoveNext() 
					}
                    rsPta.Close()  
%>
                    </select> 
                    <!-- div class="m-t-sm">
                        <div class="btn-group" --> 
                         <h4 class="font-bold">Fecha:</h4>
                         <div class="input-group date">
                            <input class="form-control date-picker date" id="FechaBusqueda" 
                                   placeholder="dd/mm/aaaa" type="text" value="" 
                                   style="width: 168px;float: left;" > 
                               <span class="input-group-addon" style="width: 37px;float: left;height: 34px;"><i class="fa fa-calendar"></i></span>
                         </div>
                       <!-- /div>
                    </div  -->
                </div>
            </div>
                <div class="ibox">
                    
                    
                </div>
            </div> 
     
        <div class="col-md-9">
            <div class="ibox">
                <div class="ibox-title">
<%if((IDUsuario == 97) || (IDUsuario == 34) || (IDUsuario == 36) || (IDUsuario == 37)|| (IDUsuario == 35)) {%>
                <span class="pull-right"> <a   class="text-muted btnSupervisor"><i class="fa fa-inbox"></i>&nbsp;<strong>Supervisor </strong></a> </span>
<%}%>
                    <span class="pull-right">
                        <a data-toggle="modal" data-target="#ModalImprimir" class="text-muted"><i class="fa fa-print"></i>&nbsp;<strong>Imprimir</strong></a>
                        &nbsp;|&nbsp;(<strong><div id="dvNumCitas">0</div></strong>) Citas | </span>
                    <h5>Citas en agenda</h5>  
                </div>
                <div  id="dvCitas" >

                  

                </div>
            </div>
        </div>
               
        </div>
    </div>

<div class="modal fade" id="ModalImprimir" tabindex="-1" role="dialog" aria-labelledby="ModalImprimir" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title">Imprimir</h5><button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
      </div>
      <div class="modal-body">
        <div class="form-horizontal">
            <div class="form-group">
                <label class="control-label col-md-3">D&iacute;a requerido:</label>
                <div class="i-checks">
                    <label class="control-label opciones">
                        <input type="radio" value="<%=Hoy%>" checked="checked" name="gpo1"/>&nbsp;Hoy (<%=Hoy%>)</label>
                    <label class="control-label opciones">
                        <input type="radio" value="<%=Maniana%>" name="gpo1"/>&nbsp;Ma&ntilde;ana (<%=Maniana%>)</label>
                </div>
                
            </div>     
            <div class="form-group">
                <label class="control-label col-md-3">Dirigido a:</label>
                <div class="i-checks" data-radios="opciones">
                    <label class="control-label opciones"><input type="radio" value="1" checked="checked" name="gpo2"/>&nbsp;Ambos</label>
                    <label class="control-label opciones"><input type="radio" value="2" name="gpo2"/>&nbsp;Seguridad</label>
                    <label class="control-label opciones"><input type="radio" value="3" name="gpo2"/>&nbsp;Recepci&oacute;n</label>
                </div>
            </div>     
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-danger" data-dismiss="modal">Cerrar</button>
        <button type="button" class="btn btn-primary btnImprimeConfig">Imprimir</button>
      </div>
    </div>
  </div>
</div>
<input id="inicio" type="hidden" value="" />
<input id="fin" type="hidden" value="" />
      
<!-- iCheck -->
<script src="/Template/inspina/js/plugins/iCheck/icheck.min.js"></script>

<!-- Select2 -->
<script src="/Template/inspina/js/plugins/select2/select2.full.min.js"></script>
<!-- Date range use moment.js same as full calendar plugin -->
<script src="/Template/inspina/js/plugins/fullcalendar/moment.min.js"></script>

<!-- Date range use moment.js same as full calendar plugin -->
<script src="/Template/inspina/js/plugins/fullcalendar/moment.min.js"></script>

<!-- Date range picker -->
<script src="/Template/inspina/js/plugins/daterangepicker/daterangepicker.js"></script>

<script type="application/javascript">

$(document).ready(function(){

        $('.i-checks').iCheck({ radioClass: 'iradio_square-green' }); 

        $('.btnRecibir').click(function(e) {
            e.preventDefault()

            var Params = "?TA_ID=" + $(this).data("taid")
                Params += "&IR_ID=" + $(this).data("irid")
                Params += "&CliOC_ID=" + $(this).data("cliocid")
                Params += "&Cli_ID=" + $(this).data("cliid") 
                Params += "&OC_ID=" + $(this).data("ocid")
                Params += "&Prov_ID=" + $(this).data("provid") 
                Params += "&Pro_ID=" + $(this).data("proid")
                Params += "&Usu_ID=" + $("#IDUsuario").val()
                Params += "&VI=" + $("#VentanaIndex").val()
            
            var UsuRol = <%=UsuarioRol%>
            

            //if( UsuRol == 2 || UsuRol == 3){
			if( $("#IDUsuario").val()==97||$("#IDUsuario").val()==36||$("#IDUsuario").val()==37){
                //$("#Contenido").load("/pz/wms/BPM/BPM_Recepciones.asp" + Params)
                $("#Contenido").load("/pz/wms/OC/ROC_Recepciones.asp" + Params)
            } else {
                $("#Contenido").load("/pz/wms/Recepcion/RecepcionEscaneo.asp" + Params)
            }
        });

        $('#btnBuscarFecha').click(function(e) {
            e.preventDefault()

            if ($("#InputBuscarFecha").val() == ""){
                var Fecha = "-"	
            } else {
                var Fecha=$("#InputBuscarFecha").val()
            }

            if ($("#IR_Puerta").val() == ""){
                var Puerta = "-"	
            } else{
                var	Puerta=$("#IR_Puerta").val()
            }
            
            
            
        });
    
        $('.btnHuella').click(function(e) {
            e.preventDefault()

            var Params = "?CliOC_ID=" + $(this).data("cliocid")
                   Params += "&Cli_ID=" + $(this).data("cliid") 
    //		Params += "&TA_ID=" + $(this).data("taid")   
            <%/*%>    Params += "&CliOC_ID=" + $(this).data("cliocid")
                Params += "&Cli_ID=" + $(this).data("cliid") 
                Params += "&OC_ID=" + $(this).data("ocid")
                Params += "&Prov_ID=" + $(this).data("provid") 
                Params += "&Pro_ID=" + $(this).data("proid")
                Params += "&IDUsuario=" + $("#IDUsuario").val()
                Params += "&VI=" + $("#VentanaIndex").val()<%*/%>

            $("#Contenido").load("/pz/wms/Recepcion/RecepcionIncidencias.asp" + Params)
        });    

        $('.btnSupervisor').click(function(e) {
            e.preventDefault()

            var Params = "?CliOC_ID=" + $(this).data("cliocid")
    //		Params += "&TA_ID=" + $(this).data("taid")   
            <%/*%>    Params += "&CliOC_ID=" + $(this).data("cliocid")
                Params += "&Cli_ID=" + $(this).data("cliid") 
                Params += "&OC_ID=" + $(this).data("ocid")
                Params += "&Prov_ID=" + $(this).data("provid") 
                Params += "&Pro_ID=" + $(this).data("proid")
                Params += "&IDUsuario=" + $("#IDUsuario").val()
                Params += "&VI=" + $("#VentanaIndex").val()<%*/%>

            $("#Contenido").load("/pz/wms/Recepcion/RecepcionSupervisor.asp" + Params)
        });

        $('.btnImprimeRecep').click(function(e) {
            e.preventDefault()
            RecepImprime($(this).data("irid"),$(this).data("cliocid"), $(this).data("cliid"),3)
        });

        $('.btnImprimeConfig').click(function(e) {
            e.preventDefault()
            RecepImprimeTodos($("input[name='gpo1']:checked"). val(),$("input[name='gpo2']:checked"). val())
        });		

//        $('.Fecha').datepicker({
//            todayBtn: "linked", 
//
//            dateFormat: 'dd/mm/yyyy',
//            language: "es",
//            todayHighlight: true,
//            autoclose: true
//        });

        $('#btnPruebaRapida').click(function(e) {
            e.preventDefault()
            MandaSO()
        });
    
   
        $('#FechaBusqueda').daterangepicker({
			"showDropdowns": true,
			//"singleDatePicker": true,
			"firstDay": 7,	
			"startDate": moment().subtract(29, 'days'),
			"endDate": moment(),
            "autoApply": true,
			"ranges": {
			   'Solo hoy': [moment(), moment()],
			   'Al dia de hoy': [moment().startOf('month'), moment()],
			   'Mañana': [moment().add(1, 'days'), moment().add(1, 'days')],
			   'Este Mes': [moment().startOf('month'), moment().endOf('month')],
			   'Mes pasado': [moment().subtract(1, 'month').startOf('month')
			                , moment().subtract(1, 'month').endOf('month')],		   
			   //'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
			   '+- 7 Dias': [moment().subtract(6, 'days'), moment().add(7, 'days')],
			   '+- 15 Dias': [moment().subtract(14, 'days'), moment().add(15, 'days')],                
			   '+- 30 Dias': [moment().subtract(29, 'days'), moment().add(30, 'days')],
			   'Siguientes 60 Dias': [moment().startOf('month'), moment().add(60, 'days')]
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

    
    
        CargaCitas()

    });	
    
    $(document).scroll(function(e) {

		  if ($(document).scrollTop() > 200) {
			$("#dvFiltros").addClass("Caja-Flotando");
		  } else {
			$("#dvFiltros").removeClass("Caja-Flotando");
		  }
	  
	});  
    
//	var Calendar = $('#InputBuscarFecha').fullCalendar({
//            header: {
//                left: 'prev,next today',
//                center: 'title',
//                right: 'agendaWeek,month,agendaDay'
//            },
//			themeSystem: 'bootstrap3',
//			lang: 'es',
//			timeFormat: 'H(:mm)',
//			contentHeight:"auto",
//            droppable: true,
//			firstDay: 1,
//			editable: true,
//			eventLimit: true,
//			selectable: true,
//			selectHelper: true,
//            drop: function() {
//                // is the "remove after drop" checkbox checked?
//                    // if so, remove the element from the "Draggable Events" list
//                    $(this).remove();
//					//console.log($(this))
//
//            },
//			eventDrop: function(event, delta, revertFunc) {
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
//				} else {
//					UpdateCita(event.start.format(),terminar.format(),event.id)
//				}
//			},
//			eventResize: function(info) {	
//				console.log(info.start.format())
//				console.log(info.id)
//				if (!confirm("Seguro?")) {
//					revertFunc();
//				} else {
//					UpdateCita(info.start.format(),info.end.format(),info.id)
//				}
//			},
//			select: function(start, end) {
//				$('.Robin').attr('disabled',false)
//				$('#MyBatmanModal').modal('show')  
//				$('#TitleCall').text()
//				$('#InputBuscarFecha').val(start.format('DD/MM/YYYY'))
//				
//			},
//			eventClick: function(event, jsEvent, view) {
//				$('.Robin').attr('disabled',true)
//				$('#MyBatmanModal').modal('show')  
//				
//				console.log(event)
//				var terminar = event.end
//				if(terminar == null){
//					terminar = event._start
//				}
//				$('#InputBuscarFecha').val(event.start.format('DD/MM/YYYY'))
//			
//				$('#Event_ID').val(event.id)	
//			},
//			events: {
//				url: '/pz/wms/Recepcion/RecepcionEventos.asp',
//				error: function() {
//					
//				}
//			},
//			loading: function(bool) {
//				$('#loading').toggle(bool);
//			},
//			eventRender: function(eventObj, $el) {
//			  $el.popover({
//				title: eventObj.title,
//				content: eventObj.description,
//				trigger: 'hover',
//				placement: 'top',
//				container: 'body'
//			  });
//			}
//	  });

    function CargaCitas(){
        
      //  var Params = "?Tarea=" + 1
      //      Params += "&IR_FechaEntrega=" + Fecha
      //      Params += "&IR_Puerta=" + Puerta

       // $("#Contenido").load("/pz/wms/Recepcion/Recepcion_Citas.asp" + Params)
        
        
        $("#dvNumCitas").html("100")
        $("#dvCitas").load("/pz/wms/Recepcion/Recepcion_Citas.asp")
        
    }


    function Enfasis(Folio){
        var Fol = Folio.attr('id');
        $('#'+Fol).addClass('bg-warning')
        
        setTimeout(function(){
            $('#'+Fol).removeClass('bg-warning')	
        },5000)	 
    }
    
    function RecepImprime(f,o,c,t){
            var newWin=window.open("/pz/wms/Recepcion/RecepcionDocImpreso.asp?Tipo="+t+"&IR_ID="+f+"&CliOC_ID="+o+"&Cli_ID="+c);
    }
    
    function RecepImprimeTodos(d,v){
            var newWin=window.open("/pz/wms/Recepcion/RecepcionDocImpreso.asp?IR_ID=-1&Dia="+d+"&Tipo="+v);
    }	

</script>