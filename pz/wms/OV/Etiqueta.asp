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
<div>
    <div style="text-align:center;margin-left:50px">
        <canvas id="barcode"></canvas>      
    </div>  
    <div class="form-horizontal">
             <div class="form-group">
                 <label class="control-lable col-xs-3">Direcci&oacute;n:</label>
                 <div class="col-xs-9">
					  <%=SHIPPING_ADDRESS%>
                 </div>
             </div>
             <div class="form-group">
                 <label class="control-lable col-xs-3">Destinatario:</label>
                 <div class="col-xs-9">
                    <%=CUSTOMER_NAME%>
                 </div>
             </div>
             <div class="form-group">
                    <label class="control-lable col-xs-3">Corte: </label>
                 <div class="col-xs-7">
                    <%=Cort_ID%>
                 </div>
            </div>
        </div> 
    </div>        
    </div>        
</div>	

<script src="/Template/inspina/js/jquery-3.1.1.min.js"></script>
<script charset="utf-8" src="/Template/inspina/js/plugins/JsBarcode/JsBarcode.all.min.js"></script>
<script charset="utf-8" >
	JsBarcode("#barcode", "<%=Folio%>", {
	  width: 3,
	  height: 100,
	  fontSize: 22,
	  displayValue: true,
	  font:"fantasy"
	});
	
$(document).ready(function(e) {
    window.print();
setTimeout(function(){ 
             window.close();
  }, 800)
});	
	

</script>    



        