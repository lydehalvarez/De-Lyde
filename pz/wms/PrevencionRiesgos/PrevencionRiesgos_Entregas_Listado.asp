<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2021-JUL-29 Prevencion de Riesgos - Entregas - Listado: Creación de Archivo
// HA ID: 2 2021-AGO-04 Ajustes: Agregado de Filtro

var cxnTipo = 0;

var rqStrEnt_Folio = Parametro("Ent_Folio", "");
var rqStrMan_Folio = Parametro("Man_Folio", "");
var rqStrEnt_FolioCliente = Parametro("Ent_FolioCliente", "");
var rqStrEnt_Guia = Parametro("Ent_Guia", "");
var rqIntEnt_Est_ID = Parametro("Ent_Est_ID", -1);
var rqIntCli_ID = Parametro("Cli_ID", -1);
var rqDateEnt_FechaInicial = Parametro("Ent_FechaInicial", "");
var rqDateEnt_FechaFinal = Parametro("Ent_FechaFinal", "");
var rqStrEnt_Remision = Parametro("Ent_Remision", "");
var rqIntMan_Prov_ID = Parametro("Man_Prov_ID", -1)                         /* HA ID: 2 Agregado de Filtro Man_Prov_ID */

var rqIntIDUsuario = Parametro("IDUsuario", -1)
var rqIntSiguienteRegistro = Parametro("SiguienteRegistro", 0);
var rqIntRegistrosPagina = Parametro("RegistrosPagina", 10);

var Entrega = {
        Estatus: {
            Transito: 5
            , PrimerIntento: 6
            , SegundoIntento: 7
            , TercerIntento: 8
            , FallaEntrega: 9
            , EntregaExitosa: 10
            , AvisoDevolucion: 22
        }
    }

/* HA ID: 2 Agregado de Filtro Man_prov_ID */
var sqlPreRieEnt = "EXEC SPR_PrevencionRiesgos "
      + "@Opcion = 1100 "
    + ", @Ent_Folio = " + ( (rqStrEnt_Folio.length > 0) ? "'" + rqStrEnt_Folio + "'" : "NULL" ) + " "
    + ", @Man_Folio = " + ( (rqStrMan_Folio.length > 0) ? "'" + rqStrMan_Folio + "'" : "NULL" ) + " "
    + ", @Ent_FolioCliente = " + ( (rqStrEnt_FolioCliente.length > 0) ? "'" + rqStrEnt_FolioCliente + "'" : "NULL" ) + " "
    + ", @Ent_Guia = " + ( (rqStrEnt_Guia.length > 0) ? "'" + rqStrEnt_Guia + "'" : "NULL" ) + " "
    + ", @Ent_Est_ID = " + ( (rqIntEnt_Est_ID > -1) ? rqIntEnt_Est_ID : "NULL" ) + " "
    + ", @Cli_ID = " + ( (rqIntCli_ID > -1) ? rqIntCli_ID : "NULL" ) + " "  
    + ", @Ent_FechaInicial = " + ( (rqDateEnt_FechaInicial.length > 0) ? "'" + rqDateEnt_FechaInicial + "'" : "NULL" ) + " "
    + ", @Ent_FechaFinal = " + ( (rqDateEnt_FechaFinal.length > 0) ? "'" + rqDateEnt_FechaFinal + "'" : "NULL" ) + " "
    + ", @Ent_Remision = " + ( (rqStrEnt_Remision.length > 0) ? "'" + rqStrEnt_Remision + "'" : "NULL" ) + " "
    + ", @Man_Prov_ID = " + ( (rqIntMan_Prov_ID > -1) ? rqIntMan_Prov_ID : "NULL" ) + " " 
    + ", @IDUsuario = " + ( (rqIntIDUsuario > -1) ? rqIntIDUsuario : "NULL" ) + " "  
    + ", @SiguienteRegistro = " + ( (rqIntSiguienteRegistro > 0) ?  rqIntSiguienteRegistro : 0) + " "
    + ", @RegistrosPagina = " + ( (rqIntRegistrosPagina > 0) ?  rqIntRegistrosPagina : 10) + " "

