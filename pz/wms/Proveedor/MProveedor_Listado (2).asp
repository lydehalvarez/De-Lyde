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

var sqlTAMan = "EXEC SPR_MProveedor "
      + "@Opcion = 1100 "
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

var rsMPro = AbreTabla(sqlTAMan, 1, cxnTipo)

if( !(rsMPro.EOF) ){

    var bolCamEst = false;
    var i = 0
    while(!(rsMPro.EOF)){
        i++
        bolCamEst = false

        if( rsMPro("Est_ID").Value == 5 || rsMPro("Est_ID").Value == 6 || rsMPro("Est_ID").Value == 7 || rsMPro("Est_ID").Value == 8 ){
            bolCamEst = true
        }
%>
                    <tr>
                        <td>

                            <div class="ibox">
                                <div class="ibox-content">
                                    <div class="row">
                                        <div class="col-lg-12">
                                            <div class="m-b-md">
<%
        if( bolCamEst ){
%>
                                                <a class="btn btn-success btn-sm pull-right" onclick='Proveedor.EstatusCambiar({TA_ID: <%= rsMPro("TA_ID").Value %>, OV_ID: <%= rsMPro("OV_ID").Value %>})'>
                                                    <i class="fa fa-refresh"></i> Cambiar Estatus
                                                </a>
<%
        }
%>
                                                
                                                <h2>
                                                    <b class="text-danger"><%= rsMPro("Folio").Value %></b>
                                                    <div class="col-sm-1">
                                                        <b><%=  rsMPro("ID").Value %></b>
                                                    </div>
                                                </h2>
                                            </div>
                                        </div>
                                    </div>
<%
        var strEstatusColor = "info"
        switch( rsMPro("Est_ID").Value ){
            case 5: { strEstatusColor = "info" } break; //	Tránsito
            case 6: case 7: case 8: { strEstatusColor = "warning" } break; // 1er, 2do, 3er Intento
            case 10: { strEstatusColor = "success" } break; // Entrega exitosa
            case 9: { strEstatusColor = "danger" } break; // entrega fallida 
        }
%>
                                               

                                    <div class="row">
                                        <div class="col-lg-5">
                                            <dl class="dl-horizontal">
                                                <dt>Estatus:</dt> 
                                                    <dd>
                                                        <span class="label label-<%= strEstatusColor %>">
                                                            <%= rsMPro("Est_Nombre").Value %>
                                                        </span>
                                                    </dd>
                                                <dt>Fecha Estatus</dt>
                                                    <dd><%= rsMPro("ProG_UltimaFechaEstatus").Value %></dd>
                                                <dt>Tienda:</dt> 
                                                    <dd><%= rsMPro("Almacen").Value %></dd>
                                                <dt>Direccion:</dt> 
                                                    <dd>
                                                        <a class="text-navy"> 
                                                            <%= rsMPro("Direccion").Value %>
                                                        </a>
                                                    </dd>
                                                <dt>Recibe:</dt> 
                                                    <dd><%= rsMPro("Responsable").Value %></dd>
                                                <dt>Telefono:</dt> 
                                                    <dd><%= rsMPro("Telefono").Value %></dd>
                                                <dt>Peso:</dt> 
                                                    <dd><%= rsMPro("Peso").Value %></dd>
                                                <dt>Volumen:</dt> 
                                                    <dd><%= rsMPro("Volumen").Value %></dd>
                                                <dt>Cajas:</dt> 
                                                    <dd><%= rsMPro("Cajas").Value %></dd>
                                            </dl>
                                        </div>
                                        <div class="col-lg-7" id="cluster_info">
                                            <dl class="dl-horizontal">

                                                <dt>Manifiesto:</dt> 
                                                    <dd>
                                                        <a class="text-navy"> 
                                                            <b><%= rsMPro("Man_Folio").Value %></b>
                                                        </a>
                                                    </dd>

                                                <dt>Transportista:</dt> 
                                                    <dd><%= rsMPro("Transportista").Value %></dd>
       
                                                <dt>Guia:</dt> 
                                                    <dd><%= rsMPro("Guia").Value %></dd>

                                                <dt>Ruta:</dt> 
                                                    <dd><%= rsMPro("Ruta").Value %></dd>

                                                <dt>Tipo Ruta:</dt> 
                                                    <dd><%= rsMPro("TipoRuta").Value %></dd>

                                                <dt>Aeropuerto:</dt> 
                                                    <dd><%= rsMPro("Aeropuerto").Value %></dd>

                                                <dt>Fecha Manifiesto:</dt>
                                                    <dd><%= rsMPro("Man_FechaConfirmado").Value %></dd>

                                                <dt>Fecha Compromiso:</dt>
                                                    <dd class="text-danger"><%= rsMPro("Man_FechaCompromiso").Value %></dd>
<%      if( rsMPro("Est_ID").Value == 10 ){
%>
                                                <dt>Recibio:</dt> 
                                                    <dd><%= rsMPro("ProG_Recibio").Value %></dd>
<%      }

        if( rsMPro("Est_ID").Value == 9 || rsMPro("Est_ID").Value == 10 ){
%>
                                                <dt>Comentario:</dt> 
                                                    <dd><%= rsMPro("ProG_Comentario").Value %></dd>
<%
        }
%>
                                                
                                                
                                            </dl>
                                        </div>
                                    </div>
                                </div>
                            </div>

                        </td>
                    </tr>
<%  
        Response.Flush()
        rsMPro.MoveNext()
    }        
     
}
rsMPro.Close()
%>