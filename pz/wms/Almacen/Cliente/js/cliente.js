var urlBaseCliente = "/pz/wms/Almacen/Cliente/"

var Cliente = {
    ComboCargar: function(){

        var prmJson = (!(arguments[0] == undefined )) ? arguments[0] : {};

        var strContenedor = ( !(prmJson.Contenedor == undefined) ) ? prmJson.Contenedor : "selCliente";
        var bolUsaNotaEntrada = ( !(prmJson.UsaNotaEntrada ==  undefined) ) ? prmJson.UsaNotaEntrada : -1;

        $.ajax({
              url: urlBaseCliente + "Cliente_ajax.asp"
            , method: "post"
            , async: false
            , data: {
                Tarea: 100
                , UsaNotaEntrada: bolUsaNotaEntrada
            }
            , success: function(res){
                $("#" + strContenedor).html(res);
            }
        });
    }
}