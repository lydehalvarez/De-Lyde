
<script language="JavaScript" >
<!--
var TotReg = 0
var iSigVentana = {Variable:sSiguienteVentana};
var iActualVentana = {Variable:VentanaIndex};
var sImagenEspera = '<img src="/images/ajax-Barraroja.gif" width="128" height="15">'
 
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
	
		$("#PaginaActual").val(Valor);
		var strParmsSerial = $("#frmDatos").serialize();
		var sDatos =  "Tarea=2&";
			sDatos += strParmsSerial;
			sDatos += "&r=" + Math.floor(Math.random()*9999999);

		$.ajax({
			type:"POST",
			url: "/Plugins/Grid_IQon/GRIQon_Ajax.asp", 
			//dataType: "application/x-www-form-urlencoded",
			dataType: "html",
			data:sDatos,
			async: false,
			processData: false,
			success: function(data){ 
					$("#DatosGrid").html(data);
					  },
			error: function(XMLHttpRequest, textStatus, errorThrown) {
				$.jGrowl("Error " + errorThrown, { header: 'Aviso', sticky: true, glue:'before'});
			}               
	   });
	
//	$.post("/Plugins/Grid_IQon/GRIQon_Ajax.asp", { Tarea: 2 
//		, iqCli_ID: $("#iqCli_ID").val()
//		, Sys_ID: $("#SistemaActual").val()
//		, WgCfg_ID: {Variable:iWgCfgID}   
//		, SQLC: $("#SQLC").val()
//		, ConBus: $("#ConBus").val()
//		, Mnu_ID: $("#VentanaIndex").val()
//		, SysLog_ID: $("#IDUsuario").val()
//		, Wgt_ID: {Variable:iWgID}
//		, WgCfgC_ID: $("#WgCfgC_ID").val()
//		, SysLogCat_ID: $("#UsuarioTpo").val()
//		, TotalRegistros: $("#TotalRegistros").val()
//		, TotalPaginas: $("#TotalPaginas").val()
//		, PaginaActual: Valor
//		, RegPorVentana: $("#RegPorVentana").val()
//	},function(data) {
//		$("#DatosGrid").html(data);			
//	});	
	
}

 
function AcPaginacion(Valor) {
	
		var strParmsSerial = $("#frmDatos").serialize();
		var sDatos =  "Tarea=1&";
			sDatos += strParmsSerial;
			sDatos += "&r=" + Math.floor(Math.random()*9999999);

		$.ajax({
			type:"POST",
			url: "/Plugins/Grid_IQon/GRIQon_Ajax.asp", 
			//dataType: "application/x-www-form-urlencoded",
			dataType: "html",
			data:sDatos,
			async: false,
			processData: false,
			success: function(data){ 
					$("#ContenidoGrid").html(data);
					CargaDatosAlGrid();	
					  },
			error: function(XMLHttpRequest, textStatus, errorThrown) {
				$.jGrowl("Error " + errorThrown, { header: 'Aviso', sticky: true, glue:'before'});
			}               
	   });
	
//		$.post("/Plugins/Grid_IQon/GRIQon_Ajax.asp", { Tarea: 1 
//		, iqCli_ID: $("#iqCli_ID").val()
//		, Sys_ID: $("#SistemaActual").val()
//		, WgCfg_ID: {Variable:iWgCfgID}
//		, SQLC: $("#SQLC").val()
//		, ConBus: $("#ConBus").val()
//		, Mnu_ID: $("#VentanaIndex").val()
//		, SysLog_ID: $("#IDUsuario").val()
//		, Wgt_ID: {Variable:iWgID}
//		, WgCfgC_ID: $("#WgCfgC_ID").val()
//		, SysLogCat_ID: $("#UsuarioTpo").val()
//		, TotalRegistros: $("#TotalRegistros").val()
//		, RegPorVentana: $("#RegPorVentana").val()
//	},function(data) {
//		$("#ContenidoGrid").html(data);	
//		CargaDatosAlGrid();		
//	});	
} 

	
 	
