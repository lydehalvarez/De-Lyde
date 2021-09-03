var NotaEntradaPendienteBuscar = {
      urlBase: "/pz/wms/Devolucion/NotaEntrada/"
    , ListadoCargar: function(){

        Cargando.Iniciar();
        
        var strFolio = $("#inpNEPBTAOVFolio").val();
        var strPro_Sku = $("#inpNEPBPro_SKU").val();
        var intCli_ID = $("#selNEPBCliente").val();
        var dateFechaInicial = $("#inpNEPBFechaInicial").val();
        var dateFechaFinal = $("#inpNEPBFechaFinal").val();

        var bolError = false;
        var arrError = [];

        if( strFolio.trim() == "" && strPro_Sku.trim() == "" && !( intCli_ID > -1 ) ){
            arrError.push("Seleccionar algún Filtro");
            bolError = false;
        }

        if( bolError ){
            Avisa("warning", "Buscar", arrError.join("<br>"));
        } else {

            $.ajax({
                url: NotaEntradaPendienteBuscar.urlBase + "NotaEntrada_PendienteListado.asp"
                , method: "post"
                , async: false
                , data: {
                    Folio: strFolio
                    , Pro_SKU: strPro_Sku
                    , Cli_ID: intCli_ID
                    , FechaInicial: dateFechaInicial
                    , FechaFinal: dateFechaFinal
                }
                , success: function(res){
                    $("#divNEPBListado").html(res);
                }
            });
        
        }

        Cargando.Finalizar();

    }
}