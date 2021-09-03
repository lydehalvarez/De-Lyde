var OrdenMovimiento = {
       url: "/pz/wms/Almacen/OrdenMovimiento/"
     , Tipo: {
          Surtido: 1
        , Estatus: 2
        , Reacomodo: 3
    }
    , Estatus: {
          Auditada: 7
        , Cancelada: 5
        , EnAuditoria: 6
        , EnProceso: 3
        , Nuevo: 1
        , Pendiente: 2
        , Terminada: 4
    }  
    , Crear: function(){
        var prmJson = ( !(arguments[0] == undefined) ) ? arguments[0] : {};
        var intTOM_ID = ( !(prmJson.TOM_ID == undefined) ) ? prmJson.TOM_ID : -1;

        switch(parseInt(intTOM_ID)){
            case this.Tipo.Surtido: {
                OrdenMovimientoPorSurtido.Crear();
            } break;

        }
    }
    , Editar: function(){
        var prmJson = ( !(arguments[0] == undefined) ) ? arguments[0] : {};
        var intTOM_ID = ( !(prmJson.TOM_ID == undefined) ) ? prmJson.TOM_ID : -1;
        var intIOM_ID = ( !(prmJson.IOM_ID == undefined) ) ? prmJson.IOM_ID : -1;

        switch(parseInt(intTOM_ID)){
            case this.Tipo.Surtido: {
                OrdenMovimientoPorSurtido.Editar({IOM_ID: intIOM_ID})
            } break;

        }
    }
    , Eliminar: function(){
        var prmJson = ( !(arguments[0] == undefined) ) ? arguments[0] : {};
        var intIOM_ID = ( !(prmJson.IOM_ID == undefined) ) ? prmJson.IOM_ID : -1;

        var bolError = false;
        var arrError = [];

        if( !(intIOM_ID > -1) ){
            bolError = true;
            arrError.push("Identificador de Orden de Movimiento no permitido");
        }

        if( bolError ){
            Avisa("warning","Orden de Movimiento", "Verificar el Formulario:<br>" + arrError.join("<br>"));
        } else {
            Cargando.Iniciar();

            $.ajax({
                  url: this.url + "OrdenMovimiento_ajax.asp"
                , method: "post"
                , async: true
                , dataType: "json"
                , data: {
                    Tarea: 4000
                    , IOM_ID : intIOM_ID
                }
                , success: function(res){

                    if( res.Error.Numero == 0 ){
                        Avisa("success", "Ordende Movimiento", res.Error.Descripcion);
                        OrdenMovimiento.ListadoCargar();
                    } else {
                        Avisa("warning", "Orden de Movimiento", res.Error.Descripcion);
                    }

                    Cargando.Finalizar();
                }
                , error: function(){
                    Avisa("error", "Orden de Movimiento", "No se puede eliminar la Orden de Movimiento");
                    Cargando.Finalizar();
                }
            });
        }
    } 
    , ListadoCargar: function(){
        Cargando.Iniciar();

        var strIOM_Folio = $("#inpIOMOM_Folio").val();
        var strPro_SKU = $("#inpIOMPro_SKU").val();
        var intCli_ID = $("#selIOMCliente").val();
        var intUbi_ID_Destino = $("#selIOMUbicacion").val();
        var intEst_ID = $("#selIOMEstatus").val();
        var intTOM_ID = $("#selIOMTipo").val();
        var dateFechaInicial = $("#inpIOMFechaInicial").val();
        var dateFechaFinal = $("#inpIOMFechaFinal").val();
        var intIOM_Prioridad = $("#selIOMPrioridad").val();

        $.ajax({
            url: this.url + "OrdenMovimiento_Listado.asp"
            , method: "post"
            , async: true
            , data: {
                Tarea: 1000
                , IOM_Folio: strIOM_Folio
                , Pro_SKU: strPro_SKU
                , Cli_ID: intCli_ID
                , Ubi_ID_Destino: intUbi_ID_Destino
                , Est_ID: intEst_ID
                , TOM_ID: intTOM_ID
                , FechaInicial: dateFechaInicial
                , FechaFinal: dateFechaFinal
                , IOM_Prioridad: intIOM_Prioridad
            }  
            , success: function(res){
                $("#divIOMListado").html(res);
                Cargando.Finalizar();
            }
            , error: function(){
                Avisa("error", "Orden Movimiento - Panel", "No se puede cargar el Listado")
                Cargando.Finalizar();
            }
        }) 
    }
    
}

