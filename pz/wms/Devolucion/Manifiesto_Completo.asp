<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->

<%
    var sSQL  = " SELECT * , CONVERT(VARCHAR(17), ManD_FechaRegistro, 103) AS Fecha"
		sSQL += ",[dbo].[fn_CatGral_DameDato](94,ManD_TipoDeRutaCG94) Cat_Nombre "
		sSQL += ",ISNULL((SELECT Aer_Nombre FROM Cat_Aeropuerto WHERE Aer_ID = a.Aer_ID),'') Aer_Nombre  "
		sSQL += ",ISNULL((SELECT Edo_Nombre FROM Cat_Estado WHERE Edo_ID = a.Edo_ID),'') Edo_Nombre  "
		sSQL += ",ISNULL((SELECT Prov_Nombre FROM Proveedor WHERE Prov_ID = a.Prov_ID),'') Prov_Nombre  "
		sSQL += ",(SELECT COUNT(*) FROM TransferenciaAlmacen t WHERE t.ManD_ID = a.ManD_ID)  as CANTIDAD  "
        sSQL += " FROM Manifiesto_Devolucion a "
        sSQL += " WHERE ManD_Borrador = 0 ORDER BY ManD_ID DESC "

	var rsManifiesto = AbreTabla(sSQL,1,0)
	var TA_ID = ""
%>



<div class="ibox-title">
    <h5>Manifiestos</h5>
</div>    
<div class="project-list">
  <table class="table table-hover">
    <tbody>
        <%
        while (!rsManifiesto.EOF){
		var Fecha = ""
		var ManD_ID = rsManifiesto.Fields.Item("ManD_ID").Value
		Fecha = rsManifiesto.Fields.Item("Fecha").Value
		
        %>    
      <tr>
         <td class="project-title">
              <a href="#"><%=rsManifiesto.Fields.Item("ManD_Folio").Value%></a>
            <br/>
            <small>Fecha Registro: <%=rsManifiesto.Fields.Item("ManD_FechaRegistro").Value%></small>
        </td>
        <td class="project-title">
            <a href="#"><%=rsManifiesto.Fields.Item("Cat_Nombre").Value%></a>
            <br/>
          Ruta: R <%=rsManifiesto.Fields.Item("ManD_Ruta").Value%> 
        </td>
        <td class="project-title">
            <a href="#"><%=rsManifiesto.Fields.Item("Prov_Nombre").Value%></a>
        </td>
        <td class="project-title">
            <a href="#"><%=rsManifiesto.Fields.Item("Edo_Nombre").Value%></a>
            <br/>
         	 Aeropuerto: <%=rsManifiesto.Fields.Item("Aer_Nombre").Value%>
        </td>
   <td class="project-title">
            <a href="#">Transferencias: <%=rsManifiesto.Fields.Item("CANTIDAD").Value%></a>
        </td>
        <td class="project-actions" width="31">
          <a class="btn btn-white btn-sm" href="#" onclick="ManifiestoFunciones.Contenido_Reporte(<%=ManD_ID%>);  return false"><i class="fa fa-folder"></i> Reporte</a>
          <a class="btn btn-white btnExcel" href="#" data-manid="<%=ManD_ID%>" data-manfecha= "<%=Fecha%>"><i class="fa fa-folder"></i> Reporte xlsx</a>

        </td>
      </tr>
        <%
            rsManifiesto.MoveNext() 
            }
        rsManifiesto.Close()   
        %>       
    </tbody>
  </table>
</div>    
<script src="/Template/inspina/js/plugins/sheetJs/xlsx.full.min.js"></script>

<script type="text/javascript">
	$(document).ready(function(){
	  
	$('.btnExcel').click(function(e) { 
	var ManD_ID = $(this).data('manid')
	var ManD_Fecha = $(this).data('manfecha')
	$.post("/pz/wms/Devolucion/ExcelManifiesto.asp",{ManD_ID:ManD_ID}
    , function(data){
		var response = JSON.parse(data)
		var ws = XLSX.utils.json_to_sheet(response);
		var wb = XLSX.utils.book_new(); XLSX.utils.book_append_sheet(wb, ws, "Sheet1");
		XLSX.writeFile(wb, "Manifiesto "+ManD_Fecha+".xlsx");
	});
});

	});



</script>