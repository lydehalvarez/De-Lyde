<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2021-JUN-03 Tiedas y entregas: Creación de archivo

var cxnTipo = 0

var rqIntTA_ID = Parametro("TA_ID", "-1")

var Entregas = {
      Estatus: {
          Pendiente: 1
        , Picking: 2
        , Packing: 3
        , Shipping: 4
        , Transito: 5
        , Intento_1er: 6
        , Intento_2do: 7
        , Intento_3er: 8
        , Falla_entrega: 9
        , Entrega_exitosa: 10
        , Cancelado: 11
        , Devuelto: 16
    }
}

var sqlTADet = "EXEC SPR_TransferenciaAlmacen "
      + "@Opcion = 1000 "
    + ", @TA_ID = " + (( rqIntAlm_ID > -1 ) ? rqIntAlm_ID : "NULL" ) + " "
    
var rsTADet = AbreTabla(sqlTADet, 1, cxnTipo)

var strLblEstatus = "";

if( !(rsTADet.EOF) ){

    switch( parseInt(rsTADet("Est_ID").Value) ){
        case Entregas.Estatus.Pendiente: 
        case Entregas.Estatus.Packing: 
        case Entregas.Estatus.Shipping: { 
            strliEstatus = "warning-element"; 
            strLblEstatus = "label-warning";
        } break;
        case Entregas.Estatus.Transito:
        case Entregas.Estatus.Intento_1er:
        case Entregas.Estatus.Intento_2do:
        case Entregas.Estatus.Intento_3er: { 
            strliEstatus = "success-element";
            strLblEstatus = "label-success";
        } break;
        case Entregas.Estatus.Entrega_exitosa:{ 
            strliEstatus = "info-element";
            strLblEstatus = "label-info";
        } break;
        case Entregas.Estatus.Falla_entrega:
        case Entregas.Estatus.Cancelado:
        case Entregas.Estatus.Devuelto:{ 
            strliEstatus = "danger-element";
            strLblEstatus = "label-danger";
        } break;
            
    }
%>
    <div class="ibox">
        <div class="ibox-title">
            <h5><%= rsTADet("TA_Folio").Value %></h5>
            <div class="ibox-tools">
                <label class="label <%= strLblEstatus %>">
                    <%= rsTADet("Est_Nombre").Value %>
                </label>
            </div>
        </div>
        <div class="ibox-content">

            <b>Origen:</b> <%= rsTADet("Alm_Nombre_Origen").Value %>
            <br>

            <b>Destino:</b> <%= rsTADet("Alm_Nombre_Destino").Value %>
            <br>

            <b>Fecha Entrega:</b> <%= rsTADet("TTA_FechaEntrega").Value %>
            <br>
            
            <b>Manifiesto:</b> <%= rsTADet("Man_Folio").Value %>
            <br>
            
            <b>Transportista:</b> <%= rsTADet("Prov_Nombre").Value %>
            <br>
            
            <b>Guia:</b> <%= rsTADet("TA_Guia").Value %>
            <br>
            
            <b>Ruta:</b> <%= rsTADet("Man_Ruta").Value %>
            <br>

            <b>Tipo Ruta:</b> <%= rsTADet("TRu_Nombre").Value %>
            <br>
            
            <b>Confirmado:</b> <%= rsTADet("MMan_FechaConfirmado").Value %>
            <br>
                    
        </div>
    </div>  
<%

}
rsTADet.Close()
%>