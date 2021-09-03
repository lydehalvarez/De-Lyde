<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
    <!-- ChartJS--> 
<script src="/Template/inspina/js/plugins/chartJs/Chart.min.js"></script>
	<div class="ibox float-e-margins">
	<div class="ibox-title">
    	<h10><%Response.Write("Izzi Ventas")%></h10>
    </div>
    <div class="ibox-content">
    	<iframe class="chartjs-hidden-iframe"style="width:100%;display:block;border:0px;height:0px;margin:0px;position:absolute;left:0px;                right:0px;top:0px;bottom:0px;">
        </iframe>
        <canvas id=<%Response.Write("grafica_dona1")%> height="480" width="602" style="display: block; width: 602px; height: 280px;"></canvas>
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
	while (!rsEtq.EOF)
	{
		 if(Etiquetas != "" ) {Etiquetas += ","}
		 if(Barra1 != "" ) {Barra1 += ","}
		 if(Barra2 != "" ) {Barra2 += ","}
		 if(Barra3 != "" ) {Barra3 += ","}		 
		 Etiquetas += '"' + rsEtq.Fields.Item("Pro_ClaveAlterna").Value + '"'
		 dato = rsEtq.Fields.Item("Cuenta").Value
		 Barra1 += dato
		 if(dato==0) {dato = 10 }
		 rsEtq.MoveNext()
	}
    rsEtq.Close() 
%>	
   	    var doughnutData = 
		{
			labels: [<%=Etiquetas%>],
			datasets:
			[
				{
					data: [<%=Barra1%>],
					backgroundColor:["#a3e1d4","#dedede","#b5b8cf","coral"]
				}
			]
    	};
    	var doughnutOptions = {responsive:true};
   	 	var ctx4 = document.getElementById("grafica_dona1").getContext("2d");
    	new Chart(ctx4,{type:'doughnut',data:doughnutData,options:doughnutOptions});
   </script>