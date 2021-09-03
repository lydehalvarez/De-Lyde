var Cliente = {
    ComboCargar: function(){
        $.ajax({
              url: urlBase + "OrdenSurtido_ajax.asp"
            , method: "post"
            , async: false
            , data: {
                Tarea: 100
            }
            , success: function(res){
                $("#selCliente").html(res);
            }
        });
    }
}

var Catalogo = {
    ComboCargar: function( prmIntSec_ID ){
        
        var intSec_ID = prmIntSec_ID;
        
        $.ajax({
            url: urlBase + "OrdenSurtido_ajax.asp"
          , method: "post"
          , async: false
          , data: {
              Tarea: 900
              , Sec_ID: intSec_ID
          }
          , success: function(res){
              $("#selEstatus").html(res);
          }
      });
    }
}

var Inventario = {
    SeriesTotalBuscar: function(){
        //extraer el numero de serie
        //Extraer el tipo de busqueda


        //Buscar el total del último de registro por FIFO

    }
}

var Ubicacion = {
    ComboCargar: function( prmSelUbicacion ){
        $.ajax({
            url: urlBase + "OrdenSurtido_ajax.asp"
          , method: "post"
          , async: false
          , data: {
              Tarea: 200
          }
          , success: function(res){
              $("#" + prmSelUbicacion).html(res);
              //$("#" + prmSelUbicacion).select2();
          }
      });
    }
}

var RecepcionSeries = {
    ListadoCargar: function( prmIntUbi_Id ){

        var intUbi_ID = prmIntUbi_Id;

        $.ajax({
              url: urlBase + "OrdenSurtido_ajax.asp"
            , method: "post"
            , data: {
                  Tarea: 300
                , Ubi_ID: intUbi_ID
            }
            , success: function(res){
                $("#divDetalle").show();
                $("#divRecepcionSeries").html(res);
            }
        });

    }
}

var OrdenSurtido = {
    Ver: function( prmIntIORS_ID ){
        OrdenSurtido.ModalSurtidoAbrir(prmIntIORS_ID);
    }
    , Crear: function(){
        OrdenSurtido.ModalEdicionAbrir();  
    }
    , Editar: function(prmIntIORS_ID){
        
        OrdenSurtido.ModalEdicionAbrir();  

        var jsonRes = OrdenSurtido.ExtrarID( prmIntIORS_ID );
        
        $("#inpIORS_ID").val(jsonRes.IORS_ID);
        $("#inpProductoSKU").val(jsonRes.IORS_Folio);
        $("#inpCantidad").val(jsonRes.IORS_CantidadSolicitada);
        $("#selUbicacionDestino").val(jsonRes.UBI_ID);
        $("#chbPrioridad").prop("checked", ( parseInt(jsonRes.IORS_Prioridad) == 1 ) );

    }
    , ExtrarID: function( prmIntIORS_ID ){
        
        var jsonRes = "{}";

        $.ajax({
              url: urlBase + "OrdenSurtido_ajax.asp"
            , method: "post"
            , async: false
            , dataType: "json"
            , data: {
                  Tarea: 2
                , IORS_ID: prmIntIORS_ID
            }
            , success: function(res){
                jsonRes = res;
            }
        })

        return jsonRes;
    }
    , Guardar: function(){

        var intIORS_ID = $("#inpIORS_ID").val();
        var strProductoSKU = $("#inpProductoSKU").val();
        var intCantidad = $("#inpCantidad").val();
        var intUbi_ID = $("#selUbicacionDestino").val();
        var intPrioridad = ( $("#chbPrioridad").is(":checked") ) ? 1 : 0;
        var intIDUsuario = $("#IDUsuario").val()

        var arrError = [];
        var bolError = false;

        if( strProductoSKU == "" ){
            bolError = true;
            arrError.push("- Agregar el SKU del producto");
        }

        if( !((/^[1-9]+[0-9]*$/gm).test(intCantidad)) ){
            bolError = true;
            arrError.push("- Agregar un numero positivo");
        }

        if( intUbi_ID == "" ){
            bolError = true;
            arrError.push("- Seleccionar la Ubicacion a surtir");
        }

        if( bolError ){
            Avisa("warning", "Orden de Surtido", "Verificar el Formulario <br>" + arrError.join("<br>") );
        } else {

            $.ajax({
                  url: urlBase + "OrdenSurtido_ajax.asp"
                , method: "post"
                , async: false
                , dataType: "json"
                , data: {
                      Tarea: 2000
                    , IORS_ID: intIORS_ID
                    , ProductoSKU: strProductoSKU
                    , Cantidad: intCantidad
                    , Ubi_ID: intUbi_ID
                    , Prioridad: intPrioridad
                    , IDUsuario: intIDUsuario
                    , Est_ID: 1
                }
                , success: function(res){
                    
                    if(parseInt(res.Error.Numero) == 0){
                        Avisa("warning", "Orden de Surtido", res.Error.Descripcion );
                        OrdenSurtido.ModalEdicionLimpiar();
                        OrdenSurtido.ListadoPrincipalCargar();
                    } else {
                        Avisa("error", "Orden de Surtido", res.Error.Descripcion );
                    } 
                }
            });
        }

    
    }
    , ListadoPrincipalCargar: function(){

        var intCli_ID = $("#selCliente").val();
        var strUbi_ID = $("#selUbicacion").val();
        var strPro_SKU = $("#inpProductoSku").val();
        var intEst_ID = $("#selEstatus").val();

        $.ajax({
              url: urlBase + "OrdenSurtido_ajax.asp"
            , method: "post"
            , async: false
            , data: {
                Tarea: 1000
                , Cli_ID: intCli_ID
                , Ubi_ID: strUbi_ID
                , Pro_SKU: strPro_SKU
                , Est_ID: intEst_ID
            }
            , success: function(res){
                $("#divOrdenSurtidoTabla").html(res);
            }
        });
    }
    , ListadoPanelCargar: function(){

        var intCli_ID = $("#selCliente").val();
        var strUbi_ID = $("#selUbicacion").val();
        var strPro_SKU = $("#inpProductoSku").val();
        var intEst_ID = $("#selEstatus").val();

        $.ajax({
              url: urlBase + "OrdenSurtido_ajax.asp"
            , method: "post"
            , async: false
            , data: {
                Tarea: 1001
            }
            , success: function(res){
                $("#divOrdenSurtidoTabla").html(res);
            }
        });
    }
    , ModalEdicionAbrir: function( prmIntRac_ID ){

        if( !($("#modalOrdenSurtidoEdicion").lenght > 0) ){

            $.ajax({
                url: urlBase + "OrdenSurtido_ajax.asp"
                , method: "post"
                , async: false
                , data: {
                    Tarea: 50
                }
                , success: function(res){
                    $("#Contenido").append(res);

                    Ubicacion.ComboCargar("selUbicacionDestino");

                }
            });

        }

        OrdenSurtido.ModalEdicionLimpiar();
        $("#modalOrdenSurtidoEdicion").modal("show");       
    }
    , ModalEdicionCerrar: function(){

        OrdenSurtido.ModalEdicionLimpiar();
        $("#modalOrdenSurtidoEdicion").modal("hide");
        

    }
    , ModalEdicionLimpiar: function(){
        $("#inpIORS_ID").val("");
        $("#inpProductoSKU").val("");
        $("#inpCantidad").val("");
        $("#selUbicacionDestino").val("");
        $("#chbPrioridad").prop("checked", false);
    }
    , ModalSurtidoAbrir: function(prmIntIORS_ID, prmIntIORS_Cantidad){

        if( !($("#modalOrdenSurtidoSurtido").lenght > 0) ){
            $.ajax({
                url: urlBase + "OrdenSurtido_ajax.asp"
                , method: "post"
                , async: false
                , data: {
                    Tarea: 55
                }
                , success: function(res){
                    $("#Contenido").append(res);
                }
            });
        }

        $("#inpSurtidoIORS_ID").val(prmIntIORS_ID);
        $("#labelTotalSolicitado").text(prmIntIORS_Cantidad);

        $("#modalOrdenSurtidoSurtido").modal("show");

    }
    , ModalSurtidonCerrar: function(){

        OrdenSurtido.ModalSurtidoLimpiar();
        $("#modalOrdenSurtidoSurtido").modal("hide");

    }
    , ModalSurtidoLimpiar: function(){
        
        $("#inpSurtidoIORS_ID").val("");
        $("#labelTotalSolicitado").text("0");
        $("#labelTotalApartado").text("0");
        $("#labelTotalFaltante").text("0");
       
        OrdenSurtido.ModalSurtidoFormularioLimpiar();
     
    }
    , ModalSurtidoFormularioLimpiar: function(){
        
        $("#inpSurtidoSerie").val("");
        $("input[name=optSerieBuscar]").prop("checked",false);
     
    }
}

