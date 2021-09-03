<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2021-ENE-26 Devoulcion Decisión: Archivo Nuevo

var urlBase = "/pz/wms/Devolucion/"
var urlBaseTemplate = "/Template/inspina/";

%>
<link href="<%= urlBaseTemplate %>css/plugins/select2/select2.min.css" rel="stylesheet">
<link href="<%= urlBaseTemplate %>css/plugins/daterangepicker/daterangepicker-bs3.css" rel="stylesheet">
<link href="<%= urlBaseTemplate %>css/plugins/iCheck/green.css" rel="stylesheet">
<!-- Select2 -->

<div id="wrapper">
    <div class="wrapper wrapper-content">    
        <div class="row">
            <div class="col-sm-12">
                <div class="ibox">
                    <div class="ibox-title">
                        <h5>Filtros de b&uacute;squeda</h5>
                        <div class="ibox-tools">
                            
                            <button class="btn btn-success btn-sm" type="button" id="btnBuscar" onClick="NotaEntradaPendienteBuscar.ListadoCargar();">
                                <i class="fa fa-search"></i> Buscar
                            </button>

                        </div>
                    </div>
                    <div class="ibox-content">
                        <div class="row"> 
                            <div class="col-sm-12 m-b-xs">        
                                <div class="row">
                                    <label class="col-sm-2 control-label" title="Transferencia/Orden de Venta">Tra. /Ord Vta.:</label>
                                    <div class="col-sm-4 m-b-xs">
                                        <input type="text" id="inpNEPBTAOVFolio" class="form-control" placeholder="Folio"
                                         autocomplete="off">
                                    </div>
                                    <label class="col-sm-2 control-label">Producto(SKU)</label>    
                                    <div class="col-sm-4 m-b-xs">
                                        <input type="text" id="inpNEPBPro_SKU" class="form-control" placeholder="SKU"
                                         autocomplete="off">
                                    </div>   
                                </div>
                                <div class="row form-group">
                                    <label class="col-sm-2 control-label">Rango fechas:</label>
                                    <div class="col-sm-4 m-b-xs">
                                        <div class="input-group">
                                            <input class="form-control date-picker date" id="inpNEPBFechaBusqueda" 
                                                placeholder="mm/dd/aaaa" type="text" value="" autocomplete="off" > 
                                            <span class="input-group-addon">
                                                <i class="fa fa-calendar"></i>
                                            </span>
                                        </div>
                                    </div>
                                    <input id="inpNEPBFechaInicial" type="hidden" value="" />
                                    <input id="inpNEPBFechaFinal" type="hidden" value="" />
                                    <label class="col-sm-2 control-label">Cliente</label>    
                                    <div class="col-sm-4 m-b-xs">
                                    <%CargaCombo("Cli_ID",'class="form-control"',"Cli_ID","Cli_Nombre","Cliente","","Cli_ID","Editar",0,"Selecciona cliente")%>
                                    </div>
                                    
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!--
            <div class="col-sm-3" id="divLateral" >
                
            </div>
            -->
        </div>
        <div id="loading" class="row">
            <div class="col-md-12">
                <div class="ibox text-center">
                    <div class="spiner-example">
                        <div class="sk-spinner sk-spinner-wandering-cubes">
                            <div class="sk-cube1"></div>
                            <div class="sk-cube2"></div>
                        </div>
                    </div>
                    <p>Cargando informaci&oacute;n espere un momento por favor</p>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-md-12">
                <div class="ibox">
                    <div id="divNEPBListado"></div>
                </div>
            </div>
        </div>
    </div>
</div>


<div class="modal fade" id="ModalNotaEntrada" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="myModalLabel">Crear nota de entrada</h4>
      </div>
      <div class="modal-body" id="bodyModalNotaEntrada">

      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Cancelar</button>
        <button type="button" class="btn btn-primary btnCreaNota">Crear nota</button>
      </div>
    </div>
  </div>
</div>


