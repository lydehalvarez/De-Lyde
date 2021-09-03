<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../Includes/iqon.asp" -->
<%

//Debug_ImprimeParametros("Parametros que entraron a l grid pg 2")
var Tarea = Parametro("Tarea",0)
var bMostrarRenglonesComplemento = false
    VentanaIndex   = Parametro("Mnu_ID",-1)
var iPaginaActual   = Parametro("PaginaActual",1)
var iTotalPaginas   = Parametro("TotalPaginas",0)
var iTotalRegistros = Parametro("TotalRegistros",0)
var iRegPorVentana  = Parametro("RegPorVentana",iRegPorVentana)
var iRegistroActual = Parametro("RegistroActual",0)
var iRengPintados = 0
var iUltimoRengPintados = 0
    SistemaActual   = Parametro("Sys_ID",0)
    VentanaIndex    = Parametro("Mnu_ID",0)
var iWgCfg_ID       = Parametro("WgCfg_ID",0)
var iWgID           = Parametro("Wgt_ID",42)
//var iWgCfgCID       = Parametro("WgCfgC_ID",0)
var SQLC            = Parametro("SQLC","")
var ConBus          = Parametro("ConBus","")
var iqCli_ID        = Parametro("iqCli_ID",-1)
var SysLog_ID        = Parametro("SysLog_ID",-1)
var IDUsuario        = SysLog_ID
var UsuarioTpo        = Parametro("UsuarioTpo",-1)
var sConsultaFiltros = ""
var sConsultaFiltrosEnlace = ""

ConBus = ConBus.split("Â").join("")
if (EsVacio(ConBus) || ConBus.indexOf(":") == -1 ) {
	ConBus = ""
}
SQLC = SQLC.split("Â").join("")
if (EsVacio(SQLC) || SQLC.indexOf(":") == -1 ) {
	SQLC = ""
}

var iSysLogID       = Parametro("SysLog_ID",-1)
var iSysLogCatID    = Parametro("SysLogCat_ID",-1)
  
var iIQonDebug      = ParametroDeVentana(SistemaActual, VentanaIndex, "Debug",0)
var iIQonMuestraQueryPrincipal = ParametroDeVentanaConUsuario(SistemaActual, VentanaIndex, SysLog_ID, "Ver query principal",0)

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
	var LLaveHeredada  = new Array(0)   //esta llave entra por los parametros de condicion y es agregada al arreglo para tomar sus  datos
	                                    //pero no puede ser usada porque es posible que no este en el arreglo de campos del query
	
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
	var iMW_PuedeSeleccionar = 0                     //permiso por configuracion
	var iMWPuedeSeleccionar = Session("NxSelecct")   //acceso a la siguiente ventana
	var iAbrirNuevaVentana  = 0
	var sqCampoLlavePrefijo = ""
	var MGrdT_TieneChecks = 0 
	var MGrdT_UsarDivs    = 0
	var MGrdT_EstiloPaginador = ""
	var MGrdT_EstiloTabla = ""

	var arrLLaves  = ""  // estructura =  Campo,Alias,EsPermanente,UsarParaConsulta,EsPrimaria,Tipo
	var arrCampos  = ""  //               Nombre,Campo,Alias,Ancho,Alineacion,Clase,Orden,Tipo,Visible
	var arrOcultos = ""  //               Campo,EsPermanente
	var arrOrden   = ""  //               Campo/Alias,Orden

	var sC = String.fromCharCode(34)
	var sResultado = ""


	var sSQLConfBase = " select Wgt_ID, WgCfg_ID, MW_Param, MW_PuedeAgregar, MW_PuedeBorrar, MW_PuedeEditar, "
		sSQLConfBase += " MW_PuedeSeleccionar, MW_AlSeleccionarAbrirNuevaVentana "
		sSQLConfBase += " from Menu_Widget "
		sSQLConfBase += " WHERE Sys_ID = " + SistemaActual
		sSQLConfBase += " AND Mnu_ID = " + VentanaIndex
		sSQLConfBase += " AND Wgt_ID = 42 "  // + iWgID
		//sSQLConfBase += " AND WgCfg_ID = " + iWgCfg_ID
		

