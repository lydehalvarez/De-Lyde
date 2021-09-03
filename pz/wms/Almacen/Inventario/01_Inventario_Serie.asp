<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../../Includes/iqon.asp" -->
[
<%
	var Pt_ID = Parametro("Pt_ID",-1)
	var Cli_ID = Parametro("Cli_ID","")

	var sSQL = "SELECT Inv_ID,Inv_Serie,Pro_SKU,Pro_Nombre "
		sSQL += " FROM Inventario a, Producto b "
		sSQL += " WHERE Pt_ID = "+Pt_ID 
		sSQL += " AND a.Cli_ID = "+Cli_ID
		sSQL += " AND a.Pro_ID = b.Pro_ID "
		
var i = 0
var rsJson = AbreTabla(sSQL,1,0)

while (!rsJson.EOF){ 
	var Inv_ID =  rsJson.Fields.Item("Inv_ID").Value
	var Inv_Serie =  rsJson.Fields.Item("Inv_Serie").Value
	var Pro_SKU =  rsJson.Fields.Item("Pro_SKU").Value
	var Pro_Nombre = DSITrim(rsJson.Fields.Item("Pro_Nombre").Value)
%>{
    "ID":<%=Inv_ID%>,
    "Serie":"<%=Inv_Serie%>",
    "SKU":"<%=Pro_SKU%>",
    "Nombre":"<%=Pro_Nombre%>"
}<%=(i < rsJson.RecordCount - 1 ) ? "," : ""  %>
<%
i++;
   rsJson.MoveNext()
 }
 rsJson.Close()

%>]

