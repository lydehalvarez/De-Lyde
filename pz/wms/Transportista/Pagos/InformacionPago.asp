<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../../Includes/iqon.asp" -->
<%

	var bIQon4Web = false
	var iProvID = Parametro("Prov_ID",-1)
	var iPagID = Parametro("Pag_ID",-1)
   
	if(bIQon4Web){ Response.Write("Prov_ID: " + iProvID + " | Pag_ID: " + iPagID) }


	var sSQLPago = "SELECT PP.* "
		sSQLPago += ",(SELECT P.Prov_Nombre FROM Proveedor P WHERE P.Prov_ID = PP.Prov_ID) AS NOMPROV "
		sSQLPago += ",CONVERT(NVARCHAR(20),Pag_FechaPago,103) AS FECHAPAGO "
		sSQLPago += ",CONVERT(NVARCHAR(20),Pag_FechaAplicacion,103) AS FECHAAPLI "
		sSQLPago += ",CONVERT(NVARCHAR(20),Pag_FechaRegistro,103) AS FECHAREG "
		sSQLPago += ",CONVERT(NVARCHAR(20),Pag_FechaRegistro,22) AS FECHAREGFORM "
		
		sSQLPago += ",(SELECT CG.Cat_Nombre FROM Cat_Catalogo CG WHERE CG.Sec_ID = 150 AND CG.Cat_ID = PP.Pag_AplicadoCG150) AS ESTATUS "
		sSQLPago += "FROM Proveedor_Pago PP "
		sSQLPago += "WHERE PP.Prov_ID = " + iProvID
   		sSQLPago += " AND PP.Pag_ID = " + iPagID
   
	if(bIQon4Web){ Response.Write("<br>Pago: " + sSQLPago) }
   
		bHayParametros = false
		ParametroCargaDeSQL(sSQLPago,0) 
		
		var ClaseEstatus = ""
        var iEstatus = 0 //Parametro("Pag_AplicadoCG150",0)		
		
			ClaseEstatus = "plain"

			switch (parseInt(iEstatus)) {

				case 1:
					 ClaseEstatus = "info"   
				break;    
				case 5:
					ClaseEstatus = "primary"
				break;     
				case 4:
					ClaseEstatus = "success"
				break;    
				case 2:
					ClaseEstatus = "warning"
				break;   
				case 3:
					ClaseEstatus = "danger"
				break;  

			}   		
		
   
   
   
%>   
   
<div class="wrapper wrapper-content">
	<div class="row">
		<div class="col-lg-8">
			<div class="ibox float-e-margins">
				<div class="ibox-content">	
					<div>
						<span class="pull-right text-right">
						<small>Referencia bancaria: <strong><%=Parametro("Pag_ReferenciaBancaria","")%></strong></small>
							<br/>
							<br/>
							<span class="label label-<%=ClaseEstatus%>"><%=Parametro("ESTATUS","")%></span>
						</span>
						<h3 class="font-bold no-margins">
							<%=Parametro("NOMPROV","")%>
						</h3>
						<small></small>
						<br>
					</div>
					<br>
					<hr>
					<div class="row">
						<div class="col-lg-5">
							<dl class="dl-horizontal">
								<dt>Fecha de pago:</dt>
								<dd><%=Parametro("FECHAPAGO","")%></dd>
								<dt>Fecha de Aplicaci&oacute;n:</dt>
								<dd><%=Parametro("FECHAAPLI","")%></dd>
								<dt>&nbsp;</dt>
								<dd>&nbsp;</dd>
								<dt>Fecha de registro:</dt>
								<dd><%=Parametro("FECHAREGFORM","")%></dd>  
							</dl>
						</div>
						<div class="col-lg-7" id="cluster_info">
							<dl class="dl-horizontal">
								<dt>Monto:</dt>
								<dd class="text-left"><% Response.Write(FM + " " + formato(Parametro("Pag_Monto",0),2))%></dd>
								<dt>Monto aplicado:</dt>
								<dd class="text-left"><% Response.Write(FM + " " + formato(Parametro("Pag_MontoAplicado",0),2))%></dd>
								<dt>Monto parcial:</dt>
								<dd class="text-left"><% Response.Write(FM + " " + formato(Parametro("Pag_Parcial",0),2))%></dd>
							</dl>   
						</div>						
					</div>
					<br>
					<div class="row">
						<div class="col-lg-12">
								<div class="ibox float-e-margins" id="dvBtnNuevo">
                                    <div class="ibox-title">
                                        <h5>Facturas cargadas</h5>
                                        <button class="btn btn-primary btn-sm pull-right" id="btnCargaFactura" >
                                        <i class="fa fa-upload"></i>&nbsp;Cargar una nueva factura
                                        </button>
                                    </div>
                                </div>
                                <div class="ibox float-e-margins" id="dvBtnRegresar">
                                    <div class="ibox-title">
                                        <h5>Carga de archivos XML y PDF de la factura</h5>
                                        <button class="btn btn-primary btn-sm pull-right" id="btnRegresar">
                                        <i class="fa fa-mail-reply"></i>&nbsp;Regresar
                                        </button>
                                    </div>   
                                </div>						
						</div>
						<div class="ibox-content" id="dvCuerpoDatos">
                        	<!-- aqui cae el grid y el cargador de facturas  -->
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="col-lg-4">
			<div class="ibox float-e-margins">
				<div class="ibox-content">
				
				</div>
			</div>
		</div>					
	</div>
</div>
<link href="/Template/inspina/css/plugins/jasny/jasny-bootstrap.min.css" rel="stylesheet">
<!-- Jasny -->
<script src="/Template/inspina/js/plugins/jasny/jasny-bootstrap.min.js"></script>

<script type="text/javascript" language="javascript">

	$(document).ready(function() { 

		
		$("#btnCargaFactura").click(function(e) {
			e.preventDefault();
			
			$("#dvBtnNuevo").hide("slow");

			var sDatos  = "?OC_ID=" + $("#OC_ID").val() 
				sDatos += "&Prov_ID=" + $("#Prov_ID").val() 
				sDatos += "&Pag_ID=" + $("#Pag_ID").val()
				sDatos += "&Usu_ID=" + $("#IDUsuario").val()

			$("#dvCuerpoDatos").load("/pz/wms/Transportista/Pagos/Pago_Factura_Carga.asp" + sDatos);
			$("#dvBtnRegresar").show("slow");
			
        });  		
		
		
		$("#dvBtnRegresar").click(function(e) {
            e.preventDefault();
			
			$("#dvBtnRegresar").hide("slow");
		    CargaGridFacturas()
			$("#dvBtnNuevo").show("slow");
			
        });		
		

		$("#dvBtnRegresar").hide();
		CargaGridFacturas();
		
		
	});


	function CargaGridFacturas(){
		
		var sDatos  = "?OC_ID=" + $("#OC_ID").val() 
		    sDatos += "&Prov_ID=" + $("#Prov_ID").val()
			sDatos += "&Pag_ID=" + $("#Pag_ID").val()
		    sDatos += "&Usu_ID=" + $("#IDUsuario").val()
		
		
		$("#dvCuerpoDatos").load("/pz/wms/Transportista/Pagos/Pago_Factura_Grid.asp" + sDatos);
		//$("#dvSumas").load("/pz/fnd/OC/OC_Factura_Sumas.asp" + sDatos);
		
	}	
	
	
	
	
</script>	
	
	
	
	