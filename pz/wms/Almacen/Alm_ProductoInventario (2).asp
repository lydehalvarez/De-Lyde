<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%

var Cli_ID = Parametro("Cli_ID", -1)
var Pro_ID = Parametro("Pro_ID", -1)

var sqlInv = "select * from Producto where Pro_ID = " + Pro_ID

var rsProd = AbreTabla( sqlInv, 1 , 0 )
if(!rsProd.EOF){
	var NombreProducto = rsProd.Fields.Item("Pro_ClaveAlterna").Value
        NombreProducto += " - " +rsProd.Fields.Item("Pro_Nombre").Value 
    var Descripcion = rsProd.Fields.Item("Pro_Descripcion").Value
   
 
   
%>
<div class="ibox-content">
	<div class="table-responsive">
		 <h1><%= NombreProducto %>  <br> <small><%= Descripcion  %></small> </h1> 
		<hr> 
		 <div class="col-lg-12">
			<div class="ibox float-e-margins">
				<div class="ibox-title">
					<span class="label label-primary pull-right">Activo</span>
					<h5>Existencias</h5>
					
				</div>
                
				<div class="ibox-content">
					<div class="row">
						<div class="col-md-3">
							<h1 class="no-margins" id="dtTOTAL"><img src="/Img/ajaxLoader.gif" width="10" height="10" alt=""/></h1>
							<div class="font-bold text-navy" title="Total de producto recibido">
								Total
							</div>
						</div>
						<div class="col-md-3">
							<h1 class="no-margins" id="dtDisponible"><img src="/Img/ajaxLoader.gif" width="10" height="10" alt=""/></h1>
							<div class="font-bold text-navy" title="Articulos disponibles en todas las tinedas o almacenes">
								Global Disponibles
							</div>
						</div>
                        <div class="col-md-3">
							<h1 class="no-margins" id="dtComprometidos"><img src="/Img/ajaxLoader.gif" width="10" height="10" alt=""/></h1>
							<div class="font-bold text-navy" title="Total de articulos que estan por surtirse en una orden de venta nueva o una transfeencia en curso">
								Comprometidos
							</div>
						</div>
						<div class="col-md-3">
							<h1 class="no-margins" id="dtVentasSO"><img src="/Img/ajaxLoader.gif" width="10" height="10" alt=""/></h1>
							<div class="font-bold text-navy" title="Total de ordenes de venta surtidas directamente a clientes">
								Ventas clientes
							</div>
						</div>
						<div class="col-md-3">
							<h1 class="no-margins" id="dtTransferencias"><img src="/Img/ajaxLoader.gif" width="10" height="10" alt=""/></h1>
							<div class="font-bold text-navy" title="Articulos transferidos a una tienda">
								Transferencias a tiendas
							</div>
						</div>
                        <div class="col-md-3">
							<h1 class="no-margins" id="dtSurtido"><img src="/Img/ajaxLoader.gif" width="10" height="10" alt=""/></h1>
							<div class="font-bold text-navy" title="Total de articulos surtidos a tiendas o ventas directas">
								Surtido
							</div>
						</div>
                        <div class="col-md-3">
							<h1 class="no-margins" id="dtTransfiriendose"><img src="/Img/ajaxLoader.gif" width="10" height="10" alt=""/></h1>
							<div class="font-bold text-navy" title="Articulos actualmente transfiriendose">
								En transferencia
							</div>
						</div>
                        <div class="col-md-3">
							<h1 class="no-margins" id="dtCuarentena"><img src="/Img/ajaxLoader.gif" width="10" height="10" alt=""/></h1>
							<div class="font-bold text-navy" title="Articulos en custodia en el cedis por cuarentena">
								Cuarentena
							</div>
						</div>  
					</div>
				</div>
         
			</div>
		</div>
	</div>
</div>
				
	<div class="ibox-content">
		<div class="table-responsive" id="dvTablaInventario">
            <div class="spiner-example">
                <div class="sk-spinner sk-spinner-three-bounce">
                    <div class="sk-bounce1"></div>
                    <div class="sk-bounce2"></div>
                    <div class="sk-bounce3"></div>
                </div>
            </div>
        </div>
	</div>
							
<script type="text/javascript">
    
    $(document).ready(function(){ 
        
        Avisa("info", "Inventario", "Por favor espere, la informaci&oacute;n se cargar&aacute; parcialemnte");
        
        var sDatos  = "?Cli_ID=<%=Cli_ID%>"
            sDatos += "&Pro_ID=<%=Pro_ID%>"
        var sAjax = "/pz/wms/Almacen/Alm_ProductoInventario_Ajax.asp"
        var sTarea = "&Tarea="
        
        $("#dtTOTAL").load(sAjax + sDatos + sTarea + "1");
        $("#dtDisponible").load(sAjax + sDatos + sTarea + "2");
        $("#dtVentasSO").load(sAjax + sDatos + sTarea + "3");
        $("#dtComprometidos").load(sAjax + sDatos + sTarea + "4");
        $("#dtTransferencias").load(sAjax + sDatos + sTarea + "5");
        $("#dtTransfiriendose").load(sAjax + sDatos + sTarea + "6");
        $("#dtSurtido").load(sAjax + sDatos + sTarea + "7");
        $("#dtCuarentena").load(sAjax + sDatos + sTarea + "8");        
		$("#dvTablaInventario").load("/pz/wms/Almacen/Alm_ProductoInventario_Grid.asp" + sDatos
                                     ,function(){
                                            var AlmID = 0
                                            $('.coldato').each(function(index, element) {
                                                AlmID = $(this).data("almid")
                                                $.post( sAjax
                                                       ,{ Tarea:9,
                                                          Cli_ID:<%=Cli_ID%>,
                                                          Pro_ID:<%=Pro_ID%>,
                                                          Alm_ID:AlmID}
                                                       , function(data){
                                                            var response = JSON.parse(data);
                                                            AlID = response.AlmID
                                                            if(response.result == 1){
                                                                 $("#td-" + AlID + "-R").html(response.Recibido)
                                                                 $("#td-" + AlID + "-V").html(response.Vendidos)
                                                                 $("#td-" + AlID + "-C").html(response.Comprometido)
                                                                 $("#td-" + AlID + "-D").html(response.Disponible)
                                                            } else {
                                                                Avisa("error","Error",response.mensaje);
                                                                console.log(response.query)
                                                            }
                                                        });
                                            });
                                      });         

 
    });
    
    
    
    
    
    
</script>

                            
<%  }   %>