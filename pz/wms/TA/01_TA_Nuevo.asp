<%@LANGUAGE="JAVASCRIPT" CODEPAGE="65001"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
// HA ID: 1 2020-jun-24 Creación de Archivo: Formualrio completo de Nueva Transferencia
// HA ID: 2 2020-jul-06 Numero de Serie del Articulo: Agregado de Modal y Sección de Numeros de Serie Seleccionados

var cxnIntTipo = 0 
var intAlmLyde = 2	//Almacén interno LYDE
var intCliLyde = 1 //Cliente LYDE

var strRutaBaseTem = "/Template/inspina/";
var strRutaBaseTA = "/pz/wms/TA/";

var intIdSis = Parametro("SistemaActual", -1) 
var intIdCli = Parametro("Cli_ID", 1)

var cIntIdSisLyde = 19			//Identificador de Sistema de LYDE
var cIntIdSisIzzi = 29			//Identificador de Sistema de IZZI

//intIdSis = cIntIdSisIzzi //prueba

switch( parseInt(intIdSis) ){
	//LYDE
	case cIntIdSisLyde:{
		intRedVen = 2529 //Menú de búsqueda
	} break;
	//IZZI
	case cIntIdSisIzzi:{
		intRedVen = 1112 //Menú de búsqueda
	} break;
}

var bolEsCliExt = (parseInt(intIdCli) != intCliLyde)

%>
	<link href="<%= strRutaBaseTem %>css/plugins/select2/select2.min.css" rel="stylesheet">
	<link href="<%= strRutaBaseTem %>css/plugins/datapicker/datepicker3.css" rel="stylesheet">
	
	<!-- Select2 -->
	<script src="<%= strRutaBaseTem %>js/plugins/select2/select2.full.min.js"></script>
    
	<!-- Data picker -->
    <script src="<%= strRutaBaseTem %>js/plugins/datapicker/bootstrap-datepicker.js"></script>
	
    <!-- Input Mask-->
    <script src="<%= strRutaBaseTem %>js/plugins/jasny/jasny-bootstrap.min.js"></script>
    
	<script type="text/javascript">
	
		var strRutaBaseTA = "<%= strRutaBaseTA %>";
		var intAlmLyde = <%= intAlmLyde %>;
		var intRedVen = <%= intRedVen %>;
		var intIdSis = <%= intIdSis %>;
		var intCliLyde = <%= intCliLyde %>;
		
	</script>
	
	<!-- Js -->
	<script src="<%= strRutaBaseTA %>js/TA_Nuevo.js"></script>
	
	<div class="row">
		<div class="col-sm-8">
			<div class="ibox ">
				<div class="ibox-content" style="overflow: auto;">
			   
						<div class="clients-list">
							
							<input type="hidden" id="TA_ID" name="TA_ID" value="">
							<input type="hidden" id="TA_Folio" value="">
							
							<div class="tab-content">
								<div id="tab-1" class="tab-pane active">
									<div class="ibox-content" style="padding-top: 2px; padding-bottom: 198px;">
										<div class="ibox">
											<div class="col-md-12 forum-item active">
												<div class="pull-right">
													<div class="tooltip-demo">
														<button type="button" class="btn btn-success" onclick="Transferencia.ActivarSeccion(Transferencia.Seccion.Destino)">
															Siguiente <i class="fa fa-chevron-right" style="color: white;"></i>
														</button>
													</div>
												</div>
											
												<div class="col-md-col-md-offset-0 forum-icon">
													<i class="fa fa-list-ul"></i>
												</div>
												<a href="#" class="forum-item-title" style="pointer-events: none">
													<h3>Tipo de Transferencia y Cliente</h3>
												</a>
												<div class="forum-sub-title">Seleccionar el Tipo de Trasferencias y el cliente a quien se realizar&aacute; la transferencia</div>
												
												<!--br-->
												<div class="hr-line-dashed"></div>
												
												<div class="form-group col-md-12 row border-bottom">
													<label class="col-form-label col-md-12 p-3">
														<i class="fa fa-list-ul fa-lg"></i> Tipo
													</label>
												</div>
												
												<!-- row&nbsp;1 - renglon -->
												<div class="form-group">
													<div class="col-md-12">
														<div class="col">
<%
var sqlTipTra = "SELECT Sec_ID "
		+ ", Cat_ID "
		+ ", Cat_Nombre "
	+ "FROM CAT_Catalogo "
	+ "WHERE SEC_ID = 65 "

