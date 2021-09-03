<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../Includes/iqon.asp" -->
<%

var iDebugSubQuerys = 0
var iIQonDebug = 0 //((Parametro("IDUsuario",0) == 358) ? 0 : 1)
var iIQonSentNecesaria = 0
var AcabaDeBorrar = false

if (Parametro("VentanaIndex",0) == 20045 ) {  //sustituye el 3 por el numero de ventana para que el debug solo sea para esa ventana
	iIQonDebug = 1 //((Parametro("IDUsuario",0) == 358) ? 0 :1)
    iIQonSentNecesaria = 1
}

if (Parametro("IDUsuario",Session("IDUsuario")) == 358) {
	iIQonDebug = 0 
	iIQonSentNecesaria = 1
}

var iOcultoTipo2 = 0    // tipo 2 es cuando en el campo de oculto viene un 2 entonces se verificara que el campo venga como solo lectura y se
						// colocara el dato con un oculto

var biQ4Web = false



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

//AplicaFormato
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
				//Response.Write(sResultado)
				var stfc6 = FormatoFechaII(sResultado,"CST a fecha","Guardar")
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



function CargaBotones() {

	var sBot = ""
		//Botones 
	//var bMuestraLinea = false
		
		sBot = "<div class='form-group'>"
		sBot += "<div id='areafunciones' class='col-xs-6'>&nbsp;</div>"
		
		sBot += "<div id='areabotones' class='col-xs-6' style='text-align: right;padding-right:100px;'>"
		
			if (Modo == "Editar") {
			
				if (iMWPuedeEditar >= 1 && Session("Editar") == 1) {
					//bMuestraLinea = true
					sBot += "<a class=" + sC + "btn btn-blue" + sC + "id=" + sC + "btnCancelar" + sC + "name=" + sC + "btnCancelar" + sC + "href=" + sC + "javascript:AcFCancelar();" + sC + ">Cancelar&nbsp;<i class=" + sC + "fa fa-ban" + sC + "></i></a>"
					sBot += "&nbsp;<a class=" + sC + "btn btn-green" + sC + "id=" + sC + "btnGuardar" + sC + "name=" + sC + "btnGuardar" + sC + "href=" + sC + "javascript:AcFGuardar();" + sC + ">Guardar&nbsp;<i class=" + sC + "fa fa-save" + sC + "></i></a>"
				}

//				if (bMuestraLinea) {
//					sBot += "<hr>"					
//				}
				
			} else {

					if (iMWPuedeBorrar >= 1 && Session("Borrar") == 1) {
						//bMuestraLinea = true
						sBot += "&nbsp;<a class=" + sC + "btn btn-red" + sC + "id=" + sC + "btnBorrar" + sC + "name=" + sC + "btnBorrar" + sC + "href=" + sC + "javascript:AcFBorrar();" + sC + ">Borrar&nbsp;<i class=" + sC + "fa fa-eraser" + sC + "></i></a>"	
					}
					if (iMWPuedeEditar >= 1 && Session("Editar") == 1) {
						//bMuestraLinea = true
						sBot += "&nbsp;<a class=" + sC + "btn btn-primary" + sC + "id=" + sC + "btnGuardar" + sC + "name=" + sC + "btnGuardar" + sC + "href=" + sC + "javascript:AcFEditar();" + sC + ">Editar&nbsp;<i class=" + sC + "fa fa-pencil-square-o" + sC + "></i></a>"
					}
					if (iMWPuedeAgregar >= 1 && Session("Agregar") == 1) {
						//bMuestraLinea = true
						sBot += "&nbsp;<a class=" + sC + "btn btn-green" + sC + "id=" + sC + "btnNuevo" + sC + "name=" + sC + "btnNuevo" + sC + "href=" + sC + "javascript:AcFNuevo();" + sC + ">Nuevo&nbsp;<i class=" + sC + "fa fa-plus" + sC + "></i></a>"
					}
					
	//				if (bMuestraLinea) {
	//					sBot += "<hr>"					
	//				}

			}
			
		sBot += "</div>"
		sBot += "</div>"

	return sBot

}

/*
<div class='form-group'>
	<label class='col-lg-2 control-label'>Email</label>
	<div class='col-lg-10'>
	  <p class='form-control-static'>email@ejemplo.com</p>
	</div>
</div>
*/

//checkbox
function CajaSeleccion(NombreCaja,EventosClases,ValorParametro,Valor,Modo) {
	
	var sRespuesta = ""
	
		if (Modo == "Editar" ) {
			sRespuesta += "<label class='checkbox-inline'>"
				sRespuesta += "<input name='" + NombreCaja + "' type='checkbox' " + EventosClases
				sRespuesta += " id='" + NombreCaja + "' value='" + Valor + "' "
				if (ValorParametro == Valor ) {
					sRespuesta +=  " checked "
				}
				sRespuesta += " class=" + sC + EventosClases + sC + " >"
			sRespuesta += "</label>"
		}
		
		if (Modo != "Editar" ) {
		
			if (ValorParametro == Valor ) {
				sRespuesta += "<p class='form-control-static'>S&iacute;&nbsp;<img src='Img/Bien.png' width='16' height='16' /></p>"
			} else {
				sRespuesta += "<p class='form-control-static'>No&nbsp;<img src='Img/Mal.png' width='16' height='16' /></p>"
			}
			
			if (iOcultoTipo2 == 2) {
				sRespuesta += " <p class='form-control-static'><input type=" + sC + "hidden" + sC 
				sRespuesta += " name=" + sC + NombreCaja + sC 
				sRespuesta += " id=" + sC + NombreCaja + sC 
				sRespuesta += " value=" + sC + ValorParametro + sC + "></p> "
			}
			
		}
		
	return sRespuesta
	
}


//radio
function OpcionesFicha(NombreCaja,EventosClases,SarrOpciones,SarrValores,ValorActual,Modo) {

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
			sRespuesta += "<label class='radio-inline'>"
				sRespuesta += "<input type=" + sC + "radio" + sC + " name=" + sC + NombreCaja + sC + " id=" + sC + Opciones[i] 
				sRespuesta += sC + " value=" + sC + ValoresOpc[i] + sC + " " 
				if (ValoresOpc[i] == ValorActual || i==0) { sRespuesta += " checked " }
				sRespuesta += " class=" + sC + EventosClases + sC + " >"
			sRespuesta +=  Opciones[i] + "</label>"
		}
		
	}
	
	if (Modo != "Editar" ) {
		for (i=0;i<Opciones.length;i++) {
			if (ValoresOpc[i] == ValorActual) {
				sRespuesta =  "<p class='form-control-static'>" + Opciones[i] + "</p>" }
				
		}
		if (iOcultoTipo2 == 2) {
			sRespuesta += " <p class='form-control-static'><input type=" + sC + "hidden" + sC 
			sRespuesta += " name=" + sC + NombreCaja + sC 
			sRespuesta += " id=" + sC + NombreCaja + sC 
			sRespuesta += " value=" + sC + ValorActual + sC + "></p> "
		}
	}
	
	return sRespuesta

}


