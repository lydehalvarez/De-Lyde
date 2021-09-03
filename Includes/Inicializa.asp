<%
// Declaracion de Variables
//--------------------------------------------------------------------------------------------------------------------


var sPlantillaCruda = ""  // Aqui carga todo el archivo, o lo que falta de procesar
var sPlantillaProcesada = ""  // aqui va depositando lo que ya proceso
var sPlantillaRenglonProcesada = ""
var sPlantillaRenglonCruda = ""
var sCodigoParaELJQuery = ""
var sMenuPrincipal = ""
var sHerramientasDelMenu= ""
var sOtrasVariables = ""
var sMenuSecundario = ""
var sBreadCrumb = ""
var sMenuPan = ""
var sFlotantes = ""
var sCargaEstilos = ""
var sCargaIncludesDeJavaScript = "" 
var sCargaFinal = "" 
var iHijos = 0
var iqCli_Nombre = "" 
var iqCli_NombreOficial = ""
var iqCli_Turno = ""
var iqCli_Enlace = "" 
var iqCli_Telefono = "" 
var iqCli_Telefono2 = "" 
var iqCli_Habilitado = ""
var iqCli_Direccion = ""
var iqCli_Obervaciones = ""
var iqCli_Pla_ID = 0
var iqCli_FechadeAlta = ""
var iqCli_Logo = ""
var iqCli_RutaArchivos = "/"
var AlrS_ID = Parametro("AlrS_ID","-1")
var Alr_ID = Parametro("Alr_ID","-1")
var AlrE_ID = Parametro("AlrE_ID","-1")
var sTmpComodin01 = ""
var sTmpComodin02 = ""
var sTmpComodin03 = ""
var sTmpComodin04 = ""
var sTmpComodin05 = ""
var sTmpComodin06 = ""
var sTmpComodin07 = ""
var sDivision = "" 
var sDivisionImagenes = ""
var sJQDeTabs = ""
var sContenedorDeTabs = ""
var sContenedorMenuTag1 = ""
var sContenedorMenuTag2 = ""
var sContenedorMenuTag3 = ""
var sUsuarioFirmado = Parametro("sUsuarioSes","")
var sFlModo = Parametro("Modo","Consulta")
var sFlAccion = Parametro("Accion","Consulta")
var comodinNombreDiv = ""
var comodinFuncionDespues = ""
var comodinArchivoAjax = ""
var arrComodin = new Array(0)
var arrComodinDIV = new Array(0)
var NombreEscuela = ""
var sPZPrincipal  = ""
var sPZJS  = "" 
var sPZJQ  = ""  
var sPZEjecutable  = ""  
var iEsPanza = 0
var wgParam = "" 
var swgtBotones = ""
var sBodyFunciones = ""
var iIDSeguridad = 0
var iUsarPP = 0
var iWgCfgID = -1
var iWgID = -1
var frmCampoLlave = "FaltaCmpLLave" 
var arrOcultos = new Array(0)
var arrOPP = new Array(0)
var arrOValor = new Array(0)
var arrOTipo = new Array(0)


// =================================================================================================================
//             Inicia Cargado de Plantillas                               JD y ROG  29 Enero 2011
//                                                                                  21 Nov   2011
//                                                                        ROG       22/8/2017  Alertas
// =================================================================================================================

// Cargado de los parametros de la ventana en turno para colocarlos en la plantilla
//--------------------------------------------------------------------------------------------------------------------
	
	if (VentanaIndex > 0) { 
		sLigaSalida = "javascript:CambiaVentana(" + SistemaActual + ",1);"
	}  else {
		InicializaSesion(IDUsuario)	
	}
	if (VentanaIndex == 1) { 
		sLigaSalida = "javascript:CambiaVentana(" + SistemaActual + ",0);"
	} 
	if (VentanaIndex == -1) { 
		ParametroCambiaValor("VentanaIndex",0) 
		VentanaIndex = 0
		ParametroCambiaValor("VentanaIndexAnterior",0) 
		VentanaIndexAnterior = 0
	}
   
	CargaDatosGeneralesDelIQonCliente( VentanaIndex, SistemaActual )	
	CargaDatosDeLaPantallaEnTurno( VentanaIndex, SistemaActual )
//Response.Write("<br>99 VentanaIndex = " + VentanaIndex + " SistemaActual = " + SistemaActual)
//Response.End()
var bSesionValida = true

	Session("Editar")  = 0
	Session("Agregar") = 0
	Session("Borrar")  = 0
	
	//var sCondVS = " Sys_ID = " + SistemaActual + " and Mnu_ID = " + VentanaIndex
	//esto ya lo hace en la funcion de carga de datos de la pantalla en turno
	//ValidaSesion = BuscaSoloUnDato("Mnu_ValidaSesion","Menu",sCondVS,0,2)
	
	if (ValidaSesion == 0 ) {
		Session("Editar")  = 1
		Session("Agregar") = 1
		Session("Borrar")  = 1
		bSesionValida = true
	} else {
		if (IDUsuario > -1 && !EsVacio(IDUsuario)) {
			bSesionValida = true
			Seguridad(iIDSeguridad,IDUsuario,SegGrupo,SistemaActual)
		} else {
			bSesionValida = false
			Session("Editar")  = 0
			Session("Agregar") = 0
			Session("Borrar")  = 0
		}		
	}
  			
	// Cargando la plantilla 
	if (EsVacio(sArchivoPlantilla)) {
		sArchivoPlantilla = "/Template/Basica/BasicaInicial.html"
	}
	sPlantillaCruda = CargaArchivo(sArchivoPlantilla)

	CargaVariablesPermanentes(SistemaActual)

   //SerializaParametros()
	//GuardaParametrosenBD()
	//Preparando el form y las variables ocultas de control
	//Debug_ImprimeParametros("linea 125 de inicializa cargando solo parametros permanentes")
		
		//Cargando los objetos que se incrustan desde el principio se llamaran plugins
		//el widget normal es cuando se coloca codigo para ser llamado por ajax al iniciar la pagina
		 
		if (bSesionValida) {
			//este tipo de plugin se instala solo en el menu en accion
			CargaPluginsNivelMenu(SistemaActual, VentanaIndex)	

			//este tipo de plugin se instala en todos los menus que tengan esta plantilla
			CargaPluginsNivelPlantilla(SistemaActual, VentanaIndex)	

			CargaWidgets(SistemaActual, VentanaIndex,1)	
	
			//leo del menu widgets cual es el que le corresponde junto con la plantilla para conocer la posicion
			CargaWidgets(SistemaActual, VentanaIndex,0)		

			//descargue de variables permanentes
		} else {	
		    AgregaDebug("Error en validar usuario","============== no se cargaran los objetos ===================================")
			//Carga Widget de Validacion
			//sCodigoParaELJQuery += CargaArchivo("/widgets/SolicitaLogin/LoginJS.asp")
		}

		PreparaCamposOcultosPP()
		PreparaCamposOcultos()		
		sCargaIncludesDeJavaScript = BuscaParametros(sCargaIncludesDeJavaScript)		
		sCargaIncludesDeJavaScript = BuscaVariablesEN(sCargaIncludesDeJavaScript)
	
	//Cargando las variables de la plantilla con informacion

	BuscaVariables()
	
	sPlantillaCruda = BuscaParametros(sPlantillaCruda)	
	
// esto es un intento por compilar lo armado	
//  var sNmbrArchv = "C:\\Proyectos Web\\iqon\\www\\IQON_" + SistemaActual + "_" + VentanaIndex + ".html"	
//  var fso, ts;
//  var ForWriting= 2;
//  fso = new ActiveXObject("Scripting.FileSystemObject")
//  var FileObject = fso.OpenTextFile("C:\\LogFile.txt", 8, true,0); // 8=append, true=create if not exist, 0 = ASCII
//  ts = fso.OpenTextFile(sNmbrArchv, 8, true, 0 )
//	a.Write( sPlantillaCruda )
//	a.Close()	
//	
//	var fso = new ActiveXObject("Scripting.FileSystemObject")
//	if (fso2.FolderExists("C:\\Proyectos Web\\iqon\\www\\"))  {
//        fso2.DeleteFile("C:\\Proyectos Web\\iqon\\www\\" + sNmbrArchv)
//  }

