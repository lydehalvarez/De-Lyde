<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2021-ENE-04 Estado: Creación de archivo

var cxnTipo = 0
var rqStrTarea = Parametro("Tarea", -1)

switch( parseInt( rqStrTarea ) ){

     //Opcion Ubicacion
    case 100: {
        
        var strOpcionDefaultValor = Parametro("OpcionDefaultValor", "");
        var strOpcionDefaultTexto = Parametro("OpcionDefaultTexto", "TODOS")
        var bolOpcionDefaultEsVisible = Parametro("OpcionDefaultEsVisible", 1);

        var sqlEdo = "EXEC SPR_CAT_Estado "
              + "@Opcion = 100 "

        var rsEdo = AbreTabla(sqlEdo, 1, cxnTipo)

        if( bolOpcionDefaultEsVisible == 1 ){
%>
        <option value="<%= strOpcionDefaultValor %>">
            <%= strOpcionDefaultTexto %> 
        </option>
<%
        }

        while( !(rsEdo.EOF) ){
%>
        <option value='<%= rsEdo("Edo_ID").Value %>'>
            <%= rsEdo("Edo_Nombre").Value %>
        </option>
<%
            rsEdo.MoveNext()
        }

        rsEdo.Close()

    } break
}
%>