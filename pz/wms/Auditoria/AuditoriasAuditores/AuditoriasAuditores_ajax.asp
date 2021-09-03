<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2021-FEB-20 Auditorias Auditores: Creación de archivo

var cxnTipo = 0
var rqStrTarea = Parametro("Tarea", -1)

switch( parseInt( rqStrTarea ) ){

    //Combo Auditorias Auditores General
    case 100: {
        
        var rqIntAud_Habilitado = Parametro("Aud_Habilitado", -1)
        var rqIntAud_Externo = Parametro("Aud_Externo", -1)

        var sqlAUA = "EXEC SPR_Auditorias_Auditores "
              + "@Opcion = 100 "
            + ", @Aud_Externo = " + ( (rqIntAud_Externo > -1) ? rqIntAud_Externo : "NULL") + " "
            + ", @Aud_Habilitado = " + ( (rqIntAud_Habilitado > -1) ? rqIntAud_Habilitado : "NULL") + " "

        
        var rsAUA = AbreTabla(sqlAUA, 1 ,cxnTipo)
%>
        <option value="">
            <%= "TODOS" %>
        </option>
<%
        while( !(rsAUA.EOF)){
%>
            <option value="<%= rsAUA("Usu_ID").Value %>">
                <%= rsAUA("Usu_Nombre").Value %>
            </option>
<%
            rsAUA.MoveNext()
        }
        rsAUA.Close()

    } break;
}
%>