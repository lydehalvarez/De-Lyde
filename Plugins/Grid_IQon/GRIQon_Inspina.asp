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
var iRegPorVentana  = Parametro("RegPorVentana",ParametroDeVentana(SistemaActual, VentanaIndex, "Registros Por Ventana",18))
var iRegistroActual = Parametro("RegistroActual",0)
var iRengPintados = 0
var iUltimoRengPintados = 0
    SistemaActual   = Parametro("Sys_ID",0)
    VentanaIndex    = Parametro("Mnu_ID",0)
var iWgCfg_ID       = Parametro("WgCfg_ID",0)
var iWgID           = 61
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

var iIQonDebug = ParametroDeVentanaConUsuario(SistemaActual, VentanaIndex, SysLog_ID, "Debug",0)
var iIQonSeguridad = ParametroDeVentanaConUsuario(SistemaActual, VentanaIndex, SysLog_ID, "Grid con seguridad",0)
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
	var WgCfg_LlavesALimpiar = ""  
	var MGrdT_Conexion    = 0

	var arrLLaves  = ""  // estructura =  Campo,Alias,EsPermanente,UsarParaConsulta,EsPrimaria,Tipo
	var arrCampos  = ""  //               Nombre,Campo,Alias,Ancho,Alineacion,Clase,Orden,Tipo,Visible
	var arrOcultos = ""  //               Campo,EsPermanente
	var arrOrden   = ""  //               Campo/Alias,Orden

	var sC = String.fromCharCode(34)  //" comilla doble 
	var sResultado = ""
	
	var sSQLConfBase = " select Wgt_ID, WgCfg_ID, MW_Param, MW_PuedeAgregar, MW_PuedeBorrar, MW_PuedeEditar, "
		sSQLConfBase += " MW_PuedeSeleccionar, MW_AlSeleccionarAbrirNuevaVentana "
		sSQLConfBase += " from Menu_Widget "
		sSQLConfBase += " WHERE Sys_ID = " + SistemaActual
		sSQLConfBase += " AND Mnu_ID = " + VentanaIndex
		sSQLConfBase += " AND Wgt_ID = 61 "  // + iWgID
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
			
		var sCondVS = " Sys_ID = " + SistemaActual + " and WgCfg_ID = " + iWgCfg_ID + " AND Wgt_ID = 61 "
		WgCfg_LlavesALimpiar = "" + BuscaSoloUnDato("WgCfg_LlavesALimpiar","Widget_Configuracion",sCondVS,0,2)
	}
	rsConfBase.Close()
	
if (iIQonDebug > 0) { 
    Response.Write("<br>linea 126 Resultado de seguridad" ) 
    Response.Write("<br>iRegPorVentana " + iRegPorVentana) 	
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
		sSQLTTLlaves = " Sys_ID = " + SistemaActual
		sSQLTTLlaves += " AND WgCfg_ID = " + iWgCfg_ID
		//sSQLTTLlaves += " AND Mnu_ID = " + VentanaIndex
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
			SQLTabla = FiltraVacios(rsEncTB.Fields.Item("MGrdT_SQLTabla").Value)
			SQLTabla = ProcesaBuscadorDeParametros(SQLTabla)
if (iIQonDebug > 0) { Response.Write("<br>linea 162) SQLTabla<br> SQL = " + SQLTabla) }	

			SQLCondicion = FiltraVacios(rsEncTB.Fields.Item("MGrdT_SQLCondicion").Value)
			SQLCondicion = ProcesaBuscadorDeParametros(SQLCondicion)
			SQLOrden     = FiltraVacios(rsEncTB.Fields.Item("MGrdT_SQLOrden").Value)
			MGrdT_TieneChecks = rsEncTB.Fields.Item("MGrdT_TieneChecks").Value
			MGrdT_UsarDivs    = rsEncTB.Fields.Item("MGrdT_UsarDivs").Value	
			sConsultaFiltrosEnlace = FiltraVacios(rsEncTB.Fields.Item("MGrdT_EnlaceConFiltros").Value)		
			MGrdT_EstiloPaginador = rsEncTB.Fields.Item("MGrdT_EstiloPaginador").Value
			MGrdT_EstiloTabla    = rsEncTB.Fields.Item("MGrdT_EstiloTabla").Value	
			MGrdT_Conexion = rsEncTB.Fields.Item("MGrdT_Conexion").Value
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
				if(WgCfg_LlavesALimpiar.indexOf(LLaveCampo[hi]) == -1){
					if (SQLCondicionSQLC != "") { SQLCondicionSQLC += " AND " }
					if ( !EsVacio(LLavePrefijo[hi]) ) { 
						SQLCondicionSQLC += LLavePrefijo[hi] + "."
					}                                               
					SQLCondicionSQLC += LLaveCampo[hi] + " = " + LLaveValor[hi]
				}
			}
		}

		if (SQLCondicion != "" && SQLCondicionSQLC != "" ) {SQLCondicion += " AND " } 
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

