<link rel="stylesheet" type="text/css" href="/Template/ClipOne/admin/clip-one/assets/plugins/select2/select2.css" />
<link rel="stylesheet" href="/Template/ClipOne/admin/clip-one/assets/plugins/DataTables/media/css/DT_bootstrap.css" />

<script language="JavaScript" >
<!--
var TotReg = 0
var iSigVentana = {Variable:sSiguienteVentana};
var iActualVentana = {Variable:VentanaIndex};
 
function grAccEditar(RegAEditar,iRAVentana) {
	
	var iVS = 0;
	$("#Accion").val("Editar");
	$("#Modo").val("Editar");
	$("#{Variable:frmCampoLlave}").val(RegAEditar);	
	if (iRAVentana < 1 ) { 
		iVS = iActualVentana; 
	} else {
		iVS = iSigVentana; 
	}
	if (iRAVentana > 1 ) { iVS = iRAVentana; }
	CambiaVentana({Variable:SistemaActual},iVS)

}

function grAccNuevo(RegAEditar,iRAVentana) {
	
	var iVS = 0;
	$("#Accion").val("Nuevo");
	$("#Modo").val("Editar");
	$("#{Variable:frmCampoLlave}").val(RegAEditar);	
	if (iRAVentana < 1 ) { 
		iVS = iActualVentana; 
	} else {
		iVS = iSigVentana; 
	}
	if (iRAVentana > 1 ) { iVS = iRAVentana; }
	CambiaVentana({Variable:SistemaActual},iVS)

}

function grAccBorrar(RegABorrar,Registro) {
var iPagina = {Variable:iPagina};
var iRegPorVentana = {Variable:iRegPorVentana};
var iRegistros = {Variable:iRegPorVentana};
var iTemp = 0
  if (confirm("El registro será borrado permanentemente \n ¿Quiere continuar?"))  {
		$("#Accion").val("Borrar");
		$("#Modo").val("Editar");
	  if (TotReg == Registro) {
		  iTemp = ( iPagina -1 ) * iRegPorVentana;
		  iTemp = Registro - iTemp;
		  if ( iTemp == 1 ) {
			iPagina--;	
		  }
	  	  document.frmDatos.Pag.value = iPagina;
	  }
	  $("#{Variable:frmCampoLlave}").val(RegABorrar);
	if ( {Variable:sSiguienteVentana} == 0 ) {
    	CambiaVentana({Variable:SistemaActual},{Variable:VentanaIndex})
	} else {
		CambiaVentana({Variable:SistemaActual},{Variable:sSiguienteVentana})
	}
  }
}


function CambiaAPagina(Valor) {
	var PaginaAIr = 1
	//alert(Valor);
	switch (parseInt(Valor)) {
		
		case 1:		
			PaginaAIr = 1;
			$("#IrAPagina").val(PaginaAIr);
			$("#liPrimero").attr('class',"disabled");
			$("#refPrimero").attr('href',"#");
			//$("#iPrimero").attr('class',"icon-double-angle-right");
			$("#liAnterior").attr('class',"disabled");
			$("#refAnterior").attr('href',"#");
			//$("#iAnterior").attr('class',"icon-double-angle-right");
			break;
		
		case 2:	
			PaginaAIr = $("#IrAPagina").val();
			if (parseFloat(PaginaAIr) > 1) { //Página 2,3,4.....
				PaginaAIr--;
				$("#IrAPagina").val(PaginaAIr);
				$("#liPrimero").attr('class',"");
				$("#refPrimero").attr('href',"javascript:CambiaAPagina(1);");
				//$("#iPrimero").attr('class',"icon-double-angle-right");
				$("#liAnterior").attr('class',"");
				$("#refAnterior").attr('href',"javascript:CambiaAPagina(2)");
				//$("#iAnterior").attr('class',"icon-double-angle-right");
			} if (parseFloat(PaginaAIr) == 1) { //Página uno 1
				$("#IrAPagina").val(PaginaAIr);
				$("#liPrimero").attr('class',"disabled");
				$("#refPrimero").attr('href',"#");
				//$("#iPrimero").attr('class',"icon-double-angle-right");
				$("#liAnterior").attr('class',"disabled");
				$("#refAnterior").attr('href',"#");
				//$("#iAnterior").attr('class',"icon-double-angle-right");
			}
				$("#liSiguiente").attr('class',"");
				$("#refSiguiente").attr('href',"javascript:CambiaAPagina(3);");
				//$("#iSiguiente").attr('class',"icon-double-angle-right");
				$("#liUltimo").attr('class',"");
				$("#refUltimo").attr('href',"javascript:CambiaAPagina(4);");
				//$("#iUltimo").attr('class',"icon-double-angle-right");			
			break;
		
		case 3:		
			PaginaAIr = $("#IrAPagina").val();
			if (parseFloat(PaginaAIr) < parseFloat($("#TotalPaginas").val())) {
				PaginaAIr++;
				$("#IrAPagina").val(PaginaAIr);
				$("#liPrimero").attr('class',"");
				$("#refPrimero").attr('href',"javascript:CambiaAPagina(1);");
				//$("#iPrimero").attr('class',"icon-double-angle-right");
				$("#liAnterior").attr('class',"");
				$("#refAnterior").attr('href',"javascript:CambiaAPagina(2)");
				//$("#iAnterior").attr('class',"icon-double-angle-right");
				if (parseFloat(PaginaAIr) == parseFloat($("#TotalPaginas").val())) {
					$("#liSiguiente").attr('class',"disabled");
					$("#refSiguiente").attr('href',"#");
					//$("#iSiguiente").attr('class',"icon-double-angle-right");
					$("#liUltimo").attr('class',"disabled");
					$("#refUltimo").attr('href',"#");
					//$("#iUltimo").attr('class',"icon-double-angle-right");
				}
			
			}
			
			break;
			
		case 4:		
			PaginaAIr = $("#TotalPaginas").val();
				$("#IrAPagina").val(PaginaAIr);
				
				$("#liPrimero").attr('class',"");
				$("#refPrimero").attr('href',"javascript:CambiaAPagina(1);");
				//$("#iPrimero").attr('class',"icon-double-angle-right");
				$("#liAnterior").attr('class',"");
				$("#refAnterior").attr('href',"javascript:CambiaAPagina(2)");
				//$("#iAnterior").attr('class',"icon-double-angle-right");

				if (parseFloat($("#TotalPaginas").val()) == parseFloat(PaginaAIr)) {
					$("#liSiguiente").attr('class',"disabled");
					$("#refSiguiente").attr('href',"#");
					//$("#iSiguiente").attr('class',"icon-double-angle-right");
					$("#liUltimo").attr('class',"disabled");
					$("#refUltimo").attr('href',"#");
					//$("#iUltimo").attr('class',"icon-double-angle-right");
				}
				
			break;

	}
	
	AcIrAPagina(PaginaAIr)
	
}


