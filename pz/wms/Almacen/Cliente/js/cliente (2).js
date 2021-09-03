var urlBaseCliente = "/pz/wms/Almacen/Cliente/"

var Cliente = {
    ComboCargar: function(){

        var prmJson = (!(arguments[0] == undefined )) ? arguments[0] : {};

        var strContenedor = ( !(prmJson.Contenedor == undefined) ) ? prmJson.Contenedor : "selCliente";
        var UsaNotaEntrada = ( !(prmJson.UsaNotaEntrada ==  undefined) ) ? prmJson.UsaNotaEntrada : -1;
        var Habilitado = ( !(prmJson.Habilitado ==  undefined) ) ? prmJson.Habilitado : -1;


        $.ajax({
              url: urlBaseCliente + "Cliente_ajax.asp"
            , method: "post"
            , async: false
            , data: {
                Tarea: 100
                , UsaNotaEntrada: prmJson.UsaNotaEntrada
                , Habilitado: prmJson.Habilitado
            }
            , success: function(res){
                $("#" + strContenedor).html(res);
            }
        });
    }
}