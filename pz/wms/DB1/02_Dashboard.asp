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
     $(document).ready(function() {
	
<%
var CRn = 0
var CCol = 0
var Tpo = 0

var sSQLCarga = " select DsbR_ID,DsbC_ID,DsbC_TipoGrafico "
    sSQLCarga += " from Dashboard d, Dashboard_Columna c "
	sSQLCarga += " where d.Sys_ID = c.Sys_ID and c.Sys_ID = " + SistemaActual
	sSQLCarga += " and d.Mnu_ID = c.Mnu_ID "
	sSQLCarga += " and d.WgCfg_ID = c.WgCfg_ID AND c.WgCfg_ID = " + VentanaIndex
Response.Write(sSQLCarga)	 
 var rsCarga = AbreTabla(sSQLCarga,1,2) 	
 while (!rsCarga.EOF){
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
</script>