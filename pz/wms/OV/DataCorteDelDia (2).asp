<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->

<%
		
var sSQLFol = " SELECT OV_Folio,(SELECT Cat_Nombre FROM Cat_Catalogo WHERE Sec_ID = 51 AND Cat_ID = p.OV_EstatusCG51) Estatus,OV_Cancelada "
	sSQLFol += ",ISNULL(OV_TRACKING_NUMBER,'') Guia "
	sSQLFol += "FROM Orden_Venta p "
	sSQLFol += "WHERE OV_Test = 0 "
	sSQLFol += "AND OV_Cancelada = 0 "   

		
var sSQLTer = " SELECT (SELECT Pro_ClaveAlterna FROM Producto WHERE Pro_ID = i.Pro_ID) SKU "
	sSQLTer += ",(SELECT Pro_Nombre FROM Producto WHERE Pro_ID = i.Pro_ID) Nombre  "
	sSQLTer += ",Inv_Serie  "
	sSQLTer += ",(SELECT Cat_Nombre FROM Cat_Catalogo WHERE Sec_ID = 20 AND Cat_ID = i.Inv_EstatusCG20) EstatusAlamcen  "
	sSQLTer += ",(SELECT Alm_Nombre FROM Almacen WHERE Alm_ID = i.Alm_ID) Almacen  "
	sSQLTer += ",(SELECT Alm_Numero FROM Almacen WHERE Alm_ID = i.Alm_ID) SAP_ID "
	sSQLTer += ", CASE  "
	sSQLTer += "WHEN (SELECT TOP 1 OV_ID FROM [dbo].[Orden_Venta_Picking] WHERE OVP_Serie = i.Inv_Serie) != ''  "
	sSQLTer += "THEN  (SELECT TOP 1 OV_Folio FROM Orden_Venta WHERE OV_Test = 0 AND OV_ID = (SELECT TOP 1 OV_ID FROM [dbo].[Orden_Venta_Picking] WHERE OVP_Serie = i.Inv_Serie ORDER BY OV_ID DESC)) "
	sSQLTer += "ELSE (SELECT TOP 1 TA_Folio FROM TransferenciaAlmacen WHERE TA_ID = (SELECT TOP 1 TA_ID FROM [dbo].TransferenciaAlmacen_Articulo_Picking WHERE TAS_Serie = i.Inv_Serie ORDER BY TA_ID DESC))  "
	sSQLTer += "END FolioLyde "
	sSQLTer += ", CASE  "
	sSQLTer += "WHEN (SELECT TOP 1 OV_ID FROM [dbo].[Orden_Venta_Picking] WHERE OVP_Serie = i.Inv_Serie ORDER BY OV_ID DESC) != ''  "
	sSQLTer += "THEN  (SELECT TOP 1 OV_CUSTOMER_SO FROM Orden_Venta WHERE OV_Test = 0 AND OV_ID = (SELECT TOP 1 OV_ID FROM [dbo].[Orden_Venta_Picking] WHERE OVP_Serie = i.Inv_Serie ORDER BY OV_ID DESC)) "
	sSQLTer += "END CUSTOMER_SO "
	sSQLTer += ", CASE  "
	sSQLTer += "WHEN (SELECT TOP 1 OV_ID FROM [dbo].[Orden_Venta_Picking] WHERE OVP_Serie = i.Inv_Serie ORDER BY OV_ID DESC) != ''  "
	sSQLTer += "THEN  (SELECT TOP 1 (SELECT Cat_Nombre FROM Cat_Catalogo WHERE Sec_ID = 51 AND Cat_ID = p.OV_EstatusCG51) FROM Orden_Venta p WHERE OV_Test = 0 AND OV_ID = (SELECT TOP 1 OV_ID FROM [dbo].[Orden_Venta_Picking] WHERE OVP_Serie = i.Inv_Serie ORDER BY OV_ID DESC)) "
	sSQLTer += "END Estatus "
	sSQLTer += "FROM Inventario i "
	sSQLTer += "WHERE Pro_ID in (SELECT Pro_ID FROM Producto WHERE Pro_ID = i.Pro_ID AND TPro_ID = 1) "
	sSQLTer += "AND Inv_EstatusCG20 != 10  "

