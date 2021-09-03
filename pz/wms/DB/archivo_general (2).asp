    <%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
	<!--#include file="../../../Includes/iqon.asp" -->
    <link href="/Template/inspina/css/bootstrap.min.css" rel="stylesheet">
    <link href="/Template/inspina/font-awesome/css/font-awesome.css" rel="stylesheet">
    <link href="/Template/inspina/css/animate.css" rel="stylesheet">
    <link href="/Template/inspina/css/style.css" rel="stylesheet">
    <!-- ChartJS--> 
	<script src="/Template/inspina/js/plugins/chartJs/Chart.min.js"></script>    
    <!-- Mainly scripts -->
    <script src="/Template/inspina/js/jquery-3.1.1.min.js"></script>
    <script src="/Template/inspina/js/bootstrap.min.js"></script>
    <script src="/Template/inspina/js/plugins/metisMenu/jquery.metisMenu.js"></script>
    <script src="/Template/inspina/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
    <!-- Flot -->
    <script src="/Template/inspina/js/plugins/flot/jquery.flot.js"></script>
    <script src="/Template/inspina/js/plugins/flot/jquery.flot.tooltip.min.js"></script>
    <script src="/Template/inspina/js/plugins/flot/jquery.flot.spline.js"></script>
    <script src="/Template/inspina/js/plugins/flot/jquery.flot.resize.js"></script>
    <script src="/Template/inspina/js/plugins/flot/jquery.flot.pie.js"></script>
    <script src="/Template/inspina/js/plugins/flot/jquery.flot.symbol.js"></script>
    <script src="/Template/inspina/js/plugins/flot/jquery.flot.time.js"></script>
    <!-- Peity -->
    <script src="/Template/inspina/js/plugins/peity/jquery.peity.min.js"></script>
    <script src="/Template/inspina/js/demo/peity-demo.js"></script>
    <!-- Custom and plugin javascript -->
    <script src="/Template/inspina/js/inspinia.js"></script>
    <script src="/Template/inspina/js/plugins/pace/pace.min.js"></script>
    <!-- jQuery UI -->
    <script src="/Template/inspina/js/plugins/jquery-ui/jquery-ui.min.js"></script>
    <!-- Jvectormap -->
    <script src="/Template/inspina/js/plugins/jvectormap/jquery-jvectormap-2.0.2.min.js"></script>
    <script src="/Template/inspina/js/plugins/jvectormap/jquery-jvectormap-world-mill-en.js"></script>
    <!-- EayPIE -->
    <script src="/Template/inspina/js/plugins/easypiechart/jquery.easypiechart.js"></script>
    <!-- Sparkline -->
    <script src="/Template/inspina/js/plugins/sparkline/jquery.sparkline.min.js"></script>
    <!-- Sparkline demo data  -->
    <script src="/Template/inspina/js/demo/sparkline-demo.js"></script>
