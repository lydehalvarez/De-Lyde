var Serie = {
    url: {
        Listado: "/pz/wms/Incidencias/Incidencias_Formulario_Entrega_Serie_Listado.asp"
        , Ajax: "/pz/wms/Incidencias/Incidencias_Formulario_Entrega_Serie_Listado_Ajax.asp"
    }
    , Tipo: -1
    , Ent_ID: -1
    , Ent_Pro_ID: -1
    , Ins_ID: -1
    , CambiarSerie: 0
    , Listado: { 
        Cargar: function( jsonPrm ){

            Serie.Tipo = ( jsonPrm.Tipo != undefined ) ? jsonPrm.Tipo : -1;
            Serie.Ent_ID = ( jsonPrm.Ent_ID != undefined ) ? jsonPrm.Ent_ID : -1;
            Serie.Ent_Pro_ID = ( jsonPrm.Ent_Pro_ID != undefined ) ? jsonPrm.Ent_Pro_ID : -1;
            Serie.CambiarSerie = ( jsonPrm.CambiarSerie != undefined ) ? jsonPrm.CambiarSerie : 0;
            Serie.Ins_ID = ( jsonPrm.Ins_ID != undefined ) ? jsonPrm.Ins_ID : 0;

            var bolError = false
            var arrError = [];

            if( !(parseInt(Serie.Tipo) > -1) && !(parseInt(Serie.Ent_ID) > -1) && !(parseInt(Serie.Ent_Pro_ID) > -1) ){
                bolError = true;
                arrError.push("- Identificadores no permitidos");
            }

            if( bolError ){
                Avisa("warning", "Serie - Listado - Cargar", "Verificar Formulario<br>" + arrError.join("<br>"));
            } else {

                var intEnt_Pro_ID = Serie.Ent_Pro_ID;

                $.ajax({
                      url: Serie.url.Listado 
                    , method: "post"
                    , async: true
                    , data: {
                        Tipo: Serie.Tipo
                        , Ent_ID: Serie.Ent_ID
                        , Ent_Pro_ID: Serie.Ent_Pro_ID
                        , CambiarSerie: Serie.CambiarSerie
                        , Ins_ID: Serie.Ins_ID
                    }
                    , beforeSend: function(){
                        Cargando.Iniciar();
                    }
                    , success: function( res ){

                        var intColspan = $("#trInsEntPro_" + intEnt_Pro_ID).find("td").length;

                        var objTr = "<tr id='trInsEntProSer_" + intEnt_Pro_ID + "'>"
                                + "<td colspan='" + intColspan + "'>"
                                    + "" + res + ""
                                + "</td>"
                            + "</tr>";

                        $(objTr).insertAfter("#trInsEntPro_" + intEnt_Pro_ID);

                        $("#btnInsProCargar_" + intEnt_Pro_ID).hide();
                        $("#btnInsProRemover_" + intEnt_Pro_ID).show();
                    }
                    , error: function(){
                        Avisa("Error", "Serie - Listado - Cargar", "Error en la peticion");
                    }
                    , complete: function(){
                        Cargando.Finalizar();
                    }
                })
            }

        }
        , Remover: function( jsonPrm ){

            var intEnt_Pro_ID = jsonPrm.Ent_Pro_ID;

            $("#trInsEntProSer_" + intEnt_Pro_ID).remove();

            $("#btnInsProCargar_" + intEnt_Pro_ID).show();
            $("#btnInsProRemover_" + intEnt_Pro_ID).hide(); 
            
            Cargando.Finalizar();
        }
        , Registro: {
            
            SeleccionValidar: function( prmJson ){
                var bolError = false;
                var arrError = [];

                var objError = "";

                var objBase = prmJson.Objeto;
                var objPadre = $(objBase).parent().parent();
                var bolEsSeleccionado = $(".cssChkInsEntSerInv_ID", objPadre).is(":checked");
                var strSerieCambio = $(".cssInpInsEntSerCambiarSerie", objPadre).val();

                if( Serie.CambiarSerie == 1){
                    if( bolEsSeleccionado){
                        if( strSerieCambio.trim() == ""){
                            bolError = true;
                            arrError.push("Agregar el numero de serie a Cambiar");
                        }
                    } 
                }

                if( bolError ){
                    objError = "<i class='fa fa-exclamation-circle fa-2x text-danger cssInsEntError' title='" + arrError.join(",") + "'></i>"
                } else {
                    objError = "";
                }

                $(".cssInsEntSerError", objPadre).html(objError);
            }
        
        }
        , Seleccion: {
            Validar: function(){

                var bolError = false;

                if( $(".cssChkInsEntSerInv_ID:checked").length > 0 ){

                    if( $(".cssInsEntError").length > 0 ){
                        bolError = true;
                    }

                } else {
                    bolError = true;
                }
                
                return !(bolError);
            }
            , Guardar: function( prmJson, prmCallFuncion){
                /* Extraer las series seleccionadas */

                var intTA_ID = prmJson.TA_ID;
                var intIns_ID = prmJson.Ins_ID;
                var intIDUsuario = prmJson.IDUsuario;

                var arrRegSerSel = this.Extraer();	//Retorna arreglo de json de cada registro seleccionado

                var arrRegSelSer = [];
                var strRegSelSer = "";

                for( var i=0; i<arrRegSerSel.length; i++){
                    var strRegSel = arrRegSerSel[i].Inv_ID + "|" + arrRegSerSel[i].Inv_Serie_Cambio
                    arrRegSelSer.push(strRegSel);
                }

                strRegSelSer = arrRegSelSer.join("|,|");

                $.ajax({
                    url: Serie.url.Ajax
                    , method: "post"
                    , async: true
                    , dataType: "json"
                    , data: {
                        Tarea: 5000
                        , Ins_ID: intIns_ID
                        , TA_ID: intTA_ID
                        , Series: strRegSelSer
                        , IDUsuario: intIDUsuario
                    }
                    , beforeSend: function(){
                        Cargando.Iniciar();
                    }
                    , success: function( res ){
                        if( res.Error.Numero == 0){
                            Avisa("success", "Incidencia - Series - Guardar", res.Error.Descripcion);

                            prmCallFuncion();
                        } else {
                            Avisa("warning", "Incidencia - Series - Guardar", res.Error.Descripcion);
                        }
                    }
                    , error: function(){
                        Avisa("error", "Incidencia - Series - Guardar", "Errorn en la peticion");
                    }
                    , complete: function(){
                        Cargando.Finalizar();
                    }
                });
            }
            , Extraer: function(){
                var arrReg = [];
                var bolCambiarSerie = ( Serie.CambiarSerie == 1 );

                $(".cssTrInsEntInv_ID").each(function(){

                    var bolEsSeleccionado = $(".cssChkInsEntSerInv_ID", $(this)).is(":checked");

                    if( bolEsSeleccionado ){
                        var intInv_ID = $(this).data("inv_id");

                        var strInv_Serie_Cambio = ( bolCambiarSerie ) ? $(".cssInpInsEntSerCambiarSerie", $(this)).val() : "";

                        var jsonReg = {
                            Inv_ID: intInv_ID
                            , Inv_Serie_Cambio: strInv_Serie_Cambio
                        }

                        arrReg.push(jsonReg);
                    }
                    
                })

                return arrReg;
            }
        }
    }
}