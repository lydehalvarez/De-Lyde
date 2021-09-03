<SCRIPT type="text/javascript">
<!--
var TotReg = 0
//********************************* ACCIONES DEL GRID ***********************************

function AcGEditar(RegAEditar)   {
	document.frmDatos.action = "ProfesorDet.asp";
    document.frmDatos.Accion.value = "Editar";
    document.frmDatos.Prof_ID.value = RegAEditar;
    document.frmDatos.submit();
}

function Selecciona(RegAEditar)   {
	document.frmDatos.action = "ProfesorDet.asp";
    document.frmDatos.Accion.value = "Consulta";
    document.frmDatos.Prof_ID.value = RegAEditar;
    document.frmDatos.submit();
}

function AcGNuevo() {
	document.frmDatos.action = "ProfesorDet.asp";
	document.frmDatos.Accion.value = "Nuevo";
	document.frmDatos.Modo.value = "Editar";
	document.frmDatos.Prof_ID.value = -1;
	document.frmDatos.submit(); 
}

function AcGBorrar(RegABorrar,Registro) {
/* 
Estas variables las manejamos en el archivo ASP
var iPagina = "<%=iPagina%>";
var iRegPorPagina = "<%=iRegPorPagina%>";
var iRegistros = "<%=iRegPorPagina%>";
*/

var iTemp = 0
  if (confirm("El registro será borrado permanentemente \n ¿Quiere continuar?"))  {
	  document.frmDatos.Accion.value = "Borrar";
	  if (TotReg == Registro) {
		  iTemp = ( iPagina -1 ) * iRegPorPagina;
		  iTemp = Registro - iTemp;
		  if ( iTemp == 1 ) {
			iPagina--;	
		  }
	  	document.frmDatos.Pag.value = iPagina;
	  }
	  document.frmDatos.Prof_ID.value = RegABorrar;
	  document.frmDatos.submit();
  }
}


//*********************************** ACCIONES PARA LA FORMA *****************************

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

//-->
</script>


