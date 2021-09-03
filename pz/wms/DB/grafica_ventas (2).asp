    <!-- ChartJS--> 
<script src="/Template/inspina/js/plugins/chartJs/Chart.min.js"></script>
<div class="ibox float-e-margins">
	<div class="ibox-title">
    	<H5 align="center"><%Response.Write("IZZI Ventas")%></H5>
    </div>
    <div class="ibox-content">
		<iframe class="chartjs-hidden-iframe" style="width: 100%; display: block; border: 0px; height: 0px; margin: 0px; position: absolute; left: 0px; right: 0px; top: 0px; bottom: 0px;"></iframe>
         <canvas id="lineChart" height="280" width="602" style="display: block; width: 602px; height: 280px;"></canvas>
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