<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2020-ENE-05 Surtido: Creación de archivo

var cxnTipo = 0

var rqIntTA_ID = Parametro("TA_ID", -1)
var rqIntOV_ID = Parametro("OV_ID", -1)

var intEst_ID = -1
var intDias_Transcurridos = 0
var strFolio = ""
var strEst_Nombre = ""

var sqlExt = "EXEC SPR_MProveedor "
      + "@Opcion = 1000 "
    + ", @TA_ID = " + ( ( rqIntTA_ID > -1 ) ? rqIntTA_ID : "NULL" ) + " "
    + ", @OV_ID = " + ( ( rqIntOV_ID > -1 ) ? rqIntOV_ID : "NULL" ) + " "

var rsExt = AbreTabla(sqlExt, 1, cxnTipo)

if( !(rsExt.EOF) ){
    intEst_ID = rsExt("EST_ID").Value
    intDias_Transcurridos = (rsExt("Dias_Transcurridos").Value + 1 ) * -1;
    strFolio = rsExt("Folio").Value
    strEst_Nombre = rsExt("Est_Nombre").Value
}

rsExt.Close()

var arrCat_IDs = [];
var strCat_IDs = "";

var Estatus = {
          Transito: 5
        , PrimerIntento: 6
        , SegundoIntento: 7
        , TercerIntento: 8
        , FallaEntrega: 9
        , EntregaExitosa: 10
        , AvisoDevolucion: 22
    }

switch(parseInt(intEst_ID)){
    case Estatus.Transito: {
        arrCat_IDs = [
              Estatus.PrimerIntento
            , Estatus.AvisoDevolucion
            , Estatus.EntregaExitosa
        ] 
    } break;
    case Estatus.PrimerIntento: {
        arrCat_IDs = [
                Estatus.SegundoIntento
            , Estatus.AvisoDevolucion
            , Estatus.EntregaExitosa
        ] 
    } break; 
    case Estatus.SegundoIntento: {
        arrCat_IDs = [
                Estatus.TercerIntento
            , Estatus.AvisoDevolucion
            , Estatus.EntregaExitosa
        ] 
    } break; 
    case Estatus.TercerIntento: {
        arrCat_IDs = [
                Estatus.AvisoDevolucion
            , Estatus.EntregaExitosa
        ] 
    } break;  
}

strCat_IDs = arrCat_IDs.join(",");
%>

<script type="text/javascript">

    $(document).ready(function(){

        $('.clockpicker').clockpicker();

         $('.datepicker').datepicker({
            todayBtn: "linked",
            keyboardNavigation: false,
            forceParse: false,
            calendarWeeks: true,
            autoclose: true,
            startDate: '<%= intDias_Transcurridos %>d',
            endDate: '0d'
        });

    })

</script>

<div class="modal fade" id="mdlMProEstCam" tabindex="-1" role="dialog" aria-labelledby="divMdlMProEstCam" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                
                <button type="button" class="close" data-dismiss="modal" aria-label="Close" onclick="Proveedor.EstatusCambiarModalCerrar();">
                    <span aria-hidden="true">&times;</span>
                </button>
                <h2 class="modal-title" id="divMdlMProEstCam">
                    <i class="fa fa-refresh"></i> Cambio de estatus - <b class="text-danger" id="lblMdlMProEstCamTitulo"><%= strFolio %></b>
                    <br />
                    <small> 
                        Estatus Actual <b class="text-info" id="lblMdlMProEstCamSubtitulo"><%= strEst_Nombre %></b>
                    </small>
                </h2>
                
            </div>
            <div class="modal-body">
                
                <input type="hidden" id="hidMdlMProEstCamTA_ID" value="<%= rqIntTA_ID %>">
                <input type="hidden" id="hidMdlMProEstCamOV_ID" value="<%= rqIntOV_ID %>">
                
                <div class="form-group row">

                    <label class="col-sm-2 control-label">Estatus:</label>    
                    <div class="col-sm-4 m-b-xs">
<%
    CargaCombo("selMdlMProEstCamEstatus", "class='form-control' onchange='Proveedor.EstatusCambiarModalEstatusCambiar();'", "CAT_ID", "CAT_Nombre", "CAT_Catalogo", "CAT_ID IN (" + strCat_IDs + ") AND SEC_ID = 51", "CAT_Nombre DESC", "", cxnTipo, "SELECCIONAR","")
%>
                    </div>
                    <label class="col-sm-6 control-label"></label>  
                </div>

                <div class="form-group row">
                    <label class="col-sm-2 control-label">Fecha</label>  
                    <div class="col-sm-4 m-b-xs">
                        <div class="input-group date">
                            <span class="input-group-addon">
                                <i class="fa fa-calendar"></i>
                            </span>
                            <input type="text" id="inpMdlMProEstCamFecha"  class="form-control datepicker" value="" readonly>
                        </div>
                    </div>

                    <div class="col-sm-4 m-b-xs">
                        <div class="input-group clockpicker" data-autoclose="true">
                            <input type="text" class="form-control" id="inpMdlMProEstCamHora" value="" readonly>
                            <span class="input-group-addon">
                                <span class="fa fa-clock-o"></span>
                            </span>
                        </div>
                    </div>

                </div>

                <div class="form-group row clsMdlMProEstCamComentario" style="display: none;">

                    <label class="col-sm-2 control-label">Comentario:</label>    
                    <div class="col-sm-10 m-b-xs">
                        <textarea id="txaMdlMProEstCamComentario" class="form-control" placeholder="Comentario"
                        ></textarea>
                    </div>
                    
                </div>
                <div class="form-group row clsMdlMProEstCamRecibio" style="display: none;">

                    <label class="col-sm-2 control-label">Persona que recibio:</label>    
                    <div class="col-sm-10 m-b-xs">
                        <input type="text" id="inpMdlMProEstCamRecibio" class="form-control" placeholder="Persona que Recibio" autocomplete="off" maxlength="150">
                    </div>
                    
                </div>

                <div class="form-group row clsMdlMProEstCamRecibio" style="display: none;">

                    <label class="col-sm-2 control-label">Evidencia 1:</label>    
                    <div class="col-sm-10 m-b-xs">
                        <input type="file" id="inpMdlMProEstCamArchivoEvidencia1" acept=".doc,.docx,.pdf,image/*"
                        class="form-control" placeholder="Evidencia 1" autocomplete="off" multiple>
                    </div>
                    
                </div>

                <div class="form-group row clsMdlMProEstCamRecibio" style="display: none;">

                    <label class="col-sm-2 control-label">Evidencia 2:</label>    
                    <div class="col-sm-10 m-b-xs">
                        <input type="file" id="inpMdlMProEstCamArchivoEvidencia2" acept=".doc,.docx,.pdf,image/*"
                        class="form-control" placeholder="Evidencia 2" autocomplete="off" multiple>
                    </div>
                    
                </div>

            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-secondary btn-seg" data-dismiss="modal" onclick="Proveedor.EstatusCambiarModalCerrar();">
                    <i class="fa fa-times"></i> Cerrar
                </button>
                <button type="button" class="btn btn-primary btn-seg" onclick="Proveedor.EstatusGuardar();">
                    <i class="fa fa-floppy-o"></i> Guardar
                </button>
            </div>
        </div>
    </div>
</div>