//combo de una sección catálogo
function ComboSeccionFicha(NombreCombo,Eventos,Seccion,Seleccionado,Conexion,Todos,Orden,Modo,Estilo) {
	
	var sElemento = ""
	var sResultado = ""

		if (Modo == "Editar") {

			sResultado = "<select name='" + NombreCombo + "' id='" + NombreCombo + "' " + Eventos 
			sResultado += " class='" + Estilo + "' >"
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

		} else {
	
			var sCondicion = " Sec_ID = " + Seccion + " AND Cat_ID = " + Seleccionado
			
				sResultado = " <p class='form-control-static'> " + BuscaSoloUnDato("Cat_Nombre","Cat_Catalogo",sCondicion,"",Conexion) + " </p>"
			
			if (iOcultoTipo2 == 2) {
				sResultado += " <p class='form-control-static'><input type=" + sC + "hidden" + sC 
				sResultado += " name=" + sC + NombreCombo + sC 
				sResultado += " id=" + sC + NombreCombo + sC 
				sResultado += " value=" + sC + Seleccionado + sC + "></p> "
			}

		}
	
	return sResultado
	
}


//CargaComboFicha(sMFCCampo,sEventos,sLlave,sCampoDescripcion,sTabla,sCondicion,sOrden,Parametro(sMFCCampo,sMFCValorDefault),0,sTodos,"Editar")
function CargaComboFicha(NombreCombo,Eventos,CampoID,CampoDescripcion,Tabla,Condicion,Orden,Seleccionado,Conexion,Todos,Modo,Estilo) {
	
	var sElemento = ""
	var sResultado = ""
	
	if (EsVacio(Seleccionado)) {Seleccionado = -1 }
	
	if (Modo == "Editar") {
		
		sResultado = "<select name='"+NombreCombo+"' id='"+NombreCombo+"' " + Eventos 
		sResultado += " class='" + Estilo + "' >"
		
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
			
			sElemento = " <p class='form-control-static'> " + BuscaSoloUnDato(CampoDescripcion,Tabla,sSQLCondicion,"",Conexion) + " </p>" 
			
			if (iOcultoTipo2 == 2) {
				sElemento += " <p class='form-control-static'><input type=" + sC + "hidden" + sC 
				sElemento += " name=" + sC + NombreCombo + sC 
				sElemento += " id=" + sC + NombreCombo + sC 
				sElemento += " value=" + sC + Seleccionado + sC + "></p> "
			}
			
		}
		
		sResultado = sElemento
	
	}
	
	return sResultado
}


