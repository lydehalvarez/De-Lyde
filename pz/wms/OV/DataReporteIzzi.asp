<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
{
  "data": [
<%

//	var sSQLOV = "SELECT CONVERT(date, OV_FechaRegistro, 103) Fecha "
//		sSQLOV += " ,(SELECT Count(*) FROM Orden_Venta WHERE OV_EstatusCG51 = 1 AND OV_Cancelada = 0 AND OV_Test = 0 AND CONVERT(date, OV_FechaRegistro, 103) = CONVERT(date, p.OV_FechaRegistro, 103)) as Recibidos "
//		sSQLOV += " ,(SELECT Count(*) FROM Orden_Venta WHERE OV_EstatusCG51 = 3 AND OV_Cancelada = 0 AND OV_Test = 0 AND CONVERT(date, OV_FechaRegistro, 103) = CONVERT(date, p.OV_FechaRegistro, 103)) as Packing "
//		sSQLOV += " ,(SELECT Count(*) FROM Orden_Venta WHERE OV_EstatusCG51 = 5 AND OV_Cancelada = 0 AND OV_Test = 0 AND CONVERT(date, OV_FechaRegistro, 103) = CONVERT(date, p.OV_FechaRegistro, 103)) as Transito "
//		sSQLOV += " ,(SELECT Count(*) FROM Orden_Venta WHERE OV_EstatusCG51 = 6 AND OV_Cancelada = 0 AND OV_Test = 0 AND CONVERT(date, OV_FechaRegistro, 103) = CONVERT(date, p.OV_FechaRegistro, 103)) as PrimerIntento "
//		sSQLOV += " ,(SELECT Count(*) FROM Orden_Venta WHERE OV_EstatusCG51 = 7 AND OV_Cancelada = 0 AND OV_Test = 0 AND CONVERT(date, OV_FechaRegistro, 103) = CONVERT(date, p.OV_FechaRegistro, 103)) as SegundoIntento "
//		sSQLOV += " ,(SELECT Count(*) FROM Orden_Venta WHERE OV_EstatusCG51 = 8 AND OV_Cancelada = 0 AND OV_Test = 0 AND CONVERT(date, OV_FechaRegistro, 103) = CONVERT(date, p.OV_FechaRegistro, 103)) as TercerIntento "
//		sSQLOV += " ,(SELECT Count(*) FROM Orden_Venta WHERE OV_EstatusCG51 = 9 AND OV_Cancelada = 0 AND OV_Test = 0 AND CONVERT(date, OV_FechaRegistro, 103) = CONVERT(date, p.OV_FechaRegistro, 103)) as Fallido "
//		sSQLOV += " FROM Orden_Venta p "
//		sSQLOV += " WHERE OV_Cancelada = 0 "
//		sSQLOV += " AND OV_Test = 0 "
//		sSQLOV += " GROUP BY  CONVERT(date, OV_FechaRegistro, 103) "
//		sSQLOV += " ORDER BY CONVERT(date, OV_FechaRegistro, 103) DESC "
		
	var sSQLOV = "SELECT ISNULL(CONVERT(VARCHAR(30), CONVERT(date, OV_FechaRegistro, 103)), 'TOTAL') AS Fecha "
		sSQLOV += " , SUM( CASE OV_EstatusCG51 WHEN 1 THEN 1 ELSE 0 END) AS Recibidos "
		sSQLOV += " , SUM( CASE OV_EstatusCG51 WHEN 3 THEN 1 ELSE 0 END) AS Packing "
		sSQLOV += " , SUM( CASE OV_EstatusCG51 WHEN 5 THEN 1 ELSE 0 END) AS Transito "
		sSQLOV += " , SUM( CASE OV_EstatusCG51 WHEN 6 THEN 1 ELSE 0 END) AS PrimerIntento "
		sSQLOV += " , SUM( CASE OV_EstatusCG51 WHEN 7 THEN 1 ELSE 0 END) AS SegundoIntento "
		sSQLOV += " , SUM( CASE OV_EstatusCG51 WHEN 8 THEN 1 ELSE 0 END) AS TercerIntento "
		sSQLOV += " , SUM( CASE OV_EstatusCG51 WHEN 9 THEN 1 ELSE 0 END) AS Fallido "
		sSQLOV += " , SUM( CASE OV_EstatusCG51 WHEN 10 THEN 1 ELSE 0 END) AS Entregado "
		sSQLOV += " , SUM( CASE WHEN OV_EstatusCG51 IN (1,3,5,6,7,8,9,10) THEN 1 ELSE 0 END) AS Total "
		sSQLOV += " FROM Orden_Venta p "
		sSQLOV += " WHERE OV_Test = 0 "
		sSQLOV += " AND OV_Cancelada = 0 "
		sSQLOV += " GROUP BY  CONVERT(date, OV_FechaRegistro, 103)  "
		//sSQLOV += " WITH CUBE "
		sSQLOV += " ORDER BY Fecha ASC "
			
	
		var i = 0
	
            var rsRTI = AbreTabla(sSQLOV,1,0)
            while (!rsRTI.EOF){
                var Fecha = rsRTI.Fields.Item("Fecha").Value 
                var Recibidos = rsRTI.Fields.Item("Recibidos").Value 
                var Packing = rsRTI.Fields.Item("Packing").Value 
                var Transito = rsRTI.Fields.Item("Transito").Value 
                var PrimerIntento = rsRTI.Fields.Item("PrimerIntento").Value 
                var SegundoIntento = rsRTI.Fields.Item("SegundoIntento").Value 
                var TercerIntento = rsRTI.Fields.Item("TercerIntento").Value 
                var Fallido = rsRTI.Fields.Item("Fallido").Value  
                var Entregado = rsRTI.Fields.Item("Entregado").Value  
                var Total = rsRTI.Fields.Item("Total").Value  
				
				
%>{
    "Fecha":"<%=Fecha%>",
    "Recibidos":<%=Recibidos%>,
    "Packing":<%=Packing%>,
    "Transito":{"Num":<%=Transito%>,"Class": "<%if(Transito >0) {Response.Write('warning')}else{Response.Write('')}%>"},
    "PrimerIntento":{"Num":<%=PrimerIntento%>,"Class": "<%if(PrimerIntento >0) {Response.Write('success')}else{Response.Write('')}%>"},
    "SegundoIntento":{"Num":<%=SegundoIntento%>,"Class": "<%if(SegundoIntento >0) {Response.Write('info')}else{Response.Write('')}%>"},
    "TercerIntento":{"Num":<%=TercerIntento%>,"Class": "<%if(TercerIntento >0) {Response.Write('danger')}else{Response.Write('')}%>"},
    "Fallido":<%=Fallido%>,
    "Entregado":<%=Entregado%>,
    "Total":<%=Total%>
} <%= ( i < rsRTI.RecordCount - 1 ) ? "," : ""  %>

<%	
	i++;
	rsRTI.MoveNext() 
}
rsRTI.Close()   
%>]
}