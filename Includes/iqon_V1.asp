<!--#include file="Constantes.asp" -->
<!--#include file="JavaScript.asp" -->
<!--#include file="Connection.asp" -->

<% 
// Modificación : 30 de Noviembre del 2001  JD ROG
// Modificación : 20 de Diciembre del 2001   ROG
// Modificación :  12 de Marzo del 2002 JD
// Modificación : 6 de Abril del 2002 ROG
// Modificación :  29 mayo 2002 ROG
// Modificación :  30 mayo 2002 ROG
// Modificación : 25 Nov 2002 ROG
// Modificación : 28/07/2003 DRP 
// Modificación : 12 May 2004 ROG Y DRP
// Modificación : 7 Abr 2008 ROG y JD
// Ultima Actualizacion : 11 Enero 2011 ROG y JD
// Cualquier información sobre este código puede llamar 
// IQON Sistemas de Información
// email : rornelas@hotmail.com  

// *********************************************************** Funciones *********************************************************
//  Indice de Funciones usadas:
// 1) CargaParametros() 
// 2) Parametro(Nombre,ValorPredeterminado)   
// 3) ArrBuscaValorEnParametro(NombreParametro,ValorABuscar,Tipo)
// 4) ArrBuscaValor(NombreArreglo,ValorABuscar,Tipo)
// 5) DameParametro(Nombre,ValorInicial)
// 6) CreaRS(Tipo,Conexion) 
// 7) ValidaSeguridad(valor)
// 8) NuevaSeguridad(Cambios,Altas,Bajas) 
// 9) AntiCache()
// 10) AbreTabla(sConsultaSQL,Tipo,Conexion)
// 11) LlenaCombo(sConsultaSQL,Seleccionado,LLConexion)
// 11a) LlenaCombo2(sConsultaSQL,Seleccionado,LLConexion)	REGRESA CUANTOS ELEMENTOS HAY EN EL COMBO ADEMAS DE LLENARLO
// 12) Ejecuta(sConsultaSQL,Conexion)
// 13) SiguienteID(CampoLlave,Tabla,Condicion,Conexion)
// 14) BuscaEnArreglo(Arreglo,Valor)
// 15) LimpiaValores()
// 16) ParametroEsPermanente(NombreParametro,ValoraColocar) 
// 17) ParametroCambiaValor(NombreParametro,ValoraColocar)
// 18) ParametroCambiaTipo(NombreParametro,ValoraColocar,Tamano)
// 19) ParametroCargaDeSQL(SQL,Conexion)
// 20) ParametroCargaTipoDato(SQL,Conexion)
// 21) CargaCombo(NombreCombo,Eventos,CampoID,CampoDescripcion,Tabla,Condicion,Orden,Seleccionado,Conexion,Todos)
//	REGRESA CUANTOS ELEMENTOS HAY EN EL COMBO ADEMAS DE LLENARLO
// 21a) CargaCombo(NombreCombo,Eventos,CampoID,CampoDescripcion,Tabla,Condicion,Orden,Seleccionado,Conexion,Todos)
// 22) Botones(NombreAccion,NombrDelForm,bTablaVacia)
// 23) 
// 24) ConvierteAAreglo(Arreglo,Texto)
// 25) ImprimeArreglo()
// 26) 
// 27) 
// 28) 
// 29) ValidaInsercion(VIValores, VIarCamposBD, sTabla, iIndiceInicial, iConexion, sCampoID,sCondExtra)
// 30) BDInsert(Campos,Tabla,Condicion,Conexion,IndiceInicial,ValidaInserta,sCampoID,sCondExtra)
// 31) BDUpdate(Campos,Tabla,Condicion,Conexion)
// 32) BDDelete(Campos,Tabla,Condicion,Conexion)//
// 33) PasoVariablesFrameset() 
// 34) EsVacio(Dato)
// 39) BuscaSeg(sValor,sSeg)
// 40) Seguridad (Altas,Bajas,Cambios,sSeg)
// 42) FiltraVacios(Dato)   // solo devuelve el valor si no es nulo
// 43) ConvierteACadena(Arreglo,Indice)		//Regresa la cadena, exceptuando el Indice del Arreglo

// 45) AudInsertar(NombreTabla, sDatos, Condicion, Mensaje, TipoAccion)

// 48) DameSessionID()
// 49) DSITrim(sCadena)
// 54) BuscaSoloUnDato(Campo,Tabla,Condicion,ValorDefault,Conexion) 
// 55) LeeParametrosGlobales()
// 56) EscribeParametrosGlobales(sDatos,sReferer)
// 57) DameRuta()
// 58) MarcaVLU(NoSeriePrd,iStatusVLU,iPrograma,iAgencia,iPlaza)

// 62) RedondeaNumero(mRNCantidad,iRNDecimales,iRNProfundiza)
// 65) DameCondicionDeParametros(VIarCamposBD, iIndiceInicial)
// 70) MonedaTexto(cCantidad, bMuestraMoneda)
// 71) ActualizaCLIID() 



function RemplazaComillas(CadenaCompleta) {
    var Acc = ""
	for (i=0;i<=CadenaCompleta.length;i++) {
		Acc += CadenaCompleta.substr(i,1)
		if (CadenaCompleta.substr(i,1) == '"') {
			Acc += CadenaCompleta.substr(i,1)
		}
	}
	return Acc
}

function Remplaza(CadenaCompleta) {
var sResultado = CadenaCompleta
    blankPos = CadenaCompleta.indexOf("'");
	if (blankPos > -1) {
		firstName = CadenaCompleta.substr(0, blankPos);
		lastName = CadenaCompleta.substr(blankPos + 1, CadenaCompleta.length - blankPos)
		sResultado =  firstName + "\'\'" + Remplaza(lastName);
		//sResultado = Remplaza(sResultado)
	} 
		
	return sResultado
}

function RemplazaCon(CadenaCompleta,Buscando,Sustituyendo) {
var sResultado = CadenaCompleta
    blankPos = CadenaCompleta.indexOf(String(Buscando));
	if (blankPos > -1) {
		firstName = CadenaCompleta.substr(0, blankPos);
		lastName = CadenaCompleta.substr(blankPos + 1, CadenaCompleta.length - blankPos)
		sResultado =  firstName + String(Sustituyendo) + Remplaza(lastName);
		//sResultado = Remplaza(sResultado)
	} 
		
	return sResultado
}


function QuitaComillas(CadenaCompleta) {
var sResultado = CadenaCompleta
    blankPos = CadenaCompleta.indexOf("'");
	if (blankPos > -1) {
		firstName = CadenaCompleta.substr(0, blankPos);
		lastName = CadenaCompleta.substr(blankPos + 1, CadenaCompleta.length - blankPos)
		sResultado =  firstName + "" + Remplaza(lastName);
		//sResultado = Remplaza(sResultado)
	} 
		
	return sResultado
}

// 1)Obtiene los valores de los todos los parametros
function CargaParametros() {

var NPG = 0
var NPP = 0
var ID = 0

bHayParametros = false

//cargo los parametros permanentes 

  try {
		var sSQLPP = "SELECT * from ParametrosPermanentes "
			sSQLPP +=  " WHERE Sys_ID = " + Parametro("SistemaActual",0)
			sSQLPP +=  " AND PP_Habilitado = 1 " 
			sSQLPP +=  " AND PP_Seccion = (select Mnu_UsarPP from Menu "
			sSQLPP +=  " where Sys_ID = " + Parametro("SistemaActual",0) + " and Mnu_ID = " + Parametro("VentanaIndex",0) + ") "
			sSQLPP +=  " Order by PP_Orden " 

		var rsPP = AbreTabla(sSQLPP,1,2) 
		while (!rsPP.EOF){		
			ID = ParametroNuevosValor(rsPP.Fields.Item("PP_Nombre").Value,rsPP.Fields.Item("PP_Default").Value)
			ParamPermanente[ID] = 1
			rsPP.MoveNext()
		}
		rsPP.Close()
  } catch(err) {
 		AgregaDebug("Error en el cargado de Parametros permanentes","==========")
  }

			for (var items=new Enumerator(Request.QueryString); !items.atEnd(); items.moveNext()) {
			  ParametroNuevosValor(items.item(),Request.QueryString(items.item()))
//		// Parametros[iID]=items.item()
//		//	  Valores[iID]=Request.QueryString(items.item())
//		//	  TipoCampo[iID]=-1
//		//	  TamanoCampo[iID]=0
//		//	  Permanente[iID]=0
//		//  //	  if (Parametros[iID] == "RegPorVentana") {  //ROG 31 Dic 2010  1:07 am  proteccion para valores acumulados
//		//  //		var Txt = String(Valores[iID])
//		//  //		var Arreglo = Txt.split(",")
//		//  //		Valores[iID] = Arreglo[0]
//		//  //	  }	 
//		//	  iID++
//		//	  NPG++
				bHayParametros = true
			}
	//CargaParametrosDesdeArreglo(String(Request.QueryString))
	
	for (var items=new Enumerator(Request.Form); !items.atEnd(); items.moveNext()) {
	  ParametroNuevosValor(items.item(),Request.Form(items.item()))
//	  Parametros[iID]=items.item()
//	  Valores[iID]=Request.Form(items.item())
//	  TipoCampo[iID]=-1
//	  TamanoCampo[iID]=0
//	  Permanente[iID]=0
//  //	  if (Parametros[iID] == "RegPorVentana") {   //ROG 31 Dic 2010  1:07 am  proteccion para valores acumulados
//  //		var Txt = String(Valores[iID])
//  //		var Arreglo = Txt.split(",")
//  //		Valores[iID] = Arreglo[0]
//  //	  }	   	  
//	  iID++
//	  NPP++
	  bHayParametros = true
	}
	
//Revision de parametros permanentes no duplicados
//	for (x=0;x<=Parametros.length;x++) {
//		if (ParamPermanente[x] = 1) {
//			var Txt = String(Valores[x])
//			if (Txt.indexOf(",") > 0) {
//				var Arreglo = Txt.split(",")
//				//Valores[x] = Arreglo[Arreglo.length]
//				Valores[x] = Arreglo[1]
//			}
//  	  	}	
//	}	


	SerializaParametros()

}
 
function CargaParametrosDesdeArreglo(ArrTxt){ 
 
 
}
 
function CargaParametrosDesdeArreglo2(ArrTxt){
	var Txt = String(ArrTxt)
//	if (!EsVacio(Txt)) {
//	  Txt = Txt.replace(/\%C3%A1/g, "á")
//	  Txt = Txt.replace(/\%C3%A9/g, "é")
//	  Txt = Txt.replace(/\%C3%AD/g, "í")
//	  Txt = Txt.replace(/\%C3%B3/g, "ó")
//	  Txt = Txt.replace(/\%C3%BA/g, "ú")
//	  Txt = Txt.replace(/\%C3%B1/g, "ñ")
//		Txt = Txt.split("%E1").join("á")
//		Txt = Txt.split("%E9").join("é")
//		Txt = Txt.split("%ED").join("í")
//		Txt = Txt.split("%F3").join("ó")
//		Txt = Txt.split("%FA").join("ú")
//		Txt = Txt.split("%F1").join("ñ")
//	}
	
	
	try {
		Txt = decodeURIComponent(Txt).replace(/\+/g, " ");
	} catch(err) {
 		//AgregaDebug("Error en el cargado de Parametros permanentes","==========")
    }

	if (!EsVacio(Txt)) {
		//ROG 4/07/2013  entraba un parametro con coma y caracter raro y ya no se leia el restode los parametros
		Txt = Txt.split("%5F").join("_")
		Txt = Txt.split("%2C").join(",")
		Txt = Txt.split("+").join(" ")
		Txt = Txt.split("%26").join("&")
		Txt = Txt.split("%3D").join("=")

//		Txt = Txt.split("%E1").join("á")
//		Txt = Txt.split("%E9").join("é")
//		Txt = Txt.split("%ED").join("í")
//		Txt = Txt.split("%F3").join("ó")
//		Txt = Txt.split("%FA").join("ú")
//		Txt = Txt.split("%F1").join("ñ")		

//		Txt = Txt.split("%C1").join("Á")
//		Txt = Txt.split("%C9").join("É")
//		Txt = Txt.split("%CD").join("Í")
//		Txt = Txt.split("%D3").join("Ó")
//		Txt = Txt.split("%DA").join("Ú")
//		Txt = Txt.split("%D1").join("Ñ")	
			
		Txt = Txt.split("%2E").join(".")
		Txt = Txt.split("%3A").join(":")	
		Txt = Txt.split("%3B").join(";")
		
		var Arreglo = Txt.split("&")   
		for (xpqs=0;xpqs<Arreglo.length;xpqs++) {
		//Response.Write(xpqs + ") " +  Arreglo[xpqs] + "<br>" )
			var TxtElemento = String(Arreglo[xpqs])
			var ArrElemento = TxtElemento.split("=")
			if (!EsVacio(ArrElemento[1])) {
				ParametroNuevosValor(ArrElemento[0],ArrElemento[1])
				ParametroCambiaValor(ArrElemento[0],ArrElemento[1])
			}
		}
	}
}

var Utf8 = {
 
	// public method for url encoding
	encode : function (sDato) {
		sDato = sDato.replace(/\r\n/g,"\n");
		var utftext = "";
 
		for (var n = 0; n < sDato.length; n++) {
 
			var c = sDato.charCodeAt(n);
 
			if (c < 128) {
				utftext += String.fromCharCode(c);
			}
			else if((c > 127) && (c < 2048)) {
				utftext += String.fromCharCode((c >> 6) | 192);
				utftext += String.fromCharCode((c & 63) | 128);
			}
			else {
				utftext += String.fromCharCode((c >> 12) | 224);
				utftext += String.fromCharCode(((c >> 6) & 63) | 128);
				utftext += String.fromCharCode((c & 63) | 128);
			}
 
		}
 
		return utftext;
	},
 
	// public method for url decoding
	decode : function (utftext) {
		var sDato = "";
		var i = 0;
		var c = c1 = c2 = 0;
 
		while ( i < utftext.length ) {
 
			c = utftext.charCodeAt(i);
 
			if (c < 128) {
				sDato += String.fromCharCode(c);
				i++;
			}
			else if((c > 191) && (c < 224)) {
				c2 = utftext.charCodeAt(i+1);
				sDato += String.fromCharCode(((c & 31) << 6) | (c2 & 63));
				i += 2;
			}
			else {
				c2 = utftext.charCodeAt(i+1);
				c3 = utftext.charCodeAt(i+2);
				sDato += String.fromCharCode(((c & 15) << 12) | ((c2 & 63) << 6) | (c3 & 63));
				i += 3;
			}
 
		}
 
		return sDato;
	}
 
}
 
