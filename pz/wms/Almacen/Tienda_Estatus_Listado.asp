<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2021-JUN-03 Tiedas y entregas: Creación de archivo

var cxnTipo = 0

var rqIntAlm_ID = Parametro("Tienda", "-1")
var rqStrFolio = Parametro("Folio", "")
var rqIntEst_ID = Parametro("Estatus", "-1")
var rqDateFechaInicial = Parametro("FechaInicial", "")
var rqDateFechaFinal = Parametro("FechaFinal", "")
var rqStrSKU = Parametro("SKU", "")
var rqStrECP = Parametro("ECP", "")

var rqIntTipo = Parametro("Tipo", -1)
var rqIntSiguienteRegistro = Parametro("SiguienteRegistro", 0)
var rqIntRegistrosPagina = Parametro("RegistrosPagina", 100)

var strEst_IDs = "";
var arrEst_IDs = [];

var valReg = "";

var Buscar = {
    Tipo: {
         Terminado: 1
        , Pendiente: 2
    }
}

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

var bolEsTipoPeniente = ( rqIntTipo == Buscar.Tipo.Pendiente ); 

switch( parseInt(rqIntTipo) ){
    case Buscar.Tipo.Terminado: {
        arrEst_IDs = [
              Entregas.Estatus.Falla_entrega
            , Entregas.Estatus.Entrega_exitosa
            , Entregas.Estatus.Cancelado
            , Entregas.Estatus.Devuelto
            , Entregas.Estatus.Transito
            , Entregas.Estatus.Intento_1er
            , Entregas.Estatus.Intento_2do
            , Entregas.Estatus.Intento_3er
        ];

        valReg = "cssEntTerReg";
    } break;
    case Buscar.Tipo.Pendiente: {
        arrEst_IDs = [
              Entregas.Estatus.Pendiente
            , Entregas.Estatus.Picking
            , Entregas.Estatus.Packing
            , Entregas.Estatus.Shipping    
        ];

        valReg = "cssEntPenReg";
    } break;
}

strEst_IDs = arrEst_IDs.join(",");

var sqlTieEst = "EXEC SPR_Tienda_Estatus "
      + "@Opcion = 1000 "
    + ", @Alm_ID = " + (( rqIntAlm_ID > -1 ) ? rqIntAlm_ID : "NULL" ) + " "
    + ", @Est_IDs = " + ( (strEst_IDs.length > 0) ? "'" + strEst_IDs + "'" : "NULL" ) + " "
    + ", @Folio = " + ( (rqStrFolio.length > 0) ? "'" + rqStrFolio + "'" : "NULL" ) + " "
    + ", @Est_ID = " + ( (rqIntEst_ID > -1) ? rqIntEst_ID : "NULL" ) + " "
    + ", @FechaInicial = " + ( ( rqDateFechaInicial.length > 0 ) ? "'" + rqDateFechaInicial + "'" : "NULL" ) + " "
    + ", @FechaFinal = " + ( ( rqDateFechaFinal.length > 0 ) ? "'" + rqDateFechaFinal + "'" : "NULL" ) + " "
    + ", @SKU = " + ( (rqStrSKU.length > 0) ? "'" + rqStrSKU + "'" : "NULL" ) + " "
    + ", @EPC = " + ( (rqStrECP.length > 0) ? "'" + rqStrECP + "'" : "NULL" ) + " "
    + ", @SiguienteRegistro = " + ( (rqIntSiguienteRegistro > -1) ? rqIntSiguienteRegistro : "NULL" ) + " "
    + ", @RegistrosPagina = " + ( (rqIntRegistrosPagina > 0) ? rqIntRegistrosPagina : "NULL" ) + " "

    //Response.Write(sqlTieEst)

var rsTieEst = AbreTabla(sqlTieEst, 1, cxnTipo)

var strliEstatus = ""
var strLblEstatus = ""

while( !(rsTieEst.EOF) ){

    switch( parseInt(rsTieEst("Est_ID").Value) ){
        case Entregas.Estatus.Pendiente: 
        case Entregas.Estatus.Packing: 
        case Entregas.Estatus.Shipping: { 
            strliEstatus = "warning-element "; 
            strLblEstatus = "label-warning";
        } break;
        case Entregas.Estatus.Transito:
        case Entregas.Estatus.Intento_1er:
        case Entregas.Estatus.Intento_2do:
        case Entregas.Estatus.Intento_3er: { 
            strliEstatus = "success-element ";
            strLblEstatus = "label-success";
        } break;
        case Entregas.Estatus.Entrega_exitosa:{ 
            strliEstatus = "info-element ";
            strLblEstatus = "label-info";
        } break;
        case Entregas.Estatus.Falla_entrega:
        case Entregas.Estatus.Cancelado:
        case Entregas.Estatus.Devuelto:{ 
            strliEstatus = "danger-element ";
            strLblEstatus = "label-danger";
        } break;
            
    }
%>
    <li class="<%= strliEstatus %>
     <%= valReg %>">
        <div class="pull-right">
            <label class="label <%= strLblEstatus %>">
                <%= rsTieEst("Est_Nombre").Value %>
            </label>
        </div>
        <h3>
<%  if( bolEsTipoPeniente ){
%>
            <input type="checkbox" class="cssCancelar" value='<%= rsTieEst("TA_ID").Value %>'>
<%  }
%>
            <%= rsTieEst("TA_Folio").Value %>
        </h3>
        <div class="row">
            <label class="col-sm-2 control-label">
                Tipo
            </label>
            <div class="col-sm-4">
                <%= rsTieEst("Tpo_Nombre").Value %>
            </div>
            <label class="col-sm-4 control-label">
                Articulos
            </label>
            <div class="col-sm-2">
                <%= rsTieEst("TAA_ArticulosTotal").Value %>
            </div>
        </div>
        <div class="agile-detail">
            <a class="pull-right btn btn-xs btn-white" onclick='Entregas.Transferencia.DetalleVer({TA_ID: <%= rsTieEst("TA_ID").Value %>});'>
                <i class="fa fa-file-text-o"></i> Ver
            </a>
            <i class="fa fa-calendar-o"></i> <%= rsTieEst("TA_FechaRegistro").Value %>
        </div>
    </li>
<%
    Response.Flush()
    rsTieEst.MoveNext()
}

rsTieEst.Close()
%>