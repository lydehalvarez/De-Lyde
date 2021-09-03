<link href="/Template/inspina/css/bootstrap.min.css" rel="stylesheet">
<link href="/Template/inspina/font-awesome/css/font-awesome.css" rel="stylesheet">
    <!-- Toastr style -->
<link href="/Template/inspina/css/plugins/toastr/toastr.min.css" rel="stylesheet">
    <!-- Gritter -->
<link href="/Template/inspina/js/plugins/gritter/jquery.gritter.css" rel="stylesheet">
<link href="/Template/inspina/css/animate.css" rel="stylesheet">
<link href="/Template/inspina/css/style.css" rel="stylesheet">
	                <!-- Primer DashBoard -->
<div class="row border-bottom white-bg dashboard-header">
	<div class="col-lg-3">
		<div class="ibox float-e-margins">    
    		<div class="ibox-title">
            	<span class="label label-primary pull-right">Today</span>
        		<h5><%Response.Write("Ventas")%></h5>
        	</div>
        	<div class="ibox-content">
        		<h1 class="no-margins"><%Response.Write("125")%></h1>
        		<div class="stat-percent font-bold text-navy"><%Response.Write("12%")%><i class="fa fa-level-up"></i></div>
            	<small><%Response.Write("Celulares vendidos IZZI")%></small>
         	</div>
    	</div>
	</div>
</div>				
	                <!-- Segundo DashBoard -->
<div class="row">
	<div class="col-lg-3">
   		<ul class="stat-list">
   		<li>
   			<h2 class="no-margins">2,346</h2>
        	<small>Total orders in period</small>
        	<div class="stat-percent">48% <i class="fa fa-level-up text-navy"></i></div>
        	<div class="progress progress-mini">
            	<div style="width: 48%;" class="progress-bar"></div>
        	</div>
   		</li>
   		<li>
         	<h2 class="no-margins ">4,422</h2>
         	<small>Orders in last month</small>
         	<div class="stat-percent">60% <i class="fa fa-level-down text-navy"></i></div>
         	<div class="progress progress-mini">
            	<div style="width: 60%;" class="progress-bar"></div>
         	</div>
   		</li>   		
        <li>
         	<h2 class="no-margins ">9,180</h2>
         	<small>Monthly income from orders</small>
         	<div class="stat-percent">22% <i class="fa fa-bolt text-navy"></i></div>
         	<div class="progress progress-mini">
            	<div style="width: 22%;" class="progress-bar"></div>
         	</div>
   		</li>
   		</ul>
   </div>
</div>
	                <!-- Tercer DashBoard -->
<div class="row border-bottom white-bg dashboard-header">                
	<div class="col-lg-4">
   		<div class="ibox float-e-margins">
    		<div class="ibox-title">
        		<span class="label label-warning pull-right">Annual</span>
        		<h5>Income</h5>
      		</div>
    	<div class="ibox-content">
        	<h1 class="no-margins">$ 120 430,800</h1>
         	<div class="stat-percent font-bold text-warning">16% <i class="fa fa-level-up"></i></div>
         	<small>New orders</small>
      	</div>
    	</div>
	</div>
</div>
	                <!-- Cuarto DashBoard -->
<div class="row">                    
      <div class="col-lg-4">
         <h5 class="m-b-xs">Income last month</h5>
         <h1 class="no-margins">160,000</h1>
         <div class="font-bold text-navy">98% <i class="fa fa-bolt"></i></div>
      </div>
      <div class="col-lg-4">
         <h5 class="m-b-xs">Sals current year</h5>
         <h1 class="no-margins">42,120</h1>
         <div class="font-bold text-navy">98% <i class="fa fa-bolt"></i></div>
      </div>  
</div>
	                <!-- Quinto DashBoard --> 
<div class="row">                         
	<div class="col-lg-4">
   		<div class="ibox float-e-margins">
      	<div class="ibox-title">
         <h5>Monthly income</h5>
         <div class="ibox-tools">
            <span class="label label-primary">Updated 12.2015</span>
         </div>
      	</div>
      	<div class="ibox-content no-padding">
         <div class="flot-chart m-t-lg" style="height: 55px;">
            <div class="flot-chart-content" id="flot-chart1" style="padding: 0px; position: relative;">
               <canvas class="flot-base" width="417" height="55" style="direction: ltr; position: absolute; left: 0px; top: 0px; width: 417.656px; height: 55px;"></canvas>
               <canvas class="flot-overlay" width="417" height="55" style="direction: ltr; position: absolute; left: 0px; top: 0px; width: 417.656px; height: 55px;"></canvas>
            </div>
         </div>
      </div>
   </div>
