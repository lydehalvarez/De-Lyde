<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
    <link href="/Template/inspina/css/bootstrap.min.css" rel="stylesheet">
    <link href="/Template/inspina/font-awesome/css/font-awesome.css" rel="stylesheet">
    <link href="/Template/inspina/css/animate.css" rel="stylesheet">
    <link href="/Template/inspina/css/style.css" rel="stylesheet">
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
<button>hola</button>
<script>
var tipo = 4
var grafica = ""
switch(tipo)
{
	case 1: {grafica = "caja_chica.asp";} break;
	case 2: {grafica = "caja_mediana.asp";} break;
	case 3: {grafica = "caja_chica.asp";} break;
	case 4: {grafica = "caja_chica.asp";} break;
	case 5: {grafica = "caja_mediana.asp";} break;
}
</script>
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
			Response.Write( "tipo = " +"4")
			Response.Write("</div>")				  
			rsCol.MoveNext() 
		}
        rsCol.Close()
		Response.Write("</div>")
   }
%>  
        