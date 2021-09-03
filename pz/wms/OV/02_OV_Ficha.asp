<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%
	//HA ID: 2 2020-JUN-22 Se agrega interface de Actualizaci&oacute;n de Datos personales
	//HA ID: 3 2020-JUN-25 Se agrega interface de Cancelaci&oacute;n de Orden de Venta
	//HA ID: 4 2020-JUN-26 Se agregan campos de Edición en Orden de Venta
	//HA ID: 5 2020-JUL-22 Agregado de Comentarios y Bitácora de seguimiento: Se agrega Tabs y contenido a cada tab
	//HA ID: 6 2020-JUL-24 Se agrega validación de botons de fallido
	//HA ID: 7 2020-AGO-08 Se agrega dirección de Edición: la última editada
	//HA ID: 8 2020-AGO-08 Se agrega nueva funcionalidad al botón fallido
	//HA ID: 9 2020-SEP-18 Se agrega condición de visualización de comentarios

	//HA ID: 2 INI
	
	var intSisEdi = 19 //Lyde
	var bolEsEdiSis = false
	
	//HA ID: 2 FIN
	
	//HA ID: 3	
	var bolEsCan = false
	
	//HA ID: 4 
	var bolEsRef = false
	
	var urlBase = "/pz/wms/OV/"
	
   	var Cli_ID = Parametro("Cli_ID",-1)
	var OV_ID = Parametro("OV_ID",-1)
	var Usu_ID = Parametro("IDUsuario",0)
	var TA_ID = Parametro("TA_ID",-1)	
   
   
	// HA ID: 4 Se argregan Campos de consulta
	var sSQLOrdVta = "SELECT OV_ID "
			+ ", Cort_ID, OV_Test, OV_Folio, OV_Serie, OV_FechaVenta, CONVERT(NVARCHAR, OV_FechaVenta,103) AS FECHAVTA "
			+ ", CONVERT(NVARCHAR, OV_FechaElaboracion,103) AS FECHAELAB, OV_FechaElaboracion "
			+ ", OV_FechaRequerida, CONVERT(NVARCHAR, OV_FechaRequerida,103) AS FECHAREQ "
			+ ", OV_UsuIDSolicita, OV_Total, OV_Articulos, OV_CUSTOMER_SO, OV_CUSTOMER_NAME, OV_SHIPPING_ADDRESS " 
			+ ", OV_TRACKING_COM, OV_TRACKING_NUMBER, OV_STORE_LOC, OV_TEXTO, OV_STAT5, OV_EstatusID, OV_EstatusCG51 "
			+ ", dbo.fn_CatGral_DameDato(51,[OV_EstatusCG51]) AS ESTATUS "
			+ ", OV_TipoOVG47, Cli_ID, OV_ClienteOC_ID, OV_BPM_Pro_ID, OV_BPM_Flujo, OV_BPM_Estatus, OV_BPM_Cambio "
			+ ", OV_BPM_UsuID, OV_BPM_AlrID, OV_ImpresionPiking, OV_FechaRegistro, OV_Contenido, OV_Email, OV_Telefono " 
			+ ", OV_Calle, OV_NumeroExterior, OV_NumeroInterior, OV_CP, OV_Colonia, OV_Delegacion, OV_Ciudad, OV_Estado " 
			+ ", OV_Pais, OV_Terminales, OV_SIMS, OV_DirMrgErr, OV_Cancelada, OV_CancelacionFecha, OV_MotivoCancelacion "
			+ ", OV_ReferenciaDomicilio1, OV_ReferenciaDomicilio2, OV_ReferenciaTelefono, OV_ReferenciaPersona, OV_ComentarioGeneral "
			+ ", OV_Calle + ' ' + OV_NumeroExterior + ' ' + OV_NumeroInterior + ', ' + OV_Colonia + ', ' + OV_Delegacion + ', ' + OV_Ciudad + ', ' + OV_Estado + ', ' + OV_Pais + ', ' + OV_CP AS OV_DireccionOriginal " 
			+ ", (SELECT Nombre FROM dbo.tuf_Usuario_Informacion(OV_UsuarioCambioDireccion) ) AS OV_NombreUsuarioCambio " 
			+ ", ISNULL( (SELECT TOP 1 CONVERT(NVARCHAR(50), OV_FechaCambio, 103) FROM Orden_Venta_Historico_Direccion WHERE OV_ID = OV_ID ORDER BY OV_FechaCambio DESC ), '') AS OV_FechaModificada "
			+ ", dbo.fn_CatGral_DameDato(360,OV_EstatusCG360) AS FallidoMotivo "
			+ ", (SELECT Nombre FROM dbo.tuf_Usuario_Informacion(OV_FallidoUsuario) ) AS OV_FallidoNombre " 
			+ ", CONVERT(NVARCHAR(30), OV_FallidoFecha, 103) AS OV_FallidoFecha "
        + "FROM Orden_Venta "
        + "WHERE OV_ID = "+ OV_ID  
       
   	//SI hay una edición
	bHayParametros = false
	ParametroCargaDeSQL(sSQLOrdVta,0)            
		
	//HA ID: 2 INI
	
	if( parseInt(SistemaActual) == intSisEdi ){
		bolEsEdiSis = true
	}
	
	//HA ID: 2 FIN
	
	//HA ID: 3 INI
	if( parseInt(Parametro("OV_Cancelada", 0)) == 1 ){
		bolEsCan = true
	}
	//HA ID: 3 FIN
	
	//HA ID: 4 INI
	if( Parametro("OV_ReferenciaDomicilio1", "") != "" ){
		bolEsRef = true
	}
	
	
	//HA ID: 6 INI Se agrega Validacion 
	bolEsBotEditar = false
	bolEsBotFallido = false
	bolEsBotReIntento = false
	
	if( parseInt(Parametro("OV_EstatusCG51")) == 8 ){
		bolEsBotReIntento = true
	}
	
	if( parseInt(Parametro("OV_EstatusCG51")) < 9 ){
		bolEsBotEditar = true
	}
	
	//Valida la existencia del estatus en los permitidos
	// HA ID: 8 Se agrega la validación de los diferentes estatus
	if( ExisteEnArreglo( parseInt(Parametro("OV_EstatusCG51")), [5, 6, 7, 8] ) ){
		bolEsBotFallido = true
	}
	//HA ID: 6 FIN