var rsTipTra = AbreTabla(sqlTipTra, 1, cxnIntTipo)

while( !(rsTipTra.EOF) ){
%>
															<div class="form-check">
																<input class="form-check-input" type="radio" name="TipoTransferencia" onclick="Transferencia.Seleccionar();"
																 id="TipoTransferencia_<%= rsTipTra("Cat_ID") %>" value="<%= rsTipTra("Cat_ID") %>">
																
																<label class="form-check-label" id="lblTipoTransferencia_<%= rsTipTra("Cat_ID")%>" for="TipoTransferencia_<%= rsTipTra("Cat_ID") %>">
																	<%= rsTipTra("Cat_Nombre") %>
																</label>
															</div>
<%
	rsTipTra.MoveNext()
}

rsTipTra.close()
%>
														</div>
													</div>
												</div>
													
												<div class="form-group col-md-12 row">
													
												</div>
<%
if( !(bolEsCliExt) ){
%>
												<div class="form-group col-md-12 row border-bottom">
													<label class="col-form-label col-md-12 p-3">
														<i class="fa fa-user-circle-o fa-lg"></i> Cliente
													</label>
												</div>
												
												<div class="form-group col-md-12 row">
													<label for="selCliente" class="col-form-label col-md-2">
														Cliente
													</label>
													<div class="col-md-4">
														<select id="selCliente" class="form-control col-md-4" onChange="Cliente.Seleccionar();">
															<option value="0">(SELECCIONAR)</option>
<%
	var sqlCli = "SELECT Cli_ID "
	+ ", Cli_Nombre "
	+ "FROM Cliente "
	+ "WHERE Cli_ID NOT IN ( " + intCliLyde + " ) "

	var rsCli = AbreTabla(sqlCli, 1, cxnIntTipo)

	while( !(rsCli.EOF) ){
%>
															<option value="<%= rsCli("Cli_ID") %>">
																<%= rsCli("Cli_Nombre") %>
															</option>
<%
		rsCli.MoveNext()
	}

	rsCli.close()
%>
														</select>
													</div>
												</div>
<%
} else {
%>
												<input type="hidden" id="selCliente" value="<%= intIdCli %>">
<%
}
%>												
												<div class="form-group col-md-12 row border-bottom">
													<label class="col-form-label col-md-12 p-3">
														<i class="fa fa-calendar"></i> Fechas
													</label>
												</div>
												
												<div class="form-group col-md-12 row">
													<label for="inpFechaEntrega" class="col-form-label col-md-2">
														Fecha de Entrega
													</label>
													<div class="input-group date col-md-4">
														<span class="input-group-addon">
															<i class="fa fa-calendar"></i>
														</span>
														<input type="text" id="inpFechaEntrega" class="form-control" maxlength="12" autocomplete="off" readonly="readonly">
													</div>
												</div>
												
											</div>
										</div>
									</div>
								</div>
								<div id="tab-2" class="tab-pane">
									<div class="ibox-content" style="padding-top: 2px; padding-bottom: 198px;">
										<div class="ibox">
											<div class="col-md-12 forum-item active">
											
												<div class="pull-right">
													<div class="tooltip-demo">
														<button type="button" class="btn btn-success" onclick="Transferencia.VisualizarSeccion(Transferencia.Seccion.Tipo)">
															<i class="fa fa-chevron-left" style="color: white;"></i> Anterior
														</button>
														<button type="button" class="btn btn-success" onclick="Transferencia.ActivarSeccion(Transferencia.Seccion.Articulo)">
															Siguiente <i class="fa fa-chevron-right" style="color: white;"></i>
														</button>
													</div>
												</div>
											
												<div class="col-md-col-md-offset-0 forum-icon">
													<i class="fa fa-map-marker"></i>
												</div>
												<a href="#" class="forum-item-title" style="pointer-events: none">
													<h3>Origen - Destino</h3>
												</a>
												<div class="forum-sub-title">Seleccionar el almac&eacute;n de origen y el almac&eacute;n de destino</div>
												
												<!--br-->
												<div class="hr-line-dashed"></div>

												<div class="form-group col-md-12 row border-bottom">
													<label class="col-form-label col-md-12 p-3">
														<i class="fa fa-home fa-lg"></i> Almac&eacute;n
													</label>
												</div>

												<!-- row&nbsp;1 - renglon -->
												<div class="form-group col-md-12 row">
													<label for="selOrigenAlmacen" class="classOrigen col-form-label col-md-2">
														Origen
													</label>
													<div class="col-md-4 classOrigen">
														<select id="selOrigenAlmacen" class="form-control" style="width: 220px;" 
														 onChange="Almacen.Seleccionar(Almacen.Tipo.Origen);">

														</select>
													</div>
													<label for="selDestinoAlmacen" class="classDestino col-form-label col-md-2">
														Destino
													</label>
													<div class="col-md-4 classDestino">
														<select id="selDestinoAlmacen" class="form-control" style="width: 220px;"
														 onChange="Almacen.Seleccionar(Almacen.Tipo.Destino);">

														</select>
													</div>

												</div>
												
												<div class="form-group col-md-12 row border-bottom">
													<label class="col-form-label col-md-12 p-3">
														<i class="fa fa-user fa-lg"></i> Responsables
													</label>
												</div>
												
												<div class="form-group col-md-12 row">
													
													<label class="col-form-label col-md-2 classOrigen">
														Origen
													</label>
													<div class="col-md-4 classOrigen">
														<input type="text" id="inpOrigenResponsable" class="form-control" 
														placeholder="Responsable Origen" maxlength="150" autocomplete="off">
													</div>
													
													<label class="col-form-label col-md-2 classDestino">
														Destino
													</label>
													<div class="col-md-4 classDestino">
														<input type="text" id="inpDestinoResponsable" class="form-control" 
														 placeholder="Responsable Destino" maxlength="150" autocomplete="off">
													</div>

												</div>
												
												<div class="form-group col-md-12 row border-bottom">
													<label class="col-form-label col-md-12 p-3">
														<i class="fa fa-phone fa-lg"></i> Tel&eacute;fonos
													</label>
												</div>
												
												<div class="form-group col-md-12 row">
												
													<label class="col-form-label col-md-2 classOrigen">
														Origen
													</label>
													<div class="col-md-4 classOrigen">
														<input type="text" id="inpOrigenTelefono" class="form-control" data-mask="(99) 9999-9999"
														 placeholder="Tel&eacute;fono Origen" maxlength="150" autocomplete="off">
													</div>
													
													<label class="col-form-label col-md-2 classDestino">
														Destino
													</label>
													<div class="col-md-4 classDestino">
														<input type="text" id="inpDestinoTelefono" class="form-control" 
														placeholder="Tel&eacute;fono Destino" maxlength="150" autocomplete="off" data-mask="(99) 9999-9999">
													</div>
													
												</div>
												
												<div class="form-group col-md-12 row border-bottom">
													<label class="col-form-label col-md-12 p-3">
														<i class="fa fa-envelope fa-lg"></i> Email
													</label>
												</div>
												
												<div class="form-group col-md-12 row">
												
													<label class="col-form-label col-md-2 classOrigen">
														Origen
													</label>
													<div class="col-md-4 classOrigen">
														<input type="email" id="inpOrigenEmail" class="form-control"
														 placeholder="Email Origen" maxlength="150" autocomplete="off">
													</div>
													
													<label class="col-form-label col-md-2 classDestino">
														Destino
													</label>
													<div class="col-md-4 classDestino">
														<input type="email" id="inpDestinoEmail" class="form-control" 
														placeholder="Email Destino" maxlength="150" autocomplete="off">
													</div>
													
												</div>
												
												<div class="form-group col-md-12 row border-bottom">
													<label class="col-form-label col-md-12 p-3">
														<i class="fa fa-map-o fa-lg"></i> Direccion
													</label>
												</div>
												
												<div class="form-group col-md-12 row">
												
													<label class="col-form-label col-md-2 classOrigen">
														Origen
													</label>
													<span id="inpOrigenDireccionCompleta" class="col-form-label col-md-4 classOrigen text-success">
														
													</span>
													
													<label class="col-form-label col-md-2 classDestino">
														Destino
													</label>
													<span id="inpDestinoDireccionCompleta" class="col-form-label col-md-4 classDestino text-success">
														
													</span>
													
												</div>
												
											</div>
											
										</div>
										
									</div>
								
								</div>
								<div id="tab-3" class="tab-pane">
										
									<div class="ibox-content" style="padding-top: 2px; padding-bottom: 198px;">
										<div class="ibox">
											<div class="col-md-12 forum-item active">
												
												<div class="pull-right">
													<div class="tooltip-demo">
														<button type="button" class="btn btn-success" onclick="Transferencia.VisualizarSeccion(Transferencia.Seccion.Destino)">
															<i class="fa fa-chevron-left" style="color: white;"></i> Anterior
														</button>
														<button type="button" class="btn btn-success" onclick="Transferencia.ActivarSeccion(Transferencia.Seccion.Resumen)">
															Siguiente <i class="fa fa-chevron-right" style="color: white;"></i>
														</button>
													</div>
												</div>
											
												<div class="col-md-col-md-offset-0 forum-icon">
													<i class="fa fa-tags fa-lg"></i>
												</div>
												<a href="#" class="forum-item-title" style="pointer-events: none">
													<h3>Art&iacute;culos</h3>
												</a>
												<div class="forum-sub-title">Seleccionar los art&iacute;culos que se van a transferir</div>
												
												<!--br-->
												<div class="hr-line-dashed"></div>
												
												<div class="form-group col-md-12 row">
													<label class="col-form-label col-md-10 p-3 border-bottom">
														<i class="fa fa-file-text-o fa-lg"></i> Lista de Articulos
														<br>&nbsp;
													</label>
													<div class="col-md-2 text-right">
														<button type="button" class="btn btn-success" data-toggle="modal" data-target="#modalBuscaArticulo">
															<i class="fa fa-plus" style="color: white;"></i> Agregar
														</button>
													</div>
												</div>
												
												<!-- row&nbsp;1 - renglon -->
												<div class="form-group col-md-12 row" id="tbodyArt">

												</div>
												
											</div>
												
										</div>
									</div>
								
								</div>
								<div id="tab-4" class="tab-pane">
									<div class="ibox-content" style="padding-top: 2px; padding-bottom: 198px;">
										<div class="ibox">
											<div class="col-md-12 forum-item active">
												
												<div class="pull-right">
													<div class="tooltip-demo">
														<button type="button" class="btn btn-success" onclick="Transferencia.VisualizarSeccion(Transferencia.Seccion.Articulo)">
															<i class="fa fa-chevron-left" style="color: white;"></i> Anterior
														</button>
														<button type="button" class="btn btn-success" onclick="Transferencia.ActivarSeccion(Transferencia.Seccion.Terminar)">
															<i class="fa fa-floppy-o " style="color: white;"></i> Guardar 
														</button>
													</div>
												</div>																
											
												<div class="col-md-col-md-offset-0 forum-icon">
													<i class="fa fa-file-text-o"></i>
												</div>
												<a href="#" class="forum-item-title" style="pointer-events: none">
													<h3>Resumen</h3>
												</a>
												<div class="forum-sub-title">Verificar los datos que sean los requeridos</div>
												
												<!--br-->
												<div class="hr-line-dashed"></div>

												<div class="form-group col-md-12 row border-bottom">
													<label class="col-form-label col-md-12 p-3">
														<i class="fa fa-id-card"></i> Datos Generales
													</label>
												</div>
												
												<!-- row&nbsp;1 - renglon -->
												<div class="form-group col-md-12 row">
													<span class="col-form-label col-md-4">
														<i class="fa fa-list-ul"></i> Tipo de Transferencia
													</span>
													<label id="lblResTipo" class="col-form-label col-md-8 text-success">
														
													</label>
												</div>
												
												<!-- row&nbsp;1 - renglon -->
												<div class="form-group col-md-12 row"  <% if( bolEsCliExt ){ %> style="display: none;" disabled="disabled" <% } %>>
													<span class="col-form-label col-md-4">
														<i class="fa fa-users"></i> Cliente
													</span>
													<label id="lblResCliente" class="col-form-label col-md-8 text-success">
														
													</label>
												</div>
												
												<div class="form-group col-md-12 row">
													<span class="col-form-label col-md-4">
														<i class="fa fa-calendar"></i> Fecha Entrega
													</span>
													<label id="lblResFechaEntrega" class="col-form-label col-md-8 text-success">
														
													</label>
												</div>
												
												<div class="form-group col-md-12 row border-bottom">
													<label class="col-form-label col-md-12 p-3">
														<i class="fa fa-map-marker"></i> Origen - Destino
													</label>
												</div>
												
												<div class="form-group col-md-6 col border-right classOrigen" style="display: none;">
													
													<div class="form-group col-md-12 row">
														<label class="col-form-label col-md-12 border-bottom">
															Origen
														</label>
													</div>
													
													<div class="form-group col-md-12 row">
														<span for="" class="col-form-label col-md-6">
															 <i class="fa fa-home"></i> Almac&eacute;n: 
														</span>
														<label id="lblResumenOrigenAlmacen" class="col-form-label col-md-6 text-success">
															
														</label>
													</div>
													
													<div class="form-group col-md-12 row">
														<span for="" class="col-form-label col-md-6">
															<i class="fa fa-user"></i> Responsable:
														</span>
														<label id="lblResumenOrigenResponsable" class="col-form-label col-md-6 text-success">
															
														</label>
													</div>
													
													<div class="form-group col-md-12 row">
														<span for="" class="col-form-label col-md-6">
															<i class="fa fa-phone"></i> Tel&eacute;fono:
														</span>
														<label id="lblResumenOrigenTelefono" class="col-form-label col-md-6 text-success">
															
														</label>
													</div>
													<div class="form-group col-md-12 row">
														<span for="" class="col-form-label col-md-6">
															<i class="fa fa-envelope"></i> Email
														</span>
														<label id="lblResumenOrigenEmail" class="col-form-label col-md-6 text-success">
															
														</label>
													</div>
													<div class="form-group col-md-12 row">
														<span for="" class="col-form-label col-md-6">
															<i class="fa fa-map-o"></i> Direcci&oacute;n
														</span>
														<label id="lblResumenOrigenDireccionCompleta" class="col-form-label col-md-6 text-success">
															
														</label>
													</div>
												</div>
												
												<div class="form-group col-md-6 col border-right classDestino" style="display: none;">
													
													<div class="form-group col-md-12 row">
														<label class="col-form-label col-md-12 border-bottom">
															Destino
														</label>
													</div>
													
													<div class="form-group col-md-12 row">
														<span for="" class="col-form-label col-md-6">
															 <i class="fa fa-home"></i> Almac&eacute;n: 
														</span>
														<label id="lblResumenDestinoAlmacen" class="col-form-label col-md-6 text-success">
															
														</label>
													</div>
													
													<div class="form-group col-md-12 row">
														<span for="" class="col-form-label col-md-6">
															<i class="fa fa-user"></i> Responsable:
														</span>
														<label id="lblResumenDestinoResponsable" class="col-form-label col-md-6 text-success">
															
														</label>
													</div>
													
													<div class="form-group col-md-12 row">
														<span for="" class="col-form-label col-md-6">
															<i class="fa fa-phone"></i> Tel&eacute;fono:
														</span>
														<label id="lblResumenDestinoTelefono" class="col-form-label col-md-6 text-success">
															
														</label>
													</div>
													<div class="form-group col-md-12 row">
														<span for="" class="col-form-label col-md-6">
															<i class="fa fa-envelope"></i> Email
														</span>
														<label id="lblResumenDestinoEmail" class="col-form-label col-md-6 text-success">
															
														</label>
													</div>
													<div class="form-group col-md-12 row">
														<span for="" class="col-form-label col-md-6">
															<i class="fa fa-map-o"></i> Direccio&oacute;n
														</span>
														<label id="lblResumenDestinoDireccionCompleta" class="col-form-label col-md-6 text-success">
															
														</label>
													</div>
												</div>
												
												<div class="form-group col-md-12 row border-bottom">
													<label for="" class="col-form-label col-md-2">
														<i class="fa fa-file-text-o"></i> Art&iacute;culos
													</label>
												</div>

												<div class="form-group col-md-12 row" id="tbodyResArt">
													
												</div>
												
											</div>
												
										</div>
									</div>
								
								</div>
								<div id="tab-5" class="tab-pane">
									
										<div class="ibox-content" style="padding-top: 2px; padding-bottom: 198px;">
											<div class="ibox col">
												<div class="col-md-12 forum-item active">
													
													<div class="pull-right">
														<div class="tooltip-demo">
															<button type="button" class="btn btn-success" 
															onclick="Transferencia.ActivarSeccion(Transferencia.Seccion.Fin)" >
															<i class="fa fa-check" style="color: white;"></i> Terminar
														</button>
														</div>
													</div>
												
													<div class="col-md-col-md-offset-0 forum-icon">
														<i class="fa fa-truck fa-flip-horizontal"></i>
													</div>
													<a href="#" class="forum-item-title" style="pointer-events: none">
														<h3>Transferencia</h3>
													</a>
													<div class="forum-sub-title">Solicitud Realizada</div>
													
													<!--br-->
													<div class="hr-line-dashed"></div>

													<div class="form-group col-md-12 row border-bottom text-center">
														<label class="col-form-label col-md-12 p-3 h2">
															Folio
														</label>
													</div>
													
													<div class="form-group col-md-12 row text-center">
														<label for="" class="col-form-label text-success h1">
															<i class="fa fa-barcode"></i> <span id="spanFolio"> </span>
														</label>
													</div>
													
												</div>
												
											</div>
										</div>
									
								</div>
								
							</div>
						</div>
				</div>
			</div>
            
        </div>
    
    <% //HA ID: 2 INI Sección de Articulos con Número de Series únicos
	%>
    <div class="col-sm-4" id="divSerie" style="display: none !important;">
        <div class="ibox ">
            <div id="divNumerosSerie" class=" ibox-content" style="overflow: auto;">
                
            </div>
        </div>
	</div>
	<% //HA ID: 2 FIN
	%>
	
	<!-- Modal Buscar Articulo -->
	<div class="modal fade" id="modalBuscaArticulo" tabindex="-1" role="dialog" aria-labelledby="divModalBuscaArticulo" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h2 class="modal-title" id="divModalBuscaArticulo">
                    	<i class="fa fa-search"></i> Buscar Art&iacuteculo 
                        <br />
                        <small>Buscar el art&iacute;culo a Transferir</small>
                    </h2>
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<div class="form-group row">
						<div class="form-group col-md-12 row">
							<div class="col-md-10 text-right">
								<input type="text" id="inpBuscarArticulo" class="form-control" 
								 placeholder="Buscar Art&iacute;culo" maxlength="150" autocomplete="off">
							</div>
							<div class="col-md-2 text-right">
								<button type="button" class="btn btn-success" onclick="Articulo.Buscar();">
									<i class="fa fa-search" style="color: white;"></i> Buscar
								</button>
							</div>
						</div>
						
						<div class="form-group col-md-12 row" style="overflow: auto; height: 350px;">
							<table class="table table-bordered table-hover issue-tracker">
								<thead>
									<tr>
										<th class="col-md-1"></th>
   										<th class="col-md-1">Disponible</th>
										<th class="col-md-7">Producto</th>
										<th class="col-md-2">Cantidad</th>
										<th class="col-md-1">&nbsp;</th>
									</tr>
								</thead>
								<tbody id="tbodyBusArt">
									
								</tbody>
							</table>
						</div>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary" data-dismiss="modal" onclick="Articulo.Cerrar();">
						<i class="fa fa-times"></i> Cerrar
					</button>
				</div>
			</div>
		</div>
	</div>

	<% //HA ID: 2 INI Sección de Buscar el articulo con Número de Series únicos
	%>
    <!-- Modal Buscar Numero de Serie -->
	<div class="modal fade" id="modalBuscaSerie" tabindex="-1" role="dialog" aria-labelledby="divModalBuscaSerie" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h2 class="modal-title" id="divModalBuscaSerie">
                    	<i class="fa fa-search"></i> <span id="spanBuscarSerieArticuloNombre"></span> 
                        <br />
                        <small>Buscar el n&uacute;mero de Serie a Seleccionar</small>
                    </h2>
                    <input type="hidden" id="inpBuscarSerieTAAId" value="" />
                    <input type="hidden" id="inpBuscarSeriePROId" value="" />
                    <input type="hidden" id="inpBuscarSerieTAACantidad" value="" />
					<button type="button" class="close" data-dismiss="modal" aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">
					<div class="form-group row">
						<div class="form-group col-md-12 row">
							<div class="col-md-10 text-right">
								<input type="text" id="inpBuscarSerie" class="form-control" 
								 placeholder="Buscar Art&iacute;culo" maxlength="150" autocomplete="off">
							</div>
							<div class="col-md-2 text-right">
								<button type="button" class="btn btn-success" onclick="Serie.Buscar();">
									<i class="fa fa-search" style="color: white;"></i> Buscar
								</button>
							</div>
						</div>
						
						<div class="form-group col-md-12 row" style="overflow: auto; height: 350px;">
							<table class="table table-bordered table-hover issue-tracker">
								<thead>
									<tr>
										<th class="col-md-10">No. Serie</th>
										<th class="col-md-2">&nbsp;</th>
									</tr>
								</thead>
								<tbody id="tbodyBusSer">
									
								</tbody>
							</table>
						</div>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary" data-dismiss="modal" onclick="Serie.Cerrar();">
						<i class="fa fa-times"></i> Cerrar
					</button>
				</div>
			</div>
		</div>
	</div>
    <% //HA ID: 2 FIN
	%>
	