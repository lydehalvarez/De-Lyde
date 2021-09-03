var urlBaseUbicacionRack = "/pz/wms/Almacen/Ubicacion_Rack/"

var UbicacionRack = {
    BusquedaListadoCargar: function(){

        var intInm_ID = $("#selUbicacionInmueble").val(); 
        var intAre_ID = $("#selUbicacionArea").val(); 
        var intTRa_ID = $("#selTipoRack").val(); 
        var intUbi_ID = $("#selUbicacion").val(); 

        $.ajax({
              url: urlBaseUbicacionRack + "Ubicacion_Rack_ajax.asp"
            , method: "post"
            , async: false
            , data: {
                  Tarea: 1001
                , Inm_ID: intInm_ID
                , Are_ID: intAre_ID
                , TRa_ID: intTRa_ID
                , Ubi_ID: intUbi_ID
            }
            , success: function(res){
                $("#divDetalle").hide();
                $("#divUbicacionRackTabla").html(res);
            }
        });

        this.LateralOcultar();
    }
    , ComboCargar: function(){

        var prmJson = (!(arguments[0] == undefined )) ? arguments[0] : {};

        var strContenedor = ( !(prmJson.Contenedor == undefined) ) ? prmJson.Contenedor : "selUbicacionRack"; 
        var intHabilitado = ( !(prmJson.Habilitado == undefined) ) ? prmJson.Habilitado : -1; 

       $.ajax({
            url: urlBaseUbicacionRack + "Ubicacion_Rack_ajax.asp"
          , method: "post"
          , async: false
          , data: {
              Tarea: 100
            , Habilitado: intHabilitado
          }
          , success: function(res){
              $("#" + strContenedor).html(res);
          }
      });
    }
    , Crear: function(){
        this.EdicionModalAbrir();
    }
    , Editar: function(){
        var prmJson = ( !(arguments[0] == undefined) ) ? arguments[0] : {};

        var intRac_ID = ( !(prmJson.Rac_ID == undefined) ) ? prmJson.Rac_ID : -1;

        this.EdicionModalAbrir();

        var prmJsonRes = this.Extraer({Rac_ID: intRac_ID}).Registros[0];

        $("#hidRac_ID").val(prmJsonRes.Rac_ID);
        $("#selUbicacionRackInmueble").val(prmJsonRes.Inm_ID);
        $("#selUbicacionRackArea").val(prmJsonRes.Are_ID);
        $("#inpUbicacionRackNombre").val(prmJsonRes.Rac_Nombre);
        $("#inpUbicacionRackPrefijo").val(prmJsonRes.Rac_Prefijo);
        $("#inpUbicacionRackSecciones").val(prmJsonRes.Rac_Secciones);
        $("#inpUbicacionRackNiveles").val(prmJsonRes.Rac_Niveles);
        $("#inpUbicacionRackProfundidad").val(prmJsonRes.Rac_PosicionesProfundidad);
        $("#inpUbicacionRackPosiciones").val(prmJsonRes.Rac_PosicionesFrontales);
        $("#inpUbicacionRackAncho").val(prmJsonRes.Rac_Ancho);
        $("#inpUbicacionRackLargo").val(prmJsonRes.Rac_Largo);
        $("#inpUbicacionRackAlto").val(prmJsonRes.Rac_Alto);
        $("#selUbicacionRackTipo").val(prmJsonRes.Rac_TipoCG92);
        $("#chbUbicacionRackHabilitado").prop("checked", ( parseInt(prmJsonRes.Rac_Habilitado) == 1 ));

        if( parseInt(prmJsonRes.Rac_HayOcupados) == 1){
            $("#inpUbicacionRackSecciones").prop("disabled", true);
            $("#inpUbicacionRackNiveles").prop("disabled", true);
            $("#inpUbicacionRackProfundidad").prop("disabled", true);
            $("#inpUbicacionRackPosiciones").prop("disabled", true);
            $("#iUbicacionRackHayOcupados").show();
        }
    }
    , EdicionModalAbrir(){

        if( $("#modalUbicacionRackEdicion").length == 0 ){
            $.ajax({
                  url: urlBaseUbicacionRack + "Ubicacion_Rack_ajax.asp"
                , method: "post"
                , async: false
                , data: {
                      Tarea: 190 /* Modal de Edicion*/
                }
                , success: function(res){
                    $("#wrapper").append(res);
                    
                }
            });
        }

        this.EdicionModalLimpiar();

        $("#modalUbicacionRackEdicion").modal('show');

        UbicacionInmueble.ComboCargar({Contenedor: "selUbicacionRackInmueble"});
        UbicacionArea.ComboCargar({Contenedor: "selUbicacionRackArea"});
        Catalogo.ComboCargar({
            Contenedor: "selUbicacionRackTipo"
            , SEC_ID: 92
        })
    }
    , EdicionModalCerrar: function(){
        $("#modalUbicacionRackEdicion").modal('hide');

        this.EdicionModalLimpiar()
    }
    , EdicionModalLimpiar: function(){

        $("#hidRac_ID").val("");
        $("#selUbicacionRackInmueble").val("");
        $("#selUbicacionRackArea").val("");
        $("#inpUbicacionRackNombre").val("");
        $("#inpUbicacionRackPrefijo").val("");

        $("#inpUbicacionRackSecciones").val("").prop("disabled", false);
        $("#inpUbicacionRackNiveles").val("").prop("disabled", false);
        $("#inpUbicacionRackProfundidad").val("").prop("disabled", false);
        $("#inpUbicacionRackPosiciones").val("").prop("disabled", false);

        $("#iUbicacionRackHayOcupados").hide();

        $("#inpUbicacionRackAncho").val("");
        $("#inpUbicacionRackLargo").val("");
        $("#inpUbicacionRackAlto").val("");
        $("#selUbicacionRackTipo").val("");
        $("#chbUbicacionRackHabilitado").prop("checked", false);

    }
    , Extraer: function(){
        var prmJson = ( !(arguments[0] == undefined) ) ? arguments[0] : {};

        var intRac_ID = ( !(prmJson.Rac_ID == undefined) ) ? prmJson.Rac_ID : -1;

        var prmJsonRes = {};

        $.ajax({
            url: urlBaseUbicacionRack + "Ubicacion_Rack_ajax.asp"
            , method: "post"
            , async: false
            , dataType: "json"
            , data: {
                Tarea: 1000 /* Actualizacion del Rack */
                , Rac_ID: intRac_ID
            }, success: function(res){
                prmJsonRes = res;
            }
        });

        return prmJsonRes;
    }
    , Guardar: function(){

        var bolError = false;
        var arrError = [];
        var exrNumEntPos = /^[1-9][0-9]*$/;
        var exrNumDesPos = /^[0-9]+[\.]?[0-9]*$/;

        var intRac_ID = $("#hidRac_ID").val();
        var intInm_ID = $("#selUbicacionRackInmueble").val();
        var intAre_ID = $("#selUbicacionRackArea").val();
        var strRac_Nombre = $("#inpUbicacionRackNombre").val();
        var strRac_Prefijo = $("#inpUbicacionRackPrefijo").val();
        var intRac_Secciones = $("#inpUbicacionRackSecciones").val();
        var intRac_Niveles = $("#inpUbicacionRackNiveles").val();
        var intRac_PosicionesProfundidad = $("#inpUbicacionRackProfundidad").val();
        var intRac_PosicionesFrontales = $("#inpUbicacionRackPosiciones").val();
        var intRac_Ancho = $("#inpUbicacionRackAncho").val();
        var intRac_Largo = $("#inpUbicacionRackLargo").val();
        var intRac_Alto = $("#inpUbicacionRackAlto").val();
        var intRac_TipoCG92 = $("#selUbicacionRackTipo").val();
        var bolRac_Habilitado = ($("#chbUbicacionRackHabilitado").is(":checked")) ? 1: 0;

        if( intInm_ID == "" ){
            bolError = true;
            arrError.push("- Seleccionar el inmueble");
        }

        if( intAre_ID == "" ){
            bolError = true;
            arrError.push("- Seleccionar el Area");
        }

        if( strRac_Nombre == "" ){
            bolError = true;
            arrError.push("- Agregar el Nombre del Rack");
        }
        
        if( strRac_Prefijo == "" ){
            bolError = true;
            arrError.push("- Agregar el Prefijo del Rack");
        }

        if( !(exrNumEntPos.test(intRac_Niveles)) ){
            bolError = true;
            arrError.push("- Agregar a Niveles un numero entero mayor a 0 ");
        }

        if( !(exrNumEntPos.test(intRac_Secciones)) ){
            bolError = true;
            arrError.push("- Agregar a Secciones un numero entero mayor a 0 ");
        }

        if( !(exrNumEntPos.test(intRac_PosicionesProfundidad)) ){
            bolError = true;
            arrError.push("- Agregar a la profundidad un numero entero mayor a 0 ");
        }

        if( !(exrNumEntPos.test(intRac_PosicionesFrontales)) ){
            bolError = true;
            arrError.push("- Agregar a la Posiciones un numero entero mayor a 0 ");
        }

        if( !(exrNumDesPos.test(intRac_Ancho)) ){
            bolError = true;
            arrError.push("- Agregar el Ancho un numero mayor a 0 ");
        }

        if( !(exrNumDesPos.test(intRac_Largo)) ){
            bolError = true;
            arrError.push("- Agregar el Largo un numero mayor a 0 ");
        }

        if( !(exrNumDesPos.test(intRac_Alto)) ){
            bolError = true;
            arrError.push("- Agregar el Alto un numero mayor a 0 ");
        }

        if(intRac_TipoCG92 == ""){
            bolError = true;
            arrError.push("- Seleccionar el tipo de rack ");
        }

        if(bolError){
            Avisa("warning", "Rack", "Verificar el formulario<br>" + arrError.join("<br>"));
        } else {

            $.ajax({
                url: urlBaseUbicacionRack + "Ubicacion_Rack_ajax.asp"
                , method: "post"
                , async: false
                , dataType: "json"
                , data: {
                    Tarea: 3000 /* Taraea del Rack */
                    , Rac_ID: intRac_ID
                    , Inm_ID: intInm_ID
                    , Are_ID: intAre_ID
                    , Rac_Nombre: strRac_Nombre
                    , Rac_Prefijo: strRac_Prefijo
                    , Rac_Secciones: intRac_Secciones
                    , Rac_Niveles: intRac_Niveles
                    , Rac_PosicionesProfundidad: intRac_PosicionesProfundidad
                    , Rac_PosicionesFrontales: intRac_PosicionesFrontales
                    , Rac_Ancho: intRac_Ancho
                    , Rac_Largo: intRac_Largo
                    , Rac_Alto: intRac_Alto
                    , Rac_TipoCG92: intRac_TipoCG92
                    , Rac_Habilitado: bolRac_Habilitado
                }
                , success: function(res){
                    
                    if( parseInt(res.Error.Numero) == 0 ){
                        Avisa("success", "Rack", res.Error.Descripcion);
                        
                        $("#hidRac_ID").val(res.UbicacionRack.Rac_ID)

                        UbicacionRack.BusquedaListadoCargar();
                        UbicacionRack.LateralOcultar();
                        UbicacionRack.EdicionModalCerrar();

                    } else {
                        Avisa("warning", "Rack", res.Error.Descripcion);
                    }
                }
            });
        }
    }
    , Habilitar: function(){

        var prmJson = ( !(arguments[0] == undefined) ) ? arguments[0] : {};

        var objObjeto = ( !(prmJson.Objeto == undefined) ) ? prmJson.Objeto : null;
        var intRac_ID = ( !(prmJson.Rac_ID == undefined) ) ? prmJson.Rac_ID : -1;
        var intHabilitado = ( !(prmJson.Habilitado == undefined) ) ? prmJson.Habilitado : 1;

        var bolEsHabilitado = ( intHabilitado == 1) ? 0: 1;
        var strIcono = ( intHabilitado == 0) ? "fa-toggle-on": "fa-toggle-off";
        var strTitulo = ( intHabilitado == 0) ? "Habilitado": "Deshabilitado";
        
        $.ajax({
            url: urlBaseUbicacionRack + "Ubicacion_Rack_ajax.asp"
            , method: "post"
            , async: false
            , dataType: "json"
            , data: {
                Tarea: 3000 /* Actualizacion del Rack */
                , Rac_ID: intRac_ID
                , Rac_Habilitado: bolEsHabilitado
            }
            , success: function(res){

                console.log("res.Error.Numero", res.Error.Numero)
                
                if( parseInt(res.Error.Numero) == 0 ){
                    
                    $(objObjeto)
                        .attr({
                            "onClick": "UbicacionRack.Habilitar({Objeto: $(this), Rac_ID: " + intRac_ID + ", Habilitado: " + bolEsHabilitado + "});"
                            , "title": strTitulo
                        })
                        .html("<i class='fa " + strIcono + " fa-lg'></i>");

                    Avisa("success", "Rack", res.Error.Descripcion);
                } else {
                    Avisa("warning", "Rack", res.Error.Descripcion);
                }
            }
        });
        
    }
    , LateralVisualizar: function(){
        $("#divLateral").show();
    }
    , LateralOcultar: function(){
        $("#divLateral").hide().html("");
    }
    , UbicacionNombreListadoCargar: function(){
        var prmJson = ( !(arguments[0] == undefined) ) ? arguments[0] : {};

        var intRac_ID = ( !(prmJson.Rac_ID == undefined) ) ? prmJson.Rac_ID : -1;

        Ubicacion.NombreListadoCargar({
            Contenedor: "divLateral"
            , Rac_ID: intRac_ID
        });

        this.LateralVisualizar();
    }
    
}