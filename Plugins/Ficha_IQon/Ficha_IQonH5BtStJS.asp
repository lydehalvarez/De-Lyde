<script type="text/javascript" src="/js/jquery.form-charisma.js"></script>
<script src="/js/jquery.ui.datepicker-es.js"></script>
<script language="JavaScript">
<!--
	
var sImagenEspera = '<img src="/images/ajax-Barraroja.gif" width="128" height="15">'
//var sImagenEspera = '<img src="/images/ajax_BarraAvance.gif" width="128" height="15">'
//var sImagenEspera = '<img src="/images/ajax-engranes.gif" width="12" height="12">'

function AcFNuevo() {
	$("#areabotones").html(sImagenEspera);
	$("#Accion").val("Consulta");
	$("#Modo").val("Editar");
	//$('#frmDatos').submit();
	$('#frmDatos').clearForm();
	$("#{Variable:frmCampoLlave}").val(-1);
	$('#frmDatos').submit();
	InicializaFormulario();
}	
	
function AcFGuardar() {
	$("#areabotones").html(sImagenEspera);
	$("#Accion").val("Guardar");
	$("#Modo").val("Editar");
	if ( Valida() ) $('#frmDatos').submit();
	$("#Accion").val("Consulta");
	$("#Modo").val("Consulta");	
}

function AcFEditar() {
	$("#areabotones").html(sImagenEspera);
	$("#Accion").val("Consulta");
	$("#Modo").val("Editar");
	//alert($("#Modo").val());
	//document.frmDatos.submit();
	$('#frmDatos').submit();
}

function AcFBorrar() {
  $("#areabotones").html(sImagenEspera);
  if (confirm("El registro será borrado permanentemente \n ¿Quiere continuar?"))  {
	$("#Accion").val("Borrar");
	$("#Modo").val("Editar");
	$('#frmDatos').submit();
	$("#Accion").val("Consulta");
	$("#Modo").val("Consulta");		
  }
}
 
function AcFCancelar() {
  $("#areabotones").html(sImagenEspera);
  if (confirm("El registro No será Guardado y los cambios hechos se perderan \n ¿Quiere continuar?"))  {
	$("#Accion").val("Consulta");
	$("#Modo").val("Consulta");
	$('#frmDatos').submit();
  }
}

function CambiaCombo() {
	$("#Accion").val("Vuelta");
	$("#Modo").val("Editar");
	$('#frmDatos').submit();
	$("#Accion").val("Consulta");
	$("#Modo").val("Consulta");	
}

function showRequest(formData, jqForm, options) { 
    // formData is an array; here we use $.param to convert it to a string to display it 
    // but the form plugin does this for you automatically when it submits the data 
    var queryString = $.param(formData); 
 
    // jqForm is a jQuery object encapsulating the form element.  To access the 
    // DOM element for the form do this: 
    // var formElement = jqForm[0]; 
 
    //alert('About to submit: \n\n' + queryString); 
 
    // here we could return false to prevent the form from being submitted; 
    // returning anything other than false will allow the form submit to continue 
    return true; 
} 
 
// post-submit callback 
function showResponse(responseText, statusText, xhr, $form)  { 
    // for normal html responses, the first argument to the success callback 
    // is the XMLHttpRequest object's responseText property 
 
    // if the ajaxForm method was passed an Options Object with the dataType 
    // property set to 'xml' then the first argument to the success callback 
    // is the XMLHttpRequest object's responseXML property 
 
    // if the ajaxForm method was passed an Options Object with the dataType 
    // property set to 'json' then the first argument to the success callback 
    // is the json data object returned by the server 
 	 $.jGrowl("Ocurrio un error grave, avise al administrador del sistema", { header: 'Aviso', sticky: false, life: 2500, glue:'before'});
   // alert('status: ' + statusText + '\n\nresponseText: \n' + responseText + 
   //     '\n\nThe output div should have already been updated with the responseText.'); 
	
} 
// post-submit callback 



function MostrarMensaje(responseText, statusText, xhr, $form)  { 
    $.jGrowl("El registro fu&eacute; guardado correctamente", { header: 'Aviso', sticky: false, life: 2500, glue:'before'});
} 


function Valida() {
	
	return true	
}

//-->
</script>