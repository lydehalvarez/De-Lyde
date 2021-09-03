var AuditoriaSeleccionLPN = {
    Abrir: function(){

        var intAud_ID = $("#Aud_ID").val();
        
        if( $("#mdlAudSelLPN").length == 0 ){

            $.ajax({
                  url: "/pz/wms/Auditoria/Auditoria_Seleccion_LPN_Modal.asp"
                , method: "post"
                , async: true
                , success: function( res ){
                    $("#wrapper").append( res );

                    AuditoriaSeleccionLPN.LimpiarFormulario();

                    $("#hidMdlAudSelLPNAud_ID").val(intAud_ID);

                    $("#mdlAudSelLPN").modal('show');
                }
                , error: function(){
                    Avisa("error","Auditoria Seleccion LPN", "No se puede cargar la Seleccion de los LPNS para la Auditoria");
                }

            });
            
        } else {

            AuditoriaSeleccionLPN.LimpiarFormulario();

            $("#hidMdlAudSelLPNAud_ID").val(intAud_ID);

            $("#mdlAudSelLPN").modal('show');
        }
    }
    , Cerrar: function(){

        this.LimpiarFormulario();

        $("#mdlAudSelLPN").modal('hide');

    }
	, CerrarVisitaVigente: function(){
		var jsonPrm = ( !(arguments[0] == undefined) ) ? arguments[0] : {};
		var intAud_ID = ( !(jsonPrm.Aud_ID == undefined) ) ? jsonPrm.Aud_ID : -1;
		var intVisita = ( !(jsonPrm.Visita == undefined) ) ? jsonPrm.Visita : -1;
		
		var bolError = false;
		var arrError = [];
		
		if( !(intAud_ID > -1) ){
			bolError = true;
			arrError.push("Identificador de Auditoria no permitido");
		}
		
		if( !(intVisita > 1) ){
			bolError = true;
			arrError.push("Numero de visita no permitido");
		}
		
		if( bolError ) {
			Avisa("warning", "Auditoria Creacion de Papeletas", "Verificar formulario<br>" + arrError.join("<br>"));
		} else {
			
			Cargando.Iniciar();
			
			$.ajax({
				url: "/pz/wms/Auditoria/Auditoria_Seleccion_LPN_ajax.asp"
				, method: "post"
				, async: true
				, dataType: "json"
				, data: {
					  Tarea: 2100
					, Aud_ID: intAud_ID
					, Visita: intVisita
				}
				, success: function( res ){
					
					if( res.Error.Numero == 0 ){
						Avisa("success", "Auditoria Creacion Papeletas", res.Error.Descripcion );
						
						$("#dvAudLateral").load("/pz/wms/Auditoria/Auditoria_Lateral.asp", {Aud_ID: intAud_ID});
					} else {
						Avisa("warning", "Auditoria Creacion Papeletas", res.Error.Descripcion );
					}
					
					Cargando.Finalizar();
				}
				, error: function(){
					Avisa("error", "Auditoria Creacion Papeletas", "No se ejecuto el proceso de cracion de visita");
					Cargando.Finalizar();
				}
			});
		}
	}
    , Congelar: function(){

        var bolError = false;
        var arrError = [];

        var arrPT_IDs = [];

        var intAud_ID = $("#hidMdlAudSelLPNAud_ID").val();

        $(".PT_ID", "#divMdlAudSelLPNListado").each(function(){
            arrPT_IDs.push( $(this).data("pt_id") );
        })

        if( intAud_ID == "" ){
            bolError = true;
            arrError.push("-Identificador de la Auditoria no permitido");
        }

        if( arrPT_IDs.length == 0 ){
            bolError = true;
            arrError.push("Agregar LPNs para Auditar");
        }

        if( bolError ){
            Avisa("warning", "Auditoria Seleccion LPN", "Verificar Formulario<br>" + arrError.join("<br>"));
        } else {

            Cargando.Iniciar();

            var strPT_IDs = arrPT_IDs.join(",");

            $.ajax({
                  url: "/pz/wms/Auditoria/Auditoria_Seleccion_LPN_ajax.asp"
                , method: "post"
                , async: true
                , dataType: "json"
                , data: {
                      Tarea: 2000
                    , PT_IDs: strPT_IDs
					, Aud_ID: intAud_ID
                }
                , success: function( res ){
                    
                    if( res.Error.Numero == 0 ){
                        Avisa("success", "Auditoria Seleccion LPN", res.Error.Descripcion);
						
						AuditoriaSeleccionLPN.Cerrar();
						$("#dvAudLateral").load("/pz/wms/Auditoria/Auditoria_Lateral.asp", {Aud_ID: intAud_ID});
						
                    } else {
                        Avisa("warning", "Auditoria Seleccion LPN", res.Error.Descripcion);
                    }
					
                    Cargando.Finalizar();
                }
                , error: function(){
                    Avisa("success", "Auditoria Seleccion LPN", "No se ejecuto el guardado de Congelar los LPNs");
                    Cargando.Finalizar();
                }
            });

        }

    }
    , LimpiarFormulario: function(){

        $("#hidMdlAudSelLPNAud_ID").val("");
        $("#txtMdlAudSelLPNSKU").val("");
        $("#txtMdlAudSelLPNUbicacion").val("");
        $("#txtMdlAudSelLPNLPN").val("");

        $("#divMdlAudSelLPNListado").html("");

    }
    , Listar: function(){

        var bolError = false;
        var arrError = [];

        var intAud_ID = $("#hidMdlAudSelLPNAud_ID").val();

        var strSKUs = $.trim( $("#txtMdlAudSelLPNSKU").val() );
        var strUbicaciones = $.trim( $("#txtMdlAudSelLPNUbicacion").val() );
        var strLPNs = $.trim( $("#txtMdlAudSelLPNLPN").val() );

        if( strSKUs == "" && strUbicaciones == "" && strLPNs == "" ){
            bolError = true;
            arrError.push("Agregar minimo un filtro de informacion");
        }

        if( bolError ){
            Avisa("warning", "Auditoria Seleccion LPN", "Verificar Formulario<br>" + arrError.join("<br>"));
        } else {

            var arrSKUs = strSKUs.split("\n");
            var arrUbicaciones = strUbicaciones.split("\n");
            var arrLPNs = strLPNs.split("\n");

            Cargando.Iniciar();

            $.ajax({
                url: "/pz/wms/Auditoria/Auditoria_Seleccion_LPN_Listado.asp"
                , method: "post"
                , async: true
                , data: {
                      SKUs: arrSKUs.join(",")
                    , Ubicaciones: arrUbicaciones.join(",")
                    , LPNs: arrLPNs.join(",")
					, Aud_ID: intAud_ID
                }
                , success: function( res ){
                    $("#divMdlAudSelLPNListado").html( res );
                    Cargando.Finalizar();
                }
                , error: function(){
                    Cargando.Finalizar();
                }
            });
        }

    }
    , TodosSeleccionar: function(){

        var bolError = false;
        var arrError = [];

        var intAud_ID = $("#hidMdlAudSelLPNAud_ID").val();

        if( intAud_ID == "" ){
            bolError = true;
            arrError.push("- Identificador de Auditoria no permitido");
        }

        if( bolError ){

            Avisa("warning", "Auditoria - Seleccion Todos SKU", "Verificar Formulario<br>" + arrError.join("<br>"));
            
        } else {

            $.ajax({
                url: "/pz/wms/Auditoria/Auditoria_Seleccion_LPN_ajax.asp"
                , method: "post"
                , async: true
                , dataType: "json"
                , data: {
                    Tarea: 2110
                    , Aud_ID: intAud_ID
                }
                , beforeSend: function(){
                    Cargando.Iniciar();
                }
                , success: function( res ){
                
                    if( res.Error.Numero == 0 ){
                        Avisa("success", "Auditoria Seleccion LPN", res.Error.Descripcion);
                    
                        AuditoriaSeleccionLPN.Cerrar();
                        $("#dvAudLateral").load("/pz/wms/Auditoria/Auditoria_Lateral.asp", {Aud_ID: intAud_ID});
                    
                    } else {
                        Avisa("warning", "Auditoria Seleccion LPN", res.Error.Descripcion);
                    }              
                }
                , error: function(){
                    Avisa("success", "Auditoria Seleccion LPN", "No se ejecuto el guardado de Congelar los LPNs");
                }
                , complete: function(){
                    Cargando.Finalizar();
                }
            });
        }
    }
}