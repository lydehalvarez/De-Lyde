<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../Includes/iqon.asp" -->
<%
var Tarea = Parametro("Tarea",0)

var iPaginaActual   = Parametro("PaginaActual",1)
var iTotalPaginas   = Parametro("TotalPaginas",0)
var iTotalRegistros = Parametro("TotalRegistros",0)
var iRegPorVentana  = Parametro("RegPorVentana",iRegPorVentana)
var iRegistroActual = Parametro("RegistroActual",0)

var SistemaActual   = Parametro("Sys_ID",0)
var VentanaIndex    = Parametro("Mnu_ID",0)
var iWgCfgID        = Parametro("WgCfg_ID",0)
var iWgID           = Parametro("Wgt_ID",0)
var iWgCfgCID       = Parametro("WgCfgC_ID",0)
var SQLC            = Parametro("SQLC","")
var ConBus          = Parametro("ConBus","")
var iqCli_ID        = Parametro("iqCli_ID",-1)

if (EsVacio(ConBus)) {
	ConBus = ""
}
if (EsVacio(SQLC)) {
	SQLC = ""
}

var iSysLogID       = Parametro("SysLog_ID",-1)
var iSysLogCatID    = Parametro("SysLogCat_ID",-1)

var iIQonDebug      = 0

	var grdCampo       = new Array(0)         //  estos son los campos que se mostraran en el grid
	var grdNombre      = new Array(0)        //   como es una vista o una consulta pueden ser de varias tablas sin problema
	var grdAlias       = new Array(0)       //    en caso de haber una inconsistencia del tipo campo duplicado entonces se debera usar un alias para los campos
	var grdTipo        = new Array(0)	   //     pero esto solo se pondra en la configuracion no aqui
	var grdAncho       = new Array(0)
	var grdAlineacion  = new Array(0)
	var grdClass       = new Array(0)
	var grdOrden       = new Array(0)
	var grdPrefijo     = new Array(0)
	var arrSoloCampos  = ""
	var arrSoloAlias   = ""
	
	var LLaveCampo     = new Array(0)         //  los campos de llave seran colocados como ocultos con el valor general         
	var LLavePP        = new Array(0)        //   la llave primaria sera colocada en cada renglon para distinguir la diferencia
	var LLavePK        = new Array(0)       //    y usarla en las funciones, al hacer submit los ocultos mas esta PK haran la indicacion exacta
	var LLaveValor     = new Array(0)      //     estos campos seran insertados en la seccion del where
	var LLaveFormato   = new Array(0)
	var LLaveCondicion = new Array(0)
	var LLavePrefijo   = new Array(0)
	
	var ordPrefijo     = new Array(0)
	var ordCampo       = new Array(0)	
	var ordOrden       = new Array(0)	
	
	var SQLTabla      = ""
	var SQLCondicion  = ""
	var SQLOrden      = ""
	var bCpoLL        = false
	var sqCampoLlave  = ""
	var sqOrdenEmergencia   = ""
	
	var iMWPuedeAgregar     = 0
	var iMWPuedeEditar      = 1
	var iMWPuedeBorrar      = 0
	var iMWPuedeSeleccionar = Session("NxSelecct")
	var iAbrirNuevaVentana  = 0
	var sqCampoLlavePrefijo = ""


	var arrLLaves  = ""  // estructura =  Campo,Alias,EsPermanente,UsarParaConsulta,EsPrimaria,Tipo
	var arrCampos  = ""  //               Nombre,Campo,Alias,Ancho,Alineacion,Clase,Orden,Tipo,Visible
	var arrOcultos = ""  //               Campo,EsPermanente
	var arrOrden   = ""  //               Campo/Alias,Orden

	var sC = String.fromCharCode(34)
	var sResultado = ""


	var sSQLConfBase = " select MW_Param, MW_PuedeAgregar, MW_PuedeBorrar, MW_PuedeEditar, MW_AlSeleccionarAbrirNuevaVentana "
		sSQLConfBase += " from Menu_Widget "
		sSQLConfBase += " WHERE Sys_ID = " + SistemaActual
		sSQLConfBase += " AND Mnu_ID = "   + VentanaIndex
		sSQLConfBase += " AND Wgt_ID = "   + iWgID
		sSQLConfBase += " AND WgCfg_ID = " + iWgCfgID
	
	var rsConfBase = AbreTabla(sSQLConfBase,1,2)
	if (!rsConfBase.EOF){
			iAbrirNuevaVentana = rsConfBase.Fields.Item("MW_AlSeleccionarAbrirNuevaVentana").Value
			iMWPuedeAgregar    = rsConfBase.Fields.Item("MW_PuedeAgregar").Value
			iMWPuedeEditar     = rsConfBase.Fields.Item("MW_PuedeEditar").Value
			iMWPuedeBorrar     = rsConfBase.Fields.Item("MW_PuedeBorrar").Value
	}
	rsConfBase.Close()

	var sSQLTTLlaves = " iqCli_ID = " + iqCli_ID
		sSQLTTLlaves += " AND Sys_ID = " + SistemaActual
		sSQLTTLlaves += " AND WgCfg_ID = " + iWgCfgID
		sSQLTTLlaves += " AND Mnu_ID = " + VentanaIndex
		sSQLTTLlaves += " AND SysLog_ID = -1 "
		sSQLTTLlaves += " AND SysLogCat_ID = -1 "
		sSQLTTLlaves += " AND Wgt_ID = " + iWgID
		sSQLTTLlaves += " AND WgCfgC_ID = 0 " // iWgCfgCID
	//sSQLTTLlaves = "iqCli_ID = 1 AND Sys_ID = 1001 AND WgCfg_ID = 85 AND Mnu_ID = 3010 AND SysLog_ID = -1 AND SysLogCat_ID = -1 AND Wgt_ID = 25 AND WgCfgC_ID = 0"
    //Plugins/Grid_IQon/GRIQon_Ajax.asp?Tarea=1&TotalPaginas=2052&TotalRegistros=36931&iqCli_ID=1&Sys_ID=1001&WgCfg_ID=85&Mnu_ID=3010&SysLog_ID=-1&SysLogCat_ID=-1&Wgt_ID=25&WgCfgC_ID=0
	var sATTb = "SELECT * "
		sATTb += " FROM MenuGridTablas "
		sATTb += " WHERE  Sys_ID = " + SistemaActual
		sATTb += " AND WgCfg_ID = " + iWgCfgID

	var rsEncTB = AbreTabla(sATTb,1,2)
	if (!rsEncTB.EOF){
			SQLTabla     = FiltraVacios(rsEncTB.Fields.Item("MGrdT_SQLTabla").Value)
			SQLCondicion = FiltraVacios(rsEncTB.Fields.Item("MGrdT_SQLCondicion").Value)
			SQLOrden     = FiltraVacios(rsEncTB.Fields.Item("MGrdT_SQLOrden").Value)
	}
	rsEncTB.Close()
	
	var sSQLTT = " Select * from Widget_Configuracion_Complemento "	
		sSQLTT += " Where " + sSQLTTLlaves

	var rsSQLTT = AbreTabla(sSQLTT,1,2)
	if (!rsSQLTT.EOF){
		arrLLaves  = String(rsSQLTT.Fields.Item("WgCfgC_Atributo1").Value)
		arrCampos  = String(rsSQLTT.Fields.Item("WgCfgC_Atributo2").Value)
		arrOcultos = String(rsSQLTT.Fields.Item("WgCfgC_Atributo5").Value)
		arrOrden   = String(rsSQLTT.Fields.Item("WgCfgC_Atributo4").Value)
	} 
	rsSQLTT.Close()
	
	
