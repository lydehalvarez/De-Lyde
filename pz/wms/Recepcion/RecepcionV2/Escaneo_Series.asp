<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../../Includes/iqon.asp" -->

<%
	var Tarea = Parametro("Tarea", -1)
    var Id_Usuario = Parametro("ID_Usuario",-1)  
	var CliOC_ID = Parametro("CliOC_ID",-1)
	var OC_ID = Parametro("OC_ID",-1)
	var Prov_ID = Parametro("Prov_ID",-1)
	var TA_ID = Parametro("TA_ID",-1)  
	var Cli_ID = Parametro("Cli_ID",-1)  
	var Pt_ID = Parametro("Pt_ID",-1)
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
                        <legend class="control-label col-md-12" style="text-align: left;"><h1>Folio:&nbsp;<%=Folio%></h1></legend>
                       
                     
                     </div>
                 
                <div style="overflow-y: scroll; height:655px; width: 200;">
                  <input type="text" value="<%=CliOC_ID%>" style="display:none;width:150%" class="objAco agenda"  id="CliOC_ID">
                     <input type="text" value="<%=OC_ID%>" style="display:none;width:150%" class="objAco agenda"  id="OC_ID">
                        <input type="text" value="<%=Prov_ID%>" style="display:none;width:150%" class="objAco agenda"  id="Prov_ID">
                                <input type="text" value="<%=TA_ID%>"  style="display:none;width:150%"  class="objAco agenda"  id="TA_ID">
                               <input type="text" value="<%=Cli_ID%>" style="display:none;width:150%"  class="objAco agenda"  id="Cli_ID">
                    <div class="ibox-content">
                        <div class="table" id= "dvEscaneos">
                     
                               <table class="table">
    <thead>
    <th>Pallet</th>
    	<th>SKU</th>
    	<th>Modelo</th>
    	<th>Color</th>
    	<th>LPN</th>
    	<th>Cantidad</th>
    	    </thead>
    <tbody>	
		<%
			
			 
			 
			  var inputEscan = 'style="display:none;width:150%"'
			  var totalMB = 0
			 switch (parseInt(Tarea)) {
			 case 1:
			 		 var sSQLTr  = "SELECT * FROM Recepcion_Pallet"
        sSQLTr += " WHERE Pt_ID = " + Pt_ID

		   var rsPallet = AbreTabla(sSQLTr,1,0) 
				
			var cantidad = 0
			cantidad = rsPallet.Fields.Item("Pt_Cantidad").Value -1
				sSQLTr = "UPDATE Recepcion_Pallet SET  Pt_Cantidad = "+cantidad+""
				sSQLTr += " WHERE Pt_ID = '"+Pt_ID+"'"
						Ejecuta(sSQLTr, 0)
			 var inputEscan =""
	
	var Ser_Serie = Parametro("Ser_Serie",-1)
   
	var sSQLTr  = "SELECT  RTRIM(Ser_Serie)  as Ser_Serie FROM Recepcion_Series"
        sSQLTr += " WHERE Ser_Serie = '" + Ser_Serie + "'"
	
   var rsSerie = AbreTabla(sSQLTr,1,0) 
	if (!rsSerie.EOF){
		if (rsSerie.Fields.Item("Ser_Serie").Value == Ser_Serie){
			sSQLTr = "UPDATE Recepcion_Series SET Ser_SerieEscaneada = 1, Pt_ID = "+Pt_ID+" WHERE Ser_Serie = '"+Ser_Serie+"'"
				Ejecuta(sSQLTr, 0)
		}
		}else{
			  
	var sSQLTr  = "SELECT * FROM Recepcion_Pallet"
        sSQLTr += " WHERE Pt_ID = " + Pt_ID

		   var rsIncidencia = AbreTabla(sSQLTr,1,0) 
		    if(rsIncidencia.Fields.Item("Pt_Incidencia").Value == null){
		  var incidencia = "" + Ser_Serie
			}
		  else{
		  var incidencia = rsIncidencia.Fields.Item("Pt_Incidencia").Value + ", " + Ser_Serie
		   }
			var incidencia = rsIncidencia.Fields.Item("Pt_Incidencia").Value + ", " + Ser_Serie
		
				sSQLTr = "UPDATE Recepcion_Pallet SET Pt_Incidencia = '"+ incidencia +"' , Pt_Cantidad = "+cantidad+""
				sSQLTr += " WHERE Pt_ID = '"+Pt_ID+"'"
				
						Ejecuta(sSQLTr, 0)
							var Ser_ID = BuscaSoloUnDato("ISNULL((MAX(Ser_ID)),0)+1","Recepcion_Series","",-1,0)
					sSQLTr = "INSERT INTO Recepcion_Series  (Ser_ID, OC_ID, Prov_ID,CliOC_ID, TA_ID, Cli_ID, Pt_ID, Ser_Serie, Ser_SerieEscaneada, Ser_Incidencia)  "
					sSQLTr  += "values("+Ser_ID+"," +OC_ID +"," +Prov_ID +"," +CliOC_ID +"," +TA_ID+", " +Cli_ID+", '"+Pt_ID+"','"+Ser_Serie+"', 1, 1)"
						Ejecuta(sSQLTr, 0)
		}
			 break;
			  case 2:
			  
			 	sSQLTr = "UPDATE Recepcion_Pallet SET Pt_MBRechazados = Pt_MBRechazados + 1 "
				sSQLTr += " WHERE Pt_ID = '"+Pt_ID+"'"
						Ejecuta(sSQLTr, 0)
						break;
	 			 }
		var sSQLTr  = "SELECT * FROM Recepcion_Series"
        sSQLTr += " WHERE Ser_SerieEscaneada = 1 AND  Pt_ID = "+Pt_ID 
		if(CliOC_ID > -1){
			sSQLTr += " AND  CliOC_ID= "+CliOC_ID + " ORDER BY Ser_ID Desc"
			}	if(OC_ID > -1){
		 sSQLTr += "  AND  OC_ID= "+OC_ID + " ORDER BY Ser_ID Desc"
			}if(TA_ID > -1){
			sSQLTr += " AND  TA_ID= "+TA_ID + " ORDER BY Ser_ID Desc"
				}
				 	sSQL = "SELECT *  FROM  Recepcion_Pallet WHERE  Pt_ID= "+Pt_ID+ " " 	/*%>	and ID_UsuarioLinea =  "+Id_Usuario<%*/
					      var rsPallets = AbreTabla(sSQL,1,0)
						
		   var rsSerie = AbreTabla(sSQLTr,1,0) 
			 var Pallet = 0
            while(!rsPallets.EOF){ 
			 var Pt_ID = rsPallets.Fields.Item("Pt_ID").Value 		
			 var Pt_Color = rsPallets.Fields.Item("Pt_Color").Value 
             var Pt_Modelo = rsPallets.Fields.Item("Pt_Modelo").Value 
             var Pt_SKU = rsPallets.Fields.Item("Pt_SKU").Value 
             var Pt_LPN = rsPallets.Fields.Item("Pt_LPN").Value 
			  var Pt_Cantidad = rsPallets.Fields.Item("Pt_Cantidad").Value 
			 Pallet = Pallet +1
			 sSQL = "SELECT Pro_ID FROM Producto WHERE Pro_SKU = '"+Pt_SKU+"'"
			 var rsProID = AbreTabla(sSQL,1,0)
			sSQL = "SELECT Pro_ProdRelacionado, Pro_Cantidad FROM Producto_Relacion where Pro_ID = "+ rsProID.Fields.Item("Pro_ID").Value 	
			var rsMB = AbreTabla(sSQL,1,0)
			var CantidadMB = rsMB.Fields.Item("Pro_Cantidad").Value
			while(!rsMB.EOF){ 
	sSQL = "SELECT Pro_PesoNeto FROM Producto WHERE Pro_ID = "+rsMB.Fields.Item("Pro_ProdRelacionado").Value+" AND Pro_Nombre LIKE 'MasterBox%'"
			var rsPeso =  AbreTabla(sSQL,1,0)
			
			if(!rsPeso.EOF){
			var Peso = rsPeso.Fields.Item("Pro_PesoNeto").Value
			}
			rsMB.MoveNext() 
        }
        rsMB.Close()   
			sSQLTr = "SELECT  count (*) as total  FROM  Recepcion_Series WHERE Ser_SerieEscaneada = 1 " 
				if(CliOC_ID > -1){
			sSQLTr += " AND  CliOC_ID= "+CliOC_ID 
			}	if(OC_ID > -1){
		 sSQLTr += "  AND  OC_ID= "+OC_ID
			}if(TA_ID > -1){
			sSQLTr += " AND  TA_ID= "+TA_ID
				}
				var rsTotal = AbreTabla(sSQLTr,1,0)
				var Pt_Cantidad2 =  rsTotal.Fields.Item("total").Value
        %>	
   
            <tr>
           		 <td><%=Pallet%></td>
                <td><%=Pt_SKU%></td>
                <td><%=Pt_Modelo%></td>
                <td><%=Pt_Color%></td>
                <td><%=Pt_LPN%></td>
                <td><%=Pt_Cantidad%></td>
           

                                     <td class="desc">
 <label class="control-label col-md-3" id="InputPeso<%=Pt_ID%>" style="display:none;width:200%"><strong>Peso Aprox. <%=Peso%> kg</strong></label>   <input type="button"  data-ptid="<%=Pt_ID%>" id="BtnAprobado<%=Pt_ID%>" class="btn btn-primary BtnAprobado"  value= "Aprobar" style="display:none;width:70%"> </input>
                                      <input type="button"  data-ptid="<%=Pt_ID%>"  id="BtnRechazado<%=Pt_ID%>" class="btn btn-danger BtnRechazado" value= "Rechazar"  style="display:none;width:70%"> </input>
                                   <%/*%><input type="text" value=""  data-ovid="<%=OV_ID%>" placeholder="Peso de masterbox" class="form-control InputPeso" id="InputPeso<%=OV_ID%>"/><%*/ if(Pt_Cantidad == 0){ 
							%>
                           <strong> El pallet ya ha sido terminado de escanear </strong>
							<%
							  } else {%>
                                   
                                        <input type="text" value="" <%=inputEscan%>  placeholder="Numero de serie" class="form-control InputScan agenda" id="InputScan<%=Pt_ID%>" data-ptid="<%=Pt_ID%>" data-totalmb="<%=totalMB%>"/>
                                        <p class="small" id="Mensaje<%=Pt_ID%>"></p>
                                        <p class="small" id="SeriePickeada<%=Pt_ID%>"></p>
                                        
                                        <input type="button" value="Escanear masterbox"  data-ptid="<%=Pt_ID%>" id="btnEscanear<%=Pt_ID%>" class="btn btn-info btnEscanear"/><%  } %>
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
    	<th>No. de Serie escaneado</th>
    	
    	    </thead>
    <tbody>
	<%
	     while(!rsSerie.EOF){ 
	%>
            <tr>
                <td><%=rsSerie.Fields.Item("Ser_Serie").Value%></td>
                <%
				
				if(rsSerie.Fields.Item("Ser_Incidencia").Value == 1){
				%>
               <td><input type="button" value="Incidencia" class="btn btn-danger btnIncidencia"/></td> <!--data-serid="%=Ser_ID%>" id="btnIncidencia%=TAA_ID%>"-->
                    <td><input type="text" value=""  style="display:none;width:350%;color:black;" placeholder="Escribe la incidencia" class="form-control InputIncidencia"/></td><!-- data-serid="%=Ser_ID%> id="InputIncidencia %=Ser_ID%>-->
            </tr>
        <%	
				}
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
                <div class="col-md-10">
             <a data-taid="<%=TA_ID%>"  data-ocid= "<%=OC_ID%>"  data-provid= "<%=Prov_ID%>" data-cliocid= "<%=CliOC_ID%>" class="text-muted btnClasificar"><i class="fa fa-inbox"></i>&nbsp;<strong>Ver pallets pendientes</strong></a>          </div>
                <div class="ibox-title">
               <br /> <th>SKU: <%=Pt_SKU%></th><br />
                  <td>Masterbox escaneados: 0/30</td>
                          <table class="table">
    <thead>
        <tr>
            <th class="text-center">Masterbox</th>
            <th>Estatus</th>
           
            
        </tr>
    </thead>
    <tbody>
        <tr>
            <td class="text-center">1</td>
            <td>Articulos con incidencias</td>
           <td><a href="#"><i class="fa fa-ban fa-fw"></i></a></td>
          </td>
        </tr>
		 </tbody>
</table>
                   
                   
                   
                </div>
                </div>
				</div>
</div>
</div>
<script src="/Template/inspina/js/plugins/jquery-ui/jquery-ui.min.js"></script>
<script type="text/javascript">
$(document).ready(function(e) {
	$('.btnClasificar').click(function(e) {
		e.preventDefault()
		
		var Params = "?CliOC_ID=" + $(this).data("cliocid")
		Params += "&TA_ID=" + $(this).data("taid")   
	    Params += "&OC_ID=" + $(this).data("ocid")
		Params += "&Prov_ID=" + $(this).data("provid") 
          

		$("#Contenido").load("/pz/wms/Recepcion/RecepcionPallet.asp" + Params)
		});
	$('#InputScan'+<%=Pt_ID%>).focus()
$('.btnEscanear').click(function(e) {
	e.preventDefault()
	var Pt_ID = $(this).data("ptid")
	$('#InputPeso'+Pt_ID).css('display','block')
	$('#BtnAprobado'+Pt_ID).css('display','block')
	$('#BtnRechazado'+Pt_ID).css('display','block')
		$('#InputScan'+Pt_ID).hide();
<%/*%>	$('#InputPeso'+OV_ID).focus()<%*/%>

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
	$("#dvEscaneos").load("/pz/wms/Recepcion/RecepcionEscaneo_Ajax.asp",datoAgenda
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
	var Pt_ID = $(this).data("ptid")
	var totalMB = $(this).data("totalmb")
		datoAgenda['Tarea'] =1
		datoAgenda['CliOC_ID'] = $('#CliOC_ID').val()
		datoAgenda['OC_ID'] = $('#OC_ID').val()
		datoAgenda['Prov_ID'] = $('#Prov_ID').val()
        datoAgenda['Cli_ID'] = $('#Cli_ID').val()
		datoAgenda['TA_ID'] = $('#TA_ID').val()
		datoAgenda['Pt_ID'] = Pt_ID
		datoAgenda['totalMB'] = totalMB
		datoAgenda['Ser_Serie'] = $('#InputScan'+Pt_ID).val()
		$('#InputScan'+Pt_ID).hide();
		$("#dvEscaneos").load("/pz/wms/Recepcion/RecepcionEscaneo_Ajax.asp",datoAgenda

    , function(data){
	
			sTipo = "info";
			sMensaje = "La serie se ha guardado correctamente ";
			
				Avisa(sTipo,"Aviso",sMensaje);
	});
	
});




 

				
	});
		

</script>            