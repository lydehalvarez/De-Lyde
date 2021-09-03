<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../../Includes/iqon.asp" -->
<%

Server.ScriptTimeOut = 6000

var DiasDeMes = new Array(0)
	DiasDeMes = [31,0,31,30,31,30,31,31,30,31,30,31]

var NombreDeMes = new Array 
	NombreDeMes = ["Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Septiembre","Octubre","Noviembre","Diciembre"]

var iRegPorPagina = Parametro("RegPorVentana",RegPorVentana)
var iPagina = Parametro("Pag",1)
var iRegistros = 0
var iRegistrosImpresos = 0
var bLoBusco = false
var LlaveABuscar = 0

var ArrCampo = new Array(0)
var ArrSubConsulta = new Array(0)
var ArrTitulo = new Array(0)
var ArrFormato = new Array(0)
var ArrAlineacion = new Array(0)
var ArrAncho = new Array(0)

var ArrOperacion = new Array(0)
var ArrTotSuma = new Array(0)
var ArrTotCuenta = new Array(0)
var ArrTotMax = new Array(0)
var ArrTotMin = new Array(0)

var ArrTotSumaInd = new Array(0)
var ArrTotCuentaInd = new Array(0)
var ArrTotMaxInd = new Array(0)
var ArrTotMinInd = new Array(0)

var bOperacion = false

var ArrTitAlineacion = new Array(0)
var ArrTitBold = new Array(0)
var ArrTitItalic = new Array(0)
var ArrAgrupada = new Array(0)
var ArrAgrupador = new Array(0)

var sQuerySQLWHERE = ""
var sQuerySQLFROM = ""
var sQuerySQLORDER = ""
var sQuerySQLGroup = ""
var sQuerySQLSELECT = ""
var sTempValorCampo = ""
var ArrTempValorCampo = new Array(0)
var ArrValorCampo = new Array(0)
var bIQon4Web = false


var bPaso = false
var bHayAgrupacion = false
	
	var sConsultaSQL = "SELECT * FROM Reportes "
		sConsultaSQL += " WHERE Rep_ID = " + Parametro("CboReporte",-1)
		
	if(bIQon4Web) {
		Response.Write("<h5>Reportes&nbsp;" + sConsultaSQL + "</h5><br />")
	}
	
