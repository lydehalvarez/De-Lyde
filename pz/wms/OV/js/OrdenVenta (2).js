var OrdenVenta = {
	
	Editar: function (){
		
		$("#Calle").val( $("#OVCalle").text() );
		$("#NumeroExterior").val( $("#OVNumeroExterior").text() );
		$("#NumeroInterior").val( $("#OVNumeroInterior").text() );
		$("#Colonia").val( $("#OVColonia").text() );
		$("#Delegacion").val( $("#OVDelegacion").text() );
		$("#Ciudad").val( $("#OVCiudad").text() );
		$("#Estado").val( $("#OVEstado").text() );
		$("#CodigoPostal").val( $("#OVCodigoPostal").text() );
		$("#Telefono").val( $("#OVTelefono").text() );
		$("#Email").val( $("#OVEmail").text() );
		
		$("#RefDomicilio1").val( $("#OVRefDomicilio1").text() );
		$("#RefDomicilio2").val( $("#OVRefDomicilio2").text() );
		$("#RefPersona").val( $("#OVRefPersona").text() );
		$("#RefTelefono").val( $("#OVRefTelefono").text() );
		
		$("#RefComentarios").val( $("#OVRefComentarios").text() );
	}
	, Actualizar: function(){
		
		var bolSeAbrePorModal = parseInt($("#SeAbrePorModal").val());
		var OV_ID = $("#OV_ID").val();
		
		$.ajax({
			  url: urlBase + "OV_Ajax2.asp"
			, method: "post"
			, async: true
			, data: {
				  Tarea: 1 //Actualizacion de Datos
				, OV_ID: OV_ID
				, Calle: encodeURIComponent($("#Calle").val())
				, NumeroExterior: encodeURIComponent($("#NumeroExterior").val())
				, NumeroInterior: encodeURIComponent($("#NumeroInterior").val())
				, Colonia: encodeURIComponent($("#Colonia").val())
				, Delegacion: encodeURIComponent($("#Delegacion").val())
				, Ciudad: encodeURIComponent($("#Ciudad").val())
				, Estado: encodeURIComponent($("#Estado").val())
				, CodigoPostal: encodeURIComponent($("#CodigoPostal").val())
				, Telefono: encodeURIComponent($("#Telefono").val())
				, Email: encodeURIComponent($("#Email").val())
				
				, RefDomicilio1: encodeURIComponent($("#RefDomicilio1").val())
				, RefDomicilio2: encodeURIComponent($("#RefDomicilio2").val())
				, RefPersona: encodeURIComponent($("#RefPersona").val())
				, RefTelefono: encodeURIComponent($("#RefTelefono").val())
				
				, RefComentarios: encodeURIComponent($("#RefComentarios").val())
				
				, IDUsuario:  $("#IDUsuario").val() //HA ID: 5 Se agrega
				
			}
			, success: function(res){
				
				if( parseInt(res) == 0 ){
					
					Avisa("success", "Datos Generales de Orden de Venta", "Se actualizaron los datos de Orden de Venta");
					
					if( bolSeAbrePorModal == 0 ){
						$('#modalActualiza').modal('hide');
						setTimeout( function(){ RecargaEnSiMismo(); }, 1000);
						
					} else {
						
						$.post("/pz/wms/OV/OV_Ficha.asp"
							, {OV_ID:OV_ID}
							, function(data){
								$("#modalBodySO").html(data);
								$("#SeAbrePorModal").val(1);
								$("#CheckBoxOV_"+OV_ID).iCheck('uncheck');
							}
						);
					}
					
								
				} else {
				
					Avisa("error", "Datos Generales de Orden de Venta", "No se actualizaron los datos de la Orden de Venta");
					
				}
				
			}
			, error: function(){
				
				Avisa("error", "Datos Generales", "No se actualizaron los datos de la Orden de Venta");
				
			}
			
		});
		
	}
	, Cancelar: function(){
	
		if( $("#MotivoCancelacion").val() == "" ){
			Avisa("warning", "Cancelaci&oacute;n de Orden de Venta", "Agregar motivo de Cancelaci&oacuten; la Orden Venta");
			return;
		}
	
		$.ajax({
			  url: urlBase + "OV_Ajax2.asp"
			, method: "post"
			, async: true
			, data: {
				  Tarea: 2 //Cancelacion de Datos
				, OV_ID: $("#OV_ID").val()
				, IDUsuario:  $("#IDUsuario").val() //HA ID: 5 Se agrega
				, MotivoCancelacion: $("#MotivoCancelacion").val()
				, IzziCancela: ( $("#IzziCancela").is(":checked") ) ? 1: 0
			}
			, success: function(res){
			
				if( parseInt(res) == 0 ){
					
					$('#modalCancelacion').modal('hide'); 
					
					Avisa("success", "Cancelaci&oacute;n de Orden de Venta", "Se cancel&oacute; la Orden Venta");
					
					setTimeout( function(){ RecargaEnSiMismo(); }, 1000);
					
				} else {
				
					Avisa("error", "Cancelaci&oacute;n de Orden de Venta", "No se cancel&oacute; la Orden de Venta");
					
				}
				
			}
			, error: function(){
				
				Avisa("error", "Cancelaci&oacute;n de Orden de Venta", "No se cancel&oacute; la Orden de Venta");
				
			}
		});
	}
	, EnviarFallido: function(){
		
		var bolErr = false
		var arrErr = []
		
		var intMotFal = $("#MotivoFallido").val();
		
		if( parseInt(intMotFal) == 0 ){
			bolErr = true
			arrErr.push( "- Seleccionar el motivo de Envio a Fallido" );
		}
		
		if( bolErr ){
			
			Avisa("warning", "Envio de Fallo", "Verificar Formulario: <br>" + arrErr.join("<br>"));
			
		} else {
			
			var bolRes = false;
			
			$.ajax({
				url: urlBase + "OV_Ajax2.asp"
				, method: "post"
				, async: true
				, data: {
					  Tarea: 7 //Cancelacion de Datos
					, OV_ID: $("#OV_ID").val()
					, IDUsuario:  $("#IDUsuario").val() //HA ID: 5 Se agrega
					, MotivoFallido: intMotFal
				}
				, success: function(res){
					if(res == "0"){
						API.CambiaEstatus($("#OV_ID").val(),9)
					}else{
						swal("Ups!", "Ocurri&oacute; un error al colocar los datos, intente de nuevo.", "error");
					}
				}
			});
			
			return bolRes;
			
		}
		
	}

}

