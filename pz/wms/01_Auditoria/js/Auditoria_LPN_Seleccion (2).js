var AuditoriaLPNSeleccion = {
    Abrir: function(){
		
		var jsonPrm = ( !(arguments[0] == undefined) ) ? arguments[0] : {};
		var intAud_ID = ( !(jsonPrm.Aud_ID == undefined) ) ? jsonPrm.Aud_ID : -1;
		var intVisita = ( !(jsonPrm.Visita == undefined) ) ? jsonPrm.Visita : -1;

        if( $("#mdlAudLPNSel").length == 0 ){

            $.ajax({
                  url: "/pz/wms/Auditoria/Auditoria_LPN_Seleccion_Modal.asp"
                , method: "post"
                , async: true
                , success: function( res ){
                    $("#wrapper").append( res );
                    
                    AuditoriaLPNSeleccion.LimpiarFormulario();
					
					$("#hidMdlAudLPNSelAud_ID").val(intAud_ID);
					$("#hidMdlAudLPNSelVisita").val(intVisita);
					$("#mdlAudLPNSel").modal('show');
					
                    AuditoriaLPNSeleccion.Listar();
                    
                }
            });

        } else {
			           
            AuditoriaLPNSeleccion.LimpiarFormulario();
			
			$("#hidMdlAudLPNSelAud_ID").val(intAud_ID);
			$("#hidMdlAudLPNSelVisita").val(intVisita);
			$("#mdlAudLPNSel").modal('show');
			
            AuditoriaLPNSeleccion.Listar();

        }
    }
    , Cerrar: function(){
        $("#mdlAudLPNSel").modal('hide');
		this.LimpiarFormulario();
		
    }
    , LimpiarFormulario: function(){
		$("#hidMdlAudLPNSelAud_ID").val("");
		$("#hidMdlAudLPNSelVisita").val("");
		
        $("#divMdlAudLPNSelListado").html("");
    }
    , Listar: function(){

        var intAud_ID = $("#hidMdlAudLPNSelAud_ID").val();
		var intVisita =	$("#hidMdlAudLPNSelVisita").val();

        Cargando.Iniciar();

        $.ajax({
              url: "/pz/wms/Auditoria/Auditoria_LPN_Seleccion_Listado.asp"
            , method: "post"
            , async: true
            , data: {
                  Aud_ID: intAud_ID
				, Visita: intVisita
            }
            , success: function( res ){
                
                $("#divMdlAudLPNSelListado").html(res);
                Cargando.Finalizar();
                            
            }
			, error: function(){
				Avisa("error", "Auditoria Objetivos", "No se puede extraer la informacion de los objetivos");
				Cargando.Finalizar();
			}
        });

    }
}