<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->

<div class="form-horizontal" id="toPrint">
    <div class="row">
        <div class="col-lg-9">
            <div class="ibox float-e-margins">
               <div class="ibox-content">
                    <div class="form-group">
                        <legend class="control-label col-md-12" style="text-align: left;"><h1>Incidencias</h1></legend> 
                <!--    <div class="col-md-3">
					 <legend class="control-label col-md-12" style="text-align: left;"><h1>Fecha: </h1></legend> 
                    </div>-->
                     </div>
                  
                <div style="overflow-y: scroll; height:655px; width: auto;">
                <%
                   
                                
                %>



    <table class="table">
    <thead>
    <th>Folio</th>
    	<th>SKU</th>
    	<th>Modelo</th>
    	<th>Color</th>
    	<th>LPN</th>
    	<th>Masterbox incompletos</th>
    	    </thead>
    <tbody>	
		<%
var CliOC_ID = Parametro("CliOC_ID",-1)
var Cli_ID = Parametro("Cli_ID",-1)
var TA_ID = Parametro("TA_ID",-1)  
var OC_ID = Parametro("OC_ID",6)
			if(CliOC_ID > -1){
			 	sSQL = "SELECT *  FROM Recepcion_Pallet r  INNER JOIN  Cliente_OrdenCompra c ON r.CliOC_ID=c.CliOC_ID WHERE   "
		   		sSQL += "r.Pt_MBRechazados > 0 AND  r.Cli_ID = "+Cli_ID+" AND r.CliOC_ID= "+CliOC_ID
		   var sSQL1 = "SELECT *  FROM Recepcion_Series r INNER JOIN  Cliente_OrdenCompra c  ON r.CliOC_ID=c.CliOC_ID INNER JOIN Recepcion_Pallet p ON"
		   		sSQL1 += " r.Pt_ID=p.Pt_ID WHERE Ser_Incidencia = 1  AND  r.Cli_ID = "+Cli_ID+" AND  r.CliOC_ID= "+CliOC_ID
   var sSQL2 = "SELECT *  FROM  Inventario_Recepcion INNER JOIN Cliente_OrdenCompra c  ON r.CliOC_ID=c.CliOC_ID WHERE   "
		  		 sSQL2 += " r.IR_IncidenciaDescarga > 0 AND  r.Cli_ID = "+Cli_ID+" AND r.CliOC_ID= "+CliOC_ID
   var sSQL3= "SELECT *  FROM  Inventario_Recepcion INNER JOIN Cliente_OrdenCompra c  ON r.CliOC_ID=c.CliOC_ID WHERE IR_IncidenciaInasistencia = 1  "
		  		 sSQL3 += " AND  r.Cli_ID = "+Cli_ID+" AND r.CliOC_ID= "+CliOC_ID
				 var Folio = "CliOC_Folio"
			}
			if(OC_ID > -1){
			   	sSQL = "SELECT * FROM Recepcion_Pallet r  INNER JOIN Proveedor_OrdenCompra c ON r.OC_ID=c.OC_ID  WHERE "
		   		sSQL += "r.Pt_MBRechazados > 0 AND r.OC_ID= "+OC_ID
			var sSQL1 = "SELECT * FROM Recepcion_Series r INNER JOIN  Proveedor_OrdenCompra c  ON r.OC_ID=c.OC_ID  INNER JOIN Recepcion_Pallet p ON"
		   		sSQL1 += " r.Pt_ID=p.Pt_ID WHERE Ser_Incidencia = 1  AND r.OC_ID= "+OC_ID
			   	var sSQL2 = "SELECT * FROM Inventario_Recepcion r INNER JOIN Proveedor_OrdenCompra c  ON r.OC_ID=c.OC_ID"
		  		 sSQL2 += " WHERE  r.IR_IncidenciaDescarga > 0 AND r.OC_ID= "+OC_ID
		 	   	var sSQL3 = "SELECT * FROM Inventario_Recepcion r INNER JOIN Proveedor_OrdenCompra c  ON r.OC_ID=c.OC_ID"
		  		 sSQL3 += " WHERE IR_IncidenciaInasistencia = 1 AND r.OC_ID= "+OC_ID
				 var Folio = "OC_Folio"
			}  if(TA_ID > -1){
			 	sSQL = "SELECT * FROM  Recepcion_Pallet r  INNER JOIN TransferenciaAlmacen t ON r.TA_ID=t.TA_ID WHERE  "
		   		sSQL += "r.Pt_MBRechazados > 0 AND t.TA_ID= "+TA_ID
			var sSQL1 = "SELECT *  FROM Recepcion_Series r INNER JOIN  TransferenciaAlmacen t  ON r.TA_ID=t.TA_ID  INNER JOIN Recepcion_Pallet p ON"
		   		sSQL1 += " r.Pt_ID=p.Pt_ID WHERE Ser_Incidencia = 1  AND  t.TA_ID= "+TA_ID
		   var sSQL2 = "SELECT *  FROM  Inventario_Recepcion r INNER JOIN TransferenciaAlmacen t  ON r.TA_ID=t.TA_ID WHERE "
		  		 sSQL2 += " r.IR_IncidenciaDescarga > 0 AND  t.TA_ID= "+TA_ID
		   var sSQL3 = "SELECT *  FROM  Inventario_Recepcion r INNER JOIN TransferenciaAlmacen t  ON r.TA_ID=t.TA_ID WHERE IR_IncidenciaInasistencia = 1  "
		  		 sSQL3 += " AND  t.TA_ID= "+TA_ID
				 var Folio = "TA_Folio"
				}
			   var rsPallets = AbreTabla(sSQL,1,0)
	           var rsSerie = AbreTabla(sSQL1,1,0)
			   var rsDescargas = AbreTabla(sSQL2,1,0)
			  var rsInasistencias = AbreTabla(sSQL3,1,0)
		     while(!rsPallets.EOF){ 
			 var Folio = rsPallets.Fields.Item("CliOC_Folio").Value
			 var Pt_ID = rsPallets.Fields.Item("Pt_ID").Value 
			 var Pt_Color = rsPallets.Fields.Item("Pt_Color").Value 
             var Pt_Modelo = rsPallets.Fields.Item("Pt_Modelo").Value 
             var Pt_SKU = rsPallets.Fields.Item("Pt_SKU").Value 
             var Pt_LPN = rsPallets.Fields.Item("Pt_LPN").Value 
			  var Pt_MBRechazados = rsPallets.Fields.Item("Pt_MBRechazados").Value 
			
        %>	
    
            <tr>
           		 <td><%=Folio%></td>
                <td><%=Pt_SKU%></td>
                <td><%=Pt_Modelo%></td>
                <td><%=Pt_Color%></td>
                <td><%=Pt_LPN%></td>
                <td><%=Pt_MBRechazados%></td>
                <td>
     
      
                </td>
            </tr>
        <%	
            rsPallets.MoveNext() 
        }
        rsPallets.Close()   
		   
		%>
           
    </tbody>