var sSQLSim = " SELECT (SELECT Pro_ClaveAlterna FROM Producto WHERE Pro_ID = i.Pro_ID) SKU "
	sSQLSim += ",(SELECT Pro_Nombre FROM Producto WHERE Pro_ID = i.Pro_ID) Nombre  "
	sSQLSim += ",Inv_Serie  "
	sSQLSim += ",(SELECT Cat_Nombre FROM Cat_Catalogo WHERE Sec_ID = 20 AND Cat_ID = i.Inv_EstatusCG20) EstatusAlamcen  "
	sSQLSim += ",(SELECT Alm_Nombre FROM Almacen WHERE Alm_ID = i.Alm_ID) Almacen  "
	sSQLSim += ",(SELECT Alm_Numero FROM Almacen WHERE Alm_ID = i.Alm_ID) SAP_ID "
	sSQLSim += ", CASE  "
	sSQLSim += "WHEN (SELECT TOP 1 OV_ID FROM [dbo].[Orden_Venta_Picking] WHERE OVP_Serie = i.Inv_Serie) != ''  "
	sSQLSim += "THEN  (SELECT TOP 1 OV_Folio FROM Orden_Venta WHERE OV_Test = 0 AND OV_ID = (SELECT TOP 1 OV_ID FROM [dbo].[Orden_Venta_Picking] WHERE OVP_Serie = i.Inv_Serie ORDER BY OV_ID DESC)) "
	sSQLSim += "ELSE (SELECT TOP 1 TA_Folio FROM TransferenciaAlmacen WHERE TA_ID = (SELECT TOP 1 TA_ID FROM [dbo].TransferenciaAlmacen_Articulo_Picking WHERE TAS_Serie = i.Inv_Serie ORDER BY TA_ID DESC))  "
	sSQLSim += "END FolioLyde "
	sSQLSim += ", CASE  "
	sSQLSim += "WHEN (SELECT TOP 1 OV_ID FROM [dbo].[Orden_Venta_Picking] WHERE OVP_Serie = i.Inv_Serie ORDER BY OV_ID DESC) != ''  "
	sSQLSim += "THEN  (SELECT TOP 1 OV_CUSTOMER_SO FROM Orden_Venta WHERE OV_Test = 0 AND OV_ID = (SELECT TOP 1 OV_ID FROM [dbo].[Orden_Venta_Picking] WHERE OVP_Serie = i.Inv_Serie ORDER BY OV_ID DESC)) "
	sSQLSim += "END CUSTOMER_SO "
	sSQLSim += ", CASE  "
	sSQLSim += "WHEN (SELECT TOP 1 OV_ID FROM [dbo].[Orden_Venta_Picking] WHERE OVP_Serie = i.Inv_Serie ORDER BY OV_ID DESC) != ''  "
	sSQLSim += "THEN  (SELECT TOP 1 (SELECT Cat_Nombre FROM Cat_Catalogo WHERE Sec_ID = 51 AND Cat_ID = p.OV_EstatusCG51) FROM Orden_Venta p WHERE OV_Test = 0 AND OV_ID = (SELECT TOP 1 OV_ID FROM [dbo].[Orden_Venta_Picking] WHERE OVP_Serie = i.Inv_Serie ORDER BY OV_ID DESC)) "
	sSQLSim += "END Estatus "
	sSQLSim += "FROM Inventario i "
	sSQLSim += "WHERE Pro_ID in (SELECT Pro_ID FROM Producto WHERE Pro_ID = i.Pro_ID AND TPro_ID = 2) "
	sSQLSim += "AND Inv_EstatusCG20 != 10  "
	
		var i1 = 0
		var i2 = 0
		var i3 = 0
