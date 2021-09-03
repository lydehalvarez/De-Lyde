<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2020-ENE-05 Surtido: Creación de archivo

var cxnTipo = 0
var rqStrTarea = Parametro("Tarea", -1)

switch( parseInt( rqStrTarea ) ){

    //Extraccion de Informacion
    case 100: {

        var rqIntTA_ID = Parametro("TA_ID", -1)

        var sqlTA = "EXEC SPR_TransferenciaAlmacen "
              + "@Opcion = 1900 "
            + ", @TA_ID = " + (( rqIntTA_ID > -1 ) ? rqIntTA_ID : "NULL" ) + " "

        var rsTA = AbreTabla(sqlTA, 1, cxnTipo)

        var jsonRespuesta = JSON.Convertir(rsTA, JSON.Tipo.RecordSet)

        rsTA.Close()

        Response.Write(jsonRespuesta)

    } break;

    //Opcion de Modal de Cambio de Estatus
    case 190:{
%>
        <div class="modal fade" id="mdlEstCam" tabindex="-1" role="dialog" aria-labelledby="divMdlEstCam" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close" onclick="TAProveedor.EstatusCambiarModalCerrar();">
                            <span aria-hidden="true">&times;</span>
                        </button>
                        <h2 class="modal-title" id="divMdlEstCam">
                            <i class="fa fa-refresh"></i> <label id="lblMdlCamEstTitulo"> </label>
                            <br />
                            <small id="lblMdlCamEstSubtitulo"> </small>
                        </h2>
                       
                    </div>
                    <div class="modal-body">

                        <input type="hidden" id="hidMdlEstCamTA_ID" value="">
                        
                        <div class="form-group row">

                            <label class="col-sm-2 control-label">Estatus:</label>    
                            <div class="col-sm-4 m-b-xs">
                                <select id="selMdlEstCamEstatus" class="form-control">

                                </select>
                            </div>

                            <label class="col-sm-6 control-label"> </label>    
                        </div>

                        <div class="form-group row">

                            <label class="col-sm-2 control-label">Estatus:</label>    
                            <div class="col-sm-10 m-b-xs">
                                <textarea id="selMdlEstCamEstatus" class="form-control" placeholder="Comentario">
                                
                                </textarea>
                            </div>
                            
                        </div>

                    </div>

                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary btn-seg" data-dismiss="modal" onclick="TAProveedor.EstatusCambiarModalCerrar();">
                            <i class="fa fa-times"></i> Cerrar
                        </button>
                        <button type="button" class="btn btn-primary btn-seg" onclick="TAProveedor.EstatusGuardar();">
                            <i class="fa fa-floppy-o"></i> Guardar
                        </button>
                    </div>
                </div>
            </div>
        </div>
<%
    } break;

     //Opcion Manifiesto de Salida
    case 1000: {
        
        var rqIntCli_ID = Parametro("Cli_ID", -1)
        var rqIntProv_ID = Parametro("Prov_ID", -1)
        var rqStrTA_Folio = Parametro("TA_Folio", "")
        var rqStrTA_Guia = Parametro("TA_Guia", "") 

        var sqlTAMan = "EXEC SPR_TransferenciaAlmacen "
              + "@Opcion = 1900 "
            + ", @Cli_ID = " + ( (rqIntCli_ID > -1) ? rqIntCli_ID : "NULL" ) + " "
            + ", @Prov_ID = " + ( (rqIntProv_ID > -1) ? rqIntProv_ID : "NULL" ) + " "
            + ", @TA_Folio = " + ( (rqStrTA_Folio.length > 0) ? rqStrTA_Folio : "NULL" ) + " "
            + ", @TA_Guia = " + ( (rqStrTA_Guia.length > 0) ? rqStrTA_Guia : "NULL" ) + " "

        var rsTAMan = AbreTabla(sqlTAMan, 1, cxnTipo)
%>
    <div class="ibox">
        <div class="ibox-title">
            <h3>Resultados<h3>
        </div>
        <div class="ibox-content">
            <table class="table">
                <thead>
                    <tr>
                        <th class="col-1-sm">Estatus</th>
                        <th class="col-4-sm">Manifiesto</th>
                        <th class="col-6-sm">Transferencia</th>
                        <th class="col-1-sm"></th>
                    </tr>
                </thead>
                <tbody>
<%
            if( !(rsTAMan.EOF) ){
%>
                    <tr>
                        <td class="issue-info text-nowrap">
<%
                var strEstatusColor = "text-white"
                switch( rsTAMan("TA_EstatusCG51").Value ){
                    case 5: { strEstatusColor = "text-warning" } break; //	Tránsito
                    case 6, 7, 8: { strEstatusColor = "text-success" } break; // 1er, 2do, 3er Intento
                    case 10: { strEstatusColor = "text-primary" } break; // Entrega exitosa
                    case 11: { strEstatusColor = "text-danger" } break; // Cancelada 
                }
%>
                            <a class="<%= strEstatusColor %>">
                                <%= rsTAMan("EST_Nombre").Value %>
                            </a>
                            <small>
                                <%= rsTAMan("TTp_Nombre").Value %>
                            </small>
                        </td>
                        <td class="issue-info">
                            <a>
                                <%= rsTAMan("Man_Folio").Value %>
                            </a>
                            <small>
                                Transportista: <%= rsTAMan("Prov_Nombre").Value %>
                                <br>
                                Guia: <%= rsTAMan("TA_Guia").Value %>
                                <br>
                                Ruta: <%= rsTAMan("TTR_Nombre").Value %> - <%= rsTAMan("Man_Ruta").Value %>
                            </small>
                        </td>
                        <td class="issue-info">
                            <a>
                                <%= rsTAMan("TA_Folio").Value %>
                            </a>
                            <small>
                                Origen: <%= rsTAMan("AlmO_Nombre").Value %>
                                <br>
                                Destino: <%= rsTAMan("AlmD_Nombre").Value %>
                                <br>
                                Direccion: <%= rsTAMan("AlmD_Direccion").Value %>
                                <br>
                                Responsable: <%= rsTAMan("AlmD_Responsable").Value %>
                                <br>
                                Tel&eacute;fono: <%= rsTAMan("AlmD_RespTelefono").Value %>
                                <br>
                                Fecha Registro: <%= rsTAMan("TA_FechaRegistro").Value %>
                            </small>
                        </td>
                        <td class="text-nowrap">
                            <a style="cursor: pointer;" class="btn btn-primary bt-sm" title="Cambiar Estatus"
                             onclick='TA_Proveedor.EstatusCambiar({TA_ID: <%= rsTAMan("TA_ID") %>})'>
                                <i class="fa fa-refresh fa-lg"></i>
                            </a>
                        </td>
                    </tr>
<%          
            } else {
%>
                    <tr>
                        <td colspan="3">
                            <i class="fa fa-exclamation-circle-o text-success"></i> No existen Registros
                        </td>
                    </tr>
<%         }
%>
                </tbody>
            </table>
        </div>
    </div>
<%
            rsTAMan.Close()
        
    } break;

    //Cambio de Estatus
    case 3200: {

        var rqIntEst_ID = Parametro("Est_ID", -1)
        var rqStrComentario = Parametro("Comentario", "")

        var intErrorNumero = 0
        var strErrorDescripcion = ""

        var jsonRespuesta = '{}'

        var sqlEstCam = "EXEC SPR_TransferenciaAlmacen "
              + "@Opcion = 3100 "
            + ", @TA_EstatusCG51 = " + ( (rqIntEst_ID > -1) ? rqIntEst_ID : "NULL" ) + " "
            + ", @TA_Comentario = " + ( (rqStrComentario.length > 0) ? rqStrComentario : "NULL" ) + " "

        var rsEstCam = AbreTabla(sqlEstCam, 1, cxnTipo)

        if( !(rsEstCam.EOF) ){
            intErrorNumero = rsEstCam("ErrorNumero").Value
            strErrorDescripcion = rsEstCam("ErrorDescripcion").Value
        } else {
            intErrorNumero = 1
            strErrorDescripcion = "Error al realizar la actualizacion"
        }

        rsEstCam.Close()

        jsonRespuesta = '{'
                + '"Error": {'
                      + '"Numero": "' + intErrorNumero + '"'
                    + ', "Descripcion": "' + strErrorDescripcion + '"'
                + '}'
            + '}'

        Response.Write(jsonRespuesta)

    } break;
}
%>