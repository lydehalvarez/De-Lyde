<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->

<style>
.opciones{
	margin-left: 20px;	
}
</style>
<%
var buscar = Parametro("Buscar",-1)  
%>
<div class="row">
		<div class="col-md-9">
			<div class="ibox">
				<div class="ibox-title">
  <h2>	Busqueda</h2>
                    <ol class="breadcrumb">
                        <li>
                            <a href="index.html">Home</a>
                        </li>
                        <li class="active">
                            <strong>	Busqueda</strong>
                        </li>
                    </ol>
</div>
     <div class="ibox-content">
					<div class="table-responsive">
       
                            <h2>
                               Resultados encontrados de: <span class="text-navy"><%=buscar%></span>
                            </h2>
                            

                           <!-- <div class="search-form">
                                <form action="index.html" method="get">
                                    <div class="input-group">
                                        <input type="text" placeholder="Admin Theme" name="search" class="form-control input-lg">
                                        <div class="input-group-btn">
                                            <button class="btn btn-lg btn-primary" type="submit">
                                                Search
                                            </button>
                                        </div>
                                    </div>

                                </form>
                            </div>-->
                           <div class="row">
	<div class="col-md-12">
                            <%
							var buscar = Parametro("Buscar",-1)  
							var TA_Folio = ""
							  var ssql = "select t.*,  c.Cli_Nombre, p.Pro_Nombre, p.Pro_SKU  from TransferenciaAlmacen t "
                              ssql +="inner join  TransferenciaAlmacen_Articulos a  on t.TA_ID = a.TA_ID "
							  ssql +="inner join cliente c on t.Cli_ID=c.Cli_ID "
                              ssql +="inner join  Producto p  on a.Pro_ID = p.Pro_ID where a.TAA_SKU like '%" + buscar + "%' OR p.Pro_Nombre  like '%" + buscar + "%' " 
							  var rsTrans = AbreTabla(ssql,1,0)
							
							  	if(!rsTrans.EOF){
								
								}else {
							  
var sSQL1  =	"SELECT t.TA_ID, t.TA_Folio , t.Cli_ID, c.Cli_Nombre , t.TA_Guia , "
 sSQL1 +=" t.TA_FechaEntrega , t.TA_UbicacionTienda "
 sSQL1 +=" , t.TA_End_Warehouse , e51.Cat_Nombre ,  "
 sSQL1 +=" e89.Cat_Nombre , cg65.Cat_Nombre from TransferenciaAlmacen t  "
 sSQL1 +="inner join cliente c on t.Cli_ID=c.Cli_ID "
 sSQL1 +="inner join cat_catalogo e51 on (e51.Sec_ID = 51) and (t.TA_EstatusCG51 = e51.Cat_ID) "
%>
<!-- sSQL1 +="--inner join cat_catalogo e52 on (e52.Sec_ID = 52) and (t.TA_EstatusCG52 = e52.Cat_ID)"-->
 <%
 sSQL1 +="inner join cat_catalogo e89 on (e89.Sec_ID = 89) and (t.TA_EstatusCG89 = e89.Cat_ID) "
 sSQL1 +="inner join cat_catalogo cg65 on (cg65.Sec_ID = 65) and (t.TA_TipoTransferenciaCG65 = cg65.Cat_ID) "
 sSQL1 +="where t.TA_Folio like '%" + buscar +"%' OR e51.Cat_Nombre LIKE '%" + buscar +"%' OR e89.Cat_Nombre "
 sSQL1 +=" LIKE '%" + buscar +"%' OR cg65.Cat_Nombre LIKE '%" + buscar +"%' "
 sSQL1 +="OR t.TA_End_Warehouse LIKE '%" + buscar +"%' OR "
 sSQL1 +="t.TA_CodigoIdentificador  LIKE '%" + buscar +"%' OR t.TA_UbicacionTienda  LIKE '%" + buscar +"%' "
  sSQL1 +="OR t.TA_FechaEntrega like '%" + buscar +"%' OR t.TA_Guia = '" + buscar +"' "
 sSQL1 +="OR t.TA_Transportista  LIKE '%" + buscar +"%' OR  c.Cli_Nombre LIKE '%" + buscar +"%' "
 sSQL1 +="group by t.TA_ID, t.Cli_ID, t.TA_Folio, c.Cli_Nombre, t.TA_Guia,  t.TA_End_Warehouse,  t.TA_FechaEntrega, t.TA_UbicacionTienda "
 sSQL1 +=", e51.Cat_Nombre, e89.Cat_Nombre, cg65.Cat_Nombre"
							    rsTrans = AbreTabla(sSQL1,1,0)
							   }
							    while (!rsTrans.EOF){
								var Cli_ID = rsTrans.Fields.Item("Cli_ID").Value
								var TA_ID = rsTrans.Fields.Item("TA_ID").Value
								 TA_Folio = rsTrans.Fields.Item("TA_Folio").Value
								var Cli_Nombre = rsTrans.Fields.Item("Cli_Nombre").Value
								var TA_Guia = rsTrans.Fields.Item("TA_Guia").Value
							    var TA_FechaEntrega = rsTrans.Fields.Item("TA_FechaEntrega").Value
								var TA_UbicacionTienda = rsTrans.Fields.Item("TA_UbicacionTienda").Value
								var TA_End_Warehouse = rsTrans.Fields.Item("TA_End_Warehouse").Value
												
								%>
                                <h3><a href="#" data-cliid="<%=Cli_ID%>" data-taid="<%=TA_ID%>" class="search-link LinkTRA"><%=TA_Folio%> Guia - <%=TA_Guia%></a></h3>
                        
                                <p>
                                
                                <h5><strong>Cliente:</strong> <%=Cli_Nombre%></h5><h5><strong>Almacen: </strong><%=TA_End_Warehouse%></h5><h5><strong>Ubicacion Tienda: </strong><%=TA_UbicacionTienda%></h5><h5><strong>Fecha Entrega:</strong> <%=TA_FechaEntrega%></h5>
                               <br>
                               <%
							  ssql = "select * from TransferenciaAlmacen t "
                              ssql +="inner join  TransferenciaAlmacen_Articulos a  on t.TA_ID = a.TA_ID "
                              ssql +="inner join  Producto p  on a.Pro_ID = p.Pro_ID where t.TA_Folio = '" + TA_Folio + "'"
							  var rsprod = AbreTabla(ssql,1,0)
								 
								 while (!rsprod.EOF){
									var Pro_Nombre = rsprod.Fields.Item("Pro_Nombre").Value
								    var Pro_SKU = rsprod.Fields.Item("Pro_SKU").Value
															
									%>
                                   <strong> SKU: </strong><%=Pro_SKU%><strong> Producto: </strong><%=Pro_Nombre%> <strong>/</strong>
								<%
								rsprod.MoveNext() 
									}
									rsprod.Close()
									%>
								<br>
                                --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                                <br>
                                    <%
										rsTrans.MoveNext() 
									}
									rsTrans.Close()
							
										  ssql = "select v.*,  c.Cli_Nombre, p.Pro_Nombre, p.Pro_SKU from Orden_Venta v "
                              ssql +="inner join  Orden_Venta_Articulo a  on v.OV_ID=a.OV_ID inner join cliente c on v.Cli_ID=c.Cli_ID "
                              ssql +="inner join  Producto p  on a.Pro_ID = p.Pro_ID where  p.Pro_SKU like '%" + buscar + "%' OR p.Pro_Nombre  like '%" + buscar + "%' " 
							  var rsOV = AbreTabla(ssql,1,0)
							
							  	if(!rsOV.EOF){
								
								}else {
                            ssql = "SELECT  v.OV_ID, OV_Folio,  OV_FechaVenta, v.OV_CUSTOMER_SO, OV_TRACKING_COM, OV_TRACKING_NUMBER,"
                            ssql += " e51.Cat_Nombre, OV_Cancelada, OV_CancelacionFecha, OV_UsuarioIzziCancela, OV_MotivoCancelacion, "
 							ssql += "OV_RastreoEstatus, OV_PersonaRecibePaquete, v.Cli_ID,  c.Cli_Nombre "
   							ssql += " from Orden_Venta v inner join cliente c on v.Cli_ID=c.Cli_ID "
 							ssql += "inner join cat_catalogo e51 on (e51.Sec_ID = 51) and (v.OV_EstatusCG51 = e51.Cat_ID) "
 						    ssql += "where  OV_Folio like  '%" + buscar +"%' or  OV_FechaVenta like '%" + buscar +"%' or v.OV_CUSTOMER_SO like '%" + buscar +"%' or " 
						    ssql += "OV_TRACKING_COM like '%" + buscar +"%' or OV_TRACKING_NUMBER like '%" + buscar +"%' or  e51.Cat_Nombre like '%" + buscar +"%' "
							ssql += "or OV_Cancelada like '%" + buscar +"%' or OV_CancelacionFecha like '%" + buscar +"%' or "
						    ssql += "OV_UsuarioIzziCancela like '%" + buscar +"%' or OV_MotivoCancelacion like '%" + buscar +"%' or OV_RastreoEstatus"  
  							ssql += " like '%" + buscar +"%' or OV_PersonaRecibePaquete like '%" + buscar +"%' or c.Cli_Nombre like '%" + buscar +"%'"

                              rsOV = AbreTabla(ssql,1,0)
							   }
							    while (!rsOV.EOF){
								var OV_ID = rsOV.Fields.Item("OV_ID").Value
								var Cli_ID = rsOV.Fields.Item("Cli_ID").Value
								var OV_Folio = rsOV.Fields.Item("OV_Folio").Value
								var OV_FechaVenta = rsOV.Fields.Item("OV_FechaVenta").Value
								var OV_CUSTOMER_SO = rsOV.Fields.Item("OV_CUSTOMER_SO").Value
								var Cli_Nombre = rsOV.Fields.Item("Cli_Nombre").Value
								var OV_TRACKING_COM = rsOV.Fields.Item("OV_TRACKING_COM").Value
							    var OV_TRACKING_NUMBER = rsOV.Fields.Item("OV_TRACKING_NUMBER").Value
								var OV_RastreoEstatus = rsOV.Fields.Item("OV_RastreoEstatus").Value
								
												
								%>
                                <h3><a href="#" data-cliid="<%=Cli_ID%>" data-ovid="<%=OV_ID%>" class="search-link LinkOV"><%=OV_Folio%>
                                 Guia - <%=OV_TRACKING_NUMBER%></a></h3>
                        
                                <p>
                                
                                <h5><strong>Cliente:</strong> <%=Cli_Nombre%></h5><h5><strong>Fecha Venta:</strong> <%=OV_FechaVenta%></h5>
                               <br>
                               <%
							  ssql = "select * from Orden_Venta v "
                              ssql +="inner join  Orden_Venta_Articulo a  on v.OV_ID=a.OV_ID "
                              ssql +="inner join  Producto p  on a.Pro_ID = p.Pro_ID where v.OV_ID = '" + OV_ID + "'"
							  var rsprod = AbreTabla(ssql,1,0)
								 
								 while (!rsprod.EOF){
									var Pro_Nombre = rsprod.Fields.Item("Pro_Nombre").Value
								    var Pro_SKU = rsprod.Fields.Item("Pro_SKU").Value
															
									%>
                                   <strong> SKU: </strong><%=Pro_SKU%><strong> Producto: </strong><%=Pro_Nombre%> <strong>/</strong>
								<%
								rsprod.MoveNext() 
									}
									rsprod.Close()
									%>
								<br>
                                --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                                <br>
                                    <%
										rsOV.MoveNext() 
									}
									rsOV.Close()
									
				   ssql = "SELECT  p.Pro_SKU, p.Pro_Nombre, c.Cli_Nombre, o.* "
                   ssql +="FROM  Cliente_OrdenCompra AS o INNER JOIN "
                   ssql +="Cliente_OrdenCompra_Articulos ON o.CliOC_ID = Cliente_OrdenCompra_Articulos.CliOC_ID INNER JOIN "
                   ssql +="Producto AS p ON Cliente_OrdenCompra_Articulos.Pro_ID = p.Pro_ID INNER JOIN "
                   ssql +="Cliente AS c ON o.Cli_ID = c.Cli_ID  where p.Pro_SKU like '%" + buscar + "%' OR p.Pro_Nombre  like '%" + buscar + "%'" 
							  var rsOC = AbreTabla(ssql,1,0)
									  	if(!rsOC.EOF){
								
								}else {
									ssql = "SELECT  o.Cli_ID, o.CliOC_ID, c.Cli_Nombre, a.Alm_Nombre, "
 								   	ssql +="CliOC_Folio,CliOC_NumeroOrdenCompra, CliOC_FechaElaboracion,  "
									ssql +="CliOC_Observaciones, CliOC_Proyecto, CliOC_Comprador, CliOC_Autorizador,  "
									ssql +="cg85.Cat_Nombre, cg87.Cat_Nombre FROM    Cliente_OrdenCompra o "
									ssql +="inner join cat_catalogo cg85 on (cg85.Sec_ID = 85) and (o.CliOC_CondicionesPagoCG85 = cg85.Cat_ID)  "
									ssql +="inner join cat_catalogo cg87 on (cg87.Sec_ID = 87) and (o.CliOC_TipoOCCG87 = cg87.Cat_ID) "
									ssql +="inner join cliente c on o.Cli_ID=c.Cli_ID LEFT OUTER JOIN Almacen a on a.Alm_ID = CliOC_EnviarAlmacen "
									ssql +="where  c.Cli_Nombre like '%" + buscar +"%' or a.Alm_Nombre like '%" + buscar +"%' or "
									ssql +="CliOC_Folio like '%" + buscar +"%' or CliOC_NumeroOrdenCompra like '%" + buscar +"%' or CliOC_FechaElaboracion "
									ssql +="like '%" + buscar +"%' or CliOC_Observaciones like '%" + buscar +"%' or CliOC_Proyecto like '%" + buscar +"%' or CliOC_Comprador "
									ssql +="like '%" + buscar +"%' or CliOC_Autorizador like '%" + buscar +"%' or cg85.Cat_Nombre like '%" + buscar +"%' or "
									ssql +="cg87.Cat_Nombre like '%" + buscar +"%'"
								
									 rsOC = AbreTabla(ssql,1,0)
							   }
							    while (!rsOC.EOF){
								var OC_ID = rsOC.Fields.Item("CliOC_ID").Value
								var Cli_ID = rsOC.Fields.Item("Cli_ID").Value
								var OC_Folio = rsOC.Fields.Item("CliOC_Folio").Value
								var CliOC_FechaElaboracion = rsOC.Fields.Item("CliOC_FechaElaboracion").Value
								var CliOC_NumeroOrdenCompra = rsOC.Fields.Item("CliOC_NumeroOrdenCompra").Value
								var Cli_Nombre = rsOC.Fields.Item("Cli_Nombre").Value
								var Alm_Nombre = rsOC.Fields.Item("Alm_Nombre").Value
							
								
												
								%>
                                <h3><a href="#" data-cliid="<%=Cli_ID%>" data-ocid="<%=OC_ID%>" class="search-link LinkOC"><%=OC_Folio%>
                                 No. <%=CliOC_NumeroOrdenCompra%></a></h3>
                        
                                <p>
                                
                                <h5><strong>Cliente:</strong> <%=Cli_Nombre%></h5><h5><strong>Almacen:</strong> <%=Alm_Nombre%></h5><h5><strong>Fecha Venta:</strong> <%=OV_FechaVenta%></h5>
                               <br>
                               <%
							  ssql = "select * FROM  Cliente_OrdenCompra AS o INNER JOIN "
                       	      ssql +="Cliente_OrdenCompra_Articulos ON o.CliOC_ID = Cliente_OrdenCompra_Articulos.CliOC_ID INNER JOIN "
                         	  ssql +="Producto AS p ON Cliente_OrdenCompra_Articulos.Pro_ID = p.Pro_ID where o.CliOC_ID = '" + OC_ID + "'"
								
							  var rsprod = AbreTabla(ssql,1,0)
								 
								 while (!rsprod.EOF){
									var Pro_Nombre = rsprod.Fields.Item("Pro_Nombre").Value
								    var Pro_SKU = rsprod.Fields.Item("Pro_SKU").Value
															
									%>
                                   <strong> SKU: </strong><%=Pro_SKU%><strong> Producto: </strong><%=Pro_Nombre%> <strong>/</strong>
								<%
								rsprod.MoveNext() 
									}
									rsprod.Close()
									%>
								<br>
                                --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                                <br>
                                    <%
										rsOC.MoveNext() 
									}
									rsOC.Close()
									
							   %>
                                </p>
                                 </div>
                            <div class="hr-line-dashed"></div>
                         <!--   <div class="text-center">
                                <div class="btn-group">
                                    <button class="btn btn-white" type="button"><i class="fa fa-chevron-left"></i></button>
                                    <button class="btn btn-white">1</button>
                                    <button class="btn btn-white  active">2</button>
                                    <button class="btn btn-white">3</button>
                                    <button class="btn btn-white">4</button>
                                    <button class="btn btn-white">5</button>
                                    <button class="btn btn-white">6</button>
                                    <button class="btn btn-white">7</button>
                                    <button class="btn btn-white" type="button"><i class="fa fa-chevron-right"></i> </button>
                                </div>
                            </div>-->
                        </div>
                    </div>
                </div>
                </div>
        </div>
        
        <div class="footer">
            <div class="pull-right">
                10GB of <strong>250GB</strong> Free.
            </div>
            <div>
                <strong>Copyright</strong> Example Company &copy; 2014-2017
            </div>
        </div>

        </div>



    <!-- Mainly scripts -->
    <script src="js/jquery-3.1.1.min.js"></script>
    <script src="js/bootstrap.min.js"></script>
    <script src="js/plugins/metisMenu/jquery.metisMenu.js"></script>
    <script src="js/plugins/slimscroll/jquery.slimscroll.min.js"></script>

    <!-- Custom and plugin javascript -->
    <script src="js/inspinia.js"></script>
    <script src="js/plugins/pace/pace.min.js"></script>
<script type="application/javascript">

$('.LinkTRA').click(function(e) {
		e.preventDefault()
		
		var Params = "?TA_ID=" + $(this).data("taid")
		    Params += "&Cli_ID=" + $(this).data("cliid")
		    Params += "&IDUsuario=" + $("#IDUsuario").val()	

		$("#Contenido").load("/pz/wms/TA/TA_Ficha.asp" + Params)
	});
	
	$('.LinkOV').click(function(e) {
		e.preventDefault()
		
		var Params = "?OV_ID=" + $(this).data("ovid")
		    Params += "&Cli_ID=" + $(this).data("cliid")
		    Params += "&IDUsuario=" + $("#IDUsuario").val()	

		$("#Contenido").load("/pz/wms/OV/OV_Ficha.asp" + Params)
	});
		$('.LinkOC').click(function(e) {
		e.preventDefault()
		
		var Params = "?CliOC_ID=" + $(this).data("ocid")
		    Params += "&Cli_ID=" + $(this).data("cliid")
		    Params += "&IDUsuario=" + $("#IDUsuario").val()	

		$("#Contenido").load("/pz/wms/OC/Cli_OrdenCompra.asp" + Params)
	});
	</script>
    