function CargaDatos() {

	var sResultado = ""
	
	//Aquí se cargan las secciones [Manejo de secciones]
	var iSecCont = 0
	
	var sATCps = "SELECT * "
		sATCps += " FROM MenuFichaSeccion "
		sATCps += " WHERE MFS_Habilitado = 1 "
		sATCps += " AND Sys_ID = " + SistemaActual
		sATCps += " AND WgCfg_ID = " + iWgCfgID
		//sATCps += " AND Mnu_ID = " + VentanaIndex 
		//Parametro("VentanaIndex",1)
		sATCps += " ORDER BY MFS_Orden "
		
		if (biQ4Web) {
			Response.Write("<br /><font class='text-danger'><strong>"+sATCps +"</strong></font><br />")
		}		

		var rsSeccion = AbreTabla(sATCps,1,2)
		if (rsSeccion.EOF){ 
			return ""
		} 
		
		sResultado = " <!-- Manejo de las secciones -->"
		var Offset = ""
		var Ancho = ""
		var Clase = ""
		var ClaseSec = ""
		while (!rsSeccion.EOF){
			Offset = ""
			Ancho = ""			
		    if(   !EsVacio(rsSeccion.Fields.Item("MFS_Offset").Value) 
			    && rsSeccion.Fields.Item("MFS_Offset").Value > 0     ) {
				Offset = "col-xs-offset-" + rsSeccion.Fields.Item("MFS_Offset").Value
			}
			if(   !EsVacio(rsSeccion.Fields.Item("MFS_AnchoEtiqueta").Value) 
			    && rsSeccion.Fields.Item("MFS_AnchoEtiqueta").Value > 0     ) {
				Ancho = " col-xs-" + rsSeccion.Fields.Item("MFS_AnchoEtiqueta").Value
			} else {
				Ancho = " col-xs-12"
			}
			Clase = " class='" + Offset + Ancho + "'"

			if(!EsVacio(rsSeccion.Fields.Item("MFS_Class").Value)) {
				ClaseSec = "" + rsSeccion.Fields.Item("MFS_Class").Value
			} else {
				ClaseSec = "form-group"
			}
			iSecCont++	
		
				sResultado += "<div class='" + ClaseSec + "'>" //+" control-label" 
					sResultado += "<label " + Clase + ">"
					sResultado += "<h3 style='border-bottom-color: #ee3733 !Important;"
					sResultado += "border-bottom-style: solid;"
					sResultado += "border-bottom-width: thin;'"
					sResultado += ">"+rsSeccion.Fields.Item("MFS_Nombre").Value+"</h3></label>"
				sResultado += "</div>"
		
			//Campos de la ficha MenuFichaCampos [Manejo de campos]
			
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
					Response.Write("<br /><font class='text-danger'><strong>"+sFCHCps +"</strong></font><br />")
				}		

			//Variables de la ficha normal {start}		
			//Sys_ID
			//Mnu_ID
			//WgCfg_ID
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
			var iMFCInformativo = 0
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

			//Variables de la ficha normal {end}					
			
			//Variables para el manejo de Edición y Consulta I {start}
			var sMFCValorDelCampo = ""

			//Variables para el manejo de Edición y Consulta I {end}
			
			var rsCampos = AbreTabla(sFCHCps,1,2)
			
				while (!rsCampos.EOF){		//Campos [Inicio]

					iContCol++
					iMFSID = 0 + rsCampos.Fields.Item("MFS_ID").Value
					iMFCID = 0 + rsCampos.Fields.Item("MFC_ID").Value
					iMFCRenglon = 0 + rsCampos.Fields.Item("MFC_Renglon").Value
					iMFCColumna = 0 + rsCampos.Fields.Item("MFC_Columna").Value
					sMFCOrden = "" + rsCampos.Fields.Item("MFC_Orden").Value
					iMFCOffset = "" + rsCampos.Fields.Item("MFC_Offset").Value
					sMFCAnchoEtiqueta = "" + rsCampos.Fields.Item("MFC_AnchoEtiqueta").Value
					iMFCOffsetCampo = "" + rsCampos.Fields.Item("MFC_OffsetCampo").Value
					sMFCAnchoCampo = "" + rsCampos.Fields.Item("MFC_AnchoCampo").Value
					iMFCHabilitado = 0 + rsCampos.Fields.Item("MFC_Habilitado").Value
					iMFCTipoCampo = 0 + rsCampos.Fields.Item("MFC_TipoCampo").Value
					iMFCFormato = 0 + rsCampos.Fields.Item("MFC_Formato").Value
					sMFCPlaceHolder = "" + rsCampos.Fields.Item("MFC_PlaceHolder").Value
					sMFCPlaceHolder = ((EsVacio(sMFCPlaceHolder)) ? "" : sMFCPlaceHolder)
					sMFCEtiqueta = "" + rsCampos.Fields.Item("MFC_Etiqueta").Value
					sMFCCampo = "" + rsCampos.Fields.Item("MFC_Campo").Value
					sMFCValorDefault = "" + rsCampos.Fields.Item("MFC_ValorDefault").Value
					sMFCTextoAyuda = "" + ( (EsVacio(rsCampos.Fields.Item("MFC_TextoAyuda").Value) ? "" : rsCampos.Fields.Item("MFC_TextoAyuda").Value) )
					//IFAnidado(EsVacio(rsCampos.Fields.Item("MFC_TextoAyuda").Value),"",rsCampos.Fields.Item("MFC_TextoAyuda").Value) 
					sMFCTextoValidacion = "" + rsCampos.Fields.Item("MFC_TextoValidacion").Value
					sMFCExpresionValidacion = "" + rsCampos.Fields.Item("MFC_ExpresionValidacion").Value
					iMFCRequerido = 0 + rsCampos.Fields.Item("MFC_Requerido").Value
					sMFCAlineacionEtiqueta = "" + rsCampos.Fields.Item("MFC_AlineacionEtiqueta").Value
					sMFCAlineacionCampo = "" + rsCampos.Fields.Item("MFC_AlineacionCampo").Value
					sMFCClass = "" + rsCampos.Fields.Item("MFC_Class").Value
					iMFCIDCatalogoGeneral = rsCampos.Fields.Item("MFC_IDCatalogoGeneral").Value
					sMFCComboTabla = "" + rsCampos.Fields.Item("MFC_ComboTabla").Value
					sMFCComboCampoLlave = "" + rsCampos.Fields.Item("MFC_ComboCampoLlave").Value
					sMFCComboCampoDesc = "" + rsCampos.Fields.Item("MFC_ComboCampoDesc").Value
					sMFCComboCondicion = "" + rsCampos.Fields.Item("MFC_ComboCondicion").Value
					sMFCEventosJS = "" + rsCampos.Fields.Item("MFC_EventosJS").Value
					sMFCLeyendaSelecTodos = "" + rsCampos.Fields.Item("MFC_LeyendaSelecTodos").Value
					iMFCSoloLectura = 0 + rsCampos.Fields.Item("MFC_SoloLectura").Value
					iMFCInformativo = 0 + rsCampos.Fields.Item("MFC_Informativo").Value
					iMFCEditablePermanente = 0 + rsCampos.Fields.Item("MFC_EditablePermanente").Value
					iMFCEsOculto = 0 + rsCampos.Fields.Item("MFC_EsOculto").Value
					sMFCarrValores = "" + rsCampos.Fields.Item("MFC_arrValores").Value
					iMFCEsPK = 0 + rsCampos.Fields.Item("MFC_EsPK").Value
					iMFCEsPKPrincipal = 0 + rsCampos.Fields.Item("MFC_EsPKPrincipal").Value
					iMFCEsBusqEstricta = 0 + rsCampos.Fields.Item("MFC_EsBusqEstricta").Value
									
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
							Response.Write("<br /><font class='text-danger'><strong>sCondRegCol&nbsp;" + sCondRegCol + "</strong></font><br />")
						}
						
					var iColPorSecReg = BuscaSoloUnDato("MAX(MFC_Columna)","MenuFichaCampos",sCondRegCol,1,2)
					var iRegPorSec = BuscaSoloUnDato("MAX(MFC_Renglon)","MenuFichaCampos",sCondRegCol,1,2)
		
						if (biQ4Web) {
							Response.Write("<br /><font class='text-danger' size='1'><strong>=============</strong></font><br />")
							Response.Write("<br /><font class='text-danger' size='1'><strong>&nbsp;iColPorSecReg&nbsp;" + iColPorSecReg + "&nbsp;iRegPorSec&nbsp;"+iRegPorSec+"&nbsp;iContCol&nbsp;"+ iContCol +"</strong></font><br />")
							Response.Write("<br /><font class='text-danger' size='1'><strong>iMFCRenglon&nbsp;"+parseInt(iMFCRenglon)+"&nbsp;iContRow&nbsp;"+iContRow+"</strong></font><br />")
						}
						
						if (iMFCRenglon != iContRow) {
							iContRen++
							iContRow = iMFCRenglon
							sResultado += "<div class=" + sC + "form-group" + sC + "><!-- row&nbsp;" + iContRen + " - renglon -->"
							//Response.Write("<br />Entra")
						} 
						
						if (biQ4Web) {
							Response.Write("<br /><font class='text-danger' size='1'><strong>Cerramos el renglon?</strong></font><br />")
							Response.Write("<br /><font class='text-danger' size='1'><strong>iColPorSecReg&nbsp;"+parseInt(iColPorSecReg))
							Response.Write("<br />&nbsp;iContCol&nbsp;"+iContCol+"</strong></font><br />")
						}
						
						if(parseInt(iColPorSecReg) == parseInt(iContCol)) {
							bCierraRow = true
							//iContRow = 0
							iContCol = 0	
						}
						
						//Variables para el manejo de Edición y Consulta II {start}
						sCampo = ""
						
						var sModoRO = Modo
						

						var sMFCValorDefaultBD = "" + rsCampos.Fields.Item("MFC_ValorDefault").Value
							sMFCValorDefault = ProcesaValorDefault(sMFCValorDefaultBD)
						
						sMFCValorDelCampo = Parametro( sMFCCampo , sMFCValorDefault  )
						//Variables para el manejo de Edición y Consulta II {end}
						
						switch (parseInt(iMFCTipoCampo)) {
						
						case 1:		//	1 = text box
						
							if (sModoRO == "Editar") {
								
								sCampo =  "<input type='text' class='" + sMFCClass + "'"
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
								
							} else {
								
								sCampo = "<p class='form-control-static'>" + AplicaFormato(iMFCFormato,sMFCValorDelCampo) + "</p>"
								
								if (iOcultoTipo2 == 2) {
									//sRespuesta += "<p class='form-control-static'>"
									sRespuesta += " <input type='hidden'"  
									sRespuesta += " name='" + sMFCCampo + "'"
									sRespuesta += " id='" + sMFCCampo + "'" 
									sRespuesta += " value='" + sMFCValorDelCampo + "'>"
									//sRespuesta += "</p> "
								}
								
							}
							
							if(!EsVacio(sMFCTextoAyuda)){
								//Ayuda
								sCampo += "<span class='help-block'>"
								sCampo += "<i class='fa fa-question-circle'></i>&nbsp;"
								sCampo += sMFCTextoAyuda
								sCampo += "</span>"
							}
								
							break;
		
						case 2:		//	2 = option
							
							if (!EsVacio(sMFCarrValores)) {
								var Valores = new Array(0)
								var Txt =""
								Txt = String(sMFCarrValores) // se explota el contenido para separar las opciones de los valores
								Valores = Txt.split("|")										
								var SarrOpciones  = Valores[0]
								var SarrValores	  = Valores[1]		
							}
							
							var Eventos = ""
							
							if (!EsVacio(sMFCClass)) {
								Eventos = "" + sMFCClass + " "
							}
							if (!EsVacio(sMFCEventosJS)) {
								Eventos += "  " + sMFCEventosJS 
							}
							
							sCampo = OpcionesFicha(sMFCCampo,Eventos,SarrOpciones,SarrValores,Parametro(sMFCCampo,sMFCValorDefault),sModoRO)
							
							sCampo += "<script type='text/javascript'> "
		
									sCampo += " if($('input[type=" + sC + "radio" + sC + "]').length) { "
										sCampo += "$('input[type=" + sC + "radio" + sC + "].grey').iCheck({ "
											sCampo += "radioClass: 'iradio_minimal-grey', "
											sCampo += "increaseArea: '10%' "
										sCampo += "});"
									sCampo += "}"
									
							sCampo += "</script>"

							if(!EsVacio(sMFCTextoAyuda)){
								//Ayuda
								sCampo += "<span class='help-block'>"
								sCampo += "<i class='fa fa-question-circle'></i>&nbsp;"
								sCampo += sMFCTextoAyuda
								sCampo += "</span>"
							}
							
							break;
								
						case 3:			//	3 = combo de cualquier tabla 
						
							break;
								
						case 4:			//	4 = combo
								 		//	cubierto en la seccion de un solo procedimiento
								 
							var sEventos = ""
							if (!EsVacio(FiltraVacios(sMFCEventosJS))) {
								sEventos =  " " + sMFCEventosJS + " "
							}
							
							var sEstilo = ""
							if (!EsVacio(FiltraVacios(sMFCClass))) {
								sEstilo =  "" + sMFCClass + ""
							}
							
							var sTabla = FiltraVacios(sMFCComboTabla)
							var sLlave = FiltraVacios(sMFCComboCampoLlave)
							var sCampoDescripcion = FiltraVacios(sMFCComboCampoDesc)
							
							var sCondicion = ""
							if (!EsVacio(FiltraVacios(sMFCComboCondicion))) {
								sCondicion += sMFCComboCondicion
								//sCondicion = FiltraVacios(sCondicion)
								sCondicion = ProcesaCondicionPorParametros(sCondicion)
							}
							
							
							var sOrden = ""
							if (!EsVacio(FiltraVacios(sMFCOrden))) {
								sOrden =  " " + sMFCOrden + " "
							}
							
							var sTodos = "Seleccione una opci&oacute;n"
							if (!EsVacio(FiltraVacios(sMFCLeyendaSelecTodos))) {
								sTodos = sMFCLeyendaSelecTodos
							}
								
							sCampo = CargaComboFicha(sMFCCampo,sEventos,sLlave,sCampoDescripcion,sTabla,sCondicion,sOrden,Parametro(sMFCCampo,sMFCValorDefault),0,sTodos,sModoRO,sEstilo) 
		
							if(!EsVacio(sMFCTextoAyuda)){
								//Ayuda
								sCampo += "<span class='help-block'>"
								sCampo += "<i class='fa fa-question-circle'></i>&nbsp;"
								sCampo += sMFCTextoAyuda
								sCampo += "</span>"
							}
							
							break;
							
						case 5:				//	5 = caja seleccion - checkbox
						
							var Eventos = ""
							if (!EsVacio(sMFCClass)) {
								Eventos = "class='" + sMFCClass + "'  "
							}

							sCampo = CajaSeleccion(sMFCCampo,Eventos,Parametro(sMFCCampo,1),1,sModoRO)
							
							sCampo += "<script type=" + sC + "text/javascript" + sC + "> "
		
									sCampo += " if($('input[type=" + sC + "checkbox" + sC + "]').length) { "
										sCampo += "$('input[type=" + sC + "checkbox" + sC + "].grey').iCheck({ "
											sCampo += "checkboxClass: 'icheckbox_minimal-grey', "
											sCampo += "increaseArea: '10%' "
										sCampo += "});"
									sCampo += "}"
									
							sCampo += "</script>"


							if(!EsVacio(sMFCTextoAyuda)){
								//Ayuda
								sCampo += "<span class='help-block'>"
								sCampo += "<i class='fa fa-question-circle'></i>&nbsp;"
								sCampo += sMFCTextoAyuda
								sCampo += "</span>"
							}
		
							break;
							
						case 6:				//	6 = fecha
							
							if (sModoRO == "Editar") {
								
								sCampo = "<div class='input-group'>"
									sCampo += "<input name='" + sMFCCampo + "' id='" + sMFCCampo + "'"
										sCampo += " placeholder='" + sMFCPlaceHolder + "' type='text' " 
										sCampo += " data-date-format='dd/mm/yyyy' data-date-viewmode='years'" 
										sCampo += " class='form-control date-picker' " 
										sCampo += " value='" + FormatoFecha(Parametro(sMFCCampo,'') ,'UTC a dd/mm/yyyy') + "'"
										sCampo += " >"
										sCampo += " <span class='input-group-addon'> <i class='fa fa-calendar'></i> </span>"
								sCampo += "</div>"
								
								sCampo += "<script type='text/javascript'>"
									sCampo += "	$(function() {"
						
										sCampo += "	$( '#" + sMFCCampo + "' ).datepicker({"
										sCampo += " format: 'dd/mm/yyyy',"
										sCampo += " language: 'es',"
										sCampo += " autoclose: true"
										sCampo += "});"
										
									sCampo += "});"
								sCampo += "</script>" 
								
							} else {

								sCampo = ""
								
								if (iOcultoTipo2 == 2) {
									sCampo += " <p class='form-control-static'><input type='hidden'" 
									sCampo += " name='" + sMFCCampo + "'"
									sCampo += " id='" + sMFCCampo + "'" 
									sCampo += " value='" + sMFCValorDelCampo+ "'></p> "
								} else {
									sCampo += "<p class='form-control-static'>" + AplicaFormato(iMFCFormato,sMFCValorDelCampo) + "</p>"
								}
							
							}

							if(!EsVacio(sMFCTextoAyuda)){
								//Ayuda
								sCampo += "<span class='help-block'>"
								sCampo += "<i class='fa fa-question-circle'></i>&nbsp;"
								sCampo += sMFCTextoAyuda
								sCampo += "</span>"
							}
							
							break;
							
						case 7:				//	7 = combo Catálogo General
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
							
							sCampo = ComboSeccionFicha(sMFCCampo,sEventos,sSeccion,Parametro(sMFCCampo,sMFCValorDefault),0,sTodos,sOrden,sModoRO,sEstilo)
							//sCampo = "&nbsp;" + AplicaFormato(iFormato,ValorDelCampo)
							
							if(!EsVacio(sMFCTextoAyuda)){
								//Ayuda
								sCampo += "<span class='help-block'>"
								sCampo += "<i class='fa fa-question-circle'></i>&nbsp;"
								sCampo += sMFCTextoAyuda
								sCampo += "</span>"
							}
							
							break;
							
						case 8:				//	8 = password
		
							sCampo =  "<input type='password' class='" + sMFCClass + "'"
							sCampo += " name='" + sMFCCampo + "'" 
							sCampo += " id='" + sC + sMFCCampo + "'" 
							sCampo += " placeholder='" + sC + sMFCPlaceHolder + "'"
							sCampo += ">"
							
							if(!EsVacio(sMFCTextoAyuda)){
								//Ayuda
								sCampo += "<span class='help-block'>"
								sCampo += "<i class='fa fa-question-circle'></i>&nbsp;"
								sCampo += sMFCTextoAyuda
								sCampo += "</span>"
							}
							
							break;
							
						case 9:				//	9 = Text Area
							
							if (sModoRO == "Editar") {
								
								sCampo = "<textarea id='" + sMFCCampo + "'"
								sCampo += " name='" + sMFCCampo + "'"
								sCampo += " placeholder='" + sMFCPlaceHolder + "'"
								sCampo += " class='" + sMFCClass + "'" + ">"
								sCampo += "</textarea>"
								
							} else {
								
								sCampo = "<p class='form-control-static'>" + sMFCValorDelCampo + "</p>"
								
							}
							
							if(!EsVacio(sMFCTextoAyuda)){
								//Ayuda
								sCampo += "<span class='help-block'>"
								sCampo += "<i class='fa fa-question-circle'></i>&nbsp;"
								sCampo += sMFCTextoAyuda
								sCampo += "</span>"
							}
							
							break;
							
						case 10:			//	10 = Sí / no
						
							break;
							
						case 11:			//	11 = text box doble para rangos
						
							break;
							
						case 12:			//	12 = text box doble para rangos fechas
						
							sCampo = "<div id='" + sNombreCampo + "' class='" + sMFCClass + "'></div>"
							
							break;
							
						case 13:			//	13 = 
						
							
							
							break;											

						case 20:			//	20 = text box doble para rangos fechas
						
							sCampo = " <input type='hidden" + "'"  
							sCampo += " name='" + sMFCCampo + "'" 
							sCampo += " id='" + sMFCCampo + "'" 
							sCampo += " value=''> "
							
							sCampo += "<div class='form-group'>"
								//Rango de fecha - Desde
								sCampo += "<div class='col-md-4'>"
									sCampo += "<div class='input-group'>"
										sCampo += "<input name='FechaDesde" + sMFCCampo + "'"
										sCampo += " id='FechaDesde" + sMFCCampo + "'"
										sCampo += " placeholder='" + sMFCPlaceHolder + "' type='text'" 
										sCampo += " data-date-format='dd/mm/yyyy' data-date-viewmode='years'"
										sCampo += " class='form-control date-picker'"  
										sCampo += " value='" + FormatoFecha(Parametro(sMFCCampo,'') ,'UTC a dd/mm/yyyy') + "'"
										sCampo += " >"
										sCampo += " <span class='input-group-addon' > <i class='fa fa-calendar'></i> </span>"
									sCampo += "</div>"
								sCampo += "</div>"
								//Rango de fecha - Hasta
								sCampo += "<div class='col-md-4'>"
									sCampo += "<div class='input-group'>"
										sCampo += "<input name='FechaHasta" + sMFCCampo + "'"
										sCampo += " id='FechaHasta" + sMFCCampo + "'"
										sCampo += " placeholder='" + sMFCPlaceHolder + "' type='text'" 
										sCampo += " data-date-format='dd/mm/yyyy' data-date-viewmode='years'" 
										sCampo += " class='form-control date-picker'" 
										sCampo += " value='" + sCFormatoFecha(Parametro(sMFCCampo,'') ,'UTC a dd/mm/yyyy') + "'"
										sCampo += " >"
										sCampo += " <span class='input-group-addon' > <i class='fa fa-calendar'></i> </span>"
									sCampo += "</div>"
								sCampo += "</div>"
							
							sCampo += "</div>"
		
								if(!EsVacio(sMFCTextoAyuda)){
									//Ayuda
									sCampo += "<span class='help-block'>"
									sCampo += "<i class='fa fa-question-circle'></i>&nbsp;"
									sCampo += sMFCTextoAyuda
									sCampo += "</span>"
								}
							
							sCampo += "<script type='text/javascript'>"
								sCampo += "	$(function(){"
									sCampo += "	$('#" + "FechaDesde" + sMFCCampo + "').datepicker({"
										sCampo += " format: 'dd/mm/yyyy',"
										sCampo += " language: 'es',"
										sCampo += " autoclose: true"
									sCampo += "});"
							
									sCampo += "	$('#" + "FechaHasta" + sMFCCampo +"').datepicker({"
										sCampo += " format: 'dd/mm/yyyy',"
										sCampo += " language: 'es',"
										sCampo += " autoclose: true"
									sCampo += "});"
									
									// disabling dates
									sCampo += "var nowTemp = new Date();"
									sCampo += "var now = new Date(nowTemp.getFullYear(), nowTemp.getMonth(), nowTemp.getDate(), 0, 0, 0, 0);"
		
									sCampo += " var checkin = $('#" + "FechaDesde" + sMFCCampo + "').datepicker({"
									sCampo += " onRender: function(date) { "
										sCampo += " return date.valueOf() < now.valueOf() ? 'disabled' : ''; "
									sCampo += " } "
									sCampo += " }).on('changeDate', function(ev) { "
									sCampo += "  if (ev.date.valueOf() > checkout.date.valueOf()) {"
									sCampo += "	var newDate = new Date(ev.date) "
									//sCampo += "	newDate.setDate(newDate.getDate() + 1); "
									//sCampo += "	checkout.setValue(newDate); "
									sCampo += "  }"
									sCampo += "  checkin.hide(); "
									
									sCampo += " $('#" + "FechaHasta" + sMFCCampo + "')[0].focus(); "
									sCampo += " }).data('datepicker'); "
									sCampo += " var checkout = $('#FechaHasta" + sMFCCampo + "').datepicker({"
									sCampo += " onRender: function(date) {"
									sCampo += " return date.valueOf() <= checkin.date.valueOf() ? 'disabled' : '';"
									sCampo += " }"
									sCampo += " }).on('changeDate', function(ev) { "
									sCampo += " checkout.hide(); "
									sCampo += " }).data('datepicker'); "
								sCampo += "});"
								
							sCampo += "</script>" 
						
							break;
							default:
		
								if (sModoRO == "Editar") {
									
									sCampo =  "<input type='text' class='" + sMFCClass + "'"
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
									
								} else {
									
									sCampo = "<p class='form-control-static'>" + AplicaFormato(iMFCFormato,sMFCValorDelCampo) + "</p>"
									
									if (iOcultoTipo2 == 2) {
										sRespuesta += " <p class='form-control-static'><input type='hidden'"  
										sRespuesta += " name='" + sMFCCampo + "'" 
										sRespuesta += " id='" + sMFCCampo + "'" 
										sRespuesta += " value='" + sMFCValorDelCampo + "'></p> "
									}
									
								}
							
							//break;
		
						}
								//Etiqueta
			
		    var etOffset = ""
			var etAncho = ""
			var etClase = ""								
			if(!EsVacio(iMFCOffset) && iMFCOffset > 0) {
				etOffset = " col-xs-offset-" + iMFCOffset
			}
			if(!EsVacio(sMFCAnchoEtiqueta)  && sMFCAnchoEtiqueta > 0) {
				etAncho = " col-xs-" + sMFCAnchoEtiqueta
			} else {
				etAncho = " col-xs-1" 
			}
			etClase = " class='control-label" + etOffset + etAncho + "'"
								
								sResultado += "<label " + etClase + " id='lbl"+ sMFCCampo + "'>"
								sResultado += "<strong>" + sMFCEtiqueta + "</strong>"  
								sResultado += "</label>"
								
								
		    var cpOffset = ""
			var cpAncho = ""
			var cpClase = ""								
			if(!EsVacio(iMFCOffsetCampo) && iMFCOffsetCampo > 0) {
				cpOffset = " col-xs-offset-" + iMFCOffsetCampo
			}
			if(!EsVacio(sMFCAnchoCampo) && sMFCAnchoCampo > 0) {
				cpAncho = " col-xs-" + sMFCAnchoCampo
			} else {
				cpAncho = " col-xs-5"
			}
			cpClase = " class='" + cpOffset + cpAncho + "'"
							
								
								//Tipo de campo
								sResultado += "<div" + cpClase + ">"
								sResultado += sCampo
								sResultado += "</div>"
						
						if(bCierraRow) {
							sResultado += "</div>"
						}

					rsCampos.MoveNext()
						
						if (iVueltas > 5) { return "Error al colocar el campo, revise las posiciones de columnas y renglones" }
						
				}
					
				rsCampos.Close()	//Campos [Fin]	
					
			rsSeccion.MoveNext()
		}	
		rsSeccion.Close()	
	

	return sResultado

}

