<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->

<%
    var Id_Usuario = Parametro("ID_Usuario",-1)  
	var CliOC_ID = Parametro("CliOC_ID",1)
	var TA_ID = Parametro("TA_ID",-1)  
if(CliOC_ID > -1){
	var sSQL = "SELECT c.CliOC_Folio FROM Cliente_OrdenCompra WHERE a.CliOC_ID = "+CliOC_ID
   var rsArt = AbreTabla(sSQL,1,0)
	var Folio =  rsArt.Fields.Item("CliOC_Folio").Value
	}else{
	var sSQL = "SELECT t.TA_Folio FROM TransferenciaAlmacen WHERE a.TA_ID = "+TA_ID
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
                <%
     
                %>
                    <div class="ibox-content" id="">
                        <div class="table-responsive">
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
			if(CliOC_ID > -1){
			 	sSQL = "SELECT *  FROM  Recepcion_Pallet WHERE  CliOC_ID= "+CliOC_ID+ " WHERE ID_UsuarioLinea =  "+Id_Usuario
			}else{
				 	sSQL = "SELECT  *  FROM  Recepcion_Pallet WHERE TA_ID= "+TA_ID+ "  WHERE ID_UsuarioLinea =  "+Id_Usuario
				}
	         var rsPallets = AbreTabla(sSQL,1,0)
			 var Pallet = 0
        
			 var Pt_Color = rsPallets.Fields.Item("Pt_Color").Value 
             var Pt_Modelo = rsPallets.Fields.Item("Pt_Modelo").Value 
             var Pt_SKU = rsPallets.Fields.Item("Pt_SKU").Value 
             var Pt_LPN = rsPallets.Fields.Item("Pt_LPN").Value 
			  var Pt_Cantidad = rsPallets.Fields.Item("Pt_Cantidad").Value 
			 Pallet = Pallet +1
        %>	
    
            <tr>
           		 <td><%=Pallet%></td>
                <td><%=Pt_SKU%></td>
                <td><%=Pt_Modelo%></td>
                <td><%=Pt_Color%></td>
                <td><%=Pt_LPN%></td>
                <td><%=Pt_Cantidad%></td>
           

                                     <td class="desc">
                                    <label class="control-label col-md-3" id="InputPeso<%=OV_ID%>" style="display:none;width:150%"><strong>Rango de peso 5,500 - 6,000 g</strong></label>   <input type="button"  data-ovid="<%=OV_ID%>" id="BtnAprobado<%=OV_ID%>" class="btn btn-primary BtnAprobado"  value= "Aprobar" style="display:none;width:70%"> </input>
                                      <input type="button"  data-ovid="<%=OV_ID%>"  id="BtnRechazado<%=OV_ID%>" class="btn btn-danger BtnRechazado"  id="BtnRechazado" value= "Rechazar"  style="display:none;width:70%"> </input>
                                   <%/*%><input type="text" value="" style="display:none;width:150%" data-ovid="<%=OV_ID%>" placeholder="Peso de masterbox" class="form-control InputPeso" id="InputPeso<%=OV_ID%>"/><%*/%>
                                        <input type="text" value="" style="display:none;width:150%" placeholder="Numero de serie" class="form-control InputScan" id="InputScan<%=OV_ID%>"/>
                                        <p class="small" id="Mensaje<%=OV_ID%>"></p>
                                        <p class="small" id="SeriePickeada<%=OV_ID%>"></p>
                                        <input type="button" value="Escanear pallet"  id="btnEscanear" class="btn btn-info btnEscanear"/>
   </td>
                                </tr>
                                </tbody>
                            </table>
                                                <%

	var TA_ID = Parametro("TA_ID",1)
   
	var sSQLTr  = "SELECT TA_ID,TAA_ID,(SELECT Ta_Folio FROM [dbo].[TransferenciaAlmacen] WHERE TA_ID = p.TA_ID) Folio"
		sSQLTr += " ,(SELECT Pro_Nombre FROM Producto WHERE Pro_ID = p.Pro_ID) Producto ,TAA_SKU,TAA_Cantidad "
        sSQLTr += " FROM TransferenciaAlmacen_Articulos p"
        sSQLTr += " WHERE TA_ID = " + TA_ID

	    bHayParametros = false
	    ParametroCargaDeSQL(sSQLTr,0) 
%>

                            <table class="table">
    <thead>
    	<th>No. de Serie escaneado</th>
    	
    	    </thead>
    <tbody>
		<%
			var TotalSol = 0
			var TotalEnv = 0
			var rsPicked = AbreTabla(sSQLTr,1,0)
            while(!rsPicked.EOF){ 
			 var TAA_ID = rsPicked.Fields.Item("TAA_ID").Value 
             var Folio = rsPicked.Fields.Item("Folio").Value 
             var Producto = rsPicked.Fields.Item("Producto").Value 
             var TAA_SKU = rsPicked.Fields.Item("TAA_SKU").Value 
             var TAA_Cantidad = rsPicked.Fields.Item("TAA_Cantidad").Value 
			 
			 var Enviado = "SELECT COUNT(*) Enviada FROM TransferenciaAlmacen_Articulo_Picking WHERE TA_ID = "+TA_ID +" AND TAA_ID = "+TAA_ID
			var rsEnv = AbreTabla(Enviado,1,0)
			if(!rsPicked.EOF){ 
			 var Total_Enviado = rsEnv.Fields.Item("Enviada").Value 
			}
			var TotalSol = TotalSol +TAA_Cantidad
			var TotalEnv = TotalEnv + Total_Enviado
        %>		
            <tr>
                <td>423422443255567635</td>
               <td><input type="button" value="Agregar Incidencia" data-ovid="<%=TAA_ID%>" id="btnIncidencia<%=TAA_ID%>" class="btn btn-info btnIncidencia"/></td>
                    <td><input type="text" value=""  style="display:none;width:350%;color:black;" data-ovid="<%=TAA_ID%>"  placeholder="Escribe la incidencia" class="form-control InputIncidencia" id="InputIncidencia<%=TAA_ID%>"/></td>
            </tr>
        <%	
            rsPicked.MoveNext() 
        }
        rsPicked.Close()   
		%>
           
    </tbody>
</table>
                        </div>
                    </div>
                    <%}
                        rsOrd.MoveNext() 
                    }
                    rsOrd.Close()   
                    %>
                </div>

            </div>
       
        </div>
    </div>    

       <div class="col-md-3">
            <div class="ibox">
                <div class="ibox-title">
                <th>SKU: 234H2389U5328</th><br />
                  <td>Masterbox escaneados: 5/30</td>
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
	
	$('.btnImprimirEtiqueta').click(function(e) {
		e.preventDefault()
		var newWin = window.open("http://wms.lyde.com.mx/pz/wms/OV/Etiqueta.asp?OV_ID="+$(this).data("ovid"))
	});
	$('.btnEtiquetasTotal').click(function(e) {
		e.preventDefault()
		console.log ($(this))
		var newWin = window.open("http://wms.lyde.com.mx/pz/wms/OV/Todas_Etiqueta.asp?Cort_ID="+<%=Cort_ID%>)
	});
	
	$('.btnImprimirSalida').on('click',function(e){
		e.preventDefault()
		var newWin = window.open("http://wms.lyde.com.mx/pz/wms/OV/HojaRemision.asp?OV_ID="+$(this).data("ovid"))
	});
	
	
});
$('.btnEscanear').click(function(e) {
	e.preventDefault()
	var OV_ID = $(this).data("ovid")
	$('#InputPeso'+OV_ID).css('display','block')
	$('#BtnAprobado'+OV_ID).css('display','block')
	$('#BtnRechazado'+OV_ID).css('display','block')
<%/*%>	$('#InputPeso'+OV_ID).focus()<%*/%>

});
$('.btnIncidencia').click(function(e) {
	e.preventDefault()
	var TAA_ID = $(this).data("ovid")
	$('#InputIncidencia'+TAA_ID).css('display','block')

});
$('.InputIncidencia').on('change',function(e) {
	e.preventDefault()
	var TAA_ID = $(this).data("ovid")
 $("#InputIncidencia"+TAA_ID).hide();
	
});
$('.BtnAprobado').click(function(e) {
	e.preventDefault()
	var OV_ID = $(this).data("ovid")
	$('#InputScan'+OV_ID).css('display','block')
    $("#InputPeso"+OV_ID).hide();
	$("#BtnAprobado"+OV_ID).hide();
    $("#BtnRechazado"+OV_ID).hide();
});
$('.BtnRechazado').click(function(e) {
	e.preventDefault()
	var OV_ID = $(this).data("ovid")
	    $("#InputPeso"+OV_ID).hide();
	$("#BtnAprobado"+OV_ID).hide();
    $("#BtnRechazado"+OV_ID).hide();
});
$('.InputPeso').on('change',function(e) {
	e.preventDefault()
	var OV_ID = $(this).data("ovid")
	$('#InputScan'+OV_ID).css('display','block')
	
});

