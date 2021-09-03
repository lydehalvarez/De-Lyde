<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%	

	var OC_ID = Parametro("OC_ID",1)
	var Prov_ID = Parametro("Prov_ID",0)

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



	var sSQL = "SELECT OC_Descripcion "
		sSQL += " , dbo.fn_Usuario_DameUsuario_porID(OC_UsuIDSolicita) as UsuSolicita "
        sSQL += " , dbo.fn_Usuario_DameUsuario_porID(OC_CompradorID) as Comprador "
        sSQL += " , dbo.fn_Usuario_DameUsuario_porID(OC_UsuIDOriginador) as UsuIDOriginador "		
		sSQL += " , CONVERT(NVARCHAR(20),OC_FechaElaboracion,103) as FechaElaboracion "  
		sSQL += " , CONVERT(NVARCHAR(20),OC_FechaRequerida,103) as OC_FechaRequerida " 
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
	}

%>

<div class="wrapper wrapper-content animated fadeInRight">



            <div class="row">
                <div class="col-md-9">

					<div class="ibox-content">
                            <div class="row">
                                <div class="col-lg-12">
                                    <div class="m-b-md">
                                        <button class="btn btn-primary pull-right" style="margin: 0px 15px 0px 15px;"><i class="fa fa fa-plus"></i> Guardar</button>
            &nbsp;&nbsp;&nbsp;          <button class="btn btn-warning pull-right"><i class="fa fa fa-minus"></i> Eliminar</button>
                                        <hr />
                                        <h2><%=Prov_RazonSocial%></h2> 
                                    </div>
                                    <!-- dl class="dl-horizontal">
                                        <dt>Status:</dt> <dd><span class="label label-primary">Active</span></dd>
                                    </dl -->
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-lg-5">
                                    <dl class="dl-horizontal">

                                        <dt>Creada por:</dt> <dd><%=UsuIDOriginador%></dd>
                                        <dt>Solicitada por:</dt> <dd><%=UsuSolicita%></dd>
                                        <dt>Comprador:</dt> <dd><%=Comprador%></dd>
                                        <dt>Fecha ingresada:</dt> <dd><%=FechaElaboracion%></dd>  
                                        <dt>Fecha solicitada:</dt> <dd><%=OC_FechaRequerida%></dd>
                                    </dl>
                                </div>
                                <div class="col-lg-7" id="cluster_info">
                                    <dl class="dl-horizontal" >

                                        <dt>Ultima compra:</dt> <dd><%=UltimaCompra%></dd>
                                        <dt>RFC:</dt> <dd><%=Prov_RFC%></dd>
                                        <dt>P. jur&iacute;dica:</dt> <dd><%=PersonalidadJuridica%></dd>
                                        <dt>Contacto ventas:</dt> <dd><%=Prov_ContactoVenta%></dd>
                                        <dt>tel&eacute;fono:</dt> <dd><%=Prov_TelefonoVentas%></dd>
                                        <dt>e-mail:</dt> <dd><%=Prov_EmailVentas%></dd>
                                        
                                    </dl>
                                </div>
                            </div>
                            <div class="row m-t-sm">
                            
                            <div class="row">
                                <div class="col-lg-12">
                                    <div class="m-b-md">
                                    <h3 class="col-lg-offset-1">Descripci&oacute;n</h3>
                                    <p class="col-lg-offset-2"><%=OC_Descripcion%></p>
                                    </div>
                                </div>
                            </div> 
                            
                    <div class="ibox" id="dvCuerpoDatos">
                    </div>


                            </div>
                        </div>

                </div>
                <div class="col-md-3">

                    <div class="ibox">
                        <div class="ibox-title">
                            <h5>Total general</h5>
                        </div>
                        <div class="ibox-content">
                            <span>
                               Sub Total
                          </span>
                            <h2 class="font-bold">
                                $0,00
                            </h2>
                            <span>
                                IVA
                            </span>
                            <h2 class="font-bold">
                                $0,00
                            </h2>
                            <hr/>
                             <span>
                                Total
                            </span>
                            <h2 class="font-bold">
                                $0,00
                            </h2>
                        </div>
                    </div>

                    <div class="ibox">
                        <div class="ibox-title">
                            <h5>Autorizaciones</h5>
                        </div>
                        <div class="ibox-content text-center">
                            <span >
                                Nahum Kopchinsky
                            </span> 
                            <hr/>                       
                            <span >
                                Fredy Soberanis
                            </span><span >
                                Ram&oacute;n Soler
                            </span>

                          <hr/>
                        </div>
                    </div>

                </div>
            </div>




        </div>