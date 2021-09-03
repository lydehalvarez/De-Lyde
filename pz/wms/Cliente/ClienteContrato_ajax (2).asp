<%@LANGUAGE="JAVASCRIPT" CODEPAGE="65001"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
// HA ID: 1 2020-JUl-30 Creación de Archivo: Ajax de Cliente Contrato Corte

var cxnIntTipo = 0
var rqIntTarea = Parametro("Tarea", -1)

switch( parseInt(rqIntTarea) ){
	// Cargar Corte Combo
	case 1: {
		
		var rqIntCli_ID = Parametro("Cli_ID", -1)
		
		var sqlConCom = "SELECT CliCto.CliCto_ID "
				+ ", CliCto.CliCto_Folio "
			+ "FROM Cliente_Contrato CliCto "
			+ "WHERE CliCto.CLI_Id = " + rqIntCli_ID + " "
		
		var rsConCom = AbreTabla(sqlConCom, 1, cxnIntTipo)
%>
		<option value="-2">
        	<%= "Todos" %>
        </option>
<%
		while( !(rsConCom.EOF) ){
%>        
   		<option value="<%= rsConCom("CliCto_ID").Value %>">
        	<%= rsConCom("CliCto_Folio").Value %>
        </option>

<%		
			rsConCom.MoveNext
		}
		
		rsConCom.Close
		
	} break;
}
%>