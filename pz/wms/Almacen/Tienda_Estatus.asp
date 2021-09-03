<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2021-JUN-03 Tiedas y entregas: Creación de archivo

var cxnTipo = 0

var urlBase = "/pz/wms/Almacen/"
var urlBaseTemplate = "/Template/inspina/";

var rqIntAlm_ID = Parametro("Alm_ID", -1);
%>

<link href="<%= urlBaseTemplate %>css/plugins/select2/select2.min.css" rel="stylesheet">

<link href="<%= urlBaseTemplate %>css/plugins/daterangepicker/daterangepicker-bs3.css" rel="stylesheet">

<!-- Select2 -->
<script src="<%= urlBaseTemplate %>js/plugins/select2/select2.full.min.js"></script>
<!-- Date range use moment.js same as full calendar plugin -->
<script src="<%= urlBaseTemplate %>js/plugins/fullcalendar/moment.min.js"></script>
<!-- Date range picker -->
<script src="<%= urlBaseTemplate %>js/plugins/daterangepicker/daterangepicker.js"></script>
<!-- Loading -->
<script src="<%= urlBaseTemplate %>js/loading.js"></script>

<script src="<%= urlBaseTemplate %>js/lateralflotante.js"></script>

<script src="<%= urlBaseTemplate %>/js/plugins/sheetJs/xlsx.full.min.js"></script>

<!-- Librerias-->

