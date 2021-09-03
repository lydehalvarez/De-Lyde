
<script language="javascript" type="text/javascript">
<!--



function DespuesDelSubmit() {

}
function AntesDelSubmit() {

}
function OcurrioErrorenSubmit() {

}

function InicializaFormulario() {

}

function ControlaObjeto(o){
	var id = o.attr('id')
	if(typeof(id) === "undefined") {
		console.log("el objeto que entro no tiene el id es un " + o[0].tagName )		
	} else {
		console.log("el objeto que entro tiene el id " + o.attr('id') + " y es un " + o[0].tagName )
	
		//haz lo que quieras con el objeto
	}
}
	
function CambioCompania(){

	$.post( "/pz/mms/Usuarios/usuarios_Ajax.asp" 
	       , { Tarea:11,Com_ID:$("#Com_ID").val()}
	       , function(output) { 
				var Objeto = $('#Dep_ID');
				Objeto.empty();
				var arrP = new Array(0);
					arrP = output.split(",");   
				$.each(arrP, function(clave,valor) { 
					var sValor = String(valor);
					var arrO = new Array(0);
						arrO = sValor.split(":");
					//var options = "<option " + "value='" + arrO[0] + "'>" + arrO[1] + "";
                    //Objeto.append(options);	
					Objeto.append($('<option></option>').val(arrO[0]).html(arrO[1]));
					//Objeto.selectpicker('refresh');
			 });
			 $("#Dep_ID").val(-1)
		});	
	
}
	
//-->
</script>