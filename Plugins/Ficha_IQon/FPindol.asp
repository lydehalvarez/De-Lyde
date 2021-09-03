<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../Includes/iqon.asp" -->
<%
VentanaIndex = 610
SistemaActual=30
Modo = "Editar"
Accion =  "Consulta"

var iDebugSubQuerys = 0
var iIQonDebug = 1 //IFAnidado(Parametro("IDUsuario",0) == 358,0,1)
var iIQonSentNecesaria = 0
if (Parametro("VentanaIndex",0)== 3 ) {  //sustituye el 3 por el numero de ventana para que el debug solo sea para esa ventana
	iIQonDebug = 1 //IFAnidado(Parametro("IDUsuario",0) == 358,0,1)
    iIQonSentNecesaria = 1
}
if (Parametro("IDUsuario",Session("IDUsuario")) == 358) {
	iIQonDebug = 0 
	iIQonSentNecesaria = 1
}
var iOcultoTipo2 = 0    // tipo 2 es cuando en el campo de oculto viene un 2 entonces se verificara que el campo venga como solo lectura y se
						//  colocara el dato con un oculto
									

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
						
function ProcesaCondicionPorParametros(sParametros) {
		var arrOQPP    = new Array(0)
		var arrOQCampo = new Array(0)
		var bEnc       = false
		var sResultado = ""
		
		//validando formato de entrada
		
		if (sParametros.substring(0,4) == "SQL,") {
			var iLargoVD = sParametros.length 
			sResultado = "" + sParametros.substring(4,iLargoVD)
		} else {
			if (!EsVacio(sParametros) ) {  		              //se extraen los parametros que se envian
				arrOQPP = sParametros.split("|")
				for (oi=0;oi<arrOQPP.length;oi++) {	
					var Txt = String(arrOQPP[oi])
					var arrOQCampo = Txt.split(",")
					//Response.Write("<font color='red' size='2'><strong>arrOQCampo &nbsp;" + arrOQCampo + "</strong></font> ")
					//pendiente falta poner el tipo de dato N=numero F=fecha T=texto para clavarle unas comillas o el formato de fecha
					//   N
					var tA = ""
					var tB = ""
					if (arrOQCampo[3] == "T") {
						var tA = "'"
						var tB = "'"
					}
					var sTmpPP = Parametro(String(arrOQCampo[1]),String(arrOQCampo[2]))
					//Response.Write("<font color='red' size='2'><strong>  campo  &nbsp;" + arrOQCampo[1] + "</strong></font>")
					//Response.Write("<font color='red' size='2'><strong>  default  &nbsp;" + arrOQCampo[2] + "</strong></font>")
					//Response.Write("<font color='red' size='2'><strong>  valor &nbsp;" + sTmpPP + "</strong></font><br />")
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

function SerializaCondicionPorParametros(sParametros) {
		
		var arrOQPP    = new Array(0)
		var arrOQCampo = new Array(0)
		var bEnc       = false
		var sResultado = ""
		
		//validando formato de entrada
		
		if (!EsVacio(sParametros) ) {  		              //se extraen los parametros que se envian
			arrOQPP = sParametros.split("|")
			for (oi=0;oi<arrOQPP.length;oi++) {	
				var Txt = String(arrOQPP[oi])
				var arrOQCampo = Txt.split(",")
				//pendiente falta poner el tipo de dato N=numero F=fecha T=texto para clavarle unas comillas o el formato de fecha
				//   N
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

		
function CajaSeleccion(NombreCaja,EventosClases,ValorParametro,Valor,Modo) {
var sRespuesta = ""
	if (Modo == "Editar" ) {
		sRespuesta += "<input name='" + NombreCaja + "' type='checkbox' " + EventosClases
		sRespuesta += " id='" + NombreCaja + "' value='" + Valor + "' "
		if (ValorParametro == Valor ) {
			sRespuesta +=  " checked "
		}
		sRespuesta +=  " >"
	}
	if (Modo != "Editar" ) {
		if (ValorParametro == Valor ) {
			sRespuesta +=  "S&iacute;&nbsp;<img src='Img/Bien.png' width='16' height='16' />"
		} else {
			sRespuesta +=  "No&nbsp;<img src='Img/Mal.png' width='16' height='16' />"
		}
		if (iOcultoTipo2 == 2) {
			sRespuesta += " <input type=" + sC + "hidden" + sC 
			sRespuesta += " name=" + sC + NombreCaja + sC 
			sRespuesta += " id=" + sC + NombreCaja + sC 
			sRespuesta += " value=" + sC + ValorParametro + sC + "> "
		}
	}
	
	return sRespuesta
}
 
function OpcionesFicha(NombreCaja,EventosClases,SarrOpciones,SarrValores,ValorActual,Modo) {
var sRespuesta = ""
var Opciones = new Array(0)
var ValoresOpc = new Array(0)
var i = 0
var Txt = ""

//  NombreCaja  es el nombre que tienen todos los option

Txt = String(SarrOpciones)     // es el nombre que se pone en el id para diferenciarlos del grupo  
Opciones = Txt.split(",")
Txt = String(SarrValores)      // es el valor que cada uno tiene
ValoresOpc = Txt.split(",")


	if (Modo == "Editar" ) {
		for (i=0;i<Opciones.length;i++) {
			 sRespuesta += "<label><input type=" + sC + "radio" + sC + " name=" + sC + NombreCaja + sC + " id=" + sC + Opciones[i] 
			 sRespuesta += sC + " value=" + sC + ValoresOpc[i] + sC + " " 
			 if (ValoresOpc[i] == ValorActual) { sRespuesta += " checked " }
			 sRespuesta += " />"
			 sRespuesta +=  Opciones[i] + "</label>"
		}
	}
	if (Modo != "Editar" ) {
		for (i=0;i<Opciones.length;i++) {
			if (ValoresOpc[i] == ValorActual) {
				sRespuesta =  "&nbsp;" + Opciones[i] }
				
		}
		if (iOcultoTipo2 == 2) {
			sRespuesta += " <input type=" + sC + "hidden" + sC 
			sRespuesta += " name=" + sC + NombreCaja + sC 
			sRespuesta += " id=" + sC + NombreCaja + sC 
			sRespuesta += " value=" + sC + ValorActual + sC + "> "
		}
	}
	
	return sRespuesta
}

function AplicaFormato(iFormato,sValor) {
	var sResultado = String(sValor)
	
	switch (iFormato) {
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
//			valor = 1234567.3456;
//			function funcion(){
//			valorParseado = (parseFloat(valor).toFixed(2)).toString().split(". ");
//			valorParseado2 = valorParseado[0].toString().split("").reverse().join("").replace(/\d{3}(?=\d)/g, function(encaja){ return encaja+'.';})
//			alert(valorParseado2.toString().split("").reverse( ).join("")+','+valorParseado[1]);
//			}
			break;
		case 4:
			if (sResultado == 1) {
				sResultado = "Si"
			} else {
				sResultado = "No"
			}
			break;
		case 5:
			var stfc6 = FormatoFechaII( sResultado,"CST a fecha","Guardar")
			if (stfc6 != "01/01/1900") {
				 sResultado = stfc6    
			} 
			
//			sResultado =  CambiaFormatoFecha(sResultado,"yyyy-mm-dd","dd/mm/yyyy")
//			sResultado =  FormatoFecha(sResultado ,"UTC a dd/mm/yyyy")
			break;			
		case 6:  //fechas solo identificacion y conversion
			//sResultado = FormatoFecha(sResultado ,"CST a dd/mm/yyyy")
			sResultado = FormatoFechaII(sResultado,"UTC s/fecha","Consulta") 
			break;	
		case 7:  //fechas solo identificacion y conversion
			//sResultado = FormatoFecha(sResultado ,"CST a dd/mm/yyyy")
			sResultado = FormatoFechaII(sResultado,"UTC","Consulta") 
			break;							
		default:
			sResultado = sValor
		break;							
	} 

	return sResultado
}

function ComboSeccionFicha(NombreCombo,Eventos,Seccion,sCondicion,Seleccionado,Conexion,Todos,Orden,Modo) {
	var sElemento = ""
	var sResultado = ""

	if (Modo == "Editar") {
		sResultado = "<select name='" + NombreCombo + "' id='" + NombreCombo + "' " + Eventos + ">"
			if (Todos != "") {
				sElemento = "<option value='-1'"
				if (Seleccionado == -1) { sElemento += " selected " }
				sElemento += ">" + Todos + "</option>"
			}
		var CCSQL = "SELECT Cat_ID, Cat_Nombre FROM Cat_Catalogo WHERE Sec_ID = " + Seccion
			if(!EsVacio(sCondicion)) {
				CCSQL += " AND " + sCondicion + "  "
			}		
		    CCSQL += " ORDER BY "
			if(!EsVacio(Orden)) {
				CCSQL += Orden + ", "
			}
			CCSQL += " Cat_Nombre"
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
			
//			sResultado += "<script language=\"JavaScript\">"
//			//sResultado += ""
//			sResultado += "$(function() {"
//			//sResultado += "$('#" + NombreCombo + "').change(function() { Cbo" + NombreCombo + "(this.value()); });"
//			sResultado += "$('#" + NombreCombo + "').change(function() { alert('yijaaaa'); });"
//			sResultado += "});"
//			//sResultado += "//"
//			sResultado += "</  script  >"
					
	} else {
		var sCondicion = "  Sec_ID = " + Seccion + " and Cat_ID = " + Seleccionado
		sResultado = BuscaSoloUnDato("Cat_Nombre","Cat_Catalogo",sCondicion,"",Conexion)
		if (iOcultoTipo2 == 2) {
			sResultado += " <input type=" + sC + "hidden" + sC 
			sResultado += " name=" + sC + NombreCombo + sC 
			sResultado += " id=" + sC + NombreCombo + sC 
			sResultado += " value=" + sC + Seleccionado + sC + "> "
		}
	}
	
	return sResultado
	
}


function CargaComboFicha(NombreCombo,Eventos,CampoID,CampoDescripcion,Tabla,Condicion,Orden,Seleccionado,Conexion,Todos,Modo) {
	var sElemento = ""
	var sResultado = ""
	
	if (EsVacio(Seleccionado)) {Seleccionado = -1 }
	if (Modo == "Editar") {
		sResultado = "<select name='"+NombreCombo+"' id='"+NombreCombo+"' " + Eventos + " >"
			if (Todos != "") {
				sElemento = "<option value='-1'"
				if (Seleccionado == -1) { sElemento += " selected " }
				sElemento += ">" + Todos + "</option>"
			}
		var CCSQL = "SELECT " + CampoID +", " + CampoDescripcion + " FROM " + Tabla
		if (Condicion != "") { CCSQL += " WHERE " + Condicion }
		if (Orden != "") { CCSQL += " ORDER BY " + Orden }
		var rsCC = AbreTabla(CCSQL,1,Conexion) 
		while (!rsCC.EOF){
		//Response.Write("<br>" + rsCC.Fields.Item(1).Value)
			sElemento += "<option value='"+rsCC.Fields.Item(0).Value+"'"
			if (Seleccionado == rsCC.Fields.Item(0).Value) { sElemento += " selected " }
			sElemento += ">" + rsCC.Fields.Item(1).Value + "</option>"
			rsCC.MoveNext()
		}
		sResultado += sElemento
		rsCC.Close()
		sResultado += "</select>"
	} else {
		if (EsVacio(Seleccionado)) {Seleccionado = -1 }
		if (Seleccionado == -1) {
			sElemento = Todos
		} else {
			var sSQLCondicion = " " + CampoID + " = " + Seleccionado 
			if (Condicion != "") { sSQLCondicion += " and " + Condicion }
			sElemento = BuscaSoloUnDato(CampoDescripcion,Tabla,sSQLCondicion,"",Conexion)
			if (iOcultoTipo2 == 2) {
				sElemento += " <input type=" + sC + "hidden" + sC 
				sElemento += " name=" + sC + NombreCombo + sC 
				sElemento += " id=" + sC + NombreCombo + sC 
				sElemento += " value=" + sC + Seleccionado + sC + "> "
			}
		}
		sResultado = sElemento
	}
	return sResultado
}
	
function CargaBotones() {

	var sBot = "<p class='form-submit'>"
		sBot += "<div id='areafunciones' ></div>" 
		sBot += "<div class='form-actions' id='areabotones' align='right'>"
	if (Modo == "Editar") {
		if (iMWPuedeEditar >= 1 && Session("Editar") == 1) {			
		sBot += "<a id=\"btnCancelar\" class=\"button button_small button_blue \" href=\"#\" onClick=\"javascript:AcFCancelar();\"><i class=\"icon-undo\"></i> Cancelar</a>&nbsp;&nbsp;&nbsp;&nbsp;"	
		sBot += "<a id=\"btnGuardar\" class=\"button button_small button_blue \" href=\"#\" onClick=\"javascript:AcFGuardar();\"><i class=\"icon-save\"></i> Guardar</a>&nbsp;&nbsp;&nbsp;&nbsp;"			
		}
	} else {
		if (iMWPuedeBorrar >= 1 && Session("Borrar") == 1) {
		sBot += "<a id=\"btnBorrar\" class=\"button button_small button_blue \" href=\"#\" onClick=\"javascript:AcFBorrar();\"><i class=\"icon-remove\"></i> Borrar</a>&nbsp;&nbsp;&nbsp;&nbsp;"			
		}
		if (iMWPuedeEditar >= 1 && Session("Editar") == 1) {
		sBot += "<a id=\"btnEditar\" class=\"button button_small button_blue \" href=\"#\" onClick=\"javascript:AcFEditar();\"><i class=\"icon-edit\"></i> Editar</a>&nbsp;&nbsp;&nbsp;&nbsp;"				
		}
		if (iMWPuedeAgregar >= 1 && Session("Agregar") == 1) {	
		sBot += "<a id=\"btnNuevo\" class=\"button button_small button_blue \" href=\"#\" onClick=\"javascript:AcFNuevo();\"><i class=\"icon-plus\"></i> Nuevo</a>&nbsp;&nbsp;&nbsp;&nbsp;"				
				
		}
	}				
	sBot += "</div></p>"
	
	return sBot
}	
	

function CargaDatos() {
	
	
	if (iIQonDebug == 1) {	
	Response.Write("<font color='red'>*********<strong>418 CargaDatos&nbsp</strong>******</font><br />")	
	}
	
	
	var sResultado = ""
	var iPRCAnchoCol = 25
	
	//comienza tabla de secciones  
		sResultado = ""
		
			//aqui se cargan las secciones

		var sATCps = "SELECT * "
			sATCps += " FROM MenuFichaSeccion "
			sATCps += " WHERE MFS_Habilitado = 1 "
			sATCps += " AND Sys_ID = " + SistemaActual
			sATCps += " AND WgCfg_ID = " + iWgCfgID
			//sATCps += " AND Mnu_ID = " + mnuid
			sATCps += " ORDER BY MFS_Orden "

		var rsSeccion = AbreTabla(sATCps,1,2)
		if (rsSeccion.EOF){ 
			return ""
		} 
		iPRCAnchoCol = 25
		while (!rsSeccion.EOF){
			var sCondRegCol = " MFC_Habilitado = 1 "
				sCondRegCol += " AND Sys_ID = " + rsSeccion.Fields.Item("Sys_ID").Value
				sCondRegCol += " AND WgCfg_ID = " + rsSeccion.Fields.Item("WgCfg_ID").Value
				sCondRegCol += " AND MFS_ID = " + rsSeccion.Fields.Item("MFS_ID").Value
				sCondRegCol += " AND MFC_EsOculto = 0 "
				sCondRegCol += " AND MFC_EsPKPrincipal = 0 "
				sCondRegCol += " AND MFC_EsPK = 0 "
				//Response.Write("<br /><font color='red' size='2'><strong>sCondRegCol&nbsp;" + sCondRegCol + "</strong></font><br />")
			var iColPorSecReg = BuscaSoloUnDato("MAX(MFC_Columna)","MenuFichaCampos",sCondRegCol,1,2)
			var iRegPorSec = BuscaSoloUnDato("MAX(MFC_Renglon)","MenuFichaCampos",sCondRegCol,1,2)

			sResultado += "<h3 id=\"reply-title\" class=\"comment-reply-title\">"
			sResultado += "" + rsSeccion.Fields.Item("MFS_Nombre").Value
			sResultado += "</h3>"
			

			var sFCHCps = "SELECT * "
			    sFCHCps += " ,(select COUNT(*) "
			    sFCHCps += "  from MenuFichaCampos mfcx "
			    sFCHCps += "  where mfc.Sys_ID = mfcx.Sys_ID "
			    sFCHCps += " and mfc.WgCfg_ID = mfcx.WgCfg_ID "
			    sFCHCps += " and mfc.MFS_ID = mfcx.MFS_ID "
			    sFCHCps += " and mfc.MFC_Renglon = mfcx.MFC_Renglon "
			    sFCHCps += " and mfcx.MFC_Columna > mfc.MFC_Columna "
			    sFCHCps += " ) as colspan "
			    sFCHCps += " FROM MenuFichaCampos mfc " 
				sFCHCps += " WHERE MFC_Habilitado = 1 "
				sFCHCps += " AND Sys_ID = " + rsSeccion.Fields.Item("Sys_ID").Value
				sFCHCps += " AND WgCfg_ID = " + rsSeccion.Fields.Item("WgCfg_ID").Value
				//sFCHCps += " AND Mnu_ID = " + rsSeccion.Fields.Item("Mnu_ID").Value
				sFCHCps += " AND MFS_ID = " + rsSeccion.Fields.Item("MFS_ID").Value
				sFCHCps += " AND MFC_EsOculto <> 1 "
				sFCHCps += " AND MFC_EsPKPrincipal = 0 "
				sFCHCps += " AND MFC_EsPK = 0 "
				sFCHCps += " ORDER BY MFC_Renglon, MFC_Columna "
		
			var iRen = 1
			var iCol = 1
			var iColumna = 1
			var sEtiqueta = ""
			var sCampo = ""
			var sNombreCampo = ""
			var sCampoLlave = ""
			var iFormato = 0
			var sValorDefault = ""
			var ValorDelCampo = ""
			var bEsInformativo = ""
			var sTabla = "" 
			var sCampoDesc = ""
			var sCondicion = "" 
			var iSoloLectura = 0
			var sOrden = ""			
			var iVueltas = 0
			var iControl = 1
			var bUsado = false
			var iMFSID = -1
			var iMFCID = -1
			var iMFCEtiqueta = -1
			var iMFCAnchoEtiqueta = -1
			var iMFCAnchoCampo = -1
			var sMFCAlineacion = ""
			var iColPorRenglon = 1
			var iControl = 1
			var iNumCampo = 0

			
			var iColPorSecRegOriginal = iColPorSecReg
				iColPorSecReg = iColPorSecReg*2
				var arrAnchoColumnas = new Array(iColPorSecReg)
				var iPos = 0
				var sSQLAnVal = ""
				var sSQLAnchoFin = ""
				var sSQLAncho = " FROM MenuFichaCampos " 
					sSQLAncho += " WHERE MFC_Habilitado = 1 "
					sSQLAncho += " AND Sys_ID = " + rsSeccion.Fields.Item("Sys_ID").Value
					sSQLAncho += " AND WgCfg_ID = " + rsSeccion.Fields.Item("WgCfg_ID").Value
					sSQLAncho += " AND MFS_ID = " + rsSeccion.Fields.Item("MFS_ID").Value
					sSQLAncho += " AND MFC_EsOculto <> 1 "
					sSQLAncho += " AND MFC_EsPKPrincipal = 0 "
					sSQLAncho += " AND MFC_EsPK = 0 "	
		
				//leo de la bd el valor maximo de ancho de columnas
//				for (AC=1;AC<=iColPorSecRegOriginal;AC++) {
//					var sSQLAnVal = "SELECT ISNULL(max(MFC_AnchoEtiqueta),0) "
//					    sSQLAnVal += sSQLAncho
//						sSQLAnVal += " AND MFC_Columna = " + AC
//					var rsAncho = AbreTabla(sSQLAnVal,1,2) 
//					iPos = (AC * 2) - 1
//					arrAnchoColumnas[iPos] = 0
//					if (!rsAncho.EOF){
//						arrAnchoColumnas[iPos] = rsAncho.Fields.Item(0).Value 
//						if (EsVacio(arrAnchoColumnas[iPos])) {arrAnchoColumnas[iPos] = 0 }
//					}
//					rsAncho.Close()
//					var sSQLAnVal = "SELECT ISNULL(max(MFC_AnchoCampo),0) "
//					    sSQLAnVal += sSQLAncho
//						sSQLAnVal += " AND MFC_Columna = " + AC
//						//Response.Write("<br>" + AC + ") Etiqueta" + sSQLAnVal)
//					var rsAncho = AbreTabla(sSQLAnVal,1,2) 
//					iPos = (AC * 2)
//					arrAnchoColumnas[iPos] = 0
//					if (!rsAncho.EOF){
//						arrAnchoColumnas[iPos] = rsAncho.Fields.Item(0).Value
//						if (EsVacio(arrAnchoColumnas[iPos])) {arrAnchoColumnas[iPos] = 0 }
//					} 
//					rsAncho.Close()
//				}
				
					
				//valido cuantos no tienen valor al ancho 
//				var iSinValor = 0
//				var  iSumaAnchos = 0
//				for (AC=1;AC<=iColPorSecReg;AC++) {
//					if (EsVacio(arrAnchoColumnas[AC])) {
//						arrAnchoColumnas[AC] = 0
//					}
//					iSumaAnchos += parseInt(arrAnchoColumnas[AC])
//					if (arrAnchoColumnas[AC]==0) {
//						iSinValor++
//					}
//				}
//				iPRCAnchoCol = (100 - iSumaAnchos)/iSinValor
//				for (AC=1;AC<=iColPorSecReg;AC++) {
//					if (arrAnchoColumnas[AC]==0) {
//						arrAnchoColumnas[AC]=iPRCAnchoCol
//					}
//				}
						

//					<div class="control-group">
//					  <label class="control-label" for="date01">Date input</label>
//					  <div class="controls">
//						<input type="text" class="input-xlarge datepicker hasDatepicker" id="date01" value="02/16/12">
//					  </div>
//					</div>

				var rsCampos = AbreTabla(sFCHCps,1,2)

				while (!rsCampos.EOF){ 
					iNumCampo++
					sCampo = ""
					sEtiqueta = "" + rsCampos.Fields.Item("MFC_Etiqueta").Value
					iSoloLectura = rsCampos.Fields.Item("MFC_SoloLectura").Value
					iOcultoTipo2 = rsCampos.Fields.Item("MFC_EsOculto").Value
					iFormato = rsCampos.Fields.Item("MFC_Formato").Value				
				
					sResultado += "<div class='control-group'>"
					sResultado += "<label class='control-label' for='Campo" + iNumCampo + "'>" + sEtiqueta + "</label>"
					sResultado += "<div class='controls span6'>"
				
					//********* Armado de Objetos *****************

						var sModoRO = Modo
						if (iSoloLectura == 1) {
							sModoRO = "Consulta"
						}
						bEsInformativo = rsCampos.Fields.Item("MFC_Informativo").Value
						if (bEsInformativo == 1) {
							sModoRO = "Consulta"
						}
						if (bEsInformativo == 2) {
							if (bRegistroNuevo) {
							    sModoRO = "Editar"
							} else {
								sModoRO = "Consulta"
							}
						}
						if (bEsInformativo == 3) {
							if (!bRegistroNuevo) {
							    sModoRO = "Editar"
							} else {
								sModoRO = "Consulta"
							}
						}
						if (rsCampos.Fields.Item("MFC_EditablePermanente").Value == 1) {
							sModoRO = "Editar"
						}
						sNombreCampo = "" + rsCampos.Fields.Item("MFC_Campo").Value
						sCampoLlave = "" + rsCampos.Fields.Item("MFC_ComboCampoLlave").Value
						if (EsVacio(sCampoLlave)) {
							sCampoLlave = sNombreCampo
						}
						var sValorDefaultBD = "" + rsCampos.Fields.Item("MFC_ValorDefault").Value
						sValorDefault = ProcesaValorDefault(sValorDefaultBD)

						sTabla = "" + rsCampos.Fields.Item("MFC_ComboTabla").Value
						sCampoDesc = "" + rsCampos.Fields.Item("MFC_ComboCampoDesc").Value
						sCondicion = "" + rsCampos.Fields.Item("MFC_ComboCondicion").Value
						sOrden = "" + rsCampos.Fields.Item("MFC_Orden").Value
						sLeyendaTodos = "" + rsCampos.Fields.Item("MFC_LeyendaSelecTodos").Value

						ValorDelCampo = Parametro( sNombreCampo , sValorDefault  )

											
						switch (parseInt(rsCampos.Fields.Item("MFC_TipoCampo").Value)) {
									case 1:						//			1 = text box
										if (sModoRO == "Editar") {
											var sClass = ""
											if (!EsVacio(rsCampos.Fields.Item("MFC_Class").Value)) {
												sClass = "" + rsCampos.Fields.Item("MFC_Class").Value 
											} 
											sCampo = "&nbsp;<input name=" + sC +  sNombreCampo + sC 
											sCampo += " type=" + sC + "text" + sC + " class=" + sC + sClass + sC 
											sCampo +=  " id=" + sC +sNombreCampo + sC 
											//sCampo += " style=" + sC + "width:90%" + sC + " "
											sCampo += " value=" + sC 
											sCampo += ValorDelCampo + sC 
											sCampo += " maxlength=" + sC + "100" + sC 
											if (iSoloLectura == 1) {
												sCampo += " readonly=" + sC + "readonly" + sC + " "
											}
											sCampo += " autocomplete=\"off\" >"
										} else {
										    sCampo = "&nbsp;" + AplicaFormato(iFormato,ValorDelCampo)
											if (iOcultoTipo2 == 2) {
												sCampo += " <input type=" + sC + "hidden" + sC 
												sCampo += " name=" + sC + sNombreCampo + sC 
												sCampo += " id=" + sC + sNombreCampo + sC 
												sCampo += " value=" + sC + ValorDelCampo + sC + "> "
											}
										}
										break;
									case 2:						//			2 = option
										if (!EsVacio(rsCampos.Fields.Item("MFC_arrValores").Value)) {
											var Valores = new Array(0)
											var Txt =""
											Txt = String(rsCampos.Fields.Item("MFC_arrValores").Value)    // se explota el contenido para separar las opciones de los valores
											Valores = Txt.split("|")										
											var SarrOpciones  = Valores[0]
											var SarrValores	  = Valores[1]		
										}									
										var Eventos = ""
										if (!EsVacio(rsCampos.Fields.Item("MFC_Class").Value)) {
											Eventos = "class='" +  rsCampos.Fields.Item("MFC_Class").Value + "'  "
										}
										if (!EsVacio(rsCampos.Fields.Item("MFC_EventosJS").Value)) {
											Eventos += "  " +  rsCampos.Fields.Item("MFC_EventosJS").Value 
										}									
										sCampo = "&nbsp;" + OpcionesFicha(sNombreCampo,Eventos,SarrOpciones,SarrValores,ValorDelCampo,sModoRO)
										//OpcionesFicha(NombreCaja,EventosClases,SarrOpciones,SarrValores,ValorActual,Modo)

										break;
									case 3:						//			3 = combo de cualquier tabla					
										var sCatalogoAUsarCampoDato = FiltraVacios(rsCampos.Fields.Item("MFC_ComboCampoDesc").Value)
										var sTablaCatalogo = FiltraVacios(rsCampos.Fields.Item("MFC_ComboTabla").Value)
										var sCatalogoAUsarCondicion = FiltraVacios(rsCampos.Fields.Item("MFC_ComboCondicion").Value)
		    							sCatalogoAUsarCondicion = ProcesaCondicionPorParametros(sCatalogoAUsarCondicion)
			
										var Eventos = ""
										if (!EsVacio(rsCampos.Fields.Item("MFC_Class").Value)) {
											Eventos = "class='" +  rsCampos.Fields.Item("MFC_Class").Value + "'  "
										}
										if (!EsVacio(rsCampos.Fields.Item("MFC_EventosJS").Value)) {
											Eventos += "  " +  rsCampos.Fields.Item("MFC_EventosJS").Value 
										}									
											//NombreCombo,Eventos,CampoID,CampoDescripcion,Tabla,Condicion,Orden,Seleccionado,Conexion,Todos,Modo
											sCampo = "&nbsp;" + CargaComboFicha(sNombreCampo,Eventos,sCampoLlave,
																sCatalogoAUsarCampoDato,sTablaCatalogo,sCatalogoAUsarCondicion,
																sNombreCampo,ValorDelCampo,0,"Seleccione una opción",sModoRO)
										break;
									case 4:  // 4 = combo
										var sEventos = " class='span6' " 
										if (!EsVacio(rsCampos.Fields.Item("MFC_Class").Value)) {
											sEventos = "class='" + rsCampos.Fields.Item("MFC_Class").Value + "'  "
										}
										if (!EsVacio(rsCampos.Fields.Item("MFC_EventosJS").Value)) {
											sEventos +=  " " + rsCampos.Fields.Item("MFC_EventosJS").Value + " "
										}
										var sCampoDescripcion = rsCampos.Fields.Item("MFC_ComboCampoDesc").Value
										var sTabla  = rsCampos.Fields.Item("MFC_ComboTabla").Value
										var sCondicion = "" //" Sys_ID = " + Parametro("Sys_ID",1)
										sCondicion =  FiltraVacios(rsCampos.Fields.Item("MFC_ComboCondicion").Value)
										//sLeyendaTodos = sCondicion
										sCondicion = ProcesaCondicionPorParametros(sCondicion)
										
										if (EsVacio(sLeyendaTodos)) {
											sLeyendaTodos = "Seleccione una opción"
										}	
												
										sCampo = "&nbsp;" + CargaComboFicha(sNombreCampo,sEventos,sCampoLlave,sCampoDescripcion,sTabla,sCondicion,sOrden,ValorDelCampo,0,sLeyendaTodos,sModoRO) 
										break;	
									case 5:						//			5 = caja seleccion
										var Eventos = ""
										if (!EsVacio(rsCampos.Fields.Item("MFC_Class").Value)) {
											Eventos = "class='" + rsCampos.Fields.Item("MFC_Class").Value + "'  "
										}									
										sCampo = "&nbsp;" + CajaSeleccion(sNombreCampo,Eventos,Parametro(sNombreCampo,sValorDefault),1,sModoRO)
										break;
									case 6:						//			6 = fecha modo texto formato dd/mm/yy
										if (sModoRO == "Editar") {
											sCampo = "<script type=" + sC + "text/javascript" + sC + ">"
												sCampo += "	$(function() {"
													sCampo += "	$( " + sC +	"#" + sNombreCampo + sC + " ).datepicker({"
													sCampo += "	changeMonth: true, changeYear: true, "
													sCampo += "	showOn:	" + sC + "button" + sC + ","  
													sCampo += "	buttonImage:" + sC + "/images/calendar.png" + sC + "," 		
													sCampo += " buttonImageOnly: true "
													sCampo += "});"
												sCampo += "});"
											sCampo += "</script>"  
											sCampo += "&nbsp;<input name=" + sC + sNombreCampo + sC + " type=" + sC + "text" + sC + " class=" + sC + "span6" + sC + " id=" + sC + sNombreCampo + sC  + " value=" + sC
											sCampo += AplicaFormato(iFormato,ValorDelCampo)
											sCampo += sC +" size=" + sC + "20" + sC + " maxlength=" + sC + "20" + sC  
											if (!EsVacio(rsCampos.Fields.Item("MFC_EventosJS").Value)) {
												sCampo += " " +  rsCampos.Fields.Item("MFC_EventosJS").Value + " " 
											}
											sCampo +=  sC + " />&nbsp;" 
										} else { 
											sCampo = "&nbsp;"
											if (iOcultoTipo2 == 2) {
												sCampo += " <input type=" + sC + "hidden" + sC 
												sCampo += " name=" + sC + sNombreCampo + sC 
												sCampo += " id=" + sC + sNombreCampo + sC 
												sCampo += " value=" + sC + ValorDelCampo + sC + "> "
											} else {
												sCampo += AplicaFormato(iFormato,ValorDelCampo)
											}
										}
										break;
									case 7:    // 7 = combo catalogo general
										var sEventos = " class='span6' "
										if (!EsVacio(rsCampos.Fields.Item("MFC_EventosJS").Value)) {
											sEventos +=  " " + rsCampos.Fields.Item("MFC_EventosJS").Value + " "
										}
										var sCampoDescripcion = rsCampos.Fields.Item("MFC_ComboCampoDesc").Value
										var sTabla  = rsCampos.Fields.Item("MFC_ComboTabla").Value
										var sCondicion = ""  // "Sys_ID = " + Parametro("Sys_ID",1)

										sCondicion =  FiltraVacios(rsCampos.Fields.Item("MFC_ComboCondicion").Value)
										sCondicion = ProcesaCondicionPorParametros(sCondicion)
										
										var sOrden = ""
										if (!EsVacio(rsCampos.Fields.Item("MFC_Orden").Value)) {
											sOrden =  " " + rsCampos.Fields.Item("MFC_Orden").Value + " "
										}
										var sTodos = "Seleccione una opción"
										if (!EsVacio(rsCampos.Fields.Item("MFC_LeyendaSelecTodos").Value)) {
											sTodos = rsCampos.Fields.Item("MFC_LeyendaSelecTodos").Value
										}
										var sSeccion = "1"
										if (!EsVacio(rsCampos.Fields.Item("MFC_IDCatalogoGeneral").Value)) {
											sSeccion = rsCampos.Fields.Item("MFC_IDCatalogoGeneral").Value
										} 
										//sCampo = "&nbsp;" + ValorDelCampo + "&nbsp;"
										ValorDelCampo = ComboSeccionFicha(sNombreCampo,sEventos,sSeccion,sCondicion,ValorDelCampo,0,sTodos,sOrden,sModoRO)
										sCampo = "&nbsp;" + AplicaFormato(iFormato,ValorDelCampo)
										 
										break;
									case 8:						//			8 = password
										if (sModoRO == "Editar") {
											sCampo = "&nbsp;<input type=" + sC + "password" + sC 
											sCampo += " name=" + sC +  sNombreCampo + sC 
											sCampo += " type=" + sC + "text" + sC + " class=" + sC + "span6" + sC 
											sCampo +=  " id=" + sC +sNombreCampo + sC 
											//sCampo += " style=" + sC + "width:90%" + sC + " "
											sCampo += " value=" + sC 
											sCampo += ValorDelCampo + sC 
											sCampo += " maxlength=" + sC + "100" + sC 
											if (iSoloLectura == 1) {
												sCampo += " readonly=" + sC + "readonly" + sC + " "
											}
											sCampo += " >"
										} else { 
											sCampo = "&nbsp;xxxxx" 
										}
										break;
									case 9:						//			9 = Text Area
										if (sModoRO == "Editar") {
											sCampo = "<textarea name=" + sC +  sNombreCampo + sC
											sCampo +=  " class='span6' id=" + sC + sNombreCampo + sC 
											//sCampo += " cols = " + sC + " 45 " + sC 
											sCampo += " style=" + sC + "width:100%" + sC
											sCampo += " rows=" + sC + " 5 " + sC + ">"
											sCampo += ValorDelCampo
											sCampo += "</textarea>"
										} else { 
											sCampo = "&nbsp;" + ValorDelCampo 
										}
										break;
									case 10:					//			10 = Sí / no
										var Eventos = ""
										if (!EsVacio(rsCampos.Fields.Item("MFC_Class").Value)) {
												Eventos = "class='" + rsCampos.Fields.Item("MFC_Class").Value + "'  "
										}
										sCampo = "&nbsp;" + CajaSeleccion(sNombreCampo,Eventos,Parametro(sNombreCampo,1),1,sModoRO)
										break;
									case 11:	//		11 = 	confirmacion de password
										sCampo = ""
										break;
									case 12:	//		12 = 	Hacer un div
										sCampo = "<div id=" + sC + sNombreCampo + sC + "></div>"
										break;
									case 13:    //      13 =    Una subconsulta	solo consulta
											var sSQLStringSubFIC = ""
											var sValorDeCampo = ""
											/*Abrimos el Rs de lo indicado en los campos*/
											if (!EsVacio(rsCampos.Fields.Item("MFC_Campo").Value)) {	
													sSQLStringSubFIC = " SELECT " 
													sSQLStringSubFIC += rsCampos.Fields.Item("MFC_Campo").Value
													sSQLStringSubFIC += " FROM "
													sSQLStringSubFIC += rsCampos.Fields.Item("MFC_ComboTabla").Value
												sCondicion = FiltraVacios(rsCampos.Fields.Item("MFC_ComboCondicion").Value)
												sCondicion = ProcesaCondicionPorParametros(sCondicion)
												if (!EsVacio(sCondicion)) {
													sSQLStringSubFIC += " WHERE " 
													sSQLStringSubFIC += sCondicion
												}								
												
												var rsValorSubCampos = AbreTabla(sSQLStringSubFIC,1,0)
													if(!rsValorSubCampos.EOF){
														sValorDeCampo = rsValorSubCampos.Fields.Item(0).Value
													} 
													rsValorSubCampos.Close()
											}
											sCampo = "&nbsp;" + sValorDeCampo
										break;
									case 14:	//		14 = 	solo imprime un parametro								
											sCampo = "&nbsp;" + ValorDelCampo
											if (iOcultoTipo2 == 2) {
												sCampo += " <input type=" + sC + "hidden" + sC 
												sCampo += " name=" + sC + sNombreCampo + sC 
												sCampo += " id=" + sC + sNombreCampo + sC 
												sCampo += " value=" + sC + ValorDelCampo + sC + "> "
											}
										break;
									case 15:	//		15 = 	Fecha 
										ValorDelCampo = "" + CambiaFormatoFecha(ValorDelCampo,"yyyy-mm-dd","dd/mm/yyyy") 
										if (sModoRO == "Editar") {
											sCampo = "<script type=" + sC + "text/javascript" + sC + ">"
												sCampo += "	$(function() {"
													sCampo += "	$( " + sC +	"#" + sNombreCampo + sC + " ).datepicker({"
													sCampo += "	changeMonth: true, showOtherMonths: true, selectOtherMonths: true," 
													sCampo += "	changeYear: true, showButtonPanel: true," 
													sCampo += "	showOn:	" + sC + "button" + sC + ","  
													sCampo += "	buttonImage:" + sC + "/images/calendar.png" + sC + "," 		
													sCampo += " buttonImageOnly: true "
													sCampo += "});"
												sCampo += "});"
											sCampo += "</script>"
											sCampo += "&nbsp;<input name=" + sC + sNombreCampo + sC + " type=" + sC + "text" + sC + " id=" + sC + sNombreCampo + sC  + " value=" + sC
											sCampo += ValorDelCampo
											sCampo += sC +" size=" + sC + "20" + sC + " maxlength=" + sC + "20" + sC + " />&nbsp;"
											//sCampo = ""
										} else { 
											sCampo = ValorDelCampo
										}
										break;
									case 16:						//			16 = fecha  receptor en formato juliano
									    sCampo = ValorDelCampo
										break;
									case 17:						//			17 = fecha  receptor en formato date
										sCampo = ValorDelCampo
										break;
									case 18:						//			18 = fecha  receptor en formato datetime
										if (sModoRO == "Editar") {

										} else { 
											//sCampo = "&nbsp;" + CambiaFormatoFecha(Parametro(sNombreCampo,""),"yyyy-mm-dd","dd/mm/yyyy") 
											//sCampo = "&nbsp;" + FormatoFecha(ValorDelCampo ,"UTC a dd/mm/yyyy")
											//Formato en que los va a presentar
											sCampo = ValorDelCampo
										}
										break;	
									default:	//			1 = text box
										if (sModoRO == "Editar") {
													sCampo = "&nbsp;<input name=" + sC +  sNombreCampo + sC 
													sCampo += " type=" + sC + "text" + sC + " class=" + sC + "span6" + sC 
													sCampo +=  " id=" + sC + sNombreCampo + sC 
													//sCampo += " style=" + sC + "width:90%" + sC + " "
													sCampo += " value=" + sC 
													sCampo += ValorDelCampo + sC 
													sCampo += " maxlength=" + sC + "100" + sC 
													if (iSoloLectura == 1) {
														sCampo += " readonly=" + sC + "readonly" + sC + " "
													}
													sCampo +=  " >"
										} else {
											sCampo = "&nbsp;" + ValorDelCampo
										}
										break;
								}
						bUsado = true
						iVueltas = 0
						ValorDelCampo=""
						
					//*********** Armado de estructura de la tabla ********************************
					
					var bImprimeEtiqueta = false
					var bImprimeDato = false
					var iSPET = 0
					var iSPDT = 0
								
//					for (iCr=iRen;iCr<rsCampos.Fields.Item("MFC_Renglon").Value;iCr++) { 						
//						//cerrar renglon  y colocar las columans faltantes 
////						for (iCF=iCol;iCF<=iColPorSecReg;iCF++) {
////							sResultado += "<td "
////							if (iRen == 1 ) {
////								sResultado += " width=" + sC + arrAnchoColumnas[iCF] + "%" + sC 
////							}
////							sResultado += " >&nbsp;</td>"
////						} 							
//						sResultado += "</tr>"
//						//abrir nuevo renglon
//						sResultado += "<tr class=" + sC + "FichaCampoValor" + sC + ">"
//						//iRen++
//					iCol = 1 								
//					}					
//					iRen= rsCampos.Fields.Item("MFC_Renglon").Value
//					var iColAdelantada = rsCampos.Fields.Item("MFC_Columna").Value				
//						iColAdelantada = iColAdelantada*2-1
//					if (iCol < iColAdelantada) {
//						for (iCF=iCol;iCF<iColAdelantada;iCF++) {
//							sResultado += "<td "
//							if (iRen == 1 ) {
//								sResultado += " width=" + sC + arrAnchoColumnas[iCF] + "%" + sC 
//							}
//							sResultado += " >&nbsp;</td>"
//							iCol++
//						}
//					}	

//					if (sEtiqueta == "") {
//						bImprimeEtiqueta = false
//						bImprimeDato = true
//						iSPET = 0
//						iSPDT = 2
//					} else {
//						if ( sNombreCampo == "" ) {
//							bImprimeEtiqueta=true
//							bImprimeDato = false
//							iSPET = 2
//							iSPDT = 0
//						} else {
//							bImprimeDato = true
//							bImprimeEtiqueta=true
//							iSPET = 0
//							iSPDT = 0						
//						}
//					}

	//				if (bImprimeEtiqueta) {
//						//columna pa etiqueta
//						//abrir td
//						sResultado += "<td "
//						if (iRen == 1 ) {
//							if (!EsVacio(arrAnchoColumnas[iCol])) {
//								sResultado += " width=" + sC + arrAnchoColumnas[iCol] + "%" + sC
//							}
//						}
//						if (iSPET >0) {
//							sResultado += " colspan=" + sC + iSPDT + sC  
//						}
//						sMFCAlineacion = FiltraVacios(rsCampos.Fields.Item("MFC_AlineacionEtiqueta").Value)
//						if (sMFCAlineacion!= "") {
//							sResultado += " align=" + sC + sMFCAlineacion + sC
//						}
//						sResultado += " class=\"FichaCampoTitulo\" >&nbsp;"
//						sResultado += sEtiqueta
//						//cerrar td
//						sResultado += "</td>"
//						iCol++	
//					}			
//					if (bImprimeDato) { 
//						//columna pa dato
//						//abrir td
//						sResultado += "<td "
//						if (iRen == 1 ) {
//							if (!EsVacio(arrAnchoColumnas[iCol])) {
//								sResultado += " width=" + sC + arrAnchoColumnas[iCol] + "%" + sC
//							}
//						}
//						if (rsCampos.Fields.Item("colspan").Value == 0) {
//							var iColPorJuntar = iColPorSecReg - iCol + 1
//							sResultado += " colspan=" + sC + iColPorJuntar + sC  
//							iCol++
//						}
//						sMFCAlineacion = FiltraVacios(rsCampos.Fields.Item("MFC_AlineacionCampo").Value)
//						if (sMFCAlineacion!= "") {
//							sResultado += " align=" + sC + sMFCAlineacion + sC
//						}
//						sResultado += " class=\"FichaCampoValor\" >&nbsp;"
//						//sResultado += "(" +iRen + "," + iCol + "," + ((iColPorSecReg/2) - rsCampos.Fields.Item("rowspan").Value) + ") " 
						sResultado += sCampo
//						//cerrar td
//						sResultado += "</td>"
//						iCol++	
//					}

					sResultado += "</div></div>"
					rsCampos.MoveNext()
				}
//						for (iCF=iCol;iCF<=iColPorSecReg;iCF++) {
//							sResultado += "<td "
//							if (iRen == 1 ) {
//								if (!EsVacio(arrAnchoColumnas[iCF])) {
//									sResultado += " width=" + sC + arrAnchoColumnas[iCF] + "%" + sC 
//								}
//							}
//							sResultado += " >&nbsp;</td>"
//						}
				sResultado += "<hr style='margin: 0 0 30px;'>"
				rsCampos.Close() //Cierre de la seccion			
				
			rsSeccion.MoveNext()
		}	
		rsSeccion.Close()	

		return sResultado
}

function ImprimeOcultos() {

	var sCamposOcultos = ""
	
		//para cargar al final los campos ocultos
	var sFCOcultos = "SELECT * "
		sFCOcultos += " ,ISNULL((Select PP_Nombre "
		sFCOcultos +=           "  from ParametrosPermanentes "
		sFCOcultos +=           " where ParametrosPermanentes.PP_Nombre = MenuFichaCampos.MFC_Campo "
		sFCOcultos +=           "   and Sys_ID = " +  SistemaActual 
		sFCOcultos +=           "   and PP_Seccion = (select Mnu_UsarPP from Menu "
		sFCOcultos +=                                " where Sys_ID = " + SistemaActual
		sFCOcultos +=                                " and Mnu_ID = " + VentanaIndex + ") " 
		sFCOcultos +=           "   and PP_Habilitado = 1),'No') as PP "  //mapeo los campos contra los parametros permanentes
		sFCOcultos += " FROM MenuFichaCampos "
		sFCOcultos += " WHERE MFC_Habilitado = 1 "
		sFCOcultos += "  AND Sys_ID = " + SistemaActual
		sFCOcultos += " AND WgCfg_ID = " + iWgCfgID
		//sFCOcultos += "  AND Mnu_ID = " + mnuid
		sFCOcultos += "  AND MFC_EsOculto = 1 "

	var rsOcultos = AbreTabla(sFCOcultos,1,2)

	while (!rsOcultos.EOF){
		sNombreCampo = "" + rsOcultos.Fields.Item("MFC_Campo").Value
		sValorDefault = "" + rsOcultos.Fields.Item("MFC_ValorDefault").Value
		sValorDefault = ProcesaValorDefault(sValorDefault)
		
		ValorDelCampo = Parametro( sNombreCampo , sValorDefault )
		if (EsVacio(ValorDelCampo))  { ValorDelCampo = -1 }
		if (rsOcultos.Fields.Item("PP").Value == "No" ) {
			sCamposOcultos += " <input type=" + sC + "hidden" + sC + " name=" + sC + sNombreCampo + sC + " id=" + sC + sNombreCampo + sC +" value=" + sC + ValorDelCampo + sC + "> "
		}	
		if (rsOcultos.Fields.Item("PP").Value != "No" ) {
			sCamposOcultos += " <input type=" + sC + "hidden" + sC + " name=" + sC + "pp_" + sNombreCampo + sC + " id=" + sC + "pp_" + sNombreCampo + sC +" value=" + sC + ValorDelCampo + sC + "> "
		}			
		rsOcultos.MoveNext()
	}	

	rsOcultos.Close()
	
	sCamposOcultos += " <input type=" + sC + "hidden" + sC + " name=" + sC + "GFINSRT" + sC + " id=" + sC + "GFINSRT" + sC +" value=" + sC + GFINSRT + sC + "> "
	sCamposOcultos += " <input type=" + sC + "hidden" + sC + " name=" + sC + "WgCfgID" + sC + " id=" + sC + "WgCfgID" + sC +" value=" + sC + iWgCfgID + sC + "> "
	sCamposOcultos += " <input type=" + sC + "hidden" + sC + " name=" + sC + "ModoEntrada" + sC + " id=" + sC + "ModoEntrada" + sC +" value=" + sC + ModoEntrada + sC + "> "
	sCamposOcultos += " <input type=" + sC + "hidden" + sC + " name=" + sC + "iWgRsltdAcc" + sC + " id=" + sC + "iWgRsltdAcc" + sC +" value=" + sC + iWgRsltdAcc + sC + "> "
	return sCamposOcultos
			
}

function ArmaMarco() {
	var sG = ""
	sG += CargaBotones()
	sG += CargaDatos()

	return sG

}


function BorrarLLavePrincipal() {

	for (i=0;i<CampoNombre.length;i++) {
		if (CampoLLavePK[i] == 1 && CampoLLave[i] == 1) {
			CampoValor[i] = "-1"
			ParametroCambiaValor(CampoNombre[i], "-1")
		}
	}
			
}


if (iIQonDebug == 1) {	%>
	<br /><font color='red' size='2'><strong>Iniciando entrada al Debug</strong></font><br /><br />
    <br /><font color='red' size='2'><strong>Valores de entrada</strong></font><br /><br />
<% }
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


if (iIQonDebug == 1) {	%>
	<br /><font color='red' size='2'><strong>bHayParametros = <%=bHayParametros%></strong></font>
    
    <br /><font color='red' size='2'><strong>IQPSerial = <%=Session("IQPSerial")%></strong></font>
    
<% Debug_ImprimeParametros("Ficha_IQOnDinamico.asp")
}

//if (!bHayParametros) { 	
//	LeerParametrosdeBD() 
//	//Debug_ImprimeParametros("Parametros Leidos de la BD")
//} else {
//Debug_ImprimeParametros("Parametros Encontrados")	
//}
 
var sC = String.fromCharCode(34)
var Accion = Parametro("Accion","Consulta")
var Modo = Parametro("Modo","Consulta")
var ModoEntrada = Parametro("ModoEntrada","")
var bRegistroNuevo = true
var Mensaje = ""


var SistemaActual = Parametro("SistemaActual",0)
var VentanaIndex  = Parametro("VentanaIndex",0)
var IDUsuario     = Parametro("IDUsuario",0)
var iWgCfgID      = Parametro("WgCfg_ID",Parametro("WgCfgID",0))
var iWgRsltdAcc   = "Consulto"

VentanaIndex = 610
SistemaActual=30
Modo = "Editar"
Accion =  "Consulta"


if (iIQonDebug == 1) {	%>
	<br /><font color='red' size='2'><strong>Iniciando entrada al Debug</strong></font><br /><br />
    <br /><font color='red' size='2'><strong>Valores de entrada</strong></font><br /><br />
	<br /><font color='red' size='2'><strong>SistemaActual = <%=SistemaActual%>&nbsp;:&nbsp;=&nbsp;:&nbsp;mnuid = <%=mnuid%></strong></font>
<% }
IniciaDebugBD()

var sTabla = ""
var SQLCondicion = ""
var sOrdenadoPor = ""
var	sMFC_SinPK_Ir_A = 0
var sMFC_MensajeError = ""
var iSQLVieneDeBuscador = 0
var sCondicionPorParametro = ""  //   para arreglo de condiciones posicion: 1= campo 2=nombreparametreo 3,ValorDefault separado por comas y pipes
								//    ejemplos; Cli_ID,Cli_ID,-1|Cont_ID,Cont_ID,-1|Dir1_ID,Cli_ID,-1 este ultimo transfiero a dir1 el valor de cliid		
									
var SistemaActual = Parametro("SistemaActual",0)
var mnuid = Parametro("VentanaIndex",0)
var iMWPuedeAgregar = 0
var iMWPuedeEditar = 0
var iMWPuedeBorrar = 0

var sSQLConfBase = " select MW_Param, MW_PuedeAgregar, MW_PuedeBorrar, MW_PuedeEditar "
	sSQLConfBase += " from Menu_Widget "
	sSQLConfBase += " WHERE Sys_ID = " + SistemaActual
	sSQLConfBase += " AND Mnu_ID = "   + VentanaIndex
	sSQLConfBase += " AND Wgt_ID = 43 "  // + iWgID
	sSQLConfBase += " AND WgCfg_ID = " + iWgCfgID

var rsConfBase = AbreTabla(sSQLConfBase,1,2)
if (!rsConfBase.EOF){
		iMWPuedeAgregar = rsConfBase.Fields.Item("MW_PuedeAgregar").Value
		iMWPuedeEditar  = rsConfBase.Fields.Item("MW_PuedeEditar").Value
		iMWPuedeBorrar  = rsConfBase.Fields.Item("MW_PuedeBorrar").Value
}
rsConfBase.Close()
	
	
if (iIQonDebug == 1) {	
	Response.Write("<br /><font color='red' size='2'><strong>Accion&nbsp;" + Accion + "&nbsp;:&nbsp;=&nbsp;:&nbsp;Modo&nbsp;" + Modo  + "</strong></font>")
	Response.Write("<br /><font color='red' size='2'><strong>SistemaActual&nbsp;" + SistemaActual + "&nbsp;:&nbsp;=&nbsp;:&nbsp;mnuid&nbsp;" + mnuid  + "</strong></font>")
}

	var sFCHTabla = "SELECT * "
		sFCHTabla += " FROM MenuFichaTabla "
		sFCHTabla += " WHERE Sys_ID = " + SistemaActual
		sFCHTabla += " AND WgCfg_ID = " + iWgCfgID
		//sFCHTabla += " AND Mnu_ID = " + mnuid
		sFCHTabla += " AND MFS_ID = 1 "  //campo experimental para poner una tabla diferente por seccion, ahora solo funciona un solo registro por menu
	if (iIQonDebug == 1) {	
		Response.Write("<br /><font color='red' size='2'><strong>sql&nbsp;:=&nbsp;" + sFCHTabla +  "</strong></font>")
		//Response.End()
	}
	var rsTabla = AbreTabla(sFCHTabla,1,2) 
	if (!rsTabla.EOF) {	
		sTabla = rsTabla.Fields.Item("MFC_Tabla").Value
		SQLCondicion = FiltraVacios(rsTabla.Fields.Item("MFC_CondicionGeneral").Value)
		sOrdenadoPor = FiltraVacios(rsTabla.Fields.Item("MFC_OrdenadoPor").Value)
		sCondicionPorParametro = FiltraVacios(rsTabla.Fields.Item("MFC_CondicionPorParametro").Value)
		iSQLVieneDeBuscador = rsTabla.Fields.Item("MFC_VieneDeBuscador").Value
		sMFC_SinPK_Ir_A = FiltraVacios(rsTabla.Fields.Item("MFC_SinPK_Ir_A").Value)
		sMFC_MensajeError = FiltraVacios(rsTabla.Fields.Item("MFC_MensajeError").Value)
		if (Parametro("ModoEntrada","") == "") {
			ModoEntrada = rsTabla.Fields.Item("MFC_ModoEntrada").Value
			ParametroCambiaValor("ModoEntrada", ModoEntrada)
		} 

		var VPV = 0
//		var VPV = Parametro("VeZ",0)
//		if (Parametro("VeZ",0) == 0) {
//			Accion = rsTabla.Fields.Item("MFC_AccionEntrada").Value
//			Modo = rsTabla.Fields.Item("MFC_ModoEntrada").Value
//		}
	}	
	rsTabla.Close()	

	if (iIQonDebug == 1) {	
		//Response.Write("<br /><font color='red' size='2'><strong>sql&nbsp;:=:&nbsp;" + sFCHTabla +  "</strong></font>")
		Response.Write("<br /><font color='red' size='2'><strong>sTabla:&nbsp;" + sTabla + "<br />&nbsp;SQLCondicion&nbsp;" + SQLCondicion + "<br />&nbsp;sOrdenadoPor&nbsp;" + sOrdenadoPor + "<br />&nbsp;sCondicionPorParametro&nbsp;" + sCondicionPorParametro + "<br />&nbsp;iSQLVieneDeBuscador&nbsp;" + iSQLVieneDeBuscador + "</strong></font>")
	}
	
	var sLLavePrimaria = ""
	var sLLavePrimariaCampo = ""
	var sLLavePrimariaValor = -1
	var sLLavePrimariaHeredada = ""
	var GFINSRT = Parametro("GFINSRT",0)  //grabacion forzada hacer insert
	
//	var iPos = 0
//	var iPosO = 0
	
	var sFCHCampos = "SELECT * "
		sFCHCampos += " ,ISNULL((Select PP_Nombre "
		sFCHCampos +=            " from ParametrosPermanentes "
		sFCHCampos +=           " where ParametrosPermanentes.PP_Nombre = MenuFichaCampos.MFC_Campo "
		sFCHCampos +=             " and Sys_ID = " +  SistemaActual 
		sFCHCampos +=             " and PP_Seccion = (select Mnu_UsarPP from Menu "
		sFCHCampos +=                                " where Sys_ID = " + SistemaActual
		sFCHCampos +=                                  " and Mnu_ID = " + VentanaIndex + ") " 
		sFCHCampos +=             " and PP_Habilitado = 1),'No') as PP "  //mapeo los campos contra los parametros permanentes
		sFCHCampos += " FROM MenuFichaCampos "
		sFCHCampos += " WHERE MFC_Habilitado = 1 "
		//sFCHCampos += " AND MFC_Informativo = 0 "
		sFCHCampos += " AND Sys_ID = " + SistemaActual
		sFCHCampos += " AND WgCfg_ID = " + iWgCfgID
		//sFCHCampos += " AND Mnu_ID = " + mnuid
	
if (iIQonDebug == 1) {	
	Response.Write("<br /><font color='red' size='2'><strong>sFCHCampos&nbsp;" + sFCHCampos + "</strong></font><br />") 
}

	var rsCampos = AbreTabla(sFCHCampos,1,2) 
	while (!rsCampos.EOF){	
		iCamposLL++           
		CampoNombre[iCamposLL]      = rsCampos.Fields.Item("MFC_Campo").Value
		CampoPP[iCamposLL]          = rsCampos.Fields.Item("PP").Value
		CampoLLave[iCamposLL]       = rsCampos.Fields.Item("MFC_EsPK").Value
		CampoLLavePK[iCamposLL]     = rsCampos.Fields.Item("MFC_EsPKPrincipal").Value
		CampoInformativo[iCamposLL] = rsCampos.Fields.Item("MFC_Informativo").Value
		
		var sTmpDF = FiltraVacios(rsCampos.Fields.Item("MFC_ValorDefault").Value)	
		sTmpDF = ProcesaValorDefault(sTmpDF)
		
		//if (CampoLLave[iCamposLL] == 1) {
			CampoValor[iCamposLL]  = FiltraVacios(Parametro(CampoNombre[iCamposLL],"" +sTmpDF))
			//Response.Write("<br> el valor del campo " + CampoNombre[iCamposLL] + " es " +CampoValor[iCamposLL])
		//} else {
		//	CampoValor[iCamposLL]  = "" +sTmpDF
		//}
//		if (!EsVacio(CampoValor[iCamposLL]) && rsCampos.Fields.Item("MFC_TipoCampo").Value != 6) {
//			acnCOnt++             
//			arrCMPNMBInsertar[acnCOnt]= CampoNombre[iCamposLL]
//		}
		CampoFormato[iCamposLL]    = "N"
		CampoCondicion[iCamposLL]  = rsCampos.Fields.Item("MFC_EsPK").Value 
		 
		CampoOculto[iCamposLL]     = rsCampos.Fields.Item("MFC_EsOculto").Value
		if (CampoPP[iCamposLL] != "No") {
			CampoOculto[iCamposLL] = 1
		}
		
//		MFC_YaSeUso[iPos] = false
//
//		if (MFC_EsPK == 1) {
//			sLLavePrimariaCampo = arCampos[iPos]
//			sLLavePrimaria = "  " +  arCampos[iPos] + " = " + Parametro(arCampos[iPos],-1) + " "
//			//pendiente falta poner el tipo de dato N=numero F=fecha T=texto para clavarle unas comillas o el formato de fecha
//			MFC_YaSeUso[iPos] = true
//			MFC_EsOculto = 1
//		}
//		if (MFC_EsPKPrincipal == 1) {
//			if (!MFC_YaSeUso[iPos]) {
//				if (sLLavePrimariaHeredada != "" ) { sLLavePrimariaHeredada += " AND " }
//				sLLavePrimariaHeredada += " " +  arCampos[iPos] + " = " + Parametro(arCampos[iPos],-1) + " "
//				MFC_YaSeUso[iPos] = true
//				MFC_EsOculto = 1
//			}
//		}
//		if (MFC_EsOculto == 1 ) {
//			MFC_EsOculto[iPosO] = arCampos[iPos]
//			iPosO++
//		}
//		iPos++
		rsCampos.MoveNext()
	}	
	rsCampos.Close()

	var arrCampo      = new Array(0)
	var arrPrmCPP     = new Array(0)
	var bEnc = false
	
if (iIQonDebug == 5) {	
	Response.Write("<br /><font color='red' size='2'><strong>sCondicionPorParametro_Parametrospermanentes&nbsp;" + sCondicionPorParametro + "</strong></font><br />") 
}		

	if (!EsVacio(sCondicionPorParametro) ) {
		arrPrmCPP = sCondicionPorParametro.split("|")
		for (j=0;j<arrPrmCPP.length;j++) {
			bEnc = false
			var Txt = String(arrPrmCPP[j])
			var arrCampo = Txt.split(",")
			for (fi=0;fi<=CampoNombre.length;fi++) {
				if (iIQonDebug == 5) {	
				Response.Write("<br />campo " + fi + ") -campo_nombre&nbsp;" + CampoNombre[fi] + "<br />") 
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
					Response.Write("<br /><font color='red' size='2'><strong>--encontrado en " + fi + ") CampoNombre&nbsp;" + CampoNombre[fi] + " con valor de " + CampoValor[fi] + " es llave " + CampoLLave[fi] +"</strong></font><br />") 
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
				Response.Write("<br /><font color='red' size='2'><strong>---no encontrado&nbsp;" + iCamposLL + ") CampoNombre&nbsp;" + CampoNombre[iCamposLL]+"</strong></font><br />")
				}		
			}
		}

	}

var iContPK = 0
var iContLL = 0

	for (i=0;i<CampoNombre.length;i++) {
	//Response.Write("<br> " + i + ") " + CampoNombre[i])
		
		//Response.Write("<br> llave " + i + ") " + CampoNombre[i])
			if (CampoLLavePK[i] == 1) {
				sLLavePrimaria =  " " +  CampoNombre[i] + " = " + CampoValor[i] + " "
				sLLavePrimariaCampo = CampoNombre[i]
				sLLavePrimariaValor = CampoValor[i]
				bLlavesVacias = false
				iContPK++
			}
			
			if (CampoLLavePK[i] == 0 && CampoLLave[i] == 1) {
		        if (!EsVacio(CampoValor[i]) && CampoValor[i] != "-1") {		
				    if (sLLavePrimariaHeredada != "" ) { sLLavePrimariaHeredada += " AND " }
					sLLavePrimariaHeredada += " " +  CampoNombre[i] + " = " + CampoValor[i] + " "
					bLlavesVacias = false
					iContLL++
				} 
			
			}
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
	
	if (iContLL == 0 && iContPK > 0) { bLlavesVacias = false } 

	if (EsVacio(SQLCondicion)) { SQLCondicion = "" }
	if (SQLCondicion != "" && sLLavePrimariaHeredada != "") { SQLCondicion += " AND " }
	SQLCondicion += sLLavePrimariaHeredada
	
	if (SQLCondicion != "" && sConsultaExtra != "") { SQLCondicion += " AND " }
	SQLCondicion += sConsultaExtra
	
	
	if (iIQonDebug == 1) {	Response.Write("<br /><font color='red' size='2'><strong>SQLCondicion&nbsp;=" + SQLCondicion+"</strong></font><br />") }
	if (iIQonDebug == 1) {	Response.Write("<br /><font color='red' size='2'><strong>sLLavePrimaria&nbsp;=" + sLLavePrimaria + "</strong></font><br />") }

	var sCondCamp = SQLCondicion 
	if (sCondCamp != "" && sLLavePrimaria != "") { sCondCamp += " AND " }
	sCondCamp += sLLavePrimaria
	

	if (sCondCamp != "") {
		sCondCamp = " WHERE " + sCondCamp
	}
	
	
var bRecienGuardado = false

//if (ModoEntrada == "Nuevo") {
//	Modo = "Editar"
//	Accion = "Consulta"
//	ParametroCambiaValor("Modo", "Editar")
//	ParametroCambiaValor("Accion", "Nuevo")
//	BorrarLLavePrincipal()
//	ModoEntrada = "Consulta"
//}


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




//  ***************************  Inicio   *********************************
if(Accion != "Vuelta" ) {	
	
	if (Accion == "Guardar") {
	//AgregaDebugBD("entre guardando accion = ",Accion )
		bRecienGuardado = true
		//bParametrosDeAjaxaUTF8=true
		//AgregaDebugBD("GFINSRT = ",GFINSRT )
		if (GFINSRT == 1) {
			ArmaCamposATrabajar("Insertar")
			BDInsert(arrCamposATrabajar,sTabla,"",0)
			ParametroCambiaValor("GFINSRT",0)
			iWgRsltdAcc = "Inserto"
		} else {
			//AgregaDebugBD("sLLavePrimariaCampo = ",sLLavePrimariaCampo )
			//AgregaDebugBD("sLLavePrimariaValor = ",sLLavePrimariaValor )
			if (Parametro(sLLavePrimariaCampo,sLLavePrimariaValor) == -1) {  
				//if (Session("Agregar") == 1) {
					//AgregaDebugBD("agregando = ","" )
					LlaveABuscar = SiguienteID(sLLavePrimariaCampo,sTabla, SQLCondicion ,0)
					ParametroCambiaValor(sLLavePrimariaCampo, LlaveABuscar)
					ArmaCamposATrabajar("Insertar")
					BDInsert(arrCamposATrabajar,sTabla,"",0)
					sLLavePrimaria = sLLavePrimariaCampo + " = " + LlaveABuscar
					iWgRsltdAcc = "Inserto"
				//}
			} else { 
			//AgregaDebugBD("editando = ","" )
				//if (Session("Editar") == 1) { 
					ArmaCamposATrabajar("Actualizar")
					BDUpdate(arrCamposATrabajar,sTabla,sCondCamp,0)
					iWgRsltdAcc = "Edito"   
				//}
			}
		}			
		Accion = "Consulta"
		Modo = "Consulta"
		Mensaje = "El registro fué guardado correctamente"
		ParametroCambiaValor("Modo", "Consulta")
		ParametroCambiaValor("Accion", "Consulta")
	}	
	if (Accion == "Borrar" ) {
		BDDelete(CampoNombre,sTabla,sCondCamp,0)
		//Response.Write("sSQLMod&nbsp;" + sSQLMod + "<br>")	
		Mensaje = "El registro fue borrado correctamente"
		Accion = "Consulta"
		Modo = "Borrado"
		ParametroCambiaValor("Accion", "Consulta")
		ParametroCambiaValor("Modo","Borrado")
		BorrarLLavePrincipal()
	}
	if (Accion == "Nuevo") {
		LlaveABuscar = -1
		ParametroCambiaValor(sLLavePrimariaCampo, LlaveABuscar)
		ParametroCambiaValor("Accion", "Consulta")
		Accion = "Consulta"
	}	
	
} 
	
if (Accion != "Vuelta") { 
//Cargado de Datos via sentencias SQL

	var sOtroQry = "SELECT * "
		sOtroQry += " FROM MenuFichaQuery "
		sOtroQry += " WHERE MFQ_Habilitado = 1 "
		sOtroQry += " AND Sys_ID = " + SistemaActual
		sOtroQry += " AND WgCfg_ID = " + iWgCfgID
		//sOtroQry += " AND Mnu_ID = " + mnuid
		sOtroQry += " Order By MFQ_Orden"
	if (iIQonDebug == 1) {
		Response.Write("<font color='red' size='2'><strong>Cargado de Datos via sentencias SQL&nbsp;" + sOtroQry + "</strong></font><br />")
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
			ParametroCargaDeSQL(MFQ_Query,0)
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
				Response.Write("<font color='blue' size='2'><strong>Query Armado &nbsp;" + MFQ_Query + "</strong></font><br />")
			}

			bHayParametros = false
			ParametroCargaDeSQL(MFQ_Query,0)
		}
		if (MFQ_TipoQuery == "SP") {
			var sCondicionPorParametros = ""
				sCondicionPorParametros = SerializaCondicionPorParametros(MFQ_Parametros)		
	
			MFQ_Query += "  " + sCondicionPorParametros 	
			
			var rsQrySP = AbreTabla(MFQ_Query,1,0) 
		
			if (iDebugSubQuerys == 1) {
				Response.Write("<font color='red' size='2'><strong>Query Armado &nbsp;" + MFQ_Query + "</strong></font><br />")
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
		    Response.Write("<br /><font color='red'><strong>----------------- 1697 -----------------</strong></font>")
			Response.Write("<br /><font color='red'><strong>sTabla&nbsp;" + sTabla + "</strong></font><br />")	 
		    Response.Write("<font color='red'><strong>sLLavePrimaria&nbsp;" + sLLavePrimaria + "</strong></font><br />")
			Response.Write("<font color='red'><strong>SQLCondicion&nbsp;" + SQLCondicion + "</strong></font><br />")
			Response.Write("<font color='red'><strong>-------------------------------</strong></font><br /><br /<br />")	
		}
		

	if (iIQonDebug == 1) {	Response.Write("<font color='red'><strong>Tabla_A_Manejar&nbsp;" + sConsultaSQL + "</strong></font><br />")	}
	if (iIQonSentNecesaria == 1) {
		Response.Write("iIQonDebug&nbsp;" + iIQonDebug + "&nbsp;IDUsuario&nbsp;" + Parametro("IDUsuario",Session("IDUsuario")) +"<br />")		
		Response.Write("sConsultaSQL&nbsp;  " + sConsultaSQL + "<br />")
	}

		AgregaDebugBD("sql ficha carga inicial",sConsultaSQL )
		bHayParametros = false
		ParametroCargaDeSQL(sConsultaSQL,0)
		
}

//if ( Accion == "Recarga" ) {
//	Accion = "Consulta"
//	ParametroCambiaValor("Accion", "Consulta")
//} 

GFINSRT = 0
ParametroCambiaValor("GFINSRT", 0)

if (Parametro(sLLavePrimariaCampo,sLLavePrimariaValor) == -1) {
		var Modo = "Editar"
		var Accion =  "Consulta"
		ParametroCambiaValor("Modo", Modo)
		ParametroCambiaValor("Accion", Accion)  //forza a nuevo 
		bRegistroNuevo = true
		
} else {
	bRegistroNuevo = false
//	Valido si el registro existe de lo contrario cambio a modo nuevo
	if (Accion != "Vuelta" && !bRecienGuardado) {
		var sSQLCondYE = "" + sLLavePrimaria
		if (sSQLCondYE != "" && sConsultaExtra != "") { sSQLCondYE += " AND " }
		sSQLCondYE += sConsultaExtra
		if (sSQLCondYE != "" && sLLavePrimariaHeredada != "" ) { sSQLCondYE += " AND " }
		sSQLCondYE += sLLavePrimariaHeredada
		//AgregaDebugBD("sSQLCondYE",sSQLCondYE )
		var uYaExiste = BuscaSoloUnDato("Count(*)",sTabla,sSQLCondYE,0,0)
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

if (iIQonDebug == 1) {	
Response.Write("<br /><font color='red'><strong>1755&nbsp; bLlavesVacias </strong></font>" + bLlavesVacias + "<br />")	
}

if (bLlavesVacias) {
	
	if (sMFC_MensajeError == "" ) { sMFC_MensajeError = sConsultaSQL }
	
	var sErrMsg  = "<p id=\"MsgBoxTitulo\"><strong>Error:</strong></p>"
	
		sErrMsg += "<p>" + sMFC_MensajeError + "<br><br>"
		if (sMFC_SinPK_Ir_A > 0) {
			sErrMsg += "<a href=\"javascript:CambiaTab(" + sMFC_SinPK_Ir_A + ");\">Haga click aqu&iacute; para ir a la ventana sugerida</a></p>"
		}
		//sErrMsg  = "error"
	var sError = ""
		sError += "<script language=\"JavaScript\">"
		sError += "$(function() {$.msgbox('" + sErrMsg + "', {type: 'error'});});"
		sError += "</script>"
		Response.Write( sError )
			
} else {
	//AgregaDebugBD("Modo = " + Modo,"Accion = " + Accion )
VentanaIndex = 610
SistemaActual=30
Modo = "Editar"
Accion =  "Consulta"
	Response.Write(ArmaMarco())
	var campocul = ImprimeOcultos()
	Response.Write("<br> " + campocul)
}

//<div class="comment-respond" id="respond">
//  <h3 class="comment-reply-title" id="reply-title">Leave a Reply <small><a href="/pindol/javascript/507,507.html#respond" id="cancel-comment-reply-link" rel="nofollow" style="display:none;">Cancel
//  reply</a></small></h3>
//
//  <form action="http://themes.muffingroup.com/pindol/wp-comments-post.php" class="comment-form" id="commentform" method="post" name="commentform">
//  
//    <p class="comment-notes">Your email address will not be published. Required fields are marked 
//    <span class="required">*</span>
//    </p>
//
//    <p class="comment-form-author">
//    	<label for="author">Name <span class="required">*</span></label>
//        <input id="author" name="author" size="30" type="text" value="">
//    </p>
//
//    <p class="comment-form-email">
//    	<label for="email">Email <span class="required">*</span></label> 
//        <input id="email" name="email" size="30" type="text" value="">
//    </p>
//
//    <p class="comment-form-url">
//    	<label for="url">Website</label> 
//        <input id="url" name="url" size="30" type="text" value="">
//    </p>
//
//    <p class="comment-form-comment">
//    	<label for="comment">Comment</label> 
//    	<textarea cols="45" id="comment" name="comment" rows="8"></textarea>
//    </p>
//
//
//    <p class="form-submit">
//    <input id="submit" name="submit" type="submit" value="Post Comment"> 
//    <input id="comment_post_ID" name="comment_post_ID" type="hidden" value="507"> 
//    <input id="comment_parent" name="comment_parent" type="hidden" value="0"></p>
//  </form>
//</div>
%>