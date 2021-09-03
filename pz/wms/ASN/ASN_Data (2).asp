<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
    var ASN_ID = Parametro("ASN_ID",-1) 
	
//	var Recibido = "SELECT ASN_FolioCliente,b.* "
//		Recibido += " FROM ASN a, EKT_altaASNsEKT_Articulo b "
//		Recibido += " WHERE ID_Cliente = SK_num_alta "
//		Recibido += " AND ASN_ID =  "+ASN_ID
		
	var Recibido = "SELECT ASN_FolioCliente,Pro_SKU,idContenido,ordenCompra,COUNT(a.Inv_ID) Cantidad "
		Recibido += " FROM Inventario a, Producto b , Inventario_Recepcion c, ASN d, EKT_altaASNsEKT_Articulo e "
		Recibido += " WHERE a.Pro_ID = b.Pro_ID   "
		Recibido += " AND a.Inv_LoteIngreso = c.Lot_ID "
		Recibido += " AND d.ASN_ID =  "+ASN_ID
		Recibido += " AND c.IR_ID = d.IR_ID  "
		Recibido += " AND b.Pro_SKU = e.codigoEKT "
		Recibido += " AND d.ID_Cliente = e.SK_num_alta "
		Recibido += " GROUP BY ASN_FolioCliente,Pro_SKU,idContenido,ordenCompra "
		Recibido += " ORDER BY Pro_SKU DESC "
%>

<table class="table">
<thead>
	<tr>
		<th>ASN</th>
		<th>SKU</th>
		<th>Cantidad Esperada</th>
		<th>Cantidad Recibida</th>
    </tr>
</thead>
<tbody id="ASNContenido">
   <% 
   var rsASN = AbreTabla(Recibido,1,0)
   if(!rsASN.EOF){
   while (!rsASN.EOF){
   	var Cantidad = rsASN.Fields.Item("Cantidad").Value
	var idContenido = rsASN.Fields.Item("idContenido").Value
	var codigoEKT = rsASN.Fields.Item("Pro_SKU").Value
	var ordenCompra = rsASN.Fields.Item("ordenCompra").Value
   %>    <tr>
   			<td><%=rsASN.Fields.Item("ASN_FolioCliente").Value%></td>
   			<td><%=codigoEKT%></td>
   			<td><%=Cantidad%></td>
   			<td><input type="number" min="1" max="<%=Cantidad%>" class="idContenido" data-idcont="<%=idContenido%>" data-sku="<%=codigoEKT%>" data-ordencompra="<%=ordenCompra%>" id="Contenido_<%=idContenido%>" value="<%=Cantidad%>" /></td>
       </tr>


<%
	rsASN.MoveNext() 
	}
rsASN.Close()
}else{   
%>       

<tr><td colspan="4">No hay informaci&oacute;n, debido a que todav&iacute;a no hay datos en el inventario</td></tr>

<%}%>
</tbody>

</table>

