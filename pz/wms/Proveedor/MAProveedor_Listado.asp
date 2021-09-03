<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2020-ENE-05 Surtido: Creación de archivo

var cxnTipo = 0

var rqIntGuia = Parametro("Guia", "")
var rqStrFolio = Parametro("Folio", "")
var rqStrMan_Folio = Parametro("Man_Folio", "") 
var rqIntEst_ID = Parametro("Est_ID", -1)
var rqDateFechaInicial = Parametro("FechaInicial", "")
var rqDateFechaFinal = Parametro("FechaFinal", "")
var rqIntEvidencia = Parametro("Evidencia", -1)
var rqIntIDUsuario = Parametro("IDUsuario", -1)
var rqIntProv_ID = Parametro("Prov_ID", -1)
var rqIntSiguienteRegistro = Parametro("SiguienteRegistro", 0) 
var rqIntRegistrosPagina = Parametro("RegistrosPagina", 10)

var Entrega = {
    Estatus: {
          Transito: 5
        , PrimerIntento: 6
        , SegundoIntento: 7
        , TercerIntento: 8
        , FallaEntrega: 9
        , EntregaExitosa: 10
        , Cancelado: 11
        , AvisoDevolucion: 22
    }
}

var Guia = {
    Estatus: {
        SinEntregas: 1
        , Parcial: 2
        , Total: 3
    }
}

var sqlTAMan = "EXEC SPR_MProveedor "
      + "@Opcion = 1200 "
    + ", @Prog_NumeroGuia = " + ( (rqIntGuia.length > 0) ? "'" + rqIntGuia + "'" : "NULL" ) + " "
    + ", @Folio = " + ( (rqStrFolio.length > 0) ? "'" + rqStrFolio + "'" : "NULL" ) + " "
    + ", @Man_Folio = " + ( (rqStrMan_Folio.length > 0) ? "'" + rqStrMan_Folio + "'" : "NULL" ) + " "
    + ", @Est_ID = " + ( (rqIntEst_ID > -1) ? rqIntEst_ID : "NULL" ) + " "
    + ", @FechaInicial = " + ( (rqDateFechaInicial.length > 0) ? "'" + rqDateFechaInicial + "'" : "NULL" ) + " "
    + ", @FechaFinal = " + ( (rqDateFechaFinal.length > 0) ? "'" + rqDateFechaFinal + "'" : "NULL" ) + " "
    + ", @Evidencia = " + ( ( rqIntEvidencia > -1 ) ? rqIntEvidencia : "NULL" ) + " "
    + ", @IDUsuario = " + ( (rqIntIDUsuario > -1) ? rqIntIDUsuario : "NULL" ) + " "
    + ", @Prov_ID = " + ( (rqIntProv_ID > -1) ? rqIntProv_ID : "NULL" ) + " "
    + ", @SiguienteRegistro = " + ( (rqIntSiguienteRegistro > 0) ?  rqIntSiguienteRegistro : 0) + " "
    + ", @RegistrosPagina = " + ( (rqIntRegistrosPagina > 0) ?  rqIntRegistrosPagina : 10) + " "
    + ", @ProG_Multiple = 1 "

var rsMPro = AbreTabla(sqlTAMan, 1, cxnTipo)