function ArmaMarco() {

	var siQ4WebTipofrm = "form-horizontal"
	var siQ4WebID = "frmFicha"
	var siQ4WebNombre = "frmFicha"
	
	//Agregar estos campos a la tabla de Widget_Configuracion 
	//... yo los pondria en la tabla de menu_tabla, lo platicamos rog 7/4/2016
	//12 columnas manejo de Bootstrap	

	var sG = ""
	
	sG = "<div class='" + siQ4WebTipofrm + "' id='" + siQ4WebID + "' name='" + siQ4WebNombre + "'>"
		if(!AcabaDeBorrar) {
			sG += CargaBotones()
		}
		//sG += "<hr>"
			//Manejo del mensaje al termino de guardar un registro, verificar los estilos para que se cambie 
			//el renglon del aviso.
			if (Mensaje != ""){ 
			
//				sG += "<div id=\"mensaje\" class=" + sC + "form-group" + sC + ">"
//					sG += "<div class=\"ui-widget\">"
//						sG += "<div class=\"ui-state-highlight ui-corner-all\" style=\"margin-top: 20px; padding: 0 .7em;\"> "
//						sG += "<p><span class=\"ui-icon ui-icon-info\" style=\"float: left; margin-right: .3em;\"></span>"
//						sG += "<strong>Aviso</strong> " + Mensaje
//					sG += "</p></div>"
//				sG += "</div>"
//					Mensaje = ""
//				sG += "</div>"
				
				sG += "<div id='mensaje' class='form-group' style='padding:0px 30px 0px 30px;'>"
				
					sG += "<div class='alert alert-success'>"
						sG += "<button data-dismiss='alert' class='close'>"
							sG += "&times"
						sG += "</button>"
						sG += "&nbsp;<i class='fa fa-check-circle'></i>"
						sG += "&nbsp;<strong>Aviso!</strong>&nbsp;" + Mensaje + " viene de " + ImprimeDeDondeVengo()
					sG += "</div>"
					Mensaje = ""
						
				sG += "</div>"
				
			}

			//este es el renglon para notificaciones de error
			//sG += "<div id='notificacionerror' class='form-group'>"
				/*
				sG += '<div class="alert alert-danger">'
					sG += '<button data-dismiss="alert" class="close">'
						sG += '&times;'
					sG += '</button>'
					sG += '&nbsp;<i class="fa fa-times-circle"></i>'
					sG += '&nbsp;<strong>Error!</strong>&nbsp;' + Mensaje
				sG += '</div>'
					Mensaje = ""
				*/
			//sG += "</div>"
			if(!AcabaDeBorrar) {
				sG += CargaDatos() 
			}
		
	sG += "</div>"
	
	

	return sG
	
}

