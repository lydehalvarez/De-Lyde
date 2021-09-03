<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2021-MAR-31 RFID: Creación de archivo

var cxnTipo = 0

var rqIntTarea = Parametro("Tarea", -1)

switch( parseInt(rqIntTarea) ){
    /* Busqueeda de IMEI o RFID */
    case 1000: {

        var rqStrIMEI = Parametro("IMEI", "")
        var rqStrRFID = Parametro("RFID", "")
        var rqIntIDUsuario = Parametro("IDUsuario", -1)

        var intErrorNumero = 0
        var strErrorDescripcion = ""

        var strIMEI = ""
        var strRFID = ""
        var strAntIMEI = ""
        var strAntRFID = ""
        var strUsuario = ""

        var jsonRespuesta = '{}'

        var sqlBus = "EXEC SPR_Asignacion_RFID "
              + "@Opcion = 1000 "
            + ", @IMEI = " + ( ( rqStrIMEI.length > 0) ? "'" + rqStrIMEI + "'" : "NULL" ) + " "
            + ", @RFID = " + ( ( rqStrRFID.length > 0) ? "'" + rqStrRFID + "'" : "NULL" ) + " "
            + ", @IDUsuario = " + ( ( rqIntIDUsuario > -1 ) ? rqIntIDUsuario : "NULL" ) + " "

       var rsBus = AbreTabla(sqlBus, 1, cxnTipo)

        try {

            if( !(rsBus.EOF) ){
                intErrorNumero = rsBus("ErrorNumero").Value
                strErrorDescripcion = rsBus("ErrorDescripcion").Value

                strIMEI = rsBus("IMEI").Value
                strRFID = rsBus("RFID").Value
                strAntIMEI = rsBus("AntIMEI").Value
                strAntRFID = rsBus("AntRFID").Value
                strUsuario = rsBus("Usuario").Value
            } else {
                intErrorNumero = 1
                strErrorDescripcion = "No se ejecuto la opcion del procedimiento"
            }

        } catch(e) {
            intErrorNumero = 1
            strErrorDescripcion = "No ejecuto el procedimiento"
        }

        rsBus.Close()

        jsonRespuesta = '{'
                  + '"Error": {'
                      + '"Numero": "' + intErrorNumero + '"'
                    + ', "Descripcion": "' + strErrorDescripcion + '"'
                + '}'
                + ', "Registros": {'
                      + '"IMEI": "' + strIMEI + '"'
                    + ', "RFID": "' + strRFID + '"'
                    + ', "AntIMEI": "' + strAntIMEI + '"'
                    + ', "AntRFID": "' + strAntRFID + '"'
                    + ', "Usuario": "' + strUsuario + '"'
                + '}'
            + '}'

        Response.Write(jsonRespuesta)

    } break;

    /* Actualizacion de RFID */
    case 3210: {

        var rqStrIMEI = Parametro("IMEI", "")
        var rqStrRFID = Parametro("RFID", "")
        var rqIntIDUsuario = Parametro("IDUsuario", -1)

        var intErrorNumero = 0
        var strErrorDescripcion = ""

        var strIMEI = ""
        var strRFID = ""
        var strAntIMEI = ""
        var strAntRFID = ""
        var strUsuario = ""

        var jsonRespuesta = '{}'

        var sqlRFID = "EXEC SPR_Asignacion_RFID "
              + "@Opcion = 3210 "
            + ", @IMEI = " + ( ( rqStrIMEI.length > 0) ? "'" + rqStrIMEI + "'" : "NULL" ) + " "
            + ", @RFID = " + ( ( rqStrRFID.length > 0) ? "'" + rqStrRFID + "'" : "NULL" ) + " "
            + ", @IDUsuario = " + ( ( rqIntIDUsuario > -1 ) ? rqIntIDUsuario : "NULL" ) + " "

        var rsRFID = AbreTabla(sqlRFID, 1, cxnTipo)

        try {

            if( !(rsRFID.EOF) ){
                intErrorNumero = rsRFID("ErrorNumero").Value
                strErrorDescripcion = rsRFID("ErrorDescripcion").Value

                strIMEI = rsRFID("IMEI").Value
                strRFID = rsRFID("RFID").Value
                strAntIMEI = rsRFID("AntIMEI").Value
                strAntRFID = rsRFID("AntRFID").Value
                strUsuario = rsRFID("Usuario").Value
            } else {
                intErrorNumero = 1
                strErrorDescripcion = "No ejecuto la opcion del procedimiento"
            }

        } catch(e) {
            intErrorNumero = 1
            strErrorDescripcion = "No ejecuto el procedimiento"
        }

        rsRFID.Close()

        jsonRespuesta = '{'
                  + '"Error": {'
                      + '"Numero": "' + intErrorNumero + '"'
                    + ', "Descripcion": "' + strErrorDescripcion + '"'
                + '}'
                + ', "Registros": {'
                       + '"IMEI": "' + strIMEI + '"'
                    + ', "RFID": "' + strRFID + '"'
                    + ', "AntIMEI": "' + strAntIMEI + '"'
                    + ', "AntRFID": "' + strAntRFID + '"'
                    + ', "Usuario": "' + strUsuario + '"'
                + '}'
            + '}'

        Response.Write(jsonRespuesta)

    } break;

    /* Borrado de RFID */
    case 3211: {

        var rqStrIMEI = Parametro("IMEI", "")
        var rqIntIDUsuario = Parametro("IDUsuario", -1)

        var intErrorNumero = 0
        var strErrorDescripcion = ""

        var strIMEI = ""
        var strRFID = ""
        var strAntIMEI = ""
        var strAntRFID = ""
        var strUsuario = ""

        var jsonRespuesta = '{}'

        var sqlBor = "EXEC SPR_Asignacion_RFID "
              + "@Opcion = 3211 "
            + ", @IMEI = " + ( ( rqStrIMEI.length > 0) ? "'" + rqStrIMEI + "'" : "NULL" ) + " "
            + ", @IDUsuario = " + ( ( rqIntIDUsuario > -1 ) ? rqIntIDUsuario : "NULL" ) + " "

        var rsBor = AbreTabla(sqlBor, 1, cxnTipo)

        try {

            if( !(rsBor.EOF) ){
                intErrorNumero = rsBor("ErrorNumero").Value
                strErrorDescripcion = rsBor("ErrorDescripcion").Value

                strIMEI = rsBor("IMEI").Value
                strRFID = rsBor("RFID").Value
                strAntIMEI = rsBor("AntIMEI").Value
                strAntRFID = rsBor("AntRFID").Value
                strUsuario = rsBor("Usuario").Value
            } else {
                intErrorNumero = 1
                strErrorDescripcion = "No ejecuto la opcion del procedimiento"
            }

        } catch(e) {
            intErrorNumero = 1
            strErrorDescripcion = "No ejecuto el procedimiento"
        }

        rsBor.Close()

        jsonRespuesta = '{'
                  + '"Error": {'
                      + '"Numero": "' + intErrorNumero + '"'
                    + ', "Descripcion": "' + strErrorDescripcion + '"'
                + '}'
                + ', "Registros": {'
                       + '"IMEI": "' + strIMEI + '"'
                    + ', "RFID": "' + strRFID + '"'
                    + ', "AntIMEI": "' + strAntIMEI + '"'
                    + ', "AntRFID": "' + strAntRFID + '"'
                    + ', "Usuario": "' + strUsuario + '"'
                + '}'
            + '}'

        Response.Write(jsonRespuesta)

    } break;
	    case 3212: {
        var rqStrIMEI = Parametro("IMEI", "")
        var rqStrRFID = Parametro("RFID", "")

		var Existencia = -1
		 Existencia = BuscaSoloUnDato("Inv_ID","Inventario","Inv_RFID = '"+rqStrRFID+"'",-1,0) 
	
			if(Existencia >-1){
			sSQL = "UPDATE Inventario SET Inv_Serie ='"+rqStrIMEI+"',  Inv_IMEI1='"+rqStrIMEI+"' WHERE Inv_RFID = '"+rqStrRFID + "'"
			Ejecuta(sSQL, 0)
			result = 1
			message = "Serie "+rqStrIMEI+" vinculada al RFID correctamente"
			}else{
			result = 0
			message = "El RFID ingresado no existe"
			}
        jsonRespuesta = '{"result":'+result+',"message":"'+message+'"}'
      
	    Response.Write(jsonRespuesta)

    } break;
}
%>