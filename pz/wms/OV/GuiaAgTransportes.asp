<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->


<link href="/Template/inspina/css/plugins/iCheck/blue.css" rel="stylesheet">

<div class="form-horizontal" id="toPrint"> 
		<div class="row">
			<div class="col-lg-12">
				<div class="ibox float-e-margins">
					<div class="ibox-content">
						<div class="panel-group" id="accordion">
							<div class="panel panel-default">
								<div class="panel-heading">
									<h5 class="panel-title"><a aria-expanded="false" class="collapsed" data-parent="#accordion" data-toggle="collapse" href="#collapseOne">Orden Venta</a></h5>
								</div>
								<div aria-expanded="false" class="panel-collapse collapse" id="collapseOne" style="height: 0px;">
									<div class="panel-body">
										<div class="form-group">
											<label class="control-label col-md-3">Abastecimiento sucursal</label>
											<div class="col-md-4 border border-success">
												<input class="form-control Abastecimiento" type="text" value="">
											</div>
										</div>
										<div class="col-md-4 AbasFolio"></div>
									</div>
									<div class="ibox-content">
										<div class="form-group">
											<label class="control-label col-md-3"><input checked="checked" class="i-checks" name="gpo1" type="radio" value="RedPack"> RedPack</label> <label class="control-label col-md-3"><input class="i-checks" name="gpo1" type="radio" value="UPS"> UPS</label>
										</div><input accept=".xls, .xlsx" class="fileinput fileinput-new" id="ShippingMasivo" name="ShippingMasivo" type="file">
										<div class="form-group">
											<label class="control-label col-md-3">Shipping</label>
											<div class="col-md-4">
												<input class="form-control Shipping" type="text" value="">
											</div>
										</div>
									</div>
									<div class="ibox-content">
										<input accept=".xls, .xlsx" class="fileinput fileinput-new" id="TransitoMasivo" name="TransitoMasivo" type="file">
										<div class="form-group">
											<label class="control-label col-md-3">Transito</label>
											<div class="col-md-4">
												<input class="form-control Transito" type="text" value="">
											</div>
										</div>
									</div>
									<div class="ibox-content">
										<input accept=".xls, .xlsx" class="fileinput fileinput-new" id="EntregadoMasivo" name="EntregadoMasivo" type="file">
										<div class="form-group">
											<label class="control-label col-md-3">Entregado</label>
											<div class="col-md-4">
												<input class="form-control Entregado" type="text" value="">
											</div>
										</div>
									</div>
									<div class="ibox-content">
										<div class="form-group">
											<label class="control-label col-md-3"><input checked="checked" class="i-checks2" name="Devueltos" type="radio" value="6"> Primera</label> <label class="control-label col-md-3"><input class="i-checks2" name="Devueltos" type="radio" value="7"> Segunda</label> <label class="control-label col-md-3"><input class="i-checks2" name="Devueltos" type="radio" value="8"> Tercera</label> <label class="control-label col-md-3"><input class="i-checks2" name="Devueltos" type="radio" value="9"> Entrega Fallida</label>
										</div><input accept=".xls, .xlsx" class="fileinput fileinput-new" id="DevueltoMasivo" name="DevueltoMasivo" type="file">
										<div class="form-group">
											<label class="control-label col-md-3">Primera vuelta</label>
											<div class="col-md-4">
												<input class="form-control PrimeraVuelta" type="text" value="">
											</div>
										</div>
									</div>
									<div class="ibox-content">
										<div class="form-group">
											<label class="control-label col-md-3">Segunda vuelta</label>
											<div class="col-md-4">
												<input class="form-control SegundaVuelta" type="text" value="">
											</div>
										</div>
									</div>
									<div class="ibox-content">
										<div class="form-group">
											<label class="control-label col-md-3">Tercera vuelta</label>
											<div class="col-md-4">
												<input class="form-control TerceraVuelta" type="text" value="">
											</div>
										</div>
									</div>
									<div class="ibox-content">
										<div class="form-group">
											<label class="control-label col-md-3">Entrega Fallida</label>
											<div class="col-md-4">
												<input class="form-control EntregaFallida" type="text" value="">
											</div>
										</div>
									</div>
									<div class="ibox-content">
										<input accept=".xls, .xlsx" class="fileinput fileinput-new" id="PackingMasivo" name="PackingMasivo" type="file">
										<div class="form-group">
											<label class="control-label col-md-3">Packing</label>
										</div>
									</div>
									<div class="ibox-content">
										<div class="col-md-6 col-md-offset-3" id="PruebaCaracter"></div>
									</div>
								</div>
							</div>
							<div class="panel panel-default">
								<div class="panel-heading">
									<h4 class="panel-title"><a aria-expanded="false" class="collapsed" data-parent="#accordion" data-toggle="collapse" href="#collapseTwo">Transferencias</a></h4>
								</div>
								<div aria-expanded="false" class="panel-collapse collapse" id="collapseTwo">
									<div class="panel-body"></div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

