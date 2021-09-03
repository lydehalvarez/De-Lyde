/*
HA ID: 1	2020-jun-26 Creacion de archivo: Transferencias
HA ID: 2	2020-jul-06 Numeros de Serie: Se agrega Sección de Elección y visualización de Numeros de Serie
*/

$(document).ready(function(){
			
	$("#selOrigenAlmacen").select2();
	$("#selDestinoAlmacen").select2();
	
	 $('.date').datepicker({
		todayBtn: "linked",
		keyboardNavigation: false,
		forceParse: false,
		calendarWeeks: true,
		autoclose: true,
		startDate: '0d',
		//format: 'dd/mm/yyyy'
	});

});

var Cliente = {
	Lyde: intCliLyde
	
	, Seleccionar: function(){
		Almacen.Cargar();
		
		var strCli = $("#selCliente option:selected").text();
		
		$("#lblResCliente").text(strCli);
	}
}

var Transferencia = {
	  Tipo: {
		  Ingreso: 1
		, Egreso: 2
		, Sucursales: 3
	}
	, Seccion: {
		  Tipo: 1
		, Destino: 2
		, Articulo: 3
		, Resumen: 4
		, Terminar: 5
		, Fin: 6
	}
	, Seleccionar: function(){
		
		Almacen.Cargar();
		
	}
	, ActivarSeccion: function( prmIntTab ){
		
		switch( parseInt(prmIntTab) ){
			case Transferencia.Seccion.Tipo: {
				
				Transferencia.VisualizarSeccion( Transferencia.Seccion.Tipo );
				
			} break;
			
			case Transferencia.Seccion.Destino: {
				
				var bolVal = Transferencia.Validar( Transferencia.Seccion.Tipo );
				
				if( bolVal ) {
					Transferencia.VisualizarSeccion( Transferencia.Seccion.Destino );
				}
				
			} break;
			
			case Transferencia.Seccion.Articulo: {
				
				var bolVal = Transferencia.Validar( Transferencia.Seccion.Destino );
				var bolGua = false;
				
				if( bolVal ) {
					
					bolGua = Transferencia.Guardar();
					
					if( bolGua ){
						
						Articulo.Eliminar(0, 0);
						
						/* HA ID: 2 */
						Serie.Ocultar();
						
						Transferencia.VisualizarSeccion( Transferencia.Seccion.Articulo );
					}
				}
				
			} break;
			
			case Transferencia.Seccion.Resumen: {
				
				var bolVal = Transferencia.Validar( Transferencia.Seccion.Articulo );
				
				if( bolVal ){
					Transferencia.ExtraerDatosReporte();
					
					Transferencia.VisualizarSeccion( Transferencia.Seccion.Resumen );
					
					/* HA ID: 2 */
					Serie.Ocultar();
				}
				
			} break;
			
			case Transferencia.Seccion.Terminar: {
				
				/* HA ID: 2 */
				Serie.Ocultar();
				
				var strFolio = $("#TA_Folio").val();
				$("#spanFolio").text(strFolio);
				
				Transferencia.VisualizarSeccion( Transferencia.Seccion.Terminar );
				
			} break; 
			
			case Transferencia.Seccion.Fin: {
				
				CambiaVentana(intIdSis, intRedVen);
				
			} break;
			
		}
	}
	, Guardar: function(){
		
		var intTAId = $("#TA_ID").val();
		
		var intCliId = $("#selCliente").val();
		var intTtrId = $("input[name=TipoTransferencia]:checked").val();
		var dateFecEnt = $("#inpFechaEntrega").val();
		
		var intOriAlm = $("#selOrigenAlmacen").val();
		var strOriRes = $("#inpOrigenResponsable").val();
		var strOriTel = $("#inpOrigenTelefono").val();
		var strOriEma = $("#inpOrigenEmail").val();
		
		var intDesAlm = $("#selDestinoAlmacen").val();
		var strDesRes = $("#inpDestinoResponsable").val();
		var strDesTel = $("#inpDestinoTelefono").val();
		var strDesEma = $("#inpDestinoEmail").val();
		
		var bolGua = false;
		
		$.ajax({
			  url: strRutaBaseTA + "TA_Ajax.asp"
			, method: "post"
			, dataType: "json"
			, async: false
			, data: {
				  Tarea: 3
				, TA_Id: intTAId
				, Cli_Id: intCliId
				, Ttr_Id: intTtrId
				, FechaEntrega: dateFecEnt
				, OriAlm_ID: intOriAlm
				, OriResponsable: strOriRes
				, OriTelefono: strOriTel
				, OriEmail: strOriEma
				, DesAlm_ID: intDesAlm
				, DesResponsable: strDesRes
				, DesTelefono: strDesTel
				, DesEmail: strDesEma
			}
			, success: function( res ){
				
				if( parseInt(res.Error) == 0 ){
					
					$("#TA_ID").val(res.TA_ID);
					$("#TA_Folio").val(res.TA_Folio);
					
					Avisa("success", "Transferencia", res.Mensaje);
					bolGua = true;
				} else {
					Avisa("error", "Transferencia", res.Mensaje);
				}
			}
			
		});
		
		return bolGua;
		
	}
	, VisualizarSeccion: function( prmIntPag ){
		
		$("#tab-"+prmIntPag).show();
		
		$(".tab-content .tab-pane").each(function(){
			
			if( $(this).prop("id") != "tab-"+ prmIntPag ){
				$(this).hide();
			}
		});
		
	}	
	, Validar: function( prmIntPag ){
	
		var arrRes = [];
		var bolval = true;
		
		var intCliId = $("#selCliente").val();
		var intTtrId = $("input[name=TipoTransferencia]:checked").val();
		var dateFecEnt = $("#inpFechaEntrega").val();
		
		switch( parseInt(prmIntPag) ){
		
			case Transferencia.Seccion.Tipo: {
				
				if( !(parseInt(intTtrId) > 0) ){
					arrRes.push("Seleccionar el Tipo de Transferencia");
					bolval = false;
				}
				
				if( !(parseInt(intCliId) > 0) ){
					arrRes.push("Seleccionar el cliente");
					bolval = false;
				}
				
				if( dateFecEnt == "" ){
					
					arrRes.push("Seleccionar la Fecha de Entrega");
					bolval = false;
				}
				
			} break;
			
			case Transferencia.Seccion.Destino: {
				
				if( Transferencia.Tipo.Ingreso == intTtrId || Transferencia.Tipo.Sucursales == intTtrId ){
					
					var intOriAlm = $("#selOrigenAlmacen").val();
					var strOriRes = $("#inpOrigenResponsable").val();
					var strOriTel = $("#inpOrigenTelefono").val();
					var strOriEma = $("#inpOrigenEmail").val();
					
					if( !(parseInt(intOriAlm) > 0) ){
						arrRes.push("Seleccionar el almacen de Origen");
						bolval = false;
					}
					
					if( strOriRes == "" ){
						arrRes.push("Agregar el responsable de Origen");
						bolval = false;
					}
					
					if( strOriTel == "" ){
						arrRes.push("Agregar el tel&eacute;fono de Origen");
						bolval = false;
					}
					
					if( strOriEma != ""){
						if( !( strOriEma.match(/^[a-zA-Z0-9.!#$%&'*+//=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/mg) ) ){
							arrRes.push("Agregar un Email de Origen correcto");
							bolval = false;
						}
					}
					
				}
				
				if( Transferencia.Tipo.Egreso == intTtrId || Transferencia.Tipo.Sucursales == intTtrId ){
					
					var intDesAlm = $("#selDestinoAlmacen").val();
					var strDesRes = $("#inpDestinoResponsable").val();
					var strDesTel = $("#inpDestinoTelefono").val();
					var strDesEma = $("#inpDestinoEmail").val();
					
					if( !(parseInt(intDesAlm) > 0) ){
						arrRes.push("Seleccionar el almacen de Destino");
						bolval = false;
					}
					
					if( strDesRes == "" ){
						arrRes.push("Agregar el responsable de Destino");
						bolval = false;
					}
					
					if( strDesTel == "" ){
						arrRes.push("Agregar el tel&eacute;fono de Destino");
						bolval = false;
					}
					
					if( strDesEma != "" ){
						if( !( strDesEma.match(/^[a-zA-Z0-9.!#$%&'*+//=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/mg) ) ){
							arrRes.push("Agregar un Email de Destino correcto");
							bolval = false;
						}
					}
					
				}
				
				if( Transferencia.Tipo.Sucursales == intTtrId && ( intOriAlm == intDesAlm ) ){
					arrRes.push("Seleccionar Almacenes diferentes para la transferencia");
					bolval = false;
				}
				
			} break;
			
			case Transferencia.Seccion.Articulo: {
				
				var bolInc = false;
				
				if( !( $(".trProducto").length > 0 ) ){
					arrRes.push("Agregar Articulos a Transferir");
					bolval = false;
				} else {
					
					$(".classProducto").each(function(){
						if( parseInt($(this).data("taarestante")) != 0 ){
							bolInc = true;
						}
					});
					
					if( bolInc ){
						arrRes.push("Seleccionar todos los N&uacute;meros de Serie Faltantes");
						bolval = false;
					}
				}
				
			} break;
		}
		
		if( !(bolval) ){
			Avisa("warning", "Completar el formulario", arrRes.join("<br>"));
		}
		
		return bolval;
	}
	, ExtraerDatosReporte: function(){
		
		//Tipo de Transferencia
		var intTipo = $("input[name=TipoTransferencia]:checked").val();
		var strTipo = $("#lblTipoTransferencia_" + intTipo).text();
		
		$("#lblResTipo").text(strTipo);
		
		//Fecha Entrega
		var dateFecEnt = $("#inpFechaEntrega").val();
		
		$("#lblResFechaEntrega").text(dateFecEnt);
		
		//Almacen
		var strOriAlm = $("#selOrigenAlmacen option:selected").text();
		var strOriRes = $("#inpOrigenResponsable").val();
		var strOriTel = $("#inpOrigenTelefono").val();
		var strOriEma = $("#inpOrigenEmail").val();
		var strOriDir = $("#inpOrigenDireccionCompleta").text();
		
		$("#lblResumenOrigenAlmacen").text(strOriAlm);
		$("#lblResumenOrigenResponsable").text(strOriRes);
		$("#lblResumenOrigenTelefono").text(strOriTel);
		$("#lblResumenOrigenEmail").text(strOriEma);
		$("#lblResumenOrigenDireccionCompleta").text(strOriDir);
		
		var strDesAlm = $("#selDestinoAlmacen option:selected").text();
		var strDesRes = $("#inpDestinoResponsable").val();
		var strDesTel = $("#inpDestinoTelefono").val();
		var strDesEma = $("#inpDestinoEmail").val();
		var strDesDir = $("#inpDestinoDireccionCompleta").text();
		
		$("#lblResumenDestinoAlmacen").text(strDesAlm);
		$("#lblResumenDestinoResponsable").text(strDesRes);
		$("#lblResumenDestinoTelefono").text(strDesTel);
		$("#lblResumenDestinoEmail").text(strDesEma);
		$("#lblResumenDestinoDireccionCompleta").text(strDesDir);
		
		//Articulos
		Articulo.Cargar( false );
		
	}
};

var Almacen = {
	  Lyde: intAlmLyde
	, Tipo: {
		  Origen: 1
		, Destino: 2
	}
	, Cargar: function(){
		
		var intCliId = $("#selCliente").val();
		var intTtrId = $("input[name=TipoTransferencia]:checked").val();
		
		if( parseInt(intCliId) != 0 && parseInt(intTtrId) != 0 ){
			
			Almacen.Limpiar();
					
			//Origen
			$.ajax({
				  url: strRutaBaseTA + "TA_Ajax.asp"
				, method: "post"
				, async: false
				, data: {
					  Tarea: 1 //almacenes
					, CLI_ID: ( Transferencia.Tipo.Egreso == intTtrId ) ? Cliente.Lyde: intCliId
				}
				, success: function( res ){
					
									
					$(".classOrigen").show();
					$("#selOrigenAlmacen").html( res );
					
					if( Transferencia.Tipo.Egreso == intTtrId ){
						
						$("#selOrigenAlmacen").val(Almacen.Lyde);
						$("#select2-selOrigenAlmacen-container").text( $("#selOrigenAlmacen option:selected").text() );
						
						Almacen.Seleccionar(Almacen.Tipo.Origen);
												
					}
					
				}
				
			});

			//Destino
			$.ajax({
				  url: strRutaBaseTA + "TA_Ajax.asp"
				, method: "post"
				, async: false
				, data: {
					  Tarea: 1 //almacenes
					, CLI_ID: ( Transferencia.Tipo.Ingreso == intTtrId ) ? Cliente.Lyde: intCliId
				}
				, success: function( res ){
					
					$(".classDestino").show();
					$("#selDestinoAlmacen").html( res );
					
					if( Transferencia.Tipo.Ingreso == intTtrId ){
						
						$("#selDestinoAlmacen").val(Almacen.Lyde);
						$("#select2-selDestinoAlmacen-container").text(  $("#selDestinoAlmacen option:selected").text() );

						Almacen.Seleccionar(Almacen.Tipo.Destino);
						
					} 
					
				}
				
			});
				
		}
		
		
	}
	, Seleccionar: function( intTipAlm ){
		
		switch( parseInt(intTipAlm) ){
			case Almacen.Tipo.Origen: {
				
				var strOriAlm = $("#selOrigenAlmacen option:selected").text();
				var strOriRes = $("#selOrigenAlmacen option:selected").data("responsable");
				var strOriTel = $("#selOrigenAlmacen option:selected").data("telefono");
				var strOriEma = $("#selOrigenAlmacen option:selected").data("email");
				var strOriDir = $("#selOrigenAlmacen option:selected").data("direccioncompleta");
				
				$("#inpOrigenResponsable").val(strOriRes);
				$("#inpOrigenTelefono").val(strOriTel);
				$("#inpOrigenEmail").val(strOriEma);
				$("#inpOrigenDireccionCompleta").text(strOriDir);
				
			} break;
			
			case Almacen.Tipo.Destino: {
				
				var strDesAlm = $("#selDestinoAlmacen option:selected").text();
				var strDesRes = $("#selDestinoAlmacen option:selected").data("responsable");
				var strDesTel = $("#selDestinoAlmacen option:selected").data("telefono");
				var strDesEma = $("#selDestinoAlmacen option:selected").data("email");
				var strDesDir = $("#selDestinoAlmacen option:selected").data("direccioncompleta");
				
				$("#inpDestinoResponsable").val(strDesRes);
				$("#inpDestinoTelefono").val(strDesTel);
				$("#inpDestinoEmail").val(strDesEma);
				$("#inpDestinoDireccionCompleta").text(strDesDir);
				
			} break;
		}
		
	}
	, Limpiar: function(){
		
		$("#select2-selOrigenAlmacen-container").text("").attr("title","");
		$("#select2-selDestinoAlmacen-container").text("").attr("title","");
		
		$("#inpOrigenResponsable").val("");
		$("#inpOrigenTelefono").val("");
		$("#inpOrigenEmail").val("");
		$("#inpOrigenDireccionCompleta").text("");
		
		$("#inpDestinoResponsable").val("");
		$("#inpDestinoTelefono").val("");
		$("#inpDestinoEmail").val("");
		$("#inpDestinoDireccionCompleta").text("");
	}
	
};

var Articulo = {
	
	Cargar: function( prmEsEdi ){
		
		var intTAId = $("#TA_ID").val();
		//Se agrega para validación
		var intTTRId = $("input[name=TipoTransferencia]:checked").val();
		var bolSiSer = ( intTTRId == Transferencia.Tipo.Ingreso || intTTRId == Transferencia.Tipo.Sucursales ) ? 1 : 0;
		
		$.ajax({
			url: strRutaBaseTA + "TA_Ajax.asp"
			, method: "post"
			, async: false
			, data: {
				  Tarea: 4
				, TA_ID: intTAId
				, SiSer: bolSiSer
				, EsEdi: (prmEsEdi) ? 1 : 0
			}
			, success: function( res ){
				
				if( prmEsEdi ){
					$("#tbodyArt").html(res);
				} else {
					$("#tbodyResArt").html(res);
				}

			}
		});
		
	}
	, Buscar: function(){
		
		var intCliId = $("#selCliente").val();
		var intTtrId = $("input[name=TipoTransferencia]:checked").val();
		
		var strBusArt = $("#inpBuscarArticulo").val();
		
		var intAlmId = 0
		
		if( Transferencia.Tipo.Ingreso == intTtrId || Transferencia.Tipo.Sucursales == intTtrId ){
			intAlmId = $("#selOrigenAlmacen").val()
		} else {
			intAlmId = Almacen.Lyde
		}
		
		$.ajax({
			  url: strRutaBaseTA + "TA_Ajax.asp"
			, method: "post"
			, data: {
				  Tarea: 2
				, ALM_ID: intAlmId
				, CLI_ID: intCliId
				, TTR_ID: intTtrId
				, TextoBuscar: strBusArt
			}
			, success: function( res ){
				
				$("#tbodyBusArt").html(res);

			}
		});
	}
	, Agregar: function( prmIntProId ){
		
		var arrRes = [];
		var bolval = true;
		
		var intProCan = $("#inpProCantidad_"+prmIntProId).val();
		var strProSKU = $("#inpProCantidad_"+prmIntProId).data("sku");
		var intProDis = $("#inpProCantidad_"+prmIntProId).data("disponible");
		
		var intTAId = $("#TA_ID").val();
		
		
		if( $("#trProId_"+prmIntProId).length > 0 ){
			arrRes.push("El producto ya fue agregado");
			bolval = false;
		} else {
		
		
			if( intProCan == "" ){
				arrRes.push("Agregar la cantidad del producto a transferir");
				bolval = false;			
			} else if( !( intProCan.match(/^[0-9]+$/gm) ) ){
				arrRes.push("Agregar la cantidad solo N&uacute;meros Enteros");
				bolval = false;
			} else if( parseInt(intProDis) < parseInt(intProCan) ){
				arrRes.push("Cantidad Seleccionada es mayor a la disponible");
				bolval = false;
			}
		
		}
		
		if( !(bolval) ){
			
			Avisa("warning", "Completar el formulario seleccionado", arrRes.join("<br>"));
			$("#Alerta_"+prmIntProId).show();
			
		} else {
			
			$.ajax({
				  url: strRutaBaseTA + "TA_Ajax.asp"
				, method: "post"
				, async: false
				, dataType: "json"
				, data: {
					  Tarea: 5
					, TAId: intTAId
					, ProId: prmIntProId
					, ProCantidad: intProCan
					, ProSKU: strProSKU
				}
				, success: function( res ){
					
					if( parseInt(res.Error) == 0){
						
						$("#inpProCantidad_"+prmIntProId).val("");
						$("#Alerta_"+prmIntProId).hide();
						
						Avisa("success", "Transferencias Producto", "Se agreg&oacute; el producto a la transferencia");
						Articulo.Cargar( true );
						
					} else {
						
						Avisa("warning", "Transferencias Producto", "No se agreg&oacute; el producto a la transferencia");
						
					}
				}
			});
			
		}
		
	}
	, Eliminar: function(prmIntTAAId, prmTipo){
		
		var intTAId = $("#TA_ID").val();
		
		$.ajax({
			  url: strRutaBaseTA + "TA_Ajax.asp"
			, method: "post"
			, async: false
			, dataType: "json"
			, data: {
				  Tarea: 6
				, TAId: intTAId
				, TAAId: prmIntTAAId
				, Tipo: prmTipo
			}
			, success: function( res ){
				
				if( parseInt(res.Error) == 0){
					
					Articulo.Cargar( true );
					if( parseInt(prmTipo) == 1 ){
						Avisa("success", "Transferencias Producto", "Se elimin&oacute; el producto de la transferencia");
					}
					
				} else {
					
					Avisa("warning", "Transferencias Producto", "No se elimin&oacute; el producto de la transferencia");
					
				}
			}
		});
	}
	, Cerrar: function(){
		
		$("#tbodyBusArt").html("");
		$("#inpBuscarArticulo").val("");
		
	}
};

/* HA ID: 2 INI Sección de Serie
*/
var Serie = {
	  Visualizar: function(){
		$("#divSerie").show();
	}
	, Ocultar: function(){
		$("#divSerie").hide();
		$("#divNumerosSerie").html("");
	}
	, Cargar: function( prmIntTA_Id, prmIntTAA_Id, prmIntPRO_Id, prmEsEdicion ){
		
		$.ajax({
			  url: strRutaBaseTA + "TA_Ajax.asp"
			, method: "post"
			, async: false
			, data: {
				  Tarea: 7 //Cargar Numeros de Series
				, TA_ID: prmIntTA_Id
				, TAA_ID: prmIntTAA_Id
				, PRO_ID: prmIntPRO_Id
				, EsEdicion: prmEsEdicion
			}
			, success: function( res ){
				Serie.Visualizar();
				$("#divNumerosSerie").html(res);
			}
		})
		
	}
	, VisualizarBusqueda: function( prmObjTAA ){

		var intTAAID = $(prmObjTAA).data("taaid");
		var intPROID = $(prmObjTAA).data("proid");
		var strPRONom = $(prmObjTAA).data("pronombre");
		var intTAACantidad = $(prmObjTAA).data("taacantidad");
		
		$("#spanBuscarSerieArticuloNombre").text(strPRONom);
		
		$("#inpBuscarSerieTAAId").val(intTAAID);
		$("#inpBuscarSeriePROId").val(intPROID);
		$("#inpBuscarSerieTAACantidad").val(intTAACantidad);		
		
		//validar numero de Series si es visible si no actualizar y hacer visible

	}
	, Buscar: function(){
		
		var intCliId = $("#selCliente").val();
		var intTtrId = $("input[name=TipoTransferencia]:checked").val();
		
		var intAlmId = 0
		
		if( Transferencia.Tipo.Ingreso == intTtrId || Transferencia.Tipo.Sucursales == intTtrId ){
			intAlmId = $("#selOrigenAlmacen").val()
		} else {
			intAlmId = Almacen.Lyde
		}
		
		var intPROId = $("#inpBuscarSeriePROId").val();
		var strTAASerie = $("#inpBuscarSerie").val();
		
		$.ajax({
			  url: strRutaBaseTA + "TA_Ajax.asp"
			, method: "post"
			, async: false
			, data: {
				  Tarea: 8 //Buscar Numero de Series
				, TTR_ID: intTtrId
				, CLI_ID: intCliId
				, ALM_ID: intAlmId
				, PRO_ID: intPROId
				, PRO_Serie: strTAASerie
			}
			, success: function( res ){
				$("#tbodyBusSer").html(res);
			}
		})
	}
	, Cerrar: function(){
		
		$("#tbodyBusSer").html("");
		$("#spanBuscarSerieArticuloNombre").text("");
		$("#inpBuscarSerieTAAId").val("");
		$("#inpBuscarSeriePROId").val("");
		$("#inpBuscarSerieTAACantidad").val("");	

		$("#inpBuscarSerie").val("");
	}
	, Agregar: function( prmObjSer ){
		
		var arrRes = [];
		var bolval = true;
		
		var intTA_ID = $("#TA_ID").val();
		var intTAA_ID = $("#inpBuscarSerieTAAId").val();
		var strTAS_Serie = $(prmObjSer).data("invserie");
		var intTAS_Usuario = $("#IDUsuario").val()
		var intPRO_ID = $("#inpBuscarSeriePROId").val();
		var intINV_ID = $(prmObjSer).data("invid");
		
		var intTAA_Cantidad = $("#inpBuscarSerieTAACantidad").val();
		
		//validar existencia de numero de serie
		$(".classSerie").each(function() {
			if( $(this).text() == strTAS_Serie ){
	            arrRes.push("N&uacute;mero de Serie ya agregada");
				bolval = false;
			}
        });
		
		if( $(".classSerie").length == intTAA_Cantidad ){
			arrRes.push("Ya se agregaron todos los N&uacute;meros de Serie Solicitados");
			bolval = false;
		}
		
		if( !(bolval) ){
			
			Avisa("warning","N&uacute;mero de Serie", arrRes.join("<br>"));
			
		} else {
		
			$.ajax({
				  url: strRutaBaseTA + "TA_Ajax.asp"
				, method: "post"
				, async: false
				, dataType:"json"
				, data: {
					  Tarea: 9 //Inserción de Serie
					, TA_ID: intTA_ID
					, TAA_ID: intTAA_ID
					, TAS_Serie: strTAS_Serie
					, TAS_Usuario: intTAS_Usuario
					, PRO_ID: intPRO_ID
					, INV_ID: intINV_ID
				}
				, success: function( res ){
					
					if(parseInt(res.Error) == 0){
						
						Avisa("succes", "N&uacute;mero de Serie", "Se Agreg&oacute; el N&uacute;mero de Serie");
						
						Serie.Cargar( intTA_ID, intTAA_ID, intPRO_ID, 1);
						Serie.Buscar();
						Articulo.Cargar( 1 );
						
					} else {
						Avisa("warning", "N&uacute;mero de Serie", "NO se Agreg&oacute; el N&uacute;mero de Serie");
					}
				}
			});
			
		}
	}
	, Eliminar: function( prmIntTA_ID, prmIntTAA_ID, prmIntTAS_ID, prmIntPRO_ID){
		
		$.ajax({
			url: strRutaBaseTA + "TA_Ajax.asp"
			, method: "post"
			, async: false
			, dataType: "json"
			, data: {
				Tarea: 10
				, TA_ID: prmIntTA_ID
				, TAA_ID: prmIntTAA_ID
				, TAS_ID: prmIntTAS_ID
			}
			, success: function( res ){
				if( parseInt(res.Error) == 0){
					
					Avisa("succes", "N&uacute;mero de Serie", "Se Elimin&oacute; el N&uacute;mero de Serie");
					
					Serie.Cargar( prmIntTA_ID, prmIntTAA_ID, prmIntPRO_ID, 1);
					Articulo.Cargar( 1 );
					
				} else {
					
					Avisa("warning", "N&uacute;mero de Serie", "NO se Elimin&oacute; el N&uacute;mero de Serie");
				}
			}
		});	
	}
}
/* HA ID: 2 FIN
*/