var urlBaseManifiestoDevolucion = "/pz/wms/Devolucion/ManifiestoDevolucion/";

var ManifiestoDevolucion = {
    DecisionCancelacionModalAbrir: function(){
        
        var jsonPrm = ( !(arguments[0] == undefined) ) ? arguments[0] : {};
        var intTA_ID = ( !(jsonPrm.TA_ID == undefined) ) ? jsonPrm.TA_ID : -1;
        var intOV_ID = ( !(jsonPrm.OV_ID == undefined) ) ? jsonPrm.OV_ID : -1;

        if( $("#mdlManDCancelacion").length == 0 ){

            $.ajax({
                url: urlBaseManifiestoDevolucion + "ManifiestoDevolucion_Decision_ajax.asp"
                , method: "post"
                , async: false
                , data: {
                    Tarea: 500
                }
                , success: function(res){
                    $("#wrapper").append(res);
                }
            })
        }

        this.DecisionCancelacionModalFormularioLimpiar();

        $("#mdlManDCancelacion").modal("show");

        $("#hidMdlManDTA_ID").val(intTA_ID);
        $("#hidMdlManDOV_ID").val(intOV_ID);
    }
    , DecisionCancelacionModalCerrar: function(){

        this.DecisionCancelacionModalFormularioLimpiar();
        $("#mdlManDCancelacion").modal("hide");

    }
    , DecisionCancelacionModalFormularioLimpiar: function(){

        $("#hidMdlManDTA_ID").val("");
        $("#hidMdlManDOV_ID").val("");
        $("#txaMdlManDMotivoCancelacion").val("");

    }
    , DecisionCancelar: function(){

        var intTA_ID = $("#hidMdlManDTA_ID").val();
        var intOV_ID = $("#hidMdlManDOV_ID").val();
        var strMotivoCancelacion = $("#txaMdlManDMotivoCancelacion").val();

        var bolError = false;
        var arrError = [];

        Cargando.Iniciar();

        if( strMotivoCancelacion.trim() == "" ){
            bolError = true;
            arrError.push("- Agregar el motivo de Cancelación");
        }

        if( bolError ){
            Avisa("warning", "Devolucion Decision", "Verificar formulario<br>" + arrError.join("<br>"));
        } else {

            $.ajax({
                url: urlBaseManifiestoDevolucion + "ManifiestoDevolucion_Decision_ajax.asp"
                , method: "post"
                , async: false
                , dataType: "json"
                , data: {
                    Tarea: 3200
                    , TA_ID: intTA_ID
                    , OV_ID: intOV_ID
                    , MotivoCancelacion: strMotivoCancelacion
					,IDUsuario:$('#IDUsuario').val()
                }
                , success: function(res){
                    
                    if( res.Error.Numero == 0 ){
                        Avisa("success", "Manifiesto Devolucion", res.Error.Descripcion);

                        ManifiestoDevolucion.DecisionCancelacionModalCerrar();
                        ManifiestoDevolucion.DecisionListadoCargar();

                    } else {
                        Avisa("danger", "Manifiesto Devolucion", res.Error.Descripcion);
                    }

                }
            })
        }

        Cargando.Finalizar()

    }
    , DecisionIngresar: function(){
        
        Cargando.Iniciar();

        var jsonPrm = ( !(arguments[0] == undefined) ) ? arguments[0] : {};

        var intTA_ID = ( !(jsonPrm.TA_ID == undefined) ) ? jsonPrm.TA_ID: -1;
        var intOV_ID = ( !(jsonPrm.OV_ID == undefined) ) ? jsonPrm.OV_ID: -1;

        var bolError = false;
        var arrError = [];

        if( !(intTA_ID > -1) && !(intOV_ID > -1) ){
            bolError = true;
            arrError.push("- Seleccionar la transferencia o la orden de venta")
        }

        if( bolError ){
            Avisa("warning", "Devolucion Decisión", "- Verificar el formulario<br>" + arrError.join("<br>"));
        } else {
            
            $.ajax({
                url: urlBaseManifiestoDevolucion + "ManifiestoDevolucion_Decision_ajax.asp"
                , method: "post"
                , async: false
                , dataType: "json"
                , data: {
                    Tarea: 3201
                    , TA_ID: intTA_ID
                    , OV_ID: intOV_ID
					,IDUsuario:$('#IDUsuario').val()
                }
                , success: function(res){
                    if( res.Error.Numero == 0 ){

                        Avisa("success", "Manifiesto Devolucion", res.Error.Descripcion);
                        ManifiestoDevolucion.DecisionListadoCargar();

                    } else {
                        Avisa("danger", "Manifiesto Devolucion", res.Error.Descripcion);
                    }
                }
            });

        }
        Cargando.Finalizar();
    }
    , DecisionFallidoEnviar: function(){
        
        Cargarndo.Iniciar();

        var jsonPrm = ( !(arguments[0] == undefined) ) ? arguments[0] : {};

        var intOV_ID = ( !(jsonPrm.OV_ID == undefined) ) ? jsonPrm.OV_ID: -1;

        var bolError = false;
        var arrError = [];

        if( !(intOV_ID > -1) ){
            bolError = true;
            arrError.push("- Seleccionar la orden de venta")
        }

        if( bolError ){
            Avisa("warning", "Devolucion Decisión", "- Verificar el formulario<br>" + arrError.join("<br>"));
        } else {
            
            $.ajax({
                url: urlBaseManifiestoDevolucion + "ManifiestoDevolucion_Decision_ajax.asp"
                , method: "post"
                , async: false
                , dataType: "json"
                , data: {
                    Tarea: 3202
                    , OV_ID: intOV_ID
					,IDUsuario:$('#IDUsuario').val()
                }
                , success: function(res){
                    if( res.Error.Numero == 0 ){

                        Avisa("success", "Manifiesto Devolucion", res.Error.Descripcion);
                        ManifiestoDevolucion.DecisionListadoCargar();

                    } else {
                        Avisa("danger", "Manifiesto Devolucion", res.Error.Descripcion);
                    }
                }
            });

        }
        Cargando.Finalizar();
    }
    , DecisionListadoCargar: function(){
        Cargando.Iniciar()

        var strFolio = $("#inpTAOVFolio").val();
        var intProv_ID = $("#selProveedor").val();
        var dateFecIni = $("#inpManDFechaInicial").val();
        var dateFecFin = $("#inpManDFechaFinal").val();
        var strManDFolio = $("#inpManDFolio").val();
        var intCli_ID = $("#selCliente").val()

        $.ajax({
            url: urlBaseManifiestoDevolucion + "ManifiestoDevolucion_Decision_ajax.asp"
            , method: "post"
            , async: false
            , data: {
                Tarea: 1100
                , Folio: strFolio
                , Prov_ID: intProv_ID
                , FechaInicial: dateFecIni
                , FechaFinal: dateFecFin
                , ManifiestoFolio: strManDFolio
                , Cli_ID: intCli_ID
            }
            , success: function(res){
                $("#divManDListado").html(res);
                ManifiestoDevolucion.LateralLimpiar();
            }
        })

        Cargando.Finalizar();
    }
    , DetalleCargar: function(){
        
        Cargando.Iniciar();

        var prmJson = ( !(arguments[0] == undefined) ) ? arguments[0] : {};
        var intTA_ID = ( !(prmJson.TA_ID == undefined) ) ? prmJson.TA_ID : -1;
        var intOV_ID = ( !(prmJson.OV_ID == undefined) ) ? prmJson.OV_ID : -1;

        $.ajax({
            url: urlBaseManifiestoDevolucion + "ManifiestoDevolucion_Decision_ajax.asp"
            , method: "post"
            , async: false
            , data: {
                Tarea: 1110
                , TA_ID: intTA_ID
                , OV_ID: intOV_ID
            }
            , success: function(res){
                $("#divLateral").html(res);
            }
        })

        Cargando.Finalizar();
    }
    , LateralLimpiar: function(){
        $("#divLateral").html("");
    }
}