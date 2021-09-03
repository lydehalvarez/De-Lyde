<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2020-JUL-07 Manifiestos: Creación de archivo

var cxnTipo = 0

var urlBase = "/pz/wms/"
var urlBaseTemplate = "/Template/inspina/";

//Verificacion de Usuario Login
var bolEsTransportista = Parametro("Transportista", 0);
var intProv_ID = Parametro("Prov_ID", -1);

var strMan_Folio = Parametro("Man_Folio", "")
var bolFiltrar = false;

if( strMan_Folio != ""){
    bolFiltrar = true;
}
%>
<link href="<%= urlBaseTemplate %>css/plugins/select2/select2.min.css" rel="stylesheet">
<link href="<%= urlBaseTemplate %>css/plugins/daterangepicker/daterangepicker-bs3.css" rel="stylesheet">

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

<script type="text/javascript">

    $(document).ready(function(){
    
        $(".select2").select2();

        $('#inpPrvManMan_FechaBusca').daterangepicker({
			"showDropdowns": true,
			"firstDay": 7,	
			"startDate":moment().startOf('month'),
			"endDate": moment(),
            "autoApply": true,
			"ranges": {
               'Hoy': [moment(), moment()],
			   'Al dia de hoy': [moment().startOf('month'), moment()],
			   'Este Mes': [moment().startOf('month'), moment().endOf('month')],
			   'Mes pasado': [moment().subtract(1, 'month').startOf('month')
			                , moment().subtract(1, 'month').endOf('month')],		   
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
			}}, function(start, end, label) {
				$("#inpPrvManMan_FechaInicial").val(moment.utc(start, 'MM/DD/YYYY').local().format('MM/DD/YYYY'))
				$("#inpPrvManMan_FechaFinal").val(moment.utc(end, 'MM/DD/YYYY').local().format('MM/DD/YYYY'))
                $("#inpPrvManMan_FechaBusca").val((moment.utc(start, 'DD/MM/YYYY').local().format('DD/MM/YYYY')) + " - " + (moment.utc(end, 'DD/MM/YYYY').local().format('DD/MM/YYYY')))
            }
        );
<%
    //HA ID: 4 INI
    if( bolFiltrar ){
%>
        Manifiesto.Buscador.ListadoBuscar();
<%
    }
%>
    });

    var Manifiesto = {
          url: "/pz/wms/Proveedor/" 
        , EsTransportista: <%= bolEsTransportista %>
        , Buscador: {
              Filtros: {
                  Man_Prov_ID: -1
                , Man_Guia: ""
                , Man_Folio: ""
                , Man_FechaInicial: ""
                , Man_FechaFinal: ""
                , Man_Edo_ID: -1
                , Man_TpL_ID: -1
                , Ent_Guia: ""
                , Ent_Folio: ""
                , Ent_Est_ID: -1
            }   
            , Limpiar: function(){
                $("#inpPrvManMan_Guia").val("");
                $("#inpPrvManMan_Folio").val("");
                $("#inpPrvManMan_FechaBusca").val("");
                $("#inpPrvManMan_FechaInicial").val("");
                $("#inpPrvManMan_FechaFinal").val("");
                $("#selPrvManMan_Edo_ID").val("-1");

                $("#inpPrvManEnt_Guia").val("");
                $("#inpPrvManEnt_Folio").val("");
                $("#selPrvManEnt_Est_ID").val("-1");
                
                $("#select2-selPrvManMan_Edo_ID-container").text("TODOS");
                $("#select2-selPrvManEnt_Est_ID-container").text("TODOS");

                $("#radPrvManMan_TpL_IDAmbos").prop("checked", true);

                if( Manifiesto.EsTransportista == 0 ) {

                    $("#objPrvManMan_Prov_ID").val("-1");
                    $("#select2-objPrvManMan_Prov_ID-container").text("TODOS");

                    Manifiesto.Buscador.Filtros.Man_Prov_ID = -1
                }

                Manifiesto.Buscador.Filtros.Man_Guia = "";
                Manifiesto.Buscador.Filtros.Man_Folio = "";
                Manifiesto.Buscador.Filtros.Man_FechaInicial = "";
                Manifiesto.Buscador.Filtros.Man_FechaFinal = "";
                Manifiesto.Buscador.Filtros.Man_Edo_ID = -1;
                Manifiesto.Buscador.Filtros.Man_TpL_ID = -1;

                Manifiesto.Buscador.Filtros.Ent_Guia = "";
                Manifiesto.Buscador.Filtros.Ent_Folio = "";
                Manifiesto.Buscador.Filtros.Ent_Est_ID = -1;          

            }
            , Filtrar: function(){
                
                var bolError = false;
                var arrError = [];

                var bolTrans = (Manifiesto.EsTransportista == 1);

                var intMan_Prov_ID = $("#objPrvManMan_Prov_ID").val();

                var strMan_Guia = $("#inpPrvManMan_Guia").val();
                var strMan_Folio = $("#inpPrvManMan_Folio").val();
                var dateMan_FechaInicial = $("#inpPrvManMan_FechaInicial").val();
                var dateMan_FechaFinal = $("#inpPrvManMan_FechaFinal").val();
                var intMan_Edo_ID = $("#selPrvManMan_Edo_ID").val();
                var intMan_TpL_ID = $("input[name=radPrvManMan_TpL_ID]:checked").val();

                var strEnt_Guia = $("#inpPrvManEnt_Guia").val();
                var strEnt_Folio = $("#inpPrvManEnt_Folio").val();
                var intMan_Est_ID = $("#selPrvManEnt_Est_ID").val();

                var intIDUsuario = $("#IDUsuario").val(); 

                if( ( bolTrans || ( !(bolTrans) && intMan_Prov_ID == -1 ) )
                    && strMan_Guia == ""
                    && strMan_Folio == ""
                    && dateMan_FechaInicial == ""
                    && dateMan_FechaFinal == ""
                    && intMan_Edo_ID == -1
                    && intMan_TpL_ID == -1
                    && strEnt_Guia == ""
                    && strEnt_Folio == ""
                    && intMan_Est_ID == -1
                ){
                    bolError = true;
                }

                if( bolError ){
                    Avisa("warning", "Manifiesto - Buscar", "Seleccionar al menos un filtro");
                } else {
                    
                    Manifiesto.Buscador.Filtros.Man_Prov_ID = intMan_Prov_ID;
                    Manifiesto.Buscador.Filtros.Man_Guia = strMan_Guia;
                    Manifiesto.Buscador.Filtros.Man_Folio = strMan_Folio;
                    Manifiesto.Buscador.Filtros.Man_FechaInicial = dateMan_FechaInicial;
                    Manifiesto.Buscador.Filtros.Man_FechaFinal = dateMan_FechaFinal;
                    Manifiesto.Buscador.Filtros.Man_Edo_ID = intMan_Edo_ID;
                    Manifiesto.Buscador.Filtros.Man_TpL_ID = intMan_TpL_ID;

                    Manifiesto.Buscador.Filtros.Ent_Guia = strEnt_Guia;
                    Manifiesto.Buscador.Filtros.Ent_Folio = strEnt_Folio;
                    Manifiesto.Buscador.Filtros.Ent_Est_ID = intMan_Est_ID;

                    Manifiesto.Listado.Cargar( true );
                }
            }
        }
        , Listado: {
              RegistrosPagina: 10
            , Cargar: function( prmBolIniciaBusqueda ){

                var intRegistros =  $(".cssTrPrvManLisReg").length;
                var intIDUsuario = $("#IDUsuario").val();
                var intSiguienteRegistro = ( prmBolIniciaBusqueda ) ? 0 : intRegistros;
                var intRegistrosPagina = $("#inpPrvManLisRegPag").val();

                var intRegPag = (intRegistrosPagina == "" || intRegistrosPagina == undefined ) ? Manifiesto.Listado.RegistrosPagina : intRegistrosPagina;

                if( prmBolIniciaBusqueda ){
                    $("#tbPrvManLis").html("");
                    $("#lblPrvManLisTot").text("");
                } 

                $.ajax({
                    url: Manifiesto.url + "Proveedor_Manifiestos_Listado.asp"
                    , method: "post"
                    , async: true
                    , data: {
                          Man_Prov_ID: Manifiesto.Buscador.Filtros.Man_Prov_ID
                        , Man_Guia: Manifiesto.Buscador.Filtros.Man_Guia
                        , Man_Folio: Manifiesto.Buscador.Filtros.Man_Folio
                        , Man_FechaInicial: Manifiesto.Buscador.Filtros.Man_FechaInicial
                        , Man_FechaFinal: Manifiesto.Buscador.Filtros.Man_FechaFinal 
                        , Man_Edo_ID: Manifiesto.Buscador.Filtros.Man_Edo_ID
                        , Man_TpL_ID: Manifiesto.Buscador.Filtros.Man_TpL_ID

                        , Ent_Guia: Manifiesto.Buscador.Filtros.Ent_Guia
                        , Ent_Folio: Manifiesto.Buscador.Filtros.Ent_Folio
                        , Ent_Est_ID: Manifiesto.Buscador.Filtros.Ent_Est_ID

                        , IDUsuario: intIDUsuario
                        , SiguienteRegistro: intSiguienteRegistro
                        , RegistrosPagina: intRegPag
                        , Transportista: Manifiesto.EsTransportista
                    }
                    , beforeSend: function(){
                        if( prmBolIniciaBusqueda ){
                            Procesando.Visualizar({Contenedor: "divPrvManLis"});
                        } else {
                            Procesando.Visualizar({Contenedor: "tfPrvManLisCar"});
                        }
                    }
                    , success: function(res){

                        var bolRes = false;

                        if( $(res).find("#tbPrvManLis").html().trim() != "" ){
                            bolRes = true;
                        }
                        console.log(bolRes)

                        if(prmBolIniciaBusqueda){
                            $("#divPrvManLis").html( res ); 
                        } else {
                            $("#tbPrvManLis").append( $(res).find("#tbPrvManLis").html() );
                        }
                        var objMas = "";

                        if( bolRes ){
                            objMas = "<div class='row'>"
                                    + "<div class='col-sm-9'>"
                                        + "<button type='button' class='btn btn-white btn-block' onClick='Manifiesto.Listado.Cargar(false)'>"
                                            + "<i class='fa fa-arrow-down'></i> Ver mas"
                                        + "</button>" 
                                    + "</div>"
                                    + "<div class='col-sm-2 input-group'>"
                                        + "<input type='number' id='inpPrvManRegPag' class='form-control text-right' placeholder='10' min='10' max='100' steep='10' value='10' maxlength='3' >"
                                        + "<span class='input-group-addon'> Reg/Pag </span>"
                                    + "</div>"
                                + "</div>"

                        } else if( prmBolIniciaBusqueda ) {
                            objMas = "<i class='fa fa-exclamation-circle fa-lg text-success'></i> No hay Registros"
                        }

                        $("#tfPrvManLisCar").html(objMas);

                        Manifiesto.Listado.RegistrosContar();

                    }
                    , error: function(){
                        Avisa("error","Manifiestos - Listado", "Error en la peticion")                        
                    }
                    , complete: function(){
                        Procesando.Ocultar();
                    }
                })
                
            }
            , RegistrosContar: function(){
                var intRegistros = $(".cssTrPrvManLisReg").length;

                $("#lblPrvManLisTot").text(intRegistros);
            }
        }
        , Detalle: {

            Visualizar: function(){
                $(".cssPrvManDetalle").show();
                $("#aPrvManDetVer").hide();
                $("#aPrvManDetOcultar").show();
            }
            , Ocultar: function(){
                $(".cssPrvManDetalle").hide();
                $("#aPrvManDetVer").show();
                $("#aPrvManDetOcultar").hide();
            }
        }
        , Guias: {
              Listado: {
                Cargar: function( jsonPrm ){

                    var bolError = false;
                    var arrError = [];
                    
                    var intMan_ID = jsonPrm.Man_ID;
                    var objBase = jsonPrm.Objeto;
                    var objPadre = $(objBase).parents("tr");

                    if( intMan_ID == -1 ){
                        bolError = true;
                        arrError.push("Identificador de Manifiesto no permitido");
                    }

                    if( bolError ){
                        Avisa("warning", "Manifiesto - Guias - Listado", "Verificar Formulario<br>" + arrError.join("<br>") );
                    } else {

                        $.ajax({
                            url: Manifiesto.url + "Proveedor_Manifiestos_Guias_Listado.asp"
                            , method: "post"
                            , async: true
                            , data: {
                                Man_ID: intMan_ID
                            }
                            , beforeSend: function(){
                                Cargando.Iniciar();
                            }
                            , success: function(res){

                                var objObjTr = "<tr id='trGuia_" + intMan_ID + "'>"
                                        + "<td colspan='8'>" 
                                            + res 
                                        + "<td>"
                                    + "</tr>";

                                $(objObjTr).insertAfter(objPadre);

                                Manifiesto.Guias.Listado.RegistrosContar({Man_ID: intMan_ID});

                                $("#btnManGuiaVisualizar", objPadre).hide();
                                $("#btnManGuiaOcultar", objPadre).show();
                            }
                            , error: function(){
                                Avisa("error","Manifiesto - Guia - Listado", "Error en la peticion");
                            }
                            , complete: function(){
                                Cargando.Finalizar();
                            }
                        });
                    }

                }
                , Remover: function( jsonPrm ){
                    var intMan_ID = jsonPrm.Man_ID;
                    var objBase = jsonPrm.Objeto;
                    var objPadre = $(objBase).parents("tr");

                    $("#trGuia_" + intMan_ID).remove();

                    $("#btnManGuiaVisualizar", objPadre).show();
                    $("#btnManGuiaOcultar", objPadre).hide();
                }
                , RegistrosContar: function( jsonPrm ){

                    var intMan_ID = jsonPrm.Man_ID;
                    var objPadre = $("#trGuia_" + intMan_ID);

                    var intTotReg = $(".cssTrManGuiLisReg", $(objPadre)).length;

                    $("#lblManGuiLisTot", objPadre).text(intTotReg);
                }
            }
        }
        , Documentos: {
              Listado: {
                Cargar: function( jsonPrm ){

                    var bolError = false;
                    var arrError = [];
                    
                    var intMan_ID = jsonPrm.Man_ID;
                    var objBase = jsonPrm.Objeto;
                    var objPadre = $(objBase).parents("tr");

                    if( intMan_ID == -1 ){
                        bolError = true;
                        arrError.push("Identificador de Manifiesto no permitido");
                    }

                    if( bolError ){
                        Avisa("warning", "Manifiesto - Documentos - Listado", "Verificar Formulario<br>" + arrError.join("<br>") );
                    } else {

                        $.ajax({
                            url: Manifiesto.url + "Proveedor_Manifiestos_Documentos_Listado.asp"
                            , method: "post"
                            , async: true
                            , data: {
                                Man_ID: intMan_ID
                            }
                            , beforeSend: function(){
                                Cargando.Iniciar();
                            }
                            , success: function(res){

                                var objObjTr = "<tr id='trManDoc_" + intMan_ID + "'>"
                                        + "<td colspan='8'>" 
                                            + res 
                                        + "<td>"
                                    + "</tr>";

                                $(objObjTr).insertAfter(objPadre);

                                Manifiesto.Documentos.Listado.RegistrosContar({Man_ID: intMan_ID});

                                $("#btnManDocVisualizar", objPadre).hide();
                                $("#btnManDocOcultar", objPadre).show();
                            }
                            , error: function(){
                                Avisa("error","Manifiesto - Documento - Listado", "Error en la peticion");
                            }
                            , complete: function(){
                                Cargando.Finalizar();
                            }
                        });
                    }

                }
                , Remover: function( jsonPrm ){
                    var intMan_ID = jsonPrm.Man_ID;
                    var objBase = jsonPrm.Objeto;
                    var objPadre = $(objBase).parents("tr");

                    $("#trManDoc_" + intMan_ID).remove();

                    $("#btnManDocVisualizar", objPadre).show();
                    $("#btnManDocOcultar", objPadre).hide();
                }
                , RegistrosContar: function( jsonPrm ){

                    var intMan_ID = jsonPrm.Man_ID;
                    var objPadre = $("#trManDoc_" + intMan_ID);

                    var intTotReg = $(".cssTrManDocManLisReg", $(objPadre)).length;

                    $("#lblManDocManLisTot", objPadre).text(intTotReg);
                }
            }
            , Visualizar: function( prmJson ){

                var strArc_Nombre = prmJson.Arc_Nombre;
                var strArc_Ruta = prmJson.Arc_Ruta;

                var strArc_Url = strArc_Ruta + strArc_Nombre;

                $("#mdlPrvManDocBody").html("");

                var objBase = "";

                if( strArc_Nombre.indexOf(".pdf") > -1) {
                    
                    objBase = "<iframe id='ifrMdlPrvManDoc' width='100%' height='100%' frameborder='0' scrolling='yes' src=" + strArc_Url + "></iframe>"
                    $("#mdlPrvManDocBody").html(objBase);

                } else if( strArc_Nombre.indexOf(".xml") > -1) {
                    
                    $.ajax({
                        url: strArc_Url
                        , dataType: "text"
                        , beforeSend: function(){
                            Cargando.Iniciar();
                        }
                        , success: function( res ){
                            objBase = "" + formatXml(res) + "";

                            $("#mdlPrvManDocBody").text(objBase);
                        }
                        , error: function(){
                            Avisa("error", "Manifiesto - Documento - Carga", "Error en la peticion");
                        }
                        , complete: function(){
                            Cargando.Finalizar();
                        }
                    });

                } else if( strArc_Nombre.indexOf(".jpg") > -1 
                    || strArc_Nombre.indexOf(".jpeg") > -1 
                    || strArc_Nombre.indexOf(".png") > -1
                    || strArc_Nombre.indexOf(".gif") > -1
                    || strArc_Nombre.indexOf(".bmp") > -1
                    ) {
                    
                    objBase = "<img src='" + strArc_Url + "' border='0'>";
                    $("#mdlPrvManDocBody").html(objBase);
                }

                $("#mdlPrvManDoc").modal('show');              
               
            }
        }
        , Senuelos: {
              Listado: {
                Cargar: function( jsonPrm ){

                    var bolError = false;
                    var arrError = [];
                    
                    var intMan_ID = jsonPrm.Man_ID;
                    var objBase = jsonPrm.Objeto;
                    var objPadre = $(objBase).parents("tr");

                    if( intMan_ID == -1 ){
                        bolError = true;
                        arrError.push("Identificador de Manifiesto no permitido");
                    }

                    if( bolError ){
                        Avisa("warning", "Manifiesto - Senuelos - Listado", "Verificar Formulario<br>" + arrError.join("<br>") );
                    } else {

                        $.ajax({
                            url: Manifiesto.url + "Proveedor_Manifiestos_Senuelos_Listado.asp"
                            , method: "post"
                            , async: true
                            , data: {
                                Man_ID: intMan_ID
                            }
                            , beforeSend: function(){
                                Cargando.Iniciar();
                            }
                            , success: function(res){

                                var objObjTr = "<tr id='trSenuelo_" + intMan_ID + "'>"
                                        + "<td colspan='8'>" 
                                            + res 
                                        + "<td>"
                                    + "</tr>";

                                $(objObjTr).insertAfter(objPadre);

                                Manifiesto.Senuelos.Listado.RegistrosContar({Man_ID: intMan_ID});

                                $("#btnManSenuelosVisualizar", objPadre).hide();
                                $("#btnManSenuelosOcultar", objPadre).show();
                            }
                            , error: function(){
                                Avisa("error","Manifiesto - Senuelos - Listado", "Error en la peticion");
                            }
                            , complete: function(){
                                Cargando.Finalizar();
                            }
                        });
                    }

                }
                , Remover: function( jsonPrm ){
                    var intMan_ID = jsonPrm.Man_ID;
                    var objBase = jsonPrm.Objeto;
                    var objPadre = $(objBase).parents("tr");

                    $("#trSenuelo_" + intMan_ID).remove();

                    $("#btnManSenuelosVisualizar", objPadre).show();
                    $("#btnManSenuelosOcultar", objPadre).hide();
                }
                , RegistrosContar: function( jsonPrm ){

                    var intMan_ID = jsonPrm.Man_ID;
                    var objPadre = $("#trSenuelo_" + intMan_ID);

                    var intTotReg = $(".cssTrManSnlLisReg", $(objPadre)).length;

                    $("#lblManSnlLisTot", objPadre).text(intTotReg);
                }
            }
        }
    }

    var Entregas = {
        url: "/pz/wms/Proveedor/"
        , EsTransportista: <%= bolEsTransportista %>
        , Listado:{
            Cargar: function( prmJson ){

                var bolError = false;
                var arrError = [];

                var intMan_ID = prmJson.Man_ID;

                if( !(intMan_ID > -1) ){
                    bolError = true;
                    arrError.push("Identificador de Manifiesto no permitido");
                }

                if( bolError ){
                    Avisa("warning", "Detalle - Ver", "Verificar Formulario<br>" + arrError.join("<br>"));
                } else {

                    $.ajax({
                        url: Entregas.url + "Proveedor_Manifiestos_Entregas_Listado.asp"
                        , method: "post"
                        , async: true
                        , data: {
                              Man_ID: intMan_ID
                            , Transportista: Entregas.EsTransportista
                        }
                        , beforeSend: function(){
                            Procesando.Visualizar({Contenedor: "divPrvManLis"});
                        }
                        , success: function( res ){
                            $("#divPrvManLis").html( res );

                            Entregas.Listado.RegistrosContar();
                        }
                        , error: function(){
                            Avisa("danger", "Manifiestos - Entregas", "Error en la peticion");
                        } 
                        , complete: function(){
                            Procesando.Ocultar();
                        }
                    });
                }
            }
            , RegistrosContar: function(){
                var intTotReg = $(".cssTrPrvManEntLisReg").length;
                $("#lblPrvManEntLisTot").text(intTotReg);
            }
        }
        , Detalle: {
            Ver: function( prmJson ){

                var intTA_ID = prmJson.TA_ID;
                var intOV_ID = prmJson.OV_ID;

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
                            , EsTransportista: Entregas.EsTransportista
                        }
                        , beforeSend: function(){
                            Procesando.Visualizar({Contenedor: "mdlPrvManEntBody"});
                        }
                        , success: function( res ){

                            $("#mdlPrvManEntBody").html( res );
                            $("#mdlPrvManEnt").modal("show");
                        
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
            , Redireccionar: function( prmJson ){

                var strFolio = prmJson.Folio;

                if( $("#Folio").length == 0 ){
                    
                    var objFolio = "<input type='hidden' id='Folio' name='Folio'>"

                    $("#wrapper").append( objFolio );
                } 

                $("#Folio").val(strFolio);
<%
    if( bolEsTransportista ){
%>
                CambiaVentana(27, 301);
<%
    } else {
%>
                CambiaVentana(19, 644);
<%
    }
%>
            }
        }
        , Documentos: {
              Listado: {
                Cargar: function( jsonPrm ){

                    var bolError = false;
                    var arrError = [];
                    
                    var intMan_ID = jsonPrm.Man_ID;
                    var objBase = jsonPrm.Objeto;
                    var objPadre = $(objBase).parents("tr");

                    if( intMan_ID == -1 ){
                        bolError = true;
                        arrError.push("Identificador de Manifiesto no permitido");
                    }

                    if( bolError ){
                        Avisa("warning", "Manifiesto - Entregas -Documentos - Listado", "Verificar Formulario<br>" + arrError.join("<br>") );
                    } else {

                        $.ajax({
                            url: Entregas.url + "Proveedor_Manifiestos_Entregas_Documentos_Listado.asp"
                            , method: "post"
                            , async: true
                            , data: {
                                Man_ID: intMan_ID
                            }
                            , beforeSend: function(){
                                Cargando.Iniciar();
                            }
                            , success: function(res){

                                var objObjTr = "<tr id='trEntDoc_" + intMan_ID + "'>"
                                        + "<td colspan='8'>" 
                                            + res 
                                        + "<td>"
                                    + "</tr>";

                                $(objObjTr).insertAfter(objPadre);

                                Entregas.Documentos.Listado.RegistrosContar({Man_ID: intMan_ID});

                                $("#btnEntDocVisualizar", objPadre).hide();
                                $("#btnEntDocOcultar", objPadre).show();
                            }
                            , error: function(){
                                Avisa("error","Manifiesto - Entregas - Documento - Listado", "Error en la peticion");
                            }
                            , complete: function(){
                                Cargando.Finalizar();
                            }
                        });
                    }

                }
                , Remover: function( jsonPrm ){
                    var intMan_ID = jsonPrm.Man_ID;
                    var objBase = jsonPrm.Objeto;
                    var objPadre = $(objBase).parents("tr");

                    $("#trEntDoc_" + intMan_ID).remove();

                    $("#btnEntDocVisualizar", objPadre).show();
                    $("#btnEntDocOcultar", objPadre).hide();
                }
                , RegistrosContar: function( jsonPrm ){

                    var intMan_ID = jsonPrm.Man_ID;
                    var objPadre = $("#trEntDoc_" + intMan_ID);

                    var intTotReg = $(".cssTrManDocEntLisReg", $(objPadre)).length;

                    $("#lblManDocEntLisTot", objPadre).text(intTotReg);
                }
            }
            , Visualizar: function( prmJson ){

                var strArc_Nombre = prmJson.Arc_Nombre;
                var strArc_Ruta = prmJson.Arc_Ruta;

                var strArc_Url = strArc_Ruta + strArc_Nombre;

                $("#mdlPrvManDocBody").html("");

                var objBase = "";

                if( strArc_Nombre.indexOf(".pdf") > -1) {
                    
                    objBase = "<iframe id='ifrMdlPrvManDoc' width='100%' height='100%' frameborder='0' scrolling='yes' src=" + strArc_Url + "></iframe>"
                    $("#mdlPrvManDocBody").html(objBase);

                } else if( strArc_Nombre.indexOf(".xml") > -1) {
                    
                    $.ajax({
                        url: strArc_Url
                        , dataType: "text"
                        , beforeSend: function(){
                            Cargando.Iniciar();
                        }
                        , success: function( res ){
                            objBase = "" + formatXml(res) + "";

                            $("#mdlPrvManDocBody").text(objBase);
                        }
                        , error: function(){
                            Avisa("error", "Manifiesto - Documento - Carga", "Error en la peticion");
                        }
                        , complete: function(){
                            Cargando.Finalizar();
                        }
                    });

                } else if( strArc_Nombre.indexOf(".jpg") > -1 
                    || strArc_Nombre.indexOf(".jpeg") > -1 
                    || strArc_Nombre.indexOf(".png") > -1
                    || strArc_Nombre.indexOf(".gif") > -1
                    || strArc_Nombre.indexOf(".bmp") > -1
                    ) {
                    
                    objBase = "<img src='" + strArc_Url + "' border='0'>";
                    $("#mdlPrvManDocBody").html(objBase);
                }

                $("#mdlPrvManDoc").modal('show');              
               
            }
        }
    };

function formatXml(xml) {
	var formatted = '';
	var reg = /(>)(<)(\/*)/g;
	xml = xml.replace(reg, '$1\r\n$2$3');
	var pad = 0;
	jQuery.each(xml.split('\r\n'), function(index, node)
	{
		var indent = 0;
		if (node.match( /.+<\/\w[^>]*>$/ ))
		{
			indent = 0;
		}
		else if (node.match( /^<\/\w/ ))
		{
			if (pad != 0)
			{
				pad -= 1;
			}
		}
		else if (node.match( /^<\w[^>]*[^\/]>.*$/ ))
		{
			indent = 1;
		}
		else
		{
			indent = 0;
		}
		var padding = '';
		for (var i = 0; i < pad; i++)
		{
			padding += '  ';
			
		}
		var nodo = node
		var T1 = ""
		var T2 = ""
		
		while (nodo.length > 135) {
			T1 += nodo.substring(0, 135);
			T1 += '\r\n';
			nodo = nodo.substring(135, nodo.length);			
		}
		nodo = T1 + nodo

		formatted += padding + nodo + '\r\n';
		pad += indent;
	});
	return formatted;
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
                            
                            <button class="btn btn-white btn-sm" type="button" id="btnLimpiar" onclick="Manifiesto.Buscador.Limpiar()">
                                <i class="fa fa-trash-o"></i> Limpiar
                            </button>

                            <button class="btn btn-success btn-sm" type="button" id="btnBuscar" onclick="Manifiesto.Buscador.Filtrar()">
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
        CargaCombo("objPrvManMan_Prov_ID", "class='form-control select2'", "Prov_ID", "Prov_Nombre", "Proveedor", "Prov_Habilitado = 1 AND Prov_EsPaqueteria = 1", "Prov_Nombre ASC", "", cxnTipo, "TODOS", "-1")
%>                                        
                                    </div>
<%  } else {
%>
                                    <input id="objPrvManMan_Prov_ID" type="hidden" value="<%= intProv_ID %>" />
<%
    }
%>
                                </div>

                                <div class="form-group row">

                                    <label class="col-sm-2 control-label">Gu&iacute;a Manifiesto: </label>    
                                    <div class="col-sm-4 m-b-xs">
                                        <input type="text" id="inpPrvManMan_Guia" class="form-control" placeholder="Gu&iacute;a Manifiesto"
                                         autocomplete="off" maxlength="50">
                                    </div>

                                    <label class="col-sm-2 control-label">Gu&iacute;a Entrega:</label>    
                                    <div class="col-sm-4 m-b-xs">
                                        <input type="text" id="inpPrvManEnt_Guia" class="form-control" placeholder="Gu&iacute;a Entrega"
                                         autocomplete="off" maxlength="50">
                                    </div>                              

                                </div>

                                <div class="form-group row">

                                    <label class="col-sm-2 control-label">Folio de  Manifiesto:</label>    
                                    <div class="col-sm-4 m-b-xs">
                                        <input type="text" id="inpPrvManMan_Folio" class="form-control" placeholder="Folio Manifiesto"
                                        autocomplete="off" maxlength="30">
                                    </div>

                                    <label class="col-sm-2 control-label">Folio Entrega:</label>    
                                    <div class="col-sm-4 m-b-xs">
                                        <input type="text" id="inpPrvManEnt_Folio" class="form-control" placeholder="Folio Entrega"
                                         autocomplete="off" maxlength="30" value="<%= strMan_Folio %>">
                                    </div>   
                                   
                                </div>

                                <div class="form-group row">

                                    <label class="col-sm-2 control-label">Rango fechas:</label>
                                    <div class="col-sm-4 m-b-xs">
                                        <div class="input-group">
                                            <input class="form-control date-picker date" id="inpPrvManMan_FechaBusca" 
                                                placeholder="dd/mm/aaaa - dd/mm/aaaa" type="text" value="" autocomplete="off" > 
                                            <span class="input-group-addon">
                                                <i class="fa fa-calendar"></i>
                                            </span>
                                        </div>
                                    </div>
                                    <input id="inpPrvManMan_FechaInicial" type="hidden" value="" />
                                    <input id="inpPrvManMan_FechaFinal" type="hidden" value="" />
                                    
                                    <label class="col-sm-2 control-label">Estatus de Entregas:</label>
                                    <div class="col-sm-4 m-b-xs">
<%
    CargaCombo("selPrvManEnt_Est_ID", "class='form-control select2'", "CAT_ID", "CAT_Nombre", "CAT_Catalogo", "CAT_ID IN (5,6,7,8,9,10,22) AND SEC_ID = 51", "CAT_Nombre DESC", "", cxnTipo, "TODOS","-1")
%>
                                    </div>

                                </div>

                                <div class="form-group row">

                                    <label class="col-sm-2 control-label">Estado:</label>
                                    <div class="col-sm-4 m-b-xs">
<%
    CargaCombo("selPrvManMan_Edo_ID", "class='form-control select2'", "Edo_ID", "Edo_Nombre", "CAT_Estado", "", "Edo_Nombre ASC", "", cxnTipo, "TODOS","-1")
%>
                                    </div>

                                    <label class="col-sm-2 control-label">
                                        Tipo Localidad
                                    </label>
                                    <div class="col-sm-4">
                                
                                        <input type="radio" id="radPrvManMan_TpL_IDAmbos" name="radPrvManMan_TpL_ID" value="-1" checked>
                                        <label for="radPrvManMan_TpL_IDAmbos">
                                            Ambas
                                        </label>
                                        <input type="radio" id="radPrvManMan_TpL_IDLocal" name="radPrvManMan_TpL_ID" value="1">
                                        <label for="radPrvManMan_TpL_IDLocal">
                                            Local
                                        </label>
                                        <input type="radio" id="radPrvManMan_TpL_IDForaneo" name="radPrvManMan_TpL_ID" value="2">
                                        <label for="radPrvManMan_TpL_IDForaneo">
                                            Foranea
                                        </label>
                                
                                    </div>
                                    
                                </div>

                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-sm-12" id="divPrvManLis">

            </div>

        </div>
    </div>
</div>

<div class="modal fade" id="mdlPrvManEnt" tabindex="-1" role="dialog" aria-labelledby="divPrvManEnt" aria-hidden="true" style="display: none;">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
                <h2 class="modal-title" id="divPrvManEnt">
                    <i class="fa fa-file-text-o"></i> Entrega 
                    <br />
                    <small>Entrega</small>
                </h2>
                
            </div>
            <div class="modal-body" id="mdlPrvManEntBody">

                
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-secondary btn-seg" data-dismiss="modal">
                    <i class="fa fa-times"></i> Cerrar
                </button>
                
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="mdlPrvManDoc" tabindex="-1" role="dialog" aria-labelledby="divPrvManDoc" aria-hidden="true" style="display: none;">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
                <h2 class="modal-title" id="divPrvManDoc">
                    <i class="fa fa-file-text-o"></i> Documento 
                </h2>
                
            </div>
            <div class="modal-body" id="mdlPrvManDocBody" style="height: 1100px; overflow: auto; background: #EEEEEE;">                

            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-secondary btn-seg" data-dismiss="modal">
                    <i class="fa fa-times"></i> Cerrar
                </button>
                
            </div>
        </div>
    </div>
</div>