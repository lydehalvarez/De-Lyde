<link rel="stylesheet" type="text/css" href="/css/ui.daterangepicker.css">
<script type="text/javascript" src="/js/date.js"></script>
<script type="text/javascript" src="/js/daterangepicker.jQuery.js"></script>
<script type="text/javascript">


function DespuesDeCargar() {
	
	//alert("Pte_Com_ID " + $("#PteCom_ID").val() + " Pte_ReP_ID " + $("#PteReP_ID").val());
	//Entra como nuevo
	var sDatos = "Tarea=1";
	
	if ($("#PteReP_ID").val() > -1 ) {
		sDatos += "&Com_ID="+$("#PteCom_ID").val();
		sDatos += "&ReP_ID="+$("#PteReP_ID").val();
	} else {
		sDatos += "&Com_ID=-1";
		sDatos += "&ReP_ID=-1";
	}
	//1.-
	//alert(sDatos);
	$("#CboCompania").load("/pz/Inventa/Cobranza/RelacionPagos/RelacionDePagos_Ajax.asp?"+sDatos);
	if ($("#PteReP_ID").val() > -1) {
		//alert($("#PteCom_ID").val() + " --- "  + $("#PteReP_ID").val());
		CargaDatosGralesCom($("#PteCom_ID").val(),$("#PteReP_ID").val());
	}
				
}


function CargaDatosGralesCom(ijsComID,ijsRePID) {
	
	var sDatos = "Tarea=3"; 
		sDatos += "&Com_ID=" + ijsComID;
		sDatos += "&ReP_ID=" + ijsRePID;
		//alert(sDatos);
	//2.-
	$("#FichaAMano").load("/pz/Inventa/Cobranza/RelacionPagos/RelacionDePagos_Ajax.asp?"+sDatos, function() {
			CargaRelacionPagosGenerados(ijsComID,ijsRePID);
	});
	
}

function CargaRelacionPagosGenerados(ijsComID,ijsRePID) {
	
	var sDatos = "Tarea=3"; 
		sDatos += "&Com_ID=" + ijsComID;
		sDatos += "&ReP_ID=" + ijsRePID;
		//alert(sDatos);
	//3.-
	$("#GridDatos").load("/pz/Inventa/Cobranza/RelacionPagos/RelacionDePagosGrid.asp?"+sDatos, function() {
		CargaTotalesGrid(ijsComID,ijsRePID);
	});
}

function CargaTotalesGrid(ijsComID,ijsRePID) {
	var sDatos = "Tarea=4"; 
		sDatos += "&Com_ID=" + ijsComID;
		sDatos += "&ReP_ID=" + ijsRePID;	
	$("#GridTotales").load("/pz/Inventa/Cobranza/RelacionPagos/RelacionDePagos_Ajax.asp?"+sDatos);
}


function Liquidar(ijsRePID,ijsComID,ijsConID,ijsEmpID) {
	//alert(ijsRePID + " - " + ijsComID + " - " + ijsConID + " - " + ijsEmpID);
	
	$("#ReP_ID").val(ijsRePID);
	$("#Com_ID").val(ijsComID);
	$("#Con_ID").val(ijsConID);
	$("#Emp_ID").val(ijsEmpID);
	
	if ( {Variable:sSiguienteVentana} == 0) {
		CambiaVentana({Variable:SistemaActual},{Variable:VentanaIndex})
	} else {
		CambiaVentana({Variable:SistemaActual},{Variable:sSiguienteVentana})
	}	

}


function ValidaFecha() {
	if ($("#FechaInicio").val() != "") {
		return true;
	} else {
		$.msgbox('Por favor introduzca una fecha válida, gracias.',	{type: 'alert'});
		return false;
	}
}


function EliminaRegManual(ijsElimina,sjsValor) {
// RePE_GeneradoCG24
	//alert(sjsValor);
	var str = sjsValor;
	var iSeElimina = str.charAt(0)
	//alert(iSeElimina);
	//alert(parseInt(iSeElimina));
	if (parseInt(iSeElimina) == 2) {
		//alert("Entra I");
		//alert("Entramos " + parseInt(iSeElimina));
		//alert("str " + str.substr(2));
		var sjsValores = str.substr(2);
		//alert(sjsValores);
		GuardarOEliminar(0,sjsValores);
	} else {
		//alert("Entra II");
		var sjsValores = str.substr(2);
		var sLey = ""
		if (ijsElimina == 0) { sLey = " Restar " } else { sLey = " Sumar " } 
		//alert("Vamos a...." + sLey + " y los valores son estos.... " + sjsValores);
		ModificarSaldoProgramado(ijsElimina,sjsValores);
		
	}
	
}


function GuardarOEliminar(ijqAccion,ijqValor) {
		 //GuardarOEliminar(ACCION-GUARDAR-ELIMINAR,VALOR(ES))
		 
var Tarea = 1
var sDatos = ""	
var randomNo = Math.floor(Math.random()*9999999);

// ReP_ID  RePE_ID	Com_ID	Con_ID	Cob_ID	RePE_Pagado	RePE_Monto	RePE_GeneradoCG24	Emp_ID
// ReP_ID, RePE_ID, Com_ID, Con_ID, Cob_ID

sDatos = "Tarea="+Tarea+"&Accion="+ ijqAccion + "&checkboxValor=" +ijqValor + "&LlaveForanea=" + $('#ReP_ID').val() + "&Tabla=RelacionPagoElemento" + "&r=" + randomNo;
//alert("sDatos " + sDatos);
	$.ajax({
			type:"POST",
			url: "/pz/Inventa/Cobranza/RelacionPagos/CobranzaIndividual_Ajax.asp",
			//dataType: "application/x-www-form-urlencoded",
			dataType: "html",
			data: sDatos,
			async: false,
			processData: false,
			success: function(output) {
						//alert("Los datos se guardaron correctamente");
						//alert(output);
						$("#Resultadoajax").html(output);
						CargaDatosGralesCom($("#Com_ID").val(),$("#PteReP_ID").val());

					  },
			error: function(XMLHttpRequest, textStatus, errorThrown) {
				//alert(XMLHttpRequest);
				//alert(textStatus);
				alert("Error " + textStatus);
			}						
		});
}


