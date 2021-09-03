<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%
	var Tarea = Parametro("Tarea", -1)
    var Id_Usuario = Parametro("ID_Usuario",-1)  
	var CliOC_ID = Parametro("CliOC_ID",-1)
	var OC_ID = Parametro("OC_ID",-1)
	var Prov_ID = Parametro("Prov_ID",-1)
	var TA_ID = Parametro("TA_ID",-1)  
	var Cli_ID = Parametro("Cli_ID",-1)  
	var Ser_Serie = Parametro("Ser_Serie","")
	var Pro_ID = Parametro("Pro_ID",-1)
	var CliEnt_ID = Parametro("CliEnt_ID", -1)
	var Articulos =  parseInt(Parametro("Articulos",1))
	var MB =  parseInt(Parametro("MB",-1))
	var Pallet =  parseInt(Parametro("Pallets",-1))
	var Cantidad_MB =  parseInt(Parametro("Cantidad_MB",-1))
	var Cantidad_Pallet =  parseInt(Parametro("Cantidad_Pallet",-1))
	var IR_ID = Parametro("IR_ID", -1)
	var error = Parametro("error", "")
	var OCP = Parametro("OCP", 1)
	var Pal = 1
	if(MB == 111111){
		MB = -1
	}

	if (Tarea==-1){

			var Pro_ID = Parametro("Pro_ID",-1)
			
	var sSQLTr  = "SELECT MAX(Ser_MB) AS MB, MAX(Ser_Pallet) as pallet FROM Recepcion_Series  WHERE Pro_ID = "+ Pro_ID+" AND "
if(CliOC_ID > -1){
	 sSQLTr += "CliOC_ID = "+CliOC_ID
}if(OC_ID > -1){
		 sSQLTr += "OC_ID = "+OC_ID
	}if(TA_ID > -1){
	 sSQLTr += "TA_ID = "+TA_ID
	}
			 var rsSer = AbreTabla(sSQLTr,1,0)
			  if(rsSer.RecordCount > 0){
			MB = rsSer.Fields.Item("MB").Value 
			Pallet = rsSer.Fields.Item("pallet").Value
			  }if(MB<1){
				MB = -1  
			  }
var sSQLTr  = "SELECT COUNT(*) AS Articulos FROM Recepcion_Series  WHERE Ser_MB = "+MB+"  AND Ser_Pallet = "+Pallet+" and Pro_ID = "+ Pro_ID+" AND "
if(CliOC_ID > -1){
	 sSQLTr += "CliOC_ID = "+CliOC_ID
}if(OC_ID > -1){
		 sSQLTr += "OC_ID = "+OC_ID
	}if(TA_ID > -1){
	 sSQLTr += "TA_ID = "+TA_ID
	}
			rsSer = AbreTabla(sSQLTr,1,0)
			Articulos = rsSer.Fields.Item("Articulos").Value 
	
			
				   if(OC_ID > -1){
sSQL = "SELECT  r.CliEnt_CantidadArticulos as Pro_CantidadMB, r.CliEnt_CantidadPallet as Pro_CantidadPt FROM  Producto_Cliente c INNER JOIN Producto p ON p.Pro_ID = c.Pro_ID INNER JOIN Proveedor_OrdenCompra_EntregaProducto r ON  p.Pro_ID = r.Pro_ID  WHERE  r.Pro_ID= "+Pro_ID+"  AND  r.OC_ID = "+OC_ID+" AND r.ProvEnt_ID = "+CliEnt_ID
				   }else{
sSQL = "SELECT  r.CliEnt_CantidadArticulos as Pro_CantidadMB, r.CliEnt_CantidadPallet as Pro_CantidadPt FROM  Producto_Cliente c INNER JOIN Producto p ON p.Pro_ID = c.Pro_ID INNER JOIN Cliente_OrdenCompra_EntregaProducto r ON  p.Pro_ID = r.Pro_ID  WHERE   r.Pro_ID= "+Pro_ID+" AND r.CliOC_ID = "+CliOC_ID+" AND r.CliEnt_ID = "+CliEnt_ID
				   }
				 var rsActivos = AbreTabla(sSQL,1,0)
			
				 if (rsActivos.RecordCount > 0){
					 MB = 1
				     Cantidad_MB= rsActivos.Fields.Item("Pro_CantidadMB").Value
				 while (!rsActivos.EOF){
					 Cantidad_Pallet= rsActivos.Fields.Item("Pro_CantidadPt").Value
					 Pallet = 1
		  rsActivos.MoveNext() 
                                    }
                                    rsActivos.Close()   	
				 }
	} 
	
	if(CliOC_ID > -1){
   	var sSQL1  = "select  p.Pro_ID, p.ProC_Nombre, p.ProC_SKU from Producto_Cliente p "
         sSQL1 += "inner join cliente c on p.Cli_ID=c.Cli_ID "
	   	 sSQL1 += "inner join  Cliente_OrdenCompra_Articulos a  on p.Pro_ID = a.Pro_ID "
	     sSQL1 += " where a.CliOC_ID = " + CliOC_ID 
		 sSQL1 += " AND p.Pro_ID = "+Pro_ID+" GROUP BY p.Pro_ID, p.ProC_Nombre, p.ProC_SKU"
		    var rsPro = AbreTabla(sSQL1,1,0)
			    var rsPro2 = AbreTabla(sSQL1,1,0)
		}
		if(OC_ID > -1){
   	var sSQL1  = "select  p.Pro_ID, p.ProC_Nombre, p.ProC_SKU from Producto_Proveedor p "
         sSQL1 += "inner join proveedor c on p.Prov_ID=c.Prov_ID "
			 sSQL1 += "inner join  Proveedor_OrdenCompra_Articulos a on p.Pro_ID = a.Pro_ID  "
	     sSQL1 += " where a.OC_ID = " + OC_ID 
		 sSQL1 += " AND p.Pro_ID = "+Pro_ID+" GROUP BY p.Pro_ID, p.ProC_Nombre, p.ProC_SKU"
		    var rsPro = AbreTabla(sSQL1,1,0)
			    var rsPro2 = AbreTabla(sSQL1,1,0)
		}
		 if(TA_ID > -1){
		 var sSQL1  = "select p.Pro_ID, p.ProC_Nombre, p.ProC_SKU from Producto_Cliente p "
         sSQL1 += "inner join cliente c on p.Cli_ID=c.Cli_ID "
		 sSQL1 += "inner join  TransferenciaAlmacen_Articulos a  on p.Pro_ID = a.Pro_ID  "
	     sSQL1 += " where a.TA_ID = " + TA_ID 
		  sSQL1 += " AND p.Pro_ID = "+Pro_ID+" GROUP BY p.Pro_ID, p.ProC_Nombre, p.ProC_SKU"
		 
   var rsPro = AbreTabla(sSQL1,1,0)
       var rsPro2 = AbreTabla(sSQL1,1,0)
		 }
		
