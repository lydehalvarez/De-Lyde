<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2021-FEB-15 Auditoria Pallet - Auditoria: Creación de archivo
var cxnTipo = 0

var rqIntTarea = Parametro("Tarea", -1)

switch( parseInt(rqIntTarea) ){

    //Insercion de Auditorias Ubicacion
    case 2010: {

        var rqIntAud_ID = Parametro("Aud_ID", -1)
        var rqIntPT_ID = Parametro("PT_ID", -1)
        var rqIntAudU_TipoConteoCG142 = Parametro("TPA_ID", -1)
        var rqIntUsu_ID_Int = Parametro("Usu_ID_Int", -1)
        var rqIntUsu_ID_Ext = Parametro("Usu_ID_Ext", -1)

        var intErrorNumero = 0
        var strErrorDescripcion = ""

        var jsonRespuesta = '{}'

        var sqlAAUI = "EXEC SPR_Auditorias_Ubicacion "
              + "@Opcion = 2010 "
            + ", @Aud_ID = " + ( (rqIntAud_ID > -1) ? rqIntAud_ID : "NULL" ) + " "
            + ", @PT_ID = " + ( (rqIntPT_ID > -1) ? rqIntPT_ID : "NULL" ) + " "
            + ", @AudU_TipoConteoCG142 = " + ( (rqIntAudU_TipoConteoCG142 > -1) ? rqIntAudU_TipoConteoCG142 : "NULL" ) + " "
            + ", @Usu_ID_Int = " + ( (rqIntUsu_ID_Int > -1) ? rqIntUsu_ID_Int : "NULL" ) + " "
            + ", @Usu_ID_Ext = " + ( (rqIntUsu_ID_Ext > -1) ? rqIntUsu_ID_Ext : "NULL" ) + " "

        var rsAAUI = AbreTabla(sqlAAUI, 1, cxnTipo)

        if( !(rsAAUI.EOF) ){
            intErrorNumero = rsAAUI("ErrorNumero").Value
            strErrorDescripcion = rsAAUI("ErrorDescripcion").Value

        } else {

            intErrorNumero = 1
            strErrorDescripcion = "No se actualizo la Auditoria Pallet "
        }

        rsAAUI.Close()
            
        jsonRespuesta = '{'
                + '"Error": {'
                      + '"Numero": "' + intErrorNumero + '"'
                    + ', "Descripcion": "' + strErrorDescripcion + '"'
                +'}'
            + '}'

        Response.Write( jsonRespuesta )

    } break;

    //Actualizacion de Auditorias Ubicacion
    case 3000: {

        var rqIntAud_ID = Parametro("Aud_ID", -1)
        var rqIntPT_ID = Parametro("PT_ID", -1)
        var rqIntAudU_ID = Parametro("AudU_ID", -1)
        var rqStrAudU_Comentario = Parametro("AudU_Comentario", "")
        var rqIntAudU_HallazgoCG144 = Parametro("AudU_HallazgoCG144", -1)
        var rqIntAudU_ArticulosConteoTotal = Parametro("AudU_ArticulosConteoTotal", -1)
        var rqIntAudU_MBCantidad = Parametro("AudU_MBCantidad", -1)
        var rqIntAudU_MBCantidadArticulos = Parametro("AudU_MBCantidadArticulos", -1)
        var rqIntAudU_MBCantidadSobrante = Parametro("AudU_MBCantidadSobrante", -1)
        var rqIntAudU_EnProceso = Parametro("AudU_EnProceso", -1)
        var rqIntAudU_Terminado = Parametro("AudU_Terminado", -1)

        var intErrorNumero = 0
        var strErrorDescripcion = ""

        var jsonRespuesta = '{}'

        var sqlAAUE = "EXEC SPR_Auditorias_Ubicacion "
              + "@Opcion = 3000 "
            + ", @Aud_ID = " + ( (rqIntAud_ID > -1) ? rqIntAud_ID : "NULL" ) + " "
            + ", @PT_ID = " + ( (rqIntPT_ID > -1) ? rqIntPT_ID : "NULL" ) + " "
            + ", @AudU_ID = " + ( (rqIntAudU_ID > -1) ? rqIntAudU_ID : "NULL" ) + " "
            + ", @AudU_Comentario = " + ( (rqStrAudU_Comentario.length > 0) ? "'" + rqStrAudU_Comentario + "'" : "NULL" ) + " "
            + ", @AudU_HallazgoCG144 = " + ( (rqIntAudU_HallazgoCG144 > -1) ? rqIntAudU_HallazgoCG144 : "NULL" ) +  " " 
            + ", @AudU_ArticulosConteoTotal = " + ( (rqIntAudU_ArticulosConteoTotal > -1) ? rqIntAudU_ArticulosConteoTotal : "NULL" ) + " "
            + ", @AudU_MBCantidad = " + ( (rqIntAudU_MBCantidad > -1) ? rqIntAudU_MBCantidad : "NULL" ) + " "    
            + ", @AudU_MBCantidadArticulos = " + ( (rqIntAudU_MBCantidadArticulos > -1) ? rqIntAudU_MBCantidadArticulos : "NULL" ) + " "
            + ", @AudU_MBCantidadSobrante = " + ( (rqIntAudU_MBCantidadSobrante > -1) ? rqIntAudU_MBCantidadSobrante : "NULL" ) + " "
            + ", @AudU_EnProceso = " + ( (rqIntAudU_EnProceso > -1) ? rqIntAudU_EnProceso : "NULL" ) +  " " 
            + ", @AudU_Terminado = " + ( (rqIntAudU_Terminado > -1) ? rqIntAudU_Terminado : "NULL" ) +  " " 
        
        var rsAAUE = AbreTabla(sqlAAUE, 1, cxnTipo)

        if( !(rsAAUE.EOF) ){

            intErrorNumero = rsAAUE("ErrorNumero").Value
            strErrorDescripcion = rsAAUE("ErrorDescripcion").Value

        } else {

            intErrorNumero = 1
            strErrorDescripcion = "No se actualizo la Auditoria Pallet "
        }

        rsAAUE.Close()
            
        jsonRespuesta = '{'
                + '"Error": {'
                      + '"Numero": "' + intErrorNumero + '"'
                    + ', "Descripcion": "' + strErrorDescripcion + '"'
                +'}'
            + '}'

        Response.Write( jsonRespuesta )

    } break;
}
%>