var OrdenSurtidoCorte = {
    Seleccionar: function(){

        var bolSel = $("#chbSeleccionarTodos").is(":checked");

        $(".clsOrdenSurtido").prop("checked", bolSel);
    
    }
    , Crear: function(){

        var bolError = false;
        var arrError = [];
        var arrOrdSur = [];
        var bolHay = false;

        $(".clsOrdenSurtido").each(function(){
            
            if( $(this).is(":checked") ){
                arrOrdSur.push($(this).val());
                bolHay = true;
            }

        });

        if( !(bolHay) ){
            arrError.push("Seleccionar la Orden de Suertido");
            bolError = true;
        }

        if( bolError ){
            Avisa("warning", "Ordenes de Surtido", "Seleccionar las ordenes para surtir");
        } else {
            
            var intIDUsuario = $("#IDUsuario").val();

            $.ajax({
                  url: urlBase + "OrdenSurtido_ajax.asp"
                , method: "post"
                , async: false
                , dataType: "json"
                , data: {
                      Tarea: 2100
                    , IDUsuario: intIDUsuario
                    , IORS_IDs: arrOrdSur.join(",")
                }
                , success: function(res){
                    if( parseInt(res.Error.Numero) == 0 ){
                        Avisa("success", "Ordenes de Surtido", res.Error.Descripcion );
                        OrdenSurtido.ListadoPrincipalCargar();

                    } else {
                        Avisa("warning", "Ordenes de Surtido", res.Error.Descripcion);
                    }
                }
            });

        }

    }
    , ListadoPrincipalCargar: function(){
        $.ajax({
            url: urlBase + "OrdenSurtido_ajax.asp"
          , method: "post"
          , async: false
          , dataType: "json"
          , data: {
                Tarea: 2100
          }  
          , success: function(res){
             $("#divOrdenSurtidoCorteTabla").html(res);
          }
      });
    }
}