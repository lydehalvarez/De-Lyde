<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2020-OCT-20 Cliente: Creación de archivo

var cxnTipo = 0
var rqStrTarea = Parametro("Tarea", -1)

switch( parseInt( rqStrTarea ) ){

    //Combo Cliente General
    case 100: {

        var sqlUbiAre = "EXEC SPR_Ubicacion_Area "
            + "@Opcion = 100 "
        
        var rsUbiAre = AbreTabla(sqlUbiAre, 1 ,cxnTipo)
%>
        <option value="">
            <%= "TODOS" %>
        </option>
<%
        while( !(rsUbiAre.EOF)){
%>
            <option value="<%= rsUbiAre("Are_ID").Value %>">
                <%= rsUbiAre("Are_Nombre").Value %>
            </option>
<%
            rsUbiAre.MoveNext()
        }
        rsUbiAre.Close()

    } break;
}
%>