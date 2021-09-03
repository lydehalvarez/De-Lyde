<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../../Includes/iqon.asp" -->


<div class="form-horizontal">
    <div class="row">
        <div class="col-lg-12">
            <div class="ibox float-e-margins">
                <div class="ibox-content ibox-heading">
                    <h1>Control de calidad</h1>
                    <small><i class="fa fa-map-marker"></i>&nbsp;Esta ventana permite al usuario poder verificar si el pedido realmente cuenta con lo solicitado</small>
                </div>
                <div class="ibox-content">
                    <div class="row">
                        <div class="col-lg-5">
                            <div class="form-group">
                                <div class="col-md-6 text-left">
                                    <input class="form-control Pedido" placeholder="Escanea el pedido" type="text" autocomplete="off" value=""/>
                                </div>
                                <div class="col-md-6 text-left" id="divPedido">
                                    <input class="form-control Serie" placeholder="Escanea la serie" type="text" autocomplete="off" value=""/>
                                </div>
                            </div>
                            <div class="form-group">
                                <div class="col-md-4 text-left">
                                    <input type="button" class="btn btn-success btnNuevo" value="Limpia pedido"/>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-7">
                            <div class="form-group">
                                <div class="col-md-4"><h2>Pedido:&nbsp;<strong><span id="Pedido"></span></strong></h2></div>
                                <div class="col-md-4"><h2>Cantidad SKU:&nbsp;<strong><span id="Cantidad"></span></strong></h2></div>
                                <div class="col-md-4"><h2>Cantidad items:&nbsp;<strong><span id="Cantidad_items"></span></strong></h2></div>
                            </div>
                            <table class="table table-bordered table-hover" style="font-size: medium;">
                            	<thead>
                                    <tr>
                                        <th width="45%">Descripci&oacute;n</th>
                                        <th width="15%">SKU</th>
                                        <th width="15%">Cantidad</th>
                                        <th width="15%">Escaneado</th>
                                        <th width="30%">Serie</th>
                                    </tr>
                                </thead>
                                <tbody id="Articulos">
                                
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>                
            </div>
        </div>
    </div>
</div>

<input type="hidden" id="ID" value="" />
<script type="application/javascript">


$('.Pedido').on('keypress',function(e) {
    if(e.which == 13) {
		var Pedido = $(this).val().replace("'","-")
		CCFunciones.BuscaPedido(Pedido)
    }
});

$('.btnNuevo').click(function(e) {
    e.preventDefault();
	$('.Pedido').val("");
	$('.Pedido').focus();
});


$('.Serie').on('keypress',function(e) {
    if(e.which == 13) {
		CCFunciones.BuscaSerie($(this).val());
    }
});

var CCFunciones = {
	BuscaPedido:function(Pedido){
		$.ajax({
			type: 'GET',
			cache:false,
			async:true,
			contentType:'application/json',
			url: "http://192.168.254.10:8081/api/s2012/ControlCalidad/Pedido?Pedido="+Pedido,
			success: function(response){
				console.log(response) 
				if(response.result == 1){
					$('#ID').val(response.data.ID)
					$('#Pedido').html(Pedido)
					var len = response.data.Articulo.length
					$('#Cantidad').html(len)
					var Cuenta = 0
					for(var i = 0;i<len;i++){
						Cuenta = Cuenta + response.data.Articulo[i].Cantidad
					}
					$('#Cantidad_items').html(Cuenta)
					$('.Serie').focus()
					Avisa("success","Aviso","Datos obtenidos correctamente");
					$('#Articulos').html(CCFunciones.GeneraTabla(response.data.Articulo))
				}else{
					var texto = "Comunicarse al &aacute;rea de sistemas"
					if(response.message != null){
						texto = response.message
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
	BuscaSerie:function(Serie){
		$.ajax({
			type: 'GET',
			cache:false,
			async:true,
			contentType:'application/json',
			url: "http://192.168.254.10:8081/api/s2012/ControlCalidad/Pedido/Serie?ID="+$('#ID').val()+"&Serie="+Serie,
			success: function(response){
				console.log(response) 
				if(response.result == 1){
					$('#'+Serie).addClass('bg-primary');
					$('.Serie').val("");
					$('.Serie').focus();
				}else{
					var texto = "Comunicarse al &aacute;rea de sistemas"
					if(response.message != null){
						texto = response.message
					}
					swal({
					  title: 'Lo sentimos algo sali&oacute; mal',
					  text: texto,
					  type: "error",
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
		 //console.log(arr)
		 for(var i = 0;i<arr.length;i++){ 
			 Table = Table + '<tr id="'+arr[i].Serie+'"><td>'+arr[i].Nombre+'</td><td>'+arr[i].SKU+'</td><td>'+arr[i].Cantidad+'</td><td><span  id="Renglon_'+arr[i].TA_ID+'_'+arr[i].TAA_ID+'">0</span><input type="hidden" value="" id="RenglonVal_'+arr[i].TA_ID+'_'+arr[i].TAA_ID+'"/></td><td>'+arr[i].Serie+'</td></tr>'
		 }
		 return Table
	},

}

</script>