//Armado de arreglos de llaves
	var arrLLSec  = new Array(0)
	var arrLL     = new Array(0)
	if (!EsVacio(arrLLaves) ) {
		arrLLSec = arrLLaves.split("|")
		for (j=0;j<arrLLSec.length;j++) {
			var Txt = String(arrLLSec[j])
			var arrLL = Txt.split("{")
			//   0      1     2        3             4               5       6      7
			//Prefijo,Campo,Alias,EsPermanente,UsarParaConsulta,EsPrimaria,Tipo,EsOculta
			LLavePrefijo[j]   = arrLL[0]
			LLaveCampo[j]     = arrLL[1]
			LLavePP[j]        = arrLL[3]
			LLaveCondicion[j] = arrLL[4]
			LLavePK[j]        = arrLL[5]    // solo debera ser un campo llave primaria y solo se usara el primero
			LLaveFormato[j]   = arrLL[6]
			if (!bCpoLL) {
				if (LLavePK[j] == 1 ) {                                         
					bCpoLL = true 
					if ( !EsVacio(arrLL[2]) ) {   // valido que venga un alias
						sqCampoLlave = arrLL[2]
						arrSoloAlias += arrLL[2]
						sqCampoLlavePrefijo = ""
						if ( !EsVacio(LLavePrefijo[j]) ) { 
							sqCampoLlavePrefijo = LLavePrefijo[j] + "."
						}
						sqCampoLlavePrefijo += LLaveCampo[j]
						sqOrdenEmergencia = sqCampoLlavePrefijo
						sqCampoLlavePrefijo += " as " + sqCampoLlave
						arrSoloCampos += sqCampoLlavePrefijo
						 
					} else {
						sqCampoLlave        = ""
						sqCampoLlavePrefijo = ""
						if ( !EsVacio(LLavePrefijo[j]) ) { 
							sqCampoLlave        = LLavePrefijo[j] + "."
							sqCampoLlavePrefijo = LLavePrefijo[j] + "."
						}                                                     
						sqCampoLlave += LLaveCampo[j]
						sqCampoLlavePrefijo += LLaveCampo[j]
						sqOrdenEmergencia = sqCampoLlavePrefijo
						arrSoloAlias += sqCampoLlave
						arrSoloCampos += sqCampoLlave
					}
				}
			}
		}
	}	



	if (SQLC != "") {
		var arrCampo      = new Array(0)          
		var arrPrmCPP     = new Array(0)          
		var bEnc = false
		var iCmpLL = LLaveCampo.length - 1
		//se extraen los parametros que se envian
		arrPrmCPP = SQLC.split("|")
		for (j=0;j<arrPrmCPP.length;j++) {
			bEnc = false
			var Txt = String(arrPrmCPP[j])
			var arrCampo = Txt.split(":")
			//se buscan y aplican a el arreglo de llaves
			for (hi=0;hi<LLaveCampo.length;hi++) {	
				if (LLaveCampo[hi] == arrCampo[0]) {
					bEnc = true
					LLaveCondicion[hi] = 1
					LLaveValor[hi] = arrCampo[1]
				}
			}
			if (!bEnc) {
				iCmpLL++		
				LLavePrefijo[iCmpLL]   = ""
				LLaveCampo[iCmpLL]     = arrCampo[0]
				LLaveCondicion[iCmpLL] = 1
				LLavePP[iCmpLL]        = "No"               //falta buscar si es permanente lo que esta entrando
				LLavePK[iCmpLL]        = 0                 
				LLaveValor[iCmpLL]     = arrCampo[1]       
				LLaveFormato[iCmpLL]   = "N"	
			}
		}


		//Response.Write("<br> entro = " + SQLC)
		//SQLC = SQLC.replace(/|/g, " AND ")
		//Response.Write("<br> ahora = " + SQLC)
		//SQLC = SQLC.replace(/:/g, " = ")
		//Response.Write("<br> ahora = " + SQLC)
		//SQLCondicion = SQLCondicion.split(" ").join("")
		//SQLCondicion = SQLCondicion.replace(/\s/g,"");
		
		//SQLC = SQLC.split(":").join(" = ")
		//SQLC = SQLC.split("|").join(" AND ")
		
		var SQLCondicionSQLC = ""
		for (hi=0;hi<LLaveCampo.length;hi++) {	
			if ( LLaveCondicion[hi] == 1 && !EsVacio(LLaveValor[hi]) ) {
				if (SQLCondicionSQLC != "") { SQLCondicionSQLC += " AND " }
				if ( !EsVacio(LLavePrefijo[hi]) ) { 
					SQLCondicionSQLC += LLavePrefijo[hi] + "."
				}                                               
				SQLCondicionSQLC += LLaveCampo[hi] + " = " + LLaveValor[hi]
			}
		}

		if (SQLCondicion != "") {SQLCondicion += " AND " } 
		SQLCondicion += SQLCondicionSQLC		
	}

	

	if (ConBus != "") {


//6 fecha tipo texto
		ConBus = ConBus.replace(/:td6/gi, ":'")
		ConBus = ConBus.replace(/td6:/gi, "' ")

//16 fecha tipo juliano
		ConBus = ConBus.replace(/:td16/gi, ":dbo.Gregoriano_A_Juliano('")
		ConBus = ConBus.replace(/td16:/gi, "') ")

//17 fecha tipo date
		ConBus = ConBus.replace(/:td17/gi, ">= CONVERT(DATE, '")
		ConBus = ConBus.replace(/tdm17/gi, "', 105) AND ")
		ConBus = ConBus.replace(/tdmd17/gi, " < DATEADD(day,1,CONVERT(DATE, '")
		ConBus = ConBus.replace(/td17:/gi, "', 105))) ")	
		
//18 fecha tipo date
		ConBus = ConBus.replace(/:td18/gi, ">= CONVERT(DATE, '")
		ConBus = ConBus.replace(/tdm18/gi, "', 105) AND ")
		ConBus = ConBus.replace(/tdmd18/gi, " < DATEADD(day,1,CONVERT(DATE, '")
		ConBus = ConBus.replace(/td18:/gi, "', 105))) ")	

	    ConBus = ConBus.replace(/¬%/gi, " LIKE '%")
		//ConBus = ConBus.split("¬%").join(" LIKE '%")

		ConBus = ConBus.replace(/%¬/gi, "%'")
		//ConBus = ConBus.split("%¬").join("%'")

		ConBus = ConBus.replace(/¬/gi, "'")
		//ConBus = ConBus.split("¬").join("'")

		ConBus = ConBus.replace(/:/gi, " = ")
		//ConBus = ConBus.split(":").join(" = ")

		ConBus = ConBus.split("|").join(" AND ")
		
		if (SQLCondicion != "") {SQLCondicion += " AND " } 
		SQLCondicion += ConBus		
	}
		
