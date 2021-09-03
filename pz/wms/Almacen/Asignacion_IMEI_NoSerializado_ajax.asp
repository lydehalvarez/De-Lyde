<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2021-MAR-31 Asignacion de IMEI(No Serializado): Creación de archivo
// HA ID: 2 2021-MAY-05 Ajuste de Reglas de negocio.

var cxnTipo = 0

var rqIntTarea = Parametro("Tarea", -1)

switch( parseInt(rqIntTarea) ){

    //Disponibilidad de Asignacion por SKU
    case 1200: {

        var rqStrSKU = Parametro("SKU", "")

        var intTotalDisponible = 0
        var intErrorNumero = 0
        var strErrorDescripcion = ""

        var jsonRespuesta = '{}'

        var sqlDis = "EXEC SPR_Asignacion_IMEI_NoSerializados "
              + "@Opcion = 1200 "
            + ", @SKU = " + ( ( rqStrSKU.length > 0 ) ? "'" + rqStrSKU + "'" : "NULL" ) + " "

        var rsDis = AbreTabla(sqlDis, 1, cxnTipo)

        if( !(rsDis.EOF) ){
            intTotalDisponible = rsDis("TotalDisponible").Value
        } else {
            intErrorNumero = 1
            strErrorDescripcion = "No hay registro"
        }

        rsDis.Close()

        jsonRespuesta = '{'
                  + '"Error": {'
                      + '"Numero": "' + intErrorNumero + '"'
                    + ', "Descripcion": "' + strErrorDescripcion + '"'
                + '}'
                + ', "Registro" : {'
                    + '"TotalDisponible": "' + intTotalDisponible + '"'
                + '}'
            + '}'

        Response.Write(jsonRespuesta)

    } break;

    //Actualizar el IMEI
    case 3210: {

        var rqStrSKU = Parametro("SKU", "")
        var rqstrIMEI = Parametro("IMEI", "")
        var rqIntIDUsuario = Parametro("IDUsuario", -1)

        var intTotalDisponible = 0
        var intInv_ID = -1
        var strIMEI = "";
        var strSKU = "";

        var intErrorNumero = 0
        var strErrorDescripcion = ""
        
        var jsonRespuesta = '{}'

        var sqlIMEIAct = "EXEC SPR_Asignacion_IMEI_NoSerializados "
              + "@Opcion = 3210 "
            + ", @SKU = " + ( ( rqStrSKU.length > 0 ) ? "'" + rqStrSKU + "'" : "NULL" ) +  " " 
            + ", @IMEI = " + ( ( rqstrIMEI.length > 0 ) ? "'" + rqstrIMEI + "'" : "NULL" ) +  " " 
            + ", @IDUsuario = " + ( ( rqIntIDUsuario > 0 ) ? rqIntIDUsuario : "NULL" ) + " "
        
        var rsIMEIAct = AbreTabla(sqlIMEIAct, 1, cxnTipo)

        if( !(rsIMEIAct.EOF) ){
            intErrorNumero = rsIMEIAct("ErrorNumero").Value
            strErrorDescripcion = rsIMEIAct("ErrorDescripcion").Value
            intTotalDisponible = rsIMEIAct("TotalDisponible").Value
            intInv_ID = rsIMEIAct("INV_ID").Value
            strIMEI = rsIMEIAct("antIMEI").Value;
            strSKU = rsIMEIAct("antSKU").Value;

        } else {
            intErrorNumero = 1
            strErrorDescripcion = "No se ejecuto el proceso de actualizacion"
        }

        rsIMEIAct.Close()

        jsonRespuesta = '{'
                + '"Error": {'
                      + '"Numero": "' + intErrorNumero + '"'
                    + ', "Descripcion": "' + strErrorDescripcion + '"'
                + '}'
                + ', "Registro": {'
                      + '"TotalDisponible": "' + intTotalDisponible + '"'
                    + ', "Inv_ID": "' + intInv_ID + '"'
                    + ', "IMEI": "' + strIMEI + '"'
                    + ', "SKU": "' + strSKU + '"'
                +'}'
            + '}'

        Response.Write(jsonRespuesta)

    } break;

    //Borrado de IMEI del SKU
    case 3220: {

        var rqIntInv_ID = Parametro("INV_ID", -1)
        var rqIntIDUsuario = Parametro("IDUsuario", -1)

        var intTotalDisponible = 0
        var strIMEI = ""
        var strSKU = ""
        var strInv_ID = ""

        var intErrorNumero = 0
        var strErrorDescripcion = ""

        var jsonRespuesta = '{}'

        var sqlBor = "EXEC SPR_Asignacion_IMEI_NoSerializados "
              + "@Opcion = 3220 "
            + ", @Inv_ID = " + ( ( rqIntInv_ID > 0 ) ? rqIntInv_ID : "NULL" ) +  " " 
            + ", @IDUsuario = " + ( ( rqIntIDUsuario > 0 ) ? rqIntIDUsuario : "NULL" ) + " "

        var rsBor = AbreTabla(sqlBor, 1, cxnTipo)

        try {

            if( !(rsBor.EOF) ){
                intErrorNumero = rsBor("ErrorNumero").Value
                strErrorDescripcion = rsBor("ErrorDescripcion").Value

                intTotalDisponible = rsBor("TotalDisponible").Value
                strIMEI = rsBor("IMEI").Value
                strSKU = rsBor("SKU").Value
                strInv_ID = rsBor("Inv_ID").Value
            } else {
                intErrorNumero = 1
                strErrorDescripcion = "No ejecuto la opcion del procedimiento"
            }

        } catch(e) {
            intErrorNumero = 1
            strErrorDescripcion = "No ejecuto el procedimiento"
        }

        jsonRespuesta = '{'
                + '"Error": {'
                      + '"Numero": "' + intErrorNumero + '"'
                    + ', "Descripcion": "' + strErrorDescripcion + '"'
                + '}'
                + ', "Registro": {'
                      + '"TotalDisponible": "' + intTotalDisponible + '"'
                    + ', "Inv_ID": "' + strInv_ID + '"'
                    + ', "IMEI": "' + strIMEI + '"'
                    + ', "SKU": "' + strSKU + '"'
                +'}'
            + '}'

        Response.Write(jsonRespuesta)

    } break;

}
%>