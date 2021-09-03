<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%
	var IR_ID = Parametro("IR_ID",-1)
	var Dia = Parametro("Dia",-1)
	var Tipo = Parametro("Tipo",-1)
	var CliOC_ID = Parametro("CliOC_ID",-1)
	var Cli_ID = Parametro("Cli_ID",-1)
	
		
	var sSQLRecep = "SELECT * "
		sSQLRecep += ", CONVERT(VARCHAR(20), IR_FechaEntrega, 103) AS IRFechaEntrega "
		sSQLRecep += ", CONVERT(VARCHAR(20), IR_FechaEntregaTermina, 103) AS IRFechaEntregaTermina "
		sSQLRecep += ", CONVERT(VARCHAR(8), IR_FechaEntrega, 108) AS IRHoraEntrega "
		sSQLRecep += ", CONVERT(VARCHAR(10), IR_FechaEntregaTermina, 108) AS IRHoraEntregaTermina "
		sSQLRecep += "FROM Inventario_Recepcion "
		if(IR_ID > -1){
		    sSQLRecep += " WHERE IR_ID = " +IR_ID
		}
		if(IR_ID == -1){
		    sSQLRecep += " WHERE CONVERT(VARCHAR(20), IR_FechaEntrega, 103) = '"+Dia+"'"
		}
		
%>
<style media="print">
@page {
    size: auto;   /* auto is the initial value */
}
.page-break  { display:block; page-break-before:always; }

