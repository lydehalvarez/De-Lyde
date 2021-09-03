<link rel="stylesheet" href="/Template/ClipOne/admin/clip-one/assets/plugins/datepicker/css/datepicker.css">
<script src="/Template/ClipOne/admin/clip-one/assets/plugins/bootstrap-datepicker/js/bootstrap-datepicker.js"></script>
<script src="/Template/inspina/js/plugins/sheetJs/xlsx.full.min.js"></script>

<script type="text/javascript">

function BuscarOpcion() {
		//alert($("#CboReporte").val());
		//$("#Ficha").html('<div id="espera" style="position:absolute; top:50%; left: 50%; margin-top: -100px; margin-left: -100px; height:auto; width:auto;"><img src="/Template/charisma/img/ajax-loaders/ajax-loader-7.gif">');
	if ($("#CboReporte").val()> -1) {	
		$("#Ficha").load("/pz/wms/Reportes/Dinamicos/DinamicosCampos.asp?CboReporte="+$("#CboReporte").val());
		$("#VerReporte").show();
		$("#ExportarAExcel").show();		
	}
}


function CargaReporte(theURL,winName,features) { 
  window.open(theURL,winName,features);
}


function Imprime(repid,itipo,exportar) {

//Fecha I
	var bdesde = false;
	//alert($("#txtFechaDesde").val());
	if ($("#txtFechaDesde").val() != "" && $("#txtFechaDesde").val() != undefined) {
		bdesde = true;
	}

	var bhasta = false;
	if ($("#txtFechaHasta").val() != "" && $("#txtFechaHasta").val() != undefined) {
		bhasta = true;
	}

//Fecha II
	var bdesde2 = false;
	if ($("#txtFechaDesde2").val() != "" && $("#txtFechaDesde2").val() != undefined) {
		bdesde2 = true;
	}
	
	var bhasta2 = false;
	if ($("#txtFechaHasta2").val() != "" && $("#txtFechaHasta2").val() != undefined) {
		bhasta2 = true;
	}

//Fecha III
	var bdesdeDT = false;
	if ($("#txtFechaDesdeDateTime").val() != "" && $("#txtFechaDesdeDateTime").val() != undefined) {
		bdesdeDT = true;
	}

	var bhastaDT = false;
	if ($("#txtFechaHastaDateTime").val() != "" && $("#txtFechaHastaDateTime").val() != undefined) {
		bhastaDT = true;
	}

	//alert("bdesde" + bdesde);

	var jArchivo = "";

		jArchivo += "/pz/wms/Reportes/Dinamicos/ReporteComun.asp?";
		jArchivo += "CboReporte=" + repid;
        if($("#RepCli_ID").val() != undefined){
		   jArchivo += "&RepCli_ID=" +	$("#RepCli_ID").val();
        }
        if($("#RepDeu_ID").val() != undefined){
           jArchivo += "&RepDeu_ID=" + $("#RepDeu_ID").val();	
        }
        if($("#Rep_CorteTras").val() != undefined){
		   jArchivo += "&Rep_CorteTras=" + $("#Rep_CorteTras").val();	
        }
        if($("#Rep_CorteOV").val() != undefined){
           jArchivo += "&Rep_CorteOV=" + $("#Rep_CorteOV").val();	
        }
/*  
	jArchivo += "&Cont_Empresa=" + document.frmDatos.Cont_Empresa.value;
	jArchivo += "&CboGrupo=" + document.frmDatos.CboGrupo.value;

*/

	if(bdesde){
		jArchivo += "&txtFechaDesde=" + $("#txtFechaDesde").val();
	}
	if(bhasta){
		jArchivo += "&txtFechaHasta=" + $("#txtFechaHasta").val();
	}

	if(bdesde2){
		jArchivo += "&txtFechaDesde2=" + $("#txtFechaDesde2").val();
	}
	if(bhasta2){
		jArchivo += "&txtFechaHasta2=" + $("#txtFechaHasta2").val();
	}

	if(bdesdeDT){
		jArchivo += "&txtFechaDesdeDateTime=" + $("#txtFechaDesdeDateTime").val();
	}
	if(bhastaDT){
		jArchivo += "&txtFechaHastaDateTime=" + $("#txtFechaHastaDateTime").val(); 
	}
	
		//alert(jArchivo);
		console.log(jArchivo);
	if(exportar==1) {
		//alert(exportar);$("#frmDatos").serialize() +
		if(confirm("Este proceso, generará un archivo con extensión \".asp.xls\"; lo cuál será como exportar a excel. \n Recuerde que debe asignar el nombre y la ruta donde desee que el archivo se almacene. \n ¿Desea continuar con la exportación de datos?")){
			jArchivo += "&iExport=1&iTotales=" + itipo;
			//alert(jArchivo);
			//alert("111111");
			CargaReporte(jArchivo,'Reporte','width=950,height=640,status=yes,scrollbars=yes,resizable=yes,menubar=yes');
			//window.open(jArchivo,'Reporte', '');
			
		}
	}
	
	if(exportar==0) {
		//alert("000000");$("#frmDatos").serialize() + 
		jArchivo += "&iExport=0&iTotales=" + itipo;
		//alert(jArchivo);
		CargaReporte(jArchivo,'Reporte','width=950,height=640,status=yes,scrollbars=yes,resizable=yes,menubar=yes');
		//window.open(jArchivo,'Reporte', '');
	}

}