var OrdenMovimientoPorSurtido = {
    Crear: function(){

        var intIOM_IDUsuario = $("#IDUsuario").val();

        Cargando.Iniciar();

        $.ajax({
            url: OrdenMovimientoPorSurtido.url + "OrdenMovimiento_ajax.asp"
            , method: "post"
            , async: true
            , dataType: "json"
            , data: {
                  Tarea: 2000
                , TOM_ID: OrdenMovimiento.Tipo.Surtido
                , Est_ID: OrdenMovimiento.Estatus.Nuevo
                , IOM_IDUsuario: intIOM_IDUsuario
                , Are_ID_Origen: 1  /* Almacen */
                , Are_ID_Destino: 17 /* Prepicking */
            }
            , success: function( res ){
                
                if( res.Error.Numero == 0 ){
                    Avisa("success", "Orden de Movimiento", jsonRes.Error.Descripcion);
                    Cargando.Finalizar();

                    OrdenMovimientoPorSurtido.EdicionModalAbrir()

                    var jsonReg = OrdenMovimiento.ExtraerID({IOM_ID: jsonRes.Registro.IOM_ID})

                    $("#hidMdlIOMSurIOM_ID").val(jsonReg.IOM_ID);
                    $("#lblMdlIOMSurIOM_Folio").text(jsonReg.IOM_Folio);

                    OrdenMovimiento.ListadoCargar();

                } else {
                    Avisa("success", "Orden de Movimiento", jsonRes.Error.Descripcion);
                    Cargando.Finalizar();
                }
            }
            , error: function(){
                Avisa("success", "Orden de Movimiento", "No se ejecuto el proceso de creacion de la Orden de compra");
                Cargando.Finalizar();
            }
        });
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

        $("#divMdlIOMSurProductoEdicionListado").html("");
    }
   
}






