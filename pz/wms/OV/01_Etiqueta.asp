<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->

<%

	var OV_ID = Parametro("OV_ID",-1)
	
	var sSQLOV = "SELECT * "
		sSQLOV += "FROM Orden_Venta WHERE OV_ID = " + OV_ID
		
		bHayParametros = false
		ParametroCargaDeSQL(sSQLOV,0)
	var Folio = Parametro("OV_Folio",-1)
	var CUSTOMER_NAME = Parametro("OV_CUSTOMER_NAME",-1)
	var SHIPPING_ADDRESS = Parametro("OV_SHIPPING_ADDRESS",-1)
	var Cort_ID = Parametro("Cort_ID",-1)
		
%>
<html >
<head>
<head>

    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="/Template/inspina/css/bootstrap.min.css" rel="stylesheet">
	
	
</head><div class="form-horizontal">
        <div class="ibox-content">
            <div class="col-md-12">
                <table class="table">
                <tr>
                    <td colspan="5" style="text-align:center">
                    <canvas id="barcode"></canvas>                    
                    </td>
                </tr>
                <tr>
                    <td>Direcci&oacute;n:</td>
                    <td colspan="4"><%=SHIPPING_ADDRESS%></td>
                </tr>
                <tr>
                    <td>Destinatario:</td>
                    <td colspan="4"><%=CUSTOMER_NAME%></td>
                </tr>
                <tr>
                    <td>Corte:</td>
                    <td colspan="4"><%=Cort_ID%></td>
                </tr>
                </table>
             </div>
        </div>
    </div>    
</div>
</html>

<script src="/Template/inspina/js/jquery-3.1.1.min.js"></script>
<script charset="utf-8" src="/Template/inspina/js/plugins/JsBarcode/JsBarcode.all.min.js"></script>
<script charset="utf-8" >
	JsBarcode("#barcode", "<%=Folio%>", {
	  width: 2,
	  height: 100,
	  displayValue: true   
	});
	  
$(document).ready(function(e) {
    window.print()
setTimeout(function(){ 
             window.close();
  }, 800)
});	

	

</script>    



        