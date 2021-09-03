<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%	

	var Prov_ID = Parametro("Prov_ID",-1)
	var OC_ID = Parametro("OC_ID",-1)
	var Usu_ID = Parametro("IDUsuario",0)
  	
	var sSQL = "SELECT Prov_ID, OC_ID, OC_Folio, OC_FolioProveedor, OC_Serie "
             + " , OC_Moneda, Mon_ID, OC_TipoCambio, OC_CondicionPago, OC_UsuIDSolicita "
             + " , OC_Subtotal, OC_IVA, OC_OtrosGastos, OC_Envio, OC_Gestion, OC_Total "
             + " , dbo.fn_CatGral_DameDato(85,OC_CondicionesPagoCG85) as CONDICIONES "
             + " , CONVERT(NVARCHAR(20),OC_FechaElaboracion,103) as FechaElaboracion "
             + " , CONVERT(NVARCHAR(20),OC_FechaRequerida,103) as FechaRequerida "
             + " , dbo.fn_CatGral_DameDato(51,OC_EstatusCG51) as ESTATUS  "
             + " , OC_TipoServicio, OC_EsSolicitud, OC_SinProgramacion, CliCr_ID "
             + " , OC_Observaciones "
   	         + " FROM Proveedor_OrdenCompra "
		     + " WHERE Prov_ID = " + Prov_ID
			 + " AND OC_ID = " + OC_ID
		
	var rsOC = AbreTabla(sSQL,1,0)
	
    if (!rsOC.EOF){
		var OC_Observaciones = rsOC.Fields.Item("OC_Observaciones").Value
		var OC_Folio = rsOC.Fields.Item("OC_Folio").Value
		var FechaElaboracion = rsOC.Fields.Item("FechaElaboracion").Value		
		var FechaRequerida = rsOC.Fields.Item("FechaRequerida").Value	
		var ESTATUS = rsOC.Fields.Item("ESTATUS").Value	
		var OC_FolioProveedor = rsOC.Fields.Item("OC_FolioProveedor").Value	
	}

  	var sSQL = "Select Prov_Nombre, Prov_RazonSocial, Prov_RFC, Prov_ContactoVenta, Prov_EmailVentas "
             + " , Prov_TelefonoVentas, Prov_CondicionCredito "
			 + " , dbo.fn_CatGral_DameDato(56,Prov_PersonalidadJuridicaCG56) as PersonalidadJuridica "
			 + " , ISNULL(CONVERT(NVARCHAR(20),Prov_UltimaCompra ,103),'') as UltimaCompra "
	         + " FROM Proveedor "
	         + " WHERE Prov_ID = " + Prov_ID
   

 	var rsProv= AbreTabla(sSQL,1,0)	
	
	if (!rsProv.EOF){ 
		var Prov_RazonSocial = rsProv.Fields.Item("Prov_RazonSocial").Value
		var Prov_RFC = rsProv.Fields.Item("Prov_RFC").Value		
		var PersonalidadJuridica = rsProv.Fields.Item("PersonalidadJuridica").Value
		var Prov_TelefonoVentas = rsProv.Fields.Item("Prov_TelefonoVentas").Value		
		var Prov_EmailVentas = rsProv.Fields.Item("Prov_EmailVentas").Value
		var Prov_ContactoVenta = rsProv.Fields.Item("Prov_ContactoVenta").Value
        var Prov_CondicionCredito = rsProv.Fields.Item("Prov_CondicionCredito").Value
		var UltimaCompra = rsProv.Fields.Item("UltimaCompra").Value					
	}

	var Parametros = "?OC_ID=" + OC_ID + "&Prov_ID=" + Prov_ID + "&Usu_ID=" + Usu_ID
%>
<link rel="stylesheet" type="text/css" href="/Template/inspina/css/plugins/jasny/jasny-bootstrap.min.css" >
<link rel="stylesheet" type="text/css" href="/Template/inspina/js/plugins/bootstrap-datepicker/css/datepicker.css"/>


    <div class="row">
        <div class="col-md-8">
			<div class="ibox">
				<div class="ibox-content" style="overflow: auto;">
					<div class="row">
						<div class="col-lg-12">
							<div class="m-b-md">
								<h2 class="pull-right"><%=OC_Folio%></h2>
								<h2><%=Prov_RazonSocial%></h2>
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
								<dt>Folio proveedor:</dt>
								<dd><%=OC_FolioProveedor%></dd>
								<dt>Fecha ingresada:</dt>
								<dd><%=FechaElaboracion%></dd>
								<dt>Fecha Requerida:</dt>
								<dd><%=FechaRequerida%>
								</dd>
							</dl>
						</div>
						<!--Datos del Proveedor-->
						<div class="col-lg-7" id="cluster_info">
							<dl class="dl-horizontal">
								<dt>Ultima compra:</dt>
								<dd><%=UltimaCompra%></dd>
								<dt>RFC:</dt>
								<dd><%=Prov_RFC%></dd>
								<dt>P. jur&iacute;dica:</dt>
								<dd><%=PersonalidadJuridica%></dd>
								<dt>Contacto ventas:</dt>
								<dd><%=Prov_ContactoVenta%></dd>
								<dt>tel&eacute;fono:</dt>
								<dd><%=Prov_TelefonoVentas%></dd>
								<dt>e-mail:</dt>
								<dd><%=Prov_EmailVentas%></dd>
							</dl>   
						</div>
					</div>
					
					<div class="row">
						<div class="col-lg-12">
							<div class="m-b-md">
								<h3 class="col-lg-offset-1">Observaciones</h3>
								<p class="col-lg-offset-2"><%=OC_Observaciones%></p>
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

        <div class="col-md-4" id="divOCArtCar">

		</div>
        
    </div>
 
<!-- Jasny -->
<script type="text/javascript" src="/Template/inspina/js/plugins/jasny/jasny-bootstrap.min.js"></script>  
<script type="text/javascript" src="/Template/inspina/js/plugins/bootstrap-datepicker/js/bootstrap-datepicker.js"></script>
<script type="text/javascript" src="/Template/inspina/js/plugins/bootstrap-datepicker/js/locales/bootstrap-datepicker.es.js"></script>
            
<!-- script type="text/javascript" src="/pz/wms/OC/js/Cli_OrdenCompra.js"></script -->
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
		var sDatos  = "?Prov_ID=<%=Prov_ID%>" 
		    sDatos += "&OC_ID=<%=OC_ID%>" 
		    sDatos += "&Usu_ID=" + $("#IDUsuario").val()		
		
		$("#dvCuerpoDatos").load("/pz/wms/OC/Prov_OC_Factura_Grid.asp" + sDatos);
	}
	
	
</script> 
