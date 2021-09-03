<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->

<%
var CliOC_ID = Parametro("CliOC_ID",-1)
var Cli_ID = Parametro("Cli_ID",-1)
var TA_ID = Parametro("TA_ID",-1)  
var OC_ID = Parametro("OC_ID",-1)
var Prov_ID = Parametro("Prov_ID",-1)
var Pallet = Parametro("Pallet",-1)
var Pro_ID = Parametro("Pro_ID",-1)
var CliEnt_ID = Parametro("CliEnt_ID", -1)
			
			if(CliOC_ID > -1){
 var	sSQL = "SELECT Ser_MB  FROM  Recepcion_Series WHERE  CliOC_ID= "+CliOC_ID+" AND Ser_SerieEscaneada = 0 AND Pro_ID = "+Pro_ID+" AND Ser_Pallet = "+Pallet
  		sSQL +=" group by Ser_MB  "
						var sSQL1 = "SELECT CliOC_Folio FROM Cliente_OrdenCompra WHERE  CliOC_ID= "+CliOC_ID
										var rsFolio = AbreTabla(sSQL1,1,0)
										var Folio =  rsFolio.Fields.Item("CliOC_Folio").Value
					 			}
				if(OC_ID > -1){
 var	sSQL = "SELECT Ser_MB  FROM  Recepcion_Series WHERE  OC_ID= "+OC_ID+" AND Ser_SerieEscaneada = 0 AND Pro_ID = "+Pro_ID+" AND Ser_Pallet = "+Pallet
 		sSQL +="  group by Ser_MB  "
						var sSQL1 = "SELECT OC_Folio FROM Proveedor_OrdenCompra WHERE  OC_ID= "+OC_ID
										var rsFolio = AbreTabla(sSQL1,1,0)
										var Folio =  rsFolio.Fields.Item("OC_Folio").Value

			}
			if(TA_ID>-1){
					 var	sSQL = "SELECT Ser_MB  FROM  Recepcion_Series WHERE  TA_ID= "+TA_ID+" AND Ser_SerieEscaneada = 0 AND Pro_ID = "+Pro_ID+"  AND Ser_Pallet = "+Pallet 			
					 sSQL +="  group by Ser_MB  "
						var sSQL1 = "SELECT TA_Folio FROM TransferenciaAlmacen WHERE TA_ID = "+ TA_ID
										var rsFolio = AbreTabla(sSQL1,1,0)
										var Folio =  rsFolio.Fields.Item("TA_Folio").Value

				}
				  var rsMB = AbreTabla(sSQL,1,0)
					
		
%>

