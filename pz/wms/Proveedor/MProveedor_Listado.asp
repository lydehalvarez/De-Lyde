<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2020-ENE-05 Surtido: Creación de archivo
// HA ID: 2 2021-JUN-25 Agregado de Acciones: Se agrega botón de cambio de fecha para "AG" y carga de archivos para Estatus "Entrega Exitosa".
// HA ID: 3 2021-JUL-07 Agregar Filtro de Tipo de Localidad: Local o Foranea y se agrega parametros de cambio de estatus

var cxnTipo = 0

// HA ID: 2
var arrProvFec = [ 
        3 //AG
    ];

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
var rqBolTransportista = Parametro("Transportista", 0)

//HA: 3 Filtro
var rqIntTpo_Localidad = Parametro("Tpo_Localidad", -1)

var bolVisCamFec = false;
var bolVisAgrArc = false;

var Estatus = {
          Transito: 5
        , PrimerIntento: 6
        , SegundoIntento: 7
        , TercerIntento: 8
        , FallaEntrega: 9
        , EntregaExitosa: 10
        , AvisoDevolucion: 22
    }

//HA: 3 Se agrega Filtro
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
    + ", @Tpo_Localidad = " + ( (rqIntTpo_Localidad > -1) ? rqIntTpo_Localidad : "NULL" ) + " "
    + ", @SiguienteRegistro = " + ( (rqIntSiguienteRegistro > 0) ?  rqIntSiguienteRegistro : 0) + " "
    + ", @RegistrosPagina = " + ( (rqIntRegistrosPagina > 0) ?  rqIntRegistrosPagina : 10) + " "

var rsMPro = AbreTabla(sqlTAMan, 1, cxnTipo)

if( !(rsMPro.EOF) ){

    var bolCamEst = false;
    var i = 0
    while(!(rsMPro.EOF)){
        i++
        
        bolVisAgrArc = ( parseInt(rsMPro("Est_ID").Value) == Estatus.EntregaExitosa );

        bolVisCamFec = ( rqBolTransportista == 0 || ( rqBolTransportista == 1 && arrProvFec.indexOf(parseInt( rsMPro("Prov_ID").Value )) > -1 && rsMPro("Est_ID").Value == Estatus.EntregaExitosa) );

        if( rsMPro("Est_ID").Value == Estatus.Transito
            || rsMPro("Est_ID").Value == Estatus.PrimerIntento
            || rsMPro("Est_ID").Value == Estatus.SegundoIntento
            || rsMPro("Est_ID").Value == Estatus.TercerIntento ){
            bolCamEst = true;
        } else {
            bolCamEst = false;
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

            //HA ID: 3 Se agregarn parametros para cambio de Estatus
%>
                                                <a class="btn btn-success btn-sm pull-right" style="margin-left: 5px;"
                                                    onclick='Proveedor.EstatusCambiar({
                                                          TA_ID: <%= rsMPro("TA_ID").Value %>
                                                        , OV_ID: <%= rsMPro("OV_ID").Value %>
                                                        , Folio: "<%= rsMPro("Folio").Value %>"
                                                        , Est_ID: <%= rsMPro("Est_ID").Value %>
                                                        , Est_Nombre: "<%= rsMPro("Est_Nombre").Value %>"
                                                        , DiasTranscurridos: <%= ( rsMPro("Dias_Transcurridos").Value + 1 ) * -1 %>
                                                    })'>
                                                    <i class="fa fa-refresh"></i> Cambiar Estatus
                                                </a>
<%
        }

        if( bolVisAgrArc ){
%>
                                                <a class="btn btn-info btn-sm pull-right"  style="margin-left: 5px;"
                                                 onclick='Proveedor.Archivo.ModalAbrir({TA_ID: <%= rsMPro("TA_ID").Value %>, OV_ID: <%= rsMPro("OV_ID").Value %>, Folio: "<%= rsMPro("Folio").Value %>"})'>
                                                    <i class="fa fa-files-o"></i> Agregar Evidencia
                                                </a>
<%
        }

        if( bolVisCamFec ){
%>
                                                <a class="btn btn-warning btn-sm pull-right"  style="margin-left: 5px;"
                                                 onclick='Proveedor.Fecha.ModalAbrir({TA_ID: <%= rsMPro("TA_ID").Value %>, OV_ID: <%= rsMPro("OV_ID").Value %>, Folio: "<%= rsMPro("Folio").Value %>"})'>
                                                    <i class="fa fa-calendar"></i> Cambiar Fecha
                                                </a>
<%
        }
%>
                                                <a class="btn btn-white btn-sm pull-right"
                                                 onclick='Proveedor.DetalleVer({TA_ID: <%= rsMPro("TA_ID").Value %>, OV_ID: <%= rsMPro("OV_ID").Value %>})'>
                                                    <i class="fa fa-file-text-o"></i> Ver
                                                </a>
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
        switch( parseInt(rsMPro("Est_ID").Value) ){
            case Estatus.Transito: { strEstatusColor = "info" } break; //	Tránsito
            case Estatus.PrimerIntento: case Estatus.SegundoIntento: case Estatus.TercerIntento: { strEstatusColor = "warning" } break; // 1er, 2do, 3er Intento
            case Estatus.EntregaExitosa: { strEstatusColor = "success" } break; // Entrega exitosa
            case Estatusl.FallaEntrega: { strEstatusColor = "danger" } break; // entrega fallida 
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
<%      if( rsMPro("Est_ID").Value == Estatus.EntregaExitosa ){
%>
                                                <dt>Recibio:</dt> 
                                                    <dd><%= rsMPro("ProG_Recibio").Value %></dd>
<%      }

        if( rsMPro("Est_ID").Value == Estatus.FallaEntrega || rsMPro("Est_ID").Value == Estatus.EntregaExitosa ){
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