//Armado de arreglos de campos
	var iMaxOrden = 0
	var arrCmpSec  = new Array(0)
	var arrCmp     = new Array(0)
	if (!EsVacio(arrCampos) ) {
		arrCmpSec = arrCampos.split("|")
		for (j=0;j<arrCmpSec.length;j++) {
			var Txt = String(arrCmpSec[j])
			var arrCmp = Txt.split("{")
			//0=Nombre,1=Prefijo,2=Campo,3=Alias,4=Ancho,5=Alineacion,6=Clase,7=Orden,8=Tipo,9=Visible
			if ( arrCmp[9] == 1 ) {
				grdNombre[j]     = arrCmp[0]
				grdPrefijo[j]    = arrCmp[1]
				grdCampo[j]      = arrCmp[2]
				grdAlias[j]      = arrCmp[3]
				grdAncho[j]      = arrCmp[4]
				grdAlineacion[j] = arrCmp[5]
				grdClass[j]      = arrCmp[6]
				grdOrden[j]      = arrCmp[7]
				grdTipo[j]       = arrCmp[8]

				if (grdOrden[j] > iMaxOrden) {
					iMaxOrden = grdOrden[j]
				}
				
				if (arrSoloCampos != "" ) { 
					arrSoloCampos += ", " 
					arrSoloAlias += ", " 
				}
				arrSoloCampos += arrCmp[2]
				if (grdAlias[j] != "") {
					arrSoloCampos += " as " + grdAlias[j]
					arrSoloAlias += grdAlias[j]
				} else {
					arrSoloAlias += arrCmp[2]
				}
				
			}
		}
	}
	 
