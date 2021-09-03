<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2020-ENE-05 Surtido: Creación de archivo

var cxnTipo = 0

var dateFechaDefault = new Date()

var rqIntProv_ID = Parametro("Prov_ID", -1)
var rqIntTipo = Parametro("Tipo", 1)
var rqDateFecha = Parametro("Fecha", dateFechaDefault)
var rqIntEsTransportista = Parametro("EsTransportista", -1)
var rqIntCli_ID = Parametro("Cli_ID", -1)

var dateFechaInicial = ( ( rqIntTipo == 1 ) ? "'" + rqDateFecha  + "'": "NULL" );
var dateFechaFinal = "'" + rqDateFecha  + "'"

var bolHayProv = (rqIntEsTransportista == 1)

var sqlDasLis = "EXEC SPR_MProveedor "
      + "@Opcion = 1000 "
    + ", @Prov_ID = " + ( (rqIntProv_ID > -1) ? rqIntProv_ID : "NULL" ) + " "
    + ", @Cli_ID = " + ( (rqIntCli_ID > -1) ? rqIntCli_ID : "NULL" ) + " "
    + ", @FechaInicial = " + dateFechaInicial + " "
    + ", @FechaFinal = " + dateFechaFinal + " "
    + ", @Est_IDs = '5,6,7,8' "

var rsDasLis = AbreTabla(sqlDasLis, 1, cxnTipo)

%>
     <div class="ibox">
        <div class="ibox-title">
            <h3>Entregas: <span class="text-success" id="spanProvLisDias"></span> </h3>
            <div class="ibox-tools">
                <button type="button" class="btn btn-white btn-sm" onclick="MProveedor.Dashboard.Exportar()">
                    <i class="fa fa-file-excel-o"></i> Exportar
                </button>
            </div>
        </div>
        <div class="ibox-content">
        
            <div class="table-responsive">
                <table class="table table-hover">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th class="col-sm-2">Estatus</th>
                            <th class="col-sm-2">Folio/Fecha Salida</th>
                            <th class="col-sm-3">Folio</th>
<% 
if( !(bolHayProv) ){ 
%>
                            <th class="col-sm-2">Transportista</th>
<%
}
%>
                            <th class="col-sm-2">Gu&iacute;a</th>
                            <th class="col-sm-2">Fecha Compromiso</th>
                            <th class="col-sm-1"></th>
                        </tr>
                    </thead>
                    <tbody>
<%
if( !(rsDasLis.EOF) ){

    var i = 0;
    var strColor = ""

    while( !(rsDasLis.EOF) ){
        i++;

        switch( parseInt( rsDasLis("Est_ID").Value ) ){
            case 5: { strColor = "success" } break;     // transito
            case 6: { strColor = "info" } break;        // 1er Vuelta
            case 7: { strColor = "warning" } break;     // 2da Vuelta
            case 8: { strColor = "danger" } break;      // 3ra Vuelta
        }
%>
                        <tr>
                            <td><%= i %></td>
                            <td class="project-status">
                                <span class="label label-<%= strColor %>">
                                    <%= rsDasLis("Est_Nombre").Value %>
                                </span>
                            </td>
                            <td>
                                <a class="project-title text-danger">
                                    <%= rsDasLis("Man_Folio").Value %>
                                </a>
                                <br>
                                <small>
                                    <i class="fa fa-clock-o"></i> <%= rsDasLis("Man_FechaConfirmado").Value %>
                                </small>
                            </td>
                            <td>
                                <a class="project-title text-success">
                                    <%= rsDasLis("Folio").Value %>
                                </a>
                                <br>
                                <small>
                                    <%= rsDasLis("Almacen").Value %>
                                </small>
                            </td>
<% 
if( !(bolHayProv) ){ 
%>
                            <td class="project-title">
                                <a>
                                    <%= rsDasLis("Transportista").Value %>
                                </a>
                                <br>
                                <small>
                                    <%= rsDasLis("TipoRuta").Value %>
                                </small>
                            </td>
<%
}
%>
                            <td>
                                <%= rsDasLis("Guia").Value %>
                            </td>
                            <td>
                                <%= rsDasLis("Man_FechaCompromiso").Value %>
                            </td>
                            <td>
                                <a class="btn btn-white btn-sm" onclick='MProveedor.DetalleVer({TA_ID: <%= rsDasLis("TA_ID").Value %>, OV_ID: <%= rsDasLis("OV_ID").Value %>});'>
                                    <i class="fa fa-file-text-o"></i> Ver
                                </a>
                            </td>
                        </tr>
<%
        rsDasLis.MoveNext()
    }

} else {
%>
                        <tr>
                            <td colspan="7">
                                <i class="fa fa-exclamation-circle-o text-success"></i> No hay Registros
                            </td>
                        </tr>
<%    
}
%>
                    </tbody>
                </table>
            </div>        
    
        </div>
    </div>
<%
rsDasLis.Close()
%>