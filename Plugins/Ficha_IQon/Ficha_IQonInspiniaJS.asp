<link href="/Template/inspina/font-awesome/css/font-awesome.css" rel="stylesheet">
<link href="/Template/inspina/css/style.css" rel="stylesheet">


<link href="/Template/inspina/css/plugins/select2/select2.min.css" rel="stylesheet">

<!-- Select2 -->
<script src="/Template/inspina/js/plugins/select2/select2.full.min.js"></script>

<!-- iCheck -->
<script src="/Template/inspina/js/plugins/iCheck/icheck.min.js"></script>	

<!-- Color picker -->
<link href="/Template/inspina/css/plugins/colorpicker/bootstrap-colorpicker.min.css" rel="stylesheet">	
<script src="/Template/inspina/js/plugins/colorpicker/bootstrap-colorpicker.min.js"></script>

<!-- Clock picker -->
<link href="/Template/inspina/css/plugins/clockpicker/clockpicker.css" rel="stylesheet">
<script src="/Template/inspina/js/plugins/clockpicker/clockpicker.js"></script>

<!-- Data picker -->
<script src="/Template/inspina/js/plugins/datapicker/bootstrap-datepicker.js"></script>
<link href="/Template/inspina/css/plugins/datapicker/datepicker3.css" rel="stylesheet">

<!-- Date range picker -->
<script src="/Template/inspina/js/plugins/daterangepicker/daterangepicker.js"></script>	
<link href="/Template/inspina/css/plugins/daterangepicker/daterangepicker-bs3.css" rel="stylesheet">

<script src="/Template/inspina/js/plugins/i18next/bootstrap-datepicker.es.min.js"></script>

<script type="text/javascript" src="/js/bootstrap/jquery.form.min.js"></script>
<script src="/js/jquery.confirm-master/jquery.confirm.min.js"></script>

<script type="text/javascript" src="/js/Validacion/jquery.validationEngine-es.js"></script>
<script type="text/javascript" src="/js/Validacion/jquery.validationEngine.js"></script>

<style type="text/css">
.SoloConsulta{
    /*border-bottom: solid 1px dashed #e7eaec;*/ /*#007AFF;*/
    /*border-bottom: solid 1px #CCC;*/ /*#007AFF;*/
	border-bottom-color: teal; 
	border-bottom-style: dashed;
	border-bottom-width: 1px;
    /*line-height: 30px;
	min-height: 30px;*/
	
	
    /*border-top: 1px dashed #e7eaec;
    color: #ffffff;
    background-color: #ffffff;
    height: 1px;
    margin: 20px 0;	*/
	
}	

.FichaBtnArriba {
	position: fixed;
    width: 80%;
    z-index: 1000;
    top: 10px;
}
	
</style>


<script language="javascript" type="text/javascript">
<!--
/*
Unicode para el javascript
\u00e1 = á
\u00e9 = é
\u00ed = í
\u00f3 = ó
\u00fa = ú
\u00c1 = Á
\u00c9 = É
\u00cd = Í
\u00d3 = Ó
\u00da = Ú
\u00f1 = ñ
\u00d1 = Ñ

*/


var sImagenEspera = '<div class="loading-spinner" style="width: 400px; margin-left: 600px;">'	
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
		//$('#Contenido').toggleClass('sk-loading');
		//$('#Contenido').children('.ibox-content').toggleClass('sk-loading');
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
	$('#Contenido').toggleClass('sk-loading');
	$("#areabotones").html("");
	$("#Accion").val("Consulta");
	$("#Modo").val("Editar");
	AntesDelSubmit()
	$('#frmDatos').submit();
}

function AcFBorrar() {

  /*
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
  */
	swal({
		title: "Confirmaci\u00f3n requerida",
		text: "El registro ser\u00e1 borrado permanentemente \n Quiere continuar?",
		type: "warning",
		showCancelButton: true,
		cancelButtonText:"No",
		confirmButtonColor: "#1ab394",
		confirmButtonText: "S\u00ed",
		closeOnConfirm: true
	}, function () {
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
	});	
	
}
 
function AcFCancelar(regresa) {
/*  
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
			if($("#{Variable:frmCampoLlave}").val() == -1 && regresa > 0) {
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
*/	
	
	swal({
		title: "Confirmaci\u00f3n requerida",
		text: "El registro No ser\u00e1 Guardado y los cambios hechos se perderan. Quiere continuar?",
		type: "warning",
		showCancelButton: true,
		cancelButtonText:"Cancelar",
		confirmButtonColor: "#1ab394",
		confirmButtonText: "Aceptar",
		closeOnConfirm: true
	}, function () {
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

function ControlaObjeto(o){}

function MostrarMensaje(responseText, statusText, xhr, $form)  { 
    $.jGrowl("El registro fu&eacute; guardado correctamente", { header: 'Aviso', sticky: false, life: 2500, glue:'before'});
} 


function Valida() {
	
	return true	
}
   
$(document).ready(function(){
 
	$(window).scroll(function(){
		if( $(this).scrollTop() > 205 ){
			$('.CntBtn').addClass('FichaBtnArriba');
			//console.log(">0 = " + $(this).scrollTop() )
		} else {
			$('.CntBtn').removeClass('FichaBtnArriba');
			//console.log("0 = " + $(this).scrollTop() )			
		}
	});
 
}); 
   
   
//-->
</script>
