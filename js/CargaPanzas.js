
function AcFGuardar()   {
	document.frmDatos.action = "ProfesorDet.asp";
    document.frmDatos.Accion.value = "Guardar";
    document.frmDatos.submit();
}

function AcFEditar()   {
	document.frmDatos.action = "ProfesorDet.asp";
    document.frmDatos.Accion.value = "Consulta";
	document.frmDatos.Modo.value = "Editar";
    document.frmDatos.submit();
}

function AcFBorrar() {
  if (confirm("El registro será borrado permanentemente \n ¿Quiere continuar?"))  {
	  document.frmDatos.Accion.value = "Borrar";
	  document.frmDatos.submit();
  }
}

function AcFCancelar() {
  if (confirm("El registro No será Guardado y los cambios hechos se perderan \n ¿Quiere continuar?"))  {
	  document.frmDatos.Accion.value = "Consulta";
	  document.frmDatos.Modo.value = "Consulta";
	  if (document.frmDatos.Prof_ID.value == -1 ) {
	  	document.frmDatos.action = "Profesor.asp";
	  }
	  document.frmDatos.submit();
  }
}

function CambiaCombo() {
	document.frmDatos.Accion.value="Vuelta";
	document.frmDatos.submit();
}



function Mensaje() {
	if (sMensaje != "") {
		alert(sMensaje);
	}
}



