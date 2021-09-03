<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%

// HA ID: 1 2020-jun-30 Creación de Archivo: Ajax de Transferencias
// HA ID: 2 2020-jul-06 Nueva Tarea: Despliegue, Seleccion(Agregar) y eliminación de  Productos con número de Serie Seleccionada
// HA ID: 3	2020-JUL-17 Apartado y Borrado: Se agrega apartado virtual del producto y se elimina el apartado y/o la transferencia
// HA ID: 4 2020-AGO-07 Álmacen del cliente: Se agrega filtro y validación del almacen del cliente.
// HA ID: 5 2020-SEP-07 Recepcion de Transferencia: Se agrega opcion para validar recepcion de transferencia
// HA ID: 6 2021-JUL-27 Se agrega proceso y opciones de Siniestros.
// HA ID: 7 2021-Ago-03 Siniestro: Cierre de Siniestro.
// HA ID: 8 2021-Ago-24 Entrega Parcial: Se agrega opciones de Entrega parcial

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
			+ " FROM Almacen "
			+ " WHERE Alm_Habilitado = 1 "
				+ " AND CLI_ID = " + rqIntCLI_ID  
				+ " AND Alm_TipoCG84 = " + rqIntTAL_ID  
		
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
				+ " FROM Inventario INV, Producto_Cliente PC "
                + " WHERE INV.Pro_ID = PC.Pro_ID "
				+ "   AND CASE "
						+ " WHEN " + rqIntABTTR_ID + " = " + cTTRIngreso + " /* Ingreso */ "
							+ " AND INV.Inv_EstatusCG20 IN (1, 2, 3, 4, 14) /* 1: Disponible, 2: Cuarentena, 3: Dañado, 4: Descompuesto, 14: Asignados */ "
							+ " AND Inv.Inv_EnAlmacen = 0 "
							+ " THEN 1 "
						+ " WHEN " + rqIntABTTR_ID + " = " + cTTREgreso + " /* Egreso */ "
							+ " AND INV.Inv_EstatusCG20 IN (1, 14) /* 1: Disponible, 14: Asignados */ "
							+ " AND INV.INV_EsApartado = 0 "
							+ " AND Inv.Inv_EnAlmacen = 1 "
							+ " THEN 1 "
						+ " WHEN " + rqIntABTTR_ID + " = " + cTTRSucursales + " /* Almacenes */ "
							+ " AND INV.Inv_EstatusCG20 IN (1, 14) /* 1: Disponible, 14: Asignados */ "
							+ " AND Inv.Inv_EnAlmacen = 0 "
							+ " THEN 1 "
						+ " ELSE 0 "
					+ " END = 1 "
					+ " AND INV.INV_EnTransferencia = 0 "
					+ " AND INV.Alm_ID = " + rqIntABALM_ID  					
					+ " AND INV.Inv_Dummy = 0 "
					+ " AND INV.CLI_ID = " + rqIntABCLI_ID  
             if(rqIntABTextoBuscar != "") {
                sqlAB += " AND ( "
                        + " PC.PROC_Nombre LIKE '%" + rqIntABTextoBuscar + "%' "
                        + " OR PC.PROC_Descripcion LIKE '%" + rqIntABTextoBuscar + "%' "
                        + " OR PC.PROC_SKU LIKE '%" + rqIntABTextoBuscar + "%' "
                    + ") "
             }
      sqlAB += " GROUP BY INV.PRO_ID "
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
            if(rqIntABTextoBuscar != "") {
                sqlAB += " AND ( "
                        + " PRC.PROC_Nombre LIKE '%" + rqIntABTextoBuscar + "%' "
                        + " OR PRC.PROC_Descripcion LIKE '%" + rqIntABTextoBuscar + "%' "
                        + " OR PRC.PROC_SKU LIKE '%" + rqIntABTextoBuscar + "%' "
                    + ") "
             }
		
        //Response.Write(sqlAB)
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
		
		var intTAGTAId = Parametro("TA_ID", -1)
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
		var intTAGTA_ID = 0
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
					+ " FROM TransferenciaAlmacen_Articulos TAA "
					+ " WHERE TAA.TA_ID = " + intTAGTAId + " "
				
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
								+ " WHERE INVA.Inv_EstatusCG20 IN (1) /* 1: Disponible */ "
									+ " AND INVA.Inv_EsApartado = 1 "
									+ " AND INVA.INV_EnTransferencia = 0 "
									+ " AND INVA.Inv_Dummy = 0 "
									+ " AND INVA.PRO_ID = " + intPROID + " /* PRODUCTO  */ "
									+ " AND TA.TA_ID = " + intTAGTAId + " /* TRANSFERENCIA */ "					
								+ " ORDER BY INVA.INV_LoteIngreso ASC "
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
		
		var sqlVAGBTAF = "SELECT TA_ID, TA_Folio "
			+ " FROM TransferenciaAlmacen "
			+ " WHERE TA_ID = " + intTAGTAId 
				
		var rsVAGBTAF = AbreTabla(sqlVAGBTAF, 1, cxnIntTipo)
			
		if( !(rsVAGBTAF.EOF) ){
			intTAGTA_ID = rsVAGBTAF.Fields("TA_ID").Value
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
		
		var rqIntCARTA_ID = Parametro("TA_ID", -1)
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
			+ "WHERE TA_ID = " + rqIntCARTA_ID 
		
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
                	onclick="Serie.Cargar(<%= rsCAR("TA_ID").Value %>,<%= rsCAR("TAA_Id").Value %>, <%= rsCAR("PRO_ID").Value %>,<%= (rqBolCAREsEdi) ? 1 : 0 %>)"
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
				+ " FROM Inventario INVA "
					+ " INNER JOIN TransferenciaAlmacen TA "
						+ " ON INVA.CLI_ID = TA.CLI_ID "
						+ " AND INVA.ALM_Id = TA.TA_Start_Warehouse_ID "
				+ " WHERE INVA.Inv_EstatusCG20 IN (1, 14) "   //  /* 1: Disponible, 14:asignada */  
					+ " AND INVA.Inv_EsApartado = 0 "
					+ " AND INVA.INV_EnTransferencia = 0  "
					+ " AND INVA.Inv_Dummy = 0  "
					+ " AND INVA.PRO_ID = " + rqIntITAProId   //   /* PRODUCTO  */  
					+ " AND TA.TA_ID = " + rqIntITATAId       //   /* TRANSFERENCIA */  
					
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
							+ "WHERE INVA.Inv_EstatusCG20 IN (1, 14) "  // /* 1: Disponible, 14, Asignada */ 
								+ "AND INVA.Inv_EsApartado = 1 "
								+ "AND INVA.INV_EnTransferencia = 0 "
								+ "AND INVA.Inv_Dummy = 0 "
								+ "AND INVA.PRO_ID = " + intPROID   // /* PRODUCTO  */ 
								+ "AND TA.TA_ID = " + rqIntETATAId  // /* TRANSFERENCIA */ 					
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
			+ "WHERE TA_ID = " + rqIntETATAId + " "
			
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
		+ " FROM TransferenciaAlmacen_Articulo_Picking TAS "
			+ " INNER JOIN Producto PRO "
				+ " ON TAS.PRO_ID = PRO.PRO_ID "
		+ " WHERE TAS.TA_ID = " + rqIntVAPTA_ID  
			+ " AND TAS.TAA_ID = " + rqIntVAPTAA_ID 
			+ " AND TAS.PRO_ID = " + rqIntVAPPRO_ID 
		+ " ORDER BY TAS.TAS_ID ASC "
		
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
			+ " FROM Inventario INV "
			+ " WHERE CASE "
					+ " WHEN " + rqIntBAPTTR_ID + " = " + cTTRIngreso   // /* Ingreso */  
						+ " AND " + rqIntBAPALM_ID + " <> " + cAlmLyde  
						+ " AND INV.Inv_EstatusCG20 IN (1, 2, 3, 4, 14) "
                                    // /* 1: Disponible, 2: Cuarentena, 3: Dañado, 4: Descompuesto */ 
						+ " THEN 1 "
					+ " WHEN " + rqIntBAPTTR_ID + " = " + cTTREgreso  //   /* Egreso */  
						+ " AND " + rqIntBAPALM_ID + " = " + cAlmLyde  
						+ " AND INV.Inv_EstatusCG20 IN (1, 14) "    // /* 1: Disponible */  
						+ " THEN 1 "
					+ " WHEN " + rqIntBAPTTR_ID + " = " + cTTRSucursales //  /* Almacenes */ 
						+ " AND " + rqIntBAPALM_ID + " <> " + cAlmLyde  
						+ " AND INV.Inv_EstatusCG20 IN (1, 14) "    // /* 1: Disponible */ 
						+ " THEN 1 "
					+ "ELSE 0 "
				+ " END = 1 "
				+ " AND INV.INV_EnTransferencia = 0  "
				+ " AND INV.Inv_Dummy = 0 "
				+ " AND INV.CLI_ID = " + rqIntBAPCLI_ID 
				+ " AND INV.Pro_ID = " + rqIntBAPPRO_ID 
				+ " AND INV.ALM_ID = " + rqIntBAPALM_ID 
				+ " AND INV.INV_Serie LIKE '%" + rqStrBAPPRO_Serie + "%' "
		
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
			+ " WHERE TA_ID = " + rqIntESATA_ID  
				+ " AND TAA_ID = " + rqIntESATAA_ID 
				+ " AND TAS_ID = " + rqStrESATAS_ID  
		 
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
				+ " SET TA_EstatusCG51 = 2  "   // /* Solicitud Terminada */  
				+ " WHERE TA_ID = " + rqIntTA_ID  
		
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
			
			sqlETABCa = "SELECT TAA_Cantidad, PRO_ID  "
				+ " FROM TransferenciaAlmacen_Articulos "
				+ " WHERE TA_ID = " + rqIntTA_ID 
			
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
							+ "WHERE INVA.Inv_EstatusCG20 IN (1) "
								+ "AND INVA.Inv_EsApartado = 1 "
								+ "AND INVA.INV_EnTransferencia = 0 "
								+ "AND INVA.Inv_Dummy = 0 "
								+ "AND INVA.PRO_ID = " + intPROID  
								+ "AND TA.TA_ID = " + rqIntTA_ID  				
							+ "ORDER BY INVA.INV_LoteIngreso ASC "
								+ ", INVA.Inv_FechaRegistro ASC "
						+ "); "
				
				Ejecuta(sqlETADa, cxnIntTipo)
				
				rsETABCa.MoveNext
				
			}
			rsETABCa.close
		}
		
		sqlETAAP = "DELETE FROM TransferenciaAlmacen_Articulo_Picking "
			+ "WHERE TA_ID = " + rqIntTA_ID   
		
		sqlETAA = "DELETE FROM TransferenciaAlmacen_Articulos "
			+ "WHERE TA_ID = " + rqIntTA_ID  
		
		sqlETA = "DELETE FROM TransferenciaAlmacen "
			+ "WHERE TA_ID = " + rqIntTA_ID  
		
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

	// HA ID: 5 INI  Recepcion de Transferencia
	case 13: {
		
		var TA_ID = Parametro("TA_ID", -1)
		var rqIntIDUsuario = Parametro("IDUsuario", -1)

		var errError = 0
		var errMensaje = "Se ha actualizado correctamente la recepcion"

		var jsonTAAct = '{}'

		var sqlTAAct = "UPDATE TransferenciaAlmacen "
			         + " SET TA_Recibido = 1 "
				     + ", TA_RecibioUsuario = " + rqIntIDUsuario 
				     + ", TA_RecibidoFecha = GETDATE() "
			         + " WHERE TA_ID = " + TA_ID 

		try {

			Ejecuta(sqlTAAct, cxnIntTipo)

		} catch(err){
			errError = 1
			errMensaje = "No Se ha actualizado la recepcion"
		}
//==============================================================================================    
        //Raul Jr.- El historico de los estatus solo se manejan en el trigger de TransferenciaAlamcen
		//06/07/2021
//		var sqlTAHist = "IF NOT EXISTS(SELECT 1 FROM TransferenciaAlmacen_Historico "
//                      + " WHERE TA_EstatusCG51 = 10 AND TA_Reintento = 1 AND TA_ID = " + TA_ID + " ) "
//                      + " BEGIN "
//                      + " INSERT INTO TransferenciaAlmacen_Historico ( TA_ID, TA_EstatusCG51, TA_FechaRegistro, TA_IDUnica ) "
//                      + " VALUES ( " + TA_ID + ", 10, GETDATE() , " + rqIntIDUsuario + ") "
//                      + " END  ELSE  BEGIN "
//                      + " UPDATE TransferenciaAlmacen_Historico "
//			          + " SET TA_FechaRegistro = GETDATE() "
//                      + " ,TA_Reintento = 99 "
//			          + " WHERE TA_ID = " + TA_ID  
//                      + " AND TA_EstatusCG51 = 10 "
//                      + " END"
//            
//
//            
//           Ejecuta(sqlTAHist, cxnIntTipo)
//==============================================================================================    

		var jsonTAAct = '{'
				+ ' "Error": "' + errError + '"'
				+ ', "Mensaje": "' + errMensaje + '"'
			+ '}'
			
		Response.Write(jsonTAAct)

	} break;
        case 14: {
		
		var TA_ID = Parametro("TA_ID", -1)
		var IDUsuario = Parametro("IDUsuario", -1)
            

		var errError = 0
        var errNumero = 0
		var errMensaje = "Se ha actualizado correctamente la recepcion"
            
        var sCondicion = " Doc_ID = 27 AND TA_ID = " + TA_ID
        var Doc27 = BuscaSoloUnDato("COUNT(*)","TransferenciaAlmacen_Documentos",sCondicion,0,0)    
            

		if(Doc27 >0){
            var sql14 = "UPDATE TransferenciaAlmacen "
                + " SET TA_RemisionRecibida = 1 "
                    + ", TA_RemisionRecibidaUsuario = " + IDUsuario  
                    + ", TA_RemisionRecibidaFecha = GETDATE() " 
                + " WHERE TA_ID = " + TA_ID              

            try{

                Ejecuta(sql14, 0)

            } catch(err){
                errError = 1
                errMensaje = "Ocurrio un error cuando se actualizaba el registro " 
                errMensaje += err.description 
		        errNumero = err.number 
		        errMensaje += ", " + err.message 
            }
        } else {
            errError = 1
            errMensaje = "No se encontro un documento del tipo Nota de remision"
        }

            

            
		var jsonTAAct = '{'
				+ ' "Error": ' + errError + ''
				+ ', "Mensaje": "' + errMensaje + '"'
                + ', "Numero": "' + errNumero + '"'
			+ '}'
			
		Response.Write(jsonTAAct)

	}  break;
       case 15: {

		var IdUsuario = Parametro("IdUsuario", -1)
		var TA_ID = Parametro("TA_ID", -1)
		var Comn_ID = Parametro("Comn_ID", -1)
		var Titulo = utf8_decode(Parametro("Titulo", ""))
		var Comentario = utf8_decode(Parametro("Comentario", ""))
		
		var errError = 0
		
		var sqlComnIns = "INSERT INTO Comentario( Comn_Padre, Comn_AsuntoCG26, Comn_EstatusCG27, Comn_Titulo "
				+ ", Comn_Observacion, Comn_TipoCG28, Comn_FechaComentario, IDUsuario, TA_ID ) "
			+ "VALUES ( " + Comn_ID  
                          + ", 5 "    //   /*Transferencia*/
                          + ", 1 "    //   /*Abierto*/ 
                          + ", '" + Titulo + "' "
                          + ", '" + Comentario + "' "
                          + ", 2 "    //  /*Solo una respuesta*/ 
                          + ", GETDATE() "
                          + ", " + IdUsuario  
                          + ", " + TA_ID  
                    + ") "
		
		//Response.Write(sqlComnIns)
		
		try{
			
			Ejecuta(sqlComnIns, 0)
			
		} catch(err){
			
			errError = 1
		}
		
		var jsonComIns = '{'
				+ ' "Error": "' + errError + '" '
			+ '}'
		
		Response.Write(jsonComIns)
		
       }
       break; 
	
	case 16: {

		var rqIntTA_ID = Parametro("TA_ID", -1)
		var rqStrTAA_IDs = Parametro("TAA_IDs", "")

		var jsonRespuesta = '['
		
		var sqlExpTra = "SELECT TA_Folio,Pro_SKU,Pro_Nombre,Tas_Serie, Replace(Alm_nombre,' ','_') as Almacen " +
						" FROM TransferenciaAlmacen a,TransferenciaAlmacen_Articulo_Picking b, Producto c, Almacen al "+
						" WHERE a.TA_ID = "+rqIntTA_ID+
						" AND a.TA_ID = b.TA_ID and a.TA_End_Warehouse_ID = al.Alm_ID "+
						" AND b.Pro_ID = c.Pro_ID "+
						" AND b.TAA_ID IN ( "
								+ "SELECT Value "
								+ "FROM dbo.fn_Split('" + rqStrTAA_IDs + "', ',') "
							+ ") " 
        
 

//		var sqlExpTra = "SELECT TA.TA_Folio AS Folio "
//				+ ", Pro.Pro_SKU AS SKU "
//				+ ", Pro.Pro_Nombre AS Nombre "
//				+ ", TAA.TAA_Cantidad AS Cantidad "
//				+ ", TAA.TAA_CantidadPickiada AS CantidadPicking "
//				+ ", TAS.TAS_Serie AS Serie "
//			+ "FROM TransferenciaAlmacen TA "
//				+ "INNER JOIN TransferenciaAlmacen_Articulos TAA "
//					+ "ON TA.TA_ID = TAA.TA_ID "
//				+ "INNER JOIN TransferenciaAlmacen_Articulo_Picking TAS "
//					+ "ON TAA.TA_ID = TAS.TA_ID "
//					+ "AND TAA.TAA_ID = TAS.TAA_ID "
//				+ "LEFT JOIN Producto Pro "
//					+ "ON TAA.Pro_ID = Pro.Pro_ID "
//			+ "WHERE TAA.TA_ID = " + rqIntTA_ID + " "
//				+ "AND TAA.TAA_ID IN ( "
//						+ "SELECT Value "
//						+ "FROM dbo.fn_Split('" + rqStrTAA_IDs + "', ',') "
//					+ ") " 

		var rsExpTra = AbreTabla(sqlExpTra, 1, cxnIntTipo)

		var i = 0

		while( !(rsExpTra.EOF) ){

			jsonRespuesta += ( i > 0 ) ? ',' : '';

			jsonRespuesta += '{'
					+ '"Folio": "' + rsExpTra("TA_Folio").Value + '" '
					+ ', "SKU": "' + rsExpTra("Pro_SKU").Value + '" '
					+ ', "Nombre": "' + rsExpTra("Pro_Nombre").Value + '" '
//					+ ', "Cantidad": "' + rsExpTra("Cantidad").Value + '" '
//					+ ', "CantidadPicking": "' + rsExpTra("CantidadPicking").Value + '" '
					+ ', "Serie": "' + rsExpTra("Tas_Serie").Value + '" '
                    + ', "Destino": "' + rsExpTra("Almacen").Value + '" '
				+ '}'

			i++

			rsExpTra.MoveNext()
		}

		rsExpTra.Close()

		jsonRespuesta += ']'

		Response.Write(jsonRespuesta)

	} break;
	case 17: {

		var TA_ID = Parametro("TA_ID", -1)
		var IDUsuario = Parametro("IDUsuario", -1)
		var TA_MotivoCancelacion = utf8_decode(Parametro("TA_MotivoCancelacion", ""))
		var Respuesta = ""


		var CancelaUpdate = "UPDATE TransferenciaAlmacen "
			CancelaUpdate += " SET TA_EstatusCG51 = 11 "
			CancelaUpdate += " ,TA_Cancelada = 1 "
			CancelaUpdate += " ,TA_MotivoCancelacion = '"+TA_MotivoCancelacion+"' "
			CancelaUpdate += " ,[TA_CancelacionFecha] = getdate() "
			CancelaUpdate += " ,[TA_CancelacionUsuario] = "+IDUsuario
			CancelaUpdate += " WHERE TA_ID = "+TA_ID 
			
			if(Ejecuta(CancelaUpdate,0)){
				Respuesta = '{"result":1,"message":"Cancelaci&oacute;n exitosa"}'
			}else{
				Respuesta = '{"result":-1,"message":"Ocurri&oacute; un error al momento de cancelar","SQL":"'+CancelaUpdate+'"}'
			}
		Response.Write(Respuesta)

	} break;
	case 18: //cambio de hora a un estatus de una transferencia
        {

		var TA_ID = Parametro("TA_ID", -1)
		var IDUsuario = Parametro("IDUsuario", -1)
		var sHora = Parametro("Hora", "")
        var sFecha = Parametro("Fecha", "")
        var TAH_ID = Parametro("TAH_ID", 0)
		var Respuesta = ""
        var bPasa = true

                
        sHora = sHora.substring(0, 5)  
        regex = /^([0-9]|[0-1][0-9]|2[0-3]):([0-5]|[0-5][0-9])$/;
        if ( !regex.test(sHora) ){
            Respuesta = '{"result":-1,"message":"La hora no esta en un formato correcto "' + sHora + '" "}'
            bPasa = false
        }
            
        regex = /^([0-2][0-9]|3[0-1])(\/|-)(0[1-9]|1[0-2])\2(\d{4})$/;
        if ( !regex.test(sFecha) ){
            Respuesta = '{"result":-1,"message":"La fecha no esta en un formato correcto "' + sFecha + '" "}'
            bPasa = false
        }    
            
        if(bPasa) {    
            sFecha = CambiaFormatoFecha(sFecha,"dd/mm/yyyy",FORMATOFECHASERVIDOR)
            sHora += ":" + Math.floor((Math.random()*59) + 1)
            sHora += ":" + Math.floor((Math.random()*600) + 1)
            
            var ActualizaFecha = "UPDATE TransferenciaAlmacen_Historico "
                               + " SET TA_FechaRegistro = '" + sFecha + " " + sHora + "'"
                               + " , TA_IDUnica = " + IDUsuario
                               + " WHERE TA_ID = " + TA_ID 
                               + " AND TAH_ID = " + TAH_ID

                if(Ejecuta(ActualizaFecha,0)){
                    Respuesta = '{"result":1,"message":"Se cambio la fecha correctamente"}'
                } else {
                    Respuesta = '{"result":-1,"message":"No se pudo cambiar la fecha, ocurrio un error al ejecutar escribir en la bd"}'
                }
        }
		Response.Write(Respuesta)

	} break;  
	case 19: {
		
		/* HA ID: 6 INI Se agrega validación y elementos de proceso */

		var rqIntTA_ID = Parametro("TA_ID", -1)
		var rqIntEnt_Est_ID = Parametro("Ent_Est_ID", -1)
		var rqIntIDUsuario = Parametro("IDUsuario", -1)
		var rqStrEve_Comentario = Parametro("Eve_Comentario", "")

		var intErrorNumero = 0
		var intErrorDescripcion = ""

		var jsonRespuesta = '{}'

		/* HA ID: 8 Se agrega validación de Crear Incidencia */
		var sqlEve = "EXEC SPR_Entrega_Evento "
			  + "@Opcion = 2000 "
			+ ", @TA_ID = " + ( (rqIntTA_ID > -1) ? rqIntTA_ID : "NULL" ) + " "
			+ ", @Ent_Est_ID = " + ( (rqIntEnt_Est_ID > -1) ? rqIntEnt_Est_ID : "NULL" ) + " "
			+ ", @Eve_Comentario = " + ( (rqStrEve_Comentario.length > 0) ? "'" + rqStrEve_Comentario + "'" : "NULL" ) + " "
			+ ", @CrearIncidencia = 1 "
			+ ", @IDUsuario = " + rqIntIDUsuario + " "

		var rsEve = AbreTabla(sqlEve, 1, cxnIntTipo)

		if( !(rsEve.EOF) ){
			intErrorNumero = rsEve("ErrorNumero").Value
			strErrorDescripcion = rsEve("ErrorDescripcion").Value
		} else {
			intErrorNumero = 1
			strErrorDescripcion = "No se ejecuto el procedimiento de Actualizacion"
		}

		rsEve.Close()

		var jsonRespuesta = '{'
				+ '"Error": {'
					  + '"Numero": "' + intErrorNumero + '"'
					+ ', "Descripcion": "' + strErrorDescripcion + '"'
				+ '}'
			+ '}'

		Response.Write(jsonRespuesta)

		/* HA ID: 6 FIN */

	} break;
	case 20: {
		
		var TA_ID = Parametro("TA_ID", -1)
		var IDUsuario = Parametro("IDUsuario", -1)

		var result = -1
		var message = ""

		try {
			var sqlTAAct = "UPDATE TransferenciaAlmacen "
						 + " SET TA_EstatusCG51 = 10 "
						 + ", TA_UltimoUsuarioModifico = " + IDUsuario 
						 + " WHERE TA_ID = " + TA_ID 
						 
			Ejecuta(sqlTAAct,0)
			
			result = 1
			message = "El estatus ha cambiado correctamente"

		} catch(err){
			errError = -1
			errMensaje = "Ocurri&oacute; un error"
		}

		var respuesta = '{'
				+ ' "result": "' + result + '"'
				+ ', "message": "' + message + '"'
			+ '}'
			
		Response.Write(respuesta)

	} break;
	
	/* HA ID: 6 INI Agregado de Opciono para Siniestro  de serie */
	case 22: {

		var rqIntTA_ID = Parametro("TA_ID", -1)
		var rqIntTAA_ID = Parametro("TAA_ID", -1)
		var rqIntTAS_ID = Parametro("TAS_ID", -1)

		/* HA ID: 8 Se cambia Nombre TAS_Siniestrado a TAS_EsSiniestro */
		var rqIntTAS_EsSiniestro = Parametro("TAS_EsSiniestro", -1)
		var rqIntIDUsuario = Parametro("IDUsuario", -1)

		var intErrorNumero = 0
		var intErrorDescripcion = ""

		var bolRecargar = 0;

		var jsonRespuesta = '{}'

		/* HA ID: 8 Se cambia Nombre TAS_Siniestrado a TAS_EsSiniestro */
		var sqlEveSin = "EXEC SPR_Entrega_Evento "
			  + "@Opcion = 3100 "
			+ ", @TA_ID = " + ( (rqIntTA_ID > -1) ? rqIntTA_ID : "NULL" ) + " "
			+ ", @TAA_ID = " + ( (rqIntTAA_ID > -1) ? rqIntTAA_ID : "NULL" ) + " "
			+ ", @TAS_ID = " + ( (rqIntTAS_ID > -1) ? rqIntTAS_ID : "NULL" ) + " "
			+ ", @TAS_EsSiniestro = " + ( (rqIntTAS_EsSiniestro > -1) ? rqIntTAS_EsSiniestro : "NULL" ) + " "			
			+ ", @IDUsuario = " + rqIntIDUsuario + " "

		var rsEveSin = AbreTabla(sqlEveSin, 1, cxnIntTipo)

		if( !(rsEveSin.EOF) ){
			intErrorNumero = rsEveSin("ErrorNumero").Value
			strErrorDescripcion = rsEveSin("ErrorDescripcion").Value
			bolRecargar = rsEveSin("Recargar").Value
		} else {
			intErrorNumero = 1
			strErrorDescripcion = "No se ejecuto el procedimiento de Actualizacion"
		}

		rsEveSin.Close()

		var jsonRespuesta = '{'
				  + '"Error": {'
					  + '"Numero": "' + intErrorNumero + '"'
					+ ', "Descripcion": "' + strErrorDescripcion + '"'
				+ '}'
				+ ', "Registro": {'
					+ '"Recargar": "' + bolRecargar + '"'
				+ '}'
			+ '}'

		Response.Write(jsonRespuesta)

	} break;
	/* HA ID: 6 FIN */

	/* HA ID: 7 INI Cierre de Siniestro */
	case 23: {

		var rqIntTA_ID = Parametro("TA_ID", -1);
		var rqIntIDUsuario = Parametro("IDUsuario", -1);

		var intErrorNumero = 0;
		var intErrorDescripcion = "";

		var bolRecargar = 0;

		var jsonRespuesta = '{}'

		var sqlSinCie = "EXEC SPR_Entrega_Evento "
			  + "@Opcion = 3110 "
			+ ", @TA_ID = " + ( (rqIntTA_ID > -1) ? rqIntTA_ID: "NULL" ) + " "
			+ ", @IDUsuario = " + rqIntIDUsuario + " "
		
		var rsSinCie = AbreTabla(sqlSinCie, 1, cxnIntTipo)

		if( !(rsSinCie.EOF) ){
			intErrorNumero = rsSinCie("ErrorNumero").Value
			strErrorDescripcion = rsSinCie("ErrorDescripcion").Value
		} else {
			intErrorNumero = 1
			strErrorDescripcion = "No se ejecuto el procedimiento de Actualizacion"
		}

		rsSinCie.Close()

		var jsonRespuesta = '{'
				  + '"Error": {'
					  + '"Numero": "' + intErrorNumero + '"'
					+ ', "Descripcion": "' + strErrorDescripcion + '"'
				+ '}'
			+ '}'

		Response.Write(jsonRespuesta)

	} break;
	/* HA ID: 7 FIN */

	/* HA ID: 8 INI Agregado de Opcion para Entrega Parcial de serie y de Cierre de Seleccion de Entrega Parcial */
	case 24: {

		var rqIntTA_ID = Parametro("TA_ID", -1)
		var rqIntTAA_ID = Parametro("TAA_ID", -1)
		var rqIntTAS_ID = Parametro("TAS_ID", -1)
		var rqIntTAS_EsEntregaParcial = Parametro("TAS_EsEntregaParcial", -1)
		var rqIntIDUsuario = Parametro("IDUsuario", -1)

		var intErrorNumero = 0
		var intErrorDescripcion = ""

		var jsonRespuesta = '{}'

		var sqlEveSin = "EXEC SPR_Entrega_Evento "
			  + "@Opcion = 3101 "
			+ ", @TA_ID = " + ( (rqIntTA_ID > -1) ? rqIntTA_ID : "NULL" ) + " "
			+ ", @TAA_ID = " + ( (rqIntTAA_ID > -1) ? rqIntTAA_ID : "NULL" ) + " "
			+ ", @TAS_ID = " + ( (rqIntTAS_ID > -1) ? rqIntTAS_ID : "NULL" ) + " "
			+ ", @TAS_EsEntregaParcial = " + ( (rqIntTAS_EsEntregaParcial > -1) ? rqIntTAS_EsEntregaParcial : "NULL" ) + " "			
			+ ", @IDUsuario = " + rqIntIDUsuario + " "

		var rsEveSin = AbreTabla(sqlEveSin, 1, cxnIntTipo)

		if( !(rsEveSin.EOF) ){
			intErrorNumero = rsEveSin("ErrorNumero").Value
			strErrorDescripcion = rsEveSin("ErrorDescripcion").Value
		} else {
			intErrorNumero = 1
			strErrorDescripcion = "No se ejecuto el procedimiento de Actualizacion"
		}

		rsEveSin.Close()

		var jsonRespuesta = '{'
				  + '"Error": {'
					  + '"Numero": "' + intErrorNumero + '"'
					+ ', "Descripcion": "' + strErrorDescripcion + '"'
				+ '}'
			+ '}'

		Response.Write(jsonRespuesta)

	} break;

	case 25: {

		var rqIntTA_ID = Parametro("TA_ID", -1);
		var rqIntIDUsuario = Parametro("IDUsuario", -1);

		var intErrorNumero = 0;
		var intErrorDescripcion = "";

		var bolRecargar = 0;

		var jsonRespuesta = '{}'

		var sqlSinCie = "EXEC SPR_Entrega_Evento "
			  + "@Opcion = 3111 "
			+ ", @TA_ID = " + ( (rqIntTA_ID > -1) ? rqIntTA_ID: "NULL" ) + " "
			+ ", @IDUsuario = " + rqIntIDUsuario + " "
		
		var rsSinCie = AbreTabla(sqlSinCie, 1, cxnIntTipo)

		if( !(rsSinCie.EOF) ){
			intErrorNumero = rsSinCie("ErrorNumero").Value
			strErrorDescripcion = rsSinCie("ErrorDescripcion").Value
		} else {
			intErrorNumero = 1
			strErrorDescripcion = "No se ejecuto el procedimiento de Actualizacion"
		}

		rsSinCie.Close()

		var jsonRespuesta = '{'
				  + '"Error": {'
					  + '"Numero": "' + intErrorNumero + '"'
					+ ', "Descripcion": "' + strErrorDescripcion + '"'
				+ '}'
			+ '}'

		Response.Write(jsonRespuesta)

	} break;
	/* HA ID: 7 FIN */
    
}
%>