if (iIQonDebug > 0) { 
    Response.Write("<br>linea 109 cargando los datos de menuwidget<br> SQL = " + sSQLConfBase) 
    Response.Write("<br>linea 110 uasuario y " + IDUsuario + " TipoUsuario" + UsuarioTpo + "<br>") 
}
	
	var rsConfBase = AbreTabla(sSQLConfBase,1,2)
	if (!rsConfBase.EOF){
			iAbrirNuevaVentana = rsConfBase.Fields.Item("MW_AlSeleccionarAbrirNuevaVentana").Value
			iMWPuedeAgregar    = rsConfBase.Fields.Item("MW_PuedeAgregar").Value
			iMWPuedeEditar     = rsConfBase.Fields.Item("MW_PuedeEditar").Value
			iMWPuedeBorrar     = rsConfBase.Fields.Item("MW_PuedeBorrar").Value
			iMW_PuedeSeleccionar = rsConfBase.Fields.Item("MW_PuedeSeleccionar").Value
			iWgCfg_ID     = rsConfBase.Fields.Item("WgCfg_ID").Value
			
	}
	rsConfBase.Close()
	
if (iIQonDebug > 0) { 
    Response.Write("<br>linea 126 Resultado de seguridad" ) 
    Response.Write("<br>iAbrirNuevaVentana " + iAbrirNuevaVentana) 
    Response.Write("<br>iMWPuedeAgregar " + iMWPuedeAgregar) 	
    Response.Write("<br>iMWPuedeEditar " + iMWPuedeEditar) 	
    Response.Write("<br>iMWPuedeBorrar " + iMWPuedeBorrar) 	
    Response.Write("<br>iMW_PuedeSeleccionar " + iMW_PuedeSeleccionar) 
    Response.Write("<br><br>variables de sesion" ) 	
    Response.Write("<br>Editar " + Session("Editar")) 		
    Response.Write("<br>Agregar " + Session("Agregar") ) 		
    Response.Write("<br>Borrar " + Session("Borrar")) 	
		
}
	var sSQLTTLlaves = " iqCli_ID = " + iqCli_ID
		sSQLTTLlaves += " AND Sys_ID = " + SistemaActual
		sSQLTTLlaves += " AND WgCfg_ID = " + iWgCfg_ID
		sSQLTTLlaves += " AND Mnu_ID = " + VentanaIndex
		sSQLTTLlaves += " AND SysLog_ID = -1 "
		sSQLTTLlaves += " AND SysLogCat_ID = -1 "
		sSQLTTLlaves += " AND Wgt_ID = " + iWgID
		sSQLTTLlaves += " AND WgCfgC_ID = 0 " 
		
	var sATTb = "SELECT * "
		sATTb += " FROM MenuGridTablas "
		sATTb += " WHERE  Sys_ID = " + SistemaActual
		sATTb += " AND WgCfg_ID = " + iWgCfg_ID
		
