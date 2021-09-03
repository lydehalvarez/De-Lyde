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
<div class="ibox float-e-margins">
	<div class="ibox-title">
		<span class="label label-info pull-right"><%=Estatus %></span>
        <h5><%=Titulo %></h5>
    </div>
<div class="ibox-content">
	<h1 class="no-margins"><%=Dato %></h1>
    <div class="stat-percent font-bold text-info"><%=Porcentaje %><i class="fa <%=Flecha %>"></i></div>
   		<small><%=SubTitulo %></small>
	</div> 
</div>