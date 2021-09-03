<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2021-AGO-13 Proveedor - Limite Monto Carga: Creación de archivo

var cxnTipo = 0
var rqStrTarea = Parametro("Tarea", -1)

switch( parseInt( rqStrTarea ) ){

    //Actualizacion de Montos del vehículo Foranie y local
    case 3910: {

        var rqIntProv_ID = Parametro("Prov_ID", -1);
        var rqDblProv_LimiteMontoLocal = Parametro("Prov_LimiteMontoLocal", 0.0);
        var rqDblProv_LimiteMontoForaneo = Parametro("Prov_LimiteMontoForaneo", 0.0);
        var rqIntIDUsuario = Parametro("IDUsuario", -1);

        var intErrorNumero = 0;
        var strErrorDescripcion = "";

        var jsonRespuesta = '{}'

        var sqlVehMon = "EXEC SPR_Proveedor "
              + "@Opcion = 3910 "
            + ", @Prov_ID = " + ( (rqIntProv_ID > -1) ? rqIntProv_ID : "NULL" ) + " "
            + ", @Prov_LimiteMontoLocal = " + ( (rqDblProv_LimiteMontoLocal > -1) ? rqDblProv_LimiteMontoLocal : "NULL" ) + " "
            + ", @Prov_LimiteMontoForaneo = " + ( (rqDblProv_LimiteMontoForaneo > -1) ? rqDblProv_LimiteMontoForaneo : "NULL" ) + " "
            + ", @IDUsuario = " + rqIntIDUsuario + " "
            
        var rsVehMon = AbreTabla(sqlVehMon, 1,cxnTipo)

        try{
            if( !(rsVehMon.EOF) ){
                intErrorNumero = rsVehMon("ErrorNumero").Value;
                strErrorDescripcion = rsVehMon("ErrorDescripcion").Value;
            }
        } catch(e){
            intErrorNumero = 1;
            strErrorDescripcion = "Error No se ejecuta el procedimiento";
        };

        rsVehMon.Close();

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