//  true for overwrite
//	var a = fso.CreateTextFile( sNmbrArchv, true )
//	a.WriteLine( sPlantillaCruda )
//	a.Close()

//	Imprimiendo la Plantilla	
	Response.Write( sPlantillaCruda )
	
	 
	sPlantillaCruda = ""
	sTmpComodin01 = ""
	sTmpComodin02 = ""
	sTmpComodin03 = ""
	sTmpComodin04 = ""
	sTmpComodin05 = ""
	sPlantillaCruda = "" 
	sPlantillaProcesada = ""  
	
	ParametroCambiaValor("VentanaIndex",VentanaIndex)
	
	//Debug_ImprimeParametros("Antes de guardar parametros en inicializa")
	 
	//GuardaParametrosenBD()
	//SerializaParametros()

// =================================================================================================================
//                                           Funciones
//--------------------------------------------------------------------------------------------------------------------


function CargaArchivo(RutaArchivo) {
// pendiente  hacer arreglo para guardar archivos cargados y no cargar duplicados por configuraciones paralelas
	var TristateFalse      =  0  //Open the file in ASCII mode
	var TristateUseDefault = -2  //Open the file using the system default 
	var TristateTrue       = -1  //Open the file as Unicode 
	
	var ForReading   = 1  // Open a file for reading only. You can't write to this file. 
	var ForWriting   = 2  // Open a file for writing. 
	var ForAppending = 8  // Open a file and write to the end of the file. 
	
	try {
		
		var sArchivo = ""
		var sRutaArchivo = RaizSitio + RutaArchivo
			sRutaArchivo = CambiaAntiDiagonal(sRutaArchivo)
		AgregaDebug("Cargando Ruta archivo",sRutaArchivo)
		var fso = new ActiveXObject("Scripting.FileSystemObject")
		var ArchivoHTML = fso.OpenTextFile(sRutaArchivo, ForReading, true, TristateUseDefault )
		if (!ArchivoHTML.AtEndOfStream) {
				sArchivo = ArchivoHTML.ReadAll()
		}
		ArchivoHTML.Close()
	
		return sArchivo
	} catch(err) {
		  bOcurrioError = true
		  AgregaDebug("Error en CargaArchivo","============== ERROR ===================================")
		  AgregaDebug("Parametro de entrada",RutaArchivo)
		  AgregaDebug("Ruta archivo",sRutaArchivo)
		  AgregaDebug("Error ",err.description)
		  AgregaDebug("Fin Error en CargaArchivo","===============================================================")
   }
}


