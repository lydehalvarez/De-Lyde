<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../Includes/iqon.asp" -->
<%

//Variables para debuguear y manejo de la ficha
var biQ4Web = false
var iDebugSubQuerys = 0
var iIQonDebug = 0
//var iIQonSentNecesaria = 0
var AcabaDeBorrar = false

var MW_Al_Borrar_Ir_A = 0
var MW_AlBorrarDirigirAutomatico = 0

var iMFCInformativo = 0
var iOcultoTipo2 = 0    // Se usa para que exista un campo oculto cuando esta en modo consulta

iIQonDebug = ParametroDeVentanaConUsuario(SistemaActual,VentanaIndex,IDUsuario,"Debug",0)

//iIQonSentNecesaria = iIQonDebug


//Comenzando a cargar la ficha
//LimpiaValores()
//LeerParametrosdeBD() --JD
//EscribeParametrosdeBusquedaBD("")

//Variables para el manejo de la ficha Modo - Accion
var Accion = Parametro("Accion","Consulta")
var Modo = Parametro("Modo","Consulta")

var MFC_Conexion = 0

var ModoEntrada = Parametro("ModoEntrada","")
var sC = String.fromCharCode(34)  //Maneja la comilla doble "
var bRegistroNuevo = true
var Mensaje = ""

var SistemaActual = Parametro("SistemaActual",0)
var VentanaIndex  = Parametro("VentanaIndex",0)
var IDUsuario     = Parametro("IDUsuario",0)
var iWgCfgID      = Parametro("WgCfg_ID",Parametro("WgCfgID",0))
var iWgRsltdAcc   = "Consulto"

//Falta un debug que no puse

IniciaDebugBD()

var SistemaActual = Parametro("SistemaActual",0)
var mnuid = Parametro("VentanaIndex",0)
//Permisos de los botones a mostrar
var iMWPuedeAgregar = 0
var iMWPuedeEditar = 0
var iMWPuedeBorrar = 0

//ProcesaValorDefault
function ProcesaValorDefault(sValor) {
	
	var sRespuesta = sValor

	if (sRespuesta.substring(0,2) == "P,") {
		var iLargoVD = sRespuesta.length 
			//iLargoVD = iLargoVD - 2
		var sParamVD = sRespuesta.substring(2,iLargoVD)
		sRespuesta = "" + Parametro( sParamVD ,"")
	}

	return sRespuesta
	
}

//BorrarLLavePrincipal												 
function BorrarLLavePrincipal() {

	for (i=0;i<CampoNombre.length;i++) {
		if (CampoLLavePK[i] == 1 && CampoLLave[i] == 1) {
			CampoValor[i] = "-1"
			ParametroCambiaValor(CampoNombre[i], "-1")
		}
	}
			
}
												 
function CampoModoInformativo(iMFCFormato, sMFCCampo, sMFCValorDelCampo){
	
	//cuando esta en modo de edicion y entra como informativo lo pone sin poderse editar
	//si informativo viene en 2 ademas le pone un oculto
	//si viene como consulta y es oculto 2 lo pondra como texto mas su oculto
		
	//Response.Write(iMFCFormato + "&nbsp;" + sMFCCampo + "&nbsp;" + sMFCValorDelCampo)
																	  
	var sCampo = ""
				   
	if(iMFCInformativo == 0 || iMFCInformativo == 1) {
				   
		if(!EsVacio(sMFCValorDelCampo)) {		   
			sCampo = "<p class='SoloConsulta'>" + AplicaFormato(iMFCFormato,sMFCValorDelCampo)  + "</p>"
		} else {
			sCampo = "<p class='SoloConsulta'>&nbsp;</p>"
		}

		//sCampo = AplicaFormato(iMFCFormato,sMFCValorDelCampo)

	}

	if(iMFCInformativo == 2 || iOcultoTipo2 == 2){
		sCampo += " <input type='hidden'"  
		sCampo += " name='" + sMFCCampo + "'"
		sCampo += " id='" + sMFCCampo + "'" 
		sCampo += " value='" + sMFCValorDelCampo + "'>"	
	}
	
	return sCampo
	
}

// == ProcesaCondicionPorParametros(sParametros)
function ProcesaCondicionPorParametros(sParametros) {
	
	var arrOQPP    = new Array(0)
	var arrOQCampo = new Array(0)
	var bEnc       = false
	var sResultado = ""
	
	//validando formato de entrada
	if (sParametros.substring(0,4) == "SQL,") {
		var iLargoVD = sParametros.length 
		sResultado = "" + sParametros.substring(4,iLargoVD)
		sResultado = ProcesaBuscadorDeParametros(sResultado)
	} else {
		if (!EsVacio(sParametros) ) {  //se extraen los parametros que se envian
			arrOQPP = sParametros.split("|")
			for (oi=0;oi<arrOQPP.length;oi++) {	
				var Txt = String(arrOQPP[oi])
				var arrOQCampo = Txt.split(",")
				//Response.Write("<font class='text-danger' size='2'><strong>arrOQCampo &nbsp;" + arrOQCampo + "</strong></font> ")
				//pendiente falta poner el tipo de dato N=numero F=fecha T=texto para clavarle unas comillas o el formato de fecha
				//N
				var tA = ""
				var tB = ""
				if (arrOQCampo[3] == "T") {
					var tA = "'"
					var tB = "'"
				}
				var sTmpPP = Parametro(String(arrOQCampo[1]),String(arrOQCampo[2]))
				//Response.Write("<font class='text-danger' size='2'><strong>  campo  &nbsp;" + arrOQCampo[1] + "</strong></font>")
				//Response.Write("<font class='text-danger' size='2'><strong>  default  &nbsp;" + arrOQCampo[2] + "</strong></font>")
				//Response.Write("<font class='text-danger' size='2'><strong>  valor &nbsp;" + sTmpPP + "</strong></font><br />")
				if (sTmpPP != "" && sTmpPP != -1 ) {
					if (sResultado != "") { sResultado += " AND " }
					var sSimboloComp = " = "
					switch (arrOQCampo[4]) {
						case "G":			
							sSimboloComp = " > "
							break;
						case "L":			
							sSimboloComp = " < "
							break;
						case "GE":			
							sSimboloComp = " >= "
							break;
						case "LE":			
							sSimboloComp = " <= "
							break;
						case "D":			
							sSimboloComp = " <> "
							break;
						default:	
							sSimboloComp = " = "
							break;
					}
									
					sResultado += " " + arrOQCampo[0] + sSimboloComp + tA + "" + sTmpPP + tB
					
				}
			}
	
		}
	}

	return sResultado

}			

//SerializaCondicionPorParametros											  
function SerializaCondicionPorParametros(sParametros) {
		
		var arrOQPP    = new Array(0)
		var arrOQCampo = new Array(0)
		var bEnc       = false
		var sResultado = ""

		
		//validando formato de entrada
		if (!EsVacio(sParametros) ) { //se extraen los parametros que se envian
			arrOQPP = sParametros.split("|")
			for (oi=0;oi<arrOQPP.length;oi++) {	
				var Txt = String(arrOQPP[oi])
				var arrOQCampo = Txt.split(",")
				//pendiente falta poner el tipo de dato N=numero F=fecha T=texto para clavarle unas comillas o el formato de fecha
				//N
				var tA = ""
				var tB = ""
				if (arrOQCampo[3] == "T") {
					var tA = "'"
					var tB = "'"
				}

				var sTmpPP = Parametro(String(arrOQCampo[1]),String(arrOQCampo[2]))

				if (sTmpPP != "" && sTmpPP != -1 ) {
					if (sResultado != "") { sResultado += ", " }
					var sSimboloComp = " = "
			
					sResultado += tA + "" + sTmpPP + tB
				}

			}

		}

	return sResultado

}		
											  

										  
// 	ProcesaBuscadorDeParametros(sValor)										  
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
		sRespuesta = Antes + sTmpPP + Despues
		sRespuesta = ProcesaBuscadorDeParametros(sRespuesta)
	} 
	return sRespuesta
	
}



//1.- Leer el Widget a usar en el menu a trabajar {start}

var sSQLConfBase = " SELECT MW_Param, MW_PuedeAgregar, MW_PuedeBorrar, MW_PuedeEditar "
	sSQLConfBase += " ,MW_Al_Borrar_Ir_A, MW_AlBorrarDirigirAutomatico "	
	sSQLConfBase += " FROM Menu_Widget "
	sSQLConfBase += " WHERE Sys_ID = " + SistemaActual
	sSQLConfBase += " AND Mnu_ID = " + VentanaIndex
	sSQLConfBase += " AND Wgt_ID = 64 "  // + iWgID
	sSQLConfBase += " AND WgCfg_ID = " + iWgCfgID

	if (iIQonDebug == 1) { 	Response.Write("<br /><font class='text-danger' size='2'><strong>PASO I.-<br />"+sSQLConfBase +"</strong></font><br />")  }		

	var rsConfBase = AbreTabla(sSQLConfBase,1,2)
	
	if (iIQonDebug == 1) { Response.Write("<br /><font class='text-danger' size='2'><strong>EOF&nbsp;" + !rsConfBase.EOF + "</strong></font><br />") }
	
	if (!rsConfBase.EOF){
		
		iMWPuedeAgregar = rsConfBase.Fields.Item("MW_PuedeAgregar").Value
		iMWPuedeEditar  = rsConfBase.Fields.Item("MW_PuedeEditar").Value
		iMWPuedeBorrar  = rsConfBase.Fields.Item("MW_PuedeBorrar").Value
		MW_Al_Borrar_Ir_A = rsConfBase.Fields.Item("MW_Al_Borrar_Ir_A").Value
		MW_AlBorrarDirigirAutomatico = rsConfBase.Fields.Item("MW_AlBorrarDirigirAutomatico").Value	
		
	}
	
	rsConfBase.Close()
	
var sCondicionGeneral = ""
var sOrdenadoPor = ""
var sysid = SistemaActual
var mnuid = VentanaIndex

//Debug para las variables del manejo de la ficha
if (iIQonDebug == 1) {	

	Response.Write("<br /><font class='text-danger' size='2'><strong>Accion&nbsp;=&nbsp;" + Accion + "|&nbsp;Modo&nbsp;=&nbsp;" + Modo + "&nbsp;|SistemaActual&nbsp;=&nbsp;"+SistemaActual +"|&nbsp;mnuid&nbsp;=&nbsp;" + mnuid + "</strong></font><br />")

}
//1.- Leer el Widget a usar en el menu a trabajar {end}


//2.- Verificamos que tabla se va a manejar de la tabla MenuFichaTabla {start}

	var sTabla = ""
	var SQLCondicion = ""
	var sOrdenadoPor = ""
	var	sMFC_SinPK_Ir_A = 0
	var sMFC_MensajeError = ""
	var iSQLVieneDeBuscador = 0
	
	var sCondicionPorParametro = ""  //   para arreglo de condiciones posicion: 1=campo, 2=nombreparametreo, 3=ValorDefault separado por comas y pipes
									//    ejemplos; Cli_ID,Cli_ID,-1|Cont_ID,Cont_ID,-1|Dir1_ID,Cli_ID,-1 este ultimo transfiero a dir1 el valor de cliid		

	var sFCHTabla = "SELECT * "
		sFCHTabla += " FROM MenuFichaTabla "
		sFCHTabla += " WHERE Sys_ID = " + SistemaActual
		sFCHTabla += " AND WgCfg_ID = " + iWgCfgID
		//sFCHTabla += " AND Mnu_ID = " + mnuid
		sFCHTabla += " AND MFS_ID = 1 "  //campo experimental para poner una tabla diferente por seccion, ahora solo funciona un solo registro por menu
		if (iIQonDebug == 1) {	
			Response.Write("<br /><font class='text-danger' size='2'><strong>PASO II.-<br />" + sFCHTabla +  "</strong></font>")
		}
		
	var rsTabla = AbreTabla(sFCHTabla,1,2)
	
	 	if (iIQonDebug == 1) { Response.Write("<br /><font class='text-danger' size='2'><strong>EOF&nbsp;" + !rsTabla.EOF + "</strong></font><br />") }
		
		if (!rsTabla.EOF) {	
			sTabla = rsTabla.Fields.Item("MFC_Tabla").Value
			SQLCondicion = FiltraVacios(rsTabla.Fields.Item("MFC_CondicionGeneral").Value)
			sOrdenadoPor = FiltraVacios(rsTabla.Fields.Item("MFC_OrdenadoPor").Value)
			sCondicionPorParametro = FiltraVacios(rsTabla.Fields.Item("MFC_CondicionPorParametro").Value)
			iSQLVieneDeBuscador = rsTabla.Fields.Item("MFC_VieneDeBuscador").Value
			sMFC_SinPK_Ir_A = FiltraVacios(rsTabla.Fields.Item("MFC_SinPK_Ir_A").Value)
			sMFC_MensajeError = FiltraVacios(rsTabla.Fields.Item("MFC_MensajeError").Value)
			MFC_Conexion = rsTabla.Fields.Item("MFC_Conexion").Value	
					
			if (Parametro("ModoEntrada","") == "") {
				ModoEntrada = rsTabla.Fields.Item("MFC_ModoEntrada").Value
				ParametroCambiaValor("ModoEntrada", ModoEntrada)
			} 
	
			var VPV = 0
			/*var VPV = Parametro("VeZ",0)
			if (Parametro("VeZ",0) == 0) { Accion = rsTabla.Fields.Item("MFC_AccionEntrada").Value Modo = rsTabla.Fields.Item("MFC_ModoEntrada").Value
			}*/
		}	
		rsTabla.Close()	

	if (iIQonDebug == 1) {
		
		Response.Write("<br /><font class='text-danger' size='2'><strong>&nbsp;<====== Tabla a manejar {start} ======></strong></font><br /><br />")
		Response.Write("<font class='text-danger' size='2'><strong>&nbsp;&nbsp;sTabla:&nbsp;" + sTabla + "</strong></font><br />")
		Response.Write("<font class='text-danger' size='2'><strong>&nbsp;&nbsp;SQLCondicion:&nbsp;" + SQLCondicion + "</strong></font><br />")
		Response.Write("<font class='text-danger' size='2'><strong>&nbsp;&nbsp;sOrdenadoPor:&nbsp;" + sOrdenadoPor + "</strong></font><br />")
		Response.Write("<font class='text-danger' size='2'><strong>&nbsp;&nbsp;sCondicionPorParametro:&nbsp;" + sCondicionPorParametro + "</strong></font><br />")
		Response.Write("<font class='text-danger' size='2'><strong>&nbsp;&nbsp;iSQLVieneDeBuscador:&nbsp;" + iSQLVieneDeBuscador + "</strong></font><br />")
		Response.Write("<br /><font class='text-danger' size='2'><strong>&nbsp;<====== Tabla a manejar {end} ======></strong></font><br /><br /><br />")	
		
	}

