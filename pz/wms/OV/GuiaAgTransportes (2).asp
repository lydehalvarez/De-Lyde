<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->


<link href="/Template/inspina/css/plugins/iCheck/blue.css" rel="stylesheet">
<div class="form-horizontal" id="toPrint">
    <div class="row">
        <div class="col-lg-12">
            <div class="ibox float-e-margins">
                <div class="ibox-content">
                <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">
                  <div class="panel panel-default">
                    <div class="panel-heading" role="tab" id="headingOne">
                      <h4 class="panel-title">
                        <a class="collapsed" role="button" data-toggle="collapse" data-parent="#accordion" href="#collapseOne" aria-expanded="false" aria-controls="collapseOne">
                          Orden de venta
                        </a>
                      </h4>
                    </div>
                    <div id="collapseOne" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingOne">
                      <div class="panel-body">
                            <div class="form-group">
                                <label class="control-label col-md-3">Abastecimiento sucursal <small>Guia de AG transportes</small></label>
                                <div class="col-md-4 border border-success"><input type="text" class="form-control Abastecimiento" value=""/></div>
                            </div>
                            <div class="form-group">
                            <div class="col-md-5 AbasFolio"></div>
                                <table class="table">
                                    <thead>
                                        <th>Folio</th>
                                        <th>Guia</th>
                                    </thead>
                                    <tbody id="TRAS"></tbody>
                                </table>
                            </div>
                            <div class="ibox-content">
                                <div class="form-group">
                                    <label class="control-label col-md-3"><input type="radio" checked="checked" class="i-checks" value="RedPack" name="gpo1">                     RedPack</label>
                                    <label class="control-label col-md-3"><input type="radio" class="i-checks" value="UPS" name="gpo1">                     UPS</label>
                                    </div>
                               <input class="fileinput fileinput-new" type="file" id="ShippingMasivo" name="ShippingMasivo" accept=".xls, .xlsx"/>
                                <div class="form-group">
                                <label class="control-label col-md-3">Shipping <small>Guia de AG transportes</small></label>
                                <div class="col-md-4"><input type="text" class="form-control Shipping" value=""/></div>
                                </div>
                            </div>
                            <div class="ibox-content">
                                <input class="fileinput fileinput-new" type="file" id="TransitoMasivo" name="TransitoMasivo" accept=".xls, .xlsx"/>
                                <div class="form-group">
                                    <label class="control-label col-md-3">Transito</label>
                                    <div class="col-md-4"><input type="text" class="form-control Transito" value=""/></div>
                                </div>
                            </div>
                            <div class="ibox-content">
                                <input class="fileinput fileinput-new" type="file" id="EntregadoMasivo" name="EntregadoMasivo" accept=".xls, .xlsx"/>
                                <div class="form-group">
                                    <label class="control-label col-md-3">Entregado</label>
                                    <div class="col-md-3"><input type="text" class="form-control Entregado" value=""/></div>
                                    <label class="control-label col-md-3">Quien recibe</label>
                                    <div class="col-md-3"><input type="text" class="form-control QuienRecibe" value=""/></div>
                                </div>
                            </div>
                            <div class="ibox-content">
                                <div class="form-group">
                                    <label class="control-label col-md-3"><input type="radio" checked="checked" class="i-checks2" value="6" name="Devueltos">                     Primera</label>
                                    <label class="control-label col-md-3"><input type="radio" class="i-checks2" value="7" name="Devueltos"> Segunda</label>
                                    
                                    <label class="control-label col-md-3"><input type="radio" class="i-checks2" value="8" name="Devueltos"> Tercera</label>
                                    <label class="control-label col-md-3"><input type="radio" class="i-checks2" value="9" name="Devueltos"> Entrega  Fallida</label>
                                    
                                    </div>
                                <input class="fileinput fileinput-new" type="file" id="DevueltoMasivo" name="DevueltoMasivo" accept=".xls, .xlsx"/>
                                <div class="form-group">
                                    <label class="control-label col-md-3">Primera vuelta</label>
                                    <div class="col-md-4"><input type="text" class="form-control PrimeraVuelta" value=""/></div>
                                </div>
                            </div>
                            <div class="ibox-content">
                                <div class="form-group">
                                    <label class="control-label col-md-3">Segunda vuelta</label>
                                    <div class="col-md-4"><input type="text" class="form-control SegundaVuelta" value=""/></div>
                                </div>
                            </div>
                            <div class="ibox-content">
                                <div class="form-group">
                                    <label class="control-label col-md-3">Tercera vuelta</label>
                                    <div class="col-md-4"><input type="text" class="form-control TerceraVuelta" value=""/></div>
                                </div>
                            </div>
                            <div class="ibox-content">
                                <div class="form-group">
                                    <label class="control-label col-md-3">Entrega Fallida</label>
                                    <div class="col-md-4"><input type="text" class="form-control EntregaFallida" value=""/></div>
                                </div>
                            </div>
                            <div class="ibox-content">
                                <input class="fileinput fileinput-new" type="file" id="PackingMasivo" name="PackingMasivo" accept=".xls, .xlsx"/>
                                <div class="form-group">
                                <label class="control-label col-md-3">Packing</label>
                                </div>
                            </div>
                            <div class="ibox-content">
                                <div class="row">
                                  <div class="col-md-12">
                                    <table class="table">
                                        <thead>
                                            <tr>
                                                <th>Folio</th>
                                                <th>Se movi&oacute; a</th>
                                                <th>Estatus</th>
                                                <th>Resultado en Izzi</th>
                                            </tr>
                                        </thead>
                                        <tbody id="ResumenMasivo"></tbody>
                                    </table>
                                  </div>
                                </div>
                            </div>
                      </div>
                    </div>
                  </div>
                  <div class="panel panel-default">
                    <div class="panel-heading" role="tab" id="headingTwo">
                      <h4 class="panel-title">
                        <a class="collapsed" role="button" data-toggle="collapse" data-parent="#accordion" href="#collapseTwo" aria-expanded="false" aria-controls="collapseTwo">
                          Transferencia
                        </a>
                      </h4>
                    </div>
                    <div id="collapseTwo" class="panel-collapse collapse" role="tabpanel" aria-labelledby="headingTwo">
                      <div class="panel-body">
                            <div class="ibox-content">
                                <div class="form-group">
                                    <label class="control-label col-md-3 text-left"><h2><strong>Transferencias <small>Gu&iacute;as de TRA</small></strong></h2></label>
                                    <div class="col-md-3 text-left">
                                        <a class="btn btn-success" onclick='Layout.Descarga("Transferencias Gu&iacute;as de TRA",[{Pedido:null,Guia:null,Transportista:null}])'><i class="fa fa-download"></i>&nbsp;Descarga layout</a>
                                    </div>
                                    <div class="col-md-3">
                                        <input class="fileinput fileinput-new" type="file" id="TRAMasivo" name="TRAMasivo" accept=".xls, .xlsx"/>
                                    </div>
                                </div>
                            </div>
                            <div class="ibox-content">
                                <div class="form-group">
                                    <label class="control-label col-md-3 text-left"><h2><strong>Cancelaci&oacute;n masiva</strong></h2></label>
                                    <div class="col-md-3 text-left">
                                        <a class="btn btn-success" onclick='Layout.Descarga("Cancelaci&oacute;n masiva",[{Pedido:null}])'><i class="fa fa-download"></i>&nbsp;Descarga layout</a>
                                    </div>
                                    <div class="col-md-3">
                                        <input class="fileinput fileinput-new" type="file" id="Masivo_tra" data-tipo="1" accept=".xls, .xlsx"/>
                                    </div>
                                </div>
                                <div id="loading_ResumenTRA"></div>
                                <div class="form-group">
                                    <div class="col-md-8">
                                        <a class="btn btn-danger" id="divErrores" onclick='Layout.DescargaErrores(Errores)'><i class="fa fa-download"></i>&nbsp;Descarga errores</a>
                                    </div>
                                    <div class="col-md-4">
										<strong>Cantidad Correcta :</strong> <span id="CantidadCorrecta">0</span>
                                        <br />
										<strong>Cantidad Error :</strong> <span id="CantidadError">0</span>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <table class="table">
                                        <thead>
                                            <tr>
                                                <th>#</th>
                                                <th>Folio</th>
                                                <th>Estatus</th>
                                                <th>Respuesta Elektra</th>
                                            </tr>
                                        </thead>
                                        <tbody id="CancelacionMasiva"></tbody>
                                    </table>
                                </div>
                            </div>
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
	$('#divErrores').hide()
	$('.Abastecimiento').on('keypress',function(e) {
		if(e.which == 13) {
			e.preventDefault()
			var Folio = $(this).val()
			var res = Folio.replace("'", "-");
			$(this).val("")
			var datos ={
				TA_Folio:res,
				Tarea:10,
				IDUsuario:$('#IDUsuario').val()
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
				Tarea:6,
				IDUsuario:$('#IDUsuario').val()
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
				Tarea:7,
				IDUsuario:$('#IDUsuario').val()
			}
			FolioInfo(datos,$(this),5)
			
		}
	});
	$('.Entregado').on('keypress',function(e) {
		if(e.which == 13) {
			var Quien = $('.QuienRecibe').val()
				e.preventDefault()
				var Folio = $(this).val()
				var res = Folio.replace("'", "-");
				$(this).val("")
				var datos ={
					OV_Folio:res,
					Estatus:10,
					Tarea:7,
					IDUsuario:$('#IDUsuario').val()
				}
			if(Quien != ""){
				QuienRecibio(Quien.trim(),Folio)
			}
				FolioInfo(datos,$(this),10)
//			}else{
//			sTipo = "error";   
//			sMensaje = "No se ha colocado la persona que recibi&oacute;";
//			Avisa(sTipo,"Aviso",sMensaje);	
//			}
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
				Tarea:7,
				IDUsuario:$('#IDUsuario').val()
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
				Tarea:7,
				IDUsuario:$('#IDUsuario').val()
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
				Tarea:7,
				IDUsuario:$('#IDUsuario').val()
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
				Tarea:7,
				IDUsuario:$('#IDUsuario').val()
			}
			FolioInfo(datos,$(this),9)
			
		}
	});



});

