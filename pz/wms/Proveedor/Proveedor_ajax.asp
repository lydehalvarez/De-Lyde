<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2021-MAR-10 Surtido: Creación de archivo

var cxnTipo = 0

var rqIntTarea = Parametro("Tarea", -1)

switch( parseInt(rqIntTarea) ){
    case 100: {

        var strOpcionEsVisible = Parametro("OpcionEsVisible", 1)
        var strOpcionValor = Parametro("OpcionValor", "")
        var strOpcionTexto = Parametro("OpcionTexto", "TODOS")

        var rqIntProv_EsPaqueteria = Parametro("Prov_EsPaqueteria", -1)
        var rqIntProv_Habilitado = Parametro("Prov_Habilitado", -1)
        
        var sqlProv = "EXEC SPR_Proveedor "
              + "@Opcion = 100 "
            + ", @Prov_EsPaqueteria = " + ( (rqIntProv_EsPaqueteria > -1) ? rqIntProv_EsPaqueteria : "NULL" ) + " "
            + ", @Prov_Habilitado = " + ( (rqIntProv_Habilitado > -1) ? rqIntProv_Habilitado : "NULL" ) + " "
        
        var rsProv = AbreTabla(sqlProv, 1 ,cxnTipo)

        if( strOpcionEsVisible == 1 ){
%>
        <option value="<%= strOpcionValor %>">
            <%= strOpcionTexto %>
        </option>
<%
        }

        while( !(rsProv.EOF)){
%>
            <option value="<%= rsProv("Prov_ID").Value %>">
                <%= rsProv("Prov_Nombre").Value %>
            </option>
<%
            rsProv.MoveNext()
        }
        rsProv.Close()

    } break;
}
%>