function utf8_decode (str_data) {
  // http://kevin.vanzonneveld.net
  // +   original by: Webtoolkit.info (http://www.webtoolkit.info/)
  // +      input by: Aman Gupta
  // +   improved by: Kevin van Zonneveld (http://kevin.vanzonneveld.net)
  // +   improved by: Norman "zEh" Fuchs
  // +   bugfixed by: hitwork
  // +   bugfixed by: Onno Marsman
  // +      input by: Brett Zamir (http://brett-zamir.me)
  // +   bugfixed by: Kevin van Zonneveld (http://kevin.vanzonneveld.net)
  // *     example 1: utf8_decode('Kevin van Zonneveld');
  // *     returns 1: 'Kevin van Zonneveld'
  var tmp_arr = [],
    i = 0,
    ac = 0,
    c1 = 0,
    c2 = 0,
    c3 = 0;

  str_data += '';

  while (i < str_data.length) {
    c1 = str_data.charCodeAt(i);
    if (c1 < 128) {
      tmp_arr[ac++] = String.fromCharCode(c1);
      i++;
    } else if (c1 > 191 && c1 < 224) {
      c2 = str_data.charCodeAt(i + 1);
      tmp_arr[ac++] = String.fromCharCode(((c1 & 31) << 6) | (c2 & 63));
      i += 2;
    } else {
      c2 = str_data.charCodeAt(i + 1);
      c3 = str_data.charCodeAt(i + 2);
      tmp_arr[ac++] = String.fromCharCode(((c1 & 15) << 12) | ((c2 & 63) << 6) | (c3 & 63));
      i += 3;
    }
  }

  return tmp_arr.join('');
}


function utf8_encode (argString) {
  // http://kevin.vanzonneveld.net
  // +   original by: Webtoolkit.info (http://www.webtoolkit.info/)
  // +   improved by: Kevin van Zonneveld (http://kevin.vanzonneveld.net)
  // +   improved by: sowberry
  // +    tweaked by: Jack
  // +   bugfixed by: Onno Marsman
  // +   improved by: Yves Sucaet
  // +   bugfixed by: Onno Marsman
  // +   bugfixed by: Ulrich
  // +   bugfixed by: Rafal Kukawski
  // +   improved by: kirilloid
  // *     example 1: utf8_encode('Kevin van Zonneveld');
  // *     returns 1: 'Kevin van Zonneveld'

  if (argString === null || typeof argString === "undefined") {
    return "";
  }

 // var string = (argString + ''); // .replace(/\r\n/g, "\n").replace(/\r/g, "\n");
  var argString = argString.replace(/\r\n/g, "\n").replace(/\r/g, "\n"); 
  var utftext = '',
    start, fin, stringl = 0;

  start = fin = 0;
  stringl = argString.length;
  for (var n = 0; n < stringl; n++) {
    var c1 = argString.charCodeAt(n);
    var enc = null;

    if (c1 < 128) {
      fin++;
    } else if (c1 > 127 && c1 < 2048) {
      enc = String.fromCharCode((c1 >> 6) | 192, (c1 & 63) | 128);
    } else {
      enc = String.fromCharCode((c1 >> 12) | 224, ((c1 >> 6) & 63) | 128, (c1 & 63) | 128);
    }
    if (enc !== null) {
      if (fin > start) {
        utftext += argString.slice(start, fin);
      }
      utftext += enc;
      start = fin = n + 1;
    }
  }

  if (fin > start) {
    utftext += argString.slice(start, stringl);
  }

  return utftext;
}

// 2)
function Parametro(Nombre,ValorPredeterminado) {
// Extrae del arreglo de parametros su valor de lo contrario pone el determinado
  for(i=0;i<Parametros.length;i++){ 

	  try {
	  //esto es temporal lo juro lo arreglo luego  10feb 2011 rog
		if (Valores[i].indexOf("{Parametro:") >= 0 ) { Valores[i] = "" }
	  } catch(err) {
	//		bOcurrioError = true 
	//		AgregaDebug("Error en Parametro","===============================================================")
	//		AgregaDebug("Parametro de entrada",Nombre)
	//		AgregaDebug("Error description ",err.description)
	//		AgregaDebug("Error number ",err.number)
	//		AgregaDebug("Error message ",err.message)		  
	//		AgregaDebug("Fin Error en Parametro","===============================================================")
	   }	
	  
		if (Parametros[i] == Nombre) {
			if (EsVacio(String(Valores[i]))) {
				return (ValorPredeterminado)
			} else {
				return (Valores[i])
			}
		}

		
		

	  }
	return (ValorPredeterminado)
}

function Debug_ImprimeParametros(sMensaje) {
	if (Debug_Imprime == 1) {	%>
        <br /><font color='red' size='2'><strong><%=sMensaje%></strong></font>
        <%
        for (x=0;x<Parametros.length;x++) { %>
            <br /><font color='red' size='2'><strong><%=Parametros[x]%></strong> = <%=Valores[x]%></font>
        <% }    
    }
}

function MantenSoloParametrosPermanente() {
var iSalir = 0
var bBorrarParametro = false
var iElementos = Parametros.length

		for (x=iElementos;x>=0;x--) {
			switch(String(Parametros[x])){
				case "SistemaActual":
				  bBorrarParametro = false
				  break;
				case "VentanaIndex":
				  bBorrarParametro = false
				  break;
				case "SiguienteVentana":
				  bBorrarParametro = false
				  break;
				case "TabIndex":
				  bBorrarParametro = false
				  break;
				case "Modo":
				  bBorrarParametro = false
				  break;
				case "Accion":
				  bBorrarParametro = false
				  break;
				case "sUsuarioSes":
				  bBorrarParametro = false
				  break;
				case "IDUsuario":
				  bBorrarParametro = false
				  break;
				case "Usu_Tipo":
				  bBorrarParametro = false
				  break;
				case "iqCli_ID":
				  bBorrarParametro = false
				  break;
				default:
				  bBorrarParametro = true
				  if (ParamPermanente[x] == 1) {
						bBorrarParametro = false
				  } 
			}
		
			if (bBorrarParametro) {
				Parametros.splice(x,1)
				Valores.splice(x,1)
				TipoCampo.splice(x,1)
				TamanoCampo.splice(x,1)
				Permanente.splice(x,1)
				ParamPermanente.splice(x,1)
			}
		}
} 

function ElParametroEsPermanente(sNombreParam) {
	var Resulta = 0

			for (x=0;x<=Parametros.length;x++) {
				if (sNombreParam == Parametros[x]) {
					Resulta = parseInt(ParamPermanente[x])
					return Resulta
				} 
			}
	
	return Resulta
	
} 

function DesSerializaParametros(){

	MantenSoloParametrosPermanente()

	if (!EsVacio(sParametrosSerializados) ) {
	
//		var Txt = String(sParametrosSerializados)
//		Txt = Txt.replace(/\%C3%A1/g, "á");
//		Txt = decodeURIComponent(Txt).replace(/\+/g, " ");
//
//		Txt = Txt.split("%5F").join("_")
//		Txt = Txt.split("%2C").join(",")
//		Txt = Txt.split("+").join(" ")
//		
//		sParametrosSerializado = String(Txt)
	
		arrPrm = sParametrosSerializados.split("&")
		for (i=0;i<arrPrm.length;i++) {
			var Txt = String(arrPrm[i])
			var arrDT = Txt.split("=")
			//esto es porque yiorch encontro que si habia un igual no guardaba y se desmadraba todo
			//por eso si ya lo desmadro lo junto de nuevo   JD 14/11/2012 3:29 am
			if(arrDT.length == 3) {
				arrDT[1] = arrDT[1] + " = " + arrDT[2]
			}
			//no cargo los parametros que vengan vacios
			if (!EsVacio(arrDT[1]) && arrDT[1] != -1) {
				ParametroCambiaValor(arrDT[0],arrDT[1])
			}
		}
	}

}

function SerializaParametros() {

	sParametrosSerializados = ""
	for(i=0;i<Parametros.length;i++){ 
		if (EsVacio(Valores[i]) || Valores[i] == -1) {
			Valores[i] = ""
		} else {
			//valido que no este repetido y solo tomo el primero
			var VezEnc = 0
			for(xi=0;xi<Parametros.length;xi++){ 
				if (Parametros[i] == Parametros[xi]) {
					VezEnc++
					if(VezEnc>1) {
						Parametros[xi] = VezEnc + Parametros[i]
						Valores[xi] = ""
					}
				}
			}
			if(VezEnc==1) {
				if (sParametrosSerializados != "") {sParametrosSerializados += "&" }
				sParametrosSerializados += Parametros[i] + "=" + Valores[i]
			}
		}
	}
	
	if (sParametrosSerializados != "" ) {
		Session("IQPSerial") = String(sParametrosSerializados)
	} else {
		//esta parte es muy importante para los widgets y pligins que entran a un tercer nivel y necesitan datos
		sParametrosSerializados = Session("IQPSerial")
		DesSerializaParametros()
	}
}

function GuardaParametrosenBD() {  
var sSesion = Session.SessionID	
var sParametro = ""	

var Condicion = " Nav_Sesion = '" + sSesion + "' AND Nav_Vigente = 1 "
sParametro = BuscaSoloUnDato("top 1 Nav_Parametros","Navegacion",Condicion,"",2)






	if (EsVacio(sParametro)) {
		if(EsVacio(UsuarioTpo)) {
			UsuarioTpo = -1
		}
		InicializaSesion(IDUsuario,UsuarioTpo)
	}
	sParametro=""
	if (bHayParametros) {
		for(i=0;i<Parametros.length;i++){ 
			if (EsVacio(Valores[i]) || Valores[i] == -1) {
				Valores[i] = ""
			} else {
				//valido que no este repetido y solo tomo el primero
				var VezEnc = 0
				for(xi=0;xi<Parametros.length;xi++){ 
					if (Parametros[i] == Parametros[xi]) {
						VezEnc++
						if(VezEnc>1) {
							Parametros[xi] = VezEnc + Parametros[i]
							Valores[xi] = ""
						}
					}
				}
				if(VezEnc==1) {
					if (sParametro != "") {sParametro += "&" }
					sParametro += Parametros[i] + "=" + Valores[i]
				}
			}
		}
		if(EsVacio(UsuarioTpo)) {
			UsuarioTpo = -1
		}

//		var sSQL = "Update Navegacion Set Nav_Parametros = '" + sParametro + "'"
//			sSQL += ", Nav_Sesion = '" + sSesion +"' "
//			sSQL += " where Usu_ID = " + IDUsuario
//			sSQL += " and Tpo_Usr = " + UsuarioTpo
//			sSQL += " and Sys_ID = " + SistemaActual
//			sSQL += " AND Nav_Vigente = 1 "
//
//		Ejecuta(sSQL,2)
		
		if (bLeeParametrosCampoBusqueda) {
			var sSQL = "Update Navegacion Set Nav_ParametrosBusqueda = '" + sParametro + "'"
			sSQL += " Where  Nav_Sesion = '" + sSesion +"' "
			sSQL += " AND Nav_Vigente = 1 "
			sSQL += " AND Usu_ID = " + IDUsuario
			sSQL += " and Tpo_Usr = " + UsuarioTpo
			sSQL += " and Sys_ID = " + SistemaActual
			sSQL += " AND Nav_ParametrosBusqueda = ''"

			Ejecuta(sSQL,2)
		}
	} 
}


function LeerParametrosdeBD() {
var sSesion = Session.SessionID	
var sParametro = ""
var arrPrm = new Array(0)
var arrDT = new Array(0)
	
//valido los parametros permanentes 
//  try {
//		var sSQLPP = "SELECT * from ParametrosPermanentes "
//			sSQLPP +=  " WHERE Sys_ID = " + Parametro("SistemaActual",0)
//			sSQLPP +=  " AND PP_Habilitado = 1 " 
//			sSQLPP +=  " Order by PP_Orden " 
//
//		var rsPP = AbreTabla(sSQLPP,1,2) 
//		while (!rsPP.EOF){		
//			ID = ParametroNuevosValor(rsPP.Fields.Item("PP_Nombre").Value,rsPP.Fields.Item("PP_Default").Value)
//			ParamPermanente[ID] = 1
//			rsPP.MoveNext()

//		}
//		rsPP.Close()
//  } catch(err) {
////		AgregaDebug("Error en el cargado de Parametros permanentes","==========")

//  }
	
	var Condicion = " Nav_Sesion = '" + sSesion + "' AND Nav_Vigente = 1 "
//	sParametro = BuscaSoloUnDato("top 1 Nav_Parametros","Navegacion",Condicion,"",2) 

//
//	if (!EsVacio(sParametro) ) {
//		arrPrm = sParametro.split("&")




//		for (i=0;i<arrPrm.length;i++) {
//			var Txt = String(arrPrm[i])
//			var arrDT = Txt.split("=")
//			//no cargo los parametros que vengan vacios
//			if (!EsVacio(arrDT[1]) && arrDT[1] != -1) {
//				ParametroCambiaValor(arrDT[0],arrDT[1])

//			}
//		}
//	}
	Condicion += " AND Nav_ParametrosBusqueda <> '' "
	if (bLeeParametrosCampoBusqueda) {
		sParametro = BuscaSoloUnDato("top 1 Nav_ParametrosBusqueda","Navegacion",Condicion,"",2) 
		if (!EsVacio(sParametro) ) {
			arrPrm = sParametro.split("&")
			for (i=0;i<arrPrm.length;i++) {
				var Txt = String(arrPrm[i])
				var arrDT = Txt.split("=")
				ParametroCambiaValor(arrDT[0],arrDT[1])
			}

		} 
	}
//Revision de parametros permanentes no duplicados
//	for (x=0;x<=Parametros.length;x++) {
//		if (ParamPermanente[x] = 1) {
//			var Txt = String(Valores[x])
//			if (Txt.indexOf(",") > 0) {
//				var Arreglo = Txt.split(",")
//				Valores[x] = Arreglo[1]
//			}
//  	  	}	
//	}	

 //UbicaBaseDeDatos(Parametro("iqCli_ID",-1))
}

function LeerParametrosdeBusquedaBD() {
var sSesion = Session.SessionID	
var sParametro = ""
 
//	var Condicion = " Nav_Sesion = '" + sSesion + "' AND Nav_Vigente = 1 "
//	//var Condicion = " Usu_ID = " + IDUsu + " AND Nav_Vigente = 1 AND Sys_ID = " + SistemaActual
//
//	sParametro = BuscaSoloUnDato("top 1 Nav_ParametrosBusqueda","Navegacion",Condicion,"",2) 
	
	var Condicion  = " Nav_Sesion = '" + sSesion + "' " 
		Condicion += " AND Sys_ID = " + SistemaActual
		Condicion += " AND Mnu_ID = " + VentanaIndex
		Condicion += " AND Usu_ID  = " + IDUsuario
		Condicion += " and Tpo_Usr = " + UsuarioTpo
	
	sParametro = BuscaSoloUnDato("top 1 Nav_Parametros","NavegacionParametros",Condicion,"",2)
  
	return (sParametro)
}


