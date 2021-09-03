<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2020-OCT-20 Cliente: Creación de archivo

var cxnTipo = 0
var rqStrTarea = Parametro("Tarea", -1)

switch( parseInt( rqStrTarea ) ){

    //Combo Cliente General
    case 100: {
        
        var rqIntUsaNotaEntrada = Parametro("UsaNotaEntrada", -1)

        var sqlCli = "EXEC SPR_Cliente "
              + "@Opcion = 100 "
            + ", @Cli_UsaNotaEntrada = " + ( (rqIntUsaNotaEntrada > -1) ? rqIntUsaNotaEntrada : "NULL") + " "
        
        var rsCli = AbreTabla(sqlCli, 1 ,cxnTipo)
%>
        <option value="">
            <%= "TODOS" %>
        </option>
<%
        while( !(rsCli.EOF)){
%>
            <option value="<%= rsCli("Cli_ID").Value %>">
                <%= rsCli("Cli_Nombre").Value %>
            </option>
<%
            rsCli.MoveNext()
        }
        rsCli.Close()

    } break;
}
%>