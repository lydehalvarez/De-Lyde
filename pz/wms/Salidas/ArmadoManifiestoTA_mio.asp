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
          <div>
              		<button type="button" class="btn btn-primary BtnCMnf" id= "BtnCMnf"  style="display:none" >
					Confirmar manifiesto</button>  
</div>
          <div class="ibox-title" id="dvFiltros"  style="display:none">
            <h5>Filtros de b&uacute;squeda</h5>
            <div class="ibox-tools">
            <br />
               <br />
        <input class="form-control TA"  id= "inputTA" style="width:30%" placeholder="escanea la transferencia" type="text" autocomplete="off" value="" onkeydown= "javascript:CargaTA(E);"/>

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
                        <label class="col-sm-2 control-label">Aeropuerto:</label>
                        <div class="col-sm-4 m-b-xs">
 					<select id="cboAeropuerto" class="form-control agenda">
                  <option value="--Seleccionar--" >--Seleccionar--</option>
            
			<%  
var sSQL = "SELECT al.Aer_ID, CASE  " 
+	" WHEN al.Aer_ID = -1 THEN '' " 
+	" WHEN al.Aer_ID = 0 THEN 'DIRECTO' "
+	" WHEN al.Aer_ID > 0 THEN (select Aer_NombreAG FROM Cat_Aeropuerto  ap WHERE ap.Aer_ID = al.Aer_ID) "
+	" END AS Aeropuerto "
+	" FROM Almacen al WHERE  al.Aer_ID <> 6 AND  al.Aer_ID <> '-1' "
+	" GROUP BY al.Aer_ID "
		var 	rsAer = AbreTabla(sSQL,1,0)
			
			while (!rsAer.EOF){
				var Aer_ID =  rsAer.Fields.Item("Aer_ID").Value 
				var Aeropuerto =  rsAer.Fields.Item("Aeropuerto").Value 
			
			%>
                  <option  value="<%=Aer_ID%>" ><%=Aeropuerto%></option>
		  <%	
			 rsAer.MoveNext() 
				}
			rsAer.Close()   	
			%>
                        	</select>
                        </div>
                          <label class="col-sm-2 control-label">Transporte:</label>
                        <div class="col-sm-4 m-b-xs">
 					<select id="cboTransporte" class="form-control agenda">
                  <option value="--Seleccionar--" >--Seleccionar--</option>
            
			<%  
var sSQL = "SELECT TA_Transportista as Transportista "
+	"FROM TransferenciaAlmacen "
+	" WHERE TA_Transportista IS NOT NULL AND TA_Transportista <> '-1' "
+	" GROUP BY TA_Transportista "
+ "UNION "
+ "SELECT TA_Transportista2 as Transportista "
+	"FROM TransferenciaAlmacen "
+	" WHERE TA_Transportista2 IS NOT NULL AND TA_Transportista2 <> '-1' "
+	" GROUP BY TA_Transportista2 "
			var rsTsp = AbreTabla(sSQL,1,0)
			
			while (!rsTsp.EOF){
				var Transporte =  rsTsp.Fields.Item("Transportista").Value 
			
			%>
                  <option  value="<%=Transporte%>" ><%=Transporte%></option>
		  <%	
			 rsTsp.MoveNext() 
				}
			rsTsp.Close()   	
			%>
                        	</select>
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
                        <label class="col-sm-2 control-label">Ciudad:</label>
                        <div class="col-sm-4 m-b-xs">
					<select id="cboCiudad" class="form-control agenda">
                  <option value="--Seleccionar--" >--Seleccionar--</option>
            
			<%  
var sSQL = "SELECT Alm_Ciudad	FROM Almacen "
+"WHERE Alm_Ciudad IS NOT NULL " 
+"GROUP BY Alm_Ciudad "
+"Order by Alm_Ciudad "
			var rsCiudad = AbreTabla(sSQL,1,0)
			
			while (!rsCiudad.EOF){
				var Ciudad =  rsCiudad.Fields.Item("Alm_Ciudad").Value 
			
			%>
                  <option  value="<%=Ciudad%>" ><%=Ciudad%></option>
		  <%	
			 rsCiudad.MoveNext() 
				}
			rsCiudad.Close()   	
			%>
               	</select>
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
            
            <!-- div class="row">
                <div class="col-sm-12 m-b-xs">
                    <div class="row">
                        <label class="col-sm-2 control-label">Estatus:</label>
                        <div class="col-sm-4 m-b-xs">
                        </div>
                        <label class="col-sm-1 control-label"></label>
                        <div class="col-sm-3 m-b-xs">
                            
                        </div>

                    </div>    
                </div>
            </div -->
                    

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
         
         
                                 <input type = "hidden" class = "form-control agenda" value="<%=Man_ID%>" id="Man_ID"/>
                               

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
                      <label class="control-label col-md-3"><strong>Transportista</strong></label>
                <div class="col-md-3">
				<select id="Prov_ID" class="form-control agenda">
                             <option value="--Seleccionar--" >--Seleccionar--</option>
            
			<%  
