       <%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
  
<%
 	var Tarea = Parametro("Tarea", -1)
 	var TRA = Parametro("TRA", "")


 switch (parseInt(Tarea)) {

	case 1:
	var Respuesta = ""
	var Contador = ""
		TRA = TRA.replace("'","-")
	
		sSQL = "SELECT TA_ID , Edo_Nombre "
				 +"FROM TransferenciaAlmacen"
				 +	", Almacen al, Cat_Estado e  "
				 +" WHERE (TA_Folio = '"+ TRA + "' OR TA_Guia = '"+TRA+"') "
				 +" AND TA_End_Warehouse_ID = al.Alm_ID AND al.Edo_ID = e.Edo_ID"
		var rsTRA=AbreTabla(sSQL, 1,0)
		var TA_ID =  rsTRA.Fields.Item("TA_ID").Value 
		var Edo_Nombre = rsTRA.Fields.Item("Edo_Nombre").Value 
		sSQL = "SELECT SUM(TAA_Cantidad) AS TOTAL FROM TransferenciaAlmacen_Articulos WHERE  TA_ID = " + TA_ID
		var rsTotal=AbreTabla(sSQL, 1,0)

			var sSQL = "SELECT Pro_Nombre, cast(TAA_Cantidad as int)  AS CANTIDAD "
			+"FROM Producto p, TransferenciaAlmacen_Articulos a "
			+"WHERE  a.Pro_ID=p.Pro_ID AND  (TA_ID = "+ TA_ID + ")"
				var rsTransferencia=AbreTabla(sSQL, 1,0)
				var message = TRA +" escaneada <br/> TOTAL: "  + rsTotal.Fields.Item("TOTAL").Value + " Estado: " + Edo_Nombre 
				var Productos = "" 
				while (!rsTransferencia.EOF){
				Productos =  rsTransferencia.Fields.Item("CANTIDAD").Value + " " + rsTransferencia.Fields.Item("Pro_Nombre").Value
				message = message + "<br/> "  + Productos 
				rsTransferencia.MoveNext() 
        	    	}
     		    rsTransferencia.Close()   
				result = 1
		var Existe = BuscaSoloUnDato("TA_ID","TransferenciaAlmacen","TA_Cancelada = 0 AND TA_FechaRayosX IS NOT NULL  AND TA_ID = '"+TA_ID + "'",-1,0) 
		if( Existe == -1){
   		var sSQLTr = "UPDATE TransferenciaAlmacen SET TA_FechaRayosX= getdate(), TA_EstatusCG51= 4"
   	   		  sSQLTr  += " WHERE (TA_ID = '"+ TA_ID + "' OR TA_Guia = '"+TRA+"') "
			
		if(Ejecuta(sSQLTr,0)){
				

			}else{
				result = 0
				message = "Error en la conexion de red vuelve a escanear la transferencia"
			}
		}else{
				result = 0
				message = "La transferencia "  + TRA + " esta repetida " + "<br/> " + message 
		}
					sSQL = "	SELECT COUNT(TA_ID) AS TOTAL FROM TransferenciaAlmacen WHERE  cast(TA_FechaRayosX as date)  =  cast(getdate() as date)"
		var rsCuenta=AbreTabla(sSQL, 1,0)
		Contador = rsCuenta.Fields.Item("TOTAL").Value
		
		
				Respuesta = '{"result":'+result+',"message":"'+message+'","contador":"'+Contador+'"}'
Response.Write(Respuesta)
 break;
 }

%>
   			
