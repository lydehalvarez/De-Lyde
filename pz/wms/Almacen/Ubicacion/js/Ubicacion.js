var urlBaseUbicacion = "/pz/wms/Almacen/Ubicacion/"

var Ubicacion = {
	Cargando:function(){
		var Cargan = '<tr><td colspan="5">'+Global_loading+'</td></tr>'
		$("#divmdlUbiSelAvaListado").html(Cargan)
	},
    BusquedaListadoCargar: function(){

        Cargando.Iniciar();

        var intInm_ID = $("#selUbicacionInmueble").val(); 
        var intAre_ID = $("#selUbicacionArea").val(); 
        var intTRa_ID = $("#selTipoRack").val(); 
        var intRac_ID = $("#selUbicacionRack").val(); 
        var strUbi_Nombre = $("#inpUbicacion").val();
        $.ajax({
              url: urlBaseUbicacion + "Ubicacion_ajax.asp"
            , method: "post"
            , async: true
            , data: {
                  Tarea: 1100
                , Inm_ID: intInm_ID
                , Are_ID: intAre_ID
                , TRa_ID: intTRa_ID
                , Rac_ID: intRac_ID
                , Ubi_Nombre: strUbi_Nombre
            }
            , success: function(res){
                $("#divUbicacionTabla").html(res);
                Ubicacion.LateralOcultar();
            }
        });

        Cargando.Finalizar();
    }
    , DetalleVer: function(){
        Cargando.Iniciar();

        var prmJson = ( !(arguments[0] == undefined) ) ? arguments[0] : {};
        var intUbi_ID = ( !(prmJson.Ubi_ID == undefined) ) ? prmJson.Ubi_ID : -1;

        $.ajax({
            url: urlBaseUbicacion + "Ubicacion_ajax.asp"
            , method: "post"
            , async: true
            , data: {
                Tarea: 1001
                , Ubi_ID: intUbi_ID
            }
            , success: function(res){
                $("#divLateral").html(res);
            }
        })

        Cargando.Finalizar();
    }
    , ComboCargar: function(){

        var prmJson = (!(arguments[0] == undefined )) ? arguments[0] : {};

        var strContenedor = ( !(prmJson.Contenedor == undefined) ) ? prmJson.Contenedor : "selUbicacion"; 
        var intHabilitado = ( !(prmJson.Habilitado == undefined) ) ? prmJson.Habilitado : -1; 
        var intAre_ID = ( !(prmJson.Are_ID == undefined) ) ? prmJson.Are_ID : -1; 

       $.ajax({
            url: urlBaseUbicacion + "Ubicacion_ajax.asp"
          , method: "post"
          , async: true
          , data: {
              Tarea: 100
            , Habilitado: intHabilitado
            , Are_ID: intAre_ID
          }
          , success: function(res){
              $("#" + strContenedor).html(res);
          }
      });
    }
    , EdicionModalAbrir: function(){
        
        if( $("#mdlUbiEdicion").length == 0 ){
            $.ajax({
                  url: urlBaseUbicacion + "Ubicacion_ajax.asp"
                , method: "post"
                , async: true
                , data: {
                      Tarea: 190 // Modal de Edicion
                }
                , success: function(res){
                    $("#wrapper").append(res);
                }
            });

            Cliente.ComboCargar({
                Contenedor: "selMdlUbiEdiCliente"
            });   
            
            Proveedor.ComboCargar({
                Contenedor: "selMdlUbiEdiProveedor"
            })

            Estado.ComboCargar({
                Contenedor: "selMdlUbiEdiEstado"
            })

            Producto.ComboCargar({
                Contenedor: "selMdlUbiEdiProducto"
            })
        }

        this.EdicionModalLimpiar();

        $("#mdlUbiEdicion").modal('show');
    }
    , EdicionModalCerrar: function(){

        this.EdicionModalLimpiar();
        $("#mdlUbiEdicion").modal('hide');
    }
    , EdicionModalLimpiar: function(){
        $("#hidMdlUbiEdiUbi_ID").val("");

        $("#lblMdlUbiEdiInmueble").text("");
        $("#lblMdlUbiEdiArea").text("");
        $("#lblMdlUbiEdiNivel").text("");
        $("#lblMdlUbiEdiSeccion").text("");
        $("#lblMdlUbiEdiProfundidad").text("");
        $("#lblMdlUbiEdiUbicacion").text("");
        
        $("#inpMdlUbiEdiNombre").val("");
        $("#chbMdlUbiEdiHabilitado").prop("checked", false);

        $("#inpMdlUbiEdiDimFrente").val("");
        $("#inpMdlUbiEdiDimLargo").val("");
        $("#inpMdlUbiEdiDimAlto").val("");

        $("#selMdlUbiEdiABC").val("");
        $("#inpMdlUbiEdiStockMinimo").val("");
        $("#inpMdlUbiEdiStockMaximo").val("");
        $("#chbMdlUbiEdiResurtidoAutomatico").prop("checked", false);

        $("#selMdlUbiEdiCliente").val("");
        $("#selMdlUbiEdiProducto").val("");

        $("#selMdlUbiEdiEstado").val("");
        $("#selMdlUbiEdiProveedor").val("");
        $("#chbMdlUbiEdiCuarentena").prop("checked", false);
    }
    , Editar: function(){
        
        var prmJson = ( !(arguments[0] == undefined) ) ? arguments[0] : {};

        var intUbi_ID = ( !(prmJson.Ubi_ID == undefined) ) ? prmJson.Ubi_ID : -1;

        this.EdicionModalAbrir();

        var prmJsonRes = this.ExtraerID({Ubi_ID: intUbi_ID});

        $("#hidMdlUbiEdiUbi_ID").val(intUbi_ID);

        $("#lblMdlUbiEdiInmueble").text(prmJsonRes.Inm_Nombre);
        $("#lblMdlUbiEdiArea").text(prmJsonRes.Are_Nombre);
        $("#lblMdlUbiEdiNivel").text(prmJsonRes.Ubi_Nivel);
        $("#lblMdlUbiEdiSeccion").text(prmJsonRes.Ubi_Seccion);
        $("#lblMdlUbiEdiProfundidad").text(prmJsonRes.Ubi_Profundidad);
        $("#lblMdlUbiEdiUbicacion").text(prmJsonRes.Ubi_Frente);
        
        //Campos de Edición
        $("#inpMdlUbiEdiNombre").val(prmJsonRes.Ubi_Nombre);
        $("#chbMdlUbiEdiHabilitado").prop("checked", ( prmJsonRes.Ubi_Habilitado == 1 ) )

        $("#inpMdlUbiEdiDimFrente").val(prmJsonRes.Ubi_DimFrente);
        $("#inpMdlUbiEdiDimLargo").val(prmJsonRes.Ubi_DimLargo);
        $("#inpMdlUbiEdiDimAlto").val(prmJsonRes.Ubi_DimAlto);

        $("#selMdlUbiEdiABC").val((prmJsonRes.Ubi_ABC.length > 0) ? prmJsonRes.Ubi_ABC: "");
        $("#inpMdlUbiEdiStockMinimo").val(prmJsonRes.Ubi_StockMinimo);
        $("#inpMdlUbiEdiStockMaximo").val(prmJsonRes.Ubi_StockMaximo);
        $("#chbMdlUbiEdiResurtidoAutomatico").prop("checked", (prmJsonRes.Ubi_ResurtidoAutomatico == 1) );

        $("#selMdlUbiEdiCliente").val((prmJsonRes.Cli_ID > -1) ? prmJsonRes.Cli_ID : "" );
        $("#selMdlUbiEdiProducto").val(prmJsonRes.Pro_ID);

        $("#selMdlUbiEdiEstado").val((prmJsonRes.Edo_ID > -1) ? prmJsonRes.Edo_ID : "" );
        $("#selMdlUbiEdiProveedor").val((prmJsonRes.Prov_ID > -1) ? prmJsonRes.Prov_ID : "");
        $("#chbMdlUbiEdiCuarentena").prop("checked", (prmJsonRes.Ubi_EsCuarentena == 1) );
        
    }
    , Extraer: function(){
        var prmJson = ( !(arguments[0] == undefined) ) ? arguments[0] : {};

        var intUbi_ID = ( !(prmJson.Ubi_ID == undefined) ) ? prmJson.Ubi_ID : -1;

        var prmJsonRes = {};

        $.ajax({
            url: urlBaseUbicacion + "Ubicacion_ajax.asp"
            , method: "post"
            , async: true
            , dataType: "json"
            , data: {
                Tarea: 1000 /* Actualizacion de la Ubicacion */
                , Ubi_ID: intUbi_ID
            }, success: function(res){
                prmJsonRes = res;
            }
        });

        return prmJsonRes;
    }
    , ExtraerID: function(){
        var prmJson = ( !(arguments[0] == undefined) ) ? arguments[0] : {};

        var intUbi_ID = ( !(prmJson.Ubi_ID == undefined) ) ? prmJson.Ubi_ID : -1;

        var prmJsonRes = this.Extraer({Ubi_ID: intUbi_ID}).Registros[0];

        return prmJsonRes;
    }
    , Exportar: function(){
        var prmJson = ( !(arguments[0] == undefined) ) ? arguments[0] : {};
        var intUbi_ID = ( !(prmJson.Ubi_ID == undefined) ) ? prmJson.Ubi_ID : -1;
        var intAre_ID =  ( !(prmJson.Are_ID == undefined) ) ? prmJson.Are_ID: -1;
        var intPT_ID =  ( !(prmJson.PT_ID == undefined) ) ? prmJson.PT_ID: -1;

        Cargando.Iniciar();

        $.ajax({
            url: urlBaseUbicacion + "Ubicacion_ajax.asp"
            , method: "post"
            , async: true
            , dataType: "json"
            , data: {
                Tarea: 1300
                , Ubi_ID: intUbi_ID
                , Are_ID: intAre_ID
                , PT_ID: intPT_ID
            }
            , success: function( res ){
                var xlsData = XLSX.utils.json_to_sheet( res );
                var xlsBook = XLSX.utils.book_new(); 

                XLSX.utils.book_append_sheet(xlsBook, xlsData, "SeriesUbicacion");

                XLSX.writeFile(xlsBook, "SeriesUbicacion.xlsx");

                Cargando.Finalizar();
            }
            , error: function(){
                Avisa("error","Ubicacion","No se puede realizar la exportacion");
                Cargando.Finalizar();
            }
        });
    }
    , Guardar: function(){
        
        var intUbi_ID = $("#hidMdlUbiEdiUbi_ID").val();
        
        var strUbi_Nombre = $("#inpMdlUbiEdiNombre").val();
        var bolUbi_Habilitado = ( $("#chbMdlUbiEdiHabilitado").is(":checked") ) ? 1 : 0;

        var dblUbi_DimFrente = $("#inpMdlUbiEdiDimFrente").val();
        var dblUbi_DimLargo = $("#inpMdlUbiEdiDimLargo").val();
        var dblUbi_DimAlto = $("#inpMdlUbiEdiDimAlto").val();

        var strABC = $("#selMdlUbiEdiABC").val();
        var intStockMinimo = $("#inpMdlUbiEdiStockMinimo").val();
        var intStockMaximo = $("#inpMdlUbiEdiStockMaximo").val();
        var bolResurtidoAutomatico = ($("#chbMdlUbiEdiResurtidoAutomatico").prop("checked") ) ? 1 : 0;

        var intCli_ID = $("#selMdlUbiEdiCliente").val();
        var intPro_ID = $("#selMdlUbiEdiProducto").val();

        var intEdo_ID = $("#selMdlUbiEdiEstado").val();
        var intProv_ID = $("#selMdlUbiEdiProveedor").val();
        var bolEsCuarentena = ($("#chbMdlUbiEdiCuarentena").prop("checked") ) ? 1 : 0;

        var bolError = false;
        var arrError = [];

        var exrNumero = /^[1-9]+[0-9]*$/;

        if( strUbi_Nombre == "" ){
            bolError = true;
            arrError.push("- Agregar el Nombre de la Ubicacion");
        }

        if( !(exrNumero.test(dblUbi_DimFrente)) ){
            bolError = true;
            arrError.push("- Agregar el ancho de la Ubicacion");
        }

        if( !(exrNumero.test(dblUbi_DimLargo)) ){
            bolError = true;
            arrError.push("- Agregar el largo de la Ubicacion");
        }

        if( !(exrNumero.test(dblUbi_DimAlto)) ){
            bolError = true;
            arrError.push("- Agregar el alto de la Ubicacion");
        }

        if( intStockMinimo != ""){
            if( !(exrNumero.test(intStockMinimo)) ){
                bolError = true;
                arrError.push("- Agrega el stock minimo");
            }
        }

        if( intStockMaximo != ""){
            if( !(exrNumero.test(intStockMaximo)) ){
                bolError = true;
                arrError.push("- Agrega el stock maximo");
            }
        }
            
        if( bolError ){
            Avisa("warning", "Ubicacion", "Verificar el Formulario<br>" + arrError.join("<br>"));
        } else{

            $.ajax({
                url: urlBaseUbicacion + "Ubicacion_ajax.asp"
                , method: "post"
                , async: true
                , dataType: "json"
                , data: {
                      Tarea: 3000
                    , Ubi_ID: intUbi_ID
                    , Ubi_Nombre: strUbi_Nombre
                    , Ubi_DimFrente: dblUbi_DimFrente
                    , Ubi_DimLargo: dblUbi_DimLargo
                    , Ubi_DimAlto: dblUbi_DimAlto
                    , Ubi_Habilitado: bolUbi_Habilitado

                    , Ubi_ABC: strABC
                    , Ubi_StockMinimo: intStockMinimo
                    , Ubi_StockMaximo: intStockMaximo
                    , Ubi_ResurtidoAutomatico: bolResurtidoAutomatico
            
                    , Cli_ID: intCli_ID
                    , Pro_ID: intPro_ID
            
                    , Edo_ID: intEdo_ID
                    , Prov_ID: intProv_ID
                    , EsCuarentena: bolEsCuarentena
                }
                , success: function(res){
                    
                    if(res.Error.Numero == 0){
                        Avisa("success", "Ubicacion", res.Error.Descripcion)
                        Ubicacion.EdicionModalCerrar();
                        Ubicacion.BusquedaListadoCargar();
                    } else {
                        Avisa("error", "Ubicacion", res.Error.Descripcion)
                    }
                }
            })

        }

    }
    , Habilitar: function(){

        var prmJson = ( !(arguments[0] == undefined) ) ? arguments[0] : {};

        var objObjeto = ( !(prmJson.Objeto == undefined) ) ? prmJson.Objeto : null;
        var intUbi_ID = ( !(prmJson.Ubi_ID == undefined) ) ? prmJson.Ubi_ID : -1;
        var intHabilitado = ( !(prmJson.Habilitado == undefined) ) ? prmJson.Habilitado : 1;

        var bolEsHabilitado = ( intHabilitado == 1) ? 0: 1;
        var strIcono = ( intHabilitado == 0) ? "fa-toggle-on": "fa-toggle-off";
        var strTitulo = ( intHabilitado == 0) ? "Habilitado": "Deshabilitado";
        
        $.ajax({
            url: urlBaseUbicacion + "Ubicacion_ajax.asp"
            , method: "post"
            , async: true
            , dataType: "json"
            , data: {
                Tarea: 3001 /* Actualizacion del Rack */
                , Ubi_ID: intUbi_ID
                , Ubi_Habilitado: bolEsHabilitado
            }
            , success: function(res){

                console.log("res.Error.Numero", res.Error.Numero)
                
                if( parseInt(res.Error.Numero) == 0 ){
                    
                    $(objObjeto)
                        .attr({
                            "onClick": "Ubicacion.Habilitar({Objeto: $(this), Ubi_ID: " + intUbi_ID + ", Habilitado: " + bolEsHabilitado + "});"
                            , "title": strTitulo
                        })
                        .html("<i class='fa " + strIcono + " fa-lg'></i>");

                    Avisa("success", "Ubicacion", res.Error.Descripcion);
                } else {
                    Avisa("warning", "Ubicacion", res.Error.Descripcion);
                }
            }
        });
        
    }
    , InventarioSeriesActualListadoCargar: function(){

        var prmJson = ( !(arguments[0] == undefined) ) ? arguments[0] : {};
        var intUbi_ID = ( !(prmJson.Ubi_ID == undefined) ) ? prmJson.Ubi_ID : -1;
        var intPT_ID = ( !(prmJson.PT_ID == undefined) ) ? prmJson.PT_ID : -1;

        Inventario.SerieActualListadoCargar({
            Ubi_ID: intUbi_ID
            , PT_ID: intPT_ID
            , Contenedor: "divLateral"
        });

        this.LateralVisualizar();
    }
    , ListadoPrincipalCargar: function(){
        
        var intCli_ID = $("#selCliente").val()
        var intUbi_ID = $("#selUbicacion").val()
        var strPro_SKU = $("#inpProductoSku").val()
        var intTRa_ID = $("#selTipoRack").val()
        var intAre_ID = $("#selUbicacionArea").val()
        var intRac_ID = $("#selUbicacionRack").val()

        //ocultar el div de Series
        $("#divDetalle").hide();

        $.ajax({
              url: urlBaseUbicacion + "Ubicacion_ajax.asp"
            , method: "post"
            , async: true
            , data: {
                  Tarea: 1100
                , Cli_ID: intCli_ID
                , Ubi_ID: intUbi_ID
                , Pro_SKU: strPro_SKU
                , TRa_ID: intTRa_ID
                , Are_ID: intAre_ID
                , Rac_ID: intRac_ID
                , EsCuarentena: intEsCuarentena
            }
            , success: function(res){
                $("#divUbicacionTabla").html(res);
            }
        });
    }
    , ListadoExistenciaCargar: function(){
        
        var intCli_ID = $("#selCliente").val()
        var intAre_ID = $("#selUbicacionArea").val()
        var intTRa_ID = $("#selTipoRack").val()
        var intRac_ID = $("#selUbicacionRack").val()
        var strPro_SKU = $("#inpProductoSku").val()
        var strUbi_Nombre = $("#inpNombre").val()
        var strLPN = $("#inpLPN").val()

        //ocultar el div de Series
        $("#divDetalle").hide();

        Cargando.Iniciar();

        $.ajax({
              url: urlBaseUbicacion + "Ubicacion_ajax.asp"
            , method: "post"
            , async: true
            , data: {
                  Tarea: 1200
                , Cli_ID: intCli_ID
                , Are_ID: intAre_ID
                , TRa_ID: intTRa_ID
                , Rac_ID: intRac_ID
                , Pro_SKU: strPro_SKU
                , Ubi_Nombre: strUbi_Nombre
                , PT_LPN: strLPN
            }
            , success: function(res){
                $("#divUbicacionTabla").html(res);
                Cargando.Finalizar();
                Ubicacion.LateralOcultar();
            }
            , error: function(){
                Avisa("error", "Ubicaciones", "no se puede cargar el listado")
                Cargando.Finalizar();
            }
        });
        
       
    }
    , LateralOcultar: function(){
        $("#divLateral").hide().html("");
    }
    , LateralVisualizar: function(){
        $("#divLateral").show();
    }
    , PalletLPNImprimir: function(){

        var prmJson = ( !(arguments[0] == undefined) ) ? arguments[0] : {};
        var intPT_ID = ( !(prmJson.PT_ID == undefined ) ) ? prmJson.PT_ID : -1;
        
        window.open("/pz/wms/Almacen/ImpresionLPN.asp?PT_ID="+intPT_ID+"&Tipo=2" );
    }
    , ImprimirCodigoBarras: function(){
        var prmJson = ( !(arguments[0] == undefined) ) ? arguments[0] : {};
        var intUbi_ID = ( !(prmJson.Ubi_ID == undefined ) ) ? prmJson.Ubi_ID : -1;

        window.open("/pz/wms/Almacen/Ubicacion/Ubicacion_CodigoBarras.asp?Ubi_ID="+intUbi_ID+"")
    }
    , NombreListadoCargar: function(){
        var prmJson = ( !(arguments[0] == undefined) ) ? arguments[0] : {};

        var strContenedor = ( !(prmJson.Contenedor == undefined ) ) ? prmJson.Contenedor : "divUbicacionNombreListado";
        var strTitulo = ( !(prmJson.Titulo == undefined ) ) ? prmJson.Titulo : "Ubicaciones";
        var intAlto = ( !(prmJson.Alto == undefined ) ) ? prmJson.Alto : 300;

        var intInm_ID = ( !(prmJson.Inm_ID == undefined ) ) ? prmJson.Inm_ID : -1;
        var intAre_ID = ( !(prmJson.Are_ID == undefined ) ) ? prmJson.Are_ID : -1;
        var intRac_ID = ( !(prmJson.Rac_ID == undefined ) ) ? prmJson.Rac_ID : -1;

        $.ajax({
            url: urlBaseUbicacion + "Ubicacion_ajax.asp"
            , method: "post"
            , async: true
            , data: {
                Tarea: 110 /* Listado de Nombre de Ubicaciones */
                , Inm_ID: intInm_ID
                , Are_ID: intAre_ID
                , Rac_ID: intRac_ID
                , Titulo: strTitulo
                , Alto: intAlto
            }
            , success: function(res){
                $("#" + strContenedor).html(res);
            }
        })
    }
   , SeleccionAvanzadaAbrir: function(){

        var prmJson = ( !(arguments[0] == undefined) ) ? arguments[0] : {};

        var strSelector = ( !(prmJson.Selector == undefined ) ) ? prmJson.Selector : "hidUbi_ID";
        var strEtiqueta = ( !(prmJson.Etiqueta == undefined ) ) ? prmJson.Etiqueta : "lblUbi_Nombre";

        this.SeleccionAvanzadaModalAbrir({
            Selector: strSelector
            , Etiqueta: strEtiqueta
        });
    }
    , SeleccionAvanzadaModalAbrir: function(){

        var prmJson = ( !(arguments[0] == undefined) ) ? arguments[0] : {};

        var strSelector = ( !(prmJson.Selector == undefined ) ) ? prmJson.Selector : "hidUbi_ID";
        var strEtiqueta = ( !(prmJson.Etiqueta == undefined ) ) ? prmJson.Etiqueta : "lblUbi_Nombre";

        if( $("#mdlUbiSeleccionAvanzada").length == 0 ){
            $.ajax({
                  url: urlBaseUbicacion + "Ubicacion_ajax.asp"
                , method: "post"
                , async: true
                , data: {
                      Tarea: 290 // Modal de Seleccion avanzada
                }
                , success: function(res){
                    $("#wrapper").append(res);
					UbicacionArea.ComboCargar({ Contenedor: "selmdlUbiSelAvaUbicacionArea" });
					UbicacionRack.ComboCargar({ Contenedor: "selmdlUbiSelAvaUbicacionRack"});
		
					Catalogo.ComboCargar({
							SEC_ID: 92
						, Contenedor: "selmdlUbiSelAvaTipoRack"
					});		
					
					$("#mdlUbiSeleccionAvanzada").data("selector", strSelector)
           			$("#mdlUbiSeleccionAvanzada").data("etiqueta", strEtiqueta)					
					
					Ubicacion.SeleccionAvanzadaModalLimpiar();

				    $("#mdlUbiSeleccionAvanzada").modal('show');

                }
            });
        }  else {

		    Ubicacion.SeleccionAvanzadaModalLimpiar();
	        $("#mdlUbiSeleccionAvanzada").modal('show');

		}

    }
    , SeleccionAvanzadaModalBuscar: function(){
        
        var intAre_ID = $("#selmdlUbiSelAvaUbicacionArea").val();
        var intRac_ID = $("#selmdlUbiSelAvaUbicacionRack").val();
        var intTRa_ID = $("#selmdlUbiSelAvaTipoRack").val();
        var strUbi_Nombre =  $("#inpmdlUbiSelAvaNombre").val();
        Ubicacion.Cargando();
        $.ajax({
            url: urlBaseUbicacion + "ubicacion_ajax.asp"
            , method: "post"
            , async: true
            , data:{
                Tarea: 291 //Listado de Seleccion Avanzada
                , Are_ID: intAre_ID
                , Rac_ID: intRac_ID
                , TRa_ID: intTRa_ID
                , Ubi_Nombre: strUbi_Nombre
            }
            , success: function(res){
                $("#divmdlUbiSelAvaListado").html(res);
            }
        });
    }
    , SeleccionAvanzadaModalCerrar: function(){
        $("#mdlUbiSeleccionAvanzada").modal('hide');
        this.SeleccionAvanzadaModalLimpiar();
    }
    , SeleccionAvanzadaModalFormularioLimpiar: function(){
        $("#selmdlUbiSelAvaUbicacionArea").val("");
        $("#selmdlUbiSelAvaUbicacionRack").val("");
        $("#inpmdlUbiSelAvaNombre").val("");
    }
    , SeleccionAvanzadaModalLimpiar: function(){
        this.SeleccionAvanzadaModalFormularioLimpiar();
        this.SeleccionAvanzadaModalListadoLimpiar();
    }
    , SeleccionAvanzadaModalListadoLimpiar: function(){
        $("#divmdlUbiSelAvaListado").html("");
    }
    , SeleccionAvanzadaSeleccionar: function(){
        var prmJson = ( !(arguments[0] == undefined) ) ? arguments[0] : {};
        
        var intUbi_ID = ( !(prmJson.Ubi_ID == undefined ) ) ? prmJson.Ubi_ID : -1;
        var intUbi_Nombre = ( !(prmJson.Ubi_Nombre == undefined ) ) ? prmJson.Ubi_Nombre : "";

        var strSelector = $("#mdlUbiSeleccionAvanzada").data("selector");
        var strEtiqueta = $("#mdlUbiSeleccionAvanzada").data("etiqueta");

        $("#" + strSelector).val(intUbi_ID);
        $("#" + strEtiqueta).text(intUbi_Nombre);

        this.SeleccionAvanzadaModalCerrar();
    }
}


