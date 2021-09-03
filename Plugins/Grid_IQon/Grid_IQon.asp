<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../Includes/iqon.asp" -->
<%
function ArmaGrid() {

	var sC = String.fromCharCode(34)
	var sWH9 = " width=" + sC + "9" + sC + " height=" + sC + "9" + sC +" "
	var sAL = " align=" + sC + "left" + sC + " "
	var sAC = " align=" + sC + "center" + sC + " "
	var sPadding = " style=" + sC + "padding-right: 5px;padding-left: 5px;" + sC + " "
	var sIniciaTabla = "<ta" + "ble width=" + sC + "100%" + sC + " border=" + sC + "0" + sC + " cellspacing=" + sC + "0" + sC + " cellpadding=" + sC + "0" + sC + " "
		
	var sEncabezado = ""
	var iCampos = -1
	var iCamposO = -1
	var grdCampo = new Array(0)
	var grdNombre = new Array(0)
	var grdAlias = new Array(0)
	var grdTipo = new Array(0)
	var grdAncho = new Array(0)
	var grdAlineacion = new Array(0)
	var grdClass = new Array(0)
	
	var ocultoNombre = new Array(0)
	var ocultoParam = new Array(0)
	
	var SQLTabla = ""
	var SQLCondicion = ""
	var SQLOrden = ""
	var iSQLVieneDeBuscador = -1
	var CampoOrden = ""
	
	var sCondicionPorParametro = "" //para arreglo de condiciones posicion: 1= campo 2=nombreparametreo 3,ValorDefault separado por comas y pipes
	var arrPrmNm = new Array(0)
	var arrPrmDf = new Array(0)
	var arrCampo = new Array(0)
	var arrPrmCPP = new Array(0)
	
	var CampoLlave = ""
	var sqCampoLlave = ""
	var ig = 0
	var igr = 0
	var iRengPintados = 0
	var iUltimoNoRenglon = 0
	var sClassEncabezado = ""
	
	var iRegPorPagina = Parametro("RegPorVentana",RegPorVentana)  
	var iRegistros = 0
	var iRegistrosImpresos = 0
	var iPagina = Parametro("Pag",1)
	var bLoBusco = false
	var LlaveABuscar = 0
	// ======== LEE LOS CAMPOS QUE FORMAN EL ENCABEZADO Y LOS QUE MOSTRARAN LA INFORMACIÓN
	var sATCps = "SELECT * "
		sATCps += " FROM MenuGridCampos "
		sATCps += " WHERE MGrd_Habilitado = 1 "
		sATCps += "  AND Sys_ID = " + SistemaActual
		sATCps += "  AND Mnu_ID = " + VentanaIndex

		sATCps += " ORDER BY MGrd_Orden "
		

	var rsEnc = AbreTabla(sATCps,1,2)

	if (rsEnc.EOF){ return ""}
	while (!rsEnc.EOF){
		if (rsEnc.Fields.Item("MGrd_EsLlave").Value == 1 ) {
			if (EsVacio("" + rsEnc.Fields.Item("MGrd_Alias").Value)) {
				CampoLlave = rsEnc.Fields.Item("MGrd_Campo").Value
				sqCampoLlave = CampoLlave
			} else {
				CampoLlave = rsEnc.Fields.Item("MGrd_Alias").Value
				sqCampoLlave = rsEnc.Fields.Item("MGrd_Campo").Value + " as " + CampoLlave
			}
			//CampoLlave = DSITrim(CampoLlave)
		} else {
			if ( rsEnc.Fields.Item("MGrd_EsCampoOculto").Value == 0 ) {
				iCampos++
				grdCampo[iCampos]      = rsEnc.Fields.Item("MGrd_Campo").Value
				grdNombre[iCampos]     = rsEnc.Fields.Item("MGrd_Nombre").Value
				grdAlias[iCampos]      = "" + rsEnc.Fields.Item("MGrd_Alias").Value
				grdTipo[iCampos]       = rsEnc.Fields.Item("MGrd_TipoCampo").Value
				grdAncho[iCampos]      = rsEnc.Fields.Item("MGrd_AnchoColumna").Value
				grdAlineacion[iCampos] = rsEnc.Fields.Item("MGrd_Alineacion").Value
				grdClass[iCampos]      = rsEnc.Fields.Item("MGrd_Class").Value
			} else { 
				iCamposO++
				ocultoNombre[iCamposO] = rsEnc.Fields.Item("MGrd_Campo").Value
				ocultoParam[iCamposO] = rsEnc.Fields.Item("MGrd_Alias").Value
			}
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

	
	var sATTb = "SELECT * "
		sATTb += " FROM MenuGridTablas "
		sATTb += " WHERE  Sys_ID = " + SistemaActual
		sATTb += " AND Mnu_ID = " + VentanaIndex

	var rsEncTB = AbreTabla(sATTb,1,2)
	if (rsEncTB.EOF){ return ""}
	if (!rsEncTB.EOF){
			SQLTabla = "" + rsEncTB.Fields.Item("MGrdT_SQLTabla").Value
			SQLCondicion = "" + rsEncTB.Fields.Item("MGrdT_SQLCondicion").Value
			SQLOrden = "" + rsEncTB.Fields.Item("MGrdT_SQLOrden").Value
			iSQLVieneDeBuscador = rsEncTB.Fields.Item("MGrdT_VieneDeBuscador").Value
			sCondicionPorParametro = rsEncTB.Fields.Item("MGrdT_CondicionPorParametro").Value
	}
	rsEncTB.Close()

	//sConsultaGral = "SELECT " + CampoLlave + ", " + sConsultaGral  + " "
	sConsultaGral = "SELECT " + sqCampoLlave + ", " + sConsultaGral  + " "
	sConsultaGral += " FROM " + SQLTabla + " "
	
	var arrPrmCPP = new Array(0)
	var arrCampo = new Array(0)

	if (EsVacio(SQLCondicion)) {
		SQLCondicion = ""
	}

	if (!EsVacio(sCondicionPorParametro) ) {
		arrPrmCPP = sCondicionPorParametro.split("|")
		for (i=0;i<arrPrmCPP.length;i++) {
			var Txt = String(arrPrmCPP[i])
			var arrCampo = Txt.split(",")
			if (SQLCondicion != "") {
				SQLCondicion += " AND "
			}
			SQLCondicion += " " + arrCampo[0] + " = " + Parametro(arrCampo[1],arrCampo[2]) 
		}
	}
	
	//sConsultaGral += " WHERE Sys_ID = " + SistemaActual + " "

	//==================== VIENE DE ALGUN BUSCADOR ====================
	//Response.Write(sConsultaGral) 
	
	if (parseInt(iSQLVieneDeBuscador) > -1  && AccionDePaginacion == 0) {

		var sSQLCamposBus = " SELECT * FROM MenuFichaCampos "
			sSQLCamposBus += " WHERE MFC_Habilitado = 1 "
			sSQLCamposBus += "  AND Mnu_ID = " + iSQLVieneDeBuscador
			sSQLCamposBus += "  AND Sys_ID = " + SistemaActual
			//Response.Write("<font color='red'><strong>sSQLCamposBus&nbsp;" + sSQLCamposBus + "</strong></font>")
			
		var rsSQLCamposBus = AbreTabla(sSQLCamposBus,1,2)
		
		var iCamposBus = -1
		var grdCampoBus = new Array(0)
		var grdTipoCampoBus = new Array(0)
		var grdValorDefBus = new Array(0)
		var grdIDCatGralBus = new Array(0)
		var grdCboTablaBus = new Array(0)
		var grdEsBusqEstricta = new Array(0)

			
		//if (rsSQLCamposBus.EOF){ return "" }
		
		while (!rsSQLCamposBus.EOF){
		
				iCamposBus++
				grdCampoBus[iCamposBus]  		= rsSQLCamposBus.Fields.Item("MFC_Campo").Value
				grdTipoCampoBus[iCamposBus] 	= rsSQLCamposBus.Fields.Item("MFC_TipoCampo").Value
				grdValorDefBus[iCamposBus]  	= rsSQLCamposBus.Fields.Item("MFC_ValorDefault").Value
				grdIDCatGralBus[iCamposBus]     = rsSQLCamposBus.Fields.Item("MFC_IDCatalogoGeneral").Value
				grdCboTablaBus[iCamposBus]      = rsSQLCamposBus.Fields.Item("MFC_ComboTabla").Value
				grdEsBusqEstricta[iCamposBus]	= rsSQLCamposBus.Fields.Item("MFC_EsBusqEstricta").Value
				
			rsSQLCamposBus.MoveNext()
		}
		
		rsSQLCamposBus.Close()
		
/*
1 texto
2 o ption
5 check
7 Catalogo
4 Combo
6 Fecha
*/		
		var sCondBus = ""
		//Response.Write("<br>------------------------------------------------------")
		//Response.Write("<br> SQLCondicion " + SQLCondicion)
		
			for(igB=0;igB<grdCampoBus.length;igB++){
				
				//Response.Write("<br>No.-&nbsp;" + igB + "&nbsp;" + grdCampoBus[igB])
				//Response.Write(" valor  " +Parametro(grdCampoBus[igB],""))

				if (Parametro(grdCampoBus[igB],"") != "") {
					if (grdTipoCampoBus[igB] == 1 || grdTipoCampoBus[igB] == 6) {
						if ( sCondBus != "") { sCondBus += " AND " }
						sCondBus += " " + grdCampoBus[igB]
						if (grdEsBusqEstricta[igB] == 1) {
							sCondBus += "= '" + Parametro(grdCampoBus[igB],"") +"' "
						} else {
							sCondBus += " LIKE '%" + Parametro(grdCampoBus[igB],"") +"%' "
						}
					}				

					if (grdTipoCampoBus[igB] == 7 || grdTipoCampoBus[igB] == 4) {
						if (Parametro(grdCampoBus[igB],-1) > -1) {
							if ( sCondBus != "") { sCondBus += " AND " }
							sCondBus += " " + grdCampoBus[igB]
							sCondBus += " = " + Parametro(grdCampoBus[igB],-1)
						}
					}	

					
				}if (grdTipoCampoBus[igB] == 5 || grdTipoCampoBus[igB] == 2) {
						if ( sCondBus != "") { sCondBus += " AND " }
						if (Parametro(grdCampoBus[igB],0) > 0) {
							sCondBus += " " + grdCampoBus[igB]	
							sCondBus += " = 1 " 
						} else {
							sCondBus += " " + grdCampoBus[igB]	
							sCondBus += " = 0 " 						
						}
					}
//		Response.Write("<br>------------------------------------------------------")
//		Response.Write("<br> sCondBus " + sCondBus)
//		Response.Write("<br>------------------------------------------------------<br><br>")
			}

		if (EsVacio(sCondBus)) { sCondBus = ""  }

		if (sCondBus != "") {
			var stmpep = EscribeParametrosdeBusquedaBD(sCondBus)
//Response.Write("<br>--------------------------------------------------------------------------------------------")
//Response.Write("<br> Escribiendo en la BD la consulta calculada -" + stmpep + "-")			
		}

		if (sCondBus != "") {
			if (SQLCondicion != "") { SQLCondicion += " AND " }
			SQLCondicion += sCondBus
		}
	}	
//Response.Write("<br>--------------------------------------------------------------------------------------------")
//Response.Write("<br> sCondBus -" + sCondBus + "-")
//Response.Write("<br> SQLCondicion -" + SQLCondicion + "-")
//Response.Write("<br>--------------------------------------------------------------------------------------------<br><br>")
	if (EsVacio(sCondBus)) {
		sCondBus = LeerParametrosdeBusquedaBD() 
				if (EsVacio(sCondBus)) { sCondBus = ""  }  //esto es porque el wy venia null de pronto 
		//Response.Write("<br>condicion de busqueda leida de la bd " + sCondBus )
		
		if (SQLCondicion != "" && sCondBus != "" ) { SQLCondicion += " AND " }  
		SQLCondicion += sCondBus
	}
//Response.Write("<br> sCondBus -" + sCondBus + "-")
//Response.Write("<br> SQLCondicion -" + SQLCondicion + "-")
//Response.Write("<br>--------------------------------------------------------------------------------------------<br><br>")	
		
	//Response.Write("<br><font color='red'><strong>sConsultaGral&nbsp;" + SQLCondicion + "</strong></font>")

	//==================== VIENE DE ALGUN BUSCADOR ====================
	
	if (SQLCondicion != "") {
		sConsultaGral += " WHERE " + SQLCondicion + " "
	}
	
	if (!EsVacio(SQLOrden)) {
		sConsultaGral += " ORDER BY " + SQLOrden + " "
	} else {
		if (!EsVacio(CampoOrden)) {	sConsultaGral += " ORDER BY " + CampoOrden }
	}

//AgregaDebugBD("1) SQL del GRID",sConsultaGral)
//Response.Write("<br><font color='red'><strong>CONSULTA DEL GRID <br>" + sConsultaGral+ "</strong></font>")

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
					//AgregaDebugBD("1.1) ","Pagina="  + iPagina)
					break
				}	
				rsINS.MoveNext()
			}
			rsINS.MoveFirst()
		}
		iRegistros = 0