if(CliOC_ID > -1){
	var sSQL = "SELECT CliOC_Folio FROM Cliente_OrdenCompra WHERE CliOC_ID = "+CliOC_ID
   var rsArt = AbreTabla(sSQL,1,0)
	var Folio =  rsArt.Fields.Item("CliOC_Folio").Value
	}if(OC_ID > -1){
		var sSQL = "SELECT OC_Folio FROM Proveedor_OrdenCompra WHERE OC_ID = "+OC_ID
   var rsArt = AbreTabla(sSQL,1,0)
	var Folio =  rsArt.Fields.Item("OC_Folio").Value
	}if(TA_ID > -1){
	var sSQL = "SELECT TA_Folio FROM TransferenciaAlmacen WHERE TA_ID = "+TA_ID
			   var rsArt = AbreTabla(sSQL,1,0)
				var Folio =  rsArt.Fields.Item("TA_Folio").Value
	}

%>

<div class="form-horizontal" id="toPrint">
    <div class="row">
    <%
	 if(Cantidad_Pallet>-1){
		%>
        <div class="col-lg-9">
            <div class="ibox float-e-margins">
            <%
			}else{
			%>
              <div class="col-lg-12">
                <div class="ibox">
                <%
				}
				%>
                <div class="ibox-content">
       
                 
                <div style="overflow-y: scroll; height:655px; width: 200;">
                  <input type="text" value="<%=CliOC_ID%>" style="display:none;width:150%" class="objAco agenda"  id="CliOC_ID">
                     <input type="text" value="<%=OC_ID%>" style="display:none;width:150%" class="objAco agenda"  id="OC_ID">
                        <input type="text" value="<%=Prov_ID%>" style="display:none;width:150%" class="objAco agenda"  id="Prov_ID">
                                <input type="text" value="<%=TA_ID%>"  style="display:none;width:150%"  class="objAco agenda"  id="TA_ID">
                               <input type="text" value="<%=Cli_ID%>" style="display:none;width:150%"  class="objAco agenda"  id="Cli_ID">
                                <input type="text" value="<%=CliEnt_ID%>" style="display:none;width:150%"  class="objAco agenda"  id="CliEnt_ID">

                    <div class="ibox-content">
                        <div class="table" id= "dvEscaneos">
                     
         
                                 <table class="table">
    <thead>

    	<th>SKU</th>
    	<th>Modelo</th>
       <th>Total</th>
    	    </thead>
    <tbody>	
		<%

						if(CliOC_ID > -1){
	sSQLTr = "SELECT * FROM Cliente_OrdenCompra_Articulos t INNER JOIN Producto p ON p.Pro_ID= t.Pro_ID  "
    sSQLTr += "WHERE CliOCP_SKU = '"+ rsPro2.Fields.Item("ProC_SKU").Value+"' AND CliOC_ID = "+CliOC_ID
 	 rsPro = AbreTabla(sSQLTr,1,0) 
}if(OC_ID > -1){
		sSQLTr = "SELECT * FROM Proveedor_OrdenCompra_Articulos t INNER JOIN Producto p ON p.Pro_ID= t.Pro_ID WHERE "
		 sSQLTr += "OCP_SKU = '"+ rsPro2.Fields.Item("ProC_SKU").Value+"' AND  OC_ID = "+OC_ID
	 rsPro = AbreTabla(sSQLTr,1,0) 
	}if(TA_ID > -1){
	sSQLTr = "SELECT * FROM TransferenciaAlmacen_Articulos t INNER JOIN Producto p ON p.Pro_ID= t.Pro_ID  "
	 sSQLTr += "WHERE TA_SKU = '"+ rsPro2.Fields.Item("ProC_SKU").Value+"' AND TA_ID = "+TA_ID
		 rsPro = AbreTabla(sSQLTr,1,0) 
	}
			
 
			  var inputEscan = ""
			  var inputEscan2 =  'style="display:none;width:150%"'
			  		 		
		
			 switch (parseInt(Tarea)) {
			 case 1:

			  var sSQLTr  = "SELECT * FROM Recepcion_Series where Ser_Serie = '"+Ser_Serie+"'"
				 var rsSer = AbreTabla(sSQLTr,1,0) 
						
			if(rsSer.RecordCount > 0){
		error = "  <tr>  <td class='text-center'>  <FONT COLOR='red'> "+Ser_Serie+" (Ya existe) </FONT></td></tr>" + error

			}else{
		var sSQLTr  = "SELECT * FROM Producto"
        sSQLTr += " WHERE Pro_ID = " + Pro_ID

		   var rsTPro = AbreTabla(sSQLTr,1,0) 
			
		   var Tipo = rsTPro.Fields.Item("TPro_ID").Value
	
if(Tipo != 2){
var NoCar = 15
}if(Tipo == 2){
var NoCar = 20
}
							var caracteres = Ser_Serie.length
								
							
				
	if(caracteres == NoCar){
					if(Cantidad_Pallet > -1){	
				 Articulos += 1
				 if(MB > -1){
			  	if(Articulos > Cantidad_MB){
									MB +=1
										Articulos = 1
									}
									if(MB > Cantidad_Pallet){
								  Pallet += 1	
									MB = 1
									} 
						
									//	if(MB == Cantidad_Pallet && Articulos == Cantidad_MB){
//											 Pallet += 1	
//									MB = 1
//										}
				 }
				 
					}else{
					MB = -1
					Pallet = -1	
					}
									if(Pallet<= Cantidad_Pallet || Cantidad_Pallet == -1){
								
										var SKU = rsPro2.Fields.Item("ProC_SKU").Value
											
if(CliOC_ID > -1){
sSQLTr = "INSERT INTO Cliente_Inventario (Cli_ID, CliOC_ID, CInv_NumeroSerie, CInv_NumeroSerieFabricante, Inv_EstatusCG22," 
sSQLTr  += "Pro_ID, CInv_SKU)  values("+Cli_ID+"," +CliOC_ID +",'"+Ser_Serie+"','"+Ser_Serie+"', 1,  "+Pro_ID+", '"+SKU+"')"

}if(OC_ID > -1){
sSQLTr = "INSERT INTO Proveedor_Inventario (Prov_ID, OC_ID, PInv_NumeroSerie, PInv_NumeroSerieFabricante, Inv_EstatusCG22," 
sSQLTr  += "Pro_ID, PInv_SKU)  values("+Prov_ID+"," +OC_ID +",'"+Ser_Serie+"','"+Ser_Serie+"', 1,  "+Pro_ID+", '"+SKU+"')"
	
	}if(TA_ID > -1){
	 sSQLTr += "TA_ID = "+TA_ID
	}

	Ejecuta(sSQLTr, 0) 
OCP += 1
var Ser_ID = BuscaSoloUnDato("ISNULL((MAX(Ser_ID)),0)+1","Recepcion_Series","",-1,0)
sSQLTr = "INSERT INTO Recepcion_Series  (Ser_ID, OC_ID, Prov_ID,CliOC_ID, Cli_ID,  CliEnt_ID, Ser_Serie, Pro_ID,  Ser_MB, Ser_Pallet)  "
sSQLTr  += "values("+Ser_ID+"," +OC_ID +"," +Prov_ID +"," +CliOC_ID +","+Cli_ID+","+CliEnt_ID+",'"+Ser_Serie+"', "+Pro_ID+", "
sSQLTr  += MB+","+Pallet+")"

				Ejecuta(sSQLTr, 0)
	
					
									}
									}
						
			}
	
			 break;
			 }
	 	
	

          
			 var Pro_ID = rsPro2.Fields.Item("Pro_ID").Value 		
		     var Pro_Modelo = rsPro2.Fields.Item("ProC_Nombre").Value 
             var Pro_SKU = rsPro2.Fields.Item("ProC_SKU").Value 
     

			if(CliOC_ID > -1){
sSQL = "SELECT CliEnt_CantidadPallet, CliEnt_CantidadArticulos FROM Cliente_OrdenCompra_EntregaProducto "
sSQL += "where  CliOC_ID = "+CliOC_ID+" AND CliEnt_ID = "+CliEnt_ID
			var rsMB = AbreTabla(sSQL,1,0)
	if (rsMB.RecordCount > 0){
			var CantidadMB = rsMB.Fields.Item("CliEnt_CantidadArticulos").Value
	}
			}else{
sSQL = "SELECT ProvEnt_CantidadPallet, ProvEnt_CantidadArticulos FROM Cliente_OrdenCompra_EntregaProducto "
sSQL += "where  OC_ID = "+OC_ID+" AND ProvEnt_ID = "+CliEnt_ID
			var rsMB = AbreTabla(sSQL,1,0)
	if (rsMB.RecordCount > 0){
			var CantidadMB = rsMB.Fields.Item("ProvEnt_CantidadArticulos").Value
	}
			}
		sSQLTr = "SELECT COUNT(*) as escaneadas FROM Recepcion_Series s  WHERE s.Pro_ID = "+rsPro2.Fields.Item("Pro_ID").Value+" AND Ser_SerieEscaneada = 0 AND  "
	if(CliOC_ID > -1){
	 sSQLTr += " s.CliEnt_ID = "+CliEnt_ID+" AND s.CliOC_ID = "+CliOC_ID
 	var rsEscaneadas = AbreTabla(sSQLTr,1,0) 
		 


}if(OC_ID > -1){
		 sSQLTr += " s.ProvEnt_ID = "+ProvEnt_ID+" AND s.OC_ID = "+OC_ID
	var rsEscaneadas = AbreTabla(sSQLTr,1,0) 
		

	}if(TA_ID > -1){
	 sSQLTr += "TA_ID = "+TA_ID
		var rsEscaneadas = AbreTabla(sSQLTr,1,0) 
	

	}

	var escaneadas =  rsEscaneadas.Fields.Item("escaneadas").Value 
	
	    %>	
   
            <tr>
           	

                <td><%=Pro_SKU%></td>
                <td><%=Pro_Modelo%></td>
                <td><%=escaneadas%></td>
           

                                     <td class="desc">
 <label class="control-label col-md-3" id="InputPeso<%=Pro_ID%>" style="display:none;width:200%"><strong>Peso Aprox. kg</strong></label>   <input type="button"  data-ptid="<%=Pro_ID%>" id="BtnAprobado<%=Pro_ID%>" class="btn btn-primary BtnAprobado"  value= "Aprobar" style="display:none;width:70%"> </input>
                                      <input type="button"  data-ptid="<%=Pro_ID%>"  id="BtnRechazado<%=Pro_ID%>" class="btn btn-danger BtnRechazado" value= "Rechazar"  style="display:none;width:70%"> </input>
                                   <%/*%><input type="text" value=""  data-ovid="<%=OV_ID%>" placeholder="Peso de masterbox" class="form-control InputPeso" id="InputPeso<%=OV_ID%>"/><%*/%>
                                   
                                        <input type="text" value="" <%=inputEscan%>  placeholder="Numero de serie" class="form-control InputScan agenda" id="InputScan" data-proid="<%=Pro_ID%>" data-artic= "<%=Articulos%>" data-totalmb="<%=MB%>" data-pallets="<%=Pallet%>" data-cantmb="<%=Cantidad_MB%>" data-cantpallet="<%=Cantidad_Pallet%>"/>
                                        <input type="text" value="" <%=inputEscan2%>  placeholder="Numero de serie" class="form-control InputScan2 agenda" id="InputScan2<%=Pro_ID%>" />
                                        <p class="small" id="Mensaje<%=Pro_ID%>"></p>
                                        <p class="small" id="SeriePickeada<%=Pro_ID%>"></p>
                               <%if (MB>-1){%>               
                  <input type="button" value="Resumen Pallets" data-proid="<%=Pro_ID%>" id="btnResumen" class="btn btn-info btnResumen"/>
                  <%}%>
   </td>
                                </tr>
                          
                
                                </tbody>
                            </table>
           
                      <table class="table">
    <thead>
    	<th>No. de Serie escaneado</th>
        <%if (MB>-1){%>
    		<th>Masterbox</th>
           	<th>Pallet</th>
            <% }%>
    	    </thead>
    <tbody>
             
            <%if(caracteres != NoCar){
				error = "  <tr>  <td class='text-center'>  <FONT COLOR='red'> "+Ser_Serie+" </FONT></td></tr>" + error
				%>
        <% }%>
     
	<%
	if(CliOC_ID > -1){
		var sSQLTr  = "SELECT * FROM Recepcion_Series   WHERE Pro_ID = "+Pro_ID+" AND Ser_SerieEscaneada = 0"
					var SSQL = sSQLTr + "  AND  CliOC_ID= "+CliOC_ID+"  AND Ser_MB= "+MB+" AND Ser_Pallet = "+Pallet+"  ORDER BY Ser_ID Desc "
			sSQLTr += " AND  CliOC_ID= "+CliOC_ID+" AND CliEnt_ID = "+CliEnt_ID+" ORDER BY Ser_ID Desc"
			}	if(OC_ID > -1){
			var SSQL = sSQLTr + "  AND  CliOC_ID= "+CliOC_ID+"  AND Ser_MB= "+MB+" AND Ser_Pallet = "+Pallet+"  ORDER BY Ser_ID Desc "
		 sSQLTr += "  AND  OC_ID= "+OC_ID+ "  AND CliEnt_ID = "+CliEnt_ID+" ORDER BY Ser_ID Desc"
			}if(TA_ID > -1){
			sSQLTr += " AND  TA_ID= "+TA_ID+ "  AND CliEnt_ID = "+CliEnt_ID+"  ORDER BY Ser_ID Desc"
				}
		   var rsSerie = AbreTabla(sSQLTr,1,0) 
		   var rsMBActual =  AbreTabla(SSQL,1,0) 

		   if(!rsSerie.EOF){
		    Pal = rsSerie.Fields.Item("Ser_Pallet").Value
			MB = rsSerie.Fields.Item("Ser_MB").Value
	
	     while(!rsMBActual.EOF){ 
	%>
  <tr>
                   <td><%=rsMBActual.Fields.Item("Ser_Serie").Value%></td>
                 <%if (MB>-1){%>
                <td><%=rsMBActual.Fields.Item("Ser_MB").Value%></td>
                <td><%=rsMBActual.Fields.Item("Ser_Pallet").Value%></td>
                <%
					 }
					 
				%>
            </tr>
        <%	
				
            rsMBActual.MoveNext() 
        }
        rsMBActual.Close()   
		   }
		%>
        
    </tbody>