function CargaGrid() {

//$.jGrowl("Iniciando Cargado", { header: 'Aviso', sticky: false, life: 2500, glue:'before'});

		var strParmsSerial = $("#frmDatos").serialize();
		var sDatos =  "Tarea=1&";
			sDatos += strParmsSerial;
			sDatos += "&r=" + Math.floor(Math.random()*9999999);


	var sEspera = "<div id='espera' style='position:absolute; top:50%; left: 50%; margin-top: -100px;"
		sEspera += " margin-left: -100px; height:auto; width:auto;'>"
		sEspera += " <img src='/images/ajax-engranes.gif' width='192' height='192' border='0'></div>"
	$("#Contenido2").html(sEspera);
	
		$.ajax({
			type:"POST",
			url: "/Plugins/Grid_IQon/GRIQon_Ajax.asp", 
			//dataType: "application/x-www-form-urlencoded",
			dataType: "html",
			data:sDatos,
			async: false,
			processData: false,
			success: function(data){ 
					$("#Contenido2").hide("slow");
					$("#ContenidoGrid").html(data);
					CargaDatosAlGrid();	
					  },
			error: function(XMLHttpRequest, textStatus, errorThrown) {
				$.jGrowl("Error " + errorThrown, { header: 'Aviso', sticky: true, glue:'before'});
			}               
	   });

//	$.post("/Plugins/Grid_IQon/GRIQon_Ajax.asp", { Tarea: 1 
//		, iqCli_ID: $("#iqCli_ID").val()
//		, Sys_ID: $("#SistemaActual").val()
//		, SQLC: $("#SQLC").val()
//		, ConBus: $("#ConBus").val()
//		, WgCfg_ID: {Variable:iWgCfgID}
//		, Mnu_ID: $("#VentanaIndex").val()
//		, SysLog_ID: $("#IDUsuario").val()
//		, Wgt_ID: {Variable:iWgID}
//		, WgCfgC_ID: $("#WgCfgC_ID").val() 
//		, SysLogCat_ID: $("#UsuarioTpo").val()
//		, TotalRegistros: $("#TotalRegistros").val()
//		, TotalPaginas: $("#TotalPaginas").val()
//	},function(data) { 
//		$("#ContenidoGrid").html(data);
//		CargaDatosAlGrid();		
//	});	
//$.jGrowl("Terminando Cargado", { header: 'Aviso', sticky: false, life: 2500, glue:'before'});	
}

function CargaDatosAlGrid() {
 		$("#DatosGrid").html(sImagenEspera);
		$("#PaginaActual").val(1);
		var strParmsSerial = $("#frmDatos").serialize();
		var sDatos =  "Tarea=2&";
			sDatos += strParmsSerial;
			sDatos += "&r=" + Math.floor(Math.random()*9999999);

		$.ajax({
			type:"POST",
			url: "/Plugins/Grid_IQon/GRIQon_Ajax.asp", 
			//dataType: "application/x-www-form-urlencoded",
			dataType: "html",
			data:sDatos,
			async: false,
			processData: false,
			success: function(data){ 
					$("#DatosGrid").html(data);	
					$("#btnPrimero").attr('src',$("#btnPrimero").attr('rel'));
					$("#btnAnterior").attr('src',$("#btnAnterior").attr('rel'));
					  },
			error: function(XMLHttpRequest, textStatus, errorThrown) {
				$.jGrowl("Error " + errorThrown, { header: 'Aviso', sticky: true, glue:'before'});
			}               
	   });
	
	
	
//	$.post("/Plugins/Grid_IQon/GRIQon_Ajax.asp", { Tarea:2
//		, iqCli_ID: $("#iqCli_ID").val()
//		, Sys_ID: $("#SistemaActual").val()
//		, SQLC: $("#SQLC").val() 
//		, ConBus: $("#ConBus").val()
//		, WgCfg_ID: {Variable:iWgCfgID}
//		, Mnu_ID: $("#VentanaIndex").val()
//		, SysLog_ID: $("#IDUsuario").val()
//		, Wgt_ID: {Variable:iWgID}
//		, WgCfgC_ID: $("#WgCfgC_ID").val()
//		, SysLogCat_ID: $("#UsuarioTpo").val()
//		, TotalRegistros: $("#TotalRegistros").val()
//		, TotalPaginas: $("#TotalPaginas").val()
//		, PaginaActual: 1
//		, RegPorVentana: $("#RegPorVentana").val()
//	},function(data) {
//		$("#DatosGrid").html(data);	
//		$("#btnPrimero").attr('src',$("#btnPrimero").attr('rel'));
//		$("#btnAnterior").attr('src',$("#btnAnterior").attr('rel'));				
//	});	

}

function CkTd(){
		var Checado = $('#chkT').is(':checked');
		
		$('.chkR').each(function(){
			var checkbox = $(this);
			checkbox.attr('checked',Checado);
		});
		
}


-->
</script>