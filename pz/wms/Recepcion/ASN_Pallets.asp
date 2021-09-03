<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->

<%
	var IR_ID = Parametro("IR_ID",-1) 
    var ASN_ID = Parametro("ASN_ID",-1) 
    var Pro_ID = Parametro("Pro_ID",-1)

    var Total = 0
	var  TotalRecibido = 0
%>

<table class="table table-striped table-bordered">
	<thead align="center">
    	<tr>
        	<th align="center">LPN</th>
           	<th align="center">SKU / Ubicacion</th>
           	<th align="center">Modelo</th>
           	<th align="center">Cantidad</th>
        	<th align="center">Cantidad recibida</th>
        	<th align="center">Fecha ingreso</th>
        </tr>
    </thead>
    <tbody>
    <%
    
	var sSQL = "SELECT pt.Pt_ID , pt.Pt_LPN "
			+ ", Pt_Cantidad, PT_CantidadEsperada, Pt_SKU, Pro_Nombre, Ubi_Nombre"
			+ ", CONVERT(NVARCHAR(12),Pt_FechaRegistro,103) as FECHAINGRESO "
			+ " FROM Recepcion_Pallet PT "
			+ " INNER JOIN Producto  p ON PT.Pro_ID=p.Pro_ID"
			+ " LEFT JOIN Ubicacion u ON PT.Ubi_ID=u.Ubi_ID"
			+ " WHERE pt.Pt_ID >-1"
		if(Pro_ID > -1){
			 sSQL += " AND pt.Pro_ID = " + Pro_ID  
		}
		if(IR_ID > -1){
			 sSQL += " AND pt.IR_ID = " + IR_ID 
		}
		if(ASN_ID > -1){
			 sSQL += " AND pt.ASN_ID = " + ASN_ID 
		}
            
    var Pt_ID = -1
    var sEtiqueta = ""
    var strArea = ""
	
	//Response.Write(sSQL)
	var rsInv = AbreTabla(sSQL,1,0)
       
	if(!rsInv.EOF){
		while(!rsInv.EOF){ 
         TotalRecibido = TotalRecibido + rsInv.Fields.Item("PT_Cantidad").Value
           Total = Total + rsInv.Fields.Item("PT_CantidadEsperada").Value
		    Pt_ID = rsInv.Fields.Item("Pt_ID").Value
		    SKU = rsInv.Fields.Item("Pt_SKU").Value
        
	%>
	<tr id="lpn_<%=Pt_ID%>" >
    	<td><%=rsInv.Fields.Item("Pt_LPN").Value%></td>
    	<td><%=rsInv.Fields.Item("Pt_SKU").Value%>
        <%
		if(rsInv.Fields.Item("Ubi_Nombre").Value != 'NULL'){
			%>
            <br />
			<%=rsInv.Fields.Item("Ubi_Nombre").Value%>
		<%
        }else{
		%>
        	Sin asignar
        <%	
		}
		%>
        </td>
    	<td align="center"><%=rsInv.Fields.Item("Pro_Nombre").Value%></td>
    	<td align="center"><%=formato(rsInv.Fields.Item("PT_CantidadEsperada").Value,0)%></td>
    	<td align="center"><%=formato(rsInv.Fields.Item("PT_Cantidad").Value,0)%></td>
    	<td align="center"><%=rsInv.Fields.Item("FECHAINGRESO").Value%></td>
<!--    	<td>
			<button class="btn btn-info btnSerie btn-xs" id="btnSerieExp_<%=Pt_ID%>" data-pallet="<%=rsInv.Fields.Item("Pt_LPN").Value%>" value="<%=Pt_ID%>">
				Exportar series
			</button>
            <button class="btn btn-info btnVSerie btn-xs" id="btnSerieVer_<%=Pt_ID%>" data-pallet="<%=rsInv.Fields.Item("Pt_LPN").Value%>" value="<%=Pt_ID%>">
				Ver series
			</button>
		</td>
-->    </tr>
	
	<%
            rsInv.MoveNext()
        } 
    rsInv.Close()
	} else {
	%>
	<tr>
    	<td colspan="3">No tiene pallets registrados</td>
    </tr>
	<%
	}
    %>
<tr>
	  <td>&nbsp;</td>
	  <td align="center">&nbsp;</td>
      	  <td>Total</td>
	  <td align="center"><%=Total%></td>
	  <td align="center"><%=TotalRecibido%></td>
	  <td align="center">&nbsp;</td>

	  </tr>
    </tbody>
</table>
<script type="application/javascript">
    
    
        $('.btnSerie').click(function(e) {
            e.preventDefault();
            var Pt_ID = $(this).val()
            var Pallet = $(this).data('pallet')
            InventarioFunciones.ExportarSeries(Pt_ID,Pallet);
        });
		
	
		$('.btnExpSeriesSKU').click(function(e) {
            e.preventDefault();
            var SKU = $(this).val()
		$.post("/pz/wms/Almacen/Inventario/Inventario_SeriesSKU.asp",
			{Cli_ID:6,SKU:SKU}
			,function(data){
				var response = JSON.parse(data); 
				var ws = XLSX.utils.json_to_sheet(response);
				var wb = XLSX.utils.book_new(); XLSX.utils.book_append_sheet(wb, ws, "Sheet1");
				XLSX.writeFile(wb, "Series del SKU "+SKU+".xlsx");
				Avisa("success","Archivo descargado","El archivo se ha generado correctamente");
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
               // SKU:
            }
            $("#td_"+PTID).load("/pz/wms/Almacen/Inventario/Inventario_SeriesLPN.asp"
                               , dato
                               , function(){
                                    $("#tr_"+PTID).show("slow")
            });  
        });
    
        

</script>




