<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%	
    var bDebIQ4Web = false
	var Cli_ID = Parametro("Cli_ID",-1)
	var CliOC_ID = Parametro("CliOC_ID",-1)
	var Usu_ID = Parametro("IDUsuario",0)
  	
	var OC_Serie = 0


	var sSQL = "SELECT OC_Descripcion, OC_Folio, OC_EstatusCG51, OC_Serie, Prov_ID "
		sSQL += " , dbo.fn_Usuario_DameUsuario_porID(OC_UsuIDSolicita) as UsuSolicita " //fn_Usuario_DameUsuario_porID
        sSQL += " , dbo.fn_Usuario_DameUsuario(OC_CompradorID) as Comprador "
        sSQL += " , dbo.fn_Usuario_DameUsuario(OC_UsuIDOriginador) as UsuIDOriginador "		
		sSQL += " , CONVERT(NVARCHAR(20),OC_FechaElaboracion,103) as FechaElaboracion "  
		sSQL += " , CONVERT(NVARCHAR(20),OC_FechaRequerida,103) as OC_FechaRequerida " 
		sSQL += " , OC_BPM_Pro_ID, OC_BPM_Estatus, OC_BPM_Flujo "
		sSQL += " , dbo.fn_OrdenCompra_DameEstatus(OC_ID) as ESTATUS "
	    sSQL += " FROM Cliente_OrdenCompra "
		sSQL += " WHERE Cli_ID = " + Cli_ID
	    sSQL += " AND CliOC_ID = " + CliOC_ID 
	
       if (bDebIQ4Web){ Response.Write("<br>OrdenCompra<br>"+sSQL) }
		
	var rsOC = AbreTabla(sSQL,1,0)
    if (!rsOC.EOF){
		var UsuSolicita = rsOC.Fields.Item("UsuSolicita").Value
		    Prov_ID = rsOC.Fields.Item("Prov_ID").Value
		var Comprador = rsOC.Fields.Item("Comprador").Value	
		var OC_Descripcion = rsOC.Fields.Item("OC_Descripcion").Value
		var UsuIDOriginador = rsOC.Fields.Item("UsuIDOriginador").Value		
		var FechaElaboracion = rsOC.Fields.Item("FechaElaboracion").Value		
		var OC_FechaRequerida = rsOC.Fields.Item("OC_FechaRequerida").Value	
		var ESTATUS = rsOC.Fields.Item("ESTATUS").Value	
		var OC_Folio = rsOC.Fields.Item("OC_Folio").Value	
		var OC_EstatusCG51 = rsOC.Fields.Item("OC_EstatusCG51").Value	
		var OC_BPM_Pro_ID = rsOC.Fields.Item("OC_BPM_Pro_ID").Value
		var OC_BPM_Estatus = rsOC.Fields.Item("OC_BPM_Estatus").Value
		var OC_BPM_Flujo = rsOC.Fields.Item("OC_BPM_Flujo").Value	
		    OC_Serie =  rsOC.Fields.Item("OC_Serie").Value	
		    Pro_ID = OC_BPM_Pro_ID					
	}



  	var sSQL = "Select Prov_RazonSocial, Prov_RFC, Prov_ContactoVenta, Prov_EmailVentas, Prov_TelefonoVentas "
	    sSQL += " , dbo.fn_CatGral_DameDato(56,Prov_PersonalidadJuridicaCG56) as PersonalidadJuridica "
		sSQL += " , ISNULL(CONVERT(NVARCHAR(20),Prov_UltimaCompra ,103),'') as UltimaCompra "
	    sSQL += " FROM Proveedor "
	    sSQL += " WHERE Prov_ID = " + Prov_ID
   
        if (bDebIQ4Web){ Response.Write("Proveedor<br>"+sSQL) }
   
 	var rsPr = AbreTabla(sSQL,1,0)	
	if (!rsPr.EOF){ 
		var Prov_RazonSocial = rsPr.Fields.Item("Prov_RazonSocial").Value
		var Prov_RFC = rsPr.Fields.Item("Prov_RFC").Value		
		var PersonalidadJuridica = rsPr.Fields.Item("PersonalidadJuridica").Value
		var Prov_TelefonoVentas = rsPr.Fields.Item("Prov_TelefonoVentas").Value		
		var Prov_EmailVentas = rsPr.Fields.Item("Prov_EmailVentas").Value
		var Prov_ContactoVenta = rsPr.Fields.Item("Prov_ContactoVenta").Value
		var UltimaCompra = rsPr.Fields.Item("UltimaCompra").Value					
	}

