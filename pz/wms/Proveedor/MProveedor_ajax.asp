<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2020-ENE-05 Surtido: Creación de archivo

var cxnTipo = 0
var rqStrTarea = Parametro("Tarea", -1)

switch( parseInt( rqStrTarea ) ){

    //Extraccion de Informacion
    case 1000: {

        var rqIntTA_ID = Parametro("TA_ID", -1)
        var rqIntOV_ID = Parametro("OV_ID", -1)

        var sqlMPBus = "EXEC SPR_MProveedor "
              + "@Opcion = 1000 "
            + ", @TA_ID = " + (( rqIntTA_ID > -1 ) ? rqIntTA_ID : "NULL" ) + " "
            + ", @OV_ID = " + (( rqIntOV_ID > -1 ) ? rqIntOV_ID : "NULL" ) + " "

        var rsMPBus = AbreTabla(sqlMPBus, 1, cxnTipo)

        var jsonRespuesta = JSON.Convertir(rsMPBus, JSON.Tipo.RecordSet)

        rsMPBus.Close()

        Response.Write(jsonRespuesta)

    } break;

    //Cambio de Estatus
    case 3000: {

        var rqIntTA_ID = Parametro("TA_ID", -1)
        var rqIntOV_ID = Parametro("OV_ID", -1)
        var rqIntEst_ID = Parametro("Est_ID", -1)
        var rqStrComentario = Parametro("Comentario", "")
        var rqStrRecibio = Parametro("Recibio", "")
        var rqIntIDUsuario = Parametro("IDUsuario", -1)
        var rqDateFechaHora = Parametro("FechaHora", "")

        var intErrorNumero = 0
        var strErrorDescripcion = ""

        var jsonRespuesta = '{}'

        var sqlEstCam = "EXEC SPR_MProveedor  "
              + "@Opcion = 3000 "
            + ", @TA_ID = " + ( (rqIntTA_ID > -1) ? rqIntTA_ID : "NULL" ) + " "
            + ", @OV_ID = " + ( (rqIntOV_ID > -1) ? rqIntOV_ID : "NULL" ) + " "
            + ", @Est_ID = " + ( (rqIntEst_ID > -1) ? rqIntEst_ID : "NULL" ) + " "
            + ", @Comentario = " + ( (rqStrComentario.length > 0) ? "'" + rqStrComentario + "'" : "NULL" ) + " "
            + ", @Recibio = " + ( (rqStrRecibio.length > 0) ? "'" + rqStrRecibio + "'" : "NULL" ) + " "
            + ", @UltimaFechaEstatus = " + ( (rqDateFechaHora.length > 0 ) ? "'" + rqDateFechaHora + "'" : "NULL" ) + " "
            + ", @IDUsuario = " + ( (rqIntIDUsuario > -1) ? rqIntIDUsuario : "NULL" ) + " "

        var rsEstCam = AbreTabla(sqlEstCam, 1, cxnTipo)

        if( !(rsEstCam.EOF) ){
            intErrorNumero = rsEstCam("ErrorNumero").Value
            strErrorDescripcion = rsEstCam("ErrorDescripcion").Value
        } else {
            intErrorNumero = 1
            strErrorDescripcion = "Error al realizar la actualizacion"
        }

        rsEstCam.Close()

        jsonRespuesta = '{'
                + '"Error": {'
                      + '"Numero": "' + intErrorNumero + '"'
                    + ', "Descripcion": "' + strErrorDescripcion + '"'
                + '}'
            + '}'

        Response.Write(jsonRespuesta)

    } break;
}
%>