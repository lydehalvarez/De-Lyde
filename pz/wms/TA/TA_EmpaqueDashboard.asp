<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include virtual="/Includes/iqon.asp" -->

<%
// HA ID: 1 2020-NOV-18 Transferencia Principal Dashboard: Creación de archivo

var urlBase = "/pz/wms/TA/"
var urlTemplate = "/Template/inspina/"
%>

<link href="<%= urlTemplate %>css/plugins/datapicker/datepicker3.css" rel="stylesheet">

<script src="<%= urlTemplate %>js/plugins/datapicker/bootstrap-datepicker.js"></script>

<script src="<%= urlTemplate %>js/plugins/chartJs/Chart.min.js"></script>

<script src="/pz/wms/Almacen/Cliente/js/Cliente.js"></script>

<script type="text/javascript">

    $(document).ready(function(){

        $("#inpFecha").datepicker({
              todayBtn: "linked"
            , keyboardNavigation: false
            , forceParse: false
            , autoclose: true
            , endDate: '0d'
            
        }).datepicker("setDate", "0");

        Transferencia.Dashboard.Buscar();

        Cliente.ComboCargar();
    })

    var urlBase = "<%= urlBase %>"

    var Transferencia = {
        Dashboard: {
            Buscar: function(){
                
                Transferencia.Dashboard.TotalWidgetCargar();
                Transferencia.Dashboard.TotalGraficoCargar();
                Transferencia.Dashboard.TotalWidgetEmpaqueCargar();
                Transferencia.Listado.Ocultar();

            }
            , TotalWidgetCargar: function(){
                var dateFecha = $("#inpFecha").val();
                var intCli_ID = $("#selCliente").val();

                $.ajax({
                    url: urlBase + "TA_EmpaqueDashboard_ajax.asp"
                    , method: "post"
                    , async: false
                    , data: {
                        Tarea: 1
                        , Fecha: dateFecha
                        , Cli_ID: intCli_ID
                    }
                    , success: function(res){
                        $("#divWidTotEstatus").html(res);
                    }
                });

            }
            , TotalGraficoCargar: function(){
                var dateFecha = $("#inpFecha").val();
                var intCli_ID = $("#selCliente").val();

                $.ajax({
                    url: urlBase + "TA_EmpaqueDashboard_ajax.asp"
                    , method: "post"
                    , async: false
                    , dataType: "json"
                    , data: {
                        Tarea: 2
                        , Fecha: dateFecha
                        , Cli_ID: intCli_ID
                    }
                    , success: function(res){
                        
                        var Lienzo = document.getElementById("lineChart").getContext("2d");

                        new Chart(
                                Lienzo
                                , {    
                                    type: "line"
                                    , data: res.lineData
                                    , options: res.lineOptions
                                }
                            );

                    }
                });
            }
            , TotalWidgetEmpaqueCargar: function(){
                var dateFecha = $("#inpFecha").val();
                var intCli_ID = $("#selCliente").val();

                $.ajax({
                    url: urlBase + "TA_EmpaqueDashboard_ajax.asp"
                    , method: "post"
                    , async: false
                    , data: {
                        Tarea: 3
                        , Fecha: dateFecha
                        , Cli_ID: intCli_ID
                    }
                    , success: function(res){
                        $("#divWidBarEmpaque").html(res);
                    }
                });
            }
        }
        , Listado: {
              Cargar: function(){

                var prmJson = ( !( arguments[0] == undefined ) ) ? arguments[0] : {};
                var prmStrEst_IDs = ( !( prmJson.Est_IDs == undefined ) ) ? prmJson.Est_IDs : "";

                var dateFecha = $("#inpFecha").val();
                var intCli_ID = $("#selCliente").val();

                $.ajax({
                    url: urlBase + "TA_EmpaqueDashboard_ajax.asp"
                    , method: "post"
                    , async: false
                    , data: {
                        Tarea: 4
                        , Fecha: dateFecha
                        , Est_IDs: prmStrEst_IDs
                        , Cli_ID: intCli_ID
                    }
                    , success: function(res){
                        $("#divTraListado").html(res);
                    }
                });

            }
            , Visualizar: function(){
                $("#divTraListado").show();
            }
            , Ocultar: function(){
                $("#divTraListado").hide();
                $("#divTraListado").html("")
            }
            , Direccionar: function(){
                
            }
        }
        , Detalle: {
            Ver: function(){

            }
        }

    }

</script>

<div id="wrapper">
    <div class="wrapper wrapper-content">    
        <div class="row">
            <% /* Contenedor de Filtros */ %>
            <div class="col-sm-12">
                
                <div class="ibox">
                    <div class="ibox-title">
                        <h5>Filtros de b&uacute;squeda</h5>

                        <div class="ibox-tools">
                    
                            <button class="btn btn-success btn-sm" type="button" id="btnBuscar" onclick="Transferencia.Dashboard.Buscar();">
                                <i class="fa fa-search"></i> Buscar
                            </button>

                        </div>
                        <div class="ibox-content">
                            <div class="row">
                                <label class="col-sm-3 label-control">
                                    Cliente
                                </label>
                                <div class="col-sm-3">
                                    <select class="form-control" id="selCliente">

                                    </select>
                                </div>                 
                                <label class="col-sm-3 label-control">
                                    Fecha
                                </label>
                                <div class="col-sm-3">
                                    <input type="text" id="inpFecha" plaseholder="Fecha" class="form-control">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

            </div>

           

            <% /* Contenedor Totales */ %>
            <div class="col-sm-12">
                <div class="row" id="divWidTotEstatus" >
                    
                </div>
            </div>
            <div class="col-sm-12">
                <% /* Contenedor Grafico */ %>
                <div class="row">

                    <% /* Contenedor del Grafico de Resultados */ %>
                    <div class="col-sm-9">
                        <div class="ibox">
                            <div class="ibox-title">
                                <h5>Empaque</h5>
                                <div class="ibox-tools">
                                    
                                </div>
                            </div>
                            <div class="ibox-content">
                                <div class="row">
                                    <div>
                                        <canvas id="lineChart" style="height: 130px !important;">

                                        </canvas>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>

                    <div class="col-sm-3" id="divWidBarEmpaque">
                        
                    </div>

                </div>

                <% /* Contenedor Listado */ %>
                <div class="row">

                    <% /* Contenedor de Listado de Resultados */ %>
                    <div class="col-sm-12" id="divTraListado">
                        
                    </div>

                </div>

            </div>
        </div>
    </div>
</div>