<script src="/Template/inspina/js/plugins/iCheck/icheck.min.js"></script>
<script src="/Template/inspina/js/plugins/sheetJs/xlsx.full.min.js"></script>
<script type="text/javascript">
$(document).ready(function(e) {
	
	$('.i-checks').iCheck({ radioClass: 'iradio_square-blue' }); 
	$('.i-checks2').iCheck({ radioClass: 'iradio_square-blue' }); 

	$('.i-checks').on('ifChanged', function(event) {	
		if(event.target.checked) {
			console.log($("input[name='gpo1']:checked"). val())  
		} 
	}); 
	$('.i-checks2').on('ifChanged', function(event) {	
		if(event.target.checked) {
			console.log($("input[name='Devueltos']:checked"). val())  
		} 
	}); 
			
	$('.Abastecimiento').on('keypress',function(e) {
		if(e.which == 13) {
			e.preventDefault()
			var Folio = $(this).val()
			var res = Folio.replace("'", "-");
			$(this).val("")
			var datos ={
				TA_Folio:res,
				Tarea:10
			}
			Abastecimiento(datos,$(this))
			
		}
	});

	$('.Shipping').on('keypress',function(e) {
		if(e.which == 13) {
			e.preventDefault()
			var Folio = $(this).val()
			var res = Folio.replace("'", "-");
			$(this).val("")
			var datos ={
				OV_Folio:res,
				Tarea:6
			}
			ShippingAG(datos,$(this),4)
			
		}
	});
	$('.Transito').on('keypress',function(e) {
		if(e.which == 13) {
			e.preventDefault()
			var Folio = $(this).val()
			var res = Folio.replace("'", "-");
			$(this).val("")
			var datos ={
				OV_Folio:res,
				Estatus:5,
				Tarea:7
			}
			FolioInfo(datos,$(this),5)
			
		}
	});
	$('.Entregado').on('keypress',function(e) {
		if(e.which == 13) {
			e.preventDefault()
			var Folio = $(this).val()
			var res = Folio.replace("'", "-");
			$(this).val("")
			var datos ={
				OV_Folio:res,
				Estatus:10,
				Tarea:7
			}
			FolioInfo(datos,$(this),10)
			
		}
	});
	$('.PrimeraVuelta').on('keypress',function(e) {
		if(e.which == 13) {
			e.preventDefault()
			var Folio = $(this).val()
			var res = Folio.replace("'", "-");
			$(this).val("")
			var datos ={
				OV_Folio:res,
				Estatus:6,
				Tarea:7
			}
			FolioInfo(datos,$(this),6)
			
		}
	});
	$('.SegundaVuelta').on('keypress',function(e) {
		if(e.which == 13) {
			e.preventDefault()
			var Folio = $(this).val()
			var res = Folio.replace("'", "-");
			$(this).val("")
			var datos ={
				OV_Folio:res,
				Estatus:7,
				Tarea:7
			}
			FolioInfo(datos,$(this),7)
			
		}
	});
	$('.TerceraVuelta').on('keypress',function(e) {
		if(e.which == 13) {
			e.preventDefault()
			var Folio = $(this).val()
			var res = Folio.replace("'", "-");
			$(this).val("")
			var datos ={
				OV_Folio:res,
				Estatus:8,
				Tarea:7
			}
			FolioInfo(datos,$(this),8)
			
		}
	});
	$('.EntregaFallida').on('keypress',function(e) {
		if(e.which == 13) {
			e.preventDefault()
			var Folio = $(this).val()
			var res = Folio.replace("'", "-");
			$(this).val("")
			var datos ={
				OV_Folio:res,
				Estatus:9,
				Tarea:7
			}
			FolioInfo(datos,$(this),9)
			
		}
	});



});
var Marcos ={}
var Monterry ={}
var Tijuana ={}
var Cancun ={}
var Tam ={}
var Mexicalli ={}
$("#ShippingMasivo").change(function(evt){
	//$('#bodyTransferencias').html('<tr id="CargandoDatos"><td align="center" colspan="8"><img src="/Img/ajaxLoader.gif"/></td></tr>')
	var selectedFile = evt.target.files[0];
	var reader = new FileReader();
	reader.onload = function(event) {
	  var data = event.target.result;
	  var workbook = XLSX.read(data, {
		  type: 'binary',
		  cellDates: true
	  });
	  var Hoja1 = workbook.SheetNames[0];
	  var Hoja2 = workbook.SheetNames[1];
	  var Hoja3 = workbook.SheetNames[2];
	  var Hoja4 = workbook.SheetNames[3];
	  var Hoja5 = workbook.SheetNames[4];
	  var Hoja6 = workbook.SheetNames[5];
	  
	  
	  var worksheet1 = workbook.Sheets[Hoja1];
	  var worksheet2 = workbook.Sheets[Hoja2];
	  var worksheet3 = workbook.Sheets[Hoja3];
	  var worksheet4 = workbook.Sheets[Hoja4];
	  var worksheet5 = workbook.Sheets[Hoja5];
	  var worksheet6 = workbook.Sheets[Hoja6];
	  
	  var json_object1 =  XLSX.utils.sheet_to_json(worksheet1);
	  var json_object2 =  XLSX.utils.sheet_to_json(worksheet2);
	  var json_object3 =  XLSX.utils.sheet_to_json(worksheet3);
	  var json_object4 =  XLSX.utils.sheet_to_json(worksheet4);
	  var json_object5 =  XLSX.utils.sheet_to_json(worksheet5);
	  var json_object6 =  XLSX.utils.sheet_to_json(worksheet6);
	  
		Marcos  = json_object1
		Monterry  = json_object2
		Tijuana  = json_object3
		Cancun  = json_object4
		Tam = json_object5
		Mexicalli  = json_object6

	console.log(Marcos)	  
	console.log(Monterry)	  
	console.log(Tijuana)	  
	console.log(Cancun)	  
	console.log(Tam)	  
	console.log(Mexicalli)
	
		var NumMexico = 0
		var NumMonterry = 0
		var NumTijuana = 0
		var NumCancun = 0
		var NumTam = 0
		var NumMexicalli = 0
		 
		$.each(Marcos, function(i, item) {
			CargaMasivaMarcos(item.Guia.trim(),item.Pedido.trim())
			NumMexico++ 
		});	  
//		$.each(Monterry, function(i, item) {
//			FolioMasivo(item.Guia,item.Pedido)
//			NumMonterry++
//		});	  
//		$.each(Tijuana, function(i, item) {
//			FolioMasivo(item.Guia,item.Pedido)
//			NumTijuana++
//		});	  
//		$.each(Cancun, function(i, item) {
//			FolioMasivo(item.Guia,item.Pedido)
//			NumCancun++
//		});	  
//		$.each(Tam, function(i, item) {
//			FolioMasivo(item.Guia,item.Pedido)
//			NumTam++
//		});	  
//		$.each(Mexicalli, function(i, item) {
//			FolioMasivo(item.Guia,item.Pedido)
//			NumMexicalli++
//		});	  
	
	
	
	};
	reader.onerror = function(event) {
	  console.error("File could not be read! Code " + event.target.error.code);
	};

	reader.readAsBinaryString(selectedFile);
});
var Entregados = {}
$("#EntregadoMasivo").change(function(evt){
	//$('#bodyTransferencias').html('<tr id="CargandoDatos"><td align="center" colspan="8"><img src="/Img/ajaxLoader.gif"/></td></tr>')
	var selectedFile = evt.target.files[0];
	var reader = new FileReader();
	reader.onload = function(event) {
	  var data = event.target.result;
	  var workbook = XLSX.read(data, {
		  type: 'binary',
		  cellDates: true
	  });
	  var Hoja1 = workbook.SheetNames[0];
	  
	  var worksheet1 = workbook.Sheets[Hoja1];
	  
	  var json_object1 =  XLSX.utils.sheet_to_json(worksheet1);
	  
		Entregados  = json_object1

		console.log(Entregados)	  
	
		
		$.each(Entregados, function(i, item) {
			EntregaMasiva(item.PEDIDO)
		});	  
	
	};
	reader.onerror = function(event) {
	  console.error("File could not be read! Code " + event.target.error.code);
	};

	reader.readAsBinaryString(selectedFile);
});
var Devueltos = {}
$("#DevueltoMasivo").change(function(evt){
	//$('#bodyTransferencias').html('<tr id="CargandoDatos"><td align="center" colspan="8"><img src="/Img/ajaxLoader.gif"/></td></tr>')
	var selectedFile = evt.target.files[0];
	var reader = new FileReader();
	reader.onload = function(event) {
	  var data = event.target.result;
	  var workbook = XLSX.read(data, {
		  type: 'binary',
		  cellDates: true
	  });
	  var Hoja1 = workbook.SheetNames[0];
	  
	  var worksheet1 = workbook.Sheets[Hoja1];
	  
	  var json_object1 =  XLSX.utils.sheet_to_json(worksheet1);
	  
		Devueltos  = json_object1

		console.log(Devueltos)	  
	
		
		$.each(Devueltos, function(i, item) {
			DevolucionMasiva(item.PEDIDO.trim())
		});	  
	
	};
	reader.onerror = function(event) {
	  console.error("File could not be read! Code " + event.target.error.code);
	};

	reader.readAsBinaryString(selectedFile);
});
var trsnsition = {}
$("#TransitoMasivo").change(function(evt){
	//$('#bodyTransferencias').html('<tr id="CargandoDatos"><td align="center" colspan="8"><img src="/Img/ajaxLoader.gif"/></td></tr>')
	var selectedFile = evt.target.files[0];
	var reader = new FileReader();
	reader.onload = function(event) {
	  var data = event.target.result;
	  var workbook = XLSX.read(data, {
		  type: 'binary',
		  cellDates: true
	  });
	  var Hoja1 = workbook.SheetNames[0];
	  
	  var worksheet1 = workbook.Sheets[Hoja1];
	  
	  var json_object1 =  XLSX.utils.sheet_to_json(worksheet1);
	  
		trsnsition  = json_object1

		console.log(trsnsition)	  
	
		
		$.each(trsnsition, function(i, item) {
			TransitoMasiva(item.PEDIDO)
		});	  
	
	};
	reader.onerror = function(event) {
	  console.error("File could not be read! Code " + event.target.error.code);
	};

	reader.readAsBinaryString(selectedFile);
});
var Packing = {}
$("#PackingMasivo").change(function(evt){
	//$('#bodyTransferencias').html('<tr id="CargandoDatos"><td align="center" colspan="8"><img src="/Img/ajaxLoader.gif"/></td></tr>')
	var selectedFile = evt.target.files[0];
	var reader = new FileReader();
	reader.onload = function(event) {
	  var data = event.target.result;
	  var workbook = XLSX.read(data, {
		  type: 'binary',
		  cellDates: true 
	  });
	  var Hoja1 = workbook.SheetNames[0];
	  
	  var worksheet1 = workbook.Sheets[Hoja1];
	  
	  var json_object1 =  XLSX.utils.sheet_to_json(worksheet1);
	  
		Packing  = json_object1

		console.log(Packing)	  
	
		
		$.each(Packing, function(i, item) {
			PackingMasiva(item.PEDIDO)
		});	  
	
	};
	reader.onerror = function(event) {
	  console.error("File could not be read! Code " + event.target.error.code);
	};

	reader.readAsBinaryString(selectedFile);
});