if( !(rsMPro.EOF) ){

    var bolCamEst = false;
    var i = 0
    var intID = 0
    while(!(rsMPro.EOF)){
        
        bolCamEst = false

        if( rsMPro("ProG_EstatusCG40").Value == Guia.Estatus.SinEntregas || rsMPro("ProG_EstatusCG40").Value == Guia.Estatus.Parcial ){
            bolCamEst = true
        }
        
        if( intID != rsMPro("ID").Value ){
            i = 0
%>
                    <tr id="tr_<%= rsMPro("ID").Value %>" class="cssGuia">
                        <td>
                            <div class="ibox">
                                <div class="ibox-title">
                                    <h2>
                                        <div class="col-sm-1">
                                            <b><%= rsMPro("ID").Value %></b>
                                        </div>
                                        <div class="col-sm-5">
                                            <b class="text-danger lblGuia"><%= rsMPro("Guia").Value %></b>    
                                        </div>
                                        <div class="col-sm-4">
                                            <label class="label label-success"> <%=  rsMPro("EstP_Nombre").Value %> </label>
                                        </div>
                                    </h2>
<%
            if( bolCamEst ){
%>
                                    <div class="ibox-tools">
                                        <button type="button" class="btn btn-success btn-sm btnCambioEstatus" onclick='Proveedor.EstatusCambiarVisualizar({ID: "<%= rsMPro("ID").Value %>"})'>
                                            <i class="fa fa-refresh"></i> Cambiar Estatus
                                        </button>
                                    </div>
<%
            }
%>
                                </div>
                                <div class="ibox-content">
                                    <div class="row">
                                        <div class="col-lg-5" id="cluster_info">
                                            <dl class="dl-horizontal">

                                                <dt>Manifiesto:</dt> 
                                                    <dd>
                                                        <a class="text-navy"> 
                                                            <b><%= rsMPro("Man_Folio").Value %></b>
                                                        </a>
                                                    </dd>

                                                <dt>Fecha Manifiesto:</dt>
                                                    <dd><%= rsMPro("Man_FechaConfirmado").Value %></dd>
                                                
                                                <dt>Ruta:</dt>
                                                    <dd><%= (rsMPro("Ruta").Value > 0) ? rsMPro("Ruta").Value : "N/A"  %></dd>
                                                
                                                <dt>Tipo de Ruta:</dt>
                                                    <dd><%= rsMPro("TipoRuta").Value %></dd>

                                                <dt>Aeropuerto:</dt>
                                                    <dd><%= rsMPro("Aeropuerto").Value %></dd>
                                                
                                            </dl>
                                        </div>

                                        <div class="col-lg-7" id="cluster_info">
                                            <dl class="dl-horizontal">

                                                <dt>Fecha Compromiso:</dt>
                                                    <dd class="text-danger"><%= rsMPro("Man_FechaCompromiso").Value %></dd>
                                                <dt>Transportista:</dt> 
                                                    <dd><%= rsMPro("Transportista").Value %></dd>

                                                <dt>Peso:</dt> 
                                                    <dd><%= rsMPro("Guia_Peso").Value %></dd>
                                                <dt>Volumen:</dt> 
                                                    <dd><%= rsMPro("Guia_Volumen").Value %></dd>
                                                <dt>Cajas:</dt> 
                                                    <dd><%= rsMPro("Guia_Cajas").Value %></dd>

                                            </dl>
                                        </div>

                                    </div>

                                    <div class="row divFormCambioEstatus" style="padding: 5px;">
                                    
                                    </div>

                                    <div class="row">

                                        <table class="table table-hover">
                                            <thead>
                                                <tr>
                                                    <th>&nbsp;</th>
                                                    <th>
                                                        <input type="checkbox" class="cssTodos" style="display: none;" onclick='Proveedor.EstatusCambiarTodosSeleccionar()'>
                                                    </th>
                                                    <th>Estatus</th>
                                                    <th>Folio</th>
                                                    <th>Cajas</th>
                                                    <th>Recibe</th>
                                                    <th>Recibi&oacute;</th>
                                                </tr>
                                            </thead>
                                            <tbody>
<%
        }

        var strEstatusColor = "info"
        var arrCat_IDs = [];
        var strEst_IDs = ""
        switch( rsMPro("EST_ID").Value ){
            case Entrega.Estatus.Transito: { 
                strEstatusColor = "info" 
                arrCat_IDs = [
                    Entrega.Estatus.PrimerIntento
                    , Entrega.Estatus.AvisoDevolucion
                    , Entrega.Estatus.EntregaExitosa
                ] 
            } break; //	Tránsito
            case Entrega.Estatus.PrimerIntento: { 
                strEstatusColor = "warning" 
                arrCat_IDs = [
                        Entrega.Estatus.SegundoIntento
                    , Entrega.Estatus.AvisoDevolucion
                    , Entrega.Estatus.EntregaExitosa
                ] 
            } break; // 1er Intento
            case Entrega.Estatus.SegundoIntento: { 
                strEstatusColor = "warning" 
                arrCat_IDs = [
                        Entrega.Estatus.TercerIntento
                    , Entrega.Estatus.AvisoDevolucion
                    , Entrega.Estatus.EntregaExitosa
                ] 
            } break; // 2do Intento
            case Entrega.Estatus.TercerIntento: { 
                strEstatusColor = "warning" 
                arrCat_IDs = [
                        Entrega.Estatus.AvisoDevolucion
                    , Entrega.Estatus.EntregaExitosa
                ] 
            } break; // 3er Intento
            case Entrega.Estatus.FallaEntrega: { 
                strEstatusColor = "danger" 
            } break; // entrega fallida
            case Entrega.Estatus.EntregaExitosa: { 
                strEstatusColor = "success" 
            } break; // Entrega exitosa
            case Entrega.Estatus.Cancelado: { 
                strEstatusColor = "danger" 
            } break; // entrega fallida
            case Entrega.Estatus.AvisoDevolucion: { 
                strEstatusColor = "danger" 
            } break; // entrega fallida
        }

        strCat_IDs = arrCat_IDs.join(",");

%>
                                                <tr>
                                                    <td><%= ++i %></td>
                                                    <td class="cssDatos"
                                                     data-ta_id="<%= rsMPro("TA_ID").Value %>" 
                                                     data-ov_id="<%= rsMPro("OV_ID").Value %>"
                                                     data-est_ids="<%= strCat_IDs %>"
                                                     data-guardando="0"
                                                     data-terminado="0"
                                                    >
                                                        
                                                    </td>
                                                    <td class="project-status"> 
                                                        <span class="label label-<%= strEstatusColor %>">
                                                            <%= rsMPro("Est_Nombre").Value %>
                                                        </span>
                                                        <br>
                                                        <small title="Fecha y hora de último estatus">
                                                            <i class="fa fa-clock-o"></i> <%= rsMPro("ProG_UltimaFechaEstatus").Value %>
                                                        </small>
                                                    </td>
                                                    <td class="">
                                                        <a>
                                                            <%= rsMPro("Folio").Value %>
                                                        </a>
                                                        <br>
                                                        <small>
                                                            <%= rsMPro("Almacen").Value %> (<%= rsMPro("Edo_Nombre").Value %>)
                                                            <br>
                                                            <i class="fa fa-home"></i> <%= rsMPro("Direccion").Value %>
                                                        </small>
                                                    </td>
                                                    <td>
                                                        <%= rsMPro("Cajas").Value %>
                                                    </td>
                                                    <td class="">
                                                        <a>
                                                            <%= rsMPro("Responsable").Value %>
                                                        </a>
                                                        <br>
                                                        <small>
                                                            <i class="fa fa-phone"></i> <%= rsMPro("Telefono").Value %>
                                                        </small>
                                                    </td>

                                                    <td>
<%          if( rsMPro("Est_ID").Value == Entrega.Estatus.EntregaExitosa ){
%>
                                                        <a><%= rsMPro("ProG_Recibio").Value %></a>

                                                        <br>

<%          }

            if( rsMPro("Est_ID").Value == Entrega.Estatus.FallaEntrega 
                || rsMPro("Est_ID").Value == Entrega.Estatus.EntregaExitosa 
                || rsMPro("Est_ID").Value == Entrega.Estatus.Cancelado 
                || rsMPro("Est_ID").Value == Entrega.Estatus.AvisoDevolucion ){
%>
                                                        <small>
                                                            <i class="fa fa-comments"></i> <%= rsMPro("ProG_Comentario").Value %>
                                                        </small>
<%
            }
%>
                                                    </td>
                                                </tr>
<%  
        intID = rsMPro("ID").Value;

        Response.Flush()
        rsMPro.MoveNext()

        if( rsMPro.EOF || ( !(rsMPro.EOF) && intID != rsMPro("ID").Value ) ){
%>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>

                        </td>
                    </tr>
<%
        }
    }        
     
}
rsMPro.Close()
%>