var sNombreReporte = ""
var rsReporte = AbreTabla(sConsultaSQL,1,0)
if (!rsReporte.EOF) {
	 sQuerySQLFROM = " FROM " + rsReporte.Fields.Item("Rep_SQLTabla").Value
	
	if (!EsVacio(String(rsReporte.Fields.Item("Rep_SQLCondicion").Value)) ) {
		sQuerySQLWHERE = " " + String(rsReporte.Fields.Item("Rep_SQLCondicion").Value) + " "
	}

	var sCondicionExtra = ""
	sNombreReporte = IFAnidado(!EsVacio(rsReporte.Fields.Item("Rep_Nombre").Value),rsReporte.Fields.Item("Rep_Nombre").Value,"")

	//Clientes RepCli_ID
	
		if (rsReporte.Fields.Item("Rep_Cliente").Value == 1) { 
			if (Parametro("RepCli_ID",-1) > -1 ) {
				sCondicionExtra = " " +  rsReporte.Fields.Item("Rep_CampoCliente").Value + " = " 
				sCondicionExtra += Parametro("RepCli_ID",-1)
			}
		}

	//Deudor RepDeu_ID
	
		if (rsReporte.Fields.Item("Rep_Deudor").Value == 1) { 
			if (Parametro("RepDeu_ID",-1) > -1 ) {
				sCondicionExtra = " " +  rsReporte.Fields.Item("Rep_CampoDeudor").Value + " = " 
				sCondicionExtra += Parametro("RepDeu_ID",-1)
			}
		}


	//Fechas Tipo de dato Date y DateTime
	
		//Rep_Fecha - Rep_CampoFechas
		if (rsReporte.Fields.Item("Rep_Fecha").Value == 1) { 
			if(bIQon4Web) {
				Response.Write("<br>" + rsReporte.Fields.Item("Rep_Fecha").Value + "<br>" + Parametro("txtFechaDesde","") )
			}
		  if (Parametro("txtFechaDesde","") == "" &&  Parametro("txtFechaHasta","") != "") {	
			if (sCondicionExtra != "" ) { sCondicionExtra += " AND "  }
			sCondicionExtra += " " + rsReporte.Fields.Item("Rep_CampoFechas").Value + " < "
			sCondicionExtra += " DATEADD(day,1,CONVERT(DATE, '" + Parametro("txtFechaHasta","") + "', 103))"
		  }
	
		  if (Parametro("txtFechaDesde","") != "" &&  Parametro("txtFechaHasta","") == "") {
		  	if(bIQon4Web) {
				Response.Write("<br>" + Parametro("txtFechaDesde","") )
			}
			
			if (sCondicionExtra != "" ) { sCondicionExtra += " AND "  }
			sCondicionExtra += " " + rsReporte.Fields.Item("Rep_CampoFechas").Value + " >= " 
			sCondicionExtra += " CONVERT(DATE, '" + Parametro("txtFechaDesde","") + "', 103)"
		  }	 		
		
		  if (Parametro("txtFechaDesde","") != "" &&  Parametro("txtFechaHasta","") != "") {
			if (sCondicionExtra != "" ) { sCondicionExtra += " AND "  }
			sCondicionExtra += " ( " + rsReporte.Fields.Item("Rep_CampoFechas").Value + " >= " 
			sCondicionExtra += " CONVERT(DATE, '" + Parametro("txtFechaDesde","") + "', 103)"
			sCondicionExtra += " AND " + rsReporte.Fields.Item("Rep_CampoFechas").Value + " < " 
			sCondicionExtra += " DATEADD(day,1,CONVERT(DATE, '" + Parametro("txtFechaHasta","") + "', 103))"
			sCondicionExtra += " ) "
		  }
	
		}

		//Fechas 2
		//Rep_Fecha2 - Rep_CampoFecha2
		if (rsReporte.Fields.Item("Rep_Fecha2").Value == 1) { 
		
		  if (Parametro("txtFechaDesde2","") == "" &&  Parametro("txtFechaHasta2","") != "") {
			if (sCondicionExtra != "" ) { sCondicionExtra += " AND "  }
			sCondicionExtra += " " + rsReporte.Fields.Item("Rep_CampoFecha2").Value + " < " 
			sCondicionExtra += " DATEADD(day,1,CONVERT(DATE, '" + Parametro("txtFechaHasta2","") + "', 103))"
		  }
		  
		  if (Parametro("txtFechaDesde2","") != "" &&  Parametro("txtFechaHasta2","") == "") {
			if (sCondicionExtra != "" ) { sCondicionExtra += " AND "  }
			sCondicionExtra += " " + rsReporte.Fields.Item("Rep_CampoFecha2").Value + " >= " 
			sCondicionExtra += " CONVERT(DATE, '" + Parametro("txtFechaDesde2","") + "', 103)"
		  }	
		  
		  if (Parametro("txtFechaDesde2","") != "" &&  Parametro("txtFechaHasta2","") != "") {
			if (sCondicionExtra != "" ) { sCondicionExtra += " AND "  }
			sCondicionExtra += " ( " + rsReporte.Fields.Item("Rep_CampoFecha2").Value + " >= " 
			sCondicionExtra += " CONVERT(DATE, '" + Parametro("txtFechaDesde2","") + "', 103)"
			sCondicionExtra += " AND " + rsReporte.Fields.Item("Rep_CampoFecha2").Value + " < " 
			sCondicionExtra += " DATEADD(day,1,CONVERT(DATE, '" + Parametro("txtFechaHasta","") + "', 103))"
			sCondicionExtra += " ) "
		  }
		  
		}

	if(bIQon4Web) {
		Response.Write("<h5> sQuerySQLWHERE " + sQuerySQLWHERE + " </h5><br />")		
		Response.Write("<h5> sCondicionExtra " + sCondicionExtra  + " </h5><br />") 
	}

	//Response.Write("<br>Paso 2 Condicion Fecha 2 " + sCondicionExtra)
	if (sQuerySQLWHERE != "" &&  sCondicionExtra != "" ) {
		 sQuerySQLWHERE += " AND "  }
		 sQuerySQLWHERE += sCondicionExtra

	if(bIQon4Web) {
		Response.Write("<h5> sQuerySQLWHERE " + sQuerySQLWHERE + " </h5><br />")		
		Response.Write("<h5> sCondicionExtra " + sCondicionExtra  + " </h5><br />") 
	}
	
	if (!EsVacio(String(rsReporte.Fields.Item("Rep_SQLOrden").Value))) {
		sQuerySQLORDER =  String(rsReporte.Fields.Item("Rep_SQLOrden").Value)
	}
		
	if (!EsVacio(String(rsReporte.Fields.Item("Rep_SQLGroup").Value))) {
		sQuerySQLGroup = " GROUP BY  " + String(rsReporte.Fields.Item("Rep_SQLGroup").Value)
	}
	
	var sConsultaSQL = "SELECT * FROM ReportesCampos "
	sConsultaSQL += " WHERE Rep_ID  = " + Parametro("CboReporte",-1)
	sConsultaSQL += " ORDER BY Rep_Orden"
	var iArticulos = 0
	var sTemp = ""

	if(bIQon4Web) {
		Response.Write("<h5>ReportesCamposSQL " + sConsultaSQL + " </h5><br />")		
	}

	var rsCampos = AbreTabla(sConsultaSQL,1,0)
	var sCons = ""
	var sNomb = ""
		while (!rsCampos.EOF){
				if (sQuerySQLSELECT != "" ) { sQuerySQLSELECT += ", "}
				sCons = rsCampos.Fields.Item("Rep_SubConsulta").Value 
				sNomb = rsCampos.Fields.Item("Rep_Campo").Value
				
				if (!EsVacio(sCons)) {
					if (!EsVacio(sNomb)) {
						sQuerySQLSELECT += " " + sCons + " AS " + sNomb
					} else {
						sQuerySQLSELECT += " " + sCons 
					}				
				} else {
					if (!EsVacio(sNomb)) {
						sQuerySQLSELECT += " " + sNomb
					} 
				}

				ArrCampo[iArticulos] = rsCampos.Fields.Item("Rep_Campo").Value 
				ArrSubConsulta[iArticulos] = rsCampos.Fields.Item("Rep_SubConsulta").Value 
				ArrTitulo[iArticulos] = rsCampos.Fields.Item("Rep_Titulo").Value 
				ArrFormato[iArticulos] = rsCampos.Fields.Item("Rep_Formato").Value 
				ArrAlineacion[iArticulos] = rsCampos.Fields.Item("Rep_Alineacion").Value
				ArrAncho[iArticulos] = rsCampos.Fields.Item("Rep_Ancho").Value
				ArrTitAlineacion[iArticulos] = rsCampos.Fields.Item("Rep_TitAlineacion").Value
				ArrTitBold[iArticulos] = rsCampos.Fields.Item("Rep_TitBold").Value
				ArrTitItalic[iArticulos] = rsCampos.Fields.Item("Rep_TitItalic").Value
				ArrAgrupada[iArticulos] = rsCampos.Fields.Item("Rep_Agrupada").Value
				ArrAgrupador[iArticulos] = ""
				ArrOperacion[iArticulos] = rsCampos.Fields.Item("Rep_Operacion").Value
				bOperacion = ArrOperacion[iArticulos] > 0 || bOperacion
				ArrTotSuma[iArticulos] = 0
				ArrTotCuenta[iArticulos] = 0
				ArrTotMax[iArticulos] = 0
				ArrTotMin[iArticulos] = 0
				ArrTotSumaInd[iArticulos] = 0
				ArrTotCuentaInd[iArticulos] = 0
				ArrTotMaxInd[iArticulos] = 0
				ArrTotMinInd[iArticulos] = 0			
				iArticulos++
				
			  rsCampos.MoveNext()
			}
			
	sQuerySQLSELECT = "SELECT " + sQuerySQLSELECT + " "
	rsCampos.Close() 
	
	for (iCampo=0;iArticulos<1;iCampo++) {
		Response.Write("Rep_Campo&nbsp;" + ArrCampo[iArticulos] + "<br>")
		Response.Write("Rep_SubConsulta&nbsp;" + ArrSubConsulta[iArticulos] + "<br>")
		Response.Write("Rep_Titulo&nbsp;" + ArrTitulo[iArticulos] + "<br>")
 	}

	if(bIQon4Web) {
		Response.Write("<br>iArticulos" + iArticulos)	
		Response.Write("<br>" + sQuerySQLSELECT)
	}
	
}
%>
<head>
<% if(Parametro("iExport",0) == 0){ %>
	<!--link href="/Template/Abrax/css/reset.css" rel="stylesheet" type="text/css">
    <link href="/Template/Abrax/css/960.css" rel="stylesheet" type="text/css">
    <link href="/Template/Abrax/css/styles.css" rel="stylesheet" type="text/css">
    <link href="/Template/Abrax/css/color.css" rel="stylesheet" type="text/css">
    <link href="/Template/Abrax/css/superfish.css" rel="stylesheet" type="text/css"-->
    <!--link href="/css/rstrp.css" rel="stylesheet" type="text/css"-->
    <!--link href="/css/rstrp2.css" rel="stylesheet" type="text/css">
    <link href="/Template/TCEComisiones/CSS/Estilos.css" rel="stylesheet" type="text/css">
    <link rel="stylesheet" href="../../estilos.css" type="text/css"-->
	<link rel="stylesheet" href="/Template/ClipOne/admin/clip-one/assets/plugins/bootstrap/css/bootstrap.min.css">
	<link rel="stylesheet" href="/Template/ClipOne/admin/clip-one/assets/plugins/font-awesome/css/font-awesome.min.css">
	<link rel="stylesheet" href="/Template/ClipOne/admin/clip-one/assets/fonts/style.css">
	<link rel="stylesheet" href="/Template/ClipOne/admin/clip-one/assets/css/main.css">
<% }
if(Parametro("iExport",0) == 1){
	Response.ContentType = "application/vnd.ms-excel" 
	Response.AddHeader("content-disposition", "attachment; filename=Reporte" + sNombreReporte + ".xls")
	Response.Write("<meta http-equiv=\"Content-Type\" CONTENT=\"application/vnd.ms-excel\">")
	Response.Write("<meta http-equiv=\"Content-Disposition\" CONTENT=\"inline\">")
} else {
	Response.Write("<meta http-equiv=\"Content-Type\" CONTENT=\"text/html; charset=UTF-8\">")
}