var OrdenVentaComentario = {
	Cargar: function(){
		var intOV_Id = $("#OV_ID").val();
		
		$.ajax({
			  url: urlBase + "OV_Ajax2.asp"
			, method: "post"
			, async: true
			, data: {
				  Tarea: 5 //Comentarios
				, OV_ID: intOV_Id
			}
			, success: function(res){
				$("#divOrdenVentaComentarios").html(res);
			}
		})
	}
	, VisualizarModal: function( prmIntComnId ){
		OrdenVentaComentario.LimpiarModal();
		
		$("#comNodo").val(prmIntComnId);
	}
	, Agregar: function(){
		
		var intIdUsuario = $("#IDUsuario").val();
		var intOV_ID = $("#OV_ID").val();
		var intComn_ID = $("#comNodo").val();
		var strTitulo = $("#comTitulo").val();
		var strComentario = $("#comComentario").val();
		
		var arrRes = [];
		var bolError = false;
		
		if( strTitulo == '' ){
			arrRes.push("Agregar el Titulo");
			bolError = true;
		}

		if( strComentario == '' ){
			arrRes.push("Agregar el Comentario");
			bolError = true;
		}
		
		if( bolError ){
			
			Avisa("warning", "Comentario", "Validar Formulario: <br>" + arrRes.join("<br>") );
			
		} else {
		
			$.ajax({
				  url: urlBase + "OV_Ajax2.asp"
				, method: "post"
				, async: true
				, dataType: "json"
				, data: {
					  Tarea: 6 //Bitcora
					, IdUsuario: intIdUsuario
					, OV_ID: intOV_ID
					, Comn_ID: intComn_ID
					, Titulo: strTitulo
					, Comentario: strComentario
				}
				, success: function(res){
					if( parseInt(res.Error) == 0 ){
						
						Avisa("success", "Comentario", "Se agregó el comentario a la Orden de Venta");
						
						OrdenVentaComentario.Cargar();
						OrdenVentaComentario.CerrarModal();
						
					} else {
						Avisa("warning", "Comentario", "NO se agregó el comentario a la Orden de Venta");
					}
				}
			})
		}
	}
	, LimpiarModal: function(){
		$("#comNodo").val("");
		$("#comTitulo").val("");
		$("#comComentario").val("");
	}
	, CerrarModal: function(){
		OrdenVentaComentario.LimpiarModal();
		
		var bolSeAbrePorModal = parseInt($("#SeAbrePorModal").val());
		var OV_ID = $("#OV_ID").val();
		
		if( bolSeAbrePorModal == 0 ){
			$("#modalComentario").modal("hide");
		} else {
			
			$.post("/pz/wms/OV/OV_Ficha.asp"
				, {OV_ID:OV_ID}
				, function(data){
					$("#modalBodySO").html(data);
					$("#SeAbrePorModal").val(1);
				}
			);
			
		}
	}
}

var OrdenCompraBitacora = {
	Cargar: function(){
		var intOV_Id = $("#OV_ID").val();
		
		$.ajax({
			  url: urlBase + "OV_Ajax2.asp"
			, method: "post"
			, async: true
			, data: {
				  Tarea: 3 //Bitcora
				, OV_ID: intOV_Id
			}
			, success: function(res){
				$("#divOrdenVentaBitacora").html(res);
			}
		})
	}
}

var OrdenCompraRastreo = {
	Cargar: function(){
		var intOV_Id = $("#OV_ID").val();
		
		$.ajax({
			  url: urlBase + "OV_Ajax2.asp"
			, method: "post"
			, async: true
			, data: {
				  Tarea: 4 //Rastreo
				, OV_ID: intOV_Id
			}
			, success: function(res){
				$("#divOrdenVentaRastreo").html(res);
			}
		})
	}
}

var API = {
	CambiaEstatus:function(OV_ID,Estatus){
		var data = {
			"Tarea":3,
			"OV_ID":OV_ID,
			"Estatus":Estatus,
			"Guia":"",
			"Transportista":""
		}
		var myJSON = JSON.stringify(data);
		$.ajax({
			type: 'post',
			contentType:'application/json',
			data: myJSON,
			url: "http://198.38.94.4:1117/lyde/api/ServiceZZ",
			success: function(datos){
				console.log(datos) 
				swal("Cancelado", "Se realizo la actualización.", "success");
				$('#modalFallido').modal('hide');
				setTimeout( function(){ RecargaEnSiMismo(); }, 1800);
			}
		});
		
	}

}
		