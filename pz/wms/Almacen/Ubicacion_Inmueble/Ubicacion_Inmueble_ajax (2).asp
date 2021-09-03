<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2020-OCT-20 Cliente: Creación de archivo

var cxnTipo = 0
var rqStrTarea = Parametro("Tarea", -1)

switch( parseInt( rqStrTarea ) ){

    //Combo Cliente General
    case 100: {

        var sqlUbiInm = "EXEC SPR_Ubicacion_Inmueble "
            + "@Opcion = 100 "
        
        var rsUbiInm = AbreTabla(sqlUbiInm, 1 ,cxnTipo)
%>
        <option value="">
            <%= "TODOS" %>
        </option>
<%
        while( !(rsUbiInm.EOF)){
%>
            <option value="<%= rsUbiInm("Inm_ID").Value %>">
                <%= rsUbiInm("Inm_Nombre").Value %>
            </option>
<%
            rsUbiInm.MoveNext()
        }
        rsUbiInm.Close()

    } break;
}
%>