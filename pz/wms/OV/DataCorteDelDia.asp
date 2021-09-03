<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->

<%
		

	var sSQLOV = " select distinct OV_Folio, convert(nvarchar(10),OVH.OV_FechaCambio,103) as Fecha_Entrega "
		sSQLOV += " , CONVERT(VARCHAR(20), OV.OV_FechaRegistro, 103) FechaRegistro "
		sSQLOV += " , [dbo].[fn_CatGral_DameDato](51,OV.OV_EstatusCG51) as Estatus "
		sSQLOV += " FROM Orden_Venta OV , Orden_Venta_Historia OVH "
		sSQLOV += " WHERE OV.OV_Test = 0 AND OV.OV_Cancelada = 0 "
		sSQLOV += "  AND OVH.OV_EstatusCG51 = 10  "
		sSQLOV += "  AND OVH.OV_ID = OV.OV_ID  "
		sSQLOV += "  and OVH.OV_FechaCambio in ( SELECT TOP 1 OV_FechaCambio "
		sSQLOV += " FROM Orden_Venta_Historia OVH  "
		sSQLOV += " WHERE OVH.OV_EstatusCG51 = 10 AND OVH.OV_ID = OV.OV_ID  "
		sSQLOV += " ORDER BY OVH.OV_FechaCambio DESC )  "
   
var sSQLOV = " SELECT OV_Folio,(SELECT Cat_Nombre FROM Cat_Catalogo WHERE Sec_ID = 51 AND Cat_ID = p.OV_EstatusCG51) Estatus,OV_Cancelada
sSQLOV += ",ISNULL(replace(OV_TRACKING_NUMBER, '
sSQLOV += "', ''),'') Guia
sSQLOV += "FROM Orden_Venta p
sSQLOV += "WHERE OV_Test = 0
sSQLOV += "AND OV_Cancelada = 0   
		var i = 0
	
            var rsRTI = AbreTabla(sSQLOV,1,0)
            while (!rsRTI.EOF){
                var Fecha_Entrega = rsRTI.Fields.Item("Fecha_Entrega").Value 
                var OV_Folio = rsRTI.Fields.Item("OV_Folio").Value 
				
%>

[ Folios:[
<%	
		var rsRTI = AbreTabla(sSQLOV,1,0)
	while (!rsRTI.EOF){
		var Fecha_Entrega = rsRTI.Fields.Item("Fecha_Entrega").Value 
		var OV_Folio = rsRTI.Fields.Item("OV_Folio").Value 
				
%>{"OV_Folio":"<%=OV_Folio%>",
 "Fecha de Entrega":"<%=Fecha_Entrega%>"
}<%= ( i < rsRTI.RecordCount - 1 ) ? "," : ""  %><%	
	i++;
	rsRTI.MoveNext() 
}
rsRTI.Close()   
%>
],
Terminales:[
<%	
		var rsRTI = AbreTabla(sSQLOV,1,0)
	while (!rsRTI.EOF){
		var Fecha_Entrega = rsRTI.Fields.Item("Fecha_Entrega").Value 
		var OV_Folio = rsRTI.Fields.Item("OV_Folio").Value 
				
%>{"OV_Folio":"<%=OV_Folio%>",
 "Fecha de Entrega":"<%=Fecha_Entrega%>"
}<%= ( i < rsRTI.RecordCount - 1 ) ? "," : ""  %><%	
	i++;
	rsRTI.MoveNext() 
}
rsRTI.Close()   
%>
],
SIM:[
<%	
		var rsRTI = AbreTabla(sSQLOV,1,0)
	while (!rsRTI.EOF){
		var Fecha_Entrega = rsRTI.Fields.Item("Fecha_Entrega").Value 
		var OV_Folio = rsRTI.Fields.Item("OV_Folio").Value 
				
%>{"OV_Folio":"<%=OV_Folio%>",
 "Fecha de Entrega":"<%=Fecha_Entrega%>"
}<%= ( i < rsRTI.RecordCount - 1 ) ? "," : ""  %><%	
	i++;
	rsRTI.MoveNext() 
}
rsRTI.Close()   
%>
]
]