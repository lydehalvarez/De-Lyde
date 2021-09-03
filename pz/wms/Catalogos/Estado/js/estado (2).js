var urlBaseEstado = "/pz/wms/Catalogos/Estado/"

var Estado = {
    ComboCargar: function(){

        var prmJson = (!(arguments[0] == undefined )) ? arguments[0] : {};

        var strOpcionDefaultValor = ( !(prmJson.OpcionDefaultValor == undefined) ) ? prmJson.OpcionDefaultValor : "";
        var strOpcionDefaultTexto = ( !(prmJson.OpcionDefaultTexto == undefined) ) ? prmJson.OpcionDefaultTexto : "TODOS";
        var bolOpcionDefaultEsVisible = ( !(prmJson.OpcionDefaultEsVisible == undefined) ) ? prmJson.OpcionDefaultEsVisible : 1;
        var strContenedor = ( !(prmJson.Contenedor == undefined) ) ? prmJson.Contenedor : "selEstado"; 

        $.ajax({
            url: urlBaseEstado + "Estado_ajax.asp"
          , method: "post"
          , async: false
          , data: {
              Tarea: 100
            , OpcionDefaultValor: strOpcionDefaultValor
            , OpcionDefaultTexto: strOpcionDefaultTexto
            , OpcionDefaultEsVisible: bolOpcionDefaultEsVisible
          }
          , success: function(res){
              $("#" + strContenedor).html(res);
          }
      });
    }
}