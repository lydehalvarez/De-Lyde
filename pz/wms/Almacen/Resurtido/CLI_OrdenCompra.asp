<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include virtual="/Includes/iqon.asp" -->
<%
	//HA ID: 1	2020-JUL-17 Detalle de Orden de Venta: Cración de Archivo
	
	var urlBase = "/pz/wms/Almacen/Resurtido/"
	
	var rqIntCli_ID = Parametro("Cli_ID",-1)
	var rqIntCliOC_ID = Parametro("CliOC_ID",-1)
  	
	var strCLIOC_Folio = ""
	var strCLIOC_NumeroOrdenCompra = ""
	var dateCliOC_FechaRequerido = ""
	var strCliOC_Observaciones = ""
	var dateCliOC_FechaRegistro = ""
	var dateCliOC_FechaElaboracion = ""
	var strCLIOC_Estatus = ""
	var strCLIOC_Tipo = ""
	var strCli_Nombre = ""
	var strCli_RazonSocial = ""

	var intTotal_Productos = 0
	var intTotal_Cantidad = 0
	var intTotal_CantidadEntregada = 0
	var intTotal_CantidadFaltante = 0
	
	var sSQL = ";WITH Cliente_OrdenCompra_Articulos_Totales( "
			  + "Cli_ID "
			+ ", CliOC_ID "
			+ ", Total_Productos "
			+ ", Total_Cantidad "
			+ ", Total_CantidadEntregada "
			+ ", Total_CantidadFaltante "
		+ ") "
		+ "AS ( "
			+ "SELECT CliOCP.Cli_ID "
				+ ", CliOCP.CliOC_ID "
				+ ", COUNT(CliOCP.CliOCP_ID) AS Total_Productos "
				+ ", SUM(CliOCP.CliOCP_Cantidad) AS Total_Cantidad "
				+ ", SUM(CliOCP.CliOCP_CantidadEntregada) AS Total_CantidadEntregada "
				+ ", SUM(CliOCP.CliOCP_Cantidad) - SUM(CliOCP.CliOCP_CantidadEntregada) AS Total_CantidadFaltante "
			+ "FROM Cliente_OrdenCompra_Articulos CliOCP "
			+ "GROUP BY CliOCP.Cli_ID "
				+ ", CliOCP.CliOC_ID "
		+ ") "
		+ "SELECT CLIOC.CliOC_Folio "
			+ ", CLIOC.CliOC_NumeroOrdenCompra "
			+ ", CLIOC.CliOC_FechaRequerido "
			+ ", CLIOC.CliOC_Observaciones "
			+ ", CLIOC.CliOC_FechaRegistro "
			+ ", CONVERT(NVARCHAR(20), CLIOC.CliOC_FechaElaboracion, 103) as FechaElaboracion "
			+ ", dbo.fn_CatGral_DameDato(52, CLIOC.CliOC_EstatusCG52) as CLIOC_Estatus "
			+ ", dbo.fn_CatGral_DameDato(87, CLIOC.CliOC_TipoOCCG87) AS CLIOC_Tipo "
			+ ", CLI.Cli_Nombre "
			+ ", CLI.Cli_RazonSocial "
			+ ", CLIOCPT.Total_Productos "
			+ ", CLIOCPT.Total_Cantidad "
			+ ", CLIOCPT.Total_CantidadEntregada "
			+ ", CLIOCPT.Total_CantidadFaltante "
		+ "FROM Cliente_OrdenCompra CLIOC "
			+ "INNER JOIN Cliente CLI "
				+ "ON CLIOC.Cli_ID = CLI.Cli_ID "
			+ "INNER JOIN Cliente_OrdenCompra_Articulos_Totales CLIOCPT "
				+ "ON CLIOC.Cli_ID = CLIOCPT.Cli_ID "
				+ "AND CLIOC.CliOC_ID = CLIOCPT.CliOC_ID "
		+ "WHERE CLIOC.Cli_ID = " + rqIntCli_ID + " "
			+ "AND CLIOC.CliOC_ID = " + rqIntCliOC_ID + " "
		
	var rsOrdCom = AbreTabla(sSQL,1,0)
	
    if (!rsOrdCom.EOF){
		strCLIOC_Folio = rsOrdCom("CliOC_Folio").Value
		strCLIOC_NumeroOrdenCompra = rsOrdCom("CliOC_NumeroOrdenCompra").Value
		dateCliOC_FechaRequerido = rsOrdCom("CliOC_FechaRequerido").Value
		strCliOC_Observaciones = rsOrdCom("CliOC_Observaciones").Value
		dateCliOC_FechaRegistro = rsOrdCom("CliOC_FechaRegistro").Value
		dateCliOC_FechaElaboracion = rsOrdCom("FechaElaboracion").Value
		strCLIOC_Estatus = rsOrdCom("CLIOC_Estatus").Value
		strCLIOC_Tipo = rsOrdCom("CLIOC_Tipo").Value
		strCli_Nombre = rsOrdCom("Cli_Nombre").Value
		strCli_RazonSocial = rsOrdCom("Cli_RazonSocial").Value
		
		intTotal_Productos = rsOrdCom("Total_Productos").Value
		intTotal_Cantidad = rsOrdCom("Total_Cantidad").Value
		intTotal_CantidadEntregada = rsOrdCom("Total_CantidadEntregada").Value
		intTotal_CantidadFaltante = rsOrdCom("Total_CantidadFaltante").Value

	}
	rsOrdCom.Close

