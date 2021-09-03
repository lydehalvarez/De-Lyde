<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%	

	var OC_ID = Parametro("OC_ID",1)
	var Prov_ID = Parametro("Prov_ID",0)
	var Pro_ID = Parametro("Pro_ID",0)
	var Usu_ID = Parametro("IDUsuario",0)

	var OC_Serie = 0


  	var sSQL = "Select Prov_RazonSocial, Prov_Nombre, Prov_Clave, Prov_RFC, Prov_ContactoVenta, Prov_EmailVentas, Prov_TelefonoVentas  "
	    sSQL += " , dbo.fn_CatGral_DameDato(56,Prov_PersonalidadJuridicaCG56) as PersonalidadJuridica "
		sSQL += " , ISNULL(CONVERT(NVARCHAR(20),Prov_UltimaCompra ,103),'') as UltimaCompra "
	    sSQL += " FROM Proveedor "
	    sSQL += " WHERE Prov_ID = " + Prov_ID

 	var rsPr = AbreTabla(sSQL,1,0)	
	if (!rsPr.EOF){ 
		var Prov_RazonSocial = rsPr.Fields.Item("Prov_RazonSocial").Value
        var Prov_Nombre = rsPr.Fields.Item("Prov_Nombre").Value
		var Prov_RFC = rsPr.Fields.Item("Prov_RFC").Value		
		var PersonalidadJuridica = rsPr.Fields.Item("PersonalidadJuridica").Value
		var Prov_TelefonoVentas = rsPr.Fields.Item("Prov_TelefonoVentas").Value		
		var Prov_EmailVentas = rsPr.Fields.Item("Prov_EmailVentas").Value
		var Prov_ContactoVenta = rsPr.Fields.Item("Prov_ContactoVenta").Value
		var UltimaCompra = rsPr.Fields.Item("UltimaCompra").Value					
	}



	var sSQL = "SELECT OC_Descripcion, OC_Folio, OC_EstatusCG51, OC_Serie "
		sSQL += " , dbo.fn_Usuario_DameUsuario_porID(OC_UsuIDSolicita) as UsuSolicita "
        sSQL += " , dbo.fn_Usuario_DameUsuario_porID(OC_CompradorID) as Comprador "
        sSQL += " , dbo.fn_Usuario_DameUsuario_porID(OC_UsuIDOriginador) as UsuIDOriginador "		
		sSQL += " , CONVERT(NVARCHAR(20),OC_FechaElaboracion,103) as FechaElaboracion "  
		sSQL += " , CONVERT(NVARCHAR(20),OC_FechaRequerida,103) as OC_FechaRequerida " 
		sSQL += " , OC_BPM_Pro_ID, OC_BPM_Estatus, OC_BPM_Flujo "
	    sSQL += " FROM OrdenCompra "
		sSQL += " WHERE Prov_ID = " + Prov_ID
		sSQL += " AND OC_ID = " + OC_ID
	
		
	var rsOC = AbreTabla(sSQL,1,0)
    if (!rsOC.EOF){
		var UsuSolicita = rsOC.Fields.Item("UsuSolicita").Value
		var Comprador = rsOC.Fields.Item("Comprador").Value	
		var OC_Descripcion = rsOC.Fields.Item("OC_Descripcion").Value
		var UsuIDOriginador = rsOC.Fields.Item("UsuIDOriginador").Value		
		var FechaElaboracion = rsOC.Fields.Item("FechaElaboracion").Value		
		var OC_FechaRequerida = rsOC.Fields.Item("OC_FechaRequerida").Value	
		var OC_Folio = rsOC.Fields.Item("OC_Folio").Value	
		var OC_EstatusCG51 = rsOC.Fields.Item("OC_EstatusCG51").Value	
		var OC_BPM_Pro_ID = rsOC.Fields.Item("OC_BPM_Pro_ID").Value
		var OC_BPM_Estatus = rsOC.Fields.Item("OC_BPM_Estatus").Value
		var OC_BPM_Flujo = rsOC.Fields.Item("OC_BPM_Flujo").Value
            OC_Serie =  rsOC.Fields.Item("OC_Serie").Value
	}


