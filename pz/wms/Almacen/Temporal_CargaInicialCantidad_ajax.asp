<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2020-OCT-06 Surtido: Creación de archivo

var cxnTipo = 0
var rqStrTarea = Parametro("Tarea", -1)

switch( parseInt( rqStrTarea ) ){

    //Cambio de ubicacion
    case 1: {

        var rqStrLPNUbicacion = Parametro("LPNUbicacion", "")
        var rqStrLpn = Parametro("LPN", "")
        var rqIntCantidadReal = Parametro("CantidadReal", 0)
        var rqIntIDUSuario = Parametro("IDUsuario", -1)

        var jsonRespuesta = '{}'

        var intErrorNumero = 0
        var strErrorDescripcion = ""

        //Actualización de la ubicacion de los articulos que tienen en inventario el LPN solicitado

        var sqlLpnCam = "EXEC SPR_Temporal_CargaInicialCantidad "
              + "@Opcion = 1 "
            + ", @PT_LPN = '" + rqStrLpn + "' "
            + ", @PT_CantidadReal = " + rqIntCantidadReal + " "
            + ", @Ubi_Nombre = '" + rqStrLPNUbicacion + "' "
            + ", @IDUsuario = " + rqIntIDUSuario + " "

        var rsLpnCam = AbreTabla(sqlLpnCam, 1, cxnTipo)

        if( !(rsLpnCam.EOF) ){
            intErrorNumero = rsLpnCam("ErrorNumero").Value
            strErrorDescripcion = rsLpnCam("ErrorDescripcion").Value
        } else {
            intErrorNumero = 0
            strErrorDescripcion = "No se Realiz&oacute; el cambio"
        }
        
        rsLpnCam.Close()

        jsonRespuesta = '{'
                + '"Error": {'
                    + '"Numero": "' + intErrorNumero + '" '
                    + ', "Descripcion": "' + strErrorDescripcion + '" '
                +'}'
            +'}'

        Response.Write(jsonRespuesta)

    } break;

    //Poner en por buscar
    case 2:{

        var rqIntPT_ID = Parametro("PT_ID", -1)
        
        var intErrorNumero = 0
        var strErrorDescripcion = ""

        var jsonRespuesta = '{}'

        var sqlPorBus = "EXEC SPR_Pallet "
              + "@Opcion = 3000 "
            + ", @PT_ID = " + rqIntPT_ID + " "
            + ", @Ubi_ID = -1 "
            + ", @PT_PorBuscar = 1 "

        var rsPorBus = AbreTabla(sqlPorBus, 1, cxnTipo)

        if( !(rsPorBus.EOF) ){
            intErrorNumero = rsPorBus("ErrorNumero").Value
            strErrorDescripcion = rsPorBus("ErrorDescripcion").Value
        } else {
            intErrorNumero = 1
            strErrorDescripcion = "No se actualizo el pallet"
        }

        rsPorBus.close()

        jsonRespuesta = '{'
                + '"Error": {'
                    + '"Numero": "' + intErrorNumero + '"'
                    + ', "Descripcion": "' + strErrorDescripcion + '"'
                +'}'
            + '}'

        Response.Write(jsonRespuesta)

    } break;

     //Listar Los lpns Encontrados
    case 3: {

        var rqIntUbi_ID = Parametro("Ubi_ID", 0)

        var sqlUbi = "EXEC SPR_Pallet "
              + "@Opcion = 1000 "
            + ", @Ubi_ID = " + ( (rqIntUbi_ID > -1 ) ? rqIntUbi_ID : "NULL" ) + " "
            + ", @PT_PorBuscar = 0 "

        var rsUbi = AbreTabla(sqlUbi, 1, cxnTipo)
%>
    <div class="ibox">
        <div class="ibox-title">
            <h5>LPNs en la Ubicaci&oacute;n</h5>
        </div>
        <div class="ibox-content">
          <div class="table-responsive">
             <table class="table table-striped issue-tracker">
                <thead>
                    <tr>
                      <th class="text-center"></th>
                      <th class="text-center">#</th>
                      <th class="text-left">LPN</th>
                      <th class="text-center">Conteo f&iacute;sico</th>
                      <th class="text-center">Cantidad actual</th>
                      <th class="text-center">Acciones</th>
                    </tr>
                </thead>
                <tbody>
<%  
        if( !(rsUbi.EOF) ){
            
            var i = 0
            while( !(rsUbi.EOF) ){
%>
                    <tr>
                        <td class="text-center">
                            <a class="btn btn-success btn-xs" onclick='TemporalCargaInicialCantidad.LPNSeleccionar({LPN: "<%= rsUbi("PT_LPN").Value %>", Cantidad: "<%= rsUbi("PT_ConteoFisico").Value %>"});' title="Seleccionar LPN">
                                <i class="fa fa-check-square-o" title="Seleccionar para su Reubicacion"></i>
                            </a>
                        </td>
                        <td class="text-center"><%= ++i %></td>
                        <td class="text-left col-sm-3 project-title">
                            <a href="#">
                                <%= rsUbi("PT_LPN").Value %>    
                            </a>
                            <br>
                            <small>
                                (<%= rsUbi("Pro_SKU").Value %>) - <%= rsUbi("Pro_Nombre").Value %>
                            </small>
                        </td>
                        <td class="col-sm-1 text-center">
                            <input type="text" id="ConteoFisico_<%= rsUbi("PT_ID").Value %>" class="form-control input-sm"
                             value="<%= rsUbi("PT_ConteoFisico").Value %>">
                        </td>
                        <td class="col-sm-1 text-center">
                            <%=rsUbi("PT_Cantidad_Actual").Value %>
                        </td>                              
                        <td class="col-sm-6 text-center">
                            <a class="btn btn-info btn-xs" title="Actualizar"
                             onclick='TemporalCargaInicialCantidad.LPNCambiarConteoFisico({PT_ID: <%= rsUbi("PT_ID").Value %>});'>
                                <i class="fa fa-refresh"></i> Act
                            </a>
                            <a class="btn btn-danger btn-xs" title="Por Buscar"
                             onclick='TemporalCargaInicialCantidad.LPNPorBuscarPoner({PT_ID: <%= rsUbi("PT_ID").Value %>})'>
                                <i class="fa fa-search-plus"></i> Bus
                            </a>
                        
                            <a class="btn btn-white btn-xs" title="LPN"
                             onclick='TemporalCargaInicialCantidad.ImprimirLPN({PT_ID: <%= rsUbi("PT_ID").Value %>});'>
                                <i class="fa fa-print"></i> LPN
                            </a>
                            <a class="btn btn-white btn-xs" title="Auditoria"
                             onclick='TemporalCargaInicialCantidad.ImprimirAuditoria({PT_ID: <%= rsUbi("PT_ID").Value %>});'>
                                <i class="fa fa-print"></i> Aud 
                            </a>
                            <a class="btn btn-success btn-xs" title="Auditoria"
                             onclick='TemporalCargaInicialCantidad.SeriesModalAbrir({
                                  PT_ID: <%= rsUbi("PT_ID").Value %>
                                , PT_LPN: "<%= rsUbi("PT_LPN").Value %>"
                                , Ubi_ID: <%= rsUbi("Ubi_ID").Value %>
                                , Ubi_Nombre: "<%= rsUbi("Ubi_Nombre").Value %>"
                                });'>
                                <i class="fa fa-address-card-o"></i> Series
                            </a>
                            <a class="btn btn-success btn-xs btnModalSeries" data-toggle="modal" href="/pz/wms/Almacen/CargaSeriesEscaneo.asp?Pt_ID=<%=rsUbi("PT_ID").Value %>&PT_LPN=<%=rsUbi("PT_LPN").Value%>&Ubi_ID=<%=rsUbi("Ubi_ID").Value %>&Ubi_Nombre=<%=rsUbi("Ubi_Nombre").Value%>" data-target="#GridSerieEscaneo" title="Series"> <!--i class="fa fa-barcode"></i--> Series V.2.</a>
                        </td>
                        
                    </tr>
<%
                rsUbi.MoveNext()
            }
        } else {
%>
                    <tr>
                        <td colspan="6">
                            <i class="fa fa-exclamation-circle fa-lg"></i> Ubicacion Vacia
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
    } break;

    //Listado de Pallets Extraviados
    case 4:{

        sqlPTExt = "EXEC SPR_Pallet "
              + "@Opcion = 1000 "
            + ", @PT_PorBuscar = 1 "

        rsPTExt = AbreTabla(sqlPTExt, 1, cxnTipo)
%>
    <div class="ibox">
        <div class="ibox-title">
            <h5>LPN Por Buscar</h5>
        </div>
        <div class="ibox-content">
            <table class="table table-striped issue-tracker">
                <thead>
                    <tr>
                        <th>#</th>  
                        <th>LPN</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>
<%
    if( !(rsPTExt.EOF) ){
        var i = 0
        while( !(rsPTExt.EOF) ){
%>
                    <tr>
                        <td><%= ++i %></td>
                        <td class="issue-info">
                            <a>
                                <%= rsPTExt("PT_LPN") %>
                            </a>
                            <small><%= rsPTExt("Pro_SKU") %> - <%= rsPTExt("Pro_Nombre") %></small>
                        </td>
                        <td>
                            <a class="btn btn-success btn-xs" onclick='TemporalCargaInicialCantidad.LPNSeleccionar({LPN: "<%= rsPTExt("PT_LPN") %>", Cantidad: "<%= rsPTExt("PT_ConteoFisico").Value %>"});' title="Seleccionar LPN">
                                <i class="fa fa-files-o"></i>
                            </a>
                        </td>
                    </tr>
<%
            rsPTExt.MoveNext()
        }
    } else {
%>
                    <tr>
                        <td colspan="4">
                            <i class="fa fa-exclamation-circle"></i> No hay Registros
                        </td>
                    </tr>
<%
    }
%>
                </tbody>
            </table>
        </div>
    </div>
<%
    rsPTExt.close()

    } break;    

    case 5:{

        var rqIntPT_ID = Parametro("PT_ID", -1)
        var rqIntConteoFisico = Parametro("ConteoFisico", 0)

        var jsonRespuesta = '{}'

        var intErrorNumero = 0
        var strErrorDescripcion = ""

        var sqlPTCon = "EXEC SPR_Pallet "
              + "@Opcion = 3000 "
            + ", @PT_ID = " + rqIntPT_ID + " "
            + ", @PT_ConteoFisico = " + rqIntConteoFisico + " "

        var rsPTCon = AbreTabla(sqlPTCon, 1, cxnTipo)

        if( !(rsPTCon.EOF) ){
            intErrorNumero = rsPTCon("ErrorNumero").Value
            strErrorDescripcion = rsPTCon("ErrorDescripcion").Value
        } else {
            intErrorNumero = 1
            strErrorDescripcion = "No se actualizo el registro"
        }

        rsPTCon.Close();

        jsonRespuesta = '{'
                  + '"Error": {'
                          + '"Numero": "' + intErrorNumero + '"'
                        + ', "Descripcion": "' + strErrorDescripcion + '"'
                + '}'
            + '}'

        Response.Write(jsonRespuesta)

    } break;

    // carga de Series por Carga Inicial
    case 2010: {

        var rqIntUbi_ID = Parametro("Ubi_ID", -1)
        var rqIntPT_ID = Parametro("PT_ID", -1)
        var rqStrSerie = Parametro("Serie", "")

        var jsonRespuesta = '{}'

        var intErrorNumero = 0
        var strErrorDescripcion = ""

        var intICIS_ID = -1
        var strInv_Serie = ""
        var intICIS_ErrorNumero = -1
        var strICIS_ErrorDescripcion = ""
        var intICIS_Total = -1

        var sqlSerie = "EXEC SPR_Inventario_CargaInicial_Series "
              + "@Opcion = 2010 "
            + ", @Ubi_ID = " + ( (rqIntUbi_ID > -1) ? rqIntUbi_ID : "NULL" ) + " "
            + ", @PT_ID = " + ( (rqIntPT_ID > -1) ? rqIntPT_ID : "NULL" ) + " "
            + ", @INV_Serie = " + ( (rqStrSerie.length > 0) ? "'" + rqStrSerie + "'" : "NULL" ) + " "

        var rsSerie = AbreTabla(sqlSerie, 1, cxnTipo)

        if( !(rsSerie.EOF) ){
            intErrorNumero = rsSerie("ErrorNumero").Value
            strErrorDescripcion = rsSerie("ErrorDescripcion").Value

            intICIS_ID = rsSerie("ICIS_ID").Value
            strInv_Serie = rsSerie("INV_Serie").Value
            intICIS_ErrorNumero = rsSerie("ICIS_ErrorNumero").Value
            strICIS_ErrorDescripcion = rsSerie("ICIS_ErrorDEscripcion").Value
            intICIS_Total = rsSerie("Total").Value

        } else {
            intErrorNumero = 1
            strErrorDescripcion = "No se actualizo el registro"
        }

        rsSerie.Close();

         jsonRespuesta = '{'
                  + '"Error": {'
                          + '"Numero": "' + intErrorNumero + '"'
                        + ', "Descripcion": "' + strErrorDescripcion + '"'
                + '}'
                + ', "Registro": {'
                      + '"ICIS_ID": "' + intICIS_ID + '"'
                    + ', "Inv_Serie": "' + strInv_Serie + '"'
                    + ', "ICIS_ErrorNumero": "' + intICIS_ErrorNumero + '"'
                    + ', "ICIS_ErrorDescripcion": "' + strICIS_ErrorDescripcion + '"'
                    + ', "ICIS_Total": "' + intICIS_Total + '"'
                + '}'
            + '}'

        Response.Write(jsonRespuesta)

    } break;

    case 1100: {

        var rqIntUbi_ID = Parametro("Ubi_ID", -1)
        var rqIntPT_ID = Parametro("PT_ID", -1)

        var sqlSer = "EXEC SPR_Inventario_CargaInicial_Series "
              + "@Opcion = 1000 "
            + ", @Ubi_ID = " + ( (rqIntUbi_ID > -1) ? rqIntUbi_ID : "NULL" ) + " "
            + ", @PT_ID = " + ( (rqIntPT_ID > -1) ? rqIntPT_ID : "NULL" ) + " "

        var rsSer = AbreTabla(sqlSer, 1, cxnTipo)
%>
    
            <table class="table table">
                <tr id="Encabezado">
                    <th class="col-sm-6">Serie</th>
                    <th class="col-sm-6">Error</th>
                </tr>
<%      
        if( !(rsSer.EOF) ){
            var i = 0
            while( !(rsSer.EOF) ){
                i++;

                var color = ""
                        switch (parseInt(rsSer("ICIS_ErrorNumero").Value)) {
                            case 0:{
                                color = "bg-info"  
                            } break;
                            case 1:{
                                color = "bg-warning"
                            } break;
                            case -1:{
                                color = "bg-danger"
                            } break;
                        
                            default:
                                break;
                        }
%>
                    <tr class="<%= color %>">
                        <td><%= i %></td>
                        <td>
                             <%= rsSer("INV_Serie").Value %>
                        </td>
                    </tr>

<%
                rsSer.MoveNext()
            }
        } else {
%>
                    <tr>
                        <td colspan="2">
                            <i class="fa fa-exclamation-cisrcle-o"></i> No hay Series Escaneadas
                        </td>
                    </tr>
<%
        }
%>

            </table>
<%
        rsSer.Close()
    } break;
}
%>
