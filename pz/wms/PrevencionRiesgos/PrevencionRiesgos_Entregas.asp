<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2021-JUL-29 Prevencion de Riesgos - Entregas - Buscador: Creación de Archivo
// HA ID: 2 2021-AGO-04 Ajustes: Agregado de Estatus y filtro de Proveedores

var cxnTipo = 0

var urlBase
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

        $('#inpPreRieEntEnt_FechaBusca').daterangepicker({
			"showDropdowns": true,
			"firstDay": 7,	
			"startDate":moment().startOf('month'),
			"endDate": moment(),
            "autoApply": true,
			"ranges": {
               'Hoy': [moment(), moment()],
			   'Al dia de hoy': [moment().startOf('month'), moment()],
			   'Este Mes': [moment().startOf('month'), moment().endOf('month')],
			   'Mes pasado': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')],		   
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
				$("#inpPreRieEntEnt_FechaInicial").val(moment.utc(start, 'MM/DD/YYYY').local().format('MM/DD/YYYY'))
				$("#inpPreRieEntEnt_FechaFinal").val(moment.utc(end, 'MM/DD/YYYY').local().format('MM/DD/YYYY'))
                $("#inpPreRieEntEnt_FechaBusca").val((moment.utc(start, 'DD/MM/YYYY').local().format('DD/MM/YYYY')) + " - " + (moment.utc(end, 'DD/MM/YYYY').local().format('DD/MM/YYYY')))
            }
        );

        $("#inpPreRieEntEnt_FechaInicial").val(moment().startOf('month').format('MM/DD/YYYY'));
        $("#inpPreRieEntEnt_FechaFinal").val(moment().format('MM/DD/YYYY'));
        $("#inpPreRieEntEnt_FechaBusca").val(moment().startOf('month').format('DD/MM/YYYY') + " - " + moment().format('DD/MM/YYYY'));

    });

