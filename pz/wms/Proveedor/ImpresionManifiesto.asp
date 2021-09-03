<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%
	var Man_ID = Parametro("Man_ID",-1)

    var sSQL  = "SELECT *, CONVERT(NVARCHAR(12), m.Man_FechaRegistro, 103) as Fecha "
              + " , e.Edo_Nombre as ESTADO "
              + " FROM TransferenciaAlmacen t "
              + " INNER JOIN cliente c "
              +    " ON t.Cli_ID=c.Cli_ID "
              + " INNER JOIN Almacen a  "
              +    " ON t.TA_End_Warehouse_ID = a.Alm_ID "
              + " INNER JOIN Manifiesto_Salida m "
              +    " ON m.Man_ID=t.Man_ID "
              + " LEFT JOIN Proveedor p ON m.Prov_ID=p.Prov_ID "
              + " LEFT JOIN Cat_Catalogo ct ON ct.Cat_ID = Man_TipoDeRutaCG94 and ct.Sec_ID = 94" 
              + " LEFT JOIN Cat_Estado e ON e.Edo_ID=m.Edo_ID "
              + " LEFT JOIN Cat_Aeropuerto ae ON ae.Aer_ID=m.Aer_ID "
              + " WHERE m.Man_ID="+Man_ID
              + " ORDER BY a.Alm_Ruta, a.Alm_Nombre, t.Man_FechaRegistro desc"
				
	//Response.Write(sSQL)	
	var sSQLM = " SELECT * "	
		sSQLM += " FROM Manifiesto_Salida "		
		sSQLM += " WHERE Man_ID = "+Man_ID		

	
	var rsRe = AbreTabla(sSQL,1,0)
    
	var Operador = rsRe.Fields.Item("Man_Operador").Value
	var Folio = rsRe.Fields.Item("Man_Folio").Value
	var Placas = rsRe.Fields.Item("Man_Placas").Value
	var Descripcion = rsRe.Fields.Item("Man_Vehiculo").Value
	var Fecha = rsRe.Fields.Item("Fecha").Value
	var Estado = rsRe.Fields.Item("ESTADO").Value
	var Aeropuerto = rsRe.Fields.Item("Aer_Nombre").Value
	var Ruta = "R " + rsRe.Fields.Item("Man_Ruta").Value
	var Transportista = rsRe.Fields.Item("Prov_Nombre").Value

	var CajasyPeso = " Cajas: " + rsRe.Fields.Item("Man_CantidadCajas").Value
    if(rsRe.Fields.Item("Man_Peso").Value>0){
       CajasyPeso += " Peso: " + formato(rsRe.Fields.Item("Man_Peso").Value,2)
    }
	         
    CajasyPeso +=  " Folios: " + formato(rsRe.Fields.Item("Man_Transferencias").Value,0)

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
    
 
<table width="1151" height="147" class="table table-striped table-bordered">
  <tbody>
	<tr>
	  <td width="128" rowspan="6" align="center" valign="middle"><img src="/Img/wms/Logo005.png" title="Lyde" style="width:100px"/></td>
      <td height="28" colspan="3" nowrap="nowrap"><h2>Manifiesto de salida  <%=Folio%></h2> </td>
      <td width="162" align="right" valign="baseline"  ><%=Fecha%> </td>
    </tr>
	<tr>
	  <td width="112" nowrap="nowrap"><FONT size="1">Direcci&oacute;n de origen: </FONT></td>
	  <td height="23" colspan="3"><FONT size="1">Calle: Av. Santa Cecilia , num. Ext: 211, num. Int: Nave 3 Puerta 1, C.P: 54130, Colonia: Santa Cecilia, Tlalnepantla Edo de Mex.</FONT></td>
    </tr>
    <tr>
     <td><FONT size="2">Transportista:</FONT></td>
     <td colspan="3"><FONT size="2"><%=Transportista%></FONT><FONT size="2">&nbsp; </FONT><FONT size="1"></FONT></td>
    </tr>
	<tr>
	  <td><FONT size="2">Operador:</FONT> </td>
	  <td width="242"><FONT size="2"><%=Operador%></FONT></td>
	  <td colspan="2"><FONT size="2">Estado:</FONT><FONT size="2"><%=Estado%></FONT></td>
    </tr>
	<tr>
	  <td><FONT size="2">Placas: </FONT></td>
	  <td><FONT size="2"><%=Placas%></FONT></td> 
	  <td colspan="2"><FONT size="2">Aeropuerto:</FONT><FONT size="2"><%=Aeropuerto%></FONT></td>
    </tr>
    <tr>
      <td><FONT size="2">Veh&iacute;culo: </FONT></td>
      <td><FONT size="2"><%=Descripcion%></FONT></td>
      <td colspan="2" ><FONT size="2"><%=CajasyPeso%></FONT></td>
    </tr>
    </tbody>