%>
<%  //HA ID: 2 INI Se agrega función de Actualizaci&oacute;n de Datos 
	//HA ID: 4 INI Se agregan Campos de Edición 
	//HA ID: 5 INI Se agrega Bloque de Despliegue de Comentarios, Bitacora y Rastreo
%>
<script type="text/javascript" src="<%= urlBase %>js/OrdenVenta.js"></script>

<script type="text/javascript">
	var urlBase = "<%= urlBase %>";
	
    $(document).ready(function() { 
        
        CargaProductos();
        OrdenVentaComentario.Cargar();
		OrdenCompraRastreo.Cargar();
		OrdenCompraBitacora.Cargar();
		CargaHistoricoLineTime();
		
    });

	function CargaProductos(){
        
		var sDatos  = "?OV_ID=<%=OV_ID%>";
		    sDatos += "&Usu_ID="+$("#IDUsuario").val();		
		
		$("#divProdGrid").load("/pz/wms/OV/OV_FichaProductoGrid.asp" + sDatos);
		
	}    
    
    function CargaHistoricoLineTime(){
        
		var sDatos  = "?OV_ID=<%=OV_ID%>"; 
		    sDatos += "&Usu_ID="+$("#IDUsuario").val();		
		
		$("#divHistLineTimeGrid").load("/pz/wms/OV/OV_FichaHistoricoGrid.asp" + sDatos);        
        
    }
	
	
	
	
//------------------------------------------------------------------
	
