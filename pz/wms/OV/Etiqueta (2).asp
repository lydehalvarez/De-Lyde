<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->

<%

	var OV_ID = Parametro("OV_ID",-1)
	
	var sSQLOV = "SELECT OV_Folio,OV_CUSTOMER_NAME,OV_SHIPPING_ADDRESS,[dbo].[fn_SO_DireccionCompleta] ("+OV_ID+") SHIPPING_ADDRESS,Cort_ID "
		sSQLOV += "FROM Orden_Venta WHERE OV_ID = " + OV_ID
		
		bHayParametros = false
		ParametroCargaDeSQL(sSQLOV,0)
	var Folio = Parametro("OV_Folio",-1)
	var CUSTOMER_NAME = Parametro("OV_CUSTOMER_NAME",-1)
	var SHIPPING_ADDRESS = Parametro("SHIPPING_ADDRESS",-1)
	var Cort_ID = Parametro("Cort_ID",-1)
		
%>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="/Template/inspina/css/bootstrap.min.css" rel="stylesheet">
</head>
<style>
.ParaAlla{
	margin-left:15px	
}
.Izquierda{
	text-align:right;
	padding-bottom:15px;
	font-size:10px; 
}
.Separado{
	padding-left:25px;
	padding-bottom:9px;
	font-size:10px; 
}
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

</style>

<div>
    <div style="text-align:center;">
        <canvas id="barcode"></canvas>  
        <p style="font-family:Arial, Helvetica, sans-serif;font-size:13px"><%=Folio%></p>    
    </div>  
    	<table width="100%">
        	<tbody>
            	<tr>
                	<td class="Izquierda" align="justify">Direcci&oacute;n:</td>
                	<td class="Separado"><%=SHIPPING_ADDRESS%></td>
                </tr>
            	<tr>
                	<td class="Izquierda">Destinatario:</td>
                	<td class="Separado"><%=CUSTOMER_NAME%></td>
                </tr>
            	<tr>
                	<td class="Izquierda">Corte:</td>
                	<td class="Separado"><%=Cort_ID%></td>
                </tr>
            </tbody>
        </table>
    </div>        
</div>	

<script src="/Template/inspina/js/jquery-3.1.1.min.js"></script>
<script charset="utf-8" src="/Template/inspina/js/plugins/JsBarcode/JsBarcode.all.min.js"></script>
<script charset="utf-8" >
	JsBarcode("#barcode", "<%=Folio%>", {
	  width: 2,
	  height: 75,
	  displayValue: false
	});
	
$(document).ready(function(e) {
    window.print();
setTimeout(function(){ 
             window.close();
  }, 800)
});	
	

</script>    



        