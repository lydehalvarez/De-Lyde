<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
var cxnTipo = 0;
var rqIntTarea = Parametro("Tarea", 0);

switch( parseInt(rqIntTarea) ){
    case 2000: { //Congelado
        
        var rqIntAud_ID = Parametro("Aud_ID", -1);
        var rqStrLPNs = Parametro("PT_IDs", "");

        var intErrorNumero = 0;
        var strErrorDescripcion = "";
        var jsonRespuesta = '{}';

        var sqlAudLPN = "EXEC SPR_Auditoria_Seleccion_LPN "
              + "@Opcion = 2000 "
            + ", @Aud_ID = " + ( (rqIntAud_ID > -1) ? rqIntAud_ID : "NULL" ) + " "
            + ", @PT_IDs = " + ( (rqStrLPNs.length > 0) ? "'" + rqStrLPNs + "'" : "NULL" ) + " ";

        var rsAudLPN = AbreTabla(sqlAudLPN, 1, cxnTipo);

        try{

            if( !(rsAudLPN.EOF) ){
                intErrorNumero = rsAudLPN("ErrorNumero").Value
                strErrorDescripcion = rsAudLPN("ErrorDescripcion").Value
            } else {
                intErrorNumero = 1
                strErrorDescripcion = "No se ejecuto el procedimiento de congelacion"
            }
			rsAudLPN.Close();

        } catch(e){

            intErrorNumero = 1
            strErrorDescripcion = "No se ejecuto el procedimiento de congelacion"
			rsAudLPN.Close();
        }


        jsonRespuesta = '{'
                + '"Error": {'
                      + '"Numero": "' + intErrorNumero + '"'
                    + ', "Descripcion": "' + strErrorDescripcion + '"'
                +'}'
            + '}';

        Response.Write(jsonRespuesta);

    } break;
	
	case 2100: {
		
		var rqIntAud_ID = Parametro("Aud_ID", -1)
		var rqIntVisita = Parametro("Visita", -1)
		var IDUsuario = Parametro("IDUsuario", -1)
		
		var intErrorNumero = 0
		var strErrorDescripcion = ""
		
		var jsonRespuesta = '{}'
		
		var sqlVis = "EXEC SPR_Auditoria_Generar_Papeletas "
			  + "@Opcion = 2000 "
			+ ", @Aud_ID = " + ( (rqIntAud_ID > -1) ? rqIntAud_ID : "NULL" ) + " "
			+ ", @AudU_Veces = " + ( (rqIntVisita > -1) ? rqIntVisita : "NULL") + " "
			+ ", @IDUsuario = " + IDUsuario
			
		var rsVis = AbreTabla(sqlVis, 1, cxnTipo)
		
		try {
			if( !(rsVis.EOF) ){
                intErrorNumero = rsVis("ErrorNumero").Value
                strErrorDescripcion = rsVis("ErrorDescripcion").Value
            } else {
                intErrorNumero = 1
                strErrorDescripcion = "No se ejecuto el procedimiento de Creacion de Papeletas"
            }

        } catch(e){

            intErrorNumero = 1
            strErrorDescripcion = "No se ejecuto el procedimiento de Creacion de Papeletas"

        }

        rsVis.Close();

        jsonRespuesta = '{'
                + '"Error": {'
                      + '"Numero": "' + intErrorNumero + '"'
                    + ', "Descripcion": "' + strErrorDescripcion + '"'
                +'}'
            + '}';

        Response.Write(jsonRespuesta);
		
	} break;
}
%>