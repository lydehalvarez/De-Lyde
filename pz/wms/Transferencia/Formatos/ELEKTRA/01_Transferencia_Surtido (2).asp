<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../../../Includes/iqon.asp" -->
<%
	var TA_ArchivoID = Parametro("TA_ArchivoID",-1)
	
	var Transfer = "SELECT * "
		Transfer += " ,(SELECT Alm_Nombre FROM Almacen a WHERE  a.Alm_ID = h.TA_Start_Warehouse_ID) Sucursal_Origen "
		Transfer += " ,(SELECT Alm_Numero FROM Almacen a WHERE  a.Alm_ID = h.TA_End_Warehouse_ID) Nume "
		Transfer += " ,(SELECT Alm_Nombre FROM Almacen a WHERE  a.Alm_ID = h.TA_End_Warehouse_ID) Sucursal_Destino "
		Transfer += " ,(SELECT  Alm_TipoDeRutaCG94 FROM Almacen a WHERE  a.Alm_ID = h.TA_End_Warehouse_ID) TipoTienda "
		Transfer += " ,(SELECT [dbo].[fn_CatGral_DameDato](94,Alm_TipoDeRutaCG94) FROM Almacen a WHERE  a.Alm_ID = h.TA_End_Warehouse_ID) Tipo "
		Transfer += " FROM TransferenciaAlmacen h"
		Transfer += " WHERE TA_ArchivoID = "+TA_ArchivoID
     var rsTran = AbreTabla(Transfer,1,0)
	 if(!rsTran.EOF){
		 var TA_TipoTransferenciaCG65 = rsTran.Fields.Item("TA_TipoTransferenciaCG65").Value 
	 }
	