//Nivel 1= plantillas 0 = menu
function CargaWidgets(SistActual, VentIndex, Nivel) {
var iMnuID = 0
var tmpVentIndex = VentIndex

//var sWgSQL = "select w.* , mw.*, mc.* "
//	sWgSQL += " from Menu m, Menu_Widget mw, Widget_Configuracion mc, Widget w "
//	sWgSQL += " where m.Sys_ID = mw.Sys_ID and m.Mnu_ID = mw.Mnu_ID "
//	sWgSQL += " and m.Sys_ID = mc.Sys_ID and mw.WgCfg_ID = mc.WgCfg_ID "
//	sWgSQL += " and mw.Wgt_ID = mc.Wgt_ID "
//	sWgSQL += " and mw.Wgt_ID = w.Wgt_ID "
//	sWgSQL += " and mc.Wgt_ID = w.Wgt_ID "
//	sWgSQL += " and mw.MW_Habilitado = 1 and WgCfg_Habilitado = 1 and WgCfg_Borrado = 0 "
//	if (Nivel == 0 ) {
//		sWgSQL += " and mw.MW_UsoNivelPlantilla = 1 "
//		//creo que faltaria indicarle que sea de la misma plantilla que la ocnfiguracion
//	} else {
//		sWgSQL += " and m.Mnu_ID = " + VentIndex
//	}
//	sWgSQL += " and w.Wgt_EsPlugin = 0 "
//	sWgSQL += " and m.Sys_ID = " + SistActual
//	sWgSQL += " Order by MW_OrdenDeCargado "


var sWgSQL = "SELECT MenuConWidgets.* "
	sWgSQL += ", WgCfg_Nombre, WgCfg_Descripcion, WgCfg_Habilitado, WgCfg_Borrado, WgCfg_PanzaEjecutable "
	sWgSQL += ", WgCfg_JS, WgCfg_JQ, WgCfg_Estilos, WgCfg_LlavesAUsar, WgCfg_LlavesOcultas, WgCfg_LlavesALimpiar  "
	sWgSQL += " FROM Widget_Configuracion mc "
	sWgSQL += " RIGHT JOIN ( "
	sWgSQL += " 	SELECT Wgt_RutaEjecutable, Wgt_RutaEstilos, Wgt_RutaJS, Wgt_RutaJQuery, Wgt_EsPlugin "
	sWgSQL += " 	     , mw.Sys_ID, mw.Mnu_ID, mw.Wgt_ID, WgCfg_ID, MW_Param, MW_NombreDIV, MW_BorrarDiv "
	sWgSQL += " 	     , MW_ExisteDiv, MW_Habilitado, MW_UsoNivelPlantilla, MW_Descripcion, MW_NombreFuncion "
	sWgSQL += " 	     , MW_EsFuncion, MW_OrdenDeCargado, MW_FuncionAlTerminar, MW_PuedeAgregar, MW_PuedeBorrar "
	sWgSQL += " 	     , MW_PuedeEditar, MW_AlSeleccionarAbrirNuevaVentana "
	sWgSQL += " 	     , Mnu_Padre, Mnu_SiguienteVentana, Mnu_EsMenu, Mnu_UsarPP, Mnu_EsTab, Mnu_IDLigaDelTab "
	sWgSQL += " 	     , m.Pla_Tipo, Mnu_Tag1, Mnu_Tag2, Mnu_Tag3, Mnu_IDSeguridad, Mnu_FiltroIP, Mnu_Titulo "
	sWgSQL += " 	     , Mnu_Liga, Mnu_Habilitado, Mnu_Descripcion, Mnu_Orden, Mnu_HabilitaAyuda, Mnu_Ayuda "
	sWgSQL += " 	     , Mnu_TituloVentana1, Mnu_TituloVentana2, Mnu_TituloExplorador, Mnu_LigaArchivoACargar "
	sWgSQL += " 	     , Mnu_ValidaSesion, Mnu_RutaImagen, Mnu_MostrarComentariosDesarrollo "
	sWgSQL += " 	FROM Menu m, Menu_Widget mw, Widget w  "
	sWgSQL += " 	WHERE m.Sys_ID = mw.Sys_ID and m.Mnu_ID = mw.Mnu_ID  "
	sWgSQL += " 	and mw.Wgt_ID = w.Wgt_ID  "
	sWgSQL += " 	and mw.MW_Habilitado = 1 "
	sWgSQL += " 	and w.Wgt_EsPlugin = 0 "
	sWgSQL += " 	and m.Sys_ID  = " + SistActual
	if (Nivel == 1 ) {
		sWgSQL += " and mw.MW_UsoNivelPlantilla = 1 "
		// la siguiente condicion le da funcionalidad de cargado segun el tipo de plantilla
		//sWgSQL += " and mw.Pla_Tipo = m.Pla_Tipo "     
	} else {
	    sWgSQL += " and mw.MW_UsoNivelPlantilla = 0 "
		sWgSQL += " and m.Mnu_ID = " + VentIndex
	}
	sWgSQL += "  ) MenuConWidgets "
	sWgSQL += " ON ( MenuConWidgets.Sys_ID = mc.Sys_ID  "
	sWgSQL += "   AND MenuConWidgets.Wgt_ID = mc.Wgt_ID "
	sWgSQL += "   AND MenuConWidgets.WgCfg_ID = mc.WgCfg_ID )  "
	sWgSQL += " WHERE WgCfg_Habilitado = 1 and WgCfg_Borrado = 0 "  
	//aqui va el cargado de funciones segun la seguridad
	sWgSQL += " ORDER by MenuConWidgets.MW_OrdenDeCargado "


	AgregaDebug("Seguimiento en CargaWidgets","================== Seguimiento en CargaWidgets ======================================")
	AgregaDebug("Parametro de entrada","SistActual = " + SistActual + "  VentIndex = " + VentIndex)
	
	try {
		 var rsWG = AbreTabla(sWgSQL,1,2)
			 while (!rsWG.EOF){
			    LimpiaLlaves(rsWG.Fields.Item("WgCfg_LlavesALimpiar").Value)
				wgParam = FiltraVacios(rsWG.Fields.Item("MW_Param").Value)
				//Session("MW_Param") = String(wgParam)
				iWgCfgID = -2
				iWgCfgID = rsWG.Fields.Item("WgCfg_ID").Value
				//ParametroCambiaValor("WgCfgID",iWgCfgID)
				ParametroCambiaValor("WgCfg_ID",iWgCfgID)
				//Session("WgCfg_ID") = String(iWgCfgID)   //no se pasan por sesion porque el IE9 no lo camnbia
				iWgID = -2
				iWgID = rsWG.Fields.Item("Wgt_ID").Value
				//Session("Wgt_ID") = String(iWgID)
				ParametroCambiaValor("Wgt_ID",iWgID)
				SerializaParametros()
			    comodinFuncionDespues = "" + rsWG.Fields.Item("MW_FuncionAlTerminar").Value
				CargaVariablesOcultas(FiltraVacios(rsWG.Fields.Item("WgCfg_LlavesOcultas").Value))
				//PreparaCamposOcultos()
				//se borra el contenido del div
				if ( rsWG.Fields.Item("MW_BorrarDiv").Value == 1 ) {
					sCodigoParaELJQuery += "$('#" + rsWG.Fields.Item("MW_NombreDIV").Value + "').empty(); "
				}
		
				//Cargando estilos
					fn_CargaEstilos(FiltraVacios(rsWG.Fields.Item("Wgt_RutaEstilos").Value))
					fn_CargaEstilos(FiltraVacios(rsWG.Fields.Item("WgCfg_Estilos").Value))
					 					
				//Cargando JS
					if (FiltraVacios(rsWG.Fields.Item("Wgt_RutaJS").Value) != "") {
						sCargaIncludesDeJavaScript += CargaArchivo("" +rsWG.Fields.Item("Wgt_RutaJS").Value)
					}
					if (FiltraVacios(rsWG.Fields.Item("WgCfg_JS").Value) != "") {
						sCargaIncludesDeJavaScript += CargaArchivo("" +rsWG.Fields.Item("WgCfg_JS").Value)
					}
					
				if (FiltraVacios(rsWG.Fields.Item("WgCfg_LlavesAUsar").Value) != "") {
					frmCampoLlave = "" + rsWG.Fields.Item("WgCfg_LlavesAUsar").Value
				}					
					
				sCargaIncludesDeJavaScript = BuscaParametros(sCargaIncludesDeJavaScript)		
				sCargaIncludesDeJavaScript = BuscaVariablesEN(sCargaIncludesDeJavaScript)	
				//Cargando JQ
					if (FiltraVacios(rsWG.Fields.Item("Wgt_RutaJQuery").Value) != "") {
						sCodigoParaELJQuery += CargaArchivo("" +rsWG.Fields.Item("Wgt_RutaJQuery").Value)
					}
					if (FiltraVacios(rsWG.Fields.Item("WgCfg_JQ").Value) != "") {
						sCodigoParaELJQuery += CargaArchivo("" +rsWG.Fields.Item("WgCfg_JQ").Value)
					}	
				
				//if(EsVacio(rsWG.Fields.Item("MW_NombreDIV").Value)) {
				//	//no tiene indicado que se cargue sobre un div en especial
				//	AgregaDebug("widget error ","no se indico el nombre del div donde se debera cargar")
				//} else {
					//si tiene indicado el nombre del div es decir el contenedor de la plantilla debe contener este objeto
					//es necesario agregarlo dentro del objeto contenedor
					if ( rsWG.Fields.Item("MW_ExisteDiv").Value == 0 ) {
						//si viene con 1 es porque era una panza que contenia los divs para solo llenarlos
						//sCodigoParaELJQuery += "$('#" + rsWG.Fields.Item("MW_NombreDIV").Value + "')"  //pendiente este campo debiera ser el body o el div al que se va a cargar
						sCodigoParaELJQuery += "$('body').prepend('<div id=\""   //"
						sCodigoParaELJQuery += rsWG.Fields.Item("MW_NombreDIV").Value + "\"></div>'); "  //"
					}
					if (FiltraVacios(rsWG.Fields.Item("Wgt_RutaEjecutable").Value) != "") {
						sCodigoParaELJQuery += "$('#" + rsWG.Fields.Item("MW_NombreDIV").Value + "')"
						//sCodigoParaELJQuery += ".load('" + rsWG.Fields.Item("Wgt_RutaEjecutable").Value + "'"
						sCodigoParaELJQuery += ".load('" + rsWG.Fields.Item("Wgt_RutaEjecutable").Value + "?" + Server.URLEncode(sParametrosSerializados) + "'"
						//sCodigoParaELJQuery += ".load('" + rsWG.Fields.Item("Wgt_RutaEjecutable").Value + "?'+$(\"#frmDatos\").serialize()"
						if (FiltraVacios(rsWG.Fields.Item("MW_FuncionAlTerminar").Value) != "") {
							sCodigoParaELJQuery += ",function() {" +rsWG.Fields.Item("MW_FuncionAlTerminar").Value
							sCodigoParaELJQuery += "}"
						}
						sCodigoParaELJQuery += ");"
						
					}
					sCodigoParaELJQuery = BuscaParametros(sCodigoParaELJQuery)		
					sCodigoParaELJQuery = BuscaVariablesEN(sCodigoParaELJQuery)	
//					if (FiltraVacios(rsWG.Fields.Item("WgCfg_PanzaEjecutable").Value) != "") {
//						sCodigoParaELJQuery += "$('#" + rsWG.Fields.Item("MW_NombreDIV").Value + "')"
//						sCodigoParaELJQuery += ".load('" + rsWG.Fields.Item("WgCfg_PanzaEjecutable").Value + "'); "	
//					}
				//}
					//Para debugear un plugin en especial
//					if (rsWG.Fields.Item("Wgt_ID").Value == 7 ) {
//						bOcurrioError = true
						
						AgregaDebug("plugin ",rsWG.Fields.Item("Wgt_ID").Value)
						AgregaDebug("IDConfig ",iWgCfgID)
						AgregaDebug("Parametros ",wgParam)
						AgregaDebug("Estilos Widget ",rsWG.Fields.Item("Wgt_RutaEstilos").Value)
						AgregaDebug("Estilos Configuracion ",rsWG.Fields.Item("WgCfg_Estilos").Value)
						AgregaDebug("JQ Widget ",rsWG.Fields.Item("Wgt_RutaJQuery").Value)
						AgregaDebug("JQ Configuracion ",rsWG.Fields.Item("WgCfg_JQ").Value)
						AgregaDebug("JS Widget ",rsWG.Fields.Item("Wgt_RutaJS").Value)
						AgregaDebug("JS Configuracion ",rsWG.Fields.Item("WgCfg_JS").Value)
						var sLga = rsWG.Fields.Item("Wgt_RutaEjecutable").Value
						AgregaDebug("Ejecutable Widget ","<a href='" + sLga + "' target='new'>" + sLga + "</a>")
						AgregaDebug("Ejecutable Configuracion ",rsWG.Fields.Item("WgCfg_PanzaEjecutable").Value)
//					}
				//BuscaVariables()sLga
				rsWG.MoveNext()
			 }
			 rsWG.Close()
			
			AgregaDebug("sql cargar ",sWgSQL )		  
			AgregaDebug("Fin Seguimiento en CargaWidgets","================= Fin Seguimiento en CargaWidgets ============================================")
			AgregaDebug(" "," ")

	} catch(err) {
			bOcurrioError = true
			AgregaDebug("Error en CargaWidgets","===============================================================")
			AgregaDebug("Parametro de entrada","SistActual = " + SistActual + "  VentIndex = " + VentIndex)
			AgregaDebug("Fallo el plugin ",rsWG.Fields.Item("Wgt_ID").Value)
			AgregaDebug("IDConfig ",iWgCfgID)
			AgregaDebug("Error description ",err.description)
			AgregaDebug("Error number ",err.number)
			AgregaDebug("Error message ",err.message)
			AgregaDebug("plugin ",rsWG.Fields.Item("Wgt_ID").Value)
			AgregaDebug("Parametros ",wgParam)
			AgregaDebug("Estilos Widget ",rsWG.Fields.Item("Wgt_RutaEstilos").Value)
			AgregaDebug("Estilos Configuracion ",rsWG.Fields.Item("WgCfg_Estilos").Value)
			AgregaDebug("JQ Widget ",rsWG.Fields.Item("Wgt_RutaJQuery").Value)
			AgregaDebug("JQ Configuracion ",rsWG.Fields.Item("WgCfg_JQ").Value)
			AgregaDebug("JS Widget ",rsWG.Fields.Item("Wgt_RutaJS").Value)
			AgregaDebug("JS Configuracion ",rsWG.Fields.Item("WgCfg_JS").Value)
			var sLga = rsWG.Fields.Item("Wgt_RutaEjecutable").Value
			AgregaDebug("Ejecutable Widget ","<a href='" + sLga + "' target='new'>" + sLga + "</a>")
			AgregaDebug("Ejecutable Configuracion ",rsWG.Fields.Item("WgCfg_PanzaEjecutable").Value)
			AgregaDebug("sql cargar ",sWgSQL )		  
			AgregaDebug("Fin Error en CargaWidgets","===============================================================")
			
			
   }
}