//2.- Verificamos que tabla se va a manejar de la tabla MenuFichaTabla {end}

//3.- Verificamos la tabla de MenuFichaCampos para el manejo de la información (se considero manejar arreglos) {start}

var arrCamposATrabajar = new Array(0)
var iCamposLL = -1    
var bLlavesVacias = true
var acnCOnt = -1               
var arrCMPNMBInsertar    = new Array(0)
var CampoNombre      = new Array(0)
var CampoPP          = new Array(0)
var CampoLLave       = new Array(0)
var CampoLLavePK     = new Array(0)
var CampoValor       = new Array(0)
var CampoFormato     = new Array(0)
var CampoCondicion   = new Array(0)
var CampoOculto      = new Array(0)
var CampoInformativo = new Array(0)

//Arreglos para el manejo de los valores de los campos - MenuFichaCampos - {end}

var sLLavePrimaria = ""
var sLLavePrimariaCampo = ""
var sLLavePrimariaValor = -1
var sLLavePrimariaHeredada = ""
var GFINSRT = Parametro("GFINSRT",0)  	//grabacion forzada hacer insert

var arCampos = new Array(0)
var MFC_EsOculto = new Array(0)			//para el control de campos ocultos
var MFC_EsPKPrincipal = ""				//Indica que es la llave principal, solo debe haber una
var MFC_EsPK = new Array(0)				//Indica si hay mas llaves en la tabla

var iPos = 0
var iPosO = 0

//=========== Manejo de la tabla MenuFichaCampos como de la tabla ParametrosPermanentes {start} ======================

var sFCHCampos = "SELECT * "
	sFCHCampos += " ,ISNULL((SELECT PP_Nombre "
	sFCHCampos +=            " FROM ParametrosPermanentes "
	sFCHCampos +=            " WHERE ParametrosPermanentes.PP_Nombre = MenuFichaCampos.MFC_Campo "
	sFCHCampos +=            " AND Sys_ID = " + SistemaActual 
	sFCHCampos +=            " AND PP_Seccion = (SELECT Mnu_UsarPP from Menu "
	sFCHCampos +=                                " WHERE Sys_ID = " + SistemaActual
	sFCHCampos +=                                " AND Mnu_ID = " + VentanaIndex + ") " 
	sFCHCampos +=            " AND PP_Habilitado = 1),'No') AS PP "  //mapeo los campos contra los parametros permanentes
	sFCHCampos += " FROM MenuFichaCampos "
	sFCHCampos += " WHERE MFC_Habilitado = 1 "
	//sFCHCampos += " AND MFC_Informativo = 0 "
	sFCHCampos += " AND Sys_ID = " + SistemaActual
	sFCHCampos += " AND WgCfg_ID = " + iWgCfgID
	//sFCHCampos += " AND Mnu_ID = " + mnuid
	if (iIQonDebug == 1) {	
		Response.Write("<font class='text-danger' size='2'><strong>Manejo de los campos a mostrar en la ficha, as&iacute; como los parametros permanentes a manejar<br />&nbsp;" + sFCHCampos + "</strong></font><br />") 
	}

   var rsCampos = AbreTabla(sFCHCampos,1,2)
   		while (!rsCampos.EOF){
			iCamposLL++           
			CampoNombre[iCamposLL]      = rsCampos.Fields.Item("MFC_Campo").Value
			CampoPP[iCamposLL]          = rsCampos.Fields.Item("PP").Value  //Parametros Permanentes
			CampoLLave[iCamposLL]       = rsCampos.Fields.Item("MFC_EsPK").Value
			CampoLLavePK[iCamposLL]     = rsCampos.Fields.Item("MFC_EsPKPrincipal").Value
			CampoInformativo[iCamposLL] = rsCampos.Fields.Item("MFC_Informativo").Value
			
			var sTmpDF = FiltraVacios(rsCampos.Fields.Item("MFC_ValorDefault").Value)	
				sTmpDF = ProcesaValorDefault(sTmpDF)
		
			CampoValor[iCamposLL]  = FiltraVacios(Parametro(CampoNombre[iCamposLL],"" +sTmpDF))
			//Response.Write("<br> el valor del campo " + CampoNombre[iCamposLL] + " es " +CampoValor[iCamposLL])
			CampoFormato[iCamposLL]    = "N"
			CampoCondicion[iCamposLL]  = rsCampos.Fields.Item("MFC_EsPK").Value 
			 
			CampoOculto[iCamposLL]     = rsCampos.Fields.Item("MFC_EsOculto").Value
			if (CampoPP[iCamposLL] != "No") {
				CampoOculto[iCamposLL] = 1
			}

		rsCampos.MoveNext()
	}
		
	rsCampos.Close()	

//=========== Manejo de la tabla MenuFichaCampos como de la tabla ParametrosPermanentes {end} ======================

	var arrCampo      = new Array(0)
	var arrPrmCPP     = new Array(0)
	var bEnc = false

//=========== Manejo de de la Condición por parametros de la tabla MenuFichaCampos {start} ===========

	if (!EsVacio(sCondicionPorParametro) ) {
		
		arrPrmCPP = sCondicionPorParametro.split("|")
		for (j=0;j<arrPrmCPP.length;j++) {
			bEnc = false
			var Txt = String(arrPrmCPP[j])
			var arrCampo = Txt.split(",")
			for (fi=0;fi<=CampoNombre.length;fi++) {
				
				if (iIQonDebug == 5) {	
					Response.Write("<br />campo " + fi + ")- campo_nombre&nbsp;" + CampoNombre[fi] + "<br />") 
				}
				if (CampoNombre[fi] == arrCampo[0]) {			
					bEnc = true
					CampoCondicion[fi] = 1
					if (arrCampo[1] == "") {
						var sValTmp = String(arrCampo[2])
						ParametroCambiaValor(arrCampo[0], String(arrCampo[2]))
					} else {
						var sValTmp = Parametro(String(arrCampo[1]),String(arrCampo[2])) 
					}   		
					CampoValor[fi] = String(sValTmp)
					CampoFormato[fi] = String(arrCampo[3])
					
					if (iIQonDebug == 5) {	
						Response.Write("<br /><font class='text-danger' size='2'><strong>--encontrado en " + fi + ") CampoNombre&nbsp;" + CampoNombre[fi] + " con valor de " + CampoValor[fi] + " es llave " + CampoLLave[fi] +"</strong></font><br />") 
					}
				}
			}
			
			if (!bEnc) {
				iCamposLL++
				CampoNombre[iCamposLL]      = arrCampo[0]
				CampoCondicion[iCamposLL]   = 1
				CampoPP[iCamposLL]          = 0
				CampoLLave[iCamposLL]       = 0
				CampoLLavePK[iCamposLL]     = 0
				CampoInformativo[iCamposLL] = 0
				if (arrCampo[1] == "") {
					CampoValor[iCamposLL] = String(arrCampo[2])
					ParametroCambiaValor(arrCampo[0], String(arrCampo[2]))
				} else {
					CampoValor[iCamposLL] = Parametro(String(arrCampo[1]),String(arrCampo[2]))
				}
				CampoFormato[iCamposLL]   = arrCampo[3]	
				if (iIQonDebug == 5) { 
					Response.Write("<br /><font class='text-danger' size='2'><strong>---no encontrado&nbsp;" + iCamposLL + ") CampoNombre&nbsp;" + CampoNombre[iCamposLL]+"</strong></font><br />")
				}		
			}
		}

	}

//=========== Manejo de de la Condición por parametros de la tabla MenuFichaCampos {end} ===========