$('#EntregaFallidaGuardar').on('click',function(e) {
	
	swal({
		title: "Quieres Enviar a Fallido?",
		text: "Ya no se podr&aacute; recuperar la Orden de Venta",
		type: "warning",
		showCancelButton: true,
		confirmButtonColor: "#DD6B55",
		confirmButtonText: "Fallido",
		closeOnConfirm: true,
		closeOnCancel: false,
		html: true
	}, function(data) {
		
		if(data){
			
			var bolMotFal = OrdenVenta.EnviarFallido();
			
			if( bolMotFal ){
			
				var Folio = $("#OVFolio").val();
				var res = Folio.replace("'", "-");
		
				var datos ={
					OV_Folio:res,
					Estatus:9,
					Tarea:7,
					IDUsuario:$('#IDUsuario').val()
				}
				
				FolioInfo(datos,9)
				
				if( parseInt($("#SeAbrePorModal").val()) == 0 ){

					$('#modalFallido').modal('hide');
					setTimeout( function(){ RecargaEnSiMismo(); }, 1800);
					
				} else {
					
					$.post("/pz/wms/OV/OV_Ficha.asp"
						, {OV_ID:$("#OV_ID").val()}
						, function(data){
							$("#modalBodySO").html(data);
							$("#SeAbrePorModal").val(1);
						}
					);
				}
				
				swal("Fallido", "Se realizo la actualizacion.", "success");
				
			}
			
		} else {

			swal("Folio no enviado a Fallido", "Folio no ha sufrido ningun tipo de cambio", "warning");
			
		}
		
	});
});

function FolioInfo(folio,Estatus){
	$.post("/pz/wms/OV/OV_Ajax.asp",folio,function(data){

		if(data != -1){
			CambioEstatus(data,Estatus)
			console.log("Se envia a izzi")
			
		}else{
			console.log("No se envia a izzi")
			sTipo = "error";   
			sMensaje = "No se envia a izzi";
			Avisa(sTipo,"Aviso",sMensaje);	
		}
		
	});
}
function CambioEstatus(OV_ID,Estatus){
	var data = {
		"Tarea":3,
		"OV_ID":OV_ID,
		"Estatus":Estatus,
		"Guia":"",
		"Transportista":""
	}
	var myJSON = JSON.stringify(data);
	
	
	$.ajax({
		type: 'post',
		contentType:'application/json',
		data: myJSON,
		url: "http://198.38.94.4:1117/lyde/api/ServiceZZ",
		success: function(datos){
			console.log(datos) 
			sTipo = "info";   
			sMensaje = "Estatus actualizados";
			Avisa(sTipo,"Aviso",sMensaje);	
			swal("Cancelado", "Se realizo la actualizacion.", "success");
			setTimeout(2000);
			location.reload();
		}
	});
	/*
	swal("Cancelado", "Se realizo la actualizacion.", "success");
	
	setTimeout(2000);
	location.reload();
	*/
}

$("#EntregaReingreso").on("click", function(e){
	swal({
		title: "Advertencia",
		text: "Al oprimir OK se enviara el folio a estatus Packing para su correspondiente proceso, seguro que deseas continuar?",
		type: "warning",
		showCancelButton: true,
		confirmButtonColor: "#DD6B55",
		confirmButtonText: "OK",
		closeOnConfirm: true,
		closeOnCancel: false,
		html: true
	}, function(data) {
		
		if(data){

			var Folio = $("#OVFolio").val();
			var res = Folio.replace("'", "-");
	
			var datos = {
				OV_Folio:res,
				Estatus: 3,
				Tarea:13,
				IDUsuario:$('#IDUsuario').val()
			}
			
			FolioInfo(datos,3)
		} else {

			swal("cancelacion de reintento", "Folio no ha sufrido ningun tipo de cambio", "warning");
			
		}
		
	});
})

//------------------------------------------------------------------
	
	
</script>    

