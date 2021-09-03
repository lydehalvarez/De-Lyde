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
	{   
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
			
			Response.Write("</div>")				  
			rsCol.MoveNext() 
		}
        rsCol.Close()
		Response.Write("</div>")
   }
%> 
<!-- ChartJS--> 
<script src="/Template/inspina/js/plugins/chartJs/Chart.min.js"></script>
<script>
     $(document).ready(function() {
<%
var tpo_graf = ""
var Llave = "" 
var DsbR_ID = 0
var DsbC_ID= 0

var tipo = 0
var sSQLCarga = " select d.WgCfg_ID,DsbR_ID,DsbC_ID,DsbC_TipoGrafico "
    sSQLCarga += " from Dashboard d, Dashboard_Columna c "
	sSQLCarga += " where d.Sys_ID = c.Sys_ID and c.Sys_ID = " + SistemaActual
	sSQLCarga += " and d.WgCfg_ID = c.WgCfg_ID AND c.DsbC_Habilitado = 1 "
	sSQLCarga += " and d.Mnu_ID = c.Mnu_ID AND c.Mnu_ID = " + VentanaIndex	
var rs_carga = AbreTabla(sSQLCarga,1,2) 	
while (!rs_carga.EOF)
{
	DsbC_ID = rs_carga.Fields.Item("DsbC_ID").Value
	DsbR_ID = rs_carga.Fields.Item("DsbR_ID").Value
	Llave  = "?DsbR_ID=" + DsbR_ID
	Llave += "&DsbC_ID=" + DsbC_ID
	Llave += "&WgCfg_ID=" + rs_carga.Fields.Item("WgCfg_ID").Value
	Llave += "&SID=" + SistemaActual
    Llave += "&M_ID=" + VentanaIndex	
	tipo = rs_carga.Fields.Item("DsbC_TipoGrafico").Value
	switch(tipo)
	{ 
		case 1: {tpo_graf = "caja_mediana.asp"} break;
		case 2: {tpo_graf = "caja_mediana.asp"} break;
		case 3: {tpo_graf = "caja_mediana.asp"} break;
		case 4: {tpo_graf = "caja_mediana.asp"} break;
		case 5: {tpo_graf = "caja_mediana.asp"} break;
		case 6: {tpo_graf = "caja_mediana.asp"} break;
		case 7: {tpo_graf = "caja_mediana.asp"} break;
		case 8: {tpo_graf = "caja mediana.asp"} break;	
		case 9: {tpo_graf = "caja_mediana.asp"} break;		
	}
	tpo_graf += Llave

%>
	$("#r<%=DsbR_ID%>c<%=DsbC_ID%>").load("/pz/wms/DB/<%=tpo_graf%>" )
<%
        	rs_carga.MoveNext() 
		}
        rs_carga.Close()    
%>
        });
    </script> 		 