</table>

<table width="1148" class="table table-striped table-bordered">
    <thead>
  <th width="20"><FONT size="1">Num</FONT></th>
        <th width="106"><FONT size="1">Gu&iacute:a</FONT></th>
        <th width="142"><FONT size="1">Pedido</FONT></th>
        <th width="43"><FONT size="1">Ruta</FONT></th>
        <th width="82"><FONT size="1">Estado</FONT></th>
        <th width="39"><FONT size="1">No. cajas</FONT></th>
        <th width="46"><FONT size="1">No. Tienda</FONT></th>
        <th width="278"><FONT size="1">Tienda</FONT></th>
        <th width="231"><FONT size="1">Nombre Contacto</FONT></th>
        <th width="117"><FONT size="1">Tel&eacute:fono</FONT></th>
        <tbody>
		<%
	var iCons = 1
	while (!rsRe.EOF){
  	     var TA_ID = rsRe.Fields.Item("TA_ID").Value   
   	     var Guia  = rsRe.Fields.Item("TA_Guia").Value 
		 var Pedido = rsRe.Fields.Item("TA_Folio").Value   
	     var Ruta  = "R"+ rsRe.Fields.Item("Alm_Ruta").Value 
		 var Cajas  = rsRe.Fields.Item("TA_CantidadCaja").Value 
		 var Num_Tienda = rsRe.Fields.Item("Alm_Numero").Value   
	     var Tienda = rsRe.Fields.Item("Alm_Nombre").Value 
		 var Dir_Tienda = rsRe.Fields.Item("Alm_Calle").Value +", No. Ext. " +  rsRe.Fields.Item("Alm_NumExt").Value
		 						   + ", No. Int. " + rsRe.Fields.Item("Alm_NumInt").Value + ", " +  rsRe.Fields.Item("Alm_Colonia").Value + ", " 
								   +rsRe.Fields.Item("Alm_Delegacion").Value + ", " +rsRe.Fields.Item("Alm_Ciudad").Value + ", " 
								   + rsRe.Fields.Item("ESTADO").Value
		  var Estado = rsRe.Fields.Item("ESTADO").Value
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
    
       	  <td>    <FONT size="1"><%=iCons%>   </FONT></td> 
         
          
       	  <td>   <small><FONT size="1" ><%=Guia%>  </FONT></small></td>
          <td > <FONT size="1"><%=Pedido%>  </FONT></td>
       	  <td>   <FONT size="1"><%=Ruta%>  </FONT></td>
          <td>   <FONT size="1"><%=Estado%>  </FONT></td>
          <td>   <FONT size="1"><%=Cajas%>  </FONT></td>
       	  <td>   <FONT size="1"><%=Num_Tienda%>  </FONT></td>
       	  <td>   <FONT size="1"><%=Tienda%>  </FONT></td>
       	  <td>   <FONT size="1"><%=Contacto%>  </FONT></td>
          <td>   <FONT size="1"><%=Tel%>  </FONT></td>
       	
       </tr>
		<tr>
          <td> <FONT size="1">&nbsp;</FONT></td>
       	  <td> <FONT size="1">Direcci&oacute;n</FONT></td>
           
		  <td colspan="8"> <FONT size="1"><%=Dir_Tienda%></FONT></td>
	
       </tr>
  <% if(Observaciones != "") {%>
		<tr>
         <td>&nbsp;</td>
        	<td><FONT size="1">Observaciones</FONT></td>
        	<td colspan="8" ><FONT size="1"><%=Observaciones%></FONT></td>
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


