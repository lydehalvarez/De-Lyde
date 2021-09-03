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
                    <div class="col-md-7">
                    <button type="button" class="btn btn-info addCF">Agregar</button>
                    <button type="button" class="btn btn-info VerFinal">Ver final</button>
                    </div> 
			</div>
            
            <table class="table table-striped table-hover">
            <thead>
            	<th>Producto</th>
            	<th>Cantidad</th>
            	<th>Acciones</th>
            </thead>
            <tbody id="AddRow">
            </tbody>
            </table>
        </div>
</div>
<script src="/Template/inspina/js/plugins/select2/select2.full.min.js"></script>
<script type="application/javascript">

$(document).ready(function(){
	
	var Renglon = 0
    $(".addCF").click(function(e){ 
		Renglon++
		e.preventDefault()
		CargaRenglon(Renglon)
    });
    $(".VerFinal").click(function(e){ 
		e.preventDefault()
		VerValores()
    });
	
	$("#Prov_ID").select2();

});

	$("#frmDatos").on("click", ".btnBorrarRenglon", function(){
		console.log($(this))
		var valor = $(this).val()
		$(".renglon"+valor).remove()
    });

function CargaRenglon(v){
		$.post("/pz/wms/OC/Formatos/NuevaOrden_Ajax.asp",{
		Tarea:1,
		Valor:v
		}
    , function(data){
		$("#AddRow").append(data)
		 $("#Prod_ID"+v).select2();
	});

}
function VerValores(){
	var map = []
	$(".Cantidad").each(function(indice,elemento) {
		map[indice] = $(this).val()
	});
	
	console.log(map)
	
	function newArray(name,id,cantidad){
		this.name = name;	
		this.id = id;	
		this.cantidad = cantidad || 0;	
	}
	var NewDatos = []
	$(".combo").each(function(indice,elemento) {
		var nuevoObject = new newArray($('option:selected',this).text(),$(this).val(),map[indice])
		NewDatos.push(nuevoObject)
	});
	
//	$.post("/pz/wms/OC/Formatos/NuevaOrden_Ajax.asp",{
//		Tarea:2,
//		ArregloItem:JSON.stringify(NewDatos)
//		}
//    , function(data){
//		console.log(JSON.parse(data))
//	});
	
	var url = "/pz/wms/OC/Formatos/NuevaOrden_Ajax.asp"
	var data = {
	Tarea:2,
	ArregloItem:JSON.stringify(NewDatos)
	}

	$.ajax({
	  type: "POST",
	  url: url,
	  data: data,
	  contentType: "application/json; charset=utf-8",
	  dataType: "json",
	  success: function(data) {
		console.log(data)
	  }
	});	
}
	
	
	
</script>