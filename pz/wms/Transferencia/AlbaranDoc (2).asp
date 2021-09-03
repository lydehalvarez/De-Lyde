<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%
	var TA_ID = Parametro("TA_ID",-1)
	
	
	var sSQLT = "SELECT * "
		sSQLT += ",( "
			+ "SELECT Alm_Calle + ' ' + Alm_NumExt + ' ' + Alm_NumInt + ' ' + Alm_Colonia + ', ' + Alm_Delegacion + ', ' + Alm_Ciudad + ', ' + Alm_CP + ', ' + Alm_Estado "
			+ "FROM Almacen "
			+ "WHERE Alm_Id = TA_End_Warehouse_ID "
			+ ") as Direccion "
		sSQLT += "FROM TransferenciaAlmacen "
		sSQLT += "WHERE TA_ID = " +TA_ID
		
		
		bHayParametros = false
		ParametroCargaDeSQL(sSQLT,0)
		
	var sSQLTrans = "SELECT (SELECT TA_Folio FROM [dbo].[TransferenciaAlmacen] WHERE TA_ID = h.TA_ID) FOLIO_LYDE "
		sSQLTrans += ",(SELECT TA_End_Warehouse FROM [dbo].[TransferenciaAlmacen] WHERE TA_ID = h.TA_ID) Sucursal_Destino "
		sSQLTrans += ",TAS_Serie "
		sSQLTrans += ", (SELECT Pro_Nombre FROM Producto p, Inventario i WHERE i.Inv_Serie = h.TAS_Serie AND i.Pro_ID = p.Pro_ID ) AS Nombre "
		sSQLTrans += ", (SELECT Pro_SKU FROM Producto p, Inventario i WHERE i.Inv_Serie = h.TAS_Serie AND i.Pro_ID = p.Pro_ID ) AS SKU "
		sSQLTrans += ",(SELECT Lot_Folio FROM Inventario k, Inventario_Lote l WHERE k.Inv_Serie = h.TAS_Serie AND k.Inv_LoteIngreso = l.Lot_ID ) AS LOTE "
		sSQLTrans += "FROM [dbo].[TransferenciaAlmacen_Articulo_Picking] h "
		sSQLTrans += "WHERE TA_ID = " +TA_ID
		sSQLTrans += "ORDER BY TA_ID,TAA_ID,TAS_ID ASC	 "

	
%>
<style media="print">
@page {
    size: auto;   /* auto is the initial value */
}
.page-break  { display:block; page-break-before:always; }

.marca-de-agua {
    background-image: url("/Img/wms/Logo002.png");
    background-repeat: no-repeat;
    background-position: center;
    width: 100%;
    height: auto;
    margin: auto;
}
.marca-de-agua img {
    padding: 0;
    width: 100%;
    height: auto;
    opacity: 0.7;
}
</style>
<link href="http://wms.lyde.com.mx/Template/inspina/css/style.css" rel="stylesheet">
<link href="http://wms.lyde.com.mx/Template/inspina/css/bootstrap.min.css" rel="stylesheet">
<title>Albaran</title>
<body class="marca-de-agua">


<table width="871" border="0">
  <tbody>
    <tr>
      <td width="135" rowspan="5"><img src="/Img/wms/Logo005.png" width="132" height="150" alt=""/></td>
      <td width="114">&nbsp;</td>
      <td width="252">&nbsp;</td>
      <td colspan="2" align="right">TRANSFERENCIA</td>
      <td width="113" align="right"></td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td colspan="4" align="right">Log&iacute;stica y Distribuci&oacute;n Empresarial, S.A. de C.V. </td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td width="60">&nbsp;</td>
      <td width="100">&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>Fecha</td>
      <td><%=Parametro("TA_FechaEntrega","")%></td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>Responsable</td>
      <td colspan="4"><%=Parametro("TA_Responsable","")%></td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>Tel&eacute;fono</td>
      <td colspan="4"><%=Parametro("TA_Celular","")%></td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>Direcci&oacute;n</td>
      <td colspan="4"><%=Parametro("Direccion","")%></td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
  </tbody>
</table>
<table class="table table-striped table-bordered">
    <thead> 
        <th>Folio TRA</th>
        <th>Tienda c&oacute;digo</th>
        <th>SERIE</th>
        <th>Nombre</th>
        <th>SKU</th>
        <th>Folio lote</th>
    </thead>
    <tbody>
	<%
	var rsTran = AbreTabla(sSQLTrans,1,0)
        while(!rsTran.EOF){
            var FOLIO_LYDE = rsTran.Fields.Item("FOLIO_LYDE").Value 
            var Sucursal_Destino = rsTran.Fields.Item("Sucursal_Destino").Value 
            var TAS_Serie = rsTran.Fields.Item("TAS_Serie").Value 
            var Nombre = rsTran.Fields.Item("Nombre").Value 
            var SKU = rsTran.Fields.Item("SKU").Value 
            var LOTE = rsTran.Fields.Item("LOTE").Value 
    %>		
        <tr>
        	<td><%=FOLIO_LYDE%></td>
        	<td><%=Sucursal_Destino%></td>
        	<td><%=TAS_Serie%></td>
        	<td><%=Nombre%></td>
        	<td><%=SKU%></td>
        	<td><%=LOTE%></td>
        </tr>
    <%	
        rsTran.MoveNext() 
    }
    rsTran.Close()   
    %>
    
    </tbody>
</table>

<table align="center" style="margin-top: 90px;margin-bottom: 65px;">
  <tbody>
    <tr style="border-top: 2px solid;text-align: center;">
      <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
    </tr>
    <tr style="text-align:center">
      <td>Firma</td>
    </tr>
  </tbody>
</table>

</body>
<script src="http://wms.lyde.com.mx/Template/inspina/js/jquery-3.1.1.min.js"></script>
<script type="application/javascript">
$(document).ready(function(e) {
	window.print();    
});
</script>


