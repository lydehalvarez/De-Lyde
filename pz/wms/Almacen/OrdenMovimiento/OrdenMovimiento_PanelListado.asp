<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2020-OCT-06 Movimiento: Creación de archivo

var cxnTipo = 0

var sqlPanLis = "EXEC SPR_Inventario_OrdenMovimiento "
              + "@Opcion = 1010 /* Busqueda por Tipo */ "
            + ", @IOM_Est_IDs = '2,3,4,5'"

var rsPanLis = AbreTabla(sqlPanLis, 1, cxnTipo)
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

while( !(rsPanLis.EOF)){

    i++;

%>
                    <tr>
                        <td>
<%
    if( parseInt(rsPanLis("IOM_Prioridad").Value) == 1 ){
%>
                            <i class="fa fa-exclamation fa-lg text-danger" title="Prioridad"></i>
                            <br>
<%
    }
%>
                        </td>
                        <td>
<%
    if( parseInt(rsPanLis("IOM_EsManual").Value) == 1 ){
%>
                            <i class="fa fa-hand-paper-o" title="Manual"></i>
<%
    } else {
%>
                            <i class="fa fa-laptop" title="Autom&aacute;tica"></i>
<%           
    }
%>
                        </td>
                        <td class="col-sm-2 project-status">
<%                        
    var strEstatusColor = ""

    switch( parseInt(rsPanLis("IOM_EstatusCG80").Value) ){
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
                                <%= rsPanLis("EST_Nombre").Value %>
                            </span>
                            <br>
                            <small>
                                <i class="fa fa-clock-o"></i> <%= rsPanLis("IOM_FechaRegistro").Value %>
                            </small>

                        </td>
                        <td class="col-sm-2 project-title">
                            <small>Folio</small>
                            <br>
                            <a class="text-success">
                                <%= rsPanLis("IOM_Folio").Value %>
                            </a>
                            <br>
                            
                        </td>
                        
                        <td class="col-sm-2 project-title">
                            <small>Tipo de Ord. de Mov.</small>
                            <br>
                            <a>
                                <%= rsPanLis("TOM_Nombre").Value %>
                            </a>
<%
    if( rsPanLis("EstA_Nombre").Value != "" ){
%>
                                <br>
                                <small><%= rsPanLis("EstA_Nombre").Value %></small>
<%
    }
%>                                
                        </td>
                        
                        <td class="col-sm-2 project-completion">
                            <small>Seguimiento: <%= rsPanLis("IOMP_PorcentajeSeguimiento").Value %>%</small>
                            <div class="progress progress-mini">
                                <div style="width: <%= rsPanLis("IOMP_PorcentajeSeguimiento").Value %>%;" class="progress-bar"></div>
                            </div>
                        </td>

                        <td class="col-sm-2 project-title">
                            <small>Cant. Productos</small>
                            <br>
                            <a>
                                <%= rsPanLis("IOMP_Cantidad_Producto").Value %>
                            </a>
                        </td>

                        <td class="col-sm-2 project-title">
                            <small>Canti. Articulos</small>
                            <br>
                            <a>
                                <%= rsPanLis("IOMP_CantidadSolicitada_Articulo").Value %>
                            </a>
                        </td>
                        
                        <td class="project-people">
                            <a>
                                <img alt="image" class="img-circle" src="<%= rsPanLis("Usu_RutaImagen").Value %>" width="45" height="45">
                            </a>
                            <br>
                            <small><%= rsPanLis("USU_Nombre").Value %></small>
                        </td>

                    </tr>
 <%           
    rsPanLis.MoveNext()
}
%>
                </tbody>
            </table>
        </div>
    </div>
<%
rsPanLis.Close()
%>