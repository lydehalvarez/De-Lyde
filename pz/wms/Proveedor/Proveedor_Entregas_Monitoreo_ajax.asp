<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2021-JUN-28 Surtido: Creación de archivo

var cxnTipo = 0;

var rqStrTarea = Parametro("Tarea", -1)

switch( parseInt( rqStrTarea ) ){

    case 1000: {

        var rqDateFecha = Parametro("Fecha", -1);
        var rqIntEst_ID = Parametro("Est_ID", -1);
        var rqIntProv_ID = Parametro("Prov_ID", -1)
        var rqIntCli_ID = Parametro("Cli_ID", -1)

        var sqlSeg = "EXEC SPR_Proveedor_Entregas_Monitoreo "
              + "@Opcion = 1100 "
            + ", @Est_ID = " + ( ( rqIntEst_ID > -1 ) ? rqIntEst_ID : "NULL" ) + " "
            + ", @Prov_ID = " + ( ( rqIntProv_ID > -1 ) ? rqIntProv_ID : "NULL" ) + " "
            + ", @Cli_ID = " + ( ( rqIntCli_ID > -1 ) ? rqIntCli_ID : "NULL" ) + " "
            + ", @FechaInicial = " + ( ( rqDateFecha.length > 0 ) ? "'" + rqDateFecha + "'" : "NULL" ) + " "
            + ", @FechaFinal = " + ( ( rqDateFecha.length > 0 ) ? "'" + rqDateFecha + "'" : "NULL" ) + " "

        var rsSeg = AbreTabla(sqlSeg, 1, cxnTipo)

        var jsonRespuesta = '[';
        var bolIni = true;

        while( !(rsSeg.EOF) ){
 
            jsonRespuesta += (bolIni) ? '' : ',';   

            jsonRespuesta += '{'
                      + '"ID": "' + rsSeg("ID").Value + '"'
                    + ', "FechaRegistro": "' + rsSeg("FechaRegistro").Value + '"'
                    + ', "Folio": "' + rsSeg("Folio").Value + '"'
                    + ', "Pedido": "' + rsSeg("Pedido").Value + '"'
                    + ', "Estatus": "' + rsSeg("Est_Nombre").Value + '"'
                    + ', "Transportista": "' + rsSeg("Prov_Nombre").Value + '"'
                    + ', "Guia": "' + rsSeg("Guia").Value + '"'
                    + ', "Manifiesto": "' + rsSeg("Man_Folio").Value + '"'
                    + ', "Dias_Transito": "' + rsSeg("DiasTransito").Value + '"'
                + '}'

            bolIni = false 
            Response.Flush();
            rsSeg.MoveNext();
        }

        jsonRespuesta += ']';

        rsSeg.Close();

        Response.Write(jsonRespuesta);

    } break;

}
%>