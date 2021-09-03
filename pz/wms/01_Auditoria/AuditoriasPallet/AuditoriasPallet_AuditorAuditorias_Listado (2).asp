<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2021-FEB-15 Auditoria Auditor Auditoria - Listado: Creación de archivo

var cxnTipo = 0

var rqIntUsu_ID = Parametro("Usu_ID", -1)
var rqIntUbi_ID = Parametro("Ubi_ID", -1)
var rqIntPt_EstatusCG146 = Parametro("Pt_EstatusCG146", -1)
var rqStrPT_LPN = Parametro("PT_LPN", "")

var sqlAAAL = "SPR_Auditorias_Pallet "
      + "@Opcion = 1000 "
    + ", @Usu_ID = " + ( (rqIntUsu_ID > -1) ? rqIntUsu_ID : "NULL" ) + " "
    + ", @Ubi_ID = " + ( (rqIntUbi_ID > -1) ? rqIntUbi_ID : "NULL" ) + " "
    + ", @Pt_EstatusCG146 = " + ( (rqIntPt_EstatusCG146 > -1) ? rqIntPt_EstatusCG146 : "NULL" ) + " "

var rsAAAL = AbreTabla(sqlAAAL, 1, cxnTipo)

%>
<div class="ibox">
    <div class="ibox-title">
        <h4>Resultados</h4>
    </div>
    <div class="ibox-content">
        <table class="table table-hover">
            <tbody>
<%  
if( !(rsAAAL.EOF) ){

    var strColorEstatus = "white";
    var bolAuditar = false;

    while( !(rsAAAL.EOF) ){

        switch( rsAAAL("PT_EstatusCG146").Value ){
            case 1: { strColorEstatus = "danger" } break;
            case 2: { strColorEstatus = "warning" } break;
            case 3: { strColorEstatus = "success" } break;
        }

        bolAuditar = ( rsAAAL("PT_EstatusCG146").Value == 1 || rsAAAL("PT_EstatusCG146").Value == 2 );
%>
                <tr>
                    <td class="project-title">
<%
        if( bolAuditar ){
%>                        
                        <a class="btn btn-sm btn-success pull-right" style="color: white !important;" 
                        onclick='AuditoriasUbicacion.Iniciar({Aud_ID: <%= rsAAAL("Aud_ID").Value %>, PT_ID: <%= rsAAAL("PT_ID").Value %>, AudU_ID: <%= rsAAAL("AudU_ID").Value %>});'>
                            <i class="fa fa-pencil-square-o" title="Auditar"></i> 
                        </a>
<%
        }
%>
                        <small>
                            <i class="fa fa-address-card-o fa-lg"></i> Estatus:
                        </small>
                       
                        <label class="label label-<%= strColorEstatus %>">
                            <%= rsAAAL("Est_Nombre").Value %>
                        </label>
                        <br>
                        <small>
                            <i class="fa fa-map-marker fa-lg"></i> Ubicacion:
                        </small> 
                        <br>
                        <a>
                            <%= rsAAAL("Ubi_Nombre").Value %>
                        </a>
                        <br>
                        <small>
                            <i class="fa fa-inbox fa-lg"></i> LPN:
                        </small>
                        <br>
                        <a>
                            <%= rsAAAL("PT_LPN").Value %>
                        </a>
                        <br>
                        <small>
                            <i class="fa fa-tag fa-lg"></i> Producto:
                        </small>
                        <br>
                        <a>
                            <%= rsAAAL("Pro_SKU").Value %> - <%= rsAAAL("Pro_Nombre").Value %>
                        </a>
                    </td>
                </tr>
<%
        Response.Flush()
        rsAAAL.MoveNext()
    }
} else {
%>
                <tr>
                    <td>
                        <i class="fa fa-exclamation-circle-o text-info"></i> No hay registros
                    </td>
                </tr>
<%
}

rsAAAL.Close()
%>
            </tbody>
        </table>
    </div>
</div>

