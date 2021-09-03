 <%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../../../Includes/iqon.asp" -->
<%
	var Mov_ID = Parametro("Mov_ID",-1)
	
	var sSQLO = "  SELECT "
		sSQLO += "(SELECT MovP_LPN FROM Movimiento_Pallet WHERE Mov_ID = a.Mov_ID AND MovP_ID = a.MovP_ID) Pallet "
		sSQLO += " ,(SELECT MovM_FolioCaja FROM Movimiento_Pallet_Master WHERE Mov_ID = a.Mov_ID  AND MovP_ID = a.MovP_ID AND MovM_ID = a.MovM_ID) CajaMaster"
		sSQLO += " ,MovS_Serie "
		sSQLO += " FROM Movimineto_Pallet_Master_Serie a "
		sSQLO += " WHERE Mov_ID = "+Mov_ID
		

var i = 0
var rsJson = AbreTabla(sSQLO,1,0)

while (!rsJson.EOF){ 
	var Pallet =  rsJson.Fields.Item("Pallet").Value
	var MovS_Serie =  rsJson.Fields.Item("MovS_Serie").Value
	var CajaMaster =  rsJson.Fields.Item("CajaMaster").Value
%>||<%=MovS_Serie%>||||||||<%=CajaMaster%>|<%=Pallet%><%=(i < rsJson.RecordCount - 1 ) ? "\r\n" : ""  %><%
i++;
   rsJson.MoveNext()
 }
 rsJson.Close() 
%>