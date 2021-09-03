<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->

<%
   var Folio = Parametro("Folio","")
   var FechaInicio = Parametro("FechaInicio","")
	var FechaFin = Parametro("FechaFin","")
	
    var sSQL  = " SELECT * , CONVERT(VARCHAR(17), Man_FechaRegistro, 103) AS Fecha"
		sSQL += ",[dbo].[fn_CatGral_DameDato](94,Man_TipoDeRutaCG94) Cat_Nombre "
		sSQL += ",ISNULL((SELECT Aer_Nombre FROM Cat_Aeropuerto WHERE Aer_ID = a.Aer_ID),'') Aer_Nombre  "
		sSQL += ",ISNULL((SELECT Edo_Nombre FROM Cat_Estado WHERE Edo_ID = a.Edo_ID),'') Edo_Nombre  "
		sSQL += ",ISNULL((SELECT Prov_Nombre FROM Proveedor WHERE Prov_ID = a.Prov_ID),'') Prov_Nombre  "
		sSQL += ",(SELECT COUNT(*) FROM TransferenciaAlmacen t WHERE t.Man_ID = a.Man_ID)  as CANTIDAD  "
        sSQL += " FROM Manifiesto_Salida a "
        sSQL += " WHERE Man_Borrador = 0"

	var TA_ID = ""
		if(Folio != "") {
	     sSQL += " AND Man_Folio = '" + Folio + "'"
		}
	   if(FechaFin != "" ) {
                FechaFin = CambiaFormatoFecha(FechaFin,"dd/mm/yyyy",FORMATOFECHASERVIDOR)
                sSQL += " AND CAST(Man_FechaRegistro as date)  BETWEEN '" + FechaInicio + "' AND '" + FechaFin + "'"
            }
			sSQL += " ORDER BY Man_ID DESC "
				var rsManifiesto = AbreTabla(sSQL,1,0)

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
		var Man_ID = rsManifiesto.Fields.Item("Man_ID").Value
		Fecha = rsManifiesto.Fields.Item("Fecha").Value
		
        %>    
      <tr>
         <td class="project-title">
              <a href="#"><%=rsManifiesto.Fields.Item("Man_Folio").Value%></a>
            <br/>
            <small>Fecha Registro: <%=rsManifiesto.Fields.Item("Man_FechaRegistro").Value%></small>
        </td>
        <td class="project-title">
            <a href="#"><%=rsManifiesto.Fields.Item("Cat_Nombre").Value%></a>
            <br/>
          Ruta: R <%=rsManifiesto.Fields.Item("Man_Ruta").Value%> 
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
          <a class="btn btn-white btn-sm" onclick="ManifiestoFunciones.Contenido_Reporte(<%=Man_ID%>);  return false"><i class="fa fa-print"></i>&nbsp;Imprimir</a>
          <a class="btn btn-white btnExcel"  data-manid="<%=Man_ID%>" data-manfecha= "<%=Fecha%>"><i class="fa fa-folder"></i>&nbsp;Reporte xlsx</a>
               <a class="btn btn-white btn-sm" href="#" onclick="ManifiestoFunciones.Contenido_ValidaCarga(<%=Man_ID%>);  return false">
            <i class="fa fa-plus"></i> Validar carga</a>

<!--          <a class="btn btn-white btn-sm" href="#" onclick="ManifiestoFunciones.Contenido_Borrador(<%=Man_ID%>);  return false"> <i class="fa fa-plus"></i> Modificar</a>
-->
<!--          <a class="btn btn-white btn-sm" href="#" onclick="ManifiestoFunciones.Contenido_Terminado(<%=Man_ID%>);  return false"><i class="fa fa-folder"></i> Ver</a>
-->
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
		var ip = $(this)
		ip.prop('disabled',true);
		var Man_ID = $(this).data('manid')
		var Man_Fecha = $(this).data('manfecha')
		$.post("/pz/wms/Salidas/ExcelManifiesto.asp",{Man_ID:Man_ID}
		, function(data){
			ip.prop('disabled',false);
			var response = JSON.parse(data)
			var ws = XLSX.utils.json_to_sheet(response);
			var wb = XLSX.utils.book_new(); 
			XLSX.utils.book_append_sheet(wb, ws, "Sheet1");
			XLSX.writeFile(wb, "Manifiesto "+Man_Fecha+".xlsx");
		});
	});

});



</script>