//  esto es para acomodar en el orden indicado los campos del grid		 
//	var sOrdenImprime = ""
//	if (iMaxOrden > 0 ) {
//		for (ji=1;ji<=iMaxOrden;ji++) {
//			for (jo=0;jo<grdCampo.length;jo++) {
//				if (grdOrden[jo] == ji) {
//					if (sOrdenImprime != "") {sOrdenImprime += ", " }
//					if (grdAlias[jo] == "") {
//						sOrdenImprime += grdCampo[jo]
//					} else {
//						sOrdenImprime += grdAlias[jo]
//					}
//				}
//			}
//		}
//	}
	
	

//Response.Write("<br>Orden = " + arrOrden)
//Armado de arreglos para ordenar
	var iMaxOrden  = 0
	var arrOrdSec  = new Array(0)
	var arrOrd     = new Array(0)
	if (!EsVacio(arrOrden) ) {
		arrOrdSec = arrOrden.split("|")
		//0=Prefijo,1=Campo,2=Orden
		for (j=0;j<arrOrdSec.length;j++) {
			var Txt = String(arrOrdSec[j])
			var arrOrd = Txt.split("{")
			ordPrefijo[j] = arrOrd[0] 
			ordCampo[j]   = arrOrd[1]     
			ordOrden[j]   = arrOrd[2]
			if (ordOrden[j] > iMaxOrden) {
				iMaxOrden = ordOrden[j]
			}
		}
	}
	
//   esto es para acomodar en el orden indicado los campos de Order by	 
	var sOrdenPorCampos = ""
	if (iMaxOrden > 0 ) {
		for (ji=1;ji<=iMaxOrden;ji++) {
			for (jo=0;jo<ordCampo.length;jo++) {
				if (ordOrden[jo] == ji) {
					if (sOrdenPorCampos != "") {sOrdenPorCampos += ", " }
						if (ordPrefijo[jo] != "") {sOrdenPorCampos += ordPrefijo[jo] + "." }
						sOrdenPorCampos += ordCampo[jo]
				}
			}
		}
	}
	
	if (sOrdenPorCampos != "" ) {
		SQLOrden = sOrdenPorCampos
	}
	if (SQLOrden == "" ) {
		SQLOrden = sqOrdenEmergencia
	}
	
	
	
if (iIQonDebug > 0) {
	Response.Write("<br>iMaxOrden = " + iMaxOrden)
	Response.Write("<br>arrOrden = " + arrOrden)
	Response.Write("<br>SQLOrden = " + SQLOrden)
	Response.Write("<br>sOrdenPorCampos = "  + sOrdenPorCampos)
	Response.Write("<br>SQLCondicion = "  + SQLCondicion)
	Response.Write("<br>iIQonDebug = "  + iIQonDebug)

	var fch = new Date()
	sResultado = "<br>Entrando en modo debug<br>"
	sResultado += "<br>Fecha/hora: " +  fch
	sResultado += "<br>iPaginaActual: " + iPaginaActual 
	sResultado += "<br>iTotalPaginas: " + iTotalPaginas 	
	sResultado += "<br>iTotalRegistros: " + iTotalRegistros 
	sResultado += "<br>iRegPorVentana: " + iRegPorVentana 	
	sResultado += "<br>Tarea: " + Tarea 	
	sResultado += "<br>iWgCfgID: " + iWgCfgID 	
	sResultado += "<br>iWgID: " + iWgID 
	sResultado += "<br>sSQLTTLlaves: " + sSQLTTLlaves 
	Response.Write(sResultado)
	sResultado = "<br>probando salida de resultado<br>"
} 
	switch (parseInt(Tarea)) {
		case 1:
		
			iTotalRegistros = 0
			var sTmp1 = SQLCondicion.toUpperCase()
			if (sTmp1.indexOf("GROUP BY") == -1 ) {
				iTotalRegistros = BuscaSoloUnDato("Count(*)",SQLTabla,SQLCondicion,0,0)
			} else {
				var sSQLCnt  = " SELECT Count(*) FROM " + SQLTabla
					sSQLCnt += " WHERE " + SQLCondicion
				var rsCnt = AbreTabla(sSQLCnt,1,0)
				while (!rsCnt.EOF){
					iTotalRegistros++
					//iTotalRegistros += rsCnt.Fields.Item(0).Value
					rsCnt.MoveNext()
				}
				rsCnt.Close()
			}
			
			iTotalPaginas = parseInt(iTotalRegistros / iRegPorVentana)
			sResultado ="<br>iTotalPaginas= " + iTotalPaginas
			if((iTotalRegistros % iRegPorVentana) > 0) { iTotalPaginas++ }
			sResultado = ""  + ArmaPaginacion(iTotalPaginas,iTotalRegistros)  
			sResultado += "<div id=" + sC + "DatosGrid" + sC + "></div>"
			Response.Write(sResultado)
			break;
		case 2:	
			sResultado = ArmaEncabezados()
			sResultado += CargaDatos(iPaginaActual,iRegPorVentana)
			Response.Write(sResultado)			
			break;
	}
	

	
