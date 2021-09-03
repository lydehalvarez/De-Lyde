<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%

   
%>
    
<link href="/Template/inspina/css/plugins/iCheck/custom.css" rel="stylesheet">
<link href="/Template/inspina/css/plugins/select2/select2.min.css" rel="stylesheet">    
<link href="/Template/inspina/css/plugins/daterangepicker/daterangepicker-bs3.css" rel="stylesheet">
        
<div id="wrapper">
    <div class="wrapper wrapper-content"> 
        <div class="row">
      <div class="col-lg-12">
        <div class="ibox float-e-margins">
          <div class="ibox-title">
            <h5>Filtros de b&uacute;squeda</h5>
            <div class="ibox-tools">
              <!--a class="collapse-link"><i class="fa fa-chevron-up"></i></a> <a class="dropdown-toggle" data-toggle="dropdown" href="#"><i class="fa fa-wrench"></i></a>
              <ul class="dropdown-menu dropdown-user">
                <li>
                  <a href="#">Config option 1</a>
                </li>
                <li>
                  <a href="#">Config option 2</a>
                </li>
              </ul><a class="close-link"><i class="fa fa-times"></i></a>
            </div-->
          </div>
          <div class="ibox-content">
            <div class="row"> 
                <div class="col-sm-12 m-b-xs">        
                    <div class="row">
                        <label class="col-sm-2 control-label">Cliente:</label>
                        <div class="col-sm-4 m-b-xs">
<% 
    var sEventos = " class='input-sm form-control'  style='width:200px'"
    var sCondicion = "" 

    CargaCombo("cbCli_ID", sEventos, "Cli_ID", "Cli_Nombre", "Cliente", "", "Cli_Nombre"
              , Parametro("Cli_ID",-1), 0, "No aplica", "Editar")
%>
                        </div>
                        <label class="col-sm-2 control-label">Folio interno:</label>    
                        <div class="col-sm-3 m-b-xs">
                            <input id="ASN_Folio" class="input-sm form-control" type="text" value="" style="width:150px">
                        </div>
                        <div class="col-sm-1 m-b-xs" style="text-align: left;">  
                            <button class="btn btn-success btn-sm" type="button" id="btnBuscar"><i class="fa fa-search"></i>&nbsp;&nbsp;<span class="bold">Buscar</span></button>
                        </div> 
                    </div>    
                </div>
            </div>
            <div class="row">
                <div class="col-sm-12 m-b-xs">
                    <div class="row">

                        <label class="col-sm-2 control-label">Rango fechas:</label>
                        <div class="col-sm-4 m-b-xs" >
                            <input class="form-control date-picker date" id="FechaBusqueda" 
                                   placeholder="dd/mm/aaaa" type="text" value="" 
                                   style="width: 200px;float: left;" > 
                               <span class="input-group-addon" style="width: 37px;float: left;height: 34px;"><i class="fa fa-calendar"></i></span>
                            
                        </div>
                        <label class="col-sm-2 control-label">Folio cliente:</label>
                        <div class="col-sm-4 m-b-xs">
                            <input id="ASN_FolioCliente" class="input-sm form-control" type="text" value="" style="width:150px">
                        </div>
                        

                    </div>    
                </div>
            </div>
            <div class="row">
                <div class="col-sm-12 m-b-xs">
                    <div class="row">

                        <label class="col-sm-2 control-label">Estatus:</label>
                        <div class="col-sm-4 m-b-xs" >
<% 
    var sEventos = " class='input-sm form-control'  style='width:200px'"
    ComboSeccion("ASN_EstatusCG120",sEventos,120,-1,0,"Seleccione","","Editar")
    
%> 
                        </div>
                        <label class="col-sm-2 control-label">Folio Cita:</label>
                        <div class="col-sm-4 m-b-xs">
                            <input id="FolioCita" class="input-sm form-control" type="text" value="" style="width:150px">
                        </div>
                        

                    </div>    
                </div>
            </div>
                    

            <div class="table-responsive" id="dvTablaTranferencias"></div>  
          </div>
        </div>
      </div>
    </div>
    </div>                  
</div>
              


<div class="modal fade" id="ModalDocumento" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h3 class="modal-title" id="myModalLabel">ASN <span id="FolioASN"></span></h3>
      </div>
      <div class="modal-body">
            <div id="loading">
                <div class="spiner-example">
                    <div class="sk-spinner sk-spinner-wandering-cubes">
                    <div class="sk-cube1"></div>
                    <div class="sk-cube2"></div>
                    </div>
                </div>
            </div>
            <div id="ASNData"></div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-danger" data-dismiss="modal">Cancelar</button>
        <button type="button" class="btn btn-primary btnConfirmaASN">Confirmar</button>
      </div>
    </div>
  </div>
</div>



<script src="/Template/inspina/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
<script src="/Template/inspina/js/plugins/pace/pace.min.js"></script>
<script src="/Template/inspina/js/plugins/iCheck/icheck.min.js"></script>
<script src="/Template/inspina/js/plugins/select2/select2.full.min.js"></script>
        
        
<input id="ASN_ID" type="hidden" value="" />
<input id="ASN_Folio" type="hidden" value="" />
<input id="inicio" type="hidden" value="" />
<input id="fin" type="hidden" value="" />
<!-- Date range use moment.js same as full calendar plugin -->
<script src="/Template/inspina/js/plugins/fullcalendar/moment.min.js"></script>

<!-- Date range picker -->
<script src="/Template/inspina/js/plugins/daterangepicker/daterangepicker.js"></script>
<script src="/Template/Inspina/js/plugins/PrintJs/print.min.js"></script>