function Imprime2() {
//document.frmDatos.txtFechaDesde.value=document.frmDatos.txtFechaDesde.value;
//document.frmDatos.txtFechaHasta.value=document.frmDatos.txtFechaHasta.value;
	var jArchivo = "" //document.frmDatos.Archivo.value;
	jArchivo += "/pz/wms/Reportes/Dinamicos/ReporteComun.asp?CboReporte=" + document.frmDatos.CboReporte.value;
	jArchivo += "&Cont_Empresa=" + document.frmDatos.Cont_Empresa.value;
	jArchivo += "&CboGrupo=" + document.frmDatos.CboGrupo.value;
	jArchivo += "&CboPlan=" + document.frmDatos.CboPlan.value;
	jArchivo += "&CboVendedor=" + document.frmDatos.CboVendedor.value;
	jArchivo += "&CboEstatus=" + document.frmDatos.CboEstatus.value;
	jArchivo += "&CboCliente=" + document.frmDatos.CboCliente.value;
	jArchivo += "&CboContrato=" + document.frmDatos.CboContrato.value;
	jArchivo += "&txtFechaDesde=" + document.frmDatos.txtFechaDesde.value;
	jArchivo += "&txtFechaHasta=" + document.frmDatos.txtFechaHasta.value;
//	alert("Los parametros del archivo son " + jArchivo);
	CargaReporte(jArchivo,'','width=750,height=450,status=yes,scrollbars=yes,resizable=yes,menubar=yes');
}

function Imprime2() {
//document.frmDatos.txtFechaDesde.value=document.frmDatos.txtFechaDesde.value;
//document.frmDatos.txtFechaHasta.value=document.frmDatos.txtFechaHasta.value;
	var jArchivo = "" //document.frmDatos.Archivo.value;
	jArchivo += "/pz/wms/Reportes/Dinamicos/ReporteComun.asp?CboReporte=" + document.frmDatos.CboReporte.value;
	jArchivo += "&Cont_Empresa=" + document.frmDatos.Cont_Empresa.value;
	jArchivo += "&CboGrupo=" + document.frmDatos.CboGrupo.value;
	jArchivo += "&CboPlan=" + document.frmDatos.CboPlan.value;
	jArchivo += "&CboVendedor=" + document.frmDatos.CboVendedor.value;
	jArchivo += "&CboEstatus=" + document.frmDatos.CboEstatus.value;
	jArchivo += "&CboCliente=" + document.frmDatos.CboCliente.value;
	jArchivo += "&CboContrato=" + document.frmDatos.CboContrato.value;
	jArchivo += "&txtFechaDesde=" + document.frmDatos.txtFechaDesde.value;
	jArchivo += "&txtFechaHasta=" + document.frmDatos.txtFechaHasta.value;
//	alert("Los parametros del archivo son " + jArchivo);
	CargaReporte(jArchivo,'','width=750,height=450,status=yes,scrollbars=yes,resizable=yes,menubar=yes');
}

