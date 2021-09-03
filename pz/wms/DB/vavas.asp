<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
    <link href="/Template/inspina/css/bootstrap.min.css" rel="stylesheet">
    <link href="/Template/inspina/font-awesome/css/font-awesome.css" rel="stylesheet">
    <link href="/Template/inspina/css/animate.css" rel="stylesheet">
    <link href="/Template/inspina/css/style.css" rel="stylesheet">
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
<% 
%>
<div class ="row">
<div class ="col-lg-6">
   <div class="ibox float-e-margins">
      <div class="ibox-title">
         <h8><%Response.Write("Lyde Ventas")%></h8>
      </div>
      <div class="ibox-content">
         <div>
            <iframe class="chartjs-hidden-iframe" style="width: 100%; display: block; border: 0px; height: 0px; margin: 0px; position: absolute; left: 0px; right: 0px; top: 0px; bottom: 0px;"></iframe>
            <canvas id="barChart" height="300" width="602" style="display: block; width: 602px; height: 280px;"></canvas>
         </div>
      </div>
   </div>
</div>
<div class="col-lg-4">
   <div class="ibox float-e-margins">
      <div class="ibox-title">
         <h10><%Response.Write("Izzi Ventas")%></h10>
      </div>
      <div class="ibox-content">
         <div>
            <iframe class="chartjs-hidden-iframe" style="width: 100%; display: block; border: 0px; height: 0px; margin: 0px; position: absolute; left: 0px; right: 0px; top: 0px; bottom: 0px;"></iframe>
            <canvas id="doughnutChart" height="480" width="602" style="display: block; width: 602px; height: 280px;"></canvas>
         </div>
      </div>
   </div>
   </div>
<div class="row">
<div class="col-lg-6">
   <div class="ibox float-e-margins">
      <div class="ibox-title">
         <h5><%Response.Write("Ventas de SIMS")%></h5>
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
<%
	var Etiquetas = ""
    var Barra1 = ""
    var Barra2 = ""
    var Barra3 = ""
	var dato = 0
	var sSQLEtq  = "select Pro_ClaveAlterna, count(*) as Cuenta "
    	sSQLEtq += " from Orden_Venta_Articulo v, Producto p "
    	sSQLEtq += " where v.Pro_ID = p.Pro_ID "
    	sSQLEtq += " and v.Pro_ID in (select Pro_ID from Producto where Pro_Modelo <> 'SIM') "
    	sSQLEtq += " group by Pro_ClaveAlterna "
	var rsEtq = AbreTabla(sSQLEtq,1,0)
	 while (!rsEtq.EOF){
		 if(Etiquetas != "" ) {Etiquetas += ","}
		 if(Barra1 != "" ) {Barra1 += ","}
		 if(Barra2 != "" ) {Barra2 += ","}
		 if(Barra3 != "" ) {Barra3 += ","}
		 
			Etiquetas += '"' + rsEtq.Fields.Item("Pro_ClaveAlterna").Value + '"'
		    dato = rsEtq.Fields.Item("Cuenta").Value
		    Barra1 += dato
		 	if(dato==0) { dato = 10 }
		 	dato = (dato*2)
		    Barra2 += dato
		    dato = (dato/3)
		    Barra3 += dato
 
		rsEtq.MoveNext()
	}
    rsEtq.Close() 
%>								
   var barData = {
        labels: [<%=Etiquetas%>],
        datasets: 
		[
            {
                label: "<%Response.Write("SKU 1")%>",
                backgroundColor:'rgba(220, 220, 220, 0.5)',
                pointBorderColor:"#fff",
                data: [<%=Barra2%>]
            },
            {
                label: "<%Response.Write("Ventas 2")%>",
                backgroundColor: 'rgba(26,179,148,0.5)',
                borderColor: "rgba(26,179,148,0.7)",
                pointBackgroundColor: "rgba(26,179,148,1)",
                pointBorderColor: "#fff",
                data: [<%=Barra1%>]
            },
            {
                label: "<%Response.Write("Pronostico 3")%>",
                backgroundColor:"rgba(56,19,148,0.7)" ,
                borderColor: 'rgba(26,179,148,0.5)',
                pointBackgroundColor: "rgba(26,179,148,1)",
                pointBorderColor: "#fff",
                data: [<%=Barra3%>]
            }
        ]
    };

    var barOptions = {
        responsive: true
    };
    var ctx2 = document.getElementById("barChart").getContext("2d");
    new Chart(ctx2, {type:'bar',data:barData,options:barOptions});
   </script>
   <script> 
   	    var doughnutData = 
		{
			labels:["Venta de sims","Celulares","Laptops","Software"],
			datasets:
			[
				{
					data:[150,250,100,220],
					backgroundColor:["#a3e1d4","#dedede","#b5b8cf","coral"]
				}
			]
    	};
    	var doughnutOptions = {responsive:true};
   	 	var ctx4 = document.getElementById("doughnutChart").getContext("2d");
    	new Chart(ctx4,{type:'doughnut',data:doughnutData,options:doughnutOptions});
   </script>
   <script>
   var barData = {
        labels: ["<%Response.Write("Enero")%>","<%Response.Write("Febrero")%>","<%Response.Write("Marzo")%>","<%Response.Write("Abril")%>","<%Response.Write("Mayo")%>","<%Response.Write("Junio")%>","<%Response.Write("Julio")%>"],
        datasets: [
            {
                label: "<%Response.Write("Grafica 1")%>",
                backgroundColor: 'rgba(220, 220, 220, 0.5)',
                pointBorderColor: "#fff",
                data: [<%Response.Write("65")%>,<%Response.Write("59")%>,<%Response.Write("80")%>,<%Response.Write("81")%>,<%Response.Write("56")%>,<%Response.Write("55")%>,<%Response.Write("40")%>]
            },
            {
                label: "<%Response.Write("Grafica 2")%>",
                backgroundColor: 'rgba(26,179,148,0.5)',
                borderColor: "rgba(26,179,148,0.7)",
                pointBackgroundColor: "rgba(26,179,148,1)",
                pointBorderColor: "#fff",
				data: [<%Response.Write("28")%>,<%Response.Write("48")%>,<%Response.Write("40")%>,<%Response.Write("19")%>,<%Response.Write("86")%>,<%Response.Write("27")%>,<%Response.Write("90")%>]
            }
        ]
    };

    var barOptions = {
        responsive: true
    };


    var ctx2 = document.getElementById("lineChart").getContext("2d");
    new Chart(ctx2, {type:'line',data:barData, options:barOptions});
   </script>
</div>