function CargaPluginsNivelMenu(SistActual, VentIndex) {
var iMnuID = 0
var tmpVentIndex = VentIndex

	
var sWgSQL = "select w.* , mw.*, mc.* "
	sWgSQL += " from Menu m, Menu_Widget mw, Widget_Configuracion mc, Widget w "
	sWgSQL += " where m.Sys_ID = mw.Sys_ID and m.Mnu_ID = mw.Mnu_ID "
	sWgSQL += " and m.Sys_ID = mc.Sys_ID and mw.WgCfg_ID = mc.WgCfg_ID "
	sWgSQL += " and mw.Wgt_ID = mc.Wgt_ID "
	sWgSQL += " and mw.Wgt_ID = w.Wgt_ID "
	sWgSQL += " and mc.Wgt_ID = w.Wgt_ID "
	sWgSQL += " and mw.MW_Habilitado = 1 and WgCfg_Habilitado = 1 and WgCfg_Borrado = 0 "
	sWgSQL += " and mw.MW_UsoNivelPlantilla = 0 "
	sWgSQL += " and w.Wgt_EsPlugin = 1 "
	sWgSQL += " and m.Sys_ID = " + SistActual
	sWgSQL += " and m.Mnu_ID = " + VentIndex
	sWgSQL += " Order by MW_OrdenDeCargado "
	
	//MW_EsFuncion depende del cargado segun la seguridad
	AgregaDebug("Seguimiento en CargaPluginsNivelMenu","============= Seguimiento en CargaPluginsNivelMenu ==============")
	AgregaDebug("Parametro de entrada","SistActual = " + SistActual + "  VentIndex = " + VentIndex)
	AgregaDebug("475) sql cargar ",sWgSQL )	
	try {		
		 var sTmp = ""
		 var rsWG = AbreTabla(sWgSQL,1,2)
			 while (!rsWG.EOF){
			 	LimpiaLlaves(rsWG.Fields.Item("WgCfg_LlavesALimpiar").Value)
			 	wgParam = FiltraVacios(rsWG.Fields.Item("MW_Param").Value)
				//Session("MW_Param") = String(wgParam)
				iWgCfgID = rsWG.Fields.Item("WgCfg_ID").Value
				ParametroCambiaValor("WgCfgID",iWgCfgID)
				//Session("WgCfg_ID") = String(iWgCfgID)
				iWgID = rsWG.Fields.Item("Wgt_ID").Value
				//Session("Wgt_ID") = String(iWgID)
				ParametroCambiaValor("WgID",iWgID)
				SerializaParametros()
				comodinFuncionDespues = "" + rsWG.Fields.Item("MW_FuncionAlTerminar").Value	
				
				//Cargando estilos
					fn_CargaEstilos(FiltraVacios(rsWG.Fields.Item("Wgt_RutaEstilos").Value))
					fn_CargaEstilos(FiltraVacios(rsWG.Fields.Item("WgCfg_Estilos").Value))
					
				//Cargando JS
					if (FiltraVacios(rsWG.Fields.Item("Wgt_RutaJS").Value) != "") {
						sCargaIncludesDeJavaScript += CargaArchivo("" +rsWG.Fields.Item("Wgt_RutaJS").Value)
					}
					if (FiltraVacios(rsWG.Fields.Item("WgCfg_JS").Value) != "") {
						sCargaIncludesDeJavaScript += CargaArchivo("" +rsWG.Fields.Item("WgCfg_JS").Value)
					}
				//Cargando JQ
					if (FiltraVacios(rsWG.Fields.Item("Wgt_RutaJQuery").Value) != "") {
						sCodigoParaELJQuery += CargaArchivo("" +rsWG.Fields.Item("Wgt_RutaJQuery").Value)
					}
						
				CargaVariablesOcultas(FiltraVacios(rsWG.Fields.Item("WgCfg_LlavesOcultas").Value))
				
				if (FiltraVacios(rsWG.Fields.Item("WgCfg_LlavesAUsar").Value) != "") {
					frmCampoLlave = "" + rsWG.Fields.Item("WgCfg_LlavesAUsar").Value
				}	
				//Cargando ejecutable
					if (FiltraVacios(rsWG.Fields.Item("Wgt_RutaEjecutable").Value) != "") {
						sTmp = CargaArchivo("" +rsWG.Fields.Item("Wgt_RutaEjecutable").Value)
						sTmp = ColocaValorDeLaVariable(sTmp)
					}
					
//antes 					
//					if (FiltraVacios(rsWG.Fields.Item("WgCfg_PanzaEjecutable").Value) != "") {
//						sCodigoParaELJQuery += "$('#" + rsWG.Fields.Item("MW_NombreDIV").Value + "')"
//						sCodigoParaELJQuery += ".load('" + rsWG.Fields.Item("WgCfg_PanzaEjecutable").Value + "'); "	
//					}
//nuevo
					if ( rsWG.Fields.Item("MW_ExisteDiv").Value == 0 ) {
						//si viene con 1 es porque era una panza que contenia los divs para solo llenarlos
						//sCodigoParaELJQuery += "$('#" + rsWG.Fields.Item("MW_NombreDIV").Value + "')"  //pendiente este campo debiera ser el body o el div al que se va a cargar
						
						sCodigoParaELJQuery += "$('body').prepend('<div id=\""   //"
						sCodigoParaELJQuery += rsWG.Fields.Item("MW_NombreDIV").Value + "\"></div>'); "  //"
					}
					
// forma con load
					if (FiltraVacios(rsWG.Fields.Item("WgCfg_PanzaEjecutable").Value) != "") {
						sCodigoParaELJQuery += "$('#" + rsWG.Fields.Item("MW_NombreDIV").Value + "')"
						//sCodigoParaELJQuery += ".load('" + rsWG.Fields.Item("WgCfg_PanzaEjecutable").Value + "'"
						sCodigoParaELJQuery += ".load('" + rsWG.Fields.Item("WgCfg_PanzaEjecutable").Value + "?" + Server.URLEncode(sParametrosSerializados) + "'"
						//sCodigoParaELJQuery += ".load('" + rsWG.Fields.Item("WgCfg_PanzaEjecutable").Value + "?'+$(\"#frmDatos\").serialize()"
						if (FiltraVacios(rsWG.Fields.Item("MW_FuncionAlTerminar").Value) != ""  ||  FiltraVacios(rsWG.Fields.Item("WgCfg_JQ").Value) != "") {
							sCodigoParaELJQuery += ",function() {"
							if (FiltraVacios(rsWG.Fields.Item("WgCfg_JQ").Value) != "") {
								sCodigoParaELJQuery += CargaArchivo("" +rsWG.Fields.Item("WgCfg_JQ").Value)						
							}		
							sCodigoParaELJQuery += " " + FiltraVacios(rsWG.Fields.Item("MW_FuncionAlTerminar").Value) + " "
							sCodigoParaELJQuery += "}"
						}
						sCodigoParaELJQuery += ");"
						
					}

//					
//forma con post
//              if (FiltraVacios(rsWG.Fields.Item("WgCfg_PanzaEjecutable").Value) != "") {
//					sCodigoParaELJQuery += "$.post('" + rsWG.Fields.Item("WgCfg_PanzaEjecutable").Value + "', function(data) {"
//                    sCodigoParaELJQuery += "$('#" + rsWG.Fields.Item("MW_NombreDIV").Value + "').html(data); "
//					if (FiltraVacios(rsWG.Fields.Item("WgCfg_JQ").Value) != "") {
//						sCodigoParaELJQuery += CargaArchivo("" +rsWG.Fields.Item("WgCfg_JQ").Value)
//						
//						if (FiltraVacios(rsWG.Fields.Item("MW_FuncionAlTerminar").Value) != "") {
//							sCodigoParaELJQuery += "  " + rsWG.Fields.Item("MW_FuncionAlTerminar").Value
//						}
//					}	
//					sCodigoParaELJQuery += "});  "
//                    }
//					
					sCargaIncludesDeJavaScript = BuscaParametros(sCargaIncludesDeJavaScript)
					sCargaIncludesDeJavaScript = BuscaVariablesEN(sCargaIncludesDeJavaScript)				
					
//					//Para debugear un plugin en especial
//					if (rsWG.Fields.Item("Wgt_ID").Value == 8 ) {
//						bOcurrioError = true
						AgregaDebug("plugin ",rsWG.Fields.Item("Wgt_ID").Value)
						AgregaDebug("IDConfig ",iWgCfgID)
						AgregaDebug("Parametros ",wgParam)
						AgregaDebug("Estilos Widget ",rsWG.Fields.Item("Wgt_RutaEstilos").Value)
						AgregaDebug("Estilos Configuracion ",rsWG.Fields.Item("WgCfg_Estilos").Value)
						AgregaDebug("JQ Widget ",rsWG.Fields.Item("Wgt_RutaJQuery").Value)
						AgregaDebug("JQ Configuracion ",rsWG.Fields.Item("WgCfg_JQ").Value)
						AgregaDebug("JS Widget ",rsWG.Fields.Item("Wgt_RutaJS").Value)
						AgregaDebug("JS Configuracion ",rsWG.Fields.Item("WgCfg_JS").Value)
									var sLga = rsWG.Fields.Item("Wgt_RutaEjecutable").Value
			AgregaDebug("Ejecutable Widget ","<a href='" + sLga + "' target='new'>" + sLga + "</a>")
						AgregaDebug("Ejecutable Configuracion ",rsWG.Fields.Item("WgCfg_PanzaEjecutable").Value)
//					}
				rsWG.MoveNext()
			 }
			 rsWG.Close()
			 
	AgregaDebug("Fin Seguimiento en CargaPluginsNivelMenu","============== Fin Seguimiento en CargaPluginsNivelMenu  ========================")
	AgregaDebug(" "," ")		  
	
	} catch(err) {
		bOcurrioError = true
		AgregaDebug("Error en CargaPluginsNivelMenu","================== ERROR ====================================")
						AgregaDebug("Parametro de entrada","SistActual = " + SistActual + "  VentIndex = " + VentIndex)
			AgregaDebug("Fallo el plugin ",rsWG.Fields.Item("Wgt_ID").Value)
			AgregaDebug("Error description ",err.description)
			AgregaDebug("Error number ",err.number)
			AgregaDebug("Error message ",err.message)
						AgregaDebug("Parametros ",wgParam)
						AgregaDebug("Estilos Widget ",rsWG.Fields.Item("Wgt_RutaEstilos").Value)
						AgregaDebug("Estilos Configuracion ",rsWG.Fields.Item("WgCfg_Estilos").Value)
						AgregaDebug("JQ Widget ",rsWG.Fields.Item("Wgt_RutaJQuery").Value)
						AgregaDebug("JQ Configuracion ",rsWG.Fields.Item("WgCfg_JQ").Value)
						AgregaDebug("JS Widget ",rsWG.Fields.Item("Wgt_RutaJS").Value)
						AgregaDebug("JS Configuracion ",rsWG.Fields.Item("WgCfg_JS").Value)
									var sLga = rsWG.Fields.Item("Wgt_RutaEjecutable").Value
			AgregaDebug("Ejecutable Widget ","<a href='" + sLga + "' target='new'>" + sLga + "</a>")
						AgregaDebug("Ejecutable Configuracion ",rsWG.Fields.Item("WgCfg_PanzaEjecutable").Value)
						AgregaDebug("sql cargar ",sWgSQL )		  
		AgregaDebug("Fin Error en CargaPluginsNivelMenu","===============================================================")
   }
}


