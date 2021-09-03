<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2020-NOV-03 Surtido: Creación de archivo

var urlBase = "/pz/wms/"
var urlBaseTemplate = "/Template/inspina/";

%>
<link href="<%= urlBaseTemplate %>css/plugins/select2/select2.min.css" rel="stylesheet">

<!-- Select2 -->
<script src="<%= urlBaseTemplate %>js/plugins/select2/select2.full.min.js"></script>
<!-- Loading -->
<script src="<%= urlBaseTemplate %>js/loading.js"></script>
<!-- Lateral Flotante -->
<script src="<%= urlBaseTemplate %>js/lateralflotante.js"></script>

<!-- Librerias-->
<script type="text/javascript" src="<%= urlBase %>Almacen/Cliente/js/Cliente.js"></script>
<script type="text/javascript" src="<%= urlBase %>Devolucion/Proveedor/js/proveedor.js"></script>

<script type="text/javascript">

    $(document).ready(function(){

        Cliente.ComboCargar({
            Contenedor: "selCliente"
        })
        Proveedor.ComboCargar({
            Contenedor: "selProveedor"
        })
        
        $("#selCliente").select2();
        $("#selProveedor").select2();
    })

    var urlBase = "/pz/wms/";

    var TA_Proveedor = {
        Estatus: {
              Transito: 5
            , PrimerIntento: 6
            , SegundoIntento: 7
            , TercerIntento: 8
            , Rechazado: 9
            , EntregaExitosa: 10
            , Cancelado: 11
            , Devolucion: 16
        }
        , Extraer: function(){
            var prmJson = ( !( arguments[0] == undefined ) ) ? arguments[0] : {};
            var intTA_ID = ( !( prmJson.TA_ID == undefined ) ) ? prmJson.TA_ID : -1;

            var resJson = {};

            $.ajax({
                  url: urlBase + "TA/TA_Proveedor_ajax.asp"
                , method: "post"
                , async: false
                , dataType: "json"
                , data: {
                      Tarea: 100
                    , TA_ID: intTA_ID
                }
                , success: function(res){
                    resJson = res;
                }
            });

            return resJson;
        }
        , ExtraerID: function(){
            var prmJson = ( !( arguments[0] == undefined ) ) ? arguments[0] : {};
            var intTA_ID = ( !( prmJson.TA_ID == undefined ) ) ? prmJson.TA_ID : -1;

            var resJson = this.Extraer({TA_ID: intTA_ID}).Registros[0];

            return resJson;
        }
        , EstatusCambiar: function(){
            
            var prmJson = ( !( arguments[0] == undefined ) ) ? arguments[0] : {};
            var intTA_ID = ( !( prmJson.TA_ID == undefined ) ) ? prmJson.TA_ID : -1;

            var resJson = this.ExtraerID({TA_ID: intTA_ID});

            this.EstatusCambiarModalAbrir({Est_ID: resJson.TA_EstatusCG51});

            $("#hidMdlEstCamTA_ID").val(resJson.TA_ID);
            $("#lblMdlEstCamTitulo").text(resJson.TA_Folio + " - " + resJson.AlmD_Nombre);
            $("#lblMdlEstCamSubtitulo").text(resJson.AlmD_DireccionCompleta);

        }
        , EstatusCambiarModalAbrir: function(){
            
            var prmJson = ( !( arguments[0] == undefined ) ) ? arguments[0] : {};
            var intEst_ID = ( !( prmJson.Est_ID == undefined ) ) ? prmJson.Est_ID : -1;

            if( $("#mdlEstCam").length == 0 ){
                $.ajax({
                    url: urlBase + "TA/TA_Proveedor_ajax.asp"
                    , method: "post"
                    , async: false
                    , data: {
                        Tarea: 190
                    }
                    , success: function(res){
                        $("#wrapper").append(res);
                    }
                })
            }

            var arrCat_IDs = [];

            switch(intEst_ID){
                case 5: { 
                    arrCat_IDs = [
                          this.Estatus.PrimerIntento
                        , this.Estatus.Rechazado
                        , this.Estatus.EntregaExitosa
                        , this.Estatus.Cancelado
                    ] 
                } break;        //Transito
                case 6: { 
                    arrCat_IDs = [
                          this.Estatus.SegundoIntento
                        , this.Estatus.Rechazado
                        , this.Estatus.EntregaExitosa
                        , this.Estatus.Cancelado
                    ] 
                } break;        //1er Intento
                case 7: { 
                    arrCat_IDs = [
                          this.Estatus.TercerIntento
                        , this.Estatus.Rechazado
                        , this.Estatus.EntregaExitosa
                        , this.Estatus.Cancelado
                    ] 
                } break;        //2do Intento
                case 8: { 
                    arrCat_IDs = [
                          this.Estatus.Rechazado
                        , this.Estatus.EntregaExitosa
                        , this.Estatus.Cancelado
                    ] 
                } break;        //3er Intento
                case 9: { 
                    arrCat_IDs = [
                          this.Estatus.Transito
                        , this.Estatus.Devolucion
                    ]
                } break;        //Rechazado
                case 10: { 
                    arrCat_IDs = [
                          this.Estatus.Transito
                        , this.Estatus.Cancelado
                    ] 
                } break;        //Entrega Exitosa
                case 11: { 
                    arrCat_IDs = [
                          this.Estatus.Transito
                    ] 
                } break;           //Cancelado
            }

            //Cargar el combo de Estatus de la Transferencia
            Catalogo.ComboCargar({
                  SEC_ID: 51
                , CAT_IDs: arrCat_IDs
                , Contenedor: "selMdlEstCamEstatus"
            });

            this.EstatusCambiarModalLimpiar();
            
            $("#mdlEstCam").modal("show");
        }
        , EstatusCambiarModalCerrar: function(){
            this.EstatusCambiarModalLimpiar();

            $("#mdlEstCam").modal("hide");
        }
        , EstatusCambiarModalLimpiar: function(){
            $("#hidMdlEstCamTA_ID").val("");
            $("#lblMdlEstCamTitulo").text("");
            $("#lblMdlEstCamSubtitulo").text("");

            $("#selMdlEstCamEstatus").val("");
            $("#txaMdlEstCamComentario").val("");
        }
        , EstatusGuardar: function(){
            Cargando.Iniciar();

            var intEsta
            var intEst_ID = $("#selMdlEstCamEstatus").val();
            var strComentario = $("#txaMdlEstCamComentario").val();

            var bolError = false;
            var arrError = [];

            if( intEst_ID == "" ){
                arrError.push("- Seleccionar el Estatus a Cambiar");
                bolError = true;
            }

            if( strComentario.trim() == ""){
                arrError.push("- Agregar el Comentario de cambio de Estatus");
                bolError = true;
            }

            if( bolError ){
                Avisa("warning", "Cambio de Estatus", "Verificar el Formulario<br>" + arrError.join("<br>"));
            } else {
                $.ajax({
                      url: urlBase + "TA/TA_Proveedor_ajas.asp"
                    , method: "post"
                    , async: false
                    , dataType: "json"
                    , data: {
                          Tarea: 3200
                        , TA_ID: intTA_ID
                        , Est_ID: intEst_ID
                        , Comentario: strComentario
                    }
                    , success: function(res){
                        if( res.Error.Numero == 0){
                            Avisa("success", "Cambio de Estatus", res.Error.Descripcion);

                            TAProveedor.EstatusCambiarModalCerrar();
                            TAProveedor.ListadoCargar();
                        } else {
                            Avisa("danger", "Cambio de Estatus", res.Error.Descripcion);
                        }
                    }
                });                
            }

            Cargando.Finalizar();
        }
        , ListadoCargar: function(){
            
            var intIDUsuario = $("#IDUSuario").val();
            var intCli_ID = $("#selCliente").val();
            var intProv_ID = $("#selProveedor").val();

            var strTA_Folio = $("#inpTA_Folio").val();
            var strTA_Guia = $("#inpTA_Guia").val();

            $.ajax({
                url: urlBase + "TA/TA_Proveedor_ajax.asp"
                , method: "post"
                , async: false
                , data: {
                      Tarea: 1000
                    , Cli_ID: intCli_ID
                    , Prov_ID: intProv_ID
                    , TA_Folio: strTA_Folio
                    , TA_Guia: strTA_Guia
                    , IDUsuario: intIDUsuario
                }
                , success: function(res){
                    $("#divTA_Proveedor").html(res);
                }
            });
            
        }
        
    }
