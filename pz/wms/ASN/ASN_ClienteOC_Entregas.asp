<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
 
    var Cli_ID = Parametro("Cli_ID",-1) 
    var CliOC_ID = Parametro("CliOC_ID",-1) 
    var ASN_ID = Parametro("ASN_ID",-1) 

    var bHayParams = false  

	var sSQL  = "SELECT e.*, c.*, cl.Cli_Nombre, es.Cat_Nombre as estatus, ct.Cat_Nombre as cita, a.Cat_Nombre as destino from "
					+ " Cliente_OrdenCompra_Entrega e "
					+	" INNER JOIN cliente cl ON e.Cli_ID=cl.Cli_ID"
					+ " INNER JOIN Cliente_OrdenCompra  c ON e.CliOC_ID=c.CliOC_ID AND e.Cli_ID=c.Cli_ID"
					+ " INNER JOIN Cat_Catalogo es ON es.Cat_ID=e.CliEnt_EstatusCG68 AND es.Sec_ID = 68"
					+ " INNER JOIN Cat_Catalogo ct ON ct.Cat_ID=e.CliEnt_CitaCG69 AND ct.Sec_ID = 69"
					+ " INNER JOIN Cat_Catalogo a ON a.Cat_ID=e.CliEnt_AreaDestinoCG88 AND a.Sec_ID = 88"
					+ "WHERE e.CliOC_ID > -1"
					
	  if (Cli_ID > -1) {  
        bHayParams = true
        sSQL += " AND e.Cli_ID = "+ Cli_ID
    }   
    
    if (CliOC_ID>-1) {
        bHayParams = true
        sSQL += "  AND  e.CliOC_ID = " + CliOC_ID   
    }   
	  if (ASN_ID >-1) {
        bHayParams = true
        sSQL += "  AND e.ASN_ID ="+ ASN_ID
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
    <h5>Entregas</h5>
</div>    
<div class="col-lg-12">
  <table class="table table-hover">
    <tbody>
        <tr id="tr_Ent<%=ASN_ID%>">
              		   <td class="project-title">
                       <strong> <spa>Cliente</spa></strong>
                       </td>
              		   <td class="project-title">
                       <strong> <spa>Orden de compra</spa></strong>
                       </td>
              		   <td class="project-title">
                       <strong> <spa>Numero OC</spa></strong>
                       </td>
                		   <td class="project-title">
                       <strong> <spa>Completada</spa></strong>
                       </td>
                        <td class="project-title">
                       <strong> <spa>Estatus OC</spa></strong>
                       </td>

              		   <td class="project-title">
                       <strong> <spa>Entrega</spa></strong>
                       </td>

              		   <td class="project-title">
                       <strong> <spa>Cantidad articulos</spa></strong>
                       </td>
                        <td class="project-title">
                       <strong> <spa>Estatus entrega</spa></strong>
                       </td>
              		   <td class="project-title">
                       <strong> <spa>Cita</spa></strong>
                       </td>
              		   <td class="project-title">
                       <strong> <spa>Ubicacion</spa></strong>
                       </td>
     
                       </tr>
        <%
	
        var rsCliOC = AbreTabla(sSQL,1,0)
        while (!rsCliOC.EOF){
		var IR_ID = rsCliOC.Fields.Item("IR_ID").Value
		 //Llaves += ", " + rsCliOC.Fields.Item("CliOC_ID").Value
	
        %>    
      <tr>
         <td class="project-title">
            <a href="#"><%=rsCliOC.Fields.Item("Cli_Nombre").Value%></a>
        </td>
        <td class="project-title">
            <a href="#"><%=rsCliOC.Fields.Item("CliOC_Folio").Value%></a>
            <br/>
            <small>Registro: <%=rsCliOC.Fields.Item("CliOC_FechaRegistro").Value%></small>
        </td>
        <td class="project-title">
            <a href="#"><%=rsCliOC.Fields.Item("CliOC_NumeroOrdenCompra").Value%></a>
            <br/>
            <small> Elaboracion: <br /><%=rsCliOC.Fields.Item("CliOC_FechaElaboracion").Value%></small>
        </td>

          <td class="project-title">
            <a href="#"><% 
			var Completa = rsCliOC.Fields.Item("CliOC_EstaCompleta").Value
			if(Completa == 1){ %>Completa <%} else { %> Incompleta <% } %></a>
            <br/>
            <small> Total articulos: <%=rsCliOC.Fields.Item("CliOC_TotalArticulos").Value%> <br />Recibidos: <%=rsCliOC.Fields.Item("CliOC_ArticulosRecibidos").Value%></small>
        </td>
         <td class="project-title">
        <%=rsCliOC.Fields.Item("Estatus").Value%>
        </td>
        <td class="project-title">
            <a href="#"><%=rsCliOC.Fields.Item("CliEnt_ID").Value%></a>
        </td>

          <td class="project-title">
            <a href="#"><%=rsCliOC.Fields.Item("CliEnt_CantidadArticulos").Value%></a><br />
            <small>SKUs: <%=rsCliOC.Fields.Item("CliEnt_CantidadProductos").Value%></small>
             <br/>
            <small>Pallets: <%=rsCliOC.Fields.Item("CliEnt_CantidadPallet").Value%></small>

        </td>
         <td class="project-title">
        <%=rsCliOC.Fields.Item("estatus").Value%> 
        </td>
         <td class="project-title">
           <%=rsCliOC.Fields.Item("cita").Value%> 
        </td>
         <td class="project-title">
            <%=rsCliOC.Fields.Item("destino").Value%> 
        </td>

        <td class="project-actions" width="31">
          <a class="btn btn-white btn-sm btnDespliegaProductos" data-irid="<%=rsCliOC.Fields.Item("IR_ID").Value%>" href="#" ><i class="fa fa-cube"></i> Productos</a>
          <a class="btn btn-white btn-sm btnDespliegaPallets" data-irid="<%=rsCliOC.Fields.Item("IR_ID").Value%>"  href="#"><i class="fa fa-cubes"></i> Pallets</a>
				<button class="btn btn-danger btnCierra btn-xs" id="btnC<%=rsCliOC.Fields.Item("IR_ID").Value%>" 
                        data-irid="<%=rsCliOC.Fields.Item("IR_ID").Value%>" >Cierra</button>

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
    
        $('.btnCierra').hide()
		
            $('.btnCierra').click(function(e) {
            e.preventDefault();
            $(this).hide('slow')
            var IR_ID = $(this).data('irid')
            $('.btnDespliegaProductos').show('slow')
            $('.btnDespliegaPallets').show('slow')
            $('#tr_prod'+IR_ID).hide('slow')
            $('#tr_pt'+IR_ID).hide('slow')

            setTimeout(function(){
                $('#tr_prod'+IR_ID).remove()
                $('#tr_pt'+IR_ID).remove()
            },800)
        });
      
});
    
    
		$('.btnDespliegaProductos').click(function(e) {
	         e.preventDefault();
            $(this).hide('slow')
            var IR_ID = $(this).data('irid')
            $('#btnC'+IR_ID).show('slow')

            $('<tr id="tr_prod'+IR_ID+'"><td colspan="12" id="td_prod'+IR_ID+'">'+loading+'</td></tr>').insertAfter($(this).closest('tr'));
            var dato = {
                IR_ID:IR_ID
            }
            $("#td_prod"+IR_ID).load("/pz/wms/ASN/ASN_ClienteOC_EntregasProductos.asp", dato);  
});       
            
		$('.btnDespliegaPallets').click(function(e) {
	         e.preventDefault();
            $(this).hide('slow')
            var IR_ID = $(this).data('irid')
            $('#btnC'+IR_ID).show('slow')


            $('<tr id="tr_pt'+IR_ID+'"><td colspan="12" id="td_pt'+IR_ID+'">'+loading+'</td></tr>').insertAfter($(this).closest('tr'));
            var dato = {
                IR_ID:IR_ID
            }
            $("#td_pt"+IR_ID).load("/pz/wms/ASN/ASN_Pallets.asp", dato);  
});    

</script>    
    