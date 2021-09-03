<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2021-MAR-31 Carga de Serie no Serielaizada: Creación de archivo
// HA ID: 2 2021-MAY-20 Ajuste de Reglas de negocio de validación y asignación de serie.

var cxnTipo = 0

var urlBaseTemplate = "/Template/inspina/";
%>
<!-- Loading -->
<script src="<%= urlBaseTemplate %>js/loading.js"></script>

<script type="text/javascript">
    
    $(document).ready(function(){

        AsignacionSerie.Comenzar();

        $("#inpSKU").on("keyup", function(e){
            AsignacionSerie.SKU.Escanear(e);
        });

        $("#inpIMEI").on("keyup", function(e){
            AsignacionSerie.IMEI.Escanear(e);
        });

        $("#btnLimpiar").on("click", function(){
            AsignacionSerie.Limpiar();
        });

        $("#btnAsignar").on("click", function(){
            AsignacionSerie.Asignar();
        });

        $("#btnDisponibilidadVer").on("click", function(){
                AsignacionSerie.DisponibilidadVer();
        });

    });

    var AsignacionSerie = {
          url: "/pz/wms/almacen/"
        , TipoActualizacion: {
              Bien: 0
            , SeriesNoDisponibles: -1
            , SerieAsignada: -2
            , SKUNoExiste: -3
            , SerieNoPermitida: -4
            , Eliminado: -5
            , Error: 1
        }
        , SKU: {
            Escanear: function( evento ){

                var intTecla = (document.all) ? evento.keyCode : evento.which;

                var strSKU = $("#inpSKU").val().trim();

                if(intTecla == 13){

                    if(strSKU != ""){
                        AsignacionSerie.DisponibilidadVer();

                        AsignacionSerie.IMEI.Enfocar();
                    }

                }
            }
            , Enfocar: function(){
                $("#inpSKU").focus();
            }
            , Limpiar: function(){
                var bolPermaneceSKU = $("#chkMantenerSKU").is(":checked");

                if( !(bolPermaneceSKU) ){
                    $("#inpSKU").val("");
                    AsignacionSerie.SKU.DisponibilidadLimpiar();
                }

            }
            , DisponibilidadLimpiar: function(){
                $("#lblCantidadDisponible").text("N/D");
            }
        }
        , IMEI: {
            Escanear: function( evento ){

                var intTecla = (document.all) ? evento.keyCode : evento.which;

                var strIMEI = $("#inpIMEI").val().trim();

                if (intTecla == 13){

                    if(strIMEI != ""){
                        AsignacionSerie.Asignar();
                    }

                }
            }
            , Enfocar: function(){
                $("#inpIMEI").focus();
            }
            , Limpiar: function(){
                $("#inpIMEI").val("");
            }
        }
        , Comenzar: function(){

            var bolMantenerSKU = $("#chkMantenerSKU").is(":checked");

            AsignacionSerie.Limpiar();

            if( bolMantenerSKU ){
                AsignacionSerie.IMEI.Enfocar();
            } else {
                AsignacionSerie.SKU.Enfocar();
            }
            
        }
        , Limpiar: function(){
            AsignacionSerie.SKU.Limpiar();
            AsignacionSerie.IMEI.Limpiar();
        }
        , DisponibilidadVer: function(){

            var bolError = false;
            var arrError = [];

            var strSKU = $("#inpSKU").val().trim();

            if( strSKU == "" ){
                bolError = true;
                arrError.push("- Agregar SKU");
            }

            if( bolError ){
                Avisa("warning", "Asignaci&oacute;n - Serie", "Verificar formulario<br>" + arrError.join("<br>"));
            } else {
                Cargando.Iniciar();

                $.ajax({
                      url: AsignacionSerie.url + "Asignacion_IMEI_NoSerializado_Ajax.asp"
                    , method: "post"
                    , async: true
                    , dataType: "json"
                    , data: {
                          Tarea: 1200
                        , SKU: strSKU
                    }
                    , success: function( res ){
                        if( res.Error.Numero == 0 ){
                            
                            $("#lblCantidadDisponible").text(res.Registro.TotalDisponible);

                        } else {
                            Avisa("warning", "Asignaci&oacute;n - Serie", res.Error.Descripcion);
                        }

                        Cargando.Finalizar();
                    }
                    , error: function(){
                        Avisa("warning", "Asignaci&oacute;n - Serie", "Error en la petici&oacute;n");
                        Cargando.Finalizar();
                    }
                });
            }

        }
        , Asignar: function(){

            var bolError = false;
            var arrError = [];

            var strSKU = $("#inpSKU").val();
            var strIMEI = $("#inpIMEI").val();
            var intIDUsuario = $("#IDUsuario").val();

            var bolMantenerSKU = $("#chkMantenerSKU").is(":checked");

            if( strSKU == ""){
                bolError = true;
                arrError.push("- Agregar el SKU");
            }

            if(strIMEI == ""){
                bolError = true;
                arrError.push("- Agregar el número de serie");
            }

            if( bolError ){
                Avisa("warning", "Asignaci&oacute;n - Serie", "Verificar Formulario<br>" + arrError.join("<br>"));
            } else {

                Cargando.Iniciar();
                
                var intID = AsignacionSerie.FilaAgregar( strSKU, strIMEI );

                $.ajax({
                      url: AsignacionSerie.url + "Asignacion_IMEI_NoSerializado_Ajax.asp"
                    , method: "post"
                    , async: true
                    , dataType: "json"
                    , data: {
                        Tarea: 3210
                        , SKU: strSKU
                        , IMEI: strIMEI
                        , IDUsuario: intIDUsuario
                    }
                    , success: function( res ) {

                        if( res.Error.Numero == 0){
                            Avisa("success", "Asignaci&oacute;n - Serie", res.Error.Descripcion);                                

                            if( bolMantenerSKU ) {
                                $("#lblCantidadDisponible").text(res.Registro.TotalDisponible);

                            } else {
                                $("#lblCantidadDisponible").text("N/D");
                            }

                        } else {
                            Avisa("warning", "Asignaci&oacute;n - Serie", res.Error.Descripcion);
                        }  

                        AsignacionSerie.FilaActualizar( res, intID );
                        Cargando.Finalizar();

                    }
                    , error: function(){

                        Avisa("warning", "Asignaci&oacute;n - Serie", "Error en la peticion");
                        Cargando.Finalizar();

                    }

                });

                AsignacionSerie.Comenzar();

            }

        }
        , FilaAgregar: function(prmStrSKU , prmStrIMEI ){

            var intTotal = $("#Registros")[0].childNodes.length - 1;
            var intID = intTotal + 1;

            var objtr = "<tr id='tr_" + intID + "' data-respuesta='0'>"
                    + "<td>" + intID + "</td>"
                    + "<td id='SKU_" + intID + "'>" + prmStrSKU + "</td>"
                    + "<td id='IMEI_" + intID + "'>" + prmStrIMEI + "</td>"
                    + "<td id='ico_" + intID + "'></td>"
                    + "<td id='eli_" + intID + "'></td>"
                + "</tr>"

            var objUltimo = $("#Registros").prepend(objtr);

            return intID;
        }
        , FilaActualizar: function( prmJson, prmIntID ){

            var strColor = "";
            var objHTML = "";
            var bolEli = false;
            var objEli = "";

            $("#eli_"+prmIntID).html("");

            $("#ico_"+ prmIntID)
                .html("")
                .removeClass();

            switch( parseInt(prmJson.Error.Numero) ){
                case AsignacionSerie.TipoActualizacion.Bien: { 
                    strColor = "info";
                    objHTML = "<i class='fa fa-check-circle-o fa-2x'></i> " + prmJson.Error.Descripcion
                    bolEli = true;
                } break;
                case AsignacionSerie.TipoActualizacion.SeriesNoDisponibles: { 
                    strColor = "warning"; 
                    objHTML = "<i class='fa fa-exclamation-circle fa-2x'></i> " + prmJson.Error.Descripcion
                } break;
                case AsignacionSerie.TipoActualizacion.SerieAsignada: {
                    strColor = "danger"; 
                    objHTML = "<i class='fa fa-exclamation-circle fa-2x'></i> " + prmJson.Error.Descripcion
                } break;
                case AsignacionSerie.TipoActualizacion.SKUNoExiste: {
                    strColor = "warning"; 
                    objHTML = "<i class='fa fa-exclamation-triangle fa-2x'></i> " + prmJson.Error.Descripcion
                } break;
                case AsignacionSerie.TipoActualizacion.SerieNoPermitida: {
                    strColor = "warning"; 
                    objHTML = "<i class='fa fa-exclamation-triangle fa-2x'></i> " + prmJson.Error.Descripcion
                } break;
                case AsignacionSerie.TipoActualizacion.Eliminado: {
                    strColor = "info";
                    objHTML = "<i class='fa fa-check-circle-o fa-2x'></i> " + prmJson.Error.Descripcion
                    console.log(objHTML);
                }
                case AsignacionSerie.TipoActualizacion.Error: {
                    strColor = "danger"; 
                    objHTML = "<i class='fa fa-times-circle fa-2x'></i> " + prmJson.Error.Descripcion
                } break;
            }

            if( bolEli ){
                intInv_ID = prmJson.Registro.Inv_ID;
                strSKU = '"' + prmJson.Registro.SKU + '"';
                strIMEI = '"' + prmJson.Registro.IMEI + '"';

                objEli = "<a class='btn btn-danger' onclick='AsignacionSerie.Borrar(" + prmIntID + "," + intInv_ID + "," + strSKU + "," + strIMEI + ");'>"
                        + "<i class='fa fa-trash'></i> Borrar IMEI"
                    + "</a>"              
            } else {
                objEli = ""; 
            }

            $("#eli_"+prmIntID)
                    .html(objEli);

            $("#ico_"+ prmIntID)
                .html(objHTML)
                .addClass("text-" + strColor);
        }
        , Borrar: function( prmIntID, prmIntInv_ID, prmStrSKU, prmStrIMEI){
            var bolError = false;
            var arrError = [];

            var intIDUsuario = $("#IDUsuario").val();

            if( prmIntID == "" ){
                bolError = true;
                arrError.push("- Identificador de Registro No permitido");
            }

            if( prmIntInv_ID == ""){
                bolError = true;
                arrError.push("- Sin Identificador de IMEI");
            }

            if( bolError ){
                Avisa("warning", "Asignaci&oacute;n - Serie", "Verificar formulario<br>" + arrError.join("<br>"));
            } else {

                swal({
                    title: "Borrar el IMEI al SKU",
                    text: "Desea borrar \nel IMEI: " + prmStrIMEI + " \nal SKU: " + prmStrSKU + " ",
                    type: "warning",
                    showCancelButton: true,
                    confirmButtonColor: "#23C6C8",
                    confirmButtonText: "Confirmar",
                    closeOnConfirm: false
                }
                , function(){

                    Cargando.Iniciar();
                    
                    $.ajax({
                          url: AsignacionSerie.url + "Asignacion_IMEI_NoSerializado_ajax.asp"
                        , method: "post"
                        , asyn: true
                        , dataType: "json"
                        , data: {
                              Tarea: 3220
                            , INV_ID: prmIntInv_ID
                            , IDUsuario: intIDUsuario
                        }
                        , success: function( res ){

                            if(res.Error.Numero == -5){
                                Avisa("success","Asignaci&oacute;n - Serie", res.Error.Descripcion);  

                                if( $("#chkMantenerSKU").is(":checked") ){ 
                                    $("#lblCantidadDisponible").text(res.Registro.TotalDisponible);       
                                }

                            } else {
                                Avisa("warning","Asignaci&oacute;n - Serie", res.Error.Descripcion);
                            }

                            AsignacionSerie.FilaActualizar( res, prmIntID );

                            Cargando.Finalizar();
                            swal.close();
                        }
                        , error: function(){

                            Avisa("warning", "Asignaci&oacute;n - Serie", "Error en la petici&oacute;n de Borrado");
                            Cargando.Finalizar();
                            swal.close();
                            
                        }
                    });

                });

            }
        }

    }

