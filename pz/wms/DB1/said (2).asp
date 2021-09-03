   <link href="/Template/inspina/css/plugins/clockpicker/clockpicker.css" rel="stylesheet">
   <link href="/Template/inspina/css/plugins/datapicker/datepicker3.css" rel="stylesheet">
   <link href="/Template/inspina/css/plugins/fullcalendar/fullcalendar.css" rel="stylesheet">
   <link href="/Template/inspina/css/plugins/iCheck/green.css" rel="stylesheet">
   <script src="/Template/inspina/js/plugins/jquery-ui/jquery-ui.min.js"></script>
   <script src="/Template/inspina/js/plugins/fullcalendar/moment.min.js"></script>
   <script src="/Template/inspina/js/plugins/fullcalendar/fullcalendar.min.js"></script>
   <script src="/Template/inspina/js/plugins/fullcalendar/locale-all.js"></script>
   <script src="/Template/inspina/js/plugins/clockpicker/clockpicker.js"></script>
   <script src="/Template/inspina/js/plugins/datapicker/bootstrap-datepicker.js"></script>
   <script src="/Template/inspina/js/plugins/iCheck/icheck.min.js"></script>
    	<!-- jQuery UI -->
	<script src="/Template/inspina/js/plugins/jquery-ui/jquery-ui.min.js"></script>
    	<!-- ChartJS--> 
	<script src="/Template/inspina/js/plugins/chartJs/Chart.min.js"></script>
<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
var tpo_graf = ""
var tpo = 0
var Renglones = 3 
var Columnas = 0
var Grids = 0  
var i = 0
var Col = 0	  
var sSQLRen  = " select Dsb_Renglones from Dashboard "
    sSQLRen += " where Sys_ID = " + SistemaActual
    sSQLRen += " and WgCfg_ID = " + VentanaIndex
var rsRen = AbreTabla(sSQLRen,1,2) 
 	if (!rsRen.EOF){Renglones = rsRen.Fields.Item("Dsb_Renglones").Value}
	rsRen.Close()				 
   	for (i=1;i<=Renglones;i++)
	{   /pz/wms/almacen/Alm_ProductoInventario.asp
   		Response.Write("<div class='row'>")
		var sSQLCol  = " select DsbC_ID, DsbC_TipoGrafico, DsbC_UnidadGrid from Dashboard_Columna "
			sSQLCol += " where Sys_ID = " + SistemaActual
			sSQLCol += " and WgCfg_ID = " + VentanaIndex
	        sSQLCol += " and DsbR_ID = " + i
		var rsCol = AbreTabla(sSQLCol,1,2)
        while (!rsCol.EOF)
		{
			Col = rsCol.Fields.Item("DsbC_ID").Value
	    	Grids = rsCol.Fields.Item("DsbC_UnidadGrid").Value
			Response.Write("<div class='col-lg-" + Grids +"' id='r" + i + "c" + Col + "'>")
			tpo = rsCol.Fields.Item("DsbC_TipoGrafico").Value
			switch(tpo)
			{
				case 1: {tpo_graf = "caja_chica.asp"} break;
				case 2: {tpo_graf = "grafica_ordenes.asp"} break;
				case 3: {tpo_graf = "tabla_lista.asp"} break;
				case 4: {tpo_graf = "datos_avanze.asp"} break;
				case 5: {tpo_graf = "caja_mediana.asp"} break;
				case 6: {tpo_graf = "grafica_ventas.asp"} break;
				case 7: {tpo_graf = "caja_grande.asp"} break;
				case 8: {tpo_graf = "grafica_ordenes.asp"} break;
			}
			Response.Write( "tipo = " + tpo_graf)
			Response.Write("</div>")				  
			rsCol.MoveNext() 
		}
        rsCol.Close()
		Response.Write("</div>")
   }
%> 
<script>
     $(document).ready(function() {
	
<%
var tpo_graf = ""
var cren = 0
var ccol = 0
var tipo = 0
var sSQLCarga = " select DsbR_ID,DsbC_ID,DsbC_TipoGrafico "
    sSQLCarga += " from Dashboard d, Dashboard_Columna c "
	sSQLCarga += " where d.Sys_ID = c.Sys_ID and c.Sys_ID = " + SistemaActual
	sSQLCarga += " and d.Mnu_ID = c.Mnu_ID "
	sSQLCarga += " and d.WgCfg_ID = c.WgCfg_ID AND c.WgCfg_ID = " + VentanaIndex
var rs_carga = AbreTabla(sSQLCarga,1,2) 	
while (!rs_carga.EOF)
{
	cren = rs_carga.Fields.Item("DsbR_ID").Value
    ccol = rs_carga.Fields.Item("DsbC_ID").Value
	tipo = rs_carga.Fields.Item("DsbC_TipoGrafico").Value
	switch(tipo)
	{
		case 1: {tpo_graf = "lista_usuarios.asp"} break;
		case 2: {tpo_graf = "datos_avanze.asp"} break;
		case 3: {tpo_graf = "caja_grande.asp"} break;
		case 4: {tpo_graf = "grafica_ventas.asp"} break;
		case 5: {tpo_graf = "grafica5.asp"} break;
		case 6: {tpo_graf = "grafica6.asp"} break;
		case 7: {tpo_graf = "grafica7.asp"} break;
		case 8: {tpo_graf = "grafica8.asp"} break;
	}
%>
		$("#r<%=cren%>c<%=ccol%>").load("/pz/wms/DB/<%=tpo_graf%>")
<%
        	rs_carga.MoveNext() 
		}
        rs_carga.Close()   
%>
        });
    </script> 		 