<script language="JavaScript">
<!--

function CargaContenido(iElemento) {

	var sDatos =  "Tarea=1";
		sDatos += "&SistemaActual=" + document.frmDatos.SistemaActual.value;
		sDatos += "&VentanaIndex=" + document.frmDatos.VentanaIndex.value;
		sDatos += "&iqCli_ID=" + document.frmDatos.iqCli_ID.value;
        sDatos += "&Tab3Selec=" + iElemento;
		sDatos += "&r=" +  Math.floor(Math.random()*9999999);

		$.ajax({
			type:"GET",
			url: "/widgets/Contenido/Contenido.asp",
			//dataType: "application/x-www-form-urlencoded",
			dataType: "html",
			//dataType: "script",
			data: sDatos,
			async: false,
			processData: false,
			success: function(output) {
                        //alert("Los datos fueron guardados correctamente");
                        //alert(output);
                        $('#AdmCont').html(output);
                        //$('#Contenido').load("/Plugins/Contenido/Contenido.asp?"+sDatos );
					  },
			error: function(XMLHttpRequest, textStatus, errorThrown) {
				$.jGrowl("Ocurrio un error de sistema al intentar cargar el contenido, notifique a sistemas por favor", { header: 'Aviso', sticky: false, life: 2500, glue:'before'});
			}						
		});
}
 

//-->
</script>