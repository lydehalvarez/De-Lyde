var AuditoriaSeleccionLPN = {
      url: "/pz/wms/Auditoria/"
    , Buscador: {
        Filtros: {
            TipoBusqueda: -1
            , Texto: ""
        }
        , TipoBusqueda: {
              SKU: 1
            , Ubicacion: 2
            , LPN: 3
        }
        , Escanear: function( event, prmObjeto ){

            var intChr = event.which;
            var strObj = $(prmObjeto).val();
            var regExp = /[\']/g;

            if(intChr == 13){
                
                var strRemObj = strObj.replace(regExp, "-");
                $(prmObjeto).val( strRemObj );

                AuditoriaSeleccionLPN.Buscar.Filtrar();

            }

        }
        , Filtrar: function(){
            var bolError = false;
            var arrError = [];

            var intTipBus = $("input[name=radMdlAudSelLpnTipBus]:checked").val();
            var strTexto = $("#inpMdlAudSelLpnTex").val();

            if( !(intTipBus > 0) ){
                bolError = true;
                arrError.push("- Seleccionar el tipo de busqueda");
            }
            
            if( strTexto.trim() == ""){
                bolError = true;
                arrError.push("- Agregar texto a buscar");
            }

            if( bolError ){
                Avisa("warning", "Objetivos - Buscar", "Verificar Filtros<br>" + arrError.join("<br>"));
            } else {

                AuditoriaSeleccionLPN.Buscador.Filtros.TipoBusqueda = intTipBus;
                AuditoriaSeleccionLPN.Buscador.Filtros.Texto = strTexto;

                AuditoriaSeleccionLPN.ListadoObjetivosBuscados.Cargar({
                    Filtros: AuditoriaSeleccionLPN.Buscador.Filtros
                    , Inicia: true
                });
            }
                
        }
        , FiltrosLimpiar: function(){
            AuditoriaSeleccionLPN.Buscador.Filtros.TipoBusqueda = -1;
            AuditoriaSeleccionLPN.Buscador.Filtros.Texto = "";

            $("input[name=radMdlAudSelLpnTipBus]").prop("checked", false);
            $("#inpMdlAudSelLpnTex").val("");
        }
    }
    , ListadoObjetivosBuscados: {
        Cargar: function( jsonPrm ){

            var bolInicia = jsonPrm.Inicia;
            var jsonFiltros = jsonPrm.Filtros;

            var intAud_ID = $("#Aud_ID").val();

            $.ajax({
                url: AuditoriaSeleccionLPN.url + "Auditoria_Seleccion_LPN_Listado.asp"
                , method: "post"
                , asyc: true
                , data: {
                      Aud_ID: intAud_ID
                    , TipoBusqueda: jsonFiltros.TipoBusqueda
                    , Texto: jsonFiltros.Texto
                }
                , beforeSend: function(){
                    Cargando.Iniciar();
                }
                , success: function( res ){
                    $("#ulMdlAudSelLpnLisBus").html( res );

                    AuditoriaSeleccionLPN.ListadoObjetivosBuscados.RegistrosContar();
                }
                , error: function(){
                    Avisa("warning", "Objetivos - Buscar", "Error de Peticion");
                }
                , complete: function(){
                    Cargando.Finalizar();
                }
            })

        }
        , RegistrosContar: function(){
            var intReg = $(".cssMdlAudSelLpnLisBusReg").length;

            $("#lblMdlAudSelLpnLisBusTotReg").text( intReg );
        }
        , Agregar: function( prmJson ){
			
			
            var objObjeto = {
				input:prmJson.Objeto,
				Pt_ID:prmJson.Pt_ID
			};

            var objBase = $(objObjeto.input).parents("li");
			
            AuditoriaSeleccionLPN.ListadoObjetivosSeleccionados.Cargar({Objeto: objBase,Pt_ID:objObjeto.Pt_ID,input:objObjeto.input})

        }
        , SeleccionAgregar: function(){

            var bolError = false;
            var arrError = [];

            var arrCheck = $("input[type=checkbox]:checked", ".cssMdlAudSelLpnLisBusReg");
            
            if( arrCheck.length == 0 ){
                bolError = true;
                arrError.push("- Seleccionar al menos un LPN para agregar");
            }
            
            if( bolError ){
                Avisa("warning", "Ojetivos - Seleccion", "Verificar formulario<br>" + arrError.join("<br>"));
            } else {

                $(arrCheck).each(function(){
                    AuditoriaSeleccionLPN.ListadoObjetivosBuscados.Agregar({Objeto: $(this),Pt_ID:$(this).val()});
					$(this).prop( "checked", false );
                });
				$("#chbMdlAudSelLpnLisBusTodos").prop( "checked", false );

            }
        }
        , Seleccionar: function(){

            var bolTotCheck = ( $("input[type=checkbox]", ".cssMdlAudSelLpnLisBusReg").length == $("input[type=checkbox]:checked", ".cssMdlAudSelLpnLisBusReg").length );

            $("#chbMdlAudSelLpnLisBusTodos").prop("checked", bolTotCheck)
        }
        , TodosSeleccionar: function(){
            var bolTotCheck = $("#chbMdlAudSelLpnLisBusTodos").is(":checked");

            $("input[type=checkbox]", ".cssMdlAudSelLpnLisBusReg").prop("checked", bolTotCheck)
        }

    }
    , ListadoObjetivosSeleccionados: {
        Cargar: function( prmJson ){

            var objObjeto = prmJson.Objeto;

            var bolExiste = false;

            var intPT_ID = $(objObjeto).find("input[type=checkbox]").val();
            var strLPN = $(objObjeto).find(".cssMdlAudSelLpnLisLpn").text();
            var strPro = $(objObjeto).find(".cssMdlAudSelLpnLisPro").text();
            var strUbi = $(objObjeto).find(".cssMdlAudSelLpnLisUbi").text();

            $(".cssMdlAudSelLpnLisSelReg").find("input[type=checkbox]").each(function(){
                if( $(this).val() == intPT_ID ){
                    bolExiste = true;
                }
            });

            if( bolExiste ){
                Avisa("warning", "Objetivos - Seleccionar", "El LPN: " + strLPN + " ya existe");
            } else {

                var objBase = "<li class='info-element cssMdlAudSelLpnLisSelReg'> "
                    + "<div class='pull-right'> "
                        + "<a class='btn btn-xs btn-danger cssbtnAccion' onclick='AuditoriaSeleccionLPN.ListadoObjetivosSeleccionados.Eliminar({Objeto: this,Pt_ID:"+prmJson.Pt_ID+"});'> "
                            + "<i class='fa fa-times'></i> Eliminar "
                        + "</a> "
                    + "</div> "
                    + "<h3> "
                        + "<input type='checkbox' value='" + intPT_ID + "' onclick='AuditoriaSeleccionLPN.ListadoObjetivosSeleccionados.Seleccionar();'>&nbsp; "
                        + "<span class='cssMdlAudSelLpnLisLpn'> "
                            + strLPN
                        + "</span> "
                    + "</h3> "
                    + "<div class='row'>  "
                        + "<div class='col-sm-12'> "
                            + "<i class='fa fa-tag'></i> <span class='cssMdlAudSelLpnLisPro'> " + strPro + "</span> "
                        +"</div> "
                    + "</div> "
                    + "<div class='agile-detail'>  "
                        + "<i class='fa fa-map-signs'></i> <span class='cssMdlAudSelLpnLisUbi'>" + strUbi + "</span> "
                    + "</div> "
                + "</li>"           

                $("#ulMdlAudSelLpnLisSel").prepend(objBase);

                AuditoriaSeleccionLPN.ListadoObjetivosSeleccionados.RegistrosContar();
				
				var total = parseInt($("#lblMdlAudSelLpnLisBusTotReg").text())
				$("#lblMdlAudSelLpnLisBusTotReg").html(total-1)
				
				$("#toAdd"+prmJson.Pt_ID).hide('slow')
            }     

        }
        , Eliminar: function( prmJson ){
            var objObjeto = prmJson.Objeto;
            var objBase = $(objObjeto).parents("li");

            $(objBase).remove();
            $("#chbMdlAudSelLpnLisSelTodos").prop("checked", false);
			$("#toAdd"+prmJson.Pt_ID).show('slow');
            AuditoriaSeleccionLPN.ListadoObjetivosSeleccionados.RegistrosContar();
			var total = parseInt($("#lblMdlAudSelLpnLisBusTotReg").text())
			$("#lblMdlAudSelLpnLisBusTotReg").html(total+1)

        }
        , SeleccionEliminar: function(){

            var bolError = false;
            var arrError = [];

            var arrCheck = $("input[type=checkbox]:checked", ".cssMdlAudSelLpnLisSelReg");
            
            if( arrCheck.length == 0 ){
                bolError = true;
                
                arrError.push("- Seleccionar al menos un LPN para eliminar");
            }
            
            if( bolError ){
                Avisa("warning", "Ojetivos - Seleccion", "Verificar formulario<br>" + arrError.join("<br>"));
            } else {

                $(arrCheck).each(function(){
                    AuditoriaSeleccionLPN.ListadoObjetivosSeleccionados.Eliminar({Objeto: this,Pt_ID:$(this).val()});
                });
				$("#chbMdlAudSelLpnLisSelTodos").prop( "checked", false );
            }

        }
        , RegistrosContar: function(){
            var intReg = $(".cssMdlAudSelLpnLisSelReg").length;

            $("#lblMdlAudSelLpnLisSelTotReg").text( intReg );
        }
        , Seleccionar: function(){

            var bolTotCheck = ( $("input[type=checkbox]", ".cssMdlAudSelLpnLisSelReg").length == $("input[type=checkbox]:checked", ".cssMdlAudSelLpnLisSelReg").length );

            $("#chbMdlAudSelLpnLisSelTodos").prop("checked", bolTotCheck)
        }
        , TodosSeleccionar: function(){
            var bolTotCheck = $("#chbMdlAudSelLpnLisSelTodos").is(":checked");

            $("input[type=checkbox]", ".cssMdlAudSelLpnLisSelReg").prop("checked", bolTotCheck);
        }
    }
    , Abrir: function(){

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
						$("#Contenido").load("/pz/wms/Auditoria/Auditoria.asp", {Aud_ID: intAud_ID});
						
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

        $("input[type=checkbox]:checked", ".cssMdlAudSelLpnLisSelReg").each(function(){
            arrPT_IDs.push( $(this).val() );
        });

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