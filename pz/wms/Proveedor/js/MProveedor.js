var MProveedor = {
      url: "/pz/wms/Proveedor/"
    , Estatus: {
          Transito: 5
        , PrimerIntento: 6
        , SegundoIntento: 7
        , TercerIntento: 8
        , FallaEntrega: 9
        , EntregaExitosa: 10
        , AvisoDevolucion: 22
    }
    
    , EstatusCambiar: function(){

        $("#mdlMProEstCam").remove();
        
        var prmJson = ( !( arguments[0] == undefined ) ) ? arguments[0] : {};
        var intTA_ID = ( !( prmJson.TA_ID == undefined ) ) ? prmJson.TA_ID : -1;
        var intOV_ID = ( !( prmJson.OV_ID == undefined ) ) ? prmJson.OV_ID : -1;

        var bolError = false;
        var arrError = [];

        if( intTA_ID == -1 && intOV_ID == -1 ){
            bolError = true;
            arrError.push("- Identificadores de TA o OV No permitidos");
        }

        if( bolError ){
            Avisa("warning", "Cambio de Estatus", "Verificar formulario de carga<br>" + arrError.join("<br>"));
        } else {

            Cargando.Iniciar();

            $.ajax({
                url: this.url + "MProveedor_CambioEstatus.asp"
                , method: "post"
                , async: true
                , data: {
                    TA_ID: intTA_ID
                    , OV_ID: intOV_ID
                }
                , success: function(res){
                    $("#wrapper").append(res);
                    $("#mdlMProEstCam").modal("show");
                    Cargando.Finalizar();
                }   
                , error: function(){
                    Avisa("error", "Cambio de Estatus","No se puede cargar el modal de cambio de estatus")
                    Cargando.Finalizar();
                }
            });
        }

        
    }
    
    , EstatusCambiarModalCerrar: function(){
        $("#mdlMProEstCam").modal("hide");
    }
    , EstatusCambiarModalEstatusCambiar: function(){
        var intEst_ID = $("#selMdlMProEstCamEstatus").val();

        var bolVisCom = false;
        var bolVisRec = false;

        console.log("intEst_ID",intEst_ID);
        console.log("AvisoDevolucion",this.Estatus.AvisoDevolucion);

        if( parseInt(intEst_ID) == this.Estatus.EntregaExitosa || parseInt(intEst_ID) == this.Estatus.AvisoDevolucion ){
            bolVisCom = true;
        }

        if( parseInt(intEst_ID) ==  this.Estatus.EntregaExitosa ){
            bolVisRec = true;
        }

        if( bolVisCom ){
            $(".clsMdlMProEstCamComentario").show();
        } else {
            $(".clsMdlMProEstCamComentario").hide();
        }

        if( bolVisRec ){
            $(".clsMdlMProEstCamRecibio").show();
        } else {
            $(".clsMdlMProEstCamRecibio").hide();
        }

    }
    , EstatusGuardar: function(){
        Cargando.Iniciar();
        
        var intTA_ID = $("#hidMdlMProEstCamTA_ID").val();
        var intOV_ID = $("#hidMdlMProEstCamOV_ID").val();

        var intEst_ID = $("#selMdlMProEstCamEstatus").val();
        var strComentario = $("#txaMdlMProEstCamComentario").val();
        var strRecibio = $("#inpMdlMProEstCamRecibio").val();

        var dateFecha = $("#inpMdlMProEstCamFecha").val();
        var timeHora = $("#inpMdlMProEstCamHora").val();

        var bolError = false;
        var arrError = [];
        var bolVisCom = false;
        var bolVisRec = false;

        var intIDUsuario = $("#IDUsuario").val();
        var intID = ( intTA_ID > -1 ) ? intTA_ID : (( intOV_ID > -1 ) ? intOV_ID : -1);

        //Visibilidad Campos
        if( parseInt(intEst_ID) == this.Estatus.EntregaExitosa || parseInt(intEst_ID) == this.Estatus.AvisoDevolucion ){
            bolVisCom = true;
        }
        if( parseInt(intEst_ID) == this.Estatus.EntregaExitosa ){
            bolVisRec = true;
        }
        
        //Validacion
        if( intTA_ID == -1 && intOV_ID == -1 ){
            arrError.push("- Seleccionar el Identificador de Documento");
            bolError = true;
        }

        if( intEst_ID == "-1" ){
            arrError.push("- Seleccionar el Estatus a Cambiar");
            bolError = true;
        }

        if(bolVisCom && strComentario == ""){
            arrError.push("- Agregar el Comentario de cambio de Estatus");
            bolError = true;
        }

        if( dateFecha == ""  || timeHora == "" ){
            arrError.push("- Agregra Fecha y Hora del Cambio de Estatus");
            bolError = true;
        }

        if(bolVisRec && strRecibio == ""){
            arrError.push("- Agregar el Nombre de la Persona que recibio");
            bolError = true;
        }

        if( bolError ){
            Avisa("warning", "Cambio de Estatus", "Verificar el Formulario<br>" + arrError.join("<br>"));
        } else {
            $.ajax({
                    url: this.url + "MProveedor_ajax.asp"
                , method: "post"
                , async: true
                , dataType: "json"
                , data: {
                      Tarea: 3000
                    , TA_ID: intTA_ID
                    , OV_ID: intOV_ID
                    , Est_ID: intEst_ID
                    , Comentario: strComentario
                    , Recibio: strRecibio
                    , FechaHora: dateFecha + " " + timeHora
                    , IDUsuario: intIDUsuario
                }
                , success: function(res){
                    if( res.Error.Numero == 0){

                        if( $("#inpMdlMProEstCamArchivoEvidencia1").val() != "" ){
                       
                            var frmData1 = new FormData();
                            var myInputFile1 = document.getElementById("inpMdlMProEstCamArchivoEvidencia1").files[0];
                            var myjson1 =  {"ID":intID,"ID2":0,"Doc_ID":35,"Sys":19,"IDUsuario":intIDUsuario,"Titulo":"Evidencia de Entrega","Observacion":strComentario};
                            
                            frmData1.append("",myInputFile1);
                            frmData1.append("Data",JSON.stringify(myjson1));
                            //menos de 4MB por cada carga                      
                            
                            var settings1 = {
                                "url": "https://wms.lydeapi.com/api/v2/CargaDocumento",
                                "method": "POST",
                                "timeout": 0,
                                "processData": false,
                                "mimeType": "multipart/form-data",
                                "contentType": false,
                                "data": frmData1
                            };
                            
                            $.ajax(settings1).done(function (response) {
                                console.log(response);
                            });

                        }

                        if( $("#inpMdlMProEstCamArchivoEvidencia2").val() != "" ){
                            var frmData2 = new FormData();
                            var myInputFile2 = document.getElementById("inpMdlMProEstCamArchivoEvidencia2").files[0];
                            var myjson2 =  {"ID":intID,"ID2":0,"Doc_ID":35,"Sys":19,"IDUsuario":intIDUsuario,"Titulo":"Evidencia de Entrega","Observacion":strComentario}
                            
                            frmData2.append("",myInputFile2);
                            frmData2.append("Data",JSON.stringify(myjson2));
                            //menos de 4MB por cada carga                      
                            
                            var settings = {
                                "url": "https://wms.lydeapi.com/api/v2/CargaDocumento",
                                "method": "POST",
                                "timeout": 0,
                                "processData": false,
                                "mimeType": "multipart/form-data",
                                "contentType": false,
                                "data": frmData2
                            };
                            
                            $.ajax(settings).done(function (response) {
                                console.log(response);
                            });

                        }

                        Avisa("success", "Cambio de Estatus", res.Error.Descripcion);

                        MProveedor.EstatusCambiarModalCerrar();

                        Cargando.Finalizar();

                        MProveedor.ListadoCargar();

                    } else {
                        Avisa("danger", "Cambio de Estatus", res.Error.Descripcion);
                    }
                }
            });                
        }
    }
    , BuscarLimpiar: function(){
        $("#inpMProBFolio").val("");
        $("#inpMProBMan_Folio").val("");
        $("#inpMProBFechaBusqueda").val("");
        $("#inpMProBFechaInicial").val("");
        $("#inpMProBFechaFinal").val("");

        $("#selMProBEstatus").val("-1");
        $("#select2-selMProBEstatus-container").text("TODOS");

        $("#objMProBProv_ID").val("-1");
        $("#select2-objMProBProv_ID-container").text("TODOS");

        $("#inpMdlMProEstCamArchivoEvidencia1").empty();
        $("#inpMdlMProEstCamArchivoEvidencia2").empty();
    }
    , ListadoCargar: function(){
        
        var strFolio = $("#inpMProBFolio").val();
        var strMan_Folio = $("#inpMProBMan_Folio").val();
        var intEst_ID = $("#selMProBEstatus").val();
        var dateFechaInicial = $("#inpMProBFechaInicial").val();
        var dateFechaFinal = $("#inpMProBFechaFinal").val();
        var intIDUsuario = $("#IDUsuario").val();
        var intProv_ID = $("#objMProBProv_ID").val();
        var bolEsProveedor = ($("#objMProBProv_ID").data("esproveedor") == 1 );

        var bolError = false;

        if( strFolio == "" && strMan_Folio == "" &&  dateFechaInicial == "" && dateFechaFinal == "" &&  intEst_ID == "-1" && ( bolEsProveedor || ( !(bolEsProveedor) && intProv_ID == "-1"))){
            bolError = true;
        }
        
        if( bolError ){
            Avisa("warning", "Entregas", "Seleccionar al menos un filtro");
        } else {

            Procesando.Visualizar({Contenedor: "divMProBListado"})

            $.ajax({
                url: this.url + "MProveedor_Listado.asp"
                , method: "post"
                , async: true
                , data: {
                    Folio: strFolio
                    , Man_Folio: strMan_Folio
                    , Est_ID: intEst_ID
                    , FechaInicial: dateFechaInicial
                    , FechaFinal: dateFechaFinal
                    , Prov_ID: intProv_ID
                    , IDUsuario: intIDUsuario
                }
                , success: function(res){
                    Procesando.Ocultar();
                    
                    $("#divMProBListado").html(res);
                
                }
                , error: function(){

                    Procesando.Ocultar();
                    Avisa("error","Proveedor Entregas", "No se puede cargar el listado de Entregas")
                    
                }
            })
        }
        
    }
    
}