var iContPK = 0
var iContLL = 0

	//Manejo de nombres de los campos {start}
	for (i=0;i<CampoNombre.length;i++) {
		//Response.Write("<br> " + i + ") " + CampoNombre[i])
		//Response.Write("<br> llave " + i + ") " + CampoNombre[i])
		if (CampoLLavePK[i] == 1) {
			if(EsVacio(CampoValor[i])){ CampoValor[i] = "-1" }
			sLLavePrimaria = " " +  CampoNombre[i] + " = " + CampoValor[i] + " "
			sLLavePrimariaCampo = CampoNombre[i]
			sLLavePrimariaValor = CampoValor[i]
			bLlavesVacias = false
			iContPK++
		}
		
		if (CampoLLavePK[i] == 0 && CampoLLave[i] == 1) {
			if (!EsVacio(CampoValor[i]) && CampoValor[i] != "-1") {		
				if (sLLavePrimariaHeredada != "" ) { sLLavePrimariaHeredada += " AND " }
				sLLavePrimariaHeredada += " " + CampoNombre[i] + " = " + CampoValor[i] + " "
				bLlavesVacias = false
				iContLL++
			} 
		
		}
	
		//pendiente falta poner el tipo de dato N=numero F=fecha T=texto para clavarle unas comillas o el formato de fecha
	}

	var sConsultaExtra = ""
	
	for (i=0;i<CampoNombre.length;i++) {
		if (CampoLLavePK[i] == 0 && CampoLLave[i] == 0) {
			if (CampoCondicion[i] == 1) {
				if (sConsultaExtra != "" ) { sConsultaExtra += " AND " }
				sConsultaExtra +=  " " +  CampoNombre[i] + " = " + CampoValor[i] + " "
			}
		}
	}
	//=========== Manejo de nombres de los campos {end}
	
	//{1.- start}
	if (iContLL == 0 && iContPK > 0) { bLlavesVacias = false } 

	if (EsVacio(SQLCondicion)) { SQLCondicion = "" }
	if (SQLCondicion != "" && sLLavePrimariaHeredada != "") { SQLCondicion += " AND " }
		SQLCondicion += sLLavePrimariaHeredada
	
	if (SQLCondicion != "" && sConsultaExtra != "") { SQLCondicion += " AND " }
		SQLCondicion += sConsultaExtra
	
	if (iIQonDebug == 1) {	Response.Write("<br /><font class='text-danger' size='2'><strong>SQLCondicion&nbsp;=" + SQLCondicion+"</strong></font><br />") }
	if (iIQonDebug == 1) {	Response.Write("<br /><font class='text-danger' size='2'><strong>sLLavePrimaria&nbsp;=" + sLLavePrimaria + "</strong></font><br />") }

	var sCondCamp = SQLCondicion 
	if (sCondCamp != "" && sLLavePrimaria != "") { sCondCamp += " AND " }
		sCondCamp += sLLavePrimaria

	if (sCondCamp != "") {
		sCondCamp = " WHERE " + sCondCamp
	}
	//{1.- end}

	var bRecienGuardado = false
	
	function ArmaCamposATrabajar(sModo) {
	
		var iPos = 0;
	
		for (i=0;i<CampoNombre.length;i++) {
			if (CampoInformativo[i] == 0) {
				arrCamposATrabajar[iPos] = CampoNombre[i]
				iPos++
			}
			if (CampoInformativo[i] == 2 && sModo == "Insertar") {
				arrCamposATrabajar[iPos] = CampoNombre[i]
				iPos++
			}
			if (CampoInformativo[i] == 3 && sModo == "Actualizar") {
				arrCamposATrabajar[iPos] = CampoNombre[i]
				iPos++
			}
		}
	
	}
	//=========== Manejo de nombres de los campos {end}

	//=========== Acciones de la ficha para el manejo de la misma ========= A-Altas | B-Bajas | C-Cambios =========== {start}
		
	if (Accion != "Vuelta") { 
		//Cuando la acción es Guardar
		if (Accion == "Guardar") {
		//AgregaDebugBD("entre guardando accion = ",Accion )
			bRecienGuardado = true
			//bParametrosDeAjaxaUTF8=true
			//AgregaDebugBD("GFINSRT = ",GFINSRT )
			if (GFINSRT == 1) {
				ArmaCamposATrabajar("Insertar")
				//Response.Write(arrCamposATrabajar)
				BDInsert(arrCamposATrabajar,sTabla,"",MFC_Conexion)
				ParametroCambiaValor("GFINSRT",0)
				iWgRsltdAcc = "Inserto"
			} else {	//Si la llave(s) principal(es) es -1
				//AgregaDebugBD("sLLavePrimariaCampo = ",sLLavePrimariaCampo )
				//AgregaDebugBD("sLLavePrimariaValor = ",sLLavePrimariaValor )
				if (Parametro(sLLavePrimariaCampo,sLLavePrimariaValor) == -1) {  
					//if (Session("Agregar") == 1) {
						//AgregaDebugBD("agregando = ","" )
						LlaveABuscar = SiguienteID(sLLavePrimariaCampo,sTabla, SQLCondicion ,0)

						ParametroCambiaValor(sLLavePrimariaCampo, LlaveABuscar)
						ArmaCamposATrabajar("Insertar")
						BDInsert(arrCamposATrabajar,sTabla,"",MFC_Conexion)
						sLLavePrimaria = sLLavePrimariaCampo + " = " + LlaveABuscar
						iWgRsltdAcc = "Inserto"
					//}
				} else {	//Si la llave(s) principal(es) es > -1
				//AgregaDebugBD("editando = ","" )
					//if (Session("Editar") == 1) { 
						ArmaCamposATrabajar("Actualizar")
						BDUpdate(arrCamposATrabajar,sTabla,sCondCamp,MFC_Conexion)
						iWgRsltdAcc = "Edito"   
					//}
				}
			}
						
			Accion = "Consulta"
			Modo = "Consulta"
			Mensaje = "El registro fu&eacute; guardado correctamente"
			ParametroCambiaValor("Modo", "Consulta")
			ParametroCambiaValor("Accion", "Consulta")
		}	
		if (Accion == "Borrar") {  //Cuando la acción es Borrar
			BDDelete(CampoNombre,sTabla,sCondCamp,MFC_Conexion)
			//Response.Write("sSQLMod&nbsp;" + sSQLMod + "<br>")	
			Mensaje = "El registro fu&eacute; borrado correctamente"
			Accion = "Consulta"
			Modo = "Borrado"
			AcabaDeBorrar = true
			ParametroCambiaValor("Accion", "Consulta")
			ParametroCambiaValor("Modo","Borrado")
			BorrarLLavePrincipal()		
			
		}
		if (Accion == "Nuevo") {	//Cuando la acción es Nuevo
			LlaveABuscar = -1
			ParametroCambiaValor(sLLavePrimariaCampo, LlaveABuscar)
			ParametroCambiaValor("Accion", "Consulta")
			Accion = "Consulta"
		}	
	
	}
	
	//=========== Acciones de la ficha para el manejo de la misma ========= A-Altas | B-Bajas | C-Cambios =========== {end}
	
	//=========== Manejo de la carga de datos por medio de sentencia vía SQL así como de la tabla correspondiente a manejar === {start}
	if(Accion != "Vuelta" ) {	

		//Cargado de Datos via sentencias SQL
		
			var sOtroQry = "SELECT * "
				sOtroQry += " FROM MenuFichaQuery "
				sOtroQry += " WHERE MFQ_Habilitado = 1 "
				sOtroQry += " AND Sys_ID = " + SistemaActual
				sOtroQry += " AND WgCfg_ID = " + iWgCfgID
				//sOtroQry += " AND Mnu_ID = " + mnuid
				sOtroQry += " Order By MFQ_Orden"
				
				if (iIQonDebug == 1) {
					Response.Write("<font class='text-danger' size='2'><strong>CargadodeDatosviasentenciasSQL - MenuFichaQuery&nbsp;&nbsp;<br />" + sOtroQry + "</strong></font><br />")
				}
				
			var rsOtroQry = AbreTabla(sOtroQry,1,2) 
			
			while (!rsOtroQry.EOF){	
			
				var MFQ_Query      = FiltraVacios(rsOtroQry.Fields.Item("MFQ_Query").Value)
				var MFQ_Condicion  = FiltraVacios(rsOtroQry.Fields.Item("MFQ_Condicion").Value)
				var MFQ_Parametros = FiltraVacios(rsOtroQry.Fields.Item("MFQ_Parametros").Value)
				var MFQ_QueryFinal = FiltraVacios(rsOtroQry.Fields.Item("MFQ_QueryFinal").Value)
				var MFQ_TipoQuery  = FiltraVacios(rsOtroQry.Fields.Item("MFQ_TipoQuery").Value)
				
				if (MFQ_TipoQuery == "Q") {
				
					var sCondicionPorParametros = ""
						sCondicionPorParametros = ProcesaCondicionPorParametros(MFQ_Parametros)
			
					if (MFQ_Condicion != "") {
						if (sCondicionPorParametros != "") {
							MFQ_Condicion += " AND "
						}
					} 	
						
					MFQ_Condicion += sCondicionPorParametros
					
					if (MFQ_Condicion != "") {
							MFQ_Query += " WHERE " + MFQ_Condicion
					} 
							
					MFQ_Query += " " + MFQ_QueryFinal	
					
					MFQ_Query = ProcesaBuscadorDeParametros(MFQ_Query)
					
					if (iDebugSubQuerys == 1) {
						Response.Write("<font color='red' size='2'><strong>Query Armado &nbsp;" + MFQ_Query + "</strong></font><br />")
					}
					bHayParametros = false
					ParametroCargaDeSQL(MFQ_Query,MFC_Conexion)
				}
				
				if (MFQ_TipoQuery == "FN") {
					
					var sCondicionPorParametros = ""
						sCondicionPorParametros = SerializaCondicionPorParametros(MFQ_Parametros)		
					
					var MFQ_QueryPD = ""
					var pos = MFQ_Query.indexOf(" as ")
					var pos2 = MFQ_Query.indexOf(" * ")
					if (pos>0 && pos2 == -1) {
						MFQ_QueryPD = MFQ_Query.substring(pos , MFQ_Query.length);
						MFQ_Query = MFQ_Query.substring(0,pos)
					}			
					MFQ_Query += "(" + sCondicionPorParametros + ") " + MFQ_QueryPD + " " + MFQ_QueryFinal	
					if (iDebugSubQuerys == 1) {
						Response.Write("<font class='text-danger' size='2'><strong>FN - FN - Escalar &nbsp;" + MFQ_Query + "</strong></font><br />")
					}
		
					bHayParametros = false
					ParametroCargaDeSQL(MFQ_Query,MFC_Conexion)
				}
				
				if (MFQ_TipoQuery == "SP") {
					
					var sCondicionPorParametros = ""
						sCondicionPorParametros = SerializaCondicionPorParametros(MFQ_Parametros)		
			
					MFQ_Query += "  " + sCondicionPorParametros 	
					
					var rsQrySP = AbreTabla(MFQ_Query,1,MFC_Conexion) 
				
					if (iDebugSubQuerys == 1) {
						Response.Write("<font class='text-danger' size='2'><strong>SP - Stored Procedure &nbsp;" + MFQ_Query + "</strong></font><br />")
					}		
				}
				
				rsOtroQry.MoveNext()
			}	
			
			rsOtroQry.Close()
		
		//Carga la informacion que contendran los objetos
		var sConsultaSQL = "SELECT * "
			sConsultaSQL += " FROM " + sTabla
			if (SQLCondicion != "" || sLLavePrimaria != "" ) { sConsultaSQL += " WHERE " }
			sConsultaSQL += sLLavePrimaria
			if (SQLCondicion != "" && sLLavePrimaria != "" ) { sConsultaSQL += " AND " }
			sConsultaSQL += SQLCondicion
			
				if (iIQonDebug == 1) {	
					Response.Write("<br /><font class='text-danger' size='2'><strong>sTabla=&nbsp;" + sTabla + "</strong></font><br />")	 
					Response.Write("<font class='text-danger' size='2'><strong>sLLavePrimaria=&nbsp;" + sLLavePrimaria + "</strong></font><br />")
					Response.Write("<font class='text-danger' size='2'><strong>SQLCondicion=&nbsp;" + SQLCondicion + "</strong></font><br />")	
				}
				
		
			if (iIQonDebug == 1) {	
				Response.Write("<font class='text-danger' size='2'><strong>Sentencia principal a manejar&nbsp;</strong></font><br /><br /><font class='text-danger' size='3'><strong>" + sConsultaSQL + "&nbsp;/&nbsp;bLlavesVacias=&nbsp;"+bLlavesVacias+"</font></strong><br />")	
				Response.Write("<font class='text-danger' size='2'><strong>iIQonDebug&nbsp;" + iIQonDebug + "&nbsp;IDUsuario&nbsp;" + Parametro("IDUsuario",Session("IDUsuario")) +"</font></strong><br /><br />")
			}

			AgregaDebugBD("sql ficha carga inicial",sConsultaSQL )
			bHayParametros = false
			ParametroCargaDeSQL(sConsultaSQL,MFC_Conexion)
			//Response.Write(bLlavesVacias)
			
	} 
	//=========== Manejo de la carga de datos por medio de sentencia vía SQL así como de la tabla correspondiente a manejar === {end}
	
	GFINSRT = 0
	ParametroCambiaValor("GFINSRT", 0)	

	if (Parametro(sLLavePrimariaCampo,sLLavePrimariaValor) == -1) {
		
		var Modo = "Editar"
		var Accion =  "Consulta"
		ParametroCambiaValor("Modo", Modo)
		ParametroCambiaValor("Accion", Accion)  //forzar a nuevo 
		bRegistroNuevo = true
			
	} else {
		
		bRegistroNuevo = false
		//Valido si el registro existe de lo contrario cambio a modo nuevo
		if (Accion != "Vuelta" && !bRecienGuardado) {
			var sSQLCondYE = "" + sLLavePrimaria
			if (sSQLCondYE != "" && sConsultaExtra != "") { sSQLCondYE += " AND " }
			sSQLCondYE += sConsultaExtra
			if (sSQLCondYE != "" && sLLavePrimariaHeredada != "" ) { sSQLCondYE += " AND " }
			sSQLCondYE += sLLavePrimariaHeredada
			//AgregaDebugBD("sSQLCondYE",sSQLCondYE )
			var uYaExiste = BuscaSoloUnDato("Count(*)",sTabla,sSQLCondYE,0,MFC_Conexion)
			if (uYaExiste == 0) {
				//AgregaDebugBD("entro nuevo reg con llave primaria != -1",sSQLCondYE)
				var Modo = "Editar"
				var Accion =  "Consulta"
				ParametroCambiaValor("Modo", Modo)
				ParametroCambiaValor("Accion", Accion)  //forza a nuevo 
				GFINSRT = 1
				ParametroCambiaValor("GFINSRT", 1)
				bRegistroNuevo = true
			}
		}
	}
	
	//================ {Llaves - start} ======================
	 
	if (bLlavesVacias) {   //Cuando las llaves estan vacías se levanta una ventana de error
		
		if (sMFC_MensajeError == "" ) { sMFC_MensajeError = sConsultaSQL }
		
		var sErrMsg  = "<p id='MsgBoxTitulo'><strong>Error:</strong></p>"
			sErrMsg += "<p>" + sMFC_MensajeError + "<br><br>"

			if (sMFC_SinPK_Ir_A > 0) {
				sErrMsg += "<a href='javascript:CambiaTab(" + sMFC_SinPK_Ir_A + ");'>Haga click aqu&iacute; para ir a la ventana sugerida</a></p>"
			}
	
			//sErrMsg  = "error"
	
		var sError = ""
			sError += "<script language='JavaScript'>"
			//sError += "$(function() {$.msgbox('" + sErrMsg + "', {type: 'error'});});"
			sError += "</script>"
			//Response.Write( sError )
				
	} else {  //Comienza la impresión de las fichas....
		
		//Response.Write("Vamos a empezar a armar todo....")
		//AgregaDebugBD("Modo = " + Modo,"Accion = " + Accion )
		Response.Write(ArmaMarco())
		
		var campocul = ImprimeOcultos()
		Response.Write("<br> " + campocul)

	}
	//================ {Llaves - end} ======================

	function ImprimeOcultos() {
	
		var sCamposOcultos = ""
		
			//para cargar al final los campos ocultos
		var sFCOcultos = "SELECT * "
			sFCOcultos += " ,ISNULL((SELECT PP_Nombre "
			sFCOcultos +=           " FROM ParametrosPermanentes "
			sFCOcultos +=           " WHERE ParametrosPermanentes.PP_Nombre = MenuFichaCampos.MFC_Campo "
			sFCOcultos +=           " AND Sys_ID = " +  SistemaActual 
			sFCOcultos +=           " AND PP_Seccion = (SELECT Mnu_UsarPP from Menu "
			sFCOcultos +=                                " WHERE Sys_ID = " + SistemaActual
			sFCOcultos +=                                " AND Mnu_ID = " + VentanaIndex + ") " 
			sFCOcultos +=           " AND PP_Habilitado = 1),'No') AS PP "  //mapeo los campos contra los parametros permanentes
			sFCOcultos += " FROM MenuFichaCampos "
			sFCOcultos += " WHERE MFC_Habilitado = 1 "
			sFCOcultos += " AND Sys_ID = " + SistemaActual
			sFCOcultos += " AND WgCfg_ID = " + iWgCfgID
			//sFCOcultos += "  AND Mnu_ID = " + mnuid
			sFCOcultos += " AND MFC_EsOculto = 1 "
	
		var rsOcultos = AbreTabla(sFCOcultos,1,2)
	
		while (!rsOcultos.EOF){
			sNombreCampo = "" + rsOcultos.Fields.Item("MFC_Campo").Value
			sValorDefault = "" + rsOcultos.Fields.Item("MFC_ValorDefault").Value
			sValorDefault = ProcesaValorDefault(sValorDefault)
			
			ValorDelCampo = Parametro( sNombreCampo , sValorDefault )
			if (EsVacio(ValorDelCampo))  { ValorDelCampo = -1 }
			if (rsOcultos.Fields.Item("PP").Value == "No" ) {
				sCamposOcultos += " <input type='hidden' name='" + sNombreCampo + "' id='" + sNombreCampo + "'"
				sCamposOcultos += " value='" + ValorDelCampo + "'> "
			}	
			if (rsOcultos.Fields.Item("PP").Value != "No" ) {
				sCamposOcultos += " <input type='hidden' name='pp_" + sNombreCampo + "' id='pp_" + sNombreCampo + "'"
				sCamposOcultos += " value='" + ValorDelCampo + "'> "
			}			
			rsOcultos.MoveNext()
		}	
	
		rsOcultos.Close()
		
		sCamposOcultos += " <input type='hidden' name='GFINSRT' id='GFINSRT' value='" + GFINSRT + "'> "
		sCamposOcultos += " <input type='hidden' name='WgCfgID' id='WgCfgID' value='" + iWgCfgID + "'> "
		sCamposOcultos += " <input type='hidden' name='ModoEntrada' id='ModoEntrada' value='" + ModoEntrada + "'> "
		sCamposOcultos += " <input type='hidden' name='iWgRsltdAcc' id='iWgRsltdAcc' value='" + iWgRsltdAcc + "'> "
		
		return sCamposOcultos
				
	}

	function ArmaMarco() {
	
		var siQ4WebTipofrm = "form-horizontal"
		var siQ4WebID = "frmFicha"
		var siQ4WebNombre = "frmFicha"
		
		//Agregar estos campos a la tabla de Widget_Configuracion 
		//... yo los pondria en la tabla de menu_tabla, lo platicamos rog 7/4/2016
		//12 columnas manejo de Bootstrap	
	
		var sG = ""
		//form - frm a manejar la ficha {start}
		sG = "<div class='" + siQ4WebTipofrm + "' id='" + siQ4WebID + "' name='" + siQ4WebNombre + "'>"

			if(!AcabaDeBorrar) {
				sG += CargaBotones()
			}
			
				//Manejo del mensaje al termino de guardar un registro, verificar los estilos para que se cambie 
				//el renglon del aviso.
				if (Mensaje != ""){ 
					
				
				sG += "<div class='ibox'>"
					sG += "<div class='ibox-content' style='padding-bottom: 0px;'>"
				
						sG += "<div id='mensaje' class='form-group' style='padding:0px 30px 0px 30px;'>"

							sG += "<div class='alert alert-success'>"

								sG += "<button data-dismiss='alert' class='close'>"
								sG += "&times"
								sG += "</button>"
								sG += "&nbsp;<i class='fa fa-check-circle'></i>"
								sG += "&nbsp;<strong>Aviso!</strong>&nbsp;" + Mensaje  

								if(AcabaDeBorrar) {

									if(MW_Al_Borrar_Ir_A > 0){

										if(MW_AlBorrarDirigirAutomatico == 0){
											sG += "<br><br><a href='javascript:CambiaTab(" + MW_Al_Borrar_Ir_A + ")'>Regresar</a>"
										} else {
											if ( MW_AlBorrarDirigirAutomatico < 5){ MW_AlBorrarDirigirAutomatico = 5 }
											sG += "<script type='text/javascript'>"
											sG += "var regresaventana;"
											sG += " regresaventana = setTimeout(CambiaTab(" + MW_Al_Borrar_Ir_A + "), " 
											sG +=  MW_AlBorrarDirigirAutomatico + "000);"
											sG += "</script>"
										}
									}

								}

							sG += "</div>"

							Mensaje = ""

						sG += "</div>"
																			   
					sG += "</div>"														   
				sG += "</div>"															   
																			   
					
				}

				if(!AcabaDeBorrar) {
					sG += CargaDatos() 
				}
			
		sG += "</div>"
		//form - frm a manejar la ficha {end}
	
		return sG
		
	}
	
	// ====== Carga de botones ====== {start}
	function CargaBotones() {
	
		var sBot = ""
																			   
																			   
			sBot += "<div class='ibox'>"  //ibox {start}
			
				sBot += "<div class='ibox-content' style='padding-top: 2px; padding-bottom: 31px;'>"  //ibox-content {start}
				
					sBot += "<div class='row'>"
						sBot += "<div class='col-md-12'>"
							sBot += "<div class='col-md-3' id='areafunciones'>&nbsp;</div>"
						sBot += "</div>"
					sBot += "</div>"
			
				sBot += "<div class='row'>"
					sBot += "<div class='col-md-12'>" //col - 12 areabotones {start}
					
						sBot += "<div class='col-md-offset-6 col-md-5' id='areabotones' style='text-align: right;padding-right:50px;'>" //areabotones {start}
						
						if (Modo == "Editar") {
							
							if (iMWPuedeEditar >= 1 && Session("Editar") == 1) {
							//if (iMWPuedeEditar >= 1) {													   
																			   
								sBot += "<button type='button' class='btn btn-danger' id='btnCancelar' onclick='javascript:AcFCancelar(" + MW_Al_Borrar_Ir_A + ");'><i class='fa fa-reply'> </i> Cancelar&nbsp;"
								sBot += "</button>&nbsp;<button type='button' class='btn btn-success' id='btnGuardar' onclick='javascript:AcFGuardar();'><i class='fa fa-save'> </i> Guardar&nbsp;</button>"
								/*sBot += "&nbsp;<button type='button' class='btn btn-danger' id='btnCancelar' onclick='javascript:AcFCancelarJD(" + MW_Al_Borrar_Ir_A + ");'><i class='fa fa-reply'> </i> CancelarII&nbsp;"*/

							}
				
				
						} else {
						
							if (iMWPuedeBorrar >= 1 && Session("Borrar") == 1) {
							//if (iMWPuedeBorrar >= 1) {
				
				
								sBot += "&nbsp;<button class='btn btn-danger' id='btnBorrar' onclick='javascript:AcFBorrar();' type='button'><i class='fa fa-eraser'></i> Borrar&nbsp;</button>"
				
							}
				
							if (iMWPuedeEditar >= 1 && Session("Editar") == 1) {
							//if (iMWPuedeEditar >= 1) {				
				
								sBot += "&nbsp;<button class='btn btn-info' id='btnGuardar' onclick='javascript:AcFEditar();' type='button'><i class='fa fa-edit'></i> Editar&nbsp;</button>"
						
							}
				
							if (iMWPuedeAgregar >= 1 && Session("Agregar") == 1) {
							//if (iMWPuedeAgregar >= 1) {
				
								sBot += "&nbsp;<button type='button' class='btn btn-primary' id='btnNuevo' "
								sBot += " onclick='javascript:AcFNuevo();'><i class='fa fa-plus'> </i> Nuevo&nbsp;</button>"							
				
				
							}
				
				
						}
						
						sBot += "</div>"  //areabotones {end}
					sBot += "</div>"	//col - 12 areabotones {end}
				sBot += "</div>"
			
				sBot += "<div class='row'>"
					sBot += "<div class='col-md-12'>"
						sBot += "<div id='areanotificaciones'>&nbsp;</div>"
					sBot += "</div>"
				sBot += "</div>"
				
				sBot += "</div>"  //ibox-content {end}
				
			sBot += "</div>"  //ibox {end}
	
		return sBot
	
	}

																			   
	function CargaDatos() {
		
		var sResultado = ""

		//Aquí se cargan las secciones [Manejo de secciones]
		var iSecCont = 0
		var iSecTmp = 0
		var sATCps = "SELECT * "
			sATCps += " FROM MenuFichaSeccion "
			sATCps += " WHERE MFS_Habilitado = 1 "
			sATCps += " AND Sys_ID = " + SistemaActual
			sATCps += " AND WgCfg_ID = " + iWgCfgID
			//sATCps += " AND Mnu_ID = " + VentanaIndex 
			//Parametro("VentanaIndex",1)
			sATCps += " ORDER BY MFS_Orden "

			if (biQ4Web) {
				Response.Write("<br /><font class='text-danger'><strong>Secci&oacute;n&nbsp;"+sATCps +"</strong></font><br />")
			}	
																			   
			var rsSeccion = AbreTabla(sATCps,1,2)
			if (rsSeccion.EOF){ 
				return ""
			} 
																   
		sResultado = " <!-- Manejo de las secciones -->"
		var spMFClass = ""																	   
		var Offset = "0"
		var Ancho = "12"																	   
		var spIcono = ""
		var iPaddingBottom = 1																		   
																			   
		while (!rsSeccion.EOF){																			   
															
			// ========== Manejo de las secciones involucradas {start}
		iSecCont++
		// ========= Para el ancho de la sección a utilizar ==== {start}																	   
		var sCondNumRowSecc =  " MFC_Habilitado = 1 AND MFC_EsOculto <> 1 "
			sCondNumRowSecc += " AND MFC_EsPKPrincipal = 0 AND MFC_EsPK = 0 "
			sCondNumRowSecc += " AND Sys_ID = "+SistemaActual+" AND WgCfg_ID = "+iWgCfgID 
			sCondNumRowSecc += " AND MFS_ID = " + iSecCont
			if(iIQonDebug == 1) {																   
				Response.Write("Condici&oacute;n de por secci&oacute;n&nbsp;" + sCondNumRowSecc + "<br>")
				Response.Write("iSecCont&nbsp;" + iSecCont + "&nbsp;iSecTmp&nbsp;" + iSecTmp + "<br>")	
			}
			
		if(iSecCont != iSecTmp) {	
			iSecTmp = iSecCont
			iPaddingBottom = 75
			var sCondRowSecc = " MFC_Habilitado = 1 AND MFC_EsOculto <> 1"
				sCondRowSecc += " AND MFC_EsPKPrincipal = 0 AND MFC_EsPK = 0 "
				sCondRowSecc += " AND Sys_ID = "+SistemaActual+" AND WgCfg_ID = "+iWgCfgID
				sCondRowSecc += " AND MFS_ID = " + iSecTmp
				//Response.Write("<br>Secci&oacute;n&nbsp;" + iSecTmp + "<br>")
			
			var iNumRowSecc = BuscaSoloUnDato("ISNULL(COUNT(DISTINCT(MFC_Renglon)),0)","MenuFichaCampos",sCondRowSecc,1,2)
				//Response.Write("iNumRowSeccn&nbsp;" + iNumRowSecc + "<br>")	
				//Response.Write("iPaddingBottom&nbsp;" + iPaddingBottom + "<br>")
				
			var iContRowHelp = BuscaSoloUnDato("ISNULL(COUNT(DISTINCT(MFC_Renglon)),0)","MenuFichaCampos",sCondRowSecc + " AND MFC_TextoAyuda <> ''",1,2)
				//Response.Write("Contador de renglones con ayuda:==> " + iContRowHelp)
			
			var iContRowTexA = BuscaSoloUnDato("ISNULL(COUNT(DISTINCT(MFC_Renglon)),0)","MenuFichaCampos",sCondRowSecc + " AND MFC_TipoCampo = 9",1,2)
				//Response.Write("Contador de renglones con text area:==> " + iContRowTexA + "<br>")
			
				if(iNumRowSecc > 0) {
					//Response.Write("iNumRowSecc > 0<br>")
					
					if(iContRowHelp == 0){
						iPaddingBottom += (iNumRowSecc*53) + (iContRowTexA*17)
					
					} else {
				
						iPaddingBottom += (iNumRowSecc*53) + (iContRowHelp*17) + (iContRowTexA*17)
						
					}
				
				} 
																			   
		}
			//Response.Write("iPaddingBottom&nbsp;" + iPaddingBottom + "<br>")
		// ========= Para el ancho de la sección a utilizar ==== {end}
		// style='padding-top: 2px; padding-bottom: "+ iPaddingBottom +"%;'
				
			sResultado += "<div class='ibox-content' style='padding-top: 2px; padding-bottom: "+ iPaddingBottom +"px;'>"	
				sResultado += "<div class='ibox'>"
				
																			   
					spMFClass = rsSeccion.Fields.Item("MFS_Class").Value															   
					Offset = rsSeccion.Fields.Item("MFS_Offset").Value
					Ancho = rsSeccion.Fields.Item("MFS_AnchoEtiqueta").Value														   
					spIcono = rsSeccion.Fields.Item("MFS_Icono").Value

					if(EsVacio(spMFClass)) { spMFClass = "forum-item active" }
					if(EsVacio(Offset)) { Offset = "0" }
					if(EsVacio(Ancho)) { Ancho = "12" }	
					if(EsVacio(spIcono)) { spIcono = "fa fa-gears teal" }
																			   
					Offset = "col-md-offset-" + Offset
																			   
					sResultado += "<div class='col-md-" + Ancho + " " + spMFClass + "'>"
					
						sResultado += "<div class='col-md-"+ Offset +" forum-icon'>"
							sResultado += "<i class='" + spIcono + "'></i>"
						sResultado += "</div>"
					

						sResultado += "<a href='#' class='forum-item-title' style='pointer-events: none'><h3>"
						sResultado += rsSeccion.Fields.Item("MFS_Nombre").Value + "</h3></a>"
						sResultado += "<div class='forum-sub-title'>" 
						sResultado += rsSeccion.Fields.Item("MFS_Subtitulo").Value + "</div>"	
						sResultado += "<!--br--><div class='hr-line-dashed'></div>"
																			   
				// ========== Manejo de Campos de la ficha tabla MenuFichaCampos {start}																   
				
			var sFCHCps = "SELECT * "
				sFCHCps += " FROM MenuFichaCampos "
				sFCHCps += " WHERE MFC_Habilitado = 1 "
				sFCHCps += " AND Sys_ID = " + rsSeccion.Fields.Item("Sys_ID").Value
				sFCHCps += " AND Mnu_ID = " + rsSeccion.Fields.Item("Mnu_ID").Value
				sFCHCps += " AND WgCfg_ID = " + rsSeccion.Fields.Item("WgCfg_ID").Value
				sFCHCps += " AND MFS_ID = " + rsSeccion.Fields.Item("MFS_ID").Value
				sFCHCps += " AND MFC_EsOculto <> 1 "
				sFCHCps += " AND MFC_EsPKPrincipal = 0 "
				sFCHCps += " AND MFC_EsPK = 0 "
				sFCHCps += " ORDER BY MFC_Renglon, MFC_Columna "

				if (biQ4Web) {
					Response.Write("<br /><font class='text-danger'><strong><br>MenuFichaCampos&nbsp;"+sFCHCps +"</strong></font><br />")
					
				}		
																			   
					// ============ Manejo de variables de Campos de la ficha tabla MenuFichaCampos {ficha - start}		
					//Sys_ID | Mnu_ID | WgCfg_ID

					var iMFSID = -1
					var iMFCID = -1
					var iMFCRenglon = 0
					var iMFCColumna = 0
					var sMFCOrden = ""
					var iMFCOffset = 0
					var sMFCAnchoEtiqueta = ""
					var iMFCOffsetCampo = 0
					var sMFCAnchoCampo = ""
					var iMFCHabilitado = 0
					var iMFCTipoCampo = 0
					var iMFCFormato = 0
					var sMFCPlaceHolder = ""
					var sMFCEtiqueta = ""
					var sMFCCampo = ""
					var sMFCValorDefault = ""
					var sMFCTextoAyuda = ""
					var sMFCTextoValidacion = ""
					var sMFCExpresionValidacion = ""
					var iMFCRequerido = 0
					var sMFCAlineacionEtiqueta = ""
					var sMFCAlineacionCampo = ""
					var sMFCClass = ""
					var iMFCIDCatalogoGeneral = -1
					var sMFCComboTabla = ""
					var sMFCComboCampoLlave = ""
					var sMFCComboCampoDesc = ""
					var sMFCComboCondicion = ""
					var sMFCEventosJS = ""
					var sMFCLeyendaSelecTodos = ""
					var iMFCSoloLectura = 0

					var iMFCEditablePermanente = 0
					var iMFCEsOculto = 0
					var sMFCarrValores = ""
					var iMFCEsPK = 0
					var iMFCEsPKPrincipal = 0
					var iMFCEsBusqEstricta = 0

					var iVueltas = 0
					var iControl = 1
					var bUsado = false
					var iContRen = 0
					var iContCol = 0

					var sCampo = ""
					var iCol = 1

					var iContRow = 0
					var iContCol = 0
					var bCierraRow = false

					// ============ Manejo de variables de Campos de la ficha tabla MenuFichaCampos {ficha - end}					
																			   
					var sMFCValorDelCampo = ""															   
					
					var rsCampos = AbreTabla(sFCHCps,1,2)
																			   
					while (!rsCampos.EOF){		
																			   
						// ======== Llenado de campos [start] {													   
						
						iContCol++
						iMFSID = "" + rsCampos.Fields.Item("MFS_ID").Value
						iMFCID = "" + rsCampos.Fields.Item("MFC_ID").Value
						iMFCRenglon = "" + rsCampos.Fields.Item("MFC_Renglon").Value
						iMFCColumna = "" + rsCampos.Fields.Item("MFC_Columna").Value
						sMFCOrden = "" + rsCampos.Fields.Item("MFC_Orden").Value
						iMFCOffset = "" + rsCampos.Fields.Item("MFC_Offset").Value
						sMFCAnchoEtiqueta = "" + rsCampos.Fields.Item("MFC_AnchoEtiqueta").Value
						iMFCOffsetCampo = "" + rsCampos.Fields.Item("MFC_OffsetCampo").Value
						sMFCAnchoCampo = "" + rsCampos.Fields.Item("MFC_AnchoCampo").Value
						iMFCHabilitado = "" + rsCampos.Fields.Item("MFC_Habilitado").Value
						iMFCTipoCampo = "" + rsCampos.Fields.Item("MFC_TipoCampo").Value
						iMFCFormato = "" + rsCampos.Fields.Item("MFC_Formato").Value 
						sMFCPlaceHolder = FiltraVacios(rsCampos.Fields.Item("MFC_PlaceHolder").Value)
						sMFCEtiqueta = "" + rsCampos.Fields.Item("MFC_Etiqueta").Value
						sMFCCampo = "" + rsCampos.Fields.Item("MFC_Campo").Value
						sMFCValorDefault = "" + rsCampos.Fields.Item("MFC_ValorDefault").Value
						sMFCTextoAyuda = FiltraVacios(rsCampos.Fields.Item("MFC_TextoAyuda").Value)
						sMFCTextoValidacion = "" + rsCampos.Fields.Item("MFC_TextoValidacion").Value
						sMFCExpresionValidacion = FiltraVacios(rsCampos.Fields.Item("MFC_ExpresionValidacion").Value)
						iMFCRequerido = "" + rsCampos.Fields.Item("MFC_Requerido").Value
						sMFCAlineacionEtiqueta = "" + rsCampos.Fields.Item("MFC_AlineacionEtiqueta").Value
						sMFCAlineacionCampo = "" + rsCampos.Fields.Item("MFC_AlineacionCampo").Value
						sMFCClass = "" + rsCampos.Fields.Item("MFC_Class").Value
						iMFCIDCatalogoGeneral = rsCampos.Fields.Item("MFC_IDCatalogoGeneral").Value
						sMFCComboTabla = "" + rsCampos.Fields.Item("MFC_ComboTabla").Value
						sMFCComboCampoLlave = "" + rsCampos.Fields.Item("MFC_ComboCampoLlave").Value
						sMFCComboCampoDesc = "" + rsCampos.Fields.Item("MFC_ComboCampoDesc").Value
						sMFCComboCondicion = "" + rsCampos.Fields.Item("MFC_ComboCondicion").Value
						sMFCEventosJS = FiltraVacios(rsCampos.Fields.Item("MFC_EventosJS").Value)
						sMFCLeyendaSelecTodos = "" + rsCampos.Fields.Item("MFC_LeyendaSelecTodos").Value
						iMFCSoloLectura = "" + rsCampos.Fields.Item("MFC_SoloLectura").Value
						iMFCInformativo = "" + rsCampos.Fields.Item("MFC_Informativo").Value
						//es informativo en 1=coloca el valor y 2=coloca el valor y un oculto
						iMFCEditablePermanente = "" + rsCampos.Fields.Item("MFC_EditablePermanente").Value
						iMFCEsOculto = "" + rsCampos.Fields.Item("MFC_EsOculto").Value
						iOcultoTipo2 = iMFCEsOculto
						//iOcultoTipo2 = 2 es cuando en modo edicion se quiere poner el campo en un hidden con su valor
						sMFCarrValores = "" + rsCampos.Fields.Item("MFC_arrValores").Value
						iMFCEsPK = "" + rsCampos.Fields.Item("MFC_EsPK").Value
						iMFCEsPKPrincipal = "" + rsCampos.Fields.Item("MFC_EsPKPrincipal").Value
						iMFCEsBusqEstricta = "" + rsCampos.Fields.Item("MFC_EsBusqEstricta").Value

						// ======== Llenado de campos [end] }														   
																			   
						bCierraRow = false

						var sCondRegCol = " MFC_Habilitado = 1 "
							sCondRegCol += " AND Sys_ID = " + rsSeccion.Fields.Item("Sys_ID").Value
							sCondRegCol += " AND WgCfg_ID = " + rsSeccion.Fields.Item("WgCfg_ID").Value
							sCondRegCol += " AND MFS_ID = " + rsSeccion.Fields.Item("MFS_ID").Value
							sCondRegCol += " AND MFC_Renglon = " + iMFCRenglon
							sCondRegCol += " AND MFC_EsOculto = 0 "
							sCondRegCol += " AND MFC_EsPKPrincipal = 0 "
							sCondRegCol += " AND MFC_EsPK = 0 "

							if (biQ4Web) { 
								Response.Write("<br /><font class='text-danger'><strong>sCondRegCol&nbsp;" + sCondRegCol + "</strong></font><br />"+sMFCCampo+"")
							}
																			   
						//========== Manejo de los renglones y columnas 1era. parte {start} ==========													   
						var iColPorSecReg = BuscaSoloUnDato("MAX(MFC_Columna)","MenuFichaCampos",sCondRegCol,1,2)
						var iRegPorSec = BuscaSoloUnDato("MAX(MFC_Renglon)","MenuFichaCampos",sCondRegCol,1,2)
																			   
						if (biQ4Web) {
							Response.Write("iColPorSecReg&nbsp;"+iColPorSecReg)
							Response.Write("iRegPorSec&nbsp;"+iRegPorSec)
						}
																			   
						if (biQ4Web) {
							Response.Write("<br /><font class='text-danger' size='1'><strong>=============</strong></font><br />")
							Response.Write("<br /><font class='text-danger' size='1'><strong>&nbsp;iColPorSecReg&nbsp;" + iColPorSecReg + "&nbsp;iRegPorSec&nbsp;"+iRegPorSec+"&nbsp;iContCol&nbsp;"+ iContCol +"</strong></font><br />")
							Response.Write("<br /><font class='text-danger' size='1'><strong>iMFCRenglon&nbsp;"+parseInt(iMFCRenglon)+"&nbsp;iContRow&nbsp;"+iContRow+"</strong></font><br />")
						}

																			   
						if (iMFCRenglon != iContRow) {
							iContRen++
							iContRow = iMFCRenglon
							sResultado += "<!-- row&nbsp;" + iContRen + " - renglon -->"
							sResultado += "<div class='form-group'>" //{start form-group}
							sResultado += "<div class='col-md-12'>" //{start col-md-12}
							sResultado += "<div class='row'>"	//{start row}
						} 
																			   
						if (biQ4Web) {
							Response.Write("<br /><font class='text-danger' size='1'><strong>Cerramos el renglon?</strong></font><br />")
							Response.Write("<br /><font class='text-danger' size='1'><strong>iColPorSecReg&nbsp;"+parseInt(iColPorSecReg))
							Response.Write("<br />&nbsp;iContCol&nbsp;"+iContCol+"&nbsp;TipoCampo&nbsp;"+iMFCTipoCampo + "</strong></font><br />")
						}
																			   
						if(parseInt(iColPorSecReg) == parseInt(iContCol)) {
							bCierraRow = true
							//iContRow = 0
							iContCol = 0	
						}

																			   
						sCampo = ""
						
						var sModoRO = Modo

						var sMFCValorDefaultBD = "" + rsCampos.Fields.Item("MFC_ValorDefault").Value
							sMFCValorDefault = ProcesaValorDefault(sMFCValorDefaultBD)
						
						sMFCValorDelCampo = Parametro( sMFCCampo , sMFCValorDefault  )
						
						var ReglaValidacion = ""						
						if(iMFCRequerido == 1) {
							ReglaValidacion = "required"
						}
						if(sMFCExpresionValidacion != "") {
							if(ReglaValidacion != "") { ReglaValidacion += "," }
							ReglaValidacion += sMFCExpresionValidacion
						}
						if(ReglaValidacion != "") { 
							ReglaValidacion = " validate[" + ReglaValidacion + "]" 
						}
																			   
						//========== Manejo de los renglones y columnas 1era. parte {end} ==========													   

						//========== Juego del tipo de campo a manejar para mostrarlo tipo Bootstrap {start}													   
																			   
						switch (parseInt(iMFCTipoCampo)) {													   
																			   
							// 1 = text box
							case 1:				

							//Response.Write(sModoRO + "&nbsp;" + parseInt(iMFCTipoCampo))
																			   
								if (sModoRO == "Editar") {
									if(iMFCInformativo > 0 ){
										sCampo += "<label class='col-md-offset-"+iMFCOffset+" col-md-"+sMFCAnchoEtiqueta+" control-label' id='lbl"+sMFCCampo + "'>"+sMFCEtiqueta+"</label>"
										sCampo += "<div class='col-md-"+sMFCAnchoCampo + "'>" 
										sCampo += CampoModoInformativo(iMFCFormato, sMFCCampo, sMFCValorDelCampo)
										sCampo += "</div>"
									} else {

										sCampo += "<label class='col-md-offset-"+iMFCOffset+" col-md-"+sMFCAnchoEtiqueta+" control-label' id='lbl"+sMFCCampo + "'>"+sMFCEtiqueta+"</label>"

										sCampo += "<div class='col-md-"+sMFCAnchoCampo + "'><input type='text' " 
										sCampo += " placeholder='" + sMFCPlaceHolder + "' " 
										sCampo += " class='" + sMFCClass + ReglaValidacion + "' "
										sCampo += " name='" + sMFCCampo + "'"
										sCampo += " id='" + sMFCCampo + "' " 
										sCampo += " value='" + sMFCValorDelCampo + "' "
										//eventosjs
										if(!EsVacio(sMFCEventosJS)){	
											sCampo += sMFCEventosJS
											
										}
										//readonly
										if (iMFCSoloLectura == 1) {
											sCampo += "	readonly "	 
										}
										//autocomplete
										sCampo += " autocomplete='off' "
										sCampo += ">"

											if(!EsVacio(sMFCTextoAyuda)){
												sCampo += "<span class='help-block m-b-none'><i class='fa fa-question-circle'></i>"
												sCampo += "&nbsp;" + sMFCTextoAyuda
												sCampo += "</span>"
											}

										sCampo += "</div>"

									}
								} else {

									if(iMFCInformativo < 2 ) {

										sCampo = "<label class='col-md-offset-"+iMFCOffset+" col-md-"+sMFCAnchoEtiqueta+" control-label' id='lbl"+sMFCCampo + "'>"+sMFCEtiqueta+"</label>"
										sCampo += "<div class='col-md-"+sMFCAnchoCampo+"'>"				  
											sCampo += CampoModoInformativo(iMFCFormato, sMFCCampo, sMFCValorDelCampo)
														  
											if(!EsVacio(sMFCTextoAyuda)){
												sCampo += "<span class='help-block m-b-none'><i class='fa fa-question-circle'></i>"
												sCampo += "&nbsp;" + sMFCTextoAyuda
												sCampo += "</span>"
											}
										sCampo += "</div>"

									}
								}
																			   
							break;
														  
							// 2 = option
							case 2:							  
														  
								if (!EsVacio(sMFCarrValores)) {
									var Valores = new Array(0)
									var Txt =""
									Txt = String(sMFCarrValores) // se explota el contenido para separar las opciones de los valores
									Valores = Txt.split("|")										
									var SarrOpciones  = Valores[0]
									var SarrValores	  = Valores[1]		
								}

								var Eventos = ""
								var Estilo = ""

								if (!EsVacio(sMFCClass)) {
									Estilo = "" + sMFCClass + " "
								}
								if (!EsVacio(sMFCEventosJS)) {
									Eventos += "" + sMFCEventosJS + " " 
								}

								sCampo += "<label class='col-md-offset-"+iMFCOffset+" col-md-"+sMFCAnchoEtiqueta+" control-label' id='lbl"+sMFCCampo + "'>"+sMFCEtiqueta+"</label>"

								sCampo += "<div class='col-md-"+sMFCAnchoCampo + "' >"
								sCampo += OpcionesFicha(sMFCCampo,Eventos,SarrOpciones,SarrValores,Parametro(sMFCCampo,sMFCValorDefault),iMFCRequerido,Estilo,sMFCTextoAyuda,sModoRO)
								sCampo += "</div>"

								sCampo += "<script type='text/javascript'> "

									sCampo += " $('.i-checks').iCheck({ "
										//sCampo += " checkboxClass: 'icheckbox_square-green', "
										sCampo += " radioClass: 'iradio_square-green' "
									sCampo += " }); "

								sCampo += "</script>"
														  
							break;
														  
							// 4 = combo tabla					  
							case 4:							  
														  
								var sEventos = ""
								if (!EsVacio(sMFCEventosJS)) {
									sEventos =  " " + sMFCEventosJS + " "
								}

								var sEstilo = ""
								if (!EsVacio(sMFCClass)) {
									sEstilo =  "" + sMFCClass + ""
								}

								var sTabla = sMFCComboTabla
								var sLlave = sMFCComboCampoLlave
								var sCampoDescripcion = sMFCComboCampoDesc

								var sCondicion = ""
								if (!EsVacio(sMFCComboCondicion)) {
									sCondicion += sMFCComboCondicion
								}
									sCondicion =  FiltraVacios(sMFCComboCondicion)
									sCondicion = ProcesaCondicionPorParametros(sCondicion)

								var sOrden = ""
								if (!EsVacio(sMFCOrden)) {
									sOrden =  " " + sMFCOrden + " "
								}

								var sTodos = "Seleccione una opci&oacute;n"
								if (!EsVacio(sMFCLeyendaSelecTodos)) {
									sTodos = sMFCLeyendaSelecTodos
								}
														  

								sCampo += "<label class='col-md-offset-"+iMFCOffset+" col-md-"+sMFCAnchoEtiqueta+" control-label' id='lbl"+sMFCCampo + "'>"+sMFCEtiqueta+"</label>"
								
								sCampo += "<div class='col-md-"+sMFCAnchoCampo + "' >"
													  
									sCampo += CargaComboFicha(sMFCCampo,sEventos,sLlave,sCampoDescripcion,sTabla,sCondicion,sOrden,Parametro(sMFCCampo,sMFCValorDefault),MFC_Conexion,sTodos,iMFCRequerido,sModoRO,sEstilo,sMFCTextoAyuda)

								sCampo += "</div>"						  
														  
								sCampo += "<script type='text/javascript'> "

									sCampo += "	$(document).ready(function () { "

									sCampo += " $('#"+sMFCCampo+"').select2(); "

									sCampo += " });"

								sCampo += "</script>"
														  
							break;						  

							case 5:							  
									
								var Eventos = ""
								var Estilo = ""

								if (!EsVacio(sMFCClass)) {
									Estilo = "" + sMFCClass + " "
								}
								if (!EsVacio(sMFCEventosJS)) {
									Eventos += "" + sMFCEventosJS + " " 
								}

								sCampo += "<label class='col-md-offset-"+iMFCOffset+" col-md-"+sMFCAnchoEtiqueta+" control-label' id='lbl"+sMFCCampo + "'>"+sMFCEtiqueta+"</label>"

								sCampo += "<div class='col-md-"+sMFCAnchoCampo + "'>"	

								sCampo += "" + CajaSeleccion(sMFCCampo,Eventos,Parametro(sMFCCampo,sMFCValorDefault),1,iMFCRequerido,Modo,sMFCTextoAyuda,Estilo)	

								sCampo += "</div>"

								sCampo += "<script type='text/javascript'> "

									sCampo += " $('.i-checks').iCheck({ "
										sCampo += " checkboxClass: 'icheckbox_square-green' "
										sCampo += ", radioClass: 'iradio_square-green' "
									sCampo += " }); "

								sCampo += "</script>"
														  
							break;							  
														  
							case 6:		//6 = fecha - tipo campo date				  
													  
								if (sModoRO == "Editar") {
									if(iMFCInformativo > 0 ){
										sCampo = CampoModoInformativo(iMFCFormato, sMFCCampo, sMFCValorDelCampo)
									} else {

										sCampo = "<label class='col-md-offset-"+iMFCOffset+" col-md-"+sMFCAnchoEtiqueta+" control-label' id='lbl"+sMFCCampo + "'>"+sMFCEtiqueta+"</label>"

										sCampo += "<div class='col-md-"+sMFCAnchoCampo + "' id='date"+sMFCCampo+ "'>"

											sCampo += "<div class='input-group date'>"
												sCampo += "<span class='input-group-addon'> <i class='fa fa-calendar'></i> </span>"
												sCampo += "<input name='" + sMFCCampo + "' id='" +sMFCCampo + "' "
												sCampo += " placeholder='" +sMFCPlaceHolder + "' type='text' " 
												sCampo += " class='form-control'"  
												//sCampo += FormatoFecha(Parametro(sMFCCampo,'') ,'UTC a dd/mm/yyyy') 
												sCampo += " value='" + AplicaFormato(iMFCFormato,Parametro(sMFCCampo,sMFCValorDelCampo)) + "'>"
												//sCampo += " "
											sCampo += "</div>"

											if(!EsVacio(sMFCTextoAyuda)){
												sCampo += "<span class='help-block m-b-none'><i class='fa fa-question-circle'></i>"
												sCampo += "&nbsp;" + sMFCTextoAyuda
												sCampo += "</span>"
											}

										sCampo += "</div>"

										sCampo += "<script type='text/javascript'> "

											sCampo += " $('#date"+sMFCCampo+" .input-group.date').datepicker({ "
												sCampo += " format: 'dd/mm/yyyy', "
												sCampo += " todayBtn: 'linked',  "
												sCampo += " language: 'es', "
												sCampo += " todayHighlight: true, "
												sCampo += " autoclose: true "
											sCampo += " }); "

										sCampo += "</script>"

									}
								} else {

									if(iMFCInformativo < 2 ) {

										sCampo = "<label class='col-md-offset-"+iMFCOffset+" col-md-"+sMFCAnchoEtiqueta+" control-label' id='lbl"+sMFCCampo + "'>"+sMFCEtiqueta+"</label>"
										sCampo += "<div class='col-md-"+sMFCAnchoCampo+"'>"				  
											sCampo += CampoModoInformativo(iMFCFormato, sMFCCampo, sMFCValorDelCampo)
														  
											if(!EsVacio(sMFCTextoAyuda)){
												sCampo += "<span class='help-block m-b-none'><i class='fa fa-question-circle'></i>"
												sCampo += "&nbsp;" + sMFCTextoAyuda
												sCampo += "</span>"
											}
														  
										sCampo += "</div>"

									}

								}

						
							break;
													  
							case 7:		// 7 = combo Catálogo General
													  
								var sEventos = ""
								if (!EsVacio(sMFCEventosJS)) {
									sEventos =  " " + sMFCEventosJS + " "
								}

								var sEstilo = ""
								if (!EsVacio(sMFCClass)) {
									sEstilo =  "" + sMFCClass + ""
								}

								var sCampoDescripcion = sMFCComboCampoDesc
								var sTabla = sMFCComboTabla
								var sCondicion = ""

									sCondicion =  FiltraVacios(sMFCComboCondicion)
									sCondicion = ProcesaCondicionPorParametros(sCondicion)

								var sOrden = ""
								if (!EsVacio(FiltraVacios(sMFCOrden))) {
									sOrden =  " " + sMFCOrden + " "
								}

								var sTodos = "Seleccione una opci&oacute;n"
								if (!EsVacio(FiltraVacios(sMFCLeyendaSelecTodos))) {
									sTodos = sMFCLeyendaSelecTodos
								}

								var sSeccion = "1"
								if (!EsVacio(iMFCIDCatalogoGeneral)) {
									sSeccion = iMFCIDCatalogoGeneral
								}	

								sCampo += "<label class='col-md-offset-"+iMFCOffset+" col-md-"+sMFCAnchoEtiqueta+" control-label' id='lbl"+sMFCCampo + "'>"+sMFCEtiqueta+"</label>"
								
								sCampo += "<div class='col-md-"+sMFCAnchoCampo + "' >"
													  
									sCampo += ComboSeccionFicha(sMFCCampo,sEventos,sSeccion,Parametro(sMFCCampo,sMFCValorDefault),MFC_Conexion,sTodos,sOrden,iMFCRequerido,sModoRO,sEstilo,sMFCTextoAyuda)

								sCampo += "</div>"						  
														  
								sCampo += "<script type='text/javascript'> "

									sCampo += "	$(document).ready(function () { "

									sCampo += " $('#"+sMFCCampo+"').select2(); "

									sCampo += " });"

								sCampo += "</script>"
														  
							break;
							
							case 8:		//	8 = password
		
								if (sModoRO == "Editar") {
									if(iMFCInformativo > 0 ){
										sCampo = CampoModoInformativo(iMFCFormato, sMFCCampo, sMFCValorDelCampo)
									} else {

										sCampo += "<label class='col-md-offset-"+iMFCOffset+" col-md-"+sMFCAnchoEtiqueta+" control-label' id='lbl"+sMFCCampo + "'>"+sMFCEtiqueta+"</label>"

										sCampo += "<div class='col-md-"+sMFCAnchoCampo + "'><input type='password' " 
										sCampo += " placeholder='" + sMFCPlaceHolder + "' " 
										sCampo += " class='" + sMFCClass + ReglaValidacion + "' "
										sCampo += " name='" + sMFCCampo + "'"
										sCampo += " id='" + sMFCCampo + "' " 
										sCampo += " value='" + sMFCValorDelCampo + "' "
										//readonly
										if (iMFCSoloLectura == 1) {
											sCampo += "	readonly "	 
										}
										//autocomplete
										sCampo += " autocomplete='off' "
										sCampo += ">"

											if(!EsVacio(sMFCTextoAyuda)){
												sCampo += "<span class='help-block m-b-none'><i class='fa fa-question-circle'></i>"
												sCampo += "&nbsp;" + sMFCTextoAyuda
												sCampo += "</span>"
											}

										sCampo += "</div>"

									}
								} else {

									if(iMFCInformativo < 2 ) {

										sCampo = "<label class='col-md-offset-"+iMFCOffset+" col-md-"+sMFCAnchoEtiqueta+" control-label' id='lbl"+sMFCCampo + "'>"+sMFCEtiqueta+"</label>"
										sCampo += "<div class='col-md-"+sMFCAnchoCampo+"'>"				  
											sCampo += CampoModoInformativo(iMFCFormato, sMFCCampo, sMFCValorDelCampo)
														  
											if(!EsVacio(sMFCTextoAyuda)){
												sCampo += "<span class='help-block m-b-none'><i class='fa fa-question-circle'></i>"
												sCampo += "&nbsp;" + sMFCTextoAyuda
												sCampo += "</span>"
											}
										sCampo += "</div>"

									}
								}
			  
							break;
														  
							case 9:    //	9 = Text Area
							
							if (sModoRO == "Editar") {
								if(iMFCInformativo > 0 ){
									sCampo = CampoModoInformativo(iMFCFormato, sMFCCampo, sMFCValorDelCampo)
								} else {
				
									sCampo += "<label class='col-md-offset-"+iMFCOffset+" col-md-"+sMFCAnchoEtiqueta+" control-label' id='lbl"+sMFCCampo + "'>"+sMFCEtiqueta+"</label>"
				
									sCampo += "<div class='col-md-"+sMFCAnchoCampo + "'>"			
										sCampo += "<textarea id='" + sMFCCampo + "'"
										sCampo += " name='" + sMFCCampo + "'"
										sCampo += " placeholder='" + sMFCPlaceHolder + "'"
										sCampo += " class='" + sMFCClass + ReglaValidacion + "'"
										//readonly
										if (iMFCSoloLectura == 1) {
											sCampo += "	readonly "	 
										}
										//autocomplete
										sCampo += " autocomplete='off' "				
										sCampo += ">"
										sCampo += sMFCValorDelCampo
				
									sCampo += "</textarea>"
				
									if(!EsVacio(sMFCTextoAyuda)){
										sCampo += "<span class='help-block m-b-none'><i class='fa fa-question-circle'></i>"
										sCampo += "&nbsp;" + sMFCTextoAyuda
										sCampo += "</span>"
									}
				
									sCampo += "</div>"
				
								}
				
							} else {
				
									if(iMFCInformativo < 2 ) {

										sCampo = "<label class='col-md-offset-"+iMFCOffset+" col-md-"+sMFCAnchoEtiqueta+" control-label' id='lbl"+sMFCCampo + "'>"+sMFCEtiqueta+"</label>"
										sCampo += "<div class='col-md-"+sMFCAnchoCampo+"'>"				  
											sCampo += CampoModoInformativo(iMFCFormato, sMFCCampo, sMFCValorDelCampo)
												if(!EsVacio(sMFCTextoAyuda)){
													sCampo += "<span class='help-block m-b-none'><i class='fa fa-question-circle'></i>"
													sCampo += "&nbsp;" + sMFCTextoAyuda
													sCampo += "</span>"
												}
										sCampo += "</div>"
														  
									}
				
							}
							
							break;
														  
							case 10:	//	10 = Sí / no

							break;

							case 11:	//	11 = text box doble para rangos

							break;

							case 12:	//	12 = text box doble para rangos fechas
														  
														  
							break;							  

							case 13:	//	7 = combo Catálogo General con llave de texto
										//	Cubierto en la sección de un solo procedimiento
														  
								var sEventos = ""
								if (!EsVacio(sMFCEventosJS)) {
									sEventos =  " " + sMFCEventosJS + " "
								}

								var sEstilo = ""
								if (!EsVacio(sMFCClass)) {
									sEstilo =  "" + sMFCClass + ""
								}

								var sCampoDescripcion = sMFCComboCampoDesc
								var sTabla = sMFCComboTabla
								var sCondicion = ""  //" Sys_ID = " + sysid

									sCondicion =  FiltraVacios(sMFCComboCondicion)
									sCondicion = ProcesaCondicionPorParametros(sCondicion)

								var sOrden = ""
								if (!EsVacio(FiltraVacios(sMFCOrden))) {
									sOrden =  " " + sMFCOrden + " "
								}

								var sTodos = "Seleccione una opci&oacute;n"
								if (!EsVacio(FiltraVacios(sMFCLeyendaSelecTodos))) {
									sTodos = sMFCLeyendaSelecTodos
								}

								var sSeccion = "1"
								if (!EsVacio(iMFCIDCatalogoGeneral)) {
									sSeccion = iMFCIDCatalogoGeneral
								}	
								
														  
								sCampo += "<label class='col-md-offset-"+iMFCOffset+" col-md-"+sMFCAnchoEtiqueta+" control-label' id='lbl"+sMFCCampo + "'>"+sMFCEtiqueta+"</label>"
								
								sCampo += "<div class='col-md-"+sMFCAnchoCampo + "' >"
														  
								sCampo += ComboSeccionFichaXTXT(sMFCCampo,sEventos,sSeccion,Parametro(sMFCCampo,sMFCValorDefault),MFC_Conexion,sTodos,sOrden,iMFCRequerido,sModoRO,sEstilo,sMFCTextoAyuda)
							
								sCampo += "</div>"						  
														  
								sCampo += "<script type='text/javascript'> "

									sCampo += "	$(document).ready(function () { "

									sCampo += " $('#"+sMFCCampo+"').select2(); "

									sCampo += " });"

								sCampo += "</script>"
														  
							break;							  
							
							case 21:	//ColorPicker													

								if (sModoRO == "Editar") {													
																				
										if(iMFCInformativo > 0 ){

												sCampo += "<label class='col-md-offset-"+iMFCOffset+" col-md-"+sMFCAnchoEtiqueta+" control-label' id='lbl"+sMFCCampo + "'>"+sMFCEtiqueta+"</label>"
												sCampo += "<div class='col-md-"+sMFCAnchoCampo + "'>" 
												sCampo += CampoModoInformativo(iMFCFormato, sMFCCampo, sMFCValorDelCampo)
												sCampo += "</div>"

										} else {
			
												sCampo += "<label class='col-md-offset-"+iMFCOffset+" col-md-"+sMFCAnchoEtiqueta+" control-label' id='lbl"+sMFCCampo + "'>"+sMFCEtiqueta+"</label>"
			
												sCampo += "<div class='col-md-"+sMFCAnchoCampo + "'>"
														sCampo += "<div id='cp" + sMFCCampo + "' class='input-group colorpicker-component'>"
																sCampo += "<input type='text' " 
																sCampo += " placeholder='" + sMFCPlaceHolder + "' " 
																sCampo += " class='" + sMFCClass + ReglaValidacion + "' "
																sCampo += " name='" + sMFCCampo + "'"
																sCampo += " id='" + sMFCCampo + "' " 
																sCampo += " value='" + sMFCValorDelCampo + "' "
																//eventosjs
																if(!EsVacio(sMFCEventosJS)){	
																	sCampo += sMFCEventosJS
																}
																//readonly
																if (iMFCSoloLectura == 1) {
																	sCampo += "	readonly "	 
																}
																//autocomplete
																sCampo += " autocomplete='off' "
																sCampo += ">"
															sCampo += "<span class='input-group-addon'><i></i></span>"	
														sCampo += "</div>"

													if(!EsVacio(sMFCTextoAyuda)){
														sCampo += "<span class='help-block m-b-none'><i class='fa fa-question-circle'></i>"
														sCampo += "&nbsp;" + sMFCTextoAyuda
														sCampo += "</span>"
													}

												sCampo += "</div>"

												sCampo += "<script type='text/javascript'> "

													sCampo += "	$(document).ready(function() { "

													sCampo += " $('#cp"+sMFCCampo+"').colorpicker(); "

													sCampo += " });"

												sCampo += "</script>"
			
										}																					
																				
								} else {
																				
										if(iMFCInformativo < 2 ) {				
			
												sCampo = "<label class='col-md-offset-"+iMFCOffset+" col-md-"+sMFCAnchoEtiqueta+" control-label' id='lbl"+sMFCCampo + "'>"+sMFCEtiqueta+"</label>"
												sCampo += "<div class='col-md-"+sMFCAnchoCampo+"'>"				  
													sCampo += "<button type='button' class='btn' style='background-color:"+sMFCValorDelCampo+"'>" + sMFCValorDelCampo + "</button>"
																	
													if(!EsVacio(sMFCTextoAyuda)){
														sCampo += "<span class='help-block m-b-none'><i class='fa fa-question-circle'></i>"
														sCampo += "&nbsp;" + sMFCTextoAyuda
														sCampo += "</span>"
													}

												sCampo += "</div>"
																					
										}
			
								}
			
							break;

							case 22:		//ClockPicker												
																					
								if (sModoRO == "Editar") {													
																				
										if(iMFCInformativo > 0 ){

												sCampo += "<label class='col-md-offset-"+iMFCOffset+" col-md-"+sMFCAnchoEtiqueta+" control-label' id='lbl"+sMFCCampo + "'>"+sMFCEtiqueta+"</label>"
												sCampo += "<div class='col-md-"+sMFCAnchoCampo + "'>" 
												sCampo += CampoModoInformativo(iMFCFormato, sMFCCampo, sMFCValorDelCampo)
												sCampo += "</div>"

										} else {
			
												sCampo += "<label class='col-md-offset-"+iMFCOffset+" col-md-"+sMFCAnchoEtiqueta+" control-label' id='lbl"+sMFCCampo + "'>"+sMFCEtiqueta+"</label>"

												sCampo += "<div class='col-md-"+sMFCAnchoCampo + "'>"
														sCampo += "<div id='clokp" + sMFCCampo + "' class='input-group clockpicker'>"
																sCampo += "<input type='text' " 
																sCampo += " placeholder='" + sMFCPlaceHolder + "' " 
																sCampo += " class='" + sMFCClass + ReglaValidacion + "' "
																sCampo += " name='" + sMFCCampo + "'"
																sCampo += " id='" + sMFCCampo + "' " 
																sCampo += " value='" + sMFCValorDelCampo + "' "
																//eventosjs
																if(!EsVacio(sMFCEventosJS)){	
																	sCampo += sMFCEventosJS
																}
																//readonly
																if (iMFCSoloLectura == 1) {
																	sCampo += "	readonly "	 
																}
																//autocomplete
																sCampo += " autocomplete='off' "
																sCampo += ">"
															sCampo += "<span class='input-group-addon'><span class='fa fa-clock-o'></span></span>"	
														sCampo += "</div>"

													if(!EsVacio(sMFCTextoAyuda)){
														sCampo += "<span class='help-block m-b-none'><i class='fa fa-question-circle'></i>"
														sCampo += "&nbsp;" + sMFCTextoAyuda
														sCampo += "</span>"
													}

												sCampo += "</div>"

												sCampo += "<script type='text/javascript'> "

													sCampo += "	$(document).ready(function() { "

														sCampo += " $('#"+sMFCCampo+"').clockpicker({ "

																sCampo += " placement: 'top',"
																	sCampo += " align: 'left',"					
																		sCampo += " autoclose: true" 			

														sCampo += " });"		
			
													sCampo += " });"
			
												sCampo += "</script>"
			
										}																					
																				
								} else {
																				
										if(iMFCInformativo < 2 ) {				
			
												sCampo = "<label class='col-md-offset-"+iMFCOffset+" col-md-"+sMFCAnchoEtiqueta+" control-label' id='lbl"+sMFCCampo + "'>"+sMFCEtiqueta+"</label>"
												sCampo += "<div class='col-md-"+sMFCAnchoCampo+"'>"				  
													sCampo += CampoModoInformativo(iMFCFormato, sMFCCampo, sMFCValorDelCampo)
			
													if(!EsVacio(sMFCTextoAyuda)){
														sCampo += "<span class='help-block m-b-none'><i class='fa fa-question-circle'></i>"
														sCampo += "&nbsp;" + sMFCTextoAyuda
														sCampo += "</span>"
													}

												sCampo += "</div>"
																					
										}
			
								}
																					
							break;														
																					
							default:												   
								// ======================= Valor por default en caso de que el tipo de campo no exista	
													  
								if (sModoRO == "Editar") {
									if(iMFCInformativo > 0 ){
										sCampo = CampoModoInformativo(iMFCFormato, sMFCCampo, sMFCValorDelCampo)
									} else {
										sCampo =  "<input type='text' class='" + sMFCClass + ReglaValidacion + "'"
										sCampo += " name='" + sMFCCampo + "'" 
										sCampo += " id='" + sMFCCampo + "'" 
										sCampo += " placeholder='" + sMFCPlaceHolder + "'"  
										sCampo += " value='" + sMFCValorDelCampo + "'"
										//readonly
										if (iMFCSoloLectura == 1) {
											sCampo += "	readonly "	 
										}
										//autocomplete
										sCampo += " autocomplete='off' "
										sCampo += ">"
									
										if(!EsVacio(sMFCTextoAyuda)){
											sCampo += "<span class='help-block m-b-none'><i class='fa fa-question-circle'></i>"
											sCampo += "&nbsp;" + sMFCTextoAyuda
											sCampo += "</span>"
										}
									}
									
								} else {
									sCampo = CampoModoInformativo(iMFCFormato, sMFCCampo, sMFCValorDelCampo)
									//Reponse.Write("Entramos de modo consulta!!!")
								}
																			   
						}
																			   
						//========== Juego del tipo de campo a manejar para mostrarlo tipo Bootstrap {end}
			
						sResultado += sCampo
													  
						//========== Manejo de los renglones y columnas 2da. parte {start} ==========													   
						if(bCierraRow) {
							sResultado += "</div>" //{end row}
							sResultado += "</div>" //{end col-md-12}
							sResultado += "</div>" //{end form-group}
						}
						//========== Manejo de los renglones y columnas 2da. parte {end} ==========
																			   
						rsCampos.MoveNext()													   
						if (iVueltas > 5) { return "Error al colocar el campo, revise las posiciones de columnas y renglones" }													   
																			   
					}
																			   
						rsCampos.Close()														   
																			   
				// ========== Manejo de Campos de la ficha tabla MenuFichaCampos {end}

					sResultado += "</div>"																   
				sResultado += "</div>"																   
			sResultado += "</div>"																   
																			   
																			   
		rsSeccion.MoveNext()
		}	
		rsSeccion.Close()	
	

	return sResultado
																	   

	}

			
