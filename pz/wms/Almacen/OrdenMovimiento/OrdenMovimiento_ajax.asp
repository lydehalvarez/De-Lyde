<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2020-OCT-20 Orden Movimiento: Creación de archivo

var cxnTipo = 0
var rqStrTarea = Parametro("Tarea", -1)

switch( parseInt( rqStrTarea ) ){

        //Extraer Registros
    case 10: {

        var rqIntIOM_ID = Parametro("IOM_ID", -1)

        var sqlExtID = "EXEC SPR_Inventario_OrdenMovimiento "
              + "@Opcion = 1000 "
            + ", @IOM_ID = " + ( (rqIntIOM_ID > -1) ? rqIntIOM_ID : "NULL" ) + " "
        
        var rsExtID = AbreTabla(sqlExtID, 1, cxnTipo)

        var jsonRespuesta = JSON.Convertir(rsExtID, JSON.Tipo.RecordSet)

        rsExtID.close()

        Response.Write(jsonRespuesta)

    } break;

    //Insertar Registro
    case 2000:{

        var rqIntTOM_ID = Parametro("TOM_ID", -1)
        var rqIntEst_ID = Parametro("Est_ID", -1)
        var rqIntIOM_IDUsuario = Parametro("IOM_IDUsuario", -1)
        var rqIntAre_ID_Origen = Parametro("Are_ID_Origen")
        var rqIntAre_ID_Destino = Parametro("Are_ID_Destino")

        var intErrorNumero = 0
        var strErrorDescripcion = ""

        var jsonRespuesta = '{}'

        var sqlIns = "EXEC SPR_Inventario_OrdenMovimiento "
              + "@Opcion = 2000 "
            + ", @IOM_EsManual = 1 /* Si */ "
            + ", @IOM_TipoCG86 = " + ( ( rqIntTOM_ID > -1 ) ? rqIntTOM_ID : "NULL" ) + " "
            + ", @IOM_EstatusCG80 = " + ( ( rqIntEst_ID > -1 ) ? rqIntEst_ID : "NULL" ) + " "
            + ", @IOM_IDUsuario = " + ( ( rqIntIOM_IDUsuario > -1 ) ? rqIntIOM_IDUsuario : "NULL" ) + " "
            + ", @Are_ID_Origen = " + ( ( rqIntAre_ID_Origen > -1) ? rqIntAre_ID_Origen : "NULL" ) + " "
            + ", @Are_ID_Destino = " + ( ( rqIntAre_ID_Origen > -1 ) ? rqIntAre_ID_Origen : "NULL" ) + " "

        var rsIns = AbreTabla(sqlIns, 1, cxnTipo)

        if( !(rsIns.EOF) ){
            intErrorNumero = rsIns("ErrorNumero").Value
            strErrorDescripcion = rsIns("ErrorDescripcion").Value
            intIOM_ID = rsIns("IOM_ID").Value
        } else {
            intErrorNumero = 1
            strErrorDescripcion = "No se ejecuto el procedimiento de Insercion de la Orden de Movimiento"
        }

        rsIns.Close()

        jsonRespuesta = '{ '
                  + '"Error": { '
                      + '"Numero": "' + intErrorNumero + '" '
                    + ', "Descripcion": "' + strErrorDescripcion + '" '
                + '} '
                + ', "Registro": { '
                    + '"IOM_ID": "' + intIOM_ID + '" '
                + '} '
            + '} '

        Response.Write(jsonRespuesta)

    } break;

    //Eliminar Registro de Orden de Venta
    case 4000: {

        var rqIntIOM_ID = Parametro("IOM_ID", -1)

        var intErrorNumero = 0
        var strErrorDescripcion = ""

        var jsonRespuesta = '{}'

        var sqlEli = "EXEC SPR_Inventario_OrdenMovimiento "
              + "@Opcion = 4000 "
            + ", @IOM_ID = " + ( ( rqIntIOM_ID > -1 ) ? rqIntIOM_ID : "NULL") + " "

        var rsEli = AbreTabla(sqlEli, 1, cxnTipo)

        if( !(rsEli.EOF) ){
            intErrorNumero = rsEli("ErrorNumero").Value
            strErrorDescripcion = rsEli("ErrorDescripcion").Value
        } else {
            intErrorNumero = 1
            strErrorDescripcion = "No se ejecuto el procedimiento de Eliminacion de la Orden de Movimiento"
        }
       
        jsonRespuesta = '{ '
                  + '"Error": { '
                      + '"Numero": "' + intErrorNumero + '" '
                    + ', "Descripcion": "' + strErrorDescripcion + '" '
                + '} '
            + '} '

        Response.Write(jsonRespuesta)

    } break;

}
%>