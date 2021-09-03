<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2021-JUL-19 Manifiesto: Creación de archivo

var cxnTipo = 0;

var rqIntMan_Prov_ID = Parametro("Man_Prov_ID", -1);

var rqStrMan_Guia = Parametro("Man_Guia", "");
var rqStrMan_Folio = Parametro("Man_Folio", "");
var rqDateMan_FechaInicial = Parametro("Man_FechaInicial", "");
var rqDateMan_FechaFinal = Parametro("Man_FechaFinal", "");
var rqIntMan_Edo_ID = Parametro("Man_Edo_ID", -1);
var rqIntMan_TpL_ID = Parametro("Man_TpL_ID", -1);

var rqStrEnt_Guia = Parametro("Ent_Guia", "");
var rqStrEnt_Folio = Parametro("Ent_Folio", "");
var rqIntEnt_Est_ID = Parametro("Ent_Est_ID", -1);

var rqIntIDUsuario = Parametro("IDUsuario", -1)
var rqIntSiguienteRegistro = Parametro("SiguienteRegistro", 0) ;
var rqIntRegistrosPagina = Parametro("RegistrosPagina", 10);
var rqBolTransportista = Parametro("Transportista", 0);

var bolEsTransportista = ( rqBolTransportista == 1 )

var Estatus = {
          Transito: 5
        , PrimerIntento: 6
        , SegundoIntento: 7
        , TercerIntento: 8
        , FallaEntrega: 9
        , EntregaExitosa: 10
        , AvisoDevolucion: 22
    }

var sqlMan = "EXEC SPR_Manifiesto_Monitoreo "
      + "@Opcion = 1000 "
    + ", @Man_Prov_ID = " + ( (rqIntMan_Prov_ID > -1) ? rqIntMan_Prov_ID : "NULL" ) + " "
    + ", @Man_Guia = " + ( (rqStrMan_Guia.length > 0) ? "'" + rqStrMan_Guia + "'" : "NULL" ) + " "
    + ", @Man_Folio = " + ( (rqStrMan_Folio.length > 0) ? "'" + rqStrMan_Folio + "'" : "NULL" ) + " "
    + ", @Man_FechaInicial = " + ( (rqDateMan_FechaInicial.length > 0) ? "'" + rqDateMan_FechaInicial + "'" : "NULL" ) + " "
    + ", @Man_FechaFinal = " + ( (rqDateMan_FechaFinal.length > 0) ? "'" + rqDateMan_FechaFinal + "'" : "NULL" ) + " "
    + ", @Man_Edo_ID = " + ( (rqIntMan_Edo_ID > -1) ? rqIntMan_Edo_ID : "NULL" ) + " "
    + ", @Man_TpL_ID = " + ( (rqIntMan_TpL_ID > -1) ? rqIntMan_TpL_ID : "NULL" ) + " "
    + ", @Ent_Guia = " + ( (rqStrEnt_Guia.length > 0) ? "'" + rqStrEnt_Guia + "'" : "NULL" ) + " "
    + ", @Ent_Folio = " + ( (rqStrEnt_Folio.length > 0) ? "'" + rqStrEnt_Folio + "'" : "NULL" ) + " "
    + ", @Ent_Est_ID = " + ( (rqIntEnt_Est_ID > -1) ? rqIntEnt_Est_ID : "NULL" ) + " "
    + ", @IDUsuario = " + ( (rqIntIDUsuario > -1) ? rqIntIDUsuario : "NULL" ) + " "  
    + ", @SiguienteRegistro = " + ( (rqIntSiguienteRegistro > 0) ?  rqIntSiguienteRegistro : 0) + " "
    + ", @RegistrosPagina = " + ( (rqIntRegistrosPagina > 0) ?  rqIntRegistrosPagina : 10) + " "

var rsMan = AbreTabla(sqlMan, 1, cxnTipo)
%>
     <div class="ibox">
        <div class="ibox-title">
            <h5>Resultados</h5>
            <div class="ibox-tools">

                <label class="pull-right form-group">
                    <span class="text-success" id="lblPrvManLisTot">

                    </span> Registros
                </label>

            </div>
        </div>
        <div class="ibox-content">
            <table class="table table-hover">
                <tbody id="tbPrvManLis">