//AplicaFormato
function AplicaFormato(iFormato,sValor) {
/*	if(iFormato==5) {	
		Response.Write(iFormato + "&nbsp;" + sValor)
	} */
	var sResultado = String(sValor) 
	
		switch (parseInt(iFormato)) {
			case 1:
				sResultado = PonerFormatoNumerico(sResultado,"$ ")
				break;
				
			case 2:
				sResultado += "";
				var regx = /(\d+)(\d{3})/;
				while (regx.test(sResultado)) {
					sResultado = sResultado.replace(regx, "$1" + "," + "$2");
				}
				break;
				
			case 3:
				sResultado = parseFloat(sResultado) * 100
				sResultado = sResultado.toFixed(2) + " %" 
				/*valor = 1234567.3456;
				function funcion(){
				valorParseado = (parseFloat(valor).toFixed(2)).toString().split(". ");
				valorParseado2 = valorParseado[0].toString().split("").reverse().join("").replace(/\d{3}(?=\d)/g, function(encaja){ return encaja+'.';})
				alert(valorParseado2.toString().split("").reverse( ).join("")+','+valorParseado[1]);
				}*/
				break;
				
			case 4:
				if (sResultado == 1) {
					sResultado = "Si"
				} else {
					sResultado = "No"
				}
				break;
				
			case 5:  
				//Response.Write("<br>sResultado " + sResultado)
				var stfc6 = FormatoFechaII(sResultado,"CST a fecha","Guardar")
				//Response.Write("<br>stfc6 " + stfc6)
				if (stfc6 != "01/01/1900") {
					 sResultado = stfc6    
				} 
				/*sResultado =  CambiaFormatoFecha(sResultado,"yyyy-mm-dd","dd/mm/yyyy")
				sResultado =  FormatoFecha(sResultado ,"UTC a dd/mm/yyyy")
				*/
				break;	
						
			case 6:  //fechas solo identificacion y conversion
				//sResultado = FormatoFecha(sResultado ,"CST a dd/mm/yyyy")
				//Response.Write("<br>sResultado " + sResultado)
				sResultado = FormatoFechaII(sResultado,"UTC s/fecha","Consulta") 
				//Response.Write("<br>sResultado " + sResultado)
				break;	
				
			case 7:  //fechas solo identificacion y conversion
				//sResultado = FormatoFecha(sResultado ,"CST a dd/mm/yyyy")
				sResultado = FormatoFechaII(sResultado,"UTC","Consulta") 
				break;	
				
			case 8:
				sResultado = parseFloat(sResultado)
				sResultado = sResultado.toFixed(2) + " %" 
				break;	
								
			default:
				sResultado = sValor
			break;	
									
		} 

	return sResultado
}
			