%>
<div class="wrapper wrapper-content animated fadeInRight">
	<div class="row">
        <div class="col-md-12">
        	<div class="form-group">
              <div class="btn-group" role="group" aria-label="Basic example">
                <input type="button" value="Imprimir etiquetas" data-archid="<%=TA_ArchivoID%>" class="btn btn-info btnEtiquetas"/>
                <input type="button" value="Imprimir consolidado" data-archid="<%=TA_ArchivoID%>" class="btn btn-info btnConsolidado"/>
                <input type="button" value="Obtener series" data-archid="<%=TA_ArchivoID%>" class="btn btn-info btnSeries"/>
                <input type="button" value="Direcciones" data-archid="<%=TA_ArchivoID%>" data-tipo="<%=TA_TipoTransferenciaCG65%>" class="btn btn-success btnDirecciones"/>
                </div>
            </div>
            <div class="ibox">
                <div style="overflow-y: scroll; /*height:500px;*/ width: auto;">
                <%
                    var rsTran = AbreTabla(Transfer,1,0)
    
                    while (!rsTran.EOF){
                        var TA_ID = rsTran.Fields.Item("TA_ID").Value 
                        var TipoTienda = rsTran.Fields.Item("TipoTienda").Value 
                        var Articulos = "SELECT *,(SELECT Pro_Nombre FROM Producto WHERE Pro_ID = a.Pro_ID) PRO_NOM "
                            Articulos += " FROM TransferenciaAlmacen_Articulos a"
                            Articulos += " WHERE TA_ID = "+TA_ID
							
							

                        var TA_ID = rsTran.Fields.Item("TA_ID").Value 
							
                        var rsArt = AbreTabla(Articulos,1,0)
                        var rsArt2 = AbreTabla(Articulos,1,0)
                        var rsArt3 = AbreTabla(Articulos,1,0)
                        var rsUbi = AbreTabla(Articulos,1,0)
                                
                %>
                    <div class="ibox-content" id="<%=TA_ID%>">
                        <div class="table-responsive">
                            <table class="table shoping-cart-table">
                                <tbody>
                                <tr>
                                    <td class="desc" width="50%">                                    
                                        <div class="widget style1 navy-bg">
                                             <div class="row vertical-align">
                                                <div class="col-xs-3">
                                                    <i class="fa fa-dropbox fa-2x"></i>
                                                </div>
                                                <div class="col-xs-9 text-right">
                                                    <h3 class="font-bold"><%=rsTran.Fields.Item("TA_Folio").Value%></h3>
                                                </div>
                                            </div>
                                        </div> 
                                        <div class="widget style1 lazur-bg">
                                             <div class="row vertical-align">
                                                <div class="col-xs-3">
                                                    <i class="fa fa-truck fa-2x"></i>
                                                </div>
                                                <div class="col-xs-9 text-right">
                                                    <h3 class="font-bold"><%=rsTran.Fields.Item("Tipo").Value%></h3>
                                                </div>
                                            </div>
                                        </div> 
                                 		<p> 
                                            <span class="label label-primary">Origen <%=rsTran.Fields.Item("Sucursal_Origen").Value%></span>
                                        </p>
                                        <p> 
                                            <span class="label label-primary">Destino <strong><%=rsTran.Fields.Item("Nume").Value%></strong>&nbsp;<%=rsTran.Fields.Item("Sucursal_Destino").Value%></span>
                                        </p>
                                        <p>
                                            <span class="label label-success">Folio Cliente (DO) <%=rsTran.Fields.Item("TA_FolioCliente").Value%></span>
                                        </p>
                                        <p>
                                            <span class="label label-info">Numero de remision <span id="NumFolio_<%=TA_ID%>"></span></span>
                                        </p>
                                        <p>
                                            <span class="label label-info">Numero de ruta <span id="NumRuta_<%=TA_ID%>"></span></span>
                                        </p>
                                        <input type="text" value="" style="display:none;width:50%" data-taid="<%=TA_ID%>" class="form-control InputStartPick" id="InputStartPick<%=TA_ID%>"/>
                                        <p class="small" id="Mensaje<%=TA_ID%>"></p>
                                        <div class="btn-group" role="group" aria-label="Basic example">
                                            <input type="button" value="Empezar pick" data-taid="<%=TA_ID%>" id="btnStartPick<%=TA_ID%>" class="btn btn-info btnStartPick"/>
                                            <input type="button" value="Cancelar pick" style="display:none"  id="btnCancelPick<%=TA_ID%>" class="btn btn-danger btnCancelPick"/>
                                            <input type="button" value="Imprimir Etiqueta"  data-taid="<%=TA_ID%>" class="btn btn-info btnImprimirEtiqueta"/>
                                            <input type="button" value="Env&iacute;ar datos" data-tipotienda="<%=TipoTienda%>" data-taid="<%=TA_ID%>"  class="btn btn-success btnSendData"/>
                                        </div>
                                    </td>
                                            
<%   //seccion de ubicacion 
     // ROG 22-10-2020 linea 118 el rs no correspondia a la carga de la tabla   %>                                      
                                            
                                    <td class="desc" style="padding-top: 20px;" width="8%">
                                    <%
                                        while(!rsUbi.EOF){
                                            var TAA_SKU = rsUbi.Fields.Item("TAA_SKU").Value
											
											var Ubicacion = "EXEC [dbo].[SPR_Ubicacion]  "
												Ubicacion += " @Opcion = 1001 "
												Ubicacion += ", @Pro_SKU = '"+TAA_SKU+"' "
												Ubicacion += ", @Are_ID = 8 "
												Ubicacion += ", @Cli_ID = 6" 
																						
											var rsUbiTabla = AbreTabla(Ubicacion,1,0)
											if(!rsUbiTabla.EOF){
												var Ubi_Nombre = rsUbiTabla.Fields.Item("Ubi_Nombre").Value
												%>		
													<h4><%=Ubi_Nombre%></h4>
												<%	
											}else{
												%>		
													<h4>Sin ubicaci&oacute;n asignada</h4>
												<%	
											}
                                        rsUbi.MoveNext() 
                                    }
                                    rsUbi.Close()   
                                    %>
                                    </td>
<%   // fin seccion de ubicacion  %>                                                  
                                    <td class="desc" style="padding-top: 20px;" width="22%">
                                    <%
                                        while(!rsArt.EOF){
                                            var PRO_NOM = rsArt.Fields.Item("PRO_NOM").Value 
                                    %>		
                                        <h4><%=PRO_NOM%></h4>
                                            
                                    <%	
                                        rsArt.MoveNext() 
                                    }
                                    rsArt.Close()   
                                    %><strong>Total:</strong>
                                    </td>
                                    <td class="desc" style="padding-top: 20px;" width="10%">
                                    <%
									var cantidadTotal = 0
                                        while(!rsArt2.EOF){
                                            var TAA_Cantidad = rsArt2.Fields.Item("TAA_Cantidad").Value 
											cantidadTotal = cantidadTotal + TAA_Cantidad
                                    %>		
                                        <h4><%=TAA_Cantidad%></h4>
                                    <%	
                                        rsArt2.MoveNext() 
                                    }
                                    rsArt2.Close()   
                                    %>
                                    <strong><%=cantidadTotal%></strong>
                                    </td>
                                    <td class="desc" style="padding-top: 20px;" width="10%">
                                    <%
									var totalSuma = 0
										var YaPickeados = 0
                                        while(!rsArt3.EOF){
										 var TAA_ID = rsArt3.Fields.Item("TAA_ID").Value 
										 
											
										var Picked = "SELECT COUNT(TAA_ID) Artis "
											Picked += " FROM TransferenciaAlmacen_Articulo_Picking "
											Picked += " WHERE TA_ID = "+TA_ID
											Picked += " AND TAA_ID = "+TAA_ID
												 
										var rsPicked = AbreTabla(Picked,1,0)
                                        if(!rsPicked.EOF){
										 YaPickeados = rsPicked.Fields.Item("Artis").Value 
										}   

                                    %>		
                                        <h4 id="Cont_<%=TA_ID%>_<%=TAA_ID%>"><%=YaPickeados%></h4>
                                            
                                    <%	
										totalSuma = totalSuma + YaPickeados
                                        rsArt3.MoveNext() 
                                    }
                                    rsArt3.Close()  
                                    %>
                                   	<strong><span id="TotalPickeados_<%=TA_ID%>"><%=totalSuma%></span></strong>
                                    </td>
                                </tr>
                                
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <%	
                        rsTran.MoveNext() 
                    }
                    rsTran.Close()   
                    %>
                </div>
            </div>
        </div>
    </div>
