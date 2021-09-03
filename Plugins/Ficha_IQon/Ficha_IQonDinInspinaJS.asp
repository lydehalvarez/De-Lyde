<link rel="stylesheet" href="/Template/ClipOne/admin/clip-one/assets/plugins/datepicker/css/datepicker.min.css">
<link rel="stylesheet" href="/Template/ClipOne/admin/clip-one/assets/plugins/bootstrap-timepicker/css/bootstrap-timepicker.min.css">
<link rel="stylesheet" type="text/css" href="/js/Validacion/validationEngine.jquery.css">

<script type="text/javascript" src="/js/bootstrap/jquery.form.min.js"></script>
<script type="text/javascript" src="/Template/ClipOne/admin/clip-one/assets/plugins/bootstrap-datepicker/js/bootstrap-datepicker.js"></script>
<script src="/Template/ClipOne/admin/clip-one/assets/plugins/bootstrap-timepicker/js/bootstrap-timepicker.min.js"></script>
<script type="text/javascript" src="/Template/ClipOne/admin/clip-one/assets/plugins/bootstrap-datepicker/js/locales/bootstrap-datepicker.es.js"></script>

<script src="/js/jquery.confirm-master/jquery.confirm.min.js"></script>
<script type="text/javascript" src="/js/Validacion/jquery.validationEngine-es.js"></script>
<script type="text/javascript" src="/js/Validacion/jquery.validationEngine.js"></script>
<style type="text/css">
.SoloConsulta{
    border-bottom: solid 1px #CCC; /*#007AFF;*/
    line-height: 30px;
	min-height: 30px;
	}
</style>
<script language="JavaScript">
<!--

//var sImagenEspera = '<img src="/images/ajax-Barraroja.gif" width="128" height="15">'
	
var sImagenEspera = '<div class="loading-spinner" style="width: 200px; margin-left: 600px;">'	
	sImagenEspera += '<div class="progress progress-striped active">'
		sImagenEspera += '<div class="progress-bar progress-bar-danger" style="width: 100%;"></div>'
	sImagenEspera += '</div>'
	sImagenEspera += '</div>'
	

function AcFNuevo() {
	//$("#areabotones").html(sImagenEspera);
	//$('body').modalmanager('loading');
	$("#Accion").val("Consulta");
	$("#Modo").val("Editar");
	//$('#frmDatos').submit();
	$('#frmDatos').clearForm();
	$("#{Variable:frmCampoLlave}").val(-1);
	AntesDelSubmit()
	$('#frmDatos').submit();
	InicializaFormulario();
}	
	
function AcFGuardar() {
	if ($('#frmDatos').validationEngine('validate')==1) {
		$("#areafunciones").html(sImagenEspera);
		$("#areabotones").html("");
		$("#Accion").val("Guardar");
		$("#Modo").val("Editar");
		//if ( Valida() ) {
			AntesDelSubmit()
			$('#frmDatos').submit();
		//}
		$("#Accion").val("Consulta");
		$("#Modo").val("Consulta");	
	}
}

function AcFEditar() {
	$("#areafunciones").html(sImagenEspera);
	$("#areabotones").html("");
	$("#Accion").val("Consulta");
	$("#Modo").val("Editar");
	AntesDelSubmit()
	$('#frmDatos').submit();
}

function AcFBorrar() {

/*	if (confirm("El registro será borrado permanentemente \n ¿Quiere continuar?"))  {
		$("#areabotones").html(sImagenEspera);
		$("#Accion").val("Borrar");
		$("#Modo").val("Editar");
		AntesDelSubmit()
		$('#frmDatos').submit();
		$("#Accion").val("Consulta");
		$("#Modo").val("Consulta");		
} */
  
 	$.confirm({
		text: "El registro ser&aacute; borrado permanentemente \n &#191;Quiere continuar?",
		confirm: function(button) {
			
			$("#areafunciones").html(sImagenEspera);
			$("#areabotones").html("");
			$("#Accion").val("Borrar");
			$("#Modo").val("Editar");
			$('#frmDatos').validationEngine('hideAll');
            $('#frmDatos').validationEngine('detach');
			AntesDelSubmit()                                                                                                                                          
			$('#frmDatos').submit();
			//alert($("#{Variable:frmCampoLlave}").val());
			$("#Accion").val("Consulta");
			$("#Modo").val("Consulta");	   
			//DespuesDelSubmit();	
			//CambiaVentana($("#SistemaActual").val(),$("#MnuIDVieneDe").val());
		},
		cancel: function(button) {
			
		},
		confirmButton: "S&iacute;",
		cancelButton: "No",
		confirmButtonClass: "btn btn-green",
    	cancelButtonClass: "btn-blue",
    	dialogClass: "modal-dialog"
	}); 
  
}
 
function AcFCancelar(regresa) {

/*	  if (confirm("El registro No será Guardado y los cambios hechos se perderan \n ¿Quiere continuar?"))  {
		$("#areabotones").html(sImagenEspera);
		$("#Accion").val("Consulta");
		$("#Modo").val("Consulta");
		AntesDelSubmit()
		$('#frmDatos').submit();
	  }
*/
  
	$.confirm({
		text: "El registro No ser&aacute; Guardado y los cambios hechos se perderan. Quiere continuar?",
		title: "Confirmaci&oacute;n requerida",
		confirm: function(button) {
			$("#areafunciones").html(sImagenEspera);
			$("#areabotones").html("");
			$("#Accion").val("Consulta");
			$("#Modo").val("Consulta");
			$('#frmDatos').validationEngine('hideAll');
            $('#frmDatos').validationEngine('detach');
			AntesDelSubmit()
			if(($("#{Variable:frmCampoLlave}").val() == -1 || $("#{Variable:frmCampoLlave}").val() == "") && regresa > 0) {
				CambiaTab(regresa);	
			} else {
				$('#frmDatos').submit();
			}
		},
		cancel: function(button) {
			
		},
		confirmButton: "Aceptar",
		cancelButton: "Cancelar",
		confirmButtonClass: "btn btn-green",
    	cancelButtonClass: "btn-blue",
    	dialogClass: "modal-dialog"
	}); 
  
}

function CambiaCombo() {
	$("#Accion").val("Vuelta");
	$("#Modo").val("Editar");
	AntesDelSubmit()
	$('#frmDatos').submit();
	$("#Accion").val("Consulta");
	$("#Modo").val("Consulta");	
}


function MostrarMensaje(responseText, statusText, xhr, $form)  { 
    $.jGrowl("El registro fu&eacute; guardado correctamente", { header: 'Aviso', sticky: false, life: 2500, glue:'before'});
} 


function Valida() {
	
	return true	
}

//-->
</script>


