<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%	
	//HA ID: 2	2020-JUL-17 Se agrega Div de Detalle de Carga de Articulo
	
	var urlBase = "/pz/wms/OC/"
	
	var Cli_ID = Parametro("Cli_ID",-1)
	var CliOC_ID = Parametro("CliOC_ID",-1)
	var Usu_ID = Parametro("IDUsuario",0)
  	
	var sSQL = "SELECT Cli_ID, CliOC_ID, CliOC_Folio, CliOC_EnviarAlmacen, CliOC_DireccionFacturacion "
			+ " , CliOC_NumeroOrdenCompra, CliOC_FechaElaboracion, CliOC_FechaRequerido, CliOC_INCOTERM "
			+ " , CliOC_CondicionesPagoCG85, CliOC_Moneda, CliOC_TipoDeCambio "
			+ " , CliOC_SubTotal, CliOC_IVA, CliOC_Descuento, CliOC_Total, CliOC_Observaciones "
			+ " , CliOC_Proyecto, CliOC_Comprador, CliOC_Autorizador, CliOC_EstatusCG52 "
			+ " , CliOC_RutaArchivo, CliOC_TipoOCCG87, CliOC_FechaRegistro "
			+ " , CONVERT(NVARCHAR(20),CliOC_FechaElaboracion,103) as FechaElaboracion " 
			+ " , dbo.fn_CatGral_DameDato(52,CliOC_EstatusCG52) as ESTATUS "
   	    + " FROM Cliente_OrdenCompra "
		+ " WHERE Cli_ID = " + Cli_ID
			+ " AND CliOC_ID = " + CliOC_ID
		
	var rsOC = AbreTabla(sSQL,1,0)
	
    if (!rsOC.EOF){
		var CliOC_Observaciones = rsOC.Fields.Item("CliOC_Observaciones").Value
		var CliOC_NumeroOrdenCompra = rsOC.Fields.Item("CliOC_NumeroOrdenCompra").Value
		var FechaElaboracion = rsOC.Fields.Item("FechaElaboracion").Value		
		var CliOC_FechaRequerido = rsOC.Fields.Item("CliOC_FechaRequerido").Value	
		var ESTATUS = rsOC.Fields.Item("ESTATUS").Value	
		var CliOC_Folio = rsOC.Fields.Item("CliOC_Folio").Value	
	}

  	var sSQL = "Select Cli_RazonSocial, Cli_RFC, Cli_ContactoNombre, Cli_ContactoEmail, Cli_ContactoTelefono "
			+ " , dbo.fn_CatGral_DameDato(56,Cli_PersonalidadJuridicaCG56) as PersonalidadJuridica "
			+ " , ISNULL(CONVERT(NVARCHAR(20),Cli_UltimaCompra ,103),'') as UltimaCompra "
	    + " FROM Cliente "
	    + " WHERE Cli_ID = " + Cli_ID
   

 	var rsCli = AbreTabla(sSQL,1,0)	
	
	if (!rsCli.EOF){ 
		var Cli_RazonSocial = rsCli.Fields.Item("Cli_RazonSocial").Value
		var Cli_RFC = rsCli.Fields.Item("Cli_RFC").Value		
		var PersonalidadJuridica = rsCli.Fields.Item("PersonalidadJuridica").Value
		var Cli_ContactoTelefono = rsCli.Fields.Item("Cli_ContactoTelefono").Value		
		var Cli_ContactoEmail = rsCli.Fields.Item("Cli_ContactoEmail").Value
		var Cli_ContactoNombre = rsCli.Fields.Item("Cli_ContactoNombre").Value
		var UltimaCompra = rsCli.Fields.Item("UltimaCompra").Value					
	}

	var Parametros = "?CliOC_ID=" + CliOC_ID + "&Cli_ID=" + Cli_ID + "&Usu_ID=" + Usu_ID
%>
<link rel="stylesheet" type="text/css" href="/Template/inspina/css/plugins/jasny/jasny-bootstrap.min.css" >
<link rel="stylesheet" type="text/css" href="/Template/inspina/js/plugins/bootstrap-datepicker/css/datepicker.css"/>
<!-- Jasny -->
<script type="text/javascript" src="/Template/inspina/js/plugins/jasny/jasny-bootstrap.min.js"></script>  
<script type="text/javascript" src="/Template/inspina/js/plugins/bootstrap-datepicker/js/bootstrap-datepicker.js"></script>
<script type="text/javascript" src="/Template/inspina/js/plugins/bootstrap-datepicker/js/locales/bootstrap-datepicker.es.js"></script>
   