AntiCache()

%>
<title>C.G. Administrador - Reporte</title>

<style> 
<!-- 

#leftright, #topdown{ 
	position:absolute; 
	left:0; 
	top:0; 
	width:1px; 
	height:1px; 
	layer-background-color:black; 
	background-color:black; 
	z-index:100; 
	font-size:1px; 
} 

--> 
</style> 

</head>

<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0">
<p><div id="leftright" style="width:expression(document.body.clientWidth-2)"></div> 
<div id="topdown" style="height:expression(document.body.clientHeight-2)"></div> 

<script language="JavaScript1.2"> 
<!-- 


if (document.all&&!window.print){ 
	leftright.style.width=document.body.clientWidth-2 
	topdown.style.height=document.body.clientHeight-2 
} else if (document.layers){ 
	document.leftright.clip.width=window.innerWidth 
	document.leftright.clip.height=1 
	document.topdown.clip.width=1 
	document.topdown.clip.height=window.innerHeight 
} 
  

function followmouse1(){ 
//move cross engine for IE 4+ 
	leftright.style.pixelTop=document.body.scrollTop+event.clientY+1 
	topdown.style.pixelTop=document.body.scrollTop 
	if (event.clientX<document.body.clientWidth-2) 
		topdown.style.pixelLeft=document.body.scrollLeft+event.clientX+1 
	else 
		topdown.style.pixelLeft=document.body.clientWidth-2 
} 

function followmouse2(e){ 
	//move cross engine for NS 4+ 
	document.leftright.top=e.y+1 
	document.topdown.top=pageYOffset 
	document.topdown.left=e.x+1 
} 

if (document.all) 
	document.onmousemove=followmouse1 
else if (document.layers){ 
	window.captureEvents(Event.MOUSEMOVE) 
	window.onmousemove=followmouse2 
} 

function regenerate(){ 
	window.location.reload() 
} 
function regenerate2(){ 
	setTimeout("window.onresize=regenerate",400) 
} 
if ((document.all&&!window.print)||document.layers) 
//if the user is using IE 4 or NS 4, both NOT IE 5+ 
window.onload=regenerate2 

//--> 
</script></p>

<style> 
<!-- 
#leftright, #topdown{ 
	position:absolute; 
	left:0; 
	top:0; 
	width:1px; 
	height:1px; 
	layer-background-color:black; 
	background-color:black; 
	z-index:100; 
	font-size:1px; 
} 
--> 
</style> 

</head>
<body bgcolor="#FFFFFF" text="#000000" leftmargin="0" topmargin="0">
<div id="leftright" style="width:expression(document.body.clientWidth-2)"></div> 
<div id="topdown" style="height:expression(document.body.clientHeight-2)"></div> 
<script language="javascript"> 
<!-- 

if (document.all&&!window.print){ 
	leftright.style.width=document.body.clientWidth-2 
	topdown.style.height=document.body.clientHeight-2 
} 
else if (document.layers){ 
	document.leftright.clip.width=window.innerWidth 
	document.leftright.clip.height=1 
	document.topdown.clip.width=1 
	document.topdown.clip.height=window.innerHeight 
} 
  

function followmouse1(){ 
	//move cross engine for IE 4+ 
	leftright.style.pixelTop=document.body.scrollTop+event.clientY+1 
	topdown.style.pixelTop=document.body.scrollTop 
	if (event.clientX<document.body.clientWidth-2) 
	topdown.style.pixelLeft=document.body.scrollLeft+event.clientX+1 
else 
	topdown.style.pixelLeft=document.body.clientWidth-2 
} 

function followmouse2(e){ 
	//move cross engine for NS 4+ 
	document.leftright.top=e.y+1 
	document.topdown.top=pageYOffset 
	document.topdown.left=e.x+1 
} 

if (document.all) 
	document.onmousemove=followmouse1 
