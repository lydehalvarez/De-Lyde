<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%

   
%>
    
    <link href="/Template/inspina/font-awesome/css/font-awesome.css" rel="stylesheet">
    <link href="/Template/inspina/css/plugins/iCheck/custom.css" rel="stylesheet">
    <link href="/Template/inspina/css/plugins/select2/select2.min.css" rel="stylesheet">    
    <link href="/Template/inspina/css/animate.css" rel="stylesheet">
    <link href="/Template/inspina/css/style.css" rel="stylesheet">
<link href="/Template/inspina/css/plugins/daterangepicker/daterangepicker-bs3.css" rel="stylesheet">
        
<div id="wrapper">
    <div class="wrapper wrapper-content">    
        <div class="row">
      <div class="col-lg-12">
        <div class="ibox float-e-margins">
        <div><button type="button" class="btn btn-primary BtnGMnf" id= "BtnGMnf" >
			Crear manifiesto</button>  
                     </div>
         <div><button type="button" class="btn btn-primary BtnVMnf" id= "BtnVMnf" >
			Ver manifiestos</button>  
         </div>

          <div>
              		<button type="button" class="btn btn-primary BtnCMnf" id= "BtnCMnf"  style="display:none" >
					Confirmar manifiesto</button>  
</div>
          <div class="ibox-title" id="dvFiltros" >
            <h5>Filtros de b&uacute;squeda</h5>
            <div class="ibox-tools">
            <br />
               <br />
        <input class="form-control InputTA"  id= "InputTA" style="width:20%" placeholder="escanea la transferencia" type="text" autocomplete="off" value="" />

            <%
						var Man_ID = BuscaSoloUnDato("ISNULL((MAX(Man_ID)),0)","Manifiesto_Salida","",-1,0)
			%>

               <label class="col-sm-2 control-label"> </label> <label class="col-sm-1 control-label" id = "lblManifiesto"></label>
                 <input type="hidden" id="inputManifiesto" value="" />

             

              <!--a class="collapse-link"><i class="fa fa-chevron-up"></i></a> <a class="dropdown-toggle" data-toggle="dropdown" href="#"><i class="fa fa-wrench"></i></a>
              <ul class="dropdown-menu dropdown-user">
                <li>
                  <a href="#">Config option 1</a>
                </li>
                <li>
                  <a href="#">Config option 2</a>
                </li>
              </ul><a class="close-link"><i class="fa fa-times"></i></a>
            </div-->
          </div>
          <div class="ibox-content">
            <div class="row"> 
                <div class="col-sm-12 m-b-xs">        
                    <div class="row">
                     <label class="col-sm-2 control-label">Tipo de Ruta:</label>
                        <div class="col-sm-4 m-b-xs">
                        
            
			<%  
                        var condicion = "Sec_ID = 94"
                        var campo = "Cat_Nombre"
                        
                        CargaCombo("CboCat_ID","class='form-control combman'","Cat_ID",campo,"Cat_Catalogo",condicion,"","Editar",0,"Selecciona")%>
                        </div>
                          <label class="col-sm-2 control-label">Transporte:</label>
                        <div class="col-sm-4 m-b-xs" id="dvTransporte">
 				   	<% CargaCombo("CboProv_ID","class='form-control combman'","Prov_Nombre","Prov_Nombre","Proveedor","","","Editar",0,"Selecciona")
%>
                        </div>
                   
                    </div>    
                </div>
            </div>
            <div class="row">
                <div class="col-sm-12 m-b-xs">
                    <div class="row">

                        <label class="col-sm-2 control-label">Ruta:</label>
                        <div class="col-sm-4 m-b-xs" >
                       <select id="cboRuta" class="form-control agenda">
                  <option value="--Seleccionar--" >--Seleccionar--</option>
            
			<%  
var sSQL = "SELECT  Alm_Ruta, ('R ' + CONVERT(NVARCHAR,Alm_Ruta) ) as Ruta	FROM Almacen "
+ "WHERE Alm_Ruta IS NOT NULL  GROUP BY Alm_Ruta Order by Alm_Ruta "
			var rsRuta = AbreTabla(sSQL,1,0)
			
			while (!rsRuta.EOF){
				var Ruta =  rsRuta.Fields.Item("Ruta").Value 
				var RutaBD =  rsRuta.Fields.Item("Alm_Ruta").Value 

			%>
                  <option  value="<%=RutaBD%>" ><%=Ruta%></option>
		  <%	
			 rsRuta.MoveNext() 
				}
			rsRuta.Close()   	
			%>
                        	</select>
                        </div>
                       
                          <label class="col-sm-2 control-label">Aeropuerto:</label>
                        <div class="col-sm-4 m-b-xs" id="dvAeroptos">
                       <%
					     var campo = "Aer_Nombre"
                        var condicion = ""
                        CargaCombo("CboAer_ID","class='form-control combman'","Aer_ID",campo,"Cat_Aeropuerto",condicion,"","Editar",0,"Selecciona")
