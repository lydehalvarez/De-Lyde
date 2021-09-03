<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../../Includes/iqon.asp" -->


<%
    var Cli_ID =  Parametro("Cli_ID",-1) 
%>

<div id="loading" class="text-center">
    <div class="row">
        <div class="col-lg-12">
            <div class="ibox float-e-margins">
                <div class="sk-spinner sk-spinner-three-bounce">
                    <div class="sk-bounce1"></div>
                    <div class="sk-bounce2"></div>
                    <div class="sk-bounce3"></div>
                </div>
                <div>Espere un momento por favor...</div>
            </div>
       </div> 
    </div>
</div>
<div id="GridPromo"></div>
    <div class="modal inmodal" id="mdlPromo" role="dialog" tabindex="-1" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content animated bounceInRight">
				<div class="modal-header">
					<button class="close" data-dismiss="modal" type="button"><span aria-hidden="true">&times;</span><span class="sr-only"></span></button>
					<h4 class="modal-title">Nuevo producto de promoci&oacute;n</h4>
				</div>
				<div class="modal-body">
                	<div class="form-horizontal">
                        <div class="form-group divpromo">
                            <label class="control-label col-md-3"><strong>Producto promoci&oacute;n</strong></label>
                            <div class="col-md-9"><%=CargaCombo("Promo_Pro_ID","class='form-control combman'","Pro_ID","Pro_SKU + ' - '+Pro_Nombre","Producto","Cli_ID = "+ Cli_ID,"Pro_ID","Edita",0,"Selecciona")%></div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-md-3"><strong>Producto regalo</strong></label>
                            <div class="col-md-9"><%CargaCombo("Regalo_Pro_ID","class='form-control combman'","Pro_ID","Pro_SKU + ' - '+Pro_Nombre","Producto","Cli_ID = "+ Cli_ID,"Pro_ID","Edita",0,"Selecciona")%></div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-md-3"><strong>Cantidad</strong></label>
                            <div class="col-md-9">
                                <input class="form-control" id="Prom_Cantidad" type="number" min="1" value="0">
                            </div>
                        </div>
                    </div>
				</div>
				<div class="modal-footer">
					<button class="btn btn-white btnCerrar" data-dismiss="modal" type="button">Cerrar</button>
                    <button class="btn btn-primary" onclick="Promo.GuardaPromo()" id="btnGuardaPromo" type="button">Guardar</button>
				</div>
			</div>
		</div>
	</div>
    
 
 
<script type="text/javascript">

   var Promo = {
	   BotonNuevo:function(){
		   $("#mdlPromo").modal('show');
	   }
	   ,LoadProducto:function(){
		   $('#loading').show('slow')
			$.ajax({
				method: "GET",
				url: "/pz/wms/Cliente/Promocion/Articulo_PromocionGrid.asp",
				data: { 
				  Prom_ID:$('#Prom_ID').val(),
				  Cli_ID:$('#Cli_ID').val()
				},
				cache: false,
				success: function(data){
					$('#GridPromo').html(data)
					$('#loading').hide('slow')
				},
				error:function(){
					$('#loading').hide('slow')
					
				}
			});  
		   
	   },
	  GuardaPromo:function(){
		var Cantidad = $('#Prom_Cantidad').val();
		var Regalo_Pro_ID = $('#Regalo_Pro_ID').val();
		var Promo_Pro_ID = $('#Promo_Pro_ID').val();
		if((Cantidad > 0) && (Promo_Pro_ID != -1) && (Regalo_Pro_ID != -1) ){
			$('#btnGuardaPromo').prop('disabled',true)
			swal({
			  title: "Guardar promoci&oacute;n",
			  text: 'Para terminar la promoci&oacute;n oprimer "Continuar"',
			  type: "success",
			  showCancelButton: true,
			  confirmButtonClass: "btn-success",
			  confirmButtonText: "Continuar" ,
			  closeOnConfirm: true,
			  html: true
			},
			function(data){
				if(data){
					$.ajax({
						method: "POST",
						url: "/pz/wms/Cliente/Promocion/Articulo_Promocion_Ajax.asp",
						data: { 
							  Prom_ID:$('#Prom_ID').val(),
							  Cli_ID:$('#Cli_ID').val(),
							  Regalo_Pro_ID:Regalo_Pro_ID,
							  Promo_Pro_ID:Promo_Pro_ID,
							  Prom_Cantidad: Cantidad,
							  IDUsuario:$('#IDUsuario').val(),
							  Tarea:1
						},
						cache: false,
						success: function(data){
								var response = JSON.parse(data)
								var Tipo = "success"
								if(response.result == 1){
									$("#mdlPromo").modal('hide');
									Promo.LoadProducto();
								}else{
									Tipo = "error"
								}
								Avisa(Tipo,"Aviso",response.message);
						}
					});
				}else{
					$('#btnGuardaPromo').prop('disabled',false)
				}
			});	
		}else{
			Avisa("error","Aviso","Verifica todos los campos");  
		}
   }
	   
	   
   } // Fin de Promo
   	Promo.LoadProducto();

   
</script>