<script type="text/javascript">

    $(document).ready(function(){  
       
        //Detalle
        $("#aTieVerMasVis").on("click", function(){
            Tienda.Detalle.VerMasVisualizar();
        });

        $("#aTieVerMasOcu").on("click", function(){
            Tienda.Detalle.VerMasOcultar();
        });

        //Buscar Entregas
        $("#btnEntBusLim").on("click", function(){
            Entregas.Buscar.FiltrosLimpiar();
        });

        $("#btnEntBusBus").on("click", function(){
            Entregas.Buscar.ListadoBuscar();
        });

        $("#btnCancelar").on("click", function(){
            Entregas.Cancelar();    
        });

        //Buscar Almacen
        $("#btnAlmLim").on("click", function(){
            Tienda.Buscar.FiltrosLimpiar();
        });

        $("#btnAlmBus").on("click", function(){
            Tienda.Buscar.ListadoBuscar( false );
        });


        //Rango de Fechas
        $('#inpEntFecBus').daterangepicker({
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
				$("#inpEntFecIni").val(moment.utc(start, 'MM/DD/YYYY').local().format('MM/DD/YYYY'))
				$("#inpEntFecFin").val(moment.utc(end, 'MM/DD/YYYY').local().format('MM/DD/YYYY'))
                $("#inpEntFecBus").val((moment.utc(start, 'DD/MM/YYYY').local().format('DD/MM/YYYY')) + " - " + (moment.utc(end, 'DD/MM/YYYY').local().format('DD/MM/YYYY')))
            }
        );

        Tienda.Detalle.Solicitar({
            Alm_ID: <%= rqIntAlm_ID %>
        });

       // Entregas.Buscar.ListadoBuscar(true);

    });

    var Tienda = {
        url: "/pz/wms/almacen/"
        , Detalle: {
              Solicitar: function( prmJson ){
                var bolError = false;
                var arrError = [];

                var intAlm_ID = prmJson.Alm_ID;

                if( intAlm_ID == ""){
                    bolError = false;
                    arrError.push("- Seleccionar el Identifcador de la Tienda");
                }

                if( bolError ) {
                    Avisa("warning", "Tienda - Detalle", "Verificar Formulario<br>" + arrError.join("<br>"));
                } else {
                    
                    $.ajax({
                        url: Entregas.url + "tienda_estatus_ajax.asp"
                        , method: "post"
                        , async: true
                        , dataType: "json"
                        , data: {
                            Tarea: 1000
                            , Alm_ID: intAlm_ID
                        }, success: function(res){
                            Tienda.Detalle.Cargar( res.Registro );

                            Entregas.Buscar.ListadoLimpiar( Entregas.Buscar.Tipo.Terminado );
                            Entregas.Buscar.ListadoLimpiar( Entregas.Buscar.Tipo.Pendiente );

                            Entregas.Buscar.ListadoBuscar( true );

                            Entregas.Buscar.FiltrosLimpiar();
                        }
                    });
                }
            }
            , Cargar: function( prmJson ){

                $("#Alm_ID").val( prmJson.Alm_ID );

                $("#lblTieAlm_Numero").text( prmJson.Alm_Numero );
                $("#lblTieAlm_Nombre").text( prmJson.Alm_Nombre );

                $("#lblTieTpo_Nombre").text( prmJson.Tpo_Nombre );

                $("#lblTieAlm_Responsable").text( prmJson.Alm_Responsable );
                $("#lblTieAlm_Telefono").text( prmJson.Alm_Telefono );
                $("#lblTieAlm_Email").text( prmJson.Alm_Email );
                $("#lblTieAlm_HorarioLV").text( prmJson.Alm_HorarioLV );
                $("#lblAlm_HorarioSabado").text( prmJson.Alm_HorarioSabado );
                $("#lblTieAlm_Domingo").text( prmJson.Alm_Domingo );

                $("#lblTieAlm_Direccion").text( prmJson.Alm_Direccion );

                $("#lblTieAlm_Latitud").text( prmJson.Alm_Latitud );
                $("#lblTieAlm_Longitud").text( prmJson.Alm_Longitud );

                $("#lblTieAlm_DistanciaKM").text( prmJson.Alm_DistanciaKM );
                $("#lblTieAlm_TiempoEntregaHrs").text( prmJson.Alm_TiempoEntregaHrs );

                Tienda.Detalle.VerMasOcultar();

            }
            , VerMasVisualizar: function(){
                $(".cssDetalle").show();
                $("#aTieVerMasVis").hide();
                $("#aTieVerMasOcu").show();
            }
            , VerMasOcultar: function(){
                $(".cssDetalle").hide();
                $("#aTieVerMasVis").show();
                $("#aTieVerMasOcu").hide();
            }
        }
        , Buscar: {
              RegistrosPagina: 100
            , Filtros: {
                  Texto: ""
                , Tag_IDs: ""
            }
            , FiltrosLimpiar: function(){
                $("#inpAlmTexto").val("");

                with(Tienda.Buscar.Filtros){
                    Texto = "";
                    Tag_IDs = "";
                }
            }
            , ListadoBuscar: function( prmBolVieTag ){
                var bolError = false;
                var arrError = [];

                var arrTag_IDs = [];
                var strTag_IDs = "";

                var strTexto = $("#inpAlmTexto").val();

               $(".cssTagReg").each(function(){

                    if( $(this).data("seleccionado") == 1 ){

                        var intTag_ID = $(this).data("tag_id");

                        arrTag_IDs.push( intTag_ID );
                    }

                });

                if( !(prmBolVieTag) ){

                    if(strTexto == ""){
                        bolError = true;
                        arrError.push("- Agregar texto a buscar");
                    }

                } else {
                    
                    if( arrTag_IDs.length == 0){
                        bolError = true;
                        arrError.push("A quitado todas las seleccionaes de TAGS");
                    }
                }               

                if( bolError ){
                    Avisa("warning", "Buscar - Tienda", "Verificar Formulario<br>" + arrError.join("<br>"));
                    Tienda.Buscar.ListadoLimpiar();

                } else {

                    strTag_IDs = arrTag_IDs.join(",");

                    with(Tienda.Buscar.Filtros){
                        Texto = strTexto;
                        Tag_IDs = strTag_IDs;
                    }

                    Tienda.Buscar.ListadoCargar( true );

                }
            }
            , ListadoCargar: function( prmBolIniBus ){
                
                var intReg =  $(".cssAlmReg").length;
                var intSigReg = ( prmBolIniBus ) ? 0: intReg;
                var intRegPags = $("#inpAlmRegPag").val();

                var intRegPag = (intRegPags == "" || intRegPags == undefined ) ? Tienda.Buscar.RegistrosPagina : intRegPags;

                if( prmBolIniBus ){
                    Tienda.Buscar.ListadoLimpiar();
                }

                Tienda.Buscar.ListadoVisualizar();

                Procesando.Visualizar({Contenedor: "divAlmCar"});

                $.ajax({
                    url: Tienda.url + "Tienda_Estatus_Almacen_Listado.asp"
                    , method: "post"
                    , async: true
                    , data: {
                          Texto: Tienda.Buscar.Filtros.Texto
                        , Tag_IDs: Tienda.Buscar.Filtros.Tag_IDs
                        , SiguienteRegistro: intSigReg
                        , RegistrosPagina: intRegPag
                    }
                    , success: function( res ){
                        Procesando.Ocultar();

                        if( prmBolIniBus ){
                            $("#ulAlmRes").html( res ); 
                        } else {
                            $("#ulAlmRes").append( res ); 
                        }

                        var objMas = "";

                        if( res != ""){

                            objMas = "<div class='row'>"
                                    + "<div class='col-sm-5'>"
                                        + "<button type='button' class='btn btn-white btn-block' onClick='Tienda.Buscar.ListadoCargar()'>"
                                            + "<i class='fa fa-arrow-down'></i> Ver mas"
                                        + "</button>" 
                                    + "</div>"
                                    + "<div class='col-sm-7 input-group'>"
                                        + "<input type='number' id='inpAlmRegPag' class='form-control text-right' placeholder='10' min='10' max='100' steep='10' value='10' maxlength='3' >"
                                        + "<span class='input-group-addon'> Reg/Pag </span>"
                                    + "</div>"
                                + "</div>"

                        } else if( prmBolIniBus ){
                            objMas = "<i class='fa fa-exclamation-circle fa-lg text-success'></i> No hay Registros"
                        }

                        $("#divAlmCar").html(objMas); 

                        Tienda.Buscar.ListadoRegistrosContar();
                    }
                    , error: function(){
                        Avisa("error", "Buscar - Tienda", "Error en la peticion");
                        Procesando.Ocultar();
                    }
                });

            }
            , ListadoLimpiar: function(){
                $("#ulAlmRes").html("");
                $("#lblAlmTotReg").text("");
                $("#divAlmCar").html("");
            }
            , ListadoVisualizar: function(){
                $("#divAlmRes").show();
            }
            , ListadoOcultar: function(){
                $("#divAlmRes").hide();
            }
            , Seleccionar: function( prmObj ){
                var objPad = $(prmObj).parents("li");

                var intAlm_ID = $(objPad).data("alm_id");

                var objThu = "<i class='text-success fa fa-thumbs-o-up fa-lg'></i>"

                $(objPad).find(".cssThumbs").html(objThu);
                $(objPad).removeClass("warning-element");
                $(objPad).addClass("success-element");                

                Tienda.Detalle.Solicitar({Alm_ID: intAlm_ID});
            }
            , ListadoRegistrosContar: function(){
                var intTerReg = $(".cssAlmReg").length;
                $("#lblAlmTotReg").text(intTerReg);
            }
        }
    }

    var TAG = {
        ListadoSeleccionar: function( prmObj ){
            var intSel = $(prmObj).data("seleccionado")
            var bolNoSel = ( parseInt(intSel) == 0 );

            if( bolNoSel ){
                $(prmObj)
                    .removeClass("btn-white")
                    .addClass("btn-success")
                    .data("seleccionado", 1);
            } else {
                $(prmObj)
                    .removeClass("btn-success")
                    .addClass("btn-white")
                    .data("seleccionado", 0);
            }

            Tienda.Buscar.ListadoBuscar( true );
            
        }
    }

    var Entregas = {
          url: "/pz/wms/Almacen/"
        , Buscar: {
              RegistrosPagina: 100
            , Estatus: {
                  Pendiente: 1
                , Picking: 2
                , Packing: 3
                , Shipping: 4
                , Transito: 5
                , Intento_1er: 6
                , Intento_2do: 7
                , Intento_3er: 8
                , Falla_entrega: 9
                , Entrega_exitosa: 10
                , Cancelado: 11
                , Devuelto: 16
            }
            , Filtros: {
                  Folio: ""
                , Estatus: -1
                , FechaBuscar: ""
                , FechaInicial: ""
                , FechaFinal: ""
                , SKU: ""
                , EPC: ""
            }
            , Tipo: {
                Terminado: 1
                , Pendiente: 2
            }
            , FiltrosLimpiar: function(){
                $("#inpEntFol").val("");
                $("#selEntEst").val("-1");
                $("#inpEntFecBus").val("");
                $("#inpEntFecIni").val("");
                $("#inpEntFecFin").val("");
                $("#inpEntSKU").val("");
                $("#inpEntEPC").val("");

                with(Entregas.Buscar.Filtros){
                    Folio = "";
                    Estatus = "-1";
                    FechaBuscar = "";
                    FechaInicial = "";
                    FechaFinal = "";
                    SKU = "";
                    EPC = "";
                }
            }
            , ListadoBuscar: function( prmIntTipBus ){
                
                var bolError = false;
                var arrError = [];

                var intAlm_ID = $("#Alm_ID").val();

                var strFol = $("#inpEntFol").val();
                var intEst = $("#selEntEst").val();
                var dateFecBus = $("#inpEntFecBus").val();
                var dateFecIni = $("#inpEntFecIni").val();
                var dateFecFin = $("#inpEntFecFin").val();
                var strSKU = $("#inpEntSKU").val();
                var strEPC = $("#inpEntEPC").val();

                var arrTer = [
                      Entregas.Buscar.Estatus.Transito
                    , Entregas.Buscar.Estatus.Intento_1er
                    , Entregas.Buscar.Estatus.Intento_2do
                    , Entregas.Buscar.Estatus.Intento_3er
                    , Entregas.Buscar.Estatus.Falla_entrega
                    , Entregas.Buscar.Estatus.Entrega_exitosa
                    , Entregas.Buscar.Estatus.Cancelado
                    , Entregas.Buscar.Estatus.Devuelto
                ];

                var arrPen = [
                    Entregas.Buscar.Estatus.Pendiente
                    , Entregas.Buscar.Estatus.Picking
                    , Entregas.Buscar.Estatus.Packing
                    , Entregas.Buscar.Estatus.Shipping
                ];

                if( intAlm_ID <= -1 ){
                    bolError = true;
                    arrError.push("- No existe identificador de Tienda");
                }

                if( bolError ){
                    Avisa("warning", "Estatus de la Tienda - Buscar", "Verificar el formulario<br>" + arrError.join("<br>"));
                } else {

                    with(Entregas.Buscar.Filtros){
                        Folio = strFol;
                        Estatus = intEst;
                        FechaBuscar = dateFecBus;
                        FechaInicial = dateFecIni;
                        FechaFinal = dateFecFin;
                        SKU = strSKU;
                        EPC = strEPC;
                    }

                    if( !(parseInt(intEst) > -1) || ( parseInt(intEst) > -1 && arrTer.indexOf(parseInt(intEst)) >= 0 ) ){
                        Entregas.Buscar.ListadoTerminadoCargar( true );
                    }

                    if( !(parseInt(intEst) > -1) || ( parseInt(intEst) > -1 && arrPen.indexOf(parseInt(intEst)) >= 0 ) ){
                        Entregas.Buscar.ListadoPendienteCargar( true );
                    }
                    
                    console.log("intEst", intEst);
                    console.log("arrTer", arrTer);
                    console.log("arrPen", arrPen);

                    Entregas.Buscar.ListadoLimpiar();

                    Entregas.Transferencia.DetalleLimpiar();

                }
            }
            , ListadoTerminadoCargar: function( prmBolIniBus ){
                
                var intReg =  $(".cssEntTerReg").length;
                var intSigReg = ( prmBolIniBus ) ? 0: intReg;
                var intRegPags = $("#inpTerRegPag").val();

                var intRegPag = (intRegPags == "" || intRegPags == undefined ) ? Entregas.Buscar.RegistrosPagina : intRegPags;

                var intAlm_ID = $("#Alm_ID").val();

                if( prmBolIniBus ){
                    Entregas.Buscar.ListadoLimpiar( Entregas.Buscar.Tipo.Terminado );
                }

                Procesando.Visualizar({Contenedor: "divEntTerCar"});

                $.ajax({
                    url: Entregas.url + "Tienda_Estatus_Listado.asp"
                    , method: "post"
                    , async: true
                    , data: {
                          Tienda: intAlm_ID
                        , Folio: Entregas.Buscar.Filtros.Folio
                        , Estatus: Entregas.Buscar.Filtros.Estatus
                        , FechaBuscar: Entregas.Buscar.Filtros.FechaBuscar
                        , FechaInicial: Entregas.Buscar.Filtros.FechaInicial
                        , FechaFinal: Entregas.Buscar.Filtros.FechaFinal
                        , SKU: Entregas.Buscar.Filtros.SKU
                        , EPC: Entregas.Buscar.Filtros.EPC
                        , Tipo: Entregas.Buscar.Tipo.Terminado
                        , SiguienteRegistro: intSigReg
                        , RegistrosPagina: intRegPag
                    }
                    , success: function( res ){
                       Procesando.Ocultar();

                        if( prmBolIniBus ){
                            $("#ulEntTerRes").html( res ); 
                        } else {
                            $("#ulEntTerRes").append( res ); 
                        }

                        var objMas = "";

                        if( res != ""){

                            objMas = "<div class='row'>"
                                    + "<div class='col-sm-6'>"
                                        + "<button type='button' class='btn btn-white btn-block' onClick='Entregas.Buscar.ListadoTerminadoCargar()'>"
                                            + "<i class='fa fa-arrow-down'></i> Ver mas"
                                        + "</button>" 
                                    + "</div>"
                                    + "<div class='col-sm-5 input-group'>"
                                        + "<input type='number' id='inpTerRegPag' class='form-control text-right' placeholder='10' min='10' max='100' steep='1' value='100' maxlength='3' >"
                                        + "<span class='input-group-addon'> Reg/Pag </span>"
                                    + "</div>"
                                + "</div>"

                        } else if( prmBolIniBus ){
                            objMas = "<i class='fa fa-exclamation-circle fa-lg text-success'></i> No hay Registros"
                        }

                        $("#divEntTerCar").html(objMas); 

                        Entregas.Buscar.ListadoRegistrosContar( Entregas.Buscar.Tipo.Terminado );
                    }
                    , error: function(){
                        Avisa("error", "Tienda Estatus - Buscar", "Error en la peticion de Cargar Listado Terminados");
                        Procesando.Ocultar();
                    }
                });

            }
            , ListadoPendienteCargar: function( prmBolIniBus ){
                
                var intReg =  $(".cssEntPenReg").length;
                var intSigReg = ( prmBolIniBus ) ? 0: intReg;
                var intRegPags = $("#inpPenRegPag").val();

                var intRegPag = (intRegPags == "" || intRegPags == undefined ) ? Entregas.Buscar.RegistrosPagina : intRegPags;

                var intAlm_ID = $("#Alm_ID").val();

                if( prmBolIniBus ){
                    Entregas.Buscar.ListadoLimpiar( Entregas.Buscar.Tipo.Pendiente );
                }

                Procesando.Visualizar({Contenedor: "divEntPenCar"});

                $.ajax({
                    url: Entregas.url + "Tienda_Estatus_Listado.asp"
                    , method: "post"
                    , async: true
                    , data: {
                          Tienda: intAlm_ID
                        , Folio: Entregas.Buscar.Filtros.Folio
                        , Estatus: Entregas.Buscar.Filtros.Estatus
                        , FechaBuscar: Entregas.Buscar.Filtros.FechaBuscar
                        , FechaInicial: Entregas.Buscar.Filtros.FechaInicial
                        , FechaFinal: Entregas.Buscar.Filtros.FechaFinal
                        , SKU: Entregas.Buscar.Filtros.SKU
                        , EPC: Entregas.Buscar.Filtros.EPC
                        , Tipo: Entregas.Buscar.Tipo.Pendiente
                        , SiguienteRegistro: intSigReg
                        , RegistrosPagina: intRegPag
                    }
                    , success: function( res ){
                       Procesando.Ocultar();

                        if( prmBolIniBus ){
                            $("#ulEntPenRes").html( res ); 
                        } else {
                            $("#ulEntPenRes").append( res ); 
                        }

                        var objMas = "";

                        if( res != ""){

                            objMas = "<div class='row'>"
                                    + "<div class='col-sm-8'>"
                                        + "<button type='button' class='btn btn-white btn-block' onClick='Entregas.Buscar.ListadoPendienteCargar()'>"
                                            + "<i class='fa fa-arrow-down'></i> Ver mas"
                                        + "</button>" 
                                    + "</div>"
                                    + "<div class='col-sm-3 input-group'>"
                                        + "<input type='number' id='inpPenRegPag' class='form-control text-right' placeholder='10' min='10' max='100' steep='1' value='100' maxlength='3' >"
                                        + "<span class='input-group-addon'> Reg/Pag </span>"
                                    + "</div>"
                                + "</div>"

                        } else if( prmBolIniBus ){
                            objMas = "<i class='fa fa-exclamation-circle fa-lg text-success'></i> No hay Registros"
                        }

                        $("#divEntPenCar").html(objMas); 

                        Entregas.Buscar.ListadoRegistrosContar( Entregas.Buscar.Tipo.Pendiente );
                    }
                    , error: function(){
                        Avisa("error", "Tienda Estatus - Buscar", "Error en la peticion de Cargar Listado Pendientes");
                        Procesando.Ocultar();
                    }
                });

            }
            , ListadoRegistrosContar: function( intTpoLis ){
                switch(intTpoLis) {
                    case Entregas.Buscar.Tipo.Terminado: {
                        var intTerReg = $(".cssEntTerReg").length;
                        $("#lblEntTerTotReg").text(intTerReg);
                    } break;

                    case Entregas.Buscar.Tipo.Pendiente: {
                        var intPenReg = $(".cssEntPenReg").length;
                        $("#lblEntPenTotReg").text(intPenReg);
                    } break;
                }   
            }
            , ListadoLimpiar: function( intTpoLis ){
                
                switch(intTpoLis) {
                    case Entregas.Buscar.Tipo.Terminado: {
                        $("#lblEntTerTotReg").text("");
                        $("#ulEntTerRes").html("");
                        $("#divEntTerCar").html("");
                    } break;

                    case Entregas.Buscar.Tipo.Pendiente: {
                        $("#lblEntPenTotReg").text("");
                        $("#ulEntPenRes").html("");
                        $("#divEntPenCar").html("");
                    } break;
                }                        
            }
        }
        , Cancelar: function(){
            var bolError = false;
            var arrError = [];

            var objCan = $(".cssCancelar:checked");

            if( objCan.length == 0 ){
                bolError = true;
                arrError.push("- Seleccionar al menos una Transferencia a ser cancelada");
            }

            if( bolError ){
                Avisa("warning", "Entrega - Cancelar", "Verificar Formulario<br>" + arrError.join("<br>"));
            } else {

                swal({
                    title: "Cancelar las Entregas",
                    text: "Desea cancelar las Entregas seleccionadas ",
                    type: "warning",
                    showCancelButton: true,
                    confirmButtonColor: "#ec4758",
                    confirmButtonText: "Confirmar",
                    closeOnConfirm: false
                }
                , function(){

                    Cargando.Iniciar();

                    //Ejecutar Ajax
                    setTimeout(() => {
                        Avisa("error", "Entregas - Cancelar", "Falta agregar proceso de cancelacion por API");
                        Cargando.Finalizar();
                        swal.close();
                    }, 1000);
                });
            }
        }
        , Transferencia: {
            DetalleLimpiar: function(){
                $("#divEntDet").html("").hide();
            }
            , DetalleVer: function( prmJson ){
                var bolError = false;
                var arrError = [];

                var intTA_ID = prmJson.TA_ID;

                if( !(intTA_ID > -1) ){
                    bolError = true;
                    arrError.push("- Identificador de Transferencia no permitido");
                }

                if( bolError ){
                    Avisa("warning", "Transferencia", "Verificar Formulario<br>" + arrError.join("<br>"));
                } else {

                    Cargando.Iniciar();

                    $.ajax({
                        url: "/pz/wms/TA/TA_Ficha.asp"
                        , method: "post"
                        , async: true
                        , data: {
                              TA_ID: intTA_ID
                            , EsTransportista: 1
                        }
                        , success: function( res ){
                            
                            $("#mdlEntDetVerBody").html( res );
                            $("#mdlEntDetVer").modal("show");
                            
                            Cargando.Finalizar()
                        }
                        , error: function(){
                            Avisa("error", "Transferencia", "Error en la peticion de carga detalle");
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
        <div class="row form-group">
            <div class="col-sm-9">
                <div class="ibox">
                    <div class="ibox-title">

                        <input type="hidden" id="Alm_ID" value="">

                        <h3 class="pull-right" id="lblTieTpo_Nombre"></h3>
                        <h2> 
                            <label id="lblTieAlm_Numero"></label> - <label  id="lblTieAlm_Nombre"></label>
                        </h2>
                        
                        
                    </div>

                    <div class="ibox-content">

                        <div class="row cssDetalle">
                            <div class="col-sm-12">
                                <h4>
                                    <i class="fa fa-vcard-o fa-lg"></i> Datos Generales
                                </h4>
                            </div>
                        </div>

                        <hr class="cssDetalle">

                        <div class="row cssDetalle">

                            <div class="col-sm-5">

                                <!--Datos de la Orden de compra-->
                                <dl class="dl-horizontal">
                                    <dt>Responsable:</dt>
                                        <dd id="lblTieAlm_Responsable"></dd>
                                    <dt>Tel&eacute;fono</dt>
                                        <dd id="lblTieAlm_Telefono"></dd>
                                    <dt>E-mail:</dt>
                                        <dd id="lblTieAlm_Email"></dd>
                                </dl>
                            
                            </div>

                            <div class="col-sm-5">

                                <!--Datos de la Orden de compra-->
                                <dl class="dl-horizontal">
                                    <dt>Lunes - Viernes:</dt>
                                        <dd id="lblTieAlm_HorarioLV"></dd>
                                    <dt>S&aacute;bado:</dt>
                                        <dd id="lblAlm_HorarioSabado"></dd>
                                    <dt>Domingo:</dt>
                                        <dd id="lblTieAlm_Domingo"></dd>
                                </dl>
                            
                            </div>

                        </div>

                        <div class="row cssDetalle" style="display: none;">
                            <div class="col-sm-12">
                                <h4>
                                    <i class="fa fa-map-o fa-lg"></i> Localizaci&oacute;n
                                </h4>
                            </div>
                        </div>

                        <hr class="cssDetalle" style="display: none;">

                        <div class="row cssDetalle" style="display: none;">

                            <div class="col-sm-12">

                                <!--Datos de la Orden de compra-->
                                <dl class="dl-horizontal">
                                    <dt>Direcci&oacute;n::</dt>
                                        <dd id="lblTieAlm_Direccion"></dd>
                                </dl>
                            
                            </div>

                        </div>

                        <div class="row cssDetalle" style="display: none;">

                            <div class="col-sm-5">

                                <!--Datos de la Orden de compra-->
                                <dl class="dl-horizontal">
                                    <dt>Latitud:</dt>
                                        <dd id="lblTieAlm_Latitud"></dd>
                                    <dt>Longitud:</dt>
                                        <dd id="lblTieAlm_Longitud"></dd>
                                </dl>

                            </div>

                            <div class="col-sm-5">

                                <!--Datos de la Orden de compra-->
                                <dl class="dl-horizontal">
                                    <dt>Distancia:</dt>
                                        <dd id="lblTieAlm_DistanciaKM"></dd>
                                    <dt>Tiempo Entega:</dt>
                                        <dd id="lblTieAlm_TiempoEntregaHrs"></dd>
                                </dl>

                            </div>

                        </div>

                        <div class="row form-group">
                            <label class="col-sm-12 control-label text-success text-right">
                                <a id="aTieVerMasVis" class="link">
                                    <i class="fa fa-caret-down"></i> Ver m&aacute;s ...
                                </a>
                                <a id="aTieVerMasOcu" class="link" style="display: none;">
                                    <i class="fa fa-caret-up"></i> Ocultar
                                </a>
                            </label>
                        </div>

                    </div>
                </div>

                <div class="ibox">
                    <div class="ibox-title">
                        <h5>Filtros</h5>
                        <div class="ibox-tools">
                            
                            <button class="btn btn-white btn-sm" type="button" id="btnEntBusLim">
                                <i class="fa fa-trash-o"></i> Limpiar
                            </button>

                            <button class="btn btn-success btn-sm" type="button" id="btnEntBusBus">
                                <i class="fa fa-search"></i> Buscar
                            </button>

                        </div>
                    </div>

                    <div class="ibox-content">

                        <div class="row form-group">
                            
                            <label class="col-sm-2 control-label">Folio:</label>
                            <div class="col-sm-4">
                                <input type="text" class="form-control" id="inpEntFol" placeholder="Folio de TRA"
                                 autocomplete="off" maxlength="50">
                            </div>

                            <label class="col-sm-2 control-label">Estatus:</label>
                            <div class="col-sm-4">
<%
    CargaCombo("selEntEst", "class='form-control select2'", "Cat_ID", "Cat_nombre", "Cat_Catalogo", "SEC_ID = 51 AND Cat_ID IN ( 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 16 )", "Cat_Nombre ASC", "", cxnTipo, "TODOS", "-1")
%>
                            </div>

                        </div>

                        <div class="row form-group">
                            
                            <label class="col-sm-2 control-label">Fecha:</label>
                            <div class="col-sm-4">
                                <input type="text" class="form-control" id="inpEntFecBus" placeholder="Rango de Fechas"
                                 autocomplete="off" maxlength="50">

                                <input type="hidden" id="inpEntFecIni">
                                <input type="hidden" id="inpEntFecFin">
                            </div>

                            <label class="col-sm-2 control-label">SKU:</label>
                            <div class="col-sm-4">
                                <input type="text" class="form-control" id="inpEntSKU" placeholder="SKU"
                                 autocomplete="off" maxlength="50">
                            </div>

                        </div>

                        <div class="row form-group">
                            
                            <label class="col-sm-2 control-label">Serie o EPC:</label>
                            <div class="col-sm-4">
                                <input type="text" class="form-control" id="inpEntEPC" placeholder="Serie o EPC"
                                 autocomplete="off" maxlength="50">
                            </div>

                            <label class="col-sm-2 control-label"></label>
                            <div class="col-sm-4">

                            </div>
                        </div>

                    </div>
                    <div class="ibox-footer">
                        <div class="ibox-tools">
                            <!--
                            <button type="button" class="btn btn-danger " id="btnCancelar">
                                <i class="fa fa-times"></i> Cancelar
                            </button>
                            -->
                        </div>
                    </div>

                </div>

                <div class="row form-group">

                    <div class="col-sm-6">

                        <div class="ibox">
                            <div class="ibox-title">
                                <h5>Entregadas / Canceladas</h5>
                                <div class="ibox-tools">

                                    <label class="pull-right form-group">
                                        <span class="text-success" id="lblEntTerTotReg">

                                        </span> Registros
                                    </label>

                                </div>
                            </div>
                            <div class="ibox-content">
                                <div class="row form-group"> 
                                    <ul id="ulEntTerRes" class="sortable-list connectList agile-list ui-sortable">

                                    </ul>
                                </div>
                            </div>
                            <div class="ibox-footer" id="divEntTerCar">
                                
                            </div>

                        </div>

                    </div>

                    <div class="col-sm-6">

                        <div class="ibox">
                            <div class="ibox-title">
                                <h5>Pendientes</h5>
                                <div class="ibox-tools">

                                    <label class="pull-right form-group">
                                        <span class="text-success" id="lblEntPenTotReg">

                                        </span> Registros
                                    </label>

                                </div>
                            </div>
                            <div class="ibox-content">
                                <div class="row form-group"> 
                                    <ul id="ulEntPenRes" class="sortable-list connectList agile-list ui-sortable">

                                        

                                    </ul>
                                </div>
                            </div>
                            <div class="ibox-footer" id="divEntPenCar">

                            </div>

                        </div>

                    </div>

                </div>

            </div>
            <div class="col-sm-3" id="divAlmBus">
                
                <div class="ibox">
                    <div class="ibox-title">
                        <h3><i class="fa fa-tags fa-lg"></i> Tags</h3>
                    </div>

                    <div class="ibox-content">

                        <div class="file-manager">
                            <ul class="" style="padding: 0; overflow-y: overlay; max-height: 200px;">
<%
    var sqlTag = "SPR_TAG "
          + "@Opcion = 1010 "
        + ", @SelAlmacen = 1 "

    var rsTag = AbreTabla(sqlTag, 1, cxnTipo)

    while( !(rsTag.EOF) ){
%>
                                <li style="list-style: none;">
                                    <a class="cssTagReg btn btn-white btn-sm" onclick='TAG.ListadoSeleccionar(this);'
                                    data-tag_id='<%= rsTag("Tag_ID").Value %>' data-seleccionado="0"
                                    style="margin-right: 5px; margin-top: 5px;">
                                        <i class="fa fa-tag"></i> <%= rsTag("Tag_Nombre").Value %>
                                    </a>
                                </li>
<%
        rsTag.MoveNext()
    }

    rsTag.Close()
%>
                            </ul>
                        </div>

                    </div>
                </div>

                <div class="ibox">
                    <div class="ibox-title">
                        <h3>Filtros Almac&eacute;n</h3>
                    </div>

                    <div class="ibox-content">

                        <div class="row">

                            <div class="col-sm-12 input-group">

                                <input type="text" class="input input-sm form-control" id="inpAlmTexto"
                                 placeholder="Buscar" autocomplete="off" maxlength="50">
                                <span class="input-group-btn">
                                    <button type="button" class="btn btn-sm btn-white" id="btnAlmLim"> 
                                        <i class="fa fa-trash-o" title="Limpiar"></i> 
                                    </button>
                                    <button type="button" class="btn btn-sm btn-success" id="btnAlmBus"> 
                                        <i class="fa fa-search" title="Buscar"></i> 
                                    </button>
                                </span>

                            </div>

                        </div>

                    </div>
                </div>

                <div class="ibox" id="divAlmRes" style="display: none;">
                    <div class="ibox-title">
                        <h5>Resultados</h5>
                            <div class="ibox-tools">

                                <label class="pull-right form-group">
                                    <span class="text-success" id="lblAlmTotReg">

                                    </span> Registros
                                </label>

                            </div>
                    </div>

                    <div class="ibox-content">
                        <div class="row form-group"> 
                            <ul id="ulAlmRes" class="sortable-list connectList agile-list ui-sortable">

                                

                            </ul>
                        </div>
                    </div>
                    <div class="ibox-footer" id="divAlmCar">

                    </div>

                </div>

            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="mdlEntDetVer" tabindex="-1" role="dialog" aria-labelledby="divEntDetVer" aria-hidden="true" style="display: none;">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
                <h2 class="modal-title" id="divEntDetVer">
                    <i class="fa fa-file-text-o"></i> Entrega 
                    <br />
                    <small>Entrega</small>
                </h2>
                
            </div>
            <div class="modal-body" id="mdlEntDetVerBody">

                
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-secondary btn-seg" data-dismiss="modal">
                    <i class="fa fa-times"></i> Cerrar
                </button>
                
            </div>
        </div>
    </div>
</div>