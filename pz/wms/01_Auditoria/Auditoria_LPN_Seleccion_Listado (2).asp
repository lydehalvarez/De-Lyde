<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%

var cxnTipo = 0

var rqIntAud_ID = Parametro("Aud_ID", -1)
var rqIntVisita = Parametro("Visita", -1)

var sqlLPNSel = "EXEC SPR_Auditoria_Seleccion_LPN "
        + "@Opcion = 1010 "
        + ", @Aud_ID = " + rqIntAud_ID + " "
        + ", @AudU_Veces = " + rqIntVisita + " "

var rsLPNSel = AbreTabla(sqlLPNSel, 1, cxnTipo)
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
if( !(rsLPNSel.EOF) ){
    var i = 0;
    while( !(rsLPNSel.EOF) ){
        i++;
%>
                <tr class="PT_ID" data-pt_id='<%= rsLPNSel("PT_ID").Value %>'>
                    <td><%= i %></td>
                    <td><%= rsLPNSel("Ubi_Nombre").Value %></td>
                    <td><%= rsLPNSel("PT_LPN").Value %></td>
                    <td>
                        <a><%= rsLPNSel("Pro_SKU").Value %></a>
                        <br>
                        <small><%= rsLPNSel("Pro_Nombre").Value %></small>
                    </td>
                </tr>
<%
        rsLPNSel.MoveNext()
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
rsLPNSel.Close();
%>