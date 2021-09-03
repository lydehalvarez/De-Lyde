<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%
	var TA_ID = Parametro("TA_ID",-1)
	
	
		
	var sSQLTrans = "SELECT * "
		sSQLTrans += "FROM TransferenciaAlmacen "
		sSQLTrans += "WHERE TA_ID = "+TA_ID
		
		
	bHayParametros = false
	ParametroCargaDeSQL(sSQLTrans,0)

	
%>
<style media="print">
@page {
    size: auto;   /* auto is the initial value */
}
.page-break  { display:block; page-break-before:always; }
</style>
<link href="http://wms.lyde.com.mx/Template/inspina/css/style.css" rel="stylesheet">
<link href="http://wms.lyde.com.mx/Template/inspina/css/bootstrap.min.css" rel="stylesheet">
<title>Albaran</title>
<body class="marca-de-agua">


<table width="871" border="0">
  <tbody>
    <tr>
      <td width="135" rowspan="5"><img src="/Img/wms/Logo002.png" width="132" height="150" alt=""/></td>
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
      <td>27/05/2020</td>
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
      <td>&nbsp;</td>
    </tr>
  </tbody>
</table>
<table class="table table-striped table-bordered">
    <thead> 
        <th>Trnasportista</th>
        <th>Compa&ntilde;ia</th>
        <th>Operador</th>
        <th>Placas</th>
        <th>Fecha y hora de salida</th>
    </thead>
    <tbody>
        <tr>
        	<td>Ejemplo</td>
        	<td>Ejemplo</td>
        	<td>Ejemplo</td>
        	<td>Ejemplo</td>
        	<td>Ejemplo</td>
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