$('.btnPrueba').click(function(e) {
	e.preventDefault()
	var OV_ID = $(this).data("ovid")
	//finishPicking(OV_ID)
});
$('.btnEnviarShipping').click(function(e) {
	e.preventDefault()
	var OV_ID = $(this).data("ovid")
	Shipping(OV_ID)
});
$('.btnEnviarTransito').click(function(e) {
	e.preventDefault()
	var OV_ID = $(this).data("ovid")
	Trnasit(OV_ID)
});



$('.InputStartPick').on('keypress',function(e) {
    if(e.which == 13) {
		var datos = {
			OV_ID:$(this).data("ovid"),
			OVP_Serie:$(this).val(),
			IDUsuario:$('#IDUsuario').val(),
			Tarea:5,
			Cli_ID:2,
			Limite:$('#Limiteishon'+$(this).data("ovid")).val()
		}
		Picked(datos,$(this))
    }
});

$('.btnImprimirConsolidado').click(function(e){
	e.preventDefault()
	var newWin = window.open("http://wms.lyde.com.mx/pz/wms/OV/HojaSurtido.asp?Cort_ID=<%=Cort_ID%>")
});


 
function Picked(dato,input){
	$.post("/pz/wms/OV/OV_Ajax.asp",dato,function(data){
		var response = JSON.parse(data)
		//$('#Esperado').val(response.Esperado)
		//$('#OVP_Dupla').val(response.OVP_Dupla)
		console.log(response)
		input.val("")
		
		if(response.result == 1 || response.result == 10){
		$('#SeriePickeada'+dato.OV_ID).append(dato.OVP_Serie+"<br>")
		$('#Cont_'+response.OV_ID+'_'+response.OVA_ID).html(response.OVP_ID).css('color','#6C6')
		}else{
			$('#SeriePickeada'+dato.OV_ID).append(dato.message).css('color','red')
		}
		if(response.result == 10){
			
			input.prop('disabled',true)
			finishPicking(response.OV_ID,response,input)
		}
	});
}

