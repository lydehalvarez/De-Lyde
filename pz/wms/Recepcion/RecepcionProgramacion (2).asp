<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->

<%

var TA_ID = Parametro("TA_ID",-1)
var CliOC_ID = Parametro("CliOC_ID",-1)
var OC_ID = Parametro("OC_ID",-1)
var Prov_ID = Parametro("Prov_ID",-1)
var CliEnt_ID = Parametro("CliEnt_ID", -1)
var ProvEnt_ID = Parametro("ProvEnt_ID", -1)
var Cli_ID = Parametro("Cli_ID", -1)
	var sSQLSer = "SELECT  * "
		sSQLSer += "FROM Inventario_Recepcion "
		
		bHayParametros = false
		ParametroCargaDeSQL(sSQLSer,0)
		
		var sSQLRec = "SELECT COUNT(IR_ID) as Citas "
		sSQLRec += ", CONVERT(VARCHAR(17), getdate(), 103) AS Hoy "
		sSQLRec += ", CONVERT(VARCHAR(17), getdate()+1, 103) AS Maniana "
		sSQLRec += "FROM Inventario_Recepcion "
		sSQLRec += " WHERE IR_EstatusCG52 = 1 "
		
	var rsRec = AbreTabla(sSQLRec,1,0)

	var NumCitas = 0
	if(!rsRec.EOF){
		var Hoy = rsRec.Fields.Item("Hoy").Value
		var Maniana = rsRec.Fields.Item("Maniana").Value
		NumCitas = rsRec.Fields.Item("Citas").Value
	}
	
				 if(TA_ID > -1){
			var selecciona = "Transferencia"
			var ProvCli = "Cliente"
			var ssql = "SELECT * FROM  inventario_Recepcion r INNER JOIN TransferenciaAlmacen t ON r.TA_ID=c.TA_ID" 
		     ssql += " INNER JOIN Cliente c ON c.Cli_ID=t.Cli_ID where t.TA_ID=" + TA_ID
			
			var rsCliente = AbreTabla(ssql,1,0)
				if (!rsCliente.EOF){
	        var IR_Folio =  rsCliente.Fields.Item("TA_Folio").Value
				}
		
				} if(OC_ID > -1){ 
				var selecciona = "Orden de Compra"
					var  ProvCli = "Proveedor"
		var ssql = "SELECT * FROM  inventario_Recepcion r "
		   ssql += " INNER JOIN  Proveedor_OrdenCompra o ON r.OC_ID=o.OC_ID INNER JOIN Proveedor p ON p.Prov_ID=o.Prov_ID where o.OC_ID=" + OC_ID
			
			var rsCliente = AbreTabla(ssql,1,0)
			if (!rsCliente.EOF){
             var IR_Folio =  rsCliente.Fields.Item("OC_Folio").Value
		
			}
				}if(CliOC_ID > -1){ 
					var selecciona = "Orden de Compra"
					var  ProvCli = "Cliente"
		var ssql = "SELECT * FROM  inventario_Recepcion r  "
		     ssql += " INNER JOIN Cliente_OrdenCompra o ON r.CliOC_ID=o.CliOC_ID INNER JOIN Cliente c ON c.Cli_ID=o.Cli_ID where o.CliOC_ID=" + CliOC_ID
			
			var rsCliente = AbreTabla(ssql,1,0)
				if (!rsCliente.EOF){
             var IR_Folio =  rsCliente.Fields.Item("CliOC_Folio").Value
				}
		
				}
				
				
%>
    <%

			
