<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
	var DsbR_ID = Parametro("DsbR_ID",-1)
    var DsbC_ID = Parametro("DsbC_ID",-1)
    var WgCfg_ID = Parametro("WgCfg_ID",-1)
    var SID = Parametro("SID",-1)
    var M_ID = Parametro("M_ID",-1)
    var DsbC_Query = ""
    var Dato = ""
    var Titulo = ""
    var Estatus = ""   
    var Porcentaje = ""
    var Flecha = "fa-level-up"  //fa-level-down
    var SubTitulo = "" 
    var sSQLEtq  = "select DsbC_TipoGrafico, DsbC_Query from Dashboard_Columna "
       sSQLEtq += " where Sys_ID = " + SID
       sSQLEtq += " AND Mnu_ID = " + M_ID
       sSQLEtq += " AND WgCfg_ID = " + WgCfg_ID
       sSQLEtq += " AND DsbR_ID = " + DsbR_ID
       sSQLEtq += " AND DsbC_ID = " + DsbC_ID
    var rsEtq = AbreTabla(sSQLEtq,1,2)
    if (!rsEtq.EOF) {DsbC_Query += rsEtq.Fields.Item("DsbC_Query").Value}
    rsEtq.Close() 
    var sSQLEtq  = DsbC_Query
    /* cargamos los filtros qeu vas a mandar, si los otros, com o las fechas
      si mandas las fechas entonces las concatenas al query ue trajistesssss
      de esta manera las fechas seran incluidas en el query principal
    */    	 
    var rsEtq = AbreTabla(sSQLEtq,1,0)
    if (!rsEtq.EOF)
    {		
    	Dato = formato(rsEtq.Fields.Item("Dato").Value,0)
		Titulo = rsEtq.Fields.Item("Titulo").Value
		Estatus = rsEtq.Fields.Item("Estatus").Value  
		Porcentaje = rsEtq.Fields.Item("Porcentaje").Value
		Flecha = "fa-level-up"  //fa-level-down
		SubTitulo = rsEtq.Fields.Item("SubTitulo").Value 
    }
    rsEtq.Close() 
%>
<ul class="stat-list">
	<li>
		<h2 class="no-margins"><%Response.Write("235")%></h2>
		<small><%Response.Write("Total de ordenes")%></small>
		<div class="stat-percent"><%Response.Write("35%")%> <i class="fa fa-level-up text-navy"></i></div>
			<div class="progress progress-mini">
        		<div style="width: <%Response.Write("35%")%>;" class="progress-bar"></div>
        	</div>
    </li>
    <li>
    	<h2 class="no-margins "><%Response.Write("125")%></h2>
        <small><%Response.Write("Ordenes de venta")%></small>
        <div class="stat-percent"><%Response.Write("40%")%> <i class="fa fa-level-down text-navy"></i></div>
        <div class="progress progress-mini">
        	<div style="width:<%Response.Write("40%")%>;" class="progress-bar"></div>
        </div>
    </li>
    <li>
    	<h2 class="no-margins "><%Response.Write("36")%></h2>
        <small><%Response.Write("Ingresos mensuales de pedidos")%></small>
        <div class="stat-percent"><%Response.Write("25%")%> <i class="fa fa-bolt text-navy"></i></div>
        	<div class="progress progress-mini">
            <div style="width:<%Response.Write("25%")%>;" class="progress-bar"></div>
        </div>
    </li>
</ul>