function EscribeParametrosdeBusquedaBD(sSQlBusqueda) {
var sSesion = Session.SessionID	
var sSQL = ""
var sTemp = ""

	if(EsVacio(UsuarioTpo)) {
		UsuarioTpo = -1
	}
		
 	sTemp = Remplaza(sSQlBusqueda)

	sSQL = "Delete from NavegacionParametros "
	sSQL += " where Usu_ID = " + IDUsuario
	sSQL += " and Tpo_Usr = " + UsuarioTpo
	sSQL += " and Sys_ID = " + SistemaActual
	
	Ejecuta(sSQL,2)	
	
	sSQL = "Delete from NavegacionParametros "
	sSQL += " where Nav_Sesion =  '" + sSesion + "'"
	
	Ejecuta(sSQL,2)		

	sSQL = "INSERT INTO NavegacionParametros ( Sys_ID, Mnu_ID, Usu_ID, Tpo_Usr, "
	sSQL += " Nav_Sesion, Nav_Parametros, Nav_Vigente ) "
	sSQL += " VALUES (" + SistemaActual + ", " + VentanaIndex + ", " + IDUsuario + ", " + UsuarioTpo
	sSQL += ", '" + sSesion + "', '" + sTemp  + "',1 )"
	
	Ejecuta(sSQL,2)	

	
	//if (!EsVacio(sSQlBusqueda)) {
		sTemp = Remplaza(sSQlBusqueda)
		sSQL = "UPDATE Navegacion SET "
		sSQL += " Nav_ParametrosBusqueda = '" + sTemp  + "'"
		sSQL += " WHERE Nav_Sesion = '" + sSesion + "' "
		sSQL += " AND Nav_Vigente = 1 "
	
		Ejecuta(sSQL,2)
	//}
	
	return (sSQL)
}


// 3) 
function ArrBuscaValorEnParametro(NombreParametro,ValorABuscar,Tipo) {
//Busca un valor en un parametro que entro como arreglo
// tipo es para : b=booleano chk= para que ponga checked
	var Resultado 
	if (Tipo == "b") { Resultado = false } else {Resultado = "" }
	if (bHayParametros) {	
		var Dato = Parametro(NombreParametro,"")
		for(i=0;i<Dato.length;i++) {
			if (Dato[i] == ValorABuscar) {
				if (Tipo == "b") { Resultado = true } else {Resultado = "checked" }
				return (Resultado)
			}
		}
	}
	return (Resultado)
}




// 4) 
function ArrBuscaValor(NombreArreglo,ValorABuscar,Tipo) {
// tipo = b=boleano / cualquier cosa regresa lo puesto en tipo
//Busca un valor en un arreglo
	var Resultado 
	if (Tipo == "b") { Resultado = false } else { Resultado = "" }
	for (i=0;i<NombreArreglo.length;i++) {
		if (NombreArreglo[i] == ValorABuscar) {
			arID = i
			if (Tipo == "b") { 
				Resultado = true 
			} else { 
				if (Tipo == "v") {
					Resultado = NombreArreglo[i]
				} else {
					Resultado = Tipo 
				}
			}
			return (Resultado)
		}	  
 	}
return (Resultado)
}

// 5) 
function DameParametro(Nombre,ValorInicial) {
// Obtiene el valor de los objetos del formulario uno por uno
  var sDato = ""
  if(!EsVacio(String(Request.Form(Nombre)))){  
  	sDato = String(Request.Form(Nombre))
  } else {
	sDato = ValorInicial
  }	
	return (sDato)
}


function QuitaDobleEspacio(sConsultaSQL) {
var sQDESQL = String(sConsultaSQL)
var sQDETmp = ""
var as = 0
	//Response.Write("<br>Antes de procesar: " + sQDESQL.length)
	if(sQDESQL.indexOf("  ") >= 0) {
		while(sQDESQL.indexOf("  ") >= 0 && as < 500) {
			sQDETmp = sQDESQL.substring(0, sQDESQL.indexOf("  "))
			sQDESQL = sQDETmp + sQDESQL.substring(sQDESQL.indexOf("  ") + 1, sQDESQL.length)
			as++
		}
	}
	//Response.Write("<br>as: " + as)
	//Response.Write("<br>sQDESQL: " + sQDESQL)
	//Response.Write("<br>Despues de procesar: " + sQDESQL.length)
	return sQDESQL
}


// 9) 
function AntiCache() {
	Response.Write("<meta http-equiv='pragma' content='no-cache'>")
	Response.Write("<meta http-equiv='expires' content='0'>")
	Response.Write("<meta http-equiv='cache-control' content='no-cache'>")
}

// 10) 
function AbreTabla(sConsultaSQL,Tipo,Conexion) {

 	try {	
	

//       var conn = Server.CreateObject("ADODB.Connection")
//	   conn.connectionString =  arsODBC[Conexion]
//	   conn.ConnectionTimeout = 180
//       conn.Open()
//	   var rs = Server.CreateObject("ADODB.Recordset")
//	   rs.ActiveConnection =  conn 
//	   rs.CursorType = Tipo
//	   rs.Source = sConsultaSQL
//
//	   if(bDebug && NivelDebug == 3 ){
//	       AgregaDebug("AbreTabla ",sConsultaSQL)
//	   }
//	   rs.Open()

	
// originalmente solo estaba asi
		var rs = Server.CreateObject("ADODB.Recordset")
		rs.ActiveConnection =  arsODBC[Conexion] 
		rs.CursorType = Tipo
		rs.Source = sConsultaSQL
			//Response.Write(arsODBC[Conexion])
			if(bDebug && NivelDebug == 3 ){
				AgregaDebug("AbreTabla ",sConsultaSQL)
			}
		rs.Open()
		
		return rs
		
	} 
	
	catch(err) {
		  bOcurrioError = true 
		AgregaDebug("Error en AbreTabla","===============================================================")
		AgregaDebug("Parametro de entrada ",sConsultaSQL)
		AgregaDebug("Error description ",err.description)
		AgregaDebug("Error number ",err.number)
		AgregaDebug("Error message ",err.message)		  
		AgregaDebug("Fin Error en AbreTabla","===============================================================")
		
//		var sMensajeError = "Error al intentar abrir un recordset"
//		var sSQLe =  "INSERT INTO [Log] (Log_Procedimiento ,Log_Observacion ,Log_ErrorNumber  "
//			sSQLe += ",Log_ErrorProcedure ,Log_ErrorLine ,Log_ErrorMessage ,Log_Parametros ,Usu_ID) "
//			sSQLe += " VALUES ('AbreTabla','" + sMensajeError + "' "
//			sSQLe += ", " +  err.number
//			sSQLe += ",'Funcion Abretabla iqon.asp', '559'"
//			sSQLe += ", '" + err.description + ": " + err.message + "' " 
//			sSQLe += ", '" + sConsultaSQL "' , " + IDUsuario + ")"
//			
//		Ejecuta(sSQLe,0)	
		  
		Response.Write("<br>Error en AbreTabla ===============================================================")
		Response.Write("<br>Parametro de entrada " + sConsultaSQL)
		Response.Write("<br>Error description " + err.description)
		Response.Write("<br>Error number " + err.number)
		Response.Write("<br>Error message " + err.message)
		//Response.Write("<br>Conexion " + Conexion)		
		//Response.Write("<br>arsODBC[] " + arsODBC[Conexion])		


		Debug_ImprimeParametros("Abretabla")
		 Response.Write("<br>Fin Error en AbreTabla ===============================================================<br><br>")	
		 Response.Write("<br>Nota: cualquier error a partir de este punto es generado por el error indicado por lo que es posible que sea un error de consecuencia a esta<br><br>")	
		// Response.End()  
   }
}

//10a
function AbreStoredProcedure(sConsultaSQL,Tipo,Conexion) {
	var rsPABDD = Server.CreateObject("ADODB.Recordset")
		rsPABDD.ActiveConnection = arsODBC[Conexion] 
		rsPABDD.Source = sConsultaSQL
		rsPABDD.CursorType = Tipo
		rsPABDD.CursorLocation = 2
		rsPABDD.LockType = 1
//		if (bDebug) {
//			Response.Write("<br>Debug: " + sConsultaSQL)
//		}
		rsPABDD.Open()
		return (rsPABDD)
	
}



// 11) 
function LlenaCombo(sConsultaSQL,Seleccionado,LLConexion){
	 var sOpcion =""
	 var LLC = AbreTabla(sConsultaSQL,1,LLConexion)
	 while (!LLC.EOF){
	 sOpcion = "<option value='"+ LLC.Fields.Item(0).Value + "'"
	  if (Seleccionado == LLC.Fields.Item(0).Value) {
	 sOpcion += " selected "
	 }
	 sOpcion += ">" + LLC.Fields.Item(1).Value + "</option>"
	 Response.Write(sOpcion)
     LLC.MoveNext()}
	 LLC.Close()
}

// 11a) 
// 12) 

function Ejecuta(sEConsultaSQL,Conexion) {	
var sTempEDRP = ""
var sESQLTmp = ""
var bError = false

 	try {	
		if(!EsVacio(sEConsultaSQL)) {
		var sConsultaSQL = String(sEConsultaSQL)
			sConsultaSQL = QuitaDobleEspacio(sConsultaSQL)
			sConsultaSQL = DSITrim(sConsultaSQL)
			
		if(bDebug && NivelDebug == 2 ){
			AgregaDebug("Ejecutando correcto ",sConsultaSQL)
		}

		var rsGuardaAC = Server.CreateObject("ADODB.Command")
			rsGuardaAC.ActiveConnection =  arsODBC[Conexion] 
			
		//Response.Write("<br>SQL: " + sConsultaSQL)

		//Response.Write("<br><br>Connection: " + arsODBC[Conexion] ) 
	   // Response.Write("<br><br>id c: " + Conexion ) 
	
			rsGuardaAC.CommandText = sConsultaSQL
			rsGuardaAC.Execute()
			rsGuardaAC.ActiveConnection.Close()
		//Response.Write("<br>ejecuto ")	
			
		 } 
	} catch(err) {
		bError = true
			AgregaDebug("Error en Ejecuta",    "===============================================================")
			AgregaDebug("Parametro de entrada",sConsultaSQL)
			AgregaDebug("Error description ",err.description)
			AgregaDebug("Error number ",err.number)
			AgregaDebug("Error message ",err.message)		  
			AgregaDebug("Fin Error en Ejecuta","===============================================================")
   }
   
    try {
		if (bError) {
			sSQL = "INSERT INTO DEBUG (Dbg_Accion, Dbg_Concepto, Sys_ID, Mnu_ID, IDUsuario ) "
			sSQL += " values ('" + sConsultaSQL + "','Error al ejecutar'," + SistemaActual 
			sSQL += "," + VentanaIndex  + "," + IDUsuario + ")"
			
		var rsGuardaAC = Server.CreateObject("ADODB.Command")
			rsGuardaAC.ActiveConnection =  arsODBC[2]			
			rsGuardaAC.CommandText = sSQL
			rsGuardaAC.Execute()
			rsGuardaAC.ActiveConnection.Close()
		}
  	} catch(err) {
		AgregaDebug("Error del error en ejecuta description ",err.description)
   } 
   
   return !bError
}



// 13)
function SiguienteID(CampoLlave,Tabla,Condicion,Conexion) {
	var ConSig = ""
	ConSig = "SELECT MAX(" + CampoLlave + ") FROM " + Tabla
//	ConSig +=  " WHERE (" + CampoLlave + " >= " + SigIDLimiteInferior 
//	ConSig +=  " AND  " + CampoLlave + " <= " + SigIDLimiteSuperior + ") "
	
	var IDSiguiente = 1
	
	if (Condicion != "") { 
		ConSig += " WHERE " + Condicion
	}
	//Response.Write("<br>Debug: " + ConSig)
	var rsSigID = AbreTabla(ConSig,1,Conexion)
	var sdato = String(rsSigID.Fields(0))
	if (!EsVacio(sdato) ) { 
		IDSiguiente = parseInt(sdato) + 1 
	} 
	rsSigID.Close()
//	if (IDSiguiente < SigIDLimiteInferior) {
//		IDSiguiente = SigIDLimiteInferior + IDSiguiente
//	}
	
	return (IDSiguiente)
}

// 14) 
function BuscaEnArreglo(Arreglo,Valor){
  for(i=0;i<Arreglo.length;i++){ 
	if (Arreglo[i] == Valor) {
		return (i)
	}
  }
return (-1)	
}

// 15) 
function LimpiaValores(){
  for(i=0;i<Valores.length;i++){ 
	  Valores[i]     = ""
	  TipoCampo[i]   = ""
	  TamanoCampo[i] = ""
	  Permanente[i]  = ""
  }
}

// 16) 
function ParametroEsPermanente(NombreParametro,ValoraColocar) {
// Cambia el valor de la matriz de parametros dependiendo al nombre del parametro
	  for(j=0;j<Parametros.length;j++){ 
		if (Parametros[j] == NombreParametro) {
			Permanente[j] = String(ValoraColocar)
			return j
		}
	  }
// si estas aqui es porque no lo encontraste entonces lo creamos   25 Nov 2002 ROG
	  var iID = Parametros.length
	  Parametros[iID]   = NombreParametro
	  var valor = ""
	  if (!EsVacio(String(ValoraColocar))) {
		  valor = String(ValoraColocar)
	  }
	  Valores[iID]      = String(valor)
	  TipoCampo[iID]    = -1
	  TamanoCampo[iID]  = 0
	  Permanente[iID]   = 0
	  return iID
}


// 17)
function ParametroCambiaValor_UsandoPermanencia(NombreParametro,ValoraColocar) {
// Cambia el valor de la matriz de parametros dependiendo al nombre del parametro
	  for(j=0;j<Parametros.length;j++){ 
		if (Parametros[j] == NombreParametro) {
			if (Permanente[j] == 0) {
				Valores[j] = String(ValoraColocar)
			}
			return j
		}
	  }
// si estas aqui es porque no lo encontraste entonces lo creamos   25 Nov 2002 ROG
	  var iID = Parametros.length
	  Parametros[iID]   = NombreParametro
	  var valor = ""
	  if (!EsVacio(String(ValoraColocar))) {
		  valor = String(ValoraColocar)
	  }
	  Valores[iID]      = String(valor)
	  TipoCampo[iID]    = -1
	  TamanoCampo[iID]  = 0
	  Permanente[iID]   = 0
	  return iID
}



