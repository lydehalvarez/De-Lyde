var urlBaseIncidencia = "pz/wms/Incidencias/Incidencia/"

var Incidencia = {
  GeneralModalAbrir: function(){

    if( $("#mdlIncGeneral").length == 0 ){
      $.ajax({
        url: urlBaseIncidencia + "incidencia_ajax.asp"
        , method: "post"
        , async: false
        , data: {
          Tarea: 700
        }
        , success: function(res){
          $("#Contenido").append(res);
        }
      });

      Catalogo.ComboCargar({
        SEC_ID: 66
        , Contenedor: "selTipoIncidencia"
      });

    }

    $("#mdlIncGeneral").modal("show");
  }
  , GeneralModalCerrar: function(){
    $("#mdlIncGeneral").modal("hide");
  }
  
}