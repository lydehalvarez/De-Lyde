<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2020-OCT-06 Movimiento: Creación de archivo

var cxnTipo = 0

var rqStrFolio = Parametro("IOM_Folio", "")
var rqStrPro_SKU = Parametro("Pro_SKU", "")
var rqIntCli_ID = Parametro("Cli_ID", -1)
var rqIntUbi_ID_Destino = Parametro("Ubi_ID_Destino", -1)
var rqIntEst_ID = Parametro("Est_ID", -1)
var rqIntTOM_ID = Parametro("TOM_ID", -1)
var rqDateFechaInicial = Parametro("FechaInicial", "")
var rqDateFechaFinal = Parametro("FechaFinal", "")
var rqIntIOM_Prioridad = Parametro("IOM_Prioridad", "")


var sqlBusLis = "EXEC SPR_Inventario_OrdenMovimiento "
      + "@Opcion = 1010 /* Busqueda por Tipo */ "
    + ", @IOM_Folio = " + ( ( rqStrFolio.length > 0 ) ? "'" + rqStrFolio + "'" : "NULL" ) + " "
    + ", @Pro_SKU = " + ( ( rqStrPro_SKU.length > 0 ) ? "'" + rqStrPro_SKU  + "'" : "NULL" ) + " "
    + ", @Cli_ID = " + ( ( rqIntCli_ID > -1 ) ? rqIntCli_ID : "NULL" ) + " "
    + ", @Ubi_ID_Destino = " + ( ( rqIntUbi_ID_Destino > -1 ) ? rqIntUbi_ID_Destino : "NULL" ) + " "
    + ", @IOM_EstatusCG80 = " + ( ( rqIntEst_ID > -1 ) ? rqIntEst_ID : "NULL" ) + " "
    + ", @IOM_TipoCG86 = " + ( ( rqIntTOM_ID > -1 ) ? rqIntTOM_ID : "NULL" ) + " "
    + ", @FechaInicial = " + ( ( rqDateFechaInicial.length > 0 ) ? "'" + rqDateFechaInicial + "'" : "NULL" ) + " "
    + ", @FechaFinal = " + ( ( rqDateFechaFinal.length > 0 ) ? "'" + rqDateFechaFinal + "'" : "NULL" ) + " "
    + ", @IOM_Prioridad = " + ( ( rqIntIOM_Prioridad.length > 0 ) ? rqIntIOM_Prioridad : "NULL" ) + " "

var rsBusLis = AbreTabla(sqlBusLis, 1, cxnTipo)
%>
    <div class="ibox">
        <div class="ibox-title">
            <h5>Resultados</h5>
        </div>
        <div class="ibox-content">
             <table class="table table-striped issue-tracker">
                <tbody>
<%
var intIOM_ID = 0
var i = 0

