<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->


<%
var Pt_ID = Parametro("Pt_ID",-1)
var Pro_ID = Parametro("Pro_ID",-1)
var Digitos = Parametro("Digitos",-1)
var IR_ID = Parametro("IR_ID",-1)
var MB = Parametro("MB", -1)
var MB_Cantidad = Parametro("MB_Cantidad", -1)
var Tarea =  Parametro("Tarea",-1)	

	 switch (parseInt(Tarea)) {
case 1:
 sSQL = "SELECT s.Pt_ID, MB_Numero, MB_Incidencia, MB_RayX, MB_Cantidad, ( SELECT COUNT(*) FROM Recepcion_Series rs WHERE Ser_MB = MB_Numero AND rs.Pt_ID = s.Pt_ID) as Series FROM Recepcion_Masterbox s INNER JOIN Recepcion_Pallet p ON  p.Pt_ID=s.Pt_ID WHERE  s.Pt_ID="+Pt_ID+" group by  s.Pt_ID, s.MB_Numero, MB_Incidencia, MB_RayX, MB_Cantidad  "
 var rsLinea1 = AbreTabla(sSQL,1,0)
//  sSQL = "SELECT s.Pt_ID, MB_Numero, MB_Incidencia, MB_RayX FROM Recepcion_Masterbox s INNER JOIN Recepcion_Pallet p ON  p.Pt_ID=s.Pt_ID WHERE Pt_Linea = 2 AND  s.Pt_ID="+Pt_ID+" group by  s.Pt_ID, s.MB_Numero, MB_Incidencia, MB_RayX  "
// var rsLinea2 = AbreTabla(sSQL,1,0)
// sSQL = "SELECT s.Pt_ID, MB_Numero, MB_Incidencia, MB_RayX FROM Recepcion_Masterbox s INNER JOIN Recepcion_Pallet p ON  p.Pt_ID=s.Pt_ID WHERE  Pt_Linea = 3 AND  s.Pt_ID="+Pt_ID+" group by  s.Pt_ID, s.MB_Numero, MB_Incidencia, MB_RayX  "
// var rsLinea3 = AbreTabla(sSQL,1,0)
// sSQL = "SELECT s.Pt_ID, MB_Numero, MB_Incidencia, MB_RayX FROM Recepcion_Masterbox s INNER JOIN Recepcion_Pallet p ON  p.Pt_ID=s.Pt_ID WHERE Pt_Linea = 4 AND   s.Pt_ID="+Pt_ID+" group by  s.Pt_ID, s.MB_Numero, MB_Incidencia, MB_RayX  "
// var rsLinea4 = AbreTabla(sSQL,1,0)
// sSQL = "SELECT s.Pt_ID, MB_Numero, MB_Incidencia, MB_RayX FROM Recepcion_Masterbox s INNER JOIN Recepcion_Pallet p ON  p.Pt_ID=s.Pt_ID WHERE  Pt_Linea = 5 AND  s.Pt_ID="+Pt_ID+" group by  s.Pt_ID, s.MB_Numero, MB_Incidencia, MB_RayX  "
// var rsLinea5 = AbreTabla(sSQL,1,0)
 
			
                %>
     		<td class="desc"> <strong>Masterbox</strong>&nbsp;   
                                        <%
							 while (!rsLinea1.EOF){     
						 	var Pt_ID = rsLinea1.Fields.Item("Pt_ID").Value
							var MB = rsLinea1.Fields.Item("MB_Numero").Value
							var MB_Incidencia = rsLinea1.Fields.Item("MB_Incidencia").Value
							var MB_RayX = rsLinea1.Fields.Item("MB_RayX").Value
							var MB_Cantidad = rsLinea1.Fields.Item("MB_Cantidad").Value
							
//						sSQL = "SELECT COUNT(*) AS Series FROM Recepcion_Series "
//								  + " WHERE Pt_ID ="+Pt_ID+" AND Ser_MB="+ MB
//						 var rsSeriesMB = AbreTabla(sSQL,1,0)
						 var Series = rsLinea1.Fields.Item("Series").Value
						   
 if(MB_Incidencia == 0 && MB_RayX==0 && Series==MB_Cantidad){
                                    %>		
<button type="button"  class="btn btn-primary" id="BtnMB<%=Pt_ID%><%=MB%>"  data-ptid="<%=Pt_ID%>"  data-mb = "<%=MB%>"  onclick="javascript:CargaSeries(<%=Pt_ID%>,<%=MB%>)"><%=MB%>&nbsp;<span class="label label-danger">
<%
if(Series>0){
%>
								   <%=Series%>
<%
}
%>
				                </span></button> 	 
  				<%
				}else if(MB_RayX == 1&& Series==MB_Cantidad){
	%>
<button type="button"  class="btn btn-warning" id="BtnMB<%=Pt_ID%><%=MB%>"  data-ptid="<%=Pt_ID%>"  data-mb = "<%=MB%>" onclick="javascript:CargaSeries(<%=Pt_ID%>,<%=MB%>)"><%=MB%>&nbsp;<span class="label label-danger">
<%
if(Series>0){
%>
								   <%=Series%>
<%
}
%>
				                </span></button> 	 
    <%			
				}else if(MB_Incidencia == 0||Series<MB_Cantidad){
				%>
<button type="button"  class="btn btn-danger" id="BtnMB<%=Pt_ID%><%=MB%>"  data-ptid="<%=Pt_ID%>"  data-mb = "<%=MB%>" onclick="javascript:CargaSeries(<%=Pt_ID%>,<%=MB%>)"><%=MB%>&nbsp;<span class="label label-danger">
<%
if(Series>0){
%>
								   <%=Series%>
<%
}
%>
				                </span></button> 	 
                                    <%	
  				}
                                    rsLinea1.MoveNext() 
                                    }
                                    rsLinea1.Close()   
                                    %>
          </td>
<%/*%>                                    <td class="desc">
                                
                                    <%
							 while (!rsLinea2.EOF){     
 							var Pt_ID = rsLinea2.Fields.Item("Pt_ID").Value
							var MB = rsLinea2.Fields.Item("MB_Numero").Value
							var MB_Incidencia = rsLinea2.Fields.Item("MB_Incidencia").Value
							var MB_RayX = rsLinea2.Fields.Item("MB_RayX").Value
				 if(MB_Incidencia == 0 && MB_RayX==0){
                                    %>		
<button type="button"  class="btn btn-primary" id="BtnMB<%=Pt_ID%><%=MB%>"  data-ptid="<%=Pt_ID%>"  data-mb = "<%=MB%>"  onclick="javascript:CargaSeries(<%=Pt_ID%>,<%=MB%>)"><%=MB%></button>
  				<%
				}if(MB_RayX == 1){
	%>
<button type="button"  class="btn btn-warning" id="BtnMB<%=Pt_ID%><%=MB%>"  data-ptid="<%=Pt_ID%>"  data-mb = "<%=MB%>" onclick="javascript:CargaSeries(<%=Pt_ID%>,<%=MB%>)"><%=MB%></button>
    <%			
				} if(MB_Incidencia == 1){
				%>
<button type="button"  class="btn btn-danger" id="BtnMB<%=Pt_ID%><%=MB%>"  data-ptid="<%=Pt_ID%>"  data-mb = "<%=MB%>" onclick="javascript:CargaSeries(<%=Pt_ID%>,<%=MB%>)"><%=MB%></button>
                                    <%	
  				}
                                  
                                    rsLinea2.MoveNext() 
                                    }
                                    rsLinea2.Close()   
                                    %>
                                    </td>
                                <td class="desc">
                                
                                    <%
							 while (!rsLinea3.EOF){    
							var Pt_ID = rsLinea3.Fields.Item("Pt_ID").Value
							var MB = rsLinea3.Fields.Item("MB_Numero").Value 
							var MB_Incidencia = rsLinea3.Fields.Item("MB_Incidencia").Value
							var MB_RayX = rsLinea3.Fields.Item("MB_RayX").Value
					 if(MB_Incidencia == 0 && MB_RayX==0){
                                    %>		
<button type="button"  class="btn btn-primary" id="BtnMB<%=Pt_ID%><%=MB%>"  data-ptid="<%=Pt_ID%>"  data-mb = "<%=MB%>"  onclick="javascript:CargaSeries(<%=Pt_ID%>,<%=MB%>)"><%=MB%></button>
  				<%
				}if(MB_RayX == 1){
	%>
<button type="button"  class="btn btn-warning" id="BtnMB<%=Pt_ID%><%=MB%>"  data-ptid="<%=Pt_ID%>"  data-mb = "<%=MB%>" onclick="javascript:CargaSeries(<%=Pt_ID%>,<%=MB%>)"><%=MB%></button>
    <%			
				} if(MB_Incidencia == 1){
				%>
<button type="button"  class="btn btn-danger" id="BtnMB<%=Pt_ID%><%=MB%>"  data-ptid="<%=Pt_ID%>"  data-mb = "<%=MB%>" onclick="javascript:CargaSeries(<%=Pt_ID%>,<%=MB%>)"><%=MB%></button>
                                    <%	
  				}
                                        rsLinea3.MoveNext() 
                                    }
                                    rsLinea3.Close()   
                                    %>
                                    </td>
                                    <td class="desc">
                                
                                    <%
							 while (!rsLinea4.EOF){ 
							 var Pt_ID = rsLinea4.Fields.Item("Pt_ID").Value
							var MB = rsLinea4.Fields.Item("MB_Numero").Value  
							var MB_Incidencia = rsLinea4.Fields.Item("MB_Incidencia").Value
							var MB_RayX = rsLinea4.Fields.Item("MB_RayX").Value
   				 if(MB_Incidencia == 0 && MB_RayX==0){
                                    %>		
<button type="button"  class="btn btn-primary" id="BtnMB<%=Pt_ID%><%=MB%>"  data-ptid="<%=Pt_ID%>"  data-mb = "<%=MB%>"  onclick="javascript:CargaSeries(<%=Pt_ID%>,<%=MB%>)"><%=MB%></button>
  				<%
				}if(MB_RayX == 1){
	%>
<button type="button"  class="btn btn-warning" id="BtnMB<%=Pt_ID%><%=MB%>"  data-ptid="<%=Pt_ID%>"  data-mb = "<%=MB%>" onclick="javascript:CargaSeries(<%=Pt_ID%>,<%=MB%>)"><%=MB%></button>
    <%			
				} if(MB_Incidencia == 1){
				%>
<button type="button"  class="btn btn-danger" id="BtnMB<%=Pt_ID%><%=MB%>"  data-ptid="<%=Pt_ID%>"  data-mb = "<%=MB%>" onclick="javascript:CargaSeries(<%=Pt_ID%>,<%=MB%>)"><%=MB%></button>
                                    <%	
  				}
                                    rsLinea4.MoveNext() 
                                    }
                                    rsLinea4.Close()   
                                    %>
                                    </td>
					     <td class="desc">
                                <%
							 while (!rsLinea5.EOF){ 
							var Pt_ID = rsLinea5.Fields.Item("Pt_ID").Value
							var MB = rsLinea5.Fields.Item("MB_Numero").Value   
							var MB_Incidencia = rsLinea5.Fields.Item("MB_Incidencia").Value
							var MB_RayX = rsLinea5.Fields.Item("MB_RayX").Value
  					 if(MB_Incidencia == 0 && MB_RayX==0){
                                    %>		
<button type="button"  class="btn btn-primary" id="BtnMB<%=Pt_ID%><%=MB%>"  data-ptid="<%=Pt_ID%>"  data-mb = "<%=MB%>"  onclick="javascript:CargaSeries(<%=Pt_ID%>,<%=MB%>)"><%=MB%></button>
  				<%
				}if(MB_RayX == 1){
	%>
<button type="button"  class="btn btn-warning" id="BtnMB<%=Pt_ID%><%=MB%>"  data-ptid="<%=Pt_ID%>"  data-mb = "<%=MB%>" onclick="javascript:CargaSeries(<%=Pt_ID%>,<%=MB%>)"><%=MB%></button>
    <%			
				} if(MB_Incidencia == 1){
				%>
<button type="button"  class="btn btn-danger" id="BtnMB<%=Pt_ID%><%=MB%>"  data-ptid="<%=Pt_ID%>"  data-mb = "<%=MB%>" onclick="javascript:CargaSeries(<%=Pt_ID%>,<%=MB%>)"><%=MB%></button>
                                    <%	
  				}
                                        rsLinea5.MoveNext() 
                                    }
                                    rsLinea5.Close()   
                                    %>
                                    </td>    
                             <%*/%>
                             <%
							  break;
							  
	 case 2:

sSQL = "SELECT s.Ser_Serie, s.Ser_Incidencia, s.Pro_ID, p.Pt_LPN FROM Recepcion_Series s INNER JOIN Recepcion_Pallet p ON  p.Pt_ID=s.Pt_ID WHERE  s.Ser_SerieEscaneada = 1 AND s.Pt_ID="+Pt_ID+" AND s.Ser_MB="+MB+" group by s.Ser_Serie, s.Ser_Incidencia, s.Pro_ID, p.Pt_LPN "
//Response.Write(sSQL)
 var rsSeries = AbreTabla(sSQL,1,0)
var series = rsSeries.RecordCount
                %>
                              <table class="table shoping-cart-table">
                               <thead>
<th>

<%
if(!rsSeries.EOF){
%>
<button type="button"  class="btn btn-success" id="BtnImprimirLPN"   data-ptlpn="<%=rsSeries.Fields.Item("Pt_LPN").Value%>">Imprimir LPN</button><br /><br />
<%
}
%>

<button type="button"  class="btn btn-danger" id="BtnElimMB"  data-ptid="<%=Pt_ID%>"  data-mb = "<%=MB%>" onclick="javascript:EliminarMB(<%=Pt_ID%>,<%=MB%>)">Eliminar Series</button><br /><br />
 <button type="button"  class="btn btn-danger" id="BtnModifMB" onclick="javascript:MuestraCantidad()">Modificar Masterbox</button><br /><br />
           	<input class="form-control inputMB"  id="inputMB" style="display:none;width:55%" placeholder="cantidad" type="text" autocomplete="off" value="" onkeydown="ModificarMB(event);"/><br />
 <button type="button"  class="btn btn-danger" id="BtnModifSerie" onclick="javascript:MuestraDigitos()">Largo de serie</button><br /><br />
           	<input class="form-control inputDigitos"  id="inputDigitos" style="display:none;width:55%" placeholder="digitos" type="text" autocomplete="off" value="" onkeydown="CambiaSerie(event);"/><br />

<!--<button type="button"  class="btn btn-success"  onclick="javascript:ExportaExcel()">Exportar series</button><br /><br />
--><input type="hidden" value="<%=Pt_ID%>" class="agenda" id="Pt_ID"/>
<input type="hidden" value="<%=MB%>" class="agenda" id="MB"/>
<%
if(!rsSeries.EOF){
%>

<input type="hidden" value="<%=rsSeries.Fields.Item("Pro_ID").Value%>" class="agenda" id="Pro_ID"/>
<%
}
%>

<%=series%> Series 

</th>
</thead>
<tbody>    
                                        <%
							 while (!rsSeries.EOF){     
						 	var Serie = rsSeries.Fields.Item("Ser_Serie").Value
					                      %>		
                                             <tr>
                                    <td class="desc">
                                    <%
									if(rsSeries.Fields.Item("Ser_Incidencia").Value==1){
									%>
        					<p style="color:red;"><%=Serie%></p>
                            <%	}else{	%>
                            <%=Serie%>
                            <% } %>
                              </td>	</tr>	
                                    <%	
                                    rsSeries.MoveNext() 
                                    }
                                    rsSeries.Close()   
                                    %>
                               	</tbody>
                                </table>		
						<%
						break;	
		// !! PRECAUCION!! ESTO SUBE TODA LA RECEPCION A INVENTARIO  
		case 3: {
//		var sSQL = "SELECT TOP (1) * FROM Recepcion_Series s "
//						+" INNER JOIN Recepcion_Pallet p ON p.Pt_ID = s.Pt_ID "
//						+ " INNER JOIN Inventario_Recepcion r ON p.IR_ID=r.IR_ID"
//						+ " WHERE IR_ID = "+ IR_ID
//		 var rsSeries = AbreTabla(sSQL,1,0)
//		var Pro_ID = rsSeries.Fields.Item("Pro_ID").Value
//	
//		if(!rsSeries.EOF){
//			sSQL = "SELECT Pro_EsSerializado FROM Producto WHERE Pro_ID = "+Pro_ID	
//		 	var rsTPro = AbreTabla(sSQL,1,0)
//			
//			 if(rsTPro.Fields.Item("Pro_EsSerializado").Value == 0){
//			// INGRESO DE PRODUCTO CON SERIES ESCANEADAS Y NO SERIALIZADO 
//		sSQL = "	UPDATE Producto SET Pro_EsSerializado = 1 SET WHERE Pro_ID = "+Pro_ID	
//			Ejecuta(sSQL, 0)	
//
//		var sSQL="UPDATE Inventario_Recepcion SET IR_EstatusCG52 = 21, "
//						+" IR_IngresoFecha = getdate(), IR_IngresoResultado=1 WHERE IR_ID ="+IR_ID
//			bolNoEsError = Ejecuta(sSQL, 0)// ESTE QUERY INGRESA LAS SERIES A INVENTARIO
//
//		sSQL = "	UPDATE Producto SET Pro_EsSerializado = 0 SET WHERE Pro_ID = "+Pro_ID	
//			Ejecuta(sSQL, 0)	
//
//			}else{ // INGRESO DE PRODUCTO CON SERIES ESCANEADAS Y SERIALIZADO
//			
//			var sSQL="UPDATE Inventario_Recepcion SET IR_EstatusCG52 = 21, "
//						+" IR_IngresoFecha = getdate(), IR_IngresoResultado=1 WHERE IR_ID ="+IR_ID
//			bolNoEsError = Ejecuta(sSQL, 0)// ESTE QUERY INGRESA LAS SERIES A INVENTARIO
//			}
//		}else{ //INGRESO DE PRODUCTO SIN SERIES ESCANEADAS Y NO SERIALIZADO
			
			var sSQL="UPDATE Inventario_Recepcion SET IR_EstatusCG52 = 21, "
						+" IR_IngresoFecha = getdate(), IR_IngresoResultado=1 WHERE IR_ID ="+IR_ID
			bolNoEsError = Ejecuta(sSQL, 0)// ESTE QUERY INGRESA LAS SERIES A INVENTARIO
//		}
						

			//extrae el listado de los registros que se ingresaron

			var sqlRegIng = "SELECT PT.PT_LPN "
					+ ", Pro.Pro_SKU "
					+ ", Pro.Pro_Nombre "
					+ ", PT.PT_Cantidad "
					+ ", PT.PT_CantidadIngresada, i.Lot_ID "
					+ "FROM Recepcion_pallet PT "
					+ "INNER JOIN Producto Pro "
					+ "ON PT.Pro_ID = Pro.Pro_ID "
					+ " INNER JOIN Inventario_Recepcion i"
					+ " ON PT.IR_ID=i.IR_ID "
					+ "WHERE i.IR_ID = " + IR_ID + " "

			var rsRegIng = AbreTabla(sqlRegIng, 1, 0)
%>
	<div class="ibox">
		<div class="ibox-title">
			<h5>Informaci&oacute;n ingresada a inventario</h5>
			<div class="ibox-tools">
				<button type="button" class="btn btn-success" id="btnSupervisor">
					<i class="fa fa-share"></i> Regresar
				</button>
			</div>
		</div>
		<div class="ibox-content">
			<table class="table table-hover">
				<thead>
					<tr>
						<th>#</th>
						<th>Lote</th>
						<th>LPN</th>
						<th>Producto</th>
						<th>Cant. Escaneada</th>
						<th>Cant. Ingresada</th>
					</tr>
				</thead>
				<tbody>
<%
			if( !(rsRegIng.EOF) ){
				var i = 0;
				while( !(rsRegIng.EOF) ){
					i++
%>
					<tr>
						<td class="col-sm-1">
							<%= i %>
						</td>
   						<td class="col-sm-3">
							<%= rsRegIng("Lot_ID").Value %>
						</td>
						<td class="col-sm-3">
							<%= rsRegIng("PT_LPN").Value %>
						</td>
						<td class="col-sm-5">
							<%= rsRegIng("Pro_SKU").Value %> - <%= rsRegIng("Pro_Nombre").Value %>
						</td>
						<td class="col-sm-1">
							<%= rsRegIng("PT_Cantidad").Value %>
						</td>
						<td class="col-sm-1">
							<%= rsRegIng("PT_CantidadIngresada").Value %>
						</td>
					</tr>
<%
					rsRegIng.MoveNext()
				}
			} else {
%>
					<tr>
						<td colspan="5">
							<i class="fa fa-exclamation-circle-o fa-lg text-success"></i> No hay ingreso
						</td>
					</tr>
<%
			}
%>
				</tbody>
			</table>
<%
			rsRegIng.Close()
%>
		</div>
	</div>
<%
			//Series no ingresadas
			var sqlSerErr = "SELECT PT.PT_LPN "
					+ ", Pro.Pro_SKU "
					+ ", Pro.Pro_Nombre "
					+ ", RSE.Ser_MB "
					+ ", RSE.Ser_Serie "
					+ ", RSE.Ser_ErrorDescripcion "
				+ "FROM Recepcion_Series RSE "
					+ "INNER JOIN Recepcion_Pallet PT "
						+ "ON RSE.PT_ID = PT.PT_ID "
					+ "INNER JOIN Producto Pro "
						+ "ON PT.Pro_ID = Pro.Pro_ID "
				+ "WHERE RSE.Ser_SeIngreso = -1 "
					+ "AND PT.IR_ID = " + IR_ID + " "

			var rsSerErr = AbreTabla(sqlSerErr, 1, 0)

			if( !(rsSerErr.EOF) ){
%>
	<div class="ibox">
		<div class="ibox-title">
			Series no ingresadas por error
		</div>
		<div class="ibox-content">
			<table class="table table-hover">
				<thead>
					<tr>
						<th>#</th>
						<th>LPN</th>
						<th>Producto</th>
						<th>MB</th>
						<th>Serie</th>
						<th>Error</th>
					</tr>
				</thead>
				<tbody>
<%
				var i = 0
				while( !(rsSerErr.EOF) ){
					i++;
%>
					<tr>
						<td class="col-sm-1"><%= i %></td>
						<td class="col-sm-2"><%= rsSerErr("PT_LPN").value %></td>
						<td class="col-sm-3"><%= rsSerErr("Pro_SKU").value %> - <%= rsSerErr("Pro_Nombre").value %></td>
						<td class="col-sm-1"><%= rsSerErr("Ser_MB").value %></td>
						<td class="col-sm-2"><%= rsSerErr("Ser_Serie").value %></td>
						<td class="col-sm-3"><%= rsSerErr("Ser_ErrorDescripcion").value %></td>
					</tr>
<%
					rsSerErr.MoveNext()
				}
%>
				</body>
			</table>
		</div>
	</div>
<%
			}

			rsSerErr.Close()
%>
<script type="text/javascript">
	$("#btnSupervisor").click( function(){
		$("#Contenido").load("/pz/wms/Recepcion/Recepcion.asp")
	});
</script>
<%


		} break;

			case 4:
sSQL = "DELETE FROM Recepcion_Series WHERE  Pt_ID="+ Pt_ID+" AND Ser_MB="+MB
Ejecuta(sSQL,0)

		break;
		case 5:
		if(MB_Cantidad > -1){
sSQL = "UPDATE  Recepcion_Masterbox SET MB_Cantidad  = "+MB_Cantidad+" WHERE  Pt_ID="+ Pt_ID+" AND MB_Numero="+MB

Ejecuta(sSQL,0)
Response.Write("Masterbox actualizado")
		}else{
		Response.Write("Ingresa la cantidad de articulos.")
	
		}

		break;
case 6:
		if(Digitos > -1){
sSQL = "UPDATE Producto SET Pro_SerieDigitos  = "+Digitos+" WHERE  Pro_ID="+ Pro_ID

Ejecuta(sSQL,0)
Response.Write("largo de serie actualizado")
		}else{
		Response.Write("Ingresa la cantidad de digitos de la serie.")
		}
		break;
						} 
							%>
