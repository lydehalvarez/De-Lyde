<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%

// HA ID: 1 Incidencia - Producto - Listado: Creacion de archivo.

var cxnTipo = 0

var rqIntTipo = Parametro("Tipo", 1);
var rqBolCambiarProducto = ( Parametro("CambiarProducto", 0) == 1 )
var rqBolVerSerie = ( Parametro("VerSerie", 0) == 1 );
var rqBolCambiarSerie = ( Parametro("CambiarSerie", 0) == 1 );
var rqStrFolio = Parametro("Folio", "");
var rqIntIns_ID = Parametro("Ins_ID", -2);

var sqlPro = "";

var Tipo = {
      Transferencia: 1
    , OrdenVenta: 2
}

switch( parseInt( rqIntTipo ) ){

    case Tipo.Transferencia:{ 

        var sqlPro = "SELECT DISTINCT TA.TA_ID AS Ent_ID "
                + ", TAA.TAA_ID AS Ent_Pro_ID "
                + ", Pro.Pro_ID "
                + ", Pro.Pro_SKU "
                + ", Pro.Pro_Nombre "
                + ", IIF(InsPro.Pro_ID IS NOT NULL, 1, 0) AS InsPro_Seleccionado "
                + ", COALESCE(ProCam.Pro_SKU, InsPro.Pro_SKU_Cambio, '') AS InsPro_SKU_Cambiado "
            + "FROM TransferenciaAlmacen TA "
                + "INNER JOIN TransferenciaAlmacen_Articulos TAA "
                    + "ON TA.TA_ID = TAA.TA_ID "
                + "INNER JOIN Producto Pro "
                    + "ON TAA.Pro_ID = Pro.Pro_ID "
                + "LEFT JOIN Incidencia_SKU InsPro "
                    + "ON TAA.Pro_ID = InsPro.Pro_ID "
                    + "AND TAA.TA_ID = InsPro.TA_ID "
                    + "AND InsPro.Ins_ID = " + rqIntIns_ID + " "
                + "LEFT JOIN Producto ProCam "
                    + "ON InsPro.Pro_ID_Cambio = ProCam.Pro_ID "
            + "WHERE TA.TA_Folio = '" + rqStrFolio + "' "

    } break;

    case Tipo.OrdenVenta: {

         var sqlPro = "SELECT DISTINCT OV.OV_ID AS Ent_ID"
                + ", OVA.OVA_ID AS Ent_Pro_ID "
                + ", Pro.Pro_ID "
                + ", Pro.Pro_SKU "
                + ", Pro.Pro_Nombre "
                + ", IIF(InsPro.Pro_ID IS NOT NULL, 1, 0) AS InsPro_Seleccionado "
                + ", COALESCE(ProCam.Pro_SKU, InsPro.Pro_SKU_Cambio, '') AS InsPro_SKU_Cambiado "
            + "FROM Orden_Venta OV "
                + "INNER JOIN Orden_Venta_Articulo OVA "
                    + "ON OV.OV_ID = OVA.OV_ID "
                + "INNER JOIN Producto Pro "
                    + "ON OVA.Pro_ID = Pro.Pro_ID "
                + "LEFT JOIN Incidencia_SKU InsPro "
                    + "ON OVA.Pro_ID = InsPro.Pro_ID "
                    + "AND OVA.TA_ID = InsPro.TA_ID "
                    + "AND InsPro.Ins_ID = " + rqIntIns_ID + " "
                + "LEFT JOIN Producto ProCam "
                    + "ON InsPro.Pro_ID_Cambio = ProCam.Pro_ID "
            + "WHERE TA.TA_Folio = '" + rqStrFolio + "' "

    } break;

}

var rsPro = AbreTabla(sqlPro, 1, cxnTipo)
%>

<div class="ibox" id="divInsProLis">
    <div class="ibox-title">
        <h5>Productos<h5>
        <div class="ibox-tools">
            <i class="fa fa-exclamation-circle-o fa-lg text-success" title="Seleccionar los articulos de la incidencia"></i>
        </div>
    </div>
    <div class="ibox-content">
        <table class="table">
            <thead>
                <tr>
                    <th>
                        
                    </th>
                    <th>SKU</th>
                    <th>Nombre</th>
