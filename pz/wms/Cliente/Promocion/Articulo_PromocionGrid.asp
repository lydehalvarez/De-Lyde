<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../../Includes/iqon.asp" -->
<%

    var Cli_ID =  Parametro("Cli_ID",-1) 
    var Prom_ID = Parametro("Prom_ID",-1) 

  var sSQL  = " SELECT   a.*, x.Pro_Nombre AS Promocion, r.Pro_SKU as SKU_Regalo, x.Pro_SKU AS SKU_Promo, "
		sSQL += " r.Pro_Nombre AS Regalo"
		sSQL += " ,ISNULL((SELECT Nombre FROM [dbo].[tuf_Usuario_Informacion](Prom_Usuario)),'Sin datos') Usuario"
		sSQL += " FROM Cliente_PromocionArticulo a "
		sSQL += " INNER JOIN Cliente_Promocion p ON p.Prom_ID = a.Prom_ID"
   		sSQL += " INNER JOIN Producto x ON a.Prom_Articulo_Pro_ID = x.Pro_ID "
   		sSQL += " INNER JOIN Producto r ON r.Pro_ID = a.Prom_Obsequio_Pro_ID "
		sSQL += " WHERE a.Prom_ID =" + 	Prom_ID
		sSQL += " AND a.Cli_ID = " + Cli_ID
		
		//Response.Write(sSQL)
	
%>

<link href="/Template/inspina/css/plugins/select2/select2.min.css" rel="stylesheet">

<div id="wrapper">
		<div class="wrapper wrapper-content">
			<div class="row">
				<div class="col-lg-12">
					<div class="ibox float-e-margins">
						<div class="ibox-title">
							<div class="row wrapper border-bottom white-bg page-heading">
								<div class="col-sm-10">
									<h2><strong>Articulos de promoci&oacute;n</strong></h2>
								</div>
								<div class="col-sm-2">
									<div class="title-action">
										<a class="btn btn-primary" id="btnNuevo" onclick="Promo.BotonNuevo()"><i class="fa fa-plus"></i> Nuevo</a>
									</div>
								</div>
							</div>
                            
							<table class="table table-striped">
                            	<thead>
                                	<tr>
                                        <th>SKU</th>
                                        <th>Producto</th>
                                        <th>SKU Regalo/Promoci&oacute;n</th>
                                        <th>Regalo/Promoci&oacute;n</th>
                                        <th>Cantidad</th>
                                        <th>Usuario</th>
                                    </tr>
                                </thead>
								<%
									var SKU_Regalo = ""
									var SKU_Promo = ""
									var Regalo = ""
									var Promo = ""
									var Cantidad = ""
									var Usuario = ""
									
									var rsPromocion = AbreTabla(sSQL,1,0)
									while (!rsPromocion.EOF){
										SKU_Regalo = rsPromocion.Fields.Item("SKU_Regalo")
										SKU_Promo = rsPromocion.Fields.Item("SKU_Promo")
										Regalo = rsPromocion.Fields.Item("Regalo")
										Promo = rsPromocion.Fields.Item("Promocion")
										Cantidad = rsPromocion.Fields.Item("Prom_Cantidad")
										Usuario = rsPromocion.Fields.Item("Usuario")
									%>
								<tr>
									<td><%=SKU_Promo%></td>
									<td><%=Promo%></td>
									<td><%=SKU_Regalo%></td>
									<td><%=Regalo%></td>
									<td><%=Cantidad%></td>
                                    <td><%=Usuario%></td>
								</tr><%
									rsPromocion.MoveNext() 
								   }
								rsPromocion.Close()   
								%>
							</table>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

<script src="/Template/inspina/js/plugins/select2/select2.full.min.js"></script>
<script type="application/javascript">

$(".combman").select2({
	dropdownParent: $('#mdlPromo .modal-content')
});
   
</script>



