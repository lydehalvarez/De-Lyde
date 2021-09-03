<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2020-NOV-03 Surtido: Creación de archivo

var urlBase = "/pz/wms/CC/"
var urlBaseTemplate = "/Template/inspina/";

%>
<link href="<%= urlBaseTemplate %>css/plugins/select2/select2.min.css" rel="stylesheet">

<!-- Select2 -->
<script src="<%= urlBaseTemplate %>js/plugins/select2/select2.full.min.js"></script>

<script type="text/javascript">

    $(document).ready(function(){
        Cliente.ComboCargar();
        Producto.ComboCargar();

        $("#selCliente").select2();
        $("#selProducto").select2();
        
    })

    var urlBase = "<%= urlBase %>";

    var Producto = {
        ComboCargar: function(){
            
            var intCli_ID = $("#selCliente").val();

            $.ajax({
                url: urlBase + "Serie_Reingreso_ajax.asp"
                , method: "post"
                , async: true
                , cache: false
                , data: {
                    Tarea: 101
                    , Cli_ID: intCli_ID
                }
                , success: function(res){
                    $("#selProducto").html( res );
                }
            });
        }
        , ComboEscanerCargar: function(e){
            var intTecla = (document.all) ? e.keyCode : e.which;
            
            if( intTecla == 13){
                
                var strsku = $("#inpProducto").val()

                $("#selProducto").find("option").each(function(){
                    if( $(this).data("sku") == strsku ){
                        $(this).prop("selected", true);
                        $("#select2-selProducto-container").text($(this).text());
                        $("#inpProducto").val("");
                    }
                })
            }
        }
    }

    var Cliente = {
        ComboCargar: function(){
            $.ajax({
                url: urlBase + "Serie_Reingreso_ajax.asp"
                , method: "post"
                , async: true
                , cache: false
                , data: {
                    Tarea: 201
                }
                , success: function(res){
                    $("#selCliente").html( res );
                }
            });
        }
    }

    var Reingreso = {
        SerieEscaneoBuscar: function(e){
            var intTecla = (document.all) ? e.keyCode : e.which;
            
            if( intTecla == 13){
                Reingreso.SerieBuscar();
            }
        }
        , SerieBuscarFormularioLimpiar: function(){
            $("#inpSerieBuscar").val("");
        }
        , SerieBuscar: function(){
            var strSerie = $("#inpSerieBuscar").val();

            var bolError = false;
            var arrError = [];

            if( strSerie == "" ){
                bolError = true;
                arrError.push("- Agregar Serie a buscar");
            }

            if( bolError ){
                Avisa("warning", "Reingreso", "Verificar Formulario<br>" + arrError.join("<br>"));
            } else {
                
                $.ajax({
                    url: urlBase + "Serie_Reingreso_ajax.asp"
                    , method: "post"
                    , async: true
                    , cache: false
                    , dataType: "json"
                    , data: {
                        Tarea: 1000
                        , Serie: strSerie
                    }
                    , success: function(res){

                        var strExiste = "";

                        if( res.Error.Numero == 0){
                            Avisa("success", "Reingreso", res.Error.Descripcion);
                            
                            if( res.Error.Numero == 0 ){
                                if( res.Datos.InvR_ID > 0 ){
                                    strExiste = "<strong class='text-success'><i class='fa fa-check'></i> Serie Identificada</strong>"

                                    //$("#selProducto").val(res.Datos.Pro_ID);
                                    //$("#selCliente").val(res.Datos.Cli_ID);
                                    $("#inpIMEI1").val(strSerie);

                                } else {
                                    strExiste = "<strong class='text-danger'><i class='fa fa-time'></i> Serie NO Identificada</strong>"
                                }
                                Avisa("success", "Reingreso", res.Error.Descripcion);
                            } else {
                                Avisa("warning", "Reingreso", res.Error.Descripcion);
                            }

                            $("#lblExiste").html(strExiste);

                            setTimeout(function(){$("#lblExiste").html("");}, 1000);
                            

                        } else {
                            Avisa("warning", "Reingreso", res.Error.Descripcion);
                        }

                        Reingreso.SerieBuscarFormularioLimpiar();
                    }
                }); 

            }
        }
        , SerieGuardarFormularioLimpiar: function(){


            /*
            $("#selProducto").val("");
            $("#select2-selProducto-container").text("TODOS");
            $("#selCliente").val("");
            $("#select2-selCliente-container").text("TODOS");
            */

            $("#inpIMEI1").val("");
            $("#inpIMEI2").val("");

        }
        , SerieGuardar: function(){
            var bolError = false;
            var arrError = [];

            var intPro_ID = $("#selProducto").val();
            var intCli_ID = $("#selCliente").val();
            var strIMEI1 = $("#inpIMEI1").val();
            var strIMEI2 = $("#inpIMEI2").val();

            var intTA_ID = $("#hidTransferencia").val();
            var intOV_ID = $("#hidOrdenVenta").val();

            if( intPro_ID == ""){
                bolError = true;
                arrError.push("- Seleccionar le Producto");
            }

            if( intCli_ID == ""){
                bolError = true;
                arrError.push("- Seleccionar el Cliente");
            }

            if( strIMEI1 == "" ){
                bolError = true;
                arrError.push("- Agregar el IMEI1");
            }

            if( bolError ){
                Avisa("warning", "Reingreso", "Verificar Formulario<br>" + arrError.join("<br>"));
            } else {
                $.ajax({   
                    url: urlBase + "Serie_Reingreso_ajax.asp"
                    , method: "post"
                    , async: true
                    , cache: false
                    , dataType: "json"
                    , data: {
                        Tarea: 2000
                        , IMEI1: strIMEI1
                        , IMEI2: strIMEI2
                        , Pro_ID: intPro_ID
                        , Cli_ID: intCli_ID
                    }
                    , success: function(res){
                        if( res.Error.Numero == 0 ){
                            
                            Avisa("success", "Reingreso", res.Error.Descripcion );

                            Reingreso.SerieGuardarFormularioLimpiar();

                        } else {

                            Avisa("warning", "Reingreso", res.Error.Descripcion )

                        }
                    }
                })
            }

        }
    }