<input type="hidden" id="OVFolio" value="<%= Parametro("OV_Folio", -1) %>" />
<div class="container-fluid">
<div id="wrapper ">
    <div class="wrapper wrapper-content animated fadeInRight">
        <div class="row">
            <div class="col-sm-8">
                <div class="ibox">    
                    <div class="ibox-content">
                        <div class="row">
                            <div class="col-lg-12">
                                <div class="m-b-md">
                                    <h2 class="pull-right"><%=Parametro("OV_Folio","")%><p><small><%=Parametro("OV_CUSTOMER_SO","")%></small></p></h2>
                                    <h2><%=Parametro("OV_CUSTOMER_NAME","")%></h2>
                                </div>
                            </div>
                        </div>
                        <hr>        
                        <div class="row">
                            
                            <div class="col-md-12">
                                <dl class="dl-horizontal">
                                    <dt>Estatus:</dt> <dd><span class="label label-<%= ( bolEsCan ) ? "danger" : "primary" %>"><%=Parametro("ESTATUS","")%></span></dd>
                                </dl>
                                <!--Datos de la Orden de compra-->
                                <dl class="dl-horizontal">
                                    <dt>Fecha requerida:</dt>
                                    <dd><%=Parametro("FECHAREQ","")%></dd>
                                    <dt>Fecha de venta:</dt>
                                    <dd><%=Parametro("FECHAVTA","")%></dd>
                                    <dt>Fecha de elaboraci&oacute;n:</dt>
                                    <dd><%=Parametro("FECHAELAB","")%></dd>
                                    <dt>Transportista:</dt>
                                    <dd><%=Parametro("OV_TRACKING_COM","")%></dd>
                                    <dt>Gu&iacute;a:</dt>
                                    <dd><%=Parametro("OV_TRACKING_NUMBER","")%></dd>                                        
                                </dl>
                            </div>
                            <div class="col-md-12" id="cluster_info">
								<dl class="dl-horizontal">
									<dt>Direcci&oacute;n de entrega</dt>
								</dl>   
							<% //HA ID: 2 INI Se agregan Identificadores para Edici&oacute;n y Actualizaci&oacute;n
							%>
								<dl class="dl-horizontal">
                                    <dt>Calle:</dt>
                                    <dd id="OVCalle"><%=Parametro("OV_Calle","")%></dd>
                                    <dt>Num. Ext.:</dt>
                                    <dd id="OVNumeroExterior"><%=Parametro("OV_NumeroExterior","")%></dd>
                                    <dt>Num. Int.:</dt>
                                    <dd id="OVNumeroInterior"><%=Parametro("OV_NumeroInterior","")%></dd>
                                    <dt>Colonia:</dt>
                                    <dd id="OVColonia"><%=Parametro("OV_Colonia","")%></dd>
                                    <dt>Delegaci&oacute;n/Municipio:</dt>
                                    <dd id="OVDelegacion"><%=Parametro("OV_Delegacion","")%></dd>
                                    <dt>Ciudad:</dt>
                                    <dd id="OVCiudad"><%=Parametro("OV_Ciudad","")%></dd>
                                    <dt>Estado:</dt>
                                    <dd id="OVEstado"><%=Parametro("OV_Estado","")%></dd>
                                    <dt>C&oacute;digo postal:</dt>
                                    <dd id="OVCodigoPostal"><%=Parametro("OV_CP","")%></dd>
									<dt>Tel&eacute;fono:</dt>
                                    <dd id="OVTelefono"><%=Parametro("OV_Telefono","")%></dd>
									<dt>e-mail:</dt>
                                    <dd id="OVEmail"><%=Parametro("OV_Email","")%></dd>
									
                                </dl>   
							<% //HA ID: 2 FIN
							%>
                            </div>
<% 	//HA ID: 4 INI Se agrega Condición para color de Campo
	//HA ID: 7 INI Se agrega validación de Si existió Edición 
	if( Parametro("OV_FechaModificada") != "" ){
%>
							<div class="col-md-12">
								<dl class="dl-horizontal">
									<dt>Direcci&oacute;n Actual:</dt>
                                    <dd id="OVShippingAddress" class="issue-info">
										<a href="#" class="link">
											<span class="text-success"><%= Parametro("OV_DireccionOriginal") %></span>
                                        </a>
                                        <small>
                                        	<i class="fa fa-clock-o"></i> <%= Parametro("OV_FechaModificada") %>
                                            &nbsp;
                                            <i class="fa fa-user"></i> <%= Parametro("OV_NombreUsuarioCambio") %>
                                        </small>
									</dd>
								</dl>
							</div>
<%	} else {
%>
							<div class="col-md-12">
								<dl class="dl-horizontal">
									<dt>Direcci&oacute;n Original:</dt>
                                    <dd id="OVShippingAddress" class="<%= ( Parametro("OV_CP","") != "" ) ? "warning" : "" %>">
										<%=Parametro("OV_SHIPPING_ADDRESS","")%>
									</dd>
								</dl>
							</div>
<%	}

	//HA ID: 7 FIN	
