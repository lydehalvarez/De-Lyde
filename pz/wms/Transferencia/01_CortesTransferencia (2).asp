<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
{
  "data": [
<%

	var sSQLO = "  SELECT *,(SELECT [dbo].[fn_Usuario_DameUsuario](TA_Usuario)) Usuario"
		sSQLO += " ,CONVERT(NVARCHAR(20),TA_FechaRegistro,103) + ' '+CONVERT(NVARCHAR(20),TA_FechaRegistro,108) + ' hrs' AS FechaRegistro  "
		sSQLO += " FROM TransferenciaAlmacen_Archivo "
		sSQLO += " ORDER BY TA_ArchivoID DESC "
		
var i = 0
var rsJson = AbreTabla(sSQLO,1,0)

while (!rsJson.EOF){ 
	var TA_ArchivoID =  rsJson.Fields.Item("TA_ArchivoID").Value
	var TA_Usuario = rsJson.Fields.Item("Usuario").Value
	var Fecha = rsJson.Fields.Item("FechaRegistro").Value

%>{
    "TA_ArchivoID":"<%=TA_ArchivoID%>",
    "TA_Usuario":"<%=TA_Usuario%>",
    "Fecha":"<%=Fecha%>"
}<%=(i < rsJson.RecordCount - 1 ) ? "," : ""  %>
<%
i++
   rsJson.MoveNext()
 }
 rsJson.Close() 
%>
	]
}