<script src="/Template/inspina/js/plugins/jquery-ui/jquery-ui.min.js"></script>
<script type="text/javascript">
$(document).ready(function(e) {
	$('#BtnImprimirLPN').click(function(e) {
		 var lpn = $(this).data("ptlpn")
		 var folio = "-"
		var newWin=window.open("http://wms.lyde.com.mx/pz/wms/Recepcion/RecepcionLPNImpreso.asp?Pt_LPN="+ lpn+"&FolioOC="+ folio+"&Tarea=1");
	});
	
	});
			 function ExportaExcel(ptid){

	var Pt_ID = ptid
	var Pt_LPN = $(this).data('Pt_LPN')
	$.post("/pz/wms/Recepcion/RecepcionExcelSeries.asp",{Pt_ID:Pt_ID}
    , function(data){
		var response = JSON.parse(data)
		var ws = XLSX.utils.json_to_sheet(response);
		var wb = XLSX.utils.book_new(); XLSX.utils.book_append_sheet(wb, ws, "Sheet1");
		XLSX.writeFile(wb, "Pallet "+Pt_LPN+".xlsx");
	});
}
		 function CargaSeries(ptid, mb){
		var sDatos = "Tarea=" + 2
		 sDatos += "&Pt_ID=" + 	ptid
		sDatos += "&MB=" + mb
		$("#divSeries").load("/pz/wms/Recepcion/RecepcionSupervisor_Ajax.asp?" + sDatos)

	}	
	 function EliminarMB(ptid, mb){
		var sDatos = "Tarea=" + 4
		 sDatos += "&Pt_ID=" + 	ptid
		sDatos += "&MB=" + mb
		$("#divSeries").load("/pz/wms/Recepcion/RecepcionSupervisor_Ajax.asp?" + sDatos)
	
		$("#divSeries").html("Masterbox eliminado.")

	}	
	 function MuestraDigitos(){
			$("#inputDigitos").css('display','block')
	 }


	 function CambiaSerie(event){
 	var keyNum = event.which || event.keyCode;
		  
		if( keyNum== 13 ){

		 var sDatos = "Tarea=" + 6
		 sDatos += "&Digitos=" +	$("#inputDigitos")
		 sDatos += "&Pro_ID=" + 	$("#Pro_ID")

		$("#divSeries").load("/pz/wms/Recepcion/RecepcionSupervisor_Ajax.asp?" + sDatos)
		$("#divSeries").html("Largo de serie actualizado.")

		}
	}	

	 function MuestraCantidad(){
			$("#inputMB").css('display','block')
	 }
		 function ModificarMB(event){
			 	var keyNum = event.which || event.keyCode;
		  
				if( keyNum== 13 ){

		var sDatos = "Tarea=" + 5
		 	   sDatos += "&Pt_ID=" +  $("#Pt_ID").val()
			   sDatos += "&MB=" +  $("#MB").val()
		       sDatos += "&MB_Cantidad=" + $("#inputMB").val()
		$("#divSeries").load("/pz/wms/Recepcion/RecepcionSupervisor_Ajax.asp?" + sDatos)
				}
		 }
</script>