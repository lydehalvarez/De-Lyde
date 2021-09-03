<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2021-ENE-26 Devoulcion Decisión: Archivo Nuevo
var cxnTipo = 0

var rqStrFolio = Parametro("Folio", "")
var rqStrPro_SKU = Parametro("Pro_SKU", "")
var rqIntCli_ID = Parametro("Cli_ID", -1)
var rqDateFechaInicial = Parametro("FechaInicial", "")
var rqDateFechaFinal = Parametro("FechaFinal", "")

var sqlNE = "SPR_NotaEntrada "
        + "@Opcion = 1 "
        + ", @Folio = " + ( (rqStrFolio.length > 0) ? "'" + rqStrFolio + "'" : "NULL" ) + " "
        + ", @Pro_SKU = " + ( (rqStrPro_SKU.length > 0) ? "'" + rqStrPro_SKU + "'"  : "NULL" ) + " "
        + ", @Cli_ID = " + ( (rqIntCli_ID > -1) ? rqIntCli_ID : "NULL" ) + " "
        + ", @FechaInicial = " + ( (rqDateFechaInicial.length > 0) ? "'" + rqDateFechaInicial + "'" : "NULL" ) + " "
        + ", @FechaFinal = " + ( (rqDateFechaFinal.length > 0) ? "'" + rqDateFechaFinal + "'" : "NULL" ) + " "

    var rsNE = AbreTabla(sqlNE, 1, cxnTipo)
%>
    <div class="ibox-title">
        <h5>Resultados</h5>
    </div>
    <div class="ibox-content">
        <div class="row"> 
            <table class="table table-responsive">
                <tbody>
<%
    var folio = "";
    var i = 1;

    if( !(rsNE.EOF) ){

        while ( !(rsNE.EOF) ){

           

            if( folio != rsNE("Folio").Value ){
                i++;
%>
                    <tr>
                        <td class="col-2-sm project-status">
                            <span class="label label-primary"><%= rsNE("Estatus").Value %></span>
                        </td>
                        <td class="col-2-sm project-title">
                            <small>Cliente</small>
                            <br>
                            <a class="text-danger">
                                <%= rsNE("Cliente").Value %>
                            </a>
                        </td>
                        <td class="col-2-sm project-title">
                            <small>Folio</small>
                            <br>
                            <a class="text-success btnCopiTRA" data-clipboard-target="#copytext<%= rsNE("Folio").Value %>" id="copytext<%= rsNE("Folio").Value %>">
                                <%= rsNE("Folio").Value %>
                            </a>
                        </td>
                        <td class="col-2-sm project-title">
                            <small>Fecha Registro</small>
                            <br>
                            <a><%= rsNE("FechaRegistro").Value %></a>
                        </td>
                        <td class="col-2-sm project-title">
                            <small>Fecha Cancelacion</small>
                            <br>
                            <a><%= rsNE("FechaCancelacion").Value %></a>
                        </td>
                        <td class="col-2-sm project-actions">
                            <a class="btn btn-white btn-sm RNEB_<%=i%>_ver" onclick="javascript:NotaEntradaFunciones.DatosOrden(<%=rsNE("ID").Value%>,<%=rsNE("EsOV").Value%>)" style="display: none;">
                                <i class="fa fa-file-text-o"></i> Crear Nota 
                            </a>
                            <a class="btn btn-success btn-sm RNEB_<%= i %>_ocultar" 
                            onclick="$('.RNEB_<%= i %>_ver').show(); $('.RNEB_<%= i %>_ocultar').hide();">
                                <i class="fa fa-angle-down fa-lg" title="Ver Art&iacute;culos"></i> Ver Art&iacute;culos
                            </a>
                            <a class="btn btn-danger btn-sm RNEB_<%= i %>_ver" style="display: none;"
                            onclick="$('.RNEB_<%= i %>_ver').hide(); $('.RNEB_<%= i %>_ocultar').show();"
                            >
                                <i class="fa fa-angle-up fa-lg" title="Ocultar Art&iacute;culos"></i> Ocultar Art&iacute;culos
                            </a>
                        </td>
                    </tr>
                     <tr class="RNEB_<%= i %>_ver" style="display: none;">
                        <td colspan="6">
                            <table class="table table-striped table-bordered">
                                <thead>
                                        <tr>
                                            <th class="col-1-sm">
                                                <input type="checkbox" onclick="$('.SNEB_<%= i %>').prop('checked', $(this).is(':checked'));">
                                            </th>
                                            <th class="col-sm-2">Estatus Art&iacute;culo</th>
                                            <th class="col-sm-4">Producto</th>
                                            <th class="col-sm-3">Folio Entrada</th>
                                            <th class="col-sm-2">Serie</th>
                                        </tr>
                                </thead>
                                <tbody>
<%
            }
%>
                                    <tr>
                                        <td>
                                            <input type="checkbox" class="SNEB_<%= i %>">
                                        </td>
                                        <td>
                                            <a class="btn btn-success btn-xs">
                                                <%= rsNE("EstatusSerie").Value %>
                                            </a>
                                        </td>
                                        <td class="issue-info">
                                            <a>
                                                <%= rsNE("SKU").Value %>
                                            </a>
                                            <small>
                                                <%= rsNE("Producto").Value %>
                                            </small>
                                        </td>
                                        <td>
                                            <%= rsNE("Folio").Value %>
                                        </td>
                                        <td>
                                            <%= rsNE("Serie").Value %>
                                        </td>
                                    <tr>
<%
            folio = rsNE("Folio").Value;
            rsNE.MoveNext()

            if( rsNE.EOF || ( !(rsNE.EOF) && folio != rsNE("Folio").Value ) ){
%>
                                </tbody>
                            </table>
                        </td>
                    </tr>
<%
            }
        }

    } else {
%>
                    <tr>
                        <td align="center" colspan="6">
                            <i class="fa fa-exclamation-circle fa-lg"></i> No hay registros
                        </td>
                    </tr>
<%
    }

    rsNE.Close()
%>
                </tbody>
            </table>
        </div>
    </div>
