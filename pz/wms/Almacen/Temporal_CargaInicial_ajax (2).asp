<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2020-OCT-06 Surtido: Creación de archivo

var rqStrTarea = Parametro("Tarea", -1)

switch( parseInt( rqStrTarea ) ){

    //Cambio de ubicacion
    case 1: {

        var rqIntUbi_ID = Parametro("Ubi_ID", -1)
        var rqStrLpn = Parametro("LPN", "")
        var rqIntIDUSuario = Parametro("IDUsuario", -1)

        var jsonRespuesta = '{}'

        var intErrorNumero = 0
        var strErrorDescripcion = ""

        //Actualización de la ubicacion de los articulos que tienen en inventario el LPN solicitado

        var sqlLpnCam = "EXEC SPR_Temporal_CargaInicial "
              + "@Opcion = 1 "
            + ", @PT_LPN = '" + rqStrLpn + "' "
            + ", @Ubi_ID = " + rqIntUbi_ID + " "
            + ", @IDUsuario = " + rqIntIDUSuario + " "

        var rsLpnCam = AbreTabla(sqlLpnCam, 1, 0)

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

    //Poner en por buscar
    case 2:{

        var rqIntPT_ID = Parametro("PT_ID", -1)
        
        var intErrorNumero = 0
        var strErrorDescripcion = ""

        var jsonRespuesta = '{}'

        var sqlPorBus = "EXEC SPR_Pallet "
              + "@Opcion = 3000 "
            + ", @PT_ID = " + rqIntPT_ID  
            + ", @PT_PorBuscar = 1 "

        var rsPorBus = AbreTabla(sqlPorBus, 1, 0)

        if( !(rsPorBus.EOF) ){
            intErrorNumero = rsPorBus("ErrorNumero").Value
            strErrorDescripcion = rsPorBus("ErrorDescripcion").Value
        } else {
            intErrorNumero = 1
            strErrorDescripcion = "No se actualizo el pallet"
        }

        rsPorBus.close()

        jsonRespuesta = '{'
                + '"Error": {'
                    + '"Numero": "' + intErrorNumero + '"'
                    + ', "Descripcion": "' + strErrorDescripcion + '"'
                +'}'
            + '}'

        Response.Write(jsonRespuesta)

    } break;

     //Listar Los lpns Encontrados
    case 3: {

        var rqIntUbi_ID = Parametro("Ubi_ID", 0)
        var Ubi_Nombre = Parametro("Ubi_Nombre", "")
        
        if(Ubi_Nombre == ""){
            var sCondicion = "Ubi_ID = " + rqIntUbi_ID
            Ubi_Nombre = BuscaSoloUnDato("Ubi_Nombre","Ubicacion",sCondicion,"",0)  
        }

        var sqlUbi = "EXEC SPR_Pallet "
                   + "@Opcion = 1000 "
                   + ", @PT_PorBuscar = 0 "
                   + ", @Ubi_ID = " + ( (rqIntUbi_ID > -1 ) ? rqIntUbi_ID : "NULL" ) 
 
        var rsUbi = AbreTabla(sqlUbi, 1, 0)
%>
    <div class="ibox">
        <div class="ibox-title">
            <h5>LPNs en la Ubicaci&oacute;n <%=Ubi_Nombre%></h5>
        </div>
        <div class="ibox-content">
             <table class="table table-striped issue-tracker">
                <thead>
                    <tr>
                        <th>#</th>  
                        <th>LPN</th>
                        <th>Cantidad</th>
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
                                <%= rsUbi("PT_LPN").Value %>    
                            </a>
                            <small>
                                (<%= rsUbi("Pro_SKU").Value %>) - <%= rsUbi("Pro_Nombre").Value %>
                            </small>
                        </td>
                        <td><%= rsUbi("PT_Cantidad_Actual").Value %></td>
                        <td>
                            <a class="btn btn-danger btn-sm" title="Quitar LPN de la ubicaci&oacute;n"
                                 onclick='Temporal.LPNPorBuscarPoner({PT_ID: <%= rsUbi("PT_ID").Value %>})'>
                                    <i class="fa fa-question-circle-o"></i> Quitar
                            </a>
                        </td>
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

    //Listado de Pallets Extraviados
    case 4:{

        var sqlPTExt = "EXEC SPR_Pallet "
                     + "@Opcion = 1000 "
                     + ", @PT_PorBuscar = 1 "

        rsPTExt = AbreTabla(sqlPTExt, 1, 0)
%>
    <div class="ibox">
        <div class="ibox-title">
            <h5>LPN Por Buscar</h5>
        </div>
        <div class="ibox-content">
            <table class="table table-striped issue-tracker">
                <thead>
                    <tr>
                        <th>#</th>  
                        <th>LPN</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>
<%
    if( !(rsPTExt.EOF) ){
        var i = 0
        while( !(rsPTExt.EOF) ){
%>
                    <tr>
                        <td><%= ++i %></td>
                        <td class="issue-info">
                            <a>
                                <%= rsPTExt("PT_LPN") %>
                            </a>
                            <small><%= rsPTExt("Pro_SKU") %> - <%= rsPTExt("Pro_Nombre") %></small>
                        </td>
                        <td>
                            <a class="btn btn-success btn-xs" onclick='Temporal.LPNSeleccionar({LPN: "<%= rsPTExt("PT_LPN") %>"});' title="Seleccionar LPN">
                                <i class="fa fa-files-o"></i>
                            </a>
                        </td>
                    </tr>
<%
            rsPTExt.MoveNext()
        }
    } else {
%>
                    <tr>
                        <td colspan="4">
                            <i class="fa fa-exclamation-circle"></i> No hay Registros
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
    rsPTExt.close()

    } break;    
}
%>
