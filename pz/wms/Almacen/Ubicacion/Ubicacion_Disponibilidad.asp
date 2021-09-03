<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->
<%
// HA ID: 1 2021-JUN-03 Tiedas y entregas: Creación de archivo
var cxnTipo = 0

var urlBase = "/pz/wms/Almacen/"
var urlBaseTemplate = "/Template/inspina/";

%>

<link href="<%= urlBaseTemplate %>css/plugins/select2/select2.min.css" rel="stylesheet">

<link href="<%= urlBaseTemplate %>css/plugins/daterangepicker/daterangepicker-bs3.css" rel="stylesheet">

<!-- Select2 -->
<script src="<%= urlBaseTemplate %>js/plugins/select2/select2.full.min.js"></script>
<!-- Date range use moment.js same as full calendar plugin -->
<script src="<%= urlBaseTemplate %>js/plugins/fullcalendar/moment.min.js"></script>
<!-- Date range picker -->
<script src="<%= urlBaseTemplate %>js/plugins/daterangepicker/daterangepicker.js"></script>
<!-- Loading -->
<script src="<%= urlBaseTemplate %>js/loading.js"></script>

<script src="<%= urlBaseTemplate %>js/lateralflotante.js"></script>

<script src="/Template/inspina/js/plugins/sheetJs/xlsx.full.min.js"></script>

