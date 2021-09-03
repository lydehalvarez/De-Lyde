<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%	
   
    var iCliID = Parametro("Cli_ID",-1)
    var iCliOCID = Parametro("CliOC_ID",-1)

    //Response.Write("Cli_ID: " + iCliID + "CliOCID: " + iCliOCID)   

    var sSQLOC = "SELECT (SELECT CLI.Cli_Nombre FROM Cliente CLI WHERE CLI.Cli_ID = OC.Cli_ID) AS NOMBRE "
        sSQLOC += ",OC.CliOC_Folio "   
        sSQLOC += "FROM Cliente_OrdenCompra OC "
        sSQLOC += "WHERE OC.Cli_ID = " + iCliID
        sSQLOC += " AND OC.CliOC_ID = " + iCliOCID   

    var sNombreCliente = ""
    var sCliOCFolio = ""
   
	var rsOC = AbreTabla(sSQLOC,1,0)
	
    if (!rsOC.EOF){   

        sNombreCliente = rsOC.Fields.Item("NOMBRE").Value           
        sCliOCFolio = rsOC.Fields.Item("CliOC_Folio").Value  
   
    }
   
    rsOC.Close()   
   
   
%>   
<div class="wrapper wrapper-content  animated fadeInRight">
    <div class="row">
        <div class="col-sm-9">
            <div class="ibox">
                <!--div id="divEncabezado"></div-->
                <div class="ibox-title">
                    <span class="text-muted small pull-right"><h3><strong><%=sCliOCFolio%></strong></h3></span>
                    <h2><strong><%=sNombreCliente%></strong></h2>
                        <tr>
                    <!--p>
                        All clients need to be verified before you can send email and set a project.
                    </p-->
                </div>
                        
                <div class="ibox-content">  
                    <br>
					<div class="row">
						<div class="col-lg-5">
							<dl class="dl-horizontal">
								<dt>Estatus:</dt> <dd><span class="label label-primary"><%//=ESTATUS%></span></dd>
							</dl>
							<!--Datos de la Orden de compra-->
							<dl class="dl-horizontal">
								<dt>N Orden de Compra:</dt>
								<dd><%//=CliOC_NumeroOrdenCompra%></dd>
								<dt>Fecha ingresada:</dt>
								<dd><%//=FechaElaboracion%></dd>
								<dt>Fecha Requerida:</dt>
								<dd><%//=CliOC_FechaRequerido%>
								</dd>
							</dl>
						</div>
						<!--Datos del Proveedor-->
						<div class="col-lg-7" id="cluster_info">
							<dl class="dl-horizontal">
								<dt>Ultima compra:</dt>
								<dd><%//=UltimaCompra%></dd>
								<dt>RFC:</dt>
								<dd><%//=Cli_RFC%></dd>
								<dt>P. jur&iacute;dica:</dt>
								<dd><%//=PersonalidadJuridica%></dd>
								<dt>Contacto ventas:</dt>
								<dd><%//=Cli_ContactoNombre%></dd>
								<dt>tel&eacute;fono:</dt>
								<dd><%//=Cli_ContactoTelefono%></dd>
								<dt>e-mail:</dt>
								<dd><%//=Cli_ContactoEmail%></dd>
							</dl>   
						</div>
					</div>
                        
                </div>
            </div>
        </div>
        <div class="col-sm-3">
            <div class="ibox">
                <div class="ibox-content">
                    <!--div class="tab-content"-->
                        <span class="views-number">
                            <a href="#" class="forum-item-title" style="pointer-events: none;">Total general</a>
                        </span>
                        <br>
                        <div class="ibox-content">
                            <div id="divSumas">   
                                <span><h4>Sub Total</h4></span>
                                <h2 class="font-bold">$0.00</h2>                 

                                <hr>     
                                <span><h4>Total</h4></span>
                                <h2 class="font-bold">$0.00</h2>
                            </div>
                        </div>    
                    <!--/div-->
                </div>
            </div>
        </div>
    </div>
</div>
    
    
    