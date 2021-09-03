<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../../Includes/iqon.asp" -->


<div class="form-horizontal">
    <div class="row">
        <div class="col-lg-12">
            <div class="ibox float-e-margins">
                <div class="ibox-content ibox-heading">
                    <h1>Escaneo multiple</h1>
                    <small><i class="fa fa-map-marker"></i>&nbsp;Esta ventana permite escanear una gu&iacute;a y asignarsela a multiples pedidos</small>
                </div>
                <div class="ibox-content">
                    <div class="row">
                        <div class="col-lg-6">
                            <div class="form-group">
                                <div class="col-md-6 text-left">
                                    <input class="form-control GuiaMu" placeholder="Escanea la gu&iacute;a" type="text" autocomplete="off" value=""/>
                                </div>
                                <div class="col-md-6 text-left" id="divPedido">
                                    <input class="form-control Pedido" placeholder="Escanea el pedido" type="text" autocomplete="off" value=""/>
                                </div>
                            </div>
                            <div class="form-group" id="Libera">
                                <div class="col-md-4 text-left">
                                    <input type="button" class="btn btn-success btnLiberaGuia" value="Liberar gu&iacute;a"/>
                                </div>
                                <div class="col-md-8 text-right">
                                    <input type="button" class="btn btn-primary btnFinaliza" value="Finaliza carga"/>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-6">
                            <table class="table table-striped table-bordered table-hover" style="font-size: medium;">
                            	<thead>
                                    <tr>
                                        <th width="30%">Pedidio</th>
                                        <th width="40%">Guia</th>
                                        <th width="10%">Tienda</th>
                                        <th width="20%">Acci&oacute;n</th>
                                    </tr>
                                </thead>
                                <tbody id="Acumulados">
                                
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>                
            </div>
        </div>
    </div>
</div>


<script type="application/javascript">

$('#Libera').hide()
$('#divPedido').hide()

$('.GuiaMu').on('keypress',function(e) {
    if(e.which == 13) {
		$(this).prop('disabled',true)
		var Guia = $(this).val().trim()
		MultiGuiaFunciones.VerificaGuia(Guia)
    }
});

$('.btnLiberaGuia').click(function(e) {
	e.preventDefault();
	MultiGuiaFunciones.Liberacion();
});

$('.Pedido').on('keypress',function(e) {
    if(e.which == 13) {
		var Pedido = $(this).val().replace("'","-")
		MultiGuiaFunciones.EscaneaPedidio(Pedido.trim());
    }
});

var MultiGuiaFunciones = {
	BloqueoGuia:function(){
		$('#Libera').show('slow');
		$('#divPedido').show('slow');
		$('.Pedido').focus()
		$('#Acumulados').show('slow')
	},
	Liberacion:function(){
		$('.GuiaMu').prop('disabled',false);
		$('.GuiaMu').val("");
		$('#Libera').hide('slow');
		$('#divPedido').hide('slow');
		$('#Acumulados').hide('slow',function(){$(this).html("")});
	},
	VerificaGuia:function(Guia){ 
		$.ajax({
			type: 'GET',
			contentType:'application/json',
			url: "https://wms.lydeapi.com/api/s2012/CargaGuia/VerificaGuia?Guia="+Guia,
			success: function(response){
				MultiGuiaFunciones.BloqueoGuia();
				if(response.data != null){
					//console.log(response.data);
					$('#Acumulados').prepend(MultiGuiaFunciones.GeneraTabla(response.data)); 
				}else{
					swal({
					title: "Guia libre!",
					text: "Esta guia no cuenta con ningun pedido asigando!",
					type: "success"
					});
				}
			},
			error:function(){
				swal({
					title: "Ocurrio un error",
					text: response.message, 
					type: "error",
					html:true,
					closeOnConfirm: true
				}, function () {
				});
			}
		});
	},
	EscaneaPedidio:function(Pedido){
		$('.Pedido').val("");
		var request = {
			Pedido:Pedido, 
			Guia:$('.GuiaMu').val(),
			Transportista:$("#Prov_ID option:selected").text()
		}
		var myJSON = JSON.stringify(request);
		//console.log(request)
		$.ajax({
			type: 'POST',
			data:myJSON,
			contentType:'application/json',
			url: "https://wms.lydeapi.com/api/s2012/CargaGuia/GuiaMultiple",
			success: function(response){
				//console.log(response)
				if(response.result == 1){
					Avisa("success","Aviso","Guia a&ntilde;adida al pedido "+Pedido)
					$('#Acumulados').prepend(MultiGuiaFunciones.GeneraRenglon(response.data))
				}else{
				swal({
					title: "Ocurrio un error",
					text: response.message, 
					type: "error",
					closeOnConfirm: true,
					html:true
				}, function () {
				});
				}
			},
			error:function(){
			}
		});
	},
	GeneraRenglon:function(arr){
		 var Table = '<tr id="Pedido_'+arr.IDPedido+'"><td>'+arr.Pedido+'</td><td>'+arr.Guia+'</td><td>'+arr.Tienda+'</td><td><a data-pedido="'+arr.Pedido+'" onclick="MultiGuiaFunciones.BorraPedido('+arr.IDPedido+',$(this))"><i class="text-danger fa fa-trash"></i>&nbsp;Quitar</a></td></tr>'
		 return Table
	},
	GeneraTabla:function(arr){
		 var Table = ''	
		 console.log(arr)
		 for(var i = 0;i<arr.length;i++){ 
			 Table = Table + '<tr id="Pedido_'+arr[i].ID+'"><td>'+arr[i].Pedido+'</td><td>'+arr[i].Guia+'</td><td>'+arr[i].Tienda+'</td><td><a data-pedido="'+arr[i].Pedido+'" onclick="MultiGuiaFunciones.BorraPedido('+arr[i].ID+',$(this))"><i class="text-danger fa fa-trash"></i>&nbsp;Quitar</a></td></tr>'
		 }
		 return Table
	},
	BorraPedido:function(ID,ob){
		var Pedido = ob.data('pedido')
		swal({
			title: "Desea eliminar el pedido "+Pedido,
			text: "Al borrar la gu&iacute;a del pedido "+Pedido+" se podr&aacute; asignar otra gu&iacute;a a est&eacute;", 
			type: "warning",
			closeOnConfirm: true,
			showCancelButton: true,
			confirmButtonText: "Si, quitar!",
			html:true
		}, function (data) {
			if(data){
				MultiGuiaFunciones.Borra(ID,$("#Prov_ID option:selected").text())
			}
		});
	},
	Borra:function(ID,Transportista){
		$.ajax({
			type: 'GET',
			contentType:'application/json',
			url: "https://wms.lydeapi.com/api/s2012/EliminaGuia/MultiCarga?ID="+ID+"&Transportista="+Transportista,
			success: function(response){
				var Titulo = "";
				if(response.result == 1){
					Titulo = "Operaci&oacute;n exitosa"
					$('#Pedido_'+ID).hide( "slow", function() {
						$(this).remove()
					});
				}else{
					Titulo = "Ups!"
				}
				swal({
					title: Titulo,
					text: response.message,
					type: "success",
					html:true
				});
			},
			error:function(){
				swal({
					title: "Ocurri&oacute; un error",
					text: "Comunicarse al área de sistemas", 
					type: "error",
					html:true,
					closeOnConfirm: true
				}, function () {
				});
			}
		});
	}
}

</script>
