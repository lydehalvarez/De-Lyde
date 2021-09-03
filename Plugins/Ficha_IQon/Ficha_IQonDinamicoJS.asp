<link rel="stylesheet" type="text/css" href="/css/Ficha_Pindol.css">

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
	AntesDelSubmit()
	$('#frmDatos').submit();
	InicializaFormulario();
}	
	
function AcFGuardar() {
	$("#areabotones").html(sImagenEspera);
	$("#Accion").val("Guardar");
	$("#Modo").val("Editar");
	if ( Valida() ) {
		AntesDelSubmit()
		$('#frmDatos').submit();
	}
	$("#Accion").val("Consulta");
	$("#Modo").val("Consulta");	
}

function AcFEditar() {
	$("#areabotones").html(sImagenEspera);
	$("#Accion").val("Consulta");
	$("#Modo").val("Editar");
	AntesDelSubmit()
	$('#frmDatos').submit();
}

function AcFBorrar() {

  if (confirm("El registro será borrado permanentemente \n ¿Quiere continuar?"))  {
    $("#areabotones").html(sImagenEspera);
	$("#Accion").val("Borrar");
	$("#Modo").val("Editar");
	AntesDelSubmit()
	$('#frmDatos').submit();
	$("#Accion").val("Consulta");
	$("#Modo").val("Consulta");		
  }
}
 
function AcFCancelar() {

  if (confirm("El registro No será Guardado y los cambios hechos se perderan \n ¿Quiere continuar?"))  {
    $("#areabotones").html(sImagenEspera);
	$("#Accion").val("Consulta");
	$("#Modo").val("Consulta");
	AntesDelSubmit()
	$('#frmDatos').submit();
  }
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