<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%
	//HA ID: 1 2020-JUN-22 Se agrega interface de Actualización de Datos personales

	//HA ID: 1 INI
	var intSisEdi = 19
	var bolEsEdiSis = false
	//HA ID: 1 FIN
 
   	var Cli_ID = Parametro("Cli_ID",-1)
	var OV_ID = Parametro("OV_ID",-1)
	var Usu_ID = Parametro("IDUsuario",0)
   
	var sSQLOrdVta = "SELECT OV_ID, Cort_ID, OV_Test, OV_Folio, OV_Serie, OV_FechaVenta, CONVERT(NVARCHAR, OV_FechaVenta,103) AS FECHAVTA "
        sSQLOrdVta += ",CONVERT(NVARCHAR, OV_FechaElaboracion,103) AS FECHAELAB, OV_FechaElaboracion "
        sSQLOrdVta += ",OV_FechaRequerida, CONVERT(NVARCHAR, OV_FechaRequerida,103) AS FECHAREQ "
        sSQLOrdVta += ",OV_UsuIDSolicita, OV_Total, OV_Articulos, OV_CUSTOMER_SO, OV_CUSTOMER_NAME, OV_SHIPPING_ADDRESS " 
        sSQLOrdVta += ",OV_TRACKING_COM, OV_TRACKING_NUMBER, OV_STORE_LOC, OV_TEXTO, OV_STAT5, OV_EstatusID, OV_EstatusCG51 "
        sSQLOrdVta += ",dbo.fn_CatGral_DameDato(51,[OV_EstatusCG51]) AS ESTATUS "
        sSQLOrdVta += ",OV_TipoOVG47, Cli_ID, OV_ClienteOC_ID, OV_BPM_Pro_ID, OV_BPM_Flujo, OV_BPM_Estatus, OV_BPM_Cambio "
        sSQLOrdVta += ",OV_BPM_UsuID, OV_BPM_AlrID, OV_ImpresionPiking, OV_FechaRegistro, OV_Contenido, OV_Email, OV_Telefono " 
        sSQLOrdVta += ",OV_Calle, OV_NumeroExterior, OV_NumeroInterior, OV_CP, OV_Colonia, OV_Delegacion, OV_Ciudad, OV_Estado " 
        sSQLOrdVta += ",OV_Pais, OV_Terminales, OV_SIMS, OV_DirMrgErr, OV_Cancelada, OV_CancelacionFecha "
        sSQLOrdVta += "FROM Orden_Venta "
        sSQLOrdVta += "WHERE OV_ID = "+ OV_ID 
       
   
	    bHayParametros = false
	    ParametroCargaDeSQL(sSQLOrdVta,0)            
		
	//HA ID: 1 INI
	if( parseInt(SistemaActual) == intSisEdi ){
		bolEsEdiSis = true
	}
	//HA ID: 1 FIN

%>

  
<div id="wrapper">
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
                            <div class="col-lg-6" id="cluster_info">
                             <dl class="dl-horizontal">
                             <dt>Direcci&oacute;n de entrega</dt>
                             </dl>   
							<% //HA ID: 1 INI Se agregan Identificadores para Edición y Actualización
							%>
                             <dl class="dl-horizontal">
                                    <dt>Calle:</dt>
                                    <dd id="OVCalle"><%=Parametro("OV_Calle","")%></dd>
                                    <dt>Num. Ext:</dt>
                                    <dd id="OVNumeroExterior"><%=Parametro("OV_NumeroExterior","")%></dd>
                                    <dt>Num. Interior:</dt>
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
							<% //HA ID: 1 FIN
							%>
                            </div>
                            <div class="col-lg-6">
                                <dl class="dl-horizontal">
                                    <dt>Estatus:</dt> <dd><span class="label label-primary"><%=Parametro("ESTATUS","")%></span></dd>
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
<% // HA: 1 INI Se agrega Modal de Edición de Datos Personales 
	if( bolEsEdiSis ){
%>
                            <div class="col-lg-12 text-right">
								<dl class="dl-horizontal">
                                	<a id="btnEditarOrden" class="btn btn-primary"
                                    	 data-toggle="modal" data-target="#DatosParciales">
	                                    <i class="fa fa-pencil-square-o"></i> Editar
	                                </a>
                                </dl>
                            </div>	
<% 
	}
// HA ID: 1 FIN 
%>
                        </div>
                        <hr>
                        <p></p>
                        <div class="row">
                            <div id="divProdGrid"></div>                                
                        </div>        
                    </div>
                </div>
            </div>
            <div class="col-sm-4">
                <div id="divHistLineTimeGrid"></div>
            </div>
        </div>
</div>