// 2 Options
		 //OpcionesFicha(sMFCCampo,Eventos,SarrOpciones,SarrValores,Parametro(sMFCCampo,sMFCValorDefault),iMFCRequerido,sMFCTextoAyuda,sModoRO)				
function OpcionesFicha(NombreCaja,EventosClases,SarrOpciones,SarrValores,ValorActual,Requerido,OptEstilo,sOpcAyuda,Modo) {

	var sRespuesta = ""
	var Opciones = new Array(0)
	var ValoresOpc = new Array(0)
	var i = 0
	var Txt =""

	//  NombreCaja es el nombre que tienen todos los option
	Txt = String(SarrOpciones)  // es el nombre que se pone en el id para diferenciarlos del grupo  
	Opciones = Txt.split(",")
	Txt = String(SarrValores)   // es el valor que cada uno tiene
	ValoresOpc = Txt.split(",")

	if (Modo == "Editar") {			
				
		for (i=0;i<Opciones.length;i++) {

			sRespuesta += "<label class='"+OptEstilo+"'>"
				sRespuesta += "<input type='radio' name='" + NombreCaja + "' id='" + NombreCaja + i +"' " 
				sRespuesta += " value='" + ValoresOpc[i] + "' "
				if (ValoresOpc[i] == ValorActual || i==0) { sRespuesta += " checked " }
				sRespuesta += " class='" + EventosClases
				if(Requerido==1){
					sRespuesta += " validate[required]"
				}				
				sRespuesta += " '>"
				sRespuesta += "<i></i>&nbsp;"
				sRespuesta += Opciones[i]
			sRespuesta += "</label>"

		}

		if(!EsVacio(sOpcAyuda)){
			sRespuesta += "<span class='help-block m-b-none'><i class='fa fa-question-circle'></i>"
			sRespuesta += sOpcAyuda
			sRespuesta += "</span>"
		}

	}

	if (Modo != "Editar" ) {
		for (i=0;i<Opciones.length;i++) {
			if (ValoresOpc[i] == ValorActual) {
				sRespuesta =  "<p class='SoloConsulta'>" + Opciones[i] + "</p>" 
			}
				
		}
		if (iOcultoTipo2 == 2) {
			sRespuesta += "<input type='hidden'"  
			sRespuesta += " name='" + NombreCaja + "'" 
			sRespuesta += " id='" + NombreCaja + "'" 
			sRespuesta += " value='" + ValorActual + "'>"
		}
				
		if(!EsVacio(sOpcAyuda)){
			sRespuesta += "<span class='help-block m-b-none'><i class='fa fa-question-circle'></i>"
			sRespuesta += "&nbsp;" + sOpcAyuda
			sRespuesta += "</span>"
		}
				
	}

	return sRespuesta

}
								