%>
                        </div>

                    </div>    
                </div>
            </div>
            <div class="row">
                <div class="col-sm-12 m-b-xs">
                    <div class="row">

                        <label class="col-sm-2 control-label">Estado:</label>
                        <div class="col-sm-4 m-b-xs" >
                                        <%
                        var condicion = ""
                        var campo = "Edo_Nombre"
                        
                        CargaCombo("CboEdo_ID","class='form-control combman'","Edo_ID",campo,"Cat_Estado",condicion,"","Editar",0,"Selecciona")%>
                        </div>
                        <label class="col-sm-2 control-label">Ciudad:</label>
                        <div class="col-sm-4 m-b-xs" id="dvCiudad">
                                

		
                        </div>
                        

                    </div>    
                </div>
            </div>
            <div class="row">
                <div class="col-sm-12 m-b-xs">
                    <div class="row">

                        <label class="col-sm-2 control-label">Rango fechas:</label>
                        <div class="col-sm-4 m-b-xs" >
                            <input class="form-control date-picker date" id="FechaBusqueda" 
                                   placeholder="dd/mm/aaaa" type="text" value="" 
                                   style="width: 200px;float: left;" > 
                               <span class="input-group-addon" style="width: 37px;float: left;height: 34px;"><i class="fa fa-calendar"></i></span>
                            
                        </div>
                             <div class="col-sm-1 m-b-xs" style="text-align: left;">  
                          <button class="btn btn-success btn-sm" type="button" id="btnBuscar"><i class="fa fa-search"></i>&nbsp;&nbsp;<span class="bold">Buscar</span></button>
                        </div>
                    </div>    
                </div>
            </div>
            
     
           <div class="table-responsive" id="dvTabla"></div>  
          </div>
        </div>
        <div class="modal inmodal fade in" tabindex="-1" id="MyBatmanModal" role="dialog">
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
         
         
                                 <input type = "hidden"  value=""  id="Man_ID"/>
                               

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
                        var condicion = "Sec_ID = 94"
                        var campo = "Cat_Nombre"
                        
                        CargaCombo("Cat_ID","class='form-control combman'","Cat_ID",campo,"Cat_Catalogo",condicion,"","Editar",0,"Selecciona")%>

             </div>
               <label class="control-label col-md-3"><strong>Transportista</strong></label>
                <div class="col-md-3" id = "dvTrans">
        <%
		   		CargaCombo("Prov_ID","class='form-control combman'","Prov_ID","Prov_Nombre","Proveedor","","","Editar",0,"Selecciona")

		%>
        
            </div>
            
                
            </div>
            <div class="form-group">
              
                      <label class="control-label col-md-3"><strong>Estado</strong></label>
                <div class="col-md-3">
                	<select id="Edo_ID" class="form-control agenda">
                  <option value="--Seleccionar--" >--Seleccionar--</option>
       
			<%  
var sSQL = "SELECT Edo_ID, Edo_Nombre FROM Cat_Estado "

			var rsEdo = AbreTabla(sSQL,1,0)
			
			while (!rsEdo.EOF){
			var Edo_ID =  rsEdo.Fields.Item("Edo_ID").Value 
			var Edo_Nombre =  rsEdo.Fields.Item("Edo_Nombre").Value 
	
			%>
                  <option  value="<%=Edo_ID%>"><%=Edo_Nombre%></option>
		  <%	
			 rsEdo.MoveNext() 
				}
			rsEdo.Close()   	
			%>
               	</select>
                                        <%
                     //   var condicion = ""
//                        var campo = "Edo_Nombre"
                       
