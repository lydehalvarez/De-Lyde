<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2020-ENE-05 Carga de Archivos Masiva: Creación de archivo

var cxnTipo = 0
var rqStrTarea = Parametro("Tarea", -1)

switch( parseInt( rqStrTarea ) ){

    //Buscar folio de Registro
    case 1100: {

        var rqIntProv_ID = Parametro("Prov_ID", -1)
        var rqStrFolio = Parametro("Folio", "")

        var intErrorNumero = 0
        var strErrorDescripcion = ""

        var strDestino = ""
        var strTransportista = ""
        var dateFechaRegistro = ""

        var jsonRespuesta = '{}'

        var sqlBusFol = "EXEC SPR_CargaArchivosMasivo "
              + "@Opcion = 1100 "
            + ", @Prov_ID = " + ( (rqIntProv_ID > -1) ? rqIntProv_ID : "NULL" ) + " "
            + ", @Folio = " + ( (rqStrFolio.length > 0 ) ? "'" + rqStrFolio + "'" : "NULL" ) + " "

        var rsBusFol = AbreTabla(sqlBusFol, 1, cxnTipo)

        if( !(rsBusFol.EOF) ){

            intErrorNumero = 0
            strErrorDescripcion = "Folio Encontrado"
            strDestino = rsBusFol("Destino").Value
            strTransportista = rsBusFol("Transportista").Value
            dateFechaRegistro = rsBusFol("FechaRegistro").Value

        } else {

            intErrorNumero = 1
            strErrorDescripcion = "Folio NO encontrado"

        }

        rsBusFol.Close()

        jsonRespuesta = '{'
                  + '"Error": {'
                      + '"Numero": "' + intErrorNumero + '"'
                    + ', "Descripcion": "' + strErrorDescripcion + '"'
                + '}'
                + ', "Registro": {'
                      + '"Destino": "' + strDestino + '"'
                    + ', "Transportista": "' + strTransportista + '"'
                    + ', "FechaRegistro": "' + dateFechaRegistro + '"'
                + '}'
            + '}'

        Response.Write(jsonRespuesta)

    } break;

    //Registro de Archivos 
    case 2000:{

        var rqIntProv_ID = Parametro("Prov_ID", -1)
        var rqStrDoc_Nombre = Parametro("ArchivoNombre", "")
        var rqIntIDUsuario = Parametro("IDUsuario", -1)

        var intErrorNumero = 0
        var strErrorDescripcion = 0
        var intDoc_ID = -1
        var strDoc_Nombre = ""
        var strDoc_NombreArchivo = ""
        var dateDocs_FechaRegistro = ""
        var intEst_ID = -1
        var strEst_Nombre = ""
        var intEsRelacionado = 0
        var strDoc_Folio = ""
        var strTransportista = ""
        var strGuia = ""

        var jsonRespuesta = '{}'

        var sqlArc = "EXEC SPR_CargaArchivosMasivo "
              + "@Opcion = 2000 "
            + ", @Prov_ID = " + ((rqIntProv_ID > -1) ? rqIntProv_ID : "NULL" ) + " "
            + ", @Doc_Nombre = " + ( (rqStrDoc_Nombre.length > 0) ? "'" + rqStrDoc_Nombre + "'" : "NULL" ) + " "
            + ", @IDUsuario = " + ( (rqIntIDUsuario > -1) ? rqIntIDUsuario : "NULL" ) + " "

        var rsArc = AbreTabla(sqlArc, 1, cxnTipo)

        if( !(rsArc.EOF) ){
            intErrorNumero = rsArc("ErrorNumero").Value
            strErrorDescripcion = rsArc("ErrorDescripcion").Value
            intDoc_ID = rsArc("Doc_ID").Value
            strDoc_Nombre = rsArc("Doc_Nombre").Value
            strDoc_NombreArchivo = rsArc("Doc_NombreArchivo").Value
            dateDocs_FechaRegistro = rsArc("Docs_FechaRegistro").Value
            intEst_ID = rsArc("Est_ID").Value
            strEst_Nombre = rsArc("Est_Nombre").Value
            intEsRelacionado = rsArc("EsRelacionado").Value
            strDoc_Folio = rsArc("Doc_Folio").Value
            strTransportista = rsArc("Transportista").Value
            strGuia = rsArc("Guia").Value
            
        } else {
            intErrorNumero = 1
            strErrorDescripcion = "No se ejecuto la opcion del procedimiento"
        }

        rsArc.Close()

        jsonRespuesta = '{'
                  + '"Error": {'
                      + '"Numero": "' + intErrorNumero + '"'
                    + ', "Descripcion": "' + strErrorDescripcion + '"'
                +'}'
                + ', "Registro": {'
                      + '"Doc_ID": "' + intDoc_ID + '"'
                    + ', "Doc_Nombre": "' + strDoc_Nombre + '"'
                    + ', "Doc_NombreArchivo": "' + strDoc_NombreArchivo + '"'
                    + ', "Docs_FechaRegistro": "' + dateDocs_FechaRegistro + '"'
                    + ', "Est_ID": "' + intEst_ID + '"'
                    + ', "Est_Nombre": "' + strEst_Nombre + '"'
                    + ', "EsRelacionado": "' + intEsRelacionado + '"'
                    + ', "Doc_Folio": "' + strDoc_Folio + '"'
                    + ', "Transportista": "' + strTransportista + '"'
                    + ', "Guia": "' + strGuia + '"'
                + '}'
            + '}'

        Response.Write(jsonRespuesta)

    } break;

    //Cambio de Relacion de achivos
    case 3100: {

        var rqStrFolio = Parametro("Folio", "")
        var rqStrDoc_IDs = Parametro("Doc_IDs", "")
        var rqIntIDUsuario = Parametro("IDUsuario", -1)
        var rqIntProv_ID = Parametro("Prov_ID", -1)

        var intErrorNumero = 0
        var strErrorDescripcion = ""

        var jsonRespuesta = '{}'

        var sqlArcRel = "EXEC SPR_CargaArchivosMasivo "
              + "@Opcion = 3100 "
            + ", @Folio = " + ( (rqStrFolio.length > 0) ? "'" + rqStrFolio + "'" : "NULL" ) + " "
            + ", @Doc_IDs = " + ( (rqStrDoc_IDs.length > 0 ) ? "'" + rqStrDoc_IDs + "'" : "NULL" ) +  " "
            + ", @Prov_ID = " + ( (rqIntProv_ID > -1) ? rqIntProv_ID : "NULL" ) +  " "
            + ", @IDUsuario = " + ( (rqIntIDUsuario > -1) ? rqIntIDUsuario : "NULL" ) + " "

        var rsArcRel = AbreTabla(sqlArcRel, 1, cxnTipo)

        if( !(rsArcRel.EOF) ){
            intErrorNumero = rsArcRel("ErrorNumero").Value
            strErrorDescripcion = rsArcRel("ErrorDescripcion").Value
        } else {
            intErrorNumero = 1
            strErrorDescripcion = "No se ejecuto la opcion del procedimiento"
        }

        rsArcRel.close()

        jsonRespuesta = '{'
            + '"Error": {'
                  + '"Numero": "' + intErrorNumero + '"'
                + ', "Descripcion": "' + strErrorDescripcion + '"'
            + '}'
        + '}'

        Response.Write(jsonRespuesta)

    } break;

    case 3110: {

        var rqIntDoc_ID = Parametro("Doc_ID", -1)
        var rqIDUsuario = Parametro("IDUsuario", -1)

        var intErrorNumero = 0
        var strErrorDescripcion = ""

        var intDoc_ID = -1
        var intEst_ID = -1
        var strEst_Nombre = ""
        var strDoc_Folio = ""
        var intEsRelacionado = 0

        var strTransportista = ""
        var strGuia = ""

        var jsonRespuesta = '{}'

        var sqlCar = "EXEC SPR_CargaArchivosMasivo "
              + "@Opcion = 3110 "
            + ", @Doc_ID = " + ( ( rqIntDoc_ID > -1 ) ? rqIntDoc_ID : "NULL" )+ " "
            + ", @Docs_Cargado = 1 "
            + ", @IDUsuario = " + ( (rqIntIDUsuario > -1) ? rqIntIDUsuario : "NULL" ) + " "

        var rsCar = AbreTabla(sqlCar, 1, cxnTipo)

        if( !(rsCar.EOF) ){
            intErrorNumero = rsCar("ErrorNumero").Value
            strErrorDescripcion = rsCar("ErrorDescripcion").Value
            intDoc_ID = rsCar("Doc_ID").Value
            intEst_ID = rsCar("Est_ID").Value
            strEst_Nombre = rsCar("Est_Nombre").Value
            strDoc_Folio = rsCar("Doc_Folio").Value
            intEsRelacionado = rsCar("EsRelacionado").Value
            strTransportista = rsCar("Transportista").Value
            strGuia = rsCar("Guia").Value
        } else {
            intErrorNumero = 1
            strErrorDescripcion = "No se ejecuto la opcion del procedimiento"
        }

        rsCar.Close()

        jsonRespuesta = '{'
                  + '"Error": {'
                      + '"Numero": "' + intErrorNumero + '"'
                    + ', "Descripcion": "' + strErrorDescripcion + '"'
                +'}'
                + ', "Registro": {'
                      + '"Doc_ID": "' + intDoc_ID + '"'
                    + ', "Est_ID": "' + intEst_ID + '"'
                    + ', "Est_Nombre": "' + strEst_Nombre + '"'
                    + ', "Doc_Folio": "' + strDoc_Folio + '"'
                    + ', "EsRelacionado": "' + intEsRelacionado + '"'
                    + ', "Transportista": "' + strTransportista + '"'
                    + ', "Guia": "' + strGuia + '"'
                + '}'
            + '}'

        Response.Write(jsonRespuesta)

    } break;

}
%> 