</div>  
</div>   
	                <!-- Sexto DashBoard -->   
<div class="col-lg-2">
   <div class="ibox float-e-margins">
      <div class="ibox-title">
         <span class="label label-success pull-right">Monthly</span>
         <h5>Views</h5>
      </div>
      <div class="ibox-content">
         <h1 class="no-margins">386,200</h1>
         <div class="stat-percent font-bold text-success">98% <i class="fa fa-bolt"></i></div>
         <small>Total views</small>
      </div>
   </div>
</div>                             
	                <!-- Septimo DashBoard -->                         
<div class="row">     
<div class="row">
   <div class="col-lg-12">
      <div class="flot-chart m-b-xl">
         <div class="flot-chart-content" id="flot-dashboard5-chart" style="padding: 0px; position: relative;">
            <canvas class="flot-base" width="1263" height="200" style="direction: ltr; position: absolute; left: 0px; top: 0px; width: 1263px; height: 200px;"></canvas>
            <div class="flot-text" style="position: absolute; top: 0px; left: 0px; bottom: 0px; right: 0px; font-size: smaller; color: rgb(84, 84, 84);">
               <div class="flot-x-axis flot-x1-axis xAxis x1Axis" style="position: absolute; top: 0px; left: 0px; bottom: 0px; right: 0px;">
                  <div class="flot-tick-label tickLabel" style="position: absolute; max-width: 140px; top: 183px; left: 17px; text-align: center;">0</div>
                  <div class="flot-tick-label tickLabel" style="position: absolute; max-width: 140px; top: 183px; left: 171px; text-align: center;">2</div>
                  <div class="flot-tick-label tickLabel" style="position: absolute; max-width: 140px; top: 183px; left: 326px; text-align: center;">4</div>
                  <div class="flot-tick-label tickLabel" style="position: absolute; max-width: 140px; top: 183px; left: 480px; text-align: center;">6</div>
                  <div class="flot-tick-label tickLabel" style="position: absolute; max-width: 140px; top: 183px; left: 635px; text-align: center;">8</div>
                  <div class="flot-tick-label tickLabel" style="position: absolute; max-width: 140px; top: 183px; left: 786px; text-align: center;">10</div>
                  <div class="flot-tick-label tickLabel" style="position: absolute; max-width: 140px; top: 183px; left: 941px; text-align: center;">12</div>
                  <div class="flot-tick-label tickLabel" style="position: absolute; max-width: 140px; top: 183px; left: 1095px; text-align: center;">14</div>
                  <div class="flot-tick-label tickLabel" style="position: absolute; max-width: 140px; top: 183px; left: 1250px; text-align: center;">16</div>
               </div>
               <div class="flot-y-axis flot-y1-axis yAxis y1Axis" style="position: absolute; top: 0px; left: 0px; bottom: 0px; right: 0px;">
                  <div class="flot-tick-label tickLabel" style="position: absolute; top: 171px; left: 8px; text-align: right;">0</div>
                  <div class="flot-tick-label tickLabel" style="position: absolute; top: 137px; left: 8px; text-align: right;">5</div>
                  <div class="flot-tick-label tickLabel" style="position: absolute; top: 103px; left: 2px; text-align: right;">10</div>
                  <div class="flot-tick-label tickLabel" style="position: absolute; top: 69px; left: 2px; text-align: right;">15</div>
                  <div class="flot-tick-label tickLabel" style="position: absolute; top: 35px; left: 2px; text-align: right;">20</div>
                  <div class="flot-tick-label tickLabel" style="position: absolute; top: 1px; left: 2px; text-align: right;">25</div>
               </div>
            </div>
            <canvas class="flot-overlay" width="1263" height="200" style="direction: ltr; position: absolute; left: 0px; top: 0px; width: 1263px; height: 200px;"></canvas>
         </div>
      </div>
   </div>
</div>       
	                <!-- Octavo DashBoard -->    
<div class="row">                       
	<div class="col-md-4">
   		<ul class="stat-list m-t-lg">
      	<li>
        	<h2 class="no-margins">2,346</h2>
         	<small>Total orders in period</small>
         	<div class="progress progress-mini">
            	<div class="progress-bar" style="width: 48%;"></div>
         	</div>
      	</li>
      	<li>
        	<h2 class="no-margins ">4,422</h2>
         	<small>Orders in last month</small>
         	<div class="progress progress-mini">
            	<div class="progress-bar" style="width: 60%;"></div>
         	</div>
      	</li>
   		</ul>
	</div>
