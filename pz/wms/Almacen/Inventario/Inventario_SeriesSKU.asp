<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../../Includes/iqon.asp" -->
[
<%
	var SKU = Parametro("SKU",-1)
	var Cli_ID = Parametro("Cli_ID",-1)

	var sSQL = "SELECT Inv.Inv_ID "
			+ ", Inv.Inv_Serie, Inv.Inv_RFID, "
  			+ ", Inv.Inv_Masterbox "
			+ ", pt.Pt_LPN"
			+ ", u.Ubi_Nombre"
			+ ", Pro.Pro_SKU "
			+ ", Pro.Pro_Nombre "
			+", Inv.Inv_FechaRegistro"
			+ ", Est.Cat_Nombre AS Est_Nombre "
			+ "FROM Inventario Inv "
			+ "INNER JOIN Producto Pro "
			+ "ON Inv.Pro_ID = Pro.Pro_ID "
			+ "LEFT JOIN Cat_Catalogo Est "
			+ "ON Inv.Inv_EstatusCG20 = Est.Cat_ID "
			+ "AND Est.SEC_ID = 20 "
			+	" LEFT JOIN Pallet pt"
			+ " ON pt.Pt_ID=Inv.Pt_ID"
			+ " LEFT JOIN Ubicacion u"
			+ " ON u.Ubi_ID=Inv.Ubi_ID "
			+ "WHERE Pro_SKU = '" + SKU + "' "
			+ " AND Inv.Inv_EstatusCG20 =1"
			+ " AND Inv.Inv_EnAlmacen in (0,1)"	
	if( Cli_ID > -1 ){
		sSQL += " AND Inv.Cli_ID = " + Cli_ID + " "
	}
		sSQL += " ORDER BY Inv.Ubi_ID, Inv.Pt_ID, Inv_Masterbox"		
var i = 0
//Response.Write(sSQL)
var rsJson = AbreTabla(sSQL,1,0)

while (!rsJson.EOF){ 
	var Inv_ID =  rsJson.Fields.Item("Inv_ID").Value
	var Ubi_Nombre =  rsJson.Fields.Item("Ubi_Nombre").Value
	var Pt_LPN =  rsJson.Fields.Item("Pt_LPN").Value
	var Inv_Serie =  rsJson.Fields.Item("Inv_Serie").Value
	var Inv_RFID =  rsJson.Fields.Item("Inv_RFID").Value
	var Inv_Masterbox =  rsJson.Fields.Item("Inv_Masterbox").Value
	var Pro_SKU =  rsJson.Fields.Item("Pro_SKU").Value
	var Pro_Nombre = DSITrim(rsJson.Fields.Item("Pro_Nombre").Value)
	var Fecha = rsJson.Fields.Item("Inv_FechaRegistro").Value
%>
<%=(i > 0 ) ? "," : ""  %>
{
    "Ubicacion":"<%=Ubi_Nombre%>",
	"LPN":"<%=Pt_LPN%>",
    "Masterbox":"<%= Inv_Masterbox %>",
   "Serie":"<%= Inv_Serie %>",
   "RFID":"<%= Inv_RFID%>",
    "SKU":"<%= Pro_SKU %>",
    "Nombre":"<%= Pro_Nombre %>",
    "Fecha Registro": "<%= Fecha %>"
}
<%
i++;
   rsJson.MoveNext()
 }
 rsJson.Close()

%>]

