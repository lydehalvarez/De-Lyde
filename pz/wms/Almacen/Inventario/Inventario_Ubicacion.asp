<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../../Includes/iqon.asp" -->

<%
	var SKU = Parametro("SKU","")
    var Pro_ID = Parametro("Pro_ID",-1)
	var Cli_ID = Parametro("Cli_ID",-1)

    var Total = 0
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
    
//	var sSQL = "SELECT pt.Pt_ID "
//			+ ", pt.Pt_LPN "
//			+ ", PT_Cantidad_Actual "
//			+ ", Ubi.Ubi_Nombre "
//			+ ", CONVERT(NVARCHAR(12),Pt_FechaIngreso,103) as FECHAINGRESO "
//			+ ", Lot.Lot_Folio "
//			+ ", Are.Are_Nombre "
//			+ ", ISNULL(Ubi.Ubi_Etiqueta, '') AS Ubi_Etiqueta "
//		+ " FROM Pallet PT "
//			+ " LEFT JOIN Ubicacion Ubi "
//				+ " ON PT.Ubi_ID = Ubi.Ubi_ID "
//			+ " LEFT JOIN Ubicacion_Area Are "
//				+ " ON Ubi.Are_ID = Are.Are_ID "
//			+ " LEFT JOIN Inventario_Lote Lot "
//				+ " ON PT.Lot_ID = Lot.Lot_ID "
//		+ " WHERE pt.Pro_ID = " + Pro_ID  
//		if(Cli_ID > -1){
//			 sSQL += " AND pt.Cli_ID = " + Cli_ID 
//		}
//			sSQL += " AND pt.PT_Cantidad_Actual > 0 " 
//            sSQL += " AND Are.Are_AmbientePallet in (0, 1, 5, 7) "
//            sSQL += " Order by Ubi.Ubi_ID "
            
            
	var sSQL = "SELECT pt.Pt_ID , pt.Pt_LPN , Disp.Piezas as PT_Cantidad_Actual , Ubi.Ubi_Nombre "
            + ", CONVERT(NVARCHAR(12),Pt_FechaIngreso,103) as FECHAINGRESO "
            + ", ISNULL(Lot.Lot_Folio,'') as Lot_Folio , Are.Are_Nombre , ISNULL(Ubi.Ubi_Etiqueta, '') AS Ubi_Etiqueta "
            + " FROM Pallet Pt  "
            + " JOIN ( SELECT Pt_ID, COUNT(*) as Piezas "
            + "		     FROM Inventario i "
            + "		    WHERE i.Pro_ID = " + Pro_ID
            + "		      AND i.Inv_EnAlmacen = 1 "
            + "		      AND i.Inv_EstatusCG20 = 1 "
            + "		    Group By Pt_ID ) AS Disp "
            + " ON Disp.Pt_ID = Pt.Pt_ID "
            + " LEFT JOIN Ubicacion Ubi       ON PT.Ubi_ID = Ubi.Ubi_ID "
            + " LEFT JOIN Ubicacion_Area Are  ON Ubi.Are_ID = Are.Are_ID "
            + " LEFT JOIN Inventario_Lote Lot ON PT.Lot_ID = Lot.Lot_ID "
            
            
    var Pt_ID = -1
    var sEtiqueta = ""
    var strArea = ""
	//Response.Write(sSQL)
	var rsInv = AbreTabla(sSQL,1,0)
       
	if(!rsInv.EOF){
		while(!rsInv.EOF){ 
            Total = Total + rsInv.Fields.Item("PT_Cantidad_Actual").Value
		    Pt_ID = rsInv.Fields.Item("Pt_ID").Value
            sEtiqueta = rsInv.Fields.Item("Ubi_Etiqueta").Value
		    strArea = rsInv.Fields.Item("Are_Nombre").Value
            if(sEtiqueta != "") {
                sEtiqueta = "<br><small>" + sEtiqueta + "</small>"
            }
       
	%>
	<tr id="lpn_<%=Pt_ID%>" >
    	<td ><%=rsInv.Fields.Item("Ubi_Nombre").Value%>
            <br><%= strArea %>  <%=sEtiqueta%>
        </td>
    	<td><%=rsInv.Fields.Item("Pt_LPN").Value%></td>
    	<td align="center"><%=formato(rsInv.Fields.Item("PT_Cantidad_Actual").Value,0)%></td>
    	<td align="center"><%=rsInv.Fields.Item("FECHAINGRESO").Value%></td>
    	<td align="center"><%=rsInv.Fields.Item("Lot_Folio").Value%></td>
    	<td>
			<button class="btn btn-info btnSerie btn-xs" id="btnSerieExp_<%=Pt_ID%>" data-pallet="<%=rsInv.Fields.Item("Pt_LPN").Value%>" value="<%=Pt_ID%>">
				Exportar series
			</button>
            <button class="btn btn-info btnVSerie btn-xs" id="btnSerieVer_<%=Pt_ID%>" data-pallet="<%=rsInv.Fields.Item("Pt_LPN").Value%>" value="<%=Pt_ID%>">
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
<tr>
	  <td>&nbsp;</td>
	  <td>Total</td>
	  <td align="center"><%=formato(Total,0)%></td>
	  <td align="center">&nbsp;</td>
	  <td align="center">&nbsp;</td>
	  <td>			<button class="btn btn-info btnExpSeriesSKU btn-xs" id="btnExpSeriesSKU" value="<%=SKU%>">
				Exportar series disponibles
			</button>
</td>
	  </tr>
    </tbody>
</table>
<script type="application/javascript">
    
    var URL_base = "https://wms.lydeapi.com"
        $('.btnSerie').click(function(e) {
            e.preventDefault();
            var Pt_ID = $(this).val()
            var Pallet = $(this).data('pallet')
            InventarioFunciones.ExportarSeries(Pt_ID,Pallet);
        });
		
	
		$('.btnExpSeriesSKU').click(function(e) {
            e.preventDefault();
			
            var SKU = $(this).val()
			var request = 		
				{
				 Cli_ID:<%=Cli_ID%>,
				 Pro_ID:<%=Pro_ID%>,
				Test:0
				}

			$.ajax({
				  url: URL_base + "/api/Inventario/Reporte/Series"

				, method: "post"
				, contentType:'application/json'
				, async: true
				, dataType: "json"
				, data: JSON.stringify(request)
				, success: function(res){
						if(res.result==1){
								var ws = XLSX.utils.json_to_sheet(res.data);
							var wb = XLSX.utils.book_new(); XLSX.utils.book_append_sheet(wb, ws, "Sheet1");
							XLSX.writeFile(wb, "Series del SKU "+SKU+".xlsx");
							Avisa("success","Archivo descargado","El archivo se ha generado correctamente");

						}else{
							swal({
								title: "Ups!",
								text: res.message, 
								type: "error"
							});
						}		
				}
			});

	    });

         $('.btnVSerie').click(function(e) {
            e.preventDefault();
            $(this).hide('slow')
            var pallet = $(this).data('pallet')
            var PTID = $(this).val()
            //$('#btnC'+SKU).show('slow')
            
            if ( $("#td_" +PTID).length == 0 ) {
                $('<tr id="tr_'+PTID+'"><td colspan="6" id="td_'+PTID+'">'+loading+'</td></tr>').insertAfter($("#lpn_" +PTID));
            }
            var dato = {
                Pt_ID:PTID,
                SKU:<%=SKU%>
				
            }
            $("#td_"+PTID).load("/pz/wms/Almacen/Inventario/Inventario_SeriesLPN.asp"
                               , dato
                               , function(){
                                    $("#tr_"+PTID).show("slow")
            });  
        });
    
        

</script>




