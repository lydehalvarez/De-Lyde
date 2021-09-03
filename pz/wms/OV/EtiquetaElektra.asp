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
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="/Template/inspina/css/bootstrap.min.css" rel="stylesheet">
</head>
<style>
.ParaAlla{
	margin-left:15px	
	
}
@page {
  size: A7 landscape; 
}

</style>
    <div class="form-horizontal">
             <div class="form-group">
                 <label class="control-lable col-xs-3">N&uacute;mero de tienda</label>
                 <div class="col-xs-9">456</div>
             </div>
             <div class="form-group">
                 <label class="control-lable col-xs-3">Destinatario:</label>
                 <div class="col-xs-9">Nombre de la persona</div>
             </div>
             <div class="form-group">
                    <label class="control-lable col-xs-3">Numero de caja</label>
                 <div class="col-xs-7">1 de 3</div>
            </div>
        </div> 
        <div style="text-align:center;margin-left:50px">
            <canvas id="barcode"></canvas>      
        </div>  
    </div>  

<script src="/Template/inspina/js/jquery-3.1.1.min.js"></script>
<script charset="utf-8" src="/Template/inspina/js/plugins/JsBarcode/JsBarcode.all.min.js"></script>
<script charset="utf-8" >
	JsBarcode("#barcode", "FolioXXXXX", {
	  width: 3,
	  height: 100,
	  fontSize: 22,
	  displayValue: true,
	  font:"fantasy"
	});
		

</script>    



        