var Parametros = "?OC_ID=" + OC_ID + "&Prov_ID=" + Prov_ID + "&Pro_ID=" + Pro_ID + "&OC_Serie=" + OC_Serie + "&Usu_ID=" + Usu_ID
		
%>
<style type="text/css">

	.ocfecha{
		display: table;
		width: 85px;
	}

</style>
<div class="wrapper wrapper-content animated fadeInRight">
    <div class="row">
        <div class="col-md-9">
            <div class="ibox-content">
                <div class="row">
                    <div class="col-lg-12">
                        <div class="m-b-md">
                            <h2 class="pull-right"><%=OC_Folio%></h2>
                            <h2><%=Prov_RazonSocial%></h2>
                        </div>
                    </div>
                </div>
                         
             <div class="ibox-title">            
                  <div class="btn-group pull-right" style="margin-bottom:15px;" id="BPMBotones"></div>
                  <div class="btn-group pull-right" style="margin-bottom:15px;" id="BPMEstatus"></div>
            </div>    
                
                <div class="row">
                    <div class="col-lg-5">
                    	<dl class="dl-horizontal">
                            <dt>Estatus:</dt> <dd><span class="label label-primary"><%=ESTATUS%></span></dd>
                        </dl>
                        <!--Datos de la Orden de compra-->
                        <dl class="dl-horizontal">
                            <dt>Creada por:</dt>
                            <dd><%=UsuIDOriginador%></dd>
                            <dt>Solicitada por:</dt>
                            <dd><%=UsuSolicita%></dd>
                            <dt>Fecha ingresada:</dt>
                            <dd><%=FechaElaboracion%></dd>
                            <dt>Fecha Requerida:</dt>
                            <dd><%=OC_FechaRequerida%>
                            </dd>
                        </dl>
                    </div>
                    <!--Datos del Proveedor-->
                    <div class="col-lg-7" id="cluster_info">
                     <!--   <dl class="dl-horizontal">
                            <dt>Ultima compra:</dt>
                            <dd><%=UltimaCompra%></dd>
                            <dt>RFC:</dt>
                            <dd><%=Prov_RFC%></dd>
                            <dt>P. jur&iacute;dica:</dt>
                            <dd><%=PersonalidadJuridica%></dd>
                            <dt>Contacto ventas:</dt>
                            <dd><%=Prov_ContactoVenta%></dd>
                            <dt>tel&eacute;fono:</dt>
                            <dd><%=Prov_TelefonoVentas%></dd>
                            <dt>e-mail:</dt>
                            <dd><%=Prov_EmailVentas%></dd>
                        </dl>  -->
                    </div>
                </div>
                <div class="row">
                    <div class="col-lg-12">
                        <div class="m-b-md">
                            <h3 class="col-lg-offset-1">Descripci&oacute;n</h3>
                            <p class="col-lg-offset-2"><%=OC_Descripcion%></p>
                        </div>
                    </div>
                </div>
                <div class="row m-t-sm">

                    
                    
            <div class="row m-t-sm">
                <div class="col-lg-12">
                <div class="panel blank-panel">
                  <div class="panel-body">
                <div class="tab-pane" id="tab-4">
       
                    <div class="ibox">
                        <div class="row">
                            <div class="col-lg-12">
                                <div class="ibox float-e-margins" id="dvBtnNuevo">
                                    <div class="ibox-title">
                                        <h5>Facturas cargadas</h5>
                                        <button class="btn btn-primary pull-right" id="btnCargaFactura" >
                                        <i class="fa fa fa-plus"></i> Cargar una nueva factura
                                        </button>
                                    </div>
                                </div>
                                <div class="ibox float-e-margins" id="dvBtnRegresar">
                                    <div class="ibox-title">
                                        <h5>Carga de archivos XML y PDF de la factura</h5>
                                        <button class="btn btn-primary pull-right" id="btnRegresar">
                                        <i class="fa fa fa-plus"></i> Regresar
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

                </div>
                </div>
            </div>
                    
             </div>
            </div>
        </div>
        <div class="col-md-3" id="dvSumas"></div>
    </div>
