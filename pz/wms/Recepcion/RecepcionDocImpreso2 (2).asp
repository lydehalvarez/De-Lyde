<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%

	var Dia = Parametro("Dia",-1)
	var Tipo = Parametro("Tipo",-1)
			
	var sSQLRecep = "SELECT * "
		sSQLRecep += ", CONVERT(VARCHAR(20), IR_FechaEntrega, 103) AS IRFechaEntrega "
		sSQLRecep += ", CONVERT(VARCHAR(20), IR_FechaEntregaTermina, 103) AS IRFechaEntregaTermina "
		sSQLRecep += ", CONVERT(VARCHAR(8), IR_FechaEntrega, 108) AS IRHoraEntrega "
		sSQLRecep += ", CONVERT(VARCHAR(10), IR_FechaEntregaTermina, 108) AS IRHoraEntregaTermina "
		sSQLRecep += "FROM Inventario_Recepcion "
		sSQLRecep += " WHERE CONVERT(VARCHAR(20), IR_FechaEntrega, 103) = '"+Dia+"'"
	
	bHayParametros = false

	ParametroCargaDeSQL(sSQLRecep,0)

	
%>
<style media="print">
@page {
    size: auto;   /* auto is the initial value */
}
.page-break  { display:block; page-break-before:always; }

</style>
<link href="http://wms.lyde.com.mx/Template/inspina/css/style.css" rel="stylesheet">
<link href="http://wms.lyde.com.mx/Template/inspina/css/bootstrap.min.css" rel="stylesheet">
<title>Recepci&oacute;n <%=Parametro("Dia","")%></title>
<%if(Tipo == 2 || Tipo == 1){%>
<table class="table table-striped table-bordered">
    <thead>
        <th colspan="6" style="text-align:center">Seguridad</th>
    </thead>
    <thead>
        <th>Folio</th>
        <th>Operador</th>
        <th>Placas</th>
        <th>Descripci&oacute;n del veh&iacute;culo</th>
        <th>Fecha cita</th>
        <th>Fecha salida</th>
    </thead>
    <tbody>
	<%
            var rsRe = AbreTabla(sSQLRecep,1,0)

            while (!rsRe.EOF){
				var Operador = rsRe.Fields.Item("IR_Conductor").Value
				var Placas = rsRe.Fields.Item("IR_Placas").Value
				var Descripcion = rsRe.Fields.Item("IR_DescripcionVehiculo").Value
                var IR_FechaEntrega = rsRe.Fields.Item("IRFechaEntrega").Value + " " + rsRe.Fields.Item("IRHoraEntrega").Value
                var IR_FechaEntregaTermina = rsRe.Fields.Item("IRFechaEntregaTermina").Value+ " " + rsRe.Fields.Item("IRHoraEntregaTermina").Value
                var IR_Folio = rsRe.Fields.Item("IR_Folio").Value
        %>
        <tr>
        	<td><%=IR_Folio%></td>
        	<td><%=Operador%></td>
        	<td><%=Placas%></td>
        	<td><%=Descripcion%></td>
        	<td><%=IR_FechaEntrega%></td>
        	<td><%=IR_FechaEntregaTermina%></td>
        </tr>

		<%	
        
            rsRe.MoveNext() 
        }
        
        rsRe.Close()   
        %>
    </tbody>
</table>
<%}%>
<%if(Tipo == 3 || Tipo == 1){%>
<div class="page-break"></div>
<table class="table table-striped table-bordered">
    <thead>
        <th colspan="7" style="text-align:center">Recepci&oacute;n</th>
    </thead>
    <thead>
        <th>Folio</th>
        <th>Operador</th>
        <th>Placas</th>
        <th>Veh&iacute;culo</th>
        <th>Puerta</th>
        <th>Fecha cita</th>
    </thead>
    <tbody>
	<%
            var rsRe = AbreTabla(sSQLRecep,1,0)

            while (!rsRe.EOF){
				var Operador = rsRe.Fields.Item("IR_Conductor").Value
				var Placas = rsRe.Fields.Item("IR_Placas").Value
				var Descripcion = rsRe.Fields.Item("IR_DescripcionVehiculo").Value
                var IR_FechaEntrega = rsRe.Fields.Item("IRFechaEntrega").Value + " " + rsRe.Fields.Item("IRHoraEntrega").Value
                var IR_FechaEntregaTermina = rsRe.Fields.Item("IRFechaEntregaTermina").Value+ " " + rsRe.Fields.Item("IRHoraEntregaTermina").Value
                var IR_Folio = rsRe.Fields.Item("IR_Folio").Value
                var IR_Puerta = rsRe.Fields.Item("IR_Puerta").Value
        %>
        <tr>
        	<td><%=IR_Folio%></td>
        	<td><%=Operador%></td>
        	<td><%=Placas%></td>
        	<td><%=Descripcion%></td>
        	<td><%=IR_Puerta%></td>
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
<script src="http://wms.lyde.com.mx/Template/inspina/js/jquery-3.1.1.min.js"></script>
<script type="application/javascript">
$(document).ready(function(e) {
	window.print();    
});
</script>


