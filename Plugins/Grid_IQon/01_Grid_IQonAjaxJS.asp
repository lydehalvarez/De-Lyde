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

//function grSelecciona(RegAEditar)   {
//	var iVS = 0;
//	$("#Accion").val("Consulta");
//	$("#{Variable:frmCampoLlave}").val(RegAEditar);
//	if (iSigVentana == 0 ) { 
//		iVS = iActualVentana; 
//	} else { 
//	    iVS = iSigVentana; 
//	}
//	CambiaVentana({Variable:SistemaActual},iVS)	
//
//}


function grAbreModal(RegAEditar)   {
	$("#Accion").val("Consulta");
	$("#{Variable:frmCampoLlave}").val(RegAEditar);
	//$.jGrowl("Abriendo Modal", { header: 'Aviso', sticky: false, life: 2500, glue:'before'});	
	CargaModal({Variable:sSiguienteVentana});
}

function CargaModal(sSiguienteVentana) {

	var sRuta = ""
	var iEspacioLateral = screen.width * .05;
	var iEspacioSuperior = screen.height * .15;
	var iAncho = (screen.width - (iEspacioLateral*2));
	var iAlto =  (screen.height - (iEspacioSuperior*2));
	iAncho += 15;
	//iAlto += 60;
	
	
	$("#basic-modal-content").css('width',  iAncho);
	$("#basic-modal-content").css('height', iAlto );
	
	var sDatos =  "/Default.asp?";
		sDatos += "SistemaActual=" + $("#SistemaActual").val();
		sDatos += "&IDUsuario=" + $("#IDUsuario").val();
		sDatos += "&UsuarioTpo=" + $("#UsuarioTpo").val();
		sDatos += "&SegGrupo=" + $("#SegGrupo").val();
		sDatos += "&iqCli_ID=" + $("#iqCli_ID").val();
		sDatos += "&VentanaIndex=" + $("#SiguienteVentana").val();
		sDatos += "&TabIndex=" + $("#TabIndex").val();
		sDatos += "&sUsuarioSes=" + $("#sUsuarioSes").val();
	    sDatos += "&r=" +  Math.floor(Math.random()*9999999); 
		
		
		$("#basic-modal-content").load(sDatos).modal({
			minHeight: iAlto,
			minWidth: iAncho,
			onOpen: function (dialog) {
				dialog.overlay.fadeIn('slow', function () {
					dialog.container.slideDown('slow', function () {
						dialog.data.fadeIn('slow');
					});
				  });
			},
			onClose: function (dialog) {
				dialog.data.fadeOut('slow', function () {
					dialog.container.slideUp('slow', function () {
						dialog.overlay.fadeOut('slow', function () {
							$.modal.close(); // must call this!
						});
					});
				});
			}
		},'open');


		
}