//		var sVieneDe = ImprimeDeDondeVengo()
//		Response.Write("<br> sVieneDe" + sVieneDe)	
		
function BorrarLLavePrincipal() {

	for (i=0;i<CampoNombre.length;i++) {
		if (CampoLLavePK[i] == 1 && CampoLLave[i] == 1) {
			CampoValor[i] = "-1"
			ParametroCambiaValor(CampoNombre[i], "-1")
		}
	}
			
}

	//LimpiaValores()
	LeerParametrosdeBD()
	EscribeParametrosdeBusquedaBD("")
	
	//Variables para el manejo de la ficha Modo - Accion
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
	
	//Falta un debug que no puse
	
	IniciaDebugBD()
	
	var SistemaActual = Parametro("SistemaActual",0)
	var mnuid = Parametro("VentanaIndex",0)
	//Permisos de los botones a mostrar
	var iMWPuedeAgregar = 0
	var iMWPuedeEditar = 0
	var iMWPuedeBorrar = 0
	
	var sSQLConfBase = " SELECT MW_Param, MW_PuedeAgregar, MW_PuedeBorrar, MW_PuedeEditar "
		sSQLConfBase += " FROM Menu_Widget "
		sSQLConfBase += " WHERE Sys_ID = " + SistemaActual
		sSQLConfBase += " AND Mnu_ID = " + VentanaIndex
		sSQLConfBase += " AND Wgt_ID = 76 "  // + iWgID
		sSQLConfBase += " AND WgCfg_ID = " + iWgCfgID
	
	if (biQ4Web) { 	Response.Write("<br /><font class='text-danger'><strong>"+sSQLConfBase +"</strong></font><br />")  }		
	
	var rsConfBase = AbreTabla(sSQLConfBase,1,2)

	if (!rsConfBase.EOF){
		
		iMWPuedeAgregar = rsConfBase.Fields.Item("MW_PuedeAgregar").Value
		iMWPuedeEditar  = rsConfBase.Fields.Item("MW_PuedeEditar").Value
		iMWPuedeBorrar  = rsConfBase.Fields.Item("MW_PuedeBorrar").Value
		
	}
	rsConfBase.Close()

	var sCondicionGeneral = ""
	var sOrdenadoPor = ""
	var sysid = SistemaActual
	var mnuid = VentanaIndex
	
	//Debug para las variables del manejo de la ficha
	if (iIQonDebug == 1) {	
		Response.Write("<br /><font class='text-danger' size='2'><strong>Accion&nbsp;" + Accion + "&nbsp;:&nbsp;=&nbsp;:&nbsp;Modo&nbsp;" + Modo  + "</strong></font>")
		Response.Write("<br /><font class='text-danger' size='2'><strong>SistemaActual&nbsp;" + SistemaActual + "&nbsp;:&nbsp;=&nbsp;:&nbsp;mnuid&nbsp;" + mnuid  + "</strong></font>")
	}