%>							
<% 	//HA ID: 4 FIN
	//HA ID: 4 INI Se agrea bloque de Referencias de Domicilio
	var strVisRef = (bolEsRef) ? "" : "style='display: none;'"
	
%>
							<div class="col-md-12" <%= strVisRef %> >
								<dl class="dl-horizontal">
									<dt> <i class="fa fa-map-o"></i> Referencias</dt>
								</dl>
							</div>
							
							<hr class="col-md-12" <%= strVisRef %>>                            
                            
							<div class="col-md-6" <%= strVisRef %> >
								<dl class="dl-horizontal">
									<dt>Domicilio 1: </dt>
                                    <dd id="OVRefDomicilio1"><%=Parametro("OV_ReferenciaDomicilio1","")%></dd>
									<dt>Persona: </dt>
                                    <dd id="OVRefPersona"><%=Parametro("OV_ReferenciaPersona","")%></dd>
								</dl>
							</div>
							
							<div class="col-md-6" <%= strVisRef %> >
								<dl class="dl-horizontal">
									<dt>Domicilio 2:</dt>
                                    <dd id="OVRefDomicilio2"><%=Parametro("OV_ReferenciaDomicilio2","")%></dd>
									<dt>Telefono:</dt>
									<dd id="OVRefTelefono"><%=Parametro("OV_ReferenciaTelefono","")%></dd>
								</dl>
							</div>
							
							<hr class="col-md-12" <%= strVisRef %>>
<% //HA ID: 9 Se agrega condición de visualización de comentarios

	
%>


							<div class="col-lg-12" style='display: <% if (Parametro("OV_ComentarioGeneral","") == "" ){ Response.Write("none") } else { Response.Write("in-line") } %>'>
								<dl class="dl-horizontal">
									<dt>Comentarios:</dt>
                                    <dd id="OVRefComentarios"><%=Parametro("OV_ComentarioGeneral","")%></dd>
								</dl>
							</div>
<% if( Parametro("FallidoMotivo","") != "" ) {
%>                            
                            <hr class="col-md-12">
							
							<div class="col-md-12">
                           		<dl class="dl-horizontal">
	                                <dt>
                                    	<i class="fa fa-exclamation-circle fa-lg text-success"></i> Motivo de Fallido:
                                    </dt>
									<dd class="issue-info">
										<a href="#" class="link">
											<span class="text-danger"><%= Parametro("FallidoMotivo") %></span>
                                        </a>
                                        <small>
                                        	<i class="fa fa-clock-o"></i> <%= Parametro("OV_FallidoFecha") %>
                                            &nbsp;
                                            <i class="fa fa-user"></i> <%= Parametro("OV_FallidoNombre") %>
                                        </small>
									</dd>
                                </dl>
							</div>
                            
<%	}
%>
<% 	//HA ID: 4 FIN
	//HA ID: 2 INI Se agrega bloque de bloque de Cancelaci&oacute;n
	
	var strVisCan = ( bolEsCan ) ? "" : "style='display: none;'"
%>
							<div class="col-md-12" <%= strVisCan %> id="divCancelacion">
								<dl class="dl-horizontal">
                                    <dt>Motivo de Cancelaci&oacute;n:</dt> 
									<dd id="labelMotivoCancelacion" class="text-danger">
										<%=Parametro("OV_MotivoCancelacion","")%>
									</dd>
                                </dl>
							</div>
<%
	// HA: ID 2 FIN
	
	// HA: ID 1 INI Se agrega Boton de Edici&oacute;n de Datos Personales 
	// HA: ID 2 INI Se agrega Condición de Edicíon
	
	// HA ID: 6 Se elimina Validación de Visualización de botones de Accion
%>
                            <div id="divBotonCancelacion" class="col-md-12 text-right">
								<dl class="dl-horizontal">