</div> 
<link href="/Template/inspina/css/plugins/jasny/jasny-bootstrap.min.css" rel="stylesheet">
<!-- Jasny -->
<script src="/Template/inspina/js/plugins/jasny/jasny-bootstrap.min.js"></script>  

<link rel="stylesheet" type="text/css" href="/Template/inspina/js/plugins/bootstrap-datepicker/css/datepicker.css"/>
<script type="text/javascript" src="/Template/inspina/js/plugins/bootstrap-datepicker/js/bootstrap-datepicker.js"></script>
<script type="text/javascript" src="/Template/inspina/js/plugins/bootstrap-datepicker/js/locales/bootstrap-datepicker.es.js"></script>
   
<script type="text/javascript">
<!--
	$(document).ready(function() { 

		$("#OC_FechaRequerida").datepicker({
			format: 'dd/mm/yyyy',
			language: 'es',
			autoclose: true
		});   

		$("#OC_FechaRequeridaCal1").click(function(){
			$('#OC_FechaRequerida').data("datepicker").show();
		})

		$("#btnCargaFactura").click(function(e) {
            e.preventDefault();
			$("#dvBtnNuevo").hide("slow")
			
		var sDatos  = "?OC_ID=" + $("#OC_ID").val() 
		    sDatos += "&Prov_ID=" + $("#Prov_ID").val() 
		    sDatos += "&Pro_ID=<%=Pro_ID%>"
		    sDatos += "&OC_Serie=<%=OC_Serie%>"
		    sDatos += "&Usu_ID=" + $("#IDUsuario").val()
			
			$("#dvCuerpoDatos").load("/pz/fnd/OC/OC_Factura_Carga.asp" + sDatos);
			$("#dvBtnRegresar").show("slow")
        });  

		$("#dvBtnRegresar").click(function(e) {
            e.preventDefault();
			
			$("#dvBtnRegresar").hide("slow")
		    CargaGridFacturas()
			$("#dvBtnNuevo").show("slow")
        });

		$("#OC_Descripcion").blur(function(){
			$.post( "/pz/fnd/OC/Ajax.asp" 
			   , { Tarea:9
			       ,OC_Descripcion:$("#OC_Descripcion").val()
				   ,Prov_ID:$("#Prov_ID").val()			   
				   ,OC_ID:$("#OC_ID").val() }	
			 );	            

        });

		//BPM_CargaBotonesYEstatus()

		$("#dvBtnRegresar").hide()
		
		CargaGridFacturas()

    });
    
    function CargaResumenDeArchivos(){
		var sDatos  = "?OC_ID=" + $("#OC_ID").val() 
		    sDatos += "&Pro_ID=<%=Pro_ID%>" 

		$("#dvSumas").load("/pz/fnd/OC/OC_Factura_Sumas.asp" + sDatos);        
    }
	
	function CargaGridFacturas(){
		var sDatos  = "?OC_ID=" + $("#OC_ID").val() 
		    sDatos += "&Prov_ID=" + $("#Prov_ID").val() 
		    sDatos += "&Pro_ID=<%=Pro_ID%>" 
		    sDatos += "&OC_Serie=<%=OC_Serie%>"
		    sDatos += "&Usu_ID=" + $("#IDUsuario").val()		
		
		$("#dvCuerpoDatos").load("/pz/fnd/OC/OC_Factura_Grid.asp" + sDatos);
		$("#dvSumas").load("/pz/fnd/OC/OC_Factura_Sumas.asp" + sDatos);
	}
	
	
-->
</script> 
	
	