var OrdenMovimientoPorEstatus = {
    Crear: function(){
        
        var jsonRes = OrdenMovimiento.Guardar({
                  Tipo: OrdenMovimiento.Tipo.Estatus
                , IDUsuario: $("#IDUsuario").val()
                , Estatus: OrdenMovimiento.Estatus.Nuevo
            });

        if( parseInt(jsonRes.Error.Numero) == 0){
            Avisa("success", "Orden de Movimiento", jsonRes.Error.Descripcion);

            this.EdicionModalAbrir();

            var prmJson = OrdenMovimiento.ExtraerID({IOM_ID: jsonRes.OrdenMovimiento.IOM_ID});

            $("#hidMdlIOMPorEstIOM_ID").val(prmJson.IOM_ID);

        } else {
            Avisa("danger", "Orden de Movimiento", jsonRes.Error.Descripcion);
        }
    }
    , EdicionModalAbrir: function(){
        
        if( $("#mdlIOMPorEstEdicion").length == 0 ){

            $.ajax({
                url: urlBaseOrdenMovimiento + "OrdenMovimiento_ajax.asp"
                , method: "post"
                , async: false
                , data: {
                    Tarea: 600
                }  
                , success: function(res){
                    $("#Contenido").append(res);

                    Catalogo.ComboCargar({
                          SEC_ID: 20
                        , CAT_Tipo: 1
                        , Contenedor: "selMdlIOMPorEstEstatusArticulo"
                    });
                }
            });
        }

        this.EdicionModalLimpiar();

        $("#mdlIOMPorEstEdicion").modal('show');

    }
    , EdicionModalCerrar: function(){

        $("#mdlIOMPorEstEdicion").modal('hide');
    }
    , EdicionModalFormularioLimpiar: function(){
        $("input[name=radMdlIOMPorEstTipoSelecionSerie]").prop("checked", false);
        $("#inpMdlIOMPorEstSerie").val("");
        this.InventarioSerieUbicacionListadoLimpiar();
    }
    , EdicionModalLimpiar: function(){
        $("#hidMdlIOMPorEstIOM_ID").val("");
        $("#hidMdlIOMPorEstCli_ID").val("");
        $("#hidMdlIOMPorEstPro_ID").val("");
        $("#lblMdlIOMPorEstCli_Nombre").text("");
        $("#lblMdlIOMPorEstPro_Nombre").text("");
        $("#selMdlIOMPorEstEstatusArticulo").val("");
        $("#chbMdlIOMPorEstPrioridad").prop("cheked", false);

        this.EdicionModalFormularioLimpiar()
        this.InventarioSerieUbicacionListadoLimpiar();
        this.InventarioSerieMovimientoListadoLimpiar();
    }
    , Editar: function(){
        var prmJson = ( !(arguments[0] == undefined) ) ? arguments[0] : {};

        var intIOM_ID = ( !(prmJson.IOM_ID == undefined)) ? prmJson.IOM_ID: -1;

        this.EdicionModalAbrir();

        var prmJson = this.ExtraerID({IOM_ID: intIOM_ID});

        $("#hidMdlIOMPorEstIOM_ID").val(prmJson.IOM_ID);
        $("#selMdlIOMPorEstEstatusArticulo").val( ( (parseInt(prmJson.INV_EstatusCG20) > -1) ? prmJson.INV_EstatusCG20 : "") );

        $("#hidMdlIOMPorEstCli_ID").val( prmJson.Cli_ID );
        $("#lblMdlIOMPorEstCli_Nombre").text( prmJson.Cli_Nombre );
        $("#hidMdlIOMPorEstPro_ID").val( prmJson.Pro_ID );
        $("#lblMdlIOMPorEstPro_Nombre").text( prmJson.Pro_Nombre );

        this.InventarioSerieMovimientoListadoCargar({IOM_ID: intIOM_ID});
    }
    , Eliminar: function(){
        var prmJson = ( !(arguments[0] == undefined) ) ? arguments[0] : {};

        var intIOM_ID = (!(prmJson.IOM_ID == undefined)) ? prmJson.IOM_ID : -1;

        var jsonRes = OrdenMovimiento.Eliminar({IOM_ID: intIOM_ID})

        if( parseInt(jsonRes.Error.Numero) == 0 ){
            this.ListadoPrincipalCargar();    
        }
    }
    , ExtraerID: function(){

        var prmJson = ( !(arguments[0] == undefined) ) ? arguments[0] : {};

        var intIOM_ID = (!(prmJson.IOM_ID == undefined)) ? prmJson.IOM_ID : -1;

        return OrdenMovimiento.Extraer({IOM_ID: intIOM_ID}).Registros[0];
    }
    , Guardar: function(){

        var jsonRes = OrdenMovimiento.Guardar({
                  Tipo: OrdenMovimiento.Tipo.Estatus
                , IDUsuario: $("#IDUsuario").val()
                , Prioridad: $("#chbMdlIOMPorEstPrioridad").is(":checked") ? 1 : 0
                , EstatusArticulo: $("#selMdlIOMPorEstEstatusArticulo").val()
                , Estatus: OrdenMovimiento.Estatus.Pendiente
                , CantidadSolicitada: $("#labelSerieMovimientoSeleccionadaCantidad").text()
                , IOM_ID: $("#hidMdlIOMPorEstIOM_ID").val()
                , Cli_ID: $("#hidMdlIOMPorEstCli_ID").val()
                , Pro_ID: $("#hidMdlIOMPorEstPro_ID").val()
            });

        if( parseInt(jsonRes.Error.Numero) == 0){
            Avisa("success", "Orden de Movimiento", jsonRes.Error.Descripcion);

            this.SeriesActualizar({EsGuardar: true});
            this.ListadoPrincipalCargar();  
            this.EdicionModalCerrar();

        } else {
            Avisa("danger", "Orden de Movimiento", jsonRes.Error.Descripcion);
        }
    }
    , ListadoPrincipalCargar: function(){

        Cargando.Iniciar();

        var intCli_ID = $("#selCliente").val();
        var intUbi_ID = $("#selUbicacion").val();
        var intEst_ID = $("#selEstatus").val();
        var strPro_SKU = $("#inpProductoSku").val();

        $.ajax({
            url: urlBaseOrdenMovimiento + "OrdenMovimiento_ajax.asp"
            , method: "post"
            , async: false
            , data: {
                Tarea: 1002
                , Cli_ID: intCli_ID
                , Ubi_ID_Destino: intUbi_ID
                , Est_ID: intEst_ID
                , Pro_SKU: strPro_SKU
            }  
            , success: function(res){
                $("#divIOMListadoTabla").html(res);
            }
        });

        Cargando.Finalizar();
    }
    , SerieUbicacionListadoCargar: function(){

        var strSerie = $("#inpMdlIOMPorEstSerie").val();
        var intTipoSeleccion = $("input[name=radMdlIOMPorEstTipoSelecionSerie]:checked").val();

        var bolError = false;
        var arrError = [];

        if( strSerie == "" || !(intTipoSeleccion > 0)){
            bolError = true;
            
            if( !(strSerie != "") ){
                arrError.push("- Agregar el Numero de Serie")
            }

            if( !(intTipoSeleccion > 0) ){
                arrError.push("- Agregar el tipo de Seleccion")
            }
            
        }

        if( bolError ){
            Avisa("warning", "Series de la Ubicacion", "Verificar el Formulario<br> " + arrError.join("<br>"));
        } else {

            var prmJson = this.InventarioSerieExtraerSerie({ INV_Serie: strSerie });

            var bolSeries = false;

            var intCli_ID = $("#hidMdlIOMPorEstCli_ID").val();
            var intPro_ID = $("#hidMdlIOMPorEstPro_ID").val()
            
            if( parseInt($("#labelSerieMovimientoSeleccionadaCantidad").text()) == 0 ){

                $("#hidMdlIOMPorEstCli_ID").val(prmJson.Cli_ID);
                $("#hidMdlIOMPorEstPro_ID").val(prmJson.Pro_ID);

                $("#lblMdlIOMPorEstCli_Nombre").text(prmJson.Cli_Nombre);
                $("#lblMdlIOMPorEstPro_Nombre").text(prmJson.Pro_Nombre);

                bolSeries = true

            } else {
                
                if( !( intCli_ID == prmJson.Cli_ID && intPro_ID == prmJson.Pro_ID )  && intCli_ID != ""  && intPro_ID != "" ){
                    Avisa("warning", "Series de la Ubicacion", "La serie no corresponde al cliente y producto del grupo de series a mover. ");
                } else {
                    bolSeries = true;
                }
            }
            
            if( bolSeries ){
                this.InventarioSerieUbicacionListadoCargar({
                    TipoSeleccion:intTipoSeleccion
                  , Serie: strSerie
                });
            }
      
        }

    }
    , InventarioSerieExtraerSerie: function(){
        var prmJson = ( !(arguments[0] == undefined) ) ? arguments[0] : {};

        var strSerie = (!(prmJson.INV_Serie == undefined)) ? prmJson.INV_Serie : "";

        return Inventario.SerieExtraerSerie({INV_Serie: strSerie});
    }
    , InventarioSerieUbicacionListadoCargar: function(){
        var prmJson = ( !(arguments[0] == undefined) ) ? arguments[0] : {};

        var intTipoSeleccion = (!(prmJson.TipoSeleccion == undefined)) ? prmJson.TipoSeleccion : 1;
        var strSerie = (!(prmJson.Serie == undefined)) ? prmJson.Serie : "";

        this.InventarioSerieUbicacionListadoLimpiar();

        Inventario.SerieUbicacionListadoCargar({
            Serie: strSerie
            , TipoSeleccion: intTipoSeleccion
            , Contenedor: "divMdlIOMPorEstSeriesUbicacionSeleccion"
            , EsSeleccion: 1
            , FuncionSeleccion: "OrdenMovimientoPorEstatus.SeriesAgregar()"
            , Titulo: "Series a Seleccionar"
            , VerTotalSeleccionado: 1
        });
    }
    , InventarioSerieUbicacionListadoLimpiar: function(){
        $("#divMdlIOMPorEstSeriesUbicacionSeleccion").html("");
    }
    , InventarioSerieMovimientoListadoLimpiar: function(){
        $("#divMdlIOMPorEstSeriesMovimientoSeleccion").html("");
    }
    , InventarioSerieMovimientoListadoCargar: function(){

        var prmJson = ( !(arguments[0] == undefined) ) ? arguments[0] : {};

        var intIOM_ID = (!(prmJson.IOM_ID == undefined)) ? prmJson.IOM_ID : -1;

        Inventario.SerieMovimientoListadoCargar({
            IOM_ID: intIOM_ID
          , Contenedor: "divMdlIOMPorEstSeriesMovimientoSeleccion"
          , EsSeleccion: 1
          , FuncionEliminacion: "OrdenMovimientoPorEstatus.SeriesActualizar()"
          , Titulo: "Series a Mover"
          , VerTotalSeleccionado: 1
      });
    }
    , InventarioSerieMovimientoListadoSeleccionadaCantidadVer: function(){
        Inventario.SerieMovimientoListadoSeleccionadaCantidadVer();
    }
    , SeriesAgregar: function(){

        var intIOM_ID = $("#hidMdlIOMPorEstIOM_ID").val();

        var bolError = false;
        var arrError = [];
        var arrINV_IDs = [];

        if( $(".chbSerieUbicacionSeleccion").length > 0 ){

            $(".chbSerieUbicacionSeleccion:checked").each(function(){
                arrINV_IDs.push( $(this).val())
            });

        } else {
            bolError = true;
            arrError.push(" Seleccionar al menos una Serie");
        }

        if( bolError ){
            Avisa("warning", "Series a Seleccionar", "Verificar Listado<br>" + arrError.join("<br>"));
        } else {

            $.ajax({
                url: urlBaseOrdenMovimiento + "OrdenMovimiento_ajax.asp"
                , method: "post"
                , async: false
                , dataType: "json"
                , data: {
                    Tarea: 3200
                    , IOM_ID: intIOM_ID
                    , INV_IDs: arrINV_IDs.join(",")
                    , EsAgregarIOM: 0
                }  
                , success: function(res){
                    if( parseInt(res.Error.Numero) == 0){
                        Avisa("success", "Series a Mover", res.Error.Descripcion);

                        OrdenMovimientoPorEstatus.InventarioSerieMovimientoListadoCargar({IOM_ID: intIOM_ID});
                        OrdenMovimientoPorEstatus.InventarioSerieMovimientoListadoSeleccionadaCantidadVer();
                        OrdenMovimientoPorEstatus.EdicionModalFormularioLimpiar();

                    } else {
                        Avisa("warning", "Series a Mover", res.Error.Descripcion);
                    }

                    
                }
            });
        }
        
    }
    , SeriesActualizar: function(){
        var prmJson = ( !(arguments[0] == undefined) ) ? arguments[0] : {};

        var bolEsGuardar = (!(prmJson.EsGuardar == undefined)) ? prmJson.EsGuardar : false;

        var intIOM_ID = $("#hidMdlIOMPorEstIOM_ID").val();

        var bolError = false;
        var arrError = [];
        var arrINV_IDs = [];

        if( $(".chbSerieMovimientoSeleccion").length > 0 ){

            $(".chbSerieMovimientoSeleccion:checked").each(function(){
                arrINV_IDs.push( $(this).val())
            });

        } else {
            bolError = true;
            arrError.push(" Seleccionar al menos una Serie");
        }

        if( bolError ){
            Avisa("warning", "Series a Seleccionar", "Verificar Listado<br>" + arrError.join("<br>"));
        } else {

            $.ajax({
                url: urlBaseOrdenMovimiento + "OrdenMovimiento_ajax.asp"
                , method: "post"
                , async: false
                , dataType: "json"
                , data: {
                    Tarea: 3200
                    , IOM_ID: intIOM_ID
                    , INV_IDs: arrINV_IDs.join(",")
                    , EsAgregarIOM: 1
                }  
                , success: function(res){
                    if( parseInt(res.Error.Numero) == 0){
                        Avisa("success", "Series a Mover", res.Error.Descripcion);

                        if(!(bolEsGuardar)){
                            if( parseInt($("#labelSerieMovimientoSeleccionadaCantidad").text()) == 0 ){
                                $("#hidMdlIOMPorEstCli_ID").val("");
                                $("#hidMdlIOMPorEstPro_ID").val("");
                                $("#lblMdlIOMPorEstCli_Nombre").text("");
                                $("#lblMdlIOMPorEstPro_Nombre").text("");
                            }
                            
                            OrdenMovimientoPorEstatus.InventarioSerieMovimientoListadoCargar({IOM_ID: intIOM_ID});
                            OrdenMovimientoPorEstatus.InventarioSerieMovimientoListadoSeleccionadaCantidadVer();
                            OrdenMovimientoPorEstatus.EdicionModalFormularioLimpiar();
                        }

                    } else {
                        Avisa("warning", "Series a Mover", res.Error.Descripcion);
                    }
                    
                }
            });
        }
    }
    , TerminarModalAbrir: function(){

        if( $("#modalOrdenMovimientoTerminar").length == 0 ){

            $.ajax({
                url: urlBaseOrdenMovimiento + "OrdenMovimiento_ajax.asp"
                , method: "post"
                , async: false
                , data: {
                    Tarea: 700
                }  
                , success: function(res){
                    $("#Contenido").append(res);
                }
            });
        }

        this.TerminarModalLimpiar();

        $("#modalOrdenMovimientoTerminar").modal('show');
    }
}