var Parametros = "?OC_ID=" + OC_ID + "&Prov_ID=" + Prov_ID + "&Pro_ID=" + Pro_ID + "&OC_Serie=" + OC_Serie + "&Usu_ID=" + Usu_ID
		
%>
<style type="text/css">

	.ocfecha{
		display: table;
		width: 127px;
	}

</style>    
<div class="wrapper wrapper-content animated fadeInRight">
  <div class="row">
    <div class="col-lg-12">
      <div class="ibox product-detail">
        <div class="ibox-content">
          <div class="row">
            <div class="col-md-9">
              <h3 class="font-bold m-b-xs"><%=Prov_Nombre%> <span class="pull-right"><%=OC_Folio%></span></h3>
              <!--div class="m-t-md">
                <h2 class="product-main-price">$406,602 <small class="text-muted">Exclude Tax</small></h2>
              </div-->
              <hr>        
              <div class="m-t-md"> 
                <div class="btn-group pull-right" id="BPMBotones"><button type="button" class="btn btn-outline btnEstatus btn-danger btn-sm" title="Cancela la solicitud de compra" data-prodid="1" onclick="javascript:BotonEstatus($(this))">
            Cancelar solicitud</button>&nbsp;<button type="button" class="btn btn-outline btnEstatus btn-primary btn-sm" title="Solicita autorizacion de compra" data-prodid="2" onclick="javascript:BotonEstatus($(this))">
            Solicita autorizaci&oacute;n de compra</button></div>
                <div class="btn-group pull-right" id="BPMEstatus"></div>
              </div>
              <div class="small text-muted"></div>
              <!--h4>Product description</h4>
              <div class="small text-muted">
                It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is<br>
                <br>
                There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don't look even slightly believable.
              </div-->
              <div class="row">
                  <div class="col-md-5" id="cluster_info">
                      <dl class="small m-t-md dl-horizontal">
                        <dt></dt>
                        <dd></dd>
                        <dt>Estatus:</dt>
                        <dd><span class="label label-primary">Activo</span></dd>
                        <dt>Creada por:</dt>  
                        <dd><%=UsuIDOriginador%></dd>
                        <dt>Solicitada por:</dt>
                        <dd><%=UsuSolicita%></dd>
                        <dt>Comprador:</dt>
                        <dd><%=Comprador%></dd>
                        <dt>Fecha ingresada:</dt>
                        <dd><%=FechaElaboracion%></dd>
                        <dt>Fecha solicitada:</dt>
                        <dd>
                            <div class="ocfecha" id="OC_FechaRequeridaCal1">
                                <input name="OC_FechaRequerida" id="OC_FechaRequerida" placeholder="dd/mm/aaaa" type="text" 
                            data-date-format="dd/mm/yyyy" data-date-viewmode="years" 
                            class="input-sm form-control date-picker" value="<%=OC_FechaRequerida%>"> 
                            <span class="input-group-addon"> <i class="fa fa-calendar"></i></span>
                            </div>
                        </dd>                
                      </dl>
                  </div>  
                  <div class="col-lg-7" id="cluster_info">
                    <dl class="dl-horizontal">
                        <dt></dt>
                        <dd></dd>
                        <dt>Ultima compra:</dt>
                        <dd><%=UltimaCompra%></dd>
                        <dt>R.F.C.:</dt>
                        <dd><%=Prov_RFC%></dd>
                        <dt>P. jur&iacute;dica:</dt>
                        <dd><%=PersonalidadJuridica%></dd>
                        <dt>Contacto ventas:</dt>
                        <dd><%=Prov_ContactoVenta%></dd>
                        <dt>Tel&eacute;fono:</dt>
                        <dd><%=Prov_TelefonoVentas%></dd>
                        <dt>e-mail:</dt>
                        <dd><%=Prov_EmailVentas%></dd>
                    </dl>
                   </div>
              </div>
              <h4>Descripci&oacute;n</h4>
              <div class="small text-muted">
                <!--It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is<br>-->
                <!--input type="text" placeholder="Escriba para que ser&aacute; la compra" class="form-control" id="OC_Descripcion" value="<%=OC_Descripcion%>" autocomplete="off" -->
                <textarea placeholder="Escriba para que ser&aacute; la compra" class="input-sm form-control" id="OC_Descripcion" value="<%=OC_Descripcion%>" autocomplete="off"></textarea>
              </div>                  
              <hr>
              <div class="row">
                <div class="col-lg-12">
                    <div class="ibox float-e-margins" id="dvBtnNuevo">
                        <div class="ibox-title">
                            <h5>Facturas cargadas</h5>
                            <button class="btn btn-primary pull-right" id="btnCargaFactura" style="display:none">
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
              <!--div>
                <div class="btn-group">
                  <button class="btn btn-primary btn-sm"><i class="fa fa-cart-plus"></i> Add to cart</button> <button class="btn btn-white btn-sm"><i class="fa fa-star"></i> Add to wishlist</button> <button class="btn btn-white btn-sm"><i class="fa fa-envelope"></i> Contact with author</button>
                </div>
              </div-->
            </div>
            <div class="col-md-3" id="dvSumas"></div>      
          </div>
        </div>
        <div class="ibox-footer">
          <!--span class="pull-right">Full stock - <i class="fa fa-clock-o"></i> 14.04.2016 10:04 pm</span> The generated Lorem Ipsum is therefore always free
        </div-->
      </div>
    </div>
  </div>
