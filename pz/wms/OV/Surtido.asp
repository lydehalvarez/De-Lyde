<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->

<%

	var Cort_ID = Parametro("Cort_ID","")
	var Ordenes = "SELECT * "
		Ordenes += " FROM Orden_Venta h"
		Ordenes += " WHERE Cort_ID = "+Cort_ID 
		Ordenes += " AND OV_Test = 1"
		Ordenes += " AND OV_Cancelada = 0"
		Ordenes += " AND OV_CUSTOMER_NAME is not null "
		Ordenes += " ORDER BY (SELECT TOP 1 OVA_PART_NUMBER FROM [dbo].[Orden_Venta_Articulo] WHERE OV_ID = h.OV_ID) DESC"
			
%>

<div class="form-horizontal" id="toPrint">
    <div class="row">
        <div class="col-lg-12">
            <div class="ibox float-e-margins">
                <div class="ibox-content">
                    <div class="form-group">
                        <legend class="control-label col-md-12" style="text-align: right;"><h1>Corte&nbsp;<%=Cort_ID%></h1></legend>
                     </div>
                    <div class="form-group">
                      <div class="col-lg-12"  style="text-align: right;">
                            <input type="button" class="btn btn-success btnEtiquetasTotal" value="Imprimir Etiquetas"/>
                            <input type="button" class="btn btn-success btnImprimirConsolidado" value="Imprimir consolidado"/>
                      </div>
                     </div>
                <div style="overflow-y: scroll; height:655px; width: auto;">
                <%
                    var rsOrd = AbreTabla(Ordenes,1,0)
    
                    while (!rsOrd.EOF){
                        var OV_ID = rsOrd.Fields.Item("OV_ID").Value 
                        var OV_Folio = rsOrd.Fields.Item("OV_Folio").Value 
						var background = rsOrd.Fields.Item("OV_EstatusCG51").Value 
						var fondo = ""
						if(background > 1){
							fondo = "bg-success"
						}
						
						var Articulos = "SELECT * "
							Articulos += " ,(SELECT OV_Folio FROM Orden_Venta p WHERE p.OV_ID = a.OV_ID) Folio"
							Articulos += " ,ISNULL((SELECT ISNULL(Pro_Nombre,'') FROM Producto p WHERE p.Pro_ClaveAlterna = a.OVA_PART_NUMBER),'') PRO_NOM"
							Articulos += " FROM Orden_Venta_Articulo a"
							Articulos += " WHERE OV_ID = "+OV_ID

                        var rsArt = AbreTabla(Articulos,1,0)
                        var rsArt2 = AbreTabla(Articulos,1,0)
                        var rsArt3 = AbreTabla(Articulos,1,0)
						
					if(rsArt.Fields.Item("PRO_NOM").Value != ""){
                                
                %>
                    <div class="ibox-content <%=fondo%>" id="bg_<%=OV_ID%>">
                        <div class="table-responsive">
                            <table class="table shoping-cart-table">
                                <tbody>
                                <tr>
                                    <td class="desc">
                                        <h3 class="text-navy">  
                                            <%=rsOrd.Fields.Item("OV_Folio").Value%>
                                        </h3>
                                        <input type="text" value="" style="display:none;width:50%" data-ovid="<%=OV_ID%>" placeholder="Numero de serie" class="form-control InputStartPick" id="InputStartPick<%=OV_ID%>"/>
                                        <p class="small" id="Mensaje<%=OV_ID%>"></p>
                                        <p class="small" id="SeriePickeada<%=OV_ID%>"></p>
                                        <input type="button" value="Empezar pick" data-ovid="<%=OV_ID%>" id="btnStartPick<%=OV_ID%>" class="btn btn-info btnStartPick"/>
                                        <input type="button" value="Cancelar pick" style="display:none"  id="btnCancelPick<%=OV_ID%>" class="btn btn-danger btnCancelPick"/>
                                        <input type="button" value="Imprimir salida"  data-ovid="<%=OV_ID%>" class="btn btn-info btnImprimirSalida"/>
                                        <input type="button" value="Imprimir etiqueta"  data-ovid="<%=OV_ID%>" class="btn btn-info btnImprimirEtiqueta"/>
<!--                                        <input type="button" value="Transito"  data-ovid="<%=OV_ID%>" class="btn btn-info btnEnviarTransito"/>
-->                                    </td>
                                    <td class="desc">
                                    <%
                                        while(!rsArt.EOF){
                                            var PRO_NOM = rsArt.Fields.Item("PRO_NOM").Value 
                                    %>		
                                        <h4><%=PRO_NOM%></h4>
                                    <%	
                                        rsArt.MoveNext() 
                                    }
                                    rsArt.Close()   
                                    %>
                                    </td>
                                    <td class="desc">
                                    <h3>Cantidad</h3>
                                    <%
									var Limiteishon = 0
                                        while(!rsArt2.EOF){
										Limiteishon++
                                            var OVA_Cantidad = 1 
                                    %>		
                                        <h4><%=OVA_Cantidad%></h4>
                                            
                                    <%	
                                        rsArt2.MoveNext() 
                                    }
                                    rsArt2.Close()   
                                    %>
                                    </td>
                                    <input type="hidden" id="Limiteishon<%=OV_ID%>" value="<%=Limiteishon%>"/>
                                    <td class="desc">
                                    <h3>Escaneados</h3>
                                    <%
                                        while(!rsArt3.EOF){ 
										 var OVA_ID = rsArt3.Fields.Item("OVA_ID").Value 
										 
											var Picked = "SELECT COUNT(OVP_ID) Artis "
												Picked += " FROM Orden_Venta_Picking "
												Picked += " WHERE OV_ID = "+OV_ID
												Picked += " AND OVA_ID = "+OVA_ID
												 
										var rsPicked = AbreTabla(Picked,1,0)
										var YaPickeados = 0
                                        if(!rsPicked.EOF){
										 YaPickeados = rsPicked.Fields.Item("Artis").Value 
										}   
												
										
										
                                    %>		
                                        <h4 id="Cont_<%=OV_ID%>_<%=OVA_ID%>"><%=YaPickeados%></h4>
                                            
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
                    <%}
                        rsOrd.MoveNext() 
                    }
                    rsOrd.Close()   
                    %>
                </div>

            </div>
        </div>
    </div>    
</div>
<input type="hidden" id="OVP_Dupla" value=""/>
<input type="hidden" id="Esperado" value=""/>
<script type="text/javascript">
$(document).ready(function(e) {
	
	$('.btnImprimirEtiqueta').click(function(e) {
		e.preventDefault()
		var newWin = window.open("http://qawms.lyde.com.mx/pz/wms/OV/Etiqueta.asp?OV_ID="+$(this).data("ovid"))
	});
	$('.btnEtiquetasTotal').click(function(e) {
		e.preventDefault()
		console.log ($(this))
		var newWin = window.open("http://qawms.lyde.com.mx/pz/wms/OV/Todas_Etiqueta.asp?Cort_ID="+<%=Cort_ID%>)
	});
	
	$('.btnImprimirSalida').on('click',function(e){
		e.preventDefault()
		var newWin = window.open("http://qawms.lyde.com.mx/pz/wms/OV/HojaRemision.asp?OV_ID="+$(this).data("ovid"))
	});
	
	
});
$('.btnStartPick').click(function(e) {
	e.preventDefault()
	var OV_ID = $(this).data("ovid")
	$('#InputStartPick'+OV_ID).css('display','block')
	$('#InputStartPick'+OV_ID).focus()
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