<%  
    if( rqBolCambiarProducto ){
%>
                    <th>SKU a Cambiar</th>
<%
    }

    if( rqBolVerSerie ) {
%>
                    <th></th>
<%
    }
%>
                    <th></th>
                </tr>
            </thead>
            <tbody>
<%
    if( !(rsPro.EOF) ){

        while( !(rsPro.EOF) ){
%>
                <tr id="trInsEntPro_<%= rsPro("Ent_Pro_ID").Value %>" class="cssTrInsEntPro_ID"
                 data-tipo="<%= rqIntTipo %>"
                 data-ent_id="<%= rsPro("Ent_ID").Value %>"
                 data-ent_pro_id="<%= rsPro("Ent_Pro_ID").Value %>"
                 data-pro_id="<%= rsPro("Pro_ID").Value %>"
                >
                    <td class="col-sm-1">
<%
            if( !(rqBolVerSerie) ) {
%>
                        <input type="checkbox" class="cssChkInsEntProPro_ID" <% if( rsPro("InsPro_Seleccionado").Value == 1 ){ %> checked <% } %>>
<%
            }
%>
                    </td>
                    <td class="text-left col-sm-3">
                        <%= rsPro("Pro_SKU").Value %>
                    </td>
                    <td class="text-left col-sm-4">
                        <%= rsPro("Pro_Nombre").Value %>
                    </td>
<%  
            if( rqBolCambiarProducto ){
%>
                    <td class="text-left col-sm-4">
                        <input type="text" class="form-control cssInpInsEntProCambiarProducto" value="<%= rsPro("InsPro_SKU_Cambiado").Value %>"
                         placeholder="SKU a Cambiar" autocomplete="off" maxlength="20" >
                    </td>
<%  
            }

            if( rqBolVerSerie ) {
%>
                    <td class="text-right">
                        <button type="button" class="btn btn-sm btn-white cssBtnInsProSerLisCar" id="btnInsProCargar_<%= rsPro("Ent_Pro_ID").Value %>">
                            <i class="fa fa-angle-down"></i> Ver Series
                        </button>
                        <button type="button" class="btn btn-sm btn-danger cssBtnInsProSerLisRem" id="btnInsProRemover_<%= rsPro("Ent_Pro_ID").Value %>" style="display: none;">
                            <i class="fa fa-angle-up"></i> Ocultar Series
                        </button>
                    </td>
<%
            }
%>                      
                    <td class="cssInsEntProError">

                    </td>
                </tr>
<%
            rsPro.MoveNext();
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
    </div>
</div>

<script type="text/javascript">

    $(".cssBtnInsProSerLisCar").on("click", function(){
        var objPadre = $(this).parents("tr");
        var intTipo = $(objPadre).data("tipo");
        var intEnt_ID = $(objPadre).data("ent_id");
        var intEnt_Pro_ID = $(objPadre).data("ent_pro_id");
        var intPro_ID = $(objPadre).data("pro_id");

        var jsonData = {
              Tipo: intTipo
            , Ent_ID: intEnt_ID
            , Ent_Pro_ID: intEnt_Pro_ID
            , CambiarSerie: <%= (rqBolCambiarSerie) ? 1 : 0 %>
            , Ins_ID: <%= rqIntIns_ID %>
        }

        Serie.Listado.Cargar(jsonData);
    });

    $(".cssBtnInsProSerLisRem").on("click", function(){
        var objPadre = $(this).parents("tr");
        var intEnt_Pro_ID = $(objPadre).data("ent_pro_id");

        var jsonData = {
              Ent_Pro_ID: intEnt_Pro_ID
        }

        Serie.Listado.Remover(jsonData);
    });

<%
    if( rqBolCambiarProducto ){
%>
    $(".cssChkInsEntProPro_ID").on("click", function(){
        Producto.Listado.Registro.SeleccionValidar({Objeto: this});
    });

    $(".cssInpInsEntProCambiarProducto").on("keyup", function( evento ){
        var intTecla = (document.all) ? evento.keyCode : evento.which;
			
        if( intTecla == 13 ){
            Producto.Listado.Registro.SeleccionValidar({Objeto: this, SKUCambio: $(this).val()});
        }
    });
<%
    }
%>  

</script>