//AgregaDebugBD("2) ","ya lei campos llave")			
		if (iPagina	< 1 ) { iPagina = 1}
	
		var RegInicial = (iPagina * iRegPorPagina) - iRegPorPagina + 1
		rsINS.Move(RegInicial-1)
		iRegistros = RegInicial - 1
		while (!rsINS.EOF){
			iRegistros++
			iRengPintados++
			//AgregaDebugBD("2.1) ","entrando en el ciclo")
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
					sEncabezado +="<td height=" + sC + "24" + sC + " align=" + sC + "center" + sC + " class=" + sC + "fontBlack " + TipoRenglon + sC + ">"
					sEncabezado +="<strong>" + iRegistros + "</strong></td>"
					//AgregaDebugBD("2.2) ","imprimiendo encabezado tabla renglon"  + iRegistros)
					iUltimoNoRenglon = iRegistros
					var sNombreCampo = ""
					for(ig=0;ig<grdCampo.length;ig++){ 
							
							if (EsVacio(grdAlias[ig])) { 
								sNombreCampo = grdCampo[ig]
								//AgregaDebugBD("2.3b) ","sNombreCampo="  + grdCampo[ig])
							} else {
								sNombreCampo = grdAlias[ig]
								//AgregaDebugBD("2.3a) "," mombrealias="  +  grdAlias[ig])
								//AgregaDebugBD("2.3b) ","sNombreCampo="  + grdCampo[ig])
							}
							
							
						sEncabezado += "<td align=" + sC + grdAlineacion[ig] + sC + " class=" + sC + "fontBlack " + TipoRenglon + sC + " >"
						switch (parseInt(grdTipo[ig])) {
							case 1:		
								sEncabezado += "" + rsINS.Fields.Item( sNombreCampo ).Value
								break;
							case 2:		
								sEncabezado += "" + rsINS.Fields.Item( sNombreCampo ).Value
								break;
							case 3:		
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
						//AgregaDebugBD("2.4) Cerrando td","")
					}
					sEncabezado += "<td align=" + sC + "center" + sC + " class=" + sC + "fontBlack " + TipoRenglon + sC + " >"
//AgregaDebugBD("2.5) Campo llave",CampoLlave)
					var sValorCLL = String(rsINS.Fields.Item(CampoLlave).Value)
//AgregaDebugBD("2.6) valor Campo llave",sValorCLL)					
                    sEncabezado += "<a href=" + sC + "javascript:grSelecciona(" + sValorCLL + ");" + sC + ">Seleccionar</a>"

					//if (Session("Borrar") == 1) {
						//sEncabezado += "&nbsp;-&nbsp;<a href=" + sC + "javascript:grAccBorrar(" + String(rsINS.Fields.Item(CampoLlave).Value) + "," + iRegistros + ")" + sC + ">Borrar</a>"
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
//AgregaDebugBD("3) ","ya imprimi los valores")	

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
	sPaginacion += ">12</option><option value=" + sC + "15" + sC
	if ( Parametro("RegPorVentana",RegPorVentana) == 15) { sPaginacion += "selected " } 
	sPaginacion += ">15</option><option value=" + sC + "20" + sC
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
//AgregaDebugBD("4) ","ya imprimi la paginacion")		
	//Parametros necesarios de la página
	var ParLetra = ""
		ParLetra += "Letra="+Parametro("Letra","Todas")+ "&" 		
 	var iCont = 1
	var iPag = 0
	var iPaginaActual  = Parametro("Pag",1)
	ParLetra += "TR="+iRegistros+ "&"    
	sPaginacion += "<input type=" + sC + "hidden" + sC + " name=" + sC + "TR" + sC + " value=" + sC + "" + iRegistros + "" + sC + ">"
	sPaginacion += "<input type=" + sC + "hidden" + sC + " name=" + sC + "Pag" + sC + " value=" + sC + Parametro("Pag",1) + sC + ">"
	sPaginacion += "<input type=" + sC + "hidden" + sC + " name=" + sC + "AccionDePaginacion" + sC + " value=\"1\">"
	sPaginacion += "<body  class=" + sC + "fontBlack" + sC + "> Total:" + iRegistros
	sPaginacion += "<body  class=" + sC + "fontBlack" + sC + "> &nbsp;Registros&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;"
	sPaginacion += "P&aacute;gina actual&nbsp;&nbsp;"
	sPaginacion += "<select name=" + sC + "IrAPagina" + sC + "  onchange=" + sC + "AcIrAPagina(this.value)" + sC + "  class=" + sC + "fontBlack" + sC + " >"     
//AgregaDebugBD("4) ","ya los ocultos")	
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
	
	//RegPorVentana = Parametro("RegPorVentana",RegPorVentana)
//	for(ig=iRengPintados;ig<RegPorVentana;ig++){ 
//		iUltimoNoRenglon++
//		if (TipoRenglon == "evenRow") {
//			TipoRenglon = "oddRow" 
//		} else {
//			TipoRenglon = "evenRow"
//		}
//				    sEncabezado +="<tr "
//					sEncabezado +="onmouseover=" + sC + "styleSwap(this, 'hover', 'normal', 'rowHiliten');" + sC + " "
//					sEncabezado +="onmouseout=" + sC + "styleSwap(this, 'normal', 'hover', 'rowHiliten');" + sC + " "
//					sEncabezado +="title=" + sC + sNombre + sC 
//					sEncabezado +="  >"
//					sEncabezado +="<td height=" + sC + "24" + sC + " align=" + sC + "center" + sC + " class=" + sC + "fontBlack " + TipoRenglon + sC + ">"
//					sEncabezado +="<strong>" + iUltimoNoRenglon + "</strong></td>"
//					for(igr=0;igr<grdCampo.length;igr++){ 
//						sEncabezado += "<td align=" + sC + grdAlineacion[ig] + sC + " class=" + sC + "fontBlack " + TipoRenglon + sC + " >&nbsp;</td>"	
//					}
//					sEncabezado += "<td align=" + sC + "center" + sC + " class=" + sC + "fontBlack " + TipoRenglon + sC + " >"
//                    sEncabezado += "&nbsp;</td></tr>"
//	}
	sEncabezado +="<tr><td height=" + sC + "2" + sC + " colspan=" + sC + grdCampo.length + 2 + sC + " bgcolor=" + sC + "#CCCCCC" + sC + " ></td></tr></table>"

	var sFG = "<input type=" + sC + "hidden" + sC + " name=" + sC + CampoLlave + sC + " value=" + sC + Parametro(CampoLlave,-1)+ sC + ">"
		sFG += "<input type=" + sC + "hidden" + sC + " name=" + sC + "tmpPagina" + sC + " value=" + sC + iPagina + sC + ">"
        sFG += "<input type=" + sC + "hidden" + sC + " name=" + sC + "tmpRegPorPagina" + sC + " value=" + sC + iRegPorPagina + sC + ">"
        sFG += "<input type=" + sC + "hidden" + sC + " name=" + sC + "Sys_ID" + sC + " value=" + sC + Parametro("SistemaActual",1) + sC + ">"
		for(igr=0;igr<ocultoNombre.length;igr++){ 
			sFG += "<input type=" + sC + "hidden" + sC + " name=" + sC + ocultoNombre[igr] + sC + " value=" + sC + Parametro(ocultoParam[igr],-1) + sC + ">"
		
		}
				
	//sVariablesOcultas += sFG
	sEncabezado += sFG

	return sEncabezado
}        

//  -------------------------------------------------------

	LeerParametrosdeBD()

	var SistemaActual = Parametro("SistemaActual",0)
	var VentanaIndex  = Parametro("VentanaIndex",0)
	var IDUsuario     = Parametro("IDUsuario",0)
	var AccionDePaginacion = Parametro("AccionDePaginacion",0)
	
	//IniciaDebugBD()
	
	Response.Write( ArmaGrid() )

//Importante:
// cuando el campo tenga como prefijo una tabla ej clientes.Cli_ID  debera usarse un alias forzosamente

%>