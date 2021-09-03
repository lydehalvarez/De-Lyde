var urlBaseProveedor = "/pz/wms/devolucion/Proveedor/"

var Proveedor = {
    ComboCargar: function(){
        var prmJson = (!(arguments[0] == undefined )) ? arguments[0] : {};

        var strContenedor = ( !(prmJson.Contenedor == undefined) ) ? prmJson.Contenedor : "selProveedor"; 

        $.ajax({
            url: urlBaseProveedor + "proveedor_ajax.asp"
            , method: "post"
            , async: false
            , data: {
                Tarea: 100
            }
            , success: function(res){
              $("#" + strContenedor).html(res);
            }
       });
    }
}