function ParametroCambiaValor(NombreParametro,ValoraColocar) {
// Cambia el valor de la matriz de parametros dependiendo al nombre del parametro

	  for(j=0;j<Parametros.length;j++){ 
		if (Parametros[j] == NombreParametro) {
			Valores[j] = String(ValoraColocar)
			PV[j] = PV[j] + 1
			return j
		}
	  }
	  
// si estas aqui es porque no lo encontraste entonces lo creamos   25 Nov 2002 ROG
	  var iID = Parametros.length
	  Parametros[iID]   = NombreParametro
//	  var valor = ""
//	  if (!EsVacio(String(ValoraColocar))) {
//		  valor = String(ValoraColocar)
//	  }
	  Valores[iID]      = String(ValoraColocar)
	  TipoCampo[iID]    = -1
	  TamanoCampo[iID]  = 0
	  Permanente[iID]   = 0
	  ParamPermanente[iID] = 0
	  PV[iID] = 1 
	  
	  return iID
}


function ParametroNuevosValor(NombreParametro,ValoraColocar) {
//Response.Write("<br>NombreParametro " + NombreParametro + " ,ValoraColocar " + ValoraColocar + "<br>---------------<br>")
// Cambia el valor de la matriz de parametros dependiendo al nombre del parametro
	  for(j=0;j<Parametros.length;j++){ 
		if (Parametros[j] == NombreParametro) {
			// si el parametro ya existe entonces lo dejamos porque es un parametro de entrada que hay que respetar
			if (Valores[j] == -1) { 
//				var vlPrm = String(ValoraColocar)
//				var arvlPrm = vlPrm.split(",")
//				
//				Valores[j] =  String(arvlPrm[0])
				Valores[j] = String(ValoraColocar)

			}
			
			PV[j] = PV[j] + 1
			return j
		}
	  }
// si estas aqui es porque no lo encontraste entonces lo creamos   25 Nov 2002 ROG
	  var iID = Parametros.length
	  Parametros[iID]   = NombreParametro

//			var vlPrm = String(ValoraColocar)
//				var arvlPrm = vlPrm.split(",")
				
	  //Valores[iID]      = String( arvlPrm[0] )
	  Valores[iID]      =  String(ValoraColocar)
	  TipoCampo[iID]    = -1
	  TamanoCampo[iID]  = 0	
	  Permanente[iID]   = 0  
	  ParamPermanente[iID] = 0
	  PV[iID] = 1
	  return iID
}


// 18) 
function ParametroCambiaTipo(NombreParametro,ValoraColocar,Tamano) {
//Response.Write("entramos a la chingadera accion 2")
//Response.Write(Parametros.length)
// Cambia el valor de la matriz de parametros dependiendo al nombre de elparametro
	  for(j=0;j<Parametros.length;j++){ 
	  //Response.Write("entramos a la chingadera accion 3")
		if (Parametros[j] == NombreParametro) {
			TipoCampo[j] = ValoraColocar
			TamanoCampo[j] = Tamano
			//Response.Write(ValoraColocar)
			return 
		}
	  }
	  return
}

// 19) 
// esta funcion es para las ventanas que se auto otorgan las llaves principales y para mantener el
// valor de la llave pricipal es necesario indicarla en la funcion de espermanente asi el valor se 
// conservara al dar la vuelta
function ParametroCargaDeSQL_TipoAutonomo(SQL,Conexion) {  
	var rspcdsql = AbreTabla(SQL,1,Conexion) 
	var rspRespuesta = true
	var SigP = 0
	
	for (i=0;i<rspcdsql.fields.count;i++) {
		if (!rspcdsql.EOF) { 
			if (bHayParametros) {
				ParametroNuevosValor(String(rspcdsql.Fields.Item(i).Name),String(rspcdsql.Fields.Item(i).Value))
			} else {
				ParametroCambiaValor(String(rspcdsql.Fields.Item(i).Name),String(rspcdsql.Fields.Item(i).Value))
			}
			ParametroCambiaTipo(String(rspcdsql.Fields.Item(i).Name),String(rspcdsql.Fields.Item(i).Type),String(rspcdsql.Fields.Item(i).DefinedSize))
		} else {
			if (bHayParametros) {
				ParametroNuevosValor(String(rspcdsql.Fields.Item(i).Name),"")
			} else {
				ParametroCambiaValor_UsandoPermanencia(String(rspcdsql.Fields.Item(i).Name),"")
			}
			ParametroCambiaTipo(String(rspcdsql.Fields.Item(i).Name),String(rspcdsql.Fields.Item(i).Type),String(rspcdsql.Fields.Item(i).DefinedSize))
//			SigP = Parametros.length
//			Parametros[SigP]  = String(rspcdsql.Fields.Item(i).Name)
//			Valores[SigP]     = ""
//			TipoCampo[SigP]   = String(rspcdsql.Fields.Item(i).Type)
//			TamanoCampo[SigP] = String(rspcdsql.Fields.Item(i).DefinedSize)
//			Permanente[iID]   = 0  
			rspRespuesta = false			
		}
	}
    rspcdsql.Close()
	bHayParametros = true
	return rspRespuesta	
}



function ParametroCargaDeSQL(SQL,Conexion) {   //25 Nov 2002 ROG
	var rspcdsql = AbreTabla(SQL,1,Conexion) 
	var rspRespuesta = true
	var SigP = 0

	for (i=0;i<rspcdsql.fields.count;i++) {
		if (!rspcdsql.EOF) { 
			if (bHayParametros) {
				ParametroNuevosValor(String(rspcdsql.Fields.Item(i).Name),String(rspcdsql.Fields.Item(i).Value))
			} else {
				ParametroCambiaValor(String(rspcdsql.Fields.Item(i).Name),String(rspcdsql.Fields.Item(i).Value))
			}
			ParametroCambiaTipo(String(rspcdsql.Fields.Item(i).Name),String(rspcdsql.Fields.Item(i).Type),String(rspcdsql.Fields.Item(i).DefinedSize))
		} else {
			SigP = Parametros.length
			Parametros[SigP]  = String(rspcdsql.Fields.Item(i).Name)
			Valores[SigP]     = ""
			TipoCampo[SigP]   = String(rspcdsql.Fields.Item(i).Type)
			TamanoCampo[SigP] = String(rspcdsql.Fields.Item(i).DefinedSize)
			Permanente[iID]   = 0  
			rspRespuesta = false			
		}
	}
    rspcdsql.Close()
	bHayParametros = true
	return rspRespuesta	
}


// 20) 
function ParametroCargaTipoDato(SQL,Conexion) {

	var rspcdsql = AbreTabla(SQL,1,Conexion) 
	for (i=0;i<rspcdsql.fields.count;i++) {
		ParametroCambiaTipo(String(rspcdsql.Fields.Item(i).Name),String(rspcdsql.Fields.Item(i).Type),String(rspcdsql.Fields.Item(i).DefinedSize))
	}		
    rspcdsql.Close()	
}

// 20a SQL2008)
function DameTipoDato(sIQTabla,sIQCampo,Conexion) {
	
	var sSQLTipoDato = " SELECT xtype FROM syscolumns "
		sSQLTipoDato += " WHERE ID IN "
		sSQLTipoDato += " (SELECT ID FROM sysobjects "
		sSQLTipoDato += " WHERE name = '" + sIQTabla + "')"
		sSQLTipoDato += " AND name = '" + sIQCampo +"'"

	var rsSQLTipoDato = AbreTabla(sSQLTipoDato,1,Conexion) 
		var iDatoTmp = -1
		
		if (!rsSQLTipoDato.EOF) {
			iDatoTmp = rsSQLTipoDato.Fields.Item(0).Value
		} 

		rsSQLTipoDato.Close()
		
		return iDatoTmp		
}


function TablaEnumeraCampos(SQL,Conexion) {
	Response.Write("<br>")
	var rspcdsql = AbreTabla(SQL,1,Conexion) 
	for (i=0;i<rspcdsql.fields.count;i++) {
		Response.Write(String("<br>" + rspcdsql.Fields.Item(i).Name) + " " + String(rspcdsql.Fields.Item(i).Type) + " " + String(rspcdsql.Fields.Item(i).DefinedSize))
	}		
    rspcdsql.Close()
	Response.Write("<br>")
}



// 21) 
function CargaCombo(NombreCombo,Eventos,CampoID,CampoDescripcion,Tabla,Condicion,Orden,Seleccionado,Conexion,Todos,Modo) {
	var sElemento =""
	if (Modo == "Consulta") {
		if (Seleccionado == -1) {
			sElemento = Todos
		} else {
			var sSQLCondicion = " " + CampoID + " = " + Seleccionado 
			if (Condicion != "") { sSQLCondicion += " and " + Condicion }
			sElemento = BuscaSoloUnDato(CampoDescripcion,Tabla,sSQLCondicion,"",Conexion)
		}
		Response.Write(sElemento)
	} else {
		Response.Write("<select name='"+NombreCombo+"' id='"+NombreCombo+"' "+ Eventos +" >")
			if (Todos != "") {
				sElemento = "<option value='-1'"
				if (Seleccionado == -1) { sElemento += " selected " }
				sElemento += ">"+Todos+"</option>"
				Response.Write(sElemento)
			}
		var CCSQL = "Select " + CampoID +", " + CampoDescripcion + " FROM " + Tabla
		if (Condicion != "") { CCSQL += " Where " + Condicion }
		if (Orden != "") { CCSQL += " Order By " + Orden }
		//Response.Write(CCSQL)
		var rsCC = AbreTabla(CCSQL,1,Conexion) 
		while (!rsCC.EOF){
			sElemento = "<option value='"+rsCC.Fields.Item(0).Value+"'"
			if (Seleccionado == rsCC.Fields.Item(0).Value) { sElemento += " selected " }
			sElemento += ">"+rsCC.Fields.Item(1).Value+"</option>"
			Response.Write(sElemento)
			rsCC.MoveNext()}
		rsCC.Close()
		Response.Write("</select>")
	
	}

}


// 23) 
function CargaCheckBox(NombreCheck,Eventos,CampoID,CampoRef,Tabla,Condicion,Conexion) {

var CCSQL = "Select " + CampoID + ", " + CampoRef + " FROM " + Tabla
if (Condicion != "") { CCSQL += " Where " + Condicion }

var rsCC = AbreTabla(CCSQL,1,Conexion) 
	if (!rsCC.EOF){
		Response.Write("<input type='checkbox' name='" + NombreCheck + "' onClick='" + Eventos + "' value='" + rsCC.Fields.Item(CampoRef).value + "')>")
	}
	else {
	Response.Write("")
	}
}
 
// 24) ConvierteAAreglo(Arreglo,Texto)
function ConvierteAAreglo(Arreglo,Texto) { 

var Txt = "" + Texto
var Txtemp = ""
	if (Txt.length > 0) {
		for (j=0;j<Txt.length;j++) {
			if (Txt.substring(j,j+1) == ",") {
				Arreglo[Arreglo.length] = Txtemp
				Txtemp = ""
			} else {
				Txtemp += Txt.substring(j,j+1)
			}
		}
		if (Txtemp.length > 0) {
			Arreglo[Arreglo.length] = Txtemp
		}
	}
	
//var Txt = String(Texto)
//Arreglo = Txt.split(",")
}

// 25) 
function ImprimeArreglo() { 
Response.Write("<br> Hay " + Parametros.length +" parametros")
	for (j=0;j<Parametros.length;j++) {
		Response.Write("<br> " + j +") Nombre del parametro ="+Parametros[j]+"  Valor ="+Valores[j]+"   Tipo = "+TipoCampo[j] +"   Tamaño = "+TamanoCampo[j])
	}
}

function ImprimeParametros() { 
	if (bPuedeVerDebug) {
		Response.Write("<table width='100%'  border='0' cellspacing='0' cellpadding='0'>")
		Response.Write("<tr class='TablaEncabezado'><td height='22' colspan='6' class='FichaTitulo'>Modo Debug: Valores de los parametros</td></tr>")
		Response.Write("<tr class='TablaEncabezado'><td width='10%'>No</td><td  width='15%'>Nombre</td><td >Valor</td>")
		Response.Write("<td >Tipo</td><td >Perm</td><td >Tama&ntilde;o Campo</td><td >Es Parametro Permanente</td><td >Veces Encontrado</td></tr>")
		
			iContador = 1;
			TipoRenglon = "evenRow";
			for (x=0;x<Parametros.length;x++) {
				if (TipoRenglon == "evenRow") {
					TipoRenglon = "oddRow";
				} else {
					TipoRenglon = "evenRow";
				} 
					Response.Write("<tr class=' GridTextoNormal " + TipoRenglon + "'>")
					Response.Write("<td >&nbsp;" + iContador + "</td>")
					Response.Write("<td >&nbsp;" + Parametros[x] + "</td>")
					Response.Write("<td >&nbsp;" + Valores[x] + "</td>")
					Response.Write("<td >&nbsp;" + TipoCampo[x] + "</td>")
					Response.Write("<td >&nbsp;" + Permanente[x] + "</td>")
					Response.Write("<td >&nbsp;" + TamanoCampo[x] + "</td>")
					Response.Write("<td >&nbsp;" + ParamPermanente[x] + "</td>")
					Response.Write("<td >&nbsp;" + PV[x] + "</td>")
					
					Response.Write("</tr>")
				iContador++;
			}
			Response.Write("</table><br><br>");
		}
}

