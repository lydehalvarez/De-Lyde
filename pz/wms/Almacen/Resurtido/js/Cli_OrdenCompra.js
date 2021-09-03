var OrdenCompraArticulos = {
	Cargar: function(){
		
		var intCli_ID = $("#Cli_ID").val();
		var intCliOC_ID = $("#CliOC_ID").val();
		
		$.ajax({
			url: urlBase + "Cli_OrdenCompra_ajax.asp"
			, method: "post"
			, async: false
			, data: {
				Tarea: 1
				, Cli_ID: intCli_ID
				, CliOC_ID: intCliOC_ID
			}
			, success: function( res ){
				$("#divOCArt").html(res);
			}
		});
	}
}

var OrdenVentaArticuloCarga = {
	VisualizarModalNuevo: function( prmIntCliOCP_ID ){
		
		if( $("#ModalAgregarCarga").length == 0 ){
		
			$.ajax({
				url: urlBase + "Cli_OrdenCompra_ajax.asp"
				, method: "post"
				, async: false
				, data: {
					Tarea: 100
				}
				, success: function( res ){
					$("body").append(res);
					
				}
			});
		}
		
		OrdenVentaArticuloCarga.LimpiarModalNuevo();
		OrdenVentaArticuloCarga.CargarModalNuevo(prmIntCliOCP_ID);
				
		$("#ModalAgregarCarga").modal("show");
		
	}
	, LimpiarModalNuevo: function(){
		$("#inpModalCliOCP_ID").val("");
		$("#inpModalCliOCP_ID").data("proid", "");
			
		$("#spanModalAgregarCarga").text("");
		$("#inpModalCliOCP_Pendiente").text("");
		$("#inpModalCliOCP_PorCargar").text("");
		$("#inpModalCliOCP_RestantePorCargar").text("");
	}
	, CargarModalNuevo: function( prmIntCliOCP_ID ) {
		
		var objCliOCP = $("#CliOCP_ID_" + prmIntCliOCP_ID);
		var intProId = objCliOCP.data("proid");
		var strNombre = objCliOCP.data("nombre");
		var intPendiente = objCliOCP.data("pendiente");

		$("#spanModalAgregarCarga").text(strNombre);		
		$("#inpModalCliOCP_ID").val(prmIntCliOCP_ID);
		$("#inpModalCliOCP_ID").data("proid", intProId);
		$("#inpModalCliOCP_Pendiente").text(intPendiente);
		$("#inpModalCliOCP_PorCargar").text(0);
		$("#inpModalCliOCP_RestantePorCargar").text(intPendiente);
		
		OrdenVentaArticuloCarga.CargarModalLotes();

	}
	, CargarModalLotes: function(){
		
		var intProId = $("#inpModalCliOCP_ID").data("proid");
		
		$.ajax({
			url: urlBase + "Cli_OrdenCompra_ajax.asp"
			, method: "post"
			, async: false
			, data: {
				Tarea: 300
				, Pro_ID: intProId
			}
			, success: function( res ){
				$("#tableModalLotes").html(res);
				
			}
		});
	}
	, CerrarModalNuevo: function(){
		$("#ModalAgregarCarga").modal("hide");
		
		OrdenVentaArticuloCarga.LimpiarModalNuevo();
	}
	, CalcularTotalCargaLote: function(prmObj){
		
		var objPadre = $(prmObj).parents("tr");
		var strExRg = /^[1-9]+[0-9]*$/g;
	
		var intCantidad = parseInt($(".inpLoteCantidad", objPadre).val());
		var intDisponible = parseInt($(".hidLoteId", objPadre).data("disponible"));
		var intPendiente = parseInt($("#inpModalCliOCP_Pendiente").text());
		var bolEsCheck = $(".chbLoteSeleccion", objPadre).is(":checked");
		
		var bolErr = false;
		var arrErr = [];
		
		var intSubTotal = OrdenVentaArticuloCarga.CalcularTotalCarga();
		
		if( bolEsCheck ){
			
			if( !(strExRg.test(intCantidad)) ){
				bolErr = true;
				arrErr.push("- Introducir numeros positivos");
			} else if( parseInt(intCantidad) > parseInt(intDisponible) ){
				bolErr = true;
				arrErr.push("- La cantidad a surtir de este lote se excede del disponible");
			}
		
			if( intSubTotal > intPendiente ){
				bolErr = true;
				arrErr.push("- Ha excedido la cantidad solicitada pendiente ");
			}
			
		}
		
		if( bolErr ){
			Avisa("warning", "Completar el formulario", arrErr.join("<br>"));
			$(".iLoteAlerta", objPadre).show();
		} else {
			$(".iLoteAlerta", objPadre).hide();
		}
		
		OrdenVentaArticuloCarga.ImprimirTotalCarga();
	}
	, ImprimirTotalCarga: function(){
		
		var intTotalPendiente = $("#inpModalCliOCP_Pendiente").text();
		var intTotalPorCargar = OrdenVentaArticuloCarga.CalcularTotalCarga();
		var intTolalRestPorCargar = 0;
		
		intTolalRestPorCargar = intTotalPendiente - intTotalPorCargar;
		
		$("#inpModalCliOCP_PorCargar").text(intTotalPorCargar);
		$("#inpModalCliOCP_RestantePorCargar").text(intTolalRestPorCargar);

	}
	, CalcularTotalCarga: function(){
		
		var intTotalPorCargar = 0;
		
		$(".trLoteLote").each(function(){
			if( $(".chbLoteSeleccion", $(this)).is(":checked") ){
				if( $(".inpLoteCantidad", $(this)).val() != "" ){
					intTotalPorCargar += parseInt( $(".inpLoteCantidad", $(this)).val() );
				} 
			}
		});
		
		return intTotalPorCargar;
	}
	, Guardar: function(){
		
	}
}