<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%
 	var Folio = Parametro("Folio",-1)
	
sSQL =" SELECT m.*, c.Cat_Nombre, p.Pro_Nombre, p.Pro_SKU FROM Producto_Movimiento m "
		+	" INNER JOIN Producto p ON p.Pro_ID = m.Pro_ID INNER JOIN Cat_Catalogo c ON c.Cat_ID=m.ProM_TipoCG170"
sSQL += " WHERE ProM_ID = "+Folio+"  AND c.Sec_ID  = 170"
var rsMovimiento = AbreTabla(sSQL, 1, 0)

			  var Folio = rsMovimiento.Fields.Item("ProM_ID").Value
			  var Producto = rsMovimiento.Fields.Item("Pro_Nombre").Value 
			  var Pro_SKU = rsMovimiento.Fields.Item("Pro_SKU").Value 
			  var Cantidad = rsMovimiento.Fields.Item("ProM_Cantidad").Value 
			  var Movimiento = rsMovimiento.Fields.Item("Cat_Nombre").Value 
			  var FechaRegistro = rsMovimiento.Fields.Item("ProM_FechaRegistro").Value 
	
%>
<style media="print">
    @page {
        size: auto;   /* auto is the initial value */
    }
    .page-break  { 
        display:block; 
        page-break-before:always; 
    }

</style>
<link href="/Template/inspina/css/style.css" rel="stylesheet">
<link href="/Template/inspina/css/bootstrap.min.css" rel="stylesheet">

<title>&nbsp;</title>
<body>
    <center>
        <H1>
      
        </H1>
    </center>
  <br />
  <br />
  
 
   <CENTER>

 <table border="1" style="text-align:center;">


			<tr>
            	<td WIDTH="50"  >
   <H2> <strong>Folio: </strong></H2>
   			</td>
            	<td WIDTH="50" >
<svg id="barcode"></svg>
 			 	</td>
  			<td >
   <H2> <strong>SKU: </strong></H2> 
   			</td>
            	<td >
  <H2> <strong>  <%=Pro_SKU%> </strong></H2>
 			 	</td>
         	</tr>
  				
   					<tr>
 					 <td>
    <H3>
        <strong>Modelo: </strong>
         </H3>
        			</td>
                    	<td> 
                       <h3> <strong><%=Producto%></strong></h3>
        			 	</td>
							<td>
       						     <h3> <strong>Fecha: </strong></h3>
        					</td>
                            	<td>
                                     <h3>  <strong><%=FechaRegistro%></strong></h3>
        						</td>
   </tr>
       							 <tr>
       					 			<td>
       								       <h3> <strong>  Movimiento:</strong> </h3>
                                   </td><td>
                                         <h3>   <strong><%=Movimiento%> </strong> </h3>
         					 		</td>
       					   	  			
  
  								 		<td >
        							    <h3> <strong>Cantidad: </strong></h3></td><td>    <h3> <strong><%=Cantidad%></strong></h3>
         					 		</td>
   </tr>
                                 
</table>         

   </CENTER>      
  

</body>
  
    
<script src="/Template/inspina/js/jquery-3.1.1.min.js"></script>
<script charset="utf-8" src="/Template/inspina/js/plugins/JsBarcode/JsBarcode.all.min.js"></script>
<script charset="utf-8" >
	JsBarcode("#barcode", "<%=Folio%>", {
	  width: 3,
	  align:"center",
	  height: 100,
	  fontSize: 1,
	  displayValue: false,
	  font:"fantasy"
	});

</script>


