<!--#include file="../../Includes/iqon.asp" -->
<%

function ArmaGrid() {
	var sC = String.fromCharCode(34)
	var sWH9 = " width=" + sC + "9" + sC + " height=" + sC + "9" + sC +" "
	var sAL = " align=" + sC + "left" + sC + " "
	var sAC = " align=" + sC + "center" + sC + " "
	var sPadding = " style=" + sC + "padding-right: 5px;padding-left: 5px;" + sC + " "
	var sIniciaTabla = "<table width=" + sC + "100%" + sC + " border=" + sC + "0" + sC + " cellspacing=" + sC + "0" + sC + " cellpadding=" + sC + "0" + sC + " "
		
	var sEncabezado = ""
	var iCampos = -1
	var grdCampo = new Array(0)
	var grdNombre = new Array(0)
	var grdAlias = new Array(0)
	var grdTipo = new Array(0)
	var grdAncho = new Array(0)
	var grdAlineacion = new Array(0)
	var grdClass = new Array(0)
	var SQLTabla = ""
	var SQLCondicion = ""
	var SQLOrden = ""
	var CampoOrden = ""
	var CampoLlave = ""
	var ig = 0
	var igr = 0
	var iRengPintados = 0
	var iUltimoNoRenglon = 0
	var sClassEncabezado = ""
	
	var iRegPorPagina = Parametro("RegPorVentana",12)  
	var iRegistros = 0
	var iRegistrosImpresos = 0
	var iPagina = Parametro("Pag",1)
	var bLoBusco = false
	var LlaveABuscar = 0
	
	//Cargo los parametros de los campos del grid a mostrar y los dejo en arreglos
	//porque lo usare mas abajo varias veces
	
	var sATCps = "Select * "
		sATCps += " from MenuGridCampos "
		sATCps += " Where MGrd_Habilitado = 1 "
		sATCps += "  AND Sys_ID = " + 102
		if (TabIndex > 0) {
			sATCps += "  AND Mnu_ID = " + 320
		} else {
			sATCps += "  AND Mnu_ID = " + 320
		}
		sATCps += " Order By MGrd_Orden "


	var sATCps = "Select * "
		sATCps += " from MenuGridCampos "
		sATCps += " Where MGrd_Habilitado = 1 "
		sATCps += "  AND Sys_ID = 102 "

			sATCps += "  AND Mnu_ID = 320 " 

		sATCps += " Order By MGrd_Orden "
		

	var rsEnc = AbreTabla(sATCps,1,0)

	
	if (rsEnc.EOF){ return ""}
	while (!rsEnc.EOF){
		if (rsEnc.Fields.Item("MGrd_EsLlave").Value == 1 ) {
			CampoLlave             = rsEnc.Fields.Item("MGrd_Campo").Value
		} else {
			iCampos++
			grdCampo[iCampos]      = rsEnc.Fields.Item("MGrd_Campo").Value
			grdNombre[iCampos]     = rsEnc.Fields.Item("MGrd_Nombre").Value
			grdAlias[iCampos]      = "" + rsEnc.Fields.Item("MGrd_Alias").Value
			grdTipo[iCampos]       = rsEnc.Fields.Item("MGrd_TipoCampo").Value
			grdAncho[iCampos]      = rsEnc.Fields.Item("MGrd_AnchoColumna").Value
			grdAlineacion[iCampos] = rsEnc.Fields.Item("MGrd_Alineacion").Value
			grdClass[iCampos]      = rsEnc.Fields.Item("MGrd_Class").Value
		}			
		if (rsEnc.Fields.Item("MGrd_UsarParaOrdenar").Value == 1 ) {
			if (CampoOrden != "" ) { CampoOrden += ", " }
			if (EsVacio("" + rsEnc.Fields.Item("MGrd_Alias").Value)) {
				CampoOrden += rsEnc.Fields.Item("MGrd_Campo").Value
			} else {
				CampoOrden += rsEnc.Fields.Item("MGrd_Alias").Value
			}
		}
		rsEnc.MoveNext()
	}

	sEncabezado = sIniciaTabla + " class=" + sC + "TablaGeneral" + sC + "><tr class=" + sC + "TablaEncabezado" + sC + ">"
	sEncabezado +="<tr class=" + sC + "TablaEncabezado" + sC + "><td width=" + sC + "20" + sC + " class=" + sC + "TablaEncabezado" + sC + " >No.</td>"

	//Se arma el encabezado aqui habra que poner las cosas para ordenar campos o demos cosas que inventres tu
	var sConsultaGral = ""
	for(ig=0;ig<grdCampo.length;ig++){ 
			sEncabezado +="<td width=" + sC + grdAncho[ig] + sC + " "
			sEncabezado +="align=" + sC + grdAlineacion[ig] + sC + " "
			sEncabezado +="class=" + sC + grdClass[ig] + sC + ">"
			sEncabezado += grdNombre[ig] +"</td>"
			if (sConsultaGral != "" ) { sConsultaGral += ", " }
			sConsultaGral += grdCampo[ig]
			if (!EsVacio(grdAlias[ig])) { sConsultaGral += " as " + grdAlias[ig] }
	}
	
	sEncabezado +="<td width=" + sC + "80" + sC + " align=" + sC + "center" + sC + " class=" + sC + "TablaEncabezado" + sC + ">&nbsp;</td></tr>"

	
	//Cargado de datos del encabezado
	var sATTb = "Select * "
		sATTb += " from MenuGridTablas "
		sATTb += " Where  Sys_ID = " + 102
		if (TabIndex > 0) {
			sATTb += " AND Mnu_ID = " + 320
		} else {
			sATTb += " AND Mnu_ID = " + 320
		}

	var sATTb = "Select * "
		sATTb += " from MenuGridTablas "
		sATTb += "  Where  Sys_ID = 102 " 
			sATTb += " AND Mnu_ID = 320 "



	var rsEncTB = AbreTabla(sATTb,1,0)
	if (rsEncTB.EOF){ return ""}
	if (!rsEncTB.EOF){
			SQLTabla = "" + rsEncTB.Fields.Item("MGrdT_SQLTabla").Value
			SQLCondicion = "" + rsEncTB.Fields.Item("MGrdT_SQLCondicion").Value
			SQLOrden = "" + rsEncTB.Fields.Item("MGrdT_SQLOrden").Value
	}
	rsEncTB.Close()

	//Cargado de Informacion Armado de la sentencia sql
	sConsultaGral = "Select " + CampoLlave + ", " + sConsultaGral  + " "
	sConsultaGral += " from " + SQLTabla + " "
	
	if (!EsVacio(SQLCondicion)) {
		sConsultaGral += " Where " + SQLCondicion + " "
	}
	
	// 19 ene 2011
	//Se le da prioridad a el orden encontrado en la tabla de configuracion de encabezado de tabla y 
	//segunda prioridad al campo de orden de la tabal de campos
	if (!EsVacio(SQLOrden)) {
		sConsultaGral += " Order by " + SQLOrden + " "
	} else {
		if (!EsVacio(CampoOrden)) {	sConsultaGral += " Order by " + CampoOrden }
	}
	
	var TipoRenglon = "evenRow"
	var rsINS = AbreTabla(sConsultaGral,1,0)
	if (!rsINS.EOF) {
		if (bLoBusco) {
			while (!rsINS.EOF){
				iRegistros++
				if (LlaveABuscar == rsINS.Fields.Item(CampoLlave).Value){
					if (iRegistros > RegPorVentana) {
						iPagina = parseInt(iRegistros/RegPorVentana) +1
					}
					ParametroCambiaValor("Pag",iPagina)
					break
				}	
				rsINS.MoveNext()
			}
			rsINS.MoveFirst()
		}
		iRegistros = 0
		
		if (iPagina	< 1 ) { iPagina = 1}
	
		var RegInicial = (iPagina * iRegPorPagina) - iRegPorPagina + 1
		rsINS.Move(RegInicial-1)
		iRegistros = RegInicial - 1
		while (!rsINS.EOF){
			iRegistros++
			iRengPintados++
			if (iRegistros>=RegInicial) {
				if (iRegistrosImpresos < iRegPorPagina) {
					if (TipoRenglon == "evenRow") {
						TipoRenglon = "oddRow"
					} else {
						TipoRenglon = "evenRow"
					}
					var sNombre = ""  
					//Colocando el encabezado y las llamadas a el rollback del grid cambiar a jquery porfa
				    sEncabezado +="<tr "
					sEncabezado +="onmouseover=" + sC + "styleSwap(this, 'hover', 'normal', 'rowHiliten');" + sC + " "
					sEncabezado +="onmouseout=" + sC + "styleSwap(this, 'normal', 'hover', 'rowHiliten');" + sC + " "
					sEncabezado +="title=" + sC + sNombre + sC 
					sEncabezado +="  >"
					//Colocando el numero de renglon del grid  
					sEncabezado +="<td height=" + sC + "24" + sC + " align=" + sC + "center" + sC + " class=" + sC + "TablaEncabezado " + TipoRenglon + sC + ">"
					sEncabezado +="<strong>" + iRegistros + "</strong></td>"
					iUltimoNoRenglon = iRegistros
					//Cargando datos y formato
					var sNombreCampo = ""
					for(ig=0;ig<grdCampo.length;ig++){ 
//							"class='grdClass[ig]'"
							if (EsVacio(grdAlias[ig])) { 
								sNombreCampo = grdCampo[ig] 
							} else {
								sNombreCampo = grdAlias[ig]
							}
						sEncabezado += "<td align=" + sC + grdAlineacion[ig] + sC + " class=" + sC + "fontBlack " + TipoRenglon + sC + " >"
						//Escribiendo el dato segun el tipo de campo
						switch (parseInt(grdTipo[ig])) {
							case 1:		// texto
								sEncabezado += "" + rsINS.Fields.Item( sNombreCampo ).Value
								break;
							case 2:		
								sEncabezado += "" + rsINS.Fields.Item( sNombreCampo ).Value
								break;
							case 3:		// si/no
								if (rsINS.Fields.Item( sNombreCampo ).Value == 1) {
									sEncabezado += "Si"
								} else {
									sEncabezado += "No"
								}
								break;
							default:
								sEncabezado += "" + rsINS.Fields.Item( sNombreCampo ).Value
								break;
						}
						sEncabezado += "&nbsp;</td>"	
					}
					//Columna de Funciones
					sEncabezado += "<td align=" + sC + "center" + sC + " class=" + sC + "fontBlack " + TipoRenglon + sC + " >"
                    sEncabezado += "<a href=" + sC + "javascript:Selecciona(" + rsINS.Fields.Item(CampoLlave).Value + ");" + sC + ">Seleccionar</a>&nbsp;-&nbsp;"
					//if (Session("Borrar") == 1) {
						sEncabezado += "<a href=" + sC + "javascript:AcBorrar(" + rsINS.Fields.Item(CampoLlave).Value + "," + iRegistros + ")" + sC + ">Borrar</a>"
			  		//} 
              		sEncabezado += "</td></tr>"
      
              		iRegistrosImpresos++ 
				} else {
					if (Parametro("TR",0) > 0) { 
						iRegistros  = Parametro("TR",0)
						break
					}
				}
		 	} 
			rsINS.MoveNext()
		}
		rsINS.Close()  
	}

	// Paginacion

	sPaginacion  = "<script language=" + sC + "JavaScript" + sC + ">"
	sPaginacion += "function AcPaginacion(Valor) {document.frmDatos.RegPorVentana.value = Valor;document.frmDatos.Pag.value = 1;CambiaTab(" + TabIndex + ");}"
	sPaginacion += "function AcIrAPagina(Valor) {document.frmDatos.Pag.value = Valor;CambiaTab(" + TabIndex + ");}"
	sPaginacion += "</script>"
	sPaginacion += "<table width=" + sC + "100%" + sC + " border=" + sC + "0" + sC + " cellpadding=" + sC + "0" + sC + " cellspacing=" + sC + "0" + sC + ">"
	sPaginacion += "<tr><td height=" + sC + "5" + sC + " colspan=" + sC + "11" + sC + "></td></tr>"
	sPaginacion += "<tr><td height=" + sC + "1" + sC + " colspan=" + sC + "11" + sC + " bgcolor=" + sC + "#000033" + sC + "></td></tr>"
	sPaginacion += "<tr >"
	sPaginacion += "<td width=" + sC + "5%" + sC + " align=" + sC + "left" + sC + " background=" + sC + "/Plugins/Grid_IQon/img/Fondo.jpg" + sC + "><img src=" + sC + "/Plugins/Grid_IQon/img/Boton.jpg" + sC + " width=" + sC + "24" + sC + " height=" + sC + "25" + sC + " /></td>"
	sPaginacion += "<td width=" + sC + "71%" + sC + " height=" + sC + "22" + sC + " align=" + sC + "right" + sC + " background=" + sC + "/Plugins/Grid_IQon/img/Fondo.jpg" + sC + " class=" + sC + "fontBlack" + sC + "> Registros por p&aacute;gina "
	sPaginacion += "<select name=" + sC + "RegPorVentana" + sC + " onchange=" + sC + "AcPaginacion(this.value)" + sC + " class=" + sC + "fontBlack" + sC + ">"
	sPaginacion += "<option value=" + sC + "10" + sC 
	if ( Parametro("RegPorVentana",RegPorVentana) <= 10) { sPaginacion += "selected " } 
	sPaginacion += ">10</option><option value=" + sC + "12" + sC 
	if ( Parametro("RegPorVentana",RegPorVentana) == 12) { sPaginacion += "selected " } 
	sPaginacion += ">12</option><option value=" + sC + "20" + sC
	if ( Parametro("RegPorVentana",RegPorVentana) == 20) { sPaginacion += "selected " } 
	sPaginacion += ">20</option><option value=" + sC + "30" + sC
	if ( Parametro("RegPorVentana",RegPorVentana) == 30) { sPaginacion += "selected " } 
	sPaginacion += ">30</option><option value=" + sC + "50" + sC
	if ( Parametro("RegPorVentana",RegPorVentana) == 50) { sPaginacion += "selected " } 
	sPaginacion += ">50</option><option value=" + sC + "100" + sC
	if ( Parametro("RegPorVentana",RegPorVentana) == 100) { sPaginacion += "selected " } 
	sPaginacion += ">100</option><option value=" + sC + "10000" + sC
	if ( Parametro("RegPorVentana",RegPorVentana) > 100) { sPaginacion += "selected " } 
	sPaginacion += ">todos        </option></select>"
	
	//Parametros necesarios de la página
	var ParLetra = ""
	//if (Parametro("Letra","Todas") != "Todas") {
		ParLetra += "Letra="+Parametro("Letra","Todas")+ "&"
	//} 		
 	var iCont = 1
	var iPag = 0
	var iPaginaActual  = Parametro("Pag",1)
	ParLetra += "TR="+iRegistros+ "&"    
	sPaginacion += "<input type=" + sC + "hidden" + sC + " name=" + sC + "TR" + sC + " value=" + sC + "" + iRegistros + "" + sC + ">"
	sPaginacion += "<input type=" + sC + "hidden" + sC + " name=" + sC + "Pag" + sC + " value=" + sC + Parametro("Pag",1) + sC + ">"
	sPaginacion += "<body  class=" + sC + "fontBlack" + sC + "> Total:" + iRegistros
	sPaginacion += "<body  class=" + sC + "fontBlack" + sC + "> &nbsp;Registros&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;"
	sPaginacion += "P&aacute;gina actual&nbsp;&nbsp;"
	sPaginacion += "<select name=" + sC + "IrAPagina" + sC + "  onchange=" + sC + "AcIrAPagina(this.value)" + sC + "  class=" + sC + "fontBlack" + sC + " >"     

	iPag = parseInt(iRegistros / iRegPorPagina)
	if((iRegistros % iRegPorPagina) > 0) { iPag++ }
	
	for (i = 1; i <= iPag; i++) {
		if (iPaginaActual == i) {
			sPaginacion += "<option value=" + sC + i + sC + " selected >" + i + "</option>"
		} else {
			sPaginacion += "<option value=" + sC + i + sC + " >" + i + "</option>"
		}
	}
	sPaginacion += "</select>"
	sPaginacion += "&nbsp; de &nbsp;" + iPag + "&nbsp; P&aacute;ginas&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>"

	if (iPag > 1) {
		if (iPaginaActual > 1) {
			var Anterior = parseInt(iPaginaActual) - 1 
			sPaginacion += "<td width=" + sC + "3%" + sC + " align=" + sC + "left" + sC + " background=" + sC + "/Plugins/Grid_IQon/img/Fondo.jpg" + sC + ">"
			sPaginacion += "<a href=" + sC + "javascript:AcIrAPagina(1)" + sC + "><img src=" + sC + "/Plugins/Grid_IQon/img/BtnPrimero.gif" + sC + " border=" + sC + "0" + sC + "></a></td>"
			sPaginacion += "<td width=" + sC + "3%" + sC + " align=" + sC + "left" + sC + " background=" + sC + "/Plugins/Grid_IQon/img/Fondo.jpg" + sC + ">"
			sPaginacion += "<a href=" + sC + "javascript:AcIrAPagina(" + Anterior + ")" + sC + "><img src=" + sC + "/Plugins/Grid_IQon/img/BtnAnterior.gif" + sC + " border=" + sC + "0" + sC + "></a></td>"
		} else { 
			sPaginacion += "<td width=" + sC + "3%" + sC + " align=" + sC + "left" + sC + " background=" + sC + "/Plugins/Grid_IQon/img/Fondo.jpg" + sC + ">"
			sPaginacion += "<img src=" + sC + "/Plugins/Grid_IQon/img/BtnPrimero_off.gif" + sC + " border=" + sC + "0" + sC + "></td>"
			sPaginacion += "<td width=" + sC + "3%" + sC + " align=" + sC + "left" + sC + " background=" + sC + "/Plugins/Grid_IQon/img/Fondo.jpg" + sC + ">"
			sPaginacion += "<img src=" + sC + "/Plugins/Grid_IQon/img/BtnAnterior_off.gif" + sC + " border=" + sC + "0" + sC + "></td>"
		}
		if (iPag > iPaginaActual) { 
			var Siguiente = parseInt(iPaginaActual) + 1
			sPaginacion += "<td width=" + sC + "3%" + sC + " align=" + sC + "right" + sC + " background=" + sC + "/Plugins/Grid_IQon/img/Fondo.jpg" + sC + ">"
			sPaginacion += "<a href=" + sC + "javascript:AcIrAPagina(" + Siguiente + ")" + sC + " ><img src=" + sC + "/Plugins/Grid_IQon/img/BtnSiguiente.gif" + sC + " border=" + sC + "0" + sC + "></a></td>"
			sPaginacion += "<td width=" + sC + "3%" + sC + " align=" + sC + "right" + sC + " background=" + sC + "/Plugins/Grid_IQon/img/Fondo.jpg" + sC + ">"
			sPaginacion += "<a href=" + sC + "javascript:AcIrAPagina(" + iPag + ")" + sC + " ><img src=" + sC + "/Plugins/Grid_IQon/img/BtnUltimo.gif" + sC + " border=" + sC + "0" + sC + " ></a></td>"
		}  else {
			sPaginacion += "<td width=" + sC + "3%" + sC + " align=" + sC + "right" + sC + " background=" + sC + "/Plugins/Grid_IQon/img/Fondo.jpg" + sC + ">"
			sPaginacion += "<img src=" + sC + "/Plugins/Grid_IQon/img/BtnSiguiente_off.gif" + sC + " border=" + sC + "0" + sC + "></td>"
			sPaginacion += "<td width=" + sC + "3%" + sC + " align=" + sC + "right" + sC + " background=" + sC + "/Plugins/Grid_IQon/img/Fondo.jpg" + sC + ">"
			sPaginacion += "<img src=" + sC + "/Plugins/Grid_IQon/img/BtnUltimo_off.gif" + sC + " border=" + sC + "0" + sC + " ></td>"
		}
	}
	sPaginacion += "<td width=" + sC + "3%" + sC + " align=" + sC + "right" + sC + " background=" + sC + "/Plugins/Grid_IQon/img/Fondo.jpg" + sC + ">&nbsp;&nbsp;&nbsp;</td></tr>"
	sPaginacion += "<tr><td height=" + sC + "1" + sC + " colspan=" + sC + "11" + sC + " bgcolor=" + sC + "#000033" + sC + " ></td></tr>"
	sPaginacion += "<tr><td height=" + sC + "2" + sC + " colspan=" + sC + "11" + sC + "></td></tr></table>"
	sPaginacion += "<script language=" + sC + "JavaScript" + sC + " type=" + sC + "text/JavaScript" + sC + ">"
	sPaginacion += "TotReg = " + iRegistros +";</script>"

	sEncabezado = sPaginacion + sEncabezado
	//Estos son los renglones de relleno
	RegPorVentana = Parametro("RegPorVentana",RegPorVentana)
	for(ig=iRengPintados;ig<RegPorVentana;ig++){ 
		iUltimoNoRenglon++
		if (TipoRenglon == "evenRow") {
			TipoRenglon = "oddRow"
		} else {
			TipoRenglon = "evenRow"
		}
//		"class='grdClass[ig]'"
				    sEncabezado +="<tr "
					sEncabezado +="onmouseover=" + sC + "styleSwap(this, 'hover', 'normal', 'rowHiliten');" + sC + " "
					sEncabezado +="onmouseout=" + sC + "styleSwap(this, 'normal', 'hover', 'rowHiliten');" + sC + " "
					sEncabezado +="title=" + sC + sNombre + sC 
					sEncabezado +="  >"
					sEncabezado +="<td height=" + sC + "24" + sC + " align=" + sC + "center" + sC + " class=" + sC + "fontBlack " + TipoRenglon + sC + ">"
					sEncabezado +="<strong>" + iUltimoNoRenglon + "</strong></td>"
					for(igr=0;igr<grdCampo.length;igr++){ 
						sEncabezado += "<td align=" + sC + grdAlineacion[ig] + sC + " class=" + sC + "fontBlack " + TipoRenglon + sC + " >&nbsp;</td>"	
					}
					//Columna de Funciones
					sEncabezado += "<td align=" + sC + "center" + sC + " class=" + sC + "fontBlack " + TipoRenglon + sC + " >"
                    sEncabezado += "&nbsp;</td></tr>"
	}
	//Este es el cierre de la tabla
	//sEncabezado +="<td >&nbsp;</td></tr>"
	sEncabezado +="<tr><td height=" + sC + "2" + sC + " colspan=" + sC + grdCampo.length + 2 + sC + " bgcolor=" + sC + "#CCCCCC" + sC + " ></td></tr></table>"
	    
	
	OcultosParaElGrid = ""


	var sFG = "<input type=" + sC + "hidden" + sC + " name=" + sC + CampoLlave + sC + " value=" + sC + "-1" + sC + ">"
		sFG += "<input type=" + sC + "hidden" + sC + " name=" + sC + "tmpPagina" + sC + " value=" + sC + iPagina + sC + ">"
        sFG += "<input type=" + sC + "hidden" + sC + " name=" + sC + "tmpRegPorPagina" + sC + " value=" + sC + iRegPorPagina + sC + ">"
        
	OcultosParaElGrid = sFG
	

	return sEncabezado
}        


	Response.Write(ArmaGrid())

%>