function ArmaPaginacion(iPaginas,iRegistros) {
	var sPaginacion = ""

	sPaginacion += "<table width=" + sC + "100%" + sC + " border=" + sC + "0" + sC + " cellpadding=" + sC + "0" + sC + " cellspacing=" + sC + "0" + sC + ">"
	if (iMWPuedeAgregar >= 1 && Session("Agregar") == 1) {
		sPaginacion += "<tr><td height=" + sC + "24" + sC + " colspan=" + sC + "11" + sC + " align=" + sC + "right" + sC + ">"
		sPaginacion += "<input type=\"button\" name=\"grbtnNuevo\" id=\"grbtnNuevo\" value=\"Nuevo\" onclick=\"javascript:grAccNuevo(-1," + iMWPuedeAgregar + ");\" />"
		sPaginacion += "</td></tr>"
	}
	sPaginacion += "<tr><td height=" + sC + "5" + sC + " colspan=" + sC + "11" + sC + "></td></tr>"
	sPaginacion += "<tr><td height=" + sC + "1" + sC + " colspan=" + sC + "11" + sC + " bgcolor=" + sC + "#000033" + sC + "></td></tr>"
	sPaginacion += "<tr >"
	sPaginacion += "<td width=" + sC + "5%" + sC + " align=" + sC + "left" + sC + " background=" + sC + "/Plugins/Grid_IQon/img/Fondo.jpg" + sC + "><img src=" + sC + "/Plugins/Grid_IQon/img/Boton.jpg" + sC + " width=" + sC + "24" + sC + " height=" + sC + "25" + sC + " /></td>"
	sPaginacion += "<td width=" + sC + "71%" + sC + " height=" + sC + "22" + sC + " align=" + sC + "right" + sC + " background=" + sC + "/Plugins/Grid_IQon/img/Fondo.jpg" + sC + " class=" + sC + "fontBlack" + sC + "> Registros por p&aacute;gina "
	sPaginacion += "<select name=" + sC + "RegPorVentana" + sC + " id=" + sC + "RegPorVentana" + sC
	sPaginacion += " onchange=" + sC + "AcPaginacion(this.value)" + sC + " class=" + sC + "fontBlack" + sC + ">"
	sPaginacion += "<option value=" + sC + "10" + sC 
	if ( iRegPorVentana <= 10) { sPaginacion += "selected " } 
	sPaginacion += ">10</option><option value=" + sC + "12" + sC 
	if ( iRegPorVentana == 12) { sPaginacion += "selected " } 
	sPaginacion += ">12</option><option value=" + sC + "15" + sC
	if ( iRegPorVentana == 15) { sPaginacion += "selected " } 
	sPaginacion += ">15</option><option value=" + sC + "20" + sC
	if ( iRegPorVentana == 20) { sPaginacion += "selected " } 
	sPaginacion += ">20</option><option value=" + sC + "30" + sC
	if ( iRegPorVentana == 30) { sPaginacion += "selected " } 
	sPaginacion += ">30</option><option value=" + sC + "50" + sC
	if ( iRegPorVentana == 50) { sPaginacion += "selected " } 
	sPaginacion += ">50</option><option value=" + sC + "100" + sC
	if ( iRegPorVentana == 100) { sPaginacion += "selected " } 
	sPaginacion += ">100</option><option value=" + sC + "10000" + sC
	if ( iRegPorVentana > 100) { sPaginacion += "selected " } 
	sPaginacion += ">todos        </option></select>"

	//Parametros necesarios de la página
//	var ParLetra = ""
//		ParLetra += "Letra="+Parametro("Letra","Todas")+ "&" 		
// 	var iCont = 1
	
//	ParLetra += "TR="+iRegistros+ "&"    
	sPaginacion += "<input type=" + sC + "hidden" + sC + " name=" + sC + "TotalRegistros" + sC + " id=" + sC + "TotalRegistros" + sC + " value=" + sC + iRegistros + sC + ">"
//	sPaginacion += "<input type=" + sC + "hidden" + sC + " name=" + sC + "PaginaActual" + sC + " value=" + sC + 1 + sC + ">"
	sPaginacion += "<input type=" + sC + "hidden" + sC + " name=" + sC + "TotalPaginas" + sC + " id=" + sC + "TotalPaginas" + sC + " value=" + sC + iPaginas + sC + ">"
//	sPaginacion += "<input type=" + sC + "hidden" + sC + " name=" + sC + "AccionDePaginacion" + sC + " value=" + sC + 1 + sC + ">"

	sPaginacion += "<body class=" + sC + "fontBlack" + sC + "> Total:" + iRegistros
	sPaginacion += "<body class=" + sC + "fontBlack" + sC + "> &nbsp;Registros&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;"
	sPaginacion += "P&aacute;gina actual&nbsp;&nbsp;"
	sPaginacion += "<select name=" + sC + "IrAPagina" + sC + " id=" + sC + "IrAPagina" + sC  
	sPaginacion += " onchange=" + sC + "AcIrAPagina(this.value)" + sC + "  class=" + sC + "fontBlack" + sC + " >"     
	
	for (i = 1; i <= iPaginas; i++) {
		if (1 == i) {
			sPaginacion += "<option value=" + sC + i + sC + " selected >" + i + "</option>"
		} else {
			sPaginacion += "<option value=" + sC + i + sC + " >" + i + "</option>"
		}
	}
	sPaginacion += "</select>"
	sPaginacion += "&nbsp; de &nbsp;" + iPaginas + "&nbsp; P&aacute;ginas&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>"

	if (iPaginas > 1) {
		sPaginacion += "<td width=" + sC + "3%" + sC + " align=" + sC + "left" + sC + " background=" + sC + "/Plugins/Grid_IQon/img/Fondo.jpg" + sC + ">"
		sPaginacion += "<a href=" + sC + "javascript:CambiaAPagina(1)" + sC + "><img id=" + sC + "btnPrimero" + sC 
		sPaginacion += " src=" + sC + "/Plugins/Grid_IQon/img/BtnPrimero.gif" + sC
		sPaginacion += " rel=" + sC + "/Plugins/Grid_IQon/img/BtnPrimero_off.gif" + sC 
		sPaginacion += " border=" + sC + "0" + sC + "></a></td>"
		sPaginacion += "<td width=" + sC + "3%" + sC + " align=" + sC + "left" + sC + " background=" + sC + "/Plugins/Grid_IQon/img/Fondo.jpg" + sC + ">"
		sPaginacion += "<a href=" + sC + "javascript:CambiaAPagina(2)" + sC + "><img id=" + sC + "btnAnterior" + sC 
		sPaginacion += " src=" + sC + "/Plugins/Grid_IQon/img/BtnAnterior.gif" + sC
		sPaginacion += " rel=" + sC + "/Plugins/Grid_IQon/img/BtnAnterior_off.gif" + sC 
		sPaginacion += " border=" + sC + "0" + sC + "></a></td>"
		sPaginacion += "<td width=" + sC + "3%" + sC + " align=" + sC + "right" + sC + " background=" + sC + "/Plugins/Grid_IQon/img/Fondo.jpg" + sC + ">"
		sPaginacion += "<a href=" + sC + "javascript:CambiaAPagina(3)" + sC + " ><img id=" + sC + "btnSiguiente" + sC 
		sPaginacion += " src=" + sC + "/Plugins/Grid_IQon/img/BtnSiguiente.gif" + sC 
		sPaginacion += " rel=" + sC + "/Plugins/Grid_IQon/img/BtnSiguiente_off.gif" + sC
		sPaginacion += " border=" + sC + "0" + sC + "></a></td>"
		sPaginacion += "<td width=" + sC + "3%" + sC + " align=" + sC + "right" + sC + " background=" + sC + "/Plugins/Grid_IQon/img/Fondo.jpg" + sC + ">"
		sPaginacion += "<a href=" + sC + "javascript:CambiaAPagina(4)" + sC + " ><img id=" + sC + "btnUltimo" + sC 
		sPaginacion += " src=" + sC + "/Plugins/Grid_IQon/img/BtnUltimo.gif" + sC 
		sPaginacion += " rel=" + sC + "/Plugins/Grid_IQon/img/BtnUltimo_off.gif" + sC
		sPaginacion += " border=" + sC + "0" + sC + " ></a></td>"
	}

	sPaginacion += "<td width=" + sC + "3%" + sC + " align=" + sC + "right" + sC + " background=" + sC + "/Plugins/Grid_IQon/img/Fondo.jpg" + sC + ">&nbsp;&nbsp;&nbsp;</td></tr>"
	sPaginacion += "<tr><td height=" + sC + "1" + sC + " colspan=" + sC + "11" + sC + " bgcolor=" + sC + "#000033" + sC + " ></td></tr>"
	sPaginacion += "<tr><td height=" + sC + "2" + sC + " colspan=" + sC + "11" + sC + "></td></tr></table>"

	return sPaginacion
}


