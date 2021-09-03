<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
var cxnTipo = 0

var rqStrSKUs = Parametro("SKUs", "")
var rqStrUbicaciones = Parametro("Ubicaciones", "")
var rqStrLPNs = Parametro("LPNs", "")
var rqIntAud_ID = Parametro("Aud_ID", -1)

var sqlAudLPN = "EXEC SPR_Auditoria_Seleccion_LPN "
      + "@Opcion = 1000 "
	+ ", @Aud_ID = " + ( (rqIntAud_ID > -1) ? rqIntAud_ID : "NULL" ) + " "
    + ", @SKUs = " + ( (rqStrSKUs.length > 0) ? "'" + rqStrSKUs + "'" : "NULL") + " "
    + ", @Ubicaciones = " + ( (rqStrUbicaciones.length > 0) ? "'" + rqStrUbicaciones + "'" : "NULL" ) + " "
    + ", @LPNs = " + ( (rqStrLPNs.length > 0) ? "'" + rqStrLPNs + "'" : "NULL" ) + " "

var rsAudLPN = AbreTabla(sqlAudLPN, 1, cxnTipo)
%>

<div class="ibox">
    <div class="ibox-title">
        <h4>Resultados</h4>
    </div>
    <div class="ibox-content">
        <table class="table table-hover">
            <thead>
                <tr>
                    <th class="col-sm-1">#</th>
                    <th class="col-sm-3">Ubicaci&oacute;n</th>
                    <th class="col-sm-3">LPN</th>
                    <th class="col-sm-5">SKU</th>
                </tr>
            </thead>
            <tbody>
<%  
if( !(rsAudLPN.EOF) ){
    var i = 0;
    while( !(rsAudLPN.EOF) ){
        i++;
%>
                <tr class="PT_ID" data-pt_id='<%= rsAudLPN("PT_ID").Value %>'>
                    <td><%= i %></td>
                    <td><%= rsAudLPN("Ubi_Nombre").Value %></td>
                    <td><%= rsAudLPN("PT_LPN").Value %></td>
                    <td>
                        <a><%= rsAudLPN("Pro_SKU").Value %></a>
                        <br>
                        <small><%= rsAudLPN("Pro_Nombre").Value %></small>
                    </td>
                </tr>
<%
        rsAudLPN.MoveNext()
    }
} else {
%>
                <tr colspan="4">
                    <i class="fa fa-exclamation-circle-o"></i> No hay Registros
                </tr>
<%
}
%>                
            </tbody>
        </table>
    </div>
</div>
<%
rsAudLPN.Close();
%>

