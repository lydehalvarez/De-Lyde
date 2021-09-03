<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%
	var OV_ID = Parametro("OV_ID",-1)
   
   	var sSQL = "SELECT * "
		sSQL += " FROM Orden_Venta "
		sSQL += " WHERE  OV_ID = " + OV_ID
		
   	var sSQL2 = "SELECT * "
		sSQL2 += " FROM Izzi_Orden_Venta "
		sSQL2 += " WHERE  OV_ID = " + OV_ID
		
	var rsOV = AbreTabla(sSQL2,1,0)
    if (!rsOV.EOF){
		var CUSTOMER_NAME = rsOV.Fields.Item("CUSTOMER_NAME").Value
		var SHIPPING_ADDRESS = rsOV.Fields.Item("SHIPPING_ADDRESS").Value
	}
   
	var rsTA = AbreTabla(sSQL,1,0)
    if (!rsTA.EOF){
		var OV_Folio = rsTA.Fields.Item("OV_Folio").Value
		var OV_FechaElaboracion = rsTA.Fields.Item("OV_FechaElaboracion").Value
	}
	
   	var sSQLF = "SELECT CONVERT(VARCHAR(20), GETDATE(), 103) AS  Fecha ,CONVERT(VARCHAR(5), GETDATE(), 108) AS  Hora "

	var rsFecha = AbreTabla(sSQLF,1,0)
     if(!rsFecha.EOF){
    	var fechaEla = rsFecha.Fields.Item("Fecha").Value + " - " + rsFecha.Fields.Item("Hora").Value
	 }
	
%>
<link href="http://wms.lyde.com.mx/Template/inspina/css/style.css" rel="stylesheet">
<link href="http://wms.lyde.com.mx/Template/inspina/css/bootstrap.min.css" rel="stylesheet">
<title>Hoja de remision <%=OV_Folio%></title>
<table width="871" border="0">
  <tbody>
    <tr>
      <td width="135" rowspan="5"><img src="/Img/wms/Logo002.png" width="132" height="150" alt=""/></td>
      <td width="114">&nbsp;</td>
      <td width="252">&nbsp;</td>
      <td colspan="2" align="right">Orden de venta</td>
      <td width="113" align="right"><%=OV_Folio%></td>
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
  </tbody>
</table>
<table  width="871" cellspacing="0" cellpadding="0">
  <tr>
    <td colspan="2" >ENVIAR A:</td>
    <td >&nbsp;</td>
    <td >&nbsp;</td>
    <td >&nbsp;</td>
    <td >&nbsp;</td>
    <td >&nbsp;</td>
  </tr>
  <tr>
    <td colspan="3"><%=CUSTOMER_NAME%></td>
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
  </tr>
  <tr>
    <td colspan="3">DIRECCI&Oacute;N:</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td colspan="6"><%=SHIPPING_ADDRESS%></td>
  </tr>
  <tr>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
  </tr>
</table>
<table class="table" cellspacing="0" cellpadding="0" border="0">
  <tr>
    <td colspan="2">ART&Iacute;CULOS:</td>
    <td colspan="3"></td>
    <td width="121"></td>
    <td width="131"></td>
    <td width="131"></td>
  </tr>

  <tr>
    <td >Partida</td>
    <td colspan="2">Descripci&oacute;n</td>
    <td >&nbsp;</td>
    <td >&nbsp;</td>
    <td >&nbsp;</td>
    <td >SKU</td>
    <td >Cantidad</td>
  </tr>
<%
	var iRenglon = 0

   	var sSQL3 = "SELECT * "
		sSQL3 += " ,(SELECT Pro_Nombre FROM Producto p WHERE p.Pro_SKU = h.OVA_PART_NUMBER OR p.Pro_ClaveAlterna = h.OVA_PART_NUMBER ) ProNombre"
		sSQL3 += " ,(SELECT Pro_Descripcion FROM Producto p WHERE p.Pro_SKU = h.OVA_PART_NUMBER OR p.Pro_ClaveAlterna = h.OVA_PART_NUMBER ) ProDescripcion "
		sSQL3 += " ,(SELECT OVP_Serie FROM Orden_Venta_Picking p WHERE p.OV_ID = "+OV_ID+" AND p.OVA_ID = h.OVA_ID  ) OVPSerie "
		sSQL3 += " FROM Orden_Venta_Articulo h"
		sSQL3 += " WHERE OV_ID =" + OV_ID
   
   
   
	var rsTAA = AbreTabla(sSQL3,1,0)
     while (!rsTAA.EOF){
          iRenglon++
%>	
  <tr style="border-top:1px solid #000; margin-bottom:5px;">
    <td><%=iRenglon%></td>
    <td colspan="5">
		<%=rsTAA.Fields.Item("ProNombre").Value%><br>
        <%=rsTAA.Fields.Item("ProDescripcion").Value%><br>
        <p class="small"><%=rsTAA.Fields.Item("OVPSerie").Value%></p>
	</td>
    <td><%=rsTAA.Fields.Item("OVA_PART_NUMBER").Value%></td>
    <td>1</td>
  </tr>
<%
	rsTAA.MoveNext() 
	}
rsTAA.Close()   
%>	
</table>

<table align="center" style="margin-top: 150px;margin-bottom: 65px;">
  <tbody>
    <tr>
      <td style="border-bottom: 1px solid;text-align: center;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
    </tr>
    <tr style="text-align:center">
      <td>Firma de recepci&oacute;n</td>
    </tr>
  </tbody>
</table>

