<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2020-OCT-06 Surtido: Creación de archivo

var cxnTipo = 0
var rqStrTarea = Parametro("Tarea", -1)

switch( parseInt( rqStrTarea ) ){

     //Listar Los lpns Encontrados
    case 1: {

        var rqIntUbi_ID = Parametro("Ubi_ID", 0)

        var sqlUbi = "EXEC SPR_Pallet "
              + "@Opcion = 1000 "
            + ", @Ubi_ID = " + ( (rqIntUbi_ID > -1 ) ? rqIntUbi_ID : "NULL" ) + " "

        var rsUbi = AbreTabla(sqlUbi, 1, cxnTipo)
%>
    <div class="ibox">
        <div class="ibox-title">
            <h5>LPNs en la Ubicaci&oacute;n</h5>
        </div>
        <div class="ibox-content">
             <table class="table table-striped issue-tracker">
                <thead>
                    <tr>
                        <th>#</th>  
                        <th>LPN</th>
                        <th>Cantidad</th>
                    </tr>
                </thead>
                <tbody>
<%  
        if( !(rsUbi.EOF) ){
            
            var i = 0
            while( !(rsUbi.EOF) ){
%>
                    <tr>
                        <td><%= ++i %></td>
                        <td class="issue-info">
                            <a href="#">
                                <%= rsUbi("PT_LPN").Value %>    
                            </a>
                            <small>
                                (<%= rsUbi("Pro_SKU").Value %>) - <%= rsUbi("Pro_Nombre").Value %>
                            </small>
                        </td>
                        <td><%= rsUbi("PT_Cantidad_Actual").Value %></td>
                    </tr>
<%
                rsUbi.MoveNext()
            }
        } else {
%>
                    <tr>
                        <td colspan="3">
                            <i class="fa fa-exclamation-circle fa-lg"></i> Ubicacion Vacia
                        </td>
                    </tr>               
<%
        }
%>
                </tbody>
            </table>
        </div>
    </div>
<%
    } break;

     //Listar las Ubicaciones donde se encuantran
    case 2: {

        var rqStrLPN = Parametro("LPN", "")

        var sqlUbi = "EXEC SPR_Pallet "
              + "@Opcion = 1000 "
            + ", @PT_LPN = " + ( (rqStrLPN.length > 0 ) ? "'" + rqStrLPN + "'" : "NULL" ) + " "

        var rsUbi = AbreTabla(sqlUbi, 1, cxnTipo)
%>
    <div class="ibox">
        <div class="ibox-title">
            <h5>Ubicaciones Contenidas</h5>
        </div>
        <div class="ibox-content">
             <table class="table table-striped issue-tracker">
                <thead>
                    <tr>
                        <th>#</th>  
                        <th>Ubicacion</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>
<%  
        if( !(rsUbi.EOF) ){
            
            var i = 0
            while( !(rsUbi.EOF) ){
%>
                    <tr>
                        <td><%= ++i %></td>
                        <td class="issue-info">
                            <a href="#">
                                <%= rsUbi("Ubi_Nombre").Value %>    
                            </a>
                        </td>
                        <td>
                            <a href="#" class="btn btn-info btn-xs" title="Seleccionar Ubicaci&oacute;n"
                             onclick='Temporal.UbicacionPalletSeleccionar({Ubi_ID: <%= rsUbi("Ubi_ID").Value %>, Ubi_Nombre: "<%= rsUbi("Ubi_Nombre").Value %>"})'>
                                <i class="fa fa-check-square-o"></i>
                            </a>
                        </td>
                    </tr>
<%
                rsUbi.MoveNext()
            }
        } else {
%>
                    <tr>
                        <td colspan="2">
                            <i class="fa fa-exclamation-circle fa-lg"></i> Sin Ubicacion
                        </td>
                    </tr>               
<%
        }
%>
                </tbody>
            </table>
        </div>
    </div>
<%
    } break;

    //Cambio de ubicacion
    case 3: {

        var rqIntUbi_ID = Parametro("Ubi_ID", -1)
        var rqStrLpn = Parametro("LPN", "")
        var rqIntIDUSuario = Parametro("IDUsuario", -1)

        var jsonRespuesta = '{}'

        var intErrorNumero = 0
        var strErrorDescripcion = ""

        //Actualización de la ubicacion de los articulos que tienen en inventario el LPN solicitado

        var sqlLpnCam = "EXEC SPR_Temporal_Mover_LPN "
              + "@Opcion = 1 "
            + ", @PT_LPN = '" + rqStrLpn + "' "
            + ", @Ubi_ID = " + rqIntUbi_ID + " "
            + ", @IDUsuario = " + rqIntIDUSuario + " "

        var rsLpnCam = AbreTabla(sqlLpnCam, 1, cxnTipo)

        if( !(rsLpnCam.EOF) ){
            intErrorNumero = rsLpnCam("ErrorNumero").Value
            strErrorDescripcion = rsLpnCam("ErrorDescripcion").Value
        } else {
            intErrorNumero = 0
            strErrorDescripcion = "No se Realiz&oacute; el cambio"
        }
        
        rsLpnCam.Close()

        jsonRespuesta = '{'
                + '"Error": {'
                    + '"Numero": "' + intErrorNumero + '" '
                    + ', "Descripcion": "' + strErrorDescripcion + '" '
                +'}'
            +'}'

        Response.Write(jsonRespuesta)

    } break;

}
%>
