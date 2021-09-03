<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->

<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300&display=swap" rel="stylesheet">
<link href="/Template/inspina/css/bootstrap.min.css" rel="stylesheet">
<style type="text/css">

		@media all {
		   .saltopagina{
			  display: none;
		   }
		}	
		body, div, table, thead, tbody, tfoot, tr, th, td, p {
			font-family: 'Poppins', sans-serif;
			font-size: 18px
		}
		
		@media print{
			@page {
			   size: 8in 2in portrait;
			}
		   .saltopagina{
			  display:block;
			  page-break-before:always;
		   }
		   .col-sm-1, .col-sm-2, .col-sm-3, .col-sm-4, .col-sm-5, .col-sm-6, .col-sm-7, .col-sm-8, .col-sm-9, .col-sm-10, .col-sm-11, .col-sm-12 {
			  float: left;
			}
			.col-sm-12 {
			  width: 100%;
			}
			.col-sm-6 {
			  width: 50%;
			}
		}

</style>
<div> 
<%
	var Pt_ID = Parametro("Pt_ID",-1)
	
	var Etiquetas = "EXEC [dbo].[SP_Recepcion_EtiquetasMasterBox]"
					  +"@PT_ID = "+Pt_ID
					  
	var rsEtiquetas = AbreTabla(Etiquetas,1,0)
	
	var Folio = 0
	var lado = ""
	var i = 0;
	var SaltoDeHoja = ""
	if(!rsEtiquetas.EOF){
		while(!rsEtiquetas.EOF){
			i++;
			Folio = rsEtiquetas.Fields.Item("Folio").Value
			if(i % 2 != 0){
				lado = "right"
				%>
               <div style="width:4in;height:2in;">
			<%}else{
				lado = "left"
			}%>  
            <div class="col-sm-6">
                   <div style="text-align:center;padding-<%=lado%>:30px;">
                      <img src='https://barcode.tec-it.com/barcode.ashx?data=<%=Folio%>&code=Code128&dpi=120&imagetype=Svg&hidehrt=True'/>
                        <p><%=Folio%></p>
                    </div>
                </div>   
			<%	
			if(i % 2 ==0){%>
                </div>
			<%}
			if((SaltoDeHoja != "") && (i % 2 == 0)){Response.Write("<div class='saltopagina'></div>")}else{SaltoDeHoja = "a"}
			
			rsEtiquetas.MoveNext() 
        } 
        rsEtiquetas.Close()
	}
	
%>

</div>


<script src="/Template/inspina/js/jquery-3.1.1.min.js"></script>
<script charset="utf-8" src="/Template/inspina/js/plugins/JsBarcode/JsBarcode.all.min.js"></script>
<script charset="utf-8" >

JsBarcode(".barcode").init();
	
//$(document).ready(function(e) {
//    window.print();
//setTimeout(function(){ 
//             window.close();
//  }, 800)
//});	
	

</script>    



