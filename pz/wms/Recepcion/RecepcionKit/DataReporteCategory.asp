<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../../Includes/iqon.asp" -->
{
"data": [
<%
	var Cli_ID = Parametro("Cli_ID",-1)
	var Pro_ID = Parametro("Pro_ID",-1)

	var sSQLO = " SELECT Pt_LPN,[TPro_Nombre] as Familia,Pro_Nombre,Pro_UPC,COUNT(*) Recibido "+
					" FROM Inventario a, Producto c, Cat_TipoProducto d, Pallet e "+
					" WHERE a.Pro_ID = c.Pro_ID  "+
					" AND c.TPro_ID = d.TPro_ID "+
					" AND a.Pt_ID = e.Pt_ID "+
					" AND e.Cli_ID = "+ Cli_ID +
					" AND e.Pro_ID = "+ Pro_ID +
					" GROUP BY Pt_LPN,a.Pro_ID,Pro_Nombre,Pro_UPC,[TPro_Nombre] "+
					" ORDER BY Pt_LPN ASC"
		 


var i = 0
var rsJson = AbreTabla(sSQLO,1,0)
	var Pt_LPN =  ""
	var Familia =  ""
	var Pro_Nombre =  ""
	var Pro_UPC =  ""
	var Recibido = ""
while (!rsJson.EOF){ 
	Pt_LPN =  rsJson.Fields.Item("Pt_LPN").Value
	Familia =  rsJson.Fields.Item("Familia").Value
	Pro_Nombre =  rsJson.Fields.Item("Pro_Nombre").Value
	Pro_UPC =  rsJson.Fields.Item("Pro_UPC").Value
	Recibido = rsJson.Fields.Item("Recibido").Value
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