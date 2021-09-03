var urlBaseOrdenMovimientoCorte = "/pz/wms/Almacen/OrdenMovimientoCorte/"

var OrdenMovimientoCorte = {
    Seleccionar: function(){

        var bolSel = $("#chbSeleccionarTodos").is(":checked");

        $(".clsOrdenMovimiento").prop("checked", bolSel);
    
    }
    , Crear: function(){

        var prmJson = ( !(arguments[0] == undefined) ) ? arguments[0] : {};
        var intTipo = ( !(prmJson.Tipo == undefined) ) ? prmJsoin.Tipo : OrdenMovimiento.Tipo.Surtido;

        var bolError = false;
        var arrError = [];
        var arrOrdSur = [];
        var bolHay = false;

        var intIDUsuario = $("#IDUsuario").val();

        $(".clsOrdenMovimiento").each(function(){
            
            if( $(this).is(":checked") ){
                arrOrdSur.push($(this).val());
                bolHay = true;
            }

        });

        if( !(bolHay) ){
            arrError.push("Seleccionar la Orden de Suertido");
            bolError = true;
        }

        if( bolError ){
            Avisa("warning", "Ordenes de Surtido", "Verificar Formulario<br>" + arrError.join("<br>"));
        } else {
            
            $.ajax({
                  url: urlBaseOrdenMovimientoCorte + "OrdenMovimientoCorte_ajax.asp"
                , method: "post"
                , async: false
                , dataType: "json"
                , data: {
                      Tarea: 2000
                    , IDUsuario: intIDUsuario
                    , IOM_IDs: arrOrdSur.join(",")
                }
                , success: function(res){
                    if( parseInt(res.Error.Numero) == 0 ){
                        Avisa("success", "Ordenes de Surtido", res.Error.Descripcion );

                        OrdenMovimientoCorte.OrdenMovimientoListadoCargar({Tipo: intTipo});

                    } else {
                        Avisa("warning", "Ordenes de Surtido", res.Error.Descripcion);
                    }
                }
            });

        }

    }
    , ListadoPrincipalCargar: function(){
        $.ajax({
            url: urlBaseOrdenMovimientoCorte + "OrdenMovimientoCorte_ajax.asp"
          , method: "post"
          , async: false
          , data: {
                Tarea: 1000
          }  
          , success: function(res){
             $("#divOrdenMovimientoCorteListadoTabla").html(res);
          }
      });
    }

    , OrdenMovimientoListadoCargar: function(){
        var prmJson = ( !(arguments[0] == undefined) ) ? arguments[0] : {};
        var intTipo = ( !(prmJson.Tipo == undefined) ) ? prmJson.Tipo : OrdenMovimiento.Tipo.Surtido;

        switch(parseInt(intTipo)){
            case OrdenMovimiento.Tipo.Estatus:{
                OrdenMovimientoPorEstatus.ListadoPrincipalCargar();
            } break;
        }
    }

}