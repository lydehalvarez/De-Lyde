<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../../Includes/iqon.asp" -->
<link href="/Template/inspina/css/plugins/select2/select2.min.css" rel="stylesheet">
<div class="form-horizontal" id="frmDatos">
        <div class="ibox-content">
            <div class="form-group"> 
                <label class="control-label col-md-2"><strong>Proveedor</strong></label>
                    <div class="col-md-3">
						<%CargaCombo("Prov_ID"," class='form-control'","Prov_ID","Prov_Nombre",
                        "Proveedor","","Prov_Nombre",Parametro("Prov_ID",-1),0,"Selecciona","Editar")					   
                        %>
                    </div> 
                    <div class="col-md-4">
                        <button type="button" class="btn btn-info addProducto">Agregar</button>
                    </div> 
                    <div class="col-md-2">
                        <button type="button" class="btn btn-danger endPO">Finalizar Orden</button>
                    </div> 
			</div>
            
            <table class="table table-striped table-hover">
            <thead>
            	<th>Producto</th>
            	<th>Cantidad</th>
            	<th>Precio unitario</th>
            	<th>Acciones</th>
            </thead>
            <tbody id="AddRow">
            </tbody>
            </table>
        </div>
</div>

<div class="modal fade" id="BatmanModalCompra" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="myModalLabel">Agregar nuevo producto</h4>
      </div>
      <div class="modal-body">
        <div class="form-horizontal">
            <div class="form-group">
                <label class="control-label col-md-3">Tipo de producto</label>
                <div class="col-lg-8">
                 <%CargaCombo("TPro_ID"," class='form-control getdatos TPro_ID' ",
                    "TPro_ID","TPro_Nombre","Cat_TipoProducto","","TPro_Nombre",
                    -1,0,"Selecciona","Editar")%>
                 </div>
             </div>
            <div id="cmboCategoria" class="clean"></div>
            <div id="cmboSubCategoria" class="clean"></div>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Cancelar</button>
        <button type="button" class="btn btn-primary btnAddProducto">Agregar</button>
      </div>
    </div>
  </div>
</div>

<script src="/Template/inspina/js/plugins/select2/select2.full.min.js"></script>
<script type="application/javascript">
$(".addProducto").hide()
$(".endPO").hide()
$(document).ready(function(){
	$("#Prov_ID").select2();
});

	$("#Prov_ID").change(function(e) {
		e.preventDefault()
		$(".addProducto").hide('slow')
		$(".addProducto").show('slow')
    });
	
	$('.TPro_ID').change(function(e) {
		e.preventDefault()
		$(".clean").hide('slow')
		$(".clean").html("")
		NuevaOrden.GetCategoria($(this))
		$(".clean").show('slow')
	});
	
	$("#cmboCategoria").on("change", ".ProC_ID", function(){
		$(".clean").hide('slow')
		NuevaOrden.GetSubCategoria($(this))
		$(".clean").show('slow')
    });
	
	//buttons

	var Renglon = 0
    $(".addProducto").click(function(e){
		e.preventDefault()
		$('#BatmanModalCompra').modal("show") 
    });
    $(".btnAddProducto").click(function(e){
		e.preventDefault()
		$('#BatmanModalCompra').modal('toggle');
		$("#Prov_ID").prop('disabled',true) 
		$(".endPO").show('slow')
		Renglon++
		NuevaOrden.CargaRenglon(Renglon)
    });
	$("#AddRow").on("click", ".btnConfirma", function(){
		var valor = $(this).val();
		$(this).hide('slow');
		$(".datos"+valor).prop('disabled',true)
    });
	
	$("#AddRow").on("click", ".btnBorrarRenglon", function(e){
		e.preventDefault();
		var valor = $(this).val()
		$(".renglon"+valor).hide('slow')
		setTimeout(function(){$(".renglon"+valor).remove()},2000)
    });
	
	$(".endPO").click(function(e) {
        e.preventDefault();
		swal({
			title: "Finalizar Orden de compra",
			text: "<strong>Si desea finalizar la orden de compra oprima continuar</strong>",
			type: "success",
			showCancelButton: true,
			confirmButtonColor: "#57D9DF",
			confirmButtonText: "Continuar!",
			closeOnConfirm: true,
			closeOnCancel: true,
			html: true
		}, function (data) {
			if(data){
				NuevaOrden.ColocaOrden()
			}
		});
    });
	