function CargaPluginsNivelPlantilla(SistActual, VentIndex) {

var sWgSQL = "select w.* , mw.*, mc.* "
	sWgSQL += " from Menu m, Menu_Widget mw, Widget_Configuracion mc, Widget w "
	sWgSQL += " where m.Sys_ID = mw.Sys_ID and  m.Mnu_ID = mw.Mnu_ID "
	sWgSQL += " and m.Sys_ID = mc.Sys_ID and mw.WgCfg_ID = mc.WgCfg_ID "
	sWgSQL += " and mw.Wgt_ID = mc.Wgt_ID "
	sWgSQL += " and mw.Wgt_ID = w.Wgt_ID "
	sWgSQL += " and mc.Wgt_ID = w.Wgt_ID "
	sWgSQL += " and mw.Pla_Tipo = m.Pla_Tipo  "
	sWgSQL += " and mw.MW_Habilitado = 1 and WgCfg_Habilitado = 1 and WgCfg_Borrado = 0 "
	sWgSQL += " and mw.MW_UsoNivelPlantilla = 1 "
	sWgSQL += " and w.Wgt_EsPlugin = 1 "
	sWgSQL += " and m.Sys_ID = " + SistActual
	sWgSQL += " Order by MW_OrdenDeCargado "
 
	AgregaDebug("Seguimiento en CargaPluginsNivelPlantilla","======================= Seguimiento en CargaPluginsNivelPlantilla ==================================")
	AgregaDebug("Parametro de entrada","SistActual = " + SistActual + "  VentIndex = " + VentIndex)
	
	try {	
		 var sTmp = ""
		 var rsWG = AbreTabla(sWgSQL,1,2)
			 while (!rsWG.EOF){
			 	LimpiaLlaves(rsWG.Fields.Item("WgCfg_LlavesALimpiar").Value)
			 	wgParam = FiltraVacios(rsWG.Fields.Item("MW_Param").Value)
				//Session("MW_Param") = String(wgParam)
				iWgCfgID = rsWG.Fields.Item("WgCfg_ID").Value
				ParametroCambiaValor("WgCfgID",iWgCfgID)
				//Session("WgCfg_ID") = String(iWgCfgID)
				iWgID = rsWG.Fields.Item("Wgt_ID").Value
				//Session("Wgt_ID") = String(iWgID)
				ParametroCambiaValor("WgID",iWgID)
				SerializaParametros()
				comodinFuncionDespues = "" + rsWG.Fields.Item("MW_FuncionAlTerminar").Value
					
				//Cargando estilos
					fn_CargaEstilos(FiltraVacios(rsWG.Fields.Item("Wgt_RutaEstilos").Value))
					fn_CargaEstilos(FiltraVacios(rsWG.Fields.Item("WgCfg_Estilos").Value))
					
				//Cargando JS
					if (FiltraVacios(rsWG.Fields.Item("Wgt_RutaJS").Value) != "") {
						sCargaIncludesDeJavaScript += CargaArchivo("" +rsWG.Fields.Item("Wgt_RutaJS").Value)
					}
					if (FiltraVacios(rsWG.Fields.Item("WgCfg_JS").Value) != "") {
						sCargaIncludesDeJavaScript += CargaArchivo("" +rsWG.Fields.Item("WgCfg_JS").Value)
					}
					
				//Cargando JQ
					if (FiltraVacios(rsWG.Fields.Item("Wgt_RutaJQuery").Value) != "") {
						sCodigoParaELJQuery += CargaArchivo("" +rsWG.Fields.Item("Wgt_RutaJQuery").Value)
					}
					if (FiltraVacios(rsWG.Fields.Item("WgCfg_JQ").Value) != "") {
						sCodigoParaELJQuery += CargaArchivo("" +rsWG.Fields.Item("WgCfg_JQ").Value)
					}	
					
				CargaVariablesOcultas(FiltraVacios(rsWG.Fields.Item("WgCfg_LlavesOcultas").Value))			
							
				//Cargando ejecutable
					if (FiltraVacios(rsWG.Fields.Item("Wgt_RutaEjecutable").Value) != "") {
						sTmp = CargaArchivo("" +rsWG.Fields.Item("Wgt_RutaEjecutable").Value)
						sTmp = ColocaValorDeLaVariable(sTmp)

					}
					
				sCargaIncludesDeJavaScript = BuscaParametros(sCargaIncludesDeJavaScript)
				sCargaIncludesDeJavaScript = BuscaVariablesEN(sCargaIncludesDeJavaScript)					
					
//					if (FiltraVacios(rsWG.Fields.Item("WgCfg_Ejecutable").Value) != "") {
//						sTmp = CargaArchivo("" +rsWG.Fields.Item("WgCfg_Ejecutable").Value)
//						sTmp = ColocaValorDeLaVariable(sTmp)
//						//sCargaIncludesDeJavaScript = BuscaParametros(sCargaIncludesDeJavaScript)
//						//sCargaIncludesDeJavaScript = BuscaVariablesEN(sCargaIncludesDeJavaScript)
//					}
//						revisar si se necesita convertir las variables en este punto							
////					if (FiltraVacios(rsWG.Fields.Item("Wgt_RutaEjecutable").Value) != "") {
////						sTmp = CargaArchivo("" +rsWG.Fields.Item("Wgt_RutaEjecutable").Value)
////						sTmp = ColocaValorDeLaVariable(sTmp)
////			
////						sCargaIncludesDeJavaScript = BuscaParametros(sCargaIncludesDeJavaScript)
////						sCargaIncludesDeJavaScript = BuscaVariablesEN(sCargaIncludesDeJavaScript)
////					}
					
//					//Para debugear un plugin en especial
//					if (rsWG.Fields.Item("Wgt_ID").Value == 8 ) {
//						bOcurrioError = true
						AgregaDebug("plugin ",rsWG.Fields.Item("Wgt_ID").Value)
						AgregaDebug("IDConfig ",iWgCfgID)
						AgregaDebug("Parametros ",wgParam)
						AgregaDebug("Estilos Widget ",rsWG.Fields.Item("Wgt_RutaEstilos").Value)
						AgregaDebug("Estilos Configuracion ",rsWG.Fields.Item("WgCfg_Estilos").Value)
						AgregaDebug("JQ Widget ",rsWG.Fields.Item("Wgt_RutaJQuery").Value)
						AgregaDebug("JQ Configuracion ",rsWG.Fields.Item("WgCfg_JQ").Value)
						AgregaDebug("JS Widget ",rsWG.Fields.Item("Wgt_RutaJS").Value)
						AgregaDebug("JS Configuracion ",rsWG.Fields.Item("WgCfg_JS").Value)
						AgregaDebug("Ejecutable Widget ",rsWG.Fields.Item("Wgt_RutaEjecutable").Value)
						AgregaDebug("Ejecutable Configuracion ",rsWG.Fields.Item("WgCfg_PanzaEjecutable").Value)
//					}
					
				rsWG.MoveNext()
			 }
			 rsWG.Close()
			AgregaDebug("sql cargar ",sWgSQL )	  	
			AgregaDebug("Fin Seguimiento en CargaPluginsNivelPlantilla","===============================================================")
			 			AgregaDebug(" "," ")
	} catch(err) {
		  	bOcurrioError = true
			AgregaDebug("Error en CargaPluginsNivelPlantilla","==================== ERROR =====  Error en CargaPluginsNivelPlantilla ===============================")
			AgregaDebug("Parametro de entrada","SistActual = " + SistActual + "  VentIndex = " + VentIndex)
			AgregaDebug("Fallo el plugin ",rsWG.Fields.Item("Wgt_ID").Value)
			AgregaDebug("Error description ",err.description)
			AgregaDebug("Error number ",err.number)
			AgregaDebug("Error message ",err.message)
						AgregaDebug("Parametro de entrada","SistActual = " + SistActual + "  VentIndex = " + VentIndex)
						AgregaDebug("plugin ",rsWG.Fields.Item("Wgt_ID").Value)
						AgregaDebug("Parametros ",wgParam)
						AgregaDebug("Estilos Widget ",rsWG.Fields.Item("Wgt_RutaEstilos").Value)
						AgregaDebug("Estilos Configuracion ",rsWG.Fields.Item("WgCfg_Estilos").Value)
						AgregaDebug("JQ Widget ",rsWG.Fields.Item("Wgt_RutaJQuery").Value)
						AgregaDebug("JQ Configuracion ",rsWG.Fields.Item("WgCfg_JQ").Value)
						AgregaDebug("JS Widget ",rsWG.Fields.Item("Wgt_RutaJS").Value)
						AgregaDebug("JS Configuracion ",rsWG.Fields.Item("WgCfg_JS").Value)
						var sLga = rsWG.Fields.Item("Wgt_RutaEjecutable").Value
			AgregaDebug("Ejecutable Widget ","<a href='" + sLga + "' target='new'>" + sLga + "</a>")
						AgregaDebug("Ejecutable Configuracion ",rsWG.Fields.Item("WgCfg_PanzaEjecutable").Value)
						AgregaDebug("sql cargar ",sWgSQL )		  
			AgregaDebug("Fin Error en CargaPluginsNivelPlantilla","===============================================================")
   }
}


