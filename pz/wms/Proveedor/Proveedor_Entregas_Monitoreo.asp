<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2021-JUN-14 Seguimiento de Transferencias: Creación de Archivo.

var cxnTipo = 0

var urlBase = "/pz/wms/"
var urlBaseTemplate = "/Template/inspina/";

var intProv_ID = Parametro("Prov_ID", -1)
var bolEsTransportista = ( Parametro("Transportista", 0) == 1 )

%>
<!-- Select2 -->
<link href="<%= urlBaseTemplate %>css/plugins/select2/select2.min.css" rel="stylesheet">
<!-- Date range picker -->
<link href="<%= urlBaseTemplate %>css/plugins/daterangepicker/daterangepicker-bs3.css" rel="stylesheet">

<style type="text/css">
    .headFlotante {
        position: fixed;
        z-index: 1000;
        top: 10px;
        background: white;
    }
</style>

<!-- Select2 -->
<script src="<%= urlBaseTemplate %>js/plugins/select2/select2.full.min.js"></script>
<!-- Date range use moment.js same as full calendar plugin -->
<script src="<%= urlBaseTemplate %>js/plugins/fullcalendar/moment.min.js"></script>
<!-- Date range picker -->
<script src="<%= urlBaseTemplate %>js/plugins/daterangepicker/daterangepicker.js"></script>
<!-- Loading -->
<script src="<%= urlBaseTemplate %>js/loading.js"></script>
<!-- Lateral Flotante -->
<script src="<%= urlBaseTemplate %>js/lateralflotante.js"></script>
<!-- Export -->
<script src="/Template/inspina/js/plugins/sheetJs/xlsx.full.min.js"></script>

