var urlBaseProducto = "/pz/wms/Almacen/Producto/"

var Producto = {
    ComboCargar: function(){
        
        var prmJson = ( !(arguments[0] == undefined) ) ? arguments[0] : {};

        var strContenedor = ( !(prmJson.Contenedor == undefined) ) ? prmJson.Contenedor : "selProducto";

        $.ajax({
            url: urlBaseProducto + "Producto_ajax.asp"
            , method: "post"
            , async: false
            , data: {
                Tarea: 100
            }
            , success: function(res){
                $("#" + strContenedor).html(res);
            }
        })
    }
}
