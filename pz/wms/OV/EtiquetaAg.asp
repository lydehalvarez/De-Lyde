<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->

<%

	var FolioAg = Parametro("FolioAg",-1)
	var Destino = Parametro("Destino",-1)
	var Nombre = Parametro("Nombre",-1)
	
				
%>
<html >
<head>
<head>

    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="/Template/inspina/css/bootstrap.min.css" rel="stylesheet">
	
	
</head>


<div class="form-horizontal">
        <div class="ibox-content">
            <div class="col-md-12">
                <table class="table">
                <tr>
                    <td colspan="5" style="text-align:center">
						<svg class="barcode"
                          jsbarcode-value="<%=FolioAg%>">
                        </svg>
                    </td>
                </tr>
                <tr>
                    <td>Direcci&oacute;n:</td>
                    <td colspan="4"><%=Destino%></td>
                </tr>
                <tr>
                    <td>Destinatario:</td>
                    <td colspan="4"><%=Nombre%></td>
                </tr>
                </table>
             </div>
        </div>
    </div>    
</div>

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