$("#Masivo_tra").change(function(evt){
	$("#Masivo_tra").prop('disabled',true)
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
	  
	  var MavisoTRA = []
		$.each(json_object1, function(i, item) {
			MavisoTRA.push(item.Pedido.trim().toString())
		});
		Funciones.CancelaTRA(MavisoTRA)
	};
	reader.onerror = function(event) {
	  console.error("File could not be read! Code " + event.target.error.code);
	};
	reader.readAsBinaryString(selectedFile);
});

var Errores = []
var Funciones = {
		Loading:function(){
			var Loading = '<div class="text-center"><div class="spiner-example">'+
							'<div class="sk-spinner sk-spinner-three-bounce">'+
							   ' <div class="sk-bounce1"></div>'+
								'<div class="sk-bounce2"></div>'+
								'<div class="sk-bounce3"></div>'+
							'</div>'+
						'</div>'+
						'<br><div>Cargando informaci&oacute;n esto puede demorar un par de minutos</div></div>'
			
			return Loading;
			
		},
		CancelaTRA:function(arr){
			$('#CancelacionMasiva').html("")
			$('#loading_ResumenTRA').show('slow')
			$('#loading_ResumenTRA').html(Funciones.Loading())
			$.ajax({
				type: 'post',
				contentType:'application/json',
				dataType: "json",
				data: JSON.stringify(arr),
				url: "https://elektra.lydeapi.com/api/ElektraFunction/Masivo/Usuario",
				success: function(datos){
					console.log(datos)
					$("#Masivo_tra").prop('disabled',false)
					$("#Masivo_tra").val("")
					$('#loading_ResumenTRA').hide('slow')
					$('#CancelacionMasiva').html(Funciones.TablaCancelacion(datos));
				}
			});
		},
		TablaCancelacion:function(arr){
			Errores = []
			$('#divErrores').hide('show')
			var OK = 0
			var Error = 0
			var Tabla = ""
			var obj = ""
			var Class = "";
			var Renglon = 0
			for(var i = 0;i<arr.length;i++){
				Renglon++
				op = arr[i];
				if(op.result == 1){
					Class = "bg-primary"
					Tabla = Tabla + '<tr><td>'+Renglon+'</td><td>'+op.data.Pedido+'</td><td class="'+Class+'">OK</td><td>'+op.data.ResponseEKT.ordenes[0].resultado+'</td></tr>'
					OK++
				}else{
					Class = "bg-danger"
					Errores.push(op.data.Pedid)
					Tabla = Tabla + '<tr><td>'+Renglon+'</td><td>'+op.data.Pedido+'</td><td class="'+Class+'">Error</td><td>'+op.message+'</td></tr>'
					$('#divErrores').show('show')
					Error++
				}
			}
			$('#CantidadCorrecta').html(OK)
			$('#CantidadError').html(Error)
			return Tabla;
		}	
	}