function finishPicking(OV_ID,response,input){
	
		var data = {
			"Tarea":1,
			"OV_ID":OV_ID
		}
	var myJSON = JSON.stringify(data);
	
		$.ajax({
			type: 'post',
			contentType:'application/json',
			data: myJSON,
			url: "http://198.38.94.238:1117/lyde/api/ServiceZZ",
			success: function(datos){
				console.log(datos) 
				if(datos.data.Result.result != 11){
					$('#bg_'+response.OV_ID).addClass(response.Background)	 
				}else{
//				console.log(datos.data.Result)
//				console.log(datos.data.Result.result)
//				var respuesta = datos.data.Result.result
				var mensage = datos.data.Result.message
				$('#bg_'+response.OV_ID).addClass("bg-danger")	 
				var jsonMessage = JSON.parse(mensage)
					swal({
					  title: "Detener folio",
					  text: "Error Izzi "+jsonMessage.code+" "+jsonMessage.message,
					  type: "error",
					  showCancelButton: true,
					  confirmButtonClass: "btn-success",
					  confirmButtonText: "Ok" ,
					  closeOnConfirm: true,
					  html: true
					},
					function(data){
						input.prop('disabled',false)
						$.post("/pz/wms/OV/OV_Ajax.asp",{
							Tarea:11,
							OV_ID:response.OV_ID
							},function(data){
								console.log("Picking borrado OV_ID = "+response.OV_ID)
						});
					});		
				}
				
				
				
			}
		});
	
}
function Shipping(OV_ID){
	
		var data = {
			"Tarea":3,
			"OV_ID":OV_ID,
			"Estatus":4,
			"Guia":"",
			"Transportista":""
		}
	var myJSON = JSON.stringify(data);
	
		$.ajax({
			type: 'post',
			contentType:'application/json',
			data: myJSON,
			url: "http://198.38.94.238:1117/lyde/api/ServiceZZ",
			success: function(datos){
				console.log(datos) 
				
			}
		});
	
}
function Trnasit(OV_ID){
	
		var data = {
			"Tarea":3,
			"OV_ID":OV_ID,
			"Estatus":5,
			"Guia":"",
			"Transportista":""
		}
	var myJSON = JSON.stringify(data);
	
		$.ajax({
			type: 'post',
			contentType:'application/json',
			data: myJSON,
			url: "http://198.38.94.238:1117/lyde/api/ServiceZZ",
			success: function(datos){
				console.log(datos) 
				
			}
		});
	
}


</script>            