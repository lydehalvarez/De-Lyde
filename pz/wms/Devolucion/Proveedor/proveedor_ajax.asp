<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2020-DIC-10 Devolucion Decision: Archivo Nuevo

var cxnTipo = 0
var rqStrTarea = Parametro("Tarea", -1)

switch( parseInt( rqStrTarea ) ){

    //Combo de Proveedor
    case 100: {

        var sqlProv = "EXEC SPR_Proveedor "
                + "@Opcion = 100 "
        
        var rsProv = AbreTabla(sqlProv, 1, cxnTipo)
%>
        <option value="">TODOS</option>
<%
        while( !(rsProv.EOF) ){
%>
        <option value='<%= rsProv("Prov_ID").Value %>'>
            <%= rsProv("Prov_Nombre").Value %>
        </option>
<%
            rsProv.MoveNext()
        }

        rsProv.Close()

    } break;
}
%>