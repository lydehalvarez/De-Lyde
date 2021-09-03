<script type="text/javascript" src="/js/jquery.form.js"></script>

<script language="JavaScript">
<!--
	
function AcFGuardar()   {
	document.frmDatos.Accion.value ="Guardar";	
	document.frmDatos.Modo.value = "Editar";
	$('#frmDatos').submit();
}

function AcFEditar()   {
	document.frmDatos.Accion.value ="Consulta";	
	document.frmDatos.Modo.value = "Editar";
	 $('#frmDatos').submit();
}

function AcFBorrar() {
  if (confirm("El registro será borrado permanentemente \n ¿Quiere continuar?"))  {
	document.frmDatos.Accion.value ="Borrar";	
	document.frmDatos.Modo.value = "Editar";
	$('#frmDatos').submit();
  }
}
 
function AcFCancelar() {
  if (confirm("El registro No será Guardado y los cambios hechos se perderan \n ¿Quiere continuar?"))  {
	document.frmDatos.Accion.value ="Consulta";	
	document.frmDatos.Modo.value = "Consulta";
	$('#frmDatos').submit();
  }
}

function CambiaCombo() {
	document.frmDatos.Accion.value ="Vuelta";	
	document.frmDatos.Modo.value = "Editar";
	$('#frmDatos').submit();
}

function showRequest(formData, jqForm, options) { 
    // formData is an array; here we use $.param to convert it to a string to display it 
    // but the form plugin does this for you automatically when it submits the data 
    var queryString = $.param(formData); 
 
    // jqForm is a jQuery object encapsulating the form element.  To access the 
    // DOM element for the form do this: 
    // var formElement = jqForm[0]; 
 
    alert('About to submit: \n\n' + queryString); 
 
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
 
    alert('status: ' + statusText + '\n\nresponseText: \n' + responseText + 
        '\n\nThe output div should have already been updated with the responseText.'); 
} 



//-->
</script>