function ImprimeVariablesControl() { 
	if (bPuedeVerDebug) {
		var ArrVControl = new Array()
		var ArrVControlVal = new Array()
		var iPos = 0
		ArrVControl[iPos] = "SistemaActual"
		ArrVControlVal[iPos] = Parametro("SistemaActual",-1)
		iPos++
		ArrVControl[iPos] = "VentanaIndex"
		ArrVControlVal[iPos] = Parametro("VentanaIndex",0)		
		iPos++
		ArrVControl[iPos] = "IDUsuario"
		ArrVControlVal[iPos] = IDUsuario  
		iPos++
		ArrVControl[iPos] = "iqCli_ID"
		ArrVControlVal[iPos] = Parametro("iqCli_ID",-1)
		iPos++
		ArrVControl[iPos] = "UsuarioTpo"
		ArrVControlVal[iPos] = UsuarioTpo
		iPos++
		ArrVControl[iPos] = "SegGrupo"
		ArrVControlVal[iPos] = SegGrupo		
		iPos++
		ArrVControl[iPos] = "Modo"
		ArrVControlVal[iPos] = Parametro("Modo","")
		iPos++
		ArrVControl[iPos] = "Accion"
		ArrVControlVal[iPos] = Parametro("Accion","")
		iPos++
		ArrVControl[iPos] = "PadreIndex"
		ArrVControlVal[iPos] = Parametro("PadreIndex",-1)
		iPos++
		ArrVControl[iPos] = "VentanaIndexAnterior"
		ArrVControlVal[iPos] = Parametro("VentanaIndexAnterior",-1)
		iPos++
		ArrVControl[iPos] = "TabIndex"
		ArrVControlVal[iPos] = TabIndex
		iPos++
		ArrVControl[iPos] = "sSesion"
		ArrVControlVal[iPos] = sSesionID
		iPos++
		ArrVControl[iPos] = "sArchivoPlantilla"
		ArrVControlVal[iPos] = sArchivoPlantilla
		iPos++
		ArrVControl[iPos] = "sSiguienteVentana"
		ArrVControlVal[iPos] = sSiguienteVentana
		iPos++
		ArrVControl[iPos] = "sUsuarioSes"
		ArrVControlVal[iPos] = sUsuarioSes
		iPos++
		ArrVControl[iPos] = "sTituloVentana1"
		ArrVControlVal[iPos] = sTituloVentana1
		iPos++
		ArrVControl[iPos] = "sTituloVentana2"
		ArrVControlVal[iPos] = sTituloVentana2
		iPos++
		ArrVControl[iPos] = "sTituloExplorador"
		ArrVControlVal[iPos] = sTituloExplorador

		Response.Write("<br><br><table width='100%'  border='0' cellspacing='0' cellpadding='0'>")
		Response.Write("<tr class='TablaEncabezado'><td height='22' colspan='3' class='dbgFichaTitulo'>Modo Debug: valores de control</td></tr>")
		Response.Write("<tr class='TablaEncabezado'><td  width='10%'>No</td>")
		Response.Write("<td  width='30%'>Nombre de la variable</td><td   width='60%'>Valor</td>")
		
		iContador = 1;
		TipoRenglon = "evenRow";
		for (x=0;x<ArrVControl.length;x++) {
			if (TipoRenglon == "evenRow") {
				TipoRenglon = "oddRow";
			} else {
				TipoRenglon = "evenRow";
			} 
				Response.Write("<tr   class='TablaEncabezado " + TipoRenglon + "'>")
				Response.Write("<td  >&nbsp;" + iContador + "</td>")
				Response.Write("<td  >&nbsp;" + ArrVControl[x] + "</td>")
				Response.Write("<td  >&nbsp;" + ArrVControlVal[x] + "</td>")
				Response.Write("</tr>")
			iContador++;
		}
		Response.Write("</table><br><br>");
	}
}

function DespliegaAlPie() {
	//if (bPuedeVerDebug) {
	//	if (Parametro("SistemaActual",-1) >0) {
	//		if ( bDebug == true && bOcurrioError == true ){
				ImprimeVariablesControl()
				ImprimeDebug() 
				ImprimeParametros()
				ImprimeDebugBD()
	//		} else if (bForzarMostrarDebug) {
//				ImprimeDebug() 
//				ImprimeParametros()
//				ImprimeVariablesControl()
//				ImprimeDebugBD()
//			}
//		}
//	}
}

function ImprimeDebug() { 
	if (bPuedeVerDebug) {
		Response.Write("<br><table width='100%'  border='0' cellspacing='0' cellpadding='0'>")
		Response.Write("<tr class='TablaEncabezado'><td height='22' colspan='3' class='dbgFichaTitulo'>Modo Debug: valores de consulta</td></tr>")
		Response.Write("<tr class='TablaEncabezado'><td width='10%'>No</td>")
		Response.Write("<td width='30%'>Paso</td><td width='60%'>Valor</td>")
		
		iContador = 1;
		TipoRenglon = "evenRow";
		for (x=0;x<DebugPaso.length;x++) {
			if (TipoRenglon == "evenRow") {
				TipoRenglon = "oddRow";
			} else {
				TipoRenglon = "evenRow";
			} 
				Response.Write("<tr class='TablaEncabezado " + TipoRenglon + "'>")
				Response.Write("<td >&nbsp;" + iContador + "</td>")
				Response.Write("<td >&nbsp;" + DebugPaso[x] + "</td>")
				Response.Write("<td >&nbsp;" + DebugValor[x] + "</td>")
				Response.Write("</tr>")
			iContador++;
		}
		Response.Write("</table><br><br>");
	}
}

function ImprimeDebugBD() { 
	if (bPuedeVerDebug) {
		Response.Write("<br><table width='100%'  border='0' cellspacing='0' cellpadding='0'>")
		Response.Write("<tr class='TablaEncabezado'><td height='22' colspan='3' class='dbgFichaTitulo'>Modo Debug: valores de consulta</td></tr>")
		Response.Write("<tr class='TablaEncabezado'><td width='10%'>No</td>")
		Response.Write("<td width='30%'>Paso</td><td width='60%'>Valor</td>")
		
		iContador = 1;
		TipoRenglon = "evenRow";
		var sSQLdbg = "SELECT * from Debug "
			sSQLdbg +=  " WHERE Sys_ID = " + SistemaActual
			sSQLdbg +=  " AND Mnu_ID = " + VentanaIndex
			sSQLdbg +=  " AND IDUsuario = " + IDUsuario
		
		var rsdbg = AbreTabla(sSQLdbg,1,2) 
		while (!rsdbg.EOF){		
			if (TipoRenglon == "evenRow") {
				TipoRenglon = "oddRow";
			} else {
				TipoRenglon = "evenRow";
			} 
				Response.Write("<tr class='TablaEncabezado " + TipoRenglon + "'>")
				Response.Write("<td >&nbsp;" + iContador + "</td>")
				Response.Write("<td >&nbsp;" + rsdbg.Fields.Item("Dbg_Concepto").Value + "</td>")
				Response.Write("<td >&nbsp;" + rsdbg.Fields.Item("Dbg_Accion").Value + "</td>")
				Response.Write("</tr>")
			iContador++;
			
			rsdbg.MoveNext()
		}
		rsdbg.Close()
		
		Response.Write("</table><br><br>");
	
	}
}



function AgregaDebug(sIdentificador,sValor) {
	if (bPuedeVerDebug) {
		var iPos = DebugPaso.length 
		
			DebugPaso[iPos] = sIdentificador
			DebugValor[iPos] = sValor
			
	}
}

function IniciaDebugBD() {
	if (bDebugWidgets) {               
		var sSQL = "Delete from Debug "
			sSQL += " where Dbg_FechaHora <= DATEADD(day,-1,getdate()) "
		
		Ejecuta(sSQL,2)
	}	
}


function AgregaDebugBD(sIdentificador,sValor) {
	//if (bDebugWidgets) {
            
		var sSQL = "Insert into Debug ( Sys_ID, Mnu_ID, IDUsuario, Dbg_Concepto, Dbg_Accion, Dbg_IP) "
			sSQL += " Values (" + SistemaActual + "," + VentanaIndex + "," + IDUsuario
			sSQL += " ,'" + QuitaComillas(sIdentificador) + "','" + QuitaComillas(sValor)  + "'"
			sSQL += " ,'" + String(Request.ServerVariables("REMOTE_HOST")) + "') "
		
		Ejecuta(sSQL,2)
	//}	
}

// 30) BDInsert(Campos,Tabla,Condicion,Conexion,IndiceInicial,ValidaInserta,sCampoID,sCondExtra)
function BDInsert(Campos,Tabla,Condicion,Conexion,IndiceInicial,ValidaInserta,sCampoID,sCondExtra) {
var sBDSQL = ""
//var sBDSQL1 = ""
var sBDSQLValores = ""
var bdPos =0
var tA = ""
var tB = ""
var sTemp =""
var ValorReemplazo = ""
var arCamposBD = new Array(0)
arCamposBD = (Campos)
var sSQLTD = "Select * from " + Tabla
//var Servidor1 = "svrsterling.lojack.dbo."
var sBICampoID = IFAnidado(EsVacio(sCampoID),"",sCampoID)
var sCondicionExtra = IFAnidado(EsVacio(sCondExtra),"",sCondExtra)
var iTipoCampo = -1

	//Carga el tipo de datos de la tabla   Mzo/12/02 JD
	ParametroCargaTipoDato(sSQLTD,Conexion)

	sBDSQL = "INSERT INTO " + Tabla + " ( " + Campos + " )  Values ("
	//sBDSQL1 = "INSERT INTO "+ Servidor1 + Tabla+" ( "+Campos+" )  Values ("
	sBDSQLValores = ""
var bInserta = true
//
//-----------------------------	DRP 28/07/2003
var bInserta = true
//	if(!EsVacio(ValidaInserta)) {
//		if(ValidaInserta) {
//		//Response.Write("Insertamos...&nbsp;<br>")
//			bInserta = ValidaInsercion(Valores, arCamposBD, Tabla, IndiceInicial, Conexion, sBICampoID, sCondicionExtra)
//		}
//	}
	if(bInserta) {
//-----------------------------
		for (k=0;k<arCamposBD.length;k++) {
			
			bdPos = parseInt(BuscaEnArreglo(Parametros,arCamposBD[k]))

			iTipoCampo = DameTipoDato(Tabla,arCamposBD[k],Conexion)			

			tA="0"
			tB = ""
			ValorReemplazo = ""

			//Cadenas
			//char10-175, varchar-167, text-35, nchar-239, nvarchar-231, ntext-99, varchar-167, varcharMAX-167       
			if (parseInt(iTipoCampo) == 175 || parseInt(iTipoCampo) == 167 || parseInt(iTipoCampo) == 35 || parseInt(iTipoCampo) == 231 || parseInt(iTipoCampo) == 99 || parseInt(iTipoCampo) == 167) {

				tA = String("'") 
				tB = String("'")
				ValorReemplazo = ""

				if (bParametrosDeAjaxaUTF8) {
					Valores[bdPos] = ParametrosDeAjaxaUTF8(Valores[bdPos])
				}
				
			}
			

			//Cadenas
			//bigint-127, bit-104, decimal-106, int-56, money-60, numeric-108, smallint-52, smallmoney-122, tinyint-48, float-62, real-59
			if (parseInt(iTipoCampo) == 127 || parseInt(iTipoCampo) == 104 || parseInt(iTipoCampo) == 106 || parseInt(iTipoCampo) == 56 || parseInt(iTipoCampo) == 60 || parseInt(iTipoCampo) == 108 || parseInt(iTipoCampo) == 52 || parseInt(iTipoCampo) == 122 || parseInt(iTipoCampo) == 48 || parseInt(iTipoCampo) == 62 || parseInt(iTipoCampo) == 59) {
				tA = String("") 
				tB = String("")

				ValorReemplazo = "0"

				if (Valores[bdPos] == "") {
					Valores[bdPos] = 'NULL'
					tA = "" 
					tB = ""
				}
				
				if (bParametrosDeAjaxaUTF8) {
					Valores[bdPos] = ParametrosDeAjaxaUTF8(Valores[bdPos])
				}
			}
			
			//FechasyHoras
			//date-40, datetime2-42, datetime-61, datetimeoffset-43, smalldatetime-58, time-41
			if (parseInt(iTipoCampo) == 40 || parseInt(iTipoCampo) == 42 || parseInt(iTipoCampo) == 61 || parseInt(iTipoCampo) == 43 || parseInt(iTipoCampo) == 58 || parseInt(iTipoCampo) == 41){

				//ValorReemplazo = "NULL"
				ValorReemplazo = null

				tA = "" 
				tB = ""
				
				if(EsVacio(Valores[bdPos])) {
					
					//Response.Write("EsVacio<br />")
					Valores[bdPos] = null
					
				} else {
				
					//Response.Write("!= EsVacio<br />")
					
					tA = "'" 
					tB = "'"
					
					Valores[bdPos] = CambiaFormatoFecha(Valores[bdPos],"dd/mm/yyyy",FORMATOFECHASERVIDOR)

				}
				//Response.Write("Valores[bdPos]&nbsp;"+ Valores[bdPos])
				
					
			}
			
			//Cadenas binarias
			//binary50-173, image-34, varbinary-165, varbinaryMAX-165 
			
			//OtrosTiposDeDatos
			//hierarchyid-240, sql_variant-98, timestamp-189, uniqueidentifier-36, xml-241, geography-240, geometry-240


			if ( sBDSQLValores != "" ) { sBDSQLValores += ", " }
			sBDSQLValores += tA  
			if (bdPos == -1 ) {
				sBDSQLValores += ValorReemplazo 
			} else {
				sTemp = String(Valores[bdPos])
				sBDSQLValores += sTemp
			}
			 sBDSQLValores += tB
		}
		
		sBDSQL += sBDSQLValores + ")"
		//Response.Write("<br />"+sBDSQL)
		//Response.End()
		AgregaDebugBD("Insertando",sBDSQL)
		Ejecuta(sBDSQL,Conexion)
		//AudInsertar(Tabla, sBDSQL, "", "Registro Nuevo",1)

		return sBDSQL
	}
}


// 29) ValidaInsercion(VIValores, VIarCamposBD, sTabla, iIndiceInicial, iConexion, sCampoID, sCondExtra)
function ValidaInsercion(VIValores, VIarCamposBD, sTabla, iIndiceInicial, iConexion, sCampoID, sCondExtra) {
var iVI = 0
var sCadenaSQL = ""
var bdPosVI = 0
var ValorReemplazo = ""
var sTemp = ""
var tA = ""
var tB = ""

	if(iIndiceInicial < 0) {
		iIndiceInicial = 0
	}
	for (iVI = iIndiceInicial; iVI < VIarCamposBD.length; iVI++) {
	  var sPteSync = VIarCamposBD[iVI]
	  	  sPteSync = sPteSync.toUpperCase()
	  if (sPteSync != "SYNC") {
			bdPosVI = parseInt(BuscaEnArreglo(Parametros,VIarCamposBD[iVI]))
			tA = "0"
			tB = ""
			ValorReemplazo = ""            
			if (parseInt(TipoCampo[bdPosVI]) == 202 || parseInt(TipoCampo[bdPosVI]) == 203 || parseInt(TipoCampo[bdPosVI]) == 200 || parseInt(TipoCampo[bdPosVI]) == 201){
				tA = "'" 
				tB = "'"
				ValorReemplazo = ""
				if (bParametrosDeAjaxaUTF8) {
					Valores[bdPos] = ParametrosDeAjaxaUTF8(Valores[bdPos])
				}
			}
			if (parseInt(TipoCampo[bdPosVI]) == 135 ){
				tA = "#" 
				tB = "#"
				ValorReemplazo = "01/01/2002"
			}
			if ( sCadenaSQL != "" ) { sCadenaSQL += " AND " }
			sCadenaSQL += VIarCamposBD[iVI] + " = "
			sCadenaSQL += tA
			if (bdPosVI == -1 ) {
				sCadenaSQL += ValorReemplazo 
			} else {
				sTemp = String(VIValores[bdPosVI])
				sTemp = Remplaza(sTemp)
				sCadenaSQL += sTemp
			}
			sCadenaSQL += tB
	   }
	}
	
	if(!EsVacio(sCondExtra)) {
		sCadenaSQL += " AND " + sCondExtra
	}
	
	if(EsVacio(sCampoID)) {
	var VIBusca = BuscaSoloUnDato("COUNT(*)",sTabla,sCadenaSQL,0,iConexion)
	
		if( VIBusca > 0 ) {
			bValidacionINSERT = false
		}
	} else {
		sCadenaSQL += " ORDER BY " + sCampoID + " DESC"
		vLlaveDuplicada = BuscaSoloUnDato("TOP 1 " + sCampoID,sTabla,sCadenaSQL,"",iConexion)
	
		if(!EsVacio(vLlaveDuplicada)) {
			bValidacionINSERT = false
		}
	}
	
	if(bDebug && NivelDebug == 2 ){ 
		AgregaDebug("ValidaInsercion sCadenaSQL:",sCadenaSQL)
		AgregaDebug("ValidaInsercion INSERT: " , bValidacionINSERT)
	}
	return bValidacionINSERT
}