</script>

<div id="wrapper">
    <div class="wrapper wrapper-content">    
        <div class="row">
            <div class="col-sm-12">
                <div class="ibox">
                    <div class="ibox-title">
                        <h5>Asignaci&oacute;n - Serie</h5>
                        <div class="ibox-tools">
                            
                        </div>
                    </div>
                    <div class="ibox-content">

                        <div class="form-group row">

                            <label class="col-sm-1 control-label">SKU:</label>    
                            <div class="col-sm-3 m-b-xs">
                                <input type="text" id="inpSKU" class="form-control" placeholder="SKU"
                                 autocomplete="off" maxlength="30">
                            </div>

                            <div class="col-sm-2 m-b-xs">
                                <input type="checkbox" id="chkMantenerSKU"> Mantener SKU
                            </div> 

                            <div class="col-sm-2 m-b-xs">
                                <a id="btnDisponibilidadVer" class="btn btn-info">
                                    <i class="fa fa-search"></i> Ver Disponibilidad
                                </a>
                            </div>

                            <label class="col-sm-1 control-label text-danger" id="lblCantidadDisponible"
                             style="text-align: right; font-size: 25px;">

                            </label>
                            <label class="col-sm-1 control-label" style="font-size: 25px;">Disponible(s)</label>

                            
                        </div>

                        <div class="form-group row">

                            <label class="col-sm-1 control-label">Serie:</label>
                            <div class="col-sm-3 m-b-xs">
                                <input type="text" id="inpIMEI" class="form-control" placeholder="Serie"
                                autocomplete="off" maxlength="30">
                            </div>

                            <div class="col-sm-3 m-b-xs">
                                
                                <a id="btnLimpiar" class="btn btn-white">
                                    <i class="fa fa-trash"></i> Limpiar
                                </a>

                                <a id="btnAsignar" class="btn btn-success">
                                    <i class="fa fa-barcode"></i> Asignar
                                </a>

                            </div>

                        </div> 

                    </div>

                </div>

            </div>

        </div>

        <div class="row">
            <div class="col-sm-12">
                <div class="ibox">
                    <div class="ibox-title">
                        <h5>Resultados</h5>
                        <div class="ibox-tools">

                        </div>
                    </div>
                    <div class="ibox-content">
                        <div class="form-group row">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th class="col-sm-1">#</th>
                                        <th class="col-sm-2">SKU</th>
                                        <th class="col-sm-2">Serie</th>
                                        <th class="col-sm-5"></th>
                                        <th class="col-sm-2"></th>
                                    </tr>
                                </thead>                                    
                                <tbody id="Registros">

                                </tbody>
                            </table>

                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
