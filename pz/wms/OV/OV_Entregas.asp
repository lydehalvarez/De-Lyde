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

   <div class="form-group">
               <label class="control-label col-md-3" ><strong> FILTROS </strong></label>
                <div class="col-md-3">
               </div>
               <label class="control-label col-md-3"><strong>Fecha</strong></label>
               <div class="col-md-3">
                   <input class="form-control agenda" id="OV_Fecha" placeholder="dd/mm/yyyy" type="text" autocomplete="off" value=""/> 
               </div>
               </div>
                  <div class="form-group">
               <label class="control-label col-md-3" ><strong>Folio</strong></label>
                <div class="col-md-3">
                   <input class="form-control agenda" id="OV_Folio" placeholder="Folio" type="text" autocomplete="off" value=""/> 
               </div>
               <label class="control-label col-md-3"><strong>Guia</strong></label>
               <div class="col-md-3">
                   <input class="form-control agenda" id="OV_Guia" placeholder="Guia" type="text" autocomplete="off" value=""/> 
               </div>
</div>

    <table class="table">
    <thead>
    <th>Folio</th>
    	<th>Fecha Entrega</th>
    	<th>Recibio</th>
    	<th>No. de Guia</th>
    	</thead>
    <tbody>	
		<%

var  FechaEntrega= ""
	if(FechaEntrega=="-"){
				var condicion= ""
			}else{
				if(FechaEntrega =="-"){
				var condicion= "  substring(IR_Puerta,1,2) = '"+ "'"
				}else{
				var condicion= " substring(IR_Puerta,1,2) = '"+  "'"
				}
				}
				if(FechaEntrega=="-"){
				var condicion2= "  cast (IR_FechaEntrega as date)  = '"+FechaEntrega+"' AND "
			}else{
					if(FechaEntrega=="-"){
				var condicion= ""
				}else{
				var condicion= "and substring(IR_Puerta,1,2) = '"+  "'"
				}
				var condicion2= "cast (IR_FechaEntrega as date)  = '"+ FechaEntrega + "'"
			}
		
			 	sSQL = "SELECT * FROM Orden_Venta v INNER JOIN Proveedor_Guia g ON v.OV_ID=g.OV_ID WHERE v.OV_EstatusCG51 = 10"
		   		sSQL += "AND "
			
			
				}
			   var rsOV = AbreTabla(sSQL,1,0)
	        
		     while(!rsOV.EOF){ 
			 var Folio = rsOV.Fields.Item("OV_Folio").Value
			 var OV_FechaEntrega = rsOV.Fields.Item("OV_FechaEntrega").Value 
			 var Recibio = rsOV.Fields.Item("OV_PersonaRecibePaquete").Value 
             var Guia = rsOV.Fields.Item("ProG_NumeroGuia").Value 
         			
        %>	
    
            <tr>
           		 <td><%=Folio%></td>
                <td><%=OV_FechaEntrega%></td>
                <td><%=Recibio%></td>
                <td><%=Guia%></td>
            
                <td>
     
      
                </td>
            </tr>
        <%	
            rsOV.MoveNext() 
        }
        rsOV.Close()   
		   
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