var OrdenMovimientoPorSurtido = {
    Crear: function(){
        
        var intIOM_IDUsuario = $("#IDUsuario").val();

        var jsonRes = OrdenMovimiento.BDEjecutar({
                  Tarea: 2000
                , TOM_ID: OrdenMovimiento.Tipo.Surtido
                , Est_ID: OrdenMovimiento.Estatus.Nuevo
                , IOM_IDUsuario: intIOM_IDUsuario
            });

        if( jsonRes.Error.Numero != 0 ){
            Avisa("warning", "Orden  de Movimiento", jsonRes.Error.Descripcion);
            return;
        }

        OrdenMovimiento.ListadoCargar();

        this.EdicionModalAbrir();

        var jsonReg = OrdenMovimiento.ExtraerID({IOM_ID: jsonRes.Registro.IOM_ID})

        $("#hidMdlIOMSurIOM_ID").val(jsonReg.IOM_ID);
        $("#lblMdlIOMSurIOM_Folio").text(jsonReg.IOM_Folio);

    }
    , EdicionModalAbrir: function(){

        if( $("#mdlIOMSurEdicion").length == 0 ){
            $.ajax({
                url: OrdenMovimiento.url + "OrdenMovimiento_PorSurtir_Edicion.asp"
                , method: "post"
                , async: true
                , success: function( res ){
                    $("#wrapper").append(res);
                    $("#mdlIOMSurEdicion").modal("show");
                }
            });
        }    

        this.EdicionModalLimpiar();

        $("#mdlIOMSurEdicion").modal("show");
    }
    , EdicionModalCerrar: function(){
        
        $("#mdlIOMSurEdicion").modal("hide");

        this.EdicionModalLimpiar();
    }
    , EdicionModalLimpiar: function(){
        $("#hidMdlIOMSurIOM_ID").val("");
        $("#lblMdlIOMSurIOM_Folio").text("");
        $("#chbMdlIOMSurIOM_Prioridad").prop("checked", false);

        this.EdicionModalProductoFormularioLimpiar();

        $("#divMdlIOMSurProductoEdicionListado").html("");

    }
    , EdicionModalProductoBuscarListar: function(){
        
        var bolError = false;
        var arrError = [];

        var intIOM_ID =  $("#hidMdlIOMSurIOM_ID").val();

        if( intIOM_ID == 0){
            bolError = true;
            arrError.push("Identificador de Orden de Movimiento no permitido");
        }

        if( bolError ){
            Avisa("warning", "Orden de Movimiento", arrError.join("<br>"));
        } else {

            $.ajax({
                url: OrdenMovimiento.url + "OrdenMovimientoProductoEdicion_Listado.asp"
                , method: "post"
                , async: true
                , data: {
                    IOM_ID: intIOM_ID
                }
                , success: function( res ){
                    $("#divMdlIOMSurProductoEdicionListado").html( res );
                }
            });

        }
    }
    , EdicionModalProductoAgregar: function(){

        var bolError = false;
        var arrError = [];

        var intIOM_ID = $("#hidMdlIOMSurIOM_ID").val();
        var intPro_ID = $("#selMdlIOMSurProducto").val();
        var intIOMP_CantidadSolicitada = $("#inpMdlIOMSurCantidad").val();

        if( intIOM_ID == "" ){
            bolError = true;
            arrError.push("Identificador de Orden de Movimiento no permitido");
        }

        if( intPro_ID == "" ){
            bolError = true;
            arrError.push("Seleccionar el Producto");
        }

        if( !(intIOMP_CantidadSolicitada > 0) ){
            bolError = true;
            arrError.push("Agregar cantidad mayor a 0");
        }

        if( bolError ){
            Avisa("warning", "Orden de Movimiento", "Verificar Formulario<br>" + arrError.join("<br>"));
        } else {

            Cargando.Iniciar();

            $.ajax({
                url: "/pz/wms/Almacen/OrdenMovimiento/OrdenMovimientoProducto_Listado.asp"
                , method: "post"
                , async: true
                , dataType: "json"
                , data: {
                      Tarea: 2000
                    , IOM_ID: intIOM_ID
                    , Pro_ID: intPro_ID
                    , IOMP_CantidadSolicitada: intIOMP_CantidadSolicitada
                }
                , success: function( res ){
                    if( res.Error.Numero == 0 ){

                        Avisa("success", "Orden Movimiento Producto", res.Error.Descripcion);
                        OrdenMovimientoPorSurtido.EdicionModalProductoBuscarListar();

                    } else {
                        Avisa("warning", "Orden Movimiento Producto", res.Error.Descripcion);
                    }
                    Cargando.Finalizar();
                }
                , Error: function(){

                    Avisa("error", "Orden Movimiento Producto", "NO se Registro el Producto");
                    Cargando.Finalizar();

                }
            });
        }

    }
    , EdicionModalProductoEliminar: function(){
        var bolError = false;
        var arrError = [];

        var prmJson = ( !(arguments[0] == undefined) ) ? arguments[0] : {};
        var intIOMP_ID = ( !(prmJson.IOMP_ID == undefined) ) ? prmJson.IOMP_ID : -1;

        if( !(intIOMP_ID > 0) ){
            bolError = true;
            arrError.push("Identificador de Orden de Movimiento Producto NO permitido");
        }

        if( bolError ){
            Avisa("warning", "Orden Movimiento Producto", arrError.join("<br>"));
        } else {

            Cargando.Iniciar();

            $.ajax({
                url: "/pz/wms/Almacen/OrdenMovimientoProducto/OrdenMovimientoProducto_ajax.asp"
                , method: "post"
                , async: true
                , dataType: "json"
                , data: {
                    Tarea: 4000
                    , IOMP_ID: intIOMP_ID
                }
                , success: function( res ){
                    if( res.Error.Numero == 0 ){
                        Avisa("success", "Orden Movimiento Producto", res.Error.Descripcion);
                    } else {
                        Avisa("warning", "Orden Movimiento Producto", res.Error.Descripcion);
                    }

                    Cargando.Finalizar();
                }
            })
        }
    }
    , EdicionModalProductoFormularioLimpiar: function(){
        $("#selMdlIOMSurPro_ID").val("");
        $("#inpMdlIOMSurPro_Cantidad").val("");
    }
    , Editar: function(){

    }
    , Eliminar: function(){

        var jsonPrm = ( !(arguments[0] == undefined) ) ? arguments[0] : {};
        var intIOM_ID = ( !(jsonPrm.IOM_ID == undefined) ) ? jsonPrm.IOM_ID : -1;

        var bolError = false;
        var arrError = [];
        var jsonRes = {};

        if( !(intIOM_ID > -1) ){
            bolError = ture;
            arrError.push("Identificador de Orden de Movimiento no permitido");
        }

        if( bolError ){

            jsonRes = {
                Error: {
                    Numero: 1
                    , Descripcion: arrError.join("<br>")
                }
            }

        } else {

            $.ajax({
                url: OrdenMovimiento.url + "OrdenMovimiento_ajax.asp"
                , method: "post"
                , async: false
                , dataType: "json"
                , data: {
                    Tarea: 4000
                    , IOM_ID: intIOM_ID
                }
                , success: function( res ){
                    jsonRes = res;
                }
            });

        }

        return jsonRes;

    }
    , Extraer: function(){

    }
    , ExtraerID: function(){

    }
    , Guardar: function(){

    }
}

