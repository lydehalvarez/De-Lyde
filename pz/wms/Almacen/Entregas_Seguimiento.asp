<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2021-JUN-14 Entregas - Seguiemiento: Creación de archivo

var cxnTipo = 0

var urlBase = "/pz/wms/Almacen/"
var urlBaseTemplate = "/Template/inspina/";
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
       
        //Buscar Entregas
        $("#btnFilLim").on("click", function(){
            Entrega.Buscar.FiltrosLimpiar();
        });

        $("#btnFilBus").on("click", function(){
            Entrega.Buscar.ListadoBuscar();
        });

        //Entregas
        $("#chbTodos").on("click", function(){
            Entrega.Buscar.TodosSeleccionar();
        });

        //Rango de Fechas
        $('#inpFecBus').daterangepicker({
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
				$("#inpFecIni").val(moment.utc(start, 'MM/DD/YYYY').local().format('MM/DD/YYYY'))
				$("#inpFecFin").val(moment.utc(end, 'MM/DD/YYYY').local().format('MM/DD/YYYY'))
                $("#inpFecBus").val((moment.utc(start, 'DD/MM/YYYY').local().format('DD/MM/YYYY')) + " - " + (moment.utc(end, 'DD/MM/YYYY').local().format('DD/MM/YYYY')))
            }
        );

        //Entrega.Buscar.ListadoBuscar();

        $(".select2").select2();
    });

    var Entrega = {
          url: "/pz/wms/almacen/"
        , Detalle: {
              Ver: function( prmJson ){
                var bolError = false;
                var arrError = [];

                var intTA_ID = prmJson.TA_ID;

                if( intTA_ID == ""){
                    bolError = false;
                    arrError.push("- Seleccionar el Identifcador de la entrega");
                }

                if( bolError ) {
                    Avisa("warning", "Entregas - Seuuimientos", "Verificar Formulario<br>" + arrError.join("<br>"));
                } else {
                    
                    $.ajax({
                        url: "/pz/wms/TA/TA_Ficha.asp"
                        , method: "post"
                        , async: true
                        , data: {
                              TA_ID: intTA_ID
                            , EsTransportista: 1
                        }
                        , success: function( res ){
                            
                            $("#mdlDetVerBody").html( res );
                            $("#mdlDetVer").modal("show");
                            
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
        , Buscar: {
              RegistrosPagina: 10
            , Filtros: {
                  Folio: ""
                , SKU: ""
                , TipoArticulo: -1
                , CantidadArticulo: -1
                , FechaInicio: ""
                , FechaFinal: ""
                , Estatus: -1
            }
            , FiltrosLimpiar: function(){
                $("#inpFol").val("");
                $("#inpSKU").val("");

                $("#radTpoArtTod").prop("checked", true);
                $("#selCanArt").val("-1");

                $("#inpFecBus").val("");
                $("#inpFecIni").val("");
                $("#inpFecFin").val("");
                $("#selEntEst").val("");

                $("#select2-selEst-container").text("TODOS");
                $("#select2-selCanArt-container").text("TODOS");

                Entrega.Buscar.Filtros.Folio = "";
                Entrega.Buscar.Filtros.SKU = "";
                Entrega.Buscar.Filtros.TipoArticulo = -1;
                Entrega.Buscar.Filtros.CantidadArticulo = -1;
                Entrega.Buscar.Filtros.FechaInicio = "";
                Entrega.Buscar.Filtros.FechaFinal = "";
                Entrega.Buscar.Filtros.Estatus = -1;
            }
            , ListadoBuscar: function(){
                var bolError = false;
                var arrError = [];

                var strFolio = $("#inpFol").val();
                var strSKU = $("#inpSKU").val();
                var intTipoArticulo = $("input[name=radTpoArt]:checked").val();
                var intCantidadArticulo = $("#selCanArt").val();
                var dateFechaInicial = $("#inpFecIni").val();
                var dateFechaFinal = $("#inpFecFin").val();
                var intEstatus = $("#selEst").val();                

                Entrega.Buscar.Filtros.Folio = strFolio;
                Entrega.Buscar.Filtros.SKU = strSKU;
                Entrega.Buscar.Filtros.TipoArticulo = intTipoArticulo;
                Entrega.Buscar.Filtros.CantidadArticulo = intCantidadArticulo;
                Entrega.Buscar.Filtros.FechaInicio = dateFechaInicial;
                Entrega.Buscar.Filtros.FechaFinal = dateFechaFinal;
                Entrega.Buscar.Filtros.Estatus = intEstatus;

                Entrega.Buscar.ListadoCargar( true );
            }
            , ListadoCargar: function( prmBolIniBus ){
                
                var intReg =  $(".cssReg").length;
                var intSigReg = ( prmBolIniBus ) ? 0: intReg;
                var intRegPags = $("#inpRegPag").val();

                var intRegPag = (intRegPags == "" || intRegPags == undefined ) ? Entrega.Buscar.RegistrosPagina : intRegPags;

                if( prmBolIniBus ){
                    Entrega.Buscar.ListadoLimpiar();
                }

                Procesando.Visualizar({Contenedor: "tfCar"});

                $.ajax({
                      url: Entrega.url + "Entregas_Seguimiento_Listado.asp"
                    , method: "post"
                    , async: true
                    , data: {
                          Folio: Entrega.Buscar.Filtros.Folio
                        , SKU: Entrega.Buscar.Filtros.SKU
                        , TipoArticulo: Entrega.Buscar.Filtros.TipoArticulo
                        , CantidadArticulo: Entrega.Buscar.Filtros.CantidadArticulo
                        , FechaInicio: Entrega.Buscar.Filtros.FechaInicio
                        , FechaFinal: Entrega.Buscar.Filtros.FechaFinal
                        , Estatus: Entrega.Buscar.Filtros.Estatus
                        , SiguienteRegistro: intSigReg
                        , RegistrosPagina: intRegPag
                    }
                    , success: function( res ){

                        Procesando.Ocultar();

                        if( prmBolIniBus ){
                            $("#tbLis").html( res ); 
                        } else {
                            $("#tbLis").append( res ); 
                        }

                        var objMas = "";

                        if( res != ""){

                            objMas = "<div class='row'>"
                                    + "<div class='col-sm-8'>"
                                        + "<button type='button' class='btn btn-white btn-block' onClick='Entrega.Buscar.ListadoCargar(false)'>"
                                            + "<i class='fa fa-arrow-down'></i> Ver mas"
                                        + "</button>" 
                                    + "</div>"
                                    + "<div class='col-sm-3 input-group'>"
                                        + "<input type='number' id='inpRegPag' class='form-control text-right' placeholder='10' min='10' max='100' steep='10' value='10' maxlength='3' >"
                                        + "<span class='input-group-addon'> Reg/Pag </span>"
                                    + "</div>"
                                + "</div>"

                        } else if( prmBolIniBus ){
                            objMas = "<i class='fa fa-exclamation-circle fa-lg text-success'></i> No hay Registros"
                        }

                        $("#tfCar").html(objMas); 

                        Entrega.Buscar.ListadoRegistrosContar();
                    }
                    , error: function(){
                        Avisa("error", "Entregas Seguimiento - Listado", "Error en la peticion");
                        Procesando.Ocultar();
                    }
                });

            }
            , ListadoLimpiar: function(){
                $("#chbTodos").prop("checked", false);
                $("#tbLis").html("");
                $("#lblTotReg").text("");
                $("#tfCar").html("");
            }
            , ListadoRegistrosContar: function(){
                var intTerReg = $(".cssReg").length;
                $("#lblTotReg").text(intTerReg);
            }
            , TodosSeleccionar: function(){

            }
            , RegistroSeleccionar: function(){

            }
            , ArticuloSeleccionar: function(){

            }
        }
        , CancelacionSolictar: function(){

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

   
</script>

<div id="wrapper">
    <div class="wrapper wrapper-content">    
        <div class="row form-group">
            <div class="col-sm-12">
                <div class="ibox">
                    <div class="ibox-title">

                        <h3>Filtros</h3>
                        <div class="ibox-tools">
                            <button type="button" class="btn btn-white" id="btnFilLim">
                                <i class="fa fa-trash-o"></i> Limpiar
                            </button>
                            <button type="button" class="btn btn-success" id="btnFilBus">
                                <i class="fa fa-search"></i> Buscar
                            </button>
                        </div>
                        
                    </div>

                    <div class="ibox-content">

                        <div class="row form-group">

                            <label class="col-sm-2 control-label">
                                Folio
                            </label>
                            <div class="col-sm-4">
                                <input type="text" id="inpFol" class="form-control" placeholder="Folio" maxlength="50" autocomplete="off">
                            </div>

                            <label class="col-sm-2 control-label">
                                SKU
                            </label>
                            <div class="col-sm-4">
                                <input type="text" id="inpSKU" class="form-control" placeholder="SKU" maxlength="50" autocomplete="off">
                            </div>

                        </div>

                        <div class="row form-group">
                        
                            <label class="col-sm-2 control-label">
                                Tipo Art&iacute;culo
                            </label>
                            <div class="col-sm-4">
                          
                                <input type="radio" id="radTpoArtTod" name="radTpoArt" value="-1" checked>
                                <label for="radTpoArtTod">
                                    Todos
                                </label>
                                <input type="radio" id="radTpoArtTer" name="radTpoArt" value="1">
                                <label for="radTpoArtTer">
                                    Terminales
                                </label>
                                <input type="radio" id="radTpoArtAcc" name="radTpoArt" value="2">
                                <label for="radTpoArtAcc">
                                    Accesorios
                                </label>
                          
                            </div>

                            <label class="col-sm-2 control-label">
                                Cantidad de art&iacute;culos
                            </label>
                            <div class="col-sm-4">
                                <select id="selCanArt" class="form-control select2">
                                    <option value="-1">Todos</option>
<%
    for(var i=1; i<=10; i++){
%>
                                    <option value="<%= i %>"><%= i %> Art&iacute;culo(s)</option>
<%
    }
%>
                                </select>
                            </div>                        

                        </div>

                        <div class="row form-group">

                            <label class="col-sm-2 control-label">
                                Fecha
                            </label>
                            <div class="col-sm-4">
                                <input type="text" id="inpFecBus" class="form-control" placeholder="Fecha Inicial - Fecha Final" maxlength="50" autocomplete="off">

                                <input type="hidden" id="inpFecIni">
                                <input type="hidden" id="inpFecFin">
                            </div>

                            <label class="col-sm-2 control-label">
                                Estatus
                            </label>
                            <div class="col-sm-4">
<%
    CargaCombo("selEst", "class='form-control select2'", "Cat_ID", "Cat_nombre", "Cat_Catalogo", "SEC_ID = 51 AND Cat_ID IN ( 1, 2, 3, 4 )", "Cat_ID ASC", "", cxnTipo, "TODOS", "-1")
%>
                            </div>

                        </div>

                    </div>
                </div>

                <div class="ibox">
                    <div class="ibox-title">
                        <h5>Resultados</h5>
                        <div class="ibox-tools">
                           <label class="pull-right form-group">
                                <span class="text-success" id="lblTotReg">

                                </span> Registros
                            </label>
                        </div>
                    </div>

                    <div class="ibox-content">

                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>
                                        <input type="checkbox" id="chbTodos">
                                    </th>
                                    <th colspan="6">Entregas</th>
                                </tr>
                            </thead>
                            <tbody id="tbLis">

                            </tbody>
                            <tfoot>
                                <tr>
                                    <td colspan="7" id="tfCar">
                                    
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

<div class="modal fade" id="mdlDetVer" tabindex="-1" role="dialog" aria-labelledby="divDetVer" aria-hidden="true" style="display: none;">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
                <h2 class="modal-title" id="divDetVer">
                    <i class="fa fa-file-text-o"></i> Entrega 
                    <br />
                    <small>Entrega</small>
                </h2>
                
            </div>
            <div class="modal-body" id="mdlDetVerBody">

                
            </div>

            <div class="modal-footer">
                <button type="button" class="btn btn-secondary btn-seg" data-dismiss="modal">
                    <i class="fa fa-times"></i> Cerrar
                </button>
                
            </div>
        </div>
    </div>
</div>