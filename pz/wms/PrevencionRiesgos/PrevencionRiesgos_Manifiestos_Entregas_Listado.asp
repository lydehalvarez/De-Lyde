<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2021-JUL-19 Manifiesto - Entregas: Creación de archivo

var cxnTipo = 0

var rqIntMan_ID = Parametro("Man_ID", -1)
var rqBolEsTransportista = Parametro("Transportista", 0)

var bolEsTransportista = ( rqBolEsTransportista == 1 );

var strMan_Folio = "";
var dateMan_FechaRegistro = "";
var strMan_Responsable = "";
var strProv_Nombre = "";
var strTRu_Nombre = "";
var intMan_Ruta = "";
var intMan_Total_Cajas = 0;
var intMan_Total_Peso = 0;
var strEdo_Nombre = "";
var strAer_Nombre = "";
var intMan_Total_Entregas = 0;
var intMan_Total_Entregas_Pendientes = 0;
var intMan_Total_Entregas_Entregadas = 0;
var intMan_Total_Entregas_Fallidas = 0;

var intMan_Total_Precio = 0.0;

var Estatus = {
          Transito: 5
        , PrimerIntento: 6
        , SegundoIntento: 7
        , TercerIntento: 8
        , FallaEntrega: 9
        , EntregaExitosa: 10
        , AvisoDevolucion: 22
    }

var sqlMan = "EXEC SPR_PrevencionRiesgos "
      + "@Opcion = 1000 "
    + ", @Man_ID = " + ( (rqIntMan_ID > -1) ? rqIntMan_ID : "NULL" ) + " "
    

var rsMan = AbreTabla(sqlMan, 1, cxnTipo)

if( !(rsMan.EOF) ){
    strMan_Folio = rsMan("Man_Folio").Value;
    dateMan_FechaRegistro = rsMan("Man_FechaRegistro").Value;
    strMan_Responsable = rsMan("Usu_Nombre").Value;
    strProv_Nombre = rsMan("Prov_Nombre").Value;
    strTRu_Nombre = rsMan("TRu_Nombre").Value;
    intMan_Ruta = rsMan("Man_Ruta").Value;
    intMan_Total_Cajas = rsMan("Man_Total_Cajas").Value;
    intMan_Total_Peso = rsMan("Man_Total_Peso").Value;
    strEdo_Nombre = rsMan("Edo_nombre").Value;
    strAer_Nombre = rsMan("Aer_Nombre").Value;
    intMan_Total_Entregas = rsMan("Man_Total_Entregas").Value;
    intMan_Total_Entregas_Pendientes = rsMan("Man_Total_Entregas_Pendientes").Value;
    intMan_Total_Entregas_Entregadas = rsMan("Man_Total_Entregas_Entregadas").Value;
    intMan_Total_Entregas_Fallidas = rsMan("Man_Total_Entregas_Fallidas").Value;
    intMan_Total_Precio = rsMan("Man_Total_Precio").Value;
}

rsMan.Close()
%>
    <div class="ibox">
        <div class="ibox-title">
            <h5>
                <i class="fa fa-text-file-o"></i> Manifiesto: <strong class="text-danger"><%= strMan_Folio %></strong>
            </h5>
            
            <div class="ibox-tools">

                <button type="button" class="btn btn-link btn-sm" id="aPreRieManDetVer"
                 onclick="Manifiesto.Detalle.Visualizar()">
                    <i class="fa fa-caret-down"></i> Ver m&aacute;s...
                </button>

                <button type="button" class="btn btn-link btn-sm" id="aPreRieManDetOcultar" style="display: none;"
                 onclick="Manifiesto.Detalle.Ocultar()">
                    <i class="fa fa-caret-up"></i> Ocultar...
                </button>

                <button type="button" class="btn btn-success btn-sm"
                 onclick="Manifiesto.Buscador.Filtrar()">
                    <i class="fa fa-reply"></i> Regresar
                </button>
                
            </div>
        </div>
    </div>

    <div class="ibox cssPreRieManDetalle" style="display: none;">
        <div class="ibox-title">
            <h5 class="text-navy">
                <i class="fa fa-vcard-o"></i> Datos Generales
            </h5>
        </div>
        <div class="ibox-content">
            <div class="row">
                <div class="col-sm-4">
                    <dl class="dl-horizontal">
                        <dt>Fecha Registro:</dt>
                            <dd><%= dateMan_FechaRegistro %></dd>                         
                        <dt>Responsable</dt>
                            <dd><%= strMan_Responsable %></dd>
                        <dt>Cajas:</dt>
                            <dd><%= intMan_Total_Cajas %> Cajas</dd>
                        <dt>Peso</dt>
                            <dd><%= formato_numero(intMan_Total_Peso,2) %> Kgs.</dd>
                        <dt>Costo</dt>
                            <dd>$<%= formato_numero(intMan_Total_Precio,2) %></dd>
                    </dl>
                </div>
                <div class="col-sm-4">
                    <dl class="dl-horizontal">
                        <dt>Transportista:</dt>
                            <dd><%= strProv_Nombre %></dd>
                        <dt>Tipo de Ruta</dt>
                            <dd><%= strTRu_Nombre %></dd>
                        <dt>Ruta:</dt>
                            <dd><%= intMan_Ruta %></dd>
                        <dt>Estado</dt>
                            <dd><%= strEdo_Nombre %></dd>
                        <dt>Aeropuerto</dt>
                            <dd><%= strAer_Nombre %></dd>
                    </dl>
                </div>
                <div class="col-sm-4">
                    <dl class="dl-horizontal">
                        <dt>Total Entregas:</dt>
                            <dd><b><%= intMan_Total_Entregas %></b></dd>
                        <dt>Total Pendientes</dt>
                            <dd><b class="text-warning"><%= intMan_Total_Entregas_Pendientes %></b></dd>
                        <dt>Total Entregadas:</dt>
                            <dd><b class="text-success"><%= intMan_Total_Entregas_Entregadas %></b></dd>
                        <dt>Total Fallidas</dt>
                            <dd><b class="text-danger"><%= intMan_Total_Entregas_Fallidas %></b></dd>
                    </dl>
                </div>
            </div>
        </div>
    </div>
    <div class="ibox">
        <div class="ibox-title">
            <h5 class="text-navy">
                <i class="fa fa-cubes"></i> Entregas
            </h5>
            <div class="ibox-tools">
                <label class="form-group" style="margin-right: 5px;">
                    <span class="text-success" id="lblPreRieManEntLisTot">

                    </span> Registros
                </label>
            </div>
        </div>
        <div class="ibox-content">
           