</script>

<div id="wrapper">
    <div class="wrapper wrapper-content">    
        <div class="row">
            <div class="col-sm-9">
                <div class="ibox">
                    <div class="ibox-title">
                        <h5>Filtros de b&uacute;squeda</h5>
                        <div class="ibox-tools">
                            
                            <button class="btn btn-success btn-sm" type="button" id="btnBuscar" onClick="TA_Proveedor.ListadoCargar()">
                                <i class="fa fa-search"></i> Buscar
                            </button>

                        </div>
                    </div>
                    <div class="ibox-content">
                        <div class="row"> 
                            <div class="col-sm-12 m-b-xs">        
                                 <div class="form-group row">

                                    <label class="col-sm-2 control-label">Proveedor:</label>
                                    <div class="col-sm-4 m-b-xs">
                                        <select id="selProveedor" class="form-control">

                                        </select>
                                    </div>
                                    <label class="col-sm-2 control-label">Cliente:</label>    
                                    <div class="col-sm-4 m-b-xs">
                                        <select id="selCliente" class="form-control">

                                        </select>
                                    </div>

                                </div>
                                <div class="form-group row">

                                    <label class="col-sm-2 control-label">Transferencia:</label>    
                                    <div class="col-sm-4 m-b-xs">
                                        <input type="text" id="inpTA_Folio" class="form-control"
                                         autocomplete="off" maxlength="30">
                                    </div>
                                    <label class="col-sm-2 control-label">No. Gu&iacute;a:</label>    
                                    <div class="col-sm-4 m-b-xs">
                                        <input type="text" id="inpTA_Guia" class="form-control"
                                        autocomplete="off" maxlength="30">
                                    </div>   
                                   
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="ibox" id="divTA_Proveedor">
                    
                </div>
            </div>
            <div class="col-sm-3" id="divLateral">
                
            </div>
        </div>
    </div>
</div>