</div>
 
<script src="/Template/inspina/js/plugins/sheetJs/xlsx.full.min.js"></script>
<script type="application/javascript">
$('.btnStartPick').click(function(e) {
	var TA_ID = $(this).data("taid")
	$(this).hide('slow')
    $('#btnCancelPick'+TA_ID).css('display','block')
    $('#InputStartPick'+TA_ID).css('display','block')
    $('#InputStartPick'+TA_ID).focus()
});

$('.btnImprimirEtiqueta').click(function(e) {
	var TA_ID = $(this).data("taid")
	var newWin=window.open("http://wms.lyde.com.mx/pz/wms/Transferencia/EtiquetaTransferencia.asp?TA_ID="+TA_ID);
});
$('.btnEtiquetas').click(function(e) {
	var TA_ID = $(this).data("taid")
	var newWin=window.open("http://wms.lyde.com.mx/pz/wms/Transferencia/EtiquetasTransferencia.asp?TA_ArchivoID="+<%=TA_ArchivoID%>);

});
$('.btnConsolidado').click(function(e) {
	var TA_Archivo = $(this).data("archid")
	var newWin=window.open("http://wms.lyde.com.mx/pz/wms/Transferencia/HojaSurtido.asp?TA_ArchivoID="+TA_Archivo);
});
$('.btnSeries').click(function(e) {
	var TA_Archivo = $(this).data("archid")
	var newWin=window.open("http://wms.lyde.com.mx/pz/wms/Transferencia/SeriesTransferencias.asp?TA_ArchivoID="+TA_Archivo);
});


$('.btnDirecciones').click(function(e) { 
	var TA_ArchivoID = $(this).data('archid')
	var tipo = $(this).data('tipo')
	$.post("/pz/wms/Transferencia/Transferencia_Direccion.asp",{TA_ArchivoID:TA_ArchivoID,TA_TipoTransferenciaCG65:tipo}
    , function(data){
		var response = JSON.parse(data)
		var ws = XLSX.utils.json_to_sheet(response);
		var wb = XLSX.utils.book_new(); XLSX.utils.book_append_sheet(wb, ws, "Sheet1");
		XLSX.writeFile(wb, "Transferencia <%=TA_ArchivoID%>.xlsx");
	});
});


