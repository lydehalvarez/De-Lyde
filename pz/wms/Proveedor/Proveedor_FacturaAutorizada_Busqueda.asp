<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2021-MAR-30 Factura Autorizada: Creación de archivo

var cxnTipo = 0

var urlBase = "/pz/wms/Proveedor/"
var urlBaseTemplate = "/Template/inspina/";

var rqIntProv_ID = Parametro("Prov_ID", -1)

var bolEsTransportista = ( rqIntProv_ID > -1 )
%>

<link href="<%= urlBaseTemplate %>css/plugins/select2/select2.min.css" rel="stylesheet">
<link href="<%= urlBaseTemplate %>css/plugins/daterangepicker/daterangepicker-bs3.css" rel="stylesheet">

<!-- Select2 -->
<script src="<%= urlBaseTemplate %>js/plugins/select2/select2.full.min.js"></script>
<!-- Loading -->
<script src="<%= urlBaseTemplate %>js/loading.js"></script>
<!-- Date range use moment.js same as full calendar plugin -->
<script src="<%= urlBaseTemplate %>js/plugins/fullcalendar/moment.min.js"></script>
<!-- Date range picker -->
<script src="<%= urlBaseTemplate %>js/plugins/daterangepicker/daterangepicker.js"></script>

<script type="text/javascript">

    $(document).ready(function(){

        $(".select2").select2();

        $('#inpProFacAutBusFechaBusqueda').daterangepicker({
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
				"monthNames": [ "Enero","Febrero","Marzo","April","Mayo","Junio","Julio","Agosto","Septimbre","Octubre","Novimbre","Dicimbre"]
			//"alwaysShowCalendars": true,	
		}}, function(start, end, label) {
            $("#inpProFacAutBusFechaInicial").val(moment.utc(start, 'MM/DD/YYYY').local().format('MM/DD/YYYY'))
            $("#inpProFacAutBusFechaFinal").val(moment.utc(end, 'MM/DD/YYYY').local().format('MM/DD/YYYY'))
            $("#inpProFacAutBusFechaBusqueda").val((moment.utc(start, 'DD/MM/YYYY').local().format('DD/MM/YYYY')) + " - " + (moment.utc(end, 'DD/MM/YYYY').local().format('DD/MM/YYYY')))
        });


    });

    var Proveedor = {
        url: "/pz/wms/Proveedor/"
        , RegistrosPagina: 10
        , Filtros: {
              Proveedor: -1
            , Folio: ""
            , Manifiesto: ""
            , Guia: ""
            , FechaInicial: ""
            , FechaFinal: ""
        }
        , TipoDocumento: {
             Transferencia: 1
            , OrdenVenta: 2
        }
        , FiltrosLimpiar: function(){
            $("#inpProFacAutBusFolio").val("");
            $("#inpProFacAutBusMan_Folio").val("");
            $("#inpProFacAutBusGuia").val("");

            $("#inpProFacAutBusFechaBusqueda").val("");
            $("#inpProFacAutBusFechaInicial").val("");
            $("#inpProFacAutBusFechaFinal").val("");

            $("#objProFacAutBusProv_ID").val("");
            $("#select2-objProFacAutBusProv_ID-container").text("TODOS");

            var bolEsProveedor = ($("#objProFacPorAutBusProv_ID").data("esproveedor") == 1 );

            if( !(bolEsProveedor) ) {
                Proveedor.Filtros.Proveedor = -1
            }
            Proveedor.Filtros.Folio = "";
            Proveedor.Filtros.Manifiesto = "";
            Proveedor.Filtros.Guia = "";
            Proveedor.Filtros.FechaInicial = "";
            Proveedor.Filtros.FechaFinal = "";

        }
        , ListadoBuscar: function(){
            var strFolio = $("#inpProFacAutBusFolio").val();
            var strMan_Folio = $("#inpProFacAutBusMan_Folio").val();
            var strGuia =  $("#inpProFacAutBusGuia").val();

            var dateFechaInicial = $("#inpProFacAutBusFechaInicial").val();
            var dateFechaFinal = $("#inpProFacAutBusFechaFinal").val();
            var intIDUsuario = $("#IDUsuario").val();
            var intProv_ID = $("#objProFacAutBusProv_ID").val();
            var bolEsProveedor = ($("#objProFacAutBusProv_ID").data("esproveedor") == 1 );

            var bolError = false;

            if( strFolio == "" && strMan_Folio == "" && strGuia == "" &&  dateFechaInicial == "" && dateFechaFinal == "" && ( bolEsProveedor || ( !(bolEsProveedor) && intProv_ID == "-1"))){
                bolError = true;
            }

            if( bolError ){
                Avisa("warning", "Entregas", "Seleccionar al menos un filtro");
            } else {

                Proveedor.Filtros.Proveedor = intProv_ID;
                Proveedor.Filtros.Folio = strFolio;
                Proveedor.Filtros.Manifiesto = strMan_Folio;
                Proveedor.Filtros.Guia = strGuia;
                Proveedor.Filtros.FechaInicial = dateFechaInicial;
                Proveedor.Filtros.FechaFinal = dateFechaFinal;

                Proveedor.ListadoCargar( true );

            }
        }
        , ListadoCargar: function( prmBolIniciaBusqueda ){

            var intRegistros =  $(".cssDocumentos").length;
            var intIDUsuario = $("#IDUsuario").val();
            var intSiguienteRegistro = ( prmBolIniciaBusqueda ) ? 0 : intRegistros;
            var intRegistrosPagina = $("#inpRegPag").val();

            var intRegPag = (intRegistrosPagina == "") ? Proveedor.RegistrosPagina : intRegistrosPagina;

            if( prmBolIniciaBusqueda ){
                $("#divProFacAutBusListado").html("");
                $("#divProFacAutBusTotalRegistros").text("");
            } 

            Procesando.Visualizar({Contenedor: "divProFacAutBusCargando"})

            $.ajax({
                url: this.url + "Proveedor_FacturaAutorizada_Listado.asp"
                , method: "post"
                , async: true
                , data: {
                      Prov_ID: Proveedor.Filtros.Proveedor
                    , Guia: Proveedor.Filtros.Guia
                    , Folio: Proveedor.Filtros.Folio 
                    , Man_Folio: Proveedor.Filtros.Manifiesto
                    , FechaInicial: Proveedor.Filtros.FechaInicial
                    , FechaFinal: Proveedor.Filtros.FechaFinal
                    , IDUsuario: intIDUsuario
                    , SiguienteRegistro: intSiguienteRegistro
                    , RegistrosPagina: intRegPag
                }
                , success: function(res){

                    Procesando.Ocultar();

                    if(prmBolIniciaBusqueda){
                        $("#divProFacAutBusListado").html( res );    
                    } else {
                        $("#divProFacAutBusListado").append( res );
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
                    
                    $("#divProFacAutBusCargando").html(objMas);

                    Proveedor.ListadoRegistrosContar();
                
                }
                , error: function(){

                    Procesando.Ocultar();
                    Avisa("error","Proveedor Entregas", "No se puede cargar el listado de Entregas")
                    
                }
            });
            
        }
        , ListadoRegistrosContar: function(){
           var intRegistros = $(".cssDocumentos").length;

           $("#divProFacAutBusTotalRegistros").text(intRegistros);
        }
        , TodosSeleccionar: function(){

            var bolTodo = $("#chbTodos").is(":checked");

            $(".cssTodos").prop("checked", bolTodo);
        }
        , DocumentoSeleccionar: function(){

            var bolTodo = (  $(".cssTodos:checked").length == $(".cssTodos").length );

            $("#chbTodos").prop("checked", bolTodo);
        }
        , PagoSolicitar: function(){

            var bolError = false;
            var arrError = [];
            var arrDoc = [];
            var totSel = $(".cssDocumentos:checked").length;
            var totProv = 0;

            var intProv_ID = $("#objProFacAutBusProv_ID").val();
            
            $(".cssDocumentos:checked").each(function(){

                var intProVID = $(this).data("prov_id");
                var strGuia = $(this).data("guia");

                var intID = -1
                if( intProv_ID == intProVID) {
                    totProv++;
                }

                arrDoc.push(strGuia);

            });

            if( arrDoc.length == 0 ){
                bolError = true;
                arrError.push("- Seleccionar al menos una Entrega")
            } else if( arrDoc.length != totProv ){
                bolError = true;
                arrError.push("- Se seleccionaron TA y/o OV de diferente Proveedor")
            }

            if( intProv_ID == "-1" ){
                bolError = true;
                arrError.push("- Seleccionar el proveedor");
            }

            if( bolError ){
                Avisa("warning","Solictar pago de factura", "Verificar formulario<br>" + arrError.join("<br>"));
            } else {

                swal({
                    title: "Confirmar la Solicitud de Pago",
                    text: "Al Confirmar ya no podra modificar la solicitud de Pago",
                    type: "warning",
                    showCancelButton: true,
                    confirmButtonColor: "#DD6B55",
                    confirmButtonText: "Confirmar",
                    closeOnConfirm: false
                }
                , function(){

                    var strDoc = arrDoc.join(",");

                    Cargando.Iniciar();
                    
                    $.ajax({
                          url: Proveedor.url + "Proveedor_FacturaAutorizada_ajax.asp"
                        , method: "post"
                        , asyn: true
                        , dataType: "json"
                        , data: {
                              Tarea: 2000
                            , Prov_ID : intProv_ID
                            , Documentos: strDoc
                        }
                        , success: function( res ){

                            console.log(res);

                            Cargando.Finalizar();
                            swal.close();

                            if(res.Error.Numero == 0){
                                Avisa("success","Solicitud de pago de factura", res.Error.Descripcion);

                                Proveedor.ListadoBuscar();
                            } else {
                                Avisa("warning","Solicitud de pago de factura", res.Error.Descripcion);
                            }
                        }
                        , error: function(){

                            Cargando.Finalizar();
                            Avisa("error","Solicitud de pago de factura", "No se puede crear la solicitud de pago de factura");
                            swal.close();
                            
                        }
                    });

                });

            }
        }
        , Ver: function(){
            var jsonPrm = ( !(arguments[0] == undefined) ) ? arguments[0] : {};
            var intProv_ID = ( !(jsonPrm.Prov_ID == undefined) ) ? jsonPrm.Prov_ID: -1;
            var intProG_ID = ( !(jsonPrm.ProG_ID == undefined) ) ? jsonPrm.ProG_ID: -1;

            $("#Prov_ID").val(intProv_ID);
            $("#ProG_ID").val(intProG_ID);

            CambiaSiguienteVentana();
        }
        , EntregasVer: function( prmIntID, prmBolVer ){

            if( prmBolVer ){
                $("#tr_Doc_" + prmIntID).show();
                $("#a_Doc_Ocultar_" + prmIntID).show();
                $("#a_Doc_Ver_" + prmIntID).hide();
            } else {
                $("#tr_Doc_" + prmIntID).hide();
                $("#a_Doc_Ocultar_" + prmIntID).hide();
                $("#a_Doc_Ver_" + prmIntID).show();
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
 
                            <button class="btn btn-info btn-sm" type="button" id="btnBuscar" onClick="Proveedor.PagoSolicitar()">
                                <i class="fa fa-credit-card"></i> Solictar Pago
                            </button>  

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
<%  if( bolEsTransportista ){             
%>                       
                                    <input id="objProFacAutBusProv_ID" type="hidden" data-esproveedor='1' value="<%= rqIntProv_ID %>" />
<%  } else {
%>
                                    <label class="col-sm-2 control-label">Transportista:</label>
                                    <div class="col-sm-4 m-b-xs">
                                    
<%
        CargaCombo("objProFacAutBusProv_ID", "class='form-control select2' data-esproveedor='0'", "Prov_ID", "Prov_Nombre", "Proveedor", "Prov_Habilitado = 1 AND Prov_EsPaqueteria = 1", "Prov_Nombre ASC", "", cxnTipo, "TODOS", "")
%>
                                    </div>

                                    <div class="col-sm-6 m-b-xs">                                
                                        
                                    </div>
<%
    }
%>
                                </div>
                                
                                <div class="form-group row">

                                    <label class="col-sm-2 control-label">Guia:</label>    
                                    <div class="col-sm-4 m-b-xs">
                                        <input type="text" id="inpProFacAutBusGuia" class="form-control" placeholder="Guia"
                                         autocomplete="off" maxlength="30">
                                    </div>

                                    <label class="col-sm-2 control-label">Folio:</label>    
                                    <div class="col-sm-4 m-b-xs">
                                        <input type="text" id="inpProFacAutBusFolio" class="form-control" placeholder="Folio SO o TA"
                                         autocomplete="off" maxlength="30">
                                    </div>
                                    
                                </div>

                                <div class="form-group row">

                                    <label class="col-sm-2 control-label">Rango fechas:</label>
                                    <div class="col-sm-4 m-b-xs">
                                        <div class="input-group">
                                            <input class="form-control date-picker date" id="inpProFacAutBusFechaBusqueda" 
                                                placeholder="dd/mm/aaaa - dd/mm/aaaa" type="text" value="" autocomplete="off" > 
                                            <span class="input-group-addon">
                                                <i class="fa fa-calendar"></i>
                                            </span>
                                        </div>
                                    </div>
                                    <input id="inpProFacAutBusFechaInicial" type="hidden" value="" />
                                    <input id="inpProFacAutBusFechaFinal" type="hidden" value="" />
                                    
                                    <label class="col-sm-2 control-label">Folio de  Manifiesto:</label>    
                                    <div class="col-sm-4 m-b-xs">
                                        <input type="text" id="inpProFacAutBusMan_Folio" class="form-control" placeholder="Folio Manifiesto"
                                        autocomplete="off" maxlength="30">
                                    </div>   

                                </div>

<%
    if ( !(bolEsTransportista) ){
%>
                                <input type="hidden" name="Prov_ID" id="Prov_ID" value="-1">
<%
    }
%>
                                <input type="hidden" name="ProG_ID" id="ProG_ID" value="-1">
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
                                <span class="text-success" id="divProFacAutBusTotalRegistros">

                                </span> Registros
                            </label>

                        </div>
                    </div>
                    <div class="ibox-content">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>
                                        <input type="checkbox" id="chbTodos" onclick="Proveedor.TodosSeleccionar()">
                                    </th>
                                    <th>#</th>
                                    <th class="col-sm-2">Gu&iacute;a</th>
                                    <th class="col-sm-2"></th>
                                    <th class="col-sm-3"></th>
                                    <th class="col-sm-4"></th>
                                </tr>
                            </thead>
                            <tbody id="divProFacAutBusListado">

                            </tbody>
                            <tfoot>
                                <tr>
                                    <td colspan="8" id="divProFacAutBusCargando">

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