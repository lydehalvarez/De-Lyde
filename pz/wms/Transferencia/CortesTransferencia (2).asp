<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
{
  "data": [
<%

	var sSQLO = "  SELECT *,(SELECT Usuario FROM [dbo].[tuf_Usuario_Informacion](TA_Usuario)) Usuario"
		sSQLO += " ,CONVERT(NVARCHAR(20),TA_FechaRegistro,103) + ' '+CONVERT(NVARCHAR(20),TA_FechaRegistro,108) + ' hrs' AS FechaRegistro  "
		sSQLO += " ,(SELECT Cli_Nombre FROM Cliente WHERE Cli_ID = a.Cli_ID) Cliente  "
		sSQLO += " FROM TransferenciaAlmacen_Archivo a "
		sSQLO += " ORDER BY TA_ArchivoID DESC "
		
var i = 0
var rsJson = AbreTabla(sSQLO,1,0)

while (!rsJson.EOF){ 
	var TA_ArchivoID =  rsJson.Fields.Item("TA_ArchivoID").Value
    var TA_Cantidad =  rsJson.Fields.Item("TA_Cantidad").Value
	var TA_Usuario = rsJson.Fields.Item("Usuario").Value
	var Fecha = rsJson.Fields.Item("FechaRegistro").Value
	var Cli_ID = rsJson.Fields.Item("Cli_ID").Value
	var Cliente = rsJson.Fields.Item("Cliente").Value

%>{
    "TA_ArchivoID":"<%=TA_ArchivoID%>",
    "TA_Cantidad":"<%=TA_Cantidad%>",
    "TA_Usuario":"<%=TA_Usuario%>",
    "Fecha":"<%=Fecha%>",
    "Cli_ID":"<%=Cli_ID%>",
    "Cliente":"<%=Cliente%>"
}<%=(i < rsJson.RecordCount - 1 ) ? "," : ""  %>
<%
i++
   rsJson.MoveNext()
 }
 rsJson.Close() 
%>
	]
}