//19 rangos de fecha tipo date - datetime
		ConBus = ConBus.replace(/:R19/gi, " BETWEEN CONVERT(DATE, '")
		ConBus = ConBus.replace(/sr19/gi, "', 105) AND DATEADD(day,1,CONVERT(DATE, '")
		ConBus = ConBus.replace(/R19/gi, "', 105)) ")

//21 = text box Subconsulta tipo WHERE LLAVEENLACE IN (SELECT ALIAS.LLAVEENLACE FROM TABLA ALIAS WHERE ALIAS.CAMPOBUSQUEDA LIKE ''+ @sNomCliente + '')





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
				iTotalRegistros = BuscaSoloUnDato("Count(*)",SQLTabla,SQLCondicion,0,MGrdT_Conexion)
			} else {
				var sSQLCnt  = " SELECT Count(*) FROM " + SQLTabla
					sSQLCnt += " WHERE " + SQLCondicion
				var rsCnt = AbreTabla(sSQLCnt,1,MGrdT_Conexion)
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
			sResultado  = "<div class='ibox'>"
            sResultado += "<div class='ibox-content' style='padding-bottom: 31px;'>"
			if((iTotalRegistros % iRegPorVentana) > 0) { iTotalPaginas++ }
			sResultado += ""  + ArmaPaginacionCO(iTotalPaginas,iTotalRegistros)  
			sResultado += "<div class='form-group'><div id='DatosGrid'></div></div>"
			sResultado += "</div></div>"
			
			Response.Write(sResultado)
			//}
			break;
		case 2:	
			sResultado = ArmaEncabezados()
			sResultado += CargaDatos(iPaginaActual,iRegPorVentana)
			Response.Write(sResultado)			
			break;
	}
	
	//	ArmaPaginacionCO nuevo
	function ArmaPaginacionCO(iPaginas,iRegistros) {
		
		var sPaginacion =  ""
	    var bPoneBotones = true
	     
		if(iIQonSeguridad == 0) {
			bPoneBotones = true
		} else {
			if (iMWPuedeAgregar >= 1 && Session("Agregar") == 1) {
				bPoneBotones = true
			} else {
				bPoneBotones = false
			}
		}
	

		if (bPoneBotones) {
			
				sPaginacion += "<div class='row'>"
					sPaginacion += "<div class='col-md-8'>"
						sPaginacion += "<div id='dvAreaBotones' align='right'></div>"
					sPaginacion += "</div>"
					sPaginacion += "<div class='col-md-4'>"
						sPaginacion += "<div id='dvbtnNuevo' align='right'>"
					sPaginacion += "<a class='btn btn btn-primary' href='"
					sPaginacion += "javascript:grAccNuevo(-1," + iMWPuedeAgregar + ");'>"
					sPaginacion += "<i class='fa fa-plus'> </i>&nbsp;Nuevo&nbsp;"
					sPaginacion += "</a>"
						sPaginacion += "</div>"
					sPaginacion += "</div>"
				sPaginacion += "</div>"
	
		}
			sPaginacion += "<div class='form-horizontal' id='PagGrid'>"
				sPaginacion += "<div id='pag1' class='col-md-12' align='right' style='margin-top:25px'>"
					sPaginacion += "<div class='form-group'>"
					
					     sPaginacion += "<label class='col-md-2 control-label' "
						 sPaginacion += " style='margin-right: 20px' >"
						 sPaginacion += "Total:&nbsp;" + iRegistros
					     sPaginacion += "&nbsp;Registros&nbsp;</label>"
					
					
						sPaginacion += "<label class='col-md-2 control-label'>"
						sPaginacion += "Registros por p&aacute;gina</label>"
						sPaginacion += "<div class='col-md-1'>"
	
									sPaginacion += "<select name='RegPorVentana' id='RegPorVentana'" 
										sPaginacion += " class='form-control input-sm'"
										sPaginacion += " onchange='AcPaginacion(this.value)' >"
									
										sPaginacion += "<option value='10'" 
											if ( iRegPorVentana <= 10) { sPaginacion += "selected " } 
										sPaginacion += ">10</option>"
										
										sPaginacion += "<option value='12'" 
											if ( iRegPorVentana == 12) { sPaginacion += "selected " } 
										sPaginacion += ">12</option>"
		
										sPaginacion += "<option value='15'"
											if ( iRegPorVentana == 15) { sPaginacion += "selected " } 
										sPaginacion += ">15</option>"
										
										sPaginacion += "<option value='18'"
											if ( iRegPorVentana == 18) { sPaginacion += "selected " } 
										sPaginacion += ">18</option>"
		
										sPaginacion += "<option value='20'"
											if ( iRegPorVentana == 20) { sPaginacion += "selected " } 
										sPaginacion += ">20</option>"
										
										sPaginacion += "<option value='30'"
											if ( iRegPorVentana == 30) { sPaginacion += "selected " } 
										sPaginacion += ">30</option>"
										
										sPaginacion += "<option value='50'"
											if ( iRegPorVentana == 50) { sPaginacion += "selected " } 
										sPaginacion += ">50</option>"
										
										sPaginacion += "<option value='100'"
											if ( iRegPorVentana == 100) { sPaginacion += "selected " } 
										sPaginacion += ">100</option>"
										if (iRegistros > 100) {
											sPaginacion += "<option value='" + iRegistros + "'"
												if ( iRegPorVentana > 100) { sPaginacion += "selected " } 
											sPaginacion += ">todos</option>"
										}
									sPaginacion += "</select>"
						sPaginacion += "<input type='hidden' name='TotalRegistros' id='TotalRegistros' value='" + iRegistros + "'>"
						sPaginacion += "<input type='hidden' name='TotalPaginas' id='TotalPaginas' value='" + iPaginas + "'>"
	
						sPaginacion += "</div>"	
						sPaginacion += "<label class='col-md-1 control-label' "
						sPaginacion += " style='width: 120px;' >" 	
						sPaginacion += "<p class='text-right'>P&aacute;gina actual</p>"
						sPaginacion += "</label>" 
						
						sPaginacion += "<div class='col-md-1'>" 
							sPaginacion += "<select name='IrAPagina' id='IrAPagina'" 
							sPaginacion += " class='form-control input-sm'" 
							sPaginacion += " onchange='AcIrAPagina(this.value)'>"     
							
							for (i = 1; i <= iPaginas; i++) {
								if (1 == i) {
									sPaginacion += "<option value='" + i + "' selected >" + i + "</option>"
								} else {
									sPaginacion += "<option value='" + i + "' >" + i + "</option>"
								}
							}
							sPaginacion += "</select>"
							//sPaginacion += "&nbsp; de &nbsp;" + iPaginas + "&nbsp; P&aacute;ginas&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>"
							//iPaginas,iRegistros
						sPaginacion += "</div>"
						sPaginacion += "<label class='col-md-2 control-label'>" 	
							sPaginacion += "<p class='text-left'>"
							sPaginacion += "de &nbsp;" + iPaginas + "&nbsp; P&aacute;ginas"
							iPaginas,iRegistros
						sPaginacion += "</p>"	
						sPaginacion += "</label>"
											
						//Primero,Siguiente,Atrás,Último
						sPaginacion += "<div class='col-md-2' align='center'>"
							if (iPaginas > 1) {
							
							sPaginacion += "<div class='dataTables_paginate paging_bootstrap'>"
							
								sPaginacion += "<ul id='pagination' class='pagination' style='margin-top:0px'>"
								
								  sPaginacion += "<li id='liPrimero' class=''>"
									sPaginacion += "<a id='refPrimero' title='Ir a la primera página' href='javascript:CambiaAPagina(1)'>"
										sPaginacion += "<i id='iPrimero' class='fa fa-angle-double-left'></i>"
									sPaginacion += "</a>"
								  sPaginacion += "</li>"
							
								  sPaginacion += "<li id='liAnterior' class=''>"
									sPaginacion += "<a id='refAnterior' title='Ir a la página anterior' href='javascript:CambiaAPagina(2)'>"
										sPaginacion += "<i id='iAnterior' class='fa fa-angle-left'></i>"
									sPaginacion += "</a>"
								  sPaginacion += "</li>"
							
								  sPaginacion += "<li id='liSiguiente' class=''>"
									sPaginacion += "<a id='refSiguiente' title='Ir a la página siguiente' href='javascript:CambiaAPagina(3)'>"
										sPaginacion += "<i id='iSiguiente' class='fa fa-angle-right'></i>"
									sPaginacion += "</a>"
								  sPaginacion += "</li>"
							
								  sPaginacion += "<li id='liUltimo' class=''>"
									sPaginacion += "<a id='refUltimo' title='Ir a la última página' href='javascript:CambiaAPagina(4)'>"
										sPaginacion += "<i id='iSiguiente' class='fa fa-angle-double-right'></i>"
									sPaginacion += "</a>"
								  sPaginacion += "</li>"
								  
								sPaginacion += "</ul>"
							
							sPaginacion += "</div>"
							
							sPaginacion += "<script type='text/javascript'>CambiaAPagina(1);</script>"
							}
						sPaginacion += "</div>"
	
						
							
					sPaginacion += "</div>"
				sPaginacion += "</div>"
			sPaginacion += "</div>"
			
		return sPaginacion		

	}
	