<script type="text/javascript">

    $(document).ready(function(){  
       
        $(".select2").select2();

        //Buscar
        $("#btnBusLim").on("click", function(){
            Ubicacion.Buscar.FormularioLimpiar();
        });

        $("#btnBusBus").on("click", function(){
            Ubicacion.Buscar.ListadoBuscar();
        });

        $("#btnBusExp").on("click", function(){
            Ubicacion.Buscar.Exportar();
        })

    })

    var Ubicacion = {
        url: "/pz/wms/almacen/ubicacion/"
        , Buscar: {
              RegistrosPagina: 10
            , Filtros: {
                  Area: -1
                , Rack: -1
                , Nombre: ""
                , TipoDisponibilidad: -1
            }
            , Tipo: {
                  Ambas: -1
                , Disponible: 1
                , Ocupado: 0
            }
            , FormularioLimpiar: function(){
                $("#selAre").val("-1");
                $("#select2-selAre-container").text("TODOS");

                $("#selRac").val("-1");
                $("#select2-selRac-container").text("TODOS");
                
                $("#inpNom").val("");
                $("#inpTDiAmb").prop("checked", true);
                
                Ubicacion.Buscar.Filtros.Area = -1
                Ubicacion.Buscar.Filtros.Rack = -1
                Ubicacion.Buscar.Filtros.Nombre = ""
                Ubicacion.Buscar.Filtros.TipoDisponibilidad = Ubicacion.Buscar.Tipo.Ambas
            }
            , ListadoBuscar: function( prmIntTipBus ){
                
                var bolError = false;
                var arrError = [];

                var intAlm_ID = $("#Alm_ID").val();

                var intAre = $("#selAre").val();
                var intRac = $("#selRac").val();
                var strNom = $("#inpNom").val();
                var intTDi = $("[name=inpTDi]:checked").val();

                //validación de mínimo un filtro
                if( intAre == -1 && intRac == -1 && strNom == "" && intTDi == "-1" ){
                    bolError = true;
                    arrError.push("- Introducir al menos un filtro de b&uacute;squeda");
                }

                if( bolError ){
                    Avisa("warning", "Ubicaci&oacute;n Disponibilidad - Buscar", "Verificar el formulario<br>" + arrError.join("<br>"));
                } else {

                    Ubicacion.Buscar.Filtros.Area = intAre;
                    Ubicacion.Buscar.Filtros.Rack = intRac;
                    Ubicacion.Buscar.Filtros.Nombre = strNom;
                    Ubicacion.Buscar.Filtros.TipoDisponibilidad = intTDi;

                    Ubicacion.Buscar.ListadoCargar( true );
            
                    Ubicacion.Buscar.ListadoLimpiar();

                }
            }
            , ListadoCargar: function( prmBolIniBus ){
                
                Procesando.Visualizar({Contenedor: "tfoCar"});

                $.ajax({
                    url: Ubicacion.url + "Ubicacion_Disponibilidad_Listado.asp"
                    , method: "post"
                    , async: true
                    , data: {
                          Area: Ubicacion.Buscar.Filtros.Area
                        , Rack: Ubicacion.Buscar.Filtros.Rack
                        , Nombre: Ubicacion.Buscar.Filtros.Nombre
                        , TipoDisponibilidad: Ubicacion.Buscar.Filtros.TipoDisponibilidad
                    }
                    , success: function( res ){
                       Procesando.Ocultar();

                        $("#tboReg").html(res); 

                        if( res == "" ){

                            var objMas = "<i class='fa fa-exclamation-circle fa-lg'></i> No hay registros"
                            $("#tfoCar").html(objMas);
                        }

                        Ubicacion.Buscar.ListadoRegistrosContar();
                    }
                    , error: function(){
                        Avisa("error", "Ubicaci&oacute;n Disponibilidad - Buscar", "Error en la peticion de Cargar Listado");
                        Procesando.Ocultar();
                    }
                });

            }
            , ListadoRegistrosContar: function(){
                
                var intTerReg = $(".cssReg").length;
                $("#lblTotReg").text(intTerReg);
                   
            }
            , ListadoLimpiar: function( intTpoLis ){
                
                $("#lblTotReg").text("");
                $("#tboReg").html("");              
            }
            , Exportar: function(){

                Cargando.Iniciar();

                $.ajax({
                    url: Ubicacion.url + "Ubicacion_Disponibilidad_ajax.asp"
                    , method: "post"
                    , async: true
                    , dataType: "json"
                    , data: {
                            Tarea: 1300
                        , Area: Ubicacion.Buscar.Filtros.Area
                        , Rack: Ubicacion.Buscar.Filtros.Rack
                        , Nombre: Ubicacion.Buscar.Filtros.Nombre
                        , TipoDisponibilidad: Ubicacion.Buscar.Filtros.TipoDisponibilidad
                    }
                    , success: function( res ){
                        var xlsData = XLSX.utils.json_to_sheet( res );
                        var xlsBook = XLSX.utils.book_new(); 

                        XLSX.utils.book_append_sheet(xlsBook, xlsData, "Ubicaciones_Disponibles");

                        XLSX.writeFile(xlsBook, "Ubicaciones_Disponibles.xlsx");

                        Cargando.Finalizar();
                    }
                    , error: function(){
                        Avisa("error","Ubicaci&oacute;n Disponibilidad - Exportar","error en la peticion de exportaci&oacute;n");
                        Cargando.Finalizar();
                    }
                });
            
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
                        <h5>Resultados</h5>
                        <div class="ibox-tools">
                            
                            <button class="btn btn-white btn-sm" type="button" id="btnBusLim">
                                <i class="fa fa-trash-o"></i> Limpiar
                            </button>

                            <button class="btn btn-success btn-sm" type="button" id="btnBusBus">
                                <i class="fa fa-search"></i> Buscar
                            </button>

                        </div>
                    </div>

                    <div class="ibox-content">

                        <div class="row form-group">
                            
                            <label class="col-sm-2 control-label">&Aacute;rea:</label>
                            <div class="col-sm-4">
<%
       CargaCombo("selAre", "class='form-control select2'", "Are_ID", "Are_Nombre", "Ubicacion_Area", "Are_Habilitado = 1 AND Are_TipoCG88 IN (1,3,4)", "Are_Nombre ASC", "", cxnTipo, "TODOS", "-1")
%>
                            </div>

                            <label class="col-sm-2 control-label">Rack:</label>
                            <div class="col-sm-4">
<%
       CargaCombo("selRac", "class='form-control select2'", "Rac_ID", "Rac_nombre", "Ubicacion_Rack", "Rac_Habilitado = 1 AND Are_ID IN ( SELECT AAre.Are_ID FROM Ubicacion_Area AAre WHERE AAre.Are_TipoCG88 IN (1,3,4) )", "Rac_Nombre ASC", "", cxnTipo, "TODOS", "-1")
%>
                            </div>

                        </div>

                        <div class="row form-group">
                            
                            <label class="col-sm-2 control-label">Nombre:</label>
                            <div class="col-sm-4">
                                <input type="text" class="form-control" id="inpNom" placeholder="Ubicaci&oacute;n"
                                 autocomplete="off" maxlength="50">
                            </div>

                            <label class="col-sm-2 control-label">Disponibilidad:</label>
                            <div class="col-sm-4">
                                <label for="inpTDiAmb"><input type="radio" name="inpTDi" id="inpTDiAmb" value="-1" checked> Ambos</label>
                                <label for="inpTDiDis"><input type="radio" name="inpTDi" id="inpTDiDis" value="1" > Disponible</label>
                                <label for="inpTDiSDi"><input type="radio" name="inpTDi" id="inpTDiSDi" value="0" > Ocupado</label>
                            </div>

                        </div>

                    </div>

                    <div class="ibox-footer">

                        <div class="ibox-tools">
                            
                            <button class="btn btn-white btn-sm" type="button" id="btnBusExp">
                                <i class="fa fa-file-excel-o"></i> Exportar
                            </button>

                        </div>

                    </div>

                </div>

                <div class="ibox">
                    <div class="ibox-title">
                        <h5>Terminados</h5>
                        <div class="ibox-tools">

                            <label class="pull-right form-group">
                                <span class="text-success" id="lblTotReg">

                                </span> Registros
                            </label>

                        </div>
                    </div>
                    <div class="ibox-content">
                        <div class="row"> 
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th class="col-sm-1">#</th>
                                        <th class="col-sm-3">Area</th>
                                        <th class="col-sm-4">Rack</th>
                                        <th class="col-sm-4">Ubicaci&oacute;n</th>
                                    </tr>
                                </thead>
                                <tbody id="tboReg">
                                
                                </tbody>
                                <tfoot>
                                    <tr>
                                        <td id="tfoCar" colspan="4">
                                        
                                        </td>
                                    </tr>
                                </tfoot>
                            </table>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>
</div>
