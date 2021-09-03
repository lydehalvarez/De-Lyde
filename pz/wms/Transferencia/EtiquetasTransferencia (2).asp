<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->

<%

	var TA_ArchivoID = Parametro("TA_ArchivoID",-1)

	var Transfer = "SELECT * "
		Transfer += " ,(SELECT Alm_Nombre FROM Almacen WHERE Alm_ID = h.TA_End_Warehouse_ID) as Destino"
		Transfer += " ,(SELECT Alm_DireccionCompleta FROM Almacen WHERE Alm_ID = h.TA_End_Warehouse_ID) as Direccion"
		Transfer += " ,(SELECT Cli_Nombre FROM Cliente WHERE Cli_ID  = h.Cli_ID ) Cliente"
		Transfer += " ,(SELECT Alm_Responsable FROM Almacen WHERE Alm_ID = h.TA_End_Warehouse_ID) as Responsable"
		Transfer += " ,(SELECT Alm_RespTelefono FROM Almacen WHERE Alm_ID = h.TA_End_Warehouse_ID) as Telefono"
		Transfer += " FROM TransferenciaAlmacen h"
		Transfer += " WHERE TA_ArchivoID = "+TA_ArchivoID

%>
<html >
<head>
<head>

    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="/Template/inspina/css/bootstrap.min.css" rel="stylesheet">
	
	
</head>
<style>
@page {
  size: A7;
  margin: 0;
}
@media print {
  html, body {
    width: 74mm;
    height: 74mm;
  }
  /* ... the rest of the rules ... */
}
0</style>


<%
	var rsTra = AbreTabla(Transfer,1,0)
     while (!rsTra.EOF){
		 var Cliente = rsTra.Fields.Item("Cliente")
%>	   	<table width="100%" style="font-family:Arial, Helvetica, sans-serif;font-size:13px">

            <tr>
            
                <td colspan="5" style="text-align:center">
                    <svg class="barcode"
                      jsbarcode-value="<%=rsTra.Fields.Item("TA_Folio")%>">
                    </svg>
                </td>
            </tr>
            <tr> 
                <td>Destino:</td>
                <td colspan="4">Tienda&nbsp;<%=Cliente%>&nbsp;<%=rsTra.Fields.Item("Destino")%></td>
            </tr>
            <tr>
                <td>Direcci&oacute;n:</td>
                <td colspan="4"><%=rsTra.Fields.Item("Direccion")%></td>
            </tr>
            <tr>
                <td>Responsable</td>
                <td colspan="4"><%=rsTra.Fields.Item("Responsable")%></td>
            </tr>
            <tr>
                <td>Contacto</td>
                <td colspan="4"><%=rsTra.Fields.Item("Telefono")%></td>
            </tr>
        </table>
<%
	rsTra.MoveNext() 
	}
rsTra.Close()   
%>	

</html>

<script src="/Template/inspina/js/jquery-3.1.1.min.js"></script>
<script charset="utf-8" src="/Template/inspina/js/plugins/JsBarcode/JsBarcode.all.min.js"></script>
<script charset="utf-8" >

JsBarcode(".barcode").init();
	
$(document).ready(function(e) {
    window.print();
setTimeout(function(){ 
             window.close();
  }, 800)
});	
	

</script>    



        