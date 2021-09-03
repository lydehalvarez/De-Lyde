<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->

<%
	var CuentaHoy = BuscaSoloUnDato("COUNT(*)","TransferenciaAlmacen","CAST(TA_FechaRayosX as date) = CAST(GETDATE() as date)",-1,0);

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
                    <small><i class="fa fa-map-marker"></i>Esta ventana permite al usuario escanear ya sea la gu&iacute;a o el folio para ingresarlo por rayos x.</small>
                </div>
                <div class="ibox-content">
                    <div class="form-group" id="divEncabezado">
                        <div class="col-md-3 text-left">
                            <input class="form-control FolioRayo" placeholder="Escanea la Transferencia" type="text" autocomplete="off" value=""/>
                        </div>
                	</div>
                    <div class="form-group" id="divEncabezado">
                        <div class="col-md-6 text-left">
							<h1><strong>Cuenta de hoy: <span id="CuentaHoy"><%=CuentaHoy%></span></strong></h1>
                        </div>
                	</div>
                    <div class="form-group" id="divEncabezado">
                        <div class="col-md-6 text-left">
							<h1><strong><span id="RecienEscaneado"></span></strong></h1>
                        </div>
                        <div class="col-md-6 text-left">
							<h1><strong>Numero de cajas:<span id="CajasEscaneado"></span></strong></h1>
                        </div>
                	</div>
                    <div>
                    	<table class="table">
                        <thead>
                         <tr>
                         	<th><h1>Nombre</h1></th>
                         	<th><h1>Cantidad</h1></th>
                         </tr>
                        </thead>
                        	<tbody id="dvTablaRayosX">
                        	</tbody>
                        </table>
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
		FunctionRayosX.ColocaFolio($(this).val())
    }
});
var _url = "https://wms.lydeapi.com"

function beep() { var snd = new Audio("http://sonidosmp3gratis.com/sounds/007134602_prev.mp3"); snd.play(); }
 
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
			Test:1
		};
		console.log(datos)
		var myJSON = JSON.stringify(datos); 
		$.ajax({
			type: 'POST',
			async:true,
			cache:false,
			data: myJSON,
			contentType:'application/json',
			url: _url+"/api/s2012/RayosX",
			success: function(response){
				console.log(response)
				if(response.result == 1){
					var cuenta = parseInt($("#TotalHoy").val())
					cuenta = cuenta + 1
					$('#RecienEscaneado').html(SinGuion)
					$("#TotalHoy").val(cuenta)
					$("#CuentaHoy").html(cuenta)
					$('#dvTablaRayosX').html(FunctionRayosX.GeneraTabla(response.data.Info));
					$('#CajasEscaneado').html(response.data.NumCaja);
					Avisa("success","Aviso","Escaneado Ok")
					FunctionRayosX.NotificaDCats(response.data.ID,1)
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
	GeneraTabla:function(arr){
		 var Table = ''	
		 for(var i = 0;i<arr.length;i++){
			 Table = Table + '<tr><td><h1><strong>'+arr[i].Pro_Nombre+'</strong></h1></td><td><h1><strong>'+arr[i].Cantidad+'</strong></h1></td></tr>'
		 }
		 return Table
	 },
	 NotificaDCats:function(TA_ID,test){
		$.ajax({
			type: 'GET',
			async:true,
			cache:false,
			contentType:'application/json',
			url: _url+"/api/DCats/Test/LydeRecibeRemision?TA_ID="+TA_ID+"&Test=1",
			success: function(response){
				console.log(response)
			}
		});
	 }

}
</script>            