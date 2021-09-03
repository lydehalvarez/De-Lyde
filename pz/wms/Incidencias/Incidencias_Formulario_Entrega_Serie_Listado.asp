<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%

// HA ID: 1 Incidencia - Producto - Serie - Listado: Creacion de archivo.

var cxnTipo = 0

var rqIntTipo = Parametro("Tipo", -1);
var rqIntEnt_ID = Parametro("Ent_ID", -1);
var rqIntEnt_Pro_ID = Parametro("Ent_Pro_ID", -1);
var rqBolCambiarSerie = ( Parametro("CambiarSerie", 0) == 1 )
var rqIntIns_ID = Parametro("Ins_ID", -1)

var sqlEntSer = "";

var Tipo = {
      Transferencia: 1
    , OrdenVenta: 2
}

switch( parseInt(rqIntTipo) ){
    case Tipo.Transferencia:{

        sqlEntSer = "SELECT TAS.TA_ID AS Ent_ID " 
                + ", TAS.TAA_ID AS Ent_Pro_ID " 
                + ", TAS.TAS_ID AS Ent_Art_ID "
                + ", TAS.TAS_Serie AS Ent_Serie "
                + ", ISNULL(Inv.Inv_RFID, 'N/A') AS Ent_EPC "
                + ", ISNULL(Inv.Inv_ID, -1) AS Inv_ID "
                + ", TAS.Pro_ID AS Pro_ID "
                + ", IIF(InsSer.Inv_ID IS NOT NULL, 1, 0) AS InsSer_Seleccionado "
                + ", COALESCE(InvCam.Inv_Serie, InsSer.Inv_Serie_Cambio, '') AS InsSer_Serie_Cambiado "
            + "FROM TransferenciaAlmacen_Articulo_Picking TAS "
                + "INNER JOIN Inventario Inv "
                    + "ON TAS.Inv_ID = Inv.Inv_ID "
                + "LEFT JOIN Incidencia_SKU InsSer "
                    + "ON TAS.Inv_ID = InsSer.Inv_ID "
                    + "AND TAS.TA_ID = InsSer.TA_ID "
                    + "AND InsSer.Ins_ID = " + rqIntIns_ID + " "
                + "LEFT JOIN Inventario InvCam "
                    + "ON InsSer.Inv_ID_Cambio = InvCam.Inv_ID "
            + "WHERE TAS.TA_ID = " + rqIntEnt_ID + " "
                + "AND TAS.TAA_ID = " + rqIntEnt_Pro_ID + " "

    } break;
    case Tipo.OrdenVenta:{ 

        sqlEntSer = "SELECT OVP.OV_ID AS Ent_ID " 
                + ", OVP.OVA_ID AS Ent_Pro_ID "
                + ", OVP.OVP_ID AS Ent_Art_ID "
                + ", OVP.OVP_Serie AS Ent_Serie "
                + ", ISNULL(Inv.Inv_RFID, 'N/A') AS Ent_EPC "
                + ", ISNULL(Inv.Inv_ID, -1) AS Inv_ID "
                + ", OVA.Pro_ID AS Pro_ID "
                + ", IIF(InsSer.Inv_ID IS NOT NULL, 1, 0) AS InsSer_Seleccionado "
                + ", COALESCE(InvCam.Inv_Serie, InsSer.Inv_Serie_Cambio, '') AS InsSer_Serie_Cambiado "
            + "FROM Orden_Venta_Picking OVP "
                + "INNER JOIN Inventario Inv "
                    + "ON IVP.Inv_ID = Inv.Inv_ID "
                + "LEFT JOIN Incidencia_SKU InsSer "
                    + "ON OVP.Inv_ID = InsSer.Inv_ID "
                    + "AND OVP.OV_ID = InsSer.OV_ID "
                    + "AND InsSer.Ins_ID = " + rqIntIns_ID + " "
                + "LEFT JOIN Inventario InvCam "
                    + "ON InsSer.Inv_ID_Cambio = InvCam.Inv_ID "
            + "WHERE OVP.OV_ID = " + rqIntEnt_ID + " "
                + "AND OVP.OVA_ID = " + rqIntEnt_Pro_ID + " "

    } break;

}

var rsEntSer = AbreTabla(sqlEntSer, 1, cxnTipo)
%>
    <table class="table"  id="divInsSerLis">
        <thead>
            <tr>
                <th>

                </th>
                <th>Serie</th>
                <th>EPC</th>
<%
if( rqBolCambiarSerie ) {
%>
                <th></th>
                <th></th>
<%
}
%>
            </tr>
        </thead>
        <tbody>
<%
if( !(rsEntSer.EOF) ){

    while( !(rsEntSer.EOF) ){
%>
            <tr class="cssTrInsEntInv_ID"
             data-tipo="<%= rqIntTipo %>"
             data-ent_id="<%= rsEntSer("Ent_ID").Value %>"
             data-ent_pro_id="<%= rsEntSer("Ent_Pro_ID").Value %>"
             data-pro_id="<%= rsEntSer("Pro_ID").Value %>"
             data-inv_id="<%= rsEntSer("Inv_ID").Value %>"
            >
                <td class="col-sm-1">
                    <input type="checkbox" class="cssChkInsEntSerInv_ID" id="chbInsEnt_Art_<%= rsEntSer("Inv_ID").Value %>" <% if( rsEntSer("InsSer_Seleccionado").Value == 1 ){ %> checked <% } %>>
                </td>
                <td class="col-sm-3 text-left"><%= rsEntSer("Ent_Serie").Value %></td>
                <td class="col-sm-3 text-left"><%= rsEntSer("Ent_EPC").Value %></td>
<%
if( rqBolCambiarSerie ) {
%>
                <td class="col-sm-3">
                    <input type="text" class="form-control cssInpInsEntSerCambiarSerie" value="<%= rsEntSer("InsSer_Serie_Cambiado").Value %>"
                    placeholder="Serie a Cambiar" autocomplete="off" maxlength="30">
                </td>
                <td class="cssInsEntSerError">

                </td>
<%
}
%>
            </tr>
<%
        rsEntSer.MoveNext()
    }

} else {
%>
            <tr>
                <td colspan="4" class="text-left">
                    <i class="fa fa-exclamation-circle text-success"></i> No hay Registros
                </td>
            </tr>
<%
}
%>
        </tbody>
    </table>
<%
rsEntSer.Close()
%>
<% 
    if( rqBolCambiarSerie ){
%>
<script type="text/javascript">

    $(document).ready(function(){

        Serie.CambiarSerie = <%= (rqBolCambiarSerie) ? 1: 0 %>;

        $(".cssChkInsEntSerInv_ID").on("click", function(){
            Serie.Listado.Registro.SeleccionValidar({Objeto: this});
        });

        $(".cssInpInsEntSerCambiarSerie").on("keyup", function( evento ){
            Serie.Listado.Registro.SeleccionValidar({Objeto: this});
        });
  
    });

</script>
<%
    }
%>