//                        CargaCombo("Edo_ID","class='form-control combman'","Edo_ID",campo,"Cat_Estado",condicion,"","Editar",0,"Selecciona")%>
           </div>
           <label class="control-label col-md-3"><strong>Aeropuerto</strong></label>
                <div class="col-md-3" id = "dvAero">
                <%
   					    var campo = "Aer_Nombre"
                        var condicion = ""
                        CargaCombo("Aer_ID","class='form-control combman'","Aer_ID",campo,"Cat_Aeropuerto",condicion,"","Editar",0,"Selecciona")

				%>
            </div>
            </div>
            <div class="form-group">
                  <label class="control-label col-md-3"><strong>Ruta</strong></label>
                <div class="col-md-3">
                               <%
                        var condicion = "Alm_Ruta IS NOT NULL  GROUP BY Alm_Ruta Order by Alm_Ruta"
                        var campo = "('R ' + CONVERT(NVARCHAR,Alm_Ruta) ) as Ruta"
                        
                        CargaCombo("Man_Ruta","class='form-control combman'","Alm_Ruta",campo,"Almacen",condicion,"","Editar",0,"Selecciona")%>
           </div>
               
                    
            </div>
            </div>	
         
              
        </div>   
           <div class="modal-footer">
        <button type="button"  class="btn btn-primary" id="BtnGuardar">Guardar</button>
        <button type="button" class="btn btn-danger" id="BtnCancelar">Cancelar</button>
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cerrar</button>
      </div>
      </div>
   
      
      
      </div>
    </div>
      </div>
    </div>
    </div>                  
</div>
              
    <!-- Mainly scripts -->
    <!-- script src="/Template/inspina/js/jquery-3.1.1.min.js"></script -->
    <!-- script src="/Template/inspina/js/bootstrap.min.js"></script -->
    <script src="/Template/inspina/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>

    <!-- Custom and plugin javascript -->
    <!--  script src="/Template/inspina/js/inspinia.js"></script -->
    <script src="/Template/inspina/js/plugins/pace/pace.min.js"></script>

    <!-- iCheck -->
    <script src="/Template/inspina/js/plugins/iCheck/icheck.min.js"></script>

    <!-- Select2 -->
    <script src="/Template/inspina/js/plugins/select2/select2.full.min.js"></script>
          
    <!-- MENU -->
    <!-- script src="/Template/inspina/js/plugins/metisMenu/jquery.metisMenu.js"></script -->
        
        
<input type="hidden" name="TA_ID" id="TA_ID" value="">     
<input id="inicio" type="hidden" value="" />
<input id="fin" type="hidden" value="" />
<!-- Date range use moment.js same as full calendar plugin -->
<script src="/Template/inspina/js/plugins/fullcalendar/moment.min.js"></script>

<!-- Date range picker -->
<script src="/Template/inspina/js/plugins/daterangepicker/daterangepicker.js"></script>

<script type="text/javascript">
        
