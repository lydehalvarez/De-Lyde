<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->

<%
   var Folio = Parametro("Folio","")
   var FechaInicio = Parametro("FechaInicio","")
   var FechaFin = Parametro("FechaFin","")
   var bTienefiltros = false
   var TA_ID = ""   
	
    var sSQL  = " SELECT * , CONVERT(VARCHAR(17), Man_FechaRegistro, 103) AS Fecha"
		sSQL += ",(Cat_Nombre) as TipoDeRuta, CONVERT(VARCHAR(17), Man_FechaConfirmado, 103) AS FechaConfirmado "
		sSQL += ",ISNULL((SELECT Aer_Nombre FROM Cat_Aeropuerto WHERE Aer_ID = a.Aer_ID),'') Aer_Nombre  "
		sSQL += ",ISNULL((SELECT Edo_Nombre FROM Cat_Estado WHERE Edo_ID = a.Edo_ID),'') Edo_Nombre  "
		sSQL += ",ISNULL((SELECT Prov_Nombre FROM Proveedor WHERE Prov_ID = a.Prov_ID),'') Prov_Nombre  "
		sSQL += ",ISNULL((SELECT Prov_Nombre FROM Proveedor WHERE Prov_ID = a.ProvGuia_ID),'') ProvGuia_Nombre  "
//		sSQL += ",(SELECT COUNT(*) FROM TransferenciaAlmacen t WHERE t.Man_ID = a.Man_ID)  as CANTIDAD  "
		sSQL += ", dbo.fn_Usuario_DameNombreUsuario( Man_Usuario ) as Usuario  "
		sSQL += ", Man_CantidadCajas, Man_Peso, Man_Transferencias, Man_OrdenesDeVenta "
        sSQL += " FROM Manifiesto_Salida a, Cat_Catalogo c "
        sSQL += " WHERE Man_Borrador = 0 "
        sSQL += " AND c.Sec_ID = 94 AND c.Cat_ID = Man_TipoDeRutaCG94 "
   

    if(Folio != "") {
        sSQL += " AND Man_Folio like '%" + Folio + "'"
        bTienefiltros = true
    }
    if(FechaFin != "" ) {
        bTienefiltros = true
        FechaFin = CambiaFormatoFecha(FechaFin,"dd/mm/yyyy",FORMATOFECHASERVIDOR)
        FechaInicio = CambiaFormatoFecha(FechaInicio,"dd/mm/yyyy",FORMATOFECHASERVIDOR)
        sSQL += " AND CAST(Man_FechaRegistro as date)  BETWEEN '" + FechaInicio + "' AND '" + FechaFin + "'"
    }
   
    if(!bTienefiltros){
        if (FechaInicio == "" && FechaFin == "") {
            sSQL += " and Man_FechaRegistro >= cast(getdate() as date) " 
        }
    }
   
   
   sSQL += " ORDER BY Man_ID DESC "
 //  Response.Write(sSQL)
 
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
		
		  sSQL = "SELECT * FROM Proveedor_Guia g"
  			+" INNER JOIN Proveedor p ON g.Prov_ID=p.Prov_ID WHERE Man_ID =" + rsManifiesto.Fields.Item("Man_ID").Value
  		 var rsGuia = AbreTabla(sSQL,1,0)

        %>    
      <tr id="Man_<%=Man_ID%>">
         <td valign="top" class="project-title">
              <a href="#"><%=rsManifiesto.Fields.Item("Man_Folio").Value%></a>
            <br/>
            <small><strong>Hecho por: </strong><br/><%=rsManifiesto.Fields.Item("usuario").Value%></small>
            <br/>
            <small><strong>Confirmado por: </strong><br/><%=rsManifiesto.Fields.Item("usuario").Value%></small>

            <br />
            <br />
            <br />
        	<br />
        </td>
        <td valign="top" class="project-title">
          <a href="#"><%=rsManifiesto.Fields.Item("TipoDeRuta").Value%></a>
            </br>
            Transportista: <%=rsManifiesto.Fields.Item("Prov_Nombre").Value%>
            <br/>
          Ruta: R <%=rsManifiesto.Fields.Item("Man_Ruta").Value%> 
        <br />
            <br/>
            <small><strong>Fecha Confirmado:</strong> <%=rsManifiesto.Fields.Item("FechaConfirmado").Value%></small>
            <br/>
            <small><strong>Fecha Registro:</strong> <%=rsManifiesto.Fields.Item("Man_FechaRegistro").Value%></small>
        <br />
        <br />
        </td>
        <td valign="top" class="project-title" id="ManG_<%=Man_ID%>">
            <a href="#">Transportista Guia</a>
            
            <% if(!rsGuia.EOF){
				%>
            <%=rsGuia.Fields.Item("Prov_Nombre").Value%>
            <br />
            Guias:
            <%
			   while (!rsGuia.EOF){
				   %>
                   <%=rsGuia.Fields.Item("ProG_NumeroGuia").Value%>
 				<br />
                 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                   <%
				   rsGuia.MoveNext() 
            }
        rsGuia.Close()    
			 }
			%>
            
        	<br />        
            <a href="#"><%=rsManifiesto.Fields.Item("Edo_Nombre").Value%></a>
            <br/>
         	 Aeropuerto: <%=rsManifiesto.Fields.Item("Aer_Nombre").Value%>
             <br />
             <br />
            <a class="btn btn-white btn-sm" onclick="ManifiestoFunciones.Contenido_Borrador(<%=Man_ID%>);  return false">
            <i class="fa fa-plus"></i> Editar</a>
           <a class="btn btn-white btn-sm"   onclick="ManifiestoFunciones.Contenido_Reporte(<%=Man_ID%>);  return false">
              <i class="fa fa-print"></i>&nbsp;Imprimir</a>
        </td>
        <td valign="top" class="project-title">
            Cajas: <a href="#"><%=rsManifiesto.Fields.Item("Man_CantidadCajas").Value%></a>
            <br/>
