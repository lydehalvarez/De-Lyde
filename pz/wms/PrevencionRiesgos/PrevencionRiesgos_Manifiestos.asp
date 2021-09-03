<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2020-JUL-07 Manifiestos: Creación de archivo

var cxnTipo = 0

var urlBase = "/pz/wms/"
var urlBaseTemplate = "/Template/inspina/";

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

        $('#inpPreRieManMan_FechaBusca').daterangepicker({
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
				$("#inpPreRieManMan_FechaInicial").val(moment.utc(start, 'MM/DD/YYYY').local().format('MM/DD/YYYY'))
				$("#inpPreRieManMan_FechaFinal").val(moment.utc(end, 'MM/DD/YYYY').local().format('MM/DD/YYYY'))
                $("#inpPreRieManMan_FechaBusca").val((moment.utc(start, 'DD/MM/YYYY').local().format('DD/MM/YYYY')) + " - " + (moment.utc(end, 'DD/MM/YYYY').local().format('DD/MM/YYYY')))
            }
        );

        $("#inpPreRieManMan_FechaInicial").val(moment().startOf('month').format('MM/DD/YYYY'));
        $("#inpPreRieManMan_FechaFinal").val(moment().format('MM/DD/YYYY'));
        $("#inpPreRieManMan_FechaBusca").val(moment().startOf('month').format('DD/MM/YYYY') + " - " + moment().format('DD/MM/YYYY'));

    });

    var Manifiesto = {
          url: "/pz/wms/PrevencionRiesgos/" 
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
                $("#inpPreRieManMan_Guia").val("");
                $("#inpPreRieManMan_Folio").val("");
                $("#selPreRieManMan_Edo_ID").val("-1");

                $("#inpPreRieManEnt_Guia").val("");
                $("#inpPreRieManEnt_Folio").val("");
                $("#selPreRieManEnt_Est_ID").val("-1");
                $("#objPreRieManMan_Prov_ID").val("-1");
                
                $("#select2-selPreRieManMan_Edo_ID-container").text("TODOS");
                $("#select2-selPreRieManEnt_Est_ID-container").text("TODOS");
                $("#select2-objPreRieManMan_Prov_ID-container").text("TODOS");   

                $("#radPreRieManMan_TpL_IDAmbos").prop("checked", true);

                $("#inpPreRieManMan_FechaInicial").val(moment().startOf('month').format('MM/DD/YYYY'));
                $("#inpPreRieManMan_FechaFinal").val(moment().format('MM/DD/YYYY'));
                $("#inpPreRieManMan_FechaBusca").val(moment().startOf('month').format('DD/MM/YYYY') + " - " + moment().format('DD/MM/YYYY'));
               
            }
            , Filtrar: function(){
                
                var bolError = false;
                var arrError = [];

                var intMan_Prov_ID = $("#objPreRieManMan_Prov_ID").val();

                var strMan_Guia = $("#inpPreRieManMan_Guia").val();
                var strMan_Folio = $("#inpPreRieManMan_Folio").val();
                var dateMan_FechaInicial = $("#inpPreRieManMan_FechaInicial").val();
                var dateMan_FechaFinal = $("#inpPreRieManMan_FechaFinal").val();
                var intMan_Edo_ID = $("#selPreRieManMan_Edo_ID").val();
                var intMan_TpL_ID = $("input[name=radPreRieManMan_TpL_ID]:checked").val();

                var strEnt_Guia = $("#inpPreRieManEnt_Guia").val();
                var strEnt_Folio = $("#inpPreRieManEnt_Folio").val();
                var intMan_Est_ID = $("#selPreRieManEnt_Est_ID").val();

                var intIDUsuario = $("#IDUsuario").val(); 

                if( intMan_Prov_ID == -1 
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

                var intRegistros =  $(".cssTrPreRieManLisReg").length;
                var intIDUsuario = $("#IDUsuario").val();
                var intSiguienteRegistro = ( prmBolIniciaBusqueda ) ? 0 : intRegistros;
                var intRegistrosPagina = $("#inpPreRieManLisRegPag").val();

                var intRegPag = (intRegistrosPagina == "" || intRegistrosPagina == undefined ) ? Manifiesto.Listado.RegistrosPagina : intRegistrosPagina;

                if( prmBolIniciaBusqueda ){
                    $("#tbPreRieManLis").html("");
                    $("#lblPreRieManLisTot").text("");
                } 

                $.ajax({
                    url: Manifiesto.url + "PrevencionRiesgos_Manifiestos_Listado.asp"
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
                    }
                    , beforeSend: function(){
                        if( prmBolIniciaBusqueda ){
                            Procesando.Visualizar({Contenedor: "divPreRieManLis"});
                        } else {
                            Procesando.Visualizar({Contenedor: "tfPreRieManLisCar"});
                        }
                    }
                    , success: function(res){

                        var bolRes = false;

                        if( $(res).find("#tbPreRieManLis").html().trim() != "" ){
                            bolRes = true;
                        }

                        if(prmBolIniciaBusqueda){
                            $("#divPreRieManLis").html( res ); 
                        } else {
                            $("#tbPreRieManLis").append( $(res).find("#tbPreRieManLis").html() );
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
                                        + "<input type='number' id='inpPreRieManRegPag' class='form-control text-right' placeholder='10' min='10' max='100' steep='10' value='10' maxlength='3' >"
                                        + "<span class='input-group-addon'> Reg/Pag </span>"
                                    + "</div>"
                                + "</div>"

                        } else if( prmBolIniciaBusqueda ) {
                            objMas = "<i class='fa fa-exclamation-circle fa-lg text-success'></i> No hay Registros"
                        }

                        $("#tfPreRieManLisCar").html(objMas);

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
                var intRegistros = $(".cssTrPreRieManLisReg").length;

                $("#lblPreRieManLisTot").text(intRegistros);
            }
        }
        , Detalle: {

            Visualizar: function(){
                $(".cssPreRieManDetalle").show();
                $("#aPreRieManDetVer").hide();
                $("#aPreRieManDetOcultar").show();
            }
            , Ocultar: function(){
                $(".cssPreRieManDetalle").hide();
                $("#aPreRieManDetVer").show();
                $("#aPreRieManDetOcultar").hide();
            }
        }
    }

    var Entregas = {
        url: "/pz/wms/PrevencionRiesgos/"
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
                        url: Entregas.url + "PrevencionRiesgos_Manifiestos_Entregas_Listado.asp"
                        , method: "post"
                        , async: true
                        , data: {
                              Man_ID: intMan_ID
                         }
                        , beforeSend: function(){
                            Procesando.Visualizar({Contenedor: "divPreRieManLis"});
                        }
                        , success: function( res ){
                            $("#divPreRieManLis").html( res );

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
                var intTotReg = $(".cssTrPreRieManEntLisReg").length;
                $("#lblPreRieManEntLisTot").text(intTotReg);
            }
        }
        , Detalle: {
            Ver: function( prmJson ){

                var bolError = false;
                var arrError = [];

                var intTA_ID = prmJson.TA_ID;
                var intOV_ID = prmJson.OV_ID;

                if( $("#TA_ID").length == 0 ){
                    var objTA_ID = "<input type='hidden' id='TA_ID' name='TA_ID' value='-1'>";

                    $("#wrapper").prepend( objTA_ID );
                    $("#TA_ID").val( intTA_ID );
                }

                if( $("#OV_ID").length == 0 ){
                    var objOV_ID = "<input type='hidden' id='OV_ID' name='OV_ID' value='-1'>";

                    $("#wrapper").prepend( objOV_ID );
                    $("#OV_ID").val( intOV_ID );
                }

                if( !(parseInt(intTA_ID) > -1)  && !(parseInt(intOV_ID) > -1) ){
                    bolError = true;
                    arrError.push("Identificadores de Entrega no permitidos");
                }

                if( bolError ){
                    Avisa("warning", "Prevencion Riesgo - Entrega - Detalle", "Verificar formulario<br>" + arrError.join("<br>"));
                } else {
                    CambiaVentana(19, 10102);
                    //alert("se envía a Detalle");
                }
            }
            
        }
    };

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

                                    <label class="col-sm-2 control-label">Transportista:</label>
                                    <div class="col-sm-4 m-b-xs">

