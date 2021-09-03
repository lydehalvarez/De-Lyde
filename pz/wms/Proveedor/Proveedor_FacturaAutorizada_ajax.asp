<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2021-MAR-31 Facturas Autorizadas por solicitar pago: Creación de archivo

var cxnTipo = 0
var rqStrTarea = Parametro("Tarea", -1)

switch( parseInt( rqStrTarea ) ){

    //Inserción de Proveedor Pago y Documentos paro Embarques
    case 2000: {

        var rqIntProv_ID = Parametro("Prov_ID", -1)
        var rqStrDocs = Parametro("Documentos", "")

        var arrDocs = rqStrDocs.split(",");

        var intTotDocIns = 0

        var TipoTA = 1
        var TipoOV = 2

        var intErrorNumero = 0;
        var strErrorDescripcion = "";

        var jsonRespuesta = '{}'

        var intPag_ID = -1

        var intTA_ID = -1
        var intOV_ID = -1

        var intErrorNumeroGuia = 0
        var strErrorDescripcionGuia = ""

        var jsonRespuestaGuia = ''

        var arrDoc = [];

        var sqlProPago = "EXEC SPR_Proveedor_Pago "
              + "@Opcion = 2000 "
            + ", @Prov_ID = " + ( (rqIntProv_ID > -1) ? rqIntProv_ID : "NULL" ) + " "

        //Response.Write(sqlProPago)

        var rsProPago = AbreTabla(sqlProPago, 1, cxnTipo)

        try{
            if( !(rsProPago.EOF) ){
                intErrorNumero = rsProPago("ErrorNumero").Value
                strErrorDescripcion = rsProPago("ErrorDescripcion").Value
                intPag_ID = rsProPago("Pag_ID").Value
            } else {
                intErrorNumero = 1
                strErrorDescripcion = "Ne se ejcuto la Insercion del Proveedor Pago"
            }
        } catch(e){
            intErrorNumero = 1
            strErrorDescripcion = "Ne se ejcuto el procedimiento de Insercion del Proveedor Pago"
        }

        //Continua con la insercion de los registros del documento
        if( intErrorNumero == 0 ){

            for( var i = 0; i < arrDocs.length; i++){
                
                if( i > 0){
                    jsonRespuestaGuia += ',' 
                }

                intErrorNumeroGuia = 0
                strErrorDescripcionGuia = ""

                var strGuia = arrDocs[i];

                var sqlProPagoGuia = "EXEC SPR_Proveedor_Guia "
                      + "@Opcion = 3110 "
                    + ", @Prov_ID = " + ( (rqIntProv_ID > -1) ? rqIntProv_ID : "NULL" ) + " "
                    + ", @ProG_NumeroGuia = " + ( (strGuia.length > 0) ? "'" + strGuia + "'" : "NULL" ) + " "
                    + ", @Pag_ID = " + ( (intPag_ID > -1) ? intPag_ID : "NULL" ) + " "
                    + ", @ProG_EstatusPagoCG89 = 1 /* Solicita Pago */ "

                //Response.Write(sqlProPagoGuia + "<br>") 
                    
                var rsProPagoGuia = AbreTabla(sqlProPagoGuia, 1, cxnTipo)

                try {

                    if( !(rsProPagoGuia.EOF) ){
                        intErrorNumero = rsProPagoGuia("ErrorNumero").Value
                        strErrorDescripcion = rsProPagoGuia("ErrorDescripcion").Value
                    } else {
                        intErrorNumero = 1
                        strErrorDescripcion = "No se inserto el documento del proveedor pago embarque"
                    }

                } catch(e) {
                    intErrorNumero = 1
                    strErrorDescripcion = "No se ejecuto el procedimiento de insercion del proveedor pago embarque"
                }

                //rsProPagoGuia.Close()

                if( intErrorNumero == 1 ){
                    intTotDocIns++;                    
                }

                jsonRespuestaGuia += '{'
                          + '"Error": {'
                              + '"Numero": "' + intErrorNumeroGuia + '"'
                            + ', "Descripcion": "' + strErrorDescripcionGuia + '"'
                        + '}'
                        + ', "Registro": {'
                              + '"Prov_ID": "' + rqIntProv_ID + '"'
                            + ', "Pag_ID": "' + intPag_ID + '"'
                            + ', "Guia": "' + strGuia + '"'
                        + '}'
                    + '}'
            }

        }

        jsonRespuesta = '{'
                  + '"Error": {'
                      + '"Numero": "' + intErrorNumero + '"'
                    + ', "Descripcion": "' + strErrorDescripcion + '"'
                + '}'
                + ', "Registro": {'
                      + '"Prov_ID": "' + rqIntProv_ID + '"'
                    + ', "Pag_ID": "' + intPag_ID + '"'
                    + ', "Documentos": [' + jsonRespuestaGuia + ']'
                + '}'
            +'}'

        Response.Write(jsonRespuesta)

    } break;
}
%>