/*
function CambiaAPagina(Valor) {
var PaginaAIr = 1

	$("#btnPrimero").attr('src',$("#btnPrimero").attr('rel'));
	$("#btnAnterior").attr('src',$("#btnAnterior").attr('rel'));
	$("#btnSiguiente").attr('src',$("#btnSiguiente").attr('rel'));
	$("#btnUltimo").attr('src',$("#btnUltimo").attr('rel'));
	

	switch (parseInt(Valor)) {
		case 1:		
			PaginaAIr = 1;
			$("#IrAPagina").val(PaginaAIr);
			$("#btnSiguiente").attr('src',"/Plugins/Grid_IQon/img/BtnSiguiente.gif");
			$("#btnUltimo").attr('src',"/Plugins/Grid_IQon/img/BtnUltimo.gif");
			break;
		case 2:	
			PaginaAIr = $("#IrAPagina").val();
			if (  parseFloat(PaginaAIr) >1 ) {
				PaginaAIr--;
				$("#IrAPagina").val(PaginaAIr);
				$("#btnPrimero").attr('src',"/Plugins/Grid_IQon/img/BtnPrimero.gif");
				$("#btnAnterior").attr('src',"/Plugins/Grid_IQon/img/BtnAnterior.gif");
				$("#btnSiguiente").attr('src',"/Plugins/Grid_IQon/img/BtnSiguiente.gif");
				$("#btnUltimo").attr('src',"/Plugins/Grid_IQon/img/BtnUltimo.gif");
			}
			break;
		case 3:		
			PaginaAIr = $("#IrAPagina").val();
			if ( parseFloat(PaginaAIr) < parseFloat($("#TotalPaginas").val()) ) {
				PaginaAIr++;
				$("#IrAPagina").val(PaginaAIr);
				$("#btnPrimero").attr('src',"/Plugins/Grid_IQon/img/BtnPrimero.gif");
				$("#btnAnterior").attr('src',"/Plugins/Grid_IQon/img/BtnAnterior.gif");
				$("#btnSiguiente").attr('src',"/Plugins/Grid_IQon/img/BtnSiguiente.gif");
				$("#btnUltimo").attr('src',"/Plugins/Grid_IQon/img/BtnUltimo.gif");
			}
			break;
		case 4:		
			PaginaAIr = $("#TotalPaginas").val();
				$("#IrAPagina").val(PaginaAIr);
				$("#btnPrimero").attr('src',"/Plugins/Grid_IQon/img/BtnPrimero.gif");
				$("#btnAnterior").attr('src',"/Plugins/Grid_IQon/img/BtnAnterior.gif");

			break;
	} 

	AcIrAPagina(PaginaAIr)

}
*/
 
