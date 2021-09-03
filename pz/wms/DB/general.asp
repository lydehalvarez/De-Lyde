<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
var Titulo = "Productos Celulares"
%>
    $("#sparkline8").sparkline([5, 6, 7, 2, 0, 4, 2, 4, 5, 7, 2, 4, 12, 14, 4, 2, 14, 12, 7], {
        type: 'bar',
        barWidth: 8,
        height: '350px',
        barColor: '#1ab394',
        negBarColor: '#c6c6c6'});

<div class="row"> 
	<div class="col-lg-3">
		<div class="ibox float-e-margins">
   			<div class="ibox-title">
      			<span class="label label-primary pull-right"><%Response.Write("Mes")%></span>
      			<h5><%=Titulo%></h5>
   			</div>
   		<div class="ibox-content">
      		<h1 class="no-margins"><%Response.Write("34")%></h1>
      		<div class="stat-percent font-bold text-navy"><%Response.Write("52%")%><i class="fa fa-level-up"></i></div>
      			<small><%Response.Write("Almacen")%></small>
   			</div>
		</div>
	</div>
	<div class="col-lg-4">
		<div class="ibox float-e-margins">
   			<div class="ibox-title">
      			<span class="label label-primary pull-right"><%Response.Write("Mes")%></span>
      			<h5><%Response.Write("Productos Laptos")%></h5>
   			</div>
   		<div class="ibox-content">
      		<h1 class="no-margins"><%Response.Write("250")%></h1>
      		<div class="stat-percent font-bold text-navy"><%Response.Write("43%")%><i class="fa fa-level-up"></i></div>
      			<small><%Response.Write("Izzi")%></small>
   			</div>
		</div>
	</div>
	<div class="col-lg-5">
   		<ul class="stat-list">
      		<li>
        		<h2 class="no-margins"><%Response.Write("254")%></h2>
         		<small><%Response.Write("Celulares Vendidos")%></small>
         		<div class="stat-percent"><%Response.Write("24%")%><i class="fa fa-level-up text-navy"></i></div>
         		<div class="progress progress-mini">
            		<div style="width: <%Response.Write("24%")%>;"class="progress-bar"></div>
         		</div>
      		</li>
      		<li>
        		<h2 class="no-margins "><%Response.Write("127")%></h2>
        		<small><%Response.Write("Ventas ultimos mes")%></small>
        		<div class="stat-percent"><%Response.Write("36%")%><i class="fa fa-level-down text-navy"></i></div>
        		<div class="progress progress-mini">
            		<div style="width:<%Response.Write("60%")%>;" class="progress-bar"></div>
        		</div>
      		</li>
      		<li>
        		<h2 class="no-margins "><%Response.Write("345")%></h2>
        		<small><%Response.Write("Ingresos mensuales por mes")%></small>
        		<div class="stat-percent"><%Response.Write("40%")%><i class="fa fa-bolt text-navy"></i></div>
        		<div class="progress progress-mini">
            		<div style="width:<%Response.Write("40%")%>;" class="progress-bar"></div>
        		</div>
      		</li>
   		</ul>
	</div>
</div>
<div id="chartContainer" style="height: 300px; width: 40%;"></div>