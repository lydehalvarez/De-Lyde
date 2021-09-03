<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../../Includes/iqon.asp" -->



<div class="wrapper wrapper-content animated fadeInRight">
    <div class="form-horizontal">
        <div class="row">
            <div class="col-lg-7">
                <div class="ibox">
                    <div class="ibox-content">
                        <h2>Carga de gu&iacute;as</h2>
                        <div class="form-group">
                            <div class="col-xs-6">
                                <%var sCampo = "Prov_Nombre"
                                  var sCond = "Prov_EsPaqueteria = 1 AND Prov_Habilitado = 1"
                                    CargaCombo("Prov_ID"," class='form-control col-xs-6' ","Prov_ID",sCampo,
                                    "Proveedor",sCond,sCampo,-1,0,"Selecciona","Editar")%>
                            </div> 
                        </div>
                    </div>
                    <div id="CargaEstandar">
                        <div class="ibox-content bg-success">
                             <h2>Salida de almac&eacute;n</h2>
                             <div class="form-group divGuias">
                                <label class="control-label col-md-3">Folio</label>
                                <div class="col-md-6">
                                    <input class="form-control FolioSalida" style="color: black;"  placeholder="Ingrese el folio para dar salida" type="text" value=""/><br>
                                    <small id="Mensaje2"></small>
                                </div>
                            </div>
                        </div>
                        <div class="ibox-content bg-info dvGuiaDHL">
                        </div>
                        <div class="ibox-content bg-info">
                             <h2 class="divGuias" id="CargaGuia"></h2>
                             <div class="form-group divGuias">
                                <label class="control-label col-md-3">Folio SO</label>
                                <div class="col-md-3">
                                    <input class="form-control Folio" data-ov="1" style="color: black;"  placeholder="Ingrese el folio" type="text" value=""/><br>
                                    <small id="Mensaje"></small>
                                </div>
                                <label class="control-label col-md-3">Gu&iacute;a</label>
                                <div class="col-md-3">
                                    <input class="form-control Guia" data-guia="1" data-ov="1" style="color: black;"  placeholder="Ingrese la gu&iacute;a" type="text" value=""/>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!--<div class="ibox-content bg-success">
                        <h2 class="divGuias" id="CargaGuiaTRA"></h2>
                         <div class="form-group divGuias">
                            <label class="control-label col-md-3">Folio TRA</label>
                            <div class="col-md-3">
                                <input class="form-control Folio" data-ov="0" style="color: black;" placeholder="Ingrese el folio" type="text" value=""/><br>
                                <small id="Mensaje"></small>
                            </div>
                            <label class="control-label col-md-3">Gu&iacute;a TRA</label>
                            <div class="col-md-3">
                                <input class="form-control Guia" data-guiatra="1" data-ov="0" style="color: black;" placeholder="Ingrese la gu&iacute;a" type="text" value=""/>
                            </div>
                        </div>
                    </div>--> 
               </div>
            </div>
            <div class="col-lg-5">
                <div class="ibox">
                    <div class="ibox-content">
                        <div class="btn-group" role="group" aria-label="Basic example">
                          <button type="button" class="btn btn-success btnDescargaFolios">Descarga folios xls</button>
                          <button type="button" class="btn btn-info btnFormatoSalida">Manifiesto de salida</button>
                        </div>                    
                        <table class="table table-striped table-bordered">
                            <thead>
                                <tr>
                                    <th>Folio</th>
                                    <th>Guia</th>
                                    <th>Destino</th>
                                    <th>Usuario</th>
                                </tr>
                            </thead>
                            <tbody id="Actividades"></tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <div class="row">
            <div id="CargaEstafeta"></div>
        </div>
    </div>
</div>
<input type="hidden" id="ID" name="ID" />
<input type="hidden" id="EsOV" name="EsOV" />
<input type="hidden" id="Destino" name="Destino" />
<input type="hidden" id="Cliente" name="Cliente" />

<script src="/Template/inspina/js/plugins/iCheck/icheck.min.js"></script>
<script src="/Template/inspina/js/plugins/sheetJs/xlsx.full.min.js"></script>