</div>   
	                <!-- Noveno DashBoard -->
<div class="col-lg-6">
   <iframe class="chartjs-hidden-iframe" style="width: 100%; display: block; border: 0px; height: 0px; margin: 0px; position: absolute; left: 0px; right: 0px; top: 0px; bottom: 0px;"></iframe>
   <canvas id="doughnutChart" width="80" height="80" style="margin: 18px auto 0px; display: block; width: 80px; height: 80px;"></canvas>
   <h5>Maxtor</h5>
</div>       
<div class="row border-bottom white-bg dashboard-header"> </div>
	<div class="col-md-3">&nbsp;</div>
	<div class="col-md-3">&nbsp;</div>  
	                <!-- Decimo DashBoard -->  
<div class="row">                       
<div class="ibox-content">
   <div>
      <div class="pull-right text-right">
         <span class="bar_dashboard" style="display: none;">5,3,9,6,5,9,7,3,5,2,4,7,3,2,7,9,6,4,5,7,3,2,1,0,9,5,6,8,3,2,1</span>
         <svg class="peity" height="16" width="100">
            <rect fill="#1ab394" x="0" y="7.111111111111111" width="2.2580645161290325" height="8.88888888888889"></rect>
            <rect fill="#d7d7d7" x="3.2580645161290325" y="10.666666666666668" width="2.2580645161290325" height="5.333333333333333"></rect>
            <rect fill="#1ab394" x="6.516129032258065" y="0" width="2.2580645161290325" height="16"></rect>
            <rect fill="#d7d7d7" x="9.774193548387098" y="5.333333333333334" width="2.2580645161290325" height="10.666666666666666"></rect>
            <rect fill="#1ab394" x="13.03225806451613" y="7.111111111111111" width="2.2580645161290325" height="8.88888888888889"></rect>
            <rect fill="#d7d7d7" x="16.290322580645164" y="0" width="2.2580645161290325" height="16"></rect>
            <rect fill="#1ab394" x="19.548387096774196" y="3.555555555555557" width="2.2580645161290325" height="12.444444444444443"></rect>
            <rect fill="#d7d7d7" x="22.806451612903228" y="10.666666666666668" width="2.2580645161290325" height="5.333333333333333"></rect>
            <rect fill="#1ab394" x="26.06451612903226" y="7.111111111111111" width="2.2580645161290325" height="8.88888888888889"></rect>
            <rect fill="#d7d7d7" x="29.322580645161292" y="12.444444444444445" width="2.2580645161290325" height="3.5555555555555554"></rect>
            <rect fill="#1ab394" x="32.58064516129033" y="8.88888888888889" width="2.2580645161290325" height="7.111111111111111"></rect>
            <rect fill="#d7d7d7" x="35.83870967741936" y="3.555555555555557" width="2.2580645161290325" height="12.444444444444443"></rect>
            <rect fill="#1ab394" x="39.09677419354839" y="10.666666666666668" width="2.2580645161290325" height="5.333333333333333"></rect>
            <rect fill="#d7d7d7" x="42.35483870967742" y="12.444444444444445" width="2.2580645161290325" height="3.5555555555555554"></rect>
            <rect fill="#1ab394" x="45.612903225806456" y="3.555555555555557" width="2.2580645161290325" height="12.444444444444443"></rect>
            <rect fill="#d7d7d7" x="48.87096774193549" y="0" width="2.2580645161290325" height="16"></rect>
            <rect fill="#1ab394" x="52.12903225806452" y="5.333333333333334" width="2.2580645161290325" height="10.666666666666666"></rect>
            <rect fill="#d7d7d7" x="55.38709677419355" y="8.88888888888889" width="2.2580645161290325" height="7.111111111111111"></rect>
            <rect fill="#1ab394" x="58.645161290322584" y="7.111111111111111" width="2.2580645161290325" height="8.88888888888889"></rect>
            <rect fill="#d7d7d7" x="61.903225806451616" y="3.555555555555557" width="2.2580645161290325" height="12.444444444444443"></rect>
            <rect fill="#1ab394" x="65.16129032258065" y="10.666666666666668" width="2.2580645161290325" height="5.333333333333333"></rect>
            <rect fill="#d7d7d7" x="68.41935483870968" y="12.444444444444445" width="2.2580645161290325" height="3.5555555555555554"></rect>
            <rect fill="#1ab394" x="71.67741935483872" y="14.222222222222221" width="2.2580645161290325" height="1.7777777777777777"></rect>
            <rect fill="#d7d7d7" x="74.93548387096774" y="15" width="2.2580645161290325" height="1"></rect>
            <rect fill="#1ab394" x="78.19354838709678" y="0" width="2.2580645161290325" height="16"></rect>
            <rect fill="#d7d7d7" x="81.45161290322581" y="7.111111111111111" width="2.2580645161290325" height="8.88888888888889"></rect>
            <rect fill="#1ab394" x="84.70967741935485" y="5.333333333333334" width="2.2580645161290325" height="10.666666666666666"></rect>
            <rect fill="#d7d7d7" x="87.96774193548387" y="1.7777777777777786" width="2.2580645161290325" height="14.222222222222221"></rect>
            <rect fill="#1ab394" x="91.22580645161291" y="10.666666666666668" width="2.2580645161290325" height="5.333333333333333"></rect>
            <rect fill="#d7d7d7" x="94.48387096774194" y="12.444444444444445" width="2.2580645161290325" height="3.5555555555555554"></rect>
            <rect fill="#1ab394" x="97.74193548387098" y="14.222222222222221" width="2.2580645161290325" height="1.7777777777777777"></rect>
         </svg>
         <br>
         <small class="font-bold">$ 20 054.43</small>
      </div>
         <br>
      </h4>
   </div>
