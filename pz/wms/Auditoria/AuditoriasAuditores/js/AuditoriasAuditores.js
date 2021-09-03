var AuditoriasAuditores = {
      url: "/pz/wms/Auditoria/AuditoriasAuditores/"
    , ComboCargar: function(){

        var prmJson = (!(arguments[0] == undefined )) ? arguments[0] : {};

        var strContenedor = ( !(prmJson.Contenedor == undefined) ) ? prmJson.Contenedor : "selAuditoriasAuditores";
        var intAud_Habilitado = ( !(prmJson.Aud_Habilitado ==  undefined) ) ? prmJson.Aud_Habilitado : -1;
        var intAud_Externo = ( !(prmJson.Aud_Externo ==  undefined) ) ? prmJson.Aud_Externo : -1;

        $.ajax({
              url: AuditoriasAuditores.url + "AuditoriasAuditores_ajax.asp"
            , method: "post"
            , async: true
            , data: {
                Tarea: 100
                , Aud_Habilitado: intAud_Habilitado
                , Aud_Externo: intAud_Externo
            }
            , success: function(res){
                $("#" + strContenedor).html(res);
            }
        });
    }
}