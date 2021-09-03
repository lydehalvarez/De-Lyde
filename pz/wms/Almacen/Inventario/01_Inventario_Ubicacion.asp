<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../../Includes/iqon.asp" -->

<%
	var SKU = Parametro("SKU","")
    var Pro_ID = Parametro("Pro_ID",-1)
	var Cli_ID = Parametro("Cli_ID",-1)

%>

<table class="table table-striped table-bordered">
	<thead>
    	<tr>
        	<th>Ubicaci&oacute;n</th>
        	<th>LPN</th>
        	<th>Cantidad</th>
        	<th>Fecha ingreso</th>
        	<th>Lote folio</th>
        	<th>Series</th>
        </tr>
    </thead>
    <tbody>
    <%
    
	var sSQL = "SELECT pt.Pt_ID "
			+ ", pt.Pt_LPN "
			+ ", PT_Cantidad_Actual "
			+ ", Ubi.Ubi_Nombre "
			+ ", CONVERT(NVARCHAR(12),Pt_FechaIngreso,103) as FECHAINGRESO "
			+ ", Lot.Lot_Folio "
			+ ", Are.Are_Nombre "
			+ ", ISNULL(Ubi.Ubi_Etiqueta, '') AS Ubi_Etiqueta "
		+ " FROM Pallet PT "
			+ " LEFT JOIN Ubicacion Ubi "
				+ " ON PT.Ubi_ID = Ubi.Ubi_ID "
			+ " LEFT JOIN Ubicacion_Area Are "
				+ " ON Ubi.Are_ID = Are.Are_ID "
			+ " LEFT JOIN Inventario_Lote Lot "
				+ " ON PT.Lot_ID = Lot.Lot_ID "
		+ " WHERE pt.Pro_ID = " + Pro_ID  
			+ " AND pt.Cli_ID = " + Cli_ID 
			+ " AND pt.PT_Cantidad_Actual > 0 " 
             + " AND Are.Are_AmbientePallet in (1,5) "
	
	 
	var rsInv = AbreTabla(sSQL,1,0)
       
	if(!rsInv.EOF){
		while(!rsInv.EOF){ 
		var Pt_ID = rsInv.Fields.Item("Pt_ID").Value
        var sEtiqueta = rsInv.Fields.Item("Ubi_Etiqueta").Value
		var strArea = rsInv.Fields.Item("Are_Nombre").Value
        if(sEtiqueta != "") {
            sEtiqueta = "<br><small>" + sEtiqueta + "</small>"
        }
       
	%>
	<tr>
    	<td><%=rsInv.Fields.Item("Ubi_Nombre").Value%>
            <br><%= strArea %>  <%=sEtiqueta%>
        </td>
    	<td><%=rsInv.Fields.Item("Pt_LPN").Value%></td>
    	<td align="center"><%=formato(rsInv.Fields.Item("PT_Cantidad_Actual").Value,0)%></td>
    	<td align="center"><%=rsInv.Fields.Item("FECHAINGRESO").Value%></td>
    	<td align="center"><%=rsInv.Fields.Item("Lot_Folio").Value%></td>
    	<td>
			<button class="btn btn-info btnSerie btn-xs" id="btnSerie_<%=Pt_ID%>" data-pallet="<%=rsInv.Fields.Item("Pt_LPN").Value%>" value="<%=Pt_ID%>">
				Ver series
			</button>
		</td>
    </tr>
	<%
            rsInv.MoveNext()
        } 
    rsInv.Close()
	} else {
	%>
	<tr>
    	<td colspan="3">No tiene ubicaciones registradas</td>
    </tr>
	<%
	}
    %>
    </tbody>
</table>
<script type="application/javascript">
$('.btnSerie').click(function(e) {
	e.preventDefault();
	var Pt_ID = $(this).val()
	var Pallet = $(this).data('pallet')
	InventarioFunciones.Serie(Pt_ID,Pallet);
});

</script>