<div class="row">
   <div class="col-lg-12">
      <div class="ibox float-e-margins">
         <div class="ibox-title">
            <h5>Orders</h5>
            <div class="pull-right">
               <div class="btn-group">
                  <button type="button" class="btn btn-xs btn-white active">Hoy</button>
                  <button type="button" class="btn btn-xs btn-white">Mensual</button>
                  <button type="button" class="btn btn-xs btn-white">Anual</button>
               </div>
            </div>
         </div>
         <div class="ibox-content">
            <div class="row">
               <div class="col-lg-9">
                  <div class="flot-chart">
                     <div class="flot-chart-content" id="flot-dashboard-chart" style="padding: 0px; position: relative;">
                        <canvas class="flot-base" width="449" height="200" style="direction: ltr; position: absolute; left: 0px; top: 0px; width: 449px; height: 200px;"></canvas>
                        <div class="flot-text" style="position: absolute; top: 0px; left: 0px; bottom: 0px; right: 0px; font-size: smaller; color: rgb(84, 84, 84);">
                           <div class="flot-x-axis flot-x1-axis xAxis x1Axis" style="position: absolute; top: 0px; left: 0px; bottom: 0px; right: 0px;">
                              <div class="flot-tick-label tickLabel" style="position: absolute; max-width: 64px; top: 185px; left: 41px; text-align: center;">Enero 03</div>
                              <div class="flot-tick-label tickLabel" style="position: absolute; max-width: 64px; top: 185px; left: 80px; text-align: center;">Jan 06</div>
                              <div class="flot-tick-label tickLabel" style="position: absolute; max-width: 64px; top: 185px; left: 119px; text-align: center;">Jan 09</div>
                              <div class="flot-tick-label tickLabel" style="position: absolute; max-width: 64px; top: 185px; left: 158px; text-align: center;">Jan 12</div>
                              <div class="flot-tick-label tickLabel" style="position: absolute; max-width: 64px; top: 185px; left: 196px; text-align: center;">Jan 15</div>
                              <div class="flot-tick-label tickLabel" style="position: absolute; max-width: 64px; top: 185px; left: 235px; text-align: center;">Jan 18</div>
                              <div class="flot-tick-label tickLabel" style="position: absolute; max-width: 64px; top: 185px; left: 274px; text-align: center;">Jan 21</div>
                              <div class="flot-tick-label tickLabel" style="position: absolute; max-width: 64px; top: 185px; left: 313px; text-align: center;">Jan 24</div>
                              <div class="flot-tick-label tickLabel" style="position: absolute; max-width: 64px; top: 185px; left: 352px; text-align: center;">Jan 27</div>
                              <div class="flot-tick-label tickLabel" style="position: absolute; max-width: 64px; top: 185px; left: 391px; text-align: center;">Jan 30</div>
                           </div>
                           <div class="flot-y-axis flot-y1-axis yAxis y1Axis" style="position: absolute; top: 0px; left: 0px; bottom: 0px; right: 0px;">
                              <div class="flot-tick-label tickLabel" style="position: absolute; top: 173px; left: 19px; text-align: right;">0</div>
                              <div class="flot-tick-label tickLabel" style="position: absolute; top: 132px; left: 6px; text-align: right;">250</div>
                              <div class="flot-tick-label tickLabel" style="position: absolute; top: 92px; left: 6px; text-align: right;">500</div>
                              <div class="flot-tick-label tickLabel" style="position: absolute; top: 52px; left: 6px; text-align: right;">750</div>
                              <div class="flot-tick-label tickLabel" style="position: absolute; top: 12px; left: 0px; text-align: right;">1000</div>
                           </div>
                           <div class="flot-y-axis flot-y2-axis yAxis y2Axis" style="position: absolute; top: 0px; left: 0px; bottom: 0px; right: 0px;">
                              <div class="flot-tick-label tickLabel" style="position: absolute; top: 173px; left: 437px;">0</div>
                              <div class="flot-tick-label tickLabel" style="position: absolute; top: 144px; left: 437px;">5</div>
                              <div class="flot-tick-label tickLabel" style="position: absolute; top: 115px; left: 437px;">10</div>
                              <div class="flot-tick-label tickLabel" style="position: absolute; top: 87px; left: 437px;">15</div>
                              <div class="flot-tick-label tickLabel" style="position: absolute; top: 58px; left: 437px;">20</div>
                              <div class="flot-tick-label tickLabel" style="position: absolute; top: 29px; left: 437px;">25</div>
                              <div class="flot-tick-label tickLabel" style="position: absolute; top: 1px; left: 437px;">30</div>
                           </div>
                        </div>
                        <canvas class="flot-overlay" width="449" height="200" style="direction: ltr; position: absolute; left: 0px; top: 0px; width: 449px; height: 200px;"></canvas>
                        <div class="legend">
                           <div style="position: absolute; width: 111px; height: 30px; top: 13px; left: 35px; background-color: rgb(255, 255, 255); opacity: 0.85;"> </div>
                           <table style="position:absolute;top:13px;left:35px;;font-size:smaller;color:#545454">
                              <tbody>
                                 <tr>
                                    <td class="legendColorBox">
                                       <div style="border:1px solid #000000;padding:1px">
                                          <div style="width:4px;height:0;border:5px solid #1ab394;overflow:hidden"></div>
                                       </div>
                                    </td>
                                    <td class="legendLabel">Numero de ordenes</td>
                                 </tr>
                                 <tr>
                                    <td class="legendColorBox">
                                       <div style="border:1px solid #000000;padding:1px">
                                          <div style="width:4px;height:0;border:5px solid #1C84C6;overflow:hidden"></div>
                                       </div>
                                    </td>
                                    <td class="legendLabel">Pagos</td>
                                 </tr>
                              </tbody>
                           </table>
                        </div>
                     </div>
                  </div>
               </div>
            </div>
         </div>
      </div>
   </div>