function grAccBorrar(RegABorrar,Registro) {
var iPagina = {Variable:iPagina};
var iRegPorVentana = {Variable:iRegPorVentana};
var iRegistros = {Variable:iRegPorVentana};
var iTemp = 0
  if (confirm("El registro ser� borrado permanentemente \n �Quiere continuar?"))  {
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


var oPrevElement;

function styleSwap(oElement, sEvent, sOff, sOn) {
	var cssClass
    if(sEvent == 'click') {
        if(oPrevElement != null) {
            oPrevElement.className = sOff;
        }
        if (oElement) { oElement.className = sOff; }
        oPrevElement = oElement; 
    }
    else {
        
        if (sEvent=='hover') cssClass = sOn;
        else cssClass = sOff;
        if (oPrevElement==null) {
            oElement.className = cssClass;
        }
        else {
            if(oPrevElement.id != oElement.id) {
                oElement.className = cssClass;
            }
        }
    }
}

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


function AcIrAPagina(Valor) {
	
	$.post("/Plugins/Grid_IQon/GRIQon_Ajax.asp", { Tarea: 2 
		, iqCli_ID: $("#iqCli_ID").val()
		, Sys_ID: $("#SistemaActual").val()
		, WgCfg_ID: $("#WgCfg_ID").val()
		, SQLC: $("#SQLC").val()
		, ConBus: $("#ConBus").val()
		, Mnu_ID: $("#VentanaIndex").val()
		, SysLog_ID: $("#IDUsuario").val()
		, Wgt_ID: $("#Wgt_ID").val()
		, WgCfgC_ID: $("#WgCfgC_ID").val()
		, SysLogCat_ID: $("#UsuarioTpo").val()
		, TotalRegistros: $("#TotalRegistros").val()
		, TotalPaginas: $("#TotalPaginas").val()
		, PaginaActual: Valor
		, RegPorVentana: $("#RegPorVentana").val()
	},function(data) {
		$("#DatosGrid").html(data);			
	});	
	
}


function AcPaginacion(Valor) {
	
		$.post("/Plugins/Grid_IQon/GRIQon_Ajax.asp", { Tarea: 1 
		, iqCli_ID: $("#iqCli_ID").val()
		, Sys_ID: $("#SistemaActual").val()
		, WgCfg_ID: $("#WgCfg_ID").val()
		, SQLC: $("#SQLC").val()
		, ConBus: $("#ConBus").val()
		, Mnu_ID: $("#VentanaIndex").val()
		, SysLog_ID: $("#IDUsuario").val()
		, Wgt_ID: $("#Wgt_ID").val()
		, WgCfgC_ID: $("#WgCfgC_ID").val()
		, SysLogCat_ID: $("#UsuarioTpo").val()
		, TotalRegistros: $("#TotalRegistros").val()
		, RegPorVentana: $("#RegPorVentana").val()
	},function(data) {
		$("#ContenidoGrid").html(data);	
		CargaDatosAlGrid();		
	});	
} 

	
	
function CargaGrid() {

//$.jGrowl("Iniciando Cargado", { header: 'Aviso', sticky: false, life: 2500, glue:'before'});
	$.post("/Plugins/Grid_IQon/GRIQon_Ajax.asp", { Tarea: 1 
		, iqCli_ID: $("#iqCli_ID").val()
		, Sys_ID: $("#SistemaActual").val()
		, SQLC: $("#SQLC").val()
		, ConBus: $("#ConBus").val()
		, WgCfg_ID: $("#WgCfg_ID").val()
		, Mnu_ID: $("#VentanaIndex").val()
		, SysLog_ID: $("#IDUsuario").val()
		, Wgt_ID: $("#Wgt_ID").val()
		, WgCfgC_ID: $("#WgCfgC_ID").val()
		, SysLogCat_ID: $("#UsuarioTpo").val()
		, TotalRegistros: $("#TotalRegistros").val()
		, TotalPaginas: $("#TotalPaginas").val()
	},function(data) { 
		$("#ContenidoGrid").html(data);	
		CargaDatosAlGrid();		
	});	
//$.jGrowl("Terminando Cargado", { header: 'Aviso', sticky: false, life: 2500, glue:'before'});	
}

function CargaDatosAlGrid() {
	
	$.post("/Plugins/Grid_IQon/GRIQon_Ajax.asp", { Tarea:2
		, iqCli_ID: $("#iqCli_ID").val()
		, Sys_ID: $("#SistemaActual").val()
		, SQLC: $("#SQLC").val() 
		, ConBus: $("#ConBus").val()
		, WgCfg_ID: $("#WgCfg_ID").val()
		, Mnu_ID: $("#VentanaIndex").val()
		, SysLog_ID: $("#IDUsuario").val()
		, Wgt_ID: $("#Wgt_ID").val()
		, WgCfgC_ID: $("#WgCfgC_ID").val()
		, SysLogCat_ID: $("#UsuarioTpo").val()
		, TotalRegistros: $("#TotalRegistros").val()
		, TotalPaginas: $("#TotalPaginas").val()
		, PaginaActual: 1
		, RegPorVentana: $("#RegPorVentana").val()
	},function(data) {
		$("#DatosGrid").html(data);	
		$("#btnPrimero").attr('src',$("#btnPrimero").attr('rel'));
		$("#btnAnterior").attr('src',$("#btnAnterior").attr('rel'));				
	});	

}

-->
</script>