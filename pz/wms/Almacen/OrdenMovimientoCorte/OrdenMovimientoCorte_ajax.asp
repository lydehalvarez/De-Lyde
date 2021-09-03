<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2020-OCT-20 Orden Movimiento: Creación de archivo

var cxnTipo = 0
var rqStrTarea = Parametro("Tarea", -1)

switch( parseInt( rqStrTarea ) ){

    //Listado Principal
    case 1000: {

        var rqIntCli_ID = Parametro("Cli_ID", -1)
        var rqIntUbi_ID_Destino = Parametro("Ubi_ID_Destino", -1)
        var rqStrPro_SKU = Parametro("Pro_SKU", "")
        var rqIntIOM_TipoCG86 = Parametro("IOM_TipoCG80", -1)

        var sqlIOMCBus = "EXEC SPR_Inventario_OrdenMovimientoCorte "
              + "@Opcion = 1100 "
            + ", @Cli_ID = " + ( (rqIntCli_ID > -1) ? rqIntCli_ID : "NULL") + " "
            + ", @Pro_SKU = " + ( (rqStrPro_SKU.length > 0) ? "'" + rqStrPro_SKU + "'" : "NULL") + " "
            + ", @Ubi_ID_Destino = " + ( (rqIntUbi_ID_Destino > -1) ? rqIntUbi_ID_Destino : "NULL") + " "
            + ", @IOM_TipoCG86 = " + ( (rqIntIOM_TipoCG86 > -1) ? rqIntIOM_TipoCG86 : "NULL" ) + " "

        //Response.Write(sqlIOMCBus)

        var rsIOMCBus = AbreTabla(sqlIOMCBus, 1, cxnTipo)
%>
    <div class="ibox">
        <div class="ibox-title">
            <h5>Resultados</h5>
        </div>
        <div class="ibox-content">
             <table class="table table-striped issue-tracker">
                <thead>
                    <tr>
                        <th></th>
                        <th class="col-sm-1" title="Estatus de Orden de Movimiento">Estatus Ord. Mov.</th>
                        <th class="col-sm-1">Folio</th>
                        <th class="col-sm-1">Tipo Orden</th>
                        <th class="col-sm-1">Cliente</th>
                        <th class="col-sm-3">Ubicacion</th>
                        <th class="col-sm-1" title="Cantidad Solicitada">Cant. Sol.</th>
                        <th class="col-sm-1" title="Cantidad Entregada">Cant. Ent.</th>
                        <th class="col-sm-2"></th>
                    </tr>
                </thead>
                <tbody>
<%
        var intIOMC_ID = 0

        while(!(rsIOMCBus.EOF) ){

            if( intIOMC_ID != rsIOMCBus("IOMC_ID").Value){
%>
                    <tr class="text-success">
                        <th colspan="6">
                            <i class="fa fa-object-ungroup"></i> CORTE - <%= rsIOMCBus("IOMC_ID").Value %>
                        </th>  
                        <th colspan="3" class="text-nowrap">
                            <i class="fa fa-clock-o"></i> <%= rsIOMCBus("IOMC_FechaRegistro").Value %>
                        </th>          
                    </tr>
<%                
            }
%>
                    <tr>
                        <td>
<%
            if( parseInt(rsIOMCBus("IOM_Prioridad").Value) == 1 ){
%>
                            <i class="fa fa-exclamation fa-lg text-danger" title="Prioridad"></i>
<%
            }
%>                      
                        </td>
                        <td class="text-nowrap">
<%
            var strEstatusColor = ""

            switch( parseInt(rsIOMCBus("IOM_EstatusCG80").Value) ){

                //En Proceso
                case 3: { strEstatusColor = "label-success" } break;

                //Surtida
                case 4:	{ strEstatusColor = "label-primary" } break;

                //Cancelada
                case 5:	{ strEstatusColor = "label-danger" } break;
            }
%>
                            <label class="label <%= strEstatusColor %>">
                                <%= rsIOMCBus("IOM_Est_Nombre").Value %>
                            </label>
                        </td>
                        <td class="text-nowrap"><%= rsIOMCBus("IOM_Folio").Value %></td>
                        <td class="text-nowrap">
                            <strong><%= rsIOMCBus("IOM_TOM_Nombre").Value %></strong>
                            <br>
                            <small title="Estatus de Inventario"><%= rsIOMCBus("INV_Est_Nombre").Value %></small>
                        </td>
                        <td class="text-nowrap"><%= rsIOMCBus("Cli_Nombre").Value %></td>
                        <td class="issue-info">
                            <a href="#">
                                <%= rsIOMCBus("Ubi_Nombre").Value %>
                            </a>
                            <small>
                                <%= rsIOMCBus("Pro_SKU").Value %> - <%= rsIOMCBus("Pro_Nombre").Value %>
                            </small>
                        </td>
                        <td><%= rsIOMCBus("IOM_CantidadSolicitada").Value %></td>
                        <td><%= rsIOMCBus("IOM_CantidadEntregada").Value %></td>
                        <td class="text-nowrap">
<%
             //Terminado
            if( rsIOMCBus("IOM_EstatusCG80").Value == 3 ){

                var strfuncion = ""

                switch( parseInt(rsIOMCBus("IOM_TipoCG86").Value) ){
                    case 1: { //Surtido
                        strfuncion = "OdenMovimientoPorSurtido.ModalTerminarAbrir();"
                    } break;
                    case 2: { //por Estatus
                        strfuncion = "OdenMovimientoPorEstatus.ModalTerminarAbrir();"
                    } break;
                }
%>
                            <a href="#" class="btn btn-success btn-sm" onclick="<%= strfuncion %>" title="Terminar el movimiento">
                                <i class="fa fa-level-down"></i>
                            </a>
<%
            }
%>
                        </td>
                    </tr>
<%          
            intIOMC_ID = rsIOMCBus("IOMC_ID") .Value

            rsIOMCBus.MoveNext()
        }

        rsIOMCBus.Close()
%>
                </tbody>
            </table>
        </div>
    </div>
<%
    } break

    //Registro de Corte de Ordenes de Movimiento
    case 2000: {

        var rqIntIDUsuario = Parametro("IDUsuario", -1)
        var rqStrIOM_IDs = Parametro("IOM_IDs", "")

        var intCantidad = rqStrIOM_IDs.split(",").length

        var intIOMC_ID = -1

        var intErrorNumero = 0
        var strErrorDescripcion = ""

        var jsonRespuesta = '{}'

        var sqlIOMC = "EXEC SPR_Inventario_OrdenMovimientoCorte "
              + "@Opcion = 2000 "
            + ", @IOMC_IDUsuario = " + ( (rqIntIDUsuario > -1) ? rqIntIDUsuario : "NULL") + " "
            + ", @IOMC_CantidadOrdenesSurtir = " + ( (intCantidad > 0) ? intCantidad : 0 ) + " "

        var rsIOMC = AbreTabla(sqlIOMC, 1, cxnTipo)

        if( !(rsIOMC.EOF) ){
            intErrorNumero = rsIOMC("ErrorNumero").Value
            strErrorDescripcion = rsIOMC("ErrorDescripcion").Value
            intIOMC_ID = rsIOMC("IOMC_ID").Value
        }

        rsIOMC.Close()

        if( parseInt(intErrorNumero) == 0 ){

            var sqlIOM = "EXEC SPR_Inventario_OrdenMovimiento "
                  + "@Opcion = 3200 "
                + ", @IOM_IDs = '" + rqStrIOM_IDs + "' "
                + ", @IOMC_ID = " + intIOMC_ID + " "
                + ", @IOM_EstatusCG80 = 3 /* En Proceso */ "

            var rsIOM = AbreTabla(sqlIOM, 1, cxnTipo)

            if( !(rsIOM.EOF) ){
                intErrorNumero = rsIOM("ErrorNumero").Value
                strErrorDescripcion += "<br>" + rsIOM("ErrorDescripcion").Value
            }   

            rsIOM.Close()
        }

        if( parseInt(intErrorNumero) == 0 ){

            var arrIOM_Folios = []

            var sqlIOMBus = "EXEC SPR_Inventario_OrdenMovimiento "
                  + "@Opcion = 1000 "
                + ", @IOMC_ID = " + intIOMC_ID + " "

            var rsIOMBus = AbreTabla(sqlIOMBus, 1, cxnTipo)

            while( !(rsIOMBus.EOF) ){
                
                arrIOM_Folios.push( rsIOMBus("IOM_Folio").Value )

                rsIOMBus.MoveNext()
            }

            rsIOMBus.Close()

            strErrorDescripcion += "<br> Folios del Corte: <br>" + arrIOM_Folios.join("<br>")

        }

        jsonRespuesta = '{'
                + '"Error": {'
                    + '"Numero": "' + intErrorNumero + '" '
                    + ', "Descripcion": "' + strErrorDescripcion + '" '
                +'}'
                + ', "OrdenMovimientoCorte": {'
                    + '"IOMC_ID": "' + intIOMC_ID + '" '
                +'} '
            +'}'
        

        Response.Write(jsonRespuesta)

    } break;
}
%>