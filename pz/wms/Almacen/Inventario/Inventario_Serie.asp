<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../../Includes/iqon.asp" -->
[
<%
	var Pt_ID = Parametro("Pt_ID",-1)
	var Cli_ID = Parametro("Cli_ID",-1)

	var sSQL = "SELECT Inv.Inv_ID "
			+ ", Inv.Inv_Serie, Inv.Inv_Masterbox "
			+ ", Pro.Pro_SKU "
			+ ", Pro.Pro_Nombre "
			+ ", Est.Cat_Nombre AS Est_Nombre "
			+ "FROM Inventario Inv "
			+ "INNER JOIN Producto Pro "
			+ "ON Inv.Pro_ID = Pro.Pro_ID "
			+ "LEFT JOIN Cat_Catalogo Est "
			+ "ON Inv.Inv_EstatusCG20 = Est.Cat_ID "
			+ "AND Est.SEC_ID = 20 "
			+ "WHERE Pt_ID = " + Pt_ID 
	
	if( Cli_ID > -1 ){
		sSQL += " AND Inv.Cli_ID = " + Cli_ID + " "
	}
		sSQL += "  ORDER BY Inv_Masterbox"
var i = 0
var rsJson = AbreTabla(sSQL,1,0)

while (!rsJson.EOF){ 
	var Inv_Masterbox =  rsJson.Fields.Item("Inv_Masterbox").Value
	var Inv_Serie =  rsJson.Fields.Item("Inv_Serie").Value
	var Pro_SKU =  rsJson.Fields.Item("Pro_SKU").Value
	var Pro_Nombre = DSITrim(rsJson.Fields.Item("Pro_Nombre").Value)
	var Est_Nombre = rsJson.Fields.Item("Est_Nombre").Value
%>
<%=(i > 0 ) ? "," : ""  %>
{
    "Serie":"<%= Inv_Serie %>",
    "Masterbox":"<%= Inv_Masterbox %>",
    "SKU":"<%= Pro_SKU %>",
    "Nombre":"<%= Pro_Nombre %>"
}
<%
i++;
   rsJson.MoveNext()
 }
 rsJson.Close()

%>]

