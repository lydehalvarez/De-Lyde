<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2020-ABR-03 Entregas: Creación de archivo
// HA ID: 3 2021-ABR-19 Filtrado de Evidencia en Entregas

var cxnTipo = 0

var urlBase = "/pz/wms/"
var urlBaseTemplate = "/Template/inspina/";

//Verificacion de Usuario Login
var intProv_ID = Parametro("Prov_ID", -1)
var bolEsTransportista = (intProv_ID > -1)

%>
<link href="<%= urlBaseTemplate %>css/plugins/select2/select2.min.css" rel="stylesheet">
<link href="<%= urlBaseTemplate %>css/plugins/daterangepicker/daterangepicker-bs3.css" rel="stylesheet">

<link href="<%= urlBaseTemplate %>css/plugins/datapicker/datepicker3.css" rel="stylesheet">

<link href="<%= urlBaseTemplate %>css/plugins/clockpicker/clockpicker.css" rel="stylesheet">

<!-- Select2 -->
<script src="<%= urlBaseTemplate %>js/plugins/select2/select2.full.min.js"></script>
<!-- Loading -->
<script src="<%= urlBaseTemplate %>js/loading.js"></script>
<!-- Lateral Flotante -->
<script src="<%= urlBaseTemplate %>js/lateralflotante.js"></script>

<!-- Date range use moment.js same as full calendar plugin -->
<script src="<%= urlBaseTemplate %>js/plugins/fullcalendar/moment.min.js"></script>
<!-- Date range picker -->
<script src="<%= urlBaseTemplate %>js/plugins/daterangepicker/daterangepicker.js"></script>

<!-- Data picker -->
<script src="<%= urlBaseTemplate %>js/plugins/datapicker/bootstrap-datepicker.js"></script>

 <!-- Clock picker -->
<script src="<%= urlBaseTemplate %>js/plugins/clockpicker/clockpicker.js"></script>