function CargaDatosDeLaPantallaEnTurno(VIndex,SActual) {

	var bFallo = false
	var sSQL  = "Select * "     
		sSQL += " from Menu M, Menu_Plantilla MP "
		sSQL += " WHERE MP.Pla_ID = " + iqCli_Pla_ID
		sSQL += " AND M.Pla_Tipo = MP.Pla_Tipo "
		sSQL += " AND M.Mnu_ID = " + VIndex
		sSQL += " AND M.Sys_ID = " + SActual

 	try {	
		var rsTab = AbreTabla(sSQL,1,2)
		if (!rsTab.EOF) {
			
			sTituloVentana1       = "" + rsTab.Fields.Item("Mnu_TituloVentana1").Value 
			sTituloVentana2       = "" + rsTab.Fields.Item("Mnu_TituloVentana2").Value
			sTituloExplorador     = "" + rsTab.Fields.Item("Mnu_TituloExplorador").Value	
			sLigaArchivoACargar   = "" + rsTab.Fields.Item("Mnu_LigaArchivoACargar").Value	
			sSiguienteVentana     = "" + rsTab.Fields.Item("Mnu_SiguienteVentana").Value
			
			sArchivoPlantilla     = "" + rsTab.Fields.Item("Pla_RutaPlantilla").Value
			sHabilitaAyuda        = "" + rsTab.Fields.Item("Mnu_HabilitaAyuda").Value
			ValidaSesion          = "" + rsTab.Fields.Item("Mnu_ValidaSesion").Value
			iIDSeguridad          = "" + rsTab.Fields.Item("Mnu_IDSeguridad").Value
			iUsarPP               = "" + rsTab.Fields.Item("Mnu_UsarPP").Value
//			iIniciaSinParametros  = rsTab.Fields.Item("Mnu_IniciaSinParametros").Value
			
//			if (iIniciaSinParametros==1) {
//				MantenSoloParametrosPermanente()
//			}
//			if (  rsTab.Fields.Item("Mnu_Tag3").Value == 1 ) {
//				bLeeParametrosCampoBusqueda = true
//			} else {
//				bLeeParametrosCampoBusqueda = false
//			}
		}
		
		rsTab.Close()
		
		//ParametroCambiaValor("sSiguienteVentana",sSiguienteVentana)
		
		//pendiente a implementar ventanas de error mientras reseteo general
		if (EsVacio(sArchivoPlantilla)) {
			bFallo = true  
			var sCondicion =  " Sys_ID = " + SActual
				sCondicion += " AND Mnu_Habilitado = 1 "
			VentanaIndex =  BuscaSoloUnDato("min(Mnu_ID)","Menu",sCondicion,0,2)
			ParametroCambiaValor("VentanaIndex",VentanaIndex)
			//Response.End()
			CargaDatosDeLaPantallaEnTurno(VentanaIndex,SActual)
		}
		
		//Valido que no tenga hijos, si los tuviera no cargo widgets que los cargue su tab
		if (!bFallo) {
			var sCondicion =  " Mnu_Padre = " + VentanaIndex
				sCondicion += " AND Mnu_EsTab = 1 " 
				sCondicion += " and Sys_ID = " + SActual
				sCondicion += " AND Mnu_Habilitado = 1 "
			iHijos =  BuscaSoloUnDato("count(*)","Menu",sCondicion,0,2)
	
			// si tiene hijos busco al primero y cargo esa hoja quedando la primera como contenedor
			// los widgets deberan estar en el primer tab
			
			if (iHijos > 0 ) {
				var sCondicion  = " Mnu_Padre = " + VentanaIndex
					sCondicion += " AND Mnu_EsTab = 1 " 
					sCondicion += " and Sys_ID = " + SActual
					sCondicion += " AND Mnu_Habilitado = 1 order by Mnu_Orden "
					VentanaIndex =  BuscaSoloUnDato(" top 1 Mnu_ID","Menu",sCondicion,0,2)
	
				ParametroCambiaValor("VentanaIndex",VentanaIndex)
				//Response.Cookies("VentanaIndex")=String(VentanaIndex)
				TabIndex = -1
				ParametroCambiaValor("TabIndex",-1)
				CargaDatosDeLaPantallaEnTurno(VentanaIndex,SActual)
				//GuardaParametrosenBD()
			}
		}
	} catch(err) {
		bOcurrioError = true
		AgregaDebug("Error en CargaDatosDeLaPantallaEnTurno","======================= ERROR =============================")
		AgregaDebug("Parametro de entrada","SistActual = " + SActual + "  VentIndex = " + VIndex)
		AgregaDebug("Error description ",err.description)
		AgregaDebug("Error number ",err.number)
		AgregaDebug("Error message ",err.message)
		AgregaDebug("sql cargar ",sSQL )		  
		AgregaDebug("Fin Error en CargaDatosDeLaPantallaEnTurno","===============================================================")
   }
}		
	
	
function CargaDatosGeneralesDelIQonCliente(VIndex, SActual) {

	if (EsVacio(iqCli_ID)) { 
		Response.Write("Error , iqCli_ID vacio,  fn CargaDatosGeneralesDelIQonCliente, linea 841")
		Response.End()
	 }


	var sSQL  = "Select * "     
		sSQL += " from iqCliente "
		sSQL += " WHERE iqCli_ID = " + iqCli_ID

 	try {	
		var rsiqCliente = AbreTabla(sSQL,1,2)
		if (!rsiqCliente.EOF) {
			iqCli_Nombre = "" + rsiqCliente.Fields.Item("iqCli_Nombre").Value
			//iqCli_NombreOficial = "" + rsiqCliente.Fields.Item("iqCli_NombreOficial").Value
			//iqCli_Turno = "" + rsiqCliente.Fields.Item("iqCli_Turno").Value
			//iqCli_Enlace = "" + rsiqCliente.Fields.Item("iqCli_Enlace").Value
			//iqCli_Telefono = "" + rsiqCliente.Fields.Item("iqCli_Telefono").Value
			//iqCli_Telefono2 = "" + rsiqCliente.Fields.Item("iqCli_Telefono2").Value
			iqCli_Habilitado = "" + rsiqCliente.Fields.Item("iqCli_Habilitado").Value
			//iqCli_Direccion = "" + rsiqCliente.Fields.Item("iqCli_Direccion").Value
			//iqCli_Obervaciones = "" + rsiqCliente.Fields.Item("iqCli_Obervaciones").Value
			//Edo_ID, Mun_ID, Loc_ID, 
			iqCli_Pla_ID = "" + rsiqCliente.Fields.Item("Pla_ID").Value
			//iqCli_FechadeAlta = "" + rsiqCliente.Fields.Item("iqCli_FechadeAlta").Value
			iqCli_Logo = "" + rsiqCliente.Fields.Item("iqCli_Logo").Value
			iqCli_RutaArchivos = "" + rsiqCliente.Fields.Item("iqCli_RutaArchivos").Value
		}
		rsiqCliente.Close()


	} catch(err) {
		bOcurrioError = true
		Response.Write("<br>Error en CargaDatosGeneralesDelIQonCliente ======================= ERROR =============================")
		Response.Write("<br>linea 874 "  )		
		Response.Write("<br>Error description " + err.description)
		Response.Write("<br>Error number " + err.number)
		Response.Write("<br>Error message " + err.message)		  
		Response.Write("<br>Fin Error en CargaDatosGeneralesDelIQonCliente ===============================================================<br>")
		Response.End()	  
   }

}



