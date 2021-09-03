<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->

<link href="/Template/inspina/css/plugins/select2/select2.min.css" rel="stylesheet">
<script src="/Template/inspina/js/plugins/select2/select2.full.min.js"></script>
<link href="/Template/inspina/css/plugins/daterangepicker/daterangepicker-bs3.css" rel="stylesheet">
   
<div id="wrapper">
  <div class="wrapper wrapper-content">    
    <div class="row">
      <div class="col-lg-12">
        <div class="ibox float-e-margins">
            <div  class="ibox-title">
                <div class="row">
                    <div class="col-sm-12">        
                        <div class="col-sm-6 text-left">
                             <button type="button" class="btn btn-primary btnNuevoManifiesto">
                                      <i class="fa fa-plus"></i>&nbsp;&nbsp;Nueva devolucion</button>  
                         </div>
                                           <div class="col-sm-6 text-right">
                            <div class="btn-group" role="group" aria-label="Basic example">
                             <button type="button" class="btn btn-warning btnVerManifiestos">Devoluciones</button>  
                          
                            </div>                        
                    </div>                         
                </div>                         
            </div>
            <div class="ibox-title" id="dvFiltros" >
                     
             <h5>Filtros de b&uacute;squeda:</h5>
            </div>
            <div class="ibox-content">
                <div class="row"> 
                    <div class="col-sm-12 m-b-xs">        
                        <div class="row">
                            <div class="col-sm-1 m-b-xs pull-right">  
                              <button class="btn btn-success btn-sm pull-right" type="button" id="btnBuscar"><i class="fa fa-search"></i>&nbsp;&nbsp;<span class="bold">Buscar</span></button>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row"> 
                    <div class="col-sm-12 m-b-xs">        
                         <label class="col-sm-2 control-label">Folio:</label>
                         <div class="col-sm-4 m-b-xs">
                            <input class="form-control busFolio" placeholder="Busca folio" title="Escanea el folio que deseas encontrar" type="text" autocomplete="off" value="" />
                         </div>
                    </div>    
                </div>
            <div class="row">
                <div class="col-sm-12 m-b-xs">
                        <label class="col-sm-2 control-label">Rango fechas:</label>
                        <div class="col-sm-4 m-b-xs" >
                            <input class="form-control date-picker date" id="FechaBusqueda" 
                                   placeholder="dd/mm/aaaa" type="text" value="" 
                                   style="width: 200px;float: left;" > 
                               <span class="input-group-addon" style="width: 37px;float: left;height: 34px;"><i class="fa fa-calendar"></i></span>
                            
                        </div>
 
                </div>
            </div>
           <div class="table-responsive dvTabla" id="dvTabla">

           </div>  
          </div>
        </div>
      </div>
    </div>
    </div>                  
</div>


<div class="modal inmodal fade in" tabindex="-1" id="modalManifiesto" role="dialog">
  <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
          <div class="modal-header bg-success">
            <div class="col-md-3">
                <h5 class="modal-title" style="color:#FFF">Nueva devolci&oacute;n</h5>
            </div>
            <div class="col-md-9">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><i style="color:#FFF" class="fa fa-times"></i></button>
            </div>
          </div>
          <div class="modal-body">
            <div class="form-horizontal">
                 <div class="form-group">
                   <label class="control-label col-md-3" ><strong>Nombre operador</strong></label>
                    <div class="col-md-3">
                       <input class="form-control agenda" id="ManD_Operador" placeholder="Nombre completo" type="text" autocomplete="off" value=""/> 
                   </div>
                   <label class="control-label col-md-3"><strong>Placas del veh&iacute;culo</strong></label>
                   <div class="col-md-3">
                       <input class="form-control agenda" id="ManD_Placas" placeholder="Placas" type="text" autocomplete="off" value=""/> 
                   </div>
                </div>
                 <div class="form-group">
                 <label class="control-label col-md-3"><strong>Transportista</strong></label>
                    <div class="col-md-3" id = "dvTrans">
						<%
							CargaCombo("Prov_ID","class='form-control'","Prov_ID","Prov_Nombre","Proveedor","Prov_EsPaqueteria = 1","","Editar",0,"Selecciona")
                        %>
                    </div>
                </div>
                </div>	
            </div>   
            <div class="modal-footer">
                <button type="button" class="btn btn-danger" data-dismiss="modal">Cancelar</button>
                <button type="button"  class="btn btn-primary btnActualizarMan">Actualizar</button>
                <button type="button"  class="btn btn-primary btnGuardarMan">Guardar</button>
            </div>
      </div>
  </div>
</div>
              
          
        
<input type = "hidden"  value=""  id="ManD_ID"/> 
<input type="hidden" name="TA_ID" id="TA_ID" value="">     

