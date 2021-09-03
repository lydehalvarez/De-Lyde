<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
var TA_ID =""
%>

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
                                      <i class="fa fa-plus"></i>&nbsp;&nbsp;Nuevo manifiesto</button>  
                             <button type="button" class="btn btn-primary btnConfirma" id= "BtnCMnf" style="display:none" >
                                    <i class="fa fa-check"></i> Confirmar manifiesto</button>  
                         </div>
                        <div class="col-sm-6 text-right">
                            <div class="btn-group" role="group" aria-label="Basic example">
                             <button type="button" class="btn btn-warning btnVerManifiestos">
                                     Borrador</button>  
                             <button type="button" class="btn btn-primary btnTerminados">
                                     Terminados</button>  
                            </div>                         
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
                           <input class="form-control busFolio" placeholder="Busca folio manifiesto" title="Escanea el folio que deseas encontrar" type="text" autocomplete="off" value="" />
                         </div>
                    </div>  
                </div>
                <div class="row"> 
                    <div class="col-sm-12 m-b-xs">        
                     <label class="col-sm-2 control-label">Tipo de Ruta:</label>
                        <div class="col-sm-4 m-b-xs">
							<%  
                                var sEventos = "class='form-control combman'"
                                ComboSeccion("CboCat_ID", sEventos, 94, -1, 0, "--Seleccionar--", "", "Editar")
                            %>
                        </div>
                        
                        <label class="col-sm-1 control-label">Transporte:</label>
                        <div class="col-sm-4 m-b-xs" id="dvTransporte">
							<% 
                                var sEventos = "class='form-control combman'"
                                var sCondicion = " Prov_Habilitado = 1 "
                                CargaCombo("CboProv_ID", sEventos, "Prov_Nombre","Prov_Nombre","Proveedor",sCondicion,"","Editar",0,"--Seleccionar--")
                            %>
                        </div>

                    </div>    
                </div>
            <div class="row">
                <div class="col-sm-12 m-b-xs">
                        <label class="col-sm-2 control-label">Ruta:</label>
                        <div class="col-sm-4 m-b-xs" >
                            <select id="cboRuta" class="form-control agenda combman">
                                <option value="-1" >--Seleccionar--</option>
						<%  
                        
                            var sSQL = "SELECT  DISTINCT Alm_Ruta, ('R ' + CONVERT(NVARCHAR,Alm_Ruta) ) as Ruta	"
                                    + " FROM Almacen "
                                    + " WHERE Alm_Ruta > 0 "
                                    + " AND Alm_ID in ( SELECT TA_End_Warehouse_ID "
                                    +                   " FROM TransferenciaAlmacen "
                                    +                  " WHERE TA_EstatusCG51 = 4 ) "
                                    + " Order By Alm_Ruta "
                           
                            var rsRuta = AbreTabla(sSQL,1,0)
                                    
                            while (!rsRuta.EOF){
                        %>
                               <option value="<%=rsRuta.Fields.Item("Alm_Ruta").Value%>" >
                                       <%=rsRuta.Fields.Item("Ruta").Value%></option>
                        <%	
                                rsRuta.MoveNext() 
                                }
                            rsRuta.Close()   	
                        %>
                        	</select>
                        </div>
                       
                        <label class="col-sm-1 control-label">Aeropuerto:</label>
                        <div class="col-sm-4 m-b-xs" id="dvAeroptos">
						<%
                             
                            var sEventos = "class='form-control combman'"
                            var sCondicion = " Edo_ID = -1 "
                                        + " or Edo_ID in ( Select Distinct Edo_ID "
                                        + " from TransferenciaAlmacen t, Almacen a "
                                        + " where t.TA_End_Warehouse_ID = a.Alm_ID "
                                        + " AND t.TA_EstatusCG51 = 4 )"
                           
                            CargaCombo("CboAer_ID",sEventos,"Aer_ID","Aer_NombreAG","Cat_Aeropuerto",sCondicion,"","Editar",0,"--Seleccionar--")
                        %>
                        </div>
                </div>
            </div>     
                            
            <div class="row">
                <div class="col-sm-12 m-b-xs">
                    <label class="col-sm-2 control-label">Estado:</label>
                    <div class="col-sm-4 m-b-xs" >
				<%
                    var sEventos = "class='form-control combman'"
                    var sCondicion = " Edo_ID in ( Select Distinct Edo_ID "
                                + " from TransferenciaAlmacen t, Almacen a "
                                + " where t.TA_End_Warehouse_ID = a.Alm_ID "
                                + " AND t.TA_EstatusCG51 = 4 )"
                
                    CargaCombo( "CboEdo_ID",sEventos,"Edo_ID","Edo_Nombre","Cat_Estado",sCondicion,"","Editar",0
                               ,"--Seleccionar--")
                %>
                    </div>
                    <label class="col-sm-1 control-label">Ciudad:</label>
                    <div class="col-sm-4 m-b-xs" id="dvCiudad"> 
                        <select id="cboCiudad" class="form-control combman">
                            <option value="-1" >--Seleccione un estado--</option>
                        </select>
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
           <div class="dvCargando">
               <div class="spiner-example">
                <div class="sk-spinner sk-spinner-three-bounce">
                    <div class="sk-bounce1"></div>
                    <div class="sk-bounce2"></div>
                    <div class="sk-bounce3"></div>
                </div>
            </div>
           </div>
           <div class="table-responsive dvError" id="dvError"></div>  
           <div class="table-responsive dvTabla" id="dvTabla"></div>  
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
                <h5 class="modal-title" style="color:#FFF">Asignar manifiesto</h5>
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
                       <input class="form-control agenda" id="Man_Operador" placeholder="Nombre completo" type="text" autocomplete="off" value=""/> 
                   </div>
                   <label class="control-label col-md-3"><strong>Placas del veh&iacute;culo</strong></label>
                   <div class="col-md-3">
                       <input class="form-control agenda" id="Man_Placas" placeholder="Placas" type="text" autocomplete="off" value=""/> 
                   </div>
                </div>
                 <div class="form-group">
                   <label class="control-label col-md-3"><strong>Tipo del veh&iacute;culo</strong></label>
                    <div class="col-md-3">
                        <input class="form-control agenda" id="Man_Vehiculo" placeholder="Descripci&oacute;n de veh&iacute;culo" type="text" autocomplete="off" value=""/>
                    </div>
                  	<label class="control-label col-md-3"><strong>Folio Cliente</strong></label>
                    <div class="col-md-3">
                        <input class="form-control agenda" id="Man_FolioCliente" placeholder="Folio" type="text" autocomplete="off" value=""/>
                    </div>
                </div>
                <div class="form-group">
                     <label class="control-label col-md-3"><strong>Tipo de Ruta</strong></label>
                     <div class="col-md-3">
						<%
                        var sCondicion = "Sec_ID = 94"
                        var campo = "Cat_Nombre"
                        
                        CargaCombo("Cat_ID","class='form-control'","Cat_ID",campo,"Cat_Catalogo",sCondicion,"","Editar",0,"Selecciona")%>
                     </div>
                       <label class="control-label col-md-3"><strong>Transportista</strong></label>
                        <div class="col-md-3" id = "dvTrans">
                        <%
                            var sCondicion = "Prov_Habilitado = 1 and Prov_EsPaqueteria = 1"
                            CargaCombo("Prov_ID","class='form-control'","Prov_ID","Prov_Nombre","Proveedor",sCondicion,"","Editar",0,"Selecciona")
                        %>
                    </div>
                </div>
                <div class="form-group">
                  <label class="control-label col-md-3"><strong>Estado</strong></label>
                    <div class="col-md-3">
                        <%
                            var sCondicion = ""
                            var campo = "Edo_Nombre"
                            
                            CargaCombo("Edo_ID","class='form-control '","Edo_ID",campo,"Cat_Estado",sCondicion,"","Editar",0,"Selecciona")%>
                   </div>
                   <label class="control-label col-md-3"><strong>Aeropuerto</strong></label>
                    <div class="col-md-3" id = "dvAero">
                    <%
                            var campo = "Aer_Nombre"
                            var sCondicion = ""
                            CargaCombo("Aer_ID","class='form-control'","Aer_ID",campo,"Cat_Aeropuerto",sCondicion,"","Editar",0,"Selecciona")
    
                    %>
                    </div>
                </div>
                    <div class="form-group">
                          <label class="control-label col-md-3"><strong>Ruta</strong></label>
                            <div class="col-md-3">
                                       <%
                                var sCondicion = "Alm_Ruta IS NOT NULL  GROUP BY Alm_Ruta Order by Alm_Ruta"
                                var campo = "('R ' + CONVERT(NVARCHAR,Alm_Ruta) ) as Ruta"
                                
                                CargaCombo("Man_Ruta","class='form-control'","Alm_Ruta",campo,"Almacen",sCondicion,"","Editar",0,"Selecciona")%>
                            </div>
                    </div>
                </div>	
            </div>   
            <div class="modal-footer">
                <button type="button"  class="btn btn-primary btnGuardarMan">Guardar</button>
                <button type="button"  class="btn btn-primary btnActualizarMan">Actualizar</button>
                <button type="button" class="btn btn-danger" data-dismiss="modal">Cancelar</button>
            </div>
      </div>
  </div>