var NuevaOrden = {
	GetCategoria:function(dato){
		$.post("/pz/wms/OC/Formatos/NuevaOrden_Ajax.asp",{
			Tarea:3
			,TPro_ID:dato.val()
			}
		, function(data){
			$('#cmboCategoria').html(data)
		});				
	},
	GetSubCategoria:function(dato){
		$.post("/pz/wms/OC/Formatos/NuevaOrden_Ajax.asp",{
			Tarea:4
			,TPro_ID:$(".TPro_ID").val()
			,ProC_ID:dato.val()
			}
		, function(data){
			$('#cmboSubCategoria').html(data)
		});				
	},
	CargaRenglon:function(v){
	 var td = '<tr id="cargando"><td colspan="3"><div class="ibox-content"><div class="spiner-example"><div class="sk-spinner sk-spinner-wave"><div class="sk-rect1"></div><div class="sk-rect2"></div><div class="sk-rect3"></div><div class="sk-rect4"></div><div class="sk-rect5"></div></div></div></div></td></tr>'
		$("#AddRow").prepend(td)
		$.post("/pz/wms/OC/Formatos/NuevaOrden_Ajax.asp",{
		Tarea:1,
		Valor:v,
		Prov_ID:$('#Prov_ID').val(),
		TPro_ID:$(".TPro_ID").val(),
		ProC_ID:$(".ProC_ID").val()
		}
    , function(data){
		$("#cargando").remove()
		$("#AddRow").prepend(data)
		$("#Prod_ID"+v).select2();
	});
	},
	ColocaOrden:function(){
		$.post("/pz/wms/OC/Formatos/NuevaOrden_Ajax.asp",{
			Tarea:5
			,Prov_ID:$("#Prov_ID").val()
			,TPro_ID:$(".TPro_ID").val()
			,ProC_ID:$(".ProC_ID").val()
			}
		, function(data){
			var response = JSON.parse(data)
			if(response.result > -1){
				NuevaOrden.GetArticulos(response.result)
			}
		});				
	},
	GetArticulos:function(OC_ID){
		var cantidad = []
		$(".Cantidad").each(function(indice,elemento) {
			cantidad[indice] = $(this).val()
		});
		var precio = []
		$(".Precio").each(function(indice,elemento) {
			precio[indice] = $(this).val()
		});
		
		function newArray(Pro_ID,Cantidad,Precio){
			this.Pro_ID = Pro_ID;	
			this.Cantidad = Cantidad || 0;	
			this.Precio = Precio || 0;	
		}
		var NewDatos = []
		$(".combo").each(function(indice,elemento) {
			var nuevoObject = new newArray($(this).val(),cantidad[indice],precio[indice])
			NewDatos.push(nuevoObject)
		});
		console.log(NewDatos)
		
		$.each(NewDatos, function() {
			NuevaOrden.PutArticulos(this,OC_ID)
		});		
		
	},
	PutArticulos:function(obj,OC_ID){
		$.post("/pz/wms/OC/Formatos/NuevaOrden_Ajax.asp",{
			Tarea:6
			,Prov_ID:$("#Prov_ID").val()
			,OC_ID:OC_ID
			,Pro_ID:obj.Pro_ID
			,Cantidad:obj.Cantidad
			,Precio:obj.Precio
			}
		, function(data){
			var response = JSON.parse(data)
			if(response.result > -1){
				CambiaSiguienteVentana(862)
			}
		});				
	}
}
	
	
</script>