<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2021-MAR-31 RFID: Creación de archivo

var cxnTipo = 0

var urlBaseTemplate = "/Template/inspina/";
%>
<!-- Loading -->
<script src="<%= urlBaseTemplate %>js/loading.js"></script>

<script type="text/javascript">
    
    $(document).ready(function(){

        AsignacionRFID.Comenzar();

        $("#inpIMEI").on("keyup", function(e){
            AsignacionRFID.IMEI.Escanear(e);
        });
        
        $("#inpRFID").on("keyup", function(e){
            AsignacionRFID.RFID.Escanear(e);
        });

        $("#btnLimpiar").on("click", function(){
            AsignacionRFID.Limpiar();
        });

        $("#btnAsignar").on("click", function(){
            AsignacionRFID.Asignar();
        });

        $("#btnBuscar").on("click", function(){
            AsignacionRFID.Buscar();
        });

    });

    var AsignacionRFID = {
          url: "/pz/wms/almacen/"
        , TipoActualizacion: {
              Bien: 0
            , IMEIInexistente: -1
            , IMEIAsignado: -2
            , RFIDAsignado: -3
            , Encontrado: -4
            , NoEncontrado: -5
            , Error: 1
        }
        , IMEI: {
            Escanear: function( evento ){

                var intTecla = (document.all) ? evento.keyCode : evento.which;

                var strIMEI = $("#inpIMEI").val().trim();

                if (intTecla == 13){

                    if(strIMEI != ""){
                        AsignacionRFID.RFID.Enfocar();
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
        , RFID: {
            Escanear: function( evento ){

                var intTecla = (document.all) ? evento.keyCode : evento.which;

                var strRFID = $("#inpRFID").val().trim();

                if (intTecla == 13){

                    if(strRFID != ""){
                        AsignacionRFID.Asignar()
                    }

                }
            }
            , Enfocar: function(){
                $("#inpRFID").focus();
            }
            , Limpiar: function(){
                $("#inpRFID").val("");
            }
        }
        , Comenzar: function(){
            AsignacionRFID.Limpiar();
            AsignacionRFID.IMEI.Enfocar();
        }
        , Limpiar: function(){
            AsignacionRFID.IMEI.Limpiar();
            AsignacionRFID.RFID.Limpiar();
        }
        , Buscar: function(){
            var strIMEI = $("#inpIMEI").val();
            var strRFID = $("#inpRFID").val();
            var intIDUsuario = $("#IDUsuario").val();

            var bolError = false;
            var arrError = [];

            if( strIMEI == "" && strRFID == ""){
                bolError = true;
                arrError.push("- Agregar IMEI o EPC a buscar");
            }

            if( bolError ){
                Avisa("warning", "Asignacion - EPC", "Verificar Formulario<br>" + arrError.join("<br>"));
            } else {
                Cargando.Iniciar();

                var intID = AsignacionRFID.FilaAgregar( strIMEI, strRFID );

                $.ajax({
                    url: AsignacionRFID.url + "Asignacion_RFID_ajax.asp"
                    , method: "post"
                    , async: true
                    , dataType: "json"
                    , data: {
                        Tarea: 1000
                        , IMEI: strIMEI
                        , RFID: strRFID
                        , IDUsuario: intIDUsuario
                    }
                    , success: function( res ) {
                        
                        AsignacionRFID.FilaActualizar( res, intID );
                        Cargando.Finalizar();

                    }
                    , error: function(){

                        Avisa("warning", "Asignacion - EPC", "Error en la peticion");
                        Cargando.Finalizar();
                        
                    }
                });

                AsignacionRFID.Comenzar();
            }
            
        }
        , Borrar: function( prmIntID, prmStrIMEI, prmStrRFID ){
            var bolError = false;
            var arrError = [];

            var intIDUsuario = $("#IDUsuario").val();

            if( prmIntID == ""){
                bolError = true;
                arrError.push("- Identificador de registro vacio");
            }

            if( prmStrIMEI == ""){
                bolError = true;
                arrError.push("- Identificador IMEI vacio")
            }

            if( prmStrRFID == ""){
                bolError = true;
                arrError.push("- Identificador EPC vacio");
            }


            if( bolError ){
                Avisa("warning","Asignacion - EPC","Verificar formulario<br>" + arrError.join("<br>"))
            } else {

                swal({
                    title: "Eliminar el EPC del IMEI",
                    text: "Desea eliminar \nel EPC: " + prmStrRFID + " \nal IMEI: " + prmStrIMEI + " ",
                    type: "warning",
                    showCancelButton: true,
                    confirmButtonColor: "#23C6C8",
                    confirmButtonText: "Confirmar",
                    closeOnConfirm: false
                }
                , function(){

                    Cargando.Iniciar();
                    
                    $.ajax({
                          url: AsignacionRFID.url + "Asignacion_RFID_ajax.asp"
                        , method: "post"
                        , asyn: true
                        , dataType: "json"
                        , data: {
                              Tarea: 3211
                            , IMEI: prmStrIMEI
                            , IDUsuario: intIDUsuario
                        }
                        , success: function( res ){

                            if(res.Error.Numero == 0){
                                Avisa("success","Asignacion - EPC", res.Error.Descripcion);          
                            } else {
                                Avisa("warning","Asignacion - EPC", res.Error.Descripcion);
                            }

                            res.Registros.AntIMEI = "";
                            res.Registros.AntRFID = "";

                            AsignacionRFID.FilaActualizar( res, prmIntID );

                            Cargando.Finalizar();
                            swal.close();
                        }
                        , error: function(){

                            Avisa("warning", "Asignacion - EPC", "Error en la peticion de Borrado");
                            Cargando.Finalizar();
                            swal.close();
                            
                        }
                    });

                });
            }

        }
        , Asignar: function(){
            var bolError = false;
            var arrError = [];

            var strIMEI = $("#inpIMEI").val().trim();
            var strRFID = $("#inpRFID").val().trim();

            var expRFID = /^9000\d*$/g;

            var intIDUsuario = $("#IDUsuario").val()

            if( strIMEI == "" ) {
                bolError = true;
                arrError.push("Escanear el IMEI");
            }

            if( strRFID == "" ){
                bolError = true;
                arrError.push("Escanear el EPC");
            } else if( !(strRFID.match(expRFID)) ){
                bolError = true;
                arrError.push("El EPC no tiene el prefijo correcto");
            } else if( !(strRFID.length >= 16 && strRFID.length <= 17) ) {
                bolError = true;
                arrError.push("El EPC no tiene la longitud de digitos");
            }

            if( bolError ){
                Avisa("warning", "Asignacion - EPC", "Verificar formulario<br>" + arrError.join("<br>"));
            } else {

                Cargando.Iniciar();

                var intID = AsignacionRFID.FilaAgregar( strIMEI, strRFID );

                $.ajax({
                      url: AsignacionRFID.url + "Asignacion_RFID_ajax.asp"
                    , method: "post"
                    , async: true
                    , dataType: "json"
                    , data: {
                          Tarea: 3210
                        , IMEI: strIMEI
                        , RFID: strRFID
                        , IDUsuario: intIDUsuario
                    }
                    , success: function( res ) {
                        
                        if( res.Error.Numero == 0){
                            Avisa("success", "Asignacion - EPC", res.Error.Descripcion);                                
                        } else {
                            Avisa("warning", "Asignacion - EPC", res.Error.Descripcion);
                        }

                        AsignacionRFID.FilaActualizar( res, intID );
                        Cargando.Finalizar();

                    }
                    , error: function(){

                        Avisa("warning", "Asignacion - EPC", "Error en la peticion de Asignacion");
                        Cargando.Finalizar();
                        
                    }
                });

                AsignacionRFID.Comenzar();

            }

        }
        , FilaAgregar: function( prmStrIMEI, prmStrRFID){

            var intTotal = $("#Registros").children().length;
            var intID = intTotal + 1;

            var objtr = "<tr id='tr_" + intID + "' data-respuesta='0'>"
                    + "<td>" + intID + "</td>"
                    + "<td id='imei_" + intID + "'>" + prmStrIMEI + "</td>"
                    + "<td id='rfid_" + intID + "'>" + prmStrRFID + "</td>"
                    + "<td id='imeia_" + intID + "'>" + "</td>"
                    + "<td id='rfida_" + intID + "'>" + "</td>"
                    + "<td id='usu_" + intID + "'>" + "</td>"
                    + "<td id='ico_" + intID + "'></td>"
                    + "<td id='acc_" + intID + "'></td>"
                + "</tr>"

            $("#Registros").prepend(objtr);

            return intID;
        }
        , FilaActualizar: function( prmJson, prmIntID ){

            var strColor = "";
            var objHTML = "";

            var strIMEI = prmJson.Registros.IMEI;
            var strRFID = prmJson.Registros.RFID;
            var strAntIMEI = prmJson.Registros.AntIMEI;
            var strAntRFID = prmJson.Registros.AntRFID;
            var strUsuario = prmJson.Registros.Usuario;

            var bolEli = false;
            var strMensaje = prmJson.Error.Descripcion;

            switch( parseInt(prmJson.Error.Numero) ){

                case AsignacionRFID.TipoActualizacion.Bien: { 
                    strColor = "info";
                    objHTML = "<i class='fa fa-check-circle-o fa-2x'></i> " + strMensaje
                    bolEli = true;
                    strAntIMEI = "";
                    strAntRFID = "";
                } break;

                case AsignacionRFID.TipoActualizacion.IMEIInexistente: { 
                    strColor = "danger"; 
                    objHTML = "<i class='fa fa-exclamation-circle fa-2x'></i> " + strMensaje
                    strAntIMEI = "";
                    strAntRFID = "";
                } break;

                case AsignacionRFID.TipoActualizacion.IMEIAsignado: {
                    strColor = "warning"; 
                    objHTML = "<i class='fa fa-exclamation-circle fa-2x'></i> " + strMensaje
                    bolEli = true;
                    strAntIMEI = "";
                } break;

                case AsignacionRFID.TipoActualizacion.RFIDAsignado: {
                    strColor = "danger"; 
                    objHTML = "<i class='fa fa-exclamation-triangle fa-2x'></i> " + strMensaje
                    bolEli = true;
                    strAntRFID = ""; 
                } break;

                case AsignacionRFID.TipoActualizacion.Encontrado: {
                    strColor = "info"; 
                    objHTML = "<i class='fa fa-exclamation-circle fa-2x'></i> " + strMensaje
                   
                    if( prmJson.Registros.AntIMEI != "" && prmJson.Registros.AntRFID != "" ){
                        bolEli = true;
                    }

                    if( strIMEI != "" ){
                        strAntIMEI = "";
                    }
                    if( strRFID != ""){
                        strAntRFID = "";
                    }
                } break;

                case AsignacionRFID.TipoActualizacion.NoEncontrado: {
                    strColor = "warning"; 
                    objHTML = "<i class='fa fa-exclamation-triangle fa-2x'></i> " + strMensaje
                    strAntIMEI = "";
                    strAntRFID = "";
                } break;

                case AsignacionRFID.TipoActualizacion.Error: {
                    strColor = "danger"; 
                    objHTML = "<i class='fa fa-times-circle fa-2x'></i> " + strMensaje
                } break;

            }

            $("#imei_" + prmIntID).text(strIMEI);
            $("#imeia_" + prmIntID).text(strAntIMEI);
            $("#rfid_" + prmIntID).text(strRFID);
            $("#rfida_" + prmIntID).text(strAntRFID);
            $("#usu_" + prmIntID).text(strUsuario);
            $("#ico_"+ prmIntID).html(objHTML).addClass("text-" + strColor);
            
            if( bolEli ){

                var valIMEI = '"' + prmJson.Registros.AntIMEI + '"';
                var valRFID = '"' + prmJson.Registros.AntRFID + '"';
                
                var Evento = "AsignacionRFID.Borrar(" + prmIntID + ", " + valIMEI + ", " + valRFID + ")";
                var objAccEli = "<a class='btn btn-danger btn-sm' onclick='" + Evento + "'>"
                        + "<i class='fa fa-trash'> Borrar RFID"
                    + "</a>";

                $("#acc_" + prmIntID).html(objAccEli);
            } else {
                $("#acc_" + prmIntID).html("");
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
                        <h5>Asignacion  de RFID</h5>
                        <div class="ibox-tools">
                            
                        </div>
                    </div>
                    <div class="ibox-content">
                        <div class="form-group row">

                            <label class="col-sm-1 control-label">IMEI:</label>    
                            <div class="col-sm-3 m-b-xs">
                                <input type="text" id="inpIMEI" class="form-control" placeholder="IMEI"
                                 autocomplete="off" maxlength="30">
                            </div>

                            <label class="col-sm-1 control-label">EPC:</label>    
                            <div class="col-sm-3 m-b-xs">
                                <input type="text" id="inpRFID" class="form-control" placeholder="EPC"
                                 autocomplete="off" maxlength="30">
                            </div> 

                            <div class="col-sm-4 m-b-xs">
                                <a id="btnLimpiar" class="btn btn-white">
                                    <i class="fa fa-trash"></i> Limpiar
                                </a>

                                <a id="btnAsignar" class="btn btn-info">
                                    <i class="fa fa-barcode"></i> Asignar
                                </a>

                                <a id="btnBuscar" class="btn btn-success">
                                    <i class="fa fa-search"></i> Buscar
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
                                        <th class="">#</th>
                                        <th class="col-sm-2">IMEI Escaneado</th>
                                        <th class="col-sm-2">EPC Escaneado</th>
                                        <th class="col-sm-2">IMEI Sistema</th>
                                        <th class="col-sm-2">EPC Sistema</th>
                                        <th class="col-sm-2">Usuario</th>
                                        <th class="col-sm-2">Estatus</th>
                                        <th class="col-sm-2">Acci&oacute;n</th>
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
