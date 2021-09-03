<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../../Includes/iqon.asp" -->

             
             <div id="wrapper">
    <div class="wrapper wrapper-content animated fadeInRight">
        <div class="row">
            <div class="col-sm-8">
                <div class="ibox">    
                    <div class="ibox-content">
                        <div class="row">
                            <div class="col-lg-12">
                                <div class="m-b-md">
                                <%
								var Lot_ID = Parametro("Lot_ID",1)
								 var Tarea = Parametro("Tarea",1)  
								   var sSQL = "SELECT * FROM dbo.FNC_Inventerio_Lote_Kardex_Lote("+Lot_ID+", null) LOTH"
								    var rsKdx = AbreTabla(sSQL,1,0)
									 
									  var Lot_Folio =  rsKdx.Fields.Item("Lot_Folio").Value 
				    				    var Lot_Fecha =  rsKdx.Fields.Item("Lot_Fecha").Value 
									  var Lot_Tipo_Descripcion =  rsKdx.Fields.Item("Lot_Tipo_Descripcion").Value
									  var Lot_ArticuloCantidad =  rsKdx.Fields.Item("Lot_ArticuloCantidad").Value
  
							
	%>
      <h2 class="pull-right"><%=Lot_Folio%></h2>
      <%
	
	%>
    
                                </div>
                            </div>
                        </div>
                        <hr>        
                        <div class="row">
                            <div class="col-lg-12" id="cluster_info">
                          
                             <dl class="dl-horizontal">
                                    <dt>Fecha:</dt>
                                    <dd><%=Lot_Fecha%></dd>
                                    <dt>Tipo de movimiento:</dt>
                                    <dd><%=Lot_Tipo_Descripcion%></dd>
                                    <dt>Cantidad:</dt>
                                    <dd><%=Lot_ArticuloCantidad%></dd>
                                  							
                                </dl>   
          <table class="table" align="center" width="600">
    <thead>
        <tr>
         <th class="text-center">Folio</th>
            <th class="text-center">Fecha</th>
          
               <th>Tipo Movimiento</th>
                  <th>Cantidad</th>
                  </tr>
                  </thead>
    <%
	var Lot_ID_Padre = 0

	var arbol = "";
 var  espacios = "";

   

 var n = "";

    
		
	
   var sSQL = "SELECT * FROM dbo.FNC_Inventerio_Lote_Kardex_Lote("+Lot_ID+", null) LOTH WHERE Lot_ID <> "+Lot_ID
	
	
		 var rsKdx = AbreTabla(sSQL,1,0)
		    while (!rsKdx.EOF){
		  var Lot_ID =  rsKdx.Fields.Item("Lot_ID").Value 
		  var Lot_ID_Padre =  rsKdx.Fields.Item("Lot_ID_Padre").Value 
		  var LOT_Nivel =  rsKdx.Fields.Item("LOT_Nivel").Value 
		  var Lot_CantidadHijos =  rsKdx.Fields.Item("Lot_CantidadHijos").Value 
          var Lot_Fecha =  rsKdx.Fields.Item("Lot_Fecha").Value 
		  var Lot_Folio =  rsKdx.Fields.Item("Lot_Folio").Value
		  var Lot_Tipo_Descripcion =  rsKdx.Fields.Item("Lot_Tipo_Descripcion").Value
		  var Lot_ProductoCantidad =  rsKdx.Fields.Item("Lot_ProductoCantidad").Value
		  var Lot_ArticuloCantidad =  rsKdx.Fields.Item("Lot_ArticuloCantidad").Value
  
		for (var i = 0; i < LOT_Nivel; i++) {
			if (i == 0){
			n = "";
			}
			   n = n+'<i class="fa fa-folder-open"></i>';
     		}
			espacios = n
			
					%>
	
	 <tbody>
     <tr>
                              <td>
            <%=espacios%><a href="#" data-lotid="<%=Lot_ID%>"  data-folio = "<%=Lot_Folio%>"   class="search-link LinkFolio"><%=Lot_Folio%></a> 
            </td>          
            <td>
            <%=Lot_Fecha%>
            </td>
             
             <td>
           <a href="#" data-desc="<%=Lot_Tipo_Descripcion%>" data-cantidad="<%=Lot_ArticuloCantidad%>"  class="search-link LinkDesc"><%=Lot_Tipo_Descripcion%></a>
      
            </td>
             <td>
            <%=Lot_ArticuloCantidad%>
            </td>
        </tr>
 
	<%
		  
		   rsKdx.MoveNext() 
                                    }
                                    rsKdx.Close()   	
		
	
 %>
    
    </tbody>
     </table>
      </div>  </div>

                        </div>
                       
                    </div>
                </div>
            
            <div class="col-sm-4">
                <div id="divGrid"></div>
            </div>
        </div>
</div>
</div>
  <script>
  $(document).ready(function(){
   
   $('.LinkFolio').click(function(e) {
		e.preventDefault()
		
		var Params = "?Lot_ID=" + $(this).data("lotid")
		    Params += "&Tarea=" + 2
		    Params += "&Lot_Folio=" + $(this).data("folio")

		$("#Contenido").load("/pz/wms/Almacen/Inventario/Kardex_Lote.asp" + Params)
	});
		$('.LinkDesc').click(function(e) {
		e.preventDefault()
		var desc = $(this).data("desc")
		if( $(this).data("desc")== "Transferencia de entrada")
	{
			desc = "TransferenciaE"
	}
		if( $(this).data("desc")== "Transferencia de salida")
	{
			desc = "TransferenciaS"
	}
		var Params = "?Descripcion=" + desc
		     Params += "&Cantidad=" + $(this).data("cantidad")
		$("#divGrid").load("/pz/wms/Almacen/Inventario/Kardex_Lote_Ajax.asp" + Params)
	});
	
  });
	</script>