var rsPreRieEnt = AbreTabla(sqlPreRieEnt, 1, cxnTipo)
%>
     <div class="ibox">
        <div class="ibox-title">
            <h5>Entregas</h5>
            <div class="ibox-tools">

                <label class="pull-right form-group">
                    <span class="text-success" id="lblPreRieEntLisTot">

                    </span> Registros
                </label>

            </div>
        </div>
        <div class="ibox-content">
            <table class="table table-hover">
                <tbody id="tbPreRieEntLis">
<%
var strlabel = "";

while(!(rsPreRieEnt.EOF)){

    switch( parseInt(rsPreRieEnt("Ent_Est_ID").Value) ){
        case Entrega.Estatus.Transito: { 
            strlabel = "info" 
        } break;
        case Entrega.Estatus.PrimerIntento: 
        case Entrega.Estatus.SegundoIntento: 
        case Entrega.Estatus.TercerIntento: { 
            strlabel = "warning" 
        } break; 
        case Entrega.Estatus.EntregaExitosa: { 
            strlabel = "success" 
        } break;
        case Entrega.Estatus.FallaEntrega: 
        case Entrega.Estatus.AvisoDevolucion: { 
            strlabel = "danger" 
        } break;
    }
%> 
                    <tr class="cssTrPreRieEntLisReg">
                        <td>
                            <%= rsPreRieEnt("ID").Value %>
                        </td>
                        <td class="project-title">
                            <a>
                                <%= rsPreRieEnt("Cli_Nombre").Value %>
                            </a>
                            <br>
                            <label class="label label-<%= strlabel %>">
                                <%= rsPreRieEnt("Ent_Est_Nombre").Value %>
                            </label>
                            <br>
                            <small>
                                
                            </small>
                        </td>
                        <td class="project-title">
                            <a>
                                <i class="fa fa-truck"></i> <span class="textCopy"><%= rsPreRieEnt("Ent_Folio").Value %></span>
                            </a>
                            <br>
                            <span class="textCopy" title="Folio Cliente"><%= rsPreRieEnt("Ent_FolioCliente").Value %></span>
                            <br>
                            <small>
                                Registro: <%= rsPreRieEnt("Ent_FechaRegistro").Value %>
                                <br>
                                Elaboracion: <%= rsPreRieEnt("Ent_FechaRegistro").Value %>
                            </small>
                        </td>
                        <td class="project-title">
                            <a title="Manifiesto">
                                <i class="fa fa-file-text-o"></i> <span class="textCopy"><%= rsPreRieEnt("Man_Folio").Value %></span>
                            </a>
                            <br>
                            <span class="textCopy" title="Gu&iacute;a Entrega"><%= rsPreRieEnt("Ent_Guia").Value %></span>
                            <br>
                            <small>
                                Transportista: <%= rsPreRieEnt("Prov_Nombre").Value %>
                            </small>
                        </td>
                        <td class="project-title">
                            <a>
                                <%= rsPreRieEnt("Ent_Destino_Estado").Value %>
                            </a>
                            <br>
                            <small>
                                <%= rsPreRieEnt("Ent_Destino_Ciudad").Value %>
                            </small>
                        </td>
                        <td class="project-title">
                            <a>
                                $<%= formato_numero(rsPreRieEnt("Ent_Total_Precio").Value, 2) %>
                            </a>
                            <br>
                            <small>
                                Costo Total
                            </small>
                        </td>
                        <td class="project-title">
                            <a class="btn btn-white btn-sm" 
                             onclick='Entrega.Detalle.Ver({TA_ID: <%= rsPreRieEnt("TA_ID").Value %>, OV_ID: <%= rsPreRieEnt("OV_ID").Value %>})'>
                                <i class="fa fa-file-text-o"></i> Ver
                            </a>
                        </td>
                    </tr>
<%
    Response.Flush()
    rsPreRieEnt.MoveNext()
}

rsPreRieEnt.Close()
%>
                </tbody>
                <tfoot>
                    <tr>
                        <td id="tfPreRieEntLisCar" colspan="9">
                        
                        </td>
                    </tr>
                </tfoot>
            </table>
        </div>
    </div>   