// 31) BDUpdate(Campos,Tabla,Condicion,Conexion)
function BDUpdate(Campos,Tabla,Condicion,Conexion) {
var sBDSQL = ""
var sBDSQLValores = ""
var bdPos =0
var tA = ""
var tB = ""
var sTemp =""
var ValorReemplazo = ""
var arCamposBD = new Array(0)
arCamposBD = (Campos)
var sSQLTDE = "Select * from " + Tabla

	//Carga el tipo de datos de la tabla  Mzo/12/02 JD
	ParametroCargaTipoDato(sSQLTDE,Conexion)
	
	sBDSQL = "Update "+Tabla+" Set "
	sBDSQLValores = ""
	for (k=0;k<arCamposBD.length;k++) {
		if ( sBDSQLValores != "" ) { sBDSQLValores += ", " }
		sBDSQLValores += " " + arCamposBD[k]+ " = "
		bdPos = parseInt(BuscaEnArreglo(Parametros,arCamposBD[k]))
		
		iTipoCampo = DameTipoDato(Tabla,arCamposBD[k],Conexion)
		
		//Response.Write("numero ="+k+" Parametro ="+arCamposBD[k]+"  Posicion = "+bdPos+ " Tipo de campo = " +  TipoCampo[bdPos] + "<br>")
		tA="0"
		tB = ""
		ValorReemplazo = ""  
		     
		//Cadenas
		//char10-175, varchar-167, text-35, nchar-239, nvarchar-231, ntext-99, varchar-167, varcharMAX-167       
		if (parseInt(iTipoCampo) == 175 || parseInt(iTipoCampo) == 167 || parseInt(iTipoCampo) == 35 || parseInt(iTipoCampo) == 231 || parseInt(iTipoCampo) == 99 || parseInt(iTipoCampo) == 167) {

			tA = String("'") 
			tB = String("'")
			ValorReemplazo = ""
			if (bParametrosDeAjaxaUTF8) {
				Valores[bdPos] = ParametrosDeAjaxaUTF8(Valores[bdPos])
			}
			
		}

		//Numericos
		//bigint-127, bit-104, decimal-106, int-56, money-60, numeric-108, smallint-52, smallmoney-122, tinyint-48, float-62, real-59
		if (parseInt(iTipoCampo) == 127 || parseInt(iTipoCampo) == 104 || parseInt(iTipoCampo) == 106 || parseInt(iTipoCampo) == 56 || parseInt(iTipoCampo) == 60 || parseInt(iTipoCampo) == 108 || parseInt(iTipoCampo) == 52 || parseInt(iTipoCampo) == 122 || parseInt(iTipoCampo) == 48 || parseInt(iTipoCampo) == 62 || parseInt(iTipoCampo) == 59) {
			tA = String("") 
			tB = String("")

			ValorReemplazo = "0"
			
			if (Valores[bdPos] == "") {
				Valores[bdPos] = 'NULL'
				tA = "" 
				tB = ""
			}
			
			if (bParametrosDeAjaxaUTF8) {
				Valores[bdPos] = ParametrosDeAjaxaUTF8(Valores[bdPos])
			}
		}

			//FechasyHoras
			//date-40, datetime2-42, datetime-61, datetimeoffset-43, smalldatetime-58, time-41
			if (parseInt(iTipoCampo) == 40 || parseInt(iTipoCampo) == 42 || parseInt(iTipoCampo) == 61 || parseInt(iTipoCampo) == 43 || parseInt(iTipoCampo) == 58 || parseInt(iTipoCampo) == 41){


				ValorReemplazo = null

				tA = "" 
				tB = ""
				
				if(EsVacio(Valores[bdPos])) {
					
					//Response.Write("EsVacio<br />")
					Valores[bdPos] = null
					
				} else {
				
					//Response.Write("!= EsVacio<br />")
					
					tA = "'" 
					tB = "'"
					
					Valores[bdPos] = CambiaFormatoFecha(Valores[bdPos],"dd/mm/yyyy",FORMATOFECHASERVIDOR)

				}
				//Response.Write("Valores[bdPos]&nbsp;"+ Valores[bdPos])
				/*
				tA = "'" 
				tB = "'"
				//ValorReemplazo = "NULL"
				ValorReemplazo = ""
				if (Valores[bdPos] != "") {
					Valores[bdPos] = CambiaFormatoFecha(Valores[bdPos],"dd/mm/yyyy",FORMATOFECHASERVIDOR)
				} else {
					//Valores[bdPos] = 'NULL'
					Valores[bdPos] = ''
					tA = "" 
					tB = ""
				}		
				*/

			}
			
			//Cadenas binarias
			//binary50-173, image-34, varbinary-165, varbinaryMAX-165 
			
			//OtrosTiposDeDatos
			//hierarchyid-240, sql_variant-98, timestamp-189, uniqueidentifier-36, xml-241, geography-240, geometry-240

		
		sBDSQLValores += tA
		if (bdPos == -1 ) {
			sBDSQLValores += ValorReemplazo 
		} else {
			//sBDSQLValores += Valores[bdPos]
			sTemp = String(Valores[bdPos])
			sTemp = Remplaza(sTemp)
			sBDSQLValores += sTemp
		}
		sBDSQLValores += tB
	}
	sBDSQL += sBDSQLValores + " " + Condicion
	sBDSQL = sBDSQL.replace(/'NULL'/g, "NULL");
	//AudInsertar(Tabla, sBDSQL, Condicion, "Registro editado", 2)
	//AgregaDebug("Update ",sBDSQL)	
	//Response.Write("<br><br><br>" + sBDSQL)
	AgregaDebugBD("iqon Update",sBDSQL)
	Ejecuta(sBDSQL,Conexion)

	return sBDSQL
}

// 32) 
function BDDelete(Campos,Tabla,Condicion,Conexion) {
var sBDSQL = ""
	sBDSQL = "Delete from " + Tabla + " " + Condicion
	//Response.Write(sBDSQL)
	//AudInsertar(Tabla, sBDSQL, Condicion, "Registro borrado", 3)
	AgregaDebugBD("Delete",sBDSQL)		
	Ejecuta(sBDSQL,Conexion)
	
}


// 34) EsVacio(Dato)
function EsVacio(Dato) {
var sTemp = String(Dato)
   if (sTemp != "" && sTemp != "null" && sTemp != "undefined"  && sTemp != null ) {
	return false
   } else {
	return true
   }
}


// 42) FiltraVacios(Dato)
function FiltraVacios(Dato) {
var sTemp = String(Dato)
   if (sTemp == "" || sTemp == "null"  || sTemp == "NULL" || sTemp == "undefined" || sTemp == null ) {
	return "" 
   } else {
	return Dato
   }
}

// 43) ConvierteACadena(Arreglo,Indice)
function ConvierteACadena(Arreglo,Indice,sTipoCar) {
	var sK = ""
	if (!EsVacio(sTipoCar)) {
		sK = sTipoCar
	}
	var Txtemp = ""
	for (j=0; j<Arreglo.length; j++) {
		if (j != Indice ){
			if (Txtemp != "") {
				Txtemp += sK + "," + sK
			}
			Txtemp += Arreglo[j]
		}
	}
	if (!EsVacio(Txtemp)) {
		Txtemp = sK + Txtemp + sK
	}
	return(Txtemp)
}

function InicializaSesion(idUsr,iTpoUsr) {    
// ROG 27 Feb 2011 por usuario
// ROG 5 mzo por sesion con un timeout de 2 horas

	var sSesion = Session.SessionID	
	
	if(EsVacio(iTpoUsr)) {
		iTpoUsr = -1
	}
	
	SesionBorrar(idUsr,iTpoUsr)
	
	var sSQL = "Insert into Navegacion ( Nav_IP, Nav_Sesion, Usu_ID, Tpo_Usr, Sys_ID, Nav_Vigente ) "
		sSQL += " values ('" + Request.ServerVariables("REMOTE_HOST") + "'"
		sSQL += ",'" + sSesion + "'," + idUsr + ","  + iTpoUsr + ","
		sSQL += SistemaActual
		sSQL += ",1 )"

	Ejecuta(sSQL,2)

	var sSQL = "Update SystLogin Set SystLog_Sesion = '" + sSesion + "' "
		sSQL += " Where sys2 = " + idUsr
		sSQL += " and SysLogCat_ID = " + iTpoUsr
		sSQL += " and Sys_ID = " + SistemaActual

	Ejecuta(sSQL,2)

}


function LimpiaSesion() {
	
var sSesion = Session.SessionID		

	var sSQL = "Update Navegacion Set "
		sSQL += " Nav_Vigente = 0 "
		sSQL += ",Nav_Parametros = '' "
		sSQL += " where Nav_Sesion = '" + sSesion + "'"
		
	Ejecuta(sSQL,2)

	var sSQL = "Update NavegacionParametros Set "
		sSQL += "Nav_Parametros = '' "
		sSQL += " where Nav_Sesion = '" + sSesion + "'"
		
	Ejecuta(sSQL,2)	
	
	sSQL = "Update SystLogin Set SystLog_Sesion = '' "
	sSQL += " Where SystLog_Sesion =  '" + sSesion + "'"
	
	Ejecuta(sSQL,2)		
	
	IDUsuario = -1
	ParametroCambiaValor("IDUsuario",-1)
	Session("IDUsuario") = -1
	UsuarioTpo = -1
	ParametroCambiaValor("UsuarioTpo",-1)
	Session("UsuarioTpo") = -1
	SegGrupo = -1
	ParametroCambiaValor("SegGrupo",-1)
	Session("SegGrupo") = -1
	
}

function SesionBorrar(idUsr,iTpoUsr) {  

var sSesion = Session.SessionID	

	if(EsVacio(iTpoUsr)) {
		iTpoUsr = -1
	}

	var sSQL = "Update Navegacion Set "
		sSQL += " Nav_Vigente = 0 "
		sSQL += ",Nav_Parametros = '' "
		sSQL += " where Nav_Sesion = '" + sSesion + "'"	
		
	Ejecuta(sSQL,2)

	var sSQL = "Update NavegacionParametros Set "
		sSQL += "Nav_Parametros = '' "
		sSQL += " where Nav_Sesion = '" + sSesion + "'"
		
	Ejecuta(sSQL,2)		
		

	
	if(EsVacio(iTpoUsr)) {
		iTpoUsr = -1
	}
			
	if (!EsVacio(idUsr)) {		
		sSQL = "Update Navegacion Set "
		sSQL += " Nav_Vigente = 0 "
		sSQL += ",Nav_Parametros = '' "
		sSQL += " where Usu_ID = " + idUsr
		sSQL += " and Tpo_Usr = " + iTpoUsr
		sSQL += " and Sys_ID = " + SistemaActual
		
		Ejecuta(sSQL,2)	
		
	var sSQL = "Update NavegacionParametros Set "
		sSQL += "Nav_Parametros = '' "
		sSQL += " where Usu_ID = " + idUsr
		sSQL += " and Tpo_Usr = " + iTpoUsr
		sSQL += " and Sys_ID = " + SistemaActual		
		
	
		sSQL = "Update SystLogin Set SystLog_Sesion = '' "
		sSQL += " Where sys2 = " + idUsr
		sSQL += " and SysLogCat_ID = " + iTpoUsr
		sSQL += " and Sys_ID = " + SistemaActual
	
		Ejecuta(sSQL,2)		
	}	
				
	sSQL = "Update SystLogin Set SystLog_Sesion = '' "
	sSQL += " Where SystLog_Sesion =  '" + sSesion + "'"
	
	Ejecuta(sSQL,2)	 
	
}



// 49) DSITrim(sCadena)
function DSITrim(sCadena) {

	var i = 0
	if ( !EsVacio(sCadena)) {
		for ( i = 0; i < sCadena.length; i++) {
			if (sCadena.charAt(i) != " ") {
				sCadena = sCadena.substring(i, sCadena.length)
				i = sCadena.length
			}
		}
		for ( i = sCadena.length-1; i >= 0; i--) {
			if (sCadena.charAt(i) != " ") {
				sCadena = sCadena.substring(0, i+1)				
				i = 0
			}
		}
	}
	return sCadena
}

// 54) BuscaSoloUnDato(Campo,Tabla,Condicion,ValorDefault,Conexion)
function BuscaSoloUnDato(Campo,Tabla,Condicion,ValorDefault,Conexion) {
	var Resultado = ValorDefault
 	try {	
			var sSQL = " SELECT " + Campo + " FROM " + Tabla
			if (Condicion != "") {
				sSQL += " WHERE " + Condicion
			}
			//Response.Write("<br> BuscaSoloUnDato " + sSQL)  
			//AgregaDebugBD("BuscaSoloUnDato",sSQL)
			var rsRapidito = AbreTabla(sSQL,1,Conexion)
			if (!rsRapidito.EOF) {
				Resultado = rsRapidito.Fields.Item(0).Value
			}
			rsRapidito.Close()
	} 
	catch(err) {
		  bOcurrioError = true 
		AgregaDebug("Error en BuscaSoloUnDato","===============================================================")
		AgregaDebug("Parametro de entrada ",sSQL)
		AgregaDebug("Error description ",err.description)
		AgregaDebug("Error number ",err.number)
		AgregaDebug("Error message ",err.message)		  
		AgregaDebug("Fin Error en BuscaSoloUnDato","===============================================================")
		
//		var sMensajeError = "Error al intentar abrir un recordset"
//		var sSQLe =  "INSERT INTO [Log] (Log_Procedimiento ,Log_Observacion ,Log_ErrorNumber  "
//			sSQLe += ",Log_ErrorProcedure ,Log_ErrorLine ,Log_ErrorMessage ,Log_Parametros ,Usu_ID) "
//			sSQLe += " VALUES ('BuscaSoloUnDato','" + sMensajeError + "' "
//			sSQLe += ", " +  err.number
//			sSQLe += ",'Funcion BuscaSoloUnDato iqon.asp', '2008'"
//			sSQLe += ", '" + err.description + ": " + err.message + "' " 
//			sSQLe += ", '" + sSQL "' , " + IDUsuario + ")"
//			
//		Ejecuta(sSQLe,0)	
		  
		Response.Write("<br>Error en BuscaSoloUnDato ===============================================================")
		Response.Write("<br>Parametro de entrada " + sSQL)
		Response.Write("<br>Error description " + err.description)
		Response.Write("<br>Error number " + err.number)
		Response.Write("<br>Error message " + err.message)
		Debug_ImprimeParametros("BuscaSoloUnDato")
		 Response.Write("<br>Fin Error en BuscaSoloUnDato ===============================================================<br><br>")	
		 Response.Write("<br>Nota: cualquier error a partir de este punto es generado por el error indicado por lo que es posible que sea un error de consecuencia a esta<br><br>")	
		// Response.End()  
   }		
			
	return Resultado
}