// 4 = combo tabla
//CargaComboFicha(sMFCCampo,sEventos,sLlave,sCampoDescripcion,sTabla,sCondicion,sOrden,Parametro(sMFCCampo,sMFCValorDefault),0,sTodos,iMFCRequerido,sModoRO,sEstilo,sMFCTextoAyuda)		
function CargaComboFicha(NombreCombo,Eventos,CampoID,CampoDescripcion,Tabla,Condicion,Orden,Seleccionado,Conexion,Todos,Requerido,Modo,Estilo,sOpcAyuda) {

	var sElemento = ""
	var sResultado = ""
		
	if (EsVacio(Seleccionado)) {Seleccionado = -1 }

	if (Modo == "Editar") {		
		
		if (iMFCInformativo > 0) {

			var sSQLCondicion = " " + CampoID + " = " + Seleccionado 
			
			if (Condicion != "") { sSQLCondicion += " and " + Condicion }
			
			sElemento = " <p class='SoloConsulta'> "
			sElemento += IFAnidado(!EsVacio(BuscaSoloUnDato(CampoDescripcion,Tabla,sSQLCondicion,"",Conexion)),BuscaSoloUnDato(CampoDescripcion,Tabla,sSQLCondicion,"",Conexion),"&nbsp;") 
			sElemento += " </p>" 
			
			if (iOcultoTipo2 == 2) {
				sElemento += " <input type='hidden'"  
				sElemento += " name='" + NombreCombo + "'" 
				sElemento += " id='" + NombreCombo + "'"  
				sElemento += " value='" + Seleccionado + "'>" 
			}
		
		} else {
		
			sResultado = "<select name='" + NombreCombo + "' id='" + NombreCombo  +"' " + Eventos
				
			sResultado += " class='" + Estilo
			if(Requerido==1){
				sResultado += " validate[required]"
			}		
			sResultado += "' >"
				
				if (Todos != "") {
					sElemento = "<option value='-1'"
					if (Seleccionado == -1) { sElemento += " selected " }
					sElemento += ">" + Todos + "</option>"
				}

			var CCSQL = "SELECT " + CampoID + ", " + CampoDescripcion + " FROM " + Tabla
				if (Condicion != "") { CCSQL += " WHERE " + Condicion }
				if (Orden != "") { CCSQL += " ORDER BY " + Orden }

			var rsCC = AbreTabla(CCSQL,1,Conexion)

				while (!rsCC.EOF){
					//Response.Write("<br>" + rsCC.Fields.Item(1).Value)
					sElemento += "<option value='" + rsCC.Fields.Item(0).Value + "' "
					if (Seleccionado == rsCC.Fields.Item(0).Value) { sElemento += " selected " }
					sElemento += ">" + rsCC.Fields.Item(1).Value + "</option>"
					rsCC.MoveNext()
				}

			sResultado += sElemento
			rsCC.Close()
			sResultado += "</select>"

			if(!EsVacio(sOpcAyuda)){
				sResultado += "<span class='help-block m-b-none'><i class='fa fa-question-circle'></i>"
				sResultado += "&nbsp;" + sOpcAyuda
				sResultado += "</span>"
			}
		
		}

	} else {
	
		if (Seleccionado == -1) {
			
			sElemento = " <p class='SoloConsulta'>&nbsp;</p>" 
			
		} else {
			
			var sSQLCondicion = " " + CampoID + " = " + Seleccionado 
			
			if (Condicion != "") { sSQLCondicion += " and " + Condicion }
			
			sElemento = " <p class='SoloConsulta'> "
			sElemento += IFAnidado(!EsVacio(BuscaSoloUnDato(CampoDescripcion,Tabla,sSQLCondicion,"",Conexion)),BuscaSoloUnDato(CampoDescripcion,Tabla,sSQLCondicion,"",Conexion),"&nbsp;") 
			sElemento += " </p>" 
			
			if (iOcultoTipo2 == 2) {
				sElemento += " <input type='hidden'"  
				sElemento += " name='" + NombreCombo + "'" 
				sElemento += " id='" + NombreCombo + "'"  
				sElemento += " value='" + Seleccionado + "'>" 
			}

			if(!EsVacio(sOpcAyuda)){
				sElemento += "<span class='help-block m-b-none'><i class='fa fa-question-circle'></i>"
				sElemento += "&nbsp;" + sOpcAyuda
				sElemento += "</span>"
			}
				
		}
		
		sResultado = sElemento
		
	}
		
	return sResultado
		
}
		
