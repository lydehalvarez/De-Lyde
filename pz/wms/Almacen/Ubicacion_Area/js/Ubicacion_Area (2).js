var urlBaseUbicacionArea = "/pz/wms/Almacen/Ubicacion_Area/"

var UbicacionArea = {
    ComboCargar: function(){
        
        var prmJson = ( !(arguments[0] == undefined) ) ? arguments[0] : {};

        var strContenedor = ( !(prmJson.Contenedor == undefined) ) ? prmJson.Contenedor : "selUbicacionArea";

        $.ajax({
            url: urlBaseUbicacionArea + "Ubicacion_Area_ajax.asp"
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