<% // HA: 1 INI Se agrega Modal de Edición de Datos Personales 
	if( bolEsEdiSis ){
%>
<div class="modal fade" id="DatosParciales" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title" id="exampleModalLabel"><%=Parametro("OV_CUSTOMER_NAME","")%></h4>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            
            <div class="modal-body">
                <div class="form-group row">
                    <label for="Calle" class="col-sm-3 col-form-label">Calle</label>
                    <div class="col-sm-9">
                        <input type="text" class="form-control" id="Calle" placeholder="Calle">
                    </div>
                </div>
                <div class="form-group row">
                    <label for="NumeroExterior" class="col-sm-3 col-form-label">Numero Exterior</label>
                    <div class="col-sm-9">
                        <input type="text" class="form-control" id="NumeroExterior" placeholder="Numero Exterior">
                    </div>
                </div>
                <div class="form-group row">
                    <label for="NumeroInterior" class="col-sm-3 col-form-label">Numero Interior</label>
                    <div class="col-sm-9">
                        <input type="text" class="form-control" id="NumeroInterior" placeholder="Numero Interior">
                    </div>
                </div>
                <div class="form-group row">
                    <label for="Colonia" class="col-sm-3 col-form-label">Colonia</label>
                    <div class="col-sm-9">
                        <input type="text" class="form-control" id="Colonia" placeholder="Colonia">
                    </div>
                </div>
                <div class="form-group row">
                    <label for="Delegacion" class="col-sm-3 col-form-label">Delegacion/Municipio</label>
                    <div class="col-sm-9">
                        <input type="text" class="form-control" id="Delegacion" placeholder="Delegacion / Municipio">
                    </div>
                </div>
                <div class="form-group row">
                    <label for="Ciudad" class="col-sm-3 col-form-label">Ciudad</label>
                    <div class="col-sm-9">
                        <input type="text" class="form-control" id="Ciudad" placeholder="Ciudad">
                    </div>
                </div>
                <div class="form-group row">
                    <label for="Estado" class="col-sm-3 col-form-label">Estado</label>
                    <div class="col-sm-9">
                        <input type="text" class="form-control" id="Estado" placeholder="Estado">
                    </div>
                </div>
                <div class="form-group row"> 
                    <label for="CodigoPostal" class="col-sm-3 col-form-label">Codigo Postal</label>
                    <div class="col-sm-9">
                        <input type="text" autocomplete="off" class="form-control" id="CodigoPostal" placeholder="Codigo Postal">
                    </div>
                </div>
                <div class="form-group row">
                    <label for="Telefono" class="col-sm-3 col-form-label">Teléfono</label>
                    <div class="col-sm-9">
                        <input type="text" autocomplete="off" class="form-control" id="Telefono" placeholder="Telefono">
                    </div>
                </div>
                <div class="form-group row">
                    <label for="Email" class="col-sm-3 col-form-label">E-mail</label>
                    <div class="col-sm-9">
                        <input type="text" class="form-control" id="Email" placeholder="E-mail">
                    </div>
                </div>
            
            </div>
            
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">
					<i class="fa fa-times"></i> Cancelar
				</button>
                <button type="button" class="btn btn-primary" onclick="OrdenVenta.GuardarDatos();">
					<i class="fa fa-floppy-o"></i> Guardar
				</button>
            </div>
            
        </div>
    </div>
</div>
<% 
	}
// HA ID: 1 FIN 
%>
<script type="text/javascript">

    $(document).ready(function() { 
        
        CargaProductos();

        CargaHistoricoLineTime();
		
		
		$('#btnEditarOrden').click(function(e) {
            OrdenVenta.EditarDatosA()
        });


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
    
<% //HA ID: 1 INI Se agrega función de Actualización de Datos 
	if( bolEsEdiSis ){

%>	
	var OrdenVenta = {
		EditarDatosA: function (){
			
			$("#Calle").val( $("#OVCalle").text() );
			$("#NumeroExterior").val( $("#OVNumeroExterior").text() );
			$("#NumeroInterior").val( $("#OVNumeroInterior").text() );
			$("#Colonia").val( $("#OVColonia").text() );
			$("#Delegacion").val( $("#OVDelegacion").text() );
			$("#Ciudad").val( $("#OVCiudad").text() );
			$("#Estado").val( $("#OVEstado").text() );
			$("#CodigoPostal").val( $("#OVCodigoPostal").text() );
			$("#Telefono").val( $("#OVTelefono").text() );
			$("#Email").val( $("#OVEmail").text() );
			
		}
		, GuardarDatos: function(){
			
			$.ajax({
				  url: "/pz/wms/OV/OV_Ajax2.asp"
				, method: "post"
				, async: false
				, data: {
					  Tarea: 1
					, OV_ID: $("#OV_ID").val()
					, Calle: $("#Calle").val()
					, NumeroExterior: $("#NumeroExterior").val()
					, NumeroInterior: $("#NumeroInterior").val()
					, Colonia: $("#Colonia").val()
					, Delegacion: $("#Delegacion").val()
					, Ciudad: $("#Ciudad").val()
					, Estado: $("#Estado").val()
					, CodigoPostal: $("#CodigoPostal").val()
					, Telefono: $("#Telefono").val()
					, Email: $("#Email").val()
				}
				, success: function(res){
					
					if( parseInt(res) == 0 ){
					
						$("#OVCalle").text( $("#Calle").val() );
						$("#OVNumeroExterior").text( $("#NumeroExterior").val() );
						$("#OVNumeroInterior").text( $("#NumeroInterior").val() );
						$("#OVColonia").text( $("#Colonia").val() );
						$("#OVDelegacion").text( $("#Delegacion").val() );
						$("#OVCiudad").text( $("#Ciudad").val() );
						$("#OVEstado").text( $("#Estado").val() );
						$("#OVCodigoPostal").text( $("#CodigoPostal").val() );
						$("#OVTelefono").text( $("#Telefono").val() );
						$("#OVEmail").text( $("#Email").val() );
									
						Avisa("success", "Datos Generales", "Se actualizaron los datos de Orden de Venta");
						$('#DatosParciales').modal('hide'); 
					} else {
					
						Avisa("error", "Datos Generales", "No se actualizaron los datos de la Orden de Venta");
						
					}
					
				}
				, error: function(){
					
					Avisa("error", "Datos Generales", "No se actualizaron los datos de la Orden de Venta");
					
				}
				
			});
			
		}
	}
<% 
	}
//HA ID: 1 FIN 
%>	
    
    
</script>    
