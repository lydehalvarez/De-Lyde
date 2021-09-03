<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->

<%
	var CuentaHoy = BuscaSoloUnDato("COUNT(*)","TransferenciaAlmacen","CAST(TA_FechaRayosX as date) = CAST(GETDATE() as date)",-1,0);


	var Test = 1
%>





<!--
<div class="form-horizontal" id="frmDatos">
    <div class="row">
        <div class="col-lg-12">
                <div class="ibox float-e-margins">
                    <div class="ibox-content">
                        <div class="form-group" id="divEncabezado">
                            <label class="control-label col-md-12" style="text-align: left;"><h1>RAYOS X</h1></label>
                        </div>
                        <div class="form-group">
                            <input class="form-control TRA"  id= "TRA" style="width:80%" placeholder="Escanea la Transferencia" type="text" autocomplete="off" value="" onkeydown="FunctionRayosX.InsertTRA(event);"/>
                        </div>
                        <div class="col-sm-6 m-b-xs" id="dvContador">
                    	<div id="dvTablaInfoTRA"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
-->
<div class="form-horizontal" id="frmDatos">
    <div class="row">
        <div class="col-lg-12">
            <div class="ibox float-e-margins">
                <div class="ibox-title">
                    <h4>Escaneo para rayos x</h4>
                </div>
                <div class="ibox-content ibox-heading">
                    <h1>RAYOS X</h1>
                    <small><i class="fa fa-map-marker"> </i> Esta ventana permite al usuario escanear ya sea la gu&iacute;a o el folio para ingresarlo por rayos x.</small>
                </div>
                <div class="ibox-content">
                    <div class="form-group" id="divEncabezado">
                        <div class="col-md-3 text-left">
                            <input class="form-control FolioRayo" placeholder="Escanea la etiqueta de la caja" type="text" autocomplete="off" value=""/>
                        </div>
                	</div>
                    <div class="form-group" id="divEncabezado">
                        <div class="col-md-6 text-left">
							<h1><strong>Cuenta de hoy: <span id="CuentaHoy"><%=CuentaHoy%></span></strong></h1>
                        </div>
                	</div>
                    <div class="form-group" id="divEncabezado">
                        <div class="col-md-4 text-left">
							<h1>Caja: <strong><span id="RecienEscaneado"></span></strong></h1>
                        </div>
                        <div class="col-md-4 text-left">
							<h1><strong>Remisi&oacute;n:<span id="Remision"></span></strong></h1>
                        </div>
                        <div class="col-md-4 text-left">
							<h1><strong>N&uacute;mero de cajas: <span id="CajasEscaneado"></span>/<span id="CajasTotal"></span></strong></h1>
                        </div>
                	</div>
                    <div class="form-group" id="divEncabezado">
                        <div class="row">
                            <div class="col-lg-6">
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th>
                                                Nombre
                                            </th>
                                            <th>
                                                Cantidad</h2>
                                            </th>
                                        </tr>
                                    </thead>
                                    <tbody id="dvTablaRayosX"></tbody>
                                </table>
                             </div>   
                            <div class="col-lg-6">
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th>#</th>
                                            <th>Caja</th>
                                            <th>Usuario</th>
                                            <th>Fecha</th>
                                        </tr>
                                    </thead>
                                    <tbody id="dvTablaCajas"></tbody>
                                </table>
                             </div>   
                        </div>
                    </div>
                </div>                
            </div>
        </div>
    </div>
</div>
<input type="hidden" id="TotalHoy" value="<%=CuentaHoy%>"/>
<script type="text/javascript">

$(document).ready(function(e) {
    $('.FolioRayo').focus();
});

$('.FolioRayo').on('keypress',function(e) {
    if(e.which == 13) {
		//FunctionRayosX.ColocaFolio($(this).val());
		FunctionRayosX.Caja($(this).val());
    }
});


function beep() { var snd = new Audio("/Sonido/Error.mp3"); snd.play(); }
 
