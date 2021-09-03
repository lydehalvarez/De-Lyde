<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
{
  "data": [
<%

	var sSQLO = "  SELECT *"
		sSQLO += " , (SELECT Cat_Nombre FROM Cat_Catalogo h WHERE h.Sec_ID = 51 AND h.Cat_ID = a.OV_EstatusCG51) Estatus"
		sSQLO += " FROM Orden_Venta a"
		sSQLO += " WHERE OV_Test = 1"
		sSQLO += " AND Cort_ID = 0"
		sSQLO += " ORDER BY OV_ID DESC "
		
	var sSQLNUM = "  SELECT COUNT(OV_ID) Cantidad"
		sSQLNUM += " FROM Orden_Venta"
		sSQLNUM += " WHERE OV_Test = 1"
		sSQLNUM += " AND Cort_ID = 0"

var rsCan = AbreTabla(sSQLNUM,1,0)
if(!rsCan.EOF){ 
	var Canti =  rsCan.Fields.Item("Cantidad").Value
}
var rsJson = AbreTabla(sSQLO,1,0)
var numElementos = 0
while (!rsJson.EOF){ 
	var OV_ID =  rsJson.Fields.Item("OV_ID").Value
	var OV_Folio =  rsJson.Fields.Item("OV_Folio").Value
	var Estatus =  rsJson.Fields.Item("Estatus").Value
	var OV_FechaRegistro =  rsJson.Fields.Item("OV_FechaRegistro").Value
	numElementos++
%>{
    "id":<%=OV_ID%>,
    "Folio":"<%=OV_Folio%>",
    "Estatus":"<%=Estatus%>",
    "Fecha":"<%=OV_FechaRegistro%>"
}<%if(numElementos < Canti){Response.Write(",")}%>
<%

   rsJson.MoveNext()
 }
 rsJson.Close() 
%>
	]
}