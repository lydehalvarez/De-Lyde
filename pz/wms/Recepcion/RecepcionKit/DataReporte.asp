<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../../Includes/iqon.asp" -->
{
"data": [
<%
	var sSQLO = " SELECT Pt_LPN,[TPro_Nombre] as Familia,Pro_Nombre,Pro_UPC,COUNT(*) Recibido " +
					" FROM Inventario a, Producto c, Cat_TipoProducto d, Pallet e "+
					" WHERE a.Pro_ID = c.Pro_ID  "+
					" AND a.Pt_ID = e.Pt_ID  "+
					" AND c.TPro_ID = d.TPro_ID "+
					" AND a.Pro_ID in (SELECT Pro_ID "+
										" FROM Producto "+
										" WHERE Cli_ID = 10 "+  
										" AND Pro_MiembroDelKit != -1) "+
					" GROUP BY Pt_LPN,a.Pro_ID,Pro_Nombre,Pro_UPC,[TPro_Nombre] "
		


var i = 0
var rsJson = AbreTabla(sSQLO,1,0)

while (!rsJson.EOF){
	var Pt_LPN =  rsJson.Fields.Item("Pt_LPN").Value
	var Familia =  rsJson.Fields.Item("Familia").Value
	var Pro_Nombre =  rsJson.Fields.Item("Pro_Nombre").Value
	var Pro_UPC =  rsJson.Fields.Item("Pro_UPC").Value
	var Recibido = rsJson.Fields.Item("Recibido").Value
%>{
    "LPN":"<%=Pt_LPN%>",
    "Familia":"<%=Familia%>",
    "Nombre":"<%=Pro_Nombre%>",
    "UPC":"<%=Pro_UPC%>",
    "Recibido":<%=Recibido%>
}<%=(i < rsJson.RecordCount - 1 ) ? "," : ""  %>
<%
i++;
   rsJson.MoveNext()
 }
 rsJson.Close() 
%>]}