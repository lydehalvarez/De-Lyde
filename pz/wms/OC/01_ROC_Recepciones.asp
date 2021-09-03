<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%

	var Cli_ID = Parametro("Cli_ID",-1)
	var CliOC_ID = Parametro("CliOC_ID",-1)
	var TA_ID = Parametro("TA_ID",-1)
    var IR_ID = Parametro("IR_ID",-1)
	var Pro_ID = Parametro("Pro_ID",-1)
	var Usu_ID = Parametro("IDUsuario",-1)	
	
	
		if(CliOC_ID > -1){
		var sSQL1  = "select * "
        sSQL1 += " from Cliente_OrdenCompra "
			    sSQL1 += " where Cli_ID = " + Cli_ID
	    sSQL1 += " AND CliOC_ID = " + CliOC_ID
		
		}
			if(TA_ID > -1){
		var sSQL1  = "select * "
        sSQL1 += " from TransferenciaAlmacen "
	    sSQL1 += " where TA_ID = " + TA_ID
		}
   
   var rsTP = AbreTabla(sSQL1,1,0)

   	
	var IR_Folio = ""
	var Cli_Nombre = ""
	var IR_FechaEntrega = ""	
    var IR_Conductor = ""
    var IR_DescripcionVehiculo = ""
    var IR_Placas = ""
	var Pro_Nombre = ""
	var Cantidad = ""
	var Pro_SKU = ""
		
		if(CliOC_ID > -1){
   	var sSQL1  = "select r.*, c.Cli_Nombre,  p.Pro_Nombre, p.Pro_SKU, a.CliOCP_Cantidad from inventario_recepcion r "
         sSQL1 += "inner join cliente c on r.Cli_ID=c.Cli_ID "
	     sSQL1 += "inner join Cliente_OrdenCompra t  on  t.CliOC_ID = r.CliOC_ID "
		 sSQL1 += "inner join  Cliente_OrdenCompra_Articulos a  on t.CliOC_ID = a.CliOC_ID "
	     sSQL1 += "inner join  Producto p  on a.Pro_ID = p.Pro_ID where r.CliOC_ID = " + CliOC_ID 
		    var rsTP = AbreTabla(sSQL1,1,0)
  		    var rsArt = AbreTabla(sSQL1,1,0)
   			var rsArt2 = AbreTabla(sSQL1,1,0)
   			var rsArt3 = AbreTabla(sSQL1,1,0)
		}
		 if(TA_ID > -1){
		 var sSQL1  = "select r.*, c.Cli_Nombre,  p.Pro_Nombre, p.Pro_SKU, a.TAA_Cantidad from inventario_recepcion r "
         sSQL1 += "inner join cliente c on r.Cli_ID=c.Cli_ID "
	     sSQL1 += "inner join TransferenciaAlmacen t  on  t.TA_ID = r.TA_ID "
		 sSQL1 += "inner join  TransferenciaAlmacen_Articulos a  on t.TA_ID = a.TA_ID "
	     sSQL1 += "inner join  Producto p  on a.Pro_ID = p.Pro_ID where r.TA_ID = " + TA_ID 
		 
   var rsTP = AbreTabla(sSQL1,1,0)
   var rsArt = AbreTabla(sSQL1,1,0)
   var rsArt2 = AbreTabla(sSQL1,1,0)
   var rsArt3 = AbreTabla(sSQL1,1,0)
		 }
					
					
	if (!rsTP.EOF){
         IR_Folio  = rsTP.Fields.Item("IR_Folio").Value
         Cli_Nombre  = rsTP.Fields.Item("Cli_Nombre").Value
        IR_FechaEntrega = rsTP.Fields.Item("IR_FechaEntrega").Value
		IR_Conductor =  rsTP.Fields.Item("IR_Conductor").Value
		IR_DescripcionVehiculo =  rsTP.Fields.Item("IR_DescripcionVehiculo").Value
		IR_Placas = rsTP.Fields.Item("IR_Placas").Value
   }
                                                
					                               
                %>
 <link href="/Template/inspina/css/plugins/iCheck/green.css" rel="stylesheet">
<style>
.opciones{
	margin-left: 20px;	
}
</style>

<div class="wrapper wrapper-content animated fadeInRight">
	<div class="row">
        <div class="col-md-9">
            <div class="ibox">
                <div class="ibox-title">
                  
                    <h5>Cita en agenda</h5>  
