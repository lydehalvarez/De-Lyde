<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2020-OCT-20 Cliente: Creación de archivo

var cxnTipo = 0
var rqStrTarea = Parametro("Tarea", -1)

switch( parseInt( rqStrTarea ) ){

    //Combo Cliente General
    case 100: {

        var sqlUbiPro = "EXEC SPR_Producto "
            + "@Opcion = 100 "
        
        var rsUbiPro = AbreTabla(sqlUbiPro, 1 ,cxnTipo)
%>
        <option value="">
            <%= "TODOS" %>
        </option>
<%
        while( !(rsUbiPro.EOF)){
%>
            <option value="<%= rsUbiPro("Pro_ID").Value %>">
                <%= rsUbiPro("Pro_SKU").Value %> - <%= rsUbiPro("Pro_Nombre").Value %>
            </option>
<%
            rsUbiPro.MoveNext()
        }
        rsUbiPro.Close()

    } break;
}
%>