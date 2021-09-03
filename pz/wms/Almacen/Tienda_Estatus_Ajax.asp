<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2020-OCT-06 Surtido: Creación de archivo

var cxnTipo = 0
var rqStrTarea = Parametro("Tarea", -1)

switch( parseInt( rqStrTarea ) ){

    //Cambio de ubicacion
    case 1000: {

        var rqIntAlm_ID = Parametro("Alm_ID", -1)

        var jsonResupesta = '{}'

        var sqlAlmDet = "EXEC SPR_Almacen "
              + "@Opcion = 1000 "
            + ", @Alm_ID = " + ( ( rqIntAlm_ID > -1 ) ? rqIntAlm_ID : "NULL" ) + " "

        var rsAlmDet = AbreTabla(sqlAlmDet, 1, cxnTipo)

        if( !(rsAlmDet.EOF) ){

            jsonRespuesta = '{'
                + '"Registro": {'
                      + '"Alm_ID": "' + rsAlmDet("Alm_ID").Value + '"'
                    + ', "Tpo_Nombre": "' + rsAlmDet("Tpo_Nombre").Value + '"'
                    + ', "Alm_Numero": "' + rsAlmDet("Alm_Numero").Value + '"'
                    + ', "Alm_Nombre": "' + rsAlmDet("Alm_Nombre").Value + '"'
                    + ', "Alm_Clave": "' + rsAlmDet("Alm_Clave").Value + '"'
                    + ', "Cli_Nombre": "' + rsAlmDet("Cli_Nombre").Value + '"'
                    + ', "Alm_Responsable": "' + rsAlmDet("Alm_Responsable").Value + '"'
                    + ', "Alm_HorarioLV": "' + rsAlmDet("Alm_HorarioLV").Value + '"'
                    + ', "Alm_HorarioSabado": "' + rsAlmDet("Alm_HorarioSabado").Value + '"'
                    + ', "Alm_Domingo": "' + rsAlmDet("Alm_Domingo").Value + '"'
                    + ', "Alm_RespTelefono": "' + rsAlmDet("Alm_RespTelefono").Value + '"'
                    + ', "Alm_RespEmail": "' + rsAlmDet("Alm_RespEmail").Value + '"'
                    + ', "Alm_Direccion": "' + rsAlmDet("Alm_Direccion").Value + '"'
                    + ', "Alm_Latitud": "' + rsAlmDet("Alm_Latitud").Value + '"'
                    + ', "Alm_Longitud": "' + rsAlmDet("Alm_Longitud").Value + '"'
                    + ', "Alm_TiempoEntregaHrs": "' + rsAlmDet("Alm_TiempoEntregaHrs").Value + '"'
                    + ', "Alm_DistanciaKM": "' + rsAlmDet("Alm_DistanciaKM").Value + '"'
                + '}'
            + '}'

        }
        rsAlmDet.Close()

        Response.Write(jsonRespuesta);

    } break;

}
%>