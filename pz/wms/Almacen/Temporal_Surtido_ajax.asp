<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2020-OCT-06 Surtido: Creación de archivo

var cxnTipo = 0
var rqStrTarea = Parametro("Tarea", -1)

switch( parseInt( rqStrTarea ) ){

     //Cargar Series
    case 1: {

        var rqStrSeries = Parametro("Series", "")
        var rqIntUbi_ID = Parametro("Ubi_ID", "")
        var rqIntIDUsuario = Parametro("IDUsuario", -1)

        var intCantidadCargada = 0
        var intLot_ID = 0

        var intErrorNumero = 0
        var strErrorDescripcion = ""

        var jsonRespuesta = ""

        var sqlSerSur = "EXEC SPR_Temporal_Surtir "
              + "@Opcion = 1 "
            + ", @Ubi_ID = " + rqIntUbi_ID + " "
            + ", @Series = '" + rqStrSeries + "' "
            + ", @IDUsuario = " + rqIntIDUsuario + " "

        var rsSerSur = AbreTabla(sqlSerSur, 1, cxnTipo)

        if( !(rsSerSur.EOF) ){
            intErrorNumero = rsSerSur("ErrorNumero").Value
            strErrorDescripcion = rsSerSur("ErrorDescripcion").Value
            intCantidadCargada = rsSerSur("CantidadCargada").Value
            intLot_ID = rsSerSur("Lot_ID").Value
        }

        rsSerSur.Close()

        jsonRespuesta = '{'
              + '"Error": {'
                  + '"Numero": "' + intErrorNumero + '"'
                + ', "Descripcion": "' + strErrorDescripcion + '"'
            + '}'
            + ', "Registro": {'
                  + '"CantidadCargada": "' + intCantidadCargada + '"'
                + ', "Lot_ID": "' + intLot_ID + '"'
            + '}'
        + '}'

        Response.Write(jsonRespuesta)

    } break;

    //Series Cargadas con la nueva ubicacion
    case 2: {

        var rqIntLot_ID = Parametro("Lot_ID", -1)

        var sqlSerLot = "EXEC SPR_Temporal_Surtir "
             + "@Opcion = 2 "
            + ", @Lot_ID = " + rqIntLot_ID + " "

        var rsSerLot = AbreTabla(sqlSerLot, 1, cxnTipo)
%>
     <div class="ibox">
        <div class="ibox-title">
            <h5>Resultados</h5>
        </div>
        <div class="ibox-content">
             <table class="table table-striped issue-tracker">
                <thead>
                    <tr>
                        <th>#</th>  
                        <th>Lote</th>
                        <th>Cliente</th>
                        <th>Producto</th>
                        <th>Serie</th>
                        <th>Ubicacion</th>
                    </tr>
                </thead>
                <tbody>
<%  
        var i = 0;
        while( !(rsSerLot.EOF) ){

%>
                    <tr class="clsRegistros">
                        <td><%= ++i %></td>
                        <td class="text-nowrap"><%= rsSerLot("Lot_Folio").Value %></td>
                        <td><%= rsSerLot("Cli_Nombre").Value %></td>
                        <td class="issue-info">
                            <a href="#">
                                <%= rsSerLot("Pro_SKU").Value %>
                            </a>
                            <small>
                                <%= rsSerLot("Pro_Nombre").Value %>
                            </small>
                        </td>
                        <td class="text-nowrap"><%= rsSerLot("INV_Serie").Value %></td>
                        <td class="text-nowrap"><%= rsSerLot("Ubi_Nombre").Value %></td>
                    </tr>
<%
            Response.Flush()
            rsSerLot.MoveNext()
        }
%>
                </tbody>
            </table>
        </div>
    </div>
<%
    rsSerLot.Close()

    } break;
}
%>
