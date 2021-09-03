 <%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../../../Includes/iqon.asp" -->
<%
	var Mov_ID = Parametro("Mov_ID",-1)
	var Hora = Parametro("Hora",-1)
	var Minutes = Parametro("Minutes",-1)
	var Fecha = Parametro("Fecha","")
	var Factura = Parametro("Factura","")
	var Clave = Parametro("Clave","")
	var SKU = Parametro("SKU","")
	
	
	var sSQLO = "  SELECT "
		sSQLO += "(SELECT MovP_LPN FROM Movimiento_Pallet WHERE Mov_ID = a.Mov_ID AND MovP_ID = a.MovP_ID) Pallet "
		sSQLO += " ,(SELECT MovM_FolioCaja FROM Movimiento_Pallet_Master WHERE Mov_ID = a.Mov_ID  AND MovP_ID = a.MovP_ID AND MovM_ID = a.MovM_ID) CajaMaster"
		sSQLO += " ,MovS_Serie "
		sSQLO += " FROM Movimineto_Pallet_Master_Serie a "
		sSQLO += " WHERE Mov_ID = "+Mov_ID
		

var i = 0
var rsJson = AbreTabla(sSQLO,1,0)

if(!rsJson.EOF){ 
%>WM|<%=Clave%>|<%=Factura%>|MF_CON_LB_<%=Factura%>_<%=Fecha%>.BAN|MF_SER_LB_<%=Factura%>_<%=Fecha%>.DAT|<%=Fecha%>|<%=Hora%>:<%=Minutes%>|<%=rsJson.RecordCount%>|<%=SKU%><%
}
%>