var urlBaseIncidencia = "pz/wms/Incidencias/"

var Incidencia = {
  GeneralModalAbrir: function(){

  //  if( $("#mdlIncGeneral").length == 0 ){
      $.ajax({
        url: urlBaseIncidencia + "Incidencias_Modal.asp"
        , method: "post"
        , async: false
        , data: {
          Tarea: 700
        }
        , success: function(res){
          $("#Contenido").append(res);
        }
      });

//      Catalogo.ComboCargar({
//        SEC_ID: 66
//        , Contenedor: "selTipoIncidencia"
//      });

  //  }

    $("#mdlIncidencias").modal("show");
  }
  , GeneralModalCerrar: function(){
    $("#mdlIncidencias").modal("hide");
  }
  
}