<div class="form-horizontal" id="toPrint">
    <div class="row">
        <div class="col-lg-9">
            <div class="ibox float-e-margins">
               <div class="ibox-content">
                    <div class="form-group">
       <a data-taid="<%=TA_ID%>" data-cliocid="<%=CliOC_ID%>" data-ocid="<%=OC_ID%>" data-provid="<%=Prov_ID%>" data-cliid="<%=Cli_ID%>" data-pallet="<%=Pallet%>" data-mb="<%=Ser_MB%>"  data-proid="<%=Pro_ID%>"  data-clientid="<%=CliEnt_ID%>" class="text-muted btnRegresar"><i class="fa fa-mail-reply"></i>&nbsp;<strong>Regresar </strong></a>		

                        <legend class="control-label col-md-12" style="text-align: left;"><h1>Masterbox escaneados</h1>  <h1>Pallet: <%=Pallet%>      </h1>   
                                    		</legend> 
                <!--    <div class="col-md-3">
					 <legend class="control-label col-md-12" style="text-align: left;"><h1>Fecha: </h1></legend> 
                    </div>-->
                     </div>
                  
                <div style="overflow-y: scroll; height:655px; width: auto;">
                <%
                   
                                
                %>


    <table class="table">
    <thead>
    <th>Masterbox</th>
   	<th>Cantidad Series</th>
    	    </thead>
    <tbody>	
		<%
			while(!rsMB.EOF){ 
			if(CliOC_ID > -1){
		 	sSQL = "SELECT  count(Ser_Serie)  as Cantidad, Ser_MB FROM  Recepcion_Series WHERE  CliOC_ID= "+CliOC_ID
			sSQL += "AND Pro_ID = "+Pro_ID+" AND Ser_SerieEscaneada = 0 AND Ser_MB= "+rsMB.Fields.Item("Ser_MB")+"AND Ser_Pallet = "+Pallet+"  group by Ser_MB"
			}
				  if(OC_ID > -1){
		 	sSQL = "SELECT  count(Ser_Serie)  as Cantidad, Ser_MB FROM  Recepcion_Series WHERE  OC_ID= "+OC_ID
			sSQL += "AND Pro_ID = "+Pro_ID+" AND Ser_SerieEscaneada = 0 AND Ser_MB = "+rsMB.Fields.Item("Ser_MB")+"  AND Ser_Pallet = "+Pallet+"  group by Ser_MB"
			}  if(TA_ID > -1){
		 	sSQL = "SELECT  count(Ser_Serie)  as Cantidad, Ser_MB FROM  Recepcion_Series WHERE  TA_ID= "+TA_ID
			sSQL += "AND Pro_ID = "+Pro_ID+"  AND Ser_SerieEscaneada = 0 AND Ser_MB = "+rsMB.Fields.Item("Ser_MB")+"AND Ser_Pallet = "+Pallet+"  group by Ser_MB"
				}
	         var rsMasterbox = AbreTabla(sSQL,1,0)
		      
			 var Ser_MB = rsMasterbox.Fields.Item("Ser_MB").Value 
			 var Series = rsMasterbox.Fields.Item("Cantidad").Value 
        %>	
    
            <tr>
           		 <td><%=Ser_MB%></td>
                <td><%=Series%></td>
                <td>
                 
                <a data-taid="<%=TA_ID%>" data-cliocid="<%=CliOC_ID%>" data-ocid="<%=OC_ID%>" data-provid="<%=Prov_ID%>" data-cliid="<%=Cli_ID%>" data-pallet="<%=Pallet%>" data-mb="<%=Ser_MB%>"  data-proid="<%=Pro_ID%>" data-clientid="<%=CliEnt_ID%>" class="text-muted btnMB"><i class="fa fa-inbox"></i>&nbsp;<strong>Ver series </strong></a>
                
                </td>
            </tr>
        <%	
            rsMB.MoveNext() 
        }
        rsMB.Close()   
		%>
           
    </tbody>
</table>

                </div>

            </div>
            
        </div>
        
    </div>    
           
                
                        <input type="text" value="<%=Pro_ID%>" style="display:none;width:150%"  class="objAco agenda"  id="Pro_ID">
   

</div>
                </div>
</div>

<script type="application/javascript">


$(document).ready(function() {
$("#CliOC_ID").hide();
$("#TA_ID").hide();
$("#Cli_ID").hide();
$("#OC_ID").hide();
$("#Prov_ID").hide();

$('.btnMB').click(function(e) {
		e.preventDefault()
		
		var Params = "?CliOC_ID=" + $(this).data("cliocid")
		Params += "&TA_ID=" + $(this).data("taid")   
		Params += "&OC_ID=" + $(this).data("ocid")
		Params += "&Prov_ID=" + $(this).data("provid") 
		Params += "&Cli_ID=" + $(this).data("cliid") 
		Params += "&Pro_ID=" +   $(this).data("proid") 
		Params += "&Pallet=" + $(this).data("pallet") 
		Params += "&MB=" + $(this).data("mb") 
		Params += "&CliEnt_ID=" + $(this).data("clientid") 

		$("#divMB").load("/pz/wms/Recepcion/RecepcionResumenSeries.asp" + Params)
	});
	
	
$('.btnRegresar').click(function(e) {
		e.preventDefault()
		
		var Params = "?CliOC_ID=" + $(this).data("cliocid")
		Params += "&TA_ID=" + $(this).data("taid")   
		Params += "&OC_ID=" + $(this).data("ocid")
		Params += "&Prov_ID=" + $(this).data("provid") 
		Params += "&Pro_ID=" +   $(this).data("proid") 
		Params += "&Cli_ID=" + $(this).data("cliid") 
		Params += "&CliEnt_ID=" + $(this).data("clientid") 

		$("#divMB").load("/pz/wms/Recepcion/RecepcionResumenPallets.asp" + Params)
	});
	
 
	});
	
 
</script>