var FunctionRayosX = {
	InsertTRA:function(event){
		var keyNum = event.which || event.keyCode;
		  
		if( keyNum== 13 ){

			$.ajax({
				method: "POST",
				url: "/pz/wms/Transferencia/RayosX_Ajax.asp?",
				data: {
					TRA:$('.TRA').val(),
					Tarea:1
				},
				cache: false,
				success: function (data) {
					$('#TRA').val("")
					$('#TRA').focus()
					   var response = JSON.parse(data)
					   
					   if(response.result == 1){
						    $('#Contenido').css('background-color', 'white');
						   	$("#dvTablaInfoTRA").css('background-color', 'white');
						   	$("#dvTablaInfo").css('background-color', 'white');
						   	$("#divEncabezado").css('background-color', 'white');
						   	$("#dvContador").css('background-color', 'white');
							$("#dvTablaInfoTRA").html('<font size = 10>' + response.message + ' </font>')
   							$("#dvContador").html('<font size = 7>Escaneos de hoy: '  + response.contador + ' </font>')
							$("#dvTablaInfoTRA").html('<font size = 10>' + response.message + ' </font>')
							$("#dvContador").html('<font size = 7>Escaneos de hoy: '  + response.contador + ' </font>')
					   }else{
						    $('#Contenido').css('background-color', 'red');
						   	$("#dvTablaInfoTRA").css('background-color', 'red');
						   	$("#dvTablaInfo").css('background-color', 'red');
						   	$("#divEncabezado").css('background-color', 'red');
						   	$("#dvContador").css('background-color', 'red');
							$("#dvTablaInfoTRA").html('<p style="color:white;"><font size = 10>' + response.message + ' </font></p>')
   							$("#dvContador").html('<p style="color:white;"><font size = 7>Escaneos de hoy: '  + response.contador + ' </font></p>')
							$("#TRA").hide();
							setInterval('beep()',2000)
						
					   }

			}
			
			});
		}
	},
	ColocaFolio:function(fol){
		var SinGuion = fol.replace("'","-");
		setTimeout(function(){$('.FolioRayo').val("");},100)
		var datos = {
			Folio:SinGuion,
			IDUsuario:$('#IDUsuario').val(),
			Test:<%=Test%>
		};
		var myJSON = JSON.stringify(datos); 
		$.ajax({
			type: 'POST',
			async:true,
			cache:false,
			data: myJSON,
			contentType:'application/json',
			url: "https://wms.lydeapi.com/api/s2012/RayosX",
			success: function(response){
				//console.log(response)
				if(response.result == 1){
					var cuenta = parseInt($("#TotalHoy").val())
					cuenta = cuenta + 1
					$('#RecienEscaneado').html(SinGuion)
					$("#TotalHoy").val(cuenta)
					$("#CuentaHoy").html(cuenta)
					$('#dvTablaRayosX').html(FunctionRayosX.GeneraTabla(response.data.Info));
					$('#CajasEscaneado').html(response.data.NumCaja);
                    $('#Remision').html(response.data.Pedido.Remision);
					Avisa("success","Aviso","Escaneado Ok")
				}else{
					beep();
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
			}
		});
	},
	Caja:function(fol){
		var SinGuion = fol.replace("'","-");
		setTimeout(function(){$('.FolioRayo').val("");},100)
		var datos = {
			Folio:SinGuion,
			IDUsuario:$('#IDUsuario').val(),
			Test:<%=Test%>
		};
		$.ajax({
			type: 'POST',
			cache:false, 
			timeout:0,
			data: JSON.stringify(datos),
			contentType:'application/json',
			url: "https://wms.lydeapi.com/api/XRay/Box",
			success: function(response){
				console.log(response)
				if(response.result == 1){
					var cuenta = parseInt($("#TotalHoy").val())
					cuenta = cuenta + 1
					$("#TotalHoy").val(cuenta)
					$("#CuentaHoy").html(cuenta)
					Avisa("success","Aviso","Escaneado Ok")
				}else{
					beep();
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
				$('#RecienEscaneado').html(SinGuion)
				$('#Remision').html(response.data.Pedido.Remision);
				$('#CajasEscaneado').html(response.data.Escaneadas);
				$('#CajasTotal').html(response.data.NumCaja);
				$('#dvTablaRayosX').html(FunctionRayosX.GeneraTabla(response.data.Info));
				$('#dvTablaCajas').html(FunctionRayosX.TablaCajas(response.data.Cajas,response.data.TAC_ID));
			}
		});
	},
	GeneraTabla:function(arr){
		 var Table = ''	
		 for(var i = 0;i<arr.length;i++){
			 Table = Table + '<tr><td><strong>'+arr[i].Pro_Nombre+'</strong></td><td><strong>'+arr[i].Cantidad+'</strong></td></tr>'
		 }
		 return Table
	},
	TablaCajas:function(arr,TAC_ID){
		 var Table = ''
		 var Esca = ''	
		 for(var i = 0;i<arr.length;i++){
			 if(TAC_ID == parseInt(arr[i].Num)){Esca = "bg-primary"}else{Esca = ""}
			 Table = Table + '<tr class="'+Esca+'"><td><strong>'+arr[i].Num+'</strong></td><td><strong>'+arr[i].Caja+'</strong></td><td><strong>'+arr[i].Usuario+'</strong></td><td><strong>'+arr[i].Fecha+'</strong></td></tr>'
		 }
		 return Table
	 }
}
</script>            