<div class="col-lg-3">
   <ul class="stat-list">
      <li>
         <h2 class="no-margins"><%Response.Write("235")%></h2>
         <small><%Response.Write("Total de ordenes")%></small>
         <div class="stat-percent"><%Response.Write("35%")%> <i class="fa fa-level-up text-navy"></i></div>
         <div class="progress progress-mini">
            <div style="width: <%Response.Write("35%")%>;" class="progress-bar"></div>
         </div>
      </li>
      <li>
         <h2 class="no-margins "><%Response.Write("125")%></h2>
         <small><%Response.Write("Ordenes de venta")%></small>
         <div class="stat-percent"><%Response.Write("40%")%> <i class="fa fa-level-down text-navy"></i></div>
         <div class="progress progress-mini">
            <div style="width:<%Response.Write("40%")%>;" class="progress-bar"></div>
         </div>
      </li>
      <li>
         <h2 class="no-margins "><%Response.Write("36")%></h2>
         <small><%Response.Write("Ingresos mensuales de pedidos")%></small>
         <div class="stat-percent"><%Response.Write("25%")%> <i class="fa fa-bolt text-navy"></i></div>
         <div class="progress progress-mini">
            <div style="width:<%Response.Write("25%")%>;" class="progress-bar"></div>
         </div>
      </li>
   </ul>
</div>
</div>  
<div class="row">
	<div class="col-lg-3">
   		<div class="ibox float-e-margins">
      		<div class="ibox-title">
         		<span class="label label-success pull-right"><%Response.Write("Mensual")%></span>
         		<h5><%Response.Write("Ingreso mensual")%></h5>
      		</div>
      		<div class="ibox-content">
        		<h1 class="no-margins"><%Response.Write("1,200,000")%></h1>
         		<div class="stat-percent font-bold text-success"><%Response.Write("43%")%><i class="fa fa-bolt"></i></div>
         			<small><%Response.Write("Total de Ingeso mensual")%></small>
      			</div>
   			</div>
		</div>
	</div>
</div>
<div class="row">
<div class="col-lg-6">
   <div class="ibox float-e-margins">
      <div class="ibox-title">
         <h5><%Response.Write("Lista de proyectos del usuario")%></h5>
         <div class="ibox-tools">
            <a class="collapse-link">
            <i class="fa fa-chevron-up"></i>
            </a>
            <a class="close-link">
            <i class="fa fa-times"></i>
            </a>
         </div>
      </div>
      <div class="ibox-content" style="">
         <table class="table table-hover no-margins">
            <thead>
               <tr>
                  <th>Estatus</th>
                  <th>Fecha</th>
                  <th>Usuario</th>
                  <th>Valor</th>
               </tr>
            </thead>
            <tbody>
               <tr>
                  <td><small>Pendiente...</small></td>
                  <td><i class="fa fa-clock-o"></i> 11:20pm</td>
                  <td>Samantha</td>
                  <td class="text-navy"> <i class="fa fa-level-up"></i> 24% </td>
               </tr>
               <tr>
                  <td><span class="label label-warning">Cancelado</span> </td>
                  <td><i class="fa fa-clock-o"></i> 10:40am</td>
                  <td>Monica</td>
                  <td class="text-navy"> <i class="fa fa-level-up"></i> 66% </td>
               </tr>
               <tr>
                  <td><small>Pendiente...</small> </td>
                  <td><i class="fa fa-clock-o"></i> 01:30pm</td>
                  <td>John</td>
                  <td class="text-navy"> <i class="fa fa-level-up"></i> 54% </td>
               </tr>
               <tr>
                  <td><small>Pendiente...</small> </td>
                  <td><i class="fa fa-clock-o"></i> 02:20pm</td>
                  <td>Agnes</td>
                  <td class="text-navy"> <i class="fa fa-level-up"></i> 12% </td>
               </tr>
               <tr>
                  <td><small>Entregado...</small> </td>
                  <td><i class="fa fa-clock-o"></i> 09:40pm</td>
                  <td>Carlos</td>
                  <td class="text-navy"> <i class="fa fa-level-up"></i> 22% </td>
               </tr>
               <tr>
                  <td><span class="label label-primary">Completado</span> </td>
                  <td><i class="fa fa-clock-o"></i> 04:10am</td>
                  <td>Amelia</td>
                  <td class="text-navy"> <i class="fa fa-level-up"></i> 66% </td>
               </tr>
               <tr>
                  <td><small>Pendiente...</small> </td>
                  <td><i class="fa fa-clock-o"></i> 12:08am</td>
                  <td>Damian</td>
                  <td class="text-navy"> <i class="fa fa-level-up"></i> 23% </td>
               </tr>
            </tbody>
         </table>
      </div>
   </div>
