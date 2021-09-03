<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2020-ENE-05 Surtido: Creación de archivo

var cxnTipo = 0
var rqStrTarea = Parametro("Tarea", -1)

switch( parseInt( rqStrTarea ) ){

    //Exportacion de Informacion
    case 1100: {
        
        var dateFechaDefault = new Date()

        var rqIntProv_ID = Parametro("Prov_ID", -1)
        var rqIntCli_ID = Parametro("Cli_ID", -1)
        var rqIntTipo = Parametro("Tipo", 1)
        var rqDateFecha = Parametro("Fecha", dateFechaDefault)
        var rqIntEsTransportista = Parametro("EsTransportista", -1)

        var dateFechaInicial = ( ( rqIntTipo == 1 ) ? "'" + rqDateFecha  + "'": "NULL" );
        var dateFechaFinal = "'" + rqDateFecha  + "'"

        var bolHayProv = (rqIntEsTransportista == 1)

        var sqlExp = "EXEC SPR_MProveedor "
            + "@Opcion = 1000 "
            + ", @Prov_ID = " + ( (rqIntProv_ID > -1) ? rqIntProv_ID : "NULL" ) + " "
            + ", @Cli_ID = " + ( (rqIntCli_ID > -1) ? rqIntCli_ID : "NULL" ) + " "
            + ", @FechaInicial = " + dateFechaInicial + " "
            + ", @FechaFinal = " + dateFechaFinal + " "
            + ", @Est_IDs = '5,6,7,8' "

        var rsExp = AbreTabla(sqlExp, 1, cxnTipo)

        var jsonRespuesta = '['

        var bolInicio = true

        while( !(rsExp.EOF) ){
            
            jsonRespuesta += ( bolInicio ) ? '' : ','
            jsonRespuesta += '{'
                      + '"Estatus": "' + rsExp("Est_Nombre").Value + '"'
                    + ', "Manifiesto": "' + rsExp("Man_Folio").Value + '"'
                    + ', "Fecha_Salida": "' + rsExp("Man_FechaConfirmado").Value + '"'
                    + ', "Folio": "' + rsExp("Folio").Value + '"'
                    + ', "Destino": "' + rsExp("Almacen").Value + '"'

            if( !(bolHayProv) ) {
                jsonRespuesta += ', "Transportista": "' + rsExp("Transportista").Value + '"'
                    + ', "Tipo_Ruta": "' + rsExp("TipoRuta").Value + '"'
            }

            jsonRespuesta += ', "Guia": "' + rsExp("Guia").Value + '"'
                    + ', "Fecha_Compromiso": "' + rsExp("Man_FechaCompromiso").Value + '"'
                +'}'    

            bolInicio = false

            Response.Flush()
            rsExp.MoveNext()
        }

        jsonRespuesta += ']'

        rsExp.Close()

        Response.Write(jsonRespuesta)

    } break;
}
%>