var PalletsTotales = 0
var Cantidad_Art = 0
var MinutosPallet = 0
	if(OC_ID > -1){
	var sSQL = "SELECT p.Prov_Nombre, c.Prov_ID, a.Pro_ID, c.OC_Folio, a.OCP_SKU, OCP_Cantidad as articulos FROM Proveedor_OrdenCompra c INNER   "
 sSQL += "JOIN Proveedor_OrdenCompra_Articulos  a ON c.OC_ID = a.OC_ID  INNER JOIN Proveedor p ON p.Prov_ID=c.Prov_ID  WHERE c.Prov_ID= "+Prov_ID+" AND a.OC_ID = "+OC_ID
   var rsArt = AbreTabla(sSQL,1,0)
 
   	   if (!rsArt.EOF){
	var Folio =  rsArt.Fields.Item("OC_Folio").Value
	 var Proveedor = rsArt.Fields.Item("Prov_Nombre").Value
	   }
	}
	if(CliOC_ID > -1){
	var sSQL = "SELECT c.Cli_ID, a.Pro_ID, c.CliOC_Folio, a.ClIOCP_SKU, CliOCP_Cantidad as articulos, cl.Cli_Nombre FROM Cliente_OrdenCompra c INNER JOIN  "
	   sSQL += "Cliente_OrdenCompra_Articulos  a ON c.CliOC_ID = a.CliOC_ID AND c.Cli_ID = a.Cli_ID  INNER JOIN Cliente cl ON cl.Cli_ID=c.Cli_ID WHERE a.Cli_ID = "+Cli_ID+" AND a.CliOC_ID = "+CliOC_ID

   var rsArt = AbreTabla(sSQL,1,0)
	var Folio =  rsArt.Fields.Item("CliOC_Folio").Value
	var Cli_ID = rsArt.Fields.Item("Cli_ID").Value
	var Cliente = rsArt.Fields.Item("Cli_Nombre").Value
		}
		if(TA_ID>-1){
	var sSQL = "SELECT t.Cli_ID, c.Cli_Nombre, a.Pro_ID, t.TA_Folio, a.TAA_SKU, TAA_Cantidad  as articulos FROM TransferenciaAlmacen t INNER JOIN  "
		  sSQL += " TransferenciaAlmacen_Articulos  a ON t.TA_ID = a.TA_ID  INNER JOIN Cliente c ON c.Cli_ID=t.Cli_ID where t.TA_ID=" + TA_ID 
		  sSQL += "WHERE a.TA_ID = "+TA_ID
			   var rsArt = AbreTabla(sSQL,1,0)
				var Folio =  rsArt.Fields.Item("TA_Folio").Value
				var Cli_ID = rsArt.Fields.Item("Cli_ID").Value
				var Cliente = rsArt.Fields.Item("Cli_Nombre").Value
	}
		if (CliOC_ID>-1 || OC_ID>-1 || TA_ID>-1){
	    while (!rsArt.EOF){
			var Pro_ID = rsArt.Fields.Item("Pro_ID").Value
			if(OC_ID>-1){
	
			}else{
			var Cli_ID = rsArt.Fields.Item("Cli_ID").Value
			}
				var Articulos_Rest = rsArt.Fields.Item("articulos").Value
				
				   var rsActivos = AbreTabla(sSQL,1,0) 
				   
				if(OC_ID>-1){
		sSQL = "SELECT  r.Pro_Cantidad, r.Pro_ProdRelacionado FROM  Producto_Proveedor c INNER JOIN Producto p  INNER JOIN"
		sSQL += " Producto_Relacion r ON  p.Pro_ID = r.Pro_ID ON c.Pro_ID = p.Pro_ID WHERE  (c.Prov_ID= "+Prov_ID+") AND (r.Pro_ID = "+Pro_ID+") "
			}else{
				sSQL = "SELECT  r.Pro_Cantidad, r.Pro_ProdRelacionado FROM  Producto_Cliente c INNER JOIN Producto p INNER JOIN Producto_Relacion r ON  "
				sSQL += " p.Pro_ID = r.Pro_ID ON c.Pro_ID = p.Pro_ID WHERE  (c.Cli_ID = "+Cli_ID+") AND (r.Pro_ID = "+Pro_ID+") "
			}
				   var rsActivos = AbreTabla(sSQL,1,0)
				   if (!rsActivos.EOF){
				    var Cantidad_MB= rsActivos.Fields.Item("Pro_Cantidad").Value
				 while (!rsActivos.EOF){
					 	 var Cantidad_Pallet= rsActivos.Fields.Item("Pro_Cantidad").Value
						 var Pallet_ID =  rsActivos.Fields.Item("Pro_ProdRelacionado").Value 
				sSQL = "SELECT Pro_DescargaPallet FROM Producto WHERE Pro_ID = "+Pallet_ID
				   var rsTiempoxPallet = AbreTabla(sSQL,1,0)
				  var TiempoxPallet =  rsTiempoxPallet.Fields.Item("Pro_DescargaPallet").Value
					   rsActivos.MoveNext() 
                                    }
                                    rsActivos.Close()   	
									var Cantidad_MBTotal = Math.round(Articulos_Rest/Cantidad_MB)
									var Cantidad_PalletTotal =  Cantidad_MBTotal/Cantidad_Pallet
									
									 MinutosPallet += (Cantidad_PalletTotal * TiempoxPallet)
				   }
					   rsArt.MoveNext() 
                                    }
                                  	 rsArt.Close()   	
									
									
									
			
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
       <!--                    <span class="pull-right"> <a  class="text-muted btnImprimeRecep"><i class="fa fa-print"></i>&nbsp;<strong>Imprimir entregas de hoy</strong></a>&nbsp;|&nbsp;(<strong><%=NumCitas%></strong>) Citas</span>-->
                </div>
                <div class="ibox-content">
                    <div id='external-events'>
                        <p>  <div id="Folio"><strong>Folio: <%=IR_Folio%></strong></div>
                        </p>
                        <p>&nbsp;</p>
                      <strong>Citas Programadas:</strong>
                       <p>&nbsp;</p>
                        <%
						if (CliOC_ID>-1 || OC_ID>-1 || TA_ID>-1){
						while(!rsCliente.EOF){
							var IR_ID =  rsCliente.Fields.Item("IR_ID").Value
							 var IR_FechaEntrega =  rsCliente.Fields.Item("IR_FechaEntrega").Value
							 var IR_Puerta =  rsCliente.Fields.Item("IR_Puerta").Value
							 var IR_Conductor =  rsCliente.Fields.Item("IR_Conductor").Value
							 var IR_Placas =  rsCliente.Fields.Item("IR_Placas").Value
							 var IR_DescripcionVehiculo =  rsCliente.Fields.Item("IR_DescripcionVehiculo").Value
							 var IR_Color =  rsCliente.Fields.Item("IR_Color").Value
							 var IR_Conductor =  rsCliente.Fields.Item("IR_Conductor").Value
							var IR_AlmacenRecepcion = rsCliente.Fields.Item("IR_AlmacenRecepcion").Value
						  
						  
						  	 IR_FechaEntrega = new Date(IR_FechaEntrega);
							var day = IR_FechaEntrega.getDate()
							var month = IR_FechaEntrega.getMonth()
							var year =  IR_FechaEntrega.getYear()		
								if( day < 10){
							day = 	"0"+ day
								}
							if( month < 10){
							month = 	"0"+ month
								}
							var IR_Fecha =  month + "/" +day + "/" + year		
							var Fecha = day + "/" + month + "/" + year	 + " "
							var horas = IR_FechaEntrega.getHours()
							var minutos = IR_FechaEntrega.getMinutes()
							var segundos =  IR_FechaEntrega.getSeconds()
							if( minutos < 10){
							minutos = 	"0"+ minutos
								}
							if( horas< 10){
							horas = 	"0"+ horas
								}
							if( segundos < 10){
							segundos = 	"0"+ segundos 
								}
							 var IR_Horario =  horas + ":" +minutos + ":" + segundos
							var Horario = horas + ":" +minutos + " horas"
							  
							 %>
                      
                           <button type="button" class="btn btn-primary" id="btnCita" onclick="javascript:CargaDatos(<%=IR_ID%>,'<%=IR_Conductor%>','<%=IR_Placas%>','<%=IR_DescripcionVehiculo%>',<%=IR_AlmacenRecepcion%>,'<%=IR_Color%>','<%=IR_Fecha%>','<%=IR_Horario%>','<%=IR_Puerta%>',<%=MinutosPallet%>)"><%=Fecha%><%=Horario%></button>
                           <%
						   	   rsCliente.MoveNext() 
                                    }
                                  	 rsCliente.Close()   	
						}
						   %>
                           
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
         
         
             <div class="form-group">
                <label class="control-label col-md-3"><strong><%=selecciona%></strong></label>
                    <div class="col-md-3">
             
						   	  <label  class= "control-label col-md-3"><strong><%=Folio%></strong></label>
                               <input class = "form-control agenda" type="text" value="<%=OC_ID%>"   id="OC_ID"/>
                               <input  class = "form-control agenda" type="text" value="<%=CliOC_ID%>" id="CliOC_ID"/>
                               <input class = "form-control agenda" type="text" value="<%=Prov_ID%>"  id="Prov_ID"/>
                                <input class = "form-control agenda" type="text" value="<%=TA_ID%>" id="TA_ID"/>
                               <input class = "form-control agenda" type="text" value="<%=Cli_ID%>"   id="Cli_ID"/>
                               <input class = "form-control agenda" type="text" value="<%=IR_Folio%>"  id="IR_Folio"/>
                               <input class = "form-control agenda" type="text" value="<%=IR_ID%>"  id="IR_ID"/>
                               <input class = "form-control agenda" type="text" value="<%=CliEnt_ID%>"  id="CliEnt_ID"/>
                               <input class = "form-control agenda" type="text" value="<%=ProvEnt_ID%>"  id="ProvEnt_ID"/>
                   </div>
                <label class="control-label col-md-3"><strong><%=ProvCli%></strong></label>
                    <div class="col-md-3">
                    <% if(OC_ID>-1){%>
                       <label class="control-label col-md-3"  value="<%=Prov_ID%>" id="Prov_ID"><strong><%=Proveedor%></strong></label>
                    <%}else{%>
                <label class="control-label col-md-3"  value="<%=Cli_ID%>" id="Cli_ID"><strong><%=Cliente%></strong></label>
                <%}%>
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
                  <option value="Blanco">Blanco</option>
                   <option value="Negro">Negro</option>
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
					 ssql = "SELECT * FROM Almacen "
					 if(OC_ID>-1){
		     ssql += "  where Prov_ID=" + Prov_ID+" AND Alm_TipoCG84 =1 AND Alm_Habilitado = 1"
					 }else{
		     ssql += "  where Cli_ID=" + Cli_ID+" AND Alm_TipoCG84 =1 AND Alm_Habilitado = 1"
					 }
			 var rsAlm = AbreTabla(ssql,1,0)
			
					 while (!rsAlm.EOF){
						 var Alm_ID = rsAlm.Fields.Item("Alm_ID").Value
			var Alm_Nombre = rsAlm.Fields.Item("Alm_Nombre").Value
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
                    	<select id="IR_Puerta" data-min = "<%=MinutosPallet%>" class="form-control agenda">
                    <option value="R01">R01</option>
                  <option value="R02">R02</option>
                  <option value="R03">R03</option>
                  <option value="R04">R04</option>
                  <option value="R05">R05</option>
                  <option value="R06">R06</option>
                  <option value="R07">R07</option>
						</select>
            </div>
           </div>
                    <div class="form-group">
               <label class="control-label col-md-3"><strong>D&iacute;a cita</strong></label>
               <div class="col-md-3">
               <div class="input-group date">
                        <input class="form-control agenda"
                        id="IR_FechaEntrega" placeholder="dd/mm/aaaa" type="text" autocomplete="off"
                        value="" data-esfecha="1" readonly="readonly"> 
                        <span class="input-group-addon"><i class="fa fa-calendar"></i></span>
                    </div>
                    
                </div>
               <label class="control-label col-md-3"><strong>Hora inicio</strong></label>
                        <div class="col-md-3" id="dvHora">
                          <!--  <div class="input-group clockpicker" data-autoclose="true">
                         
                                <input class="form-control Hora Robin agenda" id="IR_Horario" type="text" autocomplete="off" placeholder="Abrir reloj"
                                value="">
                                <span class="input-group-addon"><span class="fa fa-clock-o"></span></span>
                            </div>-->
                        </div>
            </div>
            <%  
			if(CliOC_ID > -1){
			%>
			    <div class="form-group">  <label class="control-label col-md-3"><strong>Producto</strong></label>
                <div class="col-md-3">
				<select id="cbo_Producto" class="form-control agenda">
                  <option value="0">--Seleccionar--</option>
                    <%
					 ssql = "SELECT a.Pro_ID, p.ProC_Nombre FROM "
				     ssql += " Cliente_OrdenCompra_Articulos a INNER JOIN Producto_Cliente p ON p.Pro_ID=a.Pro_ID AND p.Cli_ID=a.Cli_ID where a.Cli_ID= "+Cli_ID+" AND CliOC_ID=" + CliOC_ID+" group by a.Pro_ID, p.ProC_Nombre"
	
Response.Write(ssql)
			 var rsPro = AbreTabla(ssql,1,0)
					 while (!rsPro.EOF){
			 var Pro_ID = rsPro.Fields.Item("Pro_ID").Value
			var ProC_Nombre = rsPro.Fields.Item("ProC_Nombre").Value
						 %>
                  <option value="<%=Pro_ID%>"><%=ProC_Nombre%></option>
				    <%	
				rsPro.MoveNext() 
					}
                rsPro.Close()  
		 
                %>
                </select>
            </div>
               <label class="control-label col-md-3"><strong>Cantidad</strong></label>
                <div class="col-md-3">
                <input class="form-control agenda" id="CliEnt_ArticulosRecibidos" placeholder="" type="text" autocomplete="off" value=""></input>
				</div>
                    
            </div>	
            <%
			}
			%>
              <div class="form-group" id="divEntrega">
              
              </div>
        </div>   
      </div>
      <div class="modal-footer">
        <button type="button"  class="btn btn-primary" id="BtnEntrega">Agregar Producto</button>
        <button type="button"  class="btn btn-primary" id="BtnAgendar"  data-min= "<%=MinutosPallet%>">Agendar</button>
        <button type="button" class="btn btn-primary" id="BtnActualizar" data-min= "<%=MinutosPallet%>">Actualizar</button>
        <button type="button" class="btn btn-danger" id="BtnCancelar"   data-min= "<%=MinutosPallet%>">Cancelar</button>
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
		  $("#Prov_ID").hide();
		 $("#CliOC_ID").hide();
		 $("#CliEnt_ID").hide();
		 $("#ProvEnt_ID").hide();
		 $("#TA_ID").hide();
		 $("#Cli_ID").hide();
		  $("#IR_Folio").hide();
		   $("#IR_ID").hide();

	  $('#IR_Puerta').change(function(e) {
        e.preventDefault()
		HorasDisp($(this).val(), $(this).data("min"),$('#IR_FechaEntrega').val())
    });
	function HorasDisp(puerta, minPallet, fecha){
	$.get("/pz/wms/Recepcion/Recepcion_Ajax.asp",{
		Tarea:5
		,IR_Puerta:puerta
		,TiempoPallet:minPallet
		,IR_FechaEntrega:fecha
	}
 , function(data){
		if (data != "") {
			$('#dvHora').html(data)
			}
		});
}
	$('#BtnCita').click(function(e) {
        e.preventDefault()
		 
		
		 
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
        datoAgenda['Cli_ID'] = $('#Cli_ID').val()
		datoAgenda['CliOC_ID'] = $('#CliOC_ID').val()
		datoAgenda['OC_ID'] = $('#OC_ID').val()
		datoAgenda['Prov_ID'] = $('#Prov_ID').val()
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
		datoAgenda['TiempoPallet'] = $(this).data("min")
		GuardaCita(datoAgenda)
		$('#MyBatmanModal').modal('hide') 
		//$('.agenda').val("")
    });
	$('#BtnActualizar').click(function(e) {

		var datoAgenda = {}
		$('.agenda').each(function(index, element) {
            datoAgenda[$(this).attr('id')] = $(this).val()
        });
		datoAgenda['Tarea'] = 2
		datoAgenda['IDUsuario'] = $('#IDUsuario').val()
        datoAgenda['Cli_ID'] = $('#Cli_ID').val()
		datoAgenda['CliOC_ID'] = $('#CliOC_ID').val()
		datoAgenda['OC_ID'] = $('#OC_ID').val()
		datoAgenda['Prov_ID'] = $('#Prov_ID').val()
		datoAgenda['TA_ID'] = $('#TA_ID').val()
		datoAgenda['IR_ID'] = $('#IR_ID').val()
		datoAgenda['IR_Folio'] = $('#IR_Folio').val()
	    datoAgenda['IR_Conductor'] = $('#IR_Conductor').val()
		datoAgenda['IR_Placas'] = $('#IR_Placas').val()
		datoAgenda['IR_DescripcionVehiculo'] = $('#IR_DescripcionVehiculo').val()
		datoAgenda['Alm_ID'] = $('#Alm_ID').val()
		datoAgenda['IR_Color'] = $('#IR_Color').val()
		datoAgenda['IR_FechaEntrega'] = $('#IR_FechaEntrega').val()
		datoAgenda['IR_Horario'] = $('#IR_Horario').val()
		datoAgenda['IR_Puerta'] = $('#IR_Puerta').val()
		datoAgenda['TiempoPallet'] = $(this).data("min")
		GuardaCita(datoAgenda)
		$('#MyBatmanModal').modal('hide') 
		//$('.agenda').val("")
    });
		$('#BtnEntrega').click(function(e) {
		var datoAgenda = {}
		datoAgenda['Tarea'] = 3
		datoAgenda['Pro_ID'] = $('#cbo_Producto').val()
	    datoAgenda['Cli_ID'] = $('#Cli_ID').val()
		 datoAgenda['CliEnt_ID'] = $('#CliEnt_ID').val()
		 datoAgenda['ProvEnt_ID'] = $('#ProvEnt_ID').val()
		datoAgenda['CliOC_ID'] = $('#CliOC_ID').val()
		datoAgenda['OC_ID'] = $('#OC_ID').val()
		datoAgenda['Prov_ID'] = $('#Prov_ID').val()
		datoAgenda['IR_ID'] = $('#IR_ID').val()
		datoAgenda['CliEnt_ArticulosRecibidos'] = $('#CliEnt_ArticulosRecibidos').val()
		$("#divEntrega").load("/pz/wms/Recepcion/Recepcion_Ajax.asp",datoAgenda);

  });

$('#BtnCancelar').click(function(e) {
		var datoAgenda = {}
		$('.agenda').each(function(index, element) {
            datoAgenda[$(this).attr('id')] = $(this).val()
        });
 datoAgenda['Tarea'] = 4
 	datoAgenda['IR_ID'] = $('#IR_ID').val()
		GuardaCita(datoAgenda)
		$('#MyBatmanModal').modal('hide') 
  });
	$('#Folio').click(function(e) {
	$('.Robin').attr('disabled',false)
				$('#FormDatosGen').modal('show')  

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
				$("#BtnAgendar").show();
				$("#BtnCancelar").hide();
				$("#BtnActualizar").hide();
				$("#IR_Puerta").val('--Seleccionar--');
				$("#IR_Horario").hide();
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
				$("#Contenido").load("/pz/wms/Recepcion/RecepcionProgramacion.asp")
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

	function CargaDatos(irid,conductor,placas,vehiculo,almacen,color,fecha,horario,puerta, minutos)	{
				$('#IR_ID').val(irid)
				$('#IR_Conductor').val(conductor)
				$('#IR_Placas').val(placas)
				 $('#IR_DescripcionVehiculo').val(vehiculo)
				$('#Alm_ID').val(almacen)
				$('#IR_Color').val(color)
				$('#IR_Puerta').val(puerta)
				$('#IR_FechaEntrega').val(fecha)	
				HorasDisp($('#IR_Puerta').val(),minutos,fecha)
				$('#IR_Horario').val(horario)
				$('#MyBatmanModal').modal('show')  
			   $("#BtnActualizar").show();
				$("#BtnCancelar").show();
				$("#BtnAgendar").hide();
		}
		function HorasDisp(puerta, minPallet, fecha){
	$.get("/pz/wms/Recepcion/Recepcion_Ajax.asp",{
		Tarea:5
		,IR_Puerta:puerta
		,TiempoPallet:minPallet
		,IR_FechaEntrega:fecha
	}
 , function(data){
		if (data != "") {
			$('#dvHora').html(data)
			}
		});
}
</script>
