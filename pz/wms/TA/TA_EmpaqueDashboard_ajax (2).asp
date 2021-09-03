<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
var cxnTipo = 0

var rqIntTarea = Parametro("Tarea", -1)

switch( parseInt(rqIntTarea) ){
	// Carga de Widgets Totales
	case 1: {

        var dateFecha = Parametro("Fecha", "")
        var intCli_ID = Parametro("Cli_ID", -1)

        var intTotPendientes = 0
        var intTotRecibidas = 0
        var intTotPicking = 0
        var intTotPacking = 0
        var intTotShiping = 0
        var intTotTransito = 0
        var intTotCanceladas = 0
        var intTotEntregadas = 0
        var intTotalTotal = 0

        var sqlWidTot = "EXEC SPR_Dashboard_Transferencia "
              + "@Opcion = 11 "
            + ", @TA_FechaRegistro = " + ( ( dateFecha.length > 0 ) ? "'" + dateFecha + "'" : "NULL" ) + " "
            + ", @Cli_ID = " + ( ( intCli_ID > -1) ? intCli_ID : "NULL" ) + " "


        var rsWidTot = AbreTabla(sqlWidTot, 1, cxnTipo)

        if( !(rsWidTot.EOF) ){
            intTotRecibidas = rsWidTot("Recibidas").Value
            intTotPendientes = rsWidTot("Pendientes").Value
            intTotPicking = rsWidTot("Picking").Value
            intTotPacking = rsWidTot("Packing").Value
            intTotShiping = rsWidTot("Shiping").Value
            intTotTransito = rsWidTot("Transito").Value
            intTotCanceladas = rsWidTot("Canceladas").Value
            intTotEntregadas = rsWidTot("Entregadas").Value
        }

        rsWidTot.Close()

        intTotalTotal = intTotRecibidas + intTotPendientes
        intTotalTotal = ( intTotalTotal > 0 ) ? intTotalTotal: 1;
%>
        <% /* Contenedor de Recibidas */ %>
        <div class="col-sm-2">
            <div class="ibox float-e-margins">
                <div class="ibox-title">
                    <a class="btn btn-white btn-xs pull-right" onclick='Transferencia.Listado.Cargar({Est_IDs: ""})'>
                        <i class="fa fa-file-text-o"></i> Ver
                    </a>
                    <h5>Recibidas</h5>
                </div>
                <div class="ibox-content">
                    <h2 class="no-margins font-bold"><%= formato(intTotRecibidas, 0) %></h2>
                    <div class="stat-percent font-bold text-success">
                        <%= formato(intTotPendientes, 0) %>
                    </div>
                    <small>Pendientes</small>
                </div>
            </div>
        </div>

        <% /* Contenedor de Canceladas */ %>
        <div class="col-sm-2">
            <div class="ibox float-e-margins">
                <div class="ibox-title">
                    <a class="btn btn-white btn-xs pull-right" onclick='Transferencia.Listado.Cargar({Est_IDs: "11"})'>
                        <i class="fa fa-file-text-o"></i> Ver
                    </a>
                    <h5>Canceladas</h5>
                </div>
                <div class="ibox-content">
                    <h2 class="no-margins font-bold"><%= formato(intTotCanceladas, 0) %></h2>
                    <div class="stat-percent font-bold text-success">
                        <%= formato( (intTotCanceladas * 100) / intTotalTotal, 1) %>%
                    </div>
                    <small>Canceladas</small>
                </div>
            </div>
        </div>

        <% /* Contenedor de Empaque */ %>
        <div class="col-sm-4">
            <div class="ibox float-e-margins">
                <div class="ibox-title">
                    <a class="btn btn-white btn-xs pull-right" onclick='Transferencia.Listado.Cargar({Est_IDs: "2,3,4"})'>
                        <i class="fa fa-file-text-o"></i> Ver
                    </a>
                    <h5>Empaque</h5>
                </div>
                <div class="ibox-content">
                    <div class="row">

                        <div class="col-md-4">
                            <h2 class="no-margins font-bold"><%= formato(intTotPicking, 0) %></h2>
                            <div class="stat-percent font-bold text-success">
                                <%= formato( (intTotPicking * 100) / intTotalTotal, 1) %>%
                            </div>
                            <small>Picking</small>
                        </div>

                        <div class="col-md-4">
                            <h2 class="no-margins font-bold"><%= formato(intTotPacking, 0) %></h2>
                            <div class="stat-percent font-bold text-success">
                                <%= formato( (intTotPacking * 100) / intTotalTotal, 1) %>%
                            </div>
                            <small>Packing</small>
                        </div>

                        <div class="col-md-4">
                            <h2 class="no-margins font-bold"><%= formato(intTotShiping, 0) %></h2>
                            <div class="stat-percent font-bold text-success">
                                <%= formato( (intTotShiping * 100) / intTotalTotal, 1) %>%
                            </div>
                            <small>Shiping</small>
                        </div>

                    </div>
                </div>
            </div>
        </div>

        <% /* Contenedor de Transito */ %>
        <div class="col-sm-2">
            <div class="ibox float-e-margins">
                <div class="ibox-title">
                    <a class="btn btn-white btn-xs pull-right" onclick='Transferencia.Listado.Cargar({Est_IDs: "5"})'>
                        <i class="fa fa-file-text-o"></i> Ver
                    </a>
                    <h5>Transito</h5>
                </div>
                <div class="ibox-content">
                    <h2 class="no-margins font-bold"><%= formato(intTotTransito, 0) %></h2>
                    <div class="stat-percent font-bold text-success">
                        <%= formato( (intTotTransito * 100) / intTotalTotal, 1) %>%
                    </div>
                    <small>Transito</small>
                </div>
            </div>
        </div>
        
        <% /* Contenedor de Entregadas */ %>
        
        <div class="col-sm-2">
            <div class="ibox float-e-margins">
                <div class="ibox-title">
                    <a class="btn btn-white btn-xs pull-right" onclick='Transferencia.Listado.Cargar({Est_IDs: "10"})'>
                        <i class="fa fa-file-text-o"></i> Ver
                    </a>
                    <h5>Entregadas</h5>
                </div>
                <div class="ibox-content">
                    <h2 class="no-margins font-bold"><%= formato(intTotEntregadas, 0) %></h2>
                    <div class="stat-percent font-bold text-success">
                        <%= formato( (intTotEntregadas * 100) / intTotalTotal, 1) %>%
                    </div>
                    <small>Entregadas</small>
                </div>
            </div>
        </div>
        
<%
    } break;

    // Carga de Información para gráficos
    case 2: {
        
        var dateFecha = Parametro("Fecha", "")
        var intCli_ID = Parametro("Cli_ID", -1)

        var arrLabels = []
        var arrPicking = []
        var arrPacking = []
        var arrShiping = []

        var respuestaJSON = '{}'

        var sqlEmpaque = "EXEC SPR_Dashboard_Transferencia "
              + "@Opcion = 12 "
            + ", @TA_FechaRegistro = " + ( ( dateFecha.length > 0 ) ? "'" + dateFecha + "'" : "NULL" ) + " "
            + ", @Cli_ID = " + ( ( intCli_ID > -1) ? intCli_ID : "NULL" ) + " "
          
        var rsEmpaque = AbreTabla(sqlEmpaque, 1, cxnTipo)

        while( !(rsEmpaque.EOF) ){

            arrLabels.push( '"' + rsEmpaque("Fecha").Value + '"' )
            arrPicking.push( rsEmpaque("Picking").Value )
            arrPacking.push( rsEmpaque("Packing").Value )
            arrShiping.push( rsEmpaque("Shiping").Value )

            rsEmpaque.MoveNext()
        }

        rsEmpaque.Close()

        respuestaJSON = '{'
                + '"lineData": {'
                    + '"labels": [' + arrLabels.join(",") + '] '
                    + ', "datasets": [' 
                          + '{'
                            + '"label": "Picking" '
                            + ', "backgroundColor": "rgba(236,112,99,0.5)" '
                            + ', "borderColor": "rgba(236,112,99,0.7)" '
                            + ', "pointBackgroundColor": "rgba(236,112,99,1)" '
                            + ', "pointBorderColor": "#fff" '
                            + ', "fill": false '
                            + ', "data": [' + arrPicking.join(",") + '] '
                        + '}'
                        + ', {'
                            + '"label": "Packing" '
                            + ', "backgroundColor": "rgba(84,153,199,0.5)" '
                            + ', "borderColor": "rgba(84,153,199,0.7)" '
                            + ', "pointBackgroundColor": "rgba(84,153,199,1)" '
                            + ', "pointBorderColor": "#fff" '
                            + ', "fill": false '
                            + ', "data": [' + arrPacking.join(",") + '] '
                        + '}'
                        + ', {'
                            + '"label": "Shiping" '
                            + ', "backgroundColor": "rgba(46,204,113,0.5)" '
                            + ', "borderColor": "rgba(46,204,113,0.7)" '
                            + ', "pointBackgroundColor": "rgba(46,204,113,1)" '
                            + ', "pointBorderColor": "#fff" '
                            + ', "fill": false '
                            + ', "data": [' + arrShiping.join(",") + '] '
                        + '}'
                    +'] '
                + '} '
                + ', "lineOptions": { '
                    + '"responsive": true '
                + '} '
            + '} '

        Response.Write(respuestaJSON)

    } break;

    // Lineas de Resultados
    case 3:{

        var dateFecha = Parametro("Fecha", "")
        var intCli_ID = Parametro("Cli_ID", -1)

        var intTotTotal = 0
        var intTotPacking = 0
        var intTotPicking = 0
        var intTotShiping = 0

        var sqlTotEmp = "EXEC SPR_Dashboard_Transferencia "
              + "@Opcion = 13 "
            + ", @TA_FechaRegistro = " + ( ( dateFecha.length > 0 ) ? "'" + dateFecha + "'" : "NULL" ) + " "
            + ", @Cli_ID = " + ( ( intCli_ID > -1) ? intCli_ID : "NULL" ) + " "

        
        var rsTotEmp = AbreTabla(sqlTotEmp, 1, cxnTipo)

        if( !(rsTotEmp.EOF) ){
            intTotTotal = rsTotEmp("Total").Value
            intTotPacking = rsTotEmp("Picking").Value
            intTotPicking = rsTotEmp("Packing").Value
            intTotShiping = rsTotEmp("Shiping").Value
        }

        rsTotEmp.Close()

        intTotTotal = ( ( intTotTotal > 0 ) ? intTotTotal : 1 )
%>
    <div class="ibox">
        <div class="ibox-title">
            <h5>Empaque</h5>
            <div class="ibox-tools">
                
            </div>
        </div>
        <div class="ibox-content">
            <div class="row">
                <div>
                    <ul class="stat-list">
                        <li>
                            <h2 class="no-margins font-bold"><%= formato(intTotPicking, 0) %></h2>
                            <small>Total Piking</small>
                            <div class="stat-percent"><%= formato( (intTotPicking * 100) / intTotTotal, 2 ) %>% <i class="fa fa-level-up text-navy"></i></div>
                            <div class="progress progress-mini">
                                <div style="width: <%= ( (intTotPicking * 100) / intTotTotal) %>%;" class="progress-bar"></div>
                            </div>
                        </li>
                        <li>
                            <h2 class="no-margins font-bold"><%= formato(intTotPacking, 0) %></h2>
                            <small>Total Paking</small>
                            <div class="stat-percent"><%= formato( (intTotPacking * 100) / intTotTotal, 2 ) %>% <i class="fa fa-level-up text-navy"></i></div>
                            <div class="progress progress-mini">
                                <div style="width: <%= ( (intTotPacking * 100) / intTotTotal ) %>%;" class="progress-bar"></div>
                            </div>
                        </li>
                        <li>
                            <h2 class="no-margins font-bold"><%= formato(intTotShiping, 0) %></h2>
                            <small>Total Shiping</small>
                            <div class="stat-percent"><%= formato( (intTotShiping * 100) / intTotTotal, 2 ) %>% <i class="fa fa-level-up text-navy"></i></div>
                            <div class="progress progress-mini">
                                <div style="width: <%= ( (intTotShiping * 100) / intTotTotal ) %>%;" class="progress-bar"></div>
                            </div>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
<%
    } break;

    // listado de Transferencias
    case 4:{

        var dateFecha = Parametro("Fecha", "")
        var strEst_IDs = Parametro("Est_IDs", "")
        var intCli_ID = Parametro("Cli_ID", -1)

        var sqlLis = "EXEC SPR_Dashboard_Transferencia "
              + "@Opcion = 4 "
            + ", @TA_FechaRegistro = " + ( ( dateFecha.length > 0 ) ? "'" + dateFecha + "'" : "NULL" ) + " "
            + ", @Cli_ID = " + ( ( intCli_ID > -1) ? intCli_ID : "NULL" ) + " "
            + ", @Est_IDs = " + ( (strEst_IDs.length > 0) ? "'" + strEst_IDs + "'" : "NULL" ) + " "

        //Response.Write(sqlLis)

        var rsLis = AbreTabla(sqlLis, i, cxnTipo)
%>
    <div class="ibox">
        <div class="ibox-title">
            <h5>Transferencias</h5>
            <div class="ibox-tools">
                
            </div>
        </div>
        <div class="ibox-content">
            <div class="row">
                <table class="table table-striped">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Estatus</th>
                            <th>Fec. Reg.</th>
                            <th>Folio</th>
                            <th>Origen</th>
                            <th>Destino</th>
                            <th>Cant. Prod.</th>
                            <th>Cant. Art.</th>
                            <th></th>
                        </tr>
                    </thead>
                    <tbody>
<%         
            if( !(rsLis.EOF) ){
                var i = 0;
                while( !(rsLis.EOF) ){
%>
                        <tr>
                            <td><%= ++i %></td>
                            <td><%= rsLis("EST_Nombre").Value %></td>
                            <td><%= rsLis("TA_FechaRegistro").Value %></td>
                            <td><%= rsLis("TA_Folio").Value %></td>
                            <td><%= rsLis("Alm_Nombre_Origen").Value %></td>
                            <td><%= rsLis("Alm_Nombre_Destino").Value %></td>
                            <td><%= rsLis("TA_Cantidad_Producto").Value %></td>
                            <td><%= rsLis("TA_Cantidad_Articulos").Value %></td>
                            <td>
                                <a class="btn btn-white btn-xs" onclick="Transferencia.Detalle.Ver({TA_ID: <%= rsLis("TA_ID").Value %>})">
                                    <i class="fa fa-file-text-o"></i> Ver
                                </a>
                            </td>
                        </tr>
<%                  
                    rsLis.MoveNext()
                }
            } else {
%>
                        <tr>
                            <td>
                               <i class="fa fa-exclamation-circle text-success"></i> No hay Registros
                            </td>
                        </tr>
<%
            }

            rsLis.Close()
%>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
<%
    } break;
}
%>
