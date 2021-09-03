<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%
	var Man_ID = Parametro("Man_ID",-1)


		
    var sSQL  = "SELECT *, getdate() as Fecha FROM TransferenciaAlmacen t INNER JOIN cliente c ON t.Cli_ID=c.Cli_ID "
+"INNER JOIN Almacen a on t.TA_End_Warehouse_ID = a.Alm_ID INNER JOIN Manifiesto_Salida m ON m.Man_ID=t.Man_ID "
+"INNER JOIN Proveedor p ON m.Prov_ID=p.Prov_ID LEFT OUTER JOIN Cat_Catalogo ct ON (ct.Cat_ID=Man_TipoDeRutaCG94  and ct.Sec_ID =94)" 
+" LEFT OUTER JOIN Cat_Estado e ON e.Edo_ID=m.Edo_ID LEFT OUTER JOIN Cat_Aeropuerto ae ON ae.Aer_ID=m.Aer_ID "
+"WHERE  m.Man_ID="+Man_ID+" ORDER BY m.Edo_ID desc"
				
		
	var sSQLM = " SELECT * "	
		sSQLM += " FROM Manifiesto_Salida "		
		sSQLM += " WHERE Man_ID = "+Man_ID		
				
	var rsRe = AbreTabla(sSQLM,1,0)
	
	
	var rsRe = AbreTabla(sSQL,1,0)
	var Operador = rsRe.Fields.Item("Man_Operador").Value
	var Placas = rsRe.Fields.Item("Man_Placas").Value
	var Descripcion = rsRe.Fields.Item("Man_Vehiculo").Value
	var Fecha = rsRe.Fields.Item("Fecha").Value
	var Estado = rsRe.Fields.Item("Edo_Nombre").Value
	var Aeropuerto = rsRe.Fields.Item("Aer_Nombre").Value
	var Ruta = "R " + rsRe.Fields.Item("Man_Ruta").Value
	var Transportista = rsRe.Fields.Item("Prov_Nombre").Value

		
	//bHayParametros = false
	//ParametroCargaDeSQL(sSQLRecep,0)

	
%>
<style media="print">
@page {
    size: auto;   /* auto is the initial value */
}
.page-break  { display:block; page-break-before:always; }

</style>
<link href="http://wms.lyde.com.mx/Template/inspina/css/style.css" rel="stylesheet">
<link href="http://wms.lyde.com.mx/Template/inspina/css/bootstrap.min.css" rel="stylesheet">
<div class="page-break"></div>
<table width="1151" height="137" class="table table-striped table-bordered">
  <tbody>
	<tr>
	  <td width="100" rowspan="5"><img src="/Img/wms/Logo005.png" title="Lyde" style="width:100;height:100"/></td>
	  <td width="94"  HEIGHT="1"><FONT size="1">Direccion de origen: </FONT></td>
	  <td colspan="3"  HEIGHT="1"><FONT size="1">Calle: Av. Santa Cecilia , num. Ext: 211, num. Int: Nave 3 Puerta 1, C.P: 54130, Colonia: Santa Cecilia, Tlalnepantla Edo de Mex.</FONT></td>
    </tr>
	<tr>
	  <td  HEIGHT="1"><FONT size="1">Operador:</FONT> </td>
<td width="179"  HEIGHT="1"><FONT size="1"><%=Operador%></FONT></td>
<td width="100"  HEIGHT="1"><FONT size="1">Estado:</FONT></td>
<td width="505"  HEIGHT="1"><FONT size="1"><%=Estado%></FONT></td>
  </tr>
	<tr>
	  <td  HEIGHT="1"><FONT size="1">Placas: </FONT></td>
<td  HEIGHT="1"><FONT size="1"><%=Placas%></FONT></td>
<td  HEIGHT="1"><FONT size="1">Aeropuerto:</FONT></td>
<td  HEIGHT="1"><FONT size="1"><%=Aeropuerto%></FONT></td>
</tr>
<tr>
  <td  HEIGHT="1"><FONT size="1">Vehiculo: </FONT></td>
<td  HEIGHT="1"><FONT size="1"><%=Descripcion%></FONT></td>
<td  HEIGHT="1" ><FONT size="1">Ruta:</FONT></td>
<td  HEIGHT="1"><FONT size="1"><%=Ruta%></FONT></td>
  </tr>
   <tr>
     <td  HEIGHT="1"><FONT size="1">Transportista:</FONT></td>