<script type="text/javascript">

	$(document).ready(function() { 

		$("#OC_FechaRequerida").datepicker({
			format: 'dd/mm/yyyy',
			language: 'es',
			autoclose: true
		});   

		$("#OC_FechaRequeridaCal1").click(function(){
			$('#OC_FechaRequerida').data("datepicker").show();
		})
		
		CargaGridFacturas()

    });
	
	function CargaGridFacturas(){
		var sDatos  = "?Cli_ID=<%=Cli_ID%>" 
		    sDatos += "&CliOC_ID=<%=CliOC_ID%>" 
		    sDatos += "&Usu_ID=" + $("#IDUsuario").val()		
		
		$("#dvCuerpoDatos").load("/pz/wms/OC/CliOC_Factura_Grid.asp" + sDatos);
	}
	
	
	//HA ID: 2 INI variable de Base
	var urlBase = "<%= urlBase %>";
	
</script> 

<script type="text/javascript" src="<%= urlBase %>js/Cli_OrdenCompra.js"></script>

    <div class="row">
        <div class="col-md-8">
			<div class="ibox">
				<div class="ibox-content" style="overflow: auto;">
					<div class="row">
						<div class="col-lg-12">
							<div class="m-b-md">
								<h2 class="pull-right"><%=CliOC_Folio%></h2>
								<h2><%=Cli_RazonSocial%></h2>
							</div>
						</div>
					</div>
							 
					<div class="ibox-title">            
						<div class="btn-group pull-right" style="margin-bottom:15px;" id="BPMBotones"></div>
						<div class="btn-group pull-right" style="margin-bottom:15px;" id="BPMEstatus"></div>
					</div>    
					
					<div class="row">
						<div class="col-lg-5">
							<dl class="dl-horizontal">
								<dt>Estatus:</dt> <dd><span class="label label-primary"><%=ESTATUS%></span></dd>
							</dl>
							<!--Datos de la Orden de compra-->
							<dl class="dl-horizontal">
								<dt>N Orden de Compra:</dt>
								<dd><%=CliOC_NumeroOrdenCompra%></dd>
								<dt>Fecha ingresada:</dt>
								<dd><%=FechaElaboracion%></dd>
								<dt>Fecha Requerida:</dt>
								<dd><%=CliOC_FechaRequerido%>
								</dd>
							</dl>
						</div>
						<!--Datos del Proveedor-->
						<div class="col-lg-7" id="cluster_info">
							<dl class="dl-horizontal">
								<dt>Ultima compra:</dt>
								<dd><%=UltimaCompra%></dd>
								<dt>RFC:</dt>
								<dd><%=Cli_RFC%></dd>
								<dt>P. jur&iacute;dica:</dt>
								<dd><%=PersonalidadJuridica%></dd>
								<dt>Contacto ventas:</dt>
								<dd><%=Cli_ContactoNombre%></dd>
								<dt>tel&eacute;fono:</dt>
								<dd><%=Cli_ContactoTelefono%></dd>
								<dt>e-mail:</dt>
								<dd><%=Cli_ContactoEmail%></dd>
							</dl>   
						</div>
					</div>
					
					<div class="row">
						<div class="col-lg-12">
							<div class="m-b-md">
								<h3 class="col-lg-offset-1">Observaciones</h3>
								<p class="col-lg-offset-2"><%=CliOC_Observaciones%></p>
							</div>
						</div>
					</div>
					
					<div class="row m-t-sm col-lg-12">
							
						<div class="panel blank-panel">
							<div class="panel-body">
								<div class="tab-pane" id="tab-4">

									<div class="ibox row">
										
										<div class="ibox float-e-margins forum-item active" id="dvBtnNuevo">

												<h3><i class="fa fa-tags"></i> Art&iacute;culos</h3>

										</div>
					 
										<div class="ibox-content" id="dvCuerpoDatos">
										
										</div>
										
									</div>
			
								</div>
							</div>
						</div>
					
					</div>
				</div>
			</div>
        </div>
		
        <% //HA ID: 2 Se agrega div de detalle de articulo %>
        <div class="col-md-4" id="divOCArtCar">

		</div>
        
    </div>
 