<%
        CargaCombo("objPreRieManMan_Prov_ID", "class='form-control select2'", "Prov_ID", "Prov_Nombre", "Proveedor", "Prov_Habilitado = 1 AND Prov_EsPaqueteria = 1", "Prov_Nombre ASC", "", cxnTipo, "TODOS", "-1")
%>                                        
                                    </div>
                                </div>

                                <div class="form-group row">

                                    <label class="col-sm-2 control-label">Gu&iacute;a Manifiesto: </label>    
                                    <div class="col-sm-4 m-b-xs">
                                        <input type="text" id="inpPreRieManMan_Guia" class="form-control" placeholder="Gu&iacute;a Manifiesto"
                                         autocomplete="off" maxlength="50">
                                    </div>

                                    <label class="col-sm-2 control-label">Gu&iacute;a Entrega:</label>    
                                    <div class="col-sm-4 m-b-xs">
                                        <input type="text" id="inpPreRieManEnt_Guia" class="form-control" placeholder="Gu&iacute;a Entrega"
                                         autocomplete="off" maxlength="50">
                                    </div>                              

                                </div>

                                <div class="form-group row">

                                    <label class="col-sm-2 control-label">Folio de  Manifiesto:</label>    
                                    <div class="col-sm-4 m-b-xs">
                                        <input type="text" id="inpPreRieManMan_Folio" class="form-control" placeholder="Folio Manifiesto"
                                        autocomplete="off" maxlength="30">
                                    </div>

                                    <label class="col-sm-2 control-label">Folio Entrega:</label>    
                                    <div class="col-sm-4 m-b-xs">
                                        <input type="text" id="inpPreRieManEnt_Folio" class="form-control" placeholder="Folio Entrega"
                                         autocomplete="off" maxlength="30" value="">
                                    </div>   
                                   
                                </div>

                                <div class="form-group row">

                                    <label class="col-sm-2 control-label">Rango fechas:</label>
                                    <div class="col-sm-4 m-b-xs">
                                        <div class="input-group">
                                            <input class="form-control date-picker date" id="inpPreRieManMan_FechaBusca" 
                                                placeholder="dd/mm/aaaa - dd/mm/aaaa" type="text" value="" autocomplete="off" readonly> 
                                            <span class="input-group-addon">
                                                <i class="fa fa-calendar"></i>
                                            </span>
                                        </div>
                                    </div>
                                    <input id="inpPreRieManMan_FechaInicial" type="hidden" value="" />
                                    <input id="inpPreRieManMan_FechaFinal" type="hidden" value="" />
                                    
                                    <label class="col-sm-2 control-label">Estatus de Entregas:</label>
                                    <div class="col-sm-4 m-b-xs">