<p>
   <br> faltan dos botones 1) descarga completa : no se hace nada solo se indica
       <br> 2) descarga incompleta: se indica y se debe abrir un modal para colocar la observacion campo CliOC_ObservacionesDescarga
    <br>falta imprimir este formato, de recepcion el cual se le entrega al transportista
    
    </p>
                </div>
                <div style="overflow-y: auto; height:655px; width: auto;">
           
                    <div class="ibox-content" id="<%=IR_Folio%>">
                                     <h4>
                                        Cliente: <%=Cli_Nombre%>
                                      </h4>
                                      <h4>
                                        Folio: <%=IR_Folio%>
                                      </h4>
                                      <h4>
                                        Fecha de recepci&oacute;n: <%=IR_FechaEntrega%>
                                      </h4>
                                          <h4>
                                       Conductor: <%=IR_Conductor%>
                                      </h4>
                                          <h4>
                                       Vehiculo: <%=IR_DescripcionVehiculo%>
                                      </h4>
                                      <h4>
                                       Placas: <%=IR_Placas%>
                                      </h4>
                        <div >
                        <table class="table shoping-cart-table">
                                <tbody>
                                <tr>
                                   
                                    <td class= "desc">
                                    <h3>SKU</h3>

                                    <%
                                        while(!rsArt.EOF){
                                             Pro_SKU = rsArt.Fields.Item("Pro_SKU").Value 
                                    %>		
                                        <h4><%=Pro_SKU%></h4>
                                    <%	
                                        rsArt.MoveNext() 
                                    }
                                    rsArt.Close()   
                                    %>
                                    </td>
                                     <td class= "desc">
                                        <h3>  
                                            Producto
                                        </h3>
                                      <%
                                        while(!rsArt2.EOF){
                                           Pro_Nombre = rsArt2.Fields.Item("Pro_Nombre").Value   
                                    %>		
                                        <h4><%=Pro_Nombre%></h4>
                                    <%	
                                        rsArt2.MoveNext() 
                                    }
                                    rsArt2.Close()   
                                    %>
                             </td>
                                     <td class= "desc">
                                    <h3>Cantidad</h3>
                                    <%
									var Limiteishon = 0
                                        while(!rsArt3.EOF){
												if(CliOC_ID > -1){
									Cantidad = rsArt3.Fields.Item("CliOCP_Cantidad").Value 
												}
													if(TA_ID > -1){
									Cantidad = rsArt3.Fields.Item("TAA_Cantidad").Value 
													}
                                    %>		
                                        <h4><%=Cantidad%></h4>
                                            
                                    <%	
                                        rsArt3.MoveNext() 
                                    }
                                    rsArt3.Close()   
                                    %>
                                    </td>
                               
         </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
				</div>
            </div>
        </div>
    </div>
</div>

        
<script type="text/javascript">

	<%/*%>	var Paramts = "IDUnica=" + $("#IDUsuario").val()
	    Paramts += "&<%=For_Parametros%>"

$(document).ready(function() {
		
		
  $('.collapse-link').on('click', function () {
        var ibox = $(this).closest('div.ibox-title');
        var button = $(this).find('i');

        var content = ibox.children('.ibox-content');
        content.slideToggle(200);
        button.toggleClass('fa-chevron-up').toggleClass('fa-chevron-down');
        ibox.toggleClass('').toggleClass('border-bottom');
        setTimeout(function () {
            ibox.resize();
            ibox.find('[id^=map-]').resize();
        }, 50);
    });

  
    $('.help-link').on('click', function () {
        console.log("help")
    });
		
	$('.Coments-link').on('click', function () {
        console.log("Comentarios")
    });	
		
		
		
<%	if(For_Archivo != ""){ %>

		$('#dvFor_Archivo').load('<%=For_Archivo%>?' + Paramts);
<%	} %>
		
		BPM_CargaBotonesYEstatus()
	});
	
	function EstadoBoton(Visible) {
		if( Visible == 1 ) {
			$("#btnGuardar").show("slow")
		} else {
			$("#btnGuardar").hide("slow")		
		}
	}
	
	function BPM_CargaBotonesYEstatus(){
		$("#BPMBotones").load("/pz/wms/BPM/BPM_Botones_TA.asp?" + Paramts);
	}<%*/%>

</script>
<%/*%><%	if(For_ArchivoJS != ""){  
		Response.Write("<script src='" + For_ArchivoJS + "'></script>")
 	}
%><%*/%>