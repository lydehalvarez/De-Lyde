<%@LANGUAGE="JAVASCRIPT"  CODEPAGE="1252"%>
<!--#include file="../../../../Includes/iqon.asp" -->


<%
	
	var Lot_Tipo_Descripcion = Parametro("Descripcion","")  
		var Lot_ArticuloCantidad = Parametro("Cantidad",-1)  

%>



                <div class="ibox-title">
                
                    <h5>Totales</h5>
                </div>
                  <div class="ibox-content">
                        <div class="table-responsive">
                  <table class="table">
    <thead>
          
                <%
				if(Lot_Tipo_Descripcion == "Compra"){
             var sSQL = "SELECT  c.Cli_ID,  c.CliOC_ID, c.CliOC_Folio, count(c.CliOC_Folio) as articulos FROM  Cliente_OrdenCompra c  group by c.Cli_ID,  c.CliOC_ID, c.CliOC_Folio"
				}
				if(Lot_Tipo_Descripcion == "Venta"){
                var sSQL = "SELECT  v.Cli_ID,  v.OV_ID, v.OV_Folio, count(v.OV_Folio) as articulos FROM Orden_Venta v group by v.Cli_ID,  v.OV_ID, v.OV_Folio"
				}
				if(Lot_Tipo_Descripcion == "TransferenciaE"){
                var sSQL = "SELECT   t.Cli_ID, t.TA_ID,  t.TA_Folio, count(t.TA_Folio) as articulos  FROM  TransferenciaAlmacen t group by t t.Cli_ID, t.TA_ID,  t.TA_Folio"
				}
				if(Lot_Tipo_Descripcion == "TransferenciaS"){
                var sSQL = "SELECT  t.Cli_ID, t.TA_ID,  t.TA_Folio, count(t.TA_Folio) as articulos  FROM  TransferenciaAlmacen t group by t t.Cli_ID, t.TA_ID,  t.TA_Folio"
				}
			
		 	var rsKdx = AbreTabla(sSQL,1,0)
			var total  = rsKdx.Fields.Count 
		    while (!rsKdx.EOF){
			if(Lot_Tipo_Descripcion == "Compra"){
		   	var Cli_ID = rsKdx.Fields.Item("Cli_ID").Value
			  var Id = rsKdx.Fields.Item("CliOC_ID").Value 
	          var Folio =  rsKdx.Fields.Item("CliOC_Folio").Value 
		      var articulos =  rsKdx.Fields.Item("articulos").Value 
			   var tipo_mov='<a href="#" data-cliid="'+Cli_ID+'" data-ocid="'+Id+'" class="search-link LinkOC">'+Folio+'</a>'
				}
					if(Lot_Tipo_Descripcion == "Venta"){
			var Cli_ID = rsKdx.Fields.Item("Cli_ID").Value
			  var Id = rsKdx.Fields.Item("CliOC_ID").Value 
              var Folio =  rsKdx.Fields.Item("OV_Folio").Value 
		      var articulos =  rsKdx.Fields.Item("articulos").Value 
    		   var tipo_mov='<a href="#"data-cliid="'+Cli_ID+'" data-ovid="'+Id+'" class="search-link LinkOV">'+Folio+'</a>'
	  				}
					if(Lot_Tipo_Descripcion == "TransferenciaE"){
    		  	var Cli_ID = rsKdx.Fields.Item("Cli_ID").Value
			  var Id = rsKdx.Fields.Item("TA_ID").Value 
              var Folio =  rsKdx.Fields.Item("TA_Folio").Value 
		      var articulos =  rsKdx.Fields.Item("articulos").Value 
 			   var tipo_mov='<a href="#" data-cliid="'+Cli_ID+'" data-ocid="'+Id+'" class="search-link LinkTRA">'+Folio+'</a>'
			  				}
					if(Lot_Tipo_Descripcion == "TransferenciaS"){
			var Cli_ID = rsKdx.Fields.Item("Cli_ID").Value
    		  var Id = rsKdx.Fields.Item("TA_ID").Value 
             var Folio =  rsKdx.Fields.Item("TA_Folio").Value 
		      var articulos =  rsKdx.Fields.Item("articulos").Value 
 			   var tipo_mov='<a href="#" data-cliid="'+Cli_ID+'" data-taid="'+Id+'" class="search-link LinkTRA">'+Folio+'</a>'

			  				}
		
		  
		  %>
       
            <td>
           
          <%=tipo_mov%>
            </td>
             <td>
            <%=articulos%> art.
            </td>
               </tr>
            <%
				   rsKdx.MoveNext() 
                                    }
                                    rsKdx.Close()   	
			%>
     </div>
            </div>
  
		 </tbody>
</table>

      <script>
  $(document).ready(function(){
   


$('.LinkTRA').click(function(e) {
		e.preventDefault()
		
		var Params = "?TA_ID=" + $(this).data("taid")
		    Params += "&Cli_ID=" + $(this).data("cliid")
		    Params += "&IDUsuario=" + $("#IDUsuario").val()	

		$("#Contenido").load("/pz/wms/TA/TA_Ficha.asp" + Params)
	});
	
	$('.LinkOV').click(function(e) {
		e.preventDefault()
		
		var Params = "?OV_ID=" + $(this).data("ovid")
		    Params += "&Cli_ID=" + $(this).data("cliid")
		    Params += "&IDUsuario=" + $("#IDUsuario").val()	

		$("#Contenido").load("/pz/wms/OV/OV_Ficha.asp" + Params)
	});
		$('.LinkOC').click(function(e) {
		e.preventDefault()
		
		var Params = "?CliOC_ID=" + $(this).data("ocid")
		    Params += "&Cli_ID=" + $(this).data("cliid")
		    Params += "&IDUsuario=" + $("#IDUsuario").val()	

		$("#Contenido").load("/pz/wms/OC/Cli_OrdenCompra.asp" + Params)
	});
  });
 

 </script>

