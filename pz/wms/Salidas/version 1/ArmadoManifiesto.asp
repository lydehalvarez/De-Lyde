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
          <div class="ibox-title">
            <h5>Filtros de b&uacute;squeda</h5>
            <div class="ibox-tools">
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
          <input class="form-control TA"  id= "inputTA" style="display:none;width:100%" placeholder="escanea la transferencia" type="text" autocomplete="off" value="" onkeydown=
            "FunctionRecepcion.InsertTA(event);"/>
		<button type="button" class="btn btn-primary BtnMnf" id= "BtnGMnf"  style="display:none" onclick="DatosManifiesto()">
			Guardar manifiesto</button>           

		<button type="button" class="btn btn-primary BtnMnf" id= "BtnMnf"  style="display:none" onclick="NuevoManifiesto()">
			A&ntilde;adir manifiesto</button>           
            <%
						var Man_ID = BuscaSoloUnDato("ISNULL((MAX(Man_ID)),0)","Manifiesto_Salida","",-1,0)
			%>
               <label class="col-sm-2 control-label">Numero de manifiesto: </label> <label class="col-sm-2 control-label" id = "lblManifiesto"><%=Man_ID%></label>
          </div>
          <div class="ibox-content">
            <div class="row"> 
                <div class="col-sm-12 m-b-xs">        
                    <div class="row">
                         <label class="col-sm-2 control-label">Transporte:</label>
                        <div class="col-sm-4 m-b-xs">
 					<select id="cboTransporte" class="form-control agenda">
                  <option value="--Seleccionar--" >--Seleccionar--</option>
            
			<%  
var sSQL = "SELECT TA_Transportista as Transportista "
+=	"FROM TransferenciaAlmacen "
+=	" WHERE TA_Transportista IS NOT NULL AND TA_Transportista <> '-1' "
+=	" GROUP BY TA_Transportista "
+= "UNION "
+= "SELECT TA_Transportista2 as Transportista "
+=	"FROM TransferenciaAlmacen "
+=	" WHERE TA_Transportista2 IS NOT NULL AND TA_Transportista2 <> '-1' "
+=	" GROUP BY TA_Transportista2 "
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
                        <div class="col-sm-1 m-b-xs" style="text-align: left;">  
                          <button class="btn btn-success btn-sm" type="button" id="btnBuscar"><i class="fa fa-search"></i>&nbsp;&nbsp;<span class="bold">Buscar</span></button>
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
var sSQL = "SELECT  Edo_ID, Edo_Nombre From Cat_Estado"
			var rsEstado = AbreTabla(sSQL,1,0)
			
			while (!rsEstado.EOF){
				var Edo_ID =  rsEstado.Fields.Item("Edo_ID").Value 
				var Estado =  rsEstado.Fields.Item("Estado").Value 

			%>
                  <option  value="<%=Edo_ID%>" ><%=Edo_Nombre%></option>
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
+="WHERE Alm_Ciudad IS NOT NULL " 
+="GROUP BY Alm_Ciudad "
+="Order by Alm_Ciudad "
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
         
         
                                 <input type = "hidden" class = "form-control agenda" value="<%=TA_ID%>" id="TA_ID"/>
                               <input type = "hidden"  class = "form-control agenda"  value="<%=Cli_ID%>"   id="Cli_ID"/>

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
                
			<input class="form-control agenda" id="IR_DescripcionVehiculo" placeholder="Descripci&oacute;n de veh&iacute;culo" type="text" autocomplete="off" value=""/>
				</div>
                      <label class="control-label col-md-3"><strong>Color</strong></label>
                <div class="col-md-3">
				<select id="IR_Color" class="form-control agenda">
                  <option value="Blanco">Blanco</option>
                   <option value="Negro">Negro</option>
                  <option value="Azul">Azul</option>
                  <option value="Rojo">Rojo</option>
                  <option value="Verde">Verde</option>
                  <option value="Morado">Morado</option>
                </select>
            </div>
            </div>
            </div>	
            <%
			}
			%>
              
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

            <div class="table-responsive" id="dvTabla"></div>  
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
        
        
<input type="hidden" name="OV_ID" id="OV_ID" value="">     
<input id="inicio" type="hidden" value="" />
<input id="fin" type="hidden" value="" />
<!-- Date range use moment.js same as full calendar plugin -->
<script src="/Template/inspina/js/plugins/fullcalendar/moment.min.js"></script>

<!-- Date range picker -->
<script src="/Template/inspina/js/plugins/daterangepicker/daterangepicker.js"></script>

<script type="text/javascript">
        
$(document).ready(function(){
    
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

    
    CargaGridInicial()


      $("#btnBuscar").click(function(event) {

            var dato = {}
                dato['Lpp'] = 1  //este parametro limpia el cache
                dato['Transporte'] = $('#cboTransporte').val()
                dato['Estado'] = $('#cboEstado').val()
                dato['Ciudad'] = $('#cboCiudad').val()
                dato['FechaInicio'] = $('#inicio').val()
                dato['FechaFin'] = $('#fin').val()
            $("#dvTablaTranferencias").load("/pz/wms/Salidas/ArmadoManifiestoOV_Grid.asp",dato);
	   }); 
});    
    
    function CargaGridInicial(){

        $("#dvTablaTranferencias").load("/pz/wms/Salidas/ArmadoManifiestoOV_Grid.asp");

    }
 
     	var FunctionManifiesto = {
			InsertMnf:function(){
				
					$.ajax({
    method: "POST",
    url: "/pz/wms/Salidas/ArmadoManifiestoOV_Grid.asp?",
    data: {OV_ID:<%=OV_ID%>, 
				Tarea:1
		},
    cache: false,
    success: function (data) {
			var response = JSON.parse(data)
			var Tipo = ""
			if(response.result == 1){
				Tipo = "success"

			}
		
			 if(response.result == 0){
				Tipo = "error"
			}
				
			
			Avisa(Tipo,"Aviso",response.message);
			
	}
		});	
		NuevoManifiesto:function(){
				var suma = parseInt($("#lblMnf").text()) +1
						$("#lblMnf").html(suma)
		});	       
</script>