<script type="application/javascript">

$('.divGuias').hide()
$(".Guia").prop('disabled',true)

var date = new Date()
var Dia = date.getDate()
if(Dia < 10){
	Dia = "0"+Dia	
}
var Mes = ["01","02","03","04","05","06","07","08","09","10","11","12"]
var Fecha = Dia+""+Mes[date.getMonth()]+""+date.getFullYear()+" "+date.getHours()+"."+date.getMinutes()+" hrs"
var Guias = []

$(document).ready(function() {
	
		$('.i-checks').iCheck({ radioClass: 'iradio_square-blue' }); 

		$('.btnFinalizar').click(function(e) {
            e.preventDefault();
        });
		
		$('#Prov_ID').on('change', function(event) {
			var logis = $(this).val();
			$('#CargaEstandar').show('slow')
			$('#CargaEstafeta').hide('slow')
			if(logis == 5){
				DHLEjecutor.GetLayout();
				$('.divGuias').hide('slow');
				var Transportista = $("#Prov_ID option:selected").text();
				$('#CargaGuia').html("Gu&iacute;as de "+Transportista);
				$('#CargaGuiaTRA').html("Gu&iacute;as TRA de "+Transportista);
				$('.divGuias').show('slow');
			}else if(logis == 26){
				FuncionGuia.VentanaEstafeta();
			}
			else{
				$('.divGuias').hide('slow');
				var Transportista = $("#Prov_ID option:selected").text();
				$('#CargaGuia').html("Gu&iacute;as de "+Transportista);
				$('#CargaGuiaTRA').html("Gu&iacute;as TRA de "+Transportista);
				$('.divGuias').show('slow');
			}
		}); 
		$('.Folio').on('keypress',function(e) {
			if(e.which == 13) {	
			var DatoIngreso =  FuncionGuia.FolioBienEscrito($(this).val())
			$(this).prop('disabled',true)
				if(DatoIngreso != ""){
					VerificaGuia(DatoIngreso,$(this))
				}else{
					var sTipo = "error";   
					var sMensaje = "Sin dato";
					Avisa(sTipo,"Aviso",sMensaje);			
				}
			}
		});
		$('.Guia').on('keypress',function(e) {
			if(e.which == 13) {	
				var DatoIngreso = $(this).val();
				var Proveedor = $("#Prov_ID").val();
				FuncionGuia.ValidaGuia(DatoIngreso,Proveedor)
			}
		});	
		$('.FolioSalida').on('keypress',function(e) {
			if(e.which == 13) {	
				var DatoIngreso = $(this).val();
				DatoIngreso = DatoIngreso.replace("'","-")
				Salida.DaSalida(DatoIngreso)
				$(this).prop('disabled',true)
			}
		});
		
		$('.btnFormatoSalida').click(function(e) {
            e.preventDefault();
        });
		
		
});

var Salida = {
 DaSalida: function(Folio){
	 var Datos = {
		Tarea: 7,
		Folio:Folio,
		IDUsuario:$('IDUsuario').val()
	 }
	$.post("/pz/wms/Almacen/Salida/Alm_Salida_Ajax.asp",Datos,function(data){
			var resp = JSON.parse(data)
			$('.FolioSalida').prop('disabled',false)
			var sTipo = ""
			if(resp.result ==1){
				sTipo = "success"
				var tr = "<tr class='nuevos'><td>"+Folio+"</td><td>"+resp.data[0]+"</td><td>&nbsp;</td><td>"+$("#sUsuarioSes").val()+"</td></tr>"
				$("#Actividades").prepend(tr)
				Guias.push({"Folio":Folio,"Guia":resp.data[0],"Destino":"","Usuario Escaneo":$("#sUsuarioSes").val()})
			}else{
				sTipo = "error"
			}
			Avisa(sTipo,"Aviso",resp.message);
			$('.FolioSalida').val("")
			$('.FolioSalida').focus()
			$("#Mensaje2").html(resp.message)
	});
 }
}