<script type="text/javascript">

    $(document).ready(function(){
    
        $(".select2").select2();

        $('#inpMProBFechaBusqueda').daterangepicker({
			"showDropdowns": true,
			//"singleDatePicker": true,
			"firstDay": 7,	
			"startDate":moment().startOf('month'),
			"endDate": moment(),
           // "setDate": Today,
            "autoApply": true,
			"ranges": {
               'Hoy': [moment(), moment()],
			   'Al dia de hoy': [moment().startOf('month'), moment()],
			   'Este Mes': [moment().startOf('month'), moment().endOf('month')],
			   'Mes pasado': [moment().subtract(1, 'month').startOf('month')
			                , moment().subtract(1, 'month').endOf('month')],		   
			   //'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
                
			   '7 Dias': [moment().subtract(6, 'days'), moment()],
               '15 Dias': [moment().subtract(15, 'days'), moment()],
			   '30 Dias': [moment().subtract(29, 'days'), moment()],
			},			
			"locale": {
				"format": "MM/DD/YYYY", 
				"separator": " - ",
				"applyLabel": "Aplicar",
				"cancelLabel": "Cancelar",
				"fromLabel": "Desde",
				"toLabel": "Hasta",
				"customRangeLabel": "Personalizado",
				"weekLabel": "W",
				"daysOfWeek": ["Do","Lu","Ma","Mi","Ju","Vi","Sa"],
				"monthNames": [ "Enero","Febrero","Marzo","April","Mayo","Junio"
				               ,"Julio","Agosto","Septimbre","Octubre","Novimbre","Dicimbre"]
			//"alwaysShowCalendars": true,	
			}}, function(start, end, label) {
				$("#inpMProBFechaInicial").val(moment.utc(start, 'MM/DD/YYYY').local().format('MM/DD/YYYY'))
				$("#inpMProBFechaFinal").val(moment.utc(end, 'MM/DD/YYYY').local().format('MM/DD/YYYY'))
                $("#inpMProBFechaBusqueda").val((moment.utc(start, 'DD/MM/YYYY').local().format('DD/MM/YYYY')) + " - " + (moment.utc(end, 'DD/MM/YYYY').local().format('DD/MM/YYYY')))
            }
        );
    });

    var Proveedor = {
        url: "/pz/wms/Proveedor/" 
        , RegistrosPagina: 10
        , Estatus: {
            Transito: 5
            , PrimerIntento: 6
            , SegundoIntento: 7
            , TercerIntento: 8
            , FallaEntrega: 9
            , EntregaExitosa: 10
            , AvisoDevolucion: 22
        }
        , Filtros: {
              Proveedor: -1
            , Folio: ""
            , Manifiesto: ""
            , Est_ID: -1
            , Guia: ""
            , FechaInicial: ""
            , FechaFinal: ""
            , Evidencia: -1
        }
        , EstatusCambiar: function(){

            $("#mdlMProEstCam").remove();
            
            var prmJson = ( !( arguments[0] == undefined ) ) ? arguments[0] : {};
            var intTA_ID = ( !( prmJson.TA_ID == undefined ) ) ? prmJson.TA_ID : -1;
            var intOV_ID = ( !( prmJson.OV_ID == undefined ) ) ? prmJson.OV_ID : -1;

            var bolError = false;
            var arrError = [];

            if( intTA_ID == -1 && intOV_ID == -1 ){
                bolError = true;
                arrError.push("- Identificadores de TA o OV No permitidos");
            }

            if( bolError ){
                Avisa("warning", "Cambio de Estatus", "Verificar formulario de carga<br>" + arrError.join("<br>"));
            } else {

                Cargando.Iniciar();

                $.ajax({
                    url: this.url + "MProveedor_CambioEstatus.asp"
                    , method: "post"
                    , async: true
                    , data: {
                        TA_ID: intTA_ID
                        , OV_ID: intOV_ID
                    }
                    , success: function(res){
                        $("#wrapper").append(res);
                        $("#mdlMProEstCam").modal("show");
                        Cargando.Finalizar();
                    }   
                    , error: function(){
                        Avisa("error", "Cambio de Estatus","No se puede cargar el modal de cambio de estatus")
                        Cargando.Finalizar();
                    }
                });
            }
            
        }
        
        , EstatusCambiarModalCerrar: function(){
            $("#mdlMProEstCam").modal("hide");
        }
        , EstatusCambiarModalEstatusCambiar: function(){
            var intEst_ID = $("#selMdlMProEstCamEstatus").val();

            var bolVisCom = false;
            var bolVisRec = false;

            if( parseInt(intEst_ID) == this.Estatus.EntregaExitosa || parseInt(intEst_ID) == this.Estatus.AvisoDevolucion ){
                bolVisCom = true;
            }

            if( parseInt(intEst_ID) ==  this.Estatus.EntregaExitosa ){
                bolVisRec = true;
            }

            if( bolVisCom ){
                $(".clsMdlMProEstCamComentario").show();
            } else {
                $(".clsMdlMProEstCamComentario").hide();
            }

            if( bolVisRec ){
                $(".clsMdlMProEstCamRecibio").show();
            } else {
                $(".clsMdlMProEstCamRecibio").hide();
            }

        }
        , EstatusGuardar: function(){
                        
            var intTA_ID = $("#hidMdlMProEstCamTA_ID").val();
            var intOV_ID = $("#hidMdlMProEstCamOV_ID").val();

            var intEst_ID = $("#selMdlMProEstCamEstatus").val();
            var strEst_Nombre = $("#selMdlMProEstCamEstatus").find(":selected").text();

            var strComentario = $("#txaMdlMProEstCamComentario").val();
            var strRecibio = $("#inpMdlMProEstCamRecibio").val();

            var dateFecha = $("#inpMdlMProEstCamFecha").val();
            var timeHora = $("#inpMdlMProEstCamHora").val();

            var bolError = false;
            var arrError = [];
            var bolVisCom = false;
            var bolVisRec = false;

            var intIDUsuario = $("#IDUsuario").val();
            var intID = ( intTA_ID > -1 ) ? intTA_ID : (( intOV_ID > -1 ) ? intOV_ID : -1);

            //Visibilidad Campos
            if( parseInt(intEst_ID) == this.Estatus.EntregaExitosa || parseInt(intEst_ID) == this.Estatus.AvisoDevolucion ){
                bolVisCom = true;
            }
            if( parseInt(intEst_ID) == this.Estatus.EntregaExitosa ){
                bolVisRec = true;
            }
            
            //Validacion
            if( intTA_ID == -1 && intOV_ID == -1 ){
                arrError.push("- Seleccionar el Identificador de Documento");
                bolError = true;
            }

            if( intEst_ID == "-1" ){
                arrError.push("- Seleccionar el Estatus a Cambiar");
                bolError = true;
            }

            if(bolVisCom && strComentario == ""){
                arrError.push("- Agregar el Comentario de cambio de Estatus");
                bolError = true;
            }

            if( dateFecha == ""  || timeHora == "" ){
                arrError.push("- Agregra Fecha y Hora del Cambio de Estatus");
                bolError = true;
            }

            if(bolVisRec && strRecibio == ""){
                arrError.push("- Agregar el Nombre de la Persona que recibio");
                bolError = true;
            }

            if( bolError ){
                Avisa("warning", "Cambio de Estatus", "Verificar el Formulario<br>" + arrError.join("<br>"));
            } else {

                 swal({
                    title: "Cambiar estatus del pedido",
                    text: "Desea cambiar el estatus del pedido a: <br><b class='text-danger'>" + strEst_Nombre + "</b>",
                    type: "warning",
                    showCancelButton: true,
                    confirmButtonColor: "#23C6C8",
                    confirmButtonText: "Confirmar",
                    closeOnConfirm: false,
                    html: true
                }
                , function(){

                    Cargando.Iniciar();

                    $.ajax({
                            url: Proveedor.url + "MProveedor_ajax.asp"
                        , method: "post"
                        , async: true
                        , dataType: "json"
                        , data: {
                            Tarea: 3000
                            , TA_ID: intTA_ID
                            , OV_ID: intOV_ID
                            , Est_ID: intEst_ID
                            , Comentario: strComentario
                            , Recibio: strRecibio
                            , FechaHora: dateFecha + " " + timeHora
                            , IDUsuario: intIDUsuario
                        }
                        , success: function(res){
                            if( res.Error.Numero == 0){

                                if( $("#inpMdlMProEstCamArchivoEvidencia1").val() != "" ){
                            
                                    var frmData1 = new FormData();
                                    var myInputFile1 = document.getElementById("inpMdlMProEstCamArchivoEvidencia1").files[0];
                                    var myjson1 =  {"ID":intID,"ID2":0,"Doc_ID":35,"Sys":19,"IDUsuario":intIDUsuario,"Titulo":"Evidencia de Entrega","Observacion":strComentario};
                                    
                                    frmData1.append("",myInputFile1);
                                    frmData1.append("Data",JSON.stringify(myjson1));
                                    //menos de 4MB por cada carga                      
                                    
                                    var settings1 = {
                                        "url": "https://wms.lydeapi.com/api/v2/CargaDocumento",
                                        "method": "POST",
                                        "timeout": 0,
                                        "processData": false,
                                        "mimeType": "multipart/form-data",
                                        "contentType": false,
                                        "data": frmData1
                                    };
                                    
                                    $.ajax(settings1).done(function (response) {
                                        console.log(response);
                                    });

                                }

                                if( $("#inpMdlMProEstCamArchivoEvidencia2").val() != "" ){
                                    var frmData2 = new FormData();
                                    var myInputFile2 = document.getElementById("inpMdlMProEstCamArchivoEvidencia2").files[0];
                                    var myjson2 =  {"ID":intID,"ID2":0,"Doc_ID":35,"Sys":19,"IDUsuario":intIDUsuario,"Titulo":"Evidencia de Entrega","Observacion":strComentario}
                                    
                                    frmData2.append("",myInputFile2);
                                    frmData2.append("Data",JSON.stringify(myjson2));
                                    //menos de 4MB por cada carga                      
                                    
                                    var settings = {
                                        "url": "https://wms.lydeapi.com/api/v2/CargaDocumento",
                                        "method": "POST",
                                        "timeout": 0,
                                        "processData": false,
                                        "mimeType": "multipart/form-data",
                                        "contentType": false,
                                        "data": frmData2
                                    };
                                    
                                    $.ajax(settings).done(function (response) {
                                        console.log(response);
                                    });

                                }

                                Avisa("success", "Cambio de Estatus", res.Error.Descripcion);

                                Proveedor.EstatusCambiarModalCerrar();

                                Cargando.Finalizar();

                                swal.close();

                                Proveedor.ListadoBuscar();

                            } else {

                                Cargando.Finalizar();

                                swal.close();

                                Avisa("danger", "Cambio de Estatus", res.Error.Descripcion);
                            }
                        }
                    });    
                    
                });
            }
        }
        , FiltrosLimpiar: function(){
            $("#inpMProBGuia").val("");
            $("#inpMProBFolio").val("");
            $("#inpMProBMan_Folio").val("");
            $("#inpMProBFechaBusqueda").val("");
            $("#inpMProBFechaInicial").val("");
            $("#inpMProBFechaFinal").val("");

            $("#selMProBEstatus").val("-1");
            $("#select2-selMProBEstatus-container").text("TODOS");

            $("#objMProBProv_ID").val("-1");
            $("#select2-objMProBProv_ID-container").text("TODOS");

            $("#selTieEvi").val("-1");

            var bolEsProveedor = ($("#objMProBProv_ID").data("esproveedor") == 1 );

            if( !(bolEsProveedor) ) {
                Proveedor.Filtros.Proveedor = -1
            }
            Proveedor.Filtros.Est_ID = -1;
            Proveedor.Filtros.Folio = "";
            Proveedor.Filtros.Manifiesto = "";
            Proveedor.Filtros.Guia = "";
            Proveedor.Filtros.FechaInicial = "";
            Proveedor.Filtros.FechaFinal = "";
            Proveedor.Filtros.Evidencia = -1

        }
        , ListadoBuscar: function(){
            
            var strGuia = $("#inpMProBGuia").val();
            var strFolio = $("#inpMProBFolio").val();
            var strMan_Folio = $("#inpMProBMan_Folio").val();
            var intEst_ID = $("#selMProBEstatus").val();
            var dateFechaInicial = $("#inpMProBFechaInicial").val();
            var dateFechaFinal = $("#inpMProBFechaFinal").val();
            var intEvidencia = $("#selTieEvi").val();
            var intIDUsuario = $("#IDUsuario").val();
            var intProv_ID = $("#objMProBProv_ID").val();
            var bolEsProveedor = ($("#objMProBProv_ID").data("esproveedor") == 1 );

            var bolError = false;

            if( strFolio == "" && strMan_Folio == "" && strGuia == "" && dateFechaInicial == "" && dateFechaFinal == "" &&  intEst_ID == "-1" && intEvidencia == -1 && ( bolEsProveedor || ( !(bolEsProveedor) && intProv_ID == "-1"))){
                bolError = true;
            }
            
            if( bolError ){
                Avisa("warning", "Entregas", "Seleccionar al menos un filtro");
            } else {

                Proveedor.Filtros.Proveedor = intProv_ID;
                Proveedor.Filtros.Folio = strFolio;
                Proveedor.Filtros.Manifiesto = strMan_Folio;
                Proveedor.Filtros.Est_ID = intEst_ID;
                Proveedor.Filtros.Guia = strGuia;
                Proveedor.Filtros.FechaInicial = dateFechaInicial;
                Proveedor.Filtros.FechaFinal = dateFechaFinal;
                Proveedor.Filtros.Evidencia = intEvidencia;

                Proveedor.ListadoCargar( true );
            }
        }
        , ListadoCargar: function( prmBolIniciaBusqueda ){

            var intRegistros =  $("#divMProBListado").children().length;
            var intIDUsuario = $("#IDUsuario").val();
            var intSiguienteRegistro = ( prmBolIniciaBusqueda ) ? 0 : intRegistros;
            var intRegistrosPagina = $("#inpRegPag").val();

            var intRegPag = (intRegistrosPagina == "" || intRegistrosPagina == undefined ) ? Proveedor.RegistrosPagina : intRegistrosPagina;

            if( prmBolIniciaBusqueda ){
                $("#divMProBListado").html("");
                $("#divMProBTotalRegistros").text("");
            } 

            Procesando.Visualizar({Contenedor: "divMProBCargando"})

            $.ajax({
                url: this.url + "MProveedor_Listado.asp"
                , method: "post"
                , async: true
                , data: {
                      Prov_ID: Proveedor.Filtros.Proveedor
                    , Guia: Proveedor.Filtros.Guia
                    , Folio: Proveedor.Filtros.Folio 
                    , Man_Folio: Proveedor.Filtros.Manifiesto
                    , Est_ID: Proveedor.Filtros.Est_ID
                    , FechaInicial: Proveedor.Filtros.FechaInicial
                    , FechaFinal: Proveedor.Filtros.FechaFinal
                    , Evidencia: Proveedor.Filtros.Evidencia
                    , IDUsuario: intIDUsuario
                    , SiguienteRegistro: intSiguienteRegistro
                    , RegistrosPagina: intRegPag
                }
                , success: function(res){

                    Procesando.Ocultar();

                    if(prmBolIniciaBusqueda){
                        $("#divMProBListado").html( res );    
                    } else {
                        $("#divMProBListado").append( res );
                    }
                    var objMas = "";
                    if( res != ""){
                        objMas = "<div class='row'>"
                                + "<div class='col-sm-9'>"
                                    + "<button type='button' class='btn btn-white btn-block' onClick='Proveedor.ListadoCargar()'>"
                                        + "<i class='fa fa-arrow-down'></i> Ver mas"
                                    + "</button>" 
                                + "</div>"
                                + "<div class='col-sm-2 input-group'>"
                                    + "<input type='number' id='inpRegPag' class='form-control text-right' placeholder='10' min='10' max='100' steep='10' value='10' maxlength='3' >"
                                    + "<span class='input-group-addon'> Reg/Pag </span>"
                                + "</div>"
                            + "</div>"

                    } else if( prmBolIniciaBusqueda ) {
                        objMas = "<i class='fa fa-exclamation-circle fa-lg text-success'></i> No hay Registros"
                    }

                    $("#divMProBCargando").html(objMas);

                    Proveedor.ListadoRegistrosContar();

                }
                , error: function(){

                    Procesando.Ocultar();
                    Avisa("error","Proveedor Entregas", "No se puede cargar el listado de Entregas")
                    
                }
            })
            
        }
        , ListadoRegistrosContar: function(){
           var intRegistros = $("#divMProBListado").children().length;

           $("#divMProBTotalRegistros").text(intRegistros);
        }
        
    }

