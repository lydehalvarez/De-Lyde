 <%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../../../Includes/iqon.asp" -->
[
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
%>{
    "Vacio1":"|",
    "Vacio2":"|",
    "Serie":"<%=MovS_Serie%>|",
    "Vacio3":"|",
    "Vacio4":"|",
    "Vacio5":"|",
    "Vacio6":"|",
    "Vacio7":"|",
    "Vacio8":"|",
    "Vacio9":"|",
    "Caja master":"<%=CajaMaster%>|",
    "Pallet":"<%=Pallet%>"
}<%=(i < rsJson.RecordCount - 1 ) ? "," : ""  %>
<%
i++;
   rsJson.MoveNext()
 }
 rsJson.Close() 
%>
]