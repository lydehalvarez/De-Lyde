var Producto = {
    url: "/pz/wms/Incidencias/"
    , Listado: {
          Contenedor: ""
        , Tipo: -1
        , CambiarProducto: 0
        , VerSerie: 0
        , CambiarSerie: 0
        , Ins_ID: -1
        , TipoListado: {
              Ninguno: -1
            , Transferencia: 1
            , OrdenVenta: 2
        }
        , Cargar: function( prmJson ){
            
            var bolError = false;
            var arrError = [];

            this.Tipo = ( prmJson.Tipo != undefined ) ? prmJson.Tipo : this.TipoListado.Ninguno;
            this.Contenedor = ( prmJson.Contenedor != undefined ) ? prmJson.Contenedor : "";
            this.CambiarProducto = ( prmJson.CambiarProducto != undefined ) ? prmJson.CambiarProducto : 0;
            this.VerSerie = ( prmJson.VerSerie != undefined ) ? prmJson.VerSerie : 0;
            this.CambiarSerie = ( prmJson.CambiarSerie != undefined ) ? prmJson.CambiarSerie : 0;
            this.Ins_ID = ( prmJson.Ins_ID != undefined ) ? prmJson.Ins_ID : -1;

            var strFolio = prmJson.Filtros.Folio;

            if( this.Contenedor == ""){
                bolError = true;
                arrError.push("- Agregar el identificador del contenedor");
            }

            if( this.Tipo == this.TipoListado.Ninguno ){
                bolError = true;
                arrError.push("- Seleccionanar el tipo de Listado");
            }

            if( bolError ){
                Avisa("warning", "Producto - Listado - Cargar", "Verificar<br>" + arrError.join("<br>"));
            } else {

                var strContendor = this.Contenedor;
                                    
                $.ajax({
                        url: Producto.url + "Incidencias_Formulario_Entrega_Producto_Listado.asp"
                    , method: "post"
                    , async: true
                    , data: {
                          Tipo: this.Tipo
                        , CambiarProducto: this.CambiarProducto
                        , VerSerie: this.VerSerie
                        , CambiarSerie: this.CambiarSerie
                        , Ins_ID: this.Ins_ID
                        , Folio: strFolio
                    }
                    , beforeSend: function(){
                        Cargando.Iniciar();
                    }
                    , success: function( res ){
                        $("#" + strContendor).html( res );
                    }
                    , error: function(){
                        Avisa("error", "Producto - Listado - Cargar", "Error en la peticion");
                    }
                    , complete: function(){
                        Cargando.Finalizar();
                    }
                });
            }
        }
        , Registro: {
            SeleccionValidar: function( prmJson ){
                var bolError = false;
                var arrError = [];

                var objError = "";

                var objBase = prmJson.Objeto;
                var objPadre = $(objBase).parents("tr");
                var bolEsSeleccionado = $(".cssChkInsEntProPro_ID", objPadre).is(":checked");
                var strSKUCambio = prmJson.SKUCambio;

                if( this.CambiarProducto == 1){
                    if( bolEsSeleccionado){
                        if( strSKUCambio.trim() == ""){
                            bolError = true;
                            arrError.push("Agregar el SKU a Cambiar");
                        }
                    } 
                }

                if( bolError ){
                    objError = "<i class='fa fa-exclamation-circle fa-2x text-danger cssInsEntError' title='" + arrError.join(",") + "'></i>"
                } else {
                    objError = "";
                }

                $(".cssInsEntProError").html(objError);
            }
        
        }
        , SeleccionValidar: function(){
            var bolError = ( $(".cssInsEntError").length > 0 );

            return bolError;
        }
        , DatosExtraer: function(){
            var arrReg = [];
            var bolCambiarProducto = ( this.CambiarProducto == 1 );

            $(".cssTrInsEntPro_ID").each(function(){

                var bolEsSeleccionado = $(".cssChkInsEntProPro_ID", $(this)).is(":checked");

                if( bolEsSeleccionado ){
                    var intPro_ID = $(this).data("pro_id");

                    var strPro_SKU_Cambio = ( bolCambiarProducto ) ? $(".cssInpInsEntProCambiarProducto", $(this)).val() : "";

                    var jsonReg = {
                          Pro_ID: intPro_ID
                        , Pro_SKU_Cambio: strPro_SKU_Cambio
                    }

                    arrReg.push(jsonReg);
                }
                
            })

            return arrReg;
        }
    }
}