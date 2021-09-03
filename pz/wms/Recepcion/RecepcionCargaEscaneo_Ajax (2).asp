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
	var Ser_Serie = Parametro("Ser_Serie",1)
	var Pro_ID = Parametro("Pt_ID",-1)
	var Articulos =  parseInt(Parametro("Articulos",1))
	var MB =  parseInt(Parametro("MB",-1))
	var Pallet =  parseInt(Parametro("Pallets",-1))
	var Cantidad_MB =  parseInt(Parametro("Cantidad_MB",-1))
	var Cantidad_Pallet =  parseInt(Parametro("Cantidad_Pallet",-1))
	var IR_ID = Parametro("IR_ID", -1)
	var error = Parametro("error", "")
	
	if(MB == 111111){
		MB = -1
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
        <div class="col-lg-9">
            <div class="ibox float-e-margins">
                <div class="ibox-content">
                    <div class="form-group">
                                                         <a data-taid="<%=TA_ID%>" data-cliocid="<%=CliOC_ID%>" data-ocid="<%=OC_ID%>" data-provid="<%=Prov_ID%>" data-cliid="<%=Cli_ID%>"  class="text-muted btnRegresar"><i class="fa fa-mail-reply"></i>&nbsp;<strong>Regresar </strong></a>		
                        <legend class="control-label col-md-12" style="text-align: left;"><h1>Folio:&nbsp;<%=Folio%></h1></legend>
                       
                     
                     </div>
                 
                <div style="overflow-y: scroll; height:655px; width: 200;">
                  <input type="text" value="<%=CliOC_ID%>" style="display:none;width:150%" class="objAco agenda"  id="CliOC_ID">
                     <input type="text" value="<%=OC_ID%>" style="display:none;width:150%" class="objAco agenda"  id="OC_ID">
                        <input type="text" value="<%=Prov_ID%>" style="display:none;width:150%" class="objAco agenda"  id="Prov_ID">
                                <input type="text" value="<%=TA_ID%>"  style="display:none;width:150%"  class="objAco agenda"  id="TA_ID">
                               <input type="text" value="<%=Cli_ID%>" style="display:none;width:150%"  class="objAco agenda"  id="Cli_ID">
                                  <input type="text" value="<%=Pro_ID%>" style="display:none;width:150%"  class="objAco agenda"  id="Pro_ID">
                                       <input type="text" value="<%=IR_ID%>" style="display:none;width:150%"  class="objAco agenda"  id="IR_ID">
                                 

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
			
			
			  var inputEscan = 'style="display:none;width:150%"'
			  var inputEscan2 = ""
			  var totalMB = 0
			 switch (parseInt(Tarea)) {
			 case 1:
			 
	
					
		 var sSQLTr  = "SELECT * FROM Recepcion_Series where Ser_Serie = '"+Ser_Serie+"'"
			 var rsSer = AbreTabla(sSQLTr,1,0) 
			if(rsSer.RecordCount > 0){
			}else{
		var sSQLTr  = "SELECT * FROM Producto"
        sSQLTr += " WHERE Pro_ID = " + Pro_ID

		   var rsTPro = AbreTabla(sSQLTr,1,0) 
		   
		   var Tipo = TPro.Fields.Item("TPro_ID").Value
if(Tipo != 2){
var NoCar = 15
}if(Tipo == 2){
var NoCar = 20
}
					var caracteres = Ser_Serie.length
	if(caracteres == NoCar){
					Articulos += 1
					if(MB > -1){
					if(Articulos > Cantidad_MB){
							MB += 	1
										Articulos = 1
									}
									if(MB > Cantidad_Pallet){
									Pallet += 1	
										MB = 1
									}
					}
		if(Pallet<= Cantidad_Pallet){
										
										var SKU = rsPro2.Fields.Item("ProC_SKU").Value
if(CliOC_ID > -1){
 sSQLTr += "INSERT INTO Cliente_Inventario (Cli_ID, CliOC_ID, OCP_ID, CInv_NumeroSerie, CInv_NumeroSerieFabricante, Inv_EstatusCG22," 
sSQLTr  += "Pro_ID, CInv_SKU)  values("+Cli_ID+"," +CliOC_ID +",1,'"+Ser_Serie+"','"+Ser_Serie+"', 1,  "+Pro_ID+", '"+SKU+"')"

}if(OC_ID > -1){
 sSQLTr += "INSERT INTO Proveedor_Inventario (Prov_ID, OC_ID, OCP_ID, PInv_NumeroSerie, PInv_NumeroSerieFabricante, Inv_EstatusCG22," 
sSQLTr  += "Pro_ID, PInv_SKU)  values("+Prov_ID+"," +OC_ID +",1,'"+Ser_Serie+"','"+Ser_Serie+"', 1,  "+Pro_ID+", '"+SKU+"')"
	
	
	
	}if(TA_ID > -1){
	 sSQLTr += "TA_ID = "+TA_ID
	}
	Ejecuta(sSQLTr, 0)
		var Ser_ID = BuscaSoloUnDato("ISNULL((MAX(Ser_ID)),0)+1","Recepcion_Series","",-1,0)
		sSQLTr = "INSERT INTO Recepcion_Series  (Ser_ID, OC_ID, Prov_ID,CliOC_ID, TA_ID, Cli_ID,  Ser_Serie, Pro_ID, IR_ID, Ser_MB, Ser_Pallet)  "
	sSQLTr  += "values("+Ser_ID+"," +OC_ID +"," +Prov_ID +"," +CliOC_ID +"," +TA_ID+", " +Cli_ID+", '"+Ser_Serie+"', "+Pro_ID+",  "+IR_ID+", "+MB+","+Pallet+")"
						Ejecuta(sSQLTr, 0)
					
									}
						}		
			}
		sSQLTr = "SELECT COUNT(*) as escaneadas FROM Recepcion_Series WHERE Pro_ID = "+rsPro2.Fields.Item("Pro_ID").Value+" AND "
		if(CliOC_ID > -1){
	 sSQLTr += "CliOC_ID = "+CliOC_ID
 	var rsEscaneadas = AbreTabla(sSQLTr,1,0) 
}if(OC_ID > -1){
		 sSQLTr += "OC_ID = "+OC_ID
	var rsEscaneadas = AbreTabla(sSQLTr,1,0) 
	}if(TA_ID > -1){
	 sSQLTr += "TA_ID = "+TA_ID
		var rsEscaneadas = AbreTabla(sSQLTr,1,0) 
	}
	var escaneadas = rsEscaneadas.Fields.Item("escaneadas").Value 
			 break;
		
	 			 }
	
	
          
			 var Pro_ID = rsPro2.Fields.Item("Pro_ID").Value 		
             var Pro_Modelo = rsPro2.Fields.Item("ProC_Nombre").Value 
             var Pro_SKU = rsPro2.Fields.Item("ProC_SKU").Value 
     
			 
			
			sSQL = "SELECT Pro_ProdRelacionado, Pro_Cantidad FROM Producto_Relacion where Pro_ID = "+ Pro_ID	
			var rsMB = AbreTabla(sSQL,1,0)
			 if (rsMB.RecordCount > 0){
			var CantidadMB = rsMB.Fields.Item("Pro_Cantidad").Value
			 }
		
        %>	
   
            <tr>
           	

                <td><%=Pro_SKU%></td>
                <td><%=Pro_Modelo%></td>
          		  <td><%=escaneadas%></td>
           

                                     <td class="desc">
 <label class="control-label col-md-3" id="InputPeso<%=Pro_ID%>" style="display:none;width:200%"><strong>Peso Aprox. kg</strong></label>   <input type="button"  data-ptid="<%=Pro_ID%>" id="BtnAprobado<%=Pro_ID%>" class="btn btn-primary BtnAprobado"  value= "Aprobar" style="display:none;width:70%"> </input>
                                      <input type="button"  data-ptid="<%=Pro_ID%>"  id="BtnRechazado<%=Pro_ID%>" class="btn btn-danger BtnRechazado" value= "Rechazar"  style="display:none;width:70%"> </input>
                                   <%/*%><input type="text" value=""  data-ovid="<%=OV_ID%>" placeholder="Peso de masterbox" class="form-control InputPeso" id="InputPeso<%=OV_ID%>"/><%*/ %>
                     <input type="text" value="" <%=inputEscan%>  placeholder="Numero de serie" class="form-control InputScan agenda" id="InputScan<%=Pro_ID%>"/>
                                 
                                      <input type="text" value="" <%=inputEscan2%>  placeholder="Numero de serie" class="form-control InputScan2 agenda" id="InputScan2<%=Pro_ID%>" data-ptid="<%=Pro_ID%>" data-artic= "<%=Articulos%>" data-totalmb="<%=MB%>" data-pallets="<%=Pallet%>"data-cantmb="<%=Cantidad_MB%>" data-cantpallet="<%=Cantidad_Pallet%>"/>
                                        <p class="small" id="Mensaje<%=Pro_ID%>"></p>
                                        <p class="small" id="SeriePickeada<%=Pro_ID%>"></p>
                <%if (MB>-1){%>               
                  <input type="button" value="Resumen Pallets"  id="btnResumen" class="btn btn-info btnResumen"/>
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
        <%}%>
    	    </thead>
    <tbody>
  
            <%if(caracteres < 15){
				error = "  <tr>  <td class='text-center'>  <FONT COLOR='red'> "+Ser_Serie+" </FONT></td></tr>" + error
				%>
        <% }%>

	<%
		var sSQLTr  = "SELECT * FROM Recepcion_Series"
			if(CliOC_ID > -1){
			sSQLTr += " WHERE  CliOC_ID= "+CliOC_ID
			}	if(OC_ID > -1){
		 sSQLTr += "  WHERE  OC_ID= "+OC_ID
			}if(TA_ID > -1){
			sSQLTr += " WHERE TA_ID= "+TA_ID
				}
			sSQLTr += "  AND Pro_ID = "+Pro_ID+" ORDER BY Ser_ID Desc"
								
		   var rsSerie = AbreTabla(sSQLTr,1,0) 
	     	while(!rsSerie.EOF){ 
	%>
            <tr>
             
                <td><%=rsSerie.Fields.Item("Ser_Serie").Value%></td>
                <%if (MB>-1){%>
                <td><%=rsSerie.Fields.Item("Ser_MB").Value%></td>
                <td><%=rsSerie.Fields.Item("Ser_Pallet").Value%></td>
                </tr>
                <%
					 }
						%>
          
        <%	
				
            rsSerie.MoveNext() 
        }
        rsSerie.Close()   
		%>
           
    </tbody>
</table>
                             </div>
                    </div>
                  
                </div>

            </div>
       
        </div>
    </div>    

       <div class="col-md-3">
            <div class="ibox">
                <div class="ibox-title">
            <%  	
			
				
					%>
                <th>SKU: <%=Pro_SKU%></th><br />

                  <td>Articulos masterbox: <%=Articulos%>/<%=Cantidad_MB%> <BR />Masterbox:  <%=MB%>/<%=Cantidad_Pallet%>  <br />Pallets: <%=Pallet%></td>
              
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
       
                  <%   if(MB==-1){ MB = 111111 } %>
                                     <input type="text" value="<%=MB%>" style="display:none;width:150%"  class="objAco agenda"  id="MB">
                 
                                 <input type="text" value="<%=error%>" style="display:none;width:150%"  class="objAco agenda"  id="error">

</div>
</div>
					
		<script src="/Template/inspina/js/plugins/sheetJs/xlsx.full.min.js"></script>

<script type="application/javascript">


$(document).ready(function() {
	$('#InputScan2'+<%=Pro_ID%>).focus()
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
$('.btnRegresar').click(function(e) {
		e.preventDefault()
		
		var Params = "?CliOC_ID=" + $(this).data("cliocid")
		Params += "&TA_ID=" + $(this).data("taid")   
		Params += "&OC_ID=" + $(this).data("ocid")
		Params += "&Prov_ID=" + $(this).data("provid") 
		Params += "&Cli_ID=" + $(this).data("cliid") 
		$("#Contenido").load("/pz/wms/Recepcion/RecepcionCargaSeries.asp" + Params)
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
		datoAgenda['Pro_ID'] = $('#Pro_ID').val()
        datoAgenda['Cli_ID'] = $('#Cli_ID').val()
		datoAgenda['TA_ID'] = $('#TA_ID').val()
		$("#Contenido").load("/pz/wms/Recepcion/RecepcionResumenPallets.asp",datoAgenda

 , function(data){
	
			});

});


$('.BtnAprobado').click(function(e) {
	e.preventDefault()
	var Pt_ID = $(this).data("ptid")
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
	$('.InputScan2').on('change',function(e) {
	e.preventDefault()
	var datoAgenda = {}
		$('.agenda').each(function(index, element) {
            datoAgenda[$(this).attr('id')] = $(this).val()
        });
	var Pt_ID = $(this).data("ptid")
	var Articulos = $(this).data("artic")
	var Pallets = $(this).data("pallets")
	var totalMB = $(this).data("totalmb")
		var Cantidad_Pallet = $(this).data("cantpallet")
	var Cantidad_MB = $(this).data("cantmb")
		datoAgenda['Tarea'] =1
		datoAgenda['CliOC_ID'] = $('#CliOC_ID').val()
		datoAgenda['OC_ID'] = $('#OC_ID').val()
		datoAgenda['Prov_ID'] = $('#Prov_ID').val()
        datoAgenda['Cli_ID'] = $('#Cli_ID').val()
		datoAgenda['TA_ID'] = $('#TA_ID').val()
		datoAgenda['Pt_ID'] = Pt_ID
		datoAgenda['Pallets'] = Pallets
		datoAgenda['Articulos'] = Articulos
		datoAgenda['MB'] =  $('#MB').val()
		datoAgenda['Cantidad_Pallet'] = Cantidad_Pallet
		datoAgenda['Cantidad_MB'] = Cantidad_MB
		datoAgenda['Pro_ID'] = $('#Pro_ID').val()
		datoAgenda['Ser_Serie'] = $('#InputScan2'+Pt_ID).val()
		datoAgenda['error'] =  $('#error').val()
		$('#InputScan2'+Pt_ID).hide();
		$("#Contenido").load("/pz/wms/Recepcion/RecepcionCargaEscaneo.asp",datoAgenda

    , function(data){
	
			sTipo = "info";
			sMensaje = "La serie se ha guardado correctamente ";
			
				Avisa(sTipo,"Aviso",sMensaje);
	});
	
});
});




       

// Function to download data to a file



</script>
				}
			}
	
		var CliOC_ID = Parametro("CliOC_ID",-1) 
			if(CliOC_ID > -1){
					Ser_ID = BuscaSoloUnDato("ISNULL((MAX(Ser_ID)),0)+1","RecepcionSeries","",-1,0)
			try {
	
					var sSQL = " INSERT INTO RecepcionSeries (CliOC_ID,Ser_ID, Ser_Serie, Cli_ID) "
						sSQL += " VALUES ("+CliOC_ID+","+Ser_ID+","+Ser_Serie+", "+Cli_ID+")"
	
						Ejecuta(sSQL,0)
						
						sResultado = 1
				}
			}catch(err){
					sResultado = -1
			}
		break;  
	
	}
Response.Write(sResultado)
%>
