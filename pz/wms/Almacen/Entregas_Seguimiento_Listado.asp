<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2021-JUN-14 Entregas - Seguiemiento: Creación de archivo

var cxnTipo = 0

var rqStrFolio = Parametro("Folio", "")
var rqStrSKU = Parametro("SKU", "")

var rqIntTipoArticulo = Parametro("TipoArticulo", -1)
var rqIntCantidadArticulo = Parametro("CantidadArticulo", -1)

var rqDateFechaInicial = Parametro("FechaInicial", "")
var rqDateFechaFinal = Parametro("FechaFinal", "")
var rqIntEst_ID = Parametro("Estatus", -1)

var rqIntSiguienteRegistro = Parametro("SiguienteRegistro", 0)
var rqIntRegistrosPagina = Parametro("RegistrosPagina", 10)

var Entrega = {
    Estatus: {
        Pendiente: 1
        , Picking: 2
        , Packing: 3
        , Shipping: 4
    }
}

var sqlEntSeg = "EXEC SPR_Entregas_Seguimiento "
      + "@Opcion = 1000 "
    + ", @Folio = " + ( (rqStrFolio.length > 0) ? "'" + rqStrFolio + "'" : "NULL" ) + " "
    + ", @SKU = " + ( (rqStrSKU.length > 0) ? "'" + rqStrSKU + "'" : "NULL" ) + " "
    + ", @TipoArticulo = " + ( (rqIntTipoArticulo > -1) ? rqIntTipoArticulo : "NULL" ) + " "
    + ", @CantidadArticulo = " + ( (rqIntCantidadArticulo > -1) ? rqIntCantidadArticulo : "NULL" ) + " "
    + ", @FechaInicial = " + ( ( rqDateFechaInicial.length > 0 ) ? "'" + rqDateFechaInicial + "'" : "NULL" ) + " "
    + ", @FechaFinal = " + ( ( rqDateFechaFinal.length > 0 ) ? "'" + rqDateFechaFinal + "'" : "NULL" ) + " "
    + ", @Est_ID = " + ( (rqIntEst_ID > -1) ? rqIntEst_ID : "NULL" ) + " "
    + ", @SiguienteRegistro = " + ( (rqIntSiguienteRegistro > -1) ? rqIntSiguienteRegistro : "NULL" ) + " "
    + ", @RegistrosPagina = " + ( (rqIntRegistrosPagina > 0) ? rqIntRegistrosPagina : "NULL" ) + " "

var rsEntSeg = AbreTabla(sqlEntSeg, 1, cxnTipo)

var strliEstatus = ""
var strLblEstatus = ""

var intTA_ID = 0;
var stricono = ""

while( !(rsEntSeg.EOF) ){

    switch( parseInt(rsEntSeg("Est_ID").Value) ){
        case Entrega.Estatus.Pendiente: { 
            strLblEstatus = "label-warning";
        } break;
        case Entrega.Estatus.Picking: { 
            strLblEstatus = "label-info";
        } break;
        case Entrega.Estatus.Packing:  { 
            strLblEstatus = "label-success";
        } break;
        case Entrega.Estatus.Shipping: { 
            strLblEstatus = "label-primary";
        } break;            
    }

        switch( parseInt(rsEntSeg("TpA_ID").Value) ){
        case 1:{ stricono = "fa fa-fax" } break;
        case 2:{ stricono = "fa fa-gift" } break;
        default: { stricono = "fa fa-question" }
    }

    if( intTA_ID != rsEntSeg("TA_ID").Value ){
%>
        <tr class="cssReg">
            <td>
                <input type="checkbox" class="cssTodos cssRegistro" 
                                 data-ta_id="<%= rsEntSeg("TA_ID").Value %>" 
                                 onclick="Entrega.Buscar.RegistroSeleccionar(this);">
            </td>
            <td><%= rsEntSeg("ID").Value %></td>
            <td class="col-sm-2">
                <label class="label <%= strLblEstatus %>">
                    <%= rsEntSeg("Est_Nombre").Value %>
                </label>
            </td>
            <td class="col-sm-2">
                <a class="text-danger">
                    <b><%= rsEntSeg("TA_Folio").Value %></b>
                </a>
                <br>
                <small><%= rsEntSeg("TPo_Nombre").Value %></small>
            </td>
            <td class="col-sm-6">
                <a>
                    <%= rsEntSeg("Alm_Clave").Value %> - <%= rsEntSeg("Alm_Nombre").Value %>
                </a>
                <br>
                <small>
                    <i class="fa fa-home"></i> <%= rsEntSeg("Alm_Direccion").Value %>
                </small>
            </td>
            <td class="col-sm-2">
                <a>
                    <%= rsEntSeg("TA_FechaRegistro").Value %>
                </a>
                <br>
                <small>
                    Fecha Registro
                </small>
            </td>
        </tr>
        <tr>
            <td colspan="6">
                <table class="table" >
                    <thead>
                        <tr>
                            <th>&nbsp;</th>
                            <th>&nbsp;</th>
                            <th>ID</th>
                            <th></th>
                            <th>SKU</th>
                            <th>Nombre</th>
                            <th>Cantidad</th>
                        </tr>
                    </thead>
                    <tbody>
<%
    }
%>
                        <tr>
                            <td>&nbsp;</td>
                            <td>
                                <input type="checkbox" class="cssTodos cssRegistro" 
                                 data-ta_id="<%= rsEntSeg("TA_ID").Value %>" 
                                 data_taa_id="<%= rsEntSeg("TAA_ID").Value %>"
                                 onclick="Entrega.Buscar.RegistroSeleccionar(this);">
                            </td>
                            <td><%= rsEntSeg("TAA_ID").Value %></td>
                            <td><i class="<%= stricono %>" title="<%= rsEntSeg("TpA_Nombre").Value %>"></i></td>
                            <td><%= rsEntSeg("Pro_SKU").Value %></td>
                            <td><%= rsEntSeg("Pro_Nombre").Value %></td>
                            <td><%= rsEntSeg("TAA_Cantidad").Value %></td>
                        </tr>
<%
    intTA_ID = rsEntSeg("TA_ID").Value;
    
    Response.Flush()
    rsEntSeg.MoveNext()

    if( rsEntSeg.EOF || ( !(rsEntSeg.EOF) && intTA_ID != rsEntSeg("TA_ID").Value ) ){
%>
                    </tbody>
                </table>
            </td>
        </tr>
<%
   }
    
}

rsEntSeg.Close()
%>