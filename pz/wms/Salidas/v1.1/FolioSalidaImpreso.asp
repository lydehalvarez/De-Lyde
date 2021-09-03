<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%
 	var Man_ID = Parametro("Man_ID",-1)
	
	sSQL = "SELECT TA_ID FROM TransferenciaAlmacen WHERE Man_ID = "+Man_ID 
	var rsTras = AbreTabla(sSQL, 1,0)
	 while (!rsTras.EOF){
	 var TA_ID = rsTras.Fields.Item("TA_ID").Value
		   
	sSQL = "UPDATE TransferenciaAlmacen SET TA_EstatusCG51 = 5 WHERE TA_ID="+TA_ID
		Ejecuta(sSQL,0)
	   rsTras.MoveNext() 
            	}
        rsTras.Close()   
sSQL =" SELECT m.*, p.Prov_Nombre , getdate() as fecha FROM Manifiesto_Salida m"
		+ " INNER JOIN Proveedor p ON m.Prov_ID=p.Prov_ID  WHERE Man_ID="+Man_ID
var rsManifiesto = AbreTabla(sSQL, 1, 0)

			  var Folio = rsManifiesto.Fields.Item("Man_FolioSalida").Value
			  var Man_Folio = rsManifiesto.Fields.Item("Man_Folio").Value 
			  var Cajas = rsManifiesto.Fields.Item("Man_CantidadCajas").Value 
			  var Peso = rsManifiesto.Fields.Item("Man_Peso").Value 
			  var Transferencias = rsManifiesto.Fields.Item("Man_Transferencias").Value 
			  var Proveedor = rsManifiesto.Fields.Item("Prov_Nombre").Value 
			  var Fecha = rsManifiesto.Fields.Item("fecha").Value 
			  var IDUsuario = rsManifiesto.Fields.Item("Man_UsuValido").Value 
			  
			  sSQL = "SELECT  dbo.fn_Usuario_DameNombreUsuario( "+IDUsuario+" ) as valido" 
			  var rsValido = AbreTabla(sSQL, 1, 0)

			  var UsuValido =  rsValido.Fields.Item("valido").Value 
	
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

 <table width="508" height="192" border="1" style="text-align:center;">


			<tr>
            	<td WIDTH="102"  >
   <H3> <strong>Folio de salida: </strong></H3>
   			</td>
            	<td WIDTH="50" >
<svg id="barcode"></svg>
<H2> <strong>  <%=Folio%> </strong></H2>
 			 	</td>
  			<td width="176" >
   <H3> <strong>Transportista: </strong></H3> 
   			</td>
            	<td width="134" >
  <H3> <strong>  <%=Proveedor%></strong></H3>
 			 	</td>
         	</tr>
  				
   					<tr>
 					 <td>
    <H3>
        <strong>Manifiesto: </strong>
         </H3>
        			</td>
                    	<td> 
                       <h3> <strong><%=Man_Folio%></strong></h3>
        			 	</td>
							<td>
       						     <h3> <strong>Transferencias: </strong></h3>
        					</td>
                            	<td>
                                     <h3>  <strong><%=Transferencias%></strong></h3>
        						</td>
   </tr>
       							 <tr>
       					 			<td>
       								       <h3> <strong>Cajas</strong>:</h3>
                                   </td><td>
                                         <h3><strong><%=Cajas%></strong></h3>
         					 		</td>
       					   	  			
  
  								 		<td >
        							    <h3><strong>Peso:</strong></h3></td><td>    <h3><strong><%=Peso%> kg</strong></h3>
         					 		</td>
   </tr>
   <tr>
   	 		<td >
        							    <h3> <strong>Salida hecha por: </strong></h3></td><td >    <h3> <strong><%=UsuValido%></strong></h3>
         					 		</td>
                                    <td >
        							    <h3><strong>Fecha:</strong></h3></td><td>    <h4><strong><%=Fecha%></strong></h4>
         					 		</td>
   </tr>
   <tr>
   	 		<td >
        							    <h4> <strong>Nombre y Firma LYDE: </strong></h4></td><td >    
         					 		</td>
                                    <td >
        							    <h4><strong>Nombre y Firma Transportista:</strong></h4></td><td> 
         					 		</td>
   </tr>
                                 
</table>         

   </CENTER>      
  

</body>
  
    
<script src="/Template/inspina/js/jquery-3.1.1.min.js"></script>
<script charset="utf-8" src="/Template/inspina/js/plugins/JsBarcode/JsBarcode.all.min.js"></script>
<script charset="utf-8" >
	JsBarcode("#barcode", "<%=Folio%>", {
	  width: 2,
	  align:"center",
	  height: 70,
	  fontSize: 1,
	  displayValue: false,
	  font:"fantasy"
	});

</script>


