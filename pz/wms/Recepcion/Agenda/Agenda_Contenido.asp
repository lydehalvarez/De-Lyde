<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../../Includes/iqon.asp" -->
<%
	var IR_ID = Parametro("IR_ID",-1)
	var CliOC_ID = Parametro("CliOC_ID",-1)
	
	var sSQLO = "  SELECT * "
		sSQLO += " FROM Inventario_Recepcion "
		sSQLO += " WHERE IR_ID =  "+IR_ID

	var IR_Conductor = "N/A"
	var IR_Placas = "N/A"
	var IR_DescripcionVehiculo = "N/A"
	var Cli_ID = -1
	var CliOC_ID = -1
	var IR_FechaEntrega = "N/A"

	var rsData = AbreTabla(sSQLO,1,0)
	if (!rsData.EOF){ 
		IR_FechaEntrega = rsData.Fields.Item("IR_FechaEntrega").Value 
		IR_Conductor = rsData.Fields.Item("IR_Conductor").Value 
		IR_Placas = rsData.Fields.Item("IR_Placas").Value 
		IR_DescripcionVehiculo = rsData.Fields.Item("IR_DescripcionVehiculo").Value 
		Cli_ID = rsData.Fields.Item("Cli_ID").Value 
		CliOC_ID = rsData.Fields.Item("CliOC_ID").Value 
	}
	
	
	if(IR_ID != -1){
%>


<div class="form-horizontal">
         <div class="form-group">
           <label class="control-label col-md-3"><strong>Nombre operador</strong></label>
           <label class="control-label col-md-3"><%=IR_Conductor%></label>
           <label class="control-label col-md-3"><strong>Placas del veh&iacute;culo</strong></label>
           <label class="control-label col-md-3"><%=IR_Placas%></label>
        </div>
         <div class="form-group">
           <label class="control-label col-md-3"><strong>Tipo del veh&iacute;culo</strong></label>
           <label class="control-label col-md-3"><%=IR_DescripcionVehiculo%></label>
           <label class="control-label col-md-3"><strong>Fecha de cita</strong></label>
           <label class="control-label col-md-3"><%=IR_FechaEntrega%></label>
        </div>
    <div class="ibox-content table-responsive" id="divEntrega">
    	<table class="table table-striped">
        	<thead>
            	<tr>
                	<th>SKU</th>
                	<th>Nombre</th>
                	<th>Cliente</th>
                	<th>Cantidad</th>
                </tr>
            </thead>
        	<tbody>
        		<% 
				if(IR_ID > -1){
				var Productos = "SELECT a.* "
					Productos += ",(SELECT Cli_Nombre FROM Cliente WHERE Cli_ID = "+Cli_ID+") as Client "
					Productos += ",(SELECT Pro_Nombre FROM Producto WHERE Pro_ID = a.Pro_ID) as ProNombre "
					Productos += "FROM Cliente_OrdenCompra_Articulos a"
					Productos += " WHERE a.Cli_ID = " + Cli_ID
					Productos += " AND a.CliOC_ID = " + CliOC_ID
					
					//Response.Write(Productos)
				
				var rsRe = AbreTabla(Productos,1,0)
				var total = 0
				if(!rsRe.EOF){
					while (!rsRe.EOF){
						var Cliente = rsRe.Fields.Item("Client").Value 
						var CliOCP_SKU = rsRe.Fields.Item("CliOCP_SKU").Value 
						var ProNombre = rsRe.Fields.Item("ProNombre").Value 
						var CliOCP_Cantidad = rsRe.Fields.Item("CliOCP_Cantidad").Value 
						total = total + CliOCP_Cantidad
				%>
                <tr>
                    <td><%=CliOCP_SKU%></td>
                    <td><%=ProNombre%></td>
                    <td><%=Cliente%></td>
                    <td><%=CliOCP_Cantidad%></td>
                </tr>
                
		<%	
					rsRe.MoveNext()
					Response.Flush()
				}
			 rsRe.Close() 
		%>	 
                <tr>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                    <td><strong>Total</strong></td>
                    <td><strong><%=total%></strong></td>
                </tr>
		<%	  
			 }else{ %>
                <tr>
                    <td align="center" colspan="4"><strong>Sin datos</strong></td>
                </tr>
			<% } 
		 }else{
        %>
                <tr>
                    <td colspan="4">No se han agregado productos</td>
                </tr>
           <%}%>     
        	</tbody>
        </table>
    </div>
</div>
<%
	}else{
%>

A&ntilde;adir nueva cita



<%
	}	
%>