function Imprime3() {
//document.frmDatos.txtFechaDesde.value=document.frmDatos.txtFechaDesde.value;
//document.frmDatos.txtFechaHasta.value=document.frmDatos.txtFechaHasta.value;
	//alert("NO HYA NADA DE ESTO..");
	var jArchivo = "" //document.frmDatos.Archivo.value;
	//jArchivo += "../Graficas/3dBar.asp?CboReporte=" + document.frmDatos.CboReporte.value;
	jArchivo += "#?CboReporte=1"
	jArchivo += "&Cont_Empresa=" + document.frmDatos.Cont_Empresa.value;
	jArchivo += "&CboGrupo=" + document.frmDatos.CboGrupo.value;
	jArchivo += "&CboPlan=" + document.frmDatos.CboPlan.value;
	jArchivo += "&CboVendedor=" + document.frmDatos.CboVendedor.value;
	jArchivo += "&CboEstatus=" + document.frmDatos.CboEstatus.value;
	jArchivo += "&CboCliente=" + document.frmDatos.CboCliente.value;
	jArchivo += "&CboContrato=" + document.frmDatos.CboContrato.value;
	jArchivo += "&txtFechaDesde=" + document.frmDatos.txtFechaDesde.value;
	jArchivo += "&txtFechaHasta=" + document.frmDatos.txtFechaHasta.value;
	CargaReporte(jArchivo,'','width=900,height=600,status=yes,scrollbars=yes,resizable=yes,menubar=yes');
}
function ImprimeJson(Rep_ID,h,j) {
		$('.loadingData').css('display','block');
		$('.btnJsonExcel').prop('disabled',true);
		$('.btnJsonExcel').text('Cargando reporte...');
		var Inicio = $('#txtFechaDesde').val();
		var Termina = $('#txtFechaHasta').val(); 
		if(Inicio == "" || Inicio == null){
			Inicio = null
		}
		if(Termina == "" || Termina == null){
			Termina = null
		}
		var urlApi = "http://198.38.94.238:8543/api/Reporteador?Rep_ID="+Rep_ID+"&Batman=WMS&FechaInicio="+Inicio+"&FechaFinal="+Termina+"&Cli_ID="+$("#RepCli_ID").val()
		console.log(urlApi)
		$.ajax({
			type: 'GET',
			async:true,
			cache:false,
			contentType:'application/json',
			url: urlApi,
			success: function(datos){
				console.log(datos)
				var date = new Date()
				console.log(date)
				var ws = XLSX.utils.json_to_sheet(datos);
				var wb = XLSX.utils.book_new(); 
				var months = ["Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dic"];
				XLSX.utils.book_append_sheet(wb, ws, "Hoja 1");
				XLSX.writeFile(wb, $('#NombreReporte').val()+" "+date.getDate()+" "+months[date.getMonth()]+" "+date.getHours()+"."+date.getMinutes()+" hrs.xlsx");
				$('.btnJsonExcel').text('Exportar a excel')
				$('.btnJsonExcel').prop('disabled',false)
				$('.loadingData').css('display','none')
			},
			error: function (jqXHR, textStatus, errorThrown) { 
				swal({
					title: "Error en API",
					text: "Se ha poducido un error en el servicio",
					type: "warning",
					confirmButtonColor: "#57D9DF",
					confirmButtonText: "Ok!",
					closeOnConfirm: true,
					html: true
				});
				$('.btnJsonExcel').text('Exportar a excel')
				$('.btnJsonExcel').prop('disabled',false)
				$('.loadingData').css('display','none')
			}
		});
		
//		
//		$.post("/pz/wms/Reportes/Dinamicos/ReporteJson.asp",
//		{
//			Rep_ID:Rep_ID
//		},function(data){
//			console.log(JSON.parse(data))
//			var date = new Date()
//			console.log(date)
//			var ws = XLSX.utils.json_to_sheet(JSON.parse(data));
//			var wb = XLSX.utils.book_new(); 
//			var months = ["Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dic"];
//			XLSX.utils.book_append_sheet(wb, ws, "Hoja 1");
//			XLSX.writeFile(wb, $('#NombreReporte').val()+" "+date.getDate()+" "+months[date.getMonth()]+" "+date.getHours()+"."+date.getMinutes()+" hrs.xlsx");
//		$('.btnJsonExcel').text('Exportar a excel')
//			$('.btnJsonExcel').prop('disabled',false)
//			$('.loadingData').css('display','none')
//	});


}
</script>