</div>
</div>
<div class="row">
   <div class="col-lg-12">
      <div class="ibox float-e-margins">
         <div class="ibox-title">
         </div>
      </div>
   </div>
</div>
<div class="row">
<div class="col-lg-6">
   <div class="ibox float-e-margins">
      <div class="ibox-title">
      <H5 align="center"><%Response.Write("IZZI Ventas")%></H5>
      </div>
      <div class="ibox-content">
         <div>
            <iframe class="chartjs-hidden-iframe" style="width: 100%; display: block; border: 0px; height: 0px; margin: 0px; position: absolute; left: 0px; right: 0px; top: 0px; bottom: 0px;"></iframe>
            <canvas id="lineChart" height="280" width="602" style="display: block; width: 602px; height: 280px;"></canvas>
         </div>
      </div>
   </div>
</div>
</div>
<script>
    var lineData = 
	{
        labels: ["<%Response.Write("Enero")%>","<%Response.Write("Febrero")%>","<%Response.Write("Marzo")%>","<%Response.Write("Abril")%>","<%Response.Write("Mayo")%>","<%Response.Write("Junio")%>","<%Response.Write("Julio")%>"],
        datasets: 
		[
            {
                label: "<%Response.Write("Grafica 1")%>",
                backgroundColor: 'rgba(26,179,148,0.5)',
                borderColor: "rgba(26,179,148,0.7)",
                pointBackgroundColor: "rgba(26,179,148,1)",
                pointBorderColor: "#fff",
                data: [28, 48, 40, 19, 86, 27, 90]
            },
			{
                label:"<%Response.Write("Grafica 2")%>",
                backgroundColor:'rgba(220, 220, 220, 0.5)',
                pointBorderColor:"#fff",
                data: [65,59,80,81,56,55,40]
            }
        ]
    };
    var lineOptions = 
	{
        responsive: true
    };
    var ctx = document.getElementById("lineChart").getContext("2d");
    new Chart(ctx, {type: 'line', data: lineData, options:lineOptions});