function AcIrAPagina(Valor) {
	
	$.post("/Plugins/Grid_IQon/GRIQon_HTML5CO.asp", { Tarea: 2 
		, iqCli_ID: $("#iqCli_ID").val()
		, Sys_ID: $("#SistemaActual").val()
		, WgCfg_ID: {Variable:iWgCfgID}   
		, SQLC: $("#SQLC").val()
		, ConBus: $("#ConBus").val()
		, Mnu_ID: $("#VentanaIndex").val()
		, SysLog_ID: $("#IDUsuario").val()
		, Wgt_ID: {Variable:iWgID}
		, WgCfgC_ID: $("#WgCfgC_ID").val()
		, SysLogCat_ID: $("#UsuarioTpo").val()
		, TotalRegistros: $("#TotalRegistros").val()
		, TotalPaginas: $("#TotalPaginas").val()
		, PaginaActual: Valor
		, RegPorVentana: $("#RegPorVentana").val()
		, Cli_ID: $("#Cli_ID").val()
		, Deu_ID: $("#Deu_ID").val()
		, CliD_ID: $("#CliD_ID").val()	
		, Com_ID: $("#Com_ID").val()			
	},function(data) {
		$("#DatosGrid").html(data);			
	});	
	
}

 
function AcPaginacion(Valor) {
	
		$.post("/Plugins/Grid_IQon/GRIQon_HTML5CO.asp", { Tarea: 1 
		, iqCli_ID: $("#iqCli_ID").val()
		, Sys_ID: $("#SistemaActual").val()
		, WgCfg_ID: {Variable:iWgCfgID}
		, SQLC: $("#SQLC").val()
		, ConBus: $("#ConBus").val()
		, Mnu_ID: $("#VentanaIndex").val()
		, SysLog_ID: $("#IDUsuario").val()
		, Wgt_ID: {Variable:iWgID}
		, WgCfgC_ID: $("#WgCfgC_ID").val()
		, SysLogCat_ID: $("#UsuarioTpo").val()
		, TotalRegistros: $("#TotalRegistros").val()
		, RegPorVentana: $("#RegPorVentana").val()
		, Cli_ID: $("#Cli_ID").val()
		, Deu_ID: $("#Deu_ID").val()
		, CliD_ID: $("#CliD_ID").val()	
		, Com_ID: $("#Com_ID").val()	
	},function(data) {
		$("#ContenidoGrid").html(data);	
		CargaDatosAlGrid();		
	});	
} 

	
 	
function CargaGrid() {

//$.jGrowl("Iniciando Cargado", { header: 'Aviso', sticky: false, life: 2500, glue:'before'});

	$.post("/Plugins/Grid_IQon/GRIQon_HTML5CO.asp", { Tarea: 1 
		, iqCli_ID: $("#iqCli_ID").val()
		, Sys_ID: $("#SistemaActual").val()
		, SQLC: $("#SQLC").val()
		, ConBus: $("#ConBus").val()
		, WgCfg_ID: {Variable:iWgCfgID}
		, Mnu_ID: $("#VentanaIndex").val()
		, SysLog_ID: $("#IDUsuario").val()
		, Wgt_ID: {Variable:iWgID}
		, WgCfgC_ID: $("#WgCfgC_ID").val() 
		, SysLogCat_ID: $("#UsuarioTpo").val()
		, TotalRegistros: $("#TotalRegistros").val()
		, TotalPaginas: $("#TotalPaginas").val()
		, Cli_ID: $("#Cli_ID").val()
		, Deu_ID: $("#Deu_ID").val()
		, CliD_ID: $("#CliD_ID").val()	
		, Com_ID: $("#Com_ID").val()	
	},function(data) { 
		$("#ContenidoGrid").html(data);
		CargaDatosAlGrid();		
	});	
//$.jGrowl("Terminando Cargado", { header: 'Aviso', sticky: false, life: 2500, glue:'before'});	
}

function CargaDatosAlGrid() {
 	
	$.post("/Plugins/Grid_IQon/GRIQon_HTML5CO.asp", { Tarea:2
		, iqCli_ID: $("#iqCli_ID").val()
		, Sys_ID: $("#SistemaActual").val()
		, SQLC: $("#SQLC").val() 
		, ConBus: $("#ConBus").val()
		, WgCfg_ID: {Variable:iWgCfgID}
		, Mnu_ID: $("#VentanaIndex").val()
		, SysLog_ID: $("#IDUsuario").val()
		, Wgt_ID: {Variable:iWgID}
		, WgCfgC_ID: $("#WgCfgC_ID").val()
		, SysLogCat_ID: $("#UsuarioTpo").val()
		, TotalRegistros: $("#TotalRegistros").val()
		, TotalPaginas: $("#TotalPaginas").val()
		, PaginaActual: 1
		, RegPorVentana: $("#RegPorVentana").val()
		, Cli_ID: $("#Cli_ID").val()
		, Deu_ID: $("#Deu_ID").val()
		, CliD_ID: $("#CliD_ID").val()	
		, Com_ID: $("#Com_ID").val()		
	},function(data) {
		$("#DatosGrid").html(data);	
		$("#btnPrimero").attr('src',$("#btnPrimero").attr('rel'));
		$("#btnAnterior").attr('src',$("#btnAnterior").attr('rel'));				
	});	

}

-->
</script>