$(document).ready(function(){
	
	$('#Edo_ID').change(function(e) {
				e.preventDefault()

				    var dato = {}
                dato['Edo_ID'] =$('#Edo_ID').val()
                dato['Tarea'] =5

			$("#dvAero").load("/pz/wms/Salidas/ArmadoManifiestoTA_Grid.asp", dato);
		});
			$('#CboEdo_ID').change(function(e) {
				e.preventDefault()

				    var dato = {}
                dato['Edo_ID'] =$('#CboEdo_ID').val()
                dato['Tarea'] =7

			$("#dvCiudad").load("/pz/wms/Salidas/ArmadoManifiestoTA_Grid.asp", dato);
				    var dato = {}
                dato['Edo_ID'] =$('#CboEdo_ID').val()
                dato['Tarea'] =9

			$("#dvAeroptos").load("/pz/wms/Salidas/ArmadoManifiestoTA_Grid.asp", dato);
		});
			$('#Cat_ID').change(function(e) {
				e.preventDefault()

				    var dato = {}
                dato['Cat_ID'] =$('#Cat_ID').val()
                dato['Tarea'] =6

			$("#dvTrans").load("/pz/wms/Salidas/ArmadoManifiestoTA_Grid.asp", dato);
		});
		$('#CboCat_ID').change(function(e) {
				e.preventDefault()

				    var dato = {}
                dato['Cat_ID'] =$('#CboCat_ID').val()
                dato['Tarea'] =8

			$("#dvTransporte").load("/pz/wms/Salidas/ArmadoManifiestoTA_Grid.asp", dato);
		});
	
  //   $("#dvFiltros").hide()
  	    var dato = {}
                dato['Man_Ruta'] =""
                dato['Aer_ID'] =0
                dato['Tarea'] =1

			$("#dvTabla").load("/pz/wms/Salidas/ArmadoManifiestoTA_Grid.asp", dato);
			
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

            var dato = {}
                dato['Lpp'] = 1  //este parametro limpia el cache
                dato['Aer_ID'] = $('#Aer_ID').val()
                dato['Transporte'] = $('#CboProv_ID').val()
                dato['Man_Ruta'] = $('#cboRuta').val()
                dato['Edo_ID'] = $('#CboEdo_ID').val()
                dato['Cat_ID'] = $('#CboCat_ID').val()
                dato['Ciudad'] = $('#Ciu_ID').val()
                dato['FechaInicio'] = $('#inicio').val()
                dato['FechaFin'] = $('#fin').val()
                dato['Tarea'] =1

         $("#dvTabla").load("/pz/wms/Salidas/ArmadoManifiestoTA_Grid.asp",dato);

	   });
    	
		$('#BtnMnf').click(function(e){
				var suma = parseInt($("#lblManifiesto").text()) +1
						$("#lblManifiesto").text(suma)
						$("#inputManifiesto").val(suma)
		});
		
			$('#BtnVMnf').click(function(event){
				
				  var dato = {}
						 dato['Tarea'] =2

         $("#dvTabla").load("/pz/wms/Salidas/ArmadoManifiestoTA_Grid.asp",dato);
		
		});
		
			$('#BtnGMnf').click(function(e){
				$('#MyBatmanModal').modal('show') 
			
                $('#Man_Ruta').val($('#cboRuta').val())  
                $('#Edo_ID').val($('#CboEdo_ID').val())
                $('#Cat_ID').val($('#CboCat_ID').val()) 
				$('#Prov_ID').val($('#CboProv_ID').val())
		   		$('#Aer_ID').val($('#CboAer_ID').val())
		});
		$('#BtnGuardar').click(function(e){
			e.preventDefault();
			ManifiestoFunciones.CreaManifiesto();
			$('#MyBatmanModal').modal('hide') 
			$("#dvFiltros").show()
			$('#BtnCMnf').css('display','block')
			    var dato = {}
                dato['Man_Ruta'] =""
                dato['Aer_ID'] =0
                dato['Tarea'] =1

			$("#dvTabla").load("/pz/wms/Salidas/ArmadoManifiestoTA_Grid.asp", dato);
  			    $('#cboRuta').val($('#Man_Ruta').val())
				$('#CboEdo_ID').val($('#Edo_ID').val())   
                $('#CboCat_ID').val($('#Cat_ID').val()) 
				$('#CboProv_ID').val($('#Prov_ID').val()) 
		    	$('#CboAer_ID').val($('#Aer_ID').val())
				
				var dato3 = {}
                dato3['Edo_ID'] =$('#CboEdo_ID').val()
                dato3['Tarea'] =7

			$("#dvCiudad").load("/pz/wms/Salidas/ArmadoManifiestoTA_Grid.asp", dato3);
		});

$('.InputTA').on('change',function(e) {
	e.preventDefault()
	     var dato = {}
    dato['TA_Folio'] = $('#InputTA').val()
    dato['Tarea'] =1

         $("#dvTabla").load("/pz/wms/Salidas/ArmadoManifiestoTA_Grid.asp",dato);
  
  $.post("/pz/wms/Salidas/Manifiesto_Ajax.asp",
					{Man_ID:$("#lblManifiesto").text(),
					TA_Folio:$('#InputTA').val(),
					Tarea:1,
					Usu_ID:$("#IDUsuario").val()
					}
					,	 function(data){
						
					});
							$('#InputTA').val("")
			
   	});		
	
		$('#BtnCMnf').click(function(e){
		//	var Man_ID = parseInt($("#Man_ID").val()) +1
			
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
						console.log(data)
							//$('#BtnCMnf').hide()
					$('#dvTabla').hide()
					$('#dvFiltros').hide()	
					$('#BtnCMnf').hide()	
					}
					});
			
	});
					
				
//		var FunctionManif = {
//					InsertManif:function(taid){
//					$.post("/pz/wms/Salidas/ArmadoManifiestoTA_grid.asp",
//					{TA_ID:taid,
//					Tarea:1,
//					Man_ID:<%=Man_ID%>
//					}
//					,	 function(data){
//						
//					
//					});				
//					}
//	
});    

var ManifiestoFunciones = {
		CreaManifiesto:function(){
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
				}
				,	 function(data){
					var response = JSON.parse(data)
					if(response.result>-1){
						$("#Man_ID").val(response.result)
					}
				});
			}
	
	
	}
  
    
  
</script>