</script>
<script>
   $(document).ready(function() 
   {
       $('.chart').easyPieChart({
           barColor: '#f8ac59',
   //                scaleColor: false,
           scaleLength: 5,
           lineWidth: 4,
           size: 80
       });   
       $('.chart2').easyPieChart({
           barColor: '#1c84c6',
   //                scaleColor: false,
           scaleLength: 5,
           lineWidth: 4,
           size: 80
       });   
       var data2 = 
	   [
           [gd(2012, 1, 1), 7], [gd(2012, 1, 2), 6], [gd(2012, 1, 3), 4], [gd(2012, 1, 4), 8],
           [gd(2012, 1, 5), 9], [gd(2012, 1, 6), 7], [gd(2012, 1, 7), 5], [gd(2012, 1, 8), 4],
           [gd(2012, 1, 9), 7], [gd(2012, 1, 10), 8], [gd(2012, 1, 11), 9], [gd(2012, 1, 12), 6],
           [gd(2012, 1, 13), 4],[gd(2012, 1, 14), 5], [gd(2012, 1, 15), 11], [gd(2012, 1, 16), 8],
           [gd(2012, 1, 17), 8],[gd(2012, 1, 18), 11], [gd(2012, 1, 19), 11], [gd(2012, 1, 20), 6],
           [gd(2012, 1, 21), 6],[gd(2012, 1, 22), 8], [gd(2012, 1, 23), 11], [gd(2012, 1, 24), 13],
           [gd(2012, 1, 25), 7],[gd(2012, 1, 26), 9], [gd(2012, 1, 27), 9], [gd(2012, 1, 28), 8],
           [gd(2012, 1, 29), 5],[gd(2012, 1, 30), 8], [gd(2012, 1, 31), 25]
       ];   
       var data3 = 
	   [
           [gd(2012, 1, 1), 800], [gd(2012, 1, 2), 500], [gd(2012, 1, 3), 600], [gd(2012, 1, 4), 700],
           [gd(2012, 1, 5), 500], [gd(2012, 1, 6), 456], [gd(2012, 1, 7), 800], [gd(2012, 1, 8), 589],
           [gd(2012, 1, 9), 467], [gd(2012, 1, 10), 876], [gd(2012, 1, 11), 689], [gd(2012, 1, 12), 700],
           [gd(2012, 1, 13), 500], [gd(2012, 1, 14), 600], [gd(2012, 1, 15), 700], [gd(2012, 1, 16), 786],
           [gd(2012, 1, 17), 345], [gd(2012, 1, 18), 888], [gd(2012, 1, 19), 888], [gd(2012, 1, 20), 888],
           [gd(2012, 1, 21), 987], [gd(2012, 1, 22), 444], [gd(2012, 1, 23), 999], [gd(2012, 1, 24), 567],
           [gd(2012, 1, 25), 786], [gd(2012, 1, 26), 666], [gd(2012, 1, 27), 888], [gd(2012, 1, 28), 900],
           [gd(2012, 1, 29), 178], [gd(2012, 1, 30), 555], [gd(2012, 1, 31), 993]
       ];   
       var dataset = 
	   [
           {
               label: "Numero orden",
               data: data3,
               color: "#1ab394",
               bars: {
                   show: true,
                   align: "center",
                   barWidth: 24 * 60 * 60 * 600,
                   lineWidth:0
               }
   
           }, {
               label: "Pagos",
               data: data2,
               yaxis: 2,
               color: "#1C84C6",
               lines: {
                   lineWidth:1,
                       show: true,
                       fill: true,
                   fillColor: {
                       colors: [{
                           opacity: 0.2
                       }, {
                           opacity: 0.4
                       }]
                   }
               },
               splines: {
                   show: false,
                   tension: 0.6,
                   lineWidth: 1,
                   fill: 0.1
               },
           }
       ];   
       var options = 
	   {
           xaxis: {
               mode: "time",
               tickSize: [3, "day"],
               tickLength: 0,
               axisLabel: "Date",
               axisLabelUseCanvas: true,
               axisLabelFontSizePixels: 12,
               axisLabelFontFamily: 'Arial',
               axisLabelPadding: 10,
               color: "#d5d5d5"
           },
           yaxes: [{
               position: "left",
               max: 1070,
               color: "#d5d5d5",
               axisLabelUseCanvas: true,
               axisLabelFontSizePixels: 12,
               axisLabelFontFamily: 'Arial',
               axisLabelPadding: 3
           }, {
               position: "right",
               clolor: "#d5d5d5",
               axisLabelUseCanvas: true,
               axisLabelFontSizePixels: 12,
               axisLabelFontFamily: ' Arial',
               axisLabelPadding: 67
           }
           ],
           legend: {
               noColumns: 1,
               labelBoxBorderColor: "#000000",
               position: "nw"
           },
           grid: {
               hoverable: false,
               borderWidth: 0
           }
       };
   
       function gd(year, month, day) {
           return new Date(year, month - 1, day).getTime();
       }
       var previousPoint = null, previousLabel = null;
       $.plot($("#flot-dashboard-chart"),dataset,options);
       var mapData = {
           "US": 298,
           "SA": 200,
           "DE": 220,
           "FR": 540,
           "CN": 120,
           "AU": 760,
           "BR": 550,
           "IN": 200,
           "GB": 120,
       };
   
       $('#world-map').vectorMap({
           map: 'world_mill_en',
           backgroundColor: "transparent",
           regionStyle: {
               initial: {
                   fill: '#e4e4e4',
                   "fill-opacity": 0.9,
                   stroke: 'none',
                   "stroke-width": 0,
                   "stroke-opacity": 0
               }
           },
           series: {
               regions: [{
                   values: mapData,
                   scale: ["#1ab394", "#22d6b1"],
                   normalizeFunction: 'polynomial'
               }]
           },
       });
   });
</script>         