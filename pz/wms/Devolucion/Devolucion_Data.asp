<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
[
<%
var DevC_ID = Parametro("DevC_ID",-1)

var sSQLDev = "SELECT *, [dbo].[fn_Empleado_NombreCompleto](Dev_Usuario) AS Usuario "
	sSQLDev += ", CONVERT(NVARCHAR(20),Dev_FechaRegistro,103) +' '+CONVERT(NVARCHAR(20),Dev_FechaRegistro,108) +' hrs' as FechaRegistro "
	sSQLDev += "FROM Devolucion WHERE DevC_ID = " +DevC_ID
	
	var rsDev = AbreTabla(sSQLDev,1,0)
	var i = 0
	while (!rsDev.EOF){
		var Dev_Folio = rsDev.Fields.Item("Dev_Folio").Value 
		var FechaRegistro = rsDev.Fields.Item("FechaRegistro").Value 
		var Dev_Usuario = rsDev.Fields.Item("Usuario").Value 
					                              
%>{
    "Folio":"<%=Dev_Folio%>",
    "Usuario":"<%=Dev_Usuario%>",
    "Fecha registro":"<%=FechaRegistro%>",
    "Corte":<%=DevC_ID%>
} <%= ( i < rsDev.RecordCount - 1 ) ? "," : ""  %>
<%		i++;
		rsDev.MoveNext() 
	}
rsDev.Close()   
%>

]
