<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2021-FEB-15 Auditorias Pallet: Creación de archivo

var cxnTipo = 0

var rqTarea = Parametro("Tarea", -1)

switch( parseInt(rqTarea) ){
    // Combo - Ubicacion Auditorias - Auditor
    case 101: {

        var rqIntUsu_Id = Parametro("Usu_ID", -1)

        var sqlUsuUbi = "EXEC SPR_Auditorias_Pallet "
              + "@Opcion = 101 "
            + ", @Usu_ID = " + ( (rqIntUsu_Id > -1) ? rqIntUsu_Id : "NULL" )  + " "

        var rsUsuUbi = AbreTabla(sqlUsuUbi, 1, cxnTipo)
%>
        <option value="">TODOS</option>
<%
        while( !(rsUsuUbi.EOF) ){
%>
        <option value='<%= rsUsuUbi("Ubi_ID").value %>'>
            <%= rsUsuUbi("Ubi_Nombre").value %>
        </option>
<%
            rsUsuUbi.MoveNext()
        }

    } break;

}
%>