// 39) BuscaSeg(sValor,sSeg){
// Busca en una matriz de seguridad un numero 
function BuscaSeg(sValor,sSeg) {
var Regresa = false
var ArregloSeg = new Array()
ConvierteAAreglo(ArregloSeg,String(sSeg))
	for(i=0;i<ArregloSeg.length;i++){
		if (parseInt(ArregloSeg[i]) == parseInt(sValor)) {
			Regresa = true
			break
		}
	}
	return Regresa
}



function SeguridadExtendida(iIdSeg,iIdUsr,iGrupoID,iSysID,iMnuID,iqCliID) {

	Session("EXConsulta")  = 0
	Session("EXEditar")  = 0
	Session("EXAgregar") = 0
	Session("EXBorrar")  = 0 

//	 if (iIdUsr == 1 ) {
//			Session("Editar")  = 1
//			Session("Agregar") = 1
//			Session("Borrar")  = 1	
//	 } else {	
			var sSQL = " Select * from dbo.ufn_Permisos_DamePermisosExtendidos"
				sSQL  += "(" + iIdUsr
				sSQL  += "," + iMnuID
				sSQL  += "," + iSysID
				sSQL  += "," + iGrupoID
				sSQL  += "," + iqCliID
				sSQL  += "," + iIdSeg
				sSQL  += ")"
//Response.Write(sSQL)
		var rsSeg = AbreTabla(sSQL,1,2)
		if (!rsSeg.EOF) {
			Session("EXConsulta")  = rsSeg.Fields.Item("Acceso").Value
			Session("EXEditar")  = rsSeg.Fields.Item("Editar").Value
			Session("EXAgregar") = rsSeg.Fields.Item("Agregar").Value
			Session("EXBorrar")  = rsSeg.Fields.Item("Borrar").Value		
		}
//	}
}

// 40)

function Seguridad(iIdSeg,iIdUsr,iGrupoID,iSysID) {

	Session("Editar")  = 0
	Session("Agregar") = 0
	Session("Borrar")  = 0	

//	 if (iIdUsr == 1 ) {
//			Session("Editar")  = 1
//			Session("Agregar") = 1
//			Session("Borrar")  = 1	
//	 } else {	
			var sSQL = " Select * from dbo.ufn_DamePermisosUsuario"
				sSQL  += "(" + iIdUsr
				sSQL  += "," + iIdSeg
				sSQL  += "," + iSysID
				sSQL  += "," + iGrupoID
				sSQL  += "," + iqCli_ID
				sSQL  += ")"
//Response.Write(sSQL)
		var rsSeg = AbreTabla(sSQL,1,2)
		if (!rsSeg.EOF) {
				Session("Editar")  = rsSeg.Fields.Item("Editar").Value
				Session("Agregar") = rsSeg.Fields.Item("Agregar").Value
				Session("Borrar")  = rsSeg.Fields.Item("Borrar").Value		
		}
//	}
}


function ComboSeccion(NombreCombo,Eventos,Seccion,Seleccionado,Conexion,Todos,Orden,Modo) {
var sElemento =""

if (Modo == "Editar") {
	Response.Write("<select name='" + NombreCombo + "' id='" + NombreCombo + "' " + Eventos + " >")
		if (Todos != "") {
			sElemento = "<option value='-1'"
			if (Seleccionado == -1) { sElemento += " selected " }
			sElemento += ">" + Todos + "</option>"
			Response.Write(sElemento)
		}
	var CCSQL = "SELECT Cat_ID, Cat_Nombre FROM Cat_Catalogo WHERE Sec_ID = " + Seccion + " ORDER BY "
		if(Orden == "") {
			CCSQL += " Cat_Nombre" 
		} else {
			CCSQL += Orden
		}

	//sResponse.Write(CCSQL) 
	var rsCC = AbreTabla(CCSQL,1,Conexion) 
		while (!rsCC.EOF){
			sElemento = "<option value='" + rsCC.Fields.Item(0).Value + "'"
			if (Seleccionado == rsCC.Fields.Item(0).Value) { sElemento += " selected " }
			sElemento += ">" + rsCC.Fields.Item(1).Value+"</option>"
			Response.Write(sElemento)
			rsCC.MoveNext()
		}
		rsCC.Close()
		Response.Write("</select>")
} else {
	var sCondicion = "  Sec_ID = " + Seccion + " and Cat_ID = " + Seleccionado
	sElemento = BuscaSoloUnDato("Cat_Nombre","Cat_Catalogo",sCondicion,"",Conexion)
	Response.Write(sElemento)
}
}

// 60) IFAnidado(sCondicion,sVerdadero,sFalso)
function IFAnidado(sCondicion,sVerdadero,sFalso) {
var sValuacion = ""
	if(!EsVacio(sCondicion)) {
		if(sCondicion) {
			sValuacion = sVerdadero
		} else {
			sValuacion = sFalso
		}
	}
	return sValuacion
}

function FechaConFormato(La_fecha,formato) {

	var fecha = new Date(La_fecha);
	var sResultado = ""
	
	fecha.format(formato);
	sResultado = String(fecha);
	return sResultado;


//Name               Mask                        Example
//default            ddd mmm d yyyy HH:MM:ss     Sat Jun 9 2007 17:46:21
//shortDate          m/d/yy                      6/9/07
//mediumDate         mmm d, yyyy	Jun 9, 2007
//longDate           mmmm d, yyyy	June 9, 2007
//fullDate           dddd, mmmm d, yyyy	Saturday, June 9, 2007
//shortTime          h:MM TT	5:46 PM
//mediumTime         h:MM:ss TT	5:46:21 PM
//longTime           h:MM:ss TT Z	5:46:21 PM EST
//isoDate            yyyy-mm-dd	2007-06-09
//isoTime            HH:MM:ss	17:46:21
//isoDateTime        yyyy-mm-dd'T'HH:MM:ss	2007-06-09T17:46:21
//isoFullDateTime    yyyy-mm-dd'T'HH:MM:ss.lo	2007-06-09T17:46:21.431-0500


}
/*
function DameRuta() {
	//Response.Write(" <br> vienes de " + Request.ServerVariables("HTTP_REFERER"))
	//Response.Write(" <br> Host " + Request.ServerVariables("HTTP_HOST"))
	var sVieneDe = String(Request.ServerVariables("HTTP_REFERER"))
	var sHost = String(Request.ServerVariables("HTTP_HOST"))
	
	var iInicio = sVieneDe.indexOf(sHost) 
	var iFin = sVieneDe.indexOf("?")
	if (iFin < 1) iFin = sVieneDe.length
	iInicio += sHost.length
	var Ruta =  sVieneDe.substring(iInicio,iFin)
	//Response.Write(" <br> Ruta limpia es " + Ruta)
	return Ruta
}
*/

//CambiaFormatoFecha(sFecha,"dd/mm/yyyy","yyyy-mm-dd")
function CambiaFormatoFecha(sFecha,sFormatoEntra,sFormatoSale) {
var Respuesta = ""			

	if (sFormatoEntra == "dd/mm/yyyy") {
			var sF = String(sFecha)
			sDia = sF.substring(0,sF.indexOf("/"))
			var paso = sF.substring(sF.indexOf("/")+1,10)
			sMes = paso.substring(0,paso.indexOf("/"))
			sAno = paso.substring(paso.indexOf("/")+1, 10)
	}

	if (sFormatoEntra == "dd-mm-yyyy") {
			var sF = String(sFecha)
			sDia = sF.substring(0,sF.indexOf("-"))
			var paso = sF.substring(sF.indexOf("-")+1,10)
			sMes = paso.substring(0,paso.indexOf("-"))
			sAno = paso.substring(paso.indexOf("-")+1, 10)
	}
	
	if (sFormatoEntra == "yyyy-mm-dd") {
			var sF = String(sFecha)
			sAno = sF.substring(0,sF.indexOf("-"))
			var paso = sF.substring(sF.indexOf("-")+1,10)
			sMes = paso.substring(0,paso.indexOf("-"))
			sDia = paso.substring(paso.indexOf("-")+1, 10)
	}
	
	if (sFormatoSale == "yyyy-mm-dd") {
		Respuesta = sAno + "-" + sMes + "-" + sDia
	}	
	
	if (sFormatoSale == "yyyy-dd-mm") {
		Respuesta = sAno + "-" + sDia + "-" + sMes
	}	
	
	if (sFormatoSale == "dd-mm-yyyy") {
		Respuesta =  sDia + "-" + sMes + "-" + sAno
	}	
	
	if (sFormatoSale == "dd/mm/yyyy") {
		Respuesta =  sDia + "/" + sMes + "/" + sAno
	}		
	
	return Respuesta 
}

function FormatoFecha(sFecha,sFormato) {

//Response.Write("sFecha&nbsp;" + sFecha + "&nbsp;sFormato&nbsp;" + sFormato + "<br />")
//Tipo de campo Date -- 2011-05-13

//var sAnio = sFecha.substring(0,4)
//var sMes = sFecha.substring(6,7)
//var sDia = sFecha.substring(9,10)
//
//Response.Write("sDia&nbsp;" + sDia + "<br />")
//Response.Write("sMes&nbsp;" + sMes + "<br />")
//Response.Write("sAnio&nbsp;" + sAnio + "<br />")

var Respuesta = ""
var iTmp = 0
//String(sFecha)
if (!EsVacio(sFecha)) {

	//Response.Write("sFecha&nbsp;" + sFecha + "<br />")
	if (!isNaN(sFecha)) {
		//Response.Write("cuando no es NAN fecha&nbsp;" + fecha + "<br />")	
		switch (String(sFormato)) {
				case "yyyy-mm-dd":
					var fecha = new Date(sFecha)
					Respuesta = fecha.getFullYear() + "-" 
					iTmp = (fecha.getMonth()+1 )  
					if (iTmp < 10) { Respuesta += "0" }
					Respuesta += iTmp
					Respuesta += "-" 
					iTmp = fecha.getDate()
					if (iTmp < 10) { Respuesta += "0" }
					Respuesta += iTmp
					break;
				case "dd/mm/yyyy":
				    var fecha = new Date(sFecha)
				    iTmp = fecha.getDate()
					if (iTmp < 10) { Respuesta += "0" }
					Respuesta += iTmp
					Respuesta += "/" 
					iTmp = (fecha.getMonth()+1 ) 
					if (iTmp < 10) { Respuesta += "0" }
					Respuesta += iTmp
					Respuesta += "/" + fecha.getFullYear()
					break;
				case "UTC a dd/mm/yyyy":
					var fecha = new Date(sFecha)
					fecha.toUTCString()
					iTmp = fecha.getDate()
					if (iTmp < 10) { Respuesta += "0" }
					Respuesta += iTmp 
					Respuesta += "/" 
					iTmp = (fecha.getMonth()+1 ) 
					if (iTmp < 10) { Respuesta += "0" }
					Respuesta += iTmp
					Respuesta += "/" + fecha.getFullYear()
					break;				
		}
	} 
		
}
	return Respuesta
}


