var urlBaseInventario = "/pz/wms/Almacen/Inventario/"

var Inventario = {
    TipoSeleccion: {
        Serie: 1
        , MasterBox: 2
        , Pallet: 3
    }
    , SerieExtraer(){

        var prmJson = (!(arguments[0] == undefined )) ? arguments[0] : {};

        var intINV_ID = ( !(prmJson.INV_ID == undefined) ) ? prmJson.INV_ID : -1;
        var strINV_Serie = ( !(prmJson.INV_Serie == undefined) ) ? prmJson.INV_Serie : "";

        var jsonRespuesta = "{}";
        
        $.ajax({
            url: urlBaseInventario + "Inventario_ajax.asp"
            , method: "post"
            , async: false
            , dataType: "json"
            , data: {
                  Tarea: 10
                , INV_ID: intINV_ID
                , INV_Serie: strINV_Serie
            }
            , success: function(res){
                jsonRespuesta = res;
            }
        })

        return jsonRespuesta;
    }
    , SerieExtraerID: function(){
    
        var prmJson = ( !(arguments[0] == undefined) ) ? arguments[0] : {};

        var intINV_ID = (!(prmJson.INV_ID == undefined)) ? prmJson.INV_ID : -1;
        
        return  this.SerieExtraer({INV_ID: intINV_ID}).Registros[0];

    }
    , SerieExtraerSerie: function(){
        var prmJson = ( !(arguments[0] == undefined) ) ? arguments[0] : {};

        var strINV_Serie = (!(prmJson.INV_Serie == undefined)) ? prmJson.INV_Serie : "";

        return  this.SerieExtraer({INV_Serie: strINV_Serie}).Registros[0];
    }
    , SerieSelecionListado: function(){

    }
    ,SerieUbicacionListadoCargar: function(){

        var prmJson = (!(arguments[0] == undefined )) ? arguments[0] : {};

        var strContenedor = ( !(prmJson.Contenedor == undefined) ) ? prmJson.Contenedor : "divSerieUbicacionListado";
        var strSerie = ( !(prmJson.Serie == undefined) ) ? prmJson.Serie : "";
        var intTipoSeleccion = ( !(prmJson.TipoSeleccion == undefined) ) ? prmJson.TipoSeleccion : this.TipoSeleccion.Serie;
        var strFuncionSeleccion = ( !(prmJson.FuncionSeleccion == undefined) ) ? prmJson.FuncionSeleccion : "";
        var bolEsSeleccion = ( !(prmJson.EsSeleccion == undefined) ) ? prmJson.EsSeleccion : 0;
        var strTitulo = ( !(prmJson.Titulo == undefined) ) ? prmJson.Titulo : "Series";
        var bolVerTotalSeleccionado = ( !(prmJson.VerTotalSeleccionado == undefined) ) ? prmJson.VerTotalSeleccionado : 0;

        $.ajax({
              url: urlBaseInventario + "Inventario_ajax.asp"
            , method: "post"
            , async: false
            , data: {
                  Tarea: 1101
                , Serie: strSerie
                , TipoSeleccion: intTipoSeleccion
                , FuncionSeleccion: strFuncionSeleccion
                , EsSeleccion: bolEsSeleccion
                , Titulo: strTitulo
                , VerTotalSeleccionado: bolVerTotalSeleccionado
            }
            , success: function(res){
                $("#" + strContenedor).html(res);
                
                if( parseInt(bolVerTotalSeleccionado) == 1){
                   Inventario.SerieUbicacionListadoSeleccionadaCantidadVer();
                }
            }
        });

    }
    , SerieUbicacionListadoSeleccionadaCantidadVer: function(){
        $("#labelSerieUbicacionSeleccionadaCantidad").text( $(".chbSerieUbicacionSeleccion:checked").length );
    }
    , SerieMovimientoListadoSeleccionadaCantidadVer: function(){
        $("#labelSerieMovimientoSeleccionadaCantidad").text( $(".chbSerieMovimientoSeleccion:checked").length );
    }
    , SerieMovimientoListadoCargar: function(){

        var prmJson = (!(arguments[0] == undefined )) ? arguments[0] : {};

        var strContenedor = ( !(prmJson.Contenedor == undefined) ) ? prmJson.Contenedor : "divSerieAlmacenUbicacionListado";
        var intIOM_ID = ( !(prmJson.IOM_ID == undefined) ) ? prmJson.IOM_ID : -1;
        var strFuncionEliminacion = ( !(prmJson.FuncionEliminacion == undefined) ) ? prmJson.FuncionEliminacion : "";
        var bolEsSeleccion = ( !(prmJson.EsSeleccion == undefined) ) ? prmJson.EsSeleccion : 0;
        var strTitulo = ( !(prmJson.Titulo == undefined) ) ? prmJson.Titulo : "Series";
        var bolVerTotalSeleccionado = ( !(prmJson.VerTotalSeleccionado == undefined) ) ? prmJson.VerTotalSeleccionado : 0;
       
        $.ajax({
              url: urlBaseInventario + "Inventario_ajax.asp"
            , method: "post"
            , async: false
            , data: {
                  Tarea: 1102
                , IOM_ID: intIOM_ID
                , FuncionEliminacion: strFuncionEliminacion
                , EsSeleccion: bolEsSeleccion
                , Titulo: strTitulo
                , VerTotalSeleccionado: bolVerTotalSeleccionado
            }
            , success: function(res){
                $("#" + strContenedor).html(res);

                if( parseInt(bolVerTotalSeleccionado) == 1){
                    Inventario.SerieMovimientoListadoSeleccionadaCantidadVer();
                }
            }
      });

    }
    , SerieLoteListadoCargar: function(){

        var prmJson = (!(arguments[0] == undefined )) ? arguments[0] : {};
        
        var strContenedor = ( !(prmJson.Contenedor == undefined) ) ? prmJson.Contenedor : "divSerieAlmacenUbicacionListado";
        var intLot_ID = ( !(prmJson.Lot_ID == undefined) ) ? prmJson.Lot_ID : -1;

        $.ajax({
              url: urlBaseInventario + "Inventario_ajax.asp"
            , method: "post"
            , async: false
            , data: {
                  Tarea: 1100
                , Lot_ID: intLot_ID
            }
            , success: function(res){
                $("#" + strContenedor).html(res);
            }
        });
    }
    , SerieActualListadoCargar: function(){
        var prmJson = (!(arguments[0] == undefined )) ? arguments[0] : {};
        
        var strContenedor = ( !(prmJson.Contenedor == undefined) ) ? prmJson.Contenedor : "divSerieActualListado";
        var intUbi_ID = ( !(prmJson.Ubi_ID == undefined) ) ? prmJson.Ubi_ID : -1;
        var intPT_ID = ( !(prmJson.PT_ID == undefined) ) ? prmJson.PT_ID : -1;

       $.ajax({
            url: urlBaseInventario + "Inventario_ajax.asp"
          , method: "post"
          , async: false
          , data: {
                Tarea: 1001
              , Ubi_ID: intUbi_ID
              , PT_ID: intPT_ID
          }
          , success: function(res){
              $("#" + strContenedor).html(res);
          }
      });
    }
}