</style>
<link href="http://wms.lyde.com.mx/Template/inspina/css/style.css" rel="stylesheet">
<link href="http://wms.lyde.com.mx/Template/inspina/css/bootstrap.min.css" rel="stylesheet">
<%if(Tipo == 2 || Tipo == 1){%>
<div class="page-break"></div>
<img src="/Img/wms/Logo005.png" title="Lyde" style="width:100;height:100"/>    <center> <H1>   Recepciones de <%=Dia%></H1> </center>

<table class="table table-striped table-bordered">
    <thead>
        <th colspan="6" style="text-align:center">Seguridad</th>
    </thead>
    <thead>
        <th>Folio</th>
        <th>Operador</th>
        <th>Placas</th>
        <th>Descripci&oacute;n del veh&iacute;culo</th>
        <th>Hora cita</th>
  
    </thead>
    <tbody>
	<%
            var rsRe = AbreTabla(sSQLRecep,1,0)

            while (!rsRe.EOF){
				var Operador = rsRe.Fields.Item("IR_Conductor").Value
				var Placas = rsRe.Fields.Item("IR_Placas").Value
				var Descripcion = rsRe.Fields.Item("IR_DescripcionVehiculo").Value
                var IR_FechaEntrega = rsRe.Fields.Item("IRHoraEntrega").Value
               // var IR_FechaEntregaTermina = rsRe.Fields.Item("IRFechaEntregaTermina").Value+ " " + rsRe.Fields.Item("IRHoraEntregaTermina").Value
                var IR_Folio = rsRe.Fields.Item("IR_Folio").Value
                var IR_EsPorASN = rsRe.Fields.Item("IR_EsPorASN").Value
                
                if(Placas == "0"){
                    Placas = ""
                }
        %>
        <tr>
        	<td><%=IR_Folio%></td>
        	<td><%=Operador%></td>
        	<td><%=Placas%></td>
        	<td><%=Descripcion%></td>
        	<td><%=IR_FechaEntrega%></td>
        </tr>

		<%	
        
            rsRe.MoveNext() 
        }
        
        rsRe.Close()   
        %>
    </tbody>
</table>
<%}%>
<%
			if(IR_ID > -1){
				if(Tipo == 3 || Tipo == 1){%>
<%
   var sCondicion = "IR_ID = " + IR_ID
    var CliEnt_ID = BuscaSoloUnDato("CliEnt_ID","Cliente_OrdenCompra_Entrega",sCondicion,-1,0) 

    if(CliOC_ID == -1){   
        var sSQLop = "select op.CliOC_ID "
                   + " from Cliente_OrdenCompra_Entrega e, Cliente_OrdenCompra op "
                   + " where IR_ID = " + IR_ID
                   + " and e.Cli_ID = op.Cli_ID " 
                   + " and e.CliOC_ID = op.CliOC_ID "
        
        var rsSQLop = AbreTabla(sSQLop,1,0)
        if(!rsSQLop.EOF){
           CliOC_ID =  rsSQLop.Fields.Item("CliOC_ID").Value
        }

    }

	if(CliOC_ID > -1){
//   	var sSQL1  = "select Inventario_Recepcion.*, c.Cli_Nombre,  Producto.Pro_Nombre, Producto.Pro_SKU, Cliente_OrdenCompra_EntregaProducto.CliEnt_ArticulosRecibidos as CliOCP_Cantidad FROM   Producto INNER JOIN Cliente_OrdenCompra_EntregaProducto ON Producto.Pro_ID = Cliente_OrdenCompra_EntregaProducto.Pro_ID INNER JOIN Cliente_OrdenCompra 
//ON Cliente_OrdenCompra_EntregaProducto.Cli_ID = Cliente_OrdenCompra.Cli_ID 
//
//if(IR_EsPorASN == 0) {
//    AND Cliente_OrdenCompra_EntregaProducto.CliOC_ID = Cliente_OrdenCompra.CliOC_ID 
//}
//INNER JOIN Cliente_OrdenCompra_Entrega ON Cliente_OrdenCompra_EntregaProducto.CliOC_ID = Cliente_OrdenCompra_Entrega.CliOC_ID 
//INNER JOIN Inventario_Recepcion ON Cliente_OrdenCompra_Entrega.CliOC_ID = Inventario_Recepcion.CliOC_ID AND Cliente_OrdenCompra_Entrega.IR_ID = Inventario_Recepcion.IR_ID inner join cliente c on Inventario_Recepcion.Cli_ID=c.Cli_ID where  Cliente_OrdenCompra_EntregaProducto.CliEnt_ID = "+CliEnt_ID+" AND Inventario_Recepcion.CliOC_ID = " + CliOC_ID +  " and Inventario_Recepcion.Cli_ID = "+Cli_ID+" and Inventario_Recepcion.IR_ID = " + IR_ID
//        
        
  	    var sSQL1  = "SELECT "
                   + "  Inventario_Recepcion.IR_ID, IR_FechaEntrega, IR_FechaEntregaTermina, IR_FechaElaboracion, IR_AlmacenRecepcion "
                   + ", IR_ZonaRecepcionCG88, IR_Folio, IR_FolioCliente, Alm_ID, AlmP_ID, IR_FechaRecepcion, IR_UsuarioAsignaPuerta, IR_Puerta "
                   + ", IR_Conductor, IR_Placas, IR_DescripcionVehiculo, IR_Color,  IR_FechaRegistro, c.Cli_Nombre, Producto.Pro_Nombre "
                   + ", Producto.Pro_SKU, SUM(Cliente_OrdenCompra_EntregaProducto.CliEnt_ArticulosRecibidos) AS CliEnt_ArticulosRecibidos  "
                   +  " FROM Producto "
                   + " INNER JOIN Cliente_OrdenCompra_EntregaProducto "
                   +         " ON Producto.Pro_ID = Cliente_OrdenCompra_EntregaProducto.Pro_ID "
                   + " INNER JOIN Cliente_OrdenCompra "
                   +         " ON Cliente_OrdenCompra_EntregaProducto.Cli_ID = Cliente_OrdenCompra.Cli_ID "
                   +        " AND Cliente_OrdenCompra_EntregaProducto.CliOC_ID = Cliente_OrdenCompra.CliOC_ID "
                   + " INNER JOIN Cliente_OrdenCompra_Entrega "
                   +         " ON Cliente_OrdenCompra_EntregaProducto.Cli_ID = Cliente_OrdenCompra_Entrega.Cli_ID "
                   +         " AND Cliente_OrdenCompra_EntregaProducto.CliOC_ID = Cliente_OrdenCompra_Entrega.CliOC_ID "
                   +         " AND Cliente_OrdenCompra_EntregaProducto.CliEnt_ID = Cliente_OrdenCompra_Entrega.CliEnt_ID "
                   + " INNER JOIN Inventario_Recepcion "
                   +         " ON Cliente_OrdenCompra_Entrega.IR_ID = Inventario_Recepcion.IR_ID "
        if(IR_EsPorASN = 0){
             sSQL1 +=       " AND Cliente_OrdenCompra_Entrega.CliOC_ID = Inventario_Recepcion.CliOC_ID "  
        }
             sSQL1 += "INNER JOIN Cliente c "
                   +         " ON Inventario_Recepcion.Cli_ID = c.Cli_ID "
                   + " WHERE Inventario_Recepcion.IR_ID = " + IR_ID 
                   +   " AND Inventario_Recepcion.Cli_ID = " + Cli_ID  
        if(IR_EsPorASN = 0){
             sSQL1 +=  " AND Inventario_Recepcion.CliOC_ID = " + CliOC_ID 
                   +  " AND Cliente_OrdenCompra_EntregaProducto.CliEnt_ID = " + CliEnt_ID
        }
             sSQL1 += " GROUP BY "
                   +            "  Producto.Pro_SKU, Inventario_Recepcion.IR_ID, IR_FechaEntrega, IR_FechaEntregaTermina "
                   +            ", IR_FechaElaboracion, IR_AlmacenRecepcion, IR_ZonaRecepcionCG88, IR_Folio, IR_FolioCliente "
                   +            ", Alm_ID, AlmP_ID, IR_FechaRecepcion, IR_UsuarioAsignaPuerta, IR_Puerta, IR_Conductor, IR_Placas "
                   +            ", IR_DescripcionVehiculo, IR_Color,  IR_FechaRegistro, c.Cli_Nombre, Producto.Pro_Nombre, Producto.Pro_SKU "
////   	    var sSQL1  = "SELECT "
////                   + "  Inventario_Recepcion.IR_ID, IR_FechaEntrega, IR_FechaEntregaTermina, IR_FechaElaboracion, IR_AlmacenRecepcion "
////                   + ", IR_ZonaRecepcionCG88, IR_Folio, IR_FolioCliente, Alm_ID, AlmP_ID, IR_FechaRecepcion, IR_UsuarioAsignaPuerta, IR_Puerta "
////                   + ", IR_Conductor, IR_Placas, IR_DescripcionVehiculo, IR_Color,  IR_FechaRegistro, c.Cli_Nombre, Producto.Pro_Nombre "
////                   + ", Producto.Pro_SKU, SUM(Cliente_OrdenCompra_EntregaProducto.CliEnt_ArticulosRecibidos) AS CliEnt_ArticulosRecibidos  "
////                   +  " FROM Producto "
////                   + " INNER JOIN Cliente_OrdenCompra_EntregaProducto "
////                   +         " ON Producto.Pro_ID = Cliente_OrdenCompra_EntregaProducto.Pro_ID "
////                   + " INNER JOIN Cliente_OrdenCompra "
////                   +         " ON Cliente_OrdenCompra_EntregaProducto.Cli_ID = Cliente_OrdenCompra.Cli_ID "
////                   +        " AND Cliente_OrdenCompra_EntregaProducto.CliOC_ID = Cliente_OrdenCompra.CliOC_ID "
////                   + " INNER JOIN Cliente_OrdenCompra_Entrega "
////                   +         " ON Cliente_OrdenCompra_EntregaProducto.Cli_ID = Cliente_OrdenCompra_Entrega.Cli_ID "
////                   +         " AND Cliente_OrdenCompra_EntregaProducto.CliOC_ID = Cliente_OrdenCompra_Entrega.CliOC_ID "
////                   +         " AND Cliente_OrdenCompra_EntregaProducto.CliEnt_ID = Cliente_OrdenCompra_Entrega.CliEnt_ID "
////                   + " INNER JOIN Inventario_Recepcion "
////                   +         " ON Cliente_OrdenCompra_Entrega.IR_ID = Inventario_Recepcion.IR_ID "
////        if(IR_EsPorASN = 0){
////             sSQL1 +=       " AND Cliente_OrdenCompra_Entrega.CliOC_ID = Inventario_Recepcion.CliOC_ID "  
////        }
////             sSQL1 += "INNER JOIN Cliente c "
////                   +         " ON Inventario_Recepcion.Cli_ID = c.Cli_ID "
////                   + " WHERE Inventario_Recepcion.IR_ID = " + IR_ID 
////                   +   " AND Inventario_Recepcion.Cli_ID = " + Cli_ID  
////        if(IR_EsPorASN = 0){
////             sSQL1 +=  " AND Inventario_Recepcion.CliOC_ID = " + CliOC_ID 
////                   +  " AND Cliente_OrdenCompra_EntregaProducto.CliEnt_ID = " + CliEnt_ID
////        }
////             sSQL1 += " GROUP BY "
////                   +            "  Producto.Pro_SKU, Inventario_Recepcion.IR_ID, IR_FechaEntrega, IR_FechaEntregaTermina "
////                   +            ", IR_FechaElaboracion, IR_AlmacenRecepcion, IR_ZonaRecepcionCG88, IR_Folio, IR_FolioCliente "
////                   +            ", Alm_ID, AlmP_ID, IR_FechaRecepcion, IR_UsuarioAsignaPuerta, IR_Puerta, IR_Conductor, IR_Placas "
////                   +            ", IR_DescripcionVehiculo, IR_Color,  IR_FechaRegistro, c.Cli_Nombre, Producto.Pro_Nombre, Producto.Pro_SKU "

 
    
 		//Response.Write(sSQL1)        
		 var rsProd = AbreTabla(sSQL1,1,0) 
		  
		}

   	
            var rsRe = AbreTabla(sSQLRecep,1,0)

        
				var Operador = rsRe.Fields.Item("IR_Conductor").Value
				var Placas = rsRe.Fields.Item("IR_Placas").Value
				var Descripcion = rsRe.Fields.Item("IR_DescripcionVehiculo").Value
                var IR_FechaEntrega = rsRe.Fields.Item("IRFechaEntrega").Value + " " + rsRe.Fields.Item("IRHoraEntrega").Value
                var IR_FechaEntregaTermina = rsRe.Fields.Item("IRFechaEntregaTermina").Value+ " " + rsRe.Fields.Item("IRHoraEntregaTermina").Value
                var IR_Folio = rsRe.Fields.Item("IR_Folio").Value
                var IR_Puerta = rsRe.Fields.Item("IR_Puerta").Value
                if(Placas == "0"){
                    Placas = ""
                }
        %>
<div class="page-break"></div>
<img src="/Img/wms/Logo005.png" title="Lyde" style="width:100;height:100"/>    <center> <H1>   Recepci&oacute;n <%=IR_Folio%></H1> </center>

<table class="table table-striped table-bordered">
<tbody>
	<tr>
<td>Operador: </td>
<td><%=Operador%></td>
  </tr>
  	<tr>
<td>Placas: </td>
<td><%=Placas%></td>
  </tr>
  	<tr>
<td>Vehiculo: </td>
<td><%=Descripcion%></td>
  </tr>
    	<tr>
<td>Fecha Entrega: </td>
<td><%=IR_FechaEntrega%></td>
  </tr>
               </tbody>
</table>

<table class="table table-striped table-bordered">
    <thead>
        <th>Modelo</th>
        <th>SKU</th>
        <th>Cantidad</th>
   

    </thead>
    <tbody>
		<%
		    while (!rsProd.EOF){
	     Pro_SKU = rsProd.Fields.Item("Pro_SKU").Value 
		 Pro_Nombre = rsProd.Fields.Item("Pro_Nombre").Value   
	     Cantidad = rsProd.Fields.Item("CliEnt_ArticulosRecibidos").Value 
        %>
		<tr>
        	<td><%=Pro_Nombre%></td>
        	<td><%=Pro_SKU%></td>
        	<td><%=Cantidad%></td>
       </tr>

		<%	
        
            rsProd.MoveNext() 
        }
        
        rsProd.Close()   
        %>
    </tbody>
</table>
<%}
			}
%>
<script src="http://wms.lyde.com.mx/Template/inspina/js/jquery-3.1.1.min.js"></script>
<script type="application/javascript">
$(document).ready(function(e) {
	window.print();    
});
</script>