var Layout = {
		Descarga:function(titulo,Estructura){
			Estructura[0].Pedido = "No modificar el titilo de arriba,borra este mensaje y coloca la lista de pedidos"
			
			var date = new Date()
			var Dia = date.getDate()
			if(Dia < 10){
				Dia = "0"+Dia	
			}
			var minuto =date.getMinutes()
			if(minuto < 10){
				minuto= "0"+minuto	
			}
			var Mes = ["01","02","03","04","05","06","07","08","09","10","11","12"]
			var Fecha = Dia+""+Mes[date.getMonth()]+""+date.getFullYear()+" "+date.getHours()+"."+minuto+" hrs"
			var ws = XLSX.utils.json_to_sheet(Estructura);
			var wb = XLSX.utils.book_new(); 
					 XLSX.utils.book_append_sheet(wb, ws, "Sheet1");
					 XLSX.writeFile(wb, titulo+" "+Fecha+".xlsx");
		}
	}

var Marcos ={}
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
	  var worksheet1 = workbook.Sheets[Hoja1];
	  var json_object1 =  XLSX.utils.sheet_to_json(worksheet1);
	  
		Marcos  = json_object1

		console.log(Marcos)	  
	
		var NumMexico = 0
		var NumMonterry = 0
		var NumTijuana = 0
		var NumCancun = 0
		var NumTam = 0
		var NumMexicalli = 0
		 
		$.each(Marcos, function(i, item) {
			CargaMasivaMarcos(item.Guia.trim(),item.Pedido.trim());
			NumMexico++ 
		});	  
	
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
			EntregaMasiva(item.ENTREGADO)
		});	  
	
	};
	reader.onerror = function(event) {
	  console.log("File could not be read! Code " + event.target.error.code);
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
var Transferencia = {}
$("#TRAMasivo").change(function(evt){
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
	  
		Transferencia  = json_object1
 
		console.log(Transferencia)	  
		
		$.each(Transferencia, function(i, item) {
			TRAMasiva(item.Pedido.toString(),item.Guia.toString(),item.Transportista.toString())
		});	  
	
	};
	reader.onerror = function(event) {
	  console.error("File could not be read! Code " + event.target.error.code);
	};

	reader.readAsBinaryString(selectedFile);
});