function ModificarSaldoProgramado(ijsSumaRestaSaldo,ijqValor) {
//GuardarOEliminar(ACCION-GUARDAR-ELIMINAR,VALOR(ES))
//alert("Entra..II");
/*var str = ijqValor;
var iSeElimina = str.charAt(0)
var sjsValores = str.substr(2);*/

var Tarea = 2
var sDatos = ""	
var randomNo = Math.floor(Math.random()*9999999);

// ReP_ID  RePE_ID	Com_ID	Con_ID	Cob_ID	RePE_Pagado	RePE_Monto	RePE_GeneradoCG24	Emp_ID
// ReP_ID, RePE_ID, Com_ID, Con_ID, Cob_ID

sDatos = "Tarea="+Tarea+"&Accion="+ ijsSumaRestaSaldo + "&checkboxValor=" +ijqValor + "&LlaveForanea=" + $('#ReP_ID').val() + "&Tabla=RelacionPago" + "&r=" + randomNo;
//alert("sDatos " + sDatos);
	$.ajax({
			type:"POST",
			url: "/pz/Inventa/Cobranza/RelacionPagos/CobranzaIndividual_Ajax.asp",
			//dataType: "application/x-www-form-urlencoded",
			dataType: "html",
			data: sDatos,
			async: false,
			processData: false,
			success: function(output) {
						//alert("Los datos se guardaron correctamente");
						//alert(output);
						$("#Resultadoajax").html(output);
						//3.-
						/*CargaDatosGralesCom($("#Com_ID").val(),$('#ReP_ID').val());*/
						var sDatos = "Tarea=3"; 
							sDatos += "&Com_ID=" + $("#Com_ID").val();
							sDatos += "&ReP_ID=" + $('#ReP_ID').val();
						//2.-
						$("#FichaAMano").load("/pz/Inventa/Cobranza/RelacionPagos/RelacionDePagos_Ajax.asp?"+sDatos);
						CargaTotalesGrid($("#Com_ID").val(),$('#ReP_ID').val());
					  },
			error: function(XMLHttpRequest, textStatus, errorThrown) {
				//alert(XMLHttpRequest);
				//alert(textStatus);
				alert("Error " + textStatus);
			}						
		});
}



function GenerarListado() {
		//$("#GridDatos").html('<div id="espera" style="position:absolute; top:50%; left: 50%; margin-top: -100px; margin-left: -100px; height:auto; width:auto;"><img src="/images/ajax-engranes.gif" width="192" height="192">');
	
	var Tarea = 2
	var sDatos = ""	
	var randomNo = Math.floor(Math.random()*9999999);
	
	sDatos = "Tarea="+Tarea+"&Com_ID="+$("#Com_ID").val()+"&Rep_FechaDeCorte=" + $("#FechaInicio").val() + "&Rep_FechaFinal=" + $("#FechaFin").val() + "&r=" + randomNo;
	alert("sDatos " + sDatos);
	$.ajax({
			type:"POST",
			url: "/pz/Inventa/Cobranza/RelacionPagos/RelacionDePagos_Ajax.asp",
			//dataType: "application/x-www-form-urlencoded",
			dataType: "html",
			data: sDatos,
			async: false,
			processData: false,
			success: function(output) {
						//alert("Los datos se guardaron correctamente");
						alert(output);
						//$("#Resultadoajax").html(output);
						//3.-
						$("#ReP_ID").val(parseInt(output));
						var sDatos = "Tarea=1"
							sDatos += "&Com_ID="+$("#Com_ID").val();
							sDatos += "&ReP_ID="+parseInt(output);
						$("#CboCompania").load("/pz/Inventa/Cobranza/RelacionPagos/RelacionDePagos_Ajax.asp?"+sDatos);
						CargaDatosGralesCom($("#Com_ID").val(),parseInt(output));
						/*var sDatos = "Tarea=3"; 
							sDatos += "&Com_ID=" + $("#Com_ID").val();
							sDatos += "&ReP_ID=" + $('#ReP_ID').val();
						//2.-
						$("#FichaAMano").load("/pz/Inventa/Cobranza/RelacionPagos/RelacionDePagos_Ajax.asp?"+sDatos);
						CargaTotalesGrid($("#Com_ID").val(),$('#ReP_ID').val());*/
						
					  },
			error: function(XMLHttpRequest, textStatus, errorThrown) {
				//alert(XMLHttpRequest);
				//alert(textStatus);
				alert("Error " + textStatus);
			}						
		});

}



var oPrevElement;
// click hover normal
// <tr class="normal" onMouseOver="styleSwap(this, 'hover', 'normal', 'rowHiliten');" onMouseOut="styleSwap(this, 'normal', 'hover', 'rowHiliten');">
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

</script>