//=========== Tabla MenuFichaTabla {start} =====

	var sTabla = ""
	var SQLCondicion = ""
	var sOrdenadoPor = ""
	var	sMFC_SinPK_Ir_A = 0
	var sMFC_MensajeError = ""
	var iSQLVieneDeBuscador = 0
	var sCondicionPorParametro = ""  //   para arreglo de condiciones posicion: 1= campo 2=nombreparametreo 3,ValorDefault separado por comas y pipes
									//    ejemplos; Cli_ID,Cli_ID,-1|Cont_ID,Cont_ID,-1|Dir1_ID,Cli_ID,-1 este ultimo transfiero a dir1 el valor de cliid		

	var sFCHTabla = "SELECT * "
		sFCHTabla += " FROM MenuFichaTabla "
		sFCHTabla += " WHERE Sys_ID = " + SistemaActual
		sFCHTabla += " AND WgCfg_ID = " + iWgCfgID
		//sFCHTabla += " AND Mnu_ID = " + mnuid
		sFCHTabla += " AND MFS_ID = 1 "  //campo experimental para poner una tabla diferente por seccion, ahora solo funciona un solo registro por menu
		if (iIQonDebug == 1) {	
			Response.Write("<br /><font class='text-danger' size='2'><strong>sql&nbsp;:=&nbsp;" + sFCHTabla +  "</strong></font>")
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
//			var VPV = Parametro("VeZ",0)
//			if (Parametro("VeZ",0) == 0) {
//				Accion = rsTabla.Fields.Item("MFC_AccionEntrada").Value
//				Modo = rsTabla.Fields.Item("MFC_ModoEntrada").Value
//			}
		}	
		rsTabla.Close()	

	if (iIQonDebug == 1) {	
		Response.Write("<br /><font class='text-danger' size='2'><strong>=======Variables de la Tabla&nbsp;:=:&nbsp;" + sTabla +  "&nbsp;======={start}</strong></font>")
		Response.Write("<br /><font class='text-danger' size='2'><strong>&nbsp;sTabla:&nbsp;" + sTabla + "<br />&nbsp;SQLCondicion:&nbsp;" + SQLCondicion + "<br />&nbsp;sOrdenadoPor:&nbsp;" + sOrdenadoPor + "<br />&nbsp;sCondicionPorParametro:&nbsp;" + sCondicionPorParametro + "<br />&nbsp;iSQLVieneDeBuscador:&nbsp;" + iSQLVieneDeBuscador + "</strong></font>")
		Response.Write("<br /><font class='text-danger' size='2'><strong>=======Variables de la Tabla&nbsp;:=:&nbsp;" + sTabla +  "&nbsp;======={end}</strong></font>")
	}

