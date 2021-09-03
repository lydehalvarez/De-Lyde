<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
[
<%
		
//	var sSQLOV = "SELECT  OV_Folio"
//		sSQLOV += " ,CONVERT(VARCHAR(20), OV.OV_FechaRegistro, 103) FechaRegistro "
//		sSQLOV += " ,CAT.CAT_Nombre "
//		sSQLOV += " ,(SELECT TOP 1 CONVERT(VARCHAR(20), OVH.OV_FechaCambio, 103) FROM Orden_Venta_Historia OVH WHERE OVH.OV_EstatusCG51 = 10 AND OVH.OV_ID = OV.OV_ID ORDER BY OVH.OV_FechaCambio DESC) AS Fecha_Entrega "
//		sSQLOV += " FROM Orden_Venta OV LEFT JOIN Cat_Catalogo CAT ON OV.OV_EstatusCG51 = CAT.CAT_Id AND CAT.SEC_Id = 51  "
//		sSQLOV += " WHERE OV.OV_Test = 0 AND OV.OV_Cancelada = 0 "
//		sSQLOV += " ORDER BY OV_ID DESC "

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
   
   
   
		var i = 0
	
            var rsRTI = AbreTabla(sSQLOV,1,0)
            while (!rsRTI.EOF){
                var Fecha_Entrega = rsRTI.Fields.Item("Fecha_Entrega").Value 
                var OV_Folio = rsRTI.Fields.Item("OV_Folio").Value 
				
%>{"OV_Folio":"<%=OV_Folio%>", "Fecha de Entrega":"<%=Fecha_Entrega%>"}<%= ( i < rsRTI.RecordCount - 1 ) ? "," : ""  %><%	
	i++;
	rsRTI.MoveNext() 
}
rsRTI.Close()   
%>
]