<div class="modal fade" id="ModalCondicion" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <h4 class="modal-title" id="myModalLabel">Condiciones del <span id="Condi_SKU"></span></h4>
      </div>
      <div class="modal-body" id="bodyModalCondicion">

      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-primary btnGuardaCondicion">Guarda condici&oacute;n</button>
      </div>
    </div>
  </div>
</div>

<input type="hidden" class="datos" id="ID" value=""/>
<input type="hidden" class="datos" id="EsOV" value=""/>
<input type="hidden" class="datos" id="Motivo" value=""/>

<script src="<%= urlBaseTemplate %>js/plugins/select2/select2.full.min.js"></script>
<script src="<%= urlBaseTemplate %>js/plugins/clipboard/clipboard.min.js"></script>
<!-- Loading -->
<script src="<%= urlBaseTemplate %>js/loading.js"></script>
<!-- Lateral Flotante -->
<script src="<%= urlBaseTemplate %>js/lateralflotante.js"></script>

<!-- Date range use moment.js same as full calendar plugin -->
<script src="<%= urlBaseTemplate %>js/plugins/fullcalendar/moment.min.js"></script>

<!-- Date range picker -->
<script src="<%= urlBaseTemplate %>js/plugins/daterangepicker/daterangepicker.js"></script>
<script src="<%= urlBaseTemplate %>js/plugins/iCheck/icheck.min.js"></script>
<!-- Librerias-->
<script type="text/javascript" src="/pz/wms/Almacen/Cliente/js/Cliente.js"></script>
<script type="text/javascript" src="/pz/wms/Devolucion/NotaEntrada/js/NotaEntrada_PendienteBuscar.js"></script>

<script src="/Template/Inspina/js/plugins/PrintJs/print.min.js"></script>


<script type="text/javascript">

	$("#loading").hide();
    $(document).ready(function(){

		new Clipboard('.btnCopiTRA');
//        Cliente.ComboCargar({
//            Contenedor: "selNEPBCliente"
//            , UsaNotaEntrada: 1
//        });

        $("#Cli_ID").select2();

        $('#inpNEPBFechaBusqueda').daterangepicker({
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
				$("#inpNEPBFechaInicial").val(moment.utc(start, 'MM/DD/YYYY').local().format('MM/DD/YYYY'))
				$("#inpNEPBFechaFinal").val(moment.utc(end, 'MM/DD/YYYY').local().format('MM/DD/YYYY'))
                $("#inpNEPBFechaBusqueda").val($("#inpNEPBFechaInicial").val() + " - " + $("#inpNEPBFechaFinal").val())
            })
    });
	
	$('#inpNEPBTAOVFolio').on('keypress',function(e) {
		if(e.which == 13) {
			NotaEntradaPendienteBuscar.ListadoCargar()
		}
	});
   
	$('#ModalNotaEntrada').on('shown.bs.modal', function () {
		$('.btnCreaNota').prop('disabled',true);
	})
	$('#ModalNotaEntrada').on('hidden.bs.modal', function () {
		$('.datos').val("");
	})
	
	$('#ModalCondicion').on('hidden.bs.modal', function () {
		$('#bodyModalCondicion').html("");
	})
	
	$('.btnCreaNota').click(function(e) {
        e.preventDefault();
		NotaEntradaFunciones.Confirma();
    });
	
