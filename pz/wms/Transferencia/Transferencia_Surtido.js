

$('.InputStartPick').hide()
$('.btnCancelPick').hide()

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

$('.btnStartPick').click(function(e) {
	var TA_ID = $(this).data("taid")
	$(this).hide('slow')
    $('#btnCancelPick'+TA_ID).show('slow')
    $('#InputStartPick'+TA_ID).show('slow')
    $('#InputStartPick'+TA_ID).focus()
});

$('.btnCancelPick').click(function(e) {
	var TA_ID = $(this).data("taid")
	$(this).hide('slow')
	console.log(TA_ID)
	$('#btnStartPick'+TA_ID).show('slow')
    $('#InputStartPick'+TA_ID).hide('slow')
});

$('.InputStartPick').on('keypress',function(e) {
    if(e.which == 13) {
		var DatoIngreso = $(this).val();
		var EsSKU = 0;
		if(DatoIngreso.substr(0,3) == "+C1"){
			EsSKU = 1
			DatoIngreso = DatoIngreso.substr(3,100)
		}
		if((DatoIngreso.length == 8) || (DatoIngreso.length == 6)){
			EsSKU = 1
		}
		console.log(DatoIngreso)
		var datos = {
			TA_ID:$(this).data("taid"),
			TAS_Serie:DatoIngreso,
			IDUsuario:$('#IDUsuario').val(),
			Tarea:3,
			EsSKU:EsSKU
		}
		console.log(datos)
		SeriesTransferencia(datos,$(this))
    }
});

$('.btnImprimirEtiqueta').click(function(e) {
	var TA_ID = $(this).data("taid")
	var newWin=window.open("/pz/wms/Transferencia/EtiquetaTransferencia.asp?TA_ID="+TA_ID);
});
$('.btnEtiquetas').click(function(e) {
	var TA_Archivo = $(this).data("archid")
	var newWin=window.open("/pz/wms/Transferencia/EtiquetasTransferencia.asp?TA_ArchivoID="+TA_Archivo);

});
$('.btnConsolidado').click(function(e) {
	var TA_Archivo = $(this).data("archid")
	var newWin=window.open("/pz/wms/Transferencia/HojaSurtido.asp?TA_ArchivoID="+TA_Archivo);
});
$('.btnSeries').click(function(e) {
	var TA_Archivo = $(this).data("archid")
	var newWin=window.open("/pz/wms/Transferencia/SeriesTransferencias.asp?TA_ArchivoID="+TA_Archivo);
});

$('.btnImprimirSalida').click(function(e) {
	var TA_ID = $(this).data("taid")
	var newWin=window.open("/pz/wms/Transferencia/SalidaAlmacenDoc.asp?TA_ID="+TA_ID);

});
$('.btnImprimirAlbaran').click(function(e) {
	var TA_ID = $(this).data("taid")
	var newWin=window.open("/pz/wms/Transferencia/AlbaranDoc.asp?TA_ID="+TA_ID);

});


