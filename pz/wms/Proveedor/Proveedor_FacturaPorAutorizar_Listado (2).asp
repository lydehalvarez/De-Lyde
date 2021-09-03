<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2021-MAR-30 Factura por Autorizar: Creación de archivo

var cxnTipo = 0

var rqIntGuia = Parametro("Guia", "")
var rqStrFolio = Parametro("Folio", "")
var rqStrMan_Folio = Parametro("Man_Folio", "") 
var rqIntEst_ID = Parametro("Est_ID", -1)
var rqDateFechaInicial = Parametro("FechaInicial", "")
var rqDateFechaFinal = Parametro("FechaFinal", "")
var rqIntIDUsuario = Parametro("IDUsuario", -1)
var rqIntProv_ID = Parametro("Prov_ID", -1)
var rqIntSiguienteRegistro = Parametro("SiguienteRegistro", 0)
var rqIntRegistrosPagina = Parametro("RegistrosPagina", 10)

var bolEsTransportista = ( rqIntProv_ID > -1 )

var sqlTAMan = "EXEC SPR_Proveedor_Guia "
      + "@Opcion = 1010 "
    + ", @ProG_PagoAutorizado = 0 /* No se ha autorizado */"
    + ", @Prog_NumeroGuia = " + ( (rqIntGuia.length > 0) ? "'" + rqIntGuia + "'" : "NULL" ) + " "
    + ", @Folio = " + ( (rqStrFolio.length > 0) ? "'" + rqStrFolio + "'" : "NULL" ) + " "
    + ", @Man_Folio = " + ( (rqStrMan_Folio.length > 0) ? "'" + rqStrMan_Folio + "'" : "NULL" ) + " "
    + ", @Est_IDs = '9,10,22' /* Fallido, Entrega Exitosa */ "
    + ", @FechaInicial = " + ( (rqDateFechaInicial.length > 0) ? "'" + rqDateFechaInicial + "'" : "NULL" ) + " "
    + ", @FechaFinal = " + ( (rqDateFechaFinal.length > 0) ? "'" + rqDateFechaFinal + "'" : "NULL" ) + " "
    + ", @IDUsuario = " + ( (rqIntIDUsuario > -1) ? rqIntIDUsuario : "NULL" ) + " "
    + ", @Prov_ID = " + ( (rqIntProv_ID > -1) ? rqIntProv_ID : "NULL" ) + " "
    + ", @SiguienteRegistro = " + ( (rqIntSiguienteRegistro > 0) ?  rqIntSiguienteRegistro : 0) + " "
    + ", @RegistrosPagina = " + ( (rqIntRegistrosPagina > 0) ?  rqIntRegistrosPagina : 10) + " "
    
var rsMPro = AbreTabla(sqlTAMan, 1, cxnTipo)

if( !(rsMPro.EOF) ){

    var intID = "";
    var i = 0
    while(!(rsMPro.EOF)){
        
        if( intID != rsMPro("ID").Value) {
             i = 0
%>
                    <tr>
                        <td>

                            <div class="ibox">
                                <div class="ibox-title">
                                    <button type="button" class="btn btn-white btn-sm pull-right" onClick="Proveedor.Ver({Prov_ID: <%= rsMPro("Prov_ID").Value %>, ProG_ID: <%= rsMPro("ProG_ID").Value %>})">
                                        <i class="fa fa-file-text-o"></i> Ver
                                    </button>
                                    <h2>
                                        <span class="col-sm-1">
                                            <b><%= rsMPro("ID").Value %></b>
                                        </span> Gu&iacute;a: <b class="text-danger"><%= rsMPro("Guia").Value %></b>
                                    </h2>
                                </div>
                                <div class="ibox-content">
                                   

                                    <div class="row">
                                        <div class="col-lg-5">
                                            <dl class="dl-horizontal">

                                                <dt>Transportista:</dt> 
                                                    <dd><%= rsMPro("Transportista").Value %></dd>

                                                <dt>Manifiesto:</dt> 
                                                    <dd>
                                                        <a class="text-navy"> 
                                                            <b><%= rsMPro("Man_Folio").Value %></b>
                                                        </a>
                                                    </dd>

                                                <dt>Fecha Manifiesto:</dt>
                                                    <dd><%= rsMPro("Man_FechaConfirmado").Value %></dd>
 
                                            </dl>
                                        </div>
                                        <div class="col-lg-7" id="cluster_info">
                                            <dl class="dl-horizontal">
    
                                                <dt>Fecha Compromiso:</dt>
                                                    <dd class="text-danger"><%= rsMPro("Man_FechaCompromiso").Value %></dd>

                                                <dt>Fecha Entrega:</dt>
                                                    <dd class="text-danger"><%= rsMPro("ProG_FechaEntrega").Value %></dd>
                                                
                                            </dl>
                                        </div>
                                    </div>

                                    <div class="row">
                                        

                                            <table  class="table">
                                                <thead>
                                                    <tr>
                                                        <th>#</th>
                                                        <th class="col-sm-1">Folio</th> 
                                                        <th class="col-sm-3">Direcci&oacute;n</th> 
                                                        <th class="col-sm-2">Recibe</th> 
                                                        <th class="col-sm-1">Tel&eacute;fono</th> 
                                                        <th class="col-sm-2">Recibi&oacute;</th> 
                                                        <th class="col-sm-3">Comentario</th> 
                                                    </tr>
                                                </thead>
                                                <tbody>
<%
        }
%>
                                                    <tr>
                                                        <td><%= ++i %></td>
                                                        <td nowrap><%= rsMPro("Folio").Value %></td> 
                                                        <td><%= rsMPro("Direccion").Value %></td> 
                                                        <td><%= rsMPro("Responsable").Value %></td> 
                                                        <td><%= rsMPro("Telefono").Value %></td> 
                                                        <td><%= rsMPro("ProG_Recibio").Value %></td> 
                                                        <td><%= rsMPro("ProG_Comentario").Value %></td> 
                                                    </tr>
<%
        intID = rsMPro("ID").Value

        Response.Flush()
        rsMPro.MoveNext()

        if( rsMPro.EOF || ( !(rsMPro.EOF) && intID != rsMPro("ID").Value) ) {

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
%>
                
<%
rsMPro.Close()
%>