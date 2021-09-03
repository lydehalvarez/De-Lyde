<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2021-JUN-03 Ubicacion Disponibilidad: Creación de archivo

var cxnTipo = 0
var rqStrTarea = Parametro("Tarea", -1)

switch( parseInt( rqStrTarea ) ){

    case 1300: {

        var rqIntAre_ID = Parametro("Area", -1)
        var rqIntRac_ID = Parametro("Rack", -1)
        var rqStrNombre = Parametro("Nombre", "")
        var rqIntTipoDisponibilidad = Parametro("TipoDisponibilidad", -1)

        var sqlUbiDis = "EXEC SPR_Ubicacion_Disponibilidad "
              + "@Opcion = 1100 "
            + ", @Are_ID = " + (( rqIntAre_ID > -1 ) ? rqIntAre_ID : "NULL" ) + " "
            + ", @Rac_ID = " + (( rqIntRac_ID > -1 ) ? rqIntRac_ID : "NULL" ) + " "
            + ", @Nombre = " + ( (rqStrNombre.length > 0) ? "'" + rqStrNombre + "'" : "NULL" ) + " "
            + ", @TipoDisponibilidad = " + (( rqIntTipoDisponibilidad > -1 ) ? rqIntTipoDisponibilidad : "NULL" ) + " "
    
        var rsUbiDis = AbreTabla(sqlUbiDis, 1, cxnTipo)
    
        var jsonRespuesta = '['

        var bolInicio = true

        while( !(rsUbiDis.EOF) ){
            
            jsonRespuesta += ( bolInicio ) ? '' : ','
            jsonRespuesta += '{'
                      + '"ID": "' + rsUbiDis("ID").Value + '"'
                    + ', "Area": "' + rsUbiDis("Are_Nombre").Value + '"'
                    + ', "Rack": "' + rsUbiDis("Rac_Nombre").Value + '"'
                    + ', "Ubicacion": "' + rsUbiDis("Ubi_Nombre").Value + '"'
                +'}'    

            bolInicio = false

            Response.Flush()
            rsUbiDis.MoveNext()
        }

        jsonRespuesta += ']'

        rsUbiDis.Close()

        Response.Write(jsonRespuesta)

    } break;

}
%>
