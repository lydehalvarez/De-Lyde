var UbicacionConfiguracion = {
    UrlBase: "/pz/wms/Almacen/Ubicacion/"
    , ListadoCargar: function(){

        var intInm_ID = $("#selUbicacionInmueble").val(); 
        var intAre_ID = $("#selUbicacionArea").val(); 
        var intTRa_ID = $("#selTipoRack").val(); 
        var intRac_ID = $("#selUbicacionRack").val(); 

        $.ajax({
              url: UbicacionConfiguracion.UrlBase + "UbicacionConfiguracion_ajax.asp"
            , method: "post"
            , async: true
            , data: {
                  Tarea: 1000
                , Inm_ID: intInm_ID
                , Are_ID: intAre_ID
                , TRa_ID: intTRa_ID
                , Rac_ID: intRac_ID
            }
            , success: function(res){
                $("#divUbiConfTabla").html(res);
            }
        });

        this.LateralOcultar(); 
    }
    , LateralOcultar: function(){
        $("#divLateral").hide();
    }
    , LateralVisualizar: function(){
        $("#divLateral").show();
    }
}