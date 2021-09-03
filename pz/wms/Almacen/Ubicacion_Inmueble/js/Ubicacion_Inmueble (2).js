var urlBaseUbicacionInmueble = "/pz/wms/Almacen/Ubicacion_Inmueble/"

var UbicacionInmueble = {
    ComboCargar: function(){
        
        var prmJson = ( !(arguments[0] == undefined) ) ? arguments[0] : {};

        var strContenedor = ( !(prmJson.Contenedor == undefined) ) ? prmJson.Contenedor : "selUbicacionInmueble";

        $.ajax({
            url: urlBaseUbicacionInmueble + "Ubicacion_Inmueble_ajax.asp"
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