</table>

                             </div>
                    </div>
                  
                </div>

            </div>
       
        </div>
    </div>   
    <% if(Cantidad_Pallet > -1){
		%> 
       <div class="col-md-3">
            <div class="ibox">
                <div class="ibox-title">
                
                <%
					var MBescan =MB -1
		
			if(CliOC_ID > -1){
		 	sSQL = "SELECT  count(Ser_Serie)  as Cantidad FROM  Recepcion_Series WHERE  CliOC_ID= "+CliOC_ID
			sSQL += " AND Pro_ID = "+Pro_ID+" AND Ser_SerieEscaneada = 0 AND Ser_MB= "+MB+" AND Ser_Pallet = "+Pal
			}
				  if(OC_ID > -1){
		 	sSQL = "SELECT  count(Ser_Serie)  as Cantidad  FROM  Recepcion_Series WHERE  OC_ID= "+OC_ID
			sSQL += " AND Pro_ID = "+Pro_ID+" AND Ser_SerieEscaneada = 0 AND Ser_MB = "+MB+"  AND Ser_Pallet ="+Pal
			}  if(TA_ID > -1){
		 	sSQL = "SELECT  count(Ser_Serie)  as Cantidad FROM  Recepcion_Series WHERE  TA_ID= "+TA_ID
			sSQL += " AND Pro_ID = "+Pro_ID+" AND Ser_MB = "+MB+" AND Ser_Pallet = "+Pal
				}
	         var rsMasterbox = AbreTabla(sSQL,1,0)
		
			 var Articulos = rsMasterbox.Fields.Item("Cantidad").Value 			
		
				var masterbox = MB
				Pallet = Pal 	
				if(MB==Cantidad_Pallet){
				if(Articulos==Cantidad_MB){
				//MB=0		
				}
	
				}
		
					%>
                <th>SKU: <%=SKU%></th><br />

                  <td>Articulos masterbox: <%=Articulos%>/<%=Cantidad_MB%> <BR />Masterbox:  <%=MB%>/<%=Cantidad_Pallet%>  <br />Pallet: <%=Pal%></td>
              
                          <table class="table">
    <thead>
        <tr>
            <th class="text-center">Series mal escaneadas</th>
                    
            
        </tr>
    </thead>
    <tbody>
       <%=error%>

		 </tbody>
</table>
                   
                   
                   
                </div>
                </div>
				</div>
                
                  <%  
	}
				   if(MB==-1){ MB = 111111 } %>
                                     <input type="text" value="<%=Pallet%>" style="display:none;width:150%"  class="objAco agenda"  id="Pallet">
                                     <input type="text" value="<%=MB%>" style="display:none;width:150%"  class="objAco agenda"  id="MB">
                                     <input type="text" value="<%=Articulos%>" style="display:none;width:150%"  class="objAco agenda"  id="Articulos">
                                <input type="text" value="<%=Pro_ID%>" style="display:none;width:150%"  class="objAco agenda"  id="Pro_ID">
                                     <input type="text" value="<%=error%>" style="display:none;width:150%"  class="objAco agenda"  id="error">
                                   <input type="text" value="<%=OCP%>" style="display:none;width:150%"  class="objAco agenda"  id="OCP">