<script type="text/javascript">
        
		
		
$(document).ready(function(){
	$('#loading').hide()
    $('#FechaBusqueda').daterangepicker({
			"showDropdowns": true,
			//"singleDatePicker": true,
			"firstDay": 7,	
			"startDate": moment().subtract(29, 'days'),
			"endDate": moment(),
            "autoApply": true,
			"ranges": {
			   'Al dia de hoy': [moment().startOf('month'), moment()],
			   'Este Mes': [moment().startOf('month'), moment().endOf('month')],
			   'Mes pasado': [moment().subtract(1, 'month').startOf('month')
			                , moment().subtract(1, 'month').endOf('month')],		   
			   //'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
			   '+- 7 Dias': [moment().subtract(6, 'days'), moment().add(7, 'days')],
			   '+- 30 Dias': [moment().subtract(29, 'days'), moment().add(30, 'days')],
			   'Siguientes 60 Dias': [moment().startOf('month'), moment().add(60, 'days')]
			},			
			"locale": {
				"format": "DD/MM/YYYY", 
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
				$("#inicio").val(moment.utc(start, 'DD/MM/YYYY').local().format('DD/MM/YYYY'))
				$("#fin").val(moment.utc(end, 'DD/MM/YYYY').local().format('DD/MM/YYYY'))
                $("#FechaBusqueda").val($("#inicio").val() + " - " + $("#fin").val())
            })

    
    ASNFunction.CargaGridInicial()


	$("#btnBuscar").click(function(event) {
	
		var dato = {}
			dato['Lpp'] = 1  //este parametro limpia el cache
			dato['Cli_ID'] = $('#cbCli_ID').val()
			dato['ASN_EstatusCG120'] = $('#ASN_EstatusCG120').val()
			dato['ASN_Folio'] = $('#ASN_Folio').val()  
			dato['FolioCita'] = $('#FolioCita').val()
			dato['ASN_FolioCliente'] = $('#ASN_FolioCliente').val()
			dato['FechaInicio'] = $('#inicio').val()
			dato['FechaFin'] = $('#fin').val()
	
		$("#dvTablaTranferencias").load("/pz/wms/ASN/ASN_Grid.asp",dato);
	
	});
	
	$('.btnConfirmaASN').click(function(e) {
		ASNFunction.Confirma();
	});
	
	$('#ModalDocumento').on('hide.bs.modal', function (event) {
		$("#ASN_ID").val("");
		$('#ASN_Folio').val("")
	})
	
    
});   
 
    
	
var ASNFunction = {
	CargaGridInicial:function(){
        $("#dvTablaTranferencias").load("/pz/wms/ASN/ASN_Grid.asp");
	},
	Recibo:function(ASN_ID,Folio){
		$("#ASN_ID").val(ASN_ID);
		$("#FolioASN").html(Folio);
		$('#ASN_Folio').val(Folio)
		$("#ASNData").html("");
		$('#ModalDocumento').modal('show');
		
		$('#loading').show('slow',function(){
			$("#ASNData").load("/pz/wms/ASN/ASN_Data.asp",{ASN_ID:ASN_ID},function(){$('#loading').hide('slow')});
		});
	},
	Confirma:function(){
		swal({
		  title: 'Generar documento',
		  text: "<strong>Verifica las cantidades, ya que solo hay un intento de generaci&oacute;n de documento</strong>",
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
				    closeOnConfirm: true,

				});
				ASNFunction.GeneraDocumento()
			}
		});
	},
	GeneraDocumento:function(){
		var Contenido = []
		$(".idContenido").each(function() {
			Contenido.push({idContenido:$(this).data('idcont'),codigoEKT:""+$(this).data('sku'),cantidad:$(this).val(),imei:null,ordenCompra:""+$(this).data('ordencompra')})
		});
		var request = {
				ASN_ID:$('#ASN_ID').val(),
				IDUsuario:$('#IDUsuario').val(),
				Articulos:Contenido
		}
		console.log(request)
		var myRequest = JSON.stringify(request);
		$.ajax({
			type: 'post',
			cache:false,
			async:true,
			data:myRequest,
			contentType:'application/json',
			url: "https://wms.lydeapi.com/api/s2012/Recepcion/ReciboMercancia/Test",
			success: function(response){
				console.log(response) 
				if(response.result == 0){
					ASNFunction.CargaGridInicial();
					$('#ModalDocumento').modal('hide');
					if(response.data.pdf != null){
						swal({
							title: "Documento generado",
							text: "Resultado exitoso, ya puedes imprimir el documento",
							type: "success",
							closeOnConfirm: true,
							html:true
						});
						ASNFunction.ImprimeDoc(response.data.pdf,"Recibo "+$('#ASN_Folio').val());
					}else{
						swal({
							title: "Algo salio mal",
							text: "Lo sentimos, algo fallo con el documento, reportar este incidente a tu supervisor",
							type: "error",
							closeOnConfirm: true,
							html:true
						});
					}
				}else{
					swal({
						title: response.message,
						text: "<strong>Ocurri&oacute; un error al generar el folio en elektra</strong>",
						type: "error",
						closeOnConfirm: true,
						html:true
					});
				}
			}
			
		});
	},
	ImprimeDoc:function(guia,name) {
		printJS({
			printable: guia,
			type: 'pdf',
			base64: true
		})	
	},
	VerDocumento:function(ASN){
		window.open("http://wms.lyde.com.mx/Media/wms/DocsApi/ReciboMercancia/"+ASN);
	}
}	
        
</script>