<% /* HA ID: 2 Agregado de Filtro Man_Prov_ID al proceso */ %>

    var Entrega = {
        url: "/pz/wms/PrevencionRiesgos/"
        , Buscador: {
              Filtros: {
                  Ent_Folio: ""
                , Man_Folio: ""
                , Ent_FolioCliente: ""
                , Ent_Guia: ""
                , Ent_Est_ID: -1
                , Cli_ID: -1
                , Ent_FechaInicial: ""
                , Ent_FechaFinal: ""
                , Ent_Remision: ""
                , Man_Prov_ID: ""
            }
            , Filtrar: function(){
                var bolError = false;
                var arrError = [];

                var strEnt_Folio = $("#inpPreRieEntEnt_Folio").val();
                var strMan_Folio = $("#inpPreRieEntMan_Folio").val();
                var strEnt_FolioCliente = $("#inpPreRieEntEnt_FolioCliente").val();
                var strEnt_Guia = $("#inpPreRieEntEnt_Guia").val();
                var intEnt_Est_ID = $("#selPreRieEntEnt_Est_ID").val();
                var intCli_ID = $("#selPreRieEntCli_ID").val();
                var dateEnt_FechaInicial = $("#inpPreRieEntEnt_FechaInicial").val();
                var dateEnt_FechaFinal = $("#inpPreRieEntEnt_FechaFinal").val();
                var strEnt_Remision = $("#inpPreRieEntEnt_Remision").val();
                var intMan_Prov_ID = $("#selPreRieEntMan_Prov_ID").val();

                if( strEnt_Folio == "" 
                 && strMan_Folio == "" 
                 && strEnt_FolioCliente == "" 
                 && strEnt_Guia == "" 
                 && parseInt(intEnt_Est_ID) == -1 
                 && parseInt(intCli_ID) == -1 
                 && dateEnt_FechaInicial == "" 
                 && dateEnt_FechaFinal == "" 
                 && strEnt_Remision == ""
                 && parseInt(intMan_Prov_ID) == -1 ) {
                    bolError = true;
                    arrError.push("- Seleccionar un Filtro");
                } else {

                    if( strEnt_Remision != "" && parseInt(intCli_ID) == -1 ){
                        bolError = true;
                        arrError.push("- Seleccionar el Cliente para filtrar la remision");
                    }

                }

                if( bolError ){
                    Avisa("warning", "Prevencion Riesgos - Entrada - Buscador", "Verificar formulario<br>" + arrError.join("<br>"));
                } else {

                    Entrega.Buscador.Filtros.Ent_Folio = strEnt_Folio;
                    Entrega.Buscador.Filtros.Man_Folio = strMan_Folio;
                    Entrega.Buscador.Filtros.Ent_FolioCliente = strEnt_FolioCliente;
                    Entrega.Buscador.Filtros.Ent_Guia = strEnt_Guia;
                    Entrega.Buscador.Filtros.Ent_Est_ID = intEnt_Est_ID;
                    Entrega.Buscador.Filtros.Cli_ID = intCli_ID;
                    Entrega.Buscador.Filtros.Ent_FechaInicial = dateEnt_FechaInicial;
                    Entrega.Buscador.Filtros.Ent_FechaFinal = dateEnt_FechaFinal;
                    Entrega.Buscador.Filtros.Ent_Remision = strEnt_Remision;
                    Entrega.Buscador.Filtros.Man_Prov_ID = intMan_Prov_ID;

                    Entrega.Listado.Cargar( true );
                }
            }
            , Limpiar: function(){
                
                $("#inpPreRieEntEnt_Folio").val("");
                $("#inpPreRieEntMan_Folio").val("");
                $("#inpPreRieEntEnt_FolioCliente").val("");
                $("#inpPreRieEntEnt_Guia").val("");
                $("#selPreRieEntEnt_Est_ID").val("-1");
                $("#selPreRieEntCli_ID").val("-1");
                $("#inpPreRieEntEnt_Remision").val("");
                $("#selPreRieEntMan_Prov_ID").val("-1")
                
                $("#select2-selPreRieEntEnt_Est_ID-container").text("TODOS");
                $("#select2-selPreRieEntCli_ID-container").text("TODOS");
                $("#select2-selPreRieEntMan_Prov_ID-container").text("TODOS");

                $("#inpPreRieEntEnt_FechaInicial").val(moment().startOf('month').format('MM/DD/YYYY'));
                $("#inpPreRieEntEnt_FechaFinal").val(moment().format('MM/DD/YYYY'));
                $("#inpPreRieEntEnt_FechaBusca").val(moment().startOf('month').format('DD/MM/YYYY') + " - " + moment().format('DD/MM/YYYY'));

            }
        }
        , Listado: {
            RegistrosPagina: 10
            , Cargar: function( prmBolIniciaBusqueda ){

                var intRegistros =  $(".cssTrPreRieEntLisReg").length;
                var intIDUsuario = $("#IDUsuario").val();
                var intSiguienteRegistro = ( prmBolIniciaBusqueda ) ? 0 : intRegistros;
                var intRegistrosPagina = $("#inpPreRieEntLisRegPag").val();

                var intRegPag = (intRegistrosPagina == "" || intRegistrosPagina == undefined ) ? Entrega.Listado.RegistrosPagina : intRegistrosPagina;

                if( prmBolIniciaBusqueda ){
                    $("#divPreRieEntLis").html("");
                    $("#lblPreRieLisTot").text("");
                } 

                $.ajax({
                      url: Entrega.url + "PrevencionRiesgos_Entregas_Listado.asp"
                    , method: "post"
                    , async: true
                    , data:{
                          Ent_Folio: Entrega.Buscador.Filtros.Ent_Folio
                        , Man_Folio: Entrega.Buscador.Filtros.Man_Folio
                        , Ent_FolioCliente: Entrega.Buscador.Filtros.Ent_FolioCliente
                        , Ent_Guia: Entrega.Buscador.Filtros.Ent_Guia
                        , Ent_Est_ID: Entrega.Buscador.Filtros.Ent_Est_ID
                        , Cli_ID: Entrega.Buscador.Filtros.Cli_ID
                        , Ent_FechaInicial: Entrega.Buscador.Filtros.Ent_FechaInicial
                        , Ent_FechaFinal: Entrega.Buscador.Filtros.Ent_FechaFinal
                        , Ent_Remision: Entrega.Buscador.Filtros.Ent_Remision
                        , Man_Prov_ID: Entrega.Buscador.Filtros.Man_Prov_ID
                        , IDUsuario: intIDUsuario
                        , SiguienteRegistro: intSiguienteRegistro
                        , RegistrosPagina: intRegPag
                    }
                    , beforeSend: function(){
                        if( prmBolIniciaBusqueda ){
                            Procesando.Visualizar({Contenedor: "divPreRieEntLis"});
                        } else {
                            Procesando.Visualizar({Contenedor: "tfPreRieEntLisCar"});
                        }
                    }
                    , success: function( res ){
                        var bolRes = false;
                        
                        if( $(res).find("#tbPreRieEntLis").html().trim() != ""){
                            bolRes = true;
                        }

                        if( prmBolIniciaBusqueda ){
                            $("#divPreRieEntLis").html( res );
                        } else {
                            $("#tbPreRieEntLis").append( $(res).find("#tbPreRieEntLis").html() );
                        }

                        var objMas = "";

                        if( bolRes ){
                            objMas = "<div class='row'>"
                                    + "<div class='col-sm-9'>"
                                        + "<button type='button' class='btn btn-white btn-block' onClick='Entrega.Listado.Cargar(false)'>"
                                            + "<i class='fa fa-arrow-down'></i> Ver mas"
                                        + "</button>" 
                                    + "</div>"
                                    + "<div class='col-sm-2 input-group'>"
                                        + "<input type='number' id='inpPreRieEntLisRegPag' class='form-control text-right' placeholder='10' min='10' max='100' steep='10' value='10' maxlength='3' >"
                                        + "<span class='input-group-addon'> Reg/Pag </span>"
                                    + "</div>"
                                + "</div>"
                        } else if( prmBolIniciaBusqueda ){
                            objMas = "<i class='fa fa-exclamation-circle fa-lg text-success'></i> No hay Registros"
                        }

                        $("#tfPreRieEntLisCar").html(objMas);

                        Entrega.Listado.RegistrosContar();
                    }
                    , error: function(){
                        Avisa("error", "Prevencion Riesgos - Entradas - Listado", "Error de Servidor en la Peticion");
                    }
                    , complete: function(){
                        Procesando.Ocultar();
                    }
                });
            }
            , RegistrosContar: function(){
                var intRegistros = $(".cssTrPreRieEntLisReg").length;

                $("#lblPreRieEntLisTot").text(intRegistros);
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
                }

            }
        }
    }

