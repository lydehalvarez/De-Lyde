<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2020-DIC-10 Devolucion Decision: Archivo Nuevo

var cxnTipo = 0
var rqStrTarea = Parametro("Tarea", -1)

switch( parseInt( rqStrTarea ) ){

    //Modal de Cancelar Devolución
    case 500: {
%>
    <div class="modal fade" id="mdlManDCancelacion" tabindex="-1" role="dialog" aria-labelledby="divManDCancelacion" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close" onclick="ManifiestoDevolucion.DecisionCancelacionModalCerrar();">
                        <span aria-hidden="true">&times;</span>
                    </button>
                    <h2 class="modal-title" id="divManDCancelacion">
                        <i class="fa fa-map-marker"></i> Manifiesto - Cancelaci&oacute;n
                        <br />
                        <small>Cancelaci&oacute;n de Transferencias u Ordenes de Venta del Manifiesto </small>
                    </h2>
                    
                </div>
                <div class="modal-body">

                    <input type="hidden" id="hidMdlManDTA_ID" value="">
                    <input type="hidden" id="hidMdlManDOV_ID" value="">

                    <div class="form-group row">
                        
                        <label class="col-sm-2 control-label">Motivo: </label>
                        <div class="col-sm-10">
                            <textarea id="txaMdlManDMotivoCancelacion" class="form-control" placeholder="Motivo de cancelaci&oacute;n" 
                             autocomplete="off"></textarea>
                        </div>
                            
                    </div>
                    
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary btn-seg" data-dismiss="modal" onclick="ManifiestoDevolucion.DecisionCancelacionModalCerrar();">
                        <i class="fa fa-times"></i> Cerrar
                    </button>
                    <button type="button" class="btn btn-primary btn-seg" onclick="ManifiestoDevolucion.DecisionCancelar();">
                        <i class="fa fa-times"></i> Cancelar
                    </button>
                </div>
            </div>
        </div>
    </div>
<%
    } break;

     //Listado de Transferencias Y Ordenes de Venta de Manifiestos de Devolucion
    case 1100: {

        var rqStrFolio = Parametro("Folio", "")
        var rqIntProv_ID = Parametro("Prov_ID", -1)
        var rqDateFechaInicial = Parametro("FechaInicial", "")
        var rqDateFechaFinal = Parametro("FechaFinal", "")
        var rqStrManifiestoFolio = Parametro("ManifiestoFolio", "")
        var rqIntCli_ID = Parametro("Cli_ID", -1)

        var sqlDevDes = "EXEC SPR_Manifiesto_Devolucion "
              + "@Opcion = 1100 "
            + ", @FolioGeneral = " + ( (rqStrFolio.length > 0) ? "'" + rqStrFolio + "'" : "NULL" ) + " "
            + ", @Prov_ID = " + ( (rqIntProv_ID > -1 ) ? rqIntProv_ID : "NULL" ) + " "
            + ", @FechaInicial = " + ( (rqDateFechaInicial.length > 0 ) ? "'" + rqDateFechaInicial + "'" : "NULL" ) + " "
            + ", @FechaFinal = " + ( (rqDateFechaFinal.length > 0 ) ? "'" + rqDateFechaFinal + "'" : "NULL" ) + " "
            + ", @Cli_ID = " + ( (rqIntCli_ID > -1 ) ? rqIntCli_ID : "NULL" ) + " "
            + ", @ManD_Folio = " + ( ( rqStrManifiestoFolio.length > 0 ) ? "'" + rqStrManifiestoFolio + "'" : "NULL" ) + " "

        var rsDevDes = AbreTabla(sqlDevDes, 1 ,cxnTipo)
%>
    <div class="ibox">
        <div class="ibox-title">
            <h4>Resultados de la B&uacute;squeda</h4>
        </div>
        <div class="ibox-content">
            <table width="100%">
                <thead>
                    <tr>
                        <th>Devoluciones</th>
                    </tr>
                </thead>
                <tbody>
<%
        if( !(rsDevDes.EOF) ){
            
            while( !(rsDevDes.EOF) ){
%>
                    <tr>
                        <td>
                            <div class="ibox">
                                <div class="ibox-title">
                                    <h5 class="text-success">
                                        <%= rsDevDes("IDE_Folio").Value %>
                                    </h5>

                                    <div class="ibox-tools">
                                        <a class="btn btn-white btn-sm" style="color: black;" type="button" onclick='ManifiestoDevolucion.DetalleCargar({TA_ID: <%= rsDevDes("TA_ID").Value %>, OV_ID: <%= rsDevDes("OV_ID").Value %>});'>
                                            <i class="fa fa-file-text-o fa-lg"></i> Ver
                                        </a>

                                        <a class="btn btn-info btn-sm" style="color: white;" type="button" title="Reenviar" onclick='ManifiestoDevolucion.DecisionIngresar({TA_ID: <%= rsDevDes("TA_ID").Value %>, OV_ID: <%= rsDevDes("OV_ID").Value %>})'>
                                            <i class="fa fa-share"></i> Reenviar
                                        </a>
<%
                if(  rsDevDes("OV_ID").Value > -1 && rsDevDes("Cli_ID").Value == 2 ){
%>
                                        <a class="btn btn-danger btn-sm" style="color: white;" title="Cancelar" onclick='ManifiestoDevolucion.DecisionFallidoEnviar({OV_ID: <%= rsDevDes("OV_ID").Value %>})'>
                                            <i class="fa fa-times"></i> Enviar Fallido
                                        </a>
<%
                } else {
%>
                                        <a class="btn btn-danger btn-sm" style="color: white;" title="Cancelar" onclick='ManifiestoDevolucion.DecisionCancelacionModalAbrir({TA_ID: <%= rsDevDes("TA_ID").Value %>, OV_ID: <%= rsDevDes("OV_ID").Value %>})'>
                                            <i class="fa fa-times"></i> Cancelar
                                        </a>
<%             
                }
%>
                                    </div>
                                </div>
                                <div class="ibox-content">
                                    <table width="100%">
                                        <tr>
                                            <td class="col-6-sm" style="vertical-align: top;">
                                                <b class="text-danger"><%= rsDevDes("Cli_Nombre").Value %></b>
                                                <br>
                                                Destino: <b><%= rsDevDes("IDE_Nombre_Destino").Value %></b>
                                            </td>
                                            <td class="col-6-sm">
                                                <h3 class="text-danger">
                                                    <%= rsDevDes("ManD_Folio").Value %>
                                                </h3>
                                                <i class="fa fa-calendar"></i> Solicitud: <b class="text-success"><%= rsDevDes("IDE_FechaSolicitud").Value %></b>
                                                <br>
                                                <i class="fa fa-calendar"></i> Salida: <b class="text-info"><%= rsDevDes("IDE_FechaSalida").Value %></b>
                                                <br>
                                                <i class="fa fa-calendar"></i> Devoluci&oacute;n: <b class="text-danger"><%= rsDevDes("IDE_FechaDevolucion").Value %></b>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td colspan="2">
                                                <small>
                                                    <i class="fa fa-truck"></i> Proveedor: <b><%= rsDevDes("Prov_Nombre").Value %></b>
                                                    &nbsp;
                                                    <i class="fa fa-tag"></i> Guia: <b><%= rsDevDes("IDE_Guia").Value %></b>
                                                </small>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </div>                            
                        </td>
                    </tr>
<%
                rsDevDes.MoveNext()
            }
        } else {
%>
                    <tr>
                        <td colspan="6">
                            <i class="fa fa-exclamation-circle text-success"></i> No hay registros
                        </td>
                    </tr>
<%
        }
%>
                </tbody>
            </table>
        </div>
    </div>
<%
        rsDevDes.Close()

    } break;

    //Detalle del Manifiesto Transferencia u Orden de Venta
    case 1110:{
        
        var rqIntTA_ID = Parametro("TA_ID", -1)
        var rqIntOV_ID = Parametro("OV_ID", -1)

        var sqlManDDet = "EXEC SPR_Manifiesto_Devolucion "
              + "@Opcion = 1110 "
            + ", @TA_ID = " + ( ( rqIntTA_ID > -1 ) ? rqIntTA_ID : "NULL" ) + " "
            + ", @OV_ID = " + ( ( rqIntOV_ID > -1 ) ? rqIntOV_ID : "NULL" ) + " "

        var rsManDDet = AbreTabla(sqlManDDet, 1 ,cxnTipo)
%>
    <div class="ibox">
<%
        if( !(rsManDDet.EOF) ){
%>
        <div class="ibox-title">
            <h2 class="text-success"><i class="fa fa-file-text-o lg"></i> <%= rsManDDet("IDE_Folio").Value %></H2>
        </div>
        <div class="ibox-content">
            <h3 class="text-warning"><%= rsManDDet("Cli_Nombre").Value %></h3>
            <div class="row ">
                <div class="col-sm-12">
                    <span class="col-form-label">Orien</span>
                    <div class="font-bold">
                        <%= rsManDDet("IDE_Nombre_Origen").Value %>
                    </div>
                    <span class="col-form-label">Destino</span>
                    <div class="font-bold">
                        <%= rsManDDet("IDE_Nombre_Destino").Value %>
                    </div>

                    <div class="hr-line-solid"></div>

                    <span class="col-form-label">Estatus</span>
                    <div class="font-bold">
                        <%= rsManDDet("IDE_Estatus").Value %>
                    </div>
                    <span class="col-form-label">Tipo</span>
                    <div class="font-bold">
                        <%= rsManDDet("IDE_Tipo").Value %>
                    </div>

                    <div class="hr-line-solid"></div>

                    <span class="col-form-label">Direcci&oacute;n</span>
                    <div class="font-bold">
                        <%= rsManDDet("IDE_Direccion").Value %>
                    </div>
                    <span class="col-form-label">Tel&eacute;fono</span>
                    <div class="font-bold">
                        <%= rsManDDet("IDE_Telefono").Value %>
                    </div>
                    <span class="col-form-label">Responsable</span>
                    <div class="font-bold">
                        <%= rsManDDet("IDE_Responsable").Value %>
                    </div>

                    <div class="hr-line-solid"></div>

                    <span class="col-form-label">Transportista</span>
                    <div class="font-bold">
                        <%= rsManDDet("IDE_Transportista").Value %>
                    </div>
                    <span class="col-form-label">Gu&iacute;a</span>
                    <div class="font-bold">
                        <%= rsManDDet("IDE_Guia").Value %>
                    </div>
                    <span class="col-form-label">Remisi&oacute;n</span>
                    <div class="font-bold">
                        <%= rsManDDet("IDE_Remision").Value %>
                    </div>
                    <span class="col-form-label">Hoja de Ruta</span>
                    <div class="font-bold">
                        <%= rsManDDet("IDE_HojaRuta").Value %>
                    </div>

                    <div class="hr-line-solid"></div>

                    <span class="col-form-label">Fec. Entrega</span>
                    <div class="font-bold">
                        <%= rsManDDet("IDE_FechaEntrega").Value %>
                    </div>
                    <span class="col-form-label">Fec. Registro</span>
                    <div class="font-bold">
                        <%= rsManDDet("IDE_FechaRegistro").Value %>
                    </div>
                    <span class="col-form-label">Fec. Elaboraci&oacute;n</span>
                    <div class="font-bold">
                        <%= rsManDDet("IDE_FechaElaboracion").Value %>
                    </div>
                </div>
            </div>
        </div>
<%
        } else {
%>
        <div class="ibox-content">
            <i class="fa fa-exclamation-circle-o"></i> No hay informaci&oacute;n
        </div>
<%
        }
%>
        
    </div>
<%
        rsManDDet.Close()

    } break;

    //Decisión Cancelar
    case 3200: {

        var rqIntTA_ID = Parametro("TA_ID", -1)
        var rqIntOV_ID = Parametro("OV_ID", -1)
        var rqStrMotivoCancelacion = Parametro("MotivoCancelacion", "")
        var rqIntIDUsuario = Parametro("IDUsuario", -1)

        var ErrorNumero = 0
        var ErrorDescripcion = ""

        var jsonRespuesta = '{}'

        var sqlManDCan = "EXEC SPR_Manifiesto_Devolucion "
              + "@Opcion = 3200 "
            + ", @TA_ID = " + ( ( rqIntTA_ID > -1 ) ? rqIntTA_ID : "NULL" ) + " "
            + ", @OV_ID = " + ( ( rqIntOV_ID > -1 ) ? rqIntOV_ID : "NULL" ) + " "
            + ", @MotivoCancelacion = " + ( ( rqStrMotivoCancelacion.length > 0 ) ? "'" + rqStrMotivoCancelacion + "'" : "NULL" ) + " "
            + ", @IDUsuario = " + ( (rqIntIDUsuario > -1) ? rqIntIDUsuario : "NULL" ) + " "

        var rsManDCan = AbreTabla(sqlManDCan, 1 ,cxnTipo)

        if( !(rsManDCan.EOF) ){
            ErrorNumero = rsManDCan("ErrorNumero").Value
            ErrorDescripcion = rsManDCan("ErrorDescripcion").Value
        }

        rsManDCan.Close()
        
        jsonRespuesta = '{ '
                + '"Error": { '
                    + '"Numero": "' + ErrorNumero + '" '
                    + ', "Descripcion": "' + ErrorDescripcion + '" '
                +'} '
            + '} '

        Response.Write(jsonRespuesta)

    } break;

    //Descicion Ingresar
    case 3201: {

        var rqIntTA_ID = Parametro("TA_ID", -1)
        var rqIntOV_ID = Parametro("OV_ID", -1)
        var rqIntIDUsuario = Parametro("IDUsuario", -1)

        var ErrorNumero = 0
        var ErrorDescripcion = ""

        var jsonRespuesta = '{}'

        var sqlManDIng = "EXEC SPR_Manifiesto_Devolucion "
              + "@Opcion = 3201 "
            + ", @TA_ID = " + ( ( rqIntTA_ID > -1 ) ? rqIntTA_ID : "NULL" ) + " "
            + ", @OV_ID = " + ( ( rqIntOV_ID > -1 ) ? rqIntOV_ID : "NULL" ) + " "
            + ", @IDUsuario = " + ( (rqIntIDUsuario > -1) ? rqIntIDUsuario : "NULL" ) + " "

        var rsManDIng = AbreTabla(sqlManDIng, 1, cxnTipo)

        if( !(rsManDIng.EOF) ){
            ErrorNumero = rsManDIng("ErrorNumero").Value
            ErrorDescripcion = rsManDIng("ErrorDescripcion").Value
        }

        rsManDIng.Close()
        
        jsonRespuesta = '{ '
                + '"Error": { '
                    + '"Numero": "' + ErrorNumero + '" '
                    + ', "Descripcion": "' + ErrorDescripcion + '" '
                +'} '
            + '} '

        Response.Write(jsonRespuesta)

    } break;

     //Descicion Ingresar
    case 3202: {

        var rqIntOV_ID = Parametro("OV_ID", -1)
        var rqIntIDUsuario = Parametro("IDUsuario", -1)

        var ErrorNumero = 0
        var ErrorDescripcion = ""

        var jsonRespuesta = '{}'

        var sqlManDIng = "EXEC SPR_Manifiesto_Devolucion "
              + "@Opcion = 3202 "
            + ", @OV_ID = " + ( ( rqIntOV_ID > -1 ) ? rqIntOV_ID : "NULL" ) + " "
            + ", @IDUsuario = " + ( (rqIntIDUsuario > -1) ? rqIntIDUsuario : "NULL" ) + " "

        var rsManDIng = AbreTabla(sqlManDIng, 1, cxnTipo)

        if( !(rsManDIng.EOF) ){
            ErrorNumero = rsManDIng("ErrorNumero").Value
            ErrorDescripcion = rsManDIng("ErrorDescripcion").Value
        }

        rsManDIng.Close()
        
        jsonRespuesta = '{ '
                + '"Error": { '
                    + '"Numero": "' + ErrorNumero + '" '
                    + ', "Descripcion": "' + ErrorDescripcion + '" '
                +'} '
            + '} '

        Response.Write(jsonRespuesta)

    } break;
}
%>