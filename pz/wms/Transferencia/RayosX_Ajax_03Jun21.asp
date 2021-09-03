       <%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
  
<%
 	var Tarea = Parametro("Tarea", -1)
 	var TRA = Parametro("TRA", "")


 switch (parseInt(Tarea)) {

	case 1:
		var TA_ID = -1
		var Respuesta = ""
		var Contador = 0
		var message = ""
		var result = 0
		TRA = TRA.replace("'","-")
	
		var sSQL = "SELECT TA_ID, Edo_Nombre,ISNULL(convert( varchar(10), TA_FechaRayosX, 103 ),'') Fecha,TA_EstatusCG51 Estatus  " 
			sSQL += " FROM TransferenciaAlmacen, Almacen al, Cat_Estado e  "
			sSQL += " WHERE (TA_Folio = '"+ TRA + "' OR TA_Guia = '"+TRA+"') "
			sSQL += " AND TA_End_Warehouse_ID = al.Alm_ID "
			sSQL += " AND al.Edo_ID = e.Edo_ID"
		
		var rsTRA = AbreTabla(sSQL, 1,0)
		
		var Edo_Nombre = ""
		var TA_FechaRayosX = ""
		var Estatus = ""
		if(!rsTRA.EOF){
			TA_ID =  rsTRA.Fields.Item("TA_ID").Value 
			Edo_Nombre = rsTRA.Fields.Item("Edo_Nombre").Value
			TA_FechaRayosX = rsTRA.Fields.Item("Fecha").Value
			TA_EstatusCG51 = rsTRA.Fields.Item("Estatus").Value
		}
		
		if(TA_ID > -1){
			var Producto = "SELECT Pro_Nombre, cast(TAA_Cantidad as int)  AS CANTIDAD "
				Producto += "FROM Producto p, TransferenciaAlmacen_Articulos a "
				Producto += "WHERE a.Pro_ID = p.Pro_ID "
				Producto += " AND TA_ID = "+ TA_ID
	
			var Productos = ""
			var rsTransferencia = AbreTabla(Producto, 1,0)
			while(!rsTransferencia.EOF){
				Productos =  rsTransferencia.Fields.Item("CANTIDAD").Value + " " + rsTransferencia.Fields.Item("Pro_Nombre").Value
				message = message + "<br/> "  + Productos 
				rsTransferencia.MoveNext() 
			}
			rsTransferencia.Close()   
			
			
			if(TA_FechaRayosX == ""){
				if(TA_EstatusCG51 = 3){
					var Pickeado = BuscaSoloUnDato("SUM(TAA_Cantidad)","TransferenciaAlmacen_Articulos"," TA_ID = " + TA_ID,-1,0)

					message = TRA +" escaneada <br/> TOTAL: "  + Pickeado  + " Estado: " + Edo_Nombre +"<br>"+message
						
					var sSQLTr = "UPDATE TransferenciaAlmacen "
						sSQLTr  += "SET TA_FechaRayosX = getdate()"
						sSQLTr  += ", TA_EstatusCG51= 4 "
						sSQLTr  += " WHERE TA_ID = "+TA_ID 
					
					if(Ejecuta(sSQLTr,0)){
						result = 1
					}else{
						result = 0
						message = "Error en la conexion de red vuelve a escanear la transferencia"
					}
				}
			}else{
				
				result = 0
				message = "La transferencia "  + TRA + " ya pas&oacute; por rayos X " + "<br/> " + message 
			}
		}else{
			result = -1
			message = "Lo sentimos no encontramos la transferencia, intente de nuevo"	
		}
		
		var sSQL = " SELECT COUNT(*) AS Cantidad_Tras "
			sSQL +=" FROM TransferenciaAlmacen "
			sSQL +=" WHERE cast(TA_FechaRayosX as date) = cast(getdate() as date)"
			
		var rsCuenta = AbreTabla(sSQL, 1,0)
		
		if(!rsCuenta.EOF){
			Contador = rsCuenta.Fields.Item("Cantidad_Tras").Value
		}		
		
		Respuesta = '{"result":'+result+',"message":"'+message+'","contador":"'+Contador+'"}'
		Response.Write(Respuesta)
 break;
 }

%>
   			