function ArmaEncabezados() {

	
	var sEncabezado  = "<table class='" + MGrdT_EstiloTabla + "'>"
		sEncabezado += "<thead>"
		sEncabezado += "<tr role='row'>"
		 
		if (MGrdT_TieneChecks==1) {		
			sEncabezado += "<th class='center' width='5px'>"
			sEncabezado += "<div class='checkbox-table' style='padding-left:0'>"
				sEncabezado += "<label>"
					sEncabezado += "<input name='chkT' id='chkT' type='checkbox' "
					sEncabezado += " onclick='javascript:CkTd()' class='flat-grey'>"
				sEncabezado += "</label>"
			sEncabezado += "</div>"
			sEncabezado += "</th>"		
		}
		/*
		<div class="checkbox">checkbox-table
			<label>
				<input type="checkbox" value="" class="grey">
				Checkbox 1
			</label>
		</div>

		if (MGrdT_TieneChecks==1) {
			sEncabezado += "<th width='20' class='center' >"
			sEncabezado += "<input name=\"chkT\" id=\"chkT\" type=\"checkbox\" onclick=\"javascript:CkTd()\" /></th>"
		}
		*/
		sEncabezado += "<th class='center' width='20' >Num.</th>"

	//var sConsultaGral = ""
	
	for(ig=0;ig<grdCampo.length;ig++){ 
			sEncabezado +="<th "
			if (grdAncho[ig] != "")	sEncabezado +=" width='" + grdAncho[ig] + "' "
			//if (grdAlineacion[ig] != "") sEncabezado +=" align='" + grdAlineacion[ig] + "' "
			//sEncabezado +=" align='center' "
			//if (grdClass[ig] != "")	
			sEncabezado +=" class='" + grdClass[ig] + "' "
			//sEncabezado += " class='center' "
			sEncabezado +=  ">" + grdNombre[ig] +"</th>"
	}
	
	//columna de ligas
	if ( iMWPuedeBorrar >= 1 || iMWPuedeEditar >= 1 || iMWPuedeSeleccionar >= 1 || iMW_PuedeSeleccionar >= 1) {
		sEncabezado +="<th class='center' width='80' align='center' >&nbsp;</th>"
	} else {
		sEncabezado +="<th>&nbsp;</th>"	
	}
	sEncabezado +="</tr>"
	sEncabezado +="</thead>"
	
	return sEncabezado

}