<%	//Se elimina botón de cancelación 
	// HA ID: 8 Se agrega el modal al botón
	if( bolEsBotFallido ) {
%>                                
	
                                	<a href="#" id="EntregaFallida" class="btn btn-danger"
                                     data-toggle="modal" data-target="#modalFallido">
	                                    <i class="fa fa-trash-o"></i> Fallido
	                                </a>
<%	}

	if( bolEsBotReIntento ){
%>
                                	<a href="#" id="EntregaReingreso" class="btn btn-warning">
	                                    <i class="fa fa-reply"></i> Re Intento
	                                </a>
<%	}
	if( bolEsBotEditar ){
%>                                    
									<a href="#" class="btn btn-primary" onclick="OrdenVenta.Editar();"
                                    	 data-toggle="modal" data-target="#modalActualiza">
	                                    <i class="fa fa-pencil-square-o"></i> Editar
	                                </a>
<% }
%>
                                </dl>
                            </div>	
<% 
	
// HA ID: 2 FIN 

// HA ID: 5 INI Se agrega Tabs para organizar la información
%>
							<div class="row m-t-sm">
                                <div class="col-lg-12">
									<div class="panel blank-panel">
										<div class="panel-heading">
											<div class="panel-options">
												<ul class="nav nav-tabs">
													<li class="active"><a href="#tab-1" data-toggle="tab">Art&iacute;culos</a></li>
													<li class=""><a href="#tab-2" data-toggle="tab">Bit&aacute;cora</a></li>
													<li class=""><a href="#tab-3" data-toggle="tab">Hist&oacute;rico</a></li>
													<li class=""><a href="#tab-4" data-toggle="tab">Rastreo</a></li>
												</ul>
											</div>
										</div>

										<div class="panel-body">
											<div class="tab-content">
												
												<div class="tab-pane active" id="tab-1">
													
													<div id="divOrdenVentaProductos">
								
													</div>
													
													<div id="divProdGrid">
								
													</div>  
												</div>
												
												<div class="tab-pane" id="tab-2">
													
													<div id="divOrdenVentaComentarios">
								
													</div> 
													
												</div>
												
												<div class="tab-pane" id="tab-3">
													
													<div id="divOrdenVentaBitacora">
								
													</div>

												</div>
												
												<div class="tab-pane" id="tab-4">
													
													<div id="divOrdenVentaRastreo">
								
													</div>
													
												</div>
												
											</div>

										</div>

									</div>
                                </div>
                            </div>
<%
// HA ID: 5 FIN
%>
                        </div>
                               
                    </div>
                </div>
            </div>
			
            <div class="col-sm-4">
                <div id="divHistLineTimeGrid">
				
				</div>

            </div>
			
        </div>
</div>
</div>

<%  // HA ID: 1 INI Se agrega Modal de Edici&oacute;n de Datos Personales 
	// HA ID: 6 Se elimina Validación de Edición
%>
<input type="hidden" id="SeAbrePorModal" value="0" />
<div class="modal fade" id="modalActualiza" tabindex="-1" role="dialog" aria-labelledby="divModalActualiza" aria-hidden="true">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title" id="divModalActualiza"><%=Parametro("OV_CUSTOMER_NAME","")%></h4>
                <button type="button" class="close" data-toggle="modal" data-target="#modalActualiza" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            
            <div class="modal-body">
                <div class="form-group row">
                    <label for="Calle" class="col-sm-2 col-form-label">Calle</label>
                    <div class="col-sm-10">
                        <input type="text" autocomplete="off" class="form-control" id="Calle" placeholder="Calle">
                    </div>
                </div>
                <div class="form-group row">
                    <label for="NumeroExterior" class="col-sm-2 col-form-label">No. Ext.</label>
                    <div class="col-sm-4">
                        <input type="text" autocomplete="off" class="form-control" id="NumeroExterior" placeholder="Numero Exterior">
                    </div>
               
                    <label for="NumeroInterior" class="col-sm-2 col-form-label">No. Int.</label>
                    <div class="col-sm-4">
                        <input type="text" autocomplete="off" class="form-control" id="NumeroInterior" placeholder="Numero Interior">
                    </div>
                </div>
                <div class="form-group row">
                    <label for="Colonia" class="col-sm-2 col-form-label">Colonia</label>
                    <div class="col-sm-4">
                        <input type="text" autocomplete="off" class="form-control" id="Colonia" placeholder="Colonia">
                    </div>
                
                    <label for="Delegacion" class="col-sm-2 col-form-label">Del./Mpio.</label>
                    <div class="col-sm-4">
                        <input type="text" autocomplete="off" class="form-control" id="Delegacion" placeholder="Delegacion / Municipio">
                    </div>
                </div>
                <div class="form-group row">
                    <label for="Ciudad" class="col-sm-2 col-form-label">Ciudad</label>
                    <div class="col-sm-4">
                        <input type="text" autocomplete="off" class="form-control" id="Ciudad" placeholder="Ciudad">
                    </div>
               
                    <label for="Estado" class="col-sm-2 col-form-label">Estado</label>
                    <div class="col-sm-4">
                        <input type="text" autocomplete="off" class="form-control" id="Estado" placeholder="Estado">
                    </div>
                </div>
                <div class="form-group row"> 
                    <label for="CodigoPostal" class="col-sm-2 col-form-label">Cod. Post.</label>
                    <div class="col-sm-4">
                        <input type="text" autocomplete="off" class="form-control" id="CodigoPostal" placeholder="Codigo Postal">
                    </div>
               
                    <label for="Telefono" class="col-sm-2 col-form-label">Tel&eacute;fono</label>
                    <div class="col-sm-4">
                        <input type="text" autocomplete="off" class="form-control" id="Telefono" placeholder="Telefono">
                    </div>
                </div>
                <div class="form-group row">
                    <label for="Email" class="col-sm-2 col-form-label">E-mail</label>
                    <div class="col-sm-10">
                        <input type="text" autocomplete="off" class="form-control" id="Email" placeholder="E-mail">
                    </div>
                </div>
