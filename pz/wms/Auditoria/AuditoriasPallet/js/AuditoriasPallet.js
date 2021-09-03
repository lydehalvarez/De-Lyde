var AuditoriasPallet = {
      url: "/pz/wms/Auditoria/AuditoriasPallet/"
    ,  ListadoCargar: function(){

        var intUsu_ID = $("#Usu_ID").val();
        var intPt_EstatusCG146 = $("#selAAABEstatus").val();
        var intUbi_ID = $("#selAAABUbicacion").val();

        Cargando.Iniciar();

        $.ajax({
              url: AuditoriasPallet.url + "AuditoriasPallet_AuditorAuditorias_Listado.asp"
            , method: "post"
            , async: true
            , data: {
                  Usu_ID: intUsu_ID
                , Pt_EstatusCG146: intPt_EstatusCG146
                , Ubi_ID: intUbi_ID
            }
            , success: function( res ){
                $("#divAAABListado").html( res );
                Cargando.Finalizar();
            }
        });

    }
    , UbicacionComboCargar: function(){
        var prmJson = ( !(arguments[0] == undefined) ) ? arguments[0] : {};

        var strContenedor = ( !(prmJson.Contenedor == undefined) ) ? prmJson.Contenedor : "selUbicacionAuditoria";
        var intUsu_ID = ( !(prmJson.Usu_ID == undefined) ) ? prmJson.Usu_ID : -1;

        $.ajax({
            url: AuditoriasPallet.url + "AuditoriasPallet_AuditorAuditorias_ajax.asp"
            , method: "post"
            , async: true
            , data: {
                Tarea: 101
                , Usu_ID: intUsu_ID
            }
            , success: function( res ){
                $("#" + strContenedor).html(res);
            }
        })

    }
}