function FormatoFechaII(sFecha,sFormato,sAccion) {

	//Response.Write("sFecha&nbsp;" + sFecha + "&nbsp;sFormato&nbsp;" + sFormato + "&nbsp;sAccion&nbsp;" + sAccion + "<br />")
	//Manejo en la pantalla dd/mm/aaaa
	//Tipo de campo Date -- aaaa-mm-dd
	var sDia = ""
	var sMes = ""
	var sAnio = ""		

	var Respuesta = ""

	//Formato a devolver 

	if (!EsVacio(sFecha)) {	

		switch (String(sFormato)) {
		
		    //tipo date
			case "aaaa-mm-dd":

				if (sAccion == "Consulta") {
					sDia = sFecha.substring(8,10)
					sMes = sFecha.substring(5,7)
					sAnio = sFecha.substring(0,4)

					//Response.Write("sDia&nbsp;" + sDia + "<br />")
					//Response.Write("sMes&nbsp;" + sMes + "<br />")
					//Response.Write("sAnio&nbsp;" + sAnio + "<br />")
				} else {	
					sDia = sFecha.substring(0,2)
					sMes = sFecha.substring(4,5)
					sAnio = sFecha.substring(7,10)
				}
				Respuesta = sDia + "/" + sMes + "/" + sAnio
				break;
				
			case "dd/mm/yyyy":
				if (sAccion == "Consulta") {
					sDia = sFecha.substring(0,2)
					sMes = sFecha.substring(4,5)
					sAnio = sFecha.substring(7,10)
				} else {
					sDia = sFecha.substring(8,10)
					sMes = sFecha.substring(5,7)
					sAnio = sFecha.substring(0,4)
				}
				Respuesta = sDia + "/" + sMes + "/" + sAnio
				break;
				
			//Tipo de dato DateTime
			case "yyyy-mm-dd":
				sDia = sFecha.substring(8,10)
				sMes = sFecha.substring(5,7)
				sAnio = sFecha.substring(0,4)
//					Response.Write("sDia&nbsp;" + sDia + "<br />")
//					Response.Write("sMes&nbsp;" + sMes + "<br />")
//					Response.Write("sAnio&nbsp;" + sAnio + "<br />")
				Respuesta = sDia + "/" + sMes + "/" + sAnio
				break;

			case "UTC":    // ejemplo de fecha 2012-10-29 18:33:00
				if (sAccion == "Consulta") {
				    Respuesta = String(sFecha)
					var arrFecha = Respuesta.split(" ")
					var sFe = arrFecha[0];
					var arrFe = sFe.split("-")
					if (EsVacio(arrFe[2])){
					    Respuesta = ""
					} else {
						Respuesta = arrFe[2] + "/" + arrFe[1] + "/" +  arrFe[0] + " " + arrFecha[1]
					}
//					var nvaFecha = new Date(sFecha);
//					var nvaFecha = futc.toUTCString();
//					iTmp = nvaFecha.getDate()
//					if (iTmp < 10) { Respuesta += "0" }
//					Respuesta += iTmp 
//					 "/" 
//					iTmp = (nvaFecha.getMonth()+1 ) 
//					if (iTmp < 10) { Respuesta += "0" }
//					Respuesta += iTmp
//					Respuesta += "/" + nvaFecha.getFullYear() 
					//Respuesta = futc.toString()
				} else {
					var nvaFecha = new Date(sFecha);
	//					var nvaFecha = futc.toUTCString();
					iTmp = nvaFecha.getDate()
					if (iTmp < 10) { Respuesta += "0" }
					Respuesta += iTmp 
					Respuesta += "/" 
					iTmp = (nvaFecha.getMonth()+1 ) 
					if (iTmp < 10) { Respuesta += "0" }
					Respuesta += iTmp
					Respuesta += "/" + nvaFecha.getFullYear() 
					//Respuesta = futc.toString()
				}
				break;
				
			case "UTC s/fecha":    // ejemplo de fecha 2012-10-29 18:33:00
				if (sAccion == "Consulta") {
				    Respuesta = String(sFecha)
					var arrFecha = Respuesta.split(" ")
					var sFe = arrFecha[0];
					var arrFe = sFe.split("-")
					if (EsVacio(arrFe[2])){
					    Respuesta = ""
					} else {
						Respuesta = arrFe[2] + "/" + arrFe[1] + "/" +  arrFe[0]
					}
				} else {
                    Respuesta = String(sFecha)
				}
				break;
				
			case "CST a fecha":    // ejemplo de fecha: Wed Feb 29 00:00:00 CST 2012

				    Respuesta = String(sFecha)
					
					if(!EsVacio(sFecha)) {   
					
						var arrFe = Respuesta.split(" ")
						
						if ( arrFe[1] == "Jan") {  arrFe[1] = "01" }
						if ( arrFe[1] == "Feb") {  arrFe[1] = "02" }
						if ( arrFe[1] == "Mar") {  arrFe[1] = "03" }
						if ( arrFe[1] == "Apr") {  arrFe[1] = "04" }
						if ( arrFe[1] == "May") {  arrFe[1] = "05" }
						if ( arrFe[1] == "Jun") {  arrFe[1] = "06" }
						if ( arrFe[1] == "Jul") {  arrFe[1] = "07" }
						if ( arrFe[1] == "Aug") {  arrFe[1] = "08" }
						if ( arrFe[1] == "Sep") {  arrFe[1] = "09" }
						if ( arrFe[1] == "Oct") {  arrFe[1] = "10" }
						if ( arrFe[1] == "Nov") {  arrFe[1] = "11" }
						if ( arrFe[1] == "Dec") {  arrFe[1] = "12" }
						
						Respuesta = arrFe[2] + "/" + arrFe[1] + "/" +  arrFe[5]
						//Response.Write("Respuesta-I&nbsp;" + Respuesta + "<br />")
						
						if (Respuesta == "// ") {
						  Respuesta = ""  
						}
						if (Respuesta == "NaN/NaN/NaN") {
						  Respuesta = ""
						}	
						if (Respuesta == "undefined/undefined/0 undefined") {
						  Respuesta = ""
						}
							
						if (Respuesta == " undefined/undefined/undefined") {
						  Respuesta = ""
						}	
						
						if (Respuesta == "undefined/undefined/undefined") {
						  Respuesta = ""
						}	
						
						if (Respuesta == "NULL" || Respuesta == "null"  || Respuesta == "NULL" || Respuesta == "undefined" || Respuesta == null ) {
						  Respuesta = ""
						}	
					} else {
					
						Respuesta = ""
						
					}

				break;				
				
		}			
	
	} else {
		Respuesta = ""
	}
	
		if (Respuesta == "// ") {
		  Respuesta = ""  
		}
		if (Respuesta == "NaN/NaN/NaN") {
		  Respuesta = ""
		}	
		if (Respuesta == "undefined/undefined/0 undefined") {
		  Respuesta = ""
		}
			
		if (Respuesta == " undefined/undefined/undefined") {
		  Respuesta = ""
		}	
		
		if (Respuesta == "undefined/undefined/undefined") {
		  Respuesta = ""
		}	
		
		if (Respuesta == "NULL" || Respuesta == "null"  || Respuesta == "NULL" || Respuesta == "undefined" || Respuesta == null ) {
		  Respuesta = ""
		}	
		
		//Response.Write("Respuesta-II&nbsp;" + Respuesta + "<br />")
		return Respuesta
	
}

// 35)  formato(str, dec)
function formato(str, dec) {
var Resultado = 0

	Resultado = formato_numero(str, dec)
	
	//var dato = 0
//	var Resultado = 0
//	if (!isNaN(str)) {
//		dato = parseFloat(str)
//		if(isNaN(dato)) {
//			dato = 0
//		}
//		Resultado =  dato.toLocaleString()
//	} else { 
//		Resultado = str
//	}
//	if ( Resultado == "Infinity") {
//		Resultado = str
//	}
	return Resultado
}

//formato_numero(numero, decimales, separador_decimal, separador_mile
function formato_numero(numero,dec){ 

	var decimales = dec
	var separador_decimal = "."
	var separador_miles = ","
	
    numero=parseFloat(numero);
    if(isNaN(numero)){
        return "";
    }

    if(decimales!==undefined){
        // Redondeamos
        numero=numero.toFixed(decimales)
    }

    // Convertimos el punto en separador_decimal
    numero=numero.toString().replace(".", separador_decimal!==undefined ? separador_decimal : ",");

    if(separador_miles){
        // Añadimos los separadores de miles
        var miles=new RegExp("(-?[0-9]+)([0-9]{3})");
        while(miles.test(numero)) {
            numero=numero.replace(miles, "$1" + separador_miles + "$2");
        }
    }

    return numero;
}


function CajaSeleccion(NombreCaja,EventosClases,ValorParametro,Valor,Modo) {

	if (Modo == "Editar" ) {
		Response.Write("<input name='" + NombreCaja + "' type='checkbox' " + EventosClases)
		Response.Write(" id='" + NombreCaja + "' value='" + Valor + "' ")
		if (ValorParametro == Valor ) {
			Response.Write(" checked ")
		}
		Response.Write(" >")
	}
	if (Modo != "Editar" ) {
		if (ValorParametro == Valor ) {
			Response.Write("<img src='/Img/Bien.png' width='16' height='16' />")
		} else {
			Response.Write("<img src='/Img/Mal.png' width='16' height='16' />")
		}
	}
	
} 

function PonerFormatoNumerico(num,prefix){
	prefix = prefix || "";
	num += "";
	var splitStr = num.split(".");
	var splitLeft = splitStr[0];
	if (splitStr.length == 1) {
		splitStr[1] = "00";
	} else {
		var sTmp = String(splitStr[1])
		if (sTmp.length == 1 ) {
			splitStr[1] = sTmp +"0";
		}
	}
	
	var splitRight = splitStr.length > 1 ? "." + splitStr[1] : "";
	
	var regx = /(\d+)(\d{3})/;
	while (regx.test(splitLeft)) {
		splitLeft = splitLeft.replace(regx, "$1" + "," + "$2");
	}
	return prefix + splitLeft + splitRight;
}

function DesAplicaFormatoNumerico(num) {
	
	var sTMP = String(num)
	
	sTMP = sTMP.replace(/([^0-9\.\-])/g,"")*1;
	if(EsVacio(sTMP)) { sTMP = 0 }

	return sTMP
	
}

function ParametrosDeAjaxaUTF8(sValor) {

	var sTmp = String(sValor)
/*
		sTmp= sTmp.replace(/&#225;/g, "á");
		sTmp= sTmp.replace(/&#233;/g, "é");
		sTmp= sTmp.replace(/&#237;/g, "í");
		sTmp= sTmp.replace(/&#243;/g, "ó");
		sTmp= sTmp.replace(/&#250;/g, "ú");
		sTmp= sTmp.replace(/&#241;/g, "ñ");
*/
  return String(sTmp)

}

// ************************ Inicio de IQON *********************************************************

var arsODBC = new Array(0)
arsODBC[0] = ""
arsODBC[1] = ""
arsODBC[2] = sSQLCONStr02
arsODBC[3] = sSQLCONStr03
arsODBC[4] = sSQLCONStr04
/*
Response.Write("arsODBC[2]&nbsp;"+arsODBC[2]+"<br />")
Response.Write("arsODBC[3]&nbsp;"+arsODBC[3]+"<br />")
Response.Write("arsODBC[4]&nbsp;"+arsODBC[4]+"<br />")
 */
if (EsVacio(arsODBC[0]))  arsODBC[0] = arsODBC[2]
var FORMATOFECHASERVIDOR = "yyyy-mm-dd"
//var FORMATOFECHASERVIDOR = "yyyy-dd-mm"

var FM = "$" 
var PC = "%" //arv
var TituloVentana = ""
var bDebug = true //jd
var bDebugWidgets = true 
var NivelDebug = 2  // 1 solo errores  //2 sentencias sql  // 3 abretabla es debugeado
var bForzarMostrarDebug = true // jd
var bOcurrioError = true 
var bMenuDePermisos = false //prende o apaga el menu de permisos de la primera pagina
var bDebugResponse = true//(true o false)para poner o quitar todos los response.writes que se usaron de prueba
var Debug_Imprime = 1 // imprime en varios puntos la lista de los parametros que estan en la memoria
var Parametros = new Array(0)
var Valores = new Array(0)
var TipoCampo = new Array(0)
var TamanoCampo = new Array(0)
var Permanente = new Array(0)          //mantiene el valor permanentemente
var ParamPermanente = new Array(0)     //Carga el parametro permanentemente
var PV = new Array(0)                  //mide las veces que ocurre
var sParametrosSerializados = ""

var DebugPaso = new Array(0)
var DebugValor = new Array(0)
var bGBLPuedoDebugear = false
var bPuedeVerDebug = false 
var arrDEBUGIP = new Array(0) 
var IPHost = Request.ServerVariables("REMOTE_ADDR")
var bHayParametros = false
var iID = 0
var arID = -1
var MenuPrincipal = false
var VentanaIndex = -1
var TabIndex = -1
var iWgCfgID = -1
var iWgID = -1
var ValidaSesion = -1
var sCodigoExtraParaElJQuery = ""
var arSeg = new Array(0)
var sSeg = ""
var sTag = ""
var bValidacionINSERT = true
var vLlaveDuplicada = ""
// variabes de Seguridad
var sBuscaSeguridad = ""
var sSeg = ""
var SegPermisos =  ""    
var iGrupoSes = -1
var sTipoUsuarioSes = -1
var sUsuarioSes = ""
	
var SegIP_ModoAprendizaje = true  

//Variables para los tabs y grids

var sTabsArmados = ""
var sTituloVentana1 = ""
var sTituloVentana2 = ""
var sTituloExplorador = ""
var sLigaSalida = RutaExtra + "/Default.asp";
var sPanzaConsulta = ""
var sPanzaEdicion = ""
var sHabilitaAyuda = ""
var sTipoVentana = 0
var sLigaArchivoACargar = ""
var sSiguienteVentana = 0
var iTabSeleccionado = 0
var LigaDefault  = ""
var sTabsArmados = ""
var sDivsTabs    = ""
var sTabsEnElJQuery = ""
var sCodigoDeLosTabs = ""
var sFuncionCase = ""
var CampoLlave = ""
var FuncionesParaElGrid = ""
var OcultosParaElGrid = ""
var sVariablesOcultas = ""
var sParametrosPermanentes = ""
var iIniciaSinParametros = 0
var sPaginacion = ""
var grdCampoLlave = ""
var sC = String.fromCharCode(34)
var sArchivoPlantilla = ""
var iTagActual = 1
var bParametrosDeAjaxaUTF8 = false
var bLeeParametrosCampoBusqueda = false
var sClienteActivo = "No hay cliente activo" 
var SistemaActual = -1
var VentanaIndex = -1

Server.ScriptTimeOut = 1800
Session.TimeOut = 120
Response.AddHeader("pragma", "no-cache")
Response.CacheControl = "Private"
//Response.Expires = 0
Response.Charset="ISO-8859-1"
Response.ContentType="text/html;  charset=iso-8859-1"
//Session.Codepage=65001
//Response.Charset="UTF-8"
//Response.ContentType="text/html;charset=utf-8"

//Response.AddHeader("Content-Type", "text/xml; charset=utf-8")

var sSesionID = String(Session.SessionID)

//Inicializacion basica de los arreglos para captura de parametros POST y GET

	CargaParametros()

//var sRQ = Request.QueryString()
//	CargaParametrosDesdeArreglo(String(sRQ))
//var sRF = Request.Form()
//Response.Write("<br>$RQ " + sRQ)
//Response.Write("<br>$RF " + sRF)

//cargo las variables que vengan vivas para el uso continuo de la aplicacion
var IDUsuario = Parametro("IDUsuario",-1)
var UsuarioTpo = Parametro("UsuarioTpo",1)   //1 = Usuario publico  2 = Administrativo  3 = ventas 4 = Proveedor 5 = Cliente
var SegGrupo = Parametro("SegGrupo",-1)
var iqCli_ID = Parametro("iqCli_ID",-1)
var sUsuarioSes = Parametro("sUsuarioSes","")
SistemaActual = Parametro("SistemaActual",-1)
VentanaIndex = Parametro("VentanaIndex",-1)

//Response.Write("<br> SistemaActual = " + SistemaActual )
//Response.Write("<br> bHayParametros = " + bHayParametros )

if (!bHayParametros) {
	//si no hay parametros de ningun tipo y estamso aqui es porque acaba de entrar
	//en algunos sitios almacena de forma de cookie los parametros que causa que tengan datos erroneos 
	//como el caso del svr de gerardo   ( esto me tomo 15 dias encontrarlo )
	ParametroCambiaValor("SistemaActual",-1)
	ParametroCambiaValor("iqCli_ID",-1)
	ParametroCambiaValor("VentanaIndex",-1)
	SistemaActual = -1
	iqCli_ID = -1
	VentanaIndex = -1
}

//var sqlUSR = "Insert into UsuarioBitacora ( UsuB_Sesion, Mnu_ID, Sys_ID, Usu_ID ) " 
//	sqlUSR += " Values ('" + String(Session.SessionID) + "', " + VentanaIndex + ", " + SistemaActual + ", " +  IDUsuario
//	sqlUSR += " )"
//
//Ejecuta(sqlUSR,3)		
		
%>
<!--#include file="Variables.asp" -->
<!--#include file="FlujoAcceso.asp" -->