//divide la variable en dos para dejar de un lado lo que ya se proceso
function DividePlantilla(Posicion, AQuitar) {
	sPlantillaProcesada += sPlantillaCruda.substring(0,Posicion)
	sPlantillaCruda = sPlantillaCruda.substring(Posicion+AQuitar,sPlantillaCruda.length)
}

function JuntaPlantilla() {
	sPlantillaCruda = sPlantillaProcesada + sPlantillaCruda
	sPlantillaProcesada = ""
}

function CambiaAntiDiagonal(Texto) {
var Resultado = ""
	for (i=0;i<Texto.length;i++) {
		
		if (Texto.substring(i,i+1) == "/") {
			Resultado += "\\"
			Resultado += "\\"
		} else {
			Resultado += Texto.substring(i,i+1)
		}	
	}
	return Resultado
}

function ColocaValorDeLaVariable(NombreDelCampo) {

	var sVariableValor = eval(NombreDelCampo)
	
	if (sVariableValor == "undefined") {
		sVariableValor = ""
	}
		if (sVariableValor == "null") {
		sVariableValor = ""
	}
	//AgregaDebug("Variable encontrada ",NombreDelCampo + " = " + sVariableValor)
 	return sVariableValor
}


//Los parametros son los datos que estan moviendose por post o get y se reciben en Cargaparametros
// y se leen con Parametro  el template a usar es asi: {Parametro:NombreDelParametro} 

function BuscaParametros(sTextoPlantilla) {
var sTMPCruda = sTextoPlantilla
var sTMPProcesada = ""

	var iInicioCampo = 0
	var sCampo = ""
	var sDefault = ""
	var iSale = 0
	var bValDef = false
	//busca los campos que estan en el documento para cambiarlos por datos
	iInicioCampo = sTMPCruda.indexOf("{Parametro:") 
	if (iInicioCampo > 0) {
		sTMPProcesada += sTMPCruda.substring(0,iInicioCampo)
		sTMPCruda = sTMPCruda.substring(iInicioCampo + 11,sTMPCruda.length)
		sCampo   = ""
		sDefault = ""
		bValDef = false
		for (i=0;i<sTMPCruda.length;i++) {
			if (sTMPCruda.substring(i,i+1) == "}") {
				iSale = sTMPCruda.length
				sTMPCruda = sTMPCruda.substring(i+1,sTMPCruda.length)
				sTMPProcesada += Parametro(sCampo,sDefault)
				sCampo = ""
				sDefault = ""
				bValDef = false
				i = iSale
			} else {
				if (sTMPCruda.substring(i,i+1) == ",") {
					bValDef = true
				} else {
					if (bValDef) {
						sDefault += sTMPCruda.substring(i,i+1)
					} else {
						sCampo += sTMPCruda.substring(i,i+1)
					}
				}
			}	
		}
		sTMPCruda = sTMPProcesada + sTMPCruda
		sTMPProcesada = ""
		BuscaParametros(sTMPCruda)
	}
	
	return sTMPCruda
}

