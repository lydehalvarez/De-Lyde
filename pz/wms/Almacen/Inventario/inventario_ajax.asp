<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2020-OCT-21 Inventario: Creacion de Archivo

var cxnTipo = 0
var rqStrTarea = Parametro("Tarea", -1)

switch( parseInt( rqStrTarea ) ){

    //Seies Extrraer
    case 10:{

        var rqIntINV_ID = Parametro("INV_ID", -1)
        var rqStrInv_Serie = Parametro("INV_Serie", "")

        var sqlSerBus = "EXEC SPR_Inventario "
              + "@Opcion = 1000 "
            + ", @INV_ID = " + ( (rqIntINV_ID > -1) ? rqIntINV_ID : "NULL" ) + " "
            + ", @INV_Serie = " + ( (rqStrInv_Serie.length > 0 ) ? "'" + rqStrInv_Serie + "'" : "NULL" )  + " "

        var rsSerBus = AbreTabla(sqlSerBus, 1 ,cxnTipo)

        var jsonRespuesta = JSON.Convertir(rsSerBus, JSON.Tipo.RecordSet)

        rsSerBus.Close()

        Response.Write(jsonRespuesta)

    } break;

    // Series solicitadas en tiempo actual
    case 1001: {
        rqIntUbi_ID = Parametro("Ubi_ID", -1)
        rqIntPT_ID = Parametro("PT_ID", -1)

        var sqlInvSer = "EXEC SPR_Inventario "
              + "@Opcion = 1000 "
            + ", @Ubi_ID = " + ( ( rqIntUbi_ID > -1 ) ? rqIntUbi_ID : "NULL" ) + " "
            + ", @PT_ID = " + ( ( rqIntPT_ID > -1 ) ? rqIntPT_ID : "NULL" ) + " "
        
        var rsInvSer = AbreTabla(sqlInvSer, 1, cxnTipo)
%>
        <div class="ibox">
            <div class="ibox-title">
                <h5>
                    <i class="fa fa-codebar"></i> Series
                </h5>
            </div>
            <div class="ibox-content">
                <table class="table table-striped border border-primary">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>serie</th>
                        </tr>
                    </thead>
                    <tbody>
<%          
            if( !(rsInvSer.EOF) ){
                var i = 0;
                var intPT_ID = -1
                var intMB = -1
                while( !(rsInvSer.EOF) ){

                    if( intPT_ID != rsInvSer("PT_ID").Value ){
%>
                        <tr>
                            <td colspan="2">
                                <i class="fa fa-inbox fa-lg"></i> <%= rsInvSer("PT_LPN").Value %>
                            </td>
                        </tr>
<%
                    }

                    if( intMB != rsInvSer("INV_MasterBox").Value ){
                        i = 0
%>
                        <tr>
                            <td colspan="2">
                                <i class="fa fa-cube"></i> MB: <%= rsInvSer("INV_MasterBox").Value %>
                            </td>
                        </tr>
<%
                    }
%>
                        <tr>
                            <td>
                                <%= ++i %>
                            </td>
                            <td>
                                <%= rsInvSer("INV_Serie").Value %>
                            </td>
                        </tr>
<%                  
                    intMB = rsInvSer("INV_MasterBox").Value
                    intPT_ID = rsInvSer("PT_ID").Value

                    rsInvSer.MoveNext()
                }
            } else {
%>
                        <tr>
                            <td colspan="2">
                                <i class="fa fa-exclamation-circle"></i> No hay registro(s)
                            </td>
                        </tr>
<%                
            }

            rsInvSer.Close()
%>
                    </tbody>
                </table>
            </div>
        </div>
<%
        
    } break;

    //Series Lote Listado
    case 1100: {

        rqIntLot_ID = Parametro("Lot_ID", -1)

        sqlSerLot = "EXEC SPR_Inventario "
            + "  @Opcion = 1100 "
            + ", @Lot_ID = " + ((rqIntLot_ID > -1) ? rqIntLot_ID: "NULL" ) + " "
        
        var rsSerLot = AbreTabla(sqlSerLot, 1, cxnTipo)
%>
        <div class="ibox">
            <div class="ibox-title">
                <h5>Series</h5>
            </div>
            <div class="ibox-content">
                <table class="table table-striped border border-primary">
                    <thead>
                        <tr>
                            <th>
                                #
                            </th>
                            <th> 
                                <i class="fa fa-barcode"></i> serie
                            </th>
                        </tr>
                    </thead>
                    <tbody>
<%          
            if( !(rsSerLot.EOF) ){
                var i = 0;
                while( !(rsSerLot.EOF) ){
%>
                        <tr>
                            <td>
                                <%= ++i %>
                            </td>
                            <td>
                                <%= rsSerLot("INV_Serie").Value %>
                            </td>
                        </tr>
<%
                    rsSerLot.MoveNext()
                }
            } else {
%>
                        <tr>
                            <td colspan="2">
                                <i class="fa fa-exclamation-circle"></i> No hay registro(s)
                            </td>
                        </tr>
<%                
            }

            rsSerLot.Close()
%>
                    </tbody>
                </table>
            </div>
        </div>
<%

    } break;

   //Series Ubicacion Seleccion Listado
    case 1101: {

        rqStrInv_Serie = Parametro("Serie", "")
        rqIntTipoSeleccion = Parametro("TipoSeleccion", -1)
        rqStrFuncionSeleccion = Parametro("FuncionSeleccion", "")
        rqBolEsSeleccion = Parametro("EsSeleccion", 0)
        rqIntAlto = Parametro("Alto", 120)
        rqStrTitulo = Parametro("Titulo", "Series")
        rqBolVerTotalSeleccionado = Parametro("VerTotalSeleccionado", 0)

        sqlSerLot = "EXEC SPR_Inventario "
            + "  @Opcion = 1101 "
            + ", @INV_Serie = " + ( (rqStrInv_Serie.length > 0) ? "'" + rqStrInv_Serie + "'": "NULL" ) + " "
            + ", @TipoSeleccion = " + ( (rqIntTipoSeleccion > -1) ? rqIntTipoSeleccion : "NULL" ) + " "
        
        var rsSerLot = AbreTabla(sqlSerLot, 1, cxnTipo)
%>
        <div class="ibox">
            <div class="ibox-title">
                <h5><%= rqStrTitulo %></h5>
                <div class="ibox-tools">
<%
        if(parseInt(rqBolVerTotalSeleccionado) == 1){
%>                
                    <label class="text-success" title="Cantidad Seleccionada" id="labelSerieUbicacionSeleccionadaCantidad">
                        0
                    </label>
<%
        }
%>
<%
        if( parseInt(rqBolEsSeleccion) == 1){
%>                
                    <a class="btn btn-success btn-xs" title="Agregar" onClick="<%= rqStrFuncionSeleccion %>">
                        <i class="fa fa-plus"></i>
                    </a>
<%
        }
%>
                </div>
            </div>
            <div class="ibox-content" style="overflow-y: auto; max-height: <%= rqIntAlto %>px;">
                <table class="table table-striped border border-primary">
                    <thead>
                        <tr>
<%
        if( parseInt(rqBolEsSeleccion) == 1 ){                        
%>
                            <th>
                                <input type="checkbox" onClick="
                                $('.chbSerieUbicacionSeleccion').prop('checked', $(this).is(':checked'));
                                <% if(parseInt(rqBolVerTotalSeleccionado) == 1){ %> Inventario.SerieUbicacionListadoSeleccionadaCantidadVer() <% } %>
                                " checked>
                            </th>
<%  
     }
%>
                            <th> 
                                <i class="fa fa-barcode"></i> serie
                            </th>
                        </tr>
                    </thead>
                    <tbody >
<%          
            if( !(rsSerLot.EOF) ){
                var i = 0;
                while( !(rsSerLot.EOF) ){
%>
                        <tr>
<%
        if(parseInt(rqBolEsSeleccion) == 1){                        
%>
                            <td>
                                <input type="checkbox" class="chbSerieUbicacionSeleccion" value="<%= rsSerLot("INV_ID") %>" checked
                                <% if(parseInt(rqBolVerTotalSeleccionado) == 1){ %> onclick="Inventario.SerieUbicacionListadoSeleccionadaCantidadVer()" <% } %> >
                            </td>
<%  
     }
%>                            
                            <td>
                                <%= rsSerLot("INV_Serie").Value %>
                            </td>
                        </tr>
<%
                    rsSerLot.MoveNext()
                }
            } else {
%>
                        <tr>
                            <td colspan="2">
                                <i class="fa fa-exclamation-circle"></i> No hay registro(s)
                            </td>
                        </tr>
<%                
            }

            rsSerLot.Close()
%>
                    </tbody>
                </table>
            </div>
        </div>
<%

    } break;

    //Series Ubicacion Seleccion Listado
    case 1102: {

        rqIntIOM_ID = Parametro("IOM_ID", -1)
        rqStrFuncionEliminacion = Parametro("FuncionEliminacion", "")
        rqBolEsSeleccion = Parametro("EsSeleccion", 0)
        rqIntAlto = Parametro("Alto", 120)
        rqStrTitulo = Parametro("Titulo", "Series")
        rqBolVerTotalSeleccionado = Parametro("VerTotalSeleccionado", 0)

        sqlSerLot = "EXEC SPR_Inventario "
            + "  @Opcion = 1102 "
            + ", @IOM_ID = " + ( (rqIntIOM_ID > -1) ? rqIntIOM_ID : "NULL" ) + " "
        
        var rsSerLot = AbreTabla(sqlSerLot, 1, cxnTipo)
%>
        <div class="ibox">
            <div class="ibox-title">
                <h5><%= rqStrTitulo %></h5>

                <div class="ibox-tools">
<%
        if(parseInt(rqBolVerTotalSeleccionado) == 1){
%>                
                    <label class="text-success" title="Cantidad Seleccionada" id="labelSerieMovimientoSeleccionadaCantidad">
                        0
                    </label>
<%
        }
%>
                    <a class="btn btn-danger btn-xs" title="Actualizar" onClick="<%= rqStrFuncionEliminacion %>">
                        <i class="fa fa-floppy-o"></i>
                    </a>
                </div>
            </div>
            <div class="ibox-content" style="overflow-y: auto; max-height: <%= rqIntAlto %>px;">
                <table class="table table-striped border border-primary">
                    <thead>
                        <tr>
<%
        if( parseInt(rqBolEsSeleccion) == 1){
%>                         
                            <th>
                                <input type="checkbox" onClick="
                                $('.chbSerieMovimientoSeleccion').prop('checked', $(this).is(':checked'));
                                <% if(parseInt(rqBolVerTotalSeleccionado) == 1){ %> Inventario.SerieMovimientoListadoSeleccionadaCantidadVer() <% } %>
                                " checked>
                            </th>
<%
        }
%>
                            <th> 
                                <i class="fa fa-barcode"></i> serie
                            </th>
                        </tr>
                    </thead>
                    <tbody>
<%          
            if( !(rsSerLot.EOF) ){
                var i = 0;
                while( !(rsSerLot.EOF) ){
%>
                        <tr>
<%
        if( parseInt(rqBolEsSeleccion) == 1){
%> 
                            <td>
                                <input type="checkbox" class="chbSerieMovimientoSeleccion" value="<%= rsSerLot("INV_ID") %>" checked
                                <% if(parseInt(rqBolVerTotalSeleccionado) == 1){ %> onclick="Inventario.SerieMovimientoListadoSeleccionadaCantidadVer()" <% } %>>
                            </td>
<%
        }
%>
                            <td>
                                <%= rsSerLot("INV_Serie").Value %>
                            </td>
                        </tr>
<%
                    rsSerLot.MoveNext()
                }
            } else {
%>
                        <tr>
                            <td colspan="2">
                                <i class="fa fa-exclamation-circle"></i> No hay registro(s)
                            </td>
                        </tr>
<%                
            }

            rsSerLot.Close()
%>
                    </tbody>
                </table>
            </div>
        </div>
<%

    } break;
}
%>