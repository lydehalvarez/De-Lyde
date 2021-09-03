<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
 
	var IR_ID = Parametro("IR_ID",-1) 
    var ASN_ID = Parametro("ASN_ID",-1) 

    var bHayParams = false  

	var sSQL  = "SELECT p.*,  e.IR_ID, pro.Pro_Nombre, pro.Pro_ID from "
					+ " Cliente_OrdenCompra_EntregaProducto p"
					+ " INNER JOIN Cliente_OrdenCompra  c ON p.CliOC_ID=c.CliOC_ID AND p.Cli_ID=c.Cli_ID"
					+ " INNER JOIN Cliente_OrdenCompra_Entrega  e ON e.CliOC_ID=p.CliOC_ID AND e.Cli_ID=p.Cli_ID AND e.CliEnt_ID=p.CliEnt_ID "
					+ " INNER JOIN Producto  pro ON p.Pro_ID=pro.Pro_ID "
					+ "WHERE p.CliOC_ID > -1"
					
	  if (IR_ID > -1) {  
        bHayParams = true
        sSQL += " AND e.IR_ID = "+ IR_ID
    }   
    
	  if (ASN_ID >-1) {
        bHayParams = true
        sSQL += "  AND p.ASN_ID ="+ ASN_ID 
    }   

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
    <h5>Productos Entrega</h5>
</div>    
<div class="project-list">
  <table class="table table-hover">
    <tbody>
        <tr id="tr_pro<%=IR_ID%>">
              		  
              		 
              		   <td class="project-title">
                       <strong> <spa>SKU</spa></strong>
                       </td>
                            <td class="project-title">
                       <strong> <spa>Producto</spa></strong>
                       </td>
                        <td class="project-title">
                       <strong> <spa>Articulos esperados</spa></strong>
                       </td>
                         <td class="project-title">
                       <strong> <spa>Articulos recibidos</spa></strong>
                       </td>
                       <td class="project-title">
                      <strong> <spa>Pallets</spa></strong>
                       </td>

     
                       </tr>
        <%
	
        var rsCliOC = AbreTabla(sSQL,1,0)
        while (!rsCliOC.EOF){
		var Llaves = rsCliOC.Fields.Item("IR_ID").Value
		 //Llaves += ", " + rsCliOC.Fields.Item("CliOC_ID").Value
	
        %>    
      <tr>
<!--        <td class="project-title">
            <a href="#">></a>
            <br/>
            <small>Registro:</small>
        </td>-->
        <td class="project-title">
            <a href="#"><%=rsCliOC.Fields.Item("CliEnt_SKU").Value%></a>
        </td>
        <td class="project-title">
            <a href="#"><%=rsCliOC.Fields.Item("Pro_Nombre").Value%></a>
        </td>
          <td class="project-title">
            <a href="#"><%=rsCliOC.Fields.Item("CliEnt_ArticulosRecibidos").Value%></a>
        </td>
        <td class="project-title">
            <a href="#"><%=rsCliOC.Fields.Item("CliEnt_ArticulosLlegaron").Value%></a>
        </td>
         <td class="project-title">
				<%=rsCliOC.Fields.Item("CliEnt_CantidadPallet").Value%>
        </td>
        <td class="project-actions" width="31">
          <a class="btn btn-white btn-sm btnDespliegaPalletsPro" data-irid="<%=rsCliOC.Fields.Item("IR_ID").Value%>" data-proid="<%=rsCliOC.Fields.Item("Pro_ID").Value%>"  href="#"><i class="fa fa-cubes"></i> Pallets</a>

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
		$('.btnDespliegaPalletsPro').click(function(e) {
	         e.preventDefault();
            $(this).hide('slow')
            var IR_ID = $(this).data('irid')
            var Pro_ID = $(this).data('proid')


            $('<tr id="tr_ptpro'+IR_ID+'"><td colspan="12" id="td_ptpro'+IR_ID+'">'+loading+'</td></tr>').insertAfter($(this).closest('tr'));
            var dato = {
                IR_ID:IR_ID,
				Pro_ID:Pro_ID,
				ASN_ID:<%=ASN_ID%>
            }
            $("#td_ptpro"+IR_ID).load("/pz/wms/ASN/ASN_Pallets.asp", dato);  
});    

});
    
    
function CargaCliente(c,t){

    $("#Cli_ID").val(c);
    $("#CliOC_ID").val(t);    
    CambiaSiguienteVentana();
			
}            
            
            

</script>    
    