$('.btnDirecciones').click(function(e) { 
	var TA_ArchivoID = $(this).data('archid')
	var tipo = $(this).data('tipo')
	$.post("/pz/wms/Transferencia/Transferencia_Direccion.asp",{TA_ArchivoID:TA_ArchivoID,TA_TipoTransferenciaCG65:tipo}
    , function(data){
		var response = JSON.parse(data)
		var ws = XLSX.utils.json_to_sheet(response);
		var wb = XLSX.utils.book_new(); XLSX.utils.book_append_sheet(wb, ws, "Sheet1");
		XLSX.writeFile(wb, "Transferencia "+TA_ArchivoID+".xlsx");
	});
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




//function SeriesTransferencia(datos,Th){
//	var myJSON = JSON.stringify(datos); 
//	$.ajax({
//		type: 'POST',
//		data: myJSON,
//		contentType:'application/json',
//		url: "https://wms.lydeapi.com/api/wms/picking/transferencias",
//		success: function(response){
//			var color = ""
//				var TAA_ID = 0
//				var TA_ID = 0
//				var Total = 0
//				var Contador = 0
//			
//			if(response.result == 1){
//				TAA_ID = response.data.TAA_ID
//				TA_ID = datos.TA_ID
//				Total = response.data.Escaneados
//				Contador = response.data.con
//
//				$('#Cont_'+TA_ID+'_'+TAA_ID).html(Contador)
//				$('#Cont_final_'+TA_ID+'_'+TAA_ID).html(Total)
//				
//			}else if(response.result == 2){
//				TAA_ID = response.data.TAA_ID
//				TA_ID = datos.TA_ID
//				Total = response.data.Escaneados
//				Contador = response.data.con
//				
//				$('#Cont_'+TA_ID+'_'+TAA_ID).html(Contador)
//				$('#Cont_final_'+TA_ID+'_'+TAA_ID).html(Total)
//				$('#'+TA_ID).css("background","#55a741")
//			}else{
//				color = "#ff0707"
//				swal({
//				  title: "UPS",
//				  text: response.message,
//				  type: "warning",
//				  confirmButtonClass: "btn-success",
//				  confirmButtonText: "Ok" ,
//				  closeOnConfirm: true,
//				  html: true
//				},
//				function(data){
//				});		
//			}
//			$('#Mensaje'+datos.TA_ID).html(response.message).css('color',color)
//			Th.val("")
//		}
//	});
//	
//	
////	
////	$.post("/pz/wms/Transferencia/Transferencia_Ajax.asp",datos
////    , function(data){
////		console.log(data)
////		var obj = JSON.parse(data)
////		var color = "#0ea913" 
////		if(obj.result == 1){
////			$('#Cont_'+datos.TA_ID+'_'+obj.TAA_ID).html(obj.con)
////			$('#Cont_final_'+datos.TA_ID+'_'+obj.TAA_ID).html(obj.Escaneados)
////		}else if(obj.result == 2){
////			$('#Cont_'+datos.TA_ID+'_'+obj.TAA_ID).html(obj.con)
////			$('#Cont_final_'+datos.TA_ID+'_'+obj.TAA_ID).html(obj.Escaneados)
////			$('#'+TA_ID).css("background","#55a741")
////		}else{
////			color = "#ff0707"
////			swal({
////			  title: "UPS",
////			  text: obj.message,
////			  type: "warning",
////			  confirmButtonClass: "btn-success",
////			  confirmButtonText: "Ok" ,
////			  closeOnConfirm: true,
////			  html: true
////			},
////			function(data){
////			});		
////		}
////		$('#Mensaje'+datos.TA_ID).html(obj.message).css('color',color)
////		Th.val("")
//////		Th.val("")
//////		$('#Cont_'+datos.TA_ID+'_'+obj.TAA_ID).html(obj.con)
//////		$('#TotalPickeados_'+obj.TAA_ID).html(obj.Escaneados)
//////		$('#Mensaje'+datos.TA_ID).html(obj.message).css('color','#F00')
////		
////	});
//}

function SeriesTransferencia(datos,Th){
	setTimeout(function(){Th.val("")},150)
	var myJSON = JSON.stringify(datos); 
	$.ajax({
		type: 'POST',
		data: myJSON,
		contentType:'application/json', 
		url: "https://wms.lydeapi.com/api/s2012/WMS/Picking/Transferencias/QA",
//		url: "http://192.168.254.10:8081/api/s2012/WMS/Picking/Transferencias",
		success: function(response){
			console.log(response)
			var color = ""
				var TAA_ID = 0
				var TA_ID = 0
				var Total = 0
				var Contador = 0
			
			if(response.result == 1){
				TAA_ID = response.data.TAA_ID
				TA_ID = datos.TA_ID
				Total = response.data.Escaneados
				Contador = response.data.con
 
				$('#Cont_'+TA_ID+'_'+TAA_ID).html(Contador)
				$('#Cont_'+TA_ID+'_'+response.data.Serie).html(Contador)
				$('#Cont_final_'+TA_ID).html(Total)
				TransferenciasFunciones.RecienEscaneado(TA_ID,TAA_ID);
			}else if(response.result == 2){
				TAA_ID = response.data.TAA_ID
				TA_ID = datos.TA_ID
				Total = response.data.Escaneados
				Contador = response.data.con
				
				TransferenciasFunciones.RecienEscaneado(TA_ID,TAA_ID);
				
				$('#Cont_'+TA_ID+'_'+TAA_ID).html(Contador)
				$('#Cont_'+TA_ID+'_'+response.data.Serie).html(Contador)
				$('#Cont_final_'+TA_ID).html(Total)
				$('#'+TA_ID).addClass('bg-primary');
				$('.table_'+TA_ID).css('color','#000')   
			}else{
				color = "#ff0707"
				swal({
				  title: "UPS",
				  text: response.message,
				  type: "warning",
				  confirmButtonClass: "btn-success",
				  confirmButtonText: "Ok" ,
				  closeOnConfirm: true,
				  html: true
				},
				function(data){
				});		
			}
			$('#Mensaje'+datos.TA_ID).html(response.message).css('color',color)
		}
		,error: function(){
			swal({
			  title: "UPS",
			  text: "Verfica la conexi&oacute;n de internet",
			  type: "warning",
			  confirmButtonClass: "btn-success",
			  confirmButtonText: "Ok" ,
			  closeOnConfirm: true,
			  html: true
			});		 
		}
	});
	
}



var TransferenciasFunciones = {
	RecienEscaneado:function(TA_ID,TAA_ID){
		$('#Renglon_'+TA_ID+'_'+TAA_ID).addClass('bg-primary');
		setTimeout(function(){$('#Renglon_'+TA_ID+'_'+TAA_ID).removeClass('bg-primary') },850)
	}
	,finishPicking:function(TA_ID){
		$.ajax({
			type: 'post',
			contentType:'application/json',
			url: "https://elektra.lydeapi.com/api/Lyde/QA/Surtido?TA_ID="+TA_ID,
			//url: "https://elektra.lydeapi.com/api/Lyde/Elektra/Surtido?TA_ID="+TA_ID,
			success: function(datos){
				console.log(datos) 
				if(datos.result == 1){
					Avisa("success","Aviso","Remision recibida");
					TransferenciasFunciones.GeneraRutaDedicada(TA_ID,datos.data.data.folioDocumento)
					TransferenciasFunciones.ImprimeGuia(datos.data.data.pdf,"Remision "+datos.data.data.folioDocumento[0])
				}else{
					var texto = "Comunicarse al &aacute;rea de sistemas"
					if(datos.message != null){
						texto = datos.message
					}
					swal({
					  title: 'Lo sentimos algo sali&oacute; mal',
					  text: texto,
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
					//TransferenciasFunciones.ImprimeGuia(data.data.image,"AG")
					TransferenciasFunciones.finishPicking(TA_ID)
					Avisa("success","Aviso","Guia de AG generada");
				}else{
					btn.prop('disabled',false)
				}
			}
		});
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
					//TransferenciasFunciones.InsertaRemision(requestFolio)
					Avisa("success","Aviso","Hoja de ruta recibida");
					if(data.data.data.folios != null){
						TransferenciasFunciones.ImprimeGuia(data.data.data.documento,"Hoja de ruta "+data.data.data.folios[0])
					}
					data.data.result = requestFolio.TA_ID;
					TransferenciasFunciones.HojaRuta(data.data)
					//$('#NumRuta_'+TA_ID).html()
				}else{
					swal({
					  title: 'Lo sentimos algo sali&oacute; mal con el servicio de elektra',
					  text: data.data.message,
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