//=========== Tabla MenuFichaTabla {end} =====

//Arreglos para el manejo de los valores de los campos - MenuFichaCampos - {start}

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
var GFINSRT = Parametro("GFINSRT",0)  //grabacion forzada hacer insert


var arCampos = new Array(0)
var MFC_EsOculto = new Array(0)	//para el control de campos ocultos
var MFC_EsPKPrincipal = ""	//Indica que es la llave principal, solo debe haber una
var MFC_EsPK = new Array(0)	//Indica si hay mas llaves en la tabla

var iPos = 0
var iPosO = 0

//=========== Tabla MenuFichaCampos - ParametrosPermanentes {start} =====


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
		Response.Write("<br /><font class='text-danger' size='2'><strong>sFCHCampos&nbsp;" + sFCHCampos + "</strong></font><br />") 
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


//=========== Tabla MenuFichaCampos - ParametrosPermanentes {end} =====

	var arrCampo      = new Array(0)
	var arrPrmCPP     = new Array(0)
	var bEnc = false

//=========== Condición por parametros {start}

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

//=========== Condición por parametros {end}

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
	//Manejo de nombres de los campos {end}
	
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


	//======================================= ACCIONES DE LA FICHA PARA EL MANEJO DE LA MISMA ================================= {start}
		
	if (Accion != "Vuelta") { 
	
		if (Accion == "Guardar") {
		//AgregaDebugBD("entre guardando accion = ",Accion )
			bRecienGuardado = true
			//bParametrosDeAjaxaUTF8=true
			//AgregaDebugBD("GFINSRT = ",GFINSRT )
			if (GFINSRT == 1) {
				ArmaCamposATrabajar("Insertar")
				//Response.Write(arrCamposATrabajar)
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
			Mensaje = "El registro fu&eacute; guardado correctamente"
			ParametroCambiaValor("Modo", "Consulta")
			ParametroCambiaValor("Accion", "Consulta")
		}	
		if (Accion == "Borrar") {
			BDDelete(CampoNombre,sTabla,sCondCamp,0)
			//Response.Write("sSQLMod&nbsp;" + sSQLMod + "<br>")	
			Mensaje = "El registro fu&eacute; borrado correctamente"
			Accion = "Consulta"
			Modo = "Borrado"
			AcabaDeBorrar = true
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
				Response.Write("<font class='text-danger' size='2'><strong>CargadodeDatosviasentenciasSQL&nbsp;" + sOtroQry + "</strong></font><br />")
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
						Response.Write("<font class='text-danger' size='2'><strong>Query Armado &nbsp;" + MFQ_Query + "</strong></font><br />")
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
						Response.Write("<font class='text-danger' size='2'><strong>Query Armado &nbsp;" + MFQ_Query + "</strong></font><br />")
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
					Response.Write("<br /><font class='text-danger'><strong>sTabla&nbsp;" + sTabla + "</strong></font><br />")	 
					Response.Write("<font class='text-danger'><strong>sLLavePrimaria&nbsp;" + sLLavePrimaria + "</strong></font><br />")
					Response.Write("<font class='text-danger'><strong>SQLCondicion&nbsp;" + SQLCondicion + "</strong></font><br />")	
				}
				
		
			if (iIQonDebug == 1) {	Response.Write("<font class='text-danger'><strong>Tabla_A_Manejar&nbsp;" + sConsultaSQL + "</strong></font><br />")	}
			if (iIQonSentNecesaria == 1) {
				Response.Write("iIQonDebug&nbsp;" + iIQonDebug + "&nbsp;IDUsuario&nbsp;" + Parametro("IDUsuario",Session("IDUsuario")) +"<br />")		
				Response.Write("sConsultaSQL&nbsp;  " + sConsultaSQL + "<br />")
			}
		
			AgregaDebugBD("sql ficha carga inicial",sConsultaSQL )
			bHayParametros = false
			ParametroCargaDeSQL(sConsultaSQL,0)
	
	} 
	//======================================= ACCIONES DE LA FICHA PARA EL MANEJO DE LA MISMA ================================= {end}
	
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
	
	//Cuando las llaves estan vacías se levanta una ventana de error
	if (bLlavesVacias) {
		
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
				
	} else {
		//AgregaDebugBD("Modo = " + Modo,"Accion = " + Accion )
		Response.Write(ArmaMarco())
		var campocul = ImprimeOcultos()
		Response.Write("<br> " + campocul)

	}
	

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

	function ImprimeDeDondeVengo() {
		
		var sCamposDeDondeViene = ""
		var iMnuViene = -1
		
		var sSQLIDVieneDe = "SELECT Mnu_ID FROM Menu WHERE Sys_ID = " + SistemaActual
			sSQLIDVieneDe += " AND Mnu_SiguienteVentana IN (SELECT Mnu_Padre FROM Menu WHERE Sys_ID = " + SistemaActual	
			sSQLIDVieneDe += " AND Mnu_ID = " + VentanaIndex +" )"
			//Response.Write(sSQLIDVieneDe)
		//SELECT Mnu_ID FROM Menu WHERE Sys_ID = 50 AND Mnu_SiguienteVentana IN (SELECT Mnu_Padre FROM Menu WHERE Sys_ID = 50 AND Mnu_ID = 315) 
		var rsDeDondeViene = AbreTabla(sSQLIDVieneDe,1,2)
		
		if(!rsDeDondeViene.EOF) {
			iMnuViene = rsDeDondeViene.Fields.Item("Mnu_ID").Value
			sCamposDeDondeViene += " <input type='hidden' name='MnuIDVieneDe' id='MnuIDVieneDe'"
			sCamposDeDondeViene += " value='" + iMnuViene + "'> "
		}
		rsDeDondeViene.Close()
		
		return sCamposDeDondeViene

	}


%>
