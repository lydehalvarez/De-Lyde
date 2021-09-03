<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%

// HA ID: 2 Busqueda de Objetivos: Cambio de Esquema

var cxnTipo = 0

var rqIntAud_ID = Parametro("Aud_ID", -1)
var rqIntTipoBusqueda = Parametro("TipoBusqueda", -1)
var rqStrTexto = Parametro("Texto", "")

var rqStrSKUs = "";
var rqStrUbicaciones = "";
var rqStrLPNs = "";

switch( parseInt(rqIntTipoBusqueda) ){
    // SKU
    case 1: { rqStrSKUs = rqStrTexto } break;
    case 2: { rqStrUbicaciones = rqStrTexto } break;
    case 3: { rqStrLPNs = rqStrTexto } break;
}   

var sqlAudLPN = "EXEC SPR_Auditoria_Seleccion_LPN "
      + "@Opcion = 1000 "
	+ ", @Aud_ID = " + ( (rqIntAud_ID > -1) ? rqIntAud_ID : "NULL" ) + " "
    + ", @SKUs = " + ( (rqStrSKUs.length > 0) ? "'" + rqStrSKUs + "'" : "NULL") + " "
    + ", @Ubicaciones = " + ( (rqStrUbicaciones.length > 0) ? "'" + rqStrUbicaciones + "'" : "NULL" ) + " "
    + ", @LPNs = " + ( (rqStrLPNs.length > 0) ? "'" + rqStrLPNs + "'" : "NULL" ) + " "

//Response.Write(sqlAudLPN)

var rsAudLPN = AbreTabla(sqlAudLPN, 1, cxnTipo)

if( !(rsAudLPN.EOF) ){
    var i = 0;
	var Pt_ID = -1
    while( !(rsAudLPN.EOF) ){
		Pt_ID = rsAudLPN("PT_ID").Value
        i++;
%>
    <li class='info-element toAdd cssMdlAudSelLpnLisBusReg' id="toAdd<%=Pt_ID%>">
        <div class='pull-right'>
            <a class='btn btn-xs btn-success cssbtnAccion' onclick='AuditoriaSeleccionLPN.ListadoObjetivosBuscados.Agregar({Objeto: this,Pt_ID:<%=Pt_ID%>});'>
                <i class='fa fa-plus'></i> Agregar
            </a>
        </div>
        <h3>
            <input type='checkbox' value='<%= Pt_ID %>'
            onclick='AuditoriaSeleccionLPN.ListadoObjetivosBuscados.Seleccionar();'>&nbsp;
            <span class='cssMdlAudSelLpnLisLpn textCopy'>
                <%= rsAudLPN("PT_LPN").Value %>
            </span>
        </h3>
        <div class='row'> 
            <div class='col-sm-12'>
                <i class='fa fa-tag'></i> <span class='cssMdlAudSelLpnLisPro'> <span class="textCopy"><strong><%= rsAudLPN("Pro_SKU").Value %></strong></span> - <span class="textCopy"><%= rsAudLPN("Pro_Nombre").Value %></span></span>
            </div>
        </div>
        <div class='agile-detail'> 
            <i class='fa fa-map-signs'></i> <span class='cssMdlAudSelLpnLisUbi'><span class="textCopy"><strong><%= rsAudLPN("Ubi_Nombre").Value %></strong></span></span>
        </div>
    </li>
<%
        Response.Flush()
        rsAudLPN.MoveNext()
    }
}else{%>
<li class='danger-element'>
	<h2>No se encontr&oacute; informaci&oacute;n</h2>	
</li>
	
<%}
%>                
            </tbody>
        </table>
    </div>
</div>
<%
rsAudLPN.Close();
%>