<td  HEIGHT="1"><FONT size="1"><%=Transportista%></FONT></td>
<td  HEIGHT="1"><FONT size="1">Fecha: </FONT></td>
<td  HEIGHT="1"><FONT size="1"><%=Fecha%></FONT></td>


  </tr>
               </tbody>
</table>

<table width="1148" class="table table-striped table-bordered">
    <thead>
  <th width="20"><FONT size="1">Num</FONT></th>
        <th width="106"><FONT size="1">Guia</FONT></th>
        <th width="142"><FONT size="1">Pedido</FONT></th>
        <th width="43"><FONT size="1">Ruta</FONT></th>
        <th width="82"><FONT size="1">Estado</FONT></th>
        <th width="39"><FONT size="1">No. cajas</FONT></th>
        <th width="46"><FONT size="1">No. Tienda</FONT></th>
        <th width="278"><FONT size="1">Tienda</FONT></th>
        <th width="231"><FONT size="1">Nombre Contacto</FONT></th>
        <th width="117"><FONT size="1">Telefono</FONT></th>
        <tbody>
		<%
		  var iCons = 1
		    while (!rsRe.EOF){
  	     var TA_ID = rsRe.Fields.Item("TA_ID").Value   
   	     var Guia  = rsRe.Fields.Item("TA_Guia").Value 
		 var Pedido = rsRe.Fields.Item("TA_Folio").Value   
	     var Ruta  = "R"+ rsRe.Fields.Item("Alm_Ruta").Value 
		 var Cajas  = "1"
		 var Num_Tienda = rsRe.Fields.Item("Alm_Numero").Value   
	     var Tienda = rsRe.Fields.Item("Alm_Nombre").Value 
		 var Dir_Tienda = rsRe.Fields.Item("Alm_Calle").Value +", No. Ext. " +  rsRe.Fields.Item("Alm_NumExt").Value
		 						   + ", No. Int. " + rsRe.Fields.Item("Alm_NumInt").Value + ", " +  rsRe.Fields.Item("Alm_Colonia").Value + ", " 
								   +rsRe.Fields.Item("Alm_Delegacion").Value + ", " +rsRe.Fields.Item("Alm_Ciudad").Value + ", " 
								   + rsRe.Fields.Item("Alm_Estado").Value
		  var Estado = rsRe.Fields.Item("Alm_Estado").Value
	      var Contacto = rsRe.Fields.Item("Alm_Responsable").Value 
		  var Tel = rsRe.Fields.Item("Alm_RespTelefono").Value 
		  var Observaciones = ""
	if(Estado == "ESTADO DE MEXICO"){
	Estado = "EDO. MEX."	
	}
		if(Estado == "CIUDAD DE MEXICO"){
	Estado = "CDMX"	
	}
	     %>
		<tr>
    
        	<td  HEIGHT="1">    <FONT size="1"><%=iCons%>   </FONT></td> 
         
          
        	<td  HEIGHT="1">   <small><FONT size="1" ><%=Guia%>  </FONT></small></td>
            <td HEIGHT="1" > <FONT size="1"><%=Pedido%>  </FONT></td>
        	<td HEIGHT="1">   <FONT size="1"><%=Ruta%>  </FONT></td>
            <td HEIGHT="1">   <FONT size="1"><%=Estado%>  </FONT></td>
            <td HEIGHT="1">   <FONT size="1"><%=Cajas%>  </FONT></td>
        	<td HEIGHT="1">   <FONT size="1"><%=Num_Tienda%>  </FONT></td>
        	<td HEIGHT="1">   <FONT size="1"><%=Tienda%>  </FONT></td>
        	<td HEIGHT="1">   <FONT size="1"><%=Contacto%>  </FONT></td>
            <td HEIGHT="1">   <FONT size="1"><%=Tel%>  </FONT></td>
       	
       </tr>
		<tr>
           <td HEIGHT="1"> <FONT size="1">&nbsp;</FONT></td>
        	<td HEIGHT="1"> <FONT size="1">Direccion</FONT></td>
           
			<td colspan="8"  HEIGHT="1"> <FONT size="1"><%=Dir_Tienda%></FONT></td>
	
       </tr>
  <% if(Observaciones != "") {%>
		<tr>
         <td>&nbsp;</td>
        	<td>Observaciones</td>
        	<td colspan="8" HEIGHT="10"><%=Observaciones%></td>
       </tr>
		<%	
                  }
			iCons++
            rsRe.MoveNext() 
        }
         rsRe.Close()   
        %>
    </tbody>
</table>

<script src="/Template/inspina/js/jquery-3.1.1.min.js"></script>
<script type="application/javascript">
$(document).ready(function(e) {
	window.print();    
});
</script>