var NotaEntradaFunciones = {
	DatosOrden:function(ID,EsOV){
		$('#ID').val(ID);
		$('#EsOV').val(EsOV);
		$('#bodyModalNotaEntrada').html("");
		$('#ModalNotaEntrada').modal("show");
		$('#bodyModalNotaEntrada').load("/pz/wms/Devolucion/NotaEntrada/NotaEntrada_Articulo.asp", {ID:ID,EsOV:EsOV});
	},
	Confirma:function(){
		swal({
		  title: 'Generar documento',
		  text: "<strong>Verifica las cantidades, ya que solo hay un intento de generaci&oacute;n de documento.</strong>",
		  type: "warning",
		  showCancelButton: true,  
		  confirmButtonClass: "btn-success",
		  confirmButtonText: "Ok" ,
		  closeOnConfirm: false,
		  html: true
		},
		function(data){
			if(data){
				swal({
					title: "Documento generandose!",
					text: "Por favor espere el documento que esta generando elektra!",
					type: "success",
				    closeOnConfirm: true
				});
				$('.btnCreaNota').prop('disabled',true);
				NotaEntradaFunciones.GeneraDocumento();
			}
		});
	},
	GeneraDocumento:function(){
		var Contenido = []
		$(".idContenido").each(function() {
			if($(this).val() > 0){
				Contenido.push({idContenido:""+$(this).data('idcont'),codigoEKT:""+$(this).data('sku'),cantidad:$(this).val(),imei:null})
			}
		});
		var request = {
				ID:$('#ID').val(),
				EsOV:$('#EsOV').val(),
				Motivo:""+$('#Motivo').val(),
				IDUsuario:$('#IDUsuario').val(),
				Articulos:Contenido
		}
		console.log(request);
		var myRequest = JSON.stringify(request);
		$.ajax({
			type: 'post',
			cache:false,
			async:true,
			data:myRequest,
			contentType:'application/json',
			url: "https://elektra.lydeapi.com/api/Lyde/Elektra/NE",
			success: function(response){
				console.log(response) 
				if(response.result == 1 || response.result == 2){
					NotaEntradaPendienteBuscar.ListadoCargar();
					$('#ModalNotaEntrada').modal('hide');
					swal({
						title: response.message,
						text: "El folio de gener&oacute; correctamente",
						type: "success",
						closeOnConfirm: true,
						html:true
					});
					NotaEntradaFunciones.ImprimeGuia(response.data.pdf,"Folio de entrada");
				}else{
					swal({
						title: response.message,
						text: "<strong>Ocurri&oacute; un error</strong>",
						type: "error",
						closeOnConfirm: true,
						html:true
					});
				}
			}
			
		});

	},
	VerificaSerie:function(Serie){
		var request = {
				SerialNumber:""+Serie,
				ID:$('#ID').val(),
				EsOV:$('#EsOV').val()
			}
		console.log(request)
		var myRequest = JSON.stringify(request)
		$.ajax({
			type: 'post',
			cache:false,
			async:true,
			data:myRequest,
			contentType:'application/json',
			url: "https://wms.lydeapi.com/api/s2008/VerificaSerie",
			success: function(response){
				console.log(response) 
				if(response.result == 1){
					//NotaEntradaFunciones.Condicion(response.data.ID,response.data.IID,1);
					$("#Cant_"+response.data.ID+"_"+response.data.IID).html(response.data.Cantidad)
					$("#Cant_Resul_"+response.data.ID+"_"+response.data.IID).val(response.data.Cantidad)
				}else{
					swal({
						title: response.message,
						text: "<strong>Ocurri&oacute; un error</strong>",
						type: "error",
						closeOnConfirm: true,
						html:true
					});
				}
			}
			
		});
	},
	VerificaNOSerializado:function(request){
		//console.log(request)
		var myRequest = JSON.stringify(request)
		$.ajax({
			type: 'post',
			cache:false,
			async:true,
			data:myRequest,
			contentType:'application/json',
			url: "https://wms.lydeapi.com/api/s2008/VerificaNoSerializado",
			success: function(response){
				//console.log(response) 
//				if(response.result == 1){
//				}else{
//					swal({
//						title: response.message,
//						text: "<strong>Ocurri&oacute; un error</strong>",
//						type: "error",
//						closeOnConfirm: true,
//						html:true
//					});
//				}
			}
			
		});
	},
	ImprimeGuia:function(guia,name) {
		printJS({
			printable: guia,
			type: 'pdf',
			base64: true
		})	
	},
	Condicion:function(iD,iiD,Serie,Serializado){
		var Datos = {
			ID:iD,
			IID:iiD,
			Serie:Serie,
			Serializado:Serializado
		}
		$('#bodyModalCondicion').load("/pz/wms/Devolucion/NotaEntrada/NotaEntrada_Condicion.asp",Datos);
		$('#ModalCondicion').modal({backdrop: 'static', keyboard: false}) 
	}
		
}
    
</script>
