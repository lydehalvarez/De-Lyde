<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
    var ASN_ID = Parametro("ASN_ID",-1) 
	
	var Recibido = "SELECT ASN_FolioCliente,b.* "
		Recibido += " FROM ASN a, EKT_altaASNsEKT_Articulo b "
		Recibido += " WHERE ID_Cliente = SK_num_alta "
		Recibido += " AND ASN_ID =  "+ASN_ID
	
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
   	var Cantidad = rsASN.Fields.Item("cantidad").Value
	var idContenido = rsASN.Fields.Item("idContenido").Value
	var codigoEKT = rsASN.Fields.Item("codigoEKT").Value
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

<tr><td colspan="4">No hay informaci&oacute;n</td></tr>

<%}%>
</tbody>

</table>