function BuscaVariablesEN(sTextoPlantilla) {
var sTMPCruda = sTextoPlantilla
var sTMPProcesada = ""


try {
	var iInicioCampo = 0
	var sVariable = ""
	var iSale = 0
	//busca los campos que estan en el documento para cambiarlos por datos
	iInicioCampo = sTMPCruda.indexOf("{Variable:") 
	if (iInicioCampo > 0) {
		sTMPProcesada += sTMPCruda.substring(0,iInicioCampo)
		sTMPCruda = sTMPCruda.substring(iInicioCampo+10,sTMPCruda.length)
		sVariable = ""
		for (i=0;i<sTMPCruda.length;i++) {
			if (sTMPCruda.substring(i,i+1) == "}") {
				iSale = sTMPCruda.length
				//AgregaDebug("sVariable ",sVariable )
				sTMPCruda = sTMPCruda.substring(i+1,sTMPCruda.length)
				
				sVariable = "" + ColocaValorDeLaVariable(sVariable)
				//AgregaDebug("sVariable valor ",sVariable )
				sTMPProcesada +=sVariable
				sVariable = ""
				//JuntaPlantilla()
				i = iSale
			} else {
				sVariable += sTMPCruda.substring(i,i+1)
			}	
		}
		sTMPCruda = sTMPProcesada + sTMPCruda
		sTMPProcesada = ""
		
		BuscaVariablesEN(sTMPCruda)
	}
	
	return sTMPCruda

	} catch(err) {
		Response.Write("<br>Error en BuscaVariablesEN ======================= ERROR =============================")
		Response.Write("<br>sVariable = " + sVariable)
		Response.Write("<br>Error description " + err.description)
		Response.Write("<br>Error number " + err.number)
		Response.Write("<br>Error message " + err.message)		  
		Response.Write("<br>Fin Error en CargaDatosGeneralesDelIQonCliente ===============================================================<br>")
		Response.End()
   }
}


function BuscaVariables() {
	var iInicioCampo = 0
	var sVariable = ""
	var iSale = 0
	
	try {
		//busca los campos que estan en el documento para cambiarlos por datos
		iInicioCampo = sPlantillaCruda.indexOf("{Variable:") 
		if (iInicioCampo > 0) {
			DividePlantilla(iInicioCampo,10)
			sVariable = ""
			for (i=0;i<sPlantillaCruda.length;i++) {
				if (sPlantillaCruda.substring(i,i+1) == "}") {
					iSale = sPlantillaCruda.length
					sPlantillaCruda = sPlantillaCruda.substring(i+1,sPlantillaCruda.length)
					sPlantillaProcesada += ColocaValorDeLaVariable(sVariable)
					sVariable = ""
					//JuntaPlantilla()
					i = iSale
				} else {
					sVariable += sPlantillaCruda.substring(i,i+1)
				}	
			}
			JuntaPlantilla()
			BuscaVariables()
		}
	} catch(err) {
		Response.Write("<br>Error en BuscaVariables ======================= ERROR =============================")
		Response.Write("<br>sVariable = " + sVariable)
		Response.Write("<br>Error description " + err.description)
		Response.Write("<br>Error number " + err.number)
		Response.Write("<br>Error message " + err.message)	
		
		
		bPuedeVerDebug = true
		bDebug = true
		bOcurrioError = true
		DespliegaAlPie()
		Response.End()
   }
}

function BuscaLaVariable(sNombreVar,ValorVar) {
	var iInicioCampo = 0
	var sVariable = "{Variable:" + sNombreVar + "}"
	//busca los campos que estan en el documento para cambiarlos por datos
	iInicioCampo = sPlantillaCruda.indexOf(sVariable) 
	if (iInicioCampo > 0) {
		sPlantillaCruda = sPlantillaCruda.replace( sVariable , ValorVar)
		//BuscaLaVariable(sNombreVar,ValorVar)
	}
}

function CargaVariablesPermanentes(iSysID) {
	var iCantOcultos = 0
	var sValorVar = ""
	var tval = 0
	sOtrasVariables = ""
	try {	
		if (iUsarPP > 0 ) {
			var sSQLPP = "SELECT * from ParametrosPermanentes "
				sSQLPP +=  " WHERE Sys_ID = " + iSysID
				sSQLPP +=  " AND PP_Habilitado = 1 " 
				sSQLPP +=  " AND PP_Seccion = " + iUsarPP
				sSQLPP +=  " Order by PP_Orden " 
	
			var rsPP = AbreTabla(sSQLPP,1,2) 
			while (!rsPP.EOF){
				sValorVar = ""
				var sNomCamp = FiltraVacios(rsPP.Fields.Item("PP_Nombre").Value)
				var sDef = FiltraVacios(rsPP.Fields.Item("PP_ValorConstante").Value)
				arrOcultos[iCantOcultos] = sNomCamp
				arrOPP[iCantOcultos] = 1
				arrOValor[iCantOcultos] = Parametro(sNomCamp,sDef)				
				arrOTipo[iCantOcultos] = "N"
				iCantOcultos++ 
		        tval = Parametro(sNomCamp,sDef)
				if(tval != "") { 
					sOtrasVariables += "," + sNomCamp + ":" + tval
				}
				rsPP.MoveNext()
			}
			rsPP.Close()
		}
	  } catch(err) {
			AgregaDebug("Error en el cargado del arreglo de Parametros permanentes","==========")
	  }

}

function CargaVariablesOcultas(sParametros) {
	var arrCampo = new Array(0)
	var arrPrm   = new Array(0)
	var bEnc = false
	var MaxElemento = arrOcultos.length
	var sTmp = ""

/*
	    //   formato de parametros
	   //    Campo,Parametro,ValorDefault,Tipo|Campo,Parametro,ValorDefault,Tipo|Campo,Parametro,ValorDefault,Tipo
	  //     forma 1) Campo,Parametro,ValorDefault,Tipo   = Al campo le va a depositar el parametro con el valor default
	 //            2) Campo,         ,Valor       ,tipo   = Al campo le va a depositar la constante
	//             3)      ,Parametro,valor       ,Tipo   = Al parametro le va a asignar el valor
*/

	if (!EsVacio(sParametros) ) {
		//se extraen los parametros que se envian
		arrPrm = sParametros.split("|")
		for (j=0;j<arrPrm.length;j++) {
			bEnc = false
			var Txt = String(arrPrm[j])
			var arrCampo = Txt.split(",")
			//se buscan y aplican a el arreglo de llaves
			if( arrCampo[0] == "") {
				ParametroCambiaValor(String(arrCampo[1]),arrCampo[2])
			} else {
				if( arrCampo[1] == "") {
					sTmp = arrCampo[2]
				} else {
					sTmp = Parametro(String(arrCampo[1]),arrCampo[2])
				}		
				sTmp = 	DSITrim(sTmp)
				for (hi=0;hi<arrOcultos.length;hi++) {	
					if (arrOcultos[hi] == arrCampo[0]) {
						bEnc = true
						arrOValor[hi] = sTmp
						//arrOTipo[hi] = String(arrCampo[3])
					}
				}
				if (!bEnc) {
					MaxElemento++	
					arrOcultos[MaxElemento] = arrCampo[0]
					arrOPP[MaxElemento] = 0
					arrOValor[MaxElemento] = sTmp
					arrOTipo[MaxElemento] = String(arrCampo[3])
				}
			}
		}
	}
	
}

function PreparaCamposOcultosPP() {
	
	try {
		for (pco=0;pco<arrOcultos.length;pco++) {
			if (!EsVacio(arrOcultos[pco])) {
				if (arrOPP[pco] == 1) {
					sParametrosPermanentes += " <input type='hidden' name='" + arrOcultos[pco] + "' "
					sParametrosPermanentes += " id='" + arrOcultos[pco] + "' value='" + arrOValor[pco] + "' >"
				} 
			}
		}
	} catch(err) {
		AgregaDebug("Error en el cargado de Parametros permanentes","==========")
	}

}

function PreparaCamposOcultos() {
	
	try {
		for (pco=0;pco<arrOcultos.length;pco++) {
			if (!EsVacio(arrOcultos[pco])) {
				if (arrOPP[pco] != 1) {
					sVariablesOcultas += " <input type='hidden' name='" + arrOcultos[pco] 
					sVariablesOcultas += "' id='" + arrOcultos[pco] + "' value='" + arrOValor[pco] + "' >  "
				}
			}
		}
	} catch(err) {
		AgregaDebug("Error en el cargado de Parametros ocultos","==========")
	}

}

function fn_CargaEstilos(sRutaEstilos) {

	if (sRutaEstilos != "") {
		sCargaEstilos += "<link rel='stylesheet' type='text/css' href='" + sRutaEstilos + "' />"
	} 
					
}


function LimpiaLlaves(sLlaves) {

	var arrCampo  = new Array(0)
	var arrPrmCPP = new Array(0)

	if (!EsVacio(sLlaves) ) {
		arrPrmCPP = sLlaves.split("|")
		for (j=0;j<arrPrmCPP.length;j++) {
			var Txt = String(arrPrmCPP[j])
			var arrCampo = Txt.split(",")
			ParametroCambiaValor(arrCampo[0], arrCampo[1])
		}
	}

}

%>