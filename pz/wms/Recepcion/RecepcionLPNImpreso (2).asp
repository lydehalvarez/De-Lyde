<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%
 	var IR_ID = Parametro("IR_ID",-1)
	var Dia = Parametro("Dia",-1)
	var Tipo = Parametro("Tipo",-1) 
	var Pt_LPN = Parametro("Pt_LPN","")
	var Tarea = Parametro("Tarea",-1)

	var sSQLRecep = "SELECT * "
		sSQLRecep += "FROM Recepcion_Pallet  WHERE Pt_LPN = '" +Pt_LPN + "'"
    var rsPallets = AbreTabla(sSQLRecep,1,0)
    if (!rsPallets.EOF){
		var Ubi_ID = rsPallets.Fields.Item("Ubi_ID").Value 
        var Ubicacion = rsPallets.Fields.Item("Pt_Ubicacion").Value 
		var Pt_Color = rsPallets.Fields.Item("Pt_Color").Value 
        var Pt_Modelo = rsPallets.Fields.Item("Pt_Modelo").Value 
        var Pt_SKU = rsPallets.Fields.Item("Pt_SKU").Value 
        var Pt_LPN = rsPallets.Fields.Item("Pt_LPN").Value 
        var Pt_Cantidad = rsPallets.Fields.Item("Pt_Cantidad").Value 
        var Pt_FechaRegistro =  rsPallets.Fields.Item("Pt_FechaRegistro").Value
		
		   	 var Cli_ID = rsPallets.Fields.Item("Cli_ID").Value 
			var Prov_ID = rsPallets.Fields.Item("Prov_ID").Value 
		if(Cli_ID > -1){
	sSQLRecep = "SELECT * FROM Cliente WHERE Cli_ID = '"+Cli_ID+"'"
	var rsProvCli = AbreTabla(sSQLRecep,1,0)
	var Cliente = rsProvCli.Fields.Item("Cli_Nombre").Value 
		}else{
	sSQLRecep = "SELECT * FROM Proveedor WHERE Prov_ID = '"+Prov_ID+"'"
		var rsProvCli = AbreTabla(sSQLRecep,1,0)

	var Cliente = rsProvCli.Fields.Item("Prov_Nombre").Value 
  		}
	}
    rsPallets.Close()
	if (Tarea == -1){

	
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
 	<td COLSPAN="2">
      <%
				if(Cli_ID > -1){
				%>
 <H2><strong>CLIENTE:</strong></H2>
 		<%
				}else{
 		%>
        <H2><strong>PROVEEDOR:</strong></H2>
        <%
				}
 		%>
	</td>
    <td COLSPAN="3">
 <H2><strong><%=Cliente%> </strong></H2>
   </td>    </tr>

  		<tr> 		 <td COLSPAN="5">
 <H2> <strong><%=Pt_LPN%> </strong></H2></div>
  		</td>
  		</tr>
        <tr>
 				 <td COLSPAN="5">
<svg id="barcode"></svg>

    
		  </td>
   </tr>
			<tr>
            	<td WIDTH="50"  >
   <H2> <strong>RECEPCION: </strong></H2>
   			</td>
            	<td WIDTH="50" COLSPAN="2" >
    <H2><strong> <%=Parametro("Folio","")%> </strong></H2>
 			 	</td>
  			<td >
   <H2> <strong>SKU: </strong></H2> 
   			</td>
            	<td  COLSPAN="2" >
  <H2> <strong>  <%=Pt_SKU%> </strong></H2>
 			 	</td>
         	</tr>
  				
   					<tr>
 					 <td>
    <H3>
        <strong>Modelo: </strong>
         </H3>
        			</td>
                    	<td COLSPAN="2"> 
                       <h3> <strong><%=Pt_Modelo%></strong></h3>
        			 	</td>
							<td>
       						     <h3> <strong>Fecha: </strong></h3>
        					</td>
                            	<td COLSPAN="2">
                                     <h3>  <strong><%=Pt_FechaRegistro%></strong></h3>
        						</td>
   </tr>
       							 <tr>
       					 			<td>
       								       <h3> <strong>  Color:</strong> </h3>
                                   </td><td COLSPAN="2">
                                         <h3>   <strong><%=Pt_Color%> </strong> </h3>
         					 		</td>
       					   	  			
    </H3>
  								 		<td >
        							    <h3> <strong>Cantidad: </strong></h3></td><td COLSPAN="2">    <blockquote>
        							      <h3> <strong><%=Pt_Cantidad%></strong></h3>
      							      </blockquote>
         					 		    </td>
   </tr>
<%   if(Ubicacion != ""){
%>      
       							 <tr>
       							   <td colspan="7">Ubicaci&oacute;n</td>
    </tr>
       							 <tr>
       							   <td colspan="7"><svg id="cbUbicacion"></svg>
                                            <H2> <strong>  <%=Ubicacion%> </strong></H2></td>
    </tr>
<%   }
%>                             
 </table>         

   </CENTER>      
  
  <%

  %>
</body>
<footer>&nbsp;</footer>
<% }else{
	var FolioOC = Parametro("FolioOC","")	
		
	if(Cli_ID > -1){
var sSQLTr  = "SELECT r.*, u.Ubi_Nombre, i.IR_Folio,  CONVERT(VARCHAR(17), getdate(), 103) AS Hoy, CONVERT(VARCHAR(8), getdate(), 108) AS Hora, Cli_Nombre , ASN_FolioCliente  FROM Recepcion_Pallet r INNER JOIN CLIENTE c ON c.Cli_ID=r.Cli_ID  INNER JOIN Ubicacion u ON u.Ubi_ID=r.Ubi_ID  INNER JOIN Inventario_Recepcion i ON i.IR_ID=r.IR_ID LEFT OUTER JOIN ASN a ON r.ASN_ID=a.ASN_ID WHERE Pt_LPN='"+Pt_LPN+"'"

		  	var rsUbicacion = AbreTabla(sSQLTr,1,0)
			var Cliente = rsUbicacion.Fields.Item("Cli_Nombre").Value
			var ASN =  rsUbicacion.Fields.Item("ASN_FolioCliente").Value 	
			
				if (ASN == 0){
				ASN = ""
				}
			
	}else{
		
var sSQLTr  = "SELECT r.*, u.Ubi_Nombre, i.IR_Folio,  CONVERT(VARCHAR(17), getdate(), 103) AS Hoy, CONVERT(VARCHAR(8), getdate(), 108) AS Hora, Prov_Nombre   FROM Recepcion_Pallet r INNER JOIN Proveedor p ON p.Prov_ID=r.Prov_ID INNER JOIN Ubicacion u ON u.Ubi_ID=r.Ubi_ID  INNER JOIN Inventario_Recepcion i ON i.IR_ID=r.IR_ID   "
sSQLTr += "LEFT OUTER JOIN ASN a ON r.ASN_ID=a.ASN_ID WHERE Pt_LPN='"+Pt_LPN+"'"

			var rsUbicacion = AbreTabla(sSQLTr,1,0)
			var Cliente = rsUbicacion.Fields.Item("Prov_Nombre").Value
			var ASN = ""
	}	
			var Pt_ID = rsUbicacion.Fields.Item("Pt_ID").Value
			var Ubicacion =  rsUbicacion.Fields.Item("Ubi_Nombre").Value 		
			var Hoy = rsUbicacion.Fields.Item("Hoy").Value
			var Hora = rsUbicacion.Fields.Item("Hora").Value
			var Pt_SKU = rsUbicacion.Fields.Item("Pt_SKU").Value
			var Pt_LPN = rsUbicacion.Fields.Item("Pt_LPN").Value
			var Pt_Cantidad = rsUbicacion.Fields.Item("Pt_Cantidad").Value
			var Pt_Modelo = rsUbicacion.Fields.Item("Pt_Modelo").Value
			var Pt_Color = rsUbicacion.Fields.Item("Pt_Color").Value
			var Cita = rsUbicacion.Fields.Item("IR_Folio").Value 	
			var Pt_Usuario = ""
	%>
    <style media="print">
    @page {
        size: landscape;   /* auto is the initial value */
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
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width,maximum-scale=1.0">

<!--<style type="text/css" media="screen"></style>

<style type="text/css" media="print">
 
/* @page {size:landscape}  */   
body {
    page-break-before: avoid;
    width:100%;
    height:100%;
    -webkit-transform: rotate(-90deg) scale(.90,.75); 
    -moz-transform:rotate(-90deg) scale(.78,.78);
    zoom: 200%    }

</style>-->
<center><table width="900px" border="1" cellpadding="1" cellspacing="1" style="text-align:center;">
  <tbody>
    <tr>
      <td width="143" rowspan="2">  
<img src="/Img/wms/Logo005.png" title="Lyde" style="width:100;height:100"/>
</td>
      <td colspan="3"  bgcolor = "silver"><strong>Cliente</strong></td>
      <td width="90"  bgcolor = "silver"><strong>Fecha</strong></td>
    </tr>
    <tr>
      <td height="49" colspan="3"><H1><strong> <%
            if(Cli_ID>-1){
            %>
            <%=Cliente%>  
            <%
            }else{
            %>
            LYDE
            <%
            }
            %>
            </strong></H1></td>
      <td><H3><strong><%=Hoy%></strong></H3>
</td>
    </tr>
    <tr>
      <td colspan="3"  width="150"  bgcolor = "silver"><strong>SKU</strong></td>
      <% if(ASN !=""){
		  %>
      <td width="120" bgcolor = "silver"><strong>ASN</strong></td>
      <%
	  }
	  %>
      <td colspan="2" bgcolor = "silver"><strong>Cita</strong></td>
    </tr>
    <tr>
      <td height="49"  colspan="3">  <FONT SIZE=10><strong><%=Pt_SKU%></strong></FONT></td>
      <% if(ASN !=""){
		  %>
      <td>    <H2><strong><%=ASN%></strong></H2></td>
       <%
	  }
	  %>
      <td colspan="2"><H2><strong><%=Cita%></strong></H2></td>
    </tr>
    <tr>
      <td colspan="5" align="center" bgcolor = "silver"><strong>Modelo</strong></td>
    </tr>
    <tr>
      <td height="62" colspan="5"><H2> <strong><%=Pt_Modelo%> </strong></H2>
</td>
    </tr>
    <tr>
      <td  bgcolor = "silver"><strong>Cantidad</strong></td>
      <td colspan="4"  bgcolor = "silver"><strong>LPN</strong></td>
    </tr>
    <tr>
      <td height="40">  <FONT SIZE=10><strong><%=Pt_Cantidad%></strong></FONT>
</td>
      <td colspan="4"> <svg id="barcode"></svg>
      <H1><strong><%=Pt_LPN%></strong></H1></td>
    </tr>
    <tr>
      <td colspan="5" bgcolor = "silver"><strong>Ubicacion</strong></td>
    </tr>
    <tr>
      <td height="30" colspan="5">       <svg id="cbUbicacion"></svg>
                                            <H2> <strong>  <%=Ubicacion%> </strong></H2></td>
    </tr>
    <tr>
      <td colspan="2"  bgcolor = "silver"><strong>Lote de ingreso</strong></td>
      <td  bgcolor = "silver"><strong>Folio del Documento</strong></td>
      <td colspan="2"  bgcolor = "silver"><strong>Ingresado por:</strong></td>
    </tr>
    <tr>
      <td height="33" colspan="2"></td>
      <td>  <H3><strong><%=Parametro("FolioOC","")%></strong></H3></td>
      <td colspan="2"> <%
sSQL = "SELECT (Emp_Nombre + ' ' + Emp_ApellidoPaterno) as nombre  FROM Seguridad_Indice u INNER JOIN Recepcion_Masterbox m "
+"ON m.MB_Usuario=u.IDUnica INNER JOIN Empleado e ON e.Emp_ID=u.Emp_ID  WHERE Pt_ID ="+ Pt_ID+" GROUP BY Emp_Nombre, Emp_ApellidoPaterno"

var rsUsuarios = AbreTabla(sSQL,1,0)

   while(!rsUsuarios.EOF){
	  %><FONT SIZE=4><STRONG>- <%=rsUsuarios.Fields.Item("nombre").Value%>
      </STRONG></FONT>&nbsp;
      <%	
    rsUsuarios.MoveNext() 
	}
	rsUsuarios.Close()   
	%></td>
    </tr>
  </tbody>
</table>
  
     </center>
  
</body>
<footer>&nbsp;</footer>
<% } %>
    
<script src="/Template/inspina/js/jquery-3.1.1.min.js"></script>
<script charset="utf-8" src="/Template/inspina/js/plugins/JsBarcode/JsBarcode.all.min.js"></script>
<script charset="utf-8" >
	JsBarcode("#barcode", "<%=Pt_LPN%>", {
	  width: 3,
	  align:"center",
	  height: 100,
	  fontSize: 1,
	  displayValue: false,
	  font:"fantasy"
	});
JsBarcode("#cbUbicacion", "<%=Ubicacion%>", {
	  width: 3,
	  height: 80,
	  fontSize: 1,
	  displayValue: false,
	  font:"fantasy"
	});

</script>