<%
    CargaCombo("selPreRieManEnt_Est_ID", "class='form-control select2'", "CAT_ID", "CAT_Nombre", "CAT_Catalogo", "SEC_ID = 51", "CAT_Nombre DESC", "", cxnTipo, "TODOS","-1")
%>
                                    </div>

                                </div>

                                <div class="form-group row">

                                    <label class="col-sm-2 control-label">Estado:</label>
                                    <div class="col-sm-4 m-b-xs">
<%
    CargaCombo("selPreRieManMan_Edo_ID", "class='form-control select2'", "Edo_ID", "Edo_Nombre", "CAT_Estado", "", "Edo_Nombre ASC", "", cxnTipo, "TODOS","-1")
%>
                                    </div>

                                    <label class="col-sm-2 control-label">
                                        Tipo Localidad
                                    </label>
                                    <div class="col-sm-4">
                                
                                        <input type="radio" id="radPreRieManMan_TpL_IDAmbos" name="radPreRieManMan_TpL_ID" value="-1" checked>
                                        <label for="radPreRieManMan_TpL_IDAmbos">
                                            Ambas
                                        </label>
                                        <input type="radio" id="radPreRieManMan_TpL_IDLocal" name="radPreRieManMan_TpL_ID" value="1">
                                        <label for="radPreRieManMan_TpL_IDLocal">
                                            Local
                                        </label>
                                        <input type="radio" id="radPreRieManMan_TpL_IDForaneo" name="radPreRieManMan_TpL_ID" value="2">
                                        <label for="radPreRieManMan_TpL_IDForaneo">
                                            Foranea
                                        </label>
                                
                                    </div>
                                    
                                </div>

                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-sm-12" id="divPreRieManLis">

            </div>

        </div>
    </div>
</div>