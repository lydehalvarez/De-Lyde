<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%
	var TA_ID = Parametro("TA_ID",-1)
%>
<table class="table">
    <thead>
    	<th width="143">SKU</th>    	
    	<th width="723">Producto</th>
    	<th width="237">Cantidad Solicitada</th>
    	<th width="213">Cantidad Enviada</th>
    	<th width="199">Selecciona <input type="checkbox" id="CheckAll" onchange="$('.Series').prop('checked',true);"/></th>
    </thead>
    <tbody>
		<%
    var TotalSol = 0
    var TotalEnv = 0

	var sSQLTr  = "SELECT t.TA_ID, TAA_ID, Ta_Folio , Pro_Nombre, TAA_SKU, TAA_Cantidad "
        sSQLTr += " ,(SELECT COUNT(*)  FROM TransferenciaAlmacen_Articulo_Picking p1 "
        sSQLTr += " WHERE p1.TA_ID = t.TA_ID  AND p1.TAA_ID = a.TAA_ID) as  Enviada "
        sSQLTr += " FROM TransferenciaAlmacen t, TransferenciaAlmacen_Articulos a, Producto p "
        sSQLTr += " WHERE t.TA_ID = " + TA_ID
        sSQLTr += " AND t.TA_ID = a.TA_ID "
        sSQLTr += " and a.Pro_ID = P.Pro_ID "
 
    var rsPicked = AbreTabla(sSQLTr,1,0)
	while(!rsPicked.EOF){ 
         var Total_Enviado = rsPicked.Fields.Item("Enviada").Value 
         var TAA_ID = rsPicked.Fields.Item("TAA_ID").Value 
         var TAA_Cantidad = rsPicked.Fields.Item("TAA_Cantidad").Value

         var TotalSol = TotalSol +TAA_Cantidad
         var TotalEnv = TotalEnv + Total_Enviado
        %>		
            <tr>
                <td><%=rsPicked.Fields.Item("TAA_SKU").Value%></td>                
                <td><%=rsPicked.Fields.Item("Pro_Nombre").Value%></td>
                <td><%=TAA_Cantidad%></td>
                <td><%=Total_Enviado%></td>
                <td align="center"><input class="Series" type="checkbox" value="<%=TAA_ID%>"/></td>
            </tr>
        <%	
            rsPicked.MoveNext() 
        }
        rsPicked.Close()   
		%>
            <tr>
                <td>&nbsp;</td>
                <td>Total</td>
                <td><%=TotalSol%></td>
                <td><%=TotalEnv%></td>
                <td class="text-nowrap">
					
				</td>
			</tr>
			<tr>
				<td colspan="5" class="text-nowrap text-right" >
					<a class="btn btn-success" onclick="Exportar()" title="Exportar">
						<i class="fa fa-file-excel-o"></i> Exportar
					</a>
					<a class="btn btn-info btnVerSerie" id="VerSeries" title="Ver Series">
						<i class="fa fa-file-text-o"></i> Ver Series
					</a>
				</td>
			</tr>
    </tbody>
</table>
<br />
<br />
<br />
<br />


<script src="/Template/inspina/js/plugins/sheetJs/xlsx.full.min.js"></script>

<script type="text/javascript">

var verSerie = {}


$(document).ready(function(e) {
	
    $('.btnVerSerie').click(function(e) {
        //CargaSeries()
//		console.log($('#chkSeries').val())
//		console.log($("input[class='Series']:checked").val())
		verSerie["TA_ID"] = <%=TA_ID%>
		var Seleccionados = []
		$("input[class='Series']:checked").each(function(index, element) {
			Seleccionados.push($(this).val())
		});
		verSerie["chkSeries"] = Seleccionados.toString()
        VerSeries = 1
        $("#dvHistoria").removeClass("Caja-Flotando");
		console.log(verSerie)
		CargaSeries(verSerie)
		$('#divHistLineTimeGrid').focus()
		
    });
	
});



function CargaSeries(verSerie){	
	$('#loading').show('slow')
	
	$.post("/pz/wms/TA/TA_VerSeries.asp",verSerie,function(data){
		$('#divSeries').html(data)
		$('#loading').hide('slow')
	});
}    

function Exportar(){

	var intTA_ID = $("#TA_ID").val();
	var arrTAA_IDs = [];
	$(".Series:checked").each(function(){ arrTAA_IDs.push( $(this).val() ) })

	if( arrTAA_IDs.length == 0 ){
		Avisa("warning", "Exportacion", "Seleccionar el producto a exportar");
	} else {

		$.ajax({
			url: "/pz/wms/TA/TA_ajax.asp"
			, method: "post"
			, async: false
			, dataType: "json"
			, data: {
				Tarea: 16
				, TA_ID: intTA_ID
				, TAA_IDs: arrTAA_IDs.join(",")
			}
			, success: function( res ){
				var xlsData = XLSX.utils.json_to_sheet( res );
				var xlsBook = XLSX.utils.book_new(); 

				XLSX.utils.book_append_sheet(xlsBook, xlsData, "SeriesTransferidas");

				XLSX.writeFile(xlsBook, intTA_ID+"Transferencia.xlsx");
			}
		});
	}
}

</script>


