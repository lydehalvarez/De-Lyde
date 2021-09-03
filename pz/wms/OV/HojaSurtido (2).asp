<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%
	var Cort_ID = Parametro("Cort_ID",-1)
   	var sSQL = "SELECT CONVERT(VARCHAR(20), GETDATE(), 103) AS  Fecha ,CONVERT(VARCHAR(5), GETDATE(), 108) AS  Hora "

	var rsFecha = AbreTabla(sSQL,1,0)
     if(!rsFecha.EOF){
    	var fechaEla = rsFecha.Fields.Item("Fecha").Value + " - " + rsFecha.Fields.Item("Hora").Value
	 }
   
%>
<link href="/Template/inspina/css/style.css" rel="stylesheet">
<link href="/Template/inspina/css/bootstrap.min.css" rel="stylesheet">
<title>Hoja de remision <%=Cort_ID%></title>
<table border="0">
  <tbody>
    <tr>
      <td width="135" rowspan="5"><img src="/Img/wms/Logo002.png" width="132" height="150" alt=""/></td>
      <td width="114">&nbsp;</td>
      <td width="252">&nbsp;</td>
      <td colspan="2" align="right">Orden de venta</td>
      <td width="113" align="right"><%=Cort_ID%></td>
    </tr>
    <tr>
      <td colspan="5" align="right">Log&iacute;stica y Distribuci&oacute;n Empresarial, S.A. de C.V. </td>
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
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td style="text-align:center">Fecha</td>
      <td style="text-align:center" colspan="2"><%=fechaEla%></td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>Surtido de ordenes de venta</td>
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
<table class="table" cellspacing="0" cellpadding="0" border="0">
  <tr>
    <td >Partida</td>
    <td colspan="3">Descripci&oacute;n</td>
    <td style="text-align:center">SKU</td>
    <td style="text-align:center">Cantidad</td>
  </tr>
<%

   	var sSQL3 = "SELECT  "
		sSQL3 += "COUNT(h.OVA_PART_NUMBER) Cantidad "
		sSQL3 += ",h.OVA_PART_NUMBER "
		sSQL3 += ",ISNULL((SELECT Pro_Nombre FROM Producto p WHERE p.Pro_ClaveAlterna =h.OVA_PART_NUMBER ),'') Pro_Nom "
		sSQL3 += ",(SELECT Pro_Descripcion FROM Producto p WHERE p.Pro_ClaveAlterna =h.OVA_PART_NUMBER ) Pro_Descrip "
		sSQL3 += "FROM Orden_Venta g, Orden_Venta_Articulo h "
		sSQL3 += "WHERE g.Cort_ID =  "+Cort_ID
		sSQL3 += "AND g.OV_ID = h.OV_ID "
		sSQL3 += "AND g.OV_Test = 0 "
		sSQL3 += "GROUP BY OVA_PART_NUMBER "
   
	var iRenglon = 0
	var rsArt = AbreTabla(sSQL3,1,0)
     while (!rsArt.EOF){
	 var NOM = rsArt.Fields.Item("Pro_Nom").Value
	 if(NOM != ""){
		  iRenglon++
%>	
  <tr>
    <td><%=iRenglon%></td>
    <td colspan="3"><%=NOM %><br><%=rsArt.Fields.Item("Pro_Descrip").Value%></td>
    <td style="text-align:center"><%=rsArt.Fields.Item("OVA_PART_NUMBER").Value%></td>
    <td style="text-align:center"><%=rsArt.Fields.Item("Cantidad").Value%></td>
  </tr>
<%}
	rsArt.MoveNext() 
	}
rsArt.Close()   
%>	
</table>

<table align="center" style="margin-top: 150px;margin-bottom: 65px;">
  <tbody>
    <tr>
      <td style="border-bottom: 1px solid;text-align: center;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
    </tr>
    <tr style="text-align:center">
      <td>Firma de autorizaci&oacute;n</td>
    </tr>
  </tbody>
</table>
<script src="/Template/inspina/js/jquery-3.1.1.min.js"></script>
<script>
$(document).ready(function(e) {
    window.print();
setTimeout(function(){ 
             window.close();
  }, 800);
});	
	

</script>    