<script type="text/javascript">

    $(document).ready(function(){
    
        $(".select2").select2();

        $('#inpPrvSegFecBus').daterangepicker({
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
				"monthNames": [ "Enero","Febrero","Marzo","April","Mayo","Junio","Julio","Agosto","Septimbre","Octubre","Novimbre","Dicimbre"]
		}}, function(start, end, label) {
            $("#hidPrvSegFecIni").val(moment.utc(start, 'MM/DD/YYYY').local().format('MM/DD/YYYY'))
            $("#hidPrvSegFecFin").val(moment.utc(end, 'MM/DD/YYYY').local().format('MM/DD/YYYY'))
            $("#inpPrvSegFecBus").val((moment.utc(start, 'DD/MM/YYYY').local().format('DD/MM/YYYY')) + " - " + (moment.utc(end, 'DD/MM/YYYY').local().format('DD/MM/YYYY')))
        });

        Proveedor.Buscar.ListadoBuscar();

        /*
        $(window).scroll(function(){
            if( $(this).scrollTop() > 305 ){
                $('#thPrvSegEnc')
                    .addClass('headFlotante')
                    .width( $('#tbPrvSegLis').width() );
            } else {
                $('#thPrvSegEnc').removeClass('headFlotante');			
            }
        });
        */
    });

    var Proveedor = {
          url: "/pz/wms/Proveedor/" 
        , EsTransportista: <%= Parametro("Transportista", 0) %>
        , Estatus: {
              Transito: 5
            , PrimerIntento: 6
            , SegundoIntento: 7
            , TercerIntento: 8
            , FallaEntrega: 9
            , EntregaExitosa: 10
            , AvisoDevolucion: 22
        }
        , Buscar: {
              RegistrosPagina: 10
            , Filtros: {
                Cliente: -1
                , Proveedor: <%= intProv_ID %>
                , FechaInicial: ""
                , FechaFinal: ""
            }
            , FiltrosLimpiar: function(){
                
                if( Proveedor.EsTransportista == 0 ){

                    Proveedor.Buscar.Filtros.Cliente = -1;
                    Proveedor.Buscar.Filtros.Proveedor = -1;

                    $("#selPrvSegCli_ID").val("");
                    $("#select2-selPrvSegCli_ID-container").text("TODOS");

                    $("#selPrvSegProv_ID").val("");
                    $("#select2-selPrvSegProv_ID-container").text("TODOS");
                }
                
                Proveedor.Buscar.Filtros.FechaInicial = "";
                Proveedor.Buscar.Filtros.FechaFinal = "";

                $("#inpPrvSegFecBus").val("");
                $("#hidPrvSegFecIni").val("");
                $("#hidPrvSegFecFin").val("");

            }
            , ListadoBuscar: function(){

                if ( Proveedor.EsTransportista == 0 ) {
                    Proveedor.Buscar.Filtros.Proveedor = $("#selPrvSegProv_ID").val();
                    Proveedor.Buscar.Filtros.Cliente = $("#selPrvSegCli_ID").val();
                }

                Proveedor.Buscar.Filtros.FechaInicial = $("#hidPrvSegFecIni").val();
                Proveedor.Buscar.Filtros.FechaFinal = $("#hidPrvSegFecFin").val();

                Proveedor.Buscar.ListadoCargar( true );

            }
            , ListadoCargar: function( prmBolIniciaBusqueda ){

                var intRegistros =  $(".cssReg", "#tbPrvSegLis").length;
                var intIDUsuario = $("#IDUsuario").val();
                var intSiguienteRegistro = ( prmBolIniciaBusqueda ) ? 0 : intRegistros;
                var intRegistrosPagina = $("#inpPrvSegRegPag").val();

                var intRegPag = (intRegistrosPagina == "" || intRegistrosPagina == undefined ) ? Proveedor.Buscar.RegistrosPagina : intRegistrosPagina;

                if( prmBolIniciaBusqueda ){
                    $("#tbPrvSegLis").html("");
                    $("#spanPrvSegTotReg").text("");
                } 

                $.ajax({
                      url: Proveedor.url + "proveedor_entregas_Monitoreo_Listado.asp"
                    , method: "post"
                    , async: true
                    , dataType: "html"
                    , data: {
                          Prov_ID: Proveedor.Buscar.Filtros.Proveedor
                        , Cli_ID: Proveedor.Buscar.Filtros.Cliente
                        , FechaInicial: Proveedor.Buscar.Filtros.FechaInicial
                        , FechaFinal: Proveedor.Buscar.Filtros.FechaFinal
                        , SiguienteRegistro: intSiguienteRegistro
                    , RegistrosPagina: intRegPag
                    }
                    , beforeSend: function(){
                        Procesando.Visualizar({Contenedor: "tfPrvSegCar"});
                    }
                    , success: function(res){

                        //Asignacion de despliegue de acordeon por estatus
                        if( prmBolIniciaBusqueda ){
                            $("#tbPrvSegLis").html(res);
                        } else {
                            $("#tbPrvSegLis").append(res);
                        }
    
                        var objMas = "";

                        if( res != ""){

                            objMas = "<div class='row'>"
                                    + "<div class='col-sm-9'>"
                                        + "<button type='button' class='btn btn-white btn-block' onClick='Proveedor.Buscar.ListadoCargar( false )'>"
                                            + "<i class='fa fa-arrow-down'></i> Ver mas"
                                        + "</button>" 
                                    + "</div>"
                                    + "<div class='col-sm-2 input-group'>"
                                        + "<input type='number' id='inpPrvSegRegPag' class='form-control text-right' placeholder='10' min='10' max='100' steep='10' value='10' maxlength='3' >"
                                        + "<span class='input-group-addon'> Reg/Pag </span>"
                                    + "</div>"
                                + "</div>"

                        } else if( prmBolIniciaBusqueda ) {
                            objMas = "<i class='fa fa-exclamation-circle fa-lg text-success'></i> No hay Registros"
                        }

                        $("#tfPrvSegCar").html(objMas);

                        Proveedor.Buscar.ListadoRegistrosContar();
                    }
                    , error: function(){
                        Avisa("error", "Entregas - Seguimiento - Cargar Listado", "Error en la peticion");
                    }
                    , complete: function(){
                        Procesando.Ocultar();
                    }
                });
            }
            , ListadoRegistrosContar: function(){

                var intRegistros = $(".cssReg", "#tbPrvSegLis").length;

                $("#spanPrvSegTotReg").text(intRegistros);
            }
        }
        , Entrega: {

            ListadoCargar: function( jsonPrm ){

                var bolError = false;
                var arrError = [];

                var objBas = jsonPrm.Objeto;
                var dateFecha = jsonPrm.Fecha;
                var intEst_ID = jsonPrm.Est_ID;
                var strEst_Nombre = jsonPrm.Est_Nombre;

                var intCli_ID = Proveedor.Buscar.Filtros.Cliente;
                var intProv_ID = Proveedor.Buscar.Filtros.Proveedor;

                if( objBas == undefined ){
                    bolError = true;
                    arrError.push("- No hay objeto base de seleccion");
                }

                if( dateFecha == "" ){
                    bolError = true;
                    arrError.push("- No hay fecha de seleccion");
                }

                if( bolError ){
                    Avisa("warning", "Entregas - Listado", "Verificar Formulario<br>" + arrError.join("<br>") );
                } else {
                    
                    $.ajax({
                          url: Proveedor.url + "proveedor_entregas_Monitoreo_entregas.asp"
                        , method: "post"
                        , async: true
                        , data: {
                              Fecha: dateFecha
                            , Est_ID: intEst_ID
                            , Est_Nombre: strEst_Nombre
                            , Prov_ID: intProv_ID
                            , Cli_ID: intCli_ID
                        }
                        , beforeSend: function(){
                            Cargando.Iniciar();
                        }
                        , success: function( res ){
                            
                            var objtr = "<tr>"
                                    + "<td colspan='9'>" + res + "</td>"
                                + "</tr>";

                            $(objtr).insertAfter( objBas );

                        }
                        , error: function(){
                            Avisa("error", "Entregas - Seguimiento", "Error de peticion");
                        }
                        , complete: function(){
                            Cargando.Finalizar();
                        }
                    });
                    
                }
                
            }
            , ListadoLimpiar: function( objBas ){
                $(objBas).parents('tr').remove();
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
            , Exportar: function( prmJson ){
                var bolError = false;
                var arrError = [];

                var dateFecha = prmJson.Fecha;
                var intEst_ID = prmJson.Est_ID;

                var intCli_ID = Proveedor.Buscar.Filtros.Cliente;
                var intProv_ID = Proveedor.Buscar.Filtros.Proveedor;

                if( dateFecha == ""){
                    bolError = true;
                    arrError.push("- No se agrego fecha")
                }

                if( bolError ){
                    Avisa("warning", "Entregas - Exportar", "Verificar Formulario<br>" + arrError.join("<br>") );
                } else {

                    $.ajax({
                        url: Proveedor.url + "proveedor_entregas_Monitoreo_ajax.asp"
                        , method: "post"
                        , async: true
                        , dataType: "json"
                        , data: {
                              Tarea: 1000
                            , Fecha: dateFecha
                            , Est_ID: intEst_ID
                            , Prov_ID: intProv_ID
                            , Cli_ID: intCli_ID
                        }
                        , beforeSend: function(){
                            Cargando.Iniciar();
                        }
                        , success: function( res ){

                            var xlsData = XLSX.utils.json_to_sheet( res );
                            var xlsBook = XLSX.utils.book_new(); 

                            XLSX.utils.book_append_sheet(xlsBook, xlsData, "Entregas");

                            XLSX.writeFile(xlsBook, "Entregas.xlsx");
                        }
                        , error: function(){
                            Avisa("error", "Entregas - Exportar", "Error en la Peticion");
                            
                        }
                        , complete: function(){
                            Cargando.Finalizar();
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
        , Manifiesto: {
              DetalleVer: function(){

                return;

                var jsonPrm = ( !(arguments[0] == undefined) ) ? arguments[0] : {};
                var intMan_ID = ( !(jsonPrm.Man_ID == undefined) ) ? jsonPrm.Man_ID : -1;

                var bolError = false;
                var arrError = [];

                if( !(intMan_ID > -1) ){
                    bolError = true;
                    arrError.push("-Identificador No permitido");
                }

                if( bolError ){
                    Avisa("warning", "Entrega - Detalle", "Verificar Formulario<br>" + arrError.join("<br>") );
                } else {

                    $("#mdlEntSegEnt").modal('show');

                    $.ajax({
                        url: Proveedor.url + "Proveedor_Manifiesto_Entregas.asp"
                        , method: "post"
                        , async: true
                        , data: {
                              Man_ID: intMan_ID
                            , EsTransportista: Proveedor.EsTransportista
                        }
                        , beforeSend: function(){
                             Procesando.Visualizar({Contenedor: "mdlEntSegManBody"});
                        }
                        , success: function( res ){

                            $("#mdlEntSegManBody").html( res );
                            $("#mdlEntSegMan").modal("show");
                        
                        }
                        , error: function(){
                            Avisa("error", "Manifiesto - Detalle", "Error en la peticion");
                        }
                        , complete: function(){
                            Procesando.Ocultar();
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
                        <div class="ibox-tools tooltip-demo">
                            
                            <button class="btn btn-white btn-sm" type="button" id="btnLimpiar" onClick="Proveedor.Buscar.FiltrosLimpiar()">
                                <i class="fa fa-trash-o"></i> Limpiar
                            </button>

                            <button data-toggle="tooltip" data-placement="left" title="Tooltip on left" class="btn btn-success btn-sm" type="button" id="btnBuscar" onClick="Proveedor.Buscar.ListadoBuscar()">
                                <i class="fa fa-search"></i> Buscar
                            </button>

                        </div>
                    </div>
                    <div class="ibox-content">
                        <div class="row">
                            <div class="col-sm-12 m-b-xs">  
<%  if( !(bolEsTransportista) ){             
%>                               
                                <div class="form-group row">      

                                    <label class="control-label col-md-2">Cliente</label>
                                    <div class="col-md-4 ">
<%  
        CargaCombo("selPrvSegCli_ID", "class='form-control select2'", "Cli_ID", "Cli_Nombre", "Cliente", "", "Cli_Nombre ASC", "", cxnTipo, "TODOS", "-1")
%>
                                    </div>                                    
                                    
                                    <label class=" control-label col-sm-2">Transportista:</label>
                                    <div class="col-sm-4 m-b-xs">
<%
        CargaCombo("selPrvSegProv_ID", "class='form-control select2'", "Prov_ID", "Prov_Nombre", "Proveedor", "Prov_Habilitado = 1 AND Prov_EsPaqueteria = 1", "Prov_Nombre ASC", "", cxnTipo, "TODOS", "")
%>                                        
                                    </div>

                                </div>
<%  
    } else {
%>
                                <input id="selPrvSegProv_ID" type="hidden" value="<%= intProv_ID %>" />
<%
    }
%>
                                <div class="form-group row">

                                    <label class="col-sm-2 control-label">Rango fechas:</label>
                                    <div class="col-sm-4 m-b-xs">
                                        <div class="input-group">
                                            <input class="form-control date-picker date" id="inpPrvSegFecBus" 
                                                placeholder="dd/mm/aaaa - dd/mm/aaaa" type="text" value="" autocomplete="off" > 
                                            <span class="input-group-addon">
                                                <i class="fa fa-calendar"></i>
                                            </span>
                                        </div>
                                    </div>
                                    <input id="hidPrvSegFecIni" type="hidden" value="" />
                                    <input id="hidPrvSegFecFin" type="hidden" value="" />
                                    
                                </div>

                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-sm-12">

                <div class="ibox-title">
                    <h5>Resultados</h5>
                    <div class="ibox-tools">

                        <label class="pull-right form-group">
                            <span class="text-success" id="spanPrvSegTotReg">

                            </span> Registros
                        </label>

                    </div>
                </div>

                <div class="ibox">

                    <div class="ibox-content">
                        <table class="table table-hover">
                            <thead id="thPrvSegEnc">
                                <tr>
                                    <th>Fecha</th>
                                    <th>Tr&aacute;nsito</th>
                                    <th>1er Intento</th>
                                    <th>2do Intento</th>
                                    <th>3er Intento</th>
                                    <th>Entregado</th>
                                    <th>Falla Entrega</th>
                                    <th>Devuelto</th>
                                    <th>Total</th>
                                </tr>
                            </thead>
                            <tbody id="tbPrvSegLis">

                            </tbody>
                            <tfoot>
                                <tr>
                                    <td colspan="8" id="tfPrvSegCar">
                                    
                                    </td>
                                </tr>
                            </tfoot>
                        </table>
                    </div>
                </div>
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

<div class="modal fade" id="mdlEntSegMan" tabindex="-1" role="dialog" aria-labelledby="divEntSegMan" aria-hidden="true" style="display: none;">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
                <h2 class="modal-title" id="divEntSegMan">
                    <i class="fa fa-file-text-o"></i> Manifiesto 
                    <br />
                    <small>Manifiesto</small>
                </h2>
                
            </div>
            <div class="modal-body" id="mdlEntSegManBody">

                
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-secondary btn-seg" data-dismiss="modal">
                    <i class="fa fa-times"></i> Cerrar
                </button>
                
            </div>
        </div>
    </div>
</div>
