var urlBaseAsn = "/pz/wms/Recepcion/ASN/"

var ASN = {
      Extraer: function(){

    }
    , ExtraerID: function(){
    
    }
    , DetalleVer: function(){
        
        var prmJson = ( !(arguments[0] == undefined) ) ? arguments[0] : {};

        var strASN_ID = ( !(prmJson.ASN_ID == undefined ) ) ? prmJson.ASN_ID : -1;

        if( $("#mdlASNDetalle").length == 0 ){
            $.ajax({
                  url: urlBaseAsn + "ASN_ajax.asp"
                , method: "post"
                , async: false
                , data: {
                      Tarea: 100 // Modal de Seleccion avanzada
                }
                , success: function(res){
                    $("#wrapper").append(res);
                }
            });
        }
        
        this.SeleccionAvanzadaModalLimpiar();

        $("#mdlUbiSeleccionAvanzada").modal('show');
    }
    , DetalleModalAbrir: function(){

    }
    , DetalleModalCerrar: function(){

    }
}