</div>     
</div>
	                <!-- Onceavo DashBoard -->
<li class="list-group-item">
   <div class="text-center m">
      <span id="sparkline8">
         <canvas width="170" height="150" style="display: inline-block; width: 170px; height: 150px; vertical-align: top;"></canvas>
      </span>
   </div>
</li>      
	                <!-- Doceavo DashBoard -->  
<div class="col-lg-3">
   <div class="ibox float-e-margins">
      <div class="ibox-title">
         <span class="label label-primary pull-right">Today</span>
         <h5>visits</h5>
      </div>
      <div class="ibox-content">
         <h1 class="no-margins">106,120</h1>
         <div class="stat-percent font-bold text-navy">44% <i class="fa fa-level-up"></i></div>
         <small>New visits</small>
      </div>
   </div>
</div>                           
    <!-- Flot -->
<script src="/Template/inspina/js/plugins/flot/jquery.flot.js"></script>
<script src="/Template/inspina/js/plugins/flot/jquery.flot.tooltip.min.js"></script>
<script src="/Template/inspina/js/plugins/flot/jquery.flot.spline.js"></script>
<script src="/Template/inspina/js/plugins/flot/jquery.flot.resize.js"></script>
<script src="/Template/inspina/js/plugins/flot/jquery.flot.pie.js"></script>
    <!-- Mainly scripts -->
<script src="/Template/inspina/js/jquery-3.1.1.min.js"></script>
<script src="/Template/inspina/js/bootstrap.min.js"></script>
<script src="/Template/inspina/js/plugins/metisMenu/jquery.metisMenu.js"></script>
<script src="/Template/inspina/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
    <!-- Peity -->
<script src="/Template/inspina/js/plugins/peity/jquery.peity.min.js"></script>
<script src="/Template/inspina/js/demo/peity-demo.js"></script>
    <!-- Custom and plugin javascript -->
<script src="/Template/inspina/js/inspinia.js"></script>
<script src="/Template/inspina/js/plugins/pace/pace.min.js"></script>
    <!-- jQuery UI -->
<script src="/Template/inspina/js/plugins/jquery-ui/jquery-ui.min.js"></script>
    <!-- GITTER -->
<script src="/Template/inspina/js/plugins/gritter/jquery.gritter.min.js"></script>
    <!-- Sparkline -->
<script src="/Template/inspina/js/plugins/sparkline/jquery.sparkline.min.js"></script>
    <!-- Sparkline demo data  -->
<script src="/Template/inspina/js/demo/sparkline-demo.js"></script>
    <!-- ChartJS-->
<script src="/Template/inspina/js/plugins/chartJs/Chart.min.js"></script>
    <!-- Toastr -->
<script src="/Template/inspina/js/plugins/toastr/toastr.min.js"></script>
<script>
     $(document).ready(function() {

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
		 
		 
		 
    