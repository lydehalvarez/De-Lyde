<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../../Includes/iqon.asp" -->
<%

  var bIQ4Web = false   

  var iCliID = Parametro("Cli_ID",-1)
  var iCliOCID = Parametro("CliOC_ID",-1)
  var iCliEntID = Parametro("CliEnt_ID",-1) 

  if(bIQ4Web){ 
      Response.Write("Grid - Cli_ID: " + iCliID + " | CliOC_ID: " + iCliOCID) 
  }   
   
  var iRegistros = 0
   
  var sSQLOCEP = "SELECT COCP.Cli_ID, COCP.CliOC_ID, COCP.CliEnt_ID, COCP.CliEntP_ID "
      sSQLOCEP += ",COCP.Pro_ID,ISNULL((SELECT P.Pro_Nombre FROM Producto P WHERE P.Pro_ID = COCP.Pro_ID),'') AS NOMPROD "
	    sSQLOCEP += ",COCP.CliEnt_SKU, COCP.CliEnt_ArticulosRecibidos, CliEnt_ArticulosLlegaron, CliEnt_CantidadPallet "
	    sSQLOCEP += "FROM Cliente_OrdenCompra_EntregaProducto COCP "
      sSQLOCEP += "WHERE Cli_ID = " + iCliID
      sSQLOCEP += " AND CliOC_ID = " + iCliOCID
      sSQLOCEP += " AND CliEnt_ID = " + iCliEntID  

  if(bIQ4Web){ 
      Response.Write("sSQLOCEP: " + sSQLOCEP) 
  }    
   
   
%>
<div class="table-responsive">
		<table class="table table-striped table-hover">
			<thead>
        <caption><h4>Productos.</h4></caption>
				<tr>
					<th class="text-center">#</th>
					<th class="text-center">SKU</th>
					<th>Producto</th>
          <th class="text-center">Art&iacute;culos esperados</th> 
					<th class="text-center">Art&iacute;culos recibidos</th>
          <th class="text-center">Pallets</th>
					<!--th>Date</th>
					<th>Action</th-->
				</tr>
			</thead>
			<tbody>
        <%
          var iRegistros = 0
          var rsOCEProd = AbreTabla(sSQLOCEP,1,0)
              while(!rsOCEProd.EOF){
              iRegistros++
        %>
				<tr>
					<td class="text-center"><%=iRegistros%></td>
					<td class="text-center"><%=rsOCEProd.Fields.Item("CliEnt_SKU").Value%></td>
					<td><%=rsOCEProd.Fields.Item("NOMPROD").Value%></td>
					<td class="text-center"><%=rsOCEProd.Fields.Item("CliEnt_ArticulosRecibidos").Value%></td>
          <td class="text-center"><%=rsOCEProd.Fields.Item("CliEnt_ArticulosLlegaron").Value%></td>
          <td class="text-center"><%=rsOCEProd.Fields.Item("CliEnt_CantidadPallet").Value%></td>  
					<!--td></td>
					<td></td-->
				</tr>
        <%
                  rsOCEProd.MoveNext()
              } 
          rsOCEProd.Close()
        //} else {
        %>        
			</tbody>
		</table>
	</div>  

  
  