<%
while(!(rsMan.EOF)){
%> 
                    <tr class="cssTrPrvManLisReg">
                        <td>
                            <%= rsMan("ID").Value %>
                        </td>
                        <td class="project-title">
                            <h3 class="textCopy text-danger">
                                <%= rsMan("Man_Folio").Value %>
                            </h3>
                            <small title="Fecha de Creaci&oacute;n de Manifiesto">
                                <i class="fa fa-clock-o"></i> <%= rsMan("Man_FechaRegistro").Value %>
                            </small>
<%  if( !(bolEsTransportista) ) {
%>
                            <br>
                            <small title="Usuario que cre&oacute; el Manifiesto">
                                <i class="fa fa-user"></i> <%= rsMan("Usu_Nombre").Value %>
                            </small>
<%  }
%>
                        </td>
                        <td class="project-title">
<%  if( !(bolEsTransportista) ) {
%>
                            <a title="Transportista">
                                <i class="fa fa-truck"></i> <%= rsMan("Prov_Nombre").Value %>
                            </a>
                            <br>
<%  }
%>
                            <a title="Tipo de Ruta">
                                <i class="fa fa-bolt"></i> &nbsp;<%= rsMan("TRu_Nombre").Value %>
                            </a>
                            <br>
                            <small title="Ruta">
                                <i class="fa fa-map-signs"></i> &nbsp;<%= rsMan("Man_Ruta").Value %>
                            </small>
                        </td>
                        <td class="project-title">
                            <a>
                                <i class="fa fa-cubes"></i> <%= formato_numero(rsMan("Man_Total_Cajas").Value, 0) %> Cajas.
                            </a>
                            <br>
                            <a>
                                <i class="fa fa-tachometer"></i> <%= formato_numero(rsMan("Man_Total_Peso").Value, 2) %> Kgs.
                            </a>
                        </td>
                        <td class="project-title">
                            <a title="Estado">
                                <i class="fa fa-globe"></i> <%= rsMan("Edo_Nombre").Value %></a>
                            <br>
                            <small title="Aeropuerto">
                                <i class="fa fa-plane"></i> <%= rsMan("Aer_Nombre").Value %>
                            </small>
                        </td>
                        <td class="project-title">
                            <small>
                                <i class="fa fa-cube "></i>&nbsp;
                                Total: <b><%= rsMan("Man_Total_Entregas").Value %></b>
                            </small>
                            <br>
                            <small>
                                <i class="fa fa-exclamation-circle text-warning"></i>&nbsp;
                                Pendientes: <b class="text-warning"><%= rsMan("Man_Total_Entregas_Pendientes").Value %></b>
                            </small>
                            <br>
                            <small>
                                <i class="fa fa-check-circle-o text-success"></i>&nbsp;
                                Entregados: <b class="text-success"><%= rsMan("Man_Total_Entregas_Entregadas").Value %></b>
                            </small>
                            <br>
                            <small>
                                <i class="fa fa-times-circle-o text-danger"></i>&nbsp;
                                Fallidos: <b class="text-danger"><%= rsMan("Man_Total_Entregas_Fallidas").Value %></b>
                            </small>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="8" class="project-actions">                    

<%  if(  rsMan("Man_HayDocumentos").Value == 1 ){
%>
                            <a id="btnManDocVisualizar" class="btn btn-link btn-xs" title="Ver Documentos"
                            onclick='Manifiesto.Documentos.Listado.Cargar({Man_ID: <%= rsMan("Man_ID").Value %>, Objeto: $(this)})'>
                                <i class="fa fa-files-o"></i> Ver Documentos Manifiesto
                            </a>
                            <a id="btnManDocOcultar" class="btn btn-link btn-xs" title="Ocultar Documentos" style="display: none;"
                            onclick='Manifiesto.Documentos.Listado.Remover({Man_ID: <%= rsMan("Man_ID").Value %>, Objeto: $(this)})'>
                                <i class="fa fa-files-o"></i> Ocultar Documentos Manifiesto
                            </a> | 
<%  }

    if(  rsMan("Man_HayGuias").Value == 1 ){
%>
                            <a id="btnManGuiaVisualizar" class="btn btn-link btn-xs" title="Ver Gu&iacute;as"
                            onclick='Manifiesto.Guias.Listado.Cargar({Man_ID: <%= rsMan("Man_ID").Value %>, Objeto: $(this)})'>
                                <i class="fa fa-id-card-o"></i> Ver Guias Manifiesto
                            </a>
                            <a id="btnManGuiaOcultar" class="btn btn-link btn-xs" title="Ocultar Gu&iacute;as" style="display: none;"
                            onclick='Manifiesto.Guias.Listado.Remover({Man_ID: <%= rsMan("Man_ID").Value %>, Objeto: $(this)})'>
                                <i class="fa fa-id-card-o"></i> Ocultar Guias Manifiesto
                            </a> | 
                            
<%  }

    if( rsMan("Man_HaySenuelos").Value == 1 && !(bolEsTransportista) ){
%>
                        
                            <a id="btnManSenuelosVisualizar" class="btn btn-link btn-xs" title="Ver Se&ntilde;uelos"
                            onclick='Manifiesto.Senuelos.Listado.Cargar({Man_ID: <%= rsMan("Man_ID").Value %>, Objeto: $(this)})'>
                                <i class="fa fa-wifi"></i> Ver Se&ntilde;uelos
                            </a>
                            <a id="btnManSenuelosOcultar" class="btn btn-link btn-xs" title="Ocultar Se&ntilde;uelos" style="display: none;"
                            onclick='Manifiesto.Senuelos.Listado.Remover({Man_ID: <%= rsMan("Man_ID").Value %>, Objeto: $(this)})'>
                                <i class="fa fa-wifi"></i> Ocultar Se&ntilde;uelos
                            </a> | 
                        
<%  
    }

    if(  rsMan("Ent_HayDocumentos").Value == 1 ){
%>
                            <a id="btnEntDocVisualizar" class="btn btn-link btn-xs" title="Ver Documentos"
                            onclick='Entregas.Documentos.Listado.Cargar({Man_ID: <%= rsMan("Man_ID").Value %>, Objeto: $(this)})'>
                                <i class="fa fa-archive"></i> Ver Documentos Entregas
                            </a>
                            <a id="btnEntDocOcultar" class="btn btn-link btn-xs" title="Ocultar Documentos" style="display: none;"
                            onclick='Entregas.Documentos.Listado.Remover({Man_ID: <%= rsMan("Man_ID").Value %>, Objeto: $(this)})'>
                                <i class="fa fa-archive"></i> Ocultar Documentos Entregas
                            </a> | 
<%  }
%>                          
                            <a class="btn btn-link btn-xs" title="Ver"
                             onclick='Entregas.Listado.Cargar({Man_ID: <%= rsMan("Man_ID").Value %>});'>
                                <i class="fa fa-file-text-o"></i> Ver Entregas del manifiesto
                            </a>

                        </td>
                    </tr>
<%
    Response.Flush()
    rsMan.MoveNext()
}

rsMan.Close()
%>
                </tbody>
                <tfoot>
                    <tr>
                        <td id="tfPrvManLisCar" colspan="9">
                        
                        </td>
                    </tr>
                </tfoot>
            </table>
        </div>
    </div>   