</script>

<div id="wrapper">
    <div class="wrapper wrapper-content">    
        <div class="row">
            <div class="col-sm-12">
                <div class="ibox">
                    <div class="ibox-title">
                        <h5>Filtros de b&uacute;squeda</h5>
                        <div class="ibox-tools">
                            
                            <button class="btn btn-white btn-sm" type="button" id="btnLimpiar" onClick="Proveedor.FiltrosLimpiar()">
                                <i class="fa fa-trash-o"></i> Limpiar
                            </button>

                            <button class="btn btn-success btn-sm" type="button" id="btnBuscar" onClick="Proveedor.ListadoBuscar()">
                                <i class="fa fa-search"></i> Buscar
                            </button>

                        </div>
                    </div>
                    <div class="ibox-content">
                        <div class="row">
                            <div class="col-sm-12 m-b-xs">  
                                <div class="form-group row">      
<%  if( !(bolEsTransportista) ){             
%>
                                    <label class="col-sm-2 control-label">Transportista:</label>
                                    <div class="col-sm-4 m-b-xs">

<%
        CargaCombo("objMProBProv_ID", "class='form-control select2' data-esproveedor='0'", "Prov_ID", "Prov_Nombre", "Proveedor", "Prov_Habilitado = 1 AND Prov_EsPaqueteria = 1", "Prov_Nombre ASC", "", cxnTipo, "TODOS", "")
%>                                        
                                    </div>
<%  } else {
%>
                                    <input id="objMProBProv_ID" data-esproveedor='1' type="hidden" value="<%= intProv_ID %>" />
<%
    }
