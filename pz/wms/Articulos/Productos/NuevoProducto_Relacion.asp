<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../../Includes/iqon.asp" -->

<style>

.dimension-fields{
    display: flex;
/*  border: 1px solid #b0c0d6;*/
}
.dimension-fields .dimension-input {
    flex-basis: 33%;
}
.dimension-fields .dimension-seperator {
    padding: 8px 7px;
    color: #ccc;
    background-color: #fff;
    font-size: 12px;
}
.required {
    color: #b94a48;
}
.required:after {
    content: "*";
    color: #b94a48;
}
.Espacio {
    margin-top: 35px;
    margin-bottom: 35px;
}
.ColorTitulo{
	color: #1ab394;
	/*color: #14c5b5;	*/
}
</style>

<div class="form-horizontal">
    <div class="row">
        <div class="ibox float-e-margins">
            <div class="ibox-content">
<!-------------------Cliente---------------------------------------------------->        
                <div class="form-group">
                    <legend class="control-label col-md-3 ColorTitulo">Cliente&nbsp;&nbsp;<i class="fa fa-user"></i></legend>
                    <div class="col-md-9"><button type="button" class="btn btn-md btn-info btnAddClient">A&ntilde;adir</button></div>
                </div>
                <div class="new_client_loading"><div class="spiner-example"><div class="sk-spinner sk-spinner-rotating-plane"></div></div></div>
                <div class="new_client"></div>
                
            </div>
            <div class="ibox-content">
<!-------------------Porveedor---------------------------------------------------->        
                <div class="form-group">
                    <legend class="control-label col-md-3 ColorTitulo">Proveedor&nbsp;&nbsp;<i class="fa fa-user"></i></legend>
                    <div class="col-md-9"><button type="button" class="btn btn-md btn-info btnAddProv">A&ntilde;adir</button></div>
                </div>
                <div class="new_prov_loading"><div class="spiner-example"><div class="sk-spinner sk-spinner-rotating-plane"></div></div></div>
                <div class="new_prov"></div>
            </div>
        </div>
    </div>
</div>



<script type="application/javascript">
var RenglonCli = 0
var RenglonProv = 0

$('.new_client_loading').hide();
$('.new_prov_loading').hide();

$('.btnAddClient').click(function(e) {
    e.preventDefault();
	FuncionRelacion.Cliente();
});

$('.btnAddProv').click(function(e) {
    e.preventDefault();
	FuncionRelacion.Proveedor();
});
$(".new_client").on("click", ".btnDeleteCli", function(){
	var valor = $(this).val();
	$('#Cli'+valor).hide('slow');
	setTimeout(function(){$('#Cli'+valor).remove()},1500)
	
});
$(".new_prov").on("click", ".btnDeleteProv", function(){
	var valor = $(this).val();
	$('#Prov'+valor).hide('slow');
	setTimeout(function(){$('#Prov'+valor).remove()},1500)
});
$(".new_client").on("click", ".btnSaveCli", function(){
	var valor = $(this).val()
	FuncionRelacion.SaveCliente(valor);
});
$(".new_prov").on("click", ".btnSaveProv", function(){
	var valor = $(this).val();
	FuncionRelacion.SaveProveedor(valor);
});


var FuncionRelacion = {
	Cliente:function(){
		$('.new_client_loading').show('slow')
		RenglonCli++
		$.post("/pz/wms/Articulos/Productos/NuevoProducto_Relacion_Cliente.asp",{Renglon:RenglonCli}, function(data){
			$('.new_client_loading').hide('slow')
			$('.new_client').prepend(data)
		});				
	},
	Proveedor:function(){
		$('.new_prov_loading').show('slow')
		RenglonProv++
		$.post("/pz/wms/Articulos/Productos/NuevoProducto_Relacion_Proveedor.asp",{Renglon:RenglonProv}, function(data){
			$('.new_prov_loading').hide('slow')
			$('.new_prov').prepend(data)
		});	
	},
	SaveCliente:function(renglon){
		var ClienteData = {
			Tarea:5,
			Pro_ID:$('#Pro_ID').val(),
			Cli_ID: $('#Cli_ID'+renglon).val(),
			SKU:$('.sku_client'+renglon).val(),
			Nombre:$('.name_client'+renglon).val(),
			Descripcion:$('.description_client'+renglon).val()
		}
		$('.Cli'+renglon).prop('disabled',true)
		console.log(ClienteData)
		
		FuncionRelacion.SaveDataCliProv(ClienteData)
	},
	SaveProveedor:function(renglon){
		var ProveedorData = {
			Tarea:6,
			Pro_ID:$('#Pro_ID').val(),
			Prov_ID: $('#Prov_ID'+renglon).val(),
			SKU:$('.sku_prov'+renglon).val(),
			Nombre:$('.name_prov'+renglon).val(),
			Descripcion:$('.description_prov'+renglon).val()
		}
		$('.Prov'+renglon).prop('disabled',true)
		console.log(ProveedorData)
		
		FuncionRelacion.SaveDataCliProv(ProveedorData)
	},
	SaveDataCliProv:function(datos){
		$.post("/pz/wms/Articulos/Productos/NuevoProducto_Ajax.asp",datos, function(data){
			var response = JSON.parse(data)
			console.log(response)
		});	
	}
}
</script>


