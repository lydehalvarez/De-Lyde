 <%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2020-DIC-10 Devoulcion Decisión: Archivo Nuevo

var urlBase = "/pz/wms/Devolucion/"
var urlBaseTemplate = "/Template/inspina/";

%>
<link href="<%= urlBaseTemplate %>css/plugins/select2/select2.min.css" rel="stylesheet">
<link href="<%= urlBaseTemplate %>css/plugins/datapicker/datepicker3.css" rel="stylesheet">


<div id="wrapper">
    <div class="wrapper wrapper-content">    
        <div class="row">
            <div class="col-md-9">
                <div class="ibox">
                    <div class="ibox-title">
                        <h5>Filtros de b&uacute;squeda</h5>
                        <div class="ibox-tools">
                            <button class="btn btn-success btn-sm" type="button" id="btnBuscar" onClick="ManifiestoDevolucion.DecisionListadoCargar()">
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
                                        <input type="text" id="inpTAOVFolio" class="form-control" placeholder="Folio"
                                         autocomplete="off">
                                    </div>
                                    <label class="col-sm-2 control-label">Transportista</label>    
                                    <div class="col-sm-4 m-b-xs">
										<%CargaCombo("selProveedor",'class="form-control"',"Prov_ID","Prov_Nombre","Proveedor","Prov_EsPaqueteria = 1","Prov_ID","Editar",0,"Seleccione")%>
                                    </div>
                                </div>
                                <div class="row">
                                    <label class="col-sm-2 control-label">Fecha Inicial:</label>    
                                    <div class="col-sm-4 m-b-xs">
                                        <input type="text" id="inpManDFechaInicial" class="form-control date" placeholder="mm/dd/yyyy"
                                        autocomplete="off" readonly>
                                    </div>
                                    <label class="col-sm-2 control-label">Fecha Final:</label>    
                                    <div class="col-sm-4 m-b-xs">
                                        <input type="text" id="inpManDFechaFinal" class="form-control date" placeholder="mm/dd/yyyy"
                                        autocomplete="off" readonly>
                                    </div>   
                                </div>
                                <div class="row">
                                    <label class="col-sm-2 control-label">Manifiesto</label>
                                    <div class="col-sm-4 m-b-xs">
                                        <input type="text" id="inpManDFolio" class="form-control" placeholder="Folio"
                                        autocomplete="off">
                                    </div>
                                    <label class="col-sm-2 control-label">Cliente</label>    
                                    <div class="col-sm-4 m-b-xs">
										<%CargaCombo("selCliente",'class="form-control"',"Cli_ID","Cli_Nombre","Cliente","","Cli_ID","Editar",0,"Selecciona cliente")%>
                                    </div>   
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="ibox-content" id="loading">
                        <div class="row"> 
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
                    </div> 
                    <div class="row"> 
                        <div class="col-md-12" id="divManDListado">
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="ibox-content" id="loadingLateral">
                    <div class="row"> 
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
                </div>            
            	<div id="divLateral"></div> 
            </div>
        </div>
    </div>
</div>



<div class="modal fade" id="ModalReenvio" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="myModalLabel">Motivo de reenvio</h4>
      </div>
      <div class="modal-body" id="divReenvio">
			
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
        <button type="button" class="btn btn-primary">Save changes</button>
      </div>
    </div>
  </div>
</div>



<!-- Select2 -->
<script src="<%= urlBaseTemplate %>js/plugins/select2/select2.full.min.js"></script>
<!-- Data picker -->
<script src="<%= urlBaseTemplate %>js/plugins/datapicker/bootstrap-datepicker.js"></script>
<!-- Loading -->
<script src="<%= urlBaseTemplate %>js/loading.js"></script>
<!-- Lateral Flotante -->
<!--<script src="<%= urlBaseTemplate %>js/lateralflotante.js"></script>-->

<!-- Librerias-->
<script type="text/javascript" src="/pz/wms/Almacen/Cliente/js/Cliente.js"></script>
<script type="text/javascript" src="/pz/wms/Devolucion/Proveedor/js/Proveedor.js"></script>
<script type="text/javascript" src="/pz/wms/Devolucion/ManifiestoDevolucion/js/ManifiestoDevolucion.js"></script>

<script type="text/javascript">

$("#loading").hide();
$("#loadingLateral").hide()

    $(document).ready(function(){

        //Proveedor.ComboCargar();
        //Cliente.ComboCargar();
        ManifiestoDevolucion.DecisionListadoCargar();
        $("#selProveedor").select2();
        $("#selCliente").select2();

        $('.date').datepicker({
            todayBtn: "linked", 
            keyboardNavigation: false,
            forceParse: false,
            calendarWeeks: true,
            autoclose: true,
            endDate: '0d',
        });

    });
	
	$(document).scroll(function(e) {
	
		if ($(document).scrollTop() > 230) {
			$("#divLateral").css({
					 "position": "fixed"
//					, "padding-right": "15px"
//					, "padding-left": "15px"
					,"padding-right":"10px"
					, "top": "10px"
//					, "width": "25%"
					, "overflow-y": "auto"
					, "max-height": "650px"
					, "z-index": "2000"
				})
		} else {
			$("#divLateral").removeAttr("style");
		}
		
	}); 	
	
	
	$('#inpTAOVFolio').on('keypress',function(e) {
		if(e.which == 13) {
			ManifiestoDevolucion.DecisionListadoCargar();
		}
	});
    
</script>
