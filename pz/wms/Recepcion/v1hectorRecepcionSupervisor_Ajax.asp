<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->


<%
var Pt_ID = Parametro("Pt_ID",-1)
var IR_ID = Parametro("IR_ID",-1)
var MB = Parametro("MB", -1)
var MB_Cantidad = Parametro("MB_Cantidad", -1)
var Tarea =  Parametro("Tarea",-1)	

	 switch (parseInt(Tarea)) {
case 1:
 sSQL = "SELECT s.Pt_ID, MB_Numero, MB_Incidencia, MB_RayX  FROM Recepcion_Masterbox s INNER JOIN Recepcion_Pallet p ON  p.Pt_ID=s.Pt_ID WHERE  s.Pt_ID="+Pt_ID+" group by  s.Pt_ID, s.MB_Numero, MB_Incidencia, MB_RayX  "
 var rsLinea1 = AbreTabla(sSQL,1,0)
  sSQL = "SELECT s.Pt_ID, MB_Numero, MB_Incidencia, MB_RayX FROM Recepcion_Masterbox s INNER JOIN Recepcion_Pallet p ON  p.Pt_ID=s.Pt_ID WHERE Pt_Linea = 2 AND  s.Pt_ID="+Pt_ID+" group by  s.Pt_ID, s.MB_Numero, MB_Incidencia, MB_RayX  "
 var rsLinea2 = AbreTabla(sSQL,1,0)
 sSQL = "SELECT s.Pt_ID, MB_Numero, MB_Incidencia, MB_RayX FROM Recepcion_Masterbox s INNER JOIN Recepcion_Pallet p ON  p.Pt_ID=s.Pt_ID WHERE  Pt_Linea = 3 AND  s.Pt_ID="+Pt_ID+" group by  s.Pt_ID, s.MB_Numero, MB_Incidencia, MB_RayX  "
 var rsLinea3 = AbreTabla(sSQL,1,0)
 sSQL = "SELECT s.Pt_ID, MB_Numero, MB_Incidencia, MB_RayX FROM Recepcion_Masterbox s INNER JOIN Recepcion_Pallet p ON  p.Pt_ID=s.Pt_ID WHERE Pt_Linea = 4 AND   s.Pt_ID="+Pt_ID+" group by  s.Pt_ID, s.MB_Numero, MB_Incidencia, MB_RayX  "
 var rsLinea4 = AbreTabla(sSQL,1,0)
 sSQL = "SELECT s.Pt_ID, MB_Numero, MB_Incidencia, MB_RayX FROM Recepcion_Masterbox s INNER JOIN Recepcion_Pallet p ON  p.Pt_ID=s.Pt_ID WHERE  Pt_Linea = 5 AND  s.Pt_ID="+Pt_ID+" group by  s.Pt_ID, s.MB_Numero, MB_Incidencia, MB_RayX  "
 var rsLinea5 = AbreTabla(sSQL,1,0)
 
			
                %>
               
               
                                    <td class="desc"> <strong>Masterbox</strong>&nbsp;   
                                        <%
							 while (!rsLinea1.EOF){     
						 	var Pt_ID = rsLinea1.Fields.Item("Pt_ID").Value
							var MB = rsLinea1.Fields.Item("MB_Numero").Value
							var MB_Incidencia = rsLinea1.Fields.Item("MB_Incidencia").Value
							var MB_RayX = rsLinea1.Fields.Item("MB_RayX").Value

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
                                    rsLinea1.MoveNext() 
                                    }
                                    rsLinea1.Close()   
                                    %>
                                 </td>
                                    <td class="desc">
                                
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
                             
                             <%
							  break;
							  
	 case 2:

sSQL = "SELECT s.Ser_Serie, s.Ser_Incidencia FROM Recepcion_Series s INNER JOIN Recepcion_Pallet p ON  p.Pt_ID=s.Pt_ID WHERE  s.Ser_SerieEscaneada = 1 AND s.Pt_ID="+Pt_ID+" AND s.Ser_MB="+MB+" group by s.Ser_Serie, s.Ser_Incidencia "
 var rsSeries = AbreTabla(sSQL,1,0)
var series = rsSeries.RecordCount
                %>
                              <table class="table shoping-cart-table">
                               <thead>
<th><button type="button"  class="btn btn-danger" id="BtnElimMB"  data-ptid="<%=Pt_ID%>"  data-mb = "<%=MB%>" onclick="javascript:EliminarMB(<%=Pt_ID%>,<%=MB%>)">Eliminar Series</button><br /><br />
 <button type="button"  class="btn btn-danger" id="BtnModifMB" onclick="javascript:MuestraCantidad()">Modificar Masterbox</button><br /><br />
           	<input class="form-control inputMB"  id="inputMB" style="display:none;width:55%" placeholder="cantidad" type="text" autocomplete="off" value="" onkeydown="ModificarMB(event);"/><br />
<input type="hidden" value="<%=Pt_ID%>" class="agenda" id="Pt_ID"/>
<input type="hidden" value="<%=MB%>" class="agenda" id="MB"/>
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
		case 3:
		// !! PRECAUCION!! ESTO SUBE TODA LA RECEPCION A INVENTARIO  
sSQL = "UPDATE Inventario_Recepcion SET IR_EstatusCG52 = 21 WHERE IR_ID ="+ IR_ID

Ejecuta(sSQL,0)

	var sSQLTr=" UPDATE Inventario_Recepcion SET IR_IngresoFecha = getdate() , IR_IngresoResultado=1, IR_IngresoUsuario = 97 WHERE IR_ID ="+IR_ID
	Ejecuta(sSQLTr, 0)
		break;
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
						} 
							%>
<script src="/Template/inspina/js/plugins/jquery-ui/jquery-ui.min.js"></script>
<script type="text/javascript">
$(document).ready(function(e) {

	
	});
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