<%	// HA ID: 4 INI Se agrega bloque de Referencias de Orden de Venta
%>
				<div class="form-group row">
                    <label class="col-sm-12 col-form-label">
						<i class="fa fa-map-o"></i> Referencias
					</label>
				</div>
				<div class="form-group row">
                    <label for="RefDomicilio1" class="col-sm-2 col-form-label">
						Domicilio 1
					</label>
                    <div class="col-sm-4">
                        <textarea autocomplete="off" rows="3" class="form-control" id="RefDomicilio1" 
						 placeholder="Referencia de Domicilio 1" maxlength="35"></textarea>
                    </div>
                
                    <label for="RefDomicilio2" class="col-sm-2 col-form-label">
						Domicilio 2
					</label>
                    <div class="col-sm-4">
                        <textarea autocomplete="off" rows="3" class="form-control" id="RefDomicilio2" 
						 placeholder="Referencia de Domicilio 2" maxlength="35"></textarea>
                    </div>
                </div>
				<div class="form-group row">
                    <label for="RefPersona" class="col-sm-2 col-form-label">Persona</label>
                    <div class="col-sm-4">
                        <input type="text" autocomplete="off" class="form-control" id="RefPersona" 
						 placeholder="Nombre de la Persona de la Referencia" maxlength="256">
                    </div>
                
                    <label for="RefTelefono" class="col-sm-2 col-form-label">Tel&eacute;fono</label>
                    <div class="col-sm-4">
                        <input type="text" autocomplete="off" class="form-control" id="RefTelefono" 
						 placeholder="Telefono de la Referencia" maxlength="50">
                    </div>
                </div>
				<div class="form-group row">
                    <label for="RefComentarios" class="col-sm-2 col-form-label">Comentarios</label>
                    <div class="col-sm-10">
                        <textarea autocomplete="off" rows="3" class="form-control" id="RefComentarios" 
						 placeholder="Comentarios Generales" maxlength="4000"></textarea>
                    </div>
                </div>
            
            </div>

<%	// HA ID: 4 FIN
%>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-toggle="modal" data-target="#modalActualiza">
					<i class="fa fa-times"></i> Cerrar
				</button>
                <button type="button" class="btn btn-primary" onclick="OrdenVenta.Actualizar();">
					<i class="fa fa-floppy-o"></i> Actualizar
				</button>
            </div>
            
        </div>
    </div>
