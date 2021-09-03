<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2021-JUN-03 Tiedas y entregas: Creación de archivo

var cxnTipo = 0

var rqIntAre_ID = Parametro("Area", "-1")
var rqIntRac_ID = Parametro("Rack", "-1")
var rqStrNombre = Parametro("Nombre", "")
var rqIntTipoDisponibilidad = Parametro("TipoDisponibilidad", "-1")

var sqlUbiDis = "EXEC SPR_Ubicacion_Disponibilidad "
      + "@Opcion = 1100 "
    + ", @Are_ID = " + (( rqIntAre_ID > -1 ) ? rqIntAre_ID : "NULL" ) + " "
    + ", @Rac_ID = " + (( rqIntRac_ID > -1 ) ? rqIntRac_ID : "NULL" ) + " "
    + ", @Nombre = " + ( (rqStrNombre.length > 0) ? "'" + rqStrNombre + "'" : "NULL" ) + " "
    + ", @TipoDisponibilidad = " + (( rqIntTipoDisponibilidad > -1 ) ? rqIntTipoDisponibilidad : "NULL" ) + " "
    
var rsUbiDis = AbreTabla(sqlUbiDis, 1, cxnTipo)

while( !(rsUbiDis.EOF) ){

%>
    <tr class="cssReg">
        <td><%= rsUbiDis("ID").Value %></td>
        <td><%= rsUbiDis("Are_Nombre").Value %></td>
        <td><%= rsUbiDis("Rac_Nombre").Value %></td>
        <td><%= rsUbiDis("Ubi_Nombre").Value %></td>
    </tr>
<%
    rsUbiDis.MoveNext()
}

rsUbiDis.Close()
%>