</script>

<div id="wrapper">
    <div class="row">
        <div class="col-sm-12">
            <div class="ibox">
                <div class="ibox-title">
                    <h5>Filtros</h5>
                    <div class="ibox-tools">
                        <button type="button" class="btn btn-white" onclick="Entrega.Buscador.Limpiar();">
                            <i class="fa fa-trash-o"></i> Limpiar
                        </button>
                        <button type="button" class="btn btn-success" onclick="Entrega.Buscador.Filtrar()">
                            <i class="fa fa-search"></i> Buscar
                        </button>
                    </div>
                </div>
                <div class="ibox-content">

<% /* HA ID: 2 INI Agregado de Filtro Man_Prov_ID al proceso */ %>
                    <div class="row form-group">
                        <label class="col-sm-2">
                            Proveedor:
                        </label>

                        <div class="col-sm-4">
<%
    CargaCombo("selPreRieEntMan_Prov_ID","class='form-control select2'", "Prov_ID", "Prov_Nombre", "Proveedor", "", "Prov_Nombre ASC", "Prov_EsPaqueteria = 1", cxnTipo, "TODOS", "-1")
%>
                        </div>
                    </div>
<% /* HA ID: 2 FIN */ %>                   
                    <div class="row form-group">
                        <label class="col-sm-2 control-label">
                            Folio Entrega:
                        </label>
                        <div class="col-sm-4">
                            <input type="text" id="inpPreRieEntEnt_Folio" class="form-control" placeholder="Folio TRA/SO"
                             autocomplete="off" maxlength="30">
                        </div>

                        <label class="col-sm-2 control-label">
                            Folio Manifiesto:
                        </label>
                        <div class="col-sm-4">
                            <input type="text" id="inpPreRieEntMan_Folio" class="form-control" placeholder="Folio Manifiesto"
                             autocomplete="off" maxlength="30">
                        </div>
                    </div>

                    <div class="row form-group">
                        <label class="col-sm-2 control-label">
                            Folio Cliente:
                        </label>
                        <div class="col-sm-4">
                            <input type="text" id="inpPreRieEntEnt_FolioCliente" class="form-control" placeholder="Folio Cliente"
                            autocomplete="off" maxlength="30">
                        </div>

                        <label class="col-sm-2 control-label">
                            Gu&iacute;a Entrega:
                        </label>
                        <div class="col-sm-4">
                            <input type="text" id="inpPreRieEntEnt_Guia" class="form-control" placeholder="Gu&iacute;a Entrega"
                             autocomplete="off" maxlength="30">
                        </div>
                    </div>

                    <div class="row form-group">
                       
                        <label class="col-sm-2 control-label">
                            Estatus
                        </label>

                        <div class="col-sm-4">
<%
    CargaCombo("selPreRieEntEnt_Est_ID","class='form-control select2'", "Cat_ID", "Cat_Nombre", "Cat_Catalogo", "Sec_ID = 51", "Cat_Nombre ASC", "", cxnTipo, "TODOS", "-1")
%>
                        </div>
                        
                        <label class="col-sm-2 control-label">
                            Cliente
                        </label>
                        <div class="col-sm-4">
<%
    CargaCombo("selPreRieEntCli_ID","class='form-control select2'", "Cli_ID", "Cli_Nombre", "Cliente", "", "Cli_Nombre ASC", "", cxnTipo, "TODOS", "-1")
%>
                        </div>

                    </div>
                    
                    <div class="row form-group">

                        <label class="col-sm-2 control-label">
                            Fecha:
                        </label>
                        <div class="col-sm-4">
                            <div class="input-group">
                                <input type="text" id="inpPreRieEntEnt_FechaBusca" class="form-control" placeholder="dd/mm/aaaa - dd/mm/aaaa"
                                autocomplete="off" maxlength="30" readonly>
                                <span class="input-group-addon">
                                    <i class="fa fa-calendar"></i>
                                </span>
                            </div>
                            <input type="hidden" id="inpPreRieEntEnt_FechaInicial">
                            <input type="hidden" id="inpPreRieEntEnt_FechaFinal">
                        </div>

                        <label class="col-sm-2 control-label">
                            Remisi&oacute;n:
                        </label>
                        <div class="col-sm-4">
                            <input type="text" id="inpPreRieEntEnt_Remision" class="form-control" placeholder="Remisi&oacute;n"
                             autocomplete="off" maxlength="30">
                        </div>

                    </div>

                </div>
            </div>

        </div>

        <div class="col-sm-12" id="divPreRieEntLis">

        </div>

    </div>
</div>