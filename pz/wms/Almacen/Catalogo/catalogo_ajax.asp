<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2020-OCT-20 Orden Movimiento: Creación de archivo

var cxnTipo = 0
var rqStrTarea = Parametro("Tarea", -1)

switch( parseInt( rqStrTarea ) ){

    //Cargar Combo
    case 100: {

        var rqIntSec_ID = Parametro("Sec_ID", -1)
        var rqIntCat_ID = Parametro("Cat_ID", -1)
        var rqIntCat_Tipo = Parametro("Cat_Tipo", -1)
        var rqIntCat_Maximo = Parametro("Cat_Maximo", -1) 
        var rqStrCat_IDs = Parametro("Cat_IDs", "")

        var sqlCat = "EXEC SPR_Cat_Catalogo "
              + "@Opcion = 100 /*Combo General*/ "
            + ", @SEC_ID = " + ((rqIntSec_ID > -1) ? rqIntSec_ID : "NULL" ) + " "
            + ", @CAT_ID = " + ((rqIntCat_ID > -1) ? rqIntCat_ID : "NULL" ) + " "
            + ", @CAT_Tipo = " + ((rqIntCat_Tipo > -1) ? rqIntCat_Tipo : "NULL" ) + " "
            + ", @Cat_Maximo = " + ((rqIntCat_Maximo > -1) ? "'" + rqIntCat_Maximo + "'" : "NULL" ) + " "
            + ", @Cat_IDs = " + ( (rqStrCat_IDs.length > 0) ? "'" + rqStrCat_IDs + "'" : "NULL" ) + " "
        
        var rsCat = AbreTabla(sqlCat, 1, cxnTipo)
%>
        <option value="">
            <%= "TODOS" %>
        </option>
<%
        while( !(rsCat.EOF) ){
%>
            <option value="<%= rsCat("Cat_ID").Value %>" title="<%= rsCat("Cat_Descripcion").Value %>">
                <%= rsCat("Cat_Nombre").Value %>
            </option>
<%
            rsCat.MoveNext()
        }

        rsCat.Close();

    } break;
}
%>