</div>
</div>
					
		<script src="/Template/inspina/js/plugins/sheetJs/xlsx.full.min.js"></script>

<script type="application/javascript">


$(document).ready(function() {
		$('#InputScan').focus()
	$('#dvNvoScan').click(function(e) {
	$('.Robin').attr('disabled',false)
	var  div = document.getElementById('divScan');
    div.style.display = '';

});
$('#NvoMB').click(function(e) {
	$('.Robin').attr('disabled',false)
	var  div = document.getElementById('divMB');
    div.style.display = '';

});
		$('#NvoPallet').click(function(e) {
	$('.Robin').attr('disabled',false)
	var  div = document.getElementById('divPallet');
    div.style.display = '';

});

$('.btnResumen').click(function(e) {
		e.preventDefault()
	var datoAgenda = {}
		$('.agenda').each(function(index, element) {
            datoAgenda[$(this).attr('id')] = $(this).val()
        });
		datoAgenda['CliOC_ID'] = $('#CliOC_ID').val()
		datoAgenda['OC_ID'] = $('#OC_ID').val()
		datoAgenda['Prov_ID'] = $('#Prov_ID').val()
		datoAgenda['Pro_ID'] =  $(this).data("proid")
        datoAgenda['Cli_ID'] = $('#Cli_ID').val()
		datoAgenda['CliEnt_ID'] = $('#CliEnt_ID').val()
		datoAgenda['TA_ID'] = $('#TA_ID').val()
		$("#divMB").load("/pz/wms/Recepcion/RecepcionResumenPallets.asp",datoAgenda)
<%/*%>	$('#InputPeso'+OV_ID).focus()<%*/%>

});


$('.BtnAprobado').click(function(e) {
	e.preventDefault()
	var Pro_ID = $(this).data("ptid")
	$('#InputScan'+Pt_ID).css('display','block')
    $("#InputPeso"+Pt_ID).hide();
	$("#BtnAprobado"+Pt_ID).hide();
    $("#BtnRechazado"+Pt_ID).hide();
});
$('.BtnRechazado').click(function(e) {
	e.preventDefault()
	var Pt_ID = $(this).data("ptid")
	    $("#InputPeso"+Pt_ID).hide();
	$("#BtnAprobado"+Pt_ID).hide();
    $("#BtnRechazado"+Pt_ID).hide();
	var datoAgenda = {}
	
		var Pt_ID = $(this).data("ptid")
		datoAgenda['Pt_ID'] = Pt_ID
		datoAgenda['Tarea'] =2
	$("#dvEscaneos").load("/pz/wms/Recepcion/RecepcionCargaSeries.asp",datoAgenda
	 , function(data){
	
			sTipo = "info";
			sMensaje = "Ha sido reportado como incidencia ";
			
				Avisa(sTipo,"Aviso",sMensaje);
});
});
$('.InputPeso').on('change',function(e) {
	e.preventDefault()
	var Pt_ID = $(this).data("ptid")
	$('#InputScan'+Pt_ID).css('display','block')
	
});
	$('.InputScan').on('change',function(e) {
	e.preventDefault()
	var datoAgenda = {}
		$('.agenda').each(function(index, element) {
            datoAgenda[$(this).attr('id')] = $(this).val()
        });
	var Pro_ID = $(this).data("proid")
	var Articulos = $(this).data("artic")
	var Pallets = $(this).data("pallets")
	var totalMB = $(this).data("totalmb")
	var Cantidad_Pallet = $(this).data("cantpallet")
	var Cantidad_MB = $(this).data("cantmb")
		datoAgenda['Tarea'] =1
		datoAgenda['CliOC_ID'] = $('#CliOC_ID').val()
		datoAgenda['CliEnt_ID'] = $('#CliEnt_ID').val()
		datoAgenda['OC_ID'] = $('#OC_ID').val()
		datoAgenda['Prov_ID'] = $('#Prov_ID').val()
		datoAgenda['Pro_ID'] =Pro_ID
        datoAgenda['Cli_ID'] = $('#Cli_ID').val()
		datoAgenda['TA_ID'] = $('#TA_ID').val()
		datoAgenda['Pallets'] = $('#Pallet').val()
		datoAgenda['Articulos'] = $('#Articulos').val()
		datoAgenda['MB'] =  $('#MB').val()
		datoAgenda['Cantidad_Pallet'] = Cantidad_Pallet
		datoAgenda['Cantidad_MB'] = Cantidad_MB
		datoAgenda['OCP'] =  $('#OCP').val()
		datoAgenda['Ser_Serie'] = $('#InputScan').val()
		datoAgenda['error'] =  $('#error').val()

		$('#InputScan').hide();
		$("#divMB").load("/pz/wms/Recepcion/RecepcionCargaEscaneo.asp",datoAgenda

    , function(data){
	
			sTipo = "info";
			sMensaje = "La serie se ha guardado correctamente ";
			
				Avisa(sTipo,"Aviso",sMensaje);
	});
	
});
});




       

// Function to download data to a file



</script>
	