<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%
Response.Charset="utf-8"
Response.ContentType="text/html; charset=utf-8"

// HA ID: 1 2020-jun-30 Creación de Archivo: Ajax de Ordenes de Compra
// HA ID: 2 2020-jul-21 Agregados de Orden de Compra: Se agrega Opcion de Carga de Series de Articulos Cargados
// HA ID: 3 2020-jul-21 LOG Intentos de Carga Orden de Compra: Se agrega los intentos de Orden de Compra de Carga

var cxnIntTipo = 0

var rqIntTarea = Parametro("Tarea", -1)

switch( parseInt(rqIntTarea) ){
	// Detalle de las cargas de Orden de Compra
	case 1: {
		
		var rqIntCli_ID = Parametro("Cli_Id", -1)
		var rqIntCliOC_ID = Parametro("CliOC_Id", -1)
		var rqIntCliOCP_ID = Parametro("CliOCP_Id", -1)
		
		var sqlCliOCP = "SELECT CliOCAC.CliOCC_ID "
				+ ", CONVERT(VARCHAR(10), CliOCAC.CliOCC_Fecha, 103) AS CliOCC_Fecha "
				+ ", CliOCAC.CliOCC_Cantidad "
				+ ", INL.Lot_Folio "
			+ "FROM Cliente_OrdenCompra_Articulos_Carga CliOCAC "
				+ "INNER JOIN Inventario_Lote INL "
					+ "ON CliOCAC.Lot_ID = INL.Lot_Id "
			+ "WHERE CliOCAC.Cli_ID = " + rqIntCli_ID + " "
				+ "AND CliOCAC.CliOC_ID = " + rqIntCliOC_ID + " "
				+ "AND CliOCAC.CliOCP_ID = " + rqIntCliOCP_ID + " "
%>
    <div class="ibox">
        <div class="ibox-content" style="overflow: auto;">
<%
		var rsCliOCP = AbreTabla(sqlCliOCP, 1, cxnIntTipo)
%>
			<div class="col-form-label form-group col-md-12 forum-item active">
                <i class="fa fa-dropbox fa-lg text-success"></i> <label><%= "Cargas" %></label>
            </div>
			<div class="table-responsive col-md-12">
                <table class="table table-hover table-striped">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Lote</th>
                            <th>Fecha</th>
                            <th>Cantidad</th>
                        </tr>
                    </thead>
                    <tbody>
<%		
		if( !(rsCliOCP.EOF) ){
			
			var i = 0
			
			while( !(rsCliOCP.EOF) ){
%>
                       	<tr>
                            <td class="text-center"><%= ++i %></td>
                            <td class="text-left">
								<i class="fa fa-dropbox"></i> <%= rsCliOCP("Lot_Folio").Value %>
                            </td>
                            <td class="text-left">
								<i class="fa fa-calendar"></i> <%= rsCliOCP("CliOCC_Fecha").Value %>
                            </td>
                            <td class="text-center">
								<%= rsCliOCP("CliOCC_Cantidad").Value %>
                            </td>
                        </tr>
<%			
				rsCliOCP.MoveNext
			}
		
		} else {
%>
                        <tr>
                            <td colspan="3">
                            	<i class="fa fa-exclamation-circle fa-lg"></i> No hay Cargas
                            </td>
                        </tr>
<%			
		}
		
		rsCliOCP.Close
%>       
	    			</tbody>
				</table>
			</div>
        </div>
    </div>

<%		
	} break;

	// HA ID: 2 INI Se agrega Opcion de
	case 2: {
		
		var rqIntLot_Id = Parametro("Lot_Id", -1)
		
		// HA ID: 3 Se realiza cambio de Buqueda de Números de Series
		var  sqlInvLot = "SELECT Inv_Serie "
			+ "FROM Inventario INV "
				+ "INNER JOIN Inventario_Lote_Articulos ILA "
					+ "ON INV.INV_ID = ILA.INV_Id "
			+ "WHERE ILA.Lot_Id = " + rqIntLot_Id + " "
%>

	<div class="ibox">
        <div class="ibox-content" style="overflow: auto;">
<%
		var rsInvLot = AbreTabla(sqlInvLot, 1, cxnIntTipo)
%>
			<div class="col-form-label form-group col-md-12 forum-item active">
                <i class="fa fa-dropbox fa-lg text-success"></i> <label><%= "Números de Serie" %></label>
            </div>
			<div class="table-responsive col-md-12">
                <table class="table table-hover table-striped">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>N. Serie</th>
                        </tr>
                    </thead>
                    <tbody>
<%		
		if( !(rsInvLot.EOF) ){
			
			var i = 0
			
			while( !(rsInvLot.EOF) ){
%>
                       	<tr>
                            <td class="text-center"><%= ++i %></td>
                            <td class="text-left">
								<i class="fa fa-barcode"></i> <%= rsInvLot("Inv_Serie").Value %>
                            </td>
                        </tr>
<%			
				rsInvLot.MoveNext
			}
			
		} else {

%>
                        <tr>
                            <td colspan="2">
                            	<i class="fa fa-exclamation-circle fa-lg"></i> No hay Número de Series
                            </td>
                        </tr>
<%
		}
		
		rsInvLot.Close
%>
					</tbody>
                </table>
            </div>
		</div>
	</div>			
<%		
	} break;
	// HA ID: 2 FIN 
	// HA ID: 3 INI Intentos de Carga de Articulo de Ordenes de Compra	
	case 3:{
		
		var rqIntCli_Id = Parametro("Cli_Id", -1)
		var rqIntCliOC_Id = Parametro("CliOC_Id", -1)
		var rqIntCliOCP_Id = Parametro("CliOCP_Id", -1)
		var rqIntCliCC_Id = Parametro("CliCC_Id", -1)
		
		var sqlCLog = "SELECT CliOCL_Id "
				+ ", CONVERT(VARCHAR(10), CliOCL_FechaEnvio, 103) AS CliOCL_FechaEnvio "
				+ ", CliOCL_Recibidos "
				+ ", CliOCL_Rechazados "
				+ ", CliOCL_JSonEnvio "
				+ ", CliOCL_JSonRespuesta "
				+ ", CliOCL_FechaRegistro "
			+ "FROM Cliente_OrdenCompra_Articulos_Carga_Log "
			+ "WHERE Cli_ID = " + rqIntCli_Id + " "
				+ "AND CliOC_ID = " + rqIntCliOC_Id + " "
				+ "AND CliOCP_ID = " + rqIntCliOCP_Id + " "
				+ "AND CliOCC_ID = " + rqIntCliCC_Id + " "
				
		var rsCLog = AbreTabla(sqlCLog, 1, cxnIntTipo)
		var i = 0
		
		if ( !(rsCLog.EOF) ){
%>
		<div class="panel-body">
        	<div class="panel-group" id="accordion">
<%
			while( !(rsCLog.EOF) ){
				i++
%>
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <h5 class="panel-title">
                            <a class="form-group row" data-toggle="collapse" data-parent="#accordion" href="#collapse<%= i %>">
                            	<label class="col-form-label col-md-4">
									<i class="fa fa-calendar"></i> <%= rsCLog("CliOCL_FechaEnvio").Value %>
                                </label>
                                <label class="col-form-label col-md-4 text-success">
                                	<i class="fa fa-check"></i> Recibidos: <%= rsCLog("CliOCL_Recibidos").Value %>
                                </label>
                                <label class="col-form-label col-md-4 text-danger">
                                	<i class="fa fa-times"></i> Rechazados: <%= rsCLog("CliOCL_Rechazados").Value %>
                                </label>
                            </a>
                        </h5>
                    </div>
                    <div id="collapse<%= i %>" class="panel-collapse collapse">
                        <div class="panel-body">
                        	
                            <div class="panel panel-primary">
                                <div class="panel-heading">
                                    <i class="fa fa-reply"></i> JSON Recibido 
                                </div>
                                <div class="panel-body" style="font-family:'Courier New', Courier, monospace; font-size:10px; overflow-y: auto; max-height:300px;" >
                                    <%= (rsCLog("CliOCL_JSonRespuesta").Value).replace(/\n/gi,"<br>") %>
                                </div>
                            </div>
                            
                             <div class="panel panel-success">
                                <div class="panel-heading">
                                    <i class="fa fa-share"></i> JSON Enviado 
                                </div>
                                <div class="panel-body" style="font-family:'Courier New', Courier, monospace; font-size:10px; overflow-y: auto; max-height:300px;" >
                                    <%= (rsCLog("CliOCL_JSonEnvio").Value).replace(/\n/gi,"<br>") %>
                                </div>
                            </div>
                            
                        </div>
                    </div>
                </div>
<%				
				rsCLog.MoveNext	
			} 
%>			
			</div>
		</div>
<%
		//} else {
		}
		
		rsCLog.close
		
	} break;
	// HA ID: 3 FIN
}
   
%>
