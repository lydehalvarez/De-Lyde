

<script src="/Template/inspina/js/plugins/select2/select2.full.min.js"></script>
<link href="/Template/inspina/css/plugins/select2/select2.min.css" rel="stylesheet">

<!-- Select2 -->
<script src="/Template/inspina/js/plugins/select2/select2.full.min.js"></script>

<!-- iCheck -->
<script src="/Template/inspina/js/plugins/iCheck/icheck.min.js"></script>	


<!-- Data picker -->
<script src="/Template/inspina/js/plugins/datapicker/bootstrap-datepicker.js"></script>
<link href="/Template/inspina/css/plugins/datapicker/datepicker3.css" rel="stylesheet">

<!-- Date range picker -->
<script src="/Template/inspina/js/plugins/daterangepicker/daterangepicker.js"></script>	
<link href="/Template/inspina/css/plugins/daterangepicker/daterangepicker-bs3.css" rel="stylesheet">

<script src="/Template/inspina/js/plugins/i18next/bootstrap-datepicker.es.min.js"></script>


<script language="JavaScript">
	

	
function AcBuscadorBuscar()   {
    document.frmDatos.Accion.value = "Consulta";
	if ( {Variable:sSiguienteVentana} == 0 ) {
    	CambiaVentana({Variable:SistemaActual},{Variable:VentanaIndex})
	} else {
		CambiaVentana({Variable:SistemaActual},{Variable:sSiguienteVentana})
	}
}


</script>