function ArmaEncabezados() {

	var sWH9          = " width=" + sC + "9" + sC + " height=" + sC + "9" + sC +" "
	var sAL           = " align=" + sC + "left" + sC + " "
	var sAC           = " align=" + sC + "center" + sC + " "
	var sPadding      = " style=" + sC + "padding-right: 5px;padding-left: 5px;" + sC + " "
	
	var sEncabezado  = "<ta" + "ble width=" + sC + "100%" + sC + " border=" + sC + "0" + sC + " cellspacing=" + sC 
		sEncabezado += "0" + sC + " cellpadding=" + sC + "0" + sC  + " " 
		sEncabezado += " class=" + sC + "TablaGeneral" + sC + "><tr class=" + sC + "TablaEncabezado" + sC + ">"
		sEncabezado += "<tr class=" + sC + "TablaEncabezado" + sC + "><td width=" + sC + "20" + sC + " class=" + sC + "TablaEncabezado" + sC + " >No.</td>"

	//var sConsultaGral = ""
	for(ig=0;ig<grdCampo.length;ig++){ 
			sEncabezado +="<td width=" + sC + grdAncho[ig] + sC + " "
			sEncabezado +="align=" + sC + grdAlineacion[ig] + sC + " "
			sEncabezado +="class=" + sC + grdClass[ig] + sC + ">"
			sEncabezado += grdNombre[ig] +"</td>"
			//if (sConsultaGral != "" ) { sConsultaGral += ", " }
			//sConsultaGral += grdCampo[ig]
			//if (!EsVacio(grdAlias[ig])) { sConsultaGral += " as " + grdAlias[ig] }
	}
	if ( iMWPuedeBorrar >= 1 || iMWPuedeEditar >= 1 || iMWPuedeSeleccionar >= 1 ) {
		sEncabezado +="<td width=" + sC + "80" + sC + " align=" + sC + "center" + sC + " class=" + sC + "TablaEncabezado" + sC + ">&nbsp;</td>"
	}
	sEncabezado +="</tr>"
	
	return sEncabezado

}


