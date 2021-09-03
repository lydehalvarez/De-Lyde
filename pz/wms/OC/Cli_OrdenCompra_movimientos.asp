<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%	
//HA ID: 1	2020-JUL-17 Orden de Compra Carga: Creación del Archivo
//HA ID: 2	2020-JUL-21 Adecuación de La Orden de Compra: Se agregan Saldos a cada articulo lik para despliegue de Series.

var cxnIntTipo = 0 
var urlBase = "/pz/wms/OC/"

var rqIntCli_ID = Parametro("Cli_ID",-1)
var rqIntCliOC_ID = Parametro("CliOC_ID",-1)

var strCli_RazonSocial = ""
var strCliOC_Folio = ""

var sqlCliOC = "SELECT CliOC.CliOC_Folio "
		+ ", Cli.Cli_RazonSocial "
	+ "FROM Cliente_OrdenCompra CliOC "
		+ "INNER JOIN Cliente Cli "
			+ "ON CliOC.Cli_Id = Cli.Cli_Id "
	+ "WHERE CliOC.Cli_ID = " + rqIntCli_ID + " "
		+ "AND CliOC.CliOC_ID = " + rqIntCliOC_ID + " "

var rsCliOC = AbreTabla(sqlCliOC, 1, cxnIntTipo)

if( !(rsCliOC.EOF) ){
	strCli_RazonSocial = rsCliOC("Cli_RazonSocial").Value
	strCliOC_Folio = rsCliOC("CliOC_Folio").Value
}

rsCliOC.close

%>
<script type="text/javascript" src="<%= urlBase %>js/Cli_OrdenCompra.js"></script>
<script type="text/javascript">
	urlBase = "<%= urlBase %>"
</script>

    <div class="row">
        <div class="col-md-8">
			<div class="ibox">
				<div class="ibox-content" style="overflow: auto;">
					<div class="row">
						<div class="col-lg-12">
							<div class="m-b-md">
								<h2 class="pull-right"><%= strCliOC_Folio%></h2>
								<h2><%= strCli_RazonSocial%></h2>
							</div>
						</div>
					</div>
					
                    <div class="col-md-12 forum-item active">
                        
                        <div class="col-md-col-md-offset-0 forum-icon">
                            <i class="fa fa-truck fa-flip-horizontal"></i>
                        </div>
                        <a href="#" class="forum-item-title" style="pointer-events: none">
                            <h3>Movimientos de Carga</h3>
                        </a>
                        <div class="forum-sub-title">Movimientos de carga de cada Art&iacute;culo de la Orden de Compra	</div>
                        
                        <!--br-->
                        <div class="hr-line-dashed"></div>
<%

//HA ID: 2 Se eliminan y se agregan columnas
var sqlCliOCP = "SELECT CliOCP.Cli_Id "
		+ ", CliOCP.CliOC_ID "
		+ ", CliOCP.CliOCP_ID "
		+ ", ISNULL(CliOCC.CliOCC_Id, 0) AS CliOCC_Id "
		+ ", Pro.Pro_Nombre "
		+ ", CliOCP.CliOCP_Cantidad "
		+ ", CONVERT(VARCHAR(10), CliOCP.CliOCP_FechaEntrega, 103) AS CliOCP_FechaEntrega "
		+ ", CliOCC.CliOCC_ID "
		+ ", CONVERT(VARCHAR(10), CliOCC.CliOCC_Fecha, 103) AS CliOCC_Fecha "
		+ ", ISNULL(CliOCC.CliOCC_Cantidad, 0) AS CliOCC_Cantidad "
		+ ", SUM(ISNULL(CliOCC.CliOCC_Cantidad, 0)) OVER(PARTITION BY CliOCP.Cli_ID, CliOCP.CliOC_ID, CliOCP.CliOCP_ID) AS CliOCP_TotalRecibidas " 
		+ ", ISNULL(CliOCC.Lot_Id, 0) AS Lot_Id "
		+ ", ISNULL(INL.LOT_Folio, 'S/N') AS LOT_Folio "
	+ "FROM Cliente_OrdenCompra_Articulos CliOCP "
		+ "INNER JOIN Producto Pro "
			+ "ON CliOCP.Pro_Id = Pro.Pro_Id "
		+ "LEFT JOIN Cliente_OrdenCompra_Articulos_Carga CliOCC "
			+ "ON CliOCP.Cli_Id = CliOCC.Cli_Id "
			+ "AND CliOCP.CliOC_Id = CliOCC.CliOC_Id "
			+ "AND CliOCP.CliOCP_Id = CliOCC.CliOCP_Id "
		+ "LEFT JOIN Inventario_Lote INL "
			+ "ON CliOCC.LOT_ID = INL.LOT_Id "
	+ "WHERE CliOCP.Cli_ID = " + rqIntCli_ID + " "
		+ "AND CliOCP.CliOC_ID = " + rqIntCliOC_ID + " "
	+ "ORDER BY CliOCP.CliOCP_ID ASC "
		+ ", CliOCC.CliOCC_Fecha ASC "
		
var rsCliOCP = AbreTabla(sqlCliOCP, 1 , cxnIntTipo)

var strProNombre = ""
var intTotRec = 0
var intTotSal = 0

var bolHayCar = false
var i = 0
%>
                        <div class="form-group table-responsive col-md-12 row">