</table>
 <table class="table">
    <thead>
    <th>Folio</th>
    	<th>SKU</th>
    	<th>Modelo</th>
    	<th>Color</th>
    	<th>LPN</th>
    	<th>Serie inexistente</th>
    	    </thead> 
            <%
			  while(!rsSerie.EOF){ 
			  Folio = rsSerie.Fields.Item("CliOC_Folio").Value
			  Pt_ID = rsSerie.Fields.Item("Pt_ID").Value 
			  Pt_Color = rsSerie.Fields.Item("Pt_Color").Value 
              Pt_Modelo = rsSerie.Fields.Item("Pt_Modelo").Value 
              Pt_SKU = rsSerie.Fields.Item("Pt_SKU").Value 
              Pt_LPN = rsSerie.Fields.Item("Pt_LPN").Value 
			  var Ser_Serie = rsSerie.Fields.Item("Ser_Serie").Value 
			
        %>	
    
            <tr>
           		 <td><%=Folio%></td>
                <td><%=Pt_SKU%></td>
                <td><%=Pt_Modelo%></td>
                <td><%=Pt_Color%></td>
                <td><%=Pt_LPN%></td>
                <td><%=Ser_Serie%></td>
                <td>
     

                
                </td>
            </tr>
        <%	
            rsSerie.MoveNext() 
        }
        rsSerie.Close()   
		   
		%>
            
             </tbody>
</table>
    <tbody>	
   <table class="table">
    <thead>
       	<th>Descargas incompletas</th>
        <th>Fecha</th>
    	    </thead>
    <tbody>
	<%
	     while(!rsDescargas.EOF){ 

	%>
            <tr>
                <td><%=rsDescargas.Fields.Item("CliOC_Folio").Value%></td>
           <td><%=rsDescargas.Fields.Item("IR_FechaEntregaTermina").Value%></td>
                      </tr>
        <%	
				
            rsDescargas.MoveNext() 
        }
        rsDescargas.Close()   
		%>
           
    </tbody>
</table>
 <table class="table">
    <thead>
       	<th>Inasistencias</th>
        <th>Fecha</th>
    	    </thead>
    <tbody>
	<%
	     while(!rsInasistencias.EOF){ 

	%>
            <tr>
                <td><%=rsInasistencias.Fields.Item("CliOC_Folio").Value%></td>
           <td><%=rsInasistencias.Fields.Item("IR_FechaEntregaTermina").Value%></td>
                      </tr>
        <%	
				
            rsInasistencias.MoveNext() 
        }
        rsInasistencias.Close()   
		%>
           
    </tbody>
</table>
                </div>

            </div>
            
        </div>
        
    </div>    
           
                
           


  <div class="col-md-3">
            <div class="ibox">
                <div class="ibox-title">
               
         <table class="table">
    <thead>
        <tr>
            <th class="text-center">Cliente</th>
            <th>Telefono</th>
           
            
        </tr>
    </thead>
    <tbody>
        <tr>
            <td class="text-center"></td>
            <td>-------</td>
           
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

<script src="/Template/inspina/js/plugins/jquery-ui/jquery-ui.min.js"></script>
<script type="text/javascript">
$(document).ready(function(e) {
	
	
});



 


</script>            