<script language="JavaScript" >
<!--

function btSelecciona()   {
    document.frmDatos.Accion.value = "Consulta";
	if ( {Variable:sSiguienteVentana} == 0 ) {
    	CambiaVentana({Variable:SistemaActual},{Variable:VentanaIndex})
	} else {
		CambiaVentana({Variable:SistemaActual},{Variable:sSiguienteVentana})
	}
}

function AcNuevo() {
	document.frmDatos.Accion.value = "Nuevo";
	document.frmDatos.Modo.value = "Editar";
	document.frmDatos.{Variable:grdCampoLlave}.value = -1;
	if ( {Variable:sSiguienteVentana} == 0 ) {
    	CambiaVentana({Variable:SistemaActual},{Variable:VentanaIndex})
	} else {
		CambiaVentana({Variable:SistemaActual},{Variable:sSiguienteVentana})
	}
}


-->
</script>