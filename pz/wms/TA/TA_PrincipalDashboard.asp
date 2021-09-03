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

                $.ajax({
                    url: urlBase + "TA_PrincipalDashboard_ajax.asp"
                    , method: "post"
                    , async: false
                    , data: {
                        Tarea: 1
                        , Fecha: dateFecha
                    }
                    , success: function(res){
                        $("#divWidTotEstatus").html(res);
                    }
                });

            }
            , TotalGraficoCargar: function(){
                var dateFecha = $("#inpFecha").val();

                $.ajax({
                    url: urlBase + "TA_PrincipalDashboard_ajax.asp"
                    , method: "post"
                    , async: false
                    , dataType: "json"
                    , data: {
                        Tarea: 2
                        , Fecha: dateFecha
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

                $.ajax({
                    url: urlBase + "TA_PrincipalDashboard_ajax.asp"
                    , method: "post"
                    , async: false
                    , data: {
                        Tarea: 3
                        , Fecha: dateFecha
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

                $.ajax({
                    url: urlBase + "TA_PrincipalDashboard_ajax.asp"
                    , method: "post"
                    , async: false
                    , data: {
                        Tarea: 4
                        , Fecha: dateFecha
                        , Est_IDs: prmStrEst_IDs
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
            <div class="col-sm-12">

                <% /* Contenedor Filtros */ %>
                <div class="row">

                    <% /* Contenedor de Filtros */ %>
                    <div class="col-sm-12">
                        
                        <div class="ibox">
                            <div class="ibox-title">
                                <h5>Filtros de b&uacute;squeda</h5>
                               
                                <div class="ibox-tools">
                                    <div class="row">
                                        <div class="col-sm-3 text-nowrap pull-right">
        
                                            <div class="col-sm-10">
                                                <input type="text" id="inpFecha" plaseholder="Fecha" class="form-control">
                                            </div>
                                        <div class="col-sm-2">                   

                                        <button class="btn btn-success btn-sm" type="button" id="btnBuscar" onclick="Transferencia.Dashboard.Buscar();">
                                            <i class="fa fa-search"></i>
                                        </button>
                                    </div>

                                </div>
                            </div>
                        </div>

                    </div>

                </div>

                <% /* Contenedor Totales */ %>
                <div class="row" id="divWidTotEstatus" >
                    
                </div>

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