var FuncionGuia = {
 ValidaGuia: function(Guia,Proveedor){
		if(Guia != ""){
			var Validado = 0
			if(Proveedor == 2){
				Guia = Guia.substr(1,10)
				if(Guia.length == 10){
					Validado = 1
				}else{
					var sTipo = "error";   
					var sMensaje = "Error en gu&iacute;a RedPack";
					Avisa(sTipo,"Aviso",sMensaje);			
					$('.Guia').val("")
					console.log(Guia)
				}
			}else if(Proveedor == 4){
				if(Guia.length == 18){
					Validado = 1
				}else{
					var sTipo = "error";   
					var sMensaje = "Error en gu&iacute;a UPS";
					Avisa(sTipo,"Aviso",sMensaje);			
					$('.Guia').val("")
				}
			}else{
				Validado = 1
			}
			
			if(Validado == 1){
				ColocarGuia(Guia.trim(),$(this))	;
			}
		}else{
			var sTipo = "error";   
			var sMensaje = "Sin dato";
			Avisa(sTipo,"Aviso",sMensaje);			
		}
	},
	FolioBienEscrito: function(Folio){
		var res = Folio.replace("'", "-");
		var Mayus = res.toUpperCase()
			
		return Mayus.trim()
	}
	,VentanaEstafeta:function(){
		$('#CargaEstandar').hide('slow')
		$("#CargaEstafeta").load("/pz/wms/Almacen/Salida/Alm_CargaMultiple.asp",function(){
			$(this).show('slow');
		});
	}
}
function VerificaGuia(Folio,input){
	var datos =  {
			Tarea:1,
			Folio:Folio
	}
	$.post("/pz/wms/Almacen/Salida/Alm_Salida_Ajax.asp",datos,function(data){
			var resp = JSON.parse(data)
			console.log(resp)
			if(resp.result == 1){
				var sTipo = "success";   
				$('.Guia').prop('disabled',false)
				$('.Guia').focus()
				$("#Mensaje").css('color','#09F')
				$("#ID").val(resp.data[0].ID)
				$("#Destino").val(resp.data[0].Destino)
				$("#EsOV").val(resp.data[0].EsOV)
				$("#Cliente").val(resp.data[0].Cliente)
			}else{
				input.val("")
				var sTipo = "error";   
				$("#Mensaje").css('color','#F00')
				Avisa(sTipo,"Aviso",resp.message);
			}
			input.prop('disabled',false)
			$("#Mensaje").html(resp.message)
	});
}
function ColocarGuia(Guia,input){
	
	var Datos = {}
	var EsOV = $('#EsOV').val()
	var Cliente = $('#Cliente').val()
	if(EsOV == 1){
		Datos = {
			Tarea:2,
			IDUsuario:$("#IDUsuario").val(),
			OV_ID:$("#ID").val(),
			OV_Folio:$(".Folio").val(),
			OV_TRACKING_COM:$("#Prov_ID option:selected").text(),
			OV_TRACKING_NUMBER:Guia
		}
	}else{
		Datos = {
			Tarea:3,
			TA_ID:$("#ID").val(),
			OV_Folio:$(".Folio").val(),
			OV_TRACKING_COM:$("#Prov_ID option:selected").text(),
			OV_TRACKING_NUMBER:Guia
		}
	}
	$.post("/pz/wms/Almacen/Salida/Alm_Salida_Ajax.asp",Datos,function(data){
		var response = JSON.parse(data)
			if(response.result == 1){
				$(".nuevos").removeClass('bg-success')
				var tr = "<tr class='nuevos'><td>"+Datos.OV_Folio+"</td><td>"+Datos.OV_TRACKING_NUMBER+"</td><td>"+$("#Destino").val()+"</td><td>"+$("#sUsuarioSes").val()+"</td></tr>"
				$("#Actividades").prepend(tr)
				
				$("#ID").val("")
				$("#EsOV").val("")
				$('.Folio').val("")
				$('.Folio').focus()
				$('.Guia').prop('disabled',true)
				$('.Guia').val("") 
				
				var sTipo = "success"; 
				Guias.push({"Folio":Datos.OV_Folio,"Guia":Datos.OV_TRACKING_NUMBER,"Destino":$("#Destino").val(),"Usuario Escaneo":$("#sUsuarioSes").val()})
			   	$("#Destino").val("")

					ShippingLyde(Datos.OV_ID,Datos.OV_TRACKING_NUMBER,Datos.OV_TRACKING_COM)
			}else{
				var sTipo = "error";   
			}
			Avisa(sTipo,"Aviso",response.message);		
	});
}
$(".btnDescargaFolios").click(function(){
	var ws = XLSX.utils.json_to_sheet(Guias);
	var wb = XLSX.utils.book_new(); XLSX.utils.book_append_sheet(wb, ws, "Guias");
	XLSX.writeFile(wb, "MANIFIESTO "+Fecha+".xlsx");

});



