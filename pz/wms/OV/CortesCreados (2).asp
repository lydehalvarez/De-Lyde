<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
{
  "data": [
<%

	var sSQLO = "  SELECT * "
		sSQLO += ",(SELECT [dbo].[fn_Usuario_DameUsuario](Cort_Usuario)) Usuario "
		sSQLO += "FROM Orden_Venta_Corte a  "
		
	var sSQLNUM = "  SELECT COUNT(Cort_ID) Cantidad"
		sSQLNUM += " FROM Orden_Venta_Corte"

var rsCan = AbreTabla(sSQLNUM,1,0)
if(!rsCan.EOF){ 
	var Canti =  rsCan.Fields.Item("Cantidad").Value
}
var rsJson = AbreTabla(sSQLO,1,0)
var numElementos = 0
while (!rsJson.EOF){ 
	var Cort_ID =  rsJson.Fields.Item("Cort_ID").Value
	var Cort_Usuario =  rsJson.Fields.Item("Usuario").Value
	var Fecha =  rsJson.Fields.Item("Cort_FechaRegistro").Value
	numElementos++
%>{
    "Cort_ID":"<%=Cort_ID%>",
    "Cort_Usuario":"<%=Cort_Usuario%>",
    "Fecha":"<%=Fecha%>"
}<%if(numElementos < Canti){Response.Write(",")}%>
<%

   rsJson.MoveNext()
 }
 rsJson.Close() 
%>
	]
}