function QuienRecibio(Quien,Folio){
	$.post("/pz/wms/OV/OV_Ajax.asp",
	{
		Tarea:14,
		OV_Folio:Folio,
		QuienRecibe:Quien.trim()
	},function(data){
		var obj = JSON.parse(data)
		$('.QuienRecibe').val("")
	});
		
}


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
		Transportista:$("input[name='gpo1']:checked"). val(),
		IDUsuario:$('#IDUsuario').val()
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
			url: "http://198.38.94.4:1117/lyde/api/ServiceZZ",
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
			url: "http://198.38.94.4:1117/lyde/api/ServiceZZ",
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
		Estatus:10,
		IDUsuario:$('#IDUsuario').val()
		},function(data){
		if(data !=-1){	
			CambioEstatus(data,10,Pedido)
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
		Estatus:$("input[name='Devueltos']:checked"). val(),
		IDUsuario:$('#IDUsuario').val()
		},function(data){
		if(data !=-1){	
			CambioEstatus(data,$("input[name='Devueltos']:checked"). val())
		}else{
			sTipo = "error";   
			sMensaje = "Lo sentimos el estatus enviado es menor a actual :(";
			Avisa(sTipo,"Aviso",sMensaje);	
		}
	});
}
function TransitoMasiva(Pedido){
	$.post("/pz/wms/OV/OV_Ajax.asp",
		{
		Tarea:7,
		OV_Folio:Pedido,
		Estatus:5,
		IDUsuario:$('#IDUsuario').val()
		},function(data){
		if(data !=-1){	
			CambioEstatus(data,5,Pedido)
		}else{
			sTipo = "error";   
			sMensaje = "Lo sentimos no actualizo el estatus";
			Avisa(sTipo,"Aviso",sMensaje);	
		}
	});
}
function PackingMasiva(Pedido){
	$.post("/pz/wms/OV/OV_Ajax.asp",
		{
		Tarea:7,
		OV_Folio:Pedido,
		Estatus:3,
		IDUsuario:$('#IDUsuario').val()
		},function(data){
		if(data !=-1){	
			CambioEstatus(data,3,Pedido)
		}
	});
}
function TRAMasiva(Pedido,Guia,Transportista){
	$.post("/pz/wms/OV/OV_Ajax.asp",
		{
		Tarea:12,
		TA_Folio:Pedido,
		TA_Guia:Guia,
		TA_Transportista:Transportista,
		IDUsuario:$('#IDUsuario').val()
		},function(data){
			if(data == 1){	
				sTipo = "info";   
				sMensaje = Pedido+" actualizado";
			}else{
				sTipo = "error";   
				sMensaje = Pedido+" No se actualiz&oacute;";
			}
		Avisa(sTipo,"Aviso",sMensaje);	
	});
}
function FolioInfo(folio,h,Estatus){
	$.post("/pz/wms/OV/OV_Ajax.asp",folio,function(data){
		h.focus()
		if(data != -1){
			CambioEstatus(data,Estatus,folio)
			console.log("Se envia a izzi")
		}else{
			console.log("No se envia a izzi")
			sTipo = "error";   
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


function CambioEstatus(OV_ID,Estatus,Folio){
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
			url: "http://198.38.94.4:1117/lyde/api/ServiceZZ",
			success: function(datos){
				console.log(datos) 
				if(datos.result == -1 || datos.result == 2){
					var Response = {
						Folio:Folio,
						Estatus:Estatus,
						Respuesta:datos.data.message,
						result:datos.result
					}
				}else{
					var Response = {
						Folio:datos.data.update.pickedId ,
						Estatus:datos.data.update.estado,
						Respuesta:datos.data.status,
						result:datos.result
					}
				}
				Avisa("info","Respuesta recibida","Consulta el resultado en el resumen")
				$('#ResumenMasivo').prepend(Izzi.Renglon(Response))
			}
		});
}


var Izzi = {
		Renglon:function(arr){
			var Estatus = "";
			var Estatus2 = "OK";
			var Class = "bg-primary";
			if(arr.result == -1){
				Estatus2 = "Error en Izzi"
				Class = "bg-danger"
			}
			switch(arr.Estatus){
				case 5:
					Estatus = "Transito"
				break;
				case 6:
					Estatus = "Primer intento"
				break;
				case 7:
					Estatus = "Segundo intento"
				break;
				case 8:
					Estatus = "Tercer intento"
				break;
				case 9:
					Estatus = "Entrega fallida"
				break;
				case 10:
					Estatus = "Entregado"
				break;
			}
			var tabla = '<tr><td>'+arr.Folio+'</td><td>'+Estatus+'</td><td class="'+Class+'">'+Estatus2+'</td><td>'+arr.Respuesta+'</td></tr>'
			return tabla
		}
	
	}


function AbastecimientoAG(obj){  
		var json = JSON.parse(obj)
		var data = {
			"OV_ID":json.TA_ID+100000000,
			"Folio":json.TA_Folio
		}
	var myJSON = JSON.stringify(data);
		$.ajax({
			type: 'post',
			contentType:'application/json',
			data: myJSON,
			url: "http://198.38.94.4:1117/lyde/api/AgService",
			success: function(datos){
				console.log(datos) 
			sTipo = "info";   
			sMensaje = "Folio asignado "+datos.message;
			Avisa(sTipo,"Aviso",sMensaje);	
			if(datos.message == "Lo sentimos existencia de OV_ID previa"){
				datos.message = "Ya se genero una guia para ese folio"
			}
			$('#TRAS').prepend("<tr><td>"+json.TA_Folio+"</td><td>"+datos.message+"</td></tr>")
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
			url: "http://198.38.94.4:1117/lyde/api/ServiceZZ",
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
	var myJSON = JSON.stringify(data);
		$.ajax({
			type: 'post',
			contentType:'application/json',
			data: myJSON,
			url: "http://198.38.94.238:8543/api/AgMensajeria",
			success: function(response){
				console.log(response) 
				$('#FolioAsignado').html(response.data)
				ColocaGuiaWMS(obj.OV_ID,response.data,"Ag")
				if(response.result == 1){
					var data = {
							"Tarea":3,
							"OV_ID":obj.OV_ID,
							"Estatus":4,
							"Guia": response.data,
							"Transportista":"Ag"
				
						}
					var myJSON = JSON.stringify(data);
						$.ajax({
							type: 'post',
							contentType:'application/json',
							data: myJSON,
							url: "http://198.38.94.4:1117/lyde/api/ServiceZZ",
							success: function(response){
								console.log(response) 
								if(response.result == 1){
									TransitRedPack(obj.OV_ID)
								}
								
							}
						});
				}
				
				
			}
		});
}
function ColocaGuiaWMS(ov_id,guia,transportista){
	$.post("/pz/wms/OV/OV_Ajax.asp",
	{
		Tarea:8,
		OV_ID:ov_id,
		GuiaTransportista:guia,
		Transportista:transportista
	},function(response){
		var dat = JSON.parse(response)
		
	});
}
	



</script>            