</div>
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
		});  
    
		$("#btnCargaFactura").click(function(e) {
            e.preventDefault();
			$("#dvBtnNuevo").hide("slow")
			$("#dvCuerpoDatos").load("/pz/fnd/OC/OC_Comprobacion_Carga.asp<%=Parametros%>");
			$("#dvBtnRegresar").show("slow")
        });  
		
		$("#dvBtnRegresar").click(function(e) {
            e.preventDefault();
			$("#dvBtnRegresar").hide("slow")
			$("#dvCuerpoDatos").load("/pz/fnd/OC/OC_Comprobacion_Grid.asp<%=Parametros%>");
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
	
        $(".btnEstatus").click(function(e){
			e.preventDefault()
			var o = $(this)
			$(".btnEstatus").removeClass("active")
			o.addClass("active")
			
			$("#btnBPM").hide("slow")
			
			$.post( "/pz/fnd/OC/Ajax.asp" 
			   , { Tarea:3
			       ,OC_EstatusCG51:o.data("estatusid")
				   ,Prov_ID:$("#Prov_ID").val()			   
				   ,OC_ID:$("#OC_ID").val()	 		   	   
				   ,Usu_ID:$("#IDUsuario").val() }
			   , function(output) { 
					var sMensaje= "Se actualizo el estatus de la orden de compra correctamente.";
					Avisa("success",'Actualizacion de estatus',sMensaje)	
			});				
			
			$.post( "/pz/fnd/BPM/BPM_Ajax.asp" 
			     , {  Tarea:1
					 ,Pro_ID:<%=OC_BPM_Pro_ID%>
					 ,Flujo:<%=OC_BPM_Flujo%>	
					 ,ProD_ID:o.data("prodid")
					 ,Prov_ID:$("#Prov_ID").val()			   
					 ,OC_ID:$("#OC_ID").val()	 		   	   
					 ,Usu_ID:$("#IDUsuario").val() });
			
		});
	
		$("#dvBtnRegresar").hide()
		CargaGridFacturas()
		
    });
	
	function CargaGridFacturas(){
		$("#dvCuerpoDatos").load("/pz/fnd/OC/OC_Comprobacion_Grid.asp<%=Parametros%>");
		$("#dvSumas").load("/pz/fnd/OC/OC_Comprobacion_Sumas.asp<%=Parametros%>");
	}
	
	function BPM_CargaBotonesYEstatus(){
		$("#BPMBotones").load("/pz/fnd/BPM/BPM_Botones.asp<%=Parametros%>");
		$("#BPMEstatus").load("/pz/fnd/BPM/BPM_Estatus.asp<%=Parametros%>");
	}

-->
</script>