%>
                                </div>

                                <div class="form-group row">

                                    <label class="col-sm-2 control-label">Gu&iacute;a:</label>    
                                    <div class="col-sm-4 m-b-xs">
                                        <input type="text" id="inpMProBGuia" class="form-control" placeholder="Gu&iacute;a"
                                         autocomplete="off" maxlength="50">
                                    </div>

                                    <label class="col-sm-2 control-label">Entregas con evidencia:</label>    
                                    <div class="col-sm-4 m-b-xs">
                                        <select id="selTieEvi" class="form-control">
                                            <option value="-1">TODOS</option>
                                            <option value="0">NO</option>
                                            <option value="1">SI</option>
                                        </select>
                                    </div>                              

                                </div>
                                
                                <div class="form-group row">

                                    <label class="col-sm-2 control-label">Folio:</label>    
                                    <div class="col-sm-4 m-b-xs">
                                        <input type="text" id="inpMProBFolio" class="form-control" placeholder="Folio SO o TA"
                                         autocomplete="off" maxlength="30">
                                    </div>
                                    <label class="col-sm-2 control-label">Folio de  Manifiesto:</label>    
                                    <div class="col-sm-4 m-b-xs">
                                        <input type="text" id="inpMProBMan_Folio" class="form-control" placeholder="Folio Manifiesto"
                                        autocomplete="off" maxlength="30">
                                    </div>   
                                   
                                </div>

                                <div class="form-group row">

                                    <label class="col-sm-2 control-label">Rango fechas:</label>
                                    <div class="col-sm-4 m-b-xs">
                                        <div class="input-group">
                                            <input class="form-control date-picker date" id="inpMProBFechaBusqueda" 
                                                placeholder="dd/mm/aaaa - dd/mm/aaaa" type="text" value="" autocomplete="off" > 
                                            <span class="input-group-addon">
                                                <i class="fa fa-calendar"></i>
                                            </span>
                                        </div>
                                    </div>
                                    <input id="inpMProBFechaInicial" type="hidden" value="" />
                                    <input id="inpMProBFechaFinal" type="hidden" value="" />
                                    
                                    <label class="col-sm-2 control-label">Estatus:</label>
                                    <div class="col-sm-4 m-b-xs">
<%
    CargaCombo("selMProBEstatus", "class='form-control select2'", "CAT_ID", "CAT_Nombre", "CAT_Catalogo", "CAT_ID IN (5,6,7,8,9,10) AND SEC_ID = 51", "CAT_Nombre DESC", "", cxnTipo, "TODOS","")
%>
                                    </div>

                                </div>

                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-sm-12">
                <div class="ibox">
                    <div class="ibox-title">
                        <h5>Resultados</h5>
                        <div class="ibox-tools">

                            <label class="pull-right form-group">
                                <span class="text-success" id="divMProBTotalRegistros">

                                </span> Registros
                            </label>

                        </div>
                    </div>
                    <div class="ibox-content">
                        <table class="table table-hover">
                            <tbody id="divMProBListado">

                            </tbody>
                            <tfoot id="divMProBCargando">
                                
                            </tfoot>
                        </table>
                    </div>
                </div>
                    
            </div>

        </div>
    </div>
</div>

