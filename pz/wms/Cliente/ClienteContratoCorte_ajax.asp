<%@LANGUAGE="JAVASCRIPT" CODEPAGE="65001"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%

// HA ID: 1 2020-JUl-30 Creación de Archivo: Ajax de Cliente Contrato Corte

var cxnIntTipo = 0
var rqIntTarea = Parametro("Tarea", -1)

switch( parseInt(rqIntTarea) ){
	// Cargar Corte Combo
	case 1: {
		
		var rqIntCli_ID = Parametro("Cli_ID", -1)
		
		//Ejecuta("", cxnIntTipo)
		
		var sqlCliCr = "SELECT CLICR.CliCr_ID "
				+ ", CONVERT(NVARCHAR(30), YEAR(CLICR.CliCr_FechaCorte)) + ' - ' + CONVERT(NVARCHAR(30), DATENAME(month, CLICR.CliCr_FechaCorte)) AS CliCr_CorteDescripcion "
			+ "FROM Cliente_Contrato_Corte CLICR "
			+ "WHERE Cli_ID = " + rqIntCli_ID + " "
			+ "ORDER BY CLICR.CliCr_FechaCorte DESC; "
			+ "SET LANGUAGE 'Spanish';"
			
		var rsCliCr = AbreTabla(sqlCliCr, 1, cxnIntTipo)
%>
		<option value="-1">
        	<%= "SIN CORTE" %>
        </option>
<%		
		while( !(rsCliCr.EOF) ){
%>
		<option value="<%= rsCliCr("CliCr_ID").Value %>">
        	<%= rsCliCr("CliCr_CorteDescripcion").Value %>
        </option>
<%
			rsCliCr.MoveNext
		}
		rsCliCr.Close
		
	} break;
	
	//Cargar Despliegue de Cortes
	case 1000: {
		
		Response.Charset="utf-8"
		Response.ContentType="text/html; charset=utf-8"
		
		var rqIntCli_ID = Parametro("Cli_ID", -1)
		var rqIntCliCto_ID = Parametro("CliCto_ID", -1)
		var rqIntCliCr_ID = Parametro("CliCr_ID", -1)
		
		var sqlEdoCta =  "SELECT * " 
			+ "FROM dbo.FNC_Cliente_EstadoCuenta(" + rqIntCli_ID + ", " + rqIntCliCto_ID + ", " + rqIntCliCr_ID + ") "
			+ "ORDER BY CliCto_Folio ASC "
				+ ", SerP_Nombre ASC " 
				+ ", Ser_Nombre ASC "
			
		var rsEdoCta = AbreTabla(sqlEdoCta, 1, cxnIntTipo)
		
		var i = 0
		var bolIni = true	
%>
				<table class="table table-striped table-bordered table-hover table-full-width dataTable">
                	<thead>
                    	<tr>
                            <th class="col-md-1">#</th>
                            <th class="col-md-7">Servicio</th>
                            <th class="col-md-2">Cantidad Base</th>
                            <th class="col-md-2">Cantidad Extra</th>
                        </tr>
                    </thead>
                    <tbody>
<%		
		var strSerP_Nombre = ""
		var strCliCto_Folio = ""
		
		var CliCto_ID = 0
		var SerP_ID = 0
		
		var dblTotCliCtoBase = 0
		var dblTotCliCtoExtras = 0
		
		var dblTotSerPBase = 0
		var dblTotSerPExtras = 0
		
		var i = 0

		while( !(rsEdoCta.EOF) ){
			
			CliCto_ID = rsEdoCta("CliCto_ID").Value
			SerP_ID = rsEdoCta("SerP_ID").Value
			
			if( strCliCto_Folio != rsEdoCta("CliCto_Folio").Value || strSerP_Nombre != rsEdoCta("SerP_Nombre").Value ) {
				
				if( strCliCto_Folio != rsEdoCta("CliCto_Folio").Value ){
				
					dblTotCliCtoBase = 0
					dblTotCliCtoExtras = 0
%>
						<tr>
                        	<td colspan="4">
								<strong> 
                                	<i class="fa fa-file-text"></i> <%= rsEdoCta("CliCto_Folio").Value %> 
                                </strong>
                            </td>
                        </tr>
<%				
				}
				
				if( strSerP_Nombre != rsEdoCta("SerP_Nombre").Value ){
					i = 0
					dblTotSerPBase = 0
					dblTotSerPExtras = 0
%>
						<tr class="CliCto<%= CliCto_ID %>">
                        	<td>&nbsp;</td>
                        	<td colspan="3">
                              	<strong><i class="fa fa-tags"></i> <%= rsEdoCta("SerP_Nombre").Value %></strong>
                            </td>
                        </tr>
<%			
				}
			}
			
%>
                    	<tr class="CliCto<%= CliCto_ID %> SerP<%= SerP_ID %>" >
                        	<td class="text-center"><%= ++i %></td>
                            <td class="issue-info">
                            	<a href="#" onclick="ClienteContratoCorte.CargarEstadoCuentaDocumentosTotal( <%= rsEdoCta("SerP_ID").Value %>, <%= rsEdoCta("Ser_ID").Value %>)">
									<i class="fa fa-tag"></i> <%= rsEdoCta("Ser_Nombre").Value %>	
                                </a>
                            </td>
                            <td class="text-center"><%= formato(rsEdoCta("Total_Producto_Base").Value, 0) %></td>
                            <td class="text-center"><%= formato(rsEdoCta("Total_Producto_Extras").Value, 0) %></td>
                        </tr>
<%			
			strSerP_Nombre = rsEdoCta("SerP_Nombre").Value
			strCliCto_Folio = rsEdoCta("CliCto_Folio").Value
			
			dblTotSerPBase += parseInt(rsEdoCta("Total_Producto_Base").Value)
			dblTotSerPExtras += parseInt(rsEdoCta("Total_Producto_Extras").Value)
			
			dblTotCliCtoBase += parseInt(rsEdoCta("Total_Producto_Base").Value)
			dblTotCliCtoExtras += parseInt(rsEdoCta("Total_Producto_Extras").Value)
			
			rsEdoCta.MoveNext
			
			if( rsEdoCta.EOF || ( !(rsEdoCta.EOF) && ( strCliCto_Folio != rsEdoCta("CliCto_Folio").Value || strSerP_Nombre != rsEdoCta("SerP_Nombre").Value ) ) ){
				
				if( rsEdoCta.EOF || ( !(rsEdoCta.EOF) && ( strSerP_Nombre != rsEdoCta("SerP_Nombre").Value ) ) ){
%>
						<tr class="CliCto<%= CliCto_ID %>">
                        	<td colspan="2" class="text-right">
								<strong>Total Paquete</strong>
                            </td>
                            <td class="text-center">
								<strong><%= formato(dblTotSerPBase, 0) %></strong>
                            </td>
                            <td class="text-center">
								<strong><%= formato(dblTotSerPExtras, 0) %></strong>
                            </td>
                        </tr>
<%			
				}
				
				if( rsEdoCta.EOF || ( !(rsEdoCta.EOF) && ( strCliCto_Folio != rsEdoCta("CliCto_Folio").Value ) ) ){
%>
						<tr>
                        	<td colspan="2" class="text-right">
								<strong>Total Contrato</strong>
                            </td>
                            <td class="text-center">
								<strong><%= formato(dblTotCliCtoBase, 0) %></strong>
                            </td>
                            <td class="text-center">
								<strong><%= formato(dblTotCliCtoExtras, 0) %></strong>
                            </td>
                        </tr>
<%
				}
			}
		}
%>
					</tbody>
                </table>
<%		
		rsEdoCta.Close
		
	} break;
	
	case 1100: {
		
		Response.Charset="utf-8"
		Response.ContentType="text/html; charset=utf-8"
		
		var rqIntSerP_ID = Parametro("SerP_ID", -1)
		var rqIntSer_ID = Parametro("Ser_ID", -1)
		var rqIntCli_ID = Parametro("Cli_ID", -1)
		var rqIntCliCr_ID = Parametro("CliCr_ID", -1)
		
		var sqlEdoCtaSer = "SELECT CASE SER.TDOC_ID "
					+ "WHEN 2 "
						+ "THEN 'Orden Venta' "
					+ "WHEN 1 "
						+ "THEN 'Transferencias' "
					+ "ELSE '' "
				+ "END AS Ser_Documento "
				+ ", COUNT(SER.TDOC_ID) AS Total_Documento "
				+ ", SUM(SER.Total_Cantidad) AS Total_Cantidad "
			+ "FROM dbo.FNC_Cliente_EstadoCuenta_Servicios(" + rqIntSerP_ID + ", " + rqIntSer_ID + ", " + rqIntCli_ID + ", " + rqIntCliCr_ID + ") SER "
			+ "GROUP BY SER.TDOC_ID "
		
		var rsEdoCtaSer = AbreTabla(sqlEdoCtaSer, 1, cxnIntTipo)
%>
		<div class="ibox ">
            <div class="forum-item active ibox-content" style="overflow: auto;">
                <div class="col-form-label form-group col-md-8">
                    <i class="fa fa-files-o text-success"></i> <label>Documentos</label>
                </div>
                <div style="cursor: pointer !important;" class="col-form-label form-group col-md-4 link btn btn-info" onclick="ClienteContratoCorte.ExportarEstadoCuentaDocumentos(<%= rqIntSerP_ID %>, <%= rqIntSer_ID %>)">
                    <i class="fa fa-file-excel-o" style="color:white;"></i> Exportar
                </div>

                <table class="table table-striped col-md-12">
                    <thead>
                        <tr>
                            <th class="col-sm-1">#</th>
                            <th class="col-sm-5"><i class="fa fa-file-text-o"></i> Doc.</th>
                            <th class="col-sm-3">Tot. Doc.</th>
                            <th class="col-sm-3">Cant. Tot.</th>
                        </tr>
                    </thead>
                    <tbody>

<%
		var i = 0
		if( !(rsEdoCtaSer.EOF) ){
		
			while( !(rsEdoCtaSer.EOF) ){
%>
                        <tr>
                            <td><%= ++i %></td>
                            <td>
                                
                                <span><%= rsEdoCtaSer("Ser_Documento") %></span>
                            </td>
                            <td class="text-center"><%= formato(rsEdoCtaSer("Total_Documento"), 0) %></td>
                            <td class="text-center"><%= formato(rsEdoCtaSer("Total_Cantidad"), 0) %></td>
                        </tr>
                

<%			
				rsEdoCtaSer.MoveNext
			}
		} else {
%>
						<tr>
                        	<td colspan="4">
                            	<i class="fa fa-exlamation-circle"></i> No hay Documentos
                            </td>
                        </tr>
<%			
		}

%>
            		</tbody>
       			</table>
			</div>
        </div>		
<%
		rsEdoCtaSer.Close
		
	} break;
	
	case 11000: {
		
		Response.Charset="utf-8"
		Response.ContentType="text/html; charset=utf-8"
		
		var rqIntSerP_ID = Parametro("SerP_ID", -1)
		var rqIntSer_ID = Parametro("Ser_ID", -1)
		var rqIntCli_ID = Parametro("Cli_ID", -1)
		var rqIntCliCr_ID = Parametro("CliCr_ID", -1)
		
		var sqlEdoCtaSer = "SELECT CASE SER.TDOC_ID "
				+ "WHEN 2 "
					+ "THEN 'Orden Venta' "
				+ "WHEN 1 "
					+ "THEN 'Transferencias' "
				+ "ELSE '' "
			+ "END AS Documento "
			+ ", CASE SER.TDOC_ID "
				+ "WHEN 2 "
					+ "THEN OV.OV_Folio "
				+ "WHEN 1 "
					+ "THEN TA.TA_Folio "
				+ "ELSE '' "
			+ "END AS Folio "
			+ ", CAT.CAT_Nombre AS Producto "
			+ ", CASE SER.TDOC_ID "
				+ "WHEN 2 "
					+ "THEN ISNULL(CONVERT(VARCHAR(10), OV.OV_FechaRegistro, 103), '') "
				+ "WHEN 1 "
					+ "THEN ISNULL(CONVERT(VARCHAR(10), TA.TA_FechaRegistro, 103), '') "
				+ "ELSE '' "
			+ "END AS FechaRegistro "
			+ ", CASE SER.TDOC_ID "
				+ "WHEN 2 "
					+ "THEN ISNULL(CONVERT(VARCHAR(10), OV.OV_FechaElaboracion, 103), '') "
				+ "WHEN 1 "
					+ "THEN ISNULL(CONVERT(VARCHAR(10), TA.TA_FechaElaboracion, 103), '') "
				+ "ELSE '' "
			+ "END AS FechaElaboracion "
			+ ", SER.Total_Cantidad AS Numero_Unidades "
			+ ", 1 AS Primera_Unidad "
			+ ", CASE "
				+ "WHEN SER.Total_Cantidad > 1 "
					+ "THEN SER.Total_Cantidad - 1 "
				+ "ELSE 0 "
			+ "END AS Unidades_Adicionales "
		+ "FROM dbo.FNC_Cliente_EstadoCuenta_Servicios(" + rqIntSerP_ID + ", " + rqIntSer_ID + ", " + rqIntCli_ID + ", " + rqIntCliCr_ID + ") SER "
			+ "INNER JOIN Cat_Catalogo CAT "
				+ "ON SER.TPro_ID = CAT.CAT_ID "
				+ "AND SEC_ID = 70 "
			+ "LEFT JOIN TransferenciaAlmacen TA "
				+ "ON SER.IDE_ID = TA.TA_ID "
				+ "AND SER.TDoc_ID = 1 "
			+ "LEFT JOIN Orden_Venta OV "
				+ "ON SER.IDE_ID = OV.OV_ID "
				+ "AND SER.TDoc_ID = 2 "
				
		var rsEdoCtaSer = AbreTabla(sqlEdoCtaSer, 1, cxnIntTipo)

		Response.Write(JSON.Convertir(rsEdoCtaSer, JSON.Tipo.Exportacion) )

		rsEdoCtaSer.Close
		
	} break
	
	
};


%>