<%
while ( !(rsCliOCP.EOF) ){
	
	bolHayCar = ( rsCliOCP("CliOCC_Cantidad").Value != 0 )
	
	intTotRec += rsCliOCP("CliOCC_Cantidad").Value
	
	if( strProNombre != rsCliOCP("Pro_Nombre").Value ){
		intTotSal += rsCliOCP("CliOCP_Cantidad").Value 
%>		
                        <!-- Tabla de totales -->
	                        <div class="form-group col-md-12 row">
                                <label class="col-md-12 control-label border-bottom p-xs">
									<i class="fa fa-tag fa-lg"></i> <%= rsCliOCP("Pro_Nombre").Value %>

                                </label>
								<div class="form-group row m-xs">
                                    <span class="col-md-3 control-label">
                                        <i class="fa fa-calendar"></i> Fecha Entrega 
                                        <br />
                                        <label><%= rsCliOCP("CliOCP_FechaEntrega").Value %></label>
                                    </span>
                                    <span class="col-md-3 control-label">
                                        <i class="fa fa-long-arrow-down text-bold" style="color: red !important;"></i> Cant. Solicitada: 
                                        <br />
                                        <label style="color: red !important;"><%= formato(rsCliOCP("CliOCP_Cantidad").Value, 0) %></label>
                                    </span>
                                    <span class="col-md-3 control-label">
                                        <i class="fa fa-long-arrow-up text-bold" style="color: #1ab394 !important;"></i> Cant. Recibida: 
                                        <br />
                                        <label style="color: #1ab394 !important;"><%= formato(rsCliOCP("CliOCP_TotalRecibidas").Value, 0) %></label>
                                    </span>
                                    <span class="col-md-3 control-label">
                                        <i class="fa fa-dropbox text-bold"></i> Cant. por Entregar: 
                                        <br />
                                        <label><%= formato( rsCliOCP("CliOCP_Cantidad").Value - rsCliOCP("CliOCP_TotalRecibidas").Value, 0) %></label>
                                    </span>
                                </div>
                            </div>

                       		<div class="form-group table-responsive col-md-12 row">
                            	<table class="table table-hover table-striped">
                             	 	<tbody>
                                        <tr>
                                            <th>#</th>
                                            <th>Lote</th>
                                            <th>Fecha</th>
                                            <th>Solicitado</th>
                                            <th>Entregado</th>
                                            <th>Por Entregar</th>
                                            <th>&nbsp;</th>
                                        </tr>
                                        <tr>
                                            <td><%= ++i %></td>
                                            <td>Cantidad Solicitada</td>
                                            <td>&nbsp;</td>
                                            <td class="text-center">
                                                <i class="fa fa-long-arrow-down text-bold" style="color: red !important;"></i> <%= formato(rsCliOCP("CliOCP_Cantidad").Value, 0) %>
                                            </td>
                                             <td>&nbsp;</td>
                                            <td class="text-right font-bold">
                                                <%= formato(intTotSal, 0) %>
                                            </td>
                                            <td>
                                            	
                                            </td>
                                        </tr>
<%                        
	}
	
	
		intTotSal -= rsCliOCP("CliOCC_Cantidad").Value
		
		if( bolHayCar ){
%>
                                         <tr>
                                            <td><%= ++i %></td>
                                            <td class="text-left font-bold">
                                            	<a href="#" onclick="Serie.Ver(<%= rsCliOCP("LOT_Id").Value %>)">
	                                                <i class="fa fa-files-o"></i> <%= rsCliOCP("LOT_Folio").Value %>
                                                </a>
                                            </td>
                                            <td class="text-center">
                                                <i class="fa fa-calendar"></i> <%= rsCliOCP("CliOCC_Fecha").Value %>
                                            </td>
                                            <td>&nbsp;</td>
                                            <td class="text-right">
                                                <i class="fa fa-long-arrow-up text-bold" style="color: #1ab394 !important;"></i> <%= formato(rsCliOCP("CliOCC_Cantidad").Value, 0) %>
                                            </td>
                                            <td class="text-right font-bold">
                                                <%= formato(intTotSal, 0) %>
                                            </td>
                                            <td>
                                            	<a href="#" data-toggle="modal" data-target="#CargaLogModal"
                                                 onclick="Log.Visualizar(<%= rsCliOCP("Cli_Id").Value %>, <%= rsCliOCP("CliOC_ID").Value %>,<%= rsCliOCP("CliOCP_ID").Value %>, <%= rsCliOCP("CliOCC_Id").Value %>)">
                                                	<i class="fa fa-file-text-o fa-lg"></i>
                                                </a>
                                            </td>
                                        </tr>
<%
		}
	strProNombre = rsCliOCP("Pro_Nombre").Value
	rsCliOCP.MoveNext
	
	if( rsCliOCP.EOF || ( !(rsCliOCP.EOF) && strProNombre != rsCliOCP("Pro_Nombre").Value ) ){
		
%>
                                    </tbody>
                                </table>
                             </div>
                            					
<%		
		intTotRec = 0
		intTotSal = 0
		i = 0
	}
}
%>                       
						</div> 
                    </div>
				</div>
			</div>
        </div>
        
         <% //HA ID: 2 Se agrega div de detalle de articulo %>
        <div class="col-md-4" id="divOCNumSer">

		</div>
	</div>
    
    <div class="modal fade" id="CargaLogModal" tabindex="-1" role="dialog" aria-labelledby="CargaLogModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="CargaLogModalLabel">Log de Carga del Art&iacute;culo</h5>
	                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
    	                <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body" id="divCargaLog">
                	
                    
                    
                    
                    
     
                    
                    
	            </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">
                    	<i class="fa fa-times"></i> Cerrar
                    </button>
                </div>
            </div>
        </div>
    </div>
 