$('.btnCancelPick').click(function(e) {
	var TA_ID = $(this).data("taid")
	$(this).hide('slow')
	$('#btnStartPick'+TA_ID).show('slow')
    $('#InputStartPick'+TA_ID).css('display','none')
});

$('.InputStartPick').on('keypress',function(e) {
    if(e.which == 13) {
		var datos = {
			TA_ID:$(this).data("taid"),
			TAS_Serie:$(this).val(),
			IDUsuario:$('#IDUsuario').val(),
			Tarea:3
		}
		SeriesTransferencia(datos,$(this))
    }
});


$('.btnSendData').click(function(e) {
		var TA_ID = $(this).data("taid")
		var tipotienda = $(this).data("tipotienda")
		if(tipotienda == 1){
			TransferenciasFunciones.GetDataGuia(TA_ID,$(this))
		}else{
			Avisa("info","Aviso","Es paqueteria de Elektra")
			TransferenciasFunciones.finishPicking(TA_ID)
		}
		$(this).prop('disabled',true)
		swal({
		  title: 'Datos enviados',
		  text: "En un momento obtendremos respuesta",
		  type: "success",
		  confirmButtonClass: "btn-success",
		  confirmButtonText: "Ok" ,
		  closeOnConfirm: true,
		  html: true
		},
		function(data){
		});		
});