<% if(rsManifiesto.Fields.Item("Man_Peso").Value > 0){ %>             
         	Peso: <%=rsManifiesto.Fields.Item("Man_Peso").Value%> Kg
<% } %>    
        <br /><br />
        <br />
           <a class="btn btn-white btnExcel btn-sm"  data-manid="<%=Man_ID%>" data-manfecha= "<%=Fecha%>" data-folio='<%=rsManifiesto.Fields.Item("Man_Folio").Value%>'>
              <i class="fa fa-folder"></i>&nbsp;Reporte xlsx</a>
        </td>    
   <td valign="top" class="project-title" style="width: 200px;" >
          <a href="#">Transferencias: <%=rsManifiesto.Fields.Item("Man_Transferencias").Value%></a><br/>
<% if(rsManifiesto.Fields.Item("Man_OrdenesDeVenta").Value > 0){ %>  
            <a href="#">Ordenes de venta: <%=rsManifiesto.Fields.Item("Man_OrdenesDeVenta").Value%></a>    
<% } %>  
<br />
<br /><br />
          <a class="btn btn-white btn-sm" href="#" onclick="ManifiestoFunciones.Contenido_ValidaCarga(<%=Man_ID%>);  return false">
              <i class="fa fa-plus"></i> Validar</a>
                <a class="btn btn-white btn-sm"  href="#" onclick="ManifiestoFunciones.Guia(<%=Man_ID%>);  return false">
              <i class="fa fa-plus"></i> Guias </a>

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
		$.post("/pz/wms/Salidas/ExcelManifiesto.asp"
               , { Man_ID:Man_ID }
               , function(data){
                    ip.prop('disabled',false);
                    var response = JSON.parse(data)
                    var ws = XLSX.utils.json_to_sheet(response);
                    var wb = XLSX.utils.book_new(); 
                    XLSX.utils.book_append_sheet(wb, ws, "Sheet1");
                    XLSX.writeFile(wb, ip.data("folio") +  " "+Man_Fecha+".xlsx");
                });
	});

        
	//$.ajax({
//                  url: "/pz/wms/Salidas/Modal_Transportista.asp"
//                , method: "post"
//                , async: false
//                , data: {
//             		Man_ID:manid
//               	}
//                , success: function(res){
//                    $("#wrapper").append(res);
//                }
//	 }),
//	 		  $("#mdlTransportista").modal('show');
;

});


        

</script>