function FolioMasivo(guia,pedido){
	$.post("/pz/wms/OV/OV_Ajax.asp",
	{
		Tarea:8,
		OV_Folio:pedido,
		GuiaTransportista:guia,
		Transportista:$("input[name='gpo1']:checked"). val()
	},function(data){
		
		var obj = JSON.parse(data)
		
		
//		$('#PruebaCaracter').append(data)
	});
}
function CargaMasivaMarcos(Guia,Pedido){
	$.post("/pz/wms/OV/OV_Ajax.asp",
	{
		Tarea:9,
		OV_Folio:Pedido,
		GuiaTransportista:Guia,
		Transportista:$("input[name='gpo1']:checked"). val()
	},function(data){
		console.log(data)
		ShippingRedPack(data,Guia)
//		$('#PruebaCaracter').append(data)
	});
}
function ShippingRedPack(OV_ID,guia){
		var data = {
			"Tarea":3,
			"OV_ID":OV_ID,
			"Estatus":4,
			"Guia": guia,
			"Transportista":$("input[name='gpo1']:checked"). val()

		}
	var myJSON = JSON.stringify(data);
		$.ajax({
			type: 'post',
			contentType:'application/json',
			data: myJSON,
			url: "http://198.38.94.238:1117/lyde/api/ServiceZZ",
			success: function(datos){
				//console.log(datos) 
				TransitRedPack(OV_ID)
			}
		});
	
}
function TransitRedPack(OV_ID){
		var data = {
			"Tarea":3,
			"OV_ID":OV_ID,
			"Estatus":5,
			"Guia": "",
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



function EntregaMasiva(Pedido){
	$.post("/pz/wms/OV/OV_Ajax.asp",
		{
		Tarea:7,
		OV_Folio:Pedido,
		Estatus:10
		},function(data){
		if(data !=-1){	
			CambioEstatus(data,10)
		}else{
			console.log("No se notific&oacute; a Izzi "+Pedido)	
		}
	});
}
function DevolucionMasiva(Pedido){
	$.post("/pz/wms/OV/OV_Ajax.asp",
		{
		Tarea:7,
		OV_Folio:Pedido,
		Estatus:$("input[name='Devueltos']:checked"). val()
		},function(data){
		if(data !=-1){	
			CambioEstatus(data,$("input[name='Devueltos']:checked"). val())
		}
	});
}
function TransitoMasiva(Pedido){
	$.post("/pz/wms/OV/OV_Ajax.asp",
		{
		Tarea:7,
		OV_Folio:Pedido,
		Estatus:5
		},function(data){
		if(data !=-1){	
			CambioEstatus(data,5)
		}
	});
}
function PackingMasiva(Pedido){
	$.post("/pz/wms/OV/OV_Ajax.asp",
		{
		Tarea:7,
		OV_Folio:Pedido,
		Estatus:3
		},function(data){
		if(data !=-1){	
			CambioEstatus(data,3)
		}
	});
}
function FolioInfo(folio,h,Estatus){
	$.post("/pz/wms/OV/OV_Ajax.asp",folio,function(data){
		h.focus()
		if(data != -1){
			CambioEstatus(data,Estatus)
			console.log("Se envia a izzi")
		}else{
			console.log("No se envia a izzi")
			sTipo = "danger";   
			sMensaje = "No se envia a izzi";
			Avisa(sTipo,"Aviso",sMensaje);	
		}
		
	});
}

function Abastecimiento(folio,h){
	$.post("/pz/wms/OV/OV_Ajax.asp",folio,function(data){
		h.focus()
		if(data != ""){
		var obj = JSON.parse(data)
			AbastecimientoAG(data)
			console.log(obj)
		}
		
	});
}
function ShippingAG(folio,h,Estatus){
	$.post("/pz/wms/OV/OV_Ajax.asp",folio,function(data){
		h.focus()
		if(data != ""){
		var obj = JSON.parse(data)
			ShippingAGGuia(obj)
			console.log(obj)
		}
		
	});
}


function CambioEstatus(OV_ID,Estatus){
		var data = {
			"Tarea":3,
			"OV_ID":OV_ID,
			"Estatus":Estatus,
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
				sTipo = "info";   
				sMensaje = "Estatus actualizados";
				Avisa(sTipo,"Aviso",sMensaje);	
			}
		});
}
function AbastecimientoAG(obj){  
		var json = JSON.parse(obj)
		var data = {
			"OV_ID":json.TA_ID+10000,
			"Folio":json.TA_Folio
		}
	var myJSON = JSON.stringify(data);
		$.ajax({
			type: 'post',
			contentType:'application/json',
			data: myJSON,
			url: "http://198.38.94.238:1117/lyde/api/AgService",
			success: function(datos){
				console.log(datos) 
			sTipo = "info";   
			sMensaje = "Folio asignado "+datos.message;
			Avisa(sTipo,"Aviso",sMensaje);	
			$('.AbasFolio').append(obj.TA_Folio+" "+datos.message)
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

function ShippingAGGuia(obj){                
		var data = {
			"OV_ID":obj.OV_ID,
			"Folio":obj.OV_Folio,
			"Nombre":obj.OV_CUSTOMER_NAME,
			"Telefono":obj.OV_Telefono,
			"Email":obj.OV_Email,
			"Calle":obj.OV_Calle,
			"NumeroExt":obj.OV_NumeroExterior,
			"NumeroInt":obj.OV_NumeroInterior,
			"Colonia":obj.OV_Colonia,
			"Municipio":obj.OV_Delegacion,
			"CP":obj.OV_CP,
			"Estado":obj.OV_Ciudad,
			"Pais":obj.OV_Pais
		}
		
		//console.log(data)
	var myJSON = JSON.stringify(data);
		$.ajax({
			type: 'post',
			contentType:'application/json',
			data: myJSON,
			url: "http://198.38.94.238:1117/lyde/api/AgService",
			success: function(datos){
				console.log(datos) 
				$('#FolioAsignado').html(datos.message)
			}
		});
	
	
}



</script>            