while( !(rsBusLis.EOF)){

    i++;
%>
                    <tr id="IOM_<%= rsBusLis("IOM_ID").Value %>">
                        <td>
<%
    if( parseInt(rsBusLis("IOM_EstatusCG80").Value) == 2 ) {
%>
                            <input type="checkbox" value='<%= rsBusLis("IOM_ID") %>'>
<%
    }
%>
                        </td>
                        <td>
<%
    if( parseInt(rsBusLis("IOM_Prioridad").Value) == 1 ){
%>
                            <i class="fa fa-exclamation fa-lg text-danger" title="Prioridad"></i>
<%
    }
%>
                        </td>
                        <td>
<%
    if( parseInt(rsBusLis("IOM_EsManual").Value) == 1 ){
%>
                            <i class="fa fa-hand-paper-o fa-lg" title="Manual"></i>
<%
    } else {
%>
                            <i class="fa fa-laptop fa-lg" title="Autom&aacute;tica"></i>
<%           
    }
%>
                        </td>
                        <td class="col-2-sm project-status">
<%                        
    var strEstatusColor = ""

    switch( parseInt(rsBusLis("IOM_EstatusCG80").Value) ){
        //Pendiente
        case 2:	{ strEstatusColor = "label-warning" } break;
        //En Proceso
        case 3: { strEstatusColor = "label-success" } break;
        //Terminada
        case 4:	{ strEstatusColor = "label-primary" } break;
        //Cancelada
        case 5:	{ strEstatusColor = "label-danger" } break;
    }
%> 
                            <span class="label <%= strEstatusColor %>">
                                <%= rsBusLis("EST_Nombre").Value %>
                            </span>
                            <br>
                            <small>
                                 <i class="fa fa-clock-o"></i> <%= rsBusLis("IOM_FechaRegistro").Value %>
                            </small>

                        </td>
                        <td class="col-2-sm project-title">
                            <small>Folio</small>
                            <br>
                            <a class="text-success">
                                <%= rsBusLis("IOM_Folio").Value %>
                            </a>
                        </td>
                        
                        <td class="col-sm-1 project-title">
                            <small>Tipo de Ord. de Mov.</small>
                            <br>
                            <a>
                                <%= rsBusLis("TOM_Nombre").Value %>
                            </a>
<%
    if( rsBusLis("EstA_Nombre").Value != "" ){ 
%>
                            <br>
                            <small class="text-success">
                                <%= rsBusLis("EstA_Nombre").Value %>
                            </small>
<%
    }
%>
                        </td>
                        
                        <td>
                            <small>Seguimiento: <%= rsBusLis("IOMP_PorcentajeSeguimiento").Value %>%</small>
                            <div class="progress progress-mini">
                                <div style="width: <%= rsBusLis("IOMP_PorcentajeSeguimiento").Value %>%;" class="progress-bar"></div>
                            </div>
                        </td>

                        <td class="col-sm-1 project-title">
                            <small>Cant. Productos</small>
                            <br>
                            <a>
                                <%= rsBusLis("IOMP_Cantidad_Producto").Value %>
                            </a>
                        </td>

                        <td class="col-sm-1 project-title">
                            <small>Cant. Articulos</small>
                            <br>
                            <a>
                                <%= rsBusLis("IOMP_CantidadSolicitada_Articulo").Value %>
                            </a>
                        </td>
                        
                        <td class="col-2-sm project-actions">
<%  
    if( parseInt(rsBusLis("IOM_EstatusCG80").Value) == 1 ) {
%>
                            <a class="btn btn-white btn-sm" onclick='OrdenMovimiento.Editar({IOM_ID: <%= rsBusLis("IOM_ID") %>, TOM_ID: <%= rsBusLis("IOM_TipoCG86") %>})'>
                                <i class="fa fa-pencil-square-o fa-lg"></i> Editar
                            </a>
                            <a class="btn btn-danger btn-sm" onclick='OrdenMovimiento.Eliminar({IOM_ID: <%= rsBusLis("IOM_ID") %>})'>
                                <i class="fa fa-trash-o fa-lg"></i> Eliminar
                            </a>
<%
    } else {
%>
                            <a class="btn btn-white btn-sm" onclick='OrdenMovimiento.Ver({IOM_ID: <%= rsBusLis("IOM_ID") %>})'>
                                <i class="fa fa-file-text-o fa-lg"></i> Ver
                            </a>
<%
    }
%>
                            <a class="btn btn-success btn-sm IOM_<%= rsBusLis("IOM_ID").Value %>_ver" 
                             onclick='OrdenMovimiento.ProductoVer({IOM_ID: <%= rsBusLis("IOM_ID").Value %>});'>
                                <i class="fa fa-angle-down fa-lg" title="Ver Productos"></i> Ver Productos
                            </a>

                            <a class="btn btn-danger btn-sm IOM_<%= rsBusLis("IOM_ID").Value %>_ocultar" style="display: none;"
                             onclick='OrdenMovimiento.ProductoOcultar({IOM_ID: <%= rsBusLis("IOM_ID").Value %>});'>
                                <i class="fa fa-angle-up fa-lg" title="Ocultar Productos"></i> Ocultar Productos
                            </a>

                        </td>

                    </tr>
<%
    rsBusLis.MoveNext()
}
%>
                </tbody>
            </table>
        </div>
    </div>
<%
rsBusLis.Close()
%>