if (iIQonDebug > 0) { Response.Write("<br>linea 152 cargando los datos de la tabla<br> SQL = " + sATTb) }
	var rsEncTB = AbreTabla(sATTb,1,2)
	if (!rsEncTB.EOF){
			SQLTabla     = FiltraVacios(rsEncTB.Fields.Item("MGrdT_SQLTabla").Value)
			SQLCondicion = FiltraVacios(rsEncTB.Fields.Item("MGrdT_SQLCondicion").Value)
			SQLCondicion = ProcesaBuscadorDeParametros(SQLCondicion)
			SQLOrden     = FiltraVacios(rsEncTB.Fields.Item("MGrdT_SQLOrden").Value)
			MGrdT_TieneChecks = rsEncTB.Fields.Item("MGrdT_TieneChecks").Value
			MGrdT_UsarDivs    = rsEncTB.Fields.Item("MGrdT_UsarDivs").Value	
			sConsultaFiltrosEnlace = FiltraVacios(rsEncTB.Fields.Item("MGrdT_EnlaceConFiltros").Value)		
			MGrdT_EstiloPaginador = rsEncTB.Fields.Item("MGrdT_EstiloPaginador").Value
			MGrdT_EstiloTabla    = rsEncTB.Fields.Item("MGrdT_EstiloTabla").Value	
	}
	rsEncTB.Close()


	//carga de filtros
	var sFiltros  = "SELECT Fil_FiltroSQL, MGF_Enlace "
		sFiltros += " FROM MenuGridFiltros MGF, Filtros f "
		sFiltros += " WHERE MGF.Sys_ID = f.Sys_ID AND MGF.WgCfg_ID = " + iWgCfg_ID
		sFiltros += " AND  MGF.Fil_ID  = f.Fil_ID  "
		sFiltros += " AND f.Fil_TipoUsuario = '" + UsuarioTpo + "'"
		
	if (iIQonDebug > 0) { 
		Response.Write("<br>linea 158 carga de filtros<br>") 
		Response.Write("<br>Filtros " + sFiltros)
		Response.Write("<br>------------------------------------------------------------<br>")
	}
		
	var rsFiltro = AbreTabla(sFiltros,1,2)
		while (!rsFiltro.EOF){
			if (sConsultaFiltros != "") {
				sConsultaFiltros += " " + rsFiltro.Fields.Item("MGF_Enlace").Value + " "
			}
			sConsultaFiltros += rsFiltro.Fields.Item("Fil_FiltroSQL").Value
			rsFiltro.MoveNext()
		}
		rsFiltro.Close() 

	sConsultaFiltros = ProcesaBuscadorDeParametros(sConsultaFiltros)
	
	if (iIQonDebug > 0) { 
		Response.Write("<br>linea 194 <br>") 
		Response.Write("<br>Filtro final sConsultaFiltros = " + sConsultaFiltros)
		Response.Write("<br>------------------------------------------------------------<br>")
	}	
	
	var sSQLTT = " Select * from Widget_Configuracion_Complemento "	
		sSQLTT += " Where " + sSQLTTLlaves

	if (iIQonDebug > 0) { Response.Write("<br>linea 202 sql llaves<br>" + sSQLTT) }

	var rsSQLTT = AbreTabla(sSQLTT,1,2)
	if (!rsSQLTT.EOF){
		arrLLaves  = String(rsSQLTT.Fields.Item("WgCfgC_Atributo1").Value)
		arrCampos  = String(rsSQLTT.Fields.Item("WgCfgC_Atributo2").Value)
		arrOcultos = String(rsSQLTT.Fields.Item("WgCfgC_Atributo5").Value)
		arrOrden   = String(rsSQLTT.Fields.Item("WgCfgC_Atributo4").Value)
	} 
	rsSQLTT.Close()
	
	if (iIQonDebug > 0) { Response.Write("<br>linea 213 armado de las llaves<br>") }
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
			LLaveHeredada[j]  = 0
			if (!bCpoLL) {
				if (LLavePK[j] == 1 ) {                                         
					bCpoLL = true 
					if ( !EsVacio(arrLL[2]) ) {   // valido que venga un alias
						sqCampoLlave = arrLL[2]
						if (arrSoloAlias != "") {arrSoloAlias += ", "}
						arrSoloAlias += arrLL[2]
						sqCampoLlavePrefijo = ""
						if ( !EsVacio(LLavePrefijo[j]) ) { 
							sqCampoLlavePrefijo = LLavePrefijo[j] + "."
						}
						sqCampoLlavePrefijo += LLaveCampo[j]
						sqOrdenEmergencia = sqCampoLlavePrefijo
						sqCampoLlavePrefijo += " as " + sqCampoLlave
						if (arrSoloCampos != "") {arrSoloCampos += ", "}
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
						if (arrSoloAlias != "") {arrSoloAlias += ", "}
						arrSoloAlias += sqCampoLlave
						if (arrSoloCampos != "") {arrSoloCampos += ", "}
						arrSoloCampos += sqCampoLlave
					}
				} else {
					if (arrSoloCampos != "") {arrSoloCampos += ", "}
					arrSoloCampos += LLaveCampo[j]
					if (arrSoloAlias != "") {arrSoloAlias += ", "}
					arrSoloAlias += LLaveCampo[j]
					
				}
			}
		}
	}	

	
	if (iIQonDebug > 0) { Response.Write("<br>linea 275 armado de los parametros que envian<br>") }

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
					LLaveHeredada[iCmpLL]  = 0
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
				LLaveHeredada[iCmpLL]  = 1
			}
		}

if (iIQonDebug > 0) { Response.Write("<br>linea 310 armado de la condicion<br>") }

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

