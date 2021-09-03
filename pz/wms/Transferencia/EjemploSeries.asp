<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
	   	<table width="600" style="font-family:Arial, Helvetica, sans-serif;font-size:13px">
<%
   
   var series = ['147245100379262','147245100379263','147245100379264','147245100379265','147245100379266','147245100379267','147245100379268','147245100379269','147245100379270','147245100379271','147245100379272','147245100379273','147245100379274','147245100379275','147245100379276','147245100379277','147245100379278','147245100379279','147245100379280','147245100379281','147245100379282','147245100379283','147245100379284','147245100379285','147245100379286','147245100379287','147245100379288','147245100379289','147245100379290','147245100379291','147245100379292','147245100379293','147245100379294','147245100379295','147245100379296','147245100379297','147245100379298','147245100379299','147245100379300','147245100379301']
 	for (x=0;x<40;x++) {
%>
            <tr>
                <td style="text-align:center">
                   <%=series[x]%>
                </td>
                <td   style="text-align:center">
                    <svg class="barcode"
                      jsbarcode-value="<%=series[x]%>">
                    </svg>
                </td>
                
                
            </tr>
<%
 }
%>	
        </table>

 

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



        