<%@LANGUAGE="JAVASCRIPT"  CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
   
var Tarea = Parametro("Tarea",-1)
var TA_ID = Parametro("TA_ID",-1)
var CliOC_ID = Parametro("CliOC_ID",-1)
var OC_ID = Parametro("OC_ID",-1)
var IR_ID = Parametro("IR_ID",-1)
var Observaciones = Parametro("Observaciones", "")

	switch (parseInt(Tarea)) {
		//Guarda cita
		case 1:	
				
				 if(TA_ID > -1){

		var ssql = "UPDATE TransferenciaAlmacen SET TA_DescargaCompleta = 1, TA_ObservacionesDescarga = '"+Observaciones+"' where TA_ID=" + TA_ID
				Ejecuta(ssql, 0)
	   
				} if(OC_ID > -1){ 
		var ssql = "UPDATE Proveedor_OrdenCompra SET OC_DescargaCompleta = 1, OC_ObservacionesDescarga = '"+Observaciones+"'  "
				ssql +=	"where OC_ID=" + OC_ID
		Ejecuta(ssql, 0)

				}if(CliOC_ID > -1){ 
			
			var ssql = "UPDATE Cliente_OrdenCompra SET CliOC_DescargaCompleta = 1, CliOC_ObservacionesDescarga = '"+Observaciones+"' "
			ssql +=" where CliOC_ID=" + CliOC_ID
					Ejecuta(ssql, 0)
			
				}
					 ssql = "UPDATE Inventario_Recepcion SET  IR_IncidenciaDescarga = 0 where IR_ID=" + IR_ID
					Ejecuta(ssql, 0)
						 var sResultado = 1
				
			break;
			case 2:
			
					 if(TA_ID > -1){

		var ssql = "UPDATE TransferenciaAlmacen SET TA_DescargaCompleta = 0, TA_ObservacionesDescarga = '"+Observaciones+"' where TA_ID=" + TA_ID
				Ejecuta(ssql, 0)
					
				} if(OC_ID > -1){ 
		var ssql = "UPDATE Proveedor_OrdenCompra SET OC_DescargaCompleta = 0, OC_ObservacionesDescarga = '"+Observaciones+"', , OC_EstatusCG52 = 19  "
				ssql +=	"where OC_ID=" + OC_ID
		Ejecuta(ssql, 0)
			
		
				}if(CliOC_ID > -1){ 
			
			var ssql = "UPDATE Cliente_OrdenCompra SET CliOC_DescargaCompleta = 0, CliOC_ObservacionesDescarga = '"+Observaciones+"' , CliOC_EstatusCG52 = 19"
			ssql +=" where CliOC_ID=" + CliOC_ID
					Ejecuta(ssql, 0)
			
					}
					
				 ssql = "UPDATE Inventario_Recepcion SET  IR_IncidenciaDescarga = 1 where IR_ID=" + IR_ID
					Ejecuta(ssql, 0)
					
						 var sResultado = 1
						
			break;
			case 3:
			
					 if(TA_ID > -1){

		var ssql = "UPDATE TransferenciaAlmacen SET TA_DescargaCompleta = 0, TA_ObservacionesDescarga = '"+Observaciones+"' where TA_ID=" + TA_ID
				Ejecuta(ssql, 0)
					
				} if(OC_ID > -1){ 
		var ssql = "UPDATE Proveedor_OrdenCompra SET OC_DescargaCompleta = 0, OC_ObservacionesDescarga = '"+Observaciones+"', , OC_EstatusCG52 = 22  "
				ssql +=	"where OC_ID=" + OC_ID
		Ejecuta(ssql, 0)
					
				}if(CliOC_ID > -1){ 
			
			var ssql = "UPDATE Cliente_OrdenCompra SET CliOC_DescargaCompleta = 0, CliOC_ObservacionesDescarga = '"+Observaciones+"' , CliOC_EstatusCG52 = 22"
			ssql +=" where CliOC_ID=" + CliOC_ID
					Ejecuta(ssql, 0)
				}
					
			ssql = "UPDATE Inventario_Recepcion SET  IR_IncidenciaDescarga = 1 where IR_ID=" + IR_ID
			Ejecuta(ssql, 0)
					
			var sResultado = 1
						
			break;
				}
		%>