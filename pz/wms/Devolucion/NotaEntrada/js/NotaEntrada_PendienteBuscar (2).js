var NotaEntradaPendienteBuscar = {
      urlBase: "/pz/wms/Devolucion/NotaEntrada/"
    ,ListadoCargar: function(){
		$('#loading').show('slow');
		$("#divNEPBListado").hide('slow')
        //Cargando.Iniciar();
        
        var strFolio = $("#inpNEPBTAOVFolio").val();
        var strPro_Sku = $("#inpNEPBPro_SKU").val();
        var intCli_ID = $("#Cli_ID").val();
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
                ,method: "post"
                ,async: true
				,cache:false
                ,data: {
                    Folio: strFolio.replace("'","-")
                    , Pro_SKU: strPro_Sku
                    , Cli_ID: intCli_ID
                    , FechaInicial: dateFechaInicial
                    , FechaFinal: dateFechaFinal
                }, success: function(res){
					$('#loading').hide('slow');
                    $("#divNEPBListado").html(res);
					$("#divNEPBListado").show('slow');
				}
            });
        
        }

        //Cargando.Finalizar();

    }
}