%>

[ "Folios":[
<%	
		var rsFol = AbreTabla(sSQLFol,1,0)
	while (!rsFol.EOF){
		var OV_Folio = rsFol.Fields.Item("OV_Folio").Value 
		var Estatus = rsFol.Fields.Item("Estatus").Value 
		var OV_TRACKING_NUMBER = DSITrim(rsFol.Fields.Item("Guia").Value)
				
%>{"OV_Folio":"<%=OV_Folio%>",
 "Estatus":"<%=Estatus%>",
 "Guia":"<%=OV_TRACKING_NUMBER%>"
}<%= ( i1 < rsFol.RecordCount - 1 ) ? "," : ""  %><%	
	i1++;
	rsFol.MoveNext() 
}
rsFol.Close()   
%>
],
"Terminales":[
<%	
		var rsTer = AbreTabla(sSQLTer,1,0)
	while (!rsTer.EOF){
		var SKU = rsTer.Fields.Item("SKU").Value 
		var Nombre = rsTer.Fields.Item("Nombre").Value 
		var Inv_Serie = rsTer.Fields.Item("Inv_Serie").Value 
		var EstatusAlamcen = rsTer.Fields.Item("EstatusAlamcen").Value 
		var Almacen = rsTer.Fields.Item("Almacen").Value 
		var SAP_ID = rsTer.Fields.Item("SAP_ID").Value 
		var FolioLyde = rsTer.Fields.Item("FolioLyde").Value 
		var CUSTOMER_SO = rsTer.Fields.Item("CUSTOMER_SO").Value 
		var Estatus = rsTer.Fields.Item("Estatus").Value 
				
%>{"SKU":"<%=SKU%>",
 "Nombre":"<%=Nombre%>",
 "Inv_Serie":"<%=Inv_Serie%>",
 "EstatusAlamcen":"<%=EstatusAlamcen%>",
 "SAP_ID":"<%=SAP_ID%>",
 "FolioLyde":"<%=FolioLyde%>",
 "CUSTOMER_SO":"<%=CUSTOMER_SO%>",
 "Estatus":"<%=Estatus%>" 
}<%= ( i2 < rsTer.RecordCount - 1 ) ? "," : ""  %><%	
	i2++;
	rsTer.MoveNext() 
}
rsTer.Close()   
%>
],
"SIM":[
<%	

		var rsSIM = AbreTabla(sSQLSim,1,0)
	while (!rsSIM.EOF){
		var SKU = rsSIM.Fields.Item("SKU").Value 
		var Nombre = rsSIM.Fields.Item("Nombre").Value 
		var Inv_Serie = rsSIM.Fields.Item("Inv_Serie").Value 
		var EstatusAlamcen = rsSIM.Fields.Item("EstatusAlamcen").Value 
		var Almacen = rsSIM.Fields.Item("Almacen").Value 
		var SAP_ID = rsSIM.Fields.Item("SAP_ID").Value 
		var FolioLyde = rsSIM.Fields.Item("FolioLyde").Value 
		var CUSTOMER_SO = rsSIM.Fields.Item("CUSTOMER_SO").Value 
		var Estatus = rsTer.Fields.Item("Estatus").Value 
				
%>{"SKU":"<%=SKU%>",
 "Nombre":"<%=Nombre%>",
 "Inv_Serie":"<%=Inv_Serie%>",
 "EstatusAlamcen":"<%=EstatusAlamcen%>",
 "SAP_ID":"<%=SAP_ID%>",
 "FolioLyde":"<%=FolioLyde%>",
 "CUSTOMER_SO":"<%=CUSTOMER_SO%>",
 "Estatus":"<%=Estatus%>" 
}<%= ( i3 < rsSIM.RecordCount - 1 ) ? "," : ""  %><%	
	i3++;
	rsSIM.MoveNext() 
}
rsSIM.Close()   
%>
]
]