</div>
              
          
        
<input type="hidden" name="Man_ID" id="Man_ID" value="" > 
<input type="hidden" name="TA_ID"  id="TA_ID"  value="" >     
<input type="hidden" name="Valida" id="Valida" value="" >     
<input id="inicio" type="hidden" value="" />
<input id="fin" type="hidden" value="" />

<script src="/Template/inspina/js/plugins/pace/pace.min.js"></script>
<script src="/Template/inspina/js/plugins/iCheck/icheck.min.js"></script>
<script src="/Template/inspina/js/plugins/select2/select2.full.min.js"></script>

<script src="/Template/inspina/js/plugins/fullcalendar/moment.min.js"></script>
<script src="/Template/inspina/js/plugins/daterangepicker/daterangepicker.js"></script>
<script type="application/javascript">

$('.btnConfirma').hide()
$(".dvCargando").hide('slow')
	
    
$(document).ready(function(){
    
    $('#dvError').hide()

    $(".combman").select2(); 
    
    ManifiestoFunciones.CargaBorrador();	
    
	$('#Edo_ID').change(function(e) {
	   e.preventDefault()
	   var dato = {
		   Edo_ID:$('#Edo_ID').val(),
		   Tarea:6
	   }
		$("#dvAero").load("/pz/wms/Salidas/Manifiesto_Ajax.asp", dato);
	});
    
    $('#CboEdo_ID').change(function(e) {
        e.preventDefault()
        var dato = {
			Edo_ID:$('#CboEdo_ID').val(),
			Tarea:5
			}
        $("#dvCiudad").load("/pz/wms/Salidas/Manifiesto_Ajax.asp", dato);
        
			dato = {
				Edo_ID:$('#CboEdo_ID').val(),
				Tarea:6
			}
		$("#dvAeroptos").load("/pz/wms/Salidas/Manifiesto_Ajax.asp", dato);
        
     });
    
	$('#Cat_ID').change(function(e) {
		e.preventDefault()
		var dato = {
			Cat_ID:$('#Cat_ID').val(),
			Tarea:9
		}
		$("#dvTrans").load("/pz/wms/Salidas/Manifiesto_Ajax.asp", dato);
	});
		
	$('#CboCat_ID').change(function(e) {
		e.preventDefault()
		var dato = {
			Cat_ID:$('#CboCat_ID').val(),
			Tarea:10
			}
		$("#dvTransporte").load("/pz/wms/Salidas/Manifiesto_Ajax.asp", dato);
	});
	
    $('#FechaBusqueda').daterangepicker({
			"showDropdowns": true,
			//"singleDatePicker": true,
			"firstDay": 7,	
			"startDate": moment().subtract(29, 'days'),
			"endDate": moment(),
            "autoApply": true,
			"ranges": {
			   'Al dia de hoy': [moment().startOf('month'), moment()],
			   'Este Mes': [moment().startOf('month'), moment().endOf('month')],
			   'Mes pasado': [moment().subtract(1, 'month').startOf('month')
			                , moment().subtract(1, 'month').endOf('month')],		   
			   //'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
			   '+- 7 Dias': [moment().subtract(6, 'days'), moment().add(7, 'days')],
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
  
      $("#btnBuscar").click(function(event) {
			$(".dvCargando").show('slow')
            var dato = {
				
				Lpp:1,  //este parametro limpia el cache
				Aer_ID:$('#Aer_ID').val(),
				Folio:$('.busFolio').val(),
				Transporte:$('#CboProv_ID').val(),
				Man_Ruta:$('#cboRuta').val(),
				Edo_ID:$('#CboEdo_ID').val(),
				Cat_ID:$('#CboCat_ID').val(),
				Ciudad:$('#Ciu_ID').val(),
				FechaInicio:$('#inicio').val(),
				FechaFin:$('#fin').val(),
				Tarea:1
				}
				if($('#inicio').val() != "" || $('#busFolio').val() != ""){
				 $("#dvTabla").load("/pz/wms/Salidas/Manifiesto_Completo.asp",dato,function(){
				$(".dvCargando").hide('slow')
				
			 });	
				}else{
					
			 $("#dvTabla").load("/pz/wms/Salidas/ArmadoManifiestoTA_Grid.asp",dato,function(){
				$(".dvCargando").hide('slow')
				
			 });
				}
	   });
    	
	$('.btnVerManifiestos').click(function(event){
		ManifiestoFunciones.CargaBorrador();
		$('html, body').animate({ scrollTop: $('#dvTabla').offset().top }, 'slow');

	});	
	
	$('.btnTerminados').click(function(event){
		ManifiestoFunciones.CargaTerminados();
	});
	
	$('.btnNuevoManifiesto').click(function(e){
		$('#modalManifiesto').modal('show') 
		$('#Man_Ruta').val($('#cboRuta').val())  
		$('#Edo_ID').val($('#CboEdo_ID').val())
		$('#Cat_ID').val($('#CboCat_ID').val()) 
		$('#Prov_ID').val($('#CboProv_ID').val())
		$('#Aer_ID').val($('#CboAer_ID').val())
		$('.btnActualizarMan').hide()
	});
	$('.btnGuardarMan').click(function(e){
		e.preventDefault();
		$(".dvCargando").show('slow')
		if($('#Prov_ID').val() != -1){
			ManifiestoFunciones.CreaManifiesto();
			$('#modalManifiesto').modal('hide') 
			$("#dvFiltros").show()
	
			$('#cboRuta').val($('#Man_Ruta').val())
			$('#CboEdo_ID').val($('#Edo_ID').val())   
			$('#CboCat_ID').val($('#Cat_ID').val()) 
			$('#CboProv_ID').val($('#Prov_ID').val()) 
			$('#CboAer_ID').val($('#Aer_ID').val())
				
			var dato = {
				Edo_ID:$('#CboEdo_ID').val(),
				Tarea:7
				}
	
			$("#dvCiudad").load("/pz/wms/Salidas/ArmadoManifiestoTA_Grid.asp", dato,function(){
				$(".dvCargando").hide('slow')
			});
			$('html, body').animate({ scrollTop: $('#dvTabla').offset().top }, 'slow');

		}else{
			Avisa("error","Error","No se a seleccionado el transportista")
		}
	});
	$('.btnActualizarMan').click(function(e){
		$(".dvCargando").show('slow')
		e.preventDefault();
		if($('#Prov_ID').val() != -1){
			ManifiestoFunciones.ActualizaManifiesto();
			$('#modalManifiesto').modal('hide') 
			$("#dvFiltros").show()
	
			$('#cboRuta').val($('#Man_Ruta').val())
			$('#CboEdo_ID').val($('#Edo_ID').val())   
			$('#CboCat_ID').val($('#Cat_ID').val()) 
			$('#CboProv_ID').val($('#Prov_ID').val()) 
			$('#CboAer_ID').val($('#Aer_ID').val())
				
			var dato = {
				Edo_ID:$('#CboEdo_ID').val(),
				Tarea:7
				}
	
			$("#dvCiudad").load("/pz/wms/Salidas/ArmadoManifiestoTA_Grid.asp", dato,function(){
				$(".dvCargando").hide('slow')
			});
			$('html, body').animate({ scrollTop: $('#dvTabla').offset().top }, 'slow');

		}else{
			Avisa("error","Error","No se a seleccionado el transportista")
		}
	});
	
	$('.Folio').on('keypress',function(e) {
		if(e.which == 13) {
			var DatoIngreso = $(this).val();
			DatoIngreso = DatoIngreso.replace("'","-")
			 var dato = {
					 Folio:DatoIngreso,
					 Man_ID:$('#Man_ID').val(),
					 IDUsuario:$("#IDUsuario").val()
			 }
			ManifiestoFunciones.EscaneaFolioApi(dato,$(this))
		}
	});
	
	
//	$('.Folio').on('keypress',function(e) {
//		if(e.which == 13) {
//			var DatoIngreso = $(this).val();
//			DatoIngreso = DatoIngreso.replace("'","-")
//				if(DatoIngreso.slice(0,3) == "TRA"){
//				var TA=DatoIngreso
//				var SO = ""
//			}
//			if(DatoIngreso.slice(0,2) == "SO"){
//	            var TA = ""	
//				var SO=DatoIngreso
//				SO = DatoIngreso.replace("'","")
//			}
//			if($('#Valida').val() == 0){
//				Tarea = 1
//			}else{
//			Tarea = 7
//			}
//			 var dato = {
//					 TA_Folio:TA,
//					 OV_Folio:SO,
//					 Tarea:Tarea,
//					 Man_ID:$('#Man_ID').val(),
//					 Usu_ID:$("#IDUsuario").val()
//			 }
//			ManifiestoFunciones.EscaneaFolio(dato,$(this))
//		}
//	});

	$('.btnConfirma').click(function(e){
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
		EditaManifiesto:function(Man_ID){
			
			
			
				$('#modalManifiesto').modal('show') 
//				if(folcli==0){
//				folcli=""	
//				}
//				if(conductor==0){
//				conductor=""	
//				}
//				if(placas==0){
//				placas=""	
//				}
//				if(vehiculo==0){
//				vehiculo=""	
//				}
//				$('#Man_FolioCliente').val(folcli)
//				$('#Man_Operador').val(conductor)
//				$('#Man_Placas').val(placas)
//	   		    $('#Man_Vehiculo').val(vehiculo)
//				$('#Prov_ID').val(provid)
//				$('#Cat_ID').val(tpruta)
//				$('#Aer_ID').val(aerid)
//				$('#Man_Ruta').val(ruta)	
//				$('#Edo_ID').val(edoid)	
//				$('.btnGuardarMan').hide();
//				$('.btnActualizarMan').show();
		},
		Contenido_Reporte:function(manid){
			var newWin=window.open("http://wms.lyde.com.mx/pz/wms/Salidas/ImpresionManifiesto.asp?Man_ID="+manid);
		},
		Contenido_Edicion:function(manid){
			ManifiestoFunciones.Esconde();
			var data={
				Man_ID:manid,
				Tarea:4
				}
			$("#dvTabla").load("/pz/wms/Salidas/ArmadoManifiestoTA_Grid.asp", data,function(){
					ManifiestoFunciones.Muestra();
			});

		},
		Contenido_Borrador:function(manid){
			ManifiestoFunciones.Esconde();
			$("#Man_ID").val(manid)
			$("#Valida").val(0)
			var data={
			Man_ID:manid,
			Tarea:4
			}
			$("#dvTabla").load("/pz/wms/Salidas/ArmadoManifiestoTA_Grid.asp", data,function(){
				ManifiestoFunciones.Muestra();
			});
		},
		Contenido_ValidaCarga:function(manid){
			ManifiestoFunciones.Esconde();
			$("#Man_ID").val(manid)
			$("#Valida").val(1)
			var data={
			Man_ID:manid,
			Tarea:9
			}
			$("#dvTabla").load("/pz/wms/Salidas/ArmadoManifiestoTA_Grid.asp", data,function(){
				ManifiestoFunciones.Muestra();
			});
		},
		Contenido_Eliminar:function(taid){
			ManifiestoFunciones.Esconde();
			$.post("/pz/wms/Salidas/Manifiesto_Ajax.asp",
			{
				TA_ID:taid,
				Tarea:4
			},function(data){
				var response = JSON.parse(data)
				if(response.result>-1){
					var Tipo = "error"
				}
				Avisa(Tipo,"Aviso",response.message);
				var dato={
					Man_ID:$("#Man_ID").val(),
					Tarea:4
				}
				$("#dvTabla").load("/pz/wms/Salidas/ArmadoManifiestoTA_Grid.asp", dato,function(){
					ManifiestoFunciones.Muestra();
				});
			});
	
		},
       Contenido_EliminarSO:function(ovid){
			ManifiestoFunciones.Esconde();
			$.post("/pz/wms/Salidas/Manifiesto_Ajax.asp",
			{
				OV_ID:ovid,
				Tarea:8
			},function(data){
				var response = JSON.parse(data)
				if(response.result>-1){
					var Tipo = "error"
				}
				Avisa(Tipo,"Aviso",response.message);
				var dato={
					Man_ID:$("#Man_ID").val(),
					Tarea:4
				}
				$("#dvTabla").load("/pz/wms/Salidas/ArmadoManifiestoTA_Grid.asp", dato,function(){
					ManifiestoFunciones.Muestra();
				});
			});
	
		},
		CargaBorrador:function(){
			ManifiestoFunciones.Esconde();
			$("#dvTabla").load("/pz/wms/Salidas/Manifiesto_Borrador.asp","",function(){
				ManifiestoFunciones.Muestra();
			});
		},	
		CargaTerminados:function(){
			ManifiestoFunciones.Esconde();
			$("#dvTabla").load("/pz/wms/Salidas/Manifiesto_Completo.asp","",function(){
				ManifiestoFunciones.Muestra();
			});
			$('html, body').animate({ scrollTop: $('#dvTabla').offset().top }, 'slow');
		},
		CreaManifiesto:function(){
			ManifiestoFunciones.Esconde();
			$.post("/pz/wms/Salidas/Manifiesto_Ajax.asp",
			{
				Prov_ID:$("#Prov_ID").val(),
				Man_Operador:$("#Man_Operador").val(),
				Man_Placas:$("#Man_Placas").val(),
				Man_Vehiculo:$("#Man_Vehiculo").val(),
				Man_FolioCliente:$("#Man_FolioCliente").val(),
				Cat_ID:$("#Cat_ID").val(),
				Aer_ID:$("#Aer_ID").val(),
				Man_Ruta:$("#Man_Ruta").val(),
				Edo_ID:$("#Edo_ID").val(),
				Usu_ID:$("#IDUsuario").val(),
				Tarea:2
			},function(data){
				$(".dvCargando").hide('slow')
				var response = JSON.parse(data)
				if(response.result>-1){
					$("#Man_ID").val(response.result)
					ManifiestoFunciones.Contenido_Edicion(response.result)
					$('html, body').animate({ scrollTop: $('#dvTabla').offset().top }, 'slow');
				}
			});
		},
		ActualizaManifiesto:function(){
			ManifiestoFunciones.Esconde();
			$.post("/pz/wms/Salidas/Manifiesto_Ajax.asp",
			{
				Man_ID:$("#Man_ID").val(),
				Prov_ID:$("#Prov_ID").val(),
				Man_Operador:$("#Man_Operador").val(),
				Man_Placas:$("#Man_Placas").val(),
				Man_Vehiculo:$("#Man_Vehiculo").val(),
				Man_FolioCliente:$("#Man_FolioCliente").val(),
				Cat_ID:$("#Cat_ID").val(),
				Aer_ID:$("#Aer_ID").val(),
				Man_Ruta:$("#Man_Ruta").val(),
				Edo_ID:$("#Edo_ID").val(),
				Usu_ID:$("#IDUsuario").val(),
				Tarea:3
				},function(data){
				$(".dvCargando").hide('slow')
				var response = JSON.parse(data)
				if(response.result>-1){
					$("#Man_ID").val(response.result)
					ManifiestoFunciones.Contenido_Edicion(response.result)
					$('html, body').animate({ scrollTop: $('#dvTabla').offset().top }, 'slow');
				}
			});
		},
		Confirma:function(){
			ManifiestoFunciones.Esconde();
			var data={
				Man_ID:$("#Man_ID").val()
			}
			var json=JSON.stringify(data)
			$.ajax({
				method: "POST",
				contentType:"application/json",
				url: "https://wms.lydeapi.com/api/wms/ag/FinalizaManifiesto",
				data: json,	
				success:function(data){
					$(".dvCargando").hide('slow')
					if(data.result == 1){
						swal({title: "Manifiesto terminado"});
						$('#dvTabla').hide()
						$('#dvFiltros').hide()	
						$('.btnConfirma').hide()	
					}
				}
			});
		},
		EscaneaFolioApi:function(dato,input){
			setTimeout(function(){
				input.val("");
			},200)
			var myJSON = JSON.stringify(dato); 
				$.ajax({
					type: 'POST',
					data: myJSON, 
					contentType:'application/json',
					url: "http://192.168.254.10:8081/api/s2012/Manifiesto/Add",
					success: function(response){
						console.log(response)
						if(response.result == 1){
							var total = parseInt($('#Total').val())
							total = total + 1
							$('#Total').val(total)
							$('#botonesHidden').css('display','block');
							var Caja = response.data.TA_CantidadCaja
							var Peso = response.data.TA_Peso
							var ShowCaja = ""
							var ShowPeso = ""
							if(Caja > 1){
								ShowCaja = Caja +" Cajas"
							}else{
								ShowCaja = Caja +" Caja"
							}
							if (Peso > 0) { 
								ShowPeso = '<br/><small>Peso: '+Peso+' Kg</small>'
							}
							
							var Nuevo = '<tr id="Entrante_'+response.data.ID+'">'+
										'<td class="project-title">'+
										   '<a href="#">'+response.data.Cli_Nombre+'</a>'+
											'<br/>'+
											'<small>Transportista:'+response.data.Transportista+'</small>'+
										'</td>'+
										'<td class="project-title">'+
											'<a href="#">'+response.data.Folio+'</a>'+
											'<br/>'+
											'<small>Registro:'+response.data.FechaRegistro+'</small>'+
										'</td>'+
										'<td class="project-title">'+
											'<a href="#">'+ShowCaja+'</a>'+ShowPeso+
										'</td>'+
										'<td class="project-title">'+
											'<a href="#">C.P. '+response.data.Alm_CP+'</a>'+
											'<br/>'+
											'<small> Elaboracion: '+response.data.FechaElaboracion+'</small>'+
										'</td>'+
										'<td class="project-title">'+
											'<a href="#">'+response.data.Alm_Estado+'</a>'+
											'<br/>'+response.data.Alm_Ciudad+
										'</td>'+
										'<td class="project-actions">'+
											'<a class="btn btn-danger btn-sm" href="#" onclick="ManifiestoFunciones.EliminaPedido('+response.data.ID+');  return false"><i class="fa fa-trash"></i> Eliminar</a>'+
										'</td>'+
									 '</tr>'
							 $('#TotalAcumulado').html(total)
							 $('#addManifiesto').prepend(Nuevo);
							Avisa("success","Aviso",response.message);
						}else{
							Avisa("error","Aviso",response.message);

							swal({
							  title: "Ups!",
							  text: response.message,
							  type: "error",
							  confirmButtonClass: "btn-success",
							  confirmButtonText: "Ok" ,
							  closeOnConfirm: true,
							  html: true
							},
							function(data){
							});	
						}
						
					}
				});
		},
		EscaneaFolio:function(data,inp){
			ManifiestoFunciones.Esconde();
			$.post("/pz/wms/Salidas/Manifiesto_Ajax.asp",data,function(data){
				var response = JSON.parse(data)
				var Tipo = ""
				if(response.result > 0){
					Tipo = "success"
				}else if(response.result != -10){
					Tipo = "error"
					$("#divError").show()
					$("#divError").html('<p style="color:red;"><font size = 7>'+response.message+'</font></p>')
				}else{
					Tipo = "error"
					swal({
						  title: "Transferencia cancelada",
						  text: response.message,
						  type: "warning",
						  closeOnConfirm: true,
						  html: true
						},
						function(data){
					});	
				}
				
				inp.focus()
				inp.val("")
				if($('#Valida').val() == 0){
					Tarea = 4
				}else{
					Tarea = 9
				}
				Avisa(Tipo,"Aviso",response.message);
				$("#divError").hide()
				var data={
				Man_ID:$('#Man_ID').val(),
				Tarea:Tarea
				}
				$("#dvTabla").load("/pz/wms/Salidas/ArmadoManifiestoTA_Grid.asp", data,function(){
					ManifiestoFunciones.Muestra();
				});
		});
		},
		Esconde:function(){ 
			$(".dvCargando").show('slow')
			$(".dvTabla").hide('slow')
		},
		Muestra:function(){
			$(".dvCargando").hide('slow')
			$(".dvTabla").show('slow')
		},
		EliminaPedido:function(TA_ID){
			var dato = {
				TA_ID:TA_ID,
				OV_ID:-1
			}

			var myJSON = JSON.stringify(dato); 
			$.ajax({
					type: 'POST',
					data: myJSON, 
					contentType:'application/json',
					url: "http://192.168.254.10:8081/api/s2012/Manifiesto/Delete",
					success: function(response){
						console.log(response)
						if(response.result == 1){
							var total = parseInt($('#Total').val())
							total = total - 1
							if(total == 0){
								$('#botonesHidden').css('display','none');
							}
							$('#Total').val(total)
							 $('#TotalAcumulado').html(total)
							 $('#Entrante_'+TA_ID).addClass('bg-danger')
							 $('#Entrante_'+TA_ID).hide("slow",function(){
								 $(this).remove()
								 $('.Folio').focus()
							 })
							 
							Avisa("success","Pedido borrado",response.message);
						}else{
							Avisa("error","Aviso",response.message);

							swal({
							  title: "Ups!",
							  text: response.message,
							  type: "error",
							  confirmButtonClass: "btn-success",
							  confirmButtonText: "Ok" ,
							  closeOnConfirm: true,
							  html: true
							},
							function(data){
							});	
						}
						
					},error: function(){
						swal({
							  title: "Error",
							  text: "Comunicarse al &aacute;rea de sistemas",
							  type: "error",
							  confirmButtonClass: "btn-success",
							  confirmButtonText: "Ok" ,
							  closeOnConfirm: true,
							  html: true
							},
						function(data){
						});	

					}
				});
		}
		
}
  
    
  
</script>




