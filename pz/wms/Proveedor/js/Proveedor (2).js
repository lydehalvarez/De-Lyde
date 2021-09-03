var urlBaseCliente = "/pz/wms/Almacen/Cliente/"

var Proveedor = {
    url: "/pz/wms/Proveedor/"
    , ComboCargar: function(){

        var prmJson = ( !(arguments[0] == undefined )) ? arguments[0] : {};
        var intOpcionEsVisible = ( !( prmJson.OpcionEsVisible == undefined )) ? prmJson.OpcionEsVisible : -1;
        var strOpcionValor = ( !( prmJson.OpcionValor == undefined )) ? prmJson.OpcionValor : "";
        var strOpcionTexto = ( !( prmJson.OpcionTexto == undefined )) ? prmJson.OpcionTexto : "";

        var intProv_EsPaqueteria = ( !( prmJson.Prov_EsPaqueteria == undefined )) ? prmJson.Prov_EsPaqueteria : -1;
        var intProv_Habilitado = ( !( prmJson.Prov_Habilitado == undefined )) ? prmJson.Prov_Habilitado : "";

        var strContenedor = ( !(prmJson.Contenedor == undefined) ) ? prmJson.Contenedor : "selProveedor";

        $.ajax({
              url: Proveedor.url + "Proveedor_ajax.asp"
            , method: "post"
            , async: true
            , data: {
                Tarea: 100
                , Prov_EsPaqueteria: intProv_EsPaqueteria
                , Prov_Habilitado: intProv_Habilitado
                , OpcionEsVisible: intOpcionEsVisible
                , OpcionValor: strOpcionValor
                , OpcionTexto: strOpcionTexto
            }
            , success: function(res){
                $("#" + strContenedor).html(res);
            }
        });
    }
}