</script>

<div id="wrapper">
    <div class="wrapper wrapper-content">    
        <div class="row">
            <div class="col-sm-9">
                <div class="ibox">
                    <div class="ibox-title">
                        <h5>Buscar Serie</h5>
                        <div class="ibox-tools">
  
                        </div>
                    </div>
                    <div class="ibox-content">
                        <div class="row"> 
                            <div class="col-sm-12 m-b-xs">        
                                <div class="row">
                                    <label class="col-sm-2 control-label">Serie:</label>
                                    <div class="col-sm-4 m-b-xs">
                                        <input type="text" class="form-control" id="inpSerieBuscar" onkeypress="Reingreso.SerieEscaneoBuscar(event);"
                                        autocomplete="off" placeholder="Serie">
                                    </div>
                                    <div class="col-sm-2 m-b-xs">
                                        <a class="btn btn-success btn-sm" id="btnBuscar" onClick="Reingreso.SerieBuscar();">
                                            <i class="fa fa-search"></i> Buscar
                                        </a>
                                    </div>
                                    <label class="col-sm-2 control-label" id="lblExiste">
                                    
                                    </label>
                                </div>
                                
                            </div>
                        </div>
                    </div>
                </div>

                <div class="ibox">
                    <div class="ibox-title">
                        <h5>Serie</h5>
                        <div class="ibox-tools">
                            
                            <a class="btn btn-success btn-sm" id="btnGuardar" onClick="Reingreso.SerieGuardar();">
                                <i class="fa fa-floppy-o"></i> Guardar
                            </a>

                        </div>
                    </div>
                    <div class="ibox-content">
                        <div class="row"> 

                            <label class="col-sm-2 control-label">Cliente:</label>
                            <div class="col-sm-4 m-b-xs">
                                <select id="selCliente" class="form-control">

                                </select>
                            </div>

                            <label class="col-sm-2 control-label">Producto:</label>
                            <div class="col-sm-4 m-b-xs">
                                <input type="text" id="inpProducto" autocomplete="off" placeholder="SKU" class="form-control"
                                onkeypress="Producto.ComboEscanerCargar(event);">
                                <select id="selProducto" class="form-control">

                                </select>
                            </div>
                            

                        </div>  
                        <div class="row">

                            <label class="col-sm-2 control-label">(IMEI1) Serie:</label>
                            <div class="col-sm-4 m-b-xs">
                                <input type="text" id="inpIMEI1" class="form-control" placeholder="IMEI1" autocomplete="off">
                            </div>
                            <label class="col-sm-2 control-label">(IMEI2) Serie:</label>
                            <div class="col-sm-4 m-b-xs">
                                <input type="text" id="inpIMEI2" class="form-control" placeholder="IMEI2" autocomplete="off">
                            </div>

                        </div>

                    </div>
                </div>

            </div>
            <div class="col-sm-3" id="divLateral" style="display: none; height: 750px; overflow-y: auto;">
                
            </div>
        </div>
    </div>
</div>