<script src="/Template/inspina/js/plugins/pace/pace.min.js"></script>
<script src="/Template/inspina/js/plugins/iCheck/icheck.min.js"></script>
<script src="/Template/inspina/js/plugins/select2/select2.full.min.js"></script>

<script src="/Template/inspina/js/plugins/fullcalendar/moment.min.js"></script>
<script src="/Template/inspina/js/plugins/daterangepicker/daterangepicker.js"></script>
<script type="application/javascript">

$('.btnConfirma').hide()
		
$(document).ready(function(){
   
   	 ManifiestoFunciones.CargaBorrador();
	 
    $(".combman").select2(); 
	
    $('#FechaBusqueda').daterangepicker({
			"showDropdowns": true,
			//"singleDatePicker": true,
			"firstDay": 7,	
			"startDate": moment().subtract(29, 'days'),
			"endDate": moment(),
            "autoApply": true,
            "format": "DD/MM/YYYY",
			"ranges": {
			   'Al dia de hoy': [moment().startOf('month'), moment()],
			   'Este Mes': [moment().startOf('month'), moment().endOf('month')],
			   'Mes pasado': [moment().subtract(1, 'month').startOf('month')
			                , moment().subtract(1, 'month').endOf('month')],		   
			   //'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
			   'Ultimos 7 Dias': [moment().subtract(6, 'days'), moment()],
			   'Ultimos 30 Dias': [moment().subtract(29, 'days'), moment()]
			   
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
      
	$("#btnBuscar").click(function(event) {
		ManifiestoFunciones.CargaBorrador();
	});
    	
	$('.btnVerManifiestos').click(function(event){
		ManifiestoFunciones.CargaBorrador();
	});	
	
	$('.btnTerminados').click(function(event){
		ManifiestoFunciones.CargaTerminados();
	});
	
	$('.btnNuevoManifiesto').click(function(e){
		$('#modalManifiesto').modal('show') 
		$('#ManD_Ruta').val($('#cboRuta').val())  
		$('#Prov_ID').val($('#CboProv_ID').val())
		$('.btnActualizarMan').hide()
	});
	
	
	$('.btnGuardarMan').click(function(e){
		e.preventDefault();
		if($('#Prov_ID').val() != -1){
			ManifiestoFunciones.CreaManifiesto();
			$('#modalManifiesto').modal('hide') 
			$("#dvFiltros").show()
	
			$('#cboRuta').val($('#ManD_Ruta').val())
			$('#CboEdo_ID').val($('#Edo_ID').val())   
			$('#CboCat_ID').val($('#Cat_ID').val()) 
			$('#CboProv_ID').val($('#Prov_ID').val()) 
			$('#CboAer_ID').val($('#Aer_ID').val())
				
			var dato = {
				Edo_ID:$('#CboEdo_ID').val(),
				Tarea:7
				}
	
			$("#dvCiudad").load("/pz/wms/Devolucion/ArmadoManifiestoTA_Grid.asp", dato);
			$('html, body').animate({ scrollTop: $('#dvTabla').offset().top }, 'slow');

		}else{
			Avisa("error","Error","No se a seleccionado el transportista")
		}
	});
	$('.btnActualizarMan').click(function(e){
		e.preventDefault();
		if($('#Prov_ID').val() != -1){
			ManifiestoFunciones.ActualizaManifiesto();
			$('#modalManifiesto').modal('hide') 
			$("#dvFiltros").show()
	
			$('#CboProv_ID').val($('#Prov_ID').val()) 
				
			var dato = {
				Tarea:7
			}
	
			$("#dvCiudad").load("/pz/wms/Devolucion/ArmadoManifiestoTA_Grid.asp", dato);
			$('html, body').animate({ scrollTop: $('#dvTabla').offset().top }, 'slow');

		}else{
			Avisa("error","Error","No se a seleccionado el transportista")
		}
	});

	$('.btnConfirma').click(function(e){
		e.preventDefault();
		swal({
		  title: "Terminar manifiesto",
		  text: "Al terminar el manifiesto ya no se podr&aacute; hacer modificaciones",
		  type: "warning",
		  showCancelButton: true,
		  confirmButtonClass: "btn-success",
		  confirmButtonText: "Ok" ,
		  closeOnConfirm: true,
		  html: true
		},
		function(data){
			if(data){
				ManifiestoFunciones.Confirma();
			}
		});		
	});
	
	
	
});    

var ManifiestoFunciones = {
		EditaManifiesto:function()	{
				$('#modalManifiesto').modal('show') 
				$('.btnActualizarMan').show();
		},
		Contenido_Reporte:function(manid){
			var newWin=window.open("/pz/wms/Devolucion/ImpresionManifiesto.asp?ManD_ID="+manid);
		},
		Contenido_Edicion:function(manid){
			var data={
				ManD_ID:manid,
				Tarea:4
				}
			$("#dvTabla").load("/pz/wms/Devolucion/ArmadoManifiestoTA_Grid.asp", data);

		},
		Contenido_Borrador:function(manid){
				$("#ManD_ID").val(manid)
				var data={
				ManD_ID:manid,
				Tarea:4
				}
				$("#dvTabla").load("/pz/wms/Devolucion/ArmadoManifiestoTA_Grid.asp", data);

		},
		Contenido_Eliminar:function(taid){
			$.post("/pz/wms/Devolucion/Manifiesto_Ajax.asp",
				{TA_ID:taid,Tarea:4
				},function(data){
					var response = JSON.parse(data)
					if(response.result>-1){
						var Tipo = "error"
					}
					Avisa(Tipo,"Aviso",response.message);
				});
				var dato={
					ManD_ID:$("#ManD_ID").val(),
					Tarea:4
				}
				$("#dvTabla").load("/pz/wms/Devolucion/ArmadoManifiestoTA_Grid.asp", dato);
		},
		CargaBorrador:function(){
			var dato = {
				ManD_Folio:$('.busFolio').val(),
				Transporte:$('#CboProv_ID').val(),
				FechaInicio:$('#inicio').val(),
				FechaFin:$('#fin').val() 
			}
			$("#dvTabla").load("/pz/wms/Devolucion/Manifiesto_Borrador.asp",dato);
			$('html, body').animate({ scrollTop: $('#dvTabla').offset().top }, 'slow');
		},	
		CargaTerminados:function(){
			$("#dvTabla").load("/pz/wms/Devolucion/Manifiesto_Completo.asp");
			$('html, body').animate({ scrollTop: $('#dvTabla').offset().top }, 'slow');
		},
		CreaManifiesto:function(){
				$.post("/pz/wms/Devolucion/Manifiesto_Ajax.asp",
				{
					Prov_ID:$("#Prov_ID").val(),
					ManD_Operador:$("#ManD_Operador").val(),
					ManD_Placas:$("#ManD_Placas").val(),
					ManD_Vehiculo:$("#ManD_Vehiculo").val(),
					ManD_FolioCliente:$("#ManD_FolioCliente").val(),
					Cat_ID:$("#Cat_ID").val(),
					Aer_ID:$("#Aer_ID").val(),
					ManD_Ruta:$("#ManD_Ruta").val(),
					Edo_ID:$("#Edo_ID").val(),
					Usu_ID:$("#IDUsuario").val(),
					Tarea:2
				},function(data){
					var response = JSON.parse(data)
					if(response.result>-1){
						$("#ManD_ID").val(response.result)
						ManifiestoFunciones.Contenido_Edicion(response.result)
						$('html, body').animate({ scrollTop: $('#dvTabla').offset().top }, 'slow');
					}
				});
		},
		ActualizaManifiesto:function(){
				$.post("/pz/wms/Devolucion/Manifiesto_Ajax.asp",
				{
					ManD_ID:$("#ManD_ID").val(),
					Prov_ID:$("#Prov_ID").val(),
					ManD_Operador:$("#ManD_Operador").val(),
					ManD_Placas:$("#ManD_Placas").val(),
					ManD_Vehiculo:$("#ManD_Vehiculo").val(),
					ManD_FolioCliente:$("#ManD_FolioCliente").val(),
					Cat_ID:$("#Cat_ID").val(),
					Aer_ID:$("#Aer_ID").val(), 
					ManD_Ruta:$("#ManD_Ruta").val(),
					Edo_ID:$("#Edo_ID").val(),
					Usu_ID:$("#IDUsuario").val(),
					Tarea:3
				}
				,	 function(data){
					var response = JSON.parse(data)
					if(response.result>-1){
						$("#ManD_ID").val(response.result)
						ManifiestoFunciones.Contenido_Edicion(response.result)
						$('html, body').animate({ scrollTop: $('#dvTabla').offset().top }, 'slow');
					}
				});
		},
		Confirma:function(){
			var data={
				ManD_ID:$("#ManD_ID").val(),
				Tarea:7
			}
			$.post("/pz/wms/Devolucion/Manifiesto_Ajax.asp",data
				,function(data){
					var response = JSON.parse(data)
					var Tipo = ""
					if(response.result>0)
					{
						Tipo = "success"
					}
					else
					{
						Tipo = "error"
					}
					Avisa(Tipo,"Aviso",response.message);
			});
		},
		EscaneaFolio:function(request,inp_folio){
			inp_folio.val("")
			var myRequest = JSON.stringify(request);
			$.ajax({
				type: 'post',
				cache:false,
				async:true,
				data:myRequest,
				contentType:'application/json',
				url: "https://wms.lydeapi.com/api/s2008/Devolucion/addDevolucion",
				success: function(response){
					console.log(response) 
					if(response.result == 1){
						$('.renglon').removeClass('bg-primary');
						Avisa("success","A&ntilde;adido","El pedido se agreg&oacute; correctamente al manifiesto");
						$('#NuevoPedido').prepend(ManifiestoFunciones.NuevoRenglon(response.data));
						
						setTimeout(function(){$('.renglon').removeClass('bg-primary');},1000)
						
						var Total_SO = parseInt($('#Total_SO').val());
						var Total_TRA = parseInt($('#Total_TRA').val());
						
						if(response.data.EsOV == 1){
							Total_SO = Total_SO + 1
							$('#Total_SO').val(Total_SO);
							$('#total_so').html(Total_SO);
						}else{
							Total_TRA = Total_TRA + 1
							$('#Total_TRA').val(Total_TRA);
							$('#total_tra').html(Total_TRA);
						}
					}else{
						swal({
							title: "Ups!",
							text: response.message,
							type: "error",
							closeOnConfirm: true,
							html:true
						});
					}
				},error: function(){
						swal({
							title: "Algo sal&oacute; mal",
							text: "<strong>Intente de nuevo, si falla de nuevo comuniquese al &aacute;rea de sistemas</strong>",
							type: "error",
							closeOnConfirm: true,
							html:true
						});
				}
				
			});

		},
		Elimina:function(ID,EsOV){
			var request = {
				ID:ID,
				EsOV:EsOV,
				Test:true
			}
			var myRequest = JSON.stringify(request);
			$.ajax({
				type: 'post',
				cache:false,
				async:true,
				data:myRequest,
				contentType:'application/json',
				url: "https://wms.lydeapi.com/api/s2008/Devolucion/deleteDevolucion",
				success: function(response){
					console.log(response) 
					if(response.result == 1){
						var Total_SOD = parseInt($('#Total_SO').val());
						var Total_TRAD = parseInt($('#Total_TRA').val());

						if(request.EsOV == 1){
							if(Total_SOD != 1){
								Total_SOD = Total_SOD - 1
							}else{
								Total_SOD = 0;
							}
							$('#Total_SO').val(Total_SOD);
							$('#total_so').html(Total_SOD);
						}else{
							if(Total_TRAD != 1){
								Total_TRAD = Total_TRAD - 1
							}else{
								Total_TRAD = 0;
							}
							$('#Total_TRA').val(Total_TRAD);
							$('#total_tra').html(Total_TRAD);
						}
						
						$('#Entrante_'+request.EsOV+"_"+request.ID).hide('slow',function(){$(this.remove())})
					}else{
						swal({
							title: "Ups!",
							text: response.message,
							type: "error",
							closeOnConfirm: true,
							html:true
						});
					}
				},error: function(){
						swal({
							title: "Algo sal&oacute; mal",
							text: "<strong>Intente de nuevo, si falla de nuevo comuniquese al &aacute;rea de sistemas</strong>",
							type: "error",
							closeOnConfirm: true,
							html:true
						});
				}
				
			});

		},
		NuevoRenglon:function(arr){
			var renglon = '<tr class="bg-primary renglon" id="Entrante_'+arr.EsOV+'_'+arr.ID+'">'+
										'<td class="project-title">'+
										   '<a href="#">'+arr.Cli_Nombre+'</a>'+
											'<br/>'+
											'<small>Transportista:'+arr.Transportista+'&nbsp;Guia:&nbsp;'+arr.Guia+'</small>'+
										'</td>'+
										'<td class="project-title">'+
											'<a href="#">'+arr.Folio+'</a>'+
											'<br/>'+
											'<small>Registro:'+arr.FechaRegistro+'</small>'+
										'</td>'+
										'<td class="project-title">'+
											'<a href="#">C.P. '+arr.CP+'</a>'+
											'<br/>'+
											'<small> Elaboracion: '+arr.FechaElaboracion+'</small>'+
										'</td>'+
										'<td class="project-title">'+
											'<a href="#">'+arr.Estado+'</a>'+
											'<br/>'+arr.Ciudad+
										'</td>'+
										'<td class="project-actions">'+
											'<a class="btn btn-danger btn-sm" href="#" onclick="ManifiestoFunciones.Elimina('+arr.ID+','+arr.EsOV+');  return false"><i class="fa fa-trash"></i> Eliminar</a>'+
										'</td>'+
									 '</tr>'
			return renglon; 
		}
	
	}
  
    
  
</script>