if (iIQonDebug > 0) { Response.Write("<br>linea 338 armado de los parametros de busqueda<br>") }	

	if (ConBus != "") {


//6 fecha tipo texto
		ConBus = ConBus.replace(/:td6/gi, ":'")
		ConBus = ConBus.replace(/td6:/gi, "' ")


//12 rango de fechas
		ConBus = ConBus.replace(/:R12/gi, " BETWEEN CONVERT(DATE, '")
		ConBus = ConBus.replace(/sr12/gi, "', 105) AND DATEADD(day,1,CONVERT(DATE, '")
		ConBus = ConBus.replace(/R12/gi, "', 105)) ")
//		ConBus = ConBus.replace(/:R12/gi, ">= CONVERT(DATE, '")
//		ConBus = ConBus.replace(/sr12/gi, "', 105) AND ")
//		ConBus = ConBus.replace(/sr12/gi, " < DATEADD(day,1,CONVERT(DATE, '")
//		ConBus = ConBus.replace(/R12:/gi, "', 105))) ")		
		

//11 fecha tipo rango de textos
		
		ConBus = ConBus.replace(/:R11/gi, " BETWEEN ")
		ConBus = ConBus.replace(/sr11/gi, " AND ")
		ConBus = ConBus.replace(/R11/gi, " ")

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

	    ConBus = ConBus.replace(/:¬%/gi, " LIKE '%")
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

if (iIQonDebug > 0) { Response.Write("<br>linea 398 Armado de arreglos de campos<br>") }	
	
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
	sResultado += "<br>iWgCfg_ID: " + iWgCfg_ID 	
	sResultado += "<br>iWgID: " + iWgID 
	sResultado += "<br>sSQLTTLlaves: " + sSQLTTLlaves 
	Response.Write(sResultado)
	sResultado = "<br>probando salida de resultado<br>"
} 

	switch (parseInt(Tarea)) {
		case 1:
			if (sConsultaFiltros != "") {
				//por si se les olvido poner el separador en el campo de menugridtabla
				if (SQLCondicion != "" && sConsultaFiltros != "" && sConsultaFiltrosEnlace == "") {
					sConsultaFiltrosEnlace = " and "
				}
				
				if (SQLCondicion != "") {
					SQLCondicion += " " + sConsultaFiltrosEnlace + " " 		
				}
				SQLCondicion += "( " + sConsultaFiltros + " )"
			}		
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
			//if (iTotalRegistros > 3000) {
				//Debug_ImprimeParametros("Parametros que entraron a l grid pg 2")
				//Response.End()	
			//} else {
			iTotalPaginas = parseInt(iTotalRegistros / iRegPorVentana)
			sResultado ="<br>iTotalPaginas= " + iTotalPaginas
			if((iTotalRegistros % iRegPorVentana) > 0) { iTotalPaginas++ }
			sResultado = ""  + ArmaPaginacion(iTotalPaginas,iTotalRegistros)  
			sResultado += "<div id=" + sC + "DatosGrid" + sC + "></div>"
			
			Response.Write(sResultado)
			//}
			break;
		case 2:	
			sResultado = ArmaEncabezados()
			sResultado += CargaDatos(iPaginaActual,iRegPorVentana)
			Response.Write(sResultado)			
			break;
	}
	

	
