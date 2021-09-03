<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include virtual="/Includes/iqon.asp" -->
<%
//Response.Charset="utf-8"
//Response.ContentType="text/html; charset=utf-8"

// HA ID: 1 2020-jun-30 Creación de Archivo: Ajax de Ordenes de Compra

var cxnIntTipo = 0

var rqIntTarea = Parametro("Tarea", -1)

switch( parseInt(rqIntTarea) ){
	// Detalle de las cargas de Orden de Compra
	case 1: {
		
		var rqIntCli_ID = Parametro("Cli_ID", -1)
		var rqIntCliOC_ID = Parametro("CliOC_ID", -1)
		
		var sqlCliOCP = ";WITH Cliente_ORdenCompra_Articulos_Carga_Total( "
				  + "Cli_ID "
				+ ", CliOC_ID "
				+ ", CliOCP_ID "
				+ ", Total_Cargas "
				+ ", Total_Entregado "
			+ ") "
			+ "AS ( "
				+ "SELECT CLIOCC.Cli_ID "
					+ ", CLIOCC.CliOC_ID "
					+ ", CLIOCC.CliOCP_ID "
					+ ", COUNT(*) AS Total_Cargas "
					+ ", SUM(CLIOCC.CLIOCC_Cantidad) AS Total_Entregador "
				+ "FROM Cliente_OrdenCompra_Articulos_Carga CLIOCC "
				+ "GROUP BY CLIOCC.Cli_ID "
					+ ", CLIOCC.CliOC_ID "
					+ ", CLIOCC.CliOCP_ID "
			+ ") "
			+ "SELECT CLIOCP.Cli_ID "
				+ ", CLIOCP.CliOC_ID "
				+ ", CLIOCP.CliOCP_ID "
				+ ", CLIOCP.CliOCP_Cantidad "
				+ ", PRO.PRO_ID "
				+ ", PRO.PRO_SKU "
				+ ", PRO.PRO_Nombre "
				+ ", PRO.PRO_Descripcion "
				+ ", ISNULL(CLIOCCT.Total_Cargas, 0) AS Total_Cargas "
				+ ", ISNULL(CLIOCCT.Total_Entregado, 0) AS Total_Entregado "
				+ ", CLIOCP.CliOCP_Cantidad - ISNULL(CLIOCCT.Total_Entregado, 0) AS Total_Faltante "
			+ "FROM Cliente_OrdenCompra_Articulos CLIOCP "
				+ "INNER JOIN Producto PRO "
					+ "ON CLIOCP.PRO_ID = PRO.PRO_ID "
				+ "LEFT JOIN Cliente_ORdenCompra_Articulos_Carga_Total CLIOCCT "
					+ "ON CLIOCP.Cli_ID = CLIOCCT.Cli_ID "
					+ "AND CLIOCP.CliOC_ID = CLIOCCT.CliOC_ID "
					+ "AND CLIOCP.CliOCP_ID = CLIOCCT.CliOCP_ID "
			+ "WHERE CLIOCP.Cli_ID	= " + rqIntCli_ID + " "
				+ "AND CLIOCP.CliOC_ID = " + rqIntCliOC_ID + " "
				
		var rsCliOCP = AbreTabla(sqlCliOCP, 1, cxnIntTipo)
%>
	<div class="table-responsive">
        <table class="table table-hover table-striped">
            <thead>
                <tr>
                    <th class="col-md-1">#</th>
                    <th class="col-md-2">SKU</th>
                    <th class="col-md-4">Producto</th>
                    <th class="col-md-1">Solicitado</th>
                    <th class="col-md-1">Entregado</th>
                    <th class="col-md-1">Pendiente</th>
                    <th class="col-md-1">Cargas</th>
                    <th class="col-md-1">&nbsp;</th>
                </tr>
            </thead>
            <tbody>
<%		
		var i = 0
		while( !(rsCliOCP.EOF) ){
%>
				<tr>
                	<td>
                    	<%= ++i %>
                        <input type="hidden" id="CliOCP_ID_<%= rsCliOCP("CliOCP_ID").Value %>" 
                            value="<%= rsCliOCP("CliOCP_ID").Value %>" 
                            data-nombre="<%= rsCliOCP("PRO_Nombre").Value %>" 
                            data-proid="<%= rsCliOCP("PRO_ID").Value %>"
                            data-pendiente="<%= rsCliOCP("Total_Faltante").Value %>"
                        />
                    </td>
                    <td>
                    	<%= rsCliOCP("PRO_SKU").Value %>
                    </td>
                    <td class="issue-info">
                    	<a href="#" onclick="OrdenCompraArticulos.VerCargas(<%= rsCliOCP("Cli_ID").Value %>, <%= rsCliOCP("CliOC_ID").Value %>, <%= rsCliOCP("CliOCP_ID").Value %>)">
                       		<i class="fa fa-tag text-success"></i> <%= rsCliOCP("PRO_Nombre").Value %>
                        </a>
                        <small><%= rsCliOCP("PRO_Descripcion").Value %></small>
                    </td>
                    <td>
                    	<i class="fa fa-long-arrow-down text-danger"></i> <%= rsCliOCP("CliOCP_Cantidad").Value %>
                    </td>
                    <td>
                    	<i class="fa fa-long-arrow-up text-success"></i> <%= rsCliOCP("Total_Entregado").Value %>
                    </td>
                    <td>
                    	<i class="fa fa-sticky-note text-warning"></i> <%= rsCliOCP("Total_Faltante").Value %>
                    </td>
                    <td>
                    	<i class="fa fa-dropbox text-info"></i> <%= rsCliOCP("Total_Cargas").Value %>
                    </td>
                    <td>
<%		
			if( parseInt(rsCliOCP("Total_Faltante").Value) > 0 ){
%>                    
                    	<a href="#" class="btn btn-primary btn-xs" onclick="OrdenVentaArticuloCarga.VisualizarModalNuevo(<%= rsCliOCP("CliOCP_ID").Value %>)" title="Nueva Carga">
                        	<i class="fa fa-plus"></i>
                        </a>
<%
			}
%>                        
                    </td>
                </tr>				
<%			
			rsCliOCP.MoveNext
		}
%>
			</tbody>
		</table>
	</div>
<%	
		rsCliOCP.Close
				
	} break;
	
	case 100:{
%>
	<div class="modal fade" id="ModalAgregarCarga" tabindex="-1" role="dialog" aria-labelledby="divModalAgregarCarga" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close btn-seg pull-right" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
                    <h2 class="modal-title" id="divModalAgregarCarga">
                    	<i class="fa fa-dropbox"></i> <span class="text-primary text-bold" id="spanModalAgregarCarga"> </span> 
                        <br />
                        <small>Seleccionar la cantidad disponible de los lotes para cargarlos</small>
						<input type="hidden" id="inpModalCliOCP_ID" value="" data-proid="" />
                    </h2>
					
				</div>
				<div class="modal-body">
					<div class="row">
						<div class="form-group col-md-12 row">
                            <span class="col-md-4 control-label">
                                <i class="fa fa-sticky-note text-danger"></i> Cant. Pendiente 
                                <br />
                                <label class="text-danger h3 text-bold" id="inpModalCliOCP_Pendiente">
									
                                </label>
                            </span>
                            <span class="col-md-4 control-label">
                                <i class="fa fa-dropbox text-success"></i> Cant. por Cargar 
                                <br />
                                <label class="text-success h3 text-bold" id="inpModalCliOCP_PorCargar">
									
                                </label>
                            </span>
                            <span class="col-md-4 control-label">
                                <i class="fa fa-sticky-note text-warning"></i> Cant. Rest. por Cargar 
                                <br />
                                <label class="text-warning h3 text-bold" id="inpModalCliOCP_RestantePorCargar">
									
                                </label>
                            </span>

						</div>
						
						<div class="form-group col-md-12 row" style="overflow: auto; height: 350px;" id="tableModalLotes">
							
						</div>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary btn-seg" data-dismiss="modal" onclick="OrdenVentaArticuloCarga.CerrarModalNuevo();">
						<i class="fa fa-times"></i> Cerrar
					</button>
                    <button type="button" class="btn btn-primary btn-seg" data-dismiss="modal" onclick="OrdenVentaArticuloCarga.Guardar();">
						<i class="fa fa-floppy-o"></i> Guardar
					</button>
				</div>
			</div>
		</div>
	</div>
<%		
	} break;
	
	case 300: {
		
		var rqIntPro_ID = Parametro("Pro_ID", -1)
		
		sqlProInv = "SELECT LOT.LOT_ID "
				+ ", LOT.LOT_Folio "
				+ ", ( "
					+ "SELECT COUNT(*) " 
					+ "FROM Inventario INV " 
					+ "WHERE INV.Inv_LoteActual = LOT.LOT_ID "
				+ ") AS LOT_CantidadDisponible "
			+ "FROM Inventario_lote LOT "
			+ "WHERE LOT_ID IN ( "
					+ "SELECT DISTINCT Inv_LoteActual "
					+ "FROM Inventario "
					+ "WHERE Cli_ID = 1 /* Lyde */ "
						+ "AND Inv_Cli_ID_Propietario = 1 /* Lyde */ "
						+ "AND ALM_ID = 2 /* Almacen Lyde */ "
						+ "AND Inv_EstatusCG20 = 1 /* Disponible */ "
						+ "AND PRO_ID = " + rqIntPro_ID + " "
				+") "
		
		var rsProInv = AbreTabla(sqlProInv, 1, cxnIntTipo)
%>
			<table class="table table-bordered table-hover issue-tracker">
                <thead>
                    <tr>
                    	<th class="col-md-1">&nbsp;</th>
                        <th class="col-md-1">#</th>
                        <th class="col-md-6">Lote</th>
                        <th class="col-md-2">Cant. Existente</th>
                        <th class="col-md-2">&nbsp;</th>
                    </tr>
                </thead>
                <tbody>	
<%		
		var i = 0
		while( !(rsProInv.EOF) ){
%>
					<tr class="trLoteLote">
                    	<td>
                        	<input type="hidden" class="hidLoteId" data-disponible="<%= rsProInv("LOT_CantidadDisponible").Value %>" value="<%= rsProInv("LOT_ID").Value %>" />
                        	<input type="checkbox" class="chbLoteSeleccion" onclick="OrdenVentaArticuloCarga.CalcularTotalCargaLote(this);" />
						</td>
                    	<td><%= ++i %></td>
                        <td>
                        	<i class="fa fa-exclamation-circle fa-lg text-danger iLoteAlerta" style="display:none;"></i>
							<%= rsProInv("LOT_Folio").Value %>
                        </td>
                        <td><%= rsProInv("LOT_CantidadDisponible").Value %></td>
                        <td>
                        	<input type="text" class="form-control inpLoteCantidad" value="" 
                             onKeyUp="OrdenVentaArticuloCarga.CalcularTotalCargaLote($(this));" />
                        </td>
                    </tr>
<%			
			rsProInv.MoveNext
		}
%>
				</tbody>
			</table>
<%
		rsProInv.Close
		
	} break;
}
%>