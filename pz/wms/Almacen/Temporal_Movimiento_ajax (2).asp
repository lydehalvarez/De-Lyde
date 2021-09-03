<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2020-OCT-06 Surtido: Creación de archivo

var cxnTipo = 0
var rqStrTarea = Parametro("Tarea", -1)

switch( parseInt( rqStrTarea ) ){

     //Listar Series Buscadas
    case 1: {

        var rqStrBuscar = Parametro("Buscar", "")
        var rqIntTipoSeleccion = Parametro("TipoSeleccion", -1)

        var sqlBus = "EXEC SPR_Temporal_Movimiento "
                   + "@Opcion = 1 "
                   + ", @TipoSeleccion = " + rqIntTipoSeleccion 
                   + ", @Buscar = '" + rqStrBuscar + "' "

        var rsBus = AbreTabla(sqlBus, 1, cxnTipo)
%>
    <div class="ibox">
        <div class="ibox-title">
            <h5>Resultados</h5>
            <div class="ibox-tools">
                Registros Seleccionados: <b id="selTotalBuscados">
                    
                </b>
            </div>
        </div>
        <div class="ibox-content">
            <table class="table table-striped border border-primary">
                <thead>
                    <th>
                        <input type="checkbox" onclick="Temporal.SeleccionarTodos($(this));" checked>
                    </th>
                    <th>
                        Seleccionar Todos
                    </th>
                </thead>
                <tbody>
<%
        if( !(rsBus.EOF) ){

            var i = 0
            var strPro_SKU = ""
            var intPT_ID = 0
            var intMB = 0

            while( !(rsBus.EOF) ){

                if( strPro_SKU != rsBus("Pro_SKU").Value || intPT_ID != rsBus("Pt_ID").Value ){
                    i = 0
%>
                        <td>
                            <input type="checkbox" class="Todos Pallet" 
                            value="<%= rsBus("PT_ID").Value %>"
                            onclick="Temporal.SeleccionarPallet($(this))" checked>
                        </td>
                        <td colspan="3">
                            <i class="fa fa-inbox fa-lg text-success"></i> <%= rsBus("PT_LPN").Value %> (<%= rsBus("Ubi_Nombre").Value %>)
                            <br>
                            <strong>(<%= rsBus("Pro_SKU") %>) - <%= rsBus("Pro_Nombre") %></strong>
                        </td>
                    </tr>
<%
                }

                if( intMB != rsBus("Inv_MasterBox").Value ) {
                    i = 0
%>
                    <tr>
                        <td></td>
                        <td>
                            <input type="checkbox" class="Todos MasterBox" data-pt_id="<%= rsBus("PT_ID").Value %>"
                            value="<%= rsBus("Inv_MasterBox").Value %>"
                            onclick="Temporal.SeleccionarMasterBox($(this))" 
                            checked>
                        </td>
                        <td colspan="2">
                            <i class="fa fa-cube fa-lg text-success"></i> MasterBox: <%= rsBus("Inv_MasterBox").Value %>
                        </td>
                    </tr>
<%
                }
%>
                    <tr>
                        <td>
                        
                        </td>
                        <td>
                            <%= ++i %>
                        </td>
                        <td>
                            <input type="checkbox" class="Todos Serie" data-pt_id="<%= rsBus("PT_ID").Value %>" data-mb_id="<%= rsBus("Inv_MasterBox").Value %>"
                            value="<%= rsBus("INV_ID").Value %>" 
                            onclick='Temporal.SeleccionarSerie($(this))'
                            checked>
                        </td>
                        <td>
                            <i class="fa fa-barcode fa-lg text-success"></i> <%= rsBus("Inv_Serie").Value %>
                        </td>
                    </tr>
<%
                strPro_SKU = rsBus("Pro_SKU").Value
                intPT_ID = rsBus("Pt_ID").Value
                intMB = rsBus("Inv_MasterBox").Value
                Response.Flush()
                rsBus.MoveNext()
            }

        } else {
%>
                    <tr>
                        <td colspan="4">
                            <i class="fa fa-exclamation-circle"></i> No hay Series Encontradas
                        </td>
                    </tr>
<%          
        }
%>
                </tbody>
            </table>
            <input type="hidden" id="PT_ID" value="<%= intPT_ID %>">
        </div>
    </div>
<%      
        rsBus.Close()

    } break;

    //Mover las Series
    case 2:{

        var rqIntUbi_ID = Parametro("Ubi_ID", -1)
        var rqStrSeries = Parametro("Series", "")
        var rqIntTipoMovimiento = Parametro("TipoMovimiento", -1)
        var rqIntIDUsuario = Parametro("IDUsuario", -1)
        var rqIntPermanece = Parametro("Permanece", 0)

        var intLot_ID = 0
        var intPT_ID = 0
        var intErrorNumero = 0
        var strErrorDescripcion = 0

        var jsonRespuesta = '{}'

        var sqlMov = "EXEC SPR_Temporal_Movimiento "
              + "@Opcion = 2 "
            + ", @Ubi_ID = " + rqIntUbi_ID + " "
            + ", @Series = '" + rqStrSeries + "' "
            + ", @PT_Permanece = " + rqIntPermanece + " "
            + ", @TipoMovimiento = " + rqIntTipoMovimiento + " "
            + ", @IDUsuario = " + rqIntIDUsuario + " "

        var rsMov = AbreTabla(sqlMov, 1, cxnTipo)

        if( !(rsMov.EOF) ){
            intErrorNumero = rsMov("ErrorNumero").Value
            strErrorDescripcion = rsMov("ErrorDescripcion").Value
            intLot_ID = rsMov("Lot_ID").Value
            intPT_ID = rsMov("PT_ID").Value
        }

        rsMov.Close()

        jsonRespuesta = '{ '
                + '"Error": { '
                    + '"Numero": "' + intErrorNumero + '" '
                    + ', "Descripcion": "' + strErrorDescripcion + '" '
                +'} '
                + ', "Datos": { '
                    + '"Lot_ID": "' + intLot_ID + '" '
                    + ', "PT_ID": "' + intPT_ID + '" '
                +'} '
            +'} '

        Response.Write(jsonRespuesta)

    } break;

    //Listado de Series Movidas
    case 3: {

        var rqStrLot_IDs = Parametro("Lot_IDs", "")

        var sqlSer = "EXEC SPR_Temporal_Movimiento "
              + "@Opcion = 3 "
            + ", @Lot_IDs = '" + rqStrLot_IDs +"' "

        var rsSer = AbreTabla(sqlSer, 1, cxnTipo)
%>
    <table class="table table-striped border border-primary">
        <thead>
            <tr>
                <th>#</th>
                <th></th>
                <th>Serie</th>
            </tr>
        </thead>
        <tbody>
<%
        if( !(rsSer.EOF) ){
            
            var i = 0;
            var intPT_ID = 0
            var intMB = 0

            while( !(rsSer.EOF) ){
                
                if( intPT_ID != rsSer("PT_ID").Value ){
                    i = 0
%>
            <tr>
                <td colspan="3">
                    <div class="pull-right">
                        <a class="btn btn-white btn-sm" title="Imprimir LPN" onclick='Ubicacion.PalletLPNImprimir({PT_ID: <%= rsSer("PT_ID") %>})'>
                            <i class="fa fa-print"></i> LPN
                        </a>        
                    </div>
                    <i class="fa fa-inbox fa-lg text-success"></i> <%= rsSer("PT_LPN").Value %> (<%= rsSer("Ubi_Nombre").Value %>)
                    <br>
                    <strong>(<%= rsSer("Pro_SKU") %>) - <%= rsSer("Pro_Nombre") %></strong>
                </td>
            </tr>
<%
                }

                if( intMB != rsSer("Inv_MasterBox").Value ) {
                    i = 0
%>
            <tr>
                <td></td>
                <td colspan="2">
                    <i class="fa fa-cube fa-lg text-success"></i> MasterBox <%= rsSer("Inv_MasterBox").Value %>
                </td>
            </tr>
<%
                }
%>
            <tr>
                <td></td>
                <td><%= ++i %></td>
                <td>
                    <i class="fa fa-barcode text-success"></i> <%= rsSer("Inv_Serie").Value %>
                </td>
            </tr>
<%
                intPT_ID = rsSer("PT_ID").Value
                intMB = rsSer("Inv_MasterBox").Value

                Response.Flush()
                rsSer.MoveNext()
            }

        } else {
 %>
            <tr>
                <td colspan="3">
                    <i class="fa fa-exclamation-circle"></i> No hay Series Movidas
                </td>
            </tr>
<%              
        }
%>
        </tbody>
    </table>
<%
        rsSer.Close()

    } break;

    //Exportacion de Series Movidas
    case 4: {

        var rqStrLot_IDs = Parametro("Lot_IDs", "")

        var sqlSer = "EXEC SPR_Temporal_Movimiento "
              + "@Opcion = 3 "
            + ", @Lot_IDs = '" + rqStrLot_IDs +"' "

        var rsSer = AbreTabla(sqlSer, 1, cxnTipo)

        var jsonRespuesta = '['

        var bolInicio = true

        while( !(rsSer.EOF) ){
            
            jsonRespuesta += ( bolInicio ) ? '' : ','
            jsonRespuesta += '{'
                      + '"Lote": "' + rsSer("LOT_Folio").Value + '"'
                    + ', "Area": "' + rsSer("Are_Nombre").Value + '"'
                    + ', "Ubicacion": "' + rsSer("Ubi_Nombre").Value + '"'
                    + ', "LPN": "' + rsSer("PT_LPN").Value + '"'
                    + ', "MasterBox": "' + rsSer("Inv_MAsterBox").Value + '"'
                    + ', "SKU": "' + rsSer("Pro_SKU").Value + '"'
                    + ', "Descripcion": "' + rsSer("Pro_Nombre").Value + '"'
                    + ', "Serie": "' + rsSer("Inv_Serie").Value + '"'
                    + ', "Estatus": "' + rsSer("CAT_Nombre").Value + '"'
                +'}'    

            bolInicio = false

            Response.Flush()
            rsSer.MoveNext()
        }

        jsonRespuesta += ']'

        Response.Write(jsonRespuesta)

    } break;
}
%>