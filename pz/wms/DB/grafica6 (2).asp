<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<div class ="col-lg-6">
   <div class="ibox float-e-margins">
      <div class="ibox-title">
         <h8><%Response.Write("Lyde Ventas")%></h8>
      </div>
      <div class="ibox-content">
         <div>
            <iframe class="chartjs-hidden-iframe" style="width: 100%; display: block; border: 0px; height: 0px; margin: 0px; position: absolute; left: 0px;             right: 0px; top: 0px; bottom: 0px;"></iframe>
            <canvas id="barChart" height="300" width="602" style="display: block; width: 602px; height: 280px;"></canvas>
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