// 5 == checkbox
		 //CajaSeleccion(sMFCCampo,Eventos,Parametro(sMFCCampo,sMFCValorDefault),1,iMFCRequerido,Modo,sMFCTextoAyuda,Estilo)		
function CajaSeleccion(NombreCaja,EventosClases,ValorParametro,Valor,Requerido,Modo,sOpcAyuda,Estilo) {
	
	var sRespuesta = ""
	
		if (Modo == "Editar" ) {
				
			sRespuesta += "<label class='" + Estilo + "'>"
				sRespuesta += "<input name='" + NombreCaja + "' type='checkbox' " //+ EventosClases
				sRespuesta += " id='" + NombreCaja + "' value='" + Valor + "' "
				if (ValorParametro == Valor ) {
					sRespuesta +=  " checked "
				}
				sRespuesta += " class='" + EventosClases 
				if(Requerido==1){
					sRespuesta += " validate[required]"
				}				
				sRespuesta += "' >"
			sRespuesta += "</label>"

			if(!EsVacio(sOpcAyuda)){
				sRespuesta += "<span class='help-block m-b-none'><i class='fa fa-question-circle'></i>"
				sRespuesta += "&nbsp;" + sOpcAyuda
				sRespuesta += "</span>"
			}
				
		}
					
		if (Modo != "Editar" ) {
		
			if (ValorParametro == Valor ) {
				sRespuesta += "<p class='SoloConsulta'>S&iacute;&nbsp;<img src='Img/Bien.png' width='16' height='16' /></p>"
			} else {
				sRespuesta += "<p class='SoloConsulta'>No&nbsp;<img src='Img/Mal.png' width='16' height='16' /></p>"
			}
			
			if (iOcultoTipo2 == 2) {
				sRespuesta += " <input type='hidden'" 
				sRespuesta += " name='" + NombreCaja + "'" 
				sRespuesta += " id='" + NombreCaja + "'" 
				sRespuesta += " value='" + ValorParametro + "'>"
			}

			if(!EsVacio(sOpcAyuda)){
				sRespuesta += "<span class='help-block m-b-none'><i class='fa fa-question-circle'></i>"
				sRespuesta += "&nbsp;" + sOpcAyuda
				sRespuesta += "</span>"
			}
				
		}
		
	return sRespuesta
	
}
		
