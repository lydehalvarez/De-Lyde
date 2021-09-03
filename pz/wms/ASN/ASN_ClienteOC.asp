<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
 
    var ASN_ID = Parametro("ASN_ID",-1) 

    var bHayParams = false  

	var sSQL  = " SELECT o.CliOC_Folio, o.Cli_ID,o.CliOC_ID,o.CliOC_FechaRegistro,o.CliOC_NumeroOrdenCompra,o.CliOC_FechaElaboracion, CliOC_EstaCompleta, "
					+ " CliOC_TotalArticulos, CliOC_ArticulosRecibidos, a.Alm_Estado, a.Alm_Ciudad, c.Cli_Nombre, Cat_Nombre AS Estatus "
         			+ " FROM Cliente_OrdenCompra o INNER JOIN cliente c "
					+ " ON o.Cli_ID=c.Cli_ID LEFT OUTER JOIN Almacen a ON o.CliOC_EnviarAlmacen=a.Alm_ID "
					+ " INNER JOIN Cliente_OrdenCompra_Articulos at ON  o.CliOC_ID = at.CliOC_ID "
					+ " LEFT OUTER JOIN Cliente_OrdenCompra_Entrega e ON o.CliOC_ID=e.CliOC_ID "
					+ " INNER JOIN Cliente_OrdenCompra_EntregaProducto ep ON  o.CliOC_ID = ep.CliOC_ID "
					+ " INNER JOIN Inventario_Recepcion i ON i.IR_ID=e.IR_ID "
					+ " INNER JOIN Cat_Catalogo ct ON ct.Cat_ID=o.CliOC_EstatusCG52 AND ct.Sec_ID = 52"
					+ " LEFT OUTER JOIN ASN s ON ep.ASN_ID=s.ASN_ID WHERE "
					+"   e.ASN_ID = "+ ASN_ID
					+	" GROUP BY o.CliOC_Folio, o.Cli_ID,o.CliOC_ID,o.CliOC_FechaRegistro,o.CliOC_NumeroOrdenCompra,o.CliOC_FechaElaboracion, a.Alm_Estado, a.Alm_Ciudad, 				c.Cli_Nombre, Cat_Nombre, CliOC_EstaCompleta, CliOC_TotalArticulos, CliOC_ArticulosRecibidos ORDER BY o.CliOC_ID desc"
    

    //1	En proceso     | Warning
    //2	Terminada      | Default
    //3	Revisión       | Primary
    //4	Presentada     | Default
    //5	En seguimiento | Info
    //6	Aceptada       | Success
    //7	Rechazada      | Danger
    //8	Cambio         | Info  
    //Response.Write(sSQL)
%>
<div class="ibox-title">
    <h5>Ordenes de Compra</h5>
</div>    
<div class="project-list">
  <table class="table table-hover">
    <tbody>
        <%
	
        var rsCliOC = AbreTabla(sSQL,1,0)
        while (!rsCliOC.EOF){
		var Llaves = rsCliOC.Fields.Item("Cli_ID").Value
		 Llaves += ", " + rsCliOC.Fields.Item("CliOC_ID").Value
	
        %>    
      <tr>
         <td class="project-title">
            <a href="#" onclick="javascript:CargaCliente(<%=Llaves%>);  return false"><%=rsCliOC.Fields.Item("Cli_Nombre").Value%></a>
            <br/>
            <small></small>
        </td>
        <td class="project-title">
            <a href="#"><%=rsCliOC.Fields.Item("CliOC_Folio").Value%></a>
            <br/>
            <small>Registro: <%=rsCliOC.Fields.Item("CliOC_FechaRegistro").Value%></small>
        </td>
        <td class="project-title">
            <a href="#"><%=rsCliOC.Fields.Item("CliOC_NumeroOrdenCompra").Value%></a>
            <br/>
            <small> Elaboracion: <%=rsCliOC.Fields.Item("CliOC_FechaElaboracion").Value%></small>
        </td>

          <td class="project-title">
            <a href="#"><% 
			var Completa = rsCliOC.Fields.Item("CliOC_EstaCompleta").Value
			if(Completa == 1){ %>Completa <%} else { %> Incompleta <% } %></a>
            <br/>
            <small> Total articulos: <%=rsCliOC.Fields.Item("CliOC_TotalArticulos").Value%> <br />Articulos recibidos: <%=rsCliOC.Fields.Item("CliOC_ArticulosRecibidos").Value%></small>
        </td>
         <td class="project-title">
            <a href="#">Estatus   </a>
            <br/>
            <small><%=rsCliOC.Fields.Item("Estatus").Value%> </small>
        </td>
        <td class="project-actions" width="31">
          <a class="btn btn-white btn-sm btnDespliegaEntOC" data-cliid="<%=rsCliOC.Fields.Item("Cli_ID").Value%>"  data-cliocid="<%=rsCliOC.Fields.Item("CliOC_ID").Value%>" href="#"><i class="fa fa-folder"></i> Entregas</a>
        </td>
      </tr>
        <%
            rsCliOC.MoveNext() 
            }
        rsCliOC.Close()   
        %>       
    </tbody>
  </table>


</div>

<script type="text/javascript">

$(document).ready(function(){    

    $('.tooltip-demo').tooltip({
        selector: "[data-toggle=tooltip]",
        container: "body"
    });    
	
		$('.btnDespliegaEntOC').click(function(e) {
	         e.preventDefault();
            $(this).hide('slow')

			var cli = $(this).data('cliid')
			var clioc = $(this).data('cliocid')

            $('<tr id="tr_clioc'+clioc+'"><td colspan="6" id="td_clioc'+clioc+'">'+loading+'</td></tr>').insertAfter($(this).closest('tr'));
            var dato = {
                Cli_ID:cli,
				CliOC_ID:clioc,
				ASN_ID:<%=ASN_ID%>
            }
            $("#td_clioc"+clioc).load("/pz/wms/ASN/ASN_ClienteOC_Entregas.asp", dato);  
	});

});
    
function CargaCliente(c,t){

    $("#Cli_ID").val(c);
    $("#CliOC_ID").val(t);    
    CambiaSiguienteVentana();
			
}            
            
            

</script>    
    