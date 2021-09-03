<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
{
  "data": [
<%
	var Cli_ID = Parametro("Cli_ID",-1)
	
	var sSQLO = "  SELECT * "
		sSQLO += " , ct.Cat_Nombre as Estatus "
		sSQLO += " ,CONVERT(NVARCHAR(20),TA_FechaRegistro,103) + ' '+CONVERT(NVARCHAR(20),TA_FechaRegistro,108) + ' hrs' AS FechaRegistro  "
		sSQLO += " FROM TransferenciaAlmacen a, Cat_Catalogo ct "
		sSQLO += " WHERE TA_ArchivoID = -1 AND ct.Sec_ID = 51 AND ct.Cat_ID = a.TA_EstatusCG51"
		sSQLO += " AND TA_Cancelada = 0 "
		sSQLO += " AND TA_EstatusCG51 != 11 "
		sSQLO += " AND Cli_ID = "+Cli_ID
		sSQLO += " AND TA_TipoTransferenciaCG65 = 2 "
		sSQLO += " ORDER BY TA_ID DESC "
		


var i = 0
var rsJson = AbreTabla(sSQLO,1,0)

while (!rsJson.EOF){ 
	var TA_ID =  rsJson.Fields.Item("TA_ID").Value
	var TA_Folio =  rsJson.Fields.Item("TA_Folio").Value
	var Estatus =  rsJson.Fields.Item("Estatus").Value
	var TA_FechaRegistro = rsJson.Fields.Item("FechaRegistro").Value
%>{
    "id":<%=TA_ID%>,
    "Folio":"<%=TA_Folio%>",
    "Estatus":"<%=Estatus%>",
    "Fecha":"<%=TA_FechaRegistro%>"
}<%=(i < rsJson.RecordCount - 1 ) ? "," : ""  %>
<%
i++;
   rsJson.MoveNext()
 }
 rsJson.Close() 
%>
	]
}