%>
<script type="text/javascript">

	$(document).ready(function(e) {
    	OrdenCompraArticulos.Cargar();    
    });
	
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
								<h2 class="pull-right text-right">
									<%= strCLIOC_Folio %>
                                    <br />
                                    <small>
                                        <%= strCLIOC_NumeroOrdenCompra %>
                                    </small>
                                </h2>
								<h2><%= strCli_RazonSocial%></h2>
							</div>
						</div>
					</div>
					
					<div class="col-lg-12 forum-item active border-buttom">
                        <h3><i class="fa fa-truck"></i> Datos Generales</h3>
                    </div>

                    	 
					<div class="row">
						<div class="col-lg-6">
							<dl class="dl-horizontal">
								<dt>Estatus:</dt> <dd><span class="label label-primary"><%= strCLIOC_Estatus %></span></dd>
							</dl>
							<!--Datos de la Orden de compra-->
							<dl class="dl-horizontal">
								<dt>No. Orden de Compra:</dt>
								<dd><%= strCLIOC_NumeroOrdenCompra %></dd>
								<dt>Fecha ingresada:</dt>
								<dd><%= dateCliOC_FechaElaboracion %></dd>
								<dt>Fecha Requerida:</dt>
								<dd><%= dateCliOC_FechaRequerido %></dd>
							</dl>
						</div>
						<div class="col-lg-6">
							<dl class="dl-horizontal">
								<dt>Totales:</dt> 
                                <dd>&nbsp;</dd>
							</dl>
                            
             				<!--Datos de la Orden de compra-->
							<dl class="dl-horizontal">
								<dt>Productos:</dt>
								<dd><%= intTotal_Productos %></dd>
								<dt>Articulos:</dt>
								<dd><%= intTotal_Cantidad %></dd>
								<dt>Entregados:</dt>
								<dd><%= intTotal_CantidadEntregada %></dd>
                                <dt>Faltantes:</dt>
								<dd><%= intTotal_CantidadFaltante %></dd>
							</dl>
						</div>
					</div>
					
					<div class="row">
						<div class="col-lg-12">
							<div class="m-b-md">
								<h3 class="col-lg-offset-1">Observaciones</h3>
								<p class="col-lg-offset-2"><%= strCliOC_Observaciones %></p>
							</div>
						</div>
					</div>
					
					<div class="row m-t-sm col-lg-12">
							
						<div class="panel blank-panel">
							<div class="panel-body">
								<div class="tab-pane" id="tab-4">

									<div class="ibox row">
										
										<div class="ibox float-e-margins forum-item active">
											<h3><i class="fa fa-tags"></i> Art&iacute;culos</h3>
										</div>
					 
										<div class="ibox-content" id="divOCArt">
										
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
 

