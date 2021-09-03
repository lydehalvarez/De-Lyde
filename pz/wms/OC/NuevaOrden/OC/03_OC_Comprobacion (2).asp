<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%	

	var OC_ID = Parametro("OC_ID",1)
	var Prov_ID = Parametro("Prov_ID",0)
	var Pro_ID = Parametro("Pro_ID",0)	
	var Usu_ID = Parametro("IDUsuario",0)
  	
	var OC_Serie = 0

  	var sSQL = "Select Prov_RazonSocial, Prov_RFC, Prov_ContactoVenta, Prov_EmailVentas, Prov_TelefonoVentas  "
	    sSQL += " , dbo.fn_CatGral_DameDato(56,Prov_PersonalidadJuridicaCG56) as PersonalidadJuridica "
		sSQL += " , ISNULL(CONVERT(NVARCHAR(20),Prov_UltimaCompra ,103),'') as UltimaCompra "
	    sSQL += " FROM Proveedor "
	    sSQL += " WHERE Prov_ID = " + Prov_ID

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
		    Pro_ID = OC_BPM_Pro_ID					
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
                            <dt>Estatus:</dt> <dd><span class="label label-primary">Active</span></dd>
                        </dl>
                        <dl class="dl-horizontal">
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
                              <div class="ocfecha" id="OC_FechaRequeridaCal1" >
                            <input name="OC_FechaRequerida" id="OC_FechaRequerida" placeholder="dd/mm/aaaa" type="text" 
                            data-date-format="dd/mm/yyyy" data-date-viewmode="years" 
                            class="date-picker" value="<%=OC_FechaRequerida%>"> 
                            <span class="input-group-addon"> <i class="fa fa-calendar"></i></span>
                        </div>
                            
                            
                            </dd>
                        </dl>
                    </div>
                    <div class="col-lg-7" id="cluster_info">
                        <dl class="dl-horizontal">
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
                        </dl>
                    </div>
                </div>
                <div class="row m-t-sm">

                    
                    
            <div class="row m-t-sm">
                <div class="col-lg-12">
                <div class="panel blank-panel">
                <div class="panel-heading">
                    <div class="panel-options">
                        <ul class="nav nav-tabs">
                            <li class="active"><a href="#tab-3" data-toggle="tab">Solicitud</a></li>
                            <li class=""><a href="#tab-4" data-toggle="tab">Factura</a></li>
                            <li class=""><a href="#tab-5" data-toggle="tab">Documentos</a></li>
                            <li class=""><a href="#tab-2" data-toggle="tab">Mensajes</a></li>
                            <li class=""><a href="#tab-6" data-toggle="tab">Actividad</a></li>
                            
                        </ul>
                    </div>
                </div>

                <div class="panel-body">

                <div class="tab-content">
                <div class="tab-pane" id="tab-2">
                    <div class="feed-activity-list">
                        <div class="feed-element">
                            <a href="#" class="pull-left">
                                <img alt="image" class="img-circle" src="img/a2.jpg">
                            </a>
                            <div class="media-body ">
                                <small class="pull-right">2h ago</small>
                                <strong>Mark Johnson</strong> posted message on <strong>Monica Smith</strong> site. <br>
                                <small class="text-muted">Today 2:10 pm - 12.06.2014</small>
                                <div class="well">
                                    Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s.
                                    Over the years, sometimes by accident, sometimes on purpose (injected humour and the like).
                                </div>
                            </div>
                        </div>
                        <div class="feed-element">
                            <a href="#" class="pull-left">
                                <img alt="image" class="img-circle" src="img/a3.jpg">
                            </a>
                            <div class="media-body ">
                                <small class="pull-right">2h ago</small>
                                <strong>Janet Rosowski</strong> add 1 photo on <strong>Monica Smith</strong>. <br>
                                <small class="text-muted">2 days ago at 8:30am</small>
                            </div>
                        </div>
                        <div class="feed-element">
                            <a href="#" class="pull-left">
                                <img alt="image" class="img-circle" src="img/a4.jpg">
                            </a>
                            <div class="media-body ">
                                <small class="pull-right text-navy">5h ago</small>
                                <strong>Chris Johnatan Overtunk</strong> started following <strong>Monica Smith</strong>. <br>
                                <small class="text-muted">Yesterday 1:21 pm - 11.06.2014</small>
                                <div class="actions">
                                    <a class="btn btn-xs btn-white"><i class="fa fa-thumbs-up"></i> Like </a>
                                    <a class="btn btn-xs btn-white"><i class="fa fa-heart"></i> Love</a>
                                </div>
                            </div>
                        </div>
                        <div class="feed-element">
                            <a href="#" class="pull-left">
                                <img alt="image" class="img-circle" src="img/a5.jpg">
                            </a>
                            <div class="media-body ">
                                <small class="pull-right">2h ago</small>
                                <strong>Kim Smith</strong> posted message on <strong>Monica Smith</strong> site. <br>
                                <small class="text-muted">Yesterday 5:20 pm - 12.06.2014</small>
                                <div class="well">
                                    Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s.
                                    Over the years, sometimes by accident, sometimes on purpose (injected humour and the like).
                                </div>
                            </div>
                        </div>
                        <div class="feed-element">
                            <a href="#" class="pull-left">
                                <img alt="image" class="img-circle" src="img/profile.jpg">
                            </a>
                            <div class="media-body ">
                                <small class="pull-right">23h ago</small>
                                <strong>Monica Smith</strong> love <strong>Kim Smith</strong>. <br>
                                <small class="text-muted">2 days ago at 2:30 am - 11.06.2014</small>
                            </div>
                        </div>
                        <div class="feed-element">
                            <a href="#" class="pull-left">
                                <img alt="image" class="img-circle" src="img/a7.jpg">
                            </a>
                            <div class="media-body ">
                                <small class="pull-right">46h ago</small>
                                <strong>Mike Loreipsum</strong> started following <strong>Monica Smith</strong>. <br>
                                <small class="text-muted">3 days ago at 7:58 pm - 10.06.2014</small>
                            </div>
                        </div>
                    </div>

                </div>
                <div class="tab-pane active" id="tab-3">
                    <div class="row">
                        <div class="col-lg-12">
                            <div class="m-b-md">
                                <h3 class="col-lg-offset-1">Descripci&oacute;n</h3>
                                <p class="col-lg-offset-2">
                        	<input type="text" placeholder="Escriba para que ser&aacute; la compra" class="form-control" 
                                   id="OC_Descripcion" value="<%=OC_Descripcion%>" autocomplete="off" ><br />
                                </p>
                            </div>
                        </div>
                    </div>
				</div>
                <div class="tab-pane" id="tab-4">
       
                    <div class="ibox">
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
                    </div>
                
				</div>
                 <div class="tab-pane" id="tab-5">
                
				</div>
                <div class="tab-pane" id="tab-6">

                    <table class="table table-striped">
                        <thead>
                        <tr>
                            <th>Status</th>
                            <th>Title</th>
                            <th>Start Time</th>
                            <th>End Time</th>
                            <th>Comments</th>
                        </tr>
                        </thead>
                        <tbody>
                        <tr>
                            <td>
                                <span class="label label-primary"><i class="fa fa-check"></i> Completed</span>
                            </td>
                            <td>
                               Create project in webapp
                            </td>
                            <td>
                               12.07.2014 10:10:1
                            </td>
                            <td>
                                14.07.2014 10:16:36
                            </td>
                            <td>
                            <p class="small">
                                Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable.
                            </p>
                            </td>

                        </tr>
                        <tr>
                            <td>
                                <span class="label label-primary"><i class="fa fa-check"></i> Accepted</span>
                            </td>
                            <td>
                                Various versions
                            </td>
                            <td>
                                12.07.2014 10:10:1
                            </td>
                            <td>
                                14.07.2014 10:16:36
                            </td>
                            <td>
                                <p class="small">
                                    Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).
                                </p>
                            </td>

                        </tr>
                        <tr>
                            <td>
                                <span class="label label-primary"><i class="fa fa-check"></i> Sent</span>
                            </td>
                            <td>
                                There are many variations
                            </td>
                            <td>
                                12.07.2014 10:10:1
                            </td>
                            <td>
                                14.07.2014 10:16:36
                            </td>
                            <td>
                                <p class="small">
                                    There are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which
                                </p>
                            </td>

                        </tr>
                        <tr>
                            <td>
                                <span class="label label-primary"><i class="fa fa-check"></i> Reported</span>
                            </td>
                            <td>
                                Latin words
                            </td>
                            <td>
                                12.07.2014 10:10:1
                            </td>
                            <td>
                                14.07.2014 10:16:36
                            </td>
                            <td>
                                <p class="small">
                                    Latin words, combined with a handful of model sentence structures
                                </p>
                            </td>

                        </tr>
                        <tr>
                            <td>
                                <span class="label label-primary"><i class="fa fa-check"></i> Accepted</span>
                            </td>
                            <td>
                                The generated Lorem
                            </td>
                            <td>
                                12.07.2014 10:10:1
                            </td>
                            <td>
                                14.07.2014 10:16:36
                            </td>
                            <td>
                                <p class="small">
                                    The generated Lorem Ipsum is therefore always free from repetition, injected humour, or non-characteristic words etc.
                                </p>
                            </td>

                        </tr>
                        <tr>
                            <td>
                                <span class="label label-primary"><i class="fa fa-check"></i> Sent</span>
                            </td>
                            <td>
                                The first line
                            </td>
                            <td>
                                12.07.2014 10:10:1
                            </td>
                            <td>
                                14.07.2014 10:16:36
                            </td>
                            <td>
                                <p class="small">
                                    The first line of Lorem Ipsum, "Lorem ipsum dolor sit amet..", comes from a line in section 1.10.32.
                                </p>
                            </td>

                        </tr>
                        <tr>
                            <td>
                                <span class="label label-primary"><i class="fa fa-check"></i> Reported</span>
                            </td>
                            <td>
                                The standard chunk
                            </td>
                            <td>
                                12.07.2014 10:10:1
                            </td>
                            <td>
                                14.07.2014 10:16:36
                            </td>
                            <td>
                                <p class="small">
                                    The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested.
                                </p>
                            </td>

                        </tr>
                        <tr>
                            <td>
                                <span class="label label-primary"><i class="fa fa-check"></i> Completed</span>
                            </td>
                            <td>
                                Lorem Ipsum is that
                            </td>
                            <td>
                                12.07.2014 10:10:1
                            </td>
                            <td>
                                14.07.2014 10:16:36
                            </td>
                            <td>
                                <p class="small">
                                    Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable.
                                </p>
                            </td>

                        </tr>
                        <tr>
                            <td>
                                <span class="label label-primary"><i class="fa fa-check"></i> Sent</span>
                            </td>
                            <td>
                                Contrary to popular
                            </td>
                            <td>
                                12.07.2014 10:10:1
                            </td>
                            <td>
                                14.07.2014 10:16:36
                            </td>
                            <td>
                                <p class="small">
                                    Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical
                                </p>
                            </td>

                        </tr>

                        </tbody>
                    </table>

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
			
			$("#dvCuerpoDatos").load("/pz/mms/OC/OC_Comprobacion_Carga.asp" + sDatos);
			$("#dvBtnRegresar").show("slow")
        });  

		$("#dvBtnRegresar").click(function(e) {
            e.preventDefault();
			$("#dvBtnRegresar").hide("slow")
			
		var sDatos  = "?OC_ID=" + $("#OC_ID").val() 
		    sDatos += "&Prov_ID=" + $("#Prov_ID").val() 
		    sDatos += "&Pro_ID=<%=Pro_ID%>" 
		    sDatos += "&OC_Serie=<%=OC_Serie%>"
		    sDatos += "&Usu_ID=" + $("#IDUsuario").val()
			
			$("#dvCuerpoDatos").load("/pz/mms/OC/OC_Comprobacion_Grid.asp" + sDatos);
			$("#dvBtnNuevo").show("slow")
        });

		$("#OC_Descripcion").blur(function(){
			$.post( "/pz/mms/OC/Ajax.asp" 
			   , { Tarea:9
			       ,OC_Descripcion:$("#OC_Descripcion").val()
				   ,Prov_ID:$("#Prov_ID").val()			   
				   ,OC_ID:$("#OC_ID").val() }	
			 );	            

        });

		BPM_CargaBotonesYEstatus()

		$("#dvBtnRegresar").hide()
		CargaGridFacturas()

    });
	
	function CargaGridFacturas(){
		var sDatos  = "?OC_ID=" + $("#OC_ID").val() 
		    sDatos += "&Prov_ID=" + $("#Prov_ID").val() 
		    sDatos += "&Pro_ID=<%=Pro_ID%>" 
		    sDatos += "&OC_Serie=<%=OC_Serie%>"
		    sDatos += "&Usu_ID=" + $("#IDUsuario").val()		
		
		$("#dvCuerpoDatos").load("/pz/mms/OC/OC_Comprobacion_Grid.asp" + sDatos);
		$("#dvSumas").load("/pz/mms/OC/OC_Comprobacion_Sumas.asp" + sDatos);
	}
	
	function BPM_CargaBotonesYEstatus(){
		var sDatos  = "?OC_ID=" + $("#OC_ID").val() 
		    sDatos += "&Prov_ID=" + $("#Prov_ID").val() 
		    sDatos += "&Pro_ID=<%=Pro_ID%>" 
		    sDatos += "&OC_Serie=<%=OC_Serie%>" 
		    sDatos += "&Usu_ID=" + $("#IDUsuario").val()
		
		$("#BPMBotones").load("/pz/mms/BPM/BPM_Botones.asp" + sDatos);
		//$("#BPMEstatus").load("/pz/mms/BPM/BPM_Estatus.asp" + sDatos);
	}
	
-->
</script> 
	
	