else if (document.layers){ 
	window.captureEvents(Event.MOUSEMOVE) 
	window.onmousemove=followmouse2 
} 

function regenerate(){ 
	window.location.reload() 
} 

function regenerate2(){ 
	setTimeout("window.onresize=regenerate",400) 
} 

if ((document.all&&!window.print)||document.layers) 
	//if the user is using IE 4 or NS 4, both NOT IE 5+ 
	window.onload=regenerate2 

//--> 
</script>

<form name="frmReporte" method="post" action="<%=EsteArchivo%>">
<%if (!rsReporte.EOF) {%>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td rowspan="3">&nbsp;<!--LOGO>  <--> </td>
    <td>&nbsp;</td>
  </tr>
  <tr> 
    <td> 
      <div align="center" id="Titulo1"><h3><%=rsReporte.Fields.Item("Rep_Titulo1").Value%></h3></div>
    </td>
  </tr>
  <tr> 
    <td> 
      <div align="center" id="Titulo2"><h4><%=rsReporte.Fields.Item("Rep_Titulo2").Value%></h4>
          <%
	  /*if (Parametro("Cont_Empresa",-1) > -1) {
		Response.Write("&nbsp; " + BuscaSoloUnDato("Cat_Nombre","Catalogos","Sec_ID = 28 AND Cat_ID = " + Parametro("Cont_Empresa",-1),"",0))
	  }	*/
	  var MuestraPag = 0
	  if (rsReporte.Fields.Item("Rep_Paginacion").Value == 1){
		  MuestraPag = 1
	  }
	 /* if (Parametro("CboGrupo","") != -1) {
		Response.Write("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; " + BuscaSoloUnDato("Gru_Nombre","Grupos","Gru_ID = " + Parametro("CboGrupo",-1),"",0))
	  }	*/
	  var MuestraPag = 0
	  if (rsReporte.Fields.Item("Rep_Paginacion").Value == 1){
		  MuestraPag = 1
	  }
	  
	  %></div>
    </td>
  </tr>
  <tr> 
    <td width="9%" >&nbsp;</td>
    <td>
      <div align="center" id="Titulo3"><h4>
	  <br><%=rsReporte.Fields.Item("Rep_Titulo3").Value%><%
	  if (rsReporte.Fields.Item("Rep_TitFecha").Value == 1 && rsReporte.Fields.Item("Rep_Fecha").Value == 1) {
		  if (Parametro("txtFechaDesde","") != "" ) {
			Response.Write("&nbsp;&nbsp;&nbsp;Desde "+ Parametro("txtFechaDesde",""))
		  }	 
		  if (  Parametro("txtFechaHasta","") != "") {
			Response.Write("&nbsp;Hasta "+ Parametro("txtFechaHasta",""))
		  }	
	  }
	  var MuestraPag = 0
	  if (rsReporte.Fields.Item("Rep_Paginacion").Value == 1){
		  MuestraPag = 1
	  }
	  %>
	        <%
	  if (rsReporte.Fields.Item("Rep_Fecha2").Value == 1){
			Response.Write("&nbsp&nbsp&gt;&gt;&gt&nbsp;")
	  }
	  if (rsReporte.Fields.Item("Rep_TitFecha").Value == 1 && rsReporte.Fields.Item("Rep_Fecha").Value == 1) {
		  if (Parametro("txtFechaDesde2","") != "" ) {
			Response.Write("&nbsp;&nbsp;&nbsp;Desde "+ Parametro("txtFechaDesde2",""))
		  }	 
		  if (  Parametro("txtFechaHasta2","") != "") {
			Response.Write("&nbsp;Hasta "+ Parametro("txtFechaHasta2",""))
		  }	
	  }
	  var MuestraPag = 0
	  if (rsReporte.Fields.Item("Rep_Paginacion").Value == 1){
		  MuestraPag = 1
	  }
	  
	  %></h4></div>
    </td>
  </tr>
  <tr> 
    <td colspan="2" >&nbsp;</td>
  </tr>
</table>
<%
//Response.Write("<br>iArticulosDD" + iArticulos)

var sQuerySQLORDERAgrupado = ""
if (iArticulos>0) { 

Response.Write("<table class='table table-striped table-bordered table-hover' id='sample-table-2'><thead><tr>")
	for (CAMPO=0;CAMPO<iArticulos;CAMPO++) {
		//Response.Write("<br>CAMPO" + "&nbsp;-&nbsp;-&nbsp;-"+iArticulos )
		Response.Write("<th ") //class='TablaEncabezado'
		switch (ArrTitAlineacion[CAMPO] ) {
		  case 1:Response.Write("class='left'");break;
		  case 2:Response.Write("class='center'");break;
		  case 3:Response.Write("class='right'");break;
		  default:Response.Write("class='hidden-xs'");break;
		}
		if (ArrAncho[CAMPO] > 0) {
			Response.Write(" width='"+ArrAncho[CAMPO]+"' ")
		}
		Response.Write(" >")
		//Formatos
		if(ArrTitBold[CAMPO] == 1) {
			Response.Write("<strong>") }
		Response.Write(ArrTitulo[CAMPO])
		if(ArrTitBold[CAMPO] == 1) {
			Response.Write("</strong>") }
		Response.Write("</th>")
		if (ArrAgrupada[CAMPO] == 1){
			if (sQuerySQLORDERAgrupado != ""){ 
				sQuerySQLORDERAgrupado +=", " 
			}
			if (!EsVacio(ArrSubConsulta[CAMPO]) && !EsVacio(ArrCampo[CAMPO])) {
			} else {
				if (!EsVacio(ArrSubConsulta[CAMPO]) && EsVacio(ArrCampo[CAMPO])){
					sQuerySQLORDERAgrupado += ArrSubConsulta[CAMPO]
				} else {
					sQuerySQLORDERAgrupado += ArrCampo[CAMPO]
				}
			}
		}
  	} //for del encabezado
//Armado final de la agrupación y el orden básico
	if (!EsVacio(sQuerySQLORDER) && !EsVacio(sQuerySQLORDERAgrupado)){
		sQuerySQLORDERAgrupado +=", " 
	}	
	if (!EsVacio(sQuerySQLORDER) || !EsVacio(sQuerySQLORDERAgrupado)){		
		sQuerySQLORDER = " ORDER BY " + sQuerySQLORDERAgrupado + sQuerySQLORDER
	}
	
	Response.Write("</thead><tbody></tr>")
	Response.Write("<tr><td colspan='"+iArticulos+"'></td></tr>") //height='1' bgcolor='#006633'
	
	} //encabezado
	if (sQuerySQLWHERE != "" ) { 
		sQuerySQLWHERE = " WHERE " + sQuerySQLWHERE 
	}
	
	if(bIQon4Web) {
		Response.Write("<h3> " + sQuerySQLWHERE  + " </h3><br />") 
	}

	var sConsultaSQL = sQuerySQLSELECT + sQuerySQLFROM + sQuerySQLWHERE + sQuerySQLGroup + sQuerySQLORDER

	if(bIQon4Web) {
//		Response.Write("<br>iArticulos" + iArticulos)
//		Response.Write("<h4>sConsultaSQL&nbsp;" + sConsultaSQL + "</h4><br />")
//		Response.Write("<br><h4>sQuerySQLSELECT&nbsp;&nbsp;" +sQuerySQLSELECT + "</h4>")
//		Response.Write("<br><h4>sQuerySQLFROM&nbsp;&nbsp;" +sQuerySQLFROM + "</h4>")
//		Response.Write("<br><h4>sQuerySQLWHERE&nbsp;&nbsp;" +sQuerySQLWHERE + "</h4>")
//		Response.Write("<br><h4>sQuerySQLGroup&nbsp;&nbsp;" +sQuerySQLGroup + "</h4>")
//		Response.Write("<br><h4>sQuerySQLORDER&nbsp;&nbsp;" +sQuerySQLORDER + "</h4>")			
		Response.Write("<br><h4>sConsultaSQL: " + sConsultaSQL + "</h4>")
	}
		//Response.Write("<br><h4>sConsultaSQL: " + sConsultaSQL + "</h4>")
	var rsContenido = AbreTabla(sConsultaSQL,1,0)
	var ValorCampo = ""
	var ValorNumericoCampo = 0
	iRegistros = 0
// *********************************************************************************************
//     Se utiliza la paginación el combo de la paginación	
	//Response.Write("I.-")
	if (parseInt(MuestraPag) == 1){
		//Response.Write("II.-")
		sTempValorCampo = ""
		var ValorNumericoCampoInd = 0
		while (!rsContenido.EOF){

			iRegistros++
				if (iRegistros > RegPorVentana) {
					iPagina = parseInt(iRegistros/RegPorVentana) +1
				}
				ParametroCambiaValor("Pag",iPagina)
				break
			rsContenido.MoveNext()
		}
		rsContenido.MoveFirst()
		iRegistros = 0
		// AHORA SI A IMPRIMIR	
		var RegInicial = (iPagina * iRegPorPagina)-iRegPorPagina+1
		if (RegInicial < 1) {
			RegInicial = 1
		}
		rsContenido.Move(RegInicial-1)
		iRegistros = RegInicial - 1
		//Response.Write(CAMPO)
		while (!rsContenido.EOF){
			iRegistros++
				if (iRegistros>=RegInicial) {
					if (iRegistrosImpresos < iRegPorPagina) {
		//******************************************************************************
		for (CAMPOSU=0;CAMPOSU<iArticulos;CAMPOSU++) {	
			ArrValorCampo[CAMPOSU] = rsContenido.Fields.Item(CAMPOSU).Value
		}		
		//Response.Write(CAMPO)
		//Response.Write("CAMPO&nbsp;-" + CAMPO + "-&nbsp;iArticulos&nbsp;-&nbsp;" + iArticulos)
	  	for (CAMPO=0;CAMPO<iArticulos;CAMPO++) {
			ValorCampo = "" + rsContenido.Fields.Item(CAMPO).Value
			//Response.Write("ValorCampo&nbsp;"+ValorCampo)
			if (!bPaso){
				//Response.Write("Paso")
				ArrTempValorCampo[CAMPO] = ArrValorCampo[CAMPO]
				if(CAMPO == (iArticulos-1)){
					bPaso = true
				}
			}
//Imprime el corte individual			
//Response.Write("II.-")
if (Parametro("iTotales",1)==1){  
//Response.Write("III.-")
if (CAMPO == 0)	{
	//Response.Write("IV.-")
	if (bHayAgrupacion ){
		//Response.Write("V.-")
			for (CAMPOIND=0;CAMPOIND<iArticulos;CAMPOIND++) {
				if (ArrTempValorCampo[CAMPOIND] != ArrValorCampo[CAMPOIND] && ArrAgrupada[CAMPOIND] != 0){
							Response.Write("<tr><td colspan='"+iArticulos+"' height='1' ></td></tr>") //bgcolor='#006633'
							Response.Write("<tr>")
							for (CAMPOEXT=0;CAMPOEXT<iArticulos;CAMPOEXT++) { // bgcolor='#CCCCCC'
									Response.Write("<td >&nbsp;")
									CAMPOIND = iArticulos
								if (ArrOperacion[CAMPOEXT] != 0){
									switch (ArrOperacion[CAMPOEXT]) {
										  case 1: //Suma
											Response.Write("&nbsp;Suma>&nbsp;" +formato(ArrTotSumaInd[CAMPOEXT],2))
											break; 
										  case 2://Cuenta
											Response.Write("&nbsp;Cuenta>&nbsp;" + ArrTotCuentaInd[CAMPOEXT])
											break; 
										  case 3: //Promedio
											var iPromedioInd = (ArrTotSumaInd[CAMPOEXT] / ArrTotCuentaInd[CAMPOEXT])
											Response.Write("&nbsp;Promedio>&nbsp;" + iPromedioInd)
											break;
										  case 4: //Máximo
											Response.Write("&nbsp;Máximo>&nbsp;" + ArrTotMaxInd[CAMPOEXT])
											break;
										  case 5: //Mínimo
											Response.Write("&nbsp;Mínimo>&nbsp;" + ArrTotMinInd[CAMPOEXT])
											break;  
										  case 6: //Titulo
											Response.Write(ArrTitulo[CAMPOEXT])
											break; 
									}
								} 
									ArrTotSumaInd[CAMPOEXT] = 0
									ArrTotCuentaInd[CAMPOEXT] = 0
									ArrTotMaxInd[CAMPOEXT] = 0
									ArrTotMinInd[CAMPOEXT] = 0
									ArrTempValorCampo[CAMPOEXT] = ArrValorCampo[CAMPOEXT]
									bPaso = false
								
								Response.Write("</td>")
							} //del for interno 
							Response.Write("</tr>")
					} //del if
			} //del for   
		} //del if 
if (Parametro("iTotales",1)==1){  Response.Write("<tr></tbody>") }
	} //del if
	//******************************************************************************************************************
			Response.Write("<td ") //class='hidden-xs'
			switch (ArrAlineacion[CAMPO] ) {
			  case 1:Response.Write("class='left'");break;
			  case 2:Response.Write("class='center'");break;
			  case 3:Response.Write("class='right'");break;
			  default:Response.Write("class='hidden-xs'");break;
			}
			if (ArrAncho[CAMPO] > 0) {
				Response.Write(" width='"+ArrAncho[CAMPO]+"' ")
			}
		  	Response.Write(">" )
	} //del iTotales
//Hace las operaciones de los totales Generales
			ValorNumericoCampo = 0
			if (!isNaN(ValorCampo)) {
				ValorNumericoCampo = parseFloat(ValorCampo)
				if (ArrTotMax[CAMPO] < ValorNumericoCampo) {
					ArrTotMax[CAMPO] = ValorNumericoCampo
				}
				if (ArrTotMin[CAMPO] == 0 ){
					ArrTotMin[CAMPO] = ValorNumericoCampo
				}
				if (ArrTotMin[CAMPO] > ValorNumericoCampo) {
					ArrTotMin[CAMPO] = ValorNumericoCampo
				}
			}
			ArrTotSuma[CAMPO] += ValorNumericoCampo
			ArrTotCuenta[CAMPO]++
			ArrTitulo[CAMPO]=ValorCampo

//Hace las operaciones de los totales individuales
			ValorNumericoCampoInd = 0
			if (!isNaN(ValorCampo)) {
				ValorNumericoCampoInd = parseFloat(ValorCampo)
				if (ArrTotMaxInd[CAMPO] < ValorNumericoCampoInd) {
					ArrTotMaxInd[CAMPO] = ValorNumericoCampoInd
				}
				if (ArrTotMinInd[CAMPO] == 0 ){
					ArrTotMinInd[CAMPO] = ValorNumericoCampoInd
				}
				if (ArrTotMinInd[CAMPO] > ValorNumericoCampoInd) {
					ArrTotMinInd[CAMPO] = ValorNumericoCampoInd
				}				
			}
			ArrTotSumaInd[CAMPO] += ValorNumericoCampoInd
			ArrTotCuentaInd[CAMPO]++
			ArrTitulo[CAMPO]=ValorCampo

if (Parametro("iTotales",1)==1){
			if (EsVacio(ValorCampo)) {
				ValorCampo = ""
				switch (ArrFormato[CAMPO]) {
				  case 1:Response.Write(ValorCampo);break; //"Texto"
				  case 2:Response.Write(ValorCampo);break; //"Fecha Jul"
				  case 3:Response.Write(ValorCampo);break; //"Fecha Gre"
				  case 4:Response.Write(ValorCampo);break;  //"Numérico"
				  case 5:Response.Write("0");break;
				  case 6:Response.Write("0");break;
				  case 7:Response.Write("0");break;
				 }
			} else {
				switch (ArrFormato[CAMPO]) {
				  case 1:Response.Write(ValorCampo);break; //"Texto"
				  case 2:Response.Write(JulAGre(ValorCampo));break; //"Fecha Jul"
				  case 3:Response.Write(ValorCampo);break; //"Fecha Gre"
				  case 4:Response.Write(ValorCampo);break;  //"Numérico"
				  case 5:Response.Write(formato(ValorCampo,0));break;
				  case 6:Response.Write(formato(ValorCampo,2));break;
				  case 7:Response.Write(formato(ValorCampo,4));break;		  		  
				} 
			}	
			Response.Write("</td> ")
	} //del iTotales
			if (ArrAgrupada[CAMPO] > 0){  //***********Cuando viene agrupado por un campo****************
				bHayAgrupacion = true
			}
		}
		Response.Write("</tr>") //<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
		//*******************************************************************************
			iRegistrosImpresos++
			  } //Del segundo si
			} //Del primer si
		rsContenido.MoveNext()
	}  //Del ciclo
	rsContenido.Close()

if (Parametro("iTotales",1)==1){	
if (bHayAgrupacion){
	for (CAMPOIND=0;CAMPOIND<iArticulos;CAMPOIND++) {
			if (CAMPOIND == 0){ //bgcolor='#006633'
				Response.Write("<tr><td colspan='"+iArticulos+"' height='1' class='hidden-xs'></td></tr>")
				Response.Write("<tr>")
			}
		if (ArrOperacion[CAMPOIND] != 0){
				//bgcolor='#CCCCCC' 
				Response.Write("<td class='hidden-xs'>&nbsp;")
			switch (ArrOperacion[CAMPOIND]) {
				  case 1: //Suma
					Response.Write("&nbsp;Suma>&nbsp;" + formato(ArrTotSumaInd[CAMPOIND],2))
					break; 
				  case 2://Cuenta
					Response.Write("&nbsp;Cuenta>&nbsp;" + ArrTotCuentaInd[CAMPOIND])
					break; 
				  case 3: //Promedio
					var iPromedioInd = (ArrTotSumaInd[CAMPOIND] / ArrTotCuentaInd[CAMPOIND])
					Response.Write("&nbsp;Promedio>&nbsp;" + iPromedioInd)
					break;
				  case 4: //Máximo
					Response.Write("&nbsp;Máximo>&nbsp;" + ArrTotMaxInd[CAMPOIND])
					break;
				  case 5: //Mínimo
					Response.Write("&nbsp;Mínimo>&nbsp;" + ArrTotMinInd[CAMPOIND])
					break;  
				  case 6: //Titulo
					Response.Write(ArrTitulo[CAMPOIND])
					break; 
			}
		} else { //bgcolor='#CCCCCC' 
			Response.Write("<td class='hidden-xs'>&nbsp;")
		}
		Response.Write("</td>")
	}   Response.Write("</tr>")
			Response.Write("<br>") //bgcolor='#006633' 
			Response.Write("<tr><td colspan='"+iArticulos+"' height='1' class='hidden-xs'> </td> </tr>")
}
} //del iTotales
		if (!bOperacion) {
			Response.Write("</table>")
		}
%>

<% } else {
// ********************************************************************************************************
//         Despliegue total
//	if(bIQon4Web) {
//		Response.Write("<br>iArticulos" + iArticulos)
//		Response.Write("<br>Sin paginación.-<br>")
//	}
	sTempValorCampo = ""
	var ValorNumericoCampoInd = 0
	while (!rsContenido.EOF){
	//Response.Write("ENTRAMOS.-")
		for (CAMPOSU=0;CAMPOSU<iArticulos;CAMPOSU++) {
			//Response.Write("CAMPOSU&nbsp;" + rsContenido.Fields.Item(CAMPOSU).Value)
			ArrValorCampo[CAMPOSU] = rsContenido.Fields.Item(CAMPOSU).Value
		}		
	  	for (CAMPO=0;CAMPO<iArticulos;CAMPO++) {
			//Response.Write("<br>CAMPO&nbsp;" + rsContenido.Fields.Item(CAMPO).Value + "&nbsp;!bPaso&nbsp;" + !bPaso + "<br>")
			ValorCampo = "" + rsContenido.Fields.Item(CAMPO).Value
			if (!bPaso){
				//Response.Write("ArrValorCampo[CAMPO]&nbsp;" + ArrValorCampo[CAMPO] + "<br>")
				ArrTempValorCampo[CAMPO] = ArrValorCampo[CAMPO]
				//Response.Write("CAMPO&nbsp;" + CAMPO + "&nbsp;(iArticulos-1)&nbsp;" + (iArticulos-1) + "<br>")
				if(CAMPO == (iArticulos-1)){
					bPaso = true
				}
			}
//Response.Write(ArrTempValorCampo[CAMPO] + "-<br>&nbsp;-")
//Imprime el corte individual			
if (CAMPO == 0)	{
	if (bHayAgrupacion ){
			for (CAMPOIND=0;CAMPOIND<iArticulos;CAMPOIND++) {
				if (ArrTempValorCampo[CAMPOIND] != ArrValorCampo[CAMPOIND] && ArrAgrupada[CAMPOIND] != 0){
							Response.Write("<tr><td colspan='"+iArticulos+"' height='1' ></td></tr>") //bgcolor='#006633' class='hidden-xs'
							Response.Write("<tr>")
							for (CAMPOEXT=0;CAMPOEXT<iArticulos;CAMPOEXT++) { //class='GridSubTitulos' height='20px'
									Response.Write("<td >&nbsp;")
									CAMPOIND = iArticulos
								if (ArrOperacion[CAMPOEXT] != 0){
									switch (ArrOperacion[CAMPOEXT]) {
										  case 1: //Suma
											Response.Write("&nbsp;Suma>&nbsp;" + formato(ArrTotSumaInd[CAMPOEXT],2))
											break; 
										  case 2://Cuenta
											Response.Write("&nbsp;Cuenta>&nbsp;" + ArrTotCuentaInd[CAMPOEXT])
											break; 
										  case 3: //Promedio
											var iPromedioInd = (ArrTotSumaInd[CAMPOEXT] / ArrTotCuentaInd[CAMPOEXT])
											Response.Write("&nbsp;Promedio>&nbsp;" + iPromedioInd)
											break;
										  case 4: //Máximo
											Response.Write("&nbsp;Máximo>&nbsp;" + ArrTotMaxInd[CAMPOEXT])
											break;
										  case 5: //Mínimo
											Response.Write("&nbsp;Mínimo>&nbsp;" + ArrTotMinInd[CAMPOEXT])
											break;  
										  case 6: //Título
											Response.Write(ArrTitulo[CAMPOEXT])
											break; 
									}
								} 
									ArrTotSumaInd[CAMPOEXT] = 0
									ArrTotCuentaInd[CAMPOEXT] = 0
									ArrTotMaxInd[CAMPOEXT] = 0
									ArrTotMinInd[CAMPOEXT] = 0
									ArrTempValorCampo[CAMPOEXT] = ArrValorCampo[CAMPOEXT]
									bPaso = false
								
								Response.Write("</td>")
							} //del for interno 
							Response.Write("</tr>")
					} //del if
			} //del for   
		} //del if 
if (Parametro("iTotales",1)==1){  Response.Write("<tr>")  }
	} //del if
	//*************************************************
			Response.Write("<td ") //class='hidden-xs'
			//Response.Write(ArrAlineacion[CAMPO])			
			switch (ArrAlineacion[CAMPO] ) {
			  case 1:Response.Write("class='left'");break;
			  case 2:Response.Write("class='center'");break;
			  case 3:Response.Write("class='right'");break;
			  default:Response.Write("class='center'");break;
			}
			if (ArrAncho[CAMPO] > 0) {
				Response.Write(" width='"+ArrAncho[CAMPO]+"' ")
			}
		  	Response.Write(">" )

//Hace las operaciones de los totales Generales			
			ValorNumericoCampo = 0
			if (!isNaN(ValorCampo)) {
				ValorNumericoCampo = parseFloat(ValorCampo)
				if (ArrTotMax[CAMPO] < ValorNumericoCampo) {
					ArrTotMax[CAMPO] = ValorNumericoCampo
				}
				if (ArrTotMin[CAMPO] == 0 ){
					ArrTotMin[CAMPO] = ValorNumericoCampo
				}
				if (ArrTotMin[CAMPO] > ValorNumericoCampo) {
					ArrTotMin[CAMPO] = ValorNumericoCampo
				}				
			}
			ArrTotSuma[CAMPO] += ValorNumericoCampo
			ArrTotCuenta[CAMPO]++
			ArrTitulo[CAMPO]=ValorCampo

			
//Hace las operaciones de los totales individuales
			ValorNumericoCampoInd = 0
			if (!isNaN(ValorCampo)) {
				ValorNumericoCampoInd = parseFloat(ValorCampo)
				if (ArrTotMaxInd[CAMPO] < ValorNumericoCampoInd) {
					ArrTotMaxInd[CAMPO] = ValorNumericoCampoInd
				}
				if (ArrTotMinInd[CAMPO] == 0 ){
					ArrTotMinInd[CAMPO] = ValorNumericoCampoInd
				}
				if (ArrTotMinInd[CAMPO] > ValorNumericoCampoInd) {
					ArrTotMinInd[CAMPO] = ValorNumericoCampoInd
				}				
			}
			ArrTotSumaInd[CAMPO] += ValorNumericoCampoInd
			ArrTotCuentaInd[CAMPO]++
			ArrTitulo[CAMPO]=ValorCampo
			//Response.Write("drp&nbsp;"+ (Parametro("iTotales",1)==1) + "&nbsp;-&nbsp;" +Parametro("iTotales",1) + EsVacio(ValorCampo) + "&nbsp;" + ArrFormato[CAMPO] + "&nbsp;ValorCampo"+ValorCampo)
if (Parametro("iTotales",1)==1){					
			if (EsVacio(ValorCampo)) {
					ValorCampo = ""
					//Response.Write("drp22&nbsp;"+ValorCampo)
				 switch (ArrFormato[CAMPO]) {
					  case 1:Response.Write(ValorCampo);break; //"Texto"
					  case 2:Response.Write(ValorCampo);break; //"Fecha Jul"
					  case 3:Response.Write(ValorCampo);break; //"Fecha Gre"
					  case 4:Response.Write(ValorCampo);break;  //"Numérico"
					  case 5:Response.Write("0");break;
					  case 6:Response.Write("0");break;
					  case 7:Response.Write("0");break;
				 }
			} else {
				//Response.Write("<br>VVVVVV&nbsp;" + ValorCampo + "VVVVVVV");
				switch (parseInt(ArrFormato[CAMPO])) {
						
					  case 1:Response.Write(ValorCampo);break; //"Texto"
					  case 2:Response.Write(JulAGre(ValorCampo));break; //"Fecha Jul"
					  case 3:Response.Write(ValorCampo);break; //"Fecha Gre"
					  case 4:Response.Write(ValorCampo);break;  //"Numérico"
					  case 5:Response.Write(formato(ValorCampo,0));break;
					  case 6:Response.Write(formato(ValorCampo,2));break;
					  case 7:Response.Write(formato(ValorCampo,4));break;
				} 
			} 			Response.Write("</td> ")
		} //del iTotales
			if (ArrAgrupada[CAMPO] > 0){  //***********Cuando viene agrupado por un campo****************
				bHayAgrupacion = true
			}
		}
		Response.Write("</tr>") //<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
		rsContenido.MoveNext()
	 }  
	rsContenido.Close()
if (bHayAgrupacion){
	for (CAMPOIND=0;CAMPOIND<iArticulos;CAMPOIND++) {
			if (CAMPOIND == 0){
				Response.Write("<tr><td colspan='"+iArticulos+"' class='hidden-xs'></td></tr>")  //height='1' bgcolor='#006633'
				Response.Write("<tr>")
			}
		if (ArrOperacion[CAMPOIND] != 0){
				//class='GridSubTitulos'
				Response.Write("<td >&nbsp;")
			switch (ArrOperacion[CAMPOIND]) {
				  case 1: //Suma
					Response.Write("&nbsp;Suma>&nbsp;" + formato(ArrTotSumaInd[CAMPOIND],2))
					break; 
				  case 2://Cuenta
					Response.Write("&nbsp;Cuenta>&nbsp;" + ArrTotCuentaInd[CAMPOIND])
					break; 
				  case 3: //Promedio
					var iPromedioInd = (ArrTotSumaInd[CAMPOIND] / ArrTotCuentaInd[CAMPOIND])
					Response.Write("&nbsp;Promedio>&nbsp;" + iPromedioInd)
					break;
				  case 4: //Máximo
					Response.Write("&nbsp;Máximo>&nbsp;" + ArrTotMaxInd[CAMPOIND])
					break;
				  case 5: //Mínimo
					Response.Write("&nbsp;Mínimo>&nbsp;" + ArrTotMinInd[CAMPOIND])
					break;  
				  case 6: //Titulo
						Response.Write(ArrTitulo[CAMPOIND])
					break; 
			}
		} else {
			Response.Write("<td>&nbsp;")
		}
		Response.Write("</td>")
	}
	        Response.Write("</tr>")
			Response.Write("<br>") // bgcolor='#006633'
			Response.Write("<tr><td colspan='"+iArticulos+"' height='1'> </td> </tr>")
}
		if (!bOperacion) {
			Response.Write("</table>")
		}
	} 
	if (iArticulos > 0 && bOperacion) {
		for (CAMPO=0;CAMPO<iArticulos;CAMPO++) {
			//class='GridSubTitulos'
			Response.Write("<td >&nbsp;")
			switch (ArrOperacion[CAMPO]) {
				  case 1: //Suma
				  	Response.Write("&nbsp;Suma>&nbsp;" + formato(ArrTotSuma[CAMPO],2))
				  	break; 
				  case 2://Cuenta
				  	Response.Write("&nbsp;Cuenta>&nbsp;" + ArrTotCuenta[CAMPO])
					break; 
				  case 3: //Promedio
				  	var iPromedio = (ArrTotSuma[CAMPO] / ArrTotCuenta[CAMPO])
				  	Response.Write("&nbsp;Promedio>&nbsp;" + iPromedio)
					break;
				  case 4: //Máximo
				  	Response.Write("&nbsp;Máximo>&nbsp;" + ArrTotMax[CAMPO])
					break;
				  case 5: //Mínimo
				  	Response.Write("&nbsp;Mínimo>&nbsp;" + ArrTotMin[CAMPO])
				  	break;  
				  case 6: //Titulo
					break; 
			}
			Response.Write("</td>")
		} 
			Response.Write("<tr></table>")	
	}
}
	%>
</form>
</body>
<% if(Parametro("iExport",0) == 1){ %>
	<script>
        setTime(window.close(),5000000);
    </script>
<% } %>


