function SeriesTransferencia(datos,Th){
	$.post("/pz/wms/Transferencia/Transferencia_Ajax.asp",datos
    , function(data){
		console.log(data)
		var obj = JSON.parse(data)
		
		Th.val("")
		$('#Cont_'+datos.TA_ID+'_'+obj.TAA_ID).html(obj.con)
		$('#TotalPickeados_'+obj.TAA_ID).html(obj.Escaneados)
		$('#Mensaje'+datos.TA_ID).html(obj.message).css('color','#F00')
		
	});
}
var TransferenciasFunciones = {
	finishPicking:function(TA_ID){
		$.ajax({
			type: 'post',
			contentType:'application/json',
			url: "https://elektra.lydeapi.com/api/Lyde/Elektra/Surtido?TA_ID="+TA_ID,
			success: function(datos){
				console.log(datos) 
				if(datos.result == 1){
					Avisa("success","Aviso","Remision recibida");
					TransferenciasFunciones.GeneraRutaDedicada(TA_ID,datos.data.data.folioDocumento)
					TransferenciasFunciones.ImprimeGuia(datos.data.data.pdf,"Remision "+datos.data.data.folioDocumento[0])
				}else{
					swal({
					  title: 'Lo sentimos algo sali&oacute; mal',
					  text: "Comunicarse al &aacute;rea de sistemas",
					  type: "warning",
					  confirmButtonClass: "btn-success",
					  confirmButtonText: "Ok" ,
					  closeOnConfirm: true,
					  html: true
					},
					function(data){
					});		

				}
			}
			
		});
	},
	GetDataGuia:function(taid,btn){
		$.post("/pz/wms/Transferencia/Transferencia_Ajax.asp",{
		Tarea:5,
		TA_ID:taid
		}
		, function(data){
			var obj = JSON.parse(data)
			TransferenciasFunciones.PutGuiaAG(taid,obj,btn)
		});
	},
	PutGuiaAG:function(TA_ID,obj,btn){
		var myJSON = JSON.stringify(obj);
		$.ajax({
			type: 'post',
			data: myJSON,
			contentType:'application/json',
			url: "http://198.38.94.238:8543/api/ag/GuiaDeEmbarque",
			success: function(data){
				console.log(data) 
				if(data.result == 1){
					Avisa("success","Aviso","Guia de AG recibida");
					TransferenciasFunciones.ImprimeGuia(data.data.image,"AG")
					TransferenciasFunciones.finishPicking(TA_ID)
					Avisa("success","Aviso","Guia de AG generada");
				}else{
					btn.prop('disabled',false)
				}
			}
		});
	},
	GetGuiaMensajeria:function(TA_ID){
		
	},
	GeneraRutaDedicada:function(TA_ID,folioDocumento){
		var request = {
			TA_ID:TA_ID,
			foliosDocumento:folioDocumento
		}
		var myJSON = JSON.stringify(request);
		console.log(request)
		$.ajax({
			type: 'post',
			data: myJSON,
			contentType:'application/json',
			url: "https://elektra.lydeapi.com/api/Lyde/Elektra/GeneraRuta/Dedicada",
			success: function(data){
				console.log(data) 
				if(data.result == 1){
					var requestFolio = {
						Tarea:7,
						TA_ID:TA_ID,
						TA_FolioRemision:folioDocumento[0],
						TA_FolioRuta:data.data.data.folios[0]
					}
					TransferenciasFunciones.InsertaRemision(requestFolio)
					Avisa("success","Aviso","Hoja de ruta recibida");
					if(data.data.data.folios != null){
						TransferenciasFunciones.ImprimeGuia(data.data.data.documento,"Hoja de ruta "+data.data.data.folios[0])
					}
					data.data.result = requestFolio.TA_ID;
					TransferenciasFunciones.HojaRuta(data.data)
					//$('#NumRuta_'+TA_ID).html()
				}else{
					swal({
					  title: 'Lo sentimos algo sali&oacute; mal con el servicio',
					  text: "Comunicarse al &aacute;rea de sistemas",
					  type: "warning",
					  confirmButtonClass: "btn-success",
					  confirmButtonText: "Ok" ,
					  closeOnConfirm: true,
					  html: true
					},
					function(data){
					});		
				}
			}
		});
	},
	ReImprimeGuia:function(Paq_ID){
		$.ajax({
			type: 'GET',
			contentType:'application/json',
			url: "http://198.38.94.238:8543/api/ag/GuiaDeEmbarque?Paq_ID="+Paq_ID,
			success: function(datos){
				console.log(datos) 
				if(datos.result == 1){
					TransferenciasFunciones.ImprimeGuia(datos.data.image,"AG")
				}
			}
		});
	}
	,ImprimeGuia:function(guia,name) {
			
		var winparams = 'dependent=yes,locationbar=no,scrollbars=yes,menubar=yes,'+
		'resizable,screenX=50,screenY=50,width=850,height=1050';

		var htmlPop = '<title>'+name+'</title> '
						+'<embed width=100% height=100%'
						 + ' type="application/pdf"'
						 + ' src="data:application/pdf;base64,'
						 + guia
						 + '"></embed>'; 

		var printWindow = window.open ("", "_blank", winparams);
		printWindow.document.write (htmlPop);
	},
	ImprimeEtiqueta:function(TA_ID){
		var newWin=window.open("http://wms.lyde.com.mx/pz/wms/Transferencia/EtiquetaTransferencia.asp?TA_ID="+TA_ID);	
	},
	InsertaRemision:function(request){
		$.post("/pz/wms/Transferencia/Transferencia_Ajax.asp",request
		, function(data){
			console.log(data)
			var obj = JSON.parse(data)
		});
	},
	AgForzada:function(taid){
		$.post("/pz/wms/Transferencia/Transferencia_Ajax.asp",{
		Tarea:5,
		TA_ID:taid
		}
		, function(data){
			var obj = JSON.parse(data)
			TransferenciasFunciones.AgGuiaForzada(taid,obj)
		});
	},
	AgGuiaForzada:function(TA_ID,obj){
		var myJSON = JSON.stringify(obj);
		$.ajax({
			type: 'post',
			data: myJSON,
			contentType:'application/json',
			url: "http://198.38.94.238:8543/api/ag/GuiaDeEmbarque",
			success: function(data){
				console.log(data) 
				if(data.result == 1){
					TransferenciasFunciones.ImprimeGuia(data.data.image,"AG")
					Avisa("success","Aviso","Guia de AG generada");
				}else{
					btn.prop('disabled',false)
				}
			}
		});
	},
	HojaRuta:function(Respuesta){
		var myJSON = JSON.stringify(Respuesta);
		$.ajax({
			type: 'post',
			data: myJSON,
			contentType:'application/json',
			url: "https://elektra.lydeapi.com/api/Lyde/Elektra/RespuestaRuta",
			success: function(data){
				console.log(data) 
				if(data.result == 1){
					Avisa("success","Aviso","Hoja de Ruta guardada");
				}
			}
		});
	}
}
</script>