var DHLEjecutor = {
		GetLayout:function(){
			$.post("/pz/wms/Almacen/Salida/Alm_Salida_Ajax.asp",{Tarea:5},function(data){
				$('.dvGuiaDHL').html(data)
			});
		},
		GetPedidoID:function(Folio,h,ElInput){
			$.post("/pz/wms/Almacen/Salida/Alm_Salida_Ajax.asp",{Tarea:6,Folio:Folio},function(data){
				var response = JSON.parse(data)
				if(response.result == 1){
					DHLEjecutor.GetGuia(response.data,h)
				}else{
					swal({
						  title: response.message,
						  text: "Se ha producido un error al generar la gu&iacute;a",
						  type: "warning",
						  closeOnConfirm: true
						},
						function(data){
							$('.FolioDHL').prop('disabled',false)
							$('.FolioDHL').val("")
					});	
				}
				console.log(response)
			});
		},
		GetGuia:function(ov_id,ElInput){
			console.log(ov_id[0])
			$.ajax({
				type: 'POST',
				contentType:'application/json',
				url: "http://198.38.94.238:8543/api/Dhl?OV_ID="+ov_id,
				success: function(response){
					console.log(response) 
					if(response.result == 1){
						ShippingLyde(ov_id[0],response.data.Guia,"DHL");	
						DHLEjecutor.ImprimeGuia(response.data.PDF,ElInput);
					}else{
						ElInput.prop('disabled',false)
						swal({
							  title: "Error",
							  text: "Se ha producido un error al generar la gu&iacute;a",
							  type: "warning",
							  closeOnConfirm: true,
							  html: true
							},
							function(data){
								ElInput.val("")
						});	
					}
				},
				error: function (jqXHR, textStatus, errorThrown) { 
				swal({
					title: "Error en API",
					text: "Se ha poducido un error en el servicio",
					type: "warning",
					confirmButtonColor: "#57D9DF",
					confirmButtonText: "Ok!",
					closeOnConfirm: true,
					html: true
				});
			}

			});
		},
		ImprimeGuia:function(guia,ElInput) {
			
			var winparams = 'dependent=yes,locationbar=no,scrollbars=yes,menubar=yes,'+
            'resizable,screenX=50,screenY=50,width=850,height=1050';

			var htmlPop = '<embed width=100% height=100%'
							 + ' type="application/pdf"'
							 + ' src="data:application/pdf;base64,'
							 + guia
							 + '"></embed>'; 
	
			var printWindow = window.open ("", "PDF", winparams);
			printWindow.document.write (htmlPop);
			ElInput.prop('disabled',false)
			ElInput.val("")
		}
	}

function ShippingLyde(OV_ID,guia,Prov){
	var data = {
		"Tarea":3,
		"OV_ID":OV_ID,
		"Estatus":4,
		"Guia": guia,
		"Transportista":Prov
	}
	var myJSON = JSON.stringify(data);
		$.ajax({
			type: 'post',
			contentType:'application/json',
			data: myJSON,
			url: "http://198.38.94.4:1117/lyde/api/ServiceZZ",
			success: function(datos){
				//console.log(datos) 
				TransitLyde(OV_ID)
			}
		});
}
function TransitLyde(OV_ID){
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


</script>