var sSQL = "SELECT Prov_Nombre, Prov_ID FROM Proveedor WHERE Prov_EsPaqueteria= 1 "
			var rsTsp = AbreTabla(sSQL,1,0)
			
			while (!rsTsp.EOF){
				var Prov_ID =  rsTsp.Fields.Item("Prov_ID").Value 
				var Transporte =  rsTsp.Fields.Item("Prov_Nombre").Value 
			
			%>
                  <option  value="<%=Prov_ID%>" ><%=Transporte%></option>
		  <%	
			 rsTsp.MoveNext() 
				}
			rsTsp.Close()   	
			%>
                </select>
            </div>
            </div>
            <div class="form-group">
               <label class="control-label col-md-3"><strong>Folio Cliente</strong></label>
                <div class="col-md-3">
                
			<input class="form-control agenda" id="Man_FolioCliente" placeholder="Folio" type="text" autocomplete="off" value=""/>
				</div>
                      <label class="control-label col-md-3"><strong>Ruta</strong></label>
                <div class="col-md-3">
				<select id="Man_Ruta" class="form-control agenda">
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
            </div>
            <div class="form-group">
               <label class="control-label col-md-3"><strong>Tipo de Ruta</strong></label>
                <div class="col-md-3">
                
		<select id="Cat_ID" class="form-control agenda">
                             <option value="--Seleccionar--" >--Seleccionar--</option>
            
			<%  
var sSQL = "SELECT Cat_Nombre, Cat_ID FROM Cat_Catalogo WHERE Sec_ID = 94"

			var rsTRuta = AbreTabla(sSQL,1,0)
			
			while (!rsTRuta.EOF){
				var Cat_ID =  rsTRuta.Fields.Item("Cat_ID").Value 
				var Cat_Nombre =  rsTRuta.Fields.Item("Cat_Nombre").Value 

			%>
                  <option  value="<%=Cat_ID%>" ><%=Cat_Nombre%></option>
		  <%	
			 rsTRuta.MoveNext() 
				}
			rsTRuta.Close()   	
			%>
                </select>
             </div>
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
                  <option  value="<%=Edo_ID%>" ><%=Edo_Nombre%></option>
		  <%	
			 rsEdo.MoveNext() 
				}
			rsEdo.Close()   	
			%>
                </select>
            </div>
            </div>
            <div class="form-group">
               <label class="control-label col-md-3"><strong>Aeropuerto</strong></label>
                <div class="col-md-3">
                
		<select id="Aer_ID" class="form-control agenda">
                             <option value="--Seleccionar--" >--Seleccionar--</option>
            
			<%  
var sSQL = "SELECT al.Aer_ID, CASE  " 
+	" WHEN al.Aer_ID = -1 THEN '' " 
+	" WHEN al.Aer_ID = 0 THEN 'DIRECTO' "
+	" WHEN al.Aer_ID > 0 THEN (select Aer_NombreAG FROM Cat_Aeropuerto  ap WHERE ap.Aer_ID = al.Aer_ID) "
+	" END AS Aeropuerto "
+	" FROM Almacen al WHERE  al.Aer_ID <> 6 AND  al.Aer_ID <> '-1' "
+	" GROUP BY al.Aer_ID "
		var 	rsAer = AbreTabla(sSQL,1,0)
			
			while (!rsAer.EOF){
				var Aer_ID =  rsAer.Fields.Item("Aer_ID").Value 
				var Aeropuerto =  rsAer.Fields.Item("Aeropuerto").Value 
			
			%>
                  <option  value="<%=Aer_ID%>" ><%=Aeropuerto%></option>
		  <%	
			 rsAer.MoveNext() 
				}
			rsAer.Close()   	
			%>
                </select>
             </div>
                    
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
     $("#dvFiltros").hide()
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
                dato['cboAeropuerto'] = $('#cboAeropuerto').val()
                dato['Transporte'] = $('#cboTransporte').val()
                dato['Ruta'] = $('#cboRuta').val()
                dato['Ciudad'] = $('#cboCiudad').val()
                dato['FechaInicio'] = $('#inicio').val()
                dato['FechaFin'] = $('#fin').val()

         $("#dvTabla").load("/pz/wms/Salidas/ArmadoManifiestoTA_Grid.asp",dato);

	   });
    	$('#BtnMnf').click(function(e){
				var suma = parseInt($("#lblManifiesto").text()) +1
						$("#lblManifiesto").text(suma)
						$("#inputManifiesto").val(suma)
		});
			$('#BtnGMnf').click(function(e){
					$('#MyBatmanModal').modal('show') 

		});
		$('#BtnGuardar').click(function(e){
	$.post("/pz/wms/Salidas/ArmadoManifiestoTA_grid.asp",
					{Man_ID:$("#inputManifiesto").val(),
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
					Tarea:2,
					Man_ID:<%=Man_ID%>
					
					}
					,	 function(data){
						
					
					});
						$('#MyBatmanModal').modal('hide') 
			
						 $("#dvFiltros").show()
						 			CargaGridInicial()
									$('#BtnCMnf').css('display','block')
		});
    function CargaGridInicial(){
 	var sDatos = "Tarea=" + 0
        $("#dvTabla").load("/pz/wms/Salidas/ArmadoManifiestoTA_Grid.asp?"+ sDatos)

    }
   			
		  function CargaTA(event, taid){
			  var keyNum = event.which || event.keyCode;
		  
		if( keyNum== 13 ){
    	var sDatos = "TA_ID=" +  $("#inputTA").val();
	}else{
		var sDatos = "TA_ID=" + taid;	 
	}
		sDatos += "Man_ID = "+ $("#lblManifiesto").text();
	
		$("#dvTabla").load("/pz/wms/Salidas/ArmadoManifiestoTA_grid.asp?" + sDatos)
	
	}	
		$('#BtnCMnf').click(function(e){
			var Man_ID = parseInt($("#Man_ID").val()) +1
			
			var data={
				Man_ID:Man_ID
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

	
  
    
  
</script>




