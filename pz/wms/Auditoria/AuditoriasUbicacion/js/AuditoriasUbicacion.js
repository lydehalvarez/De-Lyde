var AuditoriasUbicacion = {
      url: "/pz/wms/Auditoria/AuditoriasUbicacion/"
    , TipoConteo: {
          Vista: 1 
        , MB: 2
        , Serie: 3
    }
    , Iniciar: function(){
        
        var prmJson = ( !(arguments[0] == undefined) ) ? arguments[0] : {};
        var intAud_ID = ( !(prmJson.Aud_ID == undefined) ) ? prmJson.Aud_ID : -1;
        var intPT_ID = ( !(prmJson.PT_ID == undefined) ) ? prmJson.PT_ID : -1;
        var intAudU_ID = ( !(prmJson.AudU_ID == undefined) ) ? prmJson.AudU_ID : -1;

        var bolError = false;
        var arrError = [];

        if( !(intAud_ID > -1) && !(intPT_ID > -1) && !(intAudU_ID > -1) ){
            bolError = true;
            arrError.push("Identificadores no permitidos");
        }

        if( bolError ){
            Avisa("warning", "Auditoria Ubicacion", arrError.join("<br>"));
        } else {

            Cargando.Iniciar();

            $.ajax({
                url: AuditoriasUbicacion.url + "AuditoriasUbicacion_ajax.asp"
                , method: "post"
                , async: true
                , dataType: "json"
                , data: {
                    Tarea: 3000
                    , Aud_ID: intAud_ID
                    , PT_ID: intPT_ID
                    , AudU_ID: intAudU_ID
                    , AudU_EnProceso: 1
                }
                , success: function( res ){
                    if( res.Error.Numero == 0 ){
                        
                        $("#Contenido").load( 
                            AuditoriasUbicacion.url + "AuditoriasUbicacion_AuditarEdicion.asp"
                            , {Aud_ID: intAud_ID, PT_ID: intPT_ID, AudU_ID: intAudU_ID}
                        )

                    } else {
                        Avisa("warning", "Auditoria Ubicacion", res.Error.Descripcion);
                    }

                    Cargando.Finalizar();
                }
            });

        }

        return;
    }
    , Cancelar: function(){
        
        var intAud_ID = $("#hidAAUEAud_ID").val();
        var intPT_ID = $("#hidAAUEPT_ID").val();
        var intAudU_ID = $("#hidAAUEAudU_ID").val();

        var bolError = false;
        var arrError = [];

        if( !(intAud_ID > -1) && !(intPT_ID > -1) && !(intAudU_ID > -1) ){
            bolError = true;
            arrError.push("Identificadores no permitidos");
        }

        if( bolError ){
            Avisa("warning", "Auditoria Ubicacion", arrError.join("<br>"));
        } else {
            
            Cargando.Iniciar();

            $.ajax({
                url: AuditoriasUbicacion.url + "AuditoriasUbicacion_ajax.asp"
                , method: "post"
                , async: true
                , dataType: "json"
                , data: {
                    Tarea: 3000
                    , Aud_ID: intAud_ID
                    , PT_ID: intPT_ID
                    , AudU_ID: intAudU_ID
                    , AudU_EnProceso: 0
                }
                , success: function( res ){
                    if( res.Error.Numero == 0 ){
                        $("#Contenido").load( 
                            AuditoriasPallet.url + "AuditoriasPallet_AuditorAuditorias.asp"
                        )
                    } else {
                        Avisa("warning", "Auditoria Ubicacion", res.Error.Descripcion);
                        bolExito = false;
                    }

                    Cargando.Finalizar();
                }
            });

        }

        return;
    }
    , Terminar(){

        var intTIC_ID = $("#hidAudU_TipoConteoCG142").val();
        var intAud_ID = $("#hidAAUEAud_ID").val();
        var intPT_ID = $("#hidAAUEPT_ID").val();
        var intAudU_ID = $("#hidAAUEAudU_ID").val();

        var strAudU_Comentario = $("#txtAAUEAudU_Comentario").val();
        var intAudU_HallazgoCG144 = $("#selAAUEAudU_HallazgoCG144").val();

        var intAudU_ArticulosConteoTotal = $("#inpAAUEAudU_ArticulosConteoTotal").val();

        var intAudU_MBCantidad = $("#inpAAUEAudU_MBCantidad").val();
        var intAudU_MBCantidadArticulos = $("#inpAAUEAudU_MBCantidadArticulos").val();
        var intAudU_MBCantidadSobrante = $("#inpAAUEAudU_MBCantidadSobrante").val();

        var bolError = false;
        var arrError = [];

        if( !(intAud_ID > -1) && !(intPT_ID > -1) && !(intAudU_ID > -1) ){
            bolError = true;
            arrError.push("Identificadores no permitidos");
        }

        if( strAudU_Comentario == "" ){
            bolError = true;
            arrError.push("Agregar Comentario de la Auditoria");
        }

        if( intAudU_HallazgoCG144 == "" ){
            bolError = true;
            arrError.push("Seleccionar el tipo de Hallazgo");
        }

        if( !(intAudU_ArticulosConteoTotal > 0) ){
            
            bolError = true;

            switch(parseInt()){
                case this.TipoConteo.Vista: { 
                    arrError.push("Agregar la cantidad Total de Articulos Encontrados");
                } break;
                case this.TipoConteo.MB: { 
                    arrError.push("Agregar las cantidad solicitadas de los MasterBox");
                } break;
                case this.TipoConteo.Serie: { 
                    arrError.push("Agregar las Series encontradas");
                } break;
            }
        }

        if( parseInt(intTIC_ID) == this.TipoConteo.MB ){

            if( !(intAudU_MBCantidad > 0) ){
                bolError = true;
                arrError.push("- Agregar la cantidad de MasterBox encontrados");
            }

            if( !(intAudU_MBCantidadArticulos > 0) ){
                bolError = true;
                arrError.push("- Agregar la cantidad articulos en cada MasterBox");
            }

            if( !(intAudU_MBCantidadSobrante == "") ){
                if( !(intAudU_MBCantidadSobrante > 0) ){
                    bolError = true;
                    arrError.push("- Agregar la cantidad de articulos sobrantes encontrados");
                }
            }

        }

        if( bolError ){
            Avisa("warning", "Auditoria Pallet", "Verificar Formulario<br>" + arrError.join("<br>"))
        } else {

            Cargando.Iniciar();

            $.ajax({
                url: AuditoriasUbicacion.url + "AuditoriasUbicacion_ajax.asp"
                , method: "post"
                , async: true
                , dataType: "json"
                , data: {
                      Tarea: 3000
                    , Aud_ID: intAud_ID
                    , PT_ID: intPT_ID
                    , AudU_ID: intAudU_ID
                    , AudU_Comentario: strAudU_Comentario
                    , AudU_HallazgoCG144: intAudU_HallazgoCG144
                    , AudU_ArticulosConteoTotal: intAudU_ArticulosConteoTotal
                    , AudU_MBCantidad: intAudU_MBCantidad
                    , AudU_MBCantidadArticulos: intAudU_MBCantidadArticulos
                    , AudU_MBCantidadSobrante: intAudU_MBCantidadSobrante
                    , AudU_Terminado: 1
                }
                , success: function( res ){

                    if( res.Error.Numero == 0 ){
                        Avisa("success", "Auditoria Pallet", res.Error.Descripcion)
                        $("#Contenido").load( 
                            "/pz/wms/Auditoria/AuditoriasPallet/AuditoriasPallet_AuditorAuditorias.asp"
                        )
                    } else {
                        Avisa("warning", "Auditoria Pallet", res.Error.Descripcion)
                    }

                    Cargando.Finalizar();

                }
            });
        }

    }
    , Sumar: function(){
        var intMB = $("#inpAAUEAudU_MBCantidad").val();
        var intMBArt = $("#inpAAUEAudU_MBCantidadArticulos").val();
        var intMBSob = $("#inpAAUEAudU_MBCantidadSobrante").val();

        var intTotal = (intMB * intMBArt) + intMBSob;

        $("#inpAAUEAudU_ArticulosConteoTotal").val(intTotal);
    }
    , Crear: function(){
            
        var prmJson = ( !(arguments[0] == undefined) ) ? arguments[0] : {};
        var intAud_ID = ( !(prmJson.Aud_ID == undefined) ) ? prmJson.Aud_ID : -1;
        var intPT_ID = ( !(prmJson.PT_ID == undefined) ) ? prmJson.PT_ID : -1;

        this.EdicionModalAbrir({Aud_ID: intAud_ID });

        $("#hidMdlAUUEdiAud_ID").val( intAud_ID );
        $("#hidMdlAUUEdiPT_ID").val( intPT_ID );

    }
    , EdicionModalAbrir: function(){

        var prmJson = ( !(arguments[0] == undefined) ) ? arguments[0] : {};
        var intAud_ID = ( !(prmJson.Aud_ID == undefined) ) ? prmJson.Aud_ID : -1;

        if( $("#mdlAUUEdi").length == 0 ){
            $.ajax({
                url: "/pz/wms/Auditoria/" + "Ubicacion_edicion.asp"
                , method: "post"
                , async: false
                , success: function(res){
                    $("#wrapper").append(res);
                }
            });
        }

        Catalogo.ComboCargar({
            Contenedor: "selMdlAUUEdiTPA_ID"
            , SEC_ID: 142
        });

        AuditoriasAuditores.ComboCargar({
            Contenedor: "selMdlAUUEdiADT_ID_Ext"
            , Aud_ID: intAud_ID
            , Aud_Habilitado: 1
            , Aud_Externo: 1
        });

        AuditoriasAuditores.ComboCargar({
            Contenedor: "selMdlAUUEdiADT_ID_Int"
            , Aud_ID: intAud_ID
            , Aud_Habilitado: 1
            , Aud_Externo: 0
        });

        this.EdicionModalLimpiar();

        $("#mdlAUUEdi").modal('show');
    }
    , EdicionModalCerrar: function(){

        $("#mdlAUUEdi").modal('hide');
        this.EdicionModalLimpiar();

    }
    , EdicionModalLimpiar: function(){

        $("#hidMdlAUUEdiAud_ID").val("");
        $("#hidMdlAUUEdiPT_ID").val("");
        $("#selMdlAUUEdiTPA_ID").val("");
        $("#selMdlAUUEdiADT_ID_Int").val("");
        $("#selMdlAUUEdiADT_ID_Ext").val("");

    }
    , EdicionModalGuardar: function(){

        var bolError = false;
        var arrError = [];

        var intAud_ID = $("#hidMdlAUUEdiAud_ID").val();
        var intPT_ID = $("#hidMdlAUUEdiPT_ID").val();

        var intTPA_ID = $("#selMdlAUUEdiTPA_ID").val();
        var intUsu_ID_Int = $("#selMdlAUUEdiADT_ID_Int").val();
        var intUsu_ID_Ext = $("#selMdlAUUEdiADT_ID_Ext").val();

        if( !(intAud_ID > -1) && !(intPT_ID > -1) ){
            bolError = true;
            arrError.push("Identificadores de la auditoria Ubicaicion no permitidos");
        }

        if( intTPA_ID == "" ){
            bolError = true;
            arrError.push("Seleccionar el Tipo de Conteo")
        }

        if( bolError ){
            Avisa("warning", "Auditoria Ubicacion", arrError.join("<br>"));
        } else {

            Cargando.Iniciar();

            $.ajax({
                url: AuditoriasUbicacion.url + "AuditoriasUbicacion_ajax.asp"
                , method: "post"
                , async: false
                , dataType: "json"
                , data: {
                    Tarea: 2010
                    , Aud_ID: intAud_ID
                    , PT_ID: intPT_ID
                    , TPA_ID: intTPA_ID
                    , Usu_ID_Int: intUsu_ID_Int
                    , Usu_ID_Ext: intUsu_ID_Ext
                }
                , success: function( res ){
                    if( res.Error.Numero == 0){
                        Avisa("success", "Auditoria Ubicacion", res.Error.Descripcion);
                        AuditoriasUbicacion.EdicionModalCerrar();
                    } else {
                        Avisa("warning", "Auditoria Ubicacion", res.Error.Descripcion);
                    }

                    Cargando.Finalizar();
                }
            })
        }

    }
    , ImprimirPapeleta: function(){

        var prmJson = ( !(arguments[0] == undefined) ) ? arguments[0] : {};
        var intAud_ID = ( !(prmJson.Aud_ID == undefined) ) ? prmJson.Aud_ID : -1;
        var intPT_ID = ( !(prmJson.PT_ID == undefined) ) ? prmJson.PT_ID : -1;

        var url = "/pz/wms/Auditoria/Impresion_Papeleta2.asp?Aud_ID="+intAud_ID+"&PT_ID="+intPT_ID+"";
        
        window.open(url, "Impresion Papeleta" );
    }
}