// 7 = combo Catálogo General
//ComboSeccionFicha(sMFCCampo,sEventos,sSeccion,Parametro(sMFCCampo,sMFCValorDefault),0,sTodos,sOrden,iMFCRequerido,sModoRO,sEstilo,sMFCTextoAyuda)				
function ComboSeccionFicha(NombreCombo,Eventos,Seccion,Seleccionado,Conexion,Todos,Orden,Requerido,Modo,Estilo,sOpcAyuda) {

	var sElemento = ""
	var sResultado = ""

		if (Modo == "Editar") {		
			
			if (iMFCInformativo > 0) {
			
				var sCondicion = " Sec_ID = " + Seccion + " AND Cat_ID = " + Seleccionado
					
					sResultado = " <p class='SoloConsulta'> " 
					sResultado += IFAnidado(!EsVacio(BuscaSoloUnDato("Cat_Nombre","Cat_Catalogo",sCondicion,"",Conexion)),BuscaSoloUnDato("Cat_Nombre","Cat_Catalogo",sCondicion,"",Conexion),"&nbsp;")
					sResultado += " </p>"
				
				if (iOcultoTipo2 == 2) {
					sResultado += "<input type='hidden'"  
					sResultado += " name='" + NombreCombo + "'" 
					sResultado += " id='" + NombreCombo + "'" 
					sResultado += " value='" + Seleccionado + "'>"
				}
			
			} else {
			
				sResultado = "<select name='" + NombreCombo + "' id='" + NombreCombo + "' " + Eventos 
				sResultado += " class='" + Estilo
				if(Requerido==1){
					sResultado += " validate[required]"
				} 
				sResultado += "' >"
				
					if (Todos != "") {
						sElemento = "<option value='-1'"
						if (Seleccionado == -1) { sElemento += " selected " }
						sElemento += ">" + Todos + "</option>"
					}
				var CCSQL = "SELECT Cat_ID, Cat_Nombre FROM Cat_Catalogo WHERE Sec_ID = " + Seccion + " ORDER BY "
					if(!EsVacio(Orden)) {
						CCSQL += Orden + ", "
					}
					CCSQL += " Cat_Nombre "
				//Response.Write(CCSQL)
				var rsCC = AbreTabla(CCSQL,1,Conexion) 
					while (!rsCC.EOF){
						sElemento += "<option value='" + rsCC.Fields.Item(0).Value + "'"
						if (Seleccionado == rsCC.Fields.Item(0).Value) { sElemento += " selected " }
						sElemento += ">" + rsCC.Fields.Item(1).Value+"</option>"
						rsCC.MoveNext()
					}
					rsCC.Close()
					sResultado += sElemento + "</select>"

				if(!EsVacio(sOpcAyuda)){
					sResultado += "<span class='help-block m-b-none'><i class='fa fa-question-circle'></i>"
					sResultado += "&nbsp;" + sOpcAyuda
					sResultado += "</span>"
				}

			}
			
			
		} else {
			
			var sCondicion = " Sec_ID = " + Seccion + " AND Cat_ID = " + Seleccionado
			
			sResultado = " <p class='SoloConsulta'> " 
			sResultado += IFAnidado(!EsVacio(BuscaSoloUnDato("Cat_Nombre","Cat_Catalogo",sCondicion,"",Conexion)),BuscaSoloUnDato("Cat_Nombre","Cat_Catalogo",sCondicion,"",Conexion),"&nbsp;")
			sResultado += " </p>"
			
			if (iOcultoTipo2 == 2) {
				sResultado += "<input type='hidden'"  
				sResultado += " name='" + NombreCombo + "'" 
				sResultado += " id='" + NombreCombo + "'" 
				sResultado += " value='" + Seleccionado + "'>"
			}
				
			if(!EsVacio(sOpcAyuda)){
				sResultado += "<span class='help-block m-b-none'><i class='fa fa-question-circle'></i>"
				sResultado += "&nbsp;" + sOpcAyuda
				sResultado += "</span>"
			}
			
		}

	return sResultado

}
			
//ComboSeccionFichaXTXT			
function ComboSeccionFichaXTXT(NombreCombo,Eventos,Seccion,Seleccionado,Conexion,Todos,Orden,Requerido,Modo,Estilo,sOpcAyuda) {
	
	var sElemento = ""
	var sResultado = ""

		if (Modo == "Editar") {
			
			if (iMFCInformativo > 0) {
				
				var sCondicion = " Sec_ID = " + Seccion + " AND Cat_LlaveTexto = '" + Seleccionado + "'"

					//sResultado = " <p class='SoloConsulta'> " + BuscaSoloUnDato("(Cat_Nombre + ' - ' + Cat_Descripcion)","Cat_Catalogo",sCondicion,"",Conexion) + " </p>"
			
					sResultado = " <p class='SoloConsulta'> " 
					sResultado += IFAnidado(!EsVacio(BuscaSoloUnDato("(Cat_Nombre + ' - ' + Cat_Descripcion)","Cat_Catalogo",sCondicion,"",Conexion)),BuscaSoloUnDato("(Cat_Nombre + ' - ' + Cat_Descripcion)","Cat_Catalogo",sCondicion,"",Conexion),"&nbsp;")
					sResultado += " </p>"
				
				if (iOcultoTipo2 == 2) {
					sResultado += "<input type='hidden'"  
					sResultado += " name='" + NombreCombo + "'" 
					sResultado += " id='" + NombreCombo + "'" 
					sResultado += " value='" + Seleccionado + "'>"
				}
								
			} else {
				
				sResultado = "<select name='" + NombreCombo + "' id='" + NombreCombo + "' " + Eventos 
				sResultado += " class='" + Estilo
				if(Requerido==1){
					sResultado += " validate[required]"
				} 
				sResultado += "' >"
					if (Todos != "") {
						sElemento = "<option value=''"
						if (Seleccionado == -1) { sElemento += " selected " }
						sElemento += ">" + Todos + "</option>"
					}
				var CCSQL = "SELECT Cat_LlaveTexto, Cat_Nombre + ' - ' + Cat_Descripcion "
				    CCSQL += " FROM Cat_Catalogo WHERE Sec_ID = " + Seccion + " ORDER BY "
					if(!EsVacio(Orden)) {
						CCSQL += Orden + ", "
					}
					CCSQL += " Cat_Nombre "
				//Response.Write(CCSQL)
				var rsCC = AbreTabla(CCSQL,1,Conexion) 
					while (!rsCC.EOF){
						sElemento += "<option value='" + rsCC.Fields.Item(0).Value + "'"
						if (Seleccionado == rsCC.Fields.Item(0).Value) { sElemento += " selected " }
						sElemento += ">" + rsCC.Fields.Item(1).Value+"</option>"
						rsCC.MoveNext()
					}
					rsCC.Close()
					sResultado += sElemento + "</select>"
			
					if(!EsVacio(sOpcAyuda)){
						sResultado += "<span class='help-block m-b-none'><i class='fa fa-question-circle'></i>"
						sResultado += "&nbsp;" + sOpcAyuda
						sResultado += "</span>"
					}
			
			} 
			
		} else {
	
			var sCondicion = " Sec_ID = " + Seccion + " AND Cat_LlaveTexto = '" + Seleccionado + "' "
			
				//sResultado = " <p class='SoloConsulta'> " + BuscaSoloUnDato("(Cat_Nombre + ' - ' + Cat_Descripcion)","Cat_Catalogo",sCondicion,"",Conexion) + " </p>"

				sResultado = " <p class='SoloConsulta'> " 
				sResultado += IFAnidado(!EsVacio(BuscaSoloUnDato("(Cat_Nombre + ' - ' + Cat_Descripcion)","Cat_Catalogo",sCondicion,"",Conexion)),BuscaSoloUnDato("(Cat_Nombre + ' - ' + Cat_Descripcion)","Cat_Catalogo",sCondicion,"",Conexion),"&nbsp;")
				sResultado += " </p>"
			
				if (iOcultoTipo2 == 2) {
					sResultado += "<input type='hidden'"  
					sResultado += " name='" + NombreCombo + "'" 
					sResultado += " id='" + NombreCombo + "'" 
					sResultado += " value='" + Seleccionado + "'>"
				}

				if(!EsVacio(sOpcAyuda)){
					sResultado += "<span class='help-block m-b-none'><i class='fa fa-question-circle'></i>"
					sResultado += "&nbsp;" + sOpcAyuda
					sResultado += "</span>"
				}

		}
	
	return sResultado
	
}			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			

%>
