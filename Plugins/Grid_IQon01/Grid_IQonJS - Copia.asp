<script language="JavaScript" >
<!--
var TotReg = 0

function AcPaginacion(Valor) {
	document.frmDatos.RegPorVentana.value = Valor;
	document.frmDatos.Pag.value = 1;
	CambiaAccion("Consulta","Consulta");
	} 

function AcIrAPagina(Valor) {
	document.frmDatos.Pag.value = Valor;
	CambiaAccion("Consulta","Consulta");
	}
	
var oPrevElement;
function styleSwap(oElement, sEvent, sOff, sOn) {var cssClass;if(sEvent == 'click') {if(oPrevElement != null) {oPrevElement.className = sOff;}if (oElement) { oElement.className = sOff; } oPrevElement = oElement; } else {if (sEvent=='hover') cssClass = sOn;else cssClass = sOff;if (oPrevElement==null) {oElement.className = cssClass;} else {if(oPrevElement.id != oElement.id) {oElement.className = cssClass;}}}}
 

function grAccEditar(RegAEditar)   {
    document.frmDatos.Accion.value = "Editar";
    document.frmDatos.{Variable:frmCampoLlave}.value = RegAEditar;
	if ( {Variable:sSiguienteVentana} == 0 ) {
		CambiaVentana({Variable:SistemaActual},{Variable:VentanaIndex})
	} else {
		CambiaVentana({Variable:SistemaActual},{Variable:sSiguienteVentana})
	}
}

function grSelecciona(RegAEditar)   {
    document.frmDatos.Accion.value = "Consulta";
    document.frmDatos.{Variable:frmCampoLlave}.value = RegAEditar;
	if ( {Variable:sSiguienteVentana} == 0 ) {
    	CambiaVentana({Variable:SistemaActual},{Variable:VentanaIndex})
	} else {
		CambiaVentana({Variable:SistemaActual},{Variable:sSiguienteVentana})
	}
}

function AcNuevo() {
	if (AccSecNuevo() == false) {
		document.frmDatos.Accion.value = "Nuevo";
		document.frmDatos.Modo.value = "Editar";
		document.frmDatos.{Variable:frmCampoLlave}.value = -1;
		if ( {Variable:sSiguienteVentana} == 0 ) {
			CambiaVentana({Variable:SistemaActual},{Variable:VentanaIndex})
		} else {
			CambiaVentana({Variable:SistemaActual},{Variable:sSiguienteVentana})
		}
	}
}

function grAccBorrar(RegABorrar,Registro) {
var iPagina = {Variable:iPagina};
var iRegPorPagina = {Variable:iRegPorPagina};
var iRegistros = {Variable:iRegPorPagina};
var iTemp = 0
  if (confirm("El registro será borrado permanentemente \n ¿Quiere continuar?"))  {
	  document.frmDatos.Accion.value = "Borrar";
	  document.frmDatos.Modo.value = "Editar";
	  if (TotReg == Registro) {
		  iTemp = ( iPagina -1 ) * iRegPorPagina;
		  iTemp = Registro - iTemp;
		  if ( iTemp == 1 ) {
			iPagina--;	
		  }
	  	  document.frmDatos.Pag.value = iPagina;
	  }
	  document.frmDatos.{Variable:frmCampoLlave}.value = RegABorrar;
	if ( {Variable:sSiguienteVentana} == 0 ) {
    	CambiaVentana({Variable:SistemaActual},{Variable:VentanaIndex})
	} else {
		CambiaVentana({Variable:SistemaActual},{Variable:sSiguienteVentana})
	}
  }
}

-->
</script>