//function ProcesaBuscadorDeParametros(sValor) {
//	var sRespuesta = sValor
//	var arrPrm    = new Array(0)
//		
//	var iPos = sRespuesta.indexOf("{");
//	if (iPos > -1) {
//		var Antes = sRespuesta.substr(0, iPos);
//        var Despues = sRespuesta.substr(iPos  + 1, sRespuesta.length - iPos)
//		var iPos2 = Despues.indexOf("}");
//		var sParm = Despues.substr(0, iPos2);
//		var Despues = Despues.substr(iPos2 + 1, Despues.length - iPos2)
//		// resuelve el parametro
//		var arrPrm = sParm.split(",")
//		var sTmpPP = Parametro(arrPrm[0],arrPrm[1])
//		
////		if (EsVacio(sTmpPP)) {
////			sTmpPP = "0"
////		}
//		sRespuesta = Antes + sTmpPP + Despues
//		sRespuesta = ProcesaBuscadorDeParametros(sRespuesta)
//	} 
//	//Response.Write("JD=&nbsp;"+sRespuesta)
//	return sRespuesta
//	
//}

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
//	if (iIQonDebug > 0 || Parametro("IDUsuario",-1) == 1) {
//		Response.Write(" <br> " + sConsultaGral) 
//	}
  if (iIQonMuestraQueryPrincipal > 0) {
		Response.Write(" <br>883) " + sConsultaGral) 
  }

  try {
	var TipoRenglon = "even"
	sDatos = "<tbody>"
	sMsgError = "Ocurrio el error al intentar abrir el query"
	var rsINS = AbreTabla(sConsultaGral,1,MGrdT_Conexion)
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
			sDatos +="<tr class='" + TipoRenglon + "' >" 

			if (MGrdT_TieneChecks==1) {
				sDatos +="<td class='center' width='5px'>"				
					sDatos += "<div class='icheckbox_square-green' style='position: relative;'>"
					sDatos += "<input type='checkbox' class='i-checks' name='chkR' style='position: absolute; visibility: hidden;' " 
					sDatos += "data-parms='" + sValoresPrm + "' value='" + iRegistros + "'>"
					sDatos += "<ins class='iCheck-helper chkR' "
					sDatos += " style='position: absolute; top: 0%; left: 0%; display: block; width: 100%; height: 100%; margin: 0px; "
					sDatos += " padding: 0px; background: rgb(255, 255, 255); border: 0px; opacity: 0;' "
					sDatos += "></ins></div>"
				sDatos += "</td>"
			}
			
			/*
			if (MGrdT_TieneChecks==1) {
				sDatos +="<td height='24' align='center' class='center'>"
				sDatos +="<input name=\"chkR\" id=\"chkR\" type=\"checkbox\" "
				sDatos +=" class=\"chkR\" data-parms=\"" + sValoresPrm + "\" value=\"" + iRegistros + "\" /></td>"
				
			}
			*/
			
			sDatos +="<td height='24' align='center' class='center' >"
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
					
				//sDatos += "<td align='" + grdAlineacion[ig] + "' >"
				sValorDelCampo = "" + rsINS.Fields.Item( sNombreCampo ).Value
				if (EsVacio(sValorDelCampo)) { sValorDelCampo = ""  }
				sDatos += "<td "
				//if ( grdAlineacion[ig] != "" ) sDatos += " align='" + grdAlineacion[ig] + "'" 
				if ( grdClass[ig] != "" ) sDatos += " class='" + grdClass[ig] + "'"
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
							sDatos += "$ " + formato_numero(sValorDelCampo,2)
							//sDatos += PonerFormatoNumerico(FiltraVacios(sValorDelCampo),"$ ")
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
			sDatos += "<td nowrap ><div align='center'>"
//seccion de armado de llaves	
			sMsgError = "Ocurrio el error cuando se comenzaba a armar las llaves"		
			//var sValorCLL = rsINS.Fields.Item(sqCampoLlave).Value
			var sValorCLL = rsINS.Fields.Item(1).Value

			if (iMWPuedeBorrar >= 1 && Session("Borrar") == 1) {
				//sDatos += "&nbsp;&nbsp;<a class='btn btn-danger' "
				//sDatos += " href='javascript:grAccBorrar(" + sValorCLL + "," + iRegistros + ")'>"
				//sDatos += "<i class='icon-trash icon-white'></i>&nbsp;&nbsp;Borrar</a>&nbsp;&nbsp;"

				sDatos += "&nbsp;&nbsp;<a class='btn btn-xs btn-bricky tooltips' data-placement='top' data-original-title='Editar'"
				sDatos += " href='javascript:grAccBorrar(" + sValorCLL + "," + iRegistros + ")'>"
				sDatos += "<i class='fa fa-times fa fa-white'></i>"
				sDatos += "</a>"				
				
				
			} 
				
			if (iMWPuedeEditar >= 1 && Session("Editar") == 1) {		
				//sDatos += "&nbsp;&nbsp;<a class='btn btn-info' "
				//sDatos += " href='javascript:grAccEditar(" + sValorCLL + "," + iMWPuedeEditar + ")'>"
				//sDatos += "<i class='icon-edit icon-white'></i>&nbsp;&nbsp;Editar</a>&nbsp;&nbsp;"

				sDatos += "&nbsp;&nbsp;<a class='btn btn-xs btn-teal tooltips' data-placement='top' data-original-title='Editar'"
				sDatos += " href='javascript:grAccEditar(" + sValorCLL + "," + iMWPuedeEditar + ")'>"
				sDatos += "<i class='fa fa-edit'></i>"
				sDatos += "</a>"				
				
			}
			iMWPuedeSeleccionar=1
			if (iMWPuedeSeleccionar >= 1 && iMW_PuedeSeleccionar >= 1) {
				//sDatos += "&nbsp;&nbsp;<a class='btn btn-primary' "
				//sDatos += " href='javascript:grSelecciona(" + sValoresPrm + ")'>"
				//sDatos += "<i class='fa fa-eye'></i>&nbsp;&nbsp;Ver</a>&nbsp;&nbsp;"	
				
				sDatos += "&nbsp;&nbsp;<a class='btn btn-xs btn-green tooltips' data-placement='top' data-original-title='Seleccionar'"
				sDatos += " href='javascript:grSelecciona(" + sValoresPrm + ")'>"
				sDatos += "<i class='fa fa-share'></i>"
				sDatos += "</a>"
							
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
			sDatos +="<td height='24' align='center' class='" + TipoRenglon + "'>"
			sDatos +="<strong>" + iUltimoRengPintados + "</strong></td>"
			for(igr=0;igr<grdCampo.length;igr++){ 
				sDatos += "<td align='" + grdAlineacion[ig] + "' class='" + TipoRenglon + "' >&nbsp;</td>"	
			}
			sDatos += "<td align='center' class='" + TipoRenglon + "' >"
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
