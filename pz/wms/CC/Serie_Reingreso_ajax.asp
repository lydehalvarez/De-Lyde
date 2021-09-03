<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2020-OCT-06 Surtido: Creación de archivo

var cxnTipo = 0
var rqStrTarea = Parametro("Tarea", -1)

switch( parseInt( rqStrTarea ) ){

    //Combo Producto
    case 101: {
        
        var rqIntCli_ID = Parametro("Cli_ID", -1)

        /*
        var sqlComPro = "SELECT * "
            + "FROM Producto Pro "
                + "LEFT JOIN Producto_Cliente PrC "
                    + "ON Pro.Pro_ID = PrC.Pro_ID "
            + "WHERE PRo_Habilitado = 1 "
                + " AND ISNULL(PrC.Cli_ID, -1) = ISNULL(" + ( ( rqIntCli_ID > -1 ) ? rqIntCli_ID : "NULL" ) + ", ISNULL(PrC.Cli_ID, -1)) "
            + "ORDER BY Pro_SKU ASC "
        */
        
        var sqlComPro = "SELECT * "
            + "FROM Producto Pro "
            + "WHERE PRo_Habilitado = 1 "
            + "ORDER BY Pro_SKU ASC "

        var rsComPro = AbreTabla(sqlComPro, 1, cxnTipo)
%>
        <option value="">TODOS</option>
<%
        while( !(rsComPro.EOF) ){
%>
        <option value='<%= rsComPro("Pro_ID").Value %>'>
            <%= rsComPro("Pro_SKU").Value %> - <%= rsComPro("Pro_Nombre").Value %>
        </option>
<%
            rsComPro.MoveNext()
        }

        rsComPro.Close()

    } break;

    //Combo Producto
    case 201: {

        var sqlComCli = "SELECT * "
            + "FROM Cliente "
            + "ORDER BY Cli_Nombre ASC"

        var rsComCli = AbreTabla(sqlComCli, 1, cxnTipo)
%>
        <option value="">TODOS</option>
<%
        while( !(rsComCli.EOF) ){
%>
        <option value='<%= rsComCli("Cli_ID").Value %>'>
            <%= rsComCli("Cli_Nombre").Value %>
        </option>
<%
            rsComCli.MoveNext()
        }

        rsComCli.Close()

    } break;

    //Identificada la Serie
    case 1000:{

        rqStrSerie = Parametro("Serie", "")

        var jsonRespuesta = '{}'

        var intInvR_ID = 0
        var intPro_ID = 0
        var intCli_ID = 0
        var intErrorNumero = 0
        var strErrorDescripcion = ""

        var sqlReiBus = "EXEC SPR_Reingreso "
              + "@Opcion = 1 "
            + ", @Serie = '" + rqStrSerie + "' "

        var rsReiBus = AbreTabla(sqlReiBus, 1, cxnTipo)

        if( !(rsReiBus.EOF) ){
            intErrorNumero = rsReiBus("ErrorNumero").Value
            strErrorDescripcion = rsReiBus("ErrorDescripcion").Value
            intInvR_ID = rsReiBus("InvR_ID").Value
            intPro_ID = rsReiBus("Pro_ID").Value
            intCli_ID = rsReiBus("Cli_ID").Value
        }

        rsReiBus.Close()

        jsonRespuesta = '{'
                + '"Error": {'
                    + '"Numero": "' + intErrorNumero + '"'
                    + ', "Descripcion": "' + strErrorDescripcion + '"'
                + '}'
                + ', "Datos": {'
                    + '"InvR_ID": "' + intInvR_ID + '"'
                    + ', "Pro_ID": "' + intPro_ID + '"'
                    + ', "Cli_ID": "' + intCli_ID + '"'
                +'}'
            +'}'

        Response.Write(jsonRespuesta)

    } break;

    //Ingresar a inventario y/o actualizar los numeros de Serie
    case 2000:{

        var rqStrIMEI1 = Parametro("IMEI1", "")
        var rqStrIMEI2 = Parametro("IMEI2", "")
        var rqIntPro_ID = Parametro("Pro_ID", -1)
        var rqIntCli_ID = Parametro("Cli_ID", -1)

        var intErrorNumero = 0
        var strErrorDescripcion = ""

        var jsonRespuesta = '{}'

        var sqlIngInv = "EXEC SPR_Reingreso "
              + "@Opcion = 2 "
            + ", @Cli_ID = " + rqIntCli_ID + " "
            + ", @Pro_ID = " + rqIntPro_ID + " "
            + ", @IMEI1 = '" + rqStrIMEI1 + "' "
            + ", @IMEI2 = '" + rqStrIMEI2 + "' "

        var rsIngInv = AbreTabla(sqlIngInv, 1, cxnTipo)

        if( !(rsIngInv.EOF) ){
            intErrorNumero = rsIngInv("ErrorNumero").Value
            strErrorDescripcion = rsIngInv("ErrorDescripcion").Value
        }

        rsIngInv.Close()

        jsonRespuesta = '{'
                + '"Error": {'
                    + '"Numero": "' + intErrorNumero + '"'
                    + ', "Descripcion": "' + strErrorDescripcion + '"'
                +'}'
            +'}'
        
        Response.Write(jsonRespuesta)

    } break;
}
%>