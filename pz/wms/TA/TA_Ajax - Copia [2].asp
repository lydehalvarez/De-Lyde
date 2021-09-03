<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
//Response.Charset="utf-8"
//Response.ContentType="text/html; charset=utf-8"

// HA ID: 1 2020-jun-30 Creación de Archivo: Ajax de Transferencias
// HA ID: 2 2020-jul-06 Nueva Tarea: Despliegue, Seleccion(Agregar) y eliminación de  Productos con número de Serie Seleccionada
// HA ID: 3	2020-JUL-17 Apartado y Borrado: Se agrega apartado virtual del producto y se elimina el apartado y/o la transferencia
// HA ID: 4 2020-AGO-07 Álmacen del cliente: Se agrega filtro y validación del almacen del cliente.

var cxnIntTipo = 0

var cTTRIngreso = 1
var cTTREgreso = 2
var cTTRSucursales = 3

var cAlmLyde = 2

var rqIntTarea = Parametro("Tarea", -1)

switch( parseInt(rqIntTarea) ){
	// carga de almacenes
	case 1:{
		
		var rqIntCLI_ID = Parametro("CLI_ID", -1)
		var rqIntTTR_ID = Parametro("TTR_ID", -1)
		var rqIntTAL_ID = Parametro("TAL_ID", -1)
		
		// HA ID: 4 Se agrega campo tipo de almacen para transferencia
		var sqlCCA = "SELECT Alm_ID "
				+ ", ISNULL(Alm_Clave, 'S/C') AS Alm_Clave "
				+ ", Alm_Nombre "
				+ ", Alm_Responsable "
				+ ", Alm_RespTelefono "
				+ ", Alm_RespEmail "
				+ ", (ISNULL(Alm_Calle, '') + ' ' + ISNULL(Alm_NumExt, '') + ' ' + ISNULL(Alm_NumInt, '') + ' ' + ISNULL(Alm_Colonia, '') + ', ' + ISNULL(Alm_Delegacion, '') + ', ' + ISNULL(Alm_Ciudad, '') + ', ' + ISNULL(Alm_CP, '') + ', ' + ISNULL(Alm_Estado, '')) AS Alm_Direccion "
			+ "FROM Almacen "
			+ "WHERE Alm_Habilitado = 1 "
				+ "AND CLI_ID = " + rqIntCLI_ID + " " 
				+ "AND Alm_TipoCG84 = " + rqIntTAL_ID + " "
		
		var rsCCA = AbreTabla(sqlCCA, 1, cxnIntTipo)
%>
		<option value="0" 
		 data-Responsable="" 
		 data-Telefono=""
		 data-Email=""
		 data-DirecionCompleta=""
		 >(SELECCIONAR)</option>
<%

		while( !(rsCCA.EOF) ){
%>
		<option value="<%= rsCCA("Alm_ID") %>" 
		 data-Responsable="<%= rsCCA("Alm_Responsable") %>" 
		 data-Telefono="<%= rsCCA("Alm_RespTelefono") %>"
		 data-Email="<%= rsCCA("Alm_RespEmail") %>"
		 data-DireccionCompleta="<%= rsCCA("Alm_Direccion") %>"
		 >
			<%= rsCCA("Alm_Clave") %> - <%= rsCCA("Alm_Nombre") %>
		</option>
<%
			rsCCA.MoveNext()
		}
		
		rsCCA.close()

	} break;
	
	//Carga de Productos por almacen y cliente
	case 2: {
		
		var rqIntABALM_ID = Parametro("ALM_ID", -1)
		var rqIntABCLI_ID = Parametro("CLI_ID", -1)
		var rqIntABTTR_ID = Parametro("TTR_ID", -1)
		var rqIntABTextoBuscar = Parametro("TextoBuscar", "")
		
		
		// HA ID: 3 Se agrega validación si es apartado
		var sqlAB = ";WITH InventarioProductoDisponible ( "
				  + " PRO_ID "
				+ " , PRO_TotalDisponible "
			+ " ) AS ( "
				+ " SELECT INV.PRO_ID "
					+ " , COUNT(INV.PRO_ID) "
				+ " FROM Inventario INV "
				+ " WHERE CASE "
						+ " WHEN " + rqIntABTTR_ID + " = " + cTTRIngreso + " /* Ingreso */ "
							+ " AND INV.Inv_EstatusCG20 IN (1, 2, 3, 4) /* 1: Disponible, 2: Cuarentena, 3: Dañado, 4: Descompuesto */ "
							+ " THEN 1 "
						+ " WHEN " + rqIntABTTR_ID + " = " + cTTREgreso + " /* Egreso */ "
							+ " AND INV.Inv_EstatusCG20 IN (1) /* 1: Disponible */ "
							+ " AND INV.INV_EsApartado = 0 "
							+ " THEN 1 "
						+ " WHEN " + rqIntABTTR_ID + " = " + cTTRSucursales + " /* Almacenes */ "
							+ " AND INV.Inv_EstatusCG20 IN (1) /* 1: Disponible */ "
							+ " THEN 1 "
						+ " ELSE 0 "
					+ " END = 1 "
					+ " AND INV.INV_EnTransferencia = 0 "
					+ " AND INV.Alm_ID = " + rqIntABALM_ID + " "					
					+ " AND INV.Inv_Dummy = 0 "
					+ " AND INV.CLI_ID = " + rqIntABCLI_ID + " "
				+ " GROUP BY INV.PRO_ID "
			+ " ) "
			+ " SELECT PRC.PRO_Id "
				+ " , PRC.PROC_SKU "
				+ " , PRC.PROC_SKUQA "
				+ " , PRC.PROC_Nombre "
				+ " , PRC.PROC_Descripcion "
				+ " , IPD.PRO_TotalDisponible "
			+ " FROM Producto_Cliente PRC "
				+ " INNER JOIN InventarioProductoDisponible IPD "
					+ " ON PRC.PRO_ID = IPD.PRO_ID "
					+ " AND PRC.ProC_Habilitado = 1 "
			+ " WHERE PRC.CLI_ID = " + rqIntABCLI_ID + " "
				+ "AND ( "
					+ "PRC.PROC_Nombre LIKE '%" + rqIntABTextoBuscar + "%' "
					+ "OR PRC.PROC_Descripcion LIKE '%" + rqIntABTextoBuscar + "%' "
					+ "OR PRC.PROC_SKU LIKE '%" + rqIntABTextoBuscar + "%' "
				+ ") "
				
		var rsAB = AbreTabla(sqlAB, 1, cxnIntTipo)

		while( !(rsAB.EOF) ){
%>
		<tr>
			<td class=" col-md-1">
				<i id="Alerta_<%= rsAB("Pro_ID").Value %>" class="fa fa-exclamation-circle error" style="color: red; display: none;"></i>
			</td>
            <td class="col-md-1">
            	<%= rsAB("PRO_TotalDisponible").Value %>
            </td>
			<td class="form-group row col-md-7 issue-info">
				<a href="#">
					<%= rsAB("PROC_SKU").Value %> - <%= rsAB("PROC_Nombre").Value %>
				</a>
				<small>
					<%= rsAB("PROC_Descripcion").Value %>
				</small>
			</td>
			<td class="form-group row col-md-2">
				<input type="text" id="inpProCantidad_<%= rsAB("Pro_ID").Value %>" 
                 class="form-control col-md-2" value="" 
                 data-disponible="<%= rsAB("PRO_TotalDisponible").Value %>" 
                 data-sku="<%= rsAB("PROC_SKU").Value %>"> 
			</td>
			<td class=" col-md-1">
				<a href="#" class="link-warning" title="Agregar" onclick="Articulo.Agregar(<%= rsAB("Pro_ID").Value %>)">
					<i class="fa fa-plus-square fa-2x" style="color: green;"></i>
				</a>
			</td>
		</tr>
<%
			rsAB.MoveNext()
		}

		rsAB.Close()
		
	} break;
	
	// guardado de transferencias
	case 3: {
		
		var intTAGTAId = Parametro("TA_Id", -1)
		var intIDUsuario = Parametro("IDUsuario", -1)
		
		var intTAGCliId = Parametro("Cli_Id", -1)
		var intTAGTtrId = Parametro("Ttr_Id", -1)
		var dateTAGFecEnt = Parametro("FechaEntrega", "")
		
		var strTAGCodIde =  Parametro("CodigoIdentificador", "")
		
		var intTAGOriAlm = Parametro("OriAlm_ID", -1)
		var strTAGOriRes = Parametro("OriResponsable", "")
		var strTAGOriTel = Parametro("OriTelefono", "")
		var strTAGOriEma = Parametro("OriEmail", "")
		
		var intTAGDesAlm = Parametro("DesAlm_ID", -1)
		var strTAGDesRes = Parametro("DesResponsable", "")
		var strTAGDesTel = Parametro("DesTelefono", "")
		var strTAGDesEma = Parametro("DesEmail", "")
		
		var bolTAGExi = false
		var errError = 0
		var errMsj = ""
		var intTAGTA_Id = 0
		var strTAGTA_Folio = ""
		
		// Actualizacion 
		if( parseInt(intTAGTAId) > 0 ){
			
			//HA ID: 3 Se agrega codigo Identificador						
			//Actualizacion de la Transferencia
			var sqlTAGBTAA = "UPDATE TransferenciaAlmacen "
				+ "SET TA_Start_Warehouse_ID = " + intTAGOriAlm + " "
					+ ", TA_End_Warehouse_ID = " + intTAGDesAlm + " "
					+ ", TA_Responsable = '" + strTAGDesRes + "' "
					+ ", TA_Celular = '" + strTAGDesTel +"' "
					+ ", TA_Email = '" + strTAGDesEma + "' "
					+ ", TA_FechaEntrega = '" + dateTAGFecEnt + "' "
					+ ", TA_TipoTransferenciaCG65 = " + intTAGTtrId + " "
					+ ", TA_ResponsableOrigen = '" + strTAGOriRes +"' "
					+ ", TA_CelularOrigen = '" + strTAGOriTel + "' "
					+ ", TA_EmailOrigen = '" + strTAGOriEma + "' "
					+ ", Cli_ID = " + intTAGCliId + " "
					+ ", TA_CodigoIdentificador = '" + strTAGCodIde + "' "
					+ ", TA_UltimoUsuarioModifico = " + intIDUsuario + " "
				+ "WHERE TA_ID = " + intTAGTAId + " "
			
			//HA ID: 3 INI Se Quita el apartado de los Productos Seleccionados
			//Quitar Apartado de los productos Seleccionados si es un Egreso
			if(parseInt(intTAGTtrId) == cTTREgreso){
				
				sqlTAGBCa = "SELECT TAA.TAA_Cantidad "
						+ ", TAA.PRO_ID "
					+ "FROM TransferenciaAlmacen_Articulos TAA "
					+ "WHERE TAA.TA_ID = " + intTAGTAId + " "
				
				var rsTAGBCa = AbreTabla(sqlTAGBCa, 1, cxnIntTipo)
				var intTAACan = 0
				var intPROID = 0
				
				while( !(rsTAGBCa.EOF) ){
					
					intTAACan = rsTAGBCa("TAA_Cantidad").Value
					intPROID = rsTAGBCa("PRO_ID").Value
					
					//Actualización de Quitar el apartado
					var sqlTAGDa = "UPDATE INV "
						+ "SET INV.INV_EsApartado = 0 "
						+ "FROM Inventario INV "
						+ "WHERE INV.INV_ID IN ( "
								+ "SELECT TOP " + intTAACan + " INVA.INV_ID "
								+ "FROM Inventario INVA "
									+ "INNER JOIN TransferenciaAlmacen TA "
										+ "ON INVA.CLI_ID = TA.CLI_ID "
										+ "AND INVA.ALM_Id = TA.TA_Start_Warehouse_ID "
								+ "WHERE INVA.Inv_EstatusCG20 IN (1) /* 1: Disponible */ "
									+ "AND INVA.Inv_EsApartado = 1 "
									+ "AND INVA.INV_EnTransferencia = 0 "
									+ "AND INVA.Inv_Dummy = 0 "
									+ "AND INVA.PRO_ID = " + intPROID + " /* PRODUCTO  */ "
									+ "AND TA.TA_ID = " + intTAGTAId + " /* TRANSFERENCIA */ "					
								+ "ORDER BY INVA.INV_LoteIngreso ASC "
									+ ", INVA.Inv_FechaRegistro ASC "
							+ "); "
					
					Ejecuta(sqlTAGDa, cxnIntTipo)
					
					rsTAGBCa.MoveNext
					
				}
				rsTAGBCa.close
				
			}
			//HA ID: 3 FIN
			
			//Eliminación de los Articulos
			var sqlTAGBTADA = "DELETE TransferenciaAlmacen_Articulos "
				+ "WHERE TA_ID = " + intTAGTAId + " "
			
			//Eliminación de los Números de Serie del Articulo
			var sqlTAGBTADAP = "DELETE TransferenciaAlmacen_Articulo_Picking "
				+ "WHERE TA_ID = " + intTAGTAId + " "
			
			try {
				
				Ejecuta(sqlTAGBTADAP, cxnIntTipo) 				
				Ejecuta(sqlTAGBTADA, cxnIntTipo) 
				Ejecuta(sqlTAGBTAA, cxnIntTipo) 
				
				errMsj = "Se guard&oacute; la Transferencia"
				
				//Response.Write("<br>INSERT: " + sqlTAGBTAA + "<br>")
				
			} catch(err){
				
				errError = 1
				errMsj = "NO Se guard&oacute; la Transferencia"
				
			}
		
		//Inserción	
		} else {
			
			//Seleccion del último Registro
			var sqlTAGBTAMax = "SELECT ISNULL(MAX(TA_ID), 0) + 1 AS TA_ID_Ultimo "
				+ "FROM TransferenciaAlmacen"
			
			var rsTAGBTAMax = AbreTabla(sqlTAGBTAMax, 1, cxnIntTipo)
			
			var intTA_IDMax = 0
			
			if( !(rsTAGBTAMax.EOF) ){
				intTA_IDMax = rsTAGBTAMax("TA_ID_Ultimo").Value
			}
			
			rsTAGBTAMax.close
			
			//HA ID: 3 Se agrega Codigo Identificador
			var sqlTAGBTAI = "INSERT INTO TransferenciaAlmacen ( "
				  + "TA_ID "
				+ ", TA_Start_Warehouse_ID "
				+ ", TA_End_Warehouse_ID "
				+ ", TA_Responsable "
				+ ", TA_Celular "
				+ ", TA_Email "
				+ ", TA_FechaEntrega "
				+ ", TA_TipoTransferenciaCG65 "
				+ ", TA_ResponsableOrigen "
				+ ", TA_CelularOrigen "
				+ ", TA_EmailOrigen "
				+ ", Cli_ID "
				+ ", TA_CodigoIdentificador "
				+ ", TA_UltimoUsuarioModifico "
			+ ") "
			+ "VALUES ( "
				  + " " + intTA_IDMax + " "
				+ ", " + intTAGOriAlm + " "
				+ ", " + intTAGDesAlm + " "
				+ ", '" + strTAGDesRes + "' "
				+ ", '" + strTAGDesTel +"' "
				+ ", '" + strTAGDesEma + "' "
				+ ", '" + dateTAGFecEnt + "' "
				+ ", " + intTAGTtrId + " "
				+ ", '" + strTAGOriRes +"' "
				+ ", '" + strTAGOriTel + "' "
				+ ", '" + strTAGOriEma + "' "
				+ ", " + intTAGCliId + " "
				+ ", '" + strTAGCodIde + "' "
				+ ", " + intIDUsuario + " "
			+ ") "

			try {
				
				Ejecuta(sqlTAGBTAI, cxnIntTipo) 
				errMsj = "Se guard&oacute; la Transferencia"
				
				intTAGTAId = intTA_IDMax
				
			} catch(err){
				
				errError = 1
				errMsj = "NO Se guard&oacute; la Transferencia"
			}
			
		}
		
		var sqlVAGBTAF = "SELECT TA_ID "
				+ ", TA_Folio "
			+ "FROM TransferenciaAlmacen "
			+ "WHERE TA_ID = " + intTAGTAId + " "
				
		var rsVAGBTAF = AbreTabla(sqlVAGBTAF, 1, cxnIntTipo)
			
		if( !(rsVAGBTAF.EOF) ){
			intTAGTA_Id = rsVAGBTAF.Fields("TA_ID").Value
			strTAGTA_Folio = rsVAGBTAF.Fields("TA_Folio").Value
		}
		
		rsVAGBTAF.close()
		
		//respuesta de la ejecución de Ajax
		
		var jsonTAG = '{ '
				  + '"Error": "' + errError + '" '
				+ ', "Mensaje": "' + errMsj + '" '
				+ ', "TA_ID": "' + intTAGTAId + '" '
				+ ', "TA_Folio": "' + strTAGTA_Folio + '" '
			+ '} '
		
		Response.Write(jsonTAG)
		
	} break;
	
	//listado de Articulos
	case 4: {
		
		var rqIntCARTA_Id = Parametro("TA_ID", -1)
		//HA ID: 2 Se agrega variable 
		var rqBolSiSer = ( Parametro("SiSer", -1) == 1 )
		var rqBolCAREsEdi = ( Parametro("EsEdi", -1) == 1 )
		
		var sqlCAR = "SELECT TAA.TA_ID "
				+ ", TAA.TAA_ID "
				+ ", TAA.TAA_SKU "
				+ ", TAA.TAA_Cantidad "
				+ ", PRC.PROC_SKU "
				+ ", PRC.PROC_Nombre "
				+ ", PRC.PROC_Descripcion "
				+ ", PRC.PRO_Id "
				+ ", ( "
					+ "SELECT COUNT(*) "
					+ "FROM TransferenciaAlmacen_Articulo_Picking TAS "
					+ "WHERE TAS.TA_ID = TAA.TA_ID "
						+ "AND TAS.PRO_Id = TAA.PRO_ID "
						+ "AND TAS.TAA_Id = TAA.TAA_ID " 
				+ ") AS TAA_TotalSeries "
			+ "FROM TransferenciaAlmacen_Articulos TAA "
				+ "INNER JOIN Producto_Cliente PRC "
					+ "ON TAA.Pro_ID = PRC.Pro_Id "
			+ "WHERE TA_ID = " + rqIntCARTA_Id + " "
		
		var rsCAR = AbreTabla(sqlCAR, 1, cxnIntTipo)
		
		var iCAR = 0
		var intCARTotCan = 0
%>
<table class="table table-bordered table-hover issue-tracker">
    <thead>
        <tr>
<%	if( rqBolSiSer ){
%>
            <th class="col-md-1">&nbsp;</th>
<%	}
%>            
            <th class="col-md-1">#</th>
            <th class="col-md-7">Producto</th>
            <th class="col-md-2">Cantidad</th>
<%	if( rqBolCAREsEdi ) {
%>            
            <th class="col-md-1">&nbsp;</th>
<%	}
%>            
        </tr>
    </thead>
    <tbody>
<%
		while( !(rsCAR.EOF) ){
			iCAR++
			
			intCARTotCan += parseInt(rsCAR("TAA_Cantidad"))
%>
		<tr <% if( rqBolCAREsEdi ) { %>class="trProducto" id="trProId_<%= rsCAR("PRO_Id") %>" <% } %>>
			
<%	//HA ID: 2 INI Se agrega columna de Asignación de Números de Series
	if( rqBolSiSer ) {
	
		var strCARTipoAle = ""
		var strCARTextoAle = ""
		var intCARTotal = parseInt(rsCAR("TAA_Cantidad").Value) - parseInt(rsCAR("TAA_TotalSeries").Value)
			
		if( parseInt(rsCAR("TAA_TotalSeries").Value) == 0 ){
			strCARTipoAle = "danger"
			strCARTextoAle = "Sin Asignar"
		} else if( parseInt(rsCAR("TAA_TotalSeries").Value) != parseInt(rsCAR("TAA_Cantidad").Value) ) {
			strCARTipoAle = "warning"
			strCARTextoAle = "Incompleto"
		} else {
			strCARTipoAle = "primary"
			strCARTextoAle = "Completo"
		}
%>
            <td class="col-md-1">
		        <span class="classProducto label label-<%= strCARTipoAle %>"  
<%		if( intCARTotal != 0 ){ 
%>               
				 style="cursor: pointer;" 
                 data-toggle="modal" 
                 data-target="#modalBuscaSerie" 
<%		}
%>                 
                 data-proid="<%= rsCAR("PRO_ID").Value %>" 
                 data-pronombre="<%= rsCAR("PROC_Nombre").Value %>" 
                 data-taaid="<%= rsCAR("TAA_ID").Value %>" 
                 data-taacantidad="<%= rsCAR("TAA_Cantidad").Value %>" 
                 data-taarestante="<%= intCARTotal %>" 
                 
<%		if( intCARTotal != 0 ){
%>
                 onclick="Serie.VisualizarBusqueda($(this))" 
                 title="Cantidad Faltante (<%= intCARTotal %>)" 
<%		}
%>                
                ><%= strCARTextoAle %></span>
            </td>
<%	
	}
	//HA ID: 2 INI Se agrega columna de Asignación de Números de Series
%>            
			<td class="col-md-1">
				<%= iCAR %>
			</td>
			<td class="form-group row col-md-7 issue-info">
				<a href="#" 
<%	if( rqBolSiSer ){
%>
                	onclick="Serie.Cargar(<%= rsCAR("TA_Id").Value %>,<%= rsCAR("TAA_Id").Value %>, <%= rsCAR("PRO_ID").Value %>,<%= (rqBolCAREsEdi) ? 1 : 0 %>)"
<%	}
%>					
                >
					<i class="fa fa-file-text-o fa-lg"></i> <%= rsCAR("PROC_SKU") %> - <%= rsCAR("PROC_Nombre") %>
				</a>
				<small>
					<%= rsCAR("PROC_Descripcion") %>
				</small>
			</td>
			<td class="col-md-2">
				<%= rsCAR("TAA_Cantidad") %>
			</td>
<%
			if( rqBolCAREsEdi ) {
%>
			<td class=" col-md-1">
				<a href="#" class="link-warning" title="Eliminar" onclick="Articulo.Eliminar(<%= rsCAR("TAA_ID") %>, 1)">
					<i class="fa fa-trash fa-2x"></i>
				</a>
			</td>
<%			}
%>				
		</tr>
<%		
			rsCAR.MoveNext()
			
			if( rsCAR.EOF ){
%>
		<tr class="border-top">
<%	if( rqBolSiSer ){
%>        
			<td class=" col-md-1"></td>
<%	}
%>				            
  			<td class=" col-md-1"></td>
			<td class="form-group row col-md-7 issue-info text-right"><strong>Total</strong></td>
			<td class="col-md-2">
				<%= intCARTotCan %>
			</td>
<%
				if( rqBolCAREsEdi ) {
%>			
			<td class=" col-md-1"></td>
<%
				}
%>			
		</tr>
<%
			}
			
		}
%>
	</tbody>
</table>
<%
		rsCAR.close()
		
	} break;
	
	
	//Agregar Producto
	case 5: {
		
		// HA ID: 3 Se agrega Tipo de Transferencia
		var rqIntITATTRId = Parametro("TTRId", "-1")
		var rqIntITATAId = Parametro("TAId", "-1")
		var rqIntITAProId = Parametro("ProId", "-1")
		var rqIntITAProCantidad = Parametro("ProCantidad", "-1")
		var rqStrITAProSKU = Parametro("ProSKU", "")
		
		var errError = 0
		
		// HA ID: 3 Bandera de Tipo de Transferencia "Egreso"
		var bolSeApa = ( rqIntITATTRId == cTTREgreso )
		
		var intITAProCantidad = rqIntITAProCantidad
		
		// HA ID: 3 INI validación y reasignación de cantidad a apartar
		if( bolSeApa ){
			
			sqlITABCa = "SELECT COUNT(INVA.INV_ID) AS INVA_TotalDisponible "
				+ "FROM Inventario INVA "
					+ "INNER JOIN TransferenciaAlmacen TA "
						+ "ON INVA.CLI_ID = TA.CLI_ID "
						+ "AND INVA.ALM_Id = TA.TA_Start_Warehouse_ID "
				+ "WHERE INVA.Inv_EstatusCG20 IN (1) /* 1: Disponible */  "
					+ "AND INVA.Inv_EsApartado = 0 "
					+ "AND INVA.INV_EnTransferencia = 0  "
					+ "AND INVA.Inv_Dummy = 0  "
					+ "AND INVA.PRO_ID = " + rqIntITAProId + " /* PRODUCTO  */ "
					+ "AND TA.TA_ID = " + rqIntITATAId + " /* TRANSFERENCIA */ "
					
			var rsITABCa = AbreTabla(sqlITABCa, 1, cxnIntTipo)
			
			if( !(rsITABCa.EOF) ){
				
				if( parseInt(rsITABCa("INVA_TotalDisponible").Value) < parseInt(rqIntITAProCantidad) ){
					intITAProCantidad = parseInt(rsITABCa("INVA_TotalDisponible").Value)
				}

			}
			
			rsITABCa.close
		}
		// HA ID: 3 FIN			
		
		// HA ID: 3 Se agrega Consulta de Apartado VIRTUAL por EGRESO		
		var sqlITAInv = "UPDATE INV "
			+ "SET INV.INV_EsApartado = 1 "
			+ "FROM Inventario INV "
			+ "WHERE INV.INV_ID IN ( "
					+ "SELECT TOP " + intITAProCantidad + " INVA.INV_ID "
					+ "FROM Inventario INVA "
						+ "INNER JOIN TransferenciaAlmacen TA "
							+ "ON INVA.CLI_ID = TA.CLI_ID "
							+ "AND INVA.ALM_Id = TA.TA_Start_Warehouse_ID "
					+ "WHERE INVA.Inv_EstatusCG20 IN (1) /* 1: Disponible */ "
						+ "AND INVA.Inv_EsApartado = 0 "
						+ "AND INVA.INV_EnTransferencia = 0 "
						+ "AND INVA.Inv_Dummy = 0 "
						+ "AND INVA.PRO_ID = " + rqIntITAProId + " /* PRODUCTO A AGREGAR */ "
						+ "AND TA.TA_ID = " + rqIntITATAId + " /* TRANSFERENCIA CREADA */ "					
					+ "ORDER BY INVA.INV_LoteIngreso ASC "
						+ ", INVA.Inv_FechaRegistro ASC "
				+ "); "
				
		var sqlITA = "INSERT INTO TransferenciaAlmacen_Articulos ( "
				  + "TA_ID "
				+ ", TAA_ID "
				+ ", TAA_SKU "
				+ ", TAA_Cantidad "
				+ ", Pro_ID "
			+ ") "
			+ "VALUES ( "
				  + " " + rqIntITATAId +" "
				+ ", ISNULL((SELECT MAX(TAA_ID) FROM TransferenciaAlmacen_Articulos WHERE TA_ID = " + rqIntITATAId + "), 0) + 1 "
				+ ", '" + rqStrITAProSKU + "' "
				+ ", " + intITAProCantidad + " "
				+ ", " + rqIntITAProId + " "
			+ ") "
		
		try {
			
			// HA ID: 3 INI Se agrega apartado virtual de Producto
			if( bolSeApa ){
				Ejecuta(sqlITAInv, cxnIntTipo) 
			}
			// HA ID: 3 FIN
			
			Ejecuta(sqlITA, cxnIntTipo) 
			
		} catch(err) {
		
			errError = 1
			
		}
		
		var jsonITA = '{'
				+ ' "Error": "' + errError + '"'
			+ '}'
			
		Response.Write(jsonITA)
		
	} break;
	
	//Eliminacion del Articulo de la transferencias
	case 6: {
		// HA ID: 3 Se agrega Tipo de Transferencia
		var rqIntETATTRId = Parametro("TTRId", "-1")
		var rqIntETATAId = Parametro("TAId", "-1")
		var rqIntETATAAId = Parametro("TAAId", "-1")
		var rqIntETATipo = Parametro("Tipo", "-1")
		
		var errError = 0
		
		// HA ID: 3 INI 
		if( parseInt(rqIntETATTRId) == cTTREgreso ) {
			
			sqlETABCa = "SELECT TAA.TAA_Cantidad "
					+ ", TAA.PRO_ID "
				+ "FROM TransferenciaAlmacen_Articulos TAA "
				+ "WHERE TAA.TA_ID = " + rqIntETATAId + " "
			
			if( parseInt(rqIntETATipo) == 1 ){
				sqlETABCa += "AND TAA.TAA_Id = " + rqIntETATAAId + " "
			}
					
			var rsETABCa = AbreTabla(sqlETABCa, 1, cxnIntTipo)
			var intTAACan = 0
			var intPROID = 0
			
			while( !(rsETABCa.EOF) ){
				
				intTAACan = rsETABCa("TAA_Cantidad").Value
				intPROID = rsETABCa("PRO_ID").Value
				
				//Actualización de Quitar el apartado
				var sqlETADa = "UPDATE INV "
					+ "SET INV.INV_EsApartado = 0 "
					+ "FROM Inventario INV "
					+ "WHERE INV.INV_ID IN ( "
							+ "SELECT TOP " + intTAACan + " INVA.INV_ID "
							+ "FROM Inventario INVA "
								+ "INNER JOIN TransferenciaAlmacen TA "
									+ "ON INVA.CLI_ID = TA.CLI_ID "
									+ "AND INVA.ALM_Id = TA.TA_Start_Warehouse_ID "
							+ "WHERE INVA.Inv_EstatusCG20 IN (1) /* 1: Disponible */ "
								+ "AND INVA.Inv_EsApartado = 1 "
								+ "AND INVA.INV_EnTransferencia = 0 "
								+ "AND INVA.Inv_Dummy = 0 "
								+ "AND INVA.PRO_ID = " + intPROID + " /* PRODUCTO  */ "
								+ "AND TA.TA_ID = " + rqIntETATAId + " /* TRANSFERENCIA */ "					
							+ "ORDER BY INVA.INV_LoteIngreso ASC "
								+ ", INVA.Inv_FechaRegistro ASC "
						+ "); "
				
				Ejecuta(sqlETADa, cxnIntTipo)
				
				rsETABCa.MoveNext
				
			}
			rsETABCa.close
		}
		//HA ID: 3 FIN
		
		//HA ID: 2 Se eliminan también los números de Serie al eliminar el articulo
		var sqlETAS = "DELETE FROM TransferenciaAlmacen_Articulo_Picking "
			+ "WHERE TA_ID = " + rqIntETATAId + " "
			
		var sqlETA = "DELETE FROM TransferenciaAlmacen_Articulos "
			+ "WHERE TA_Id = " + rqIntETATAId + " "
			
		if( parseInt(rqIntETATipo) == 1 ){
			// HA ID: 2 Se agrega validación por articulo de transferencia a los numeros del articulo
			sqlETAS += "AND TAA_ID = " + rqIntETATAAId + " "
			sqlETA += "AND TAA_Id = " + rqIntETATAAId + " "
		}
			
		try {
			// HA ID: 2 Se ejecuta la eliminación la eliminación de los nimeros de serie en el picking
			Ejecuta( sqlETAS, cxnIntTipo)
			Ejecuta( sqlETA, cxnIntTipo)
		
		} catch(err){
			
			errError = 1
			
		}
		
		var jsonETA = '{'
				+ ' "Error": "' + errError + '" '
			+ '}'
		
		Response.Write(jsonETA)
		
	} break;
	
	// HA ID: 2 INI Visualización de numeros de Serie de Articulo Seleccionado
	case 7: {
		
		var rqIntVAPTA_ID = Parametro("TA_ID", -1)
		var rqIntVAPTAA_ID = Parametro("TAA_ID", -1)
		var rqIntVAPPRO_ID = Parametro("PRO_ID", -1)
		var rqBolEsEdicion = Parametro("EsEdicion", -1)
		
		var bolEsEdicion = (parseInt(rqBolEsEdicion) == 1) ? true: false; 
		
		var sqlVAP = "SELECT TAS.TA_ID "
			+ ", TAS.TAA_ID "
			+ ", TAS.TAS_ID "
			+ ", TAS.TAS_Serie "
			+ ", TAS.PRO_ID "
			+ ", PRO.PRO_Nombre "
		+ "FROM TransferenciaAlmacen_Articulo_Picking TAS "
			+ "INNER JOIN Producto PRO "
				+ "ON TAS.PRO_ID = PRO.PRO_ID "
		+ "WHERE TAS.TA_ID = " + rqIntVAPTA_ID + " "
			+ "AND TAS.TAA_ID = " + rqIntVAPTAA_ID + " "
			+ "AND TAS.PRO_ID = " + rqIntVAPPRO_ID + " "
		+ "ORDER BY TAS.TAS_ID ASC "
		
		var rsVAP = AbreTabla(sqlVAP, 1, cxnIntTipo)
		
		var iVAP = 0
		
		if( !(rsVAP.EOF) ){
%>
		<div class="col-form-label form-group col-md-12">
        	<i class="fa fa-tag fa-lg text-success"></i> <label><%= rsVAP("PRO_Nombre").Value %></label>
        </div>
<%
		}
%>
        <table class="table table-striped col-md-12">
            <thead>
                <tr>
                    <th>#</th>
                    <th>
                        Serie
                    </th>
<%		if( bolEsEdicion) {
%>
                    <th>&nbsp;</th>
<%		}
%>
                </tr>
            </thead>
            <tbody>
<%		
		while( !(rsVAP.EOF) ){
			iVAP++
%>
                <tr>
                    <td>
						<%= iVAP %>
                    </td>
                    <td>
                        <i class="fa fa-barcode"></i> <span class="classSerie"><%= rsVAP("TAS_Serie").Value %></span>
                    </td>
<%		if( bolEsEdicion) {
%>
                    <td >
                        <a href="#" class="link-warning" title="Eliminar" onclick="Serie.Eliminar(<%= rsVAP("TA_ID").Value %>, <%= rsVAP("TAA_ID").Value %>, <%= rsVAP("TAS_ID").Value %>, <%= rsVAP("PRO_ID").Value %>)">
                            <i class="fa fa-trash fa-lg"></i>
                        </a>
                    </td>
<%		}
%>
                </tr>
<%
			rsVAP.MoveNext()
		}
%>
            </tbody>
        </table>
<%		
		rsVAP.close()
		
	} break;
	
	//Buscar Numeros de Series
	case 8:{
		
		var rqIntBAPTTR_ID = Parametro("TTR_ID", -1)
		
		var rqIntBAPCLI_ID = Parametro("CLI_ID", -1)
		var rqIntBAPALM_ID = Parametro("ALM_ID", -1)
		var rqIntBAPPRO_ID = Parametro("PRO_ID", -1)
		var rqStrBAPPRO_Serie = Parametro("PRO_Serie", "")
		
		var sqlBAP = "SELECT INV.INV_ID "
				+ ", INV.INV_Serie "
			+ "FROM Inventario INV "
			+ "WHERE CASE "
					+ "WHEN " + rqIntBAPTTR_ID + " = " + cTTRIngreso + " /* Ingreso */ "
						+ "AND " + rqIntBAPALM_ID + " <> " + cAlmLyde + " "
						+ "AND INV.Inv_EstatusCG20 IN (1, 2, 3, 4) /* 1: Disponible, 2: Cuarentena, 3: Dañado, 4: Descompuesto */ "
						+ "THEN 1 "
					+ "WHEN " + rqIntBAPTTR_ID + " = " + cTTREgreso + " /* Egreso */ "
						+ "AND " + rqIntBAPALM_ID + " = " + cAlmLyde + " "
						+ "AND INV.Inv_EstatusCG20 IN (1) /* 1: Disponible */ "
						+ "THEN 1 "
					+ "WHEN " + rqIntBAPTTR_ID + " = " + cTTRSucursales + " /* Almacenes */ "
						+ "AND " + rqIntBAPALM_ID + " <> " + cAlmLyde + " "
						+ "AND INV.Inv_EstatusCG20 IN (1) /* 1: Disponible */ "
						+ "THEN 1 "
					+ "ELSE 0 "
				+ "END = 1 "
				+ "AND INV.INV_EnTransferencia = 0  "
				+ "AND INV.Inv_Dummy = 0 "
				+ "AND INV.CLI_ID = " + rqIntBAPCLI_ID + " "
				+ "AND INV.Pro_ID = " + rqIntBAPPRO_ID + " "
				+ "AND INV.ALM_ID = " + rqIntBAPALM_ID + " "
				+ "AND INV.INV_Serie LIKE '%" + rqStrBAPPRO_Serie + "%' "
		
		var rsBAP = AbreTabla(sqlBAP, 1, cxnIntTipo)
		
		while( !(rsBAP.EOF) ){
%>
			<tr>
            	<td>
                	<%= rsBAP("INV_Serie").Value %>
                </td>
                <td>
                	<a href="#" class="link-warning" title="Agregar" onclick="Serie.Agregar(this)"
                    	data-invid="<%= rsBAP("INV_ID").Value %>"
                        data-invserie="<%= rsBAP("INV_Serie").Value %>"
                    >
                    	<i class="fa fa-plus-square fa-2x"></i>
                    </a>
                </td>
            </tr>
<%			
			rsBAP.MoveNext
		}
		rsBAP.close
		
	} break;
	
	// Inserción de numero de Serie 
	case 9:{
		
		var rqIntISATA_ID = Parametro("TA_ID", -1)
		var rqIntISATAA_ID = Parametro("TAA_ID", -1)
		var rqStrISATAS_Serie = Parametro("TAS_Serie", "")
		var rqIntISATAS_Usuario = Parametro("TAS_Usuario", -1)
		var rqIntISAPRO_ID = Parametro("PRO_ID", -1)
		var rqIntISAINV_ID = Parametro("INV_ID", -1)
		
		var errISAError = 0
		
		var sqlISA = "INSERT INTO TransferenciaAlmacen_Articulo_Picking ( "
				  + "TA_ID "
				+ ", TAA_ID "
				+ ", TAS_ID "
				+ ", TAS_Serie "
				+ ", TAS_Usuario "
				+ ", Pro_ID "
				+ ", Inv_ID "
			+ ") "
			+ "VALUES( "
				  + " " + rqIntISATA_ID + " /*TA_ID*/ "
				+ ", " + rqIntISATAA_ID + " /*TAA_ID*/ "
				+ ", ISNULL((  "
					+ "SELECT MAX(TAS.TAS_ID)"
					+ "FROM TransferenciaAlmacen_Articulo_Picking TAS "
					+ "WHERE TAS.TA_ID = " + rqIntISATA_ID + " /*TA_ID*/ "
						+ "AND TAS.TAA_ID = " + rqIntISATAA_ID + " /*TAA_ID*/ "
				+ "), 0) + 1 /*TAS_ID*/ "
				+ ", '" + rqStrISATAS_Serie + "' /*TAS_Serie*/ "
				+ ", " + rqIntISATAS_Usuario + " /*TAS_Usuario*/ "
				+ ", " + rqIntISAPRO_ID + " /*Pro_ID*/ "
				+ ", " + rqIntISAINV_ID + " /*Inv_ID*/ "
			+ ") "
			
		try {
		
			Ejecuta( sqlISA, cxnIntTipo)
		
		} catch(err){
			
			errISAError = 1
			
		}
		
		var jsonISA = '{'
				+ ' "Error": "' + errISAError + '" '
			+ '}'
		
		Response.Write(jsonISA)
		
	} break;
	
	//Eliminación del número de Serie
	case 10: {
		
		var rqIntESATA_ID = Parametro("TA_ID", -1)
		var rqIntESATAA_ID = Parametro("TAA_ID", -1)
		var rqStrESATAS_ID = Parametro("TAS_ID", -1)
		
		var errESAError = 0
		
		var sqlESA = "DELETE FROM TransferenciaAlmacen_Articulo_Picking "
			+ "WHERE TA_ID = " + rqIntESATA_ID + " "
				+ "AND TAA_ID = " + rqIntESATAA_ID + " "
				+ "AND TAS_ID = " + rqStrESATAS_ID + " "
		
		try {
		
			Ejecuta( sqlESA, cxnIntTipo)
		
		} catch(err){
			
			errESAError = 1
			
		}
		
		var jsonESA = '{'
				+ ' "Error": "' + errESAError + '" '
			+ '}'
		
		Response.Write(jsonESA)
		
	} break;
	// HA ID: 2 FIN
	
	// HA ID: 3	INI Liberación: Cambio de Estatus de la transición a liberada(2)
	//Actualización de Estarus de liberación de la transferencia
	case 11: {
		
		var rqIntTA_ID = Parametro("TA_ID", -1)
		
		var errError = 0
		
		var sqlTraLib = "UPDATE TransferenciaAlmacen "
				+ "SET TA_EstatusCG89 = 2 /* Solicitud Terminada */ "
				+ "WHERE TA_ID = " + rqIntTA_ID + " "
		
		try {
			
			Ejecuta(sqlTraLib, cxnIntTipo)
		
		} catch(err) {
			
			errError = 1
			
		}
		
		var jsonTraLib = '{'
				+ ' "Error": "' + errError + '" '
			+ '}'
		
		Response.Write(jsonTraLib)
		
	} break;
	
	// HA ID: 3	FIN
	// HA ID: 3 INI Se agrega Bloque de Eliminación de Transferencia
	// Eliminación de la Transferencia
	case 12: {
		
		var rqIntTA_ID = Parametro("TA_ID", -1)
		var rqIntTTR_ID = Parametro("TTR_ID", -1)
		
		var errError = 0
		var errMensaje = ""
		
		if( parseInt(rqIntTTR_ID) == cTTREgreso ){
			
			sqlETABCa = "SELECT TAA.TAA_Cantidad "
					+ ", TAA.PRO_ID "
				+ "FROM TransferenciaAlmacen_Articulos TAA "
				+ "WHERE TAA.TA_ID = " + rqIntTA_ID + " "
			
			var rsETABCa = AbreTabla(sqlETABCa, 1, cxnIntTipo)
			var intTAACan = 0
			var intPROID = 0
			
			while( !(rsETABCa.EOF) ){
				
				intTAACan = rsETABCa("TAA_Cantidad").Value
				intPROID = rsETABCa("PRO_ID").Value
				
				//Actualización de Quitar el apartado
				var sqlETADa = "UPDATE INV "
					+ "SET INV.INV_EsApartado = 0 "
					+ "FROM Inventario INV "
					+ "WHERE INV.INV_ID IN ( "
							+ "SELECT TOP " + intTAACan + " INVA.INV_ID "
							+ "FROM Inventario INVA "
								+ "INNER JOIN TransferenciaAlmacen TA "
									+ "ON INVA.CLI_ID = TA.CLI_ID "
									+ "AND INVA.ALM_Id = TA.TA_Start_Warehouse_ID "
							+ "WHERE INVA.Inv_EstatusCG20 IN (1) /* 1: Disponible */ "
								+ "AND INVA.Inv_EsApartado = 1 "
								+ "AND INVA.INV_EnTransferencia = 0 "
								+ "AND INVA.Inv_Dummy = 0 "
								+ "AND INVA.PRO_ID = " + intPROID + " /* PRODUCTO  */ "
								+ "AND TA.TA_ID = " + rqIntTA_ID + " /* TRANSFERENCIA */ "					
							+ "ORDER BY INVA.INV_LoteIngreso ASC "
								+ ", INVA.Inv_FechaRegistro ASC "
						+ "); "
				
				Ejecuta(sqlETADa, cxnIntTipo)
				
				rsETABCa.MoveNext
				
			}
			rsETABCa.close
		}
		
		sqlETAAP = "DELETE FROM TransferenciaAlmacen_Articulo_Picking "
			+ "WHERE TA_Id = " + rqIntTA_ID + " " 
		
		sqlETAA = "DELETE FROM TransferenciaAlmacen_Articulos "
			+ "WHERE TA_Id = " + rqIntTA_ID + " " 
		
		sqlETA = "DELETE FROM TransferenciaAlmacen "
			+ "WHERE TA_Id = " + rqIntTA_ID + " "
		
		try {
			
			Ejecuta(sqlETAAP, cxnIntTipo)
			Ejecuta(sqlETAA, cxnIntTipo)
			Ejecuta(sqlETA, cxnIntTipo)
			
			errMensaje = "Se elimin&oacute; la Transferencia"
			
		} catch(err){
			
			errError = 1
			errMensaje = "NO Se elimin&oacute; la Transferencia"
		}
		
		var jsonETA = '{'
				+ ' "Error": "' + errError + '"'
				+ ', "Mensaje": "' + errMensaje + '"'
			+ '}'
			
		Response.Write(jsonETA)
		
	} break;
}

%>
