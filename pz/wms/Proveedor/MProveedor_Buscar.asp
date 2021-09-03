<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2020-ABR-03 Entregas: Creación de archivo
// HA ID: 3 2021-ABR-19 Filtrado de Evidencia en Entregas
// HA ID: 4 2021-JUL-06 Agregado deFiltrado por redireccionamiento

var cxnTipo = 0

var urlBase = "/pz/wms/"
var urlBaseTemplate = "/Template/inspina/";

//Verificacion de Usuario Login
var bolEsTransportista = Parametro("Transportista", 0);
var intProv_ID = Parametro("Prov_ID", -1);

//var bolEsTransportista = 1;
//var intProv_ID = 35;

//HA ID: 4 INI Variables enviadas y validación de Filtrado
var strFolio = Parametro("Folio", "")
var bolFiltrar = false;

if( strFolio != ""){
    bolFiltrar = true;
}
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

<!-- DROPZONE -->
<script src="<%= urlBaseTemplate %>js/plugins/dropzone/dropzone.js"></script>

<script type="text/javascript">

    $(document).ready(function(){
    
        $(".select2").select2();
        $(".clockpicker").clockpicker();

        $('.datepicker').datepicker({
            todayBtn: "linked",
            keyboardNavigation: false,
            forceParse: false,
            calendarWeeks: true,
            autoclose: true,
            //startDate: 'd',
            endDate: '0d'
        });

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
<%
    //HA ID: 4 INI
    if( bolFiltrar ){
%>
        Proveedor.ListadoBuscar();
<%
    }
%>
    });

    var Proveedor = {
        url: "/pz/wms/Proveedor/" 
        , EsTransportista: <%= bolEsTransportista %>
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
            , TipoLocalidad: -1
        }
        , EstatusCambiar: function(prmJson){

            var intEst_ID = prmJson.Est_ID;
            var intDiasTranscurridos = prmJson.DiasTranscurridos
            var arrCat_IDs = [];

            Proveedor.EstatusCambiarModalLimpiar();

            $("#inpMdlMProEstCamFecha").datepicker('remove');

            //Configuracion del combo
            switch(parseInt(intEst_ID)){
                case Proveedor.Estatus.Transito: {
                    arrCat_IDs = [
                          Proveedor.Estatus.PrimerIntento
                        , Proveedor.Estatus.AvisoDevolucion
                        , Proveedor.Estatus.EntregaExitosa
                    ] 
                } break;
                case Proveedor.Estatus.PrimerIntento: {
                    arrCat_IDs = [
                          Proveedor.Estatus.SegundoIntento
                        , Proveedor.Estatus.AvisoDevolucion
                        , Proveedor.Estatus.EntregaExitosa
                    ] 
                } break; 
                case Proveedor.Estatus.SegundoIntento: {
                    arrCat_IDs = [
                          Proveedor.Estatus.TercerIntento
                        , Proveedor.Estatus.AvisoDevolucion
                        , Proveedor.Estatus.EntregaExitosa
                    ] 
                } break; 
                case Proveedor.Estatus.TercerIntento: {
                    arrCat_IDs = [
                          Proveedor.Estatus.AvisoDevolucion
                        , Proveedor.Estatus.EntregaExitosa
                    ] 
                } break;  
            }
            
            //Visualizar combo estatus
            $("#selMdlMProEstCamEstatus option").each( function(){ 
                if( arrCat_IDs.indexOf( parseInt($(this).val()) ) >= 0 ){
                    $(this).show();
                } else {
                    $(this).hide();
                }
            });

            $('.clockpicker').clockpicker();

            $('.datepicker').datepicker({
                todayBtn: "linked",
                keyboardNavigation: false,
                forceParse: false,
                calendarWeeks: true,
                autoclose: true,
                startDate: intDiasTranscurridos + 'd',
                endDate: '0d'
            });
            
            Proveedor.EstatusCambiarModalAbrir( prmJson );
            
        }
        , EstatusCambiarModalAbrir: function( prmJson ){

            //Agregar Valores
            $("#lblMdlMProEstCamTitulo").text( prmJson.Folio );
            $("#lblMdlMProEstCamSubtitulo").text( prmJson.Est_Nombre );
            $("#hidMdlMProEstCamTA_ID").val( prmJson.TA_ID );
            $("#hidMdlMProEstCamOV_ID").val( prmJson.OV_ID );

            $("#mdlMProEstCam").modal("show");

        }
        , EstatusCambiarModalLimpiar: function(){
            $("#lblMdlMProEstCamTitulo").text("");
            $("#lblMdlMProEstCamSubtitulo").text("");
            $("#hidMdlMProEstCamTA_ID").val("");
            $("#hidMdlMProEstCamOV_ID").text("");

            Proveedor.EstatusCambiarModalFormularioLimpiar();
        }
        , EstatusCambiarModalFormularioLimpiar: function(){
            $("#selMdlMProEstCamEstatus").val("-1");
            $("#inpMdlMProEstCamFecha").val("");
            $("#inpMdlMProEstCamHora").val("");
            $("#txaMdlMProEstCamComentario").val("");
            $("#inpMdlMProEstCamRecibio").val("");
            $("#inpMdlMProEstCamArchivoEvidencia1").val("");
            $("#inpMdlMProEstCamArchivoEvidencia2").val("");

            $(".clsMdlMProEstCamComentario").hide();
            $(".clsMdlMProEstCamRecibio").hide();

        }
        , EstatusCambiarModalCerrar: function(){
            $("#mdlMProEstCam").modal("hide");

            Proveedor.EstatusCambiarModalLimpiar();
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
                            , Transportista: Proveedor.EsTransportista
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

            $("#radTpoLocAmb").prop("checked", true);

            if( Proveedor.EsTransportista == 0 ) {
                Proveedor.Filtros.Proveedor = -1
            }
            Proveedor.Filtros.Est_ID = -1;
            Proveedor.Filtros.Folio = "";
            Proveedor.Filtros.Manifiesto = "";
            Proveedor.Filtros.Guia = "";
            Proveedor.Filtros.FechaInicial = "";
            Proveedor.Filtros.FechaFinal = "";
            Proveedor.Filtros.Evidencia = -1;
            Proveedor.Filtros.TipoLocalidad = -1;

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
            var intTpo_Localidad = $("input[name=radTpoLoc]:checked").val();

            var bolTrans = Proveedor.EsTransportista;

            var bolError = false;

            if( strFolio == "" && strMan_Folio == "" && strGuia == "" && dateFechaInicial == "" && dateFechaFinal == "" &&  intEst_ID == "-1" && intEvidencia == -1 && intTpo_Localidad == -1 && ( bolTrans == 0 || ( bolTrans == 1 && intProv_ID == "-1"))){
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
                Proveedor.Filtros.TipoLocalidad = intTpo_Localidad;

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
                    , Tpo_Localidad: Proveedor.Filtros.TipoLocalidad
                    , IDUsuario: intIDUsuario
                    , SiguienteRegistro: intSiguienteRegistro
                    , RegistrosPagina: intRegPag
                    , Transportista: Proveedor.EsTransportista
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
        , DetalleVer: function( prmJson ){

                var jsonPrm = ( !(arguments[0] == undefined) ) ? arguments[0] : {};
                var intTA_ID = ( !(jsonPrm.TA_ID == undefined) ) ? jsonPrm.TA_ID : -1;
                var intOV_ID = ( !(jsonPrm.OV_ID == undefined) ) ? jsonPrm.OV_ID : -1;

                var bolError = false;
                var arrError = [];

                if( !(intTA_ID > -1) && !(intOV_ID > -1) ){
                    bolError = true;
                    arrError.push("-Identificador No permitido");
                }

                var strUrl = "";

                if( intTA_ID > -1 ){
                    strUrl = "TA/TA_Ficha.asp"
                } else if( intOV_ID > -1 ){
                    strUrl = "OV/OV_Ficha.asp"
                }

                if( bolError ){
                    Avisa("warning", "Entrega - Detalle", "Verificar Formulario<br>" + arrError.join("<br>") );
                } else {

                    $("#mdlEntSegEnt").modal('show');

                    $.ajax({
                        url: "/pz/wms/" + strUrl
                        , method: "post"
                        , async: true
                        , data: {
                              TA_ID: intTA_ID
                            , OV_ID: intOV_ID
                            , EsTransportista: Proveedor.EsTransportista
                        }
                        , beforeSend: function(){
                             Procesando.Visualizar({Contenedor: "mdlEntSegEntBody"});
                        }
                        , success: function( res ){

                            $("#mdlEntSegEntBody").html( res );
                            $("#mdlEntSegEnt").modal("show");
                        
                        }
                        , error: function(){
                            Avisa("error", "Entrega - Detalle", "Error en la peticion");
                        }
                        , complete: function(){
                            Procesando.Ocultar();
                        }
                    });
                
                }
            }

        , Archivo: {
            ModalAbrir: function(){
                var prmJson = ( !( arguments[0] == undefined ) ) ? arguments[0] : {};
                var intTA_ID = ( !( prmJson.TA_ID == undefined ) ) ? prmJson.TA_ID : -1;
                var intOV_ID = ( !( prmJson.OV_ID == undefined ) ) ? prmJson.OV_ID : -1;
                var strFolio = ( !( prmJson.Folio == undefined ) ) ? prmJson.Folio : "";

                $("#mdlMProArc").modal("show");

                $("#hidMdlMProArcTA_ID").val(intTA_ID);
                $("#hidMdlMProArcOV_ID").val(intOV_ID);
                $("#lblMdlMProArcTitulo").text(strFolio);

            }
            , ModalCerrar: function(){

                $("#mdlMProArc").modal("hide");

                Proveedor.Archivo.ModalLimpiar();

            }
            , ModalLimpiar: function(){

                $("#hidMdlMProArcTA_ID").val("");
                $("#hidMdlMProArcOV_ID").val("");
                $("#lblMdlMProArcTitulo").text("");

                Proveedor.Archivo.ModalFormularioLimpiar();
                
            }
            , ModalFormularioLimpiar: function(){

                $("#hidMdlMProArcTermino").data("total", "0");
                $("#hidMdlMProArcTermino").data("terminados", "0");

                $("#inpMdlMProArc1").val("");
                $("#inpMdlMProArc2").val("");

            }
            , Guardar: function(){

                var bolError = false;
                var arrError = [];

                var intIDUsuario = $("#IDUsuario").val();
                var intTA_ID = $("#hidMdlMProArcTA_ID").val();
                var intOV_ID = $("#hidMdlMProArcOV_ID").val();

                var intID = ( intTA_ID > -1 ) ? intTA_ID : (( intOV_ID > -1 ) ? intOV_ID : -1);

                var strArc1 = $("#inpMdlMProArc1").val();
                var strArc2 = $("#inpMdlMProArc2").val();

                var intTotal = 0;

                var exrArc = /\.(pdf)|(bmp)|(gif)|(jpeg)|(jpg)|(png)$/g;

                if( !(intID > -1) ){
                    bolError = true;
                    arrError.push("- Identificador relacional no permitido");
                }

                if(strArc1 == "" && strArc2 == "" ) {
                    bolError = true;
                    arrError.push("- Agregar al menos un documento");
                } else {
                    
                    if( strArc1 != "" ){
                        if( !( strArc1.match(exrArc) ) ){
                            bolError = true;
                            arrError.push("- El Archivo 1 no es un archivo permitido");
                        } else {
                            intTotal++;
                        }
                    }

                    if( strArc2 != "" ){
                        if( !( strArc2.match(exrArc) ) ){
                            bolError = true;
                            arrError.push("- El Archivo 2 no es un archivo permitido");
                        } else {
                            intTotal++;
                        }
                    }

                }

                if( bolError ){
                    Avisa("warning", "Carga Archivos", "Verificar Formulario<br>" + arrError.join("<br>"));
                } else {

                    $("#hidMdlMProArcTermino").data("total", intTotal);
                    $("#hidMdlMProArcTermino").data("terminados", "0");

                    if( strArc1 != "" ){

                        var formData1 = new FormData();
                        var arcArchivo1 = $("#inpMdlMProArc1")[0].files[0];
                        var jsonData1 = {
                              ID: intID
                            , ID2: 0
                            , Doc_ID: 35
                            , Sys: 19
                            , IDUsuario: intIDUsuario
                            , Titulo: "Evidencia de Entrega"
                            , Observacion:"Archivo de Evidencia"
                        };
                        
                        formData1.append("", arcArchivo1);
                        formData1.append("Data", JSON.stringify(jsonData1));

                        $.ajax({
                            url: "https://wms.lydeapi.com/api/v2/CargaDocumento"
                            , method: "POST"
                            , timeout: 0
                            , processData: false
                            , mimeType: "multipart/form-data"
                            , contentType: false
                            , data: formData1
                            , beforeSend: function(){
                                Cargando.Iniciar();
                            }
                            , success: function( res ){
                                console.log(res);
                               
                                Cargando.Finalizar();
                                Proveedor.Archivo.Terminar( true );
                            }
                            , error: function(){
                                Avisa("error", "Carga Archivos", "Error en la peticion Carga Archivo");
                                Proveedor.Archivo.Terminar( false );
                            }
                        });

                    }

                    if( strArc2 != "" ){

                        var formData2 = new FormData();
                        var arcArchivo2 = $("#inpMdlMProArc2")[0].files[0];
                        var jsonData2 = {
                              ID: intID
                            , ID2: 0
                            , Doc_ID: 35
                            , Sys: 19
                            , IDUsuario: intIDUsuario
                            , Titulo: "Evidencia de Entrega"
                            , Observacion:"Archivo de Evidencia"
                        };
                        
                        formData2.append("", arcArchivo2);
                        formData2.append("Data", JSON.stringify(jsonData2));

                        $.ajax({
                            url: "https://wms.lydeapi.com/api/v2/CargaDocumento"
                            , method: "POST"
                            , timeout: 0
                            , processData: false
                            , mimeType: "multipart/form-data"
                            , contentType: false
                            , data: formData2
                            , beforeSend: function(){
                                Cargando.Iniciar();
                            }
                            , success: function( res ){
                                console.log(res);
                               
                                Cargando.Finalizar();
                                Proveedor.Archivo.Terminar( true );
                            }
                            , error: function(){
                                Avisa("error", "Carga Archivos", "Error en la peticion Carga Archivo");
                                Proveedor.Archivo.Terminar( false );
                            }
                        });

                    }

                } 

            }
            , Terminar: function( prmBolTer ){

                var intTer = $("#hidMdlMProArcTermino").data("terminados");
                var intTot = $("#hidMdlMProArcTermino").data("total");

                if( prmBolTer ){
                    intTer++;
                }

                $("#hidMdlMProArcTermino").data("terminados", intTer);

                if( intTot == intTer){
                    Proveedor.Archivo.ModalCerrar();
                    Proveedor.ListadoBuscar();
                }
            }
        }
        , Fecha: {

            ModalAbrir: function(){
                var prmJson = ( !( arguments[0] == undefined ) ) ? arguments[0] : {};
                var intTA_ID = ( !( prmJson.TA_ID == undefined ) ) ? prmJson.TA_ID : -1;
                var intOV_ID = ( !( prmJson.OV_ID == undefined ) ) ? prmJson.OV_ID : -1;
                var strFolio = ( !( prmJson.Folio == undefined ) ) ? prmJson.Folio : "";

                $("#mdlMProFec").modal("show");

                $("#hidMdlMProFecTA_ID").val(intTA_ID);
                $("#hidMdlMProFecOV_ID").val(intOV_ID);
                $("#lblMdlMProFecTitulo").text(strFolio);
            }
            , ModalCerrar: function(){

                $("#mdlMProFec").modal("hide");

                Proveedor.Fecha.ModalLimpiar();

            }
            , ModalLimpiar: function(){

                $("#hidMdlMProFecTA_ID").val("");
                $("#hidMdlMProFecOV_ID").val("");
                $("#lblMdlMProFecTitulo").text("");

                Proveedor.Fecha.ModalFormularioLimpiar();
            }
            , ModalFormularioLimpiar: function(){
                
                $("#inpMdlMProFecFecha").val("");
                $("#inpMdlMProFecHora").val("");

            }
            , Guardar: function(){
                var bolError = false;
                var arrError = [];

                var intIDUsuario = $("#IDUsuario").val();
                var intTA_ID = $("#hidMdlMProFecTA_ID").val();
                var intOV_ID = $("#hidMdlMProFecOV_ID").val();

                var dateFecha = $("#inpMdlMProFecFecha").val();
                var timeHora = $("#inpMdlMProFecHora").val();

                var intID = ( intTA_ID > -1 ) ? intTA_ID : (( intOV_ID > -1 ) ? intOV_ID : -1);

                if( !(intID > -1) ){
                    bolError = true;
                    arrError.push("- Identificador relacional no permitido");
                }

                if( dateFecha == "" ){
                    bolError = true;
                    arrError.push("- Agregar Fecha");
                }

                if( timeHora == "" ){
                    bolError = true;
                    arrError.push("- Agregar Hora");
                }

                if( bolError ){
                    Avisa("warning", "Cambio de Fecha", "Verificar Formilario<br>" + arrError.join("<br>"));
                } else {

                    $.ajax({
                        url: Proveedor.url + "MProveedor_ajax.asp"
                        , method: "post"
                        , async: true
                        , dataType: "json"
                        , data: {
                              Tarea: 3000
                            , TA_ID: intTA_ID
                            , OV_ID: intOV_ID
                            , FechaHora: dateFecha + " " + timeHora
                            , IDUsuario: intIDUsuario
                            , Transportista: Proveedor.EsTransportista
                        }
                        , beforeSend: function(){
                            Cargando.Iniciar();
                        }
                        , success: function( res ){

                            if( res.Error.Numero == 0 ){
                                Avisa("success", "Cambio Fecha", res.Error.Descripcion);

                                Proveedor.Fecha.ModalCerrar();
                                Proveedor.ListadoBuscar();

                            } else {
                                Avisa("warning", "Cambio Fecha", res.Error.Descripcion);
                            }
                            Cargando.Finalizar();
                        }
                        , error: function(){
                            Avisa("error", "Cambio Fecha", "Error en la peticion Cambio de Fecha");
                            Cargando.Finalizar();
                        }
                    });
                }

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
<%  if( bolEsTransportista == 0 ){             
%>
                                    <label class="col-sm-2 control-label">Transportista:</label>
                                    <div class="col-sm-4 m-b-xs">

<%
        CargaCombo("objMProBProv_ID", "class='form-control select2'", "Prov_ID", "Prov_Nombre", "Proveedor", "Prov_Habilitado = 1 AND Prov_EsPaqueteria = 1", "Prov_Nombre ASC", "", cxnTipo, "TODOS", "")
%>                                        
                                    </div>
<%  } else {
%>
                                    <input id="objMProBProv_ID" type="hidden" value="<%= intProv_ID %>" />
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
                                         autocomplete="off" maxlength="30" value="<%= strFolio %>">
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

                                <div class="form-group row">

                                    <label class="col-sm-2 control-label">
                                        Tipo Localidad
                                    </label>
                                    <div class="col-sm-4">
                                
                                        <input type="radio" id="radTpoLocAmb" name="radTpoLoc" value="-1" checked>
                                        <label for="radTpoLocAmb">
                                            Ambas
                                        </label>
                                        <input type="radio" id="radTpoLocLoc" name="radTpoLoc" value="1">
                                        <label for="radTpoLocLoc">
                                            Local
                                        </label>
                                        <input type="radio" id="radTpoLocFor" name="radTpoLoc" value="2">
                                        <label for="radTpoLocFor">
                                            Foranea
                                        </label>
                                
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

<!-- Modal de agregado de archivos -->

<div class="modal fade" id="mdlMProArc" tabindex="-1" role="dialog" aria-labelledby="divMdlMProArc" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                
                <button type="button" class="close" data-dismiss="modal" aria-label="Close" onclick="Proveedor.Archivo.ModalCerrar();">
                    <span aria-hidden="true">&times;</span>
                </button>
                <h2 class="modal-title" id="divMdlMProArc">
                    <i class="fa fa-refresh"></i> Cargar Archivo - <b class="text-danger" id="lblMdlMProArcTitulo"></b>
                </h2>

                <button type="button" class="btn btn-white pull-right" id="btnMdlMProArcLim" onclick="Proveedor.Archivo.ModalFormularioLimpiar()">
                    <i class="fa fa-trash-o"></i> Limpiar
                </button>
                
            </div>
            <div class="modal-body">
                
                <input type="hidden" id="hidMdlMProArcTA_ID">
                <input type="hidden" id="hidMdlMProArcOV_ID">
                <input type="hidden" id="hidMdlMProArcTermino" data-total="0", data-terminados="0">

                <div class="form-group row">

                    <label class="control-label col-sm-2">
                        Archivo 1
                    </label>

                    <div class="col-sm-10">
                        <input name="inpArc1" id="inpMdlMProArc1" type="file" multiple />
                    </div>

                </div>

                <div class="form-group row">

                    <label class="control-label col-sm-2">
                        Archivo 2
                    </label>

                    <div class="col-sm-10">
                        <input name="inpArc2" id="inpMdlMProArc2" type="file" multiple />
                    </div>
                    
                </div>

            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-secondary btn-seg" data-dismiss="modal" onclick="Proveedor.Archivo.ModalCerrar();">
                    <i class="fa fa-times"></i> Cerrar
                </button>
                <button type="button" class="btn btn-primary btn-seg" onclick="Proveedor.Archivo.Guardar();">
                    <i class="fa fa-floppy-o"></i> Guardar
                </button>
            </div>
        </div>
    </div>
</div>

<!-- Modal de agregado de Fechas -->
<div class="modal fade" id="mdlMProFec" tabindex="-1" role="dialog" aria-labelledby="divMdlMProFec" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                
                <button type="button" class="close" data-dismiss="modal" aria-label="Close" onclick="Proveedor.Fecha.ModalCerrar();">
                    <span aria-hidden="true">&times;</span>
                </button>
                <h2 class="modal-title" id="divMdlMProFec">
                    <i class="fa fa-refresh"></i> Cambio de Fecha y Hora <b class="text-danger" id="lblMdlMProFecTitulo"></b>
                </h2>
                <button type="button" class="btn btn-white pull-right" id="btnMdlMProFecLim" onclick="Proveedor.Fecha.ModalFormularioLimpiar()">
                    <i class="fa fa-trash-o"></i> Limpiar
                </button>
                
            </div>
            <div class="modal-body">
                
                <input type="hidden" id="hidMdlMProFecTA_ID">
                <input type="hidden" id="hidMdlMProFecOV_ID">
                
                <div class="form-group row">
                    <label class="col-sm-2 control-label">Fecha</label>  
                    <div class="col-sm-4 m-b-xs">
                        <div class="input-group date">
                            <span class="input-group-addon">
                                <i class="fa fa-calendar"></i>
                            </span>
                            <input type="text" id="inpMdlMProFecFecha"  class="form-control datepicker" value="" readonly>
                        </div>
                    </div>

                    <div class="col-sm-4 m-b-xs">
                        <div class="input-group clockpicker" data-autoclose="true">
                            <input type="text" class="form-control" id="inpMdlMProFecHora" value="" readonly>
                            <span class="input-group-addon">
                                <span class="fa fa-clock-o"></span>
                            </span>
                        </div>
                    </div>

                </div>

            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-secondary btn-seg" data-dismiss="modal" onclick="Proveedor.Fecha.ModalCerrar();">
                    <i class="fa fa-times"></i> Cerrar
                </button>
                <button type="button" class="btn btn-primary btn-seg" onclick="Proveedor.Fecha.Guardar();">
                    <i class="fa fa-floppy-o"></i> Guardar
                </button>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="mdlMProEstCam" tabindex="-1" role="dialog" aria-labelledby="divMdlMProEstCam" aria-hidden="true" >
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                
                <button type="button" class="close" data-dismiss="modal" aria-label="Close" onclick="Proveedor.EstatusCambiarModalCerrar();">
                    <span aria-hidden="true">&times;</span>
                </button>
                <h2 class="modal-title" id="divMdlMProEstCam">
                    <i class="fa fa-refresh"></i> Cambio de estatus - <b class="text-danger" id="lblMdlMProEstCamTitulo"></b>
                    <br />
                    <small> 
                        Estatus Actual <b class="text-info" id="lblMdlMProEstCamSubtitulo"></b>
                    </small>
                </h2>
                <button type="button" class="btn btn-white pull-right" onclick="Proveedor.EstatusCambiarModalFormularioLimpiar()">
                    <i class="fa fa-trash-o"></i> Limpiar
                </button>
                
            </div>
            <div class="modal-body">
                
                <input type="hidden" id="hidMdlMProEstCamTA_ID">
                <input type="hidden" id="hidMdlMProEstCamOV_ID"">
                
                <div class="form-group row">

                    <label class="col-sm-2 control-label">Estatus:</label>    
                    <div class="col-sm-4 m-b-xs">
<%
    CargaCombo("selMdlMProEstCamEstatus", "class='form-control' onchange='Proveedor.EstatusCambiarModalEstatusCambiar();'", "CAT_ID", "CAT_Nombre", "CAT_Catalogo", "CAT_ID IN (6,7,8,9,10,22) AND SEC_ID = 51", "CAT_Nombre DESC", "", cxnTipo, "SELECCIONAR","")
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

<div class="modal fade" id="mdlEntSegEnt" tabindex="-1" role="dialog" aria-labelledby="divEntSegEnt" aria-hidden="true" style="display: none;">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
                <h2 class="modal-title" id="divEntSegEnt">
                    <i class="fa fa-file-text-o"></i> Entrega 
                    <br />
                    <small>Entrega</small>
                </h2>
                
            </div>
            <div class="modal-body" id="mdlEntSegEntBody">

                
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-secondary btn-seg" data-dismiss="modal">
                    <i class="fa fa-times"></i> Cerrar
                </button>
                
            </div>
        </div>
    </div>
</div>