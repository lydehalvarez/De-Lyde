var urlBaseCatalogo = "pz/wms/Almacen/Catalogo/"

var Catalogo = {
    ComboCargar: function(){

        var prmJson = (!(arguments[0] == undefined )) ? arguments[0] : {};

        var strContenedor = ( !(prmJson.Contenedor == undefined) ) ? prmJson.Contenedor : "selCatalogo"
        var intSec_ID = ( !(prmJson.SEC_ID == undefined) ) ? prmJson.SEC_ID : -1;
        var intCat_ID = ( !(prmJson.CAT_ID == undefined) ) ? prmJson.CAT_ID : -1;
        var intCat_Tipo = ( !(prmJson.CAT_Tipo == undefined) ) ? prmJson.CAT_Tipo : -1;
        var intCat_Maximo = ( !(prmJson.Cat_Maximo == undefined) ) ? prmJson.Cat_Maximo : -1;
        var strCat_IDs = ( !(prmJson.CAT_IDs == undefined) ) ? prmJson.CAT_IDs: "";

        $.ajax({
              url: urlBaseCatalogo + "catalogo_ajax.asp"
            , method: "post"
            , async: true
            , data: {
                Tarea: 100
                , Sec_ID: intSec_ID
                , Cat_ID: intCat_ID
                , Cat_Tipo: intCat_Tipo
                , Cat_Maximo: intCat_Maximo
                , Cat_IDs: strCat_IDs
            }
             , success: function(res){
                $("#" + strContenedor).html(res);
            }
        });
    }
}