</div>
<% // HA ID: 3 INI Se agrega Modal de Cancelaci&oacute;n de Orden de Venta
%>
<div class="modal fade" id="modalCancelacion" tabindex="-1" role="dialog" aria-labelledby="divModalCancelacion" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title" id="divModalCancelacion">Cancelaci&oacute;n de la Orden de Venta</h4>
                <button type="button" class="close" data-toggle="modal" data-target="#modalCancelacion" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            
            <div class="modal-body">
                <div class="form-group row">
                    <label for="MotivoCancelacion" class="col-sm-3 col-form-label">Motivo de Cancelaci&oacute;n</label>
                    <div class="col-sm-9">
                        <textarea class="form-control" id="MotivoCancelacion" placeholder="Motivo de Cancelaci&oacute;n" 
						 maxlength="200"></textarea>
                    </div>
                </div>
				<div class="form-group row">
                    <div class="form-check">
						<input class="form-check-input" type="checkbox" id="IzziCancela" value="1">
						<label class="form-check-label" for="IzziCancela">
						  Izzi es quien cancela
						</label>
					</div>
                </div>
            </div>
            
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-toggle="modal" data-target="#modalCancelacion">
					<i class="fa fa-times"></i> Cerrar
				</button>
                <button type="button" class="btn btn-danger" onclick="OrdenVenta.Cancelar();">
					<i class="fa fa-trash-o"></i> Cancelar
				</button>
            </div>
            
        </div>
    </div>
</div>

<% 
	// HA ID: 3 FIN

// HA ID: 2 FIN 
%>

<div class="modal fade" id="modalComentario" tabindex="-1" role="dialog" aria-labelledby="divModalComentario" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title" id="divModalComentario"><%= "Comentarios" %></h4>
                <button type="button" class="close"  data-toggle="modal" data-target="#modalComentario" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <input type="hidden" id="comNodo" value="" />
            <div class="modal-body">
                <div class="form-group row">
                    <label for="comTitulo" class="col-sm-2 col-form-label">Titulo</label>
                    <div class="col-sm-10">
                        <input type="text" autocomplete="off" class="form-control" id="comTitulo" placeholder="Titulo" maxlength="50">
                    </div>
                </div>
                <div class="form-group row">
					<label for="comComentario" class="col-sm-2 col-form-label">Comentarios</label>
                    <div class="col-sm-10">
                        <textarea id="comComentario" class="form-control" placeholder="Comentario" maxlength="150"></textarea>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-toggle="modal" data-target="#modalComentario">
					<i class="fa fa-times"></i> Cerrar
				</button>
                <button type="button" class="btn btn-danger" onclick="OrdenVentaComentario.Agregar();">
					<i class="fa fa-plus"></i> Agregar
				</button>
            </div>
		</div>
	</div>
</div>

<%	//HA ID: 8 INI  Agrega Modulo de Fallido
%>
<div class="modal fade" id="modalFallido" tabindex="-1" role="dialog" aria-labelledby="divModalFallido" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title" id="divModalFallido">Fallido de la Orden de Venta</h4>
                <button type="button" class="close" data-toggle="modal" data-target="#modalFallido" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            
            <div class="modal-body">
                <div class="form-group row">
                    <label for="MotivoFallido" class="col-sm-3 col-form-label">Motivo de Fallido</label>
                    <div class="col-sm-9">
                    	<select id="MotivoFallido" class="form-control">
<%
	var sqlCatFal = "SELECT CAT.Cat_ID "
			+ ", CAT.Cat_Nombre "
		+ "FROM Cat_Catalogo CAT "
		+ "WHERE CAT.SEC_ID = 360 "
		
	var rsCatFal = AbreTabla(sqlCatFal, 1, 0)
%>
							<option value="0">
                            	SELECCIONAR
                            </option>
<%
	while( !(rsCatFal.EOF) ){
%>
							<option value="<%= rsCatFal("CAT_ID").Value %>">
                            	<%= rsCatFal("CAT_Nombre").Value %>
                            </option>
<%		
		rsCatFal.MoveNext
	}
	
	rsCatFal.Close
%>                        
                        </select>

                    </div>
                </div>
            </div>
            
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-toggle="modal" data-target="#modalFallido">
					<i class="fa fa-times"></i> Cerrar
				</button>
                <button type="button" class="btn btn-danger" id="EntregaFallidaGuardar">
					<i class="fa fa-trash-o"></i> Enviar a Fallido
				</button>
            </div>
            
        </div>
    </div>
</div>
<%	//HA ID: 8 FIN
%>
