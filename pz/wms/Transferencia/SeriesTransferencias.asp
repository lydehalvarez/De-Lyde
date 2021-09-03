<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%
   
	var TA_ArchivoID = Parametro("TA_ArchivoID",-1)


	var sSQLO = " SELECT "
		sSQLO += " (SELECT TA_Folio FROM [dbo].[TransferenciaAlmacen] WHERE TA_ID = p.TA_ID ) Folio "
		sSQLO += " ,(SELECT Alm_Nombre FROM Almacen WHERE Alm_ID = (SELECT [TA_End_Warehouse_ID] FROM[dbo].[TransferenciaAlmacen] WHERE TA_ID = p.TA_ID)) Tienda "
		sSQLO += " ,(SELECT Pro_Nombre FROM Producto WHERE Pro_ID = p.Pro_ID) Producto "
		sSQLO += " ,(SELECT Pro_ClaveAlterna FROM Producto WHERE Pro_ID = p.Pro_ID) SKU "
		sSQLO += " ,[TAS_Serie] Serie "
		sSQLO += " FROM [dbo].[TransferenciaAlmacen_Articulo_Picking] p "
		sSQLO += " WHERE TA_ID IN  (SELECT TA_ID FROM TransferenciaAlmacen WHERE TA_ArchivoID = "+TA_ArchivoID+") "
		sSQLO += " ORDER BY  TA_ID ASC "

%>
<html>
<link href="/Template/inspina/css/bootstrap.min.css" rel="stylesheet">

<body>
    <table class="table table-striped table-bordered" id="Actividades" >
         <thead>
        <tr> 
            <th>Folio Lyde</th>
            <th>Tienda</th>
            <th>Producto</th>
            <th>SKU</th>
            <th>Serie</th>
         </tr>
        </thead>
        <tbody>
        <%
     var rsSer = AbreTabla(sSQLO,1,0)
         while (!rsSer.EOF){ 
         var Folio =  rsSer.Fields.Item("Folio").Value
         var Tienda =  rsSer.Fields.Item("Tienda").Value
         var Producto =  rsSer.Fields.Item("Producto").Value
         var SKU =  rsSer.Fields.Item("SKU").Value
         var Serie =  rsSer.Fields.Item("Serie").Value
	%><tr>
    	<td><%=Folio%></td>
    	<td><%=Tienda%></td>
    	<td><%=Producto%></td>
    	<td><%=SKU%></td>
    	<td><%=Serie%></td>
	</tr>  
	<%	
    rsSer.MoveNext() 
}
rsSer.Close()   
%>
       

        </tbody>
        
    </table>
</body>
</html>
<script src="/Template/inspina/js/jquery-3.1.1.min.js"></script>
<script src="/Template/inspina/js/plugins/table2excel/jquery.table2excel.min.js"></script>
<script type="application/javascript">
$(document).ready(function(e) {
	 $("#Actividades").table2excel({
		name:  'Transferencia <%=TA_ArchivoID%>',
		filename: 'Transferencia <%=TA_ArchivoID%>.xls', // do include extension
		preserveColors: false // set to true if you want background colors and font colors preserved
	});
});

function exportTableToExcel(tableID, filename){
    var downloadLink;
    var dataType = 'application/vnd.ms-excel';
    var tableSelect = document.getElementById(tableID);
    var tableHTML = tableSelect.outerHTML.replace(/ /g, '%20');
    
    // Specify file name
    filename = filename?filename+'.xls':'excel_data.xls';
    
    // Create download link element
    downloadLink = document.createElement("a");
    
    document.body.appendChild(downloadLink);
    
    if(navigator.msSaveOrOpenBlob){
        var blob = new Blob(['\ufeff', tableHTML], {
            type: dataType
        });
        navigator.msSaveOrOpenBlob( blob, filename);
    }else{
        // Create a link to the file
        downloadLink.href = 'data:' + dataType + ', ' + tableHTML;
    
        // Setting the file name
        downloadLink.download = filename;
        
        //triggering the function
        downloadLink.click();
    }
}
</script>            

