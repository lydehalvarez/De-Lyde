<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2021-MAR-30 Factura Autorizada: Creación de archivo

var cxnTipo = 0

var rqIntGuia = Parametro("Guia", "")
var rqStrFolio = Parametro("Folio", "")
var rqStrMan_Folio = Parametro("Man_Folio", "") 
var rqDateFechaInicial = Parametro("FechaInicial", "")
var rqDateFechaFinal = Parametro("FechaFinal", "")
var rqIntIDUsuario = Parametro("IDUsuario", -1)
var rqIntProv_ID = Parametro("Prov_ID", -1)
var rqIntSiguienteRegistro = Parametro("SiguienteRegistro", 0)
var rqIntRegistrosPagina = Parametro("RegistrosPagina", 10)

var bolEsTransportista = ( rqIntProv_ID > -1 )

var sqlTAMan = "EXEC SPR_Proveedor_Guia "
      + "@Opcion = 1010 "
    + ", @Prog_NumeroGuia = " + ( (rqIntGuia.length > 0) ? "'" + rqIntGuia + "'" : "NULL" ) + " "  
    + ", @Folio = " + ( (rqStrFolio.length > 0) ? "'" + rqStrFolio + "'" : "NULL" ) + " "
    + ", @Man_Folio = " + ( (rqStrMan_Folio.length > 0) ? "'" + rqStrMan_Folio + "'" : "NULL" ) + " "
    + ", @Est_IDs = '9,10,22' /* Fallido, Entrega Exitosa */ "
    + ", @FechaInicial = " + ( (rqDateFechaInicial.length > 0) ? "'" + rqDateFechaInicial + "'" : "NULL" ) + " "
    + ", @FechaFinal = " + ( (rqDateFechaFinal.length > 0) ? "'" + rqDateFechaFinal + "'" : "NULL" ) + " "
    + ", @IDUsuario = " + ( (rqIntIDUsuario > -1) ? rqIntIDUsuario : "NULL" ) + " "
    + ", @Prov_ID = " + ( (rqIntProv_ID > -1) ? rqIntProv_ID : "NULL" ) + " "
    + ", @ProG_PagoAutorizado = 1 /* Se ha autorizado */"
    + ", @ProG_EstatusPagoCG89 = -1 /* Sin estatus */ "
    + ", @SiguienteRegistro = " + ( (rqIntSiguienteRegistro > 0) ?  rqIntSiguienteRegistro : 0) + " "
    + ", @RegistrosPagina = " + ( (rqIntRegistrosPagina > 0) ?  rqIntRegistrosPagina : 10) + " "

var rsMPro = AbreTabla(sqlTAMan, 1, cxnTipo)

if( !(rsMPro.EOF) ){

    var i = 0;
    var intID = ""
    
    while( !(rsMPro.EOF) ){
        
        if( intID != rsMPro("ID").Value ){
            i = 0
%>
                        <tr>
                            <td>
                                <input type="checkbox" class="cssTodos cssDocumentos" onclick="Proveedor.DocumentoSeleccionar()"
                                 data-prov_id="<%= rsMPro("Prov_ID").Value %>"
                                 data-guia="<%= rsMPro("Guia").Value %>">
                            </td>
                            <td>
                                <h2><%= rsMPro("ID").Value %></h2>
                            </td>
                            <td colspan="3">
                                <h2>
                                    Guia: <span class="text-danger" style="font-weight: bold;"><%= rsMPro("Guia").Value %></span>
                                </h2>
                            </td>
                            <td>
                                <label class="label label-success"><%= rsMPro("ProG_Est_Nombre").Value %></label>
                            </td>
                            <td>
                                <a id="a_Doc_Ver_<%= rsMPro("ID").Value %>" class="btn btn-info btn-sm pull-right" 
                                 onClick="Proveedor.EntregasVer(<%= rsMPro("ID").Value %>, true);">
                                    <i class="fa fa-plus-square-o"></i> Ver Entregas
                                </a>
                                <a id="a_Doc_Ocultar_<%= rsMPro("ID").Value %>" class="btn btn-danger btn-sm pull-right" style="display: none;"
                                 onClick="Proveedor.EntregasVer(<%= rsMPro("ID").Value %>, false);">
                                    <i class="fa fa-minus-square-o"></i> Ocultar Entregas
                                </a>
                            </td>
                            <td>
                                <a class="btn btn-white btn-sm pull-right" onClick="Proveedor.Ver({Prov_ID: <%= rsMPro("Prov_ID").Value %>, ProG_ID: <%= rsMPro("ProG_ID").Value %>})">
                                    <i class="fa fa-file-text-o"></i> Ver
                                </a>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">&nbsp;</td>
                            <td class="project-title">
                                <a><%= rsMPro("FechaEntrega").Value %></a>
                                <br>
                                <small>Fecha Entrega</small>
                            </td>
                            <td class="project-title">
                                <a><%= rsMPro("Transportista").Value %></a> 
                                <br>
                                <small>Transportista</small>
                            </td>
                            <td class="project-title">
                                <a><%= rsMPro("ProG_Recibio").Value %></a>
                                <br>
                                <small>Usuario que recibi&oacute;</small>
                            </td>
                            <td class="project-title">
                                <a><%= rsMPro("ProG_Comentario").Value %></a>
                                <br>
                                <small>Comentario</small>
                            </td>
                            <td class="project-title"></td>
                        </tr>
                        <tr id="tr_Doc_<%= rsMPro("ID").Value %>" style="display: none;">
                            <td colspan="8">
                                <table class="table table-hover" border="1">
                                    <thead>
                                        <tr>
                                            <th>#</th>
                                            <th>Folio</th>
                                            <th>Fecha Salida</th>
                                            <th>Entrega</th>
                                            <th>Responsable</th>
                                        </tr>
                                    </thead>
                                    <tbody>
<%
        }
%>
                                        <tr>
                                            <td><%= ++i %></td>
                                            
                                            <td><%= rsMPro("Man_Folio").Value %></td> 
                                            <td>
                                                <i class="fa fa-clock-o"></i> <%= rsMPro("Man_FechaConfirmado").Value %>
                                            </td>
                                            <td class="project-title" >
                                                <a><%= rsMPro("Folio").Value %></a>
                                                <br>
                                                <small>
                                                    <%= rsMPro("Almacen").Value %>
                                                </small>
                                            </td>
                                            <td class="project-title">
                                                <a><%= rsMPro("Responsable").Value %></a>
                                                <br>
                                                <small>
                                                    <%= rsMPro("Telefono").Value %>
                                                </small>
                                            </td>
                                        </tr>
<%
        intID = rsMPro("ID").Value
        Response.Flush();
        rsMPro.MoveNext()

        if( rsMPro.EOF || ( !(rsMPro.EOF) && intID != rsMPro("ID").Value ) ){
%>
                                    </tbody>
                                </table>
                            </td>
                        </tr>

<% 
        }
    }

}

rsMPro.Close()
%>