<%
var sqlManEnt = "EXEC SPR_PrevencionRiesgos "
      + "@Opcion = 1100 "
    + ", @Man_ID = " + ( (rqIntMan_ID > -1) ? rqIntMan_ID : "NULL" ) + " "
    + ", @RegistrosPagina = -1 "

var rsManEnt = AbreTabla(sqlManEnt, 1, cxnTipo)
%>
            <table class="table table-hover">
                <tbody id="tbManEntLis">
<%

var strlblEstatus = "";
while(!(rsManEnt.EOF)){

    switch( parseInt(rsManEnt("Ent_Est_ID").Value) ){
        case Estatus.Transito: {
            strlblEstatus = "label-info"
        }
        case Estatus.PrimerIntento:
        case Estatus.SegundoIntento:
        case Estatus.TercerIntento: {
            strlblEstatus = "label-warning"
        } break;
        case Estatus.FallaEntrega:
        case Estatus.AvisoDevolucion: {
            strlblEstatus = "label-danger"
        } break;
        case Estatus.EntregaExitosa: {
            strlblEstatus = "label-primary"
        } break;
    }
%> 
                    <tr class="cssTrPreRieManEntLisReg">
                        <td>
                            <%= rsManEnt("ID").Value %>
                        </td>
                        <td class="project-status">
                            <label class="label <%= strlblEstatus %>">
                                <%= rsManEnt("Ent_Est_Nombre").Value %>
                            </label>
                        </td>
                        <td class="project-title">
                            <a><%= rsManEnt("Cli_Nombre").Value %></a>
                            <br>
                            <small><%= rsManEnt("Prov_Nombre") %></small>
                        </td>
                        <td class="project-title">
                            <a>
                                <span class="text-success textCopy"><%= rsManEnt("Ent_Folio").Value %></span>
                            </a>
                            <br>
                            Gu&iacute;a: <%= rsManEnt("Ent_Guia").Value %>
                            <br>
                            <small> Elaboracion: <%= rsManEnt("Ent_FechaRegistro").Value %></small>
                            <br>
                            <small> Entrega: <%= rsManEnt("Ent_FechaEntrega").Value %></small>
                        </td>
                        <td class="project-title">
<%
    if( rsManEnt("TA_ID").Value > -1 ){
%>
                            <a><%= rsManEnt("Ent_Destino_Numero").Value %> - <%= rsManEnt("Ent_Destino_Nombre").Value %></a>
                            <br>
                            <small>
                                <i class="fa fa-home"></i> <%= rsManEnt("Ent_Destino_Direccion").Value %>
                            </small>
<%
    }

    if( rsManEnt("OV_ID").Value > -1 ){
%>
                            <a><%= rsManEnt("Ent_Destino_Numero").Value %> - <%= rsManEnt("Ent_Destino_Nombre").Value %></a>
                            <br>
                            <small>Recibe: </small>
                            <small>
                                <i class="fa fa-home"></i> <%= rsManEnt("Ent_Destino_Direccion").Value %>
                            </small>
<%
    }
%>
                        </td>
                        <td class="project-title" nowrap>
                            <a>Cajas: <%= rsManEnt("Ent_Cajas_Total").Value %></a>
                            <br>
                            <a>Peso: <%= formato_numero(rsManEnt("Ent_Cajas_Peso").Value,2) %> Kgs.</a>
                            <br>
                            <a>Costo: $<%= formato_numero(rsManEnt("Ent_Total_Precio").Value,2) %> </a>
                        </td>
                        <td class="project-title">
                            <a>CP: <%= rsManEnt("Ent_Destino_CP").Value %> </a>
                            <br>
                            <a><%= rsManEnt("Ent_Destino_Estado").Value %></a>
                            <br>
                            <small><%= rsManEnt("Ent_Destino_Ciudad").Value %></small>
                        </td>
                        <td class="project-actions" width="31">
                            <a class="btn btn-white btn-sm" 
                            onclick='Entregas.Detalle.Ver({TA_ID: <%= rsManEnt("TA_ID").Value %>, OV_ID: <%= rsManEnt("OV_ID").Value %>});'>
                                <i class="fa fa-file-text-o"></i> Ver
                            </a>
                        </td>
                    </tr>
<%
    Response.Flush()
    rsManEnt.MoveNext()
}

rsManEnt.Close()
%>
                </tbody>
            </table>
        </div>
    </div>   