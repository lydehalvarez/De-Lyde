<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->

<%

	var Cort_ID = Parametro("Cort_ID",-1)
	
	var sSQLOV = "SELECT * "
		sSQLOV += "FROM Orden_Venta t WHERE Cort_ID = "+Cort_ID
		sSQLOV += "AND OV_Test = 0 "
		sSQLOV += "AND OV_Cancelada = 0 "
		sSQLOV += "AND OV_CUSTOMER_NAME is not null "
		sSQLOV += "ORDER BY (SELECT TOP 1 OVA_PART_NUMBER FROM [dbo].[Orden_Venta_Articulo] WHERE OV_ID = t.OV_ID) DESC "
				
%>
<html >
<head>
<head>

    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="/Template/inspina/css/bootstrap.min.css" rel="stylesheet">
	
	
</head>
<%
	var rsArt = AbreTabla(sSQLOV,1,0)
     while (!rsArt.EOF){
%>	
<div class="form-horizontal">
        <div class="ibox-content">
            <div class="col-md-12">
                <table class="table">
                <tr>
                    <td colspan="5" style="text-align:center">
						<svg class="barcode"
                          jsbarcode-value="<%=rsArt.Fields.Item("OV_Folio")%>">
                        </svg>
                    </td>
                </tr>
                <tr>
                    <td>Direcci&oacute;n:</td>
                    <td colspan="4"><%=rsArt.Fields.Item("OV_SHIPPING_ADDRESS")%></td>
                </tr>
                <tr>
                    <td>Destinatario:</td>
                    <td colspan="4"><%=rsArt.Fields.Item("OV_CUSTOMER_NAME")%></td>
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
<%
	rsArt.MoveNext() 
	}
rsArt.Close()   
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



        