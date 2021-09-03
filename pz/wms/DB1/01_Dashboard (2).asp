 <%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
var Renglones = 3 
var Columnas = 0
var Grids = 0  
var i = 0
var Col = 0	  
 var sSQLRen  = " select Dsb_Renglones from Dashboard "
     sSQLRen += " where Sys_ID = " + SistemaActual
     sSQLRen += " and WgCfg_ID = " + VentanaIndex
 var rsRen = AbreTabla(sSQLRen,1,2) 
 	if (!rsRen.EOF){
	 	Renglones = rsRen.Fields.Item("Dsb_Renglones").Value
	}
	rsRen.Close()				 
   for (i=1;i<=Renglones;i++){   
   		Response.Write("<div class='row'>")
		var sSQLCol  = " select DsbC_ID, DsbC_TipoGrafico, DsbC_UnidadGrid from Dashboard_Columna "
			sSQLCol += " where Sys_ID = " + SistemaActual
			sSQLCol += " and WgCfg_ID = " + VentanaIndex
	        sSQLCol += " and DsbR_ID = " + i
		var rsCol = AbreTabla(sSQLCol,1,2)
        while (!rsCol.EOF){
			Col = rsCol.Fields.Item("DsbC_ID").Value
	    	Grids = rsCol.Fields.Item("DsbC_UnidadGrid").Value
			Response.Write("<div class='col-lg-" + Grids +"' id='r" + i + "c" + Col + "'>")
			Response.Write( "tipo = " + rsCol.Fields.Item("DsbC_TipoGrafico").Value)
			Response.Write("</div>")				  
			rsCol.MoveNext() 
		}
        rsCol.Close()
		Response.Write("</div>")
   }
%>                 
    <!-- Flot -->
<script src="/Template/inspina/js/plugins/flot/jquery.flot.js"></script>
<script src="/Template/inspina/js/plugins/flot/jquery.flot.tooltip.min.js"></script>
<script src="/Template/inspina/js/plugins/flot/jquery.flot.spline.js"></script>
<script src="/Template/inspina/js/plugins/flot/jquery.flot.resize.js"></script>
<script src="/Template/inspina/js/plugins/flot/jquery.flot.pie.js"></script>
    <!-- Peity -->
<script src="/Template/inspina/js/plugins/peity/jquery.peity.min.js"></script>
<script src="/Template/inspina/js/demo/peity-demo.js"></script>

    <!-- jQuery UI -->
<script src="/Template/inspina/js/plugins/jquery-ui/jquery-ui.min.js"></script>

    <!-- Sparkline -->
<script src="/Template/inspina/js/plugins/sparkline/jquery.sparkline.min.js"></script>
    <!-- Sparkline demo data  -->
<script src="/Template/inspina/js/demo/sparkline-demo.js"></script>
    <!-- ChartJS--> 
<script src="/Template/inspina/js/plugins/chartJs/Chart.min.js"></script>
<script>
     $(document).ready(function() 
	 {
	<%
		var CRn = 0
		var CCol = 0
		var Tpo = 0
		var sSQLCarga = " select DsbR_ID,DsbC_ID,DsbC_TipoGrafico "
    	sSQLCarga += " from Dashboard d, Dashboard_Columna c "
		sSQLCarga += " where d.Sys_ID = c.Sys_ID and c.Sys_ID = " + SistemaActual
		sSQLCarga += " and d.Mnu_ID = c.Mnu_ID "
		sSQLCarga += " and d.WgCfg_ID = c.WgCfg_ID AND c.WgCfg_ID = " + VentanaIndex	 
		var rsCarga = AbreTabla(sSQLCarga,1,2) 	
 		while(!rsCarga.EOF)
		{
	 		CRn = rsCarga.Fields.Item("DsbR_ID").Value
     		CCol = rsCarga.Fields.Item("DsbC_ID").Value
	 		Tpo = rsCarga.Fields.Item("DsbC_TipoGrafico").Value
%>
		$("#r<%=CRn%>c<%=CCol%>").load("/pz/wms/DB/grafica<%=Tpo%>.asp")
<%
        rsCarga.MoveNext() 
	}
        rsCarga.Close()   
%>
            var data1 = [
                [0,4],[1,8],[2,5],[3,10],[4,4],[5,16],[6,5],[7,11],[8,6],[9,11],[10,30],[11,10],[12,13],[13,4],[14,3],[15,3],[16,6]
            ];
            var data2 = [
                [0,1],[1,0],[2,2],[3,0],[4,1],[5,3],[6,1],[7,5],[8,2],[9,3],[10,2],[11,1],[12,0],[13,2],[14,8],[15,0],[16,0]
            ];
            $("#flot-dashboard-chart").length && $.plot($("#flot-dashboard-chart"), [
                data1, data2
            ],
                    {
                        series: {
                            lines: {
                                show: false,
                                fill: true
                            },
                            splines: {
                                show: true,
                                tension: 0.4,
                                lineWidth: 1,
                                fill: 0.4
                            },
                            points: {
                                radius: 0,
                                show: true
                            },
                            shadowSize: 2
                        },
                        grid: {
                            hoverable: true,
                            clickable: true,
                            tickColor: "#d5d5d5",
                            borderWidth: 1,
                            color: '#d5d5d5'
                        },
                        colors: ["#1ab394", "#1C84C6"],
                        xaxis:{
                        },
                        yaxis: {
                            ticks: 4
                        },
                        tooltip: false
                    }
            );

            var doughnutData = {
                labels: ["App","Software","Laptop" ],
                datasets: [{
                    data: [300,50,100],
                    backgroundColor: ["#a3e1d4","#dedede","#9CC3DA"]
                }]
            } ;


            var doughnutOptions = {
                responsive: false,
                legend: {
                    display: false
                }
            };


            var ctx4 = document.getElementById("doughnutChart").getContext("2d");
            new Chart(ctx4, {type: 'doughnut', data: doughnutData, options:doughnutOptions});

            var doughnutData = {
                labels: ["App","Software","Laptop" ],
                datasets: [{
                    data: [70,27,85],
                    backgroundColor: ["#a3e1d4","#dedede","#9CC3DA"]
                }]
            } ;


            var doughnutOptions = {
                responsive: false,
                legend: {
                    display: false
                }
            };


            var ctx4 = document.getElementById("doughnutChart2").getContext("2d");
            new Chart(ctx4, {type: 'doughnut', data: doughnutData, options:doughnutOptions});

        });
    </script> 
		 
		 
		 
    