function ArmaPaginacion(iPaginas,iRegistros) {
	var sPaginacion = ""

	sPaginacion += "<table class=" + sC + MGrdT_EstiloPaginador + sC + " >"
	if (iMWPuedeAgregar >= 1 && Session("Agregar") == 1) {
		sPaginacion += "<tr>"
		sPaginacion += "<td colspan=" + sC + "7" + sC + " ><div id=" + sC + "dvAreaBotones" + sC + " align=" + sC + "right" + sC + "></div></td>"
		sPaginacion += "<td colspan=" + sC + "4" + sC + " ><div align=" + sC + "center" + sC + ">"
		sPaginacion += "<input type=" + sC + "button" + sC + " name=" + sC + "grbtnNuevo" + sC + " "
		sPaginacion += " id=" + sC + "grbtnNuevo" + sC + " value=" + sC + "Nuevo" + sC + " "
		sPaginacion += " onclick=" + sC + "javascript:grAccNuevo(-1," + iMWPuedeAgregar + ");" + sC + " />"
		sPaginacion += "</div></td></tr>"
	}
	sPaginacion += "<tr>"
	sPaginacion += "<td width=" + sC + "71%" + sC + " align=" + sC + "right" + sC + " valign=" + sC + "middle" + sC + " " 
	sPaginacion += " colspan=" + sC + "7" + sC + ">" 
	sPaginacion += "&nbsp;Registros por p&aacute;gina&nbsp;&nbsp;&nbsp;"
	sPaginacion += "<select name=" + sC + "RegPorVentana" + sC + " id=" + sC + "RegPorVentana" + sC
	sPaginacion += " style='width: 60px;' "
	sPaginacion += " onchange=" + sC + "AcPaginacion(this.value)" + sC + " >"
	sPaginacion += "<option value=" + sC + "10" + sC 
		if ( iRegPorVentana <= 10) { sPaginacion += "selected " } 
	sPaginacion += ">10</option>"
	
	sPaginacion += "<option value=" + sC + "12" + sC 
		if ( iRegPorVentana == 12) { sPaginacion += "selected " } 
	sPaginacion += ">12</option>"
	
	sPaginacion += "<option value=" + sC + "15" + sC
		if ( iRegPorVentana == 15) { sPaginacion += "selected " } 
	sPaginacion += ">15</option>"
	
	sPaginacion += "<option value=" + sC + "18" + sC
		if ( iRegPorVentana == 18) { sPaginacion += "selected " } 
	sPaginacion += ">18</option>"
	
	sPaginacion += "<option value=" + sC + "20" + sC
		if ( iRegPorVentana == 20) { sPaginacion += "selected " } 
	sPaginacion += ">20</option>"
	
	sPaginacion += "<option value=" + sC + "30" + sC
		if ( iRegPorVentana == 30) { sPaginacion += "selected " } 
	sPaginacion += ">30</option>"
	
	sPaginacion += "<option value=" + sC + "50" + sC
		if ( iRegPorVentana == 50) { sPaginacion += "selected " } 
	sPaginacion += ">50</option>"
	
	sPaginacion += "<option value=" + sC + "100" + sC
		if ( iRegPorVentana == 100) { sPaginacion += "selected " } 
	sPaginacion += ">100</option>"
	if (iRegistros > 100) {
		sPaginacion += "<option value=" + sC + iRegistros + sC
			if ( iRegPorVentana > 100) { sPaginacion += "selected " } 
		sPaginacion += ">todos</option>"
	}
	sPaginacion += "</select>"

	//Parametros necesarios de la página
//	var ParLetra = ""
//		ParLetra += "Letra="+Parametro("Letra","Todas")+ "&" 		
// 	var iCont = 1
	
//	ParLetra += "TR="+iRegistros+ "&"    
	sPaginacion += "<input type=" + sC + "hidden" + sC + " name=" + sC + "TotalRegistros" + sC + " id=" + sC + "TotalRegistros" + sC + " value=" + sC + iRegistros + sC + ">"
//	sPaginacion += "<input type=" + sC + "hidden" + sC + " name=" + sC + "PaginaActual" + sC + " value=" + sC + 1 + sC + ">"
	sPaginacion += "<input type=" + sC + "hidden" + sC + " name=" + sC + "TotalPaginas" + sC + " id=" + sC + "TotalPaginas" + sC + " value=" + sC + iPaginas + sC + ">"
//	sPaginacion += "<input type=" + sC + "hidden" + sC + " name=" + sC + "AccionDePaginacion" + sC + " value=" + sC + 1 + sC + ">"

	sPaginacion += "&nbsp;&nbsp;&nbsp;Total:&nbsp;" + iRegistros
	sPaginacion += "&nbsp;Registros&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;"
	sPaginacion += "P&aacute;gina actual&nbsp;&nbsp;"
	sPaginacion += "<select name=" + sC + "IrAPagina" + sC + " id=" + sC + "IrAPagina" + sC  
	sPaginacion += " onchange=" + sC + "AcIrAPagina(this.value)" + sC + " style=" + sC + "width:60px;" + sC + ">"     
	
	for (i = 1; i <= iPaginas; i++) {
		if (1 == i) {
			sPaginacion += "<option value=" + sC + i + sC + " selected >" + i + "</option>"
		} else {
			sPaginacion += "<option value=" + sC + i + sC + " >" + i + "</option>"
		}
	}
	sPaginacion += "</select>"
	sPaginacion += "&nbsp; de &nbsp;" + iPaginas + "&nbsp; P&aacute;ginas&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>"
	iPaginas,iRegistros
	if (iPaginas > 1) {
		sPaginacion += "<td width=" + sC + "3%" + sC + " align=" + sC + "left" + sC + " valign=" + sC + "middle" + sC + ">"
		sPaginacion += "<a href=" + sC + "javascript:CambiaAPagina(1)" + sC + "><img id=" + sC + "btnPrimero" + sC 
		sPaginacion += " src=" + sC + "/Plugins/Grid_IQon/img/BtnPrimero.gif" + sC
		sPaginacion += " rel=" + sC + "/Plugins/Grid_IQon/img/BtnPrimero_off.gif" + sC 
		sPaginacion += " border=" + sC + "0" + sC + "></a></td>"
		sPaginacion += "<td width=" + sC + "3%" + sC + " align=" + sC + "left" + sC + " >"
		sPaginacion += "<a href=" + sC + "javascript:CambiaAPagina(2)" + sC + "><img id=" + sC + "btnAnterior" + sC 
		sPaginacion += " src=" + sC + "/Plugins/Grid_IQon/img/BtnAnterior.gif" + sC
		sPaginacion += " rel=" + sC + "/Plugins/Grid_IQon/img/BtnAnterior_off.gif" + sC 
		sPaginacion += " border=" + sC + "0" + sC + "></a></td>"
		sPaginacion += "<td width=" + sC + "3%" + sC + " align=" + sC + "right" + sC + " >"
		sPaginacion += "<a href=" + sC + "javascript:CambiaAPagina(3)" + sC + " ><img id=" + sC + "btnSiguiente" + sC 
		sPaginacion += " src=" + sC + "/Plugins/Grid_IQon/img/BtnSiguiente.gif" + sC 
		sPaginacion += " rel=" + sC + "/Plugins/Grid_IQon/img/BtnSiguiente_off.gif" + sC
		sPaginacion += " border=" + sC + "0" + sC + "></a></td>"
		sPaginacion += "<td width=" + sC + "3%" + sC + " align=" + sC + "right" + sC + ">"
		sPaginacion += "<a href=" + sC + "javascript:CambiaAPagina(4)" + sC + " ><img id=" + sC + "btnUltimo" + sC 
		sPaginacion += " src=" + sC + "/Plugins/Grid_IQon/img/BtnUltimo.gif" + sC 
		sPaginacion += " rel=" + sC + "/Plugins/Grid_IQon/img/BtnUltimo_off.gif" + sC
		sPaginacion += " border=" + sC + "0" + sC + " ></a></td>"
	} else {
		sPaginacion += "<td colspan=" + sC + "4" + sC + " ></td>"
	}
	sPaginacion += "</table>"

	return sPaginacion
}


function ArmaEncabezados() {

	var sWH9          = " width=" + sC + "9" + sC + " height=" + sC + "9" + sC +" "
	var sAL           = " align=" + sC + "left" + sC + " "
	var sAC           = " align=" + sC + "center" + sC + " "
	var sPadding      = " style=" + sC + "padding-right: 5px;padding-left: 5px;" + sC + " "
	
	var sEncabezado  = "<table class=" + sC + MGrdT_EstiloTabla + sC + ">"
		sEncabezado += "<thead>"
		sEncabezado += "<tr role='row'>"
		if (MGrdT_TieneChecks==1) {
			sEncabezado += "<th width=" + sC + "20" + sC + " >"
			sEncabezado += "<input name=\"chkT\" id=\"chkT\" type=\"checkbox\" onclick=\"javascript:CkTd()\" /></th>"
		}
		sEncabezado += "<th width=" + sC + "20" + sC + " >Num.</th>"

	//var sConsultaGral = ""
	for(ig=0;ig<grdCampo.length;ig++){ 
			sEncabezado +="<th "
			if (grdAncho[ig] != "")	sEncabezado +=" width=" + sC + grdAncho[ig] + sC + " "
			if (grdAlineacion[ig] != "")	sEncabezado +=" align=" + sC + grdAlineacion[ig] + sC + " "
			if (grdClass[ig] != "")	sEncabezado +=" class=" + sC + grdClass[ig] + sC + " "
			sEncabezado +=  ">" + grdNombre[ig] +"</th>"
	}
	//columna de ligas
	if ( iMWPuedeBorrar >= 1 || iMWPuedeEditar >= 1 || iMWPuedeSeleccionar >= 1 || iMW_PuedeSeleccionar >= 1) {
		sEncabezado +="<th width=" + sC + "80" + sC + " align=" + sC + "center" + sC + " >&nbsp;</th>"
	}
	sEncabezado +="</tr></thead>"
	
	return sEncabezado

}

function ProcesaBuscadorDeParametros(sValor) {
	var sRespuesta = sValor
	var arrPrm    = new Array(0)
		
	var iPos = sRespuesta.indexOf("{");
	if (iPos > -1) {
		var Antes = sRespuesta.substr(0, iPos);
        var Despues = sRespuesta.substr(iPos  + 1, sRespuesta.length - iPos)
		var iPos2 = Despues.indexOf("}");
		var sParm = Despues.substr(0, iPos2);
		var Despues = Despues.substr(iPos2 + 1, Despues.length - iPos2)
		// resuelve el parametro
		var arrPrm = sParm.split(",")
		var sTmpPP = Parametro(arrPrm[0],arrPrm[1])
		
//		if (EsVacio(sTmpPP)) {
//			sTmpPP = "0"
//		}
		sRespuesta = Antes + sTmpPP + Despues
		sRespuesta = ProcesaBuscadorDeParametros(sRespuesta)
	} 
	return sRespuesta
	
}

function CargaDatos(Pagina,TamanioPagina) {
var sDatos = ""
var iUltimoNoRenglon = 0
var iPagina = Pagina -1
var iRegistros = 0
var sMsgError = ""

if (SQLCondicion != "" && sConsultaFiltros != "" && sConsultaFiltrosEnlace == "") {
	sConsultaFiltrosEnlace = " and "
}
if (sConsultaFiltros != "") {
	if (SQLCondicion != "") {
		SQLCondicion += " " + sConsultaFiltrosEnlace + " " 	
	}
	SQLCondicion += "( " + sConsultaFiltros + " )"
}

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
	//Response.Write(" <br> " + sConsultaGral)
	if (iIQonDebug > 0 || Parametro("IDUsuario",-1) == 1) {
		Response.Write(" <br> " + sConsultaGral) 
	}


  try {
	var TipoRenglon = "even"
	sDatos = "<tbody>"
	sMsgError = "Ocurrio el error al intentar abrir el query"
	var rsINS = AbreTabla(sConsultaGral,1,0)
		while (!rsINS.EOF){
			if (TipoRenglon == "even") {
				TipoRenglon = "odd"
			} else {
				TipoRenglon = "even"
			}
			
			var sValoresPrm = ""
			var llt=0
			for (llt=0;llt<LLaveCampo.length;llt++) {
				//Response.Write("<br>" + llt + ") " + LLaveCampo[llt])
				if(LLaveHeredada[llt] == 0) {
					sMsgError = "La llave " + LLaveCampo[llt] + " causo un problema al armar los parametros de salto en los registros"
					//Response.Write("<br>" + LLaveCampo[llt])
					if(sValoresPrm != "") { sValoresPrm += "," }
					sValoresPrm += rsINS.Fields.Item(LLaveCampo[llt]).Value
				}
			}		
			
			var sNombre = "" 
			iRengPintados += 1
			iRegistros =  rsINS.Fields.Item("RowNumber").Value
			sDatos +="<tr class=" + sC + TipoRenglon + sC + " >" 
			if (MGrdT_TieneChecks==1) {
				sDatos +="<td height=" + sC + "24" + sC + " align=" + sC + "center" + sC + " >"
				sDatos +="<input name=\"chkR\" id=\"chkR\" type=\"checkbox\" "
				sDatos +=" class=\"chkR\" data-parms=\"" + sValoresPrm + "\" value=\"" + iRegistros + "\" /></td>"
			}
			sDatos +="<td height=" + sC + "24" + sC + " align=" + sC + "center" + sC + " >"
			sDatos +="<strong>" + iRegistros + "</strong></td>"
			iUltimoRengPintados = iRegistros
			iUltimoNoRenglon++
			var sNombreCampo = ""
			var sValorDelCampo = ""
			sMsgError = "Ocurrio el error cuando se leian los campos del query ya leido"
			for(ig=0;ig<grdCampo.length;ig++){ 
					
					if (EsVacio(grdAlias[ig])) { 
						sNombreCampo = grdCampo[ig]
					} else {
						sNombreCampo = grdAlias[ig]
					}
					
				//sDatos += "<td align=" + sC + grdAlineacion[ig] + sC + " >"
				sValorDelCampo = "" + rsINS.Fields.Item( sNombreCampo ).Value
				if (EsVacio(sValorDelCampo)) { sValorDelCampo = ""  }
				sDatos += "<td "
				if ( grdAlineacion[ig] != "" ) sDatos += " align=" + sC + grdAlineacion[ig] + sC 
				sDatos += " >"
				switch (parseInt(grdTipo[ig])) {
					case 1:		
						sDatos += sValorDelCampo
						break;
					case 2:		
						sDatos += sValorDelCampo
						break;
					case 3:		
						if (parseInt(sValorDelCampo) == 1) {
							sDatos += "Si"
						} else {
							sDatos += "No"
						}
						break;
					case 4:		
						if (sValorDelCampo != "") {
							sDatos += PonerFormatoNumerico(FiltraVacios(sValorDelCampo),"$ ")
						} else {
							sDatos += "" 
						}
						break;	
					case 5:		
					    if (sValorDelCampo != "") {
							var fDato = parseFloat(FiltraVacios(rsINS.Fields.Item( sNombreCampo ).Value))
								fDato = fDato * 100
							sDatos += PonerFormatoNumerico(fDato,"") + " %"		
						} else {
							sDatos += "" 
						}	
						break;					
					case 6:
						if (sValorDelCampo != "") {
							sDatos += "&nbsp;" + FormatoFecha(sValorDelCampo ,"UTC a dd/mm/yyyy")
						} else {
							sDatos += "" 
						}	
						break;
					case 7:
					    if (sValorDelCampo != "") {
							sDatos += PonerFormatoNumerico(FiltraVacios(sValorDelCampo),"")
						} else {
							sDatos += "" 
						}	
						break;
					default:
						sDatos += "" + sValorDelCampo
						
				}   
				sDatos += "&nbsp;</td>"	 
			}
//este es la celda para las herramientas
			sDatos += "<td nowrap ><div align=" + sC + "center" + sC + ">"
//seccion de armado de llaves	
			sMsgError = "Ocurrio el error cuando se comenzaba a armar las llaves"		
			//var sValorCLL = rsINS.Fields.Item(sqCampoLlave).Value
			var sValorCLL = rsINS.Fields.Item(1).Value

			if (iMWPuedeBorrar >= 1 && Session("Borrar") == 1) {
				sDatos += "&nbsp;&nbsp;<a class=" + sC + "btn btn-danger" + sC + " "
				sDatos += " href=" + sC + "javascript:grAccBorrar(" + sValorCLL + "," + iRegistros + ")" + sC + ">"
				sDatos += "<i class=" + sC + "icon-trash icon-white" + sC + "></i>&nbsp;&nbsp;Borrar</a>&nbsp;&nbsp;"
			} 
				
			if (iMWPuedeEditar >= 1 && Session("Editar") == 1) {		
				sDatos += "&nbsp;&nbsp;<a class=" + sC + "btn btn-info" + sC + " "
				sDatos += " href=" + sC + "javascript:grAccEditar(" + sValorCLL + "," + iMWPuedeEditar + ")" + sC + ">"
				sDatos += "<i class=" + sC + "icon-edit icon-white" + sC + "></i>&nbsp;&nbsp;Editar</a>&nbsp;&nbsp;"
			}
			iMWPuedeSeleccionar=1
			if (iMWPuedeSeleccionar >= 1 && iMW_PuedeSeleccionar >= 1) {
				sDatos += "&nbsp;&nbsp;<a class=" + sC + "btn btn-primary" + sC + " "
				sDatos += " href=" + sC + "javascript:grSelecciona(" + sValoresPrm + ")" + sC + ">"
				sDatos += "<i class=" + sC + "fa fa-share" + sC + "></i>&nbsp;&nbsp;Ver</a>&nbsp;&nbsp;"				
			}
			sDatos += "</div></td>"		
			sDatos += "</tr>"
			rsINS.MoveNext()
		}
		rsINS.Close()  

//inicia renglones vacios extra
if (bMostrarRenglonesComplemento) {
	for(ig=iRengPintados;ig<iRegPorVentana;ig++){ 
		iUltimoRengPintados++
		if (TipoRenglon == "even") {
			TipoRenglon = "odd" 
		} else {
			TipoRenglon = "even"
		}
			sDatos +="<tr>"
			sDatos +="<td height=" + sC + "24" + sC + " align=" + sC + "center" + sC + " class=" + sC + TipoRenglon + sC + ">"
			sDatos +="<strong>" + iUltimoRengPintados + "</strong></td>"
			for(igr=0;igr<grdCampo.length;igr++){ 
				sDatos += "<td align=" + sC + grdAlineacion[ig] + sC + " class=" + sC + TipoRenglon + sC + " >&nbsp;</td>"	
			}
			sDatos += "<td align=" + sC + "center" + sC + " class=" + sC + TipoRenglon + sC + " >"
		  sDatos += "&nbsp;</td></tr>"
	}
  }
//fin renglones vacios extra
	sDatos +="<tbody>"
	sDatos +="</table>"
	sMsgError = ""
  } catch(err) {
		sDatos = "<br>Ocurrio el error  " + err.number + "<br>La descripcion es = " + err.description + "<br>Mensaje = " + err.message
		sDatos += "<br><br>por favor revise su configuracion"
		sDatos += "<br><br>"
		sDatos += "<br><br>El mensaje especifico es " + sMsgError
		sDatos += "<br><br>"
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
		sDatos += "<br>iWgCfg_ID: " + iWgCfg_ID 	
		sDatos += "<br>iWgID: " + iWgID 
		//sDatos += "<br>connectionstring : " + arsODBC[0] 
		sDatos += "<br>sSQLTTLlaves: " + sSQLTTLlaves 

  }
	
	return sDatos
	
}

%>