function CargaDatos(Pagina,TamanioPagina) {
var sDatos = ""
var iUltimoNoRenglon = 0
var iPagina = Pagina -1
var iRegistros = 0

var sConsultaGral = "SELECT  RowNumber, " + arrSoloAlias
	sConsultaGral += " FROM ( "
	sConsultaGral += " SELECT " + arrSoloCampos + ",ROW_NUMBER() OVER (ORDER BY " + SQLOrden + ") AS RowNumber "
	sConsultaGral += " FROM " + SQLTabla
	if (SQLCondicion != "") {
		sConsultaGral += " Where " + SQLCondicion
	}
	sConsultaGral += " ) AS Tabla " 
	sConsultaGral += " WHERE RowNumber BETWEEN " + TamanioPagina + " * " + iPagina + " + 1 "
	sConsultaGral += " AND " + TamanioPagina + " * (" + iPagina + " + 1) "

	if (iIQonDebug > 0) { Response.Write(" <br> " + sConsultaGral) }

  try {
	var TipoRenglon = "evenRow"
	var rsINS = AbreTabla(sConsultaGral,1,0)
		while (!rsINS.EOF){
			if (TipoRenglon == "evenRow") {
				TipoRenglon = "oddRow"
			} else {
				TipoRenglon = "evenRow"
			}
			var sNombre = "" 
			iRegistros =  rsINS.Fields.Item("RowNumber").Value
			//Colocando el encabezado y las llamadas a el rollback del grid cambiar a jquery porfa
			sDatos +="<tr "
			sDatos +=" class=" + sC + TipoRenglon + sC 
			sDatos +="onmouseover=" + sC + "styleSwap(this, 'hover', 'normal', 'rowHiliten');" + sC + " "
			sDatos +="onmouseout=" + sC + "styleSwap(this, 'normal', 'hover', 'rowHiliten');" + sC + " "
			sDatos +="title=" + sC + sNombre + sC 
			sDatos +="  >" 
			sDatos +="<td height=" + sC + "24" + sC + " align=" + sC + "center" + sC + " class=" + sC + "fontBlack " + TipoRenglon + sC + ">"
			//sDatos +="<td height=" + sC + "24" + sC + " align=" + sC + "center" + sC + ">"
			sDatos +="<strong>" + iRegistros + "</strong></td>"
			iUltimoNoRenglon++
			var sNombreCampo = ""

			for(ig=0;ig<grdCampo.length;ig++){ 
					
					if (EsVacio(grdAlias[ig])) { 
						sNombreCampo = grdCampo[ig]
					} else {
						sNombreCampo = grdAlias[ig]
					}
					
				//sDatos += "<td align=" + sC + grdAlineacion[ig] + sC + " >"
				sDatos += "<td align=" + sC + grdAlineacion[ig] + sC + " class=" + sC + "fontBlack " + TipoRenglon + sC + " >"
				switch (parseInt(grdTipo[ig])) {
					case 1:		
						sDatos += "" + rsINS.Fields.Item( sNombreCampo ).Value
						break;
					case 2:		
						sDatos += "" + rsINS.Fields.Item( sNombreCampo ).Value
						break;
					case 3:		
						if (rsINS.Fields.Item( sNombreCampo ).Value == 1) {
							sDatos += "Si"
						} else {
							sDatos += "No"
						}
						break;
					case 4:		
						sDatos += PonerFormatoNumerico(FiltraVacios(rsINS.Fields.Item( sNombreCampo ).Value),"$ ")
						break;	
					case 5:		
						var fDato = parseFloat(FiltraVacios(rsINS.Fields.Item( sNombreCampo ).Value))
							fDato = fDato * 100
						sDatos += PonerFormatoNumerico(fDato,"") + " %"			
						break;					
					case 6:
						sDatos += "&nbsp;" + FormatoFecha(rsINS.Fields.Item( sNombreCampo ).Value ,"UTC a dd/mm/yyyy")
						break;
						
					default:
						sDatos += "" + rsINS.Fields.Item( sNombreCampo ).Value
						
				}   
				sDatos += "&nbsp;</td>"	 
			}

			sDatos += "<td align=" + sC + "center" + sC + " class=" + sC + "fontBlack " + TipoRenglon + sC + " >"
//				//sDatos += "<td align=" + sC + "center" + sC + " >"
//			if (iMWPuedeBorrar >= 1 || iMWPuedeEditar >= 1) {
				//var sValorCLL = rsINS.Fields.Item(sqCampoLlave).Value
				var sValorCLL = rsINS.Fields.Item(1).Value
	
				if (iMWPuedeBorrar >= 1 && Session("Borrar") == 1) {
					sDatos += "&nbsp;&nbsp;<a href=" + sC + "javascript:grAccBorrar(" + sValorCLL + "," + iRegistros + ")" + sC + ">Borrar</a>&nbsp;&nbsp;"
				} 
				if (iMWPuedeEditar >= 1 && Session("Editar") == 1) {
					if (iAbrirNuevaVentana == 0) {
						sDatos += "&nbsp;&nbsp;<a href=" + sC + "javascript:grAccEditar(" + sValorCLL + "," + iMWPuedeEditar + ");" + sC + ">Editar</a>&nbsp;&nbsp;"
					}				
				}
				iMWPuedeSeleccionar=1
				if (iMWPuedeSeleccionar >= 1 ) {
					//if (iAbrirNuevaVentana == 0) {
						sDatos += "&nbsp;&nbsp;<a href=" + sC + "javascript:grSelecciona(" + sValorCLL + ");" + sC + ">Seleccionar</a>&nbsp;&nbsp;"
					//} else {
					//	sDatos += "&nbsp;&nbsp;<a href=" + sC + "javascript:grAbreModal(" + sValorCLL + ");" + sC + ">Seleccionar</a>&nbsp;&nbsp;"
					//}
				}				
				
				
//			}
			sDatos += "</td>"
			sDatos += "</tr>"
			rsINS.MoveNext()
		}
		rsINS.Close()  

	
//	for(ig=iRengPintados;ig<RegPorVentana;ig++){ 
//		iUltimoNoRenglon++
//		if (TipoRenglon == "evenRow") {
//			TipoRenglon = "oddRow" 
//		} else {
//			TipoRenglon = "evenRow"
//		}
//				    sDatos +="<tr "
//					sDatos +="onmouseover=" + sC + "styleSwap(this, 'hover', 'normal', 'rowHiliten');" + sC + " "
//					sDatos +="onmouseout=" + sC + "styleSwap(this, 'normal', 'hover', 'rowHiliten');" + sC + " "
//					sDatos +="title=" + sC + sNombre + sC 
//					sDatos +="  >"
//					sDatos +="<td height=" + sC + "24" + sC + " align=" + sC + "center" + sC + " class=" + sC + "fontBlack " + TipoRenglon + sC + ">"
//					sDatos +="<strong>" + iUltimoNoRenglon + "</strong></td>"
//					for(igr=0;igr<grdCampo.length;igr++){ 
//						sDatos += "<td align=" + sC + grdAlineacion[ig] + sC + " class=" + sC + "fontBlack " + TipoRenglon + sC + " >&nbsp;</td>"	
//					}
//					sDatos += "<td align=" + sC + "center" + sC + " class=" + sC + "fontBlack " + TipoRenglon + sC + " >"
//                  sDatos += "&nbsp;</td></tr>"
//	}
	sDatos +="<tr><td height=" + sC + "2" + sC + " colspan=" + sC + grdCampo.length + 2 + sC + " bgcolor=" + sC + "#CCCCCC" + sC + " ></td></tr></table>"
	
  } catch(err) {
		sDatos = "<br>Ocurrio el error  " + err.number + " Descripcion = " + err.description + "  Mensaje = " + err.message
		sDatos += "<br><br>por favor revise su configuracion"
		sDatos += "<br><br>" + sConsultaGral
		sDatos += "<br>SQLOrden = " + SQLOrden
		sDatos += "<br>iMaxOrden = " + iMaxOrden
		sDatos += "<br>arrOrden = " + arrOrden
		sDatos += "<br>sOrdenPorCampos = "  + sOrdenPorCampos
		sDatos += "<br>"
		sDatos += "<br>iMaxOrden = " + iMaxOrden
		sDatos += "<br>arrOrden = " + arrOrden
		sDatos += "<br>SQLOrden = " + SQLOrden
		sDatos += "<br>sOrdenPorCampos = "  + sOrdenPorCampos
		sDatos += "<br>SQLCondicion = "  + SQLCondicion
		sDatos += "<br>iIQonDebug = "  + iIQonDebug
		
		var fch = new Date()
		sDatos += "<br>Fecha/hora: " +  fch
		sDatos += "<br>iPaginaActual: " + iPaginaActual 
		sDatos += "<br>iTotalPaginas: " + iTotalPaginas 	
		sDatos += "<br>iTotalRegistros: " + iTotalRegistros 
		sDatos += "<br>iRegPorVentana: " + iRegPorVentana 	
		sDatos += "<br>Tarea: " + Tarea 	
		sDatos += "<br>iWgCfgID: " + iWgCfgID 	
		sDatos += "<br>iWgID: " + iWgID 
		sDatos += "<br>connectionstring : " + arsODBC[0] 
		sDatos += "<br>sSQLTTLlaves: " + sSQLTTLlaves 

  }
	
	return sDatos
	
}

%>
