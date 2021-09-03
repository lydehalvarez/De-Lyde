<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%
	var TA_ArchivoID = Parametro("TA_ArchivoID",-1)
	
	var Transfer = "SELECT * "
		Transfer += " ,(SELECT Alm_Nombre FROM Almacen a WHERE  a.Alm_ID = h.TA_Start_Warehouse_ID) Sucursal_Origen "
		Transfer += " ,(SELECT Alm_Nombre FROM Almacen a WHERE  a.Alm_ID = h.TA_End_Warehouse_ID) Sucursal_Destino "
		Transfer += " ,(SELECT  Alm_TipoDeRutaCG94 FROM Almacen a WHERE  a.Alm_ID = h.TA_End_Warehouse_ID) TipoTienda "
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
                <div style="overflow-y: scroll; height:500px; width: auto;">
                <%
                    var rsTran = AbreTabla(Transfer,1,0)
    
                    while (!rsTran.EOF){
                        var TA_ID = rsTran.Fields.Item("TA_ID").Value 
                        var TipoTienda = rsTran.Fields.Item("TipoTienda").Value 
                        var Articulos = "SELECT *,(SELECT Pro_Nombre FROM Producto WHERE Pro_ID = a.Pro_ID) PRO_NOM "
                            Articulos += " FROM TransferenciaAlmacen_Articulos a"
                            Articulos += " WHERE TA_ID = "+TA_ID
							
                        var rsArt = AbreTabla(Articulos,1,0)
                        var rsArt2 = AbreTabla(Articulos,1,0)
                        var rsArt3 = AbreTabla(Articulos,1,0)
                                
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
                                 		<p> 
                                            <span class="label label-primary">Origen <%=rsTran.Fields.Item("Sucursal_Origen").Value%></span>
                                        </p>
                                        <p> 
                                            <span class="label label-warning">Destino <%=rsTran.Fields.Item("Sucursal_Destino").Value%></span>
                                        </p>
                                        <p>
                                            <span class="label label-success">Folio Cliente <%=rsTran.Fields.Item("TA_FolioCliente").Value%></span>
                                        </p>
                                        <%if(rsTran.Fields.Item("Cli_ID").Value == 6){%>
                                        <p>
                                            <span class="label label-info">Numero de remision <span id="NumFolio_<%=TA_ID%>"></span></span>
                                        </p>
                                        <p>
                                            <span class="label label-info">Numero de ruta <span id="NumRuta_<%=TA_ID%>"></span></span>
                                        </p>
                                        <%}%>
                                        <input type="text" value="" style="display:none;width:50%" data-taid="<%=TA_ID%>" class="form-control InputStartPick" id="InputStartPick<%=TA_ID%>"/>
                                        <p class="small" id="Mensaje<%=TA_ID%>"></p>
                                            <input type="button" value="Empezar pick" data-taid="<%=TA_ID%>" id="btnStartPick<%=TA_ID%>" class="btn btn-info btnStartPick"/>
                                            <input type="button" value="Cancelar pick" style="display:none"  id="btnCancelPick<%=TA_ID%>" class="btn btn-danger btnCancelPick"/>
                                            <input type="button" value="Imprimir Etiqueta"  data-taid="<%=TA_ID%>" class="btn btn-info btnImprimirEtiqueta"/>
										<%if(rsTran.Fields.Item("Cli_ID").Value == 2){%>
                                            <input type="button" value="Imprimir salida"  data-taid="<%=TA_ID%>" class="btn btn-info btnImprimirSalida"/>
                                            <input type="button" value="Imprimir albaran"  data-taid="<%=TA_ID%>" class="btn btn-info btnImprimirAlbaran"/>
                                        <%}%>
<%/*%>                                        <%if(rsTran.Fields.Item("Cli_ID").Value == 6){%>
                                        <input type="button" value="Imprimir Remision" data-tipotienda="<%=TipoTienda%>" data-taid="<%=TA_ID%>"  class="btn btn-success ImprimirRemision"/>
                                        <input type="button" value="ReImprimir Remision" data-nombrefo="<%=rsTran.Fields.Item("TA_Folio").Value%>" data-tipotienda="1" data-taid="<%=TA_ID%>"  class="btn btn-success ReImprimirRemision"/>
                                        <input type="button" value="Envia surtido" data-taid="<%=TA_ID%>"  class="btn btn-success EnviaSurtido"/>
                                        <%}%>
<%*/%>                                    </td>
                                    <td class="desc" style="padding-top: 20px;" width="30%">
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
                                   <strong><%=totalSuma%></strong>
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

$('.btnImprimirSalida').click(function(e) {
	var TA_ID = $(this).data("taid")
	var newWin=window.open("http://wms.lyde.com.mx/pz/wms/Transferencia/SalidaAlmacenDoc.asp?TA_ID="+TA_ID);

});
$('.btnImprimirAlbaran').click(function(e) {
	var TA_ID = $(this).data("taid")
	var newWin=window.open("http://wms.lyde.com.mx/pz/wms/Transferencia/AlbaranDoc.asp?TA_ID="+TA_ID);

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

$('.ImprimirRemision').click(function(e) {
		var TA_ID = $(this).data("taid")
		var tipotienda = $(this).data("tipotienda")
		if(tipotienda == 1){
			TransferenciasFunciones.GetDataGuia(TA_ID,$(this))
		}else{
			Avisa("info","Aviso","Es paqueteria de Elektra")
			TransferenciasFunciones.finishPicking(TA_ID) 
			
		}
		$(this).prop('disabled',true)
});


$('.ReImprimirRemision').click(function(e) {
		var TA_ID = $(this).data("taid")
		var tipotienda = $(this).data("tipotienda")
		var nombrefo = $(this).data("nombrefo")
		TransferenciasFunciones.ReImprimeDoc(TA_ID,0,tipotienda,nombrefo)
		$(this).prop('disabled',true)
});



$('.EnviaSurtido').click(function(e) {
		var TA_ID = $(this).data("taid")
		TransferenciasFunciones.finishPicking(TA_ID)
		$(this).prop('disabled',true)
});




function SeriesTransferencia(datos,Th){
	$.post("/pz/wms/Transferencia/Transferencia_Ajax.asp",datos
    , function(data){
		console.log(data)
		var obj = JSON.parse(data)
		
		Th.val("")
		$('#Cont_'+datos.TA_ID+'_'+obj.TAA_ID).html(obj.con)
		$('#Mensaje'+datos.TA_ID).html(obj.message).css('color','#F00')
//		if(obj.result == 2){
//			TransferenciasFunciones.finishPicking(datos.TA_ID) 
//		}		
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
					TransferenciasFunciones.GeneraRutaDedicada(TA_ID,datos.data.data.folioDocumento)
					TransferenciasFunciones.ImprimeGuia(datos.data.data.pdf,"Remision")
				}else{
					
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
		TransferenciasFunciones.finishPicking(TA_ID)

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
					//$('#NumRuta_'+TA_ID).html()
					var requestFolio = {
						Tarea:7,
						TA_ID:TA_ID,
						TA_FolioRemision:folioDocumento[0],
						TA_FolioRuta:data.data.data.folios[0]
					}
					TransferenciasFunciones.InsertaRemision(requestFolio)
					TransferenciasFunciones.ImprimeGuia(data.data.data.documento,"Hoja de Rura")
				}else{
					
				}
			}
		});
	},
	ReImprimeGuiaAG:function(Paq_ID){
		$.ajax({
			type: 'GET',
			contentType:'application/json',
			url: "http://198.38.94.238:8543/api/ag/GuiaDeEmbarque?Paq_ID="+Paq_ID,
			success: function(datos){
				console.log(datos) 
				if(datos.result == 1){
					TransferenciasFunciones.ImprimeGuia(datos.data.image,"AG")
				}else{
					
				}
			}
		});
	},
	ReImprimeDoc:function(ID,EsOV,Tipo,nombrefo){
		$.ajax({
			type: 'GET',
			contentType:'application/json',
			url: "https://elektra.lydeapi.com/api/Lyde/Elektra/ReImprimeDocs?ID="+ID+"&EsOV="+EsOV+"&Tipo="+Tipo,
			success: function(datos){
				console.log(datos) 
				if(datos.result == 1){
					TransferenciasFunciones.ImprimeGuia(datos.data.data.pdf,"Remision "+nombrefo)
				}else{
					
				}
				$('.ReImprimirRemision').prop('disabled',false)

			}
		});
		
	},ImprimeGuia:function(guia,name) {
			
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
	InsertaRemision:function(request){
		$.post("/pz/wms/Transferencia/Transferencia_Ajax.asp",request
		, function(data){
			console.log(data)
			var obj = JSON.parse(data)
		});
	}
}
</script>