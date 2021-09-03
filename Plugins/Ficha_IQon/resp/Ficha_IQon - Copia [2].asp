<!--#include file="../../Includes/iqon.asp" -->
<%
var iIQonDebug = 0  //IFAnidado(Parametro("IDUsuario",0) == 358,0,1)
/*if (Parametro("IDUsuario",0) == 358) {
	iIQonDebug = 1
}

if (iIQonDebug = 1) {
	Response.Write("iIQonDebug&nbsp;" + iIQonDebug + "&nbsp;IDUsuario&nbsp;" + IDUsuario +"<br />")
}
*/

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
	}
	
	return sRespuesta
}

function ComboSeccionFicha(NombreCombo,Eventos,Seccion,Seleccionado,Conexion,Todos,Orden,Modo) {
	var sElemento = ""
	var sResultado = ""

	if (Modo == "Editar") {
		//Resultado = "<select name='" + NombreCombo + "' id='" + NombreCombo + "' " + Eventos + " onChange='javascript:Cbo" + NombreCombo + "();'>"
		sResultado = "<select name='" + NombreCombo + "' id='" + NombreCombo + "' " + Eventos + "'>"
			if (Todos != "") {
				sElemento = "<option value='-1'"
				if (Seleccionado == -1) { sElemento += " selected " }
				sElemento += ">" + Todos + "</option>"
			}
		var CCSQL = "SELECT Cat_ID, Cat_Nombre FROM Catalogos WHERE Sec_ID = " + Seccion + " ORDER BY "
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
//			//sResultado += "<!--"
//			sResultado += "$(function() {"
//			//sResultado += "$('#" + NombreCombo + "').change(function() { Cbo" + NombreCombo + "(this.value()); });"
//			sResultado += "$('#" + NombreCombo + "').change(function() { alert('yijaaaa'); });"
//			sResultado += "});"
//			//sResultado += "//-->"
//			sResultado += "</script>"
					
	} else {
		var sCondicion = "  Sec_ID = " + Seccion + " and Cat_ID = " + Seleccionado
		sResultado = BuscaSoloUnDato("Cat_Nombre","Catalogos",sCondicion,"",Conexion)
	}
	
	return sResultado
	
}


function CargaComboFicha(NombreCombo,Eventos,CampoID,CampoDescripcion,Tabla,Condicion,Orden,Seleccionado,Conexion,Todos,Modo) {
	var sElemento = ""
	var sResultado = ""
	
	if (EsVacio(Seleccionado)) {Seleccionado = -1 }
	if (Modo == "Editar") {
		//sResultado = "<select name='"+NombreCombo+"' id='"+NombreCombo+"' " + Eventos + " onChange='javascript:Cbo" + NombreCombo + "();'>"
		sResultado = "<select name='"+NombreCombo+"' id='"+NombreCombo+"' " + Eventos + " '>"
			if (Todos != "") {
				sElemento = "<option value='-1'"
				if (Seleccionado == -1) { sElemento += " selected " }
				sElemento += ">" + Todos + "</option>"
			}
		var CCSQL = "SELECT " + CampoID +", " + CampoDescripcion + " FROM " + Tabla
		if (Condicion != "") { CCSQL += " WHERE " + Condicion }
		if (Orden != "") { CCSQL += " ORDER BY " + Orden }
		//Response.Write(CCSQL)
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
		}
		sResultado = sElemento
	}
	return sResultado
}
	
function CargaBotones() {
	var sBot = ""

	sBot = "<tr><td width=\"72%\" height=\"25\">&nbsp;</td><td width=\"28%\" align=\"right\">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
	if (Modo == "Editar") {
		sBot += "<input name=\"btnCancelar\" type=\"button\" class=\"Botones\" id=\"btnCancelar\" value=\"Cancelar\" onClick=\"javascript:AcFCancelar();\" >&nbsp;&nbsp;&nbsp;&nbsp;"
		sBot += "<input name=\"btnGuardar\" type=\"button\" class=\"Botones\" id=\"btnGuardar\" value=\"Guardar\" onClick=\"javascript:AcFGuardar();\" >"
	} else {
		sBot += "<input name=\"btnBorrar\" type=\"button\" class=\"Botones\" id=\"btnBorrar\" value=\"Borrar\" onClick=\"javascript:AcFBorrar();\">&nbsp;&nbsp;&nbsp;&nbsp;"
		sBot += "<input name=\"btnGuardar\" type=\"button\" class=\"Botones\" id=\"btnEditar\" value=\"Editar\" onClick=\"javascript:AcFEditar();\">&nbsp;&nbsp;&nbsp;&nbsp;"
		sBot += "<input name=\"btnNuevo\" type=\"button\" class=\"Botones\" id=\"btnNuevo\" value=\"Nuevo\" onClick=\"javascript:AcFNuevo();\">"
	}
    sBot += "</td></tr>"
	
	
	return sBot
}

function CargaDatos() {
	var sResultado = ""
	//comienza tabla de secciones  
		sResultado = "<table width=" + sC + "100%" + sC + " border=" + sC + "0" + sC + " align=" + sC + "left" + sC + " cellpadding=" + sC + "0" + sC + " cellspacing=" + sC + "0" + sC + " class=" + sC + "FichaCampoValor" + sC + ">"
			//aqui se cargan las secciones

		var sATCps = "SELECT * "
			sATCps += " FROM MenuFichaSeccion "
			sATCps += " WHERE MFS_Habilitado = 1 "
			sATCps += " AND Sys_ID = " + sysid
			sATCps += " AND WgCfg_ID = " + iWgCfgID
			//sATCps += " AND Mnu_ID = " + mnuid
			sATCps += " ORDER BY MFS_Orden "
			if (iIQonDebug == 1) {
				Response.Write("<font color='red' size='-2'><strong>Sección&nbsp;" + sATCps + "</strong></font><br />")
			}
		var rsSeccion = AbreTabla(sATCps,1,2)
		if (rsSeccion.EOF){ 
			return ""
		} 

		while (!rsSeccion.EOF){
			sResultado += "<tr><td height=" + sC + "25" + sC + " colspan=" + sC + "4" + sC + " class=" + sC 
			sResultado += rsSeccion.Fields.Item("MFS_Class").Value + sC + ">"
			sResultado += "" + rsSeccion.Fields.Item("MFS_Nombre").Value
			sResultado += "</td></tr>"

			var sFCHCps = "SELECT * "
			sFCHCps += " FROM MenuFichaCampos " 
			sFCHCps += " WHERE MFC_Habilitado = 1 "
			sFCHCps += " AND Sys_ID = " + rsSeccion.Fields.Item("Sys_ID").Value
			sFCHCps += " AND WgCfg_ID = " + rsSeccion.Fields.Item("WgCfg_ID").Value
			//sFCHCps += " AND Mnu_ID = " + rsSeccion.Fields.Item("Mnu_ID").Value
			sFCHCps += " AND MFS_ID = " + rsSeccion.Fields.Item("MFS_ID").Value
			sFCHCps += " AND MFC_EsOculto = 0 "
			sFCHCps += " AND MFC_EsPKPrincipal = 0 "
			sFCHCps += " AND MFC_EsPK = 0 "
			sFCHCps += " ORDER BY MFC_Renglon, MFC_Columna "
			if (iIQonDebug == 1) {
				Response.Write("<font color='red' size='-2'><strong>Campos&nbsp;" + sFCHCps + "</strong></font><br />")
			}
			//Leemos cuantas columnas constará la tabla
			var sCondMaxCol = " MFC_Habilitado = 1 AND Sys_ID = " + rsSeccion.Fields.Item("Sys_ID").Value
				sCondMaxCol += " AND Sys_ID = " + rsSeccion.Fields.Item("Sys_ID").Value
				sCondMaxCol += " AND WgCfg_ID = " + rsSeccion.Fields.Item("WgCfg_ID").Value
				sCondMaxCol += " AND MFS_ID = " + rsSeccion.Fields.Item("MFS_ID").Value
				sCondMaxCol += " AND MFC_EsOculto = 0 "
				sCondMaxCol += " AND MFC_EsPKPrincipal = 0 "
				sCondMaxCol += " AND MFC_EsPK = 0 "				
			var iMaxColumnas = BuscaSoloUnDato("MAX(MFC_Columna)","MenuFichaCampos",sCondMaxCol,1,2)
			if (iIQonDebug == 1) {
				Response.Write("<font color='red' size='-2'><strong>Etapa de prueba..iMaxColumnas&nbsp;"+ iMaxColumnas+"&nbsp;</strong></font><br />")
			}
			var iRen = 1
			var iCol = 1
			var iColumna = 1
			var sEtiqueta = ""
			var sCampo = ""
			var sNombreCampo = ""
			var sCampoLlave = ""
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
			
				var rsCampos = AbreTabla(sFCHCps,1,2)
				while (!rsCampos.EOF){
					if (iControl == 1) {
						sResultado += "<tr>"
					}
					if ( rsCampos.Fields.Item("MFC_Renglon").Value == iRen && rsCampos.Fields.Item("MFC_Columna").Value == iCol ) {
						sCampo = ""
						sEtiqueta = "" + rsCampos.Fields.Item("MFC_Etiqueta").Value
						iSoloLectura = rsCampos.Fields.Item("MFC_SoloLectura").Value
						var sModoRO = Modo
						if (iSoloLectura == 1) {
							sModoRO = "Consulta"
						}
						bEsInformativo = rsCampos.Fields.Item("MFC_Informativo").Value
						if (bEsInformativo == 1) {
							sModoRO = "Consulta"
						}
						if (rsCampos.Fields.Item("MFC_EditablePermanente").Value == 1) {
							sModoRO = "Editar"
						}
						sNombreCampo = "" + rsCampos.Fields.Item("MFC_Campo").Value
						sCampoLlave = "" + rsCampos.Fields.Item("MFC_ComboCampoLlave").Value
						if (EsVacio(sCampoLlave)) {
							sCampoLlave = sNombreCampo
						}
						sValorDefault = "" + rsCampos.Fields.Item("MFC_ValorDefault").Value
						sTabla = "" + rsCampos.Fields.Item("MFC_ComboTabla").Value
						sCampoDesc = "" + rsCampos.Fields.Item("MFC_ComboCampoDesc").Value
						sCondicion = "" + rsCampos.Fields.Item("MFC_ComboCondicion").Value
						sOrden = "" + rsCampos.Fields.Item("MFC_Orden").Value
						sLeyendaTodos = "" + rsCampos.Fields.Item("MFC_LeyendaSelecTodos").Value
						ValorDelCampo = Parametro( sNombreCampo , sValorDefault  )


						if (iIQonDebug == 1) { 
							Response.Write("<font color='red' size='-2'><strong>Modo&nbsp;" + Modo + "</strong></font>")
							Response.Write("<br><font color='red' size='-2'><strong>MFC_TipoCampo&nbsp;" + parseInt(rsCampos.Fields.Item("MFC_TipoCampo").Value) + "</strong></font>")
						}
						
						
						switch (parseInt(rsCampos.Fields.Item("MFC_TipoCampo").Value)) {
									case 1:						//			1 = text box
										if (sModoRO == "Editar") {
											sCampo = "&nbsp;<input name=" + sC +  sNombreCampo + sC 
											sCampo += " type=" + sC + "text" + sC + " class=" + sC + "FichaObjetos" + sC 
											sCampo +=  " id=" + sC +sNombreCampo + sC 
											sCampo += " style=" + sC + "width:90%" + sC + " value=" + sC 
											sCampo += ValorDelCampo + sC 
											sCampo += " maxlength=" + sC + "100" + sC 
											if (iSoloLectura == 1) {
												sCampo += " readonly=" + sC + "readonly" + sC + " "
											}
											sCampo += " >"
										} else {
											sCampo = "&nbsp;" + ValorDelCampo
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
									case 3:						//			3 = check
										var sCatalogoAUsarCampoDato = FiltraVacios(rsCampos.Fields.Item("MFC_CatalogoAUsarCampoDato").Value)
										var sTablaCatalogo = FiltraVacios(rsCampos.Fields.Item("MFC_CatalogoAUsar").Value)
										var sCatalogoAUsarCondicion = FiltraVacios(rsCampos.Fields.Item("MFC_CatalogoAUsarCondicion").Value)
										var Eventos = ""
										if (!EsVacio(rsCampos.Fields.Item("MFC_Class").Value)) {
											Eventos = "class='" +  rsCampos.Fields.Item("MFC_Class").Value + "'  "
										}
										if (!EsVacio(rsCampos.Fields.Item("MFC_EventosJS").Value)) {
											Eventos += "  " +  rsCampos.Fields.Item("MFC_EventosJS").Value 
										}									
										if (sModoRO == "Editar") {
											//NombreCombo,Eventos,CampoID,CampoDescripcion,Tabla,Condicion,Orden,Seleccionado,Conexion,Todos,Modo
											sCampo = "&nbsp;" + CargaComboFicha(sNombreCampo,Eventos,sNombreCampo,
																sCatalogoAUsarCampoDato,sTablaCatalogo,sCatalogoAUsarCondicion,
																sNombreCampo,ValorDelCampo,0,"Seleccione una opción",sModoRO)
										} else { 
											sCampo = "&nbsp;" + CargaComboFicha(sNombreCampo,Eventos,sNombreCampo,
																sCatalogoAUsarCampoDato,sTablaCatalogo,sCatalogoAUsarCondicion,
																sNombreCampo,ValorDelCampo,0,"Sin seleccion",sModoRO)
										}
										break;
									case 4:  // 4 = combo
										var sEventos = " class='FichaObjetos' " 
										if (!EsVacio(rsCampos.Fields.Item("MFC_EventosJS").Value)) {
											sEventos +=  " " + rsCampos.Fields.Item("MFC_EventosJS").Value + " "
										}
										var sCampoDescripcion = rsCampos.Fields.Item("MFC_ComboCampoDesc").Value
										var sTabla  = rsCampos.Fields.Item("MFC_ComboTabla").Value
										var sCondicion = "" //" Sys_ID = " + Parametro("Sys_ID",1)
										if (!EsVacio(rsCampos.Fields.Item("MFC_ComboCondicion").Value)) {
											//sCondicion +=  " AND " + rsCampos.Fields.Item("MFC_ComboCondicion").Value + " "
											sCondicion +=  " " + rsCampos.Fields.Item("MFC_ComboCondicion").Value + " "
										}
										var sOrden = ""
										if (!EsVacio(rsCampos.Fields.Item("MFC_Orden").Value)) {
											sOrden =  " " + rsCampos.Fields.Item("MFC_Orden").Value + " "
										}
										var sTodos = "Seleccione una opción"
										if (!EsVacio(rsCampos.Fields.Item("MFC_LeyendaSelecTodos").Value)) {
											sTodos = rsCampos.Fields.Item("MFC_LeyendaSelecTodos").Value
										}								
										sCampo = "&nbsp;" +CargaComboFicha(sNombreCampo,sEventos,sCampoLlave,sCampoDescripcion,sTabla,sCondicion,sOrden,ValorDelCampo,0,sTodos,sModoRO) 
										break;	
									case 5:						//			5 = caja seleccion
										var Eventos = ""
										if (!EsVacio(rsCampos.Fields.Item("MFC_Class").Value)) {
											Eventos = "class='" + rsCampos.Fields.Item("MFC_Class").Value + "'  "
										}									
										sCampo = "&nbsp;" + CajaSeleccion(sNombreCampo,Eventos,Parametro(sNombreCampo,1),1,sModoRO)
										break;
									case 6:						//			6 = fecha
										if (sModoRO == "Editar") {
											sCampo = "<script type=" + sC + "text/javascript" + sC + ">"
												sCampo += "	$(function() {"
													sCampo += "	$( " + sC +	"#" + sNombreCampo + sC + " ).datepicker({"
													sCampo += "	showOn:	" + sC + "button" + sC + ","  
													sCampo += "	buttonImage:" + sC + "/images/calendar.png" + sC + "," 		
													sCampo += " buttonImageOnly: true "
													sCampo += "});"
												sCampo += "});"
											sCampo += "</script>"  
											sCampo += "&nbsp;<input name=" + sC + sNombreCampo + sC + " type=" + sC + "text" + sC + " class=" + sC + "FichaObjetos" + sC + " id=" + sC + sNombreCampo + sC  + " value=" + sC
											//sCampo += CambiaFormatoFecha(Parametro(sNombreCampo,""),"yyyy-mm-dd","dd/mm/yyyy") 
											//sCampo += FormatoFecha(Parametro(sNombreCampo,"") ,"UTC a dd/mm/yyyy")
											if (ValorDelCampo != "") {
												var stfc6 = FormatoFechaII( ValorDelCampo,"yyyy-mm-dd","Guardar")
												if (stfc6 != "01/01/1900") { sCampo += stfc6 }
											} 
											sCampo += sC +" size=" + sC + "20" + sC + " maxlength=" + sC + "20" + sC + " />&nbsp;"
											//sCampo = ""
										} else { 
											//sCampo = "&nbsp;" + CambiaFormatoFecha(Parametro(sNombreCampo,""),"yyyy-mm-dd","dd/mm/yyyy") 
											//sCampo = "&nbsp;" + FormatoFecha(Parametro(sNombreCampo,"") ,"UTC a dd/mm/yyyy")
											//Formato en que los va a presentar
											sCampo = ""
											if (ValorDelCampo != "") {
												var stfc6 = FormatoFechaII( ValorDelCampo,"yyyy-mm-dd","Guardar")
												if (stfc6 != "01/01/1900") { sCampo += stfc6 }
											} 
										}
										break;
									case 7:    // 7 = combo catalogo general
										var sEventos = " class='FichaObjetos' "
										if (!EsVacio(rsCampos.Fields.Item("MFC_EventosJS").Value)) {
											sEventos +=  " " + rsCampos.Fields.Item("MFC_EventosJS").Value + " "
										}
										var sCampoDescripcion = rsCampos.Fields.Item("MFC_ComboCampoDesc").Value
										var sTabla  = rsCampos.Fields.Item("MFC_ComboTabla").Value
										var sCondicion = ""  // "Sys_ID = " + Parametro("Sys_ID",1)
										if (!EsVacio(rsCampos.Fields.Item("MFC_ComboCondicion").Value)) {
											sCondicion +=  " " + rsCampos.Fields.Item("MFC_ComboCondicion").Value + " "
										}
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
										sCampo = "&nbsp;" + ComboSeccionFicha(sNombreCampo,sEventos,sSeccion,ValorDelCampo,0,sTodos,sOrden,sModoRO)
										break;
									case 8:						//			8 = password
										if (sModoRO == "Editar") {
											sCampo = "&nbsp;<input type=" + sC + "password" + sC 
											sCampo += " name=" + sC +  sNombreCampo + sC 
											sCampo += " type=" + sC + "text" + sC + " class=" + sC + "FichaObjetos" + sC 
											sCampo +=  " id=" + sC +sNombreCampo + sC 
											sCampo += " style=" + sC + "width:90%" + sC + " value=" + sC 
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
											sCampo = "&nbsp;<textarea name=" + sC +  sNombreCampo + sC
											sCampo +=  " class='textnormal' id=" + sC + sNombreCampo + sC 
											sCampo += " cols = " + sC + " 45 " + sC + " rows=" + sC + " 5 " + sC + ">"
											sCampo += ValorDelCampo
											sCampo += " </textarea>"
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
												//MFC_Campo --nvarchar	
												if (!EsVacio(rsCampos.Fields.Item("MFC_Campo").Value)) {
													sSQLStringSubFIC += rsCampos.Fields.Item("MFC_Campo").Value
												}
												if (!EsVacio(rsCampos.Fields.Item("MFC_ComboTabla").Value)) {
													sSQLStringSubFIC += " FROM "
													sSQLStringSubFIC += rsCampos.Fields.Item("MFC_ComboTabla").Value
												}
												
												if (!EsVacio(rsCampos.Fields.Item("MFC_ComboCondicion").Value)) {
													sSQLStringSubFIC += " WHERE " 
													sSQLStringSubFIC += rsCampos.Fields.Item("MFC_ComboCondicion").Value + " = "
													sSQLStringSubFIC += Parametro(rsCampos.Fields.Item("MFC_ComboCondicion").Value,"")
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
									
											sCampo = "&nbsp;" + Parametro(rsCampos.Fields.Item("MFC_Campo").Value,rsCampos.Fields.Item("MFC_ValorDefault").Value)
										break;
									case 15:	//		15 = 	Fecha en texto y su campo juliano
										if (sModoRO == "Editar") {
											sCampo = "<script type=" + sC + "text/javascript" + sC + ">"
												sCampo += "	$(function() {"
													sCampo += "	$( " + sC +	"#" + sNombreCampo + sC + " ).datepicker({"
													sCampo += "	showOn:	" + sC + "button" + sC + ","  
													sCampo += "	buttonImage:" + sC + "/images/calendar.png" + sC + "," 		
													sCampo += " buttonImageOnly: true "
													sCampo += "});"
												sCampo += "});"
											sCampo += "</script>"  
											sCampo += "&nbsp;<input name=" + sC + sNombreCampo + sC + " type=" + sC + "text" + sC + " class=" + sC + "FichaObjetos" + sC + " id=" + sC + sNombreCampo + sC  + " value=" + sC
											sCampo += ValorDelCampo
											sCampo += sC +" size=" + sC + "20" + sC + " maxlength=" + sC + "20" + sC + " />&nbsp;"
											//sCampo = ""
										} else { 
											//sCampo = "&nbsp;" + CambiaFormatoFecha(Parametro(sNombreCampo,""),"yyyy-mm-dd","dd/mm/yyyy") 
											//sCampo = "&nbsp;" + FormatoFecha(Parametro(sNombreCampo,"") ,"UTC a dd/mm/yyyy")
											//Formato en que los va a presentar
											sCampo = ValorDelCampo
										}
										break;
									default:	//			1 = text box
										if (sModoRO == "Editar") {
													sCampo = "&nbsp;<input name=" + sC +  sNombreCampo + sC 
													sCampo += " type=" + sC + "text" + sC + " class=" + sC + "FichaObjetos" + sC 
													sCampo +=  " id=" + sC + sNombreCampo + sC 
													sCampo += " style=" + sC + "width:90%" + sC + " value=" + sC 
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
					} else {
						ValorDelCampo=""
						sEtiqueta  = "&nbsp;"
						sCampo = "&nbsp;"
						bUsado = false
						iVueltas++
					}
					
					sResultado += "<td width=" + sC + "20%" + sC + " height=" + sC + "18" + sC + " class=" + sC + "FichaCampoTitulo" + sC + ">"
					sResultado += sEtiqueta
					sResultado += "</td>"
					
					sResultado += "<td width=" + sC + "30%" + sC + " class=" + sC + "FichaCampoValor" + sC + ">"
					sResultado += sCampo
					sResultado += "</td>"
					
						
					if (iControl == 2) {
					//if (iControl == iMaxColumnas) {
						sResultado += "</tr>"
						iRen++
						iCol = 1
						iControl = 1
					} else if (iControl == 1) { 
								iControl = 2 
								iCol = 2
					 		}
							
					if (bUsado == true) { 
						rsCampos.MoveNext()
					}
					if (iVueltas > 5) { return "Error al colocar el campo, revise las posiciones de columnas y renglones" }
				}			
				rsCampos.Close()			
			//Cierre de la seccion
			sResultado += "<tr><td colspan=" + sC + "2" + sC + ">&nbsp;</td></tr>"
	
			rsSeccion.MoveNext()
		}	
		rsSeccion.Close()	
		//Cierre de la tabla de secciones y campos
		sResultado += "</table>"


		
	//este es el cierre de la seccion de botones	
	
		return sResultado
}

function ImprimeOcultos() {

	var sCamposOcultos = ""
	
		//para cargar al final los campos ocultos
	var sFCOcultos = "SELECT * "
		sFCOcultos += " ,ISNULL((Select PP_Nombre "
		sFCOcultos +=           "  from ParametrosPermanentes "
		sFCOcultos +=           " where ParametrosPermanentes.PP_Nombre = MenuFichaCampos.MFC_Campo "
		sFCOcultos +=           "   and Sys_ID = " +  sysid 
		sFCOcultos +=           "   and PP_Habilitado = 1),'No') as PP "  //mapeo los campos contra los parametros permanentes
		sFCOcultos += " FROM MenuFichaCampos "
		sFCOcultos += " WHERE MFC_Habilitado = 1 "
		sFCOcultos += "  AND Sys_ID = " + sysid
		sFCOcultos += " AND WgCfg_ID = " + iWgCfgID
		//sFCOcultos += "  AND Mnu_ID = " + mnuid
		sFCOcultos += "  AND MFC_EsOculto = 1 "
		if (iIQonDebug == 1) {
			Response.Write("<font color='red' size='-2'><strong>Campos_Ocultos&nbsp;" + sFCOcultos + "</strong></font><br />")
		}
	var rsOcultos = AbreTabla(sFCOcultos,1,2)

	while (!rsOcultos.EOF){
		sNombreCampo = "" + rsOcultos.Fields.Item("MFC_Campo").Value
		sValorDefault = "" + rsOcultos.Fields.Item("MFC_ValorDefault").Value
		ValorDelCampo = Parametro( sNombreCampo , sValorDefault  )
		if (EsVacio(ValorDelCampo))  { ValorDelCampo = -1 }
		if (rsOcultos.Fields.Item("PP").Value == "No" ) {
			sCamposOcultos += " <input type=" + sC + "hidden" + sC + " name=" + sC + sNombreCampo + sC + " id=" + sC + sNombreCampo + sC +" value=" + sC + ValorDelCampo + sC + "> "
		}	
		rsOcultos.MoveNext()
	}	

	rsOcultos.Close()
	
	sCamposOcultos += " <input type=" + sC + "hidden" + sC + " name=" + sC + "GFINSRT" + sC + " id=" + sC + "GFINSRT" + sC +" value=" + sC + GFINSRT + sC + "> "
	sCamposOcultos += " <input type=" + sC + "hidden" + sC + " name=" + sC + "iWgCfgID" + sC + " id=" + sC + "iWgCfgID" + sC +" value=" + sC + iWgCfgID + sC + "> "
	return sCamposOcultos
			
}


function ArmaMarco() {

	var sG = ""
	var sWH9 = " width=" + sC + "9" + sC + " height=" + sC + "9" + sC +" "
	var sAL = " align=" + sC + "left" + sC + " "
	var sAC = " align=" + sC + "center" + sC + " "
	var sPadding = "style=" + sC + "padding-right: 1px;padding-left: 1px;" + sC + " "
	var sIniciaTabla = "<table width=" + sC + "100%" + sC + " border=" + sC + "0" + sC + " cellspacing=" + sC + "0" + sC + " cellpadding=" + sC + "0" + sC + " "
	
	sG =  sIniciaTabla +">"
	sG += "<tr><td width=" + sC + "1%" + sC + " >&nbsp;</td><td width=" + sC + "99%" + sC + "><tr>"
	sG += "<td class=" + sC + "FichaBorde" + sC + ">&nbsp;</td><td>"
		
	sG += "<table  class=" + sC + "TbRedondeada" + sC + " width=" + sC + "100%" + sC + " border=" + sC + "0" + sC + " cellspacing=" + sC + "0" + sC + " cellpadding=" + sC + "0" + sC + ">"
	sG += "<tr><td width=" + sC + "9" + sC + " align=" + sC + "left" + sC + " valign=" + sC + "top" + sC + "></td>"
	sG += "<td ></td>"
	sG += "<td width=" + sC + "9" + sC + " align=" + sC + "right" + sC + " valign=" + sC + "top" + sC + "></td></tr>"
	sG += "<tr><td " + sAL + " ></td>"
	sG += "<td " + sAL + " valign=" + sC + "top" + sC + ">" + sIniciaTabla + ">" 
	sG += "<tr><td width=" + sC + "15" + sC + " " + sAC + " " + sC + " " + sPadding + "></td>"
	sG += "<td width=" + sC + "98%" + sC + " " + sAC + " valign=" + sC + "top" + sC + " >"
	
	sG += "<table width=" + sC + "100%" + sC + " border=" + sC + "0" + sC + " cellspacing=" + sC + "2" + sC + " cellpadding=" + sC + "1" + sC + ">" 
	sG += CargaBotones()
	
	if (Mensaje != ""){ 
		sG += "<tr><td height=\"25\" colspan=\"2\">"
		sG += "<div class=\"ui-widget\">"
		sG += "<div class=\"ui-state-highlight ui-corner-all\" style=\"margin-top: 20px; padding: 0 .7em;\"> "
		sG += "<p><span class=\"ui-icon ui-icon-info\" style=\"float: left; margin-right: .3em;\"></span>"
		sG += "<strong>Aviso</strong> " + Mensaje
		sG += "</p></div></div>"
		Mensaje = ""
	//	sG += "<br/><div class=\"ui-widget\">"
	//	sG += "<div class=\"ui-state-error ui-corner-all\" style=\"padding: 0 .7em;\"> "
	//	sG += "<p><span class=\"ui-icon ui-icon-alert\" style=\"float: left; margin-right: .3em;\"></span> "
	//	sG += "<strong>Alert:</strong> Sample ui-state-error style."
	//	sG += "</p></div></div>"
		//var fch = new Date()
		//sG += "El VPV = " + VPV + " El modo entro como " + Parametro("Modo","modovacio") + "  la accion entro como " + Parametro("Accion","accionvacio") + " " + fch
		sG += "</td></tr>"		
	}	
	
	sG += "<tr><td height=\"25\" colspan=\"2\">"
	sG += CargaDatos()
	
	sG += "</td></tr>"

	sG +=  "</table>"
	sG += "</td><td width=" + sC + "15" + sC + " " + sAC + " class=" + sC + "padding4" + sC + " " + sPadding + "></td></tr></table></td>"
	sG += "<td align=" + sC + "right" + sC + " ></td>"
	sG += "</tr><tr><td " + sAL + " valign=" + sC + "bottom" + sC + "></td>"
	sG += "<td ></td>"
	sG += "<td align=" + sC + "right" + sC + " valign=" + sC + "bottom" + sC + "></td>"
	sG += "</tr></table>"
	
	sG += "</td><td width=" + sC + "0%" + sC + " align=" + sC + "right" + sC + " class=" + sC + "FichaBorde" + sC + ">&nbsp;</td></tr></table>"

	return sG

}

//  -------------------------------------------------------
	var iCamposLL = -1    
	var bLlavesVacias = true
	var acnCOnt = -1               
	var arrCMPNMBInsertar    = new Array(0)
	var CampoNombre    = new Array(0)
	var CampoPP        = new Array(0)
	var CampoLLave     = new Array(0)
	var CampoLLavePK   = new Array(0)
	var CampoValor     = new Array(0)
	var CampoFormato   = new Array(0)
	var CampoCondicion = new Array(0)
	var CampoOculto    = new Array(0)

if (!bHayParametros) { 	
	LeerParametrosdeBD() 
}


var sC = String.fromCharCode(34)
var Accion = Parametro("Accion","Consulta")
var Modo = Parametro("Modo","Consulta")
var Mensaje = ""

var SistemaActual = Parametro("SistemaActual",0)
var VentanaIndex  = Parametro("VentanaIndex",0)
var IDUsuario     = Parametro("IDUsuario",0)
var iWgCfgID      = Parametro("iWgCfgID",0)


IniciaDebugBD()

var sTabla = ""
var SQLCondicion = ""
var sOrdenadoPor = ""
var	sMFC_SinPK_Ir_A = 0
var sMFC_MensajeError = ""
var iSQLVieneDeBuscador = 0
var sCondicionPorParametro = ""  //   para arreglo de condiciones posicion: 1= campo 2=nombreparametreo 3,ValorDefault separado por comas y pipes
								//    ejemplos; Cli_ID,Cli_ID,-1|Cont_ID,Cont_ID,-1|Dir1_ID,Cli_ID,-1 este ultimo transfiero a dir1 el valor de cliid		
									
var sysid = Parametro("SistemaActual",0)
var mnuid = Parametro("VentanaIndex",0)

if (iIQonDebug == 1) {	Response.Write("<br /><font color='red' size='-2'><strong>Accion&nbsp;" + Accion + "&nbsp;Modo&nbsp;" + Modo  + "</strong></font>")}
	var sFCHTabla = "SELECT * "
		sFCHTabla += " FROM MenuFichaTabla "
		sFCHTabla += " WHERE Sys_ID = " + sysid
		sFCHTabla += " AND WgCfg_ID = " + iWgCfgID
		//sFCHTabla += " AND Mnu_ID = " + mnuid
		sFCHTabla += " AND MFS_ID = 1 "  //campo experimental para poner una tabla diferente por seccion, ahora solo funciona un solo registro por menu
if (iIQonDebug == 1) {	Response.Write("<br /><font color='red' size='-2'><strong>sql&nbsp;" + sFCHTabla +  "</strong></font>")}
	var rsTabla = AbreTabla(sFCHTabla,1,2) 
	if (!rsTabla.EOF) {	
		sTabla = rsTabla.Fields.Item("MFC_Tabla").Value
		SQLCondicion = FiltraVacios(rsTabla.Fields.Item("MFC_CondicionGeneral").Value)
		sOrdenadoPor = FiltraVacios(rsTabla.Fields.Item("MFC_OrdenadoPor").Value)
		sCondicionPorParametro = FiltraVacios(rsTabla.Fields.Item("MFC_CondicionPorParametro").Value)
		iSQLVieneDeBuscador = rsTabla.Fields.Item("MFC_VieneDeBuscador").Value
		sMFC_SinPK_Ir_A = FiltraVacios(rsTabla.Fields.Item("MFC_SinPK_Ir_A").Value)
		sMFC_MensajeError = FiltraVacios(rsTabla.Fields.Item("MFC_MensajeError").Value)

		var VPV = 0
//		var VPV = Parametro("VeZ",0)
//		if (Parametro("VeZ",0) == 0) {
//			Accion = rsTabla.Fields.Item("MFC_AccionEntrada").Value
//			Modo = rsTabla.Fields.Item("MFC_ModoEntrada").Value
//		}
	}	
	rsTabla.Close()	

	var sLLavePrimaria = ""
	var sLLavePrimariaCampo = ""
	var sLLavePrimariaValor = -1
	var sLLavePrimariaHeredada = ""
	var GFINSRT = Parametro("GFINSRT",0)  //gravacion forzada hacer insert
	
//	var iPos = 0
//	var iPosO = 0
	
	var sFCHCampos = "SELECT * "
		sFCHCampos += " ,ISNULL((Select PP_Nombre "
		sFCHCampos +=           "  from ParametrosPermanentes "
		sFCHCampos +=           " where ParametrosPermanentes.PP_Nombre = MenuFichaCampos.MFC_Campo "
		sFCHCampos +=           "   and Sys_ID = " +  sysid 
		sFCHCampos +=           "   and PP_Habilitado = 1),'No') as PP "  //mapeo los campos contra los parametros permanentes
		sFCHCampos += " FROM MenuFichaCampos "
		sFCHCampos += " WHERE MFC_Habilitado = 1 "
		sFCHCampos += " AND MFC_Informativo = 0 "
		sFCHCampos += " AND Sys_ID = " + sysid
		sFCHCampos += " AND WgCfg_ID = " + iWgCfgID
		//sFCHCampos += " AND Mnu_ID = " + mnuid
	
if (iIQonDebug == 1) {	Response.Write("<br /><font color='red' size='-2'><strong>sFCHCampos&nbsp;" + sFCHCampos + "</strong></font><br />") }

	var rsCampos = AbreTabla(sFCHCampos,1,2) 
	while (!rsCampos.EOF){	
		iCamposLL++           
		CampoNombre[iCamposLL]     = rsCampos.Fields.Item("MFC_Campo").Value
		CampoPP[iCamposLL]         = rsCampos.Fields.Item("PP").Value
		CampoLLave[iCamposLL]      = rsCampos.Fields.Item("MFC_EsPK").Value
		CampoLLavePK[iCamposLL]    = rsCampos.Fields.Item("MFC_EsPKPrincipal").Value
		var sTmpDF = FiltraVacios(rsCampos.Fields.Item("MFC_ValorDefault").Value)	
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
	
if (iIQonDebug == 1) {	Response.Write("<br /><font color='red' size='-2'><strong>sCondicionPorParametro&nbsp;" + sCondicionPorParametro + "</strong></font><br />") }		

	if (!EsVacio(sCondicionPorParametro) ) {
		arrPrmCPP = sCondicionPorParametro.split("|")
		for (j=0;j<arrPrmCPP.length;j++) {
			bEnc = false
			var Txt = String(arrPrmCPP[j])
			var arrCampo = Txt.split(",")
			for (fi=0;fi<CampoNombre.length;fi++) {
				if (iIQonDebug == 1) {	Response.Write("<br />campo " + fi + ") campo_nombre&nbsp;" + CampoNombre[fi] + "<br />") }
				if (CampoNombre[fi] == arrCampo[0]) {			
					bEnc = true
					CampoCondicion[fi] = 1
					var sValTmp = Parametro(String(arrCampo[1]),String(arrCampo[2]))    		
					CampoValor[fi] = String(sValTmp)
					CampoFormato[fi] = String(arrCampo[3])
					if (iIQonDebug == 1) {	Response.Write("<br /><font color='red' size='-2'><strong>encontrado en " + fi + ") CampoNombre&nbsp;" + CampoNombre[fi] + " con valor de " + CampoValor[fi] + " es llave " + CampoLLave[fi] +"</strong></font><br />") }
				}
			}
			if (!bEnc) {
				iCamposLL++
				CampoNombre[iCamposLL]    = arrCampo[0]
				CampoCondicion[iCamposLL] = 1
				CampoPP[iCamposLL]        = 0
				CampoLLave[iCamposLL]     = 0
				CampoLLavePK[iCamposLL]   = 0
				CampoValor[iCamposLL]     = Parametro(String(arrCampo[1]),String(arrCampo[2]))
				CampoFormato[iCamposLL]   = arrCampo[3]	
				if (iIQonDebug == 1) {
				
				Response.Write("<br /><font color='red' size='-2'><strong>no encontrado&nbsp;" + iCamposLL + ") CampoNombre&nbsp;" + CampoNombre[iCamposLL]+"</strong></font><br />")
				
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
				iContPK++
			}
			
			if (CampoLLavePK[i] == 0 && CampoLLave[i] == 1) {
		        if (!EsVacio(CampoValor[i]) && CampoValor[i] != "-1") {		
				    if (sLLavePrimariaHeredada != "" ) { sLLavePrimariaHeredada += " AND " }
					sLLavePrimariaHeredada += " " +  CampoNombre[i] + " = " + CampoValor[i] + " "
					bLlavesVacias = false
					iContLL++
				} else {
					//aviso para el programador
					Response.Write("Las llaves complementarias vienen vacias, revisar que las llaves no primarias tengan datos")
					ImprimeParametros()
						var sErrMsg  = "<p id=\"MsgBoxTitulo\"><strong>Error:</strong></p>"
	
					sErrMsg += "<p>" + sMFC_MensajeError + "<br><br>"
					sErrMsg += "Ocurrio un error avise al administrador del sistema, Codigo de error " + VentanaIndex +"</p>"
				var sError = ""
					sError += "<script language=\"JavaScript\">"
					sError += "$(function() {$.msgbox('" + sErrMsg + "', {type: 'error'});});"
					sError += "</script>"
					Response.Write( sError )
		
					Response.End()
				}				
			}
	
		//pendiente falta poner el tipo de dato N=numero F=fecha T=texto para clavarle unas comillas o el formato de fecha
	}
	if (iContLL == 0 && iContPK > 0) { bLlavesVacias = false } 

	if (EsVacio(SQLCondicion)) { SQLCondicion = "" }
	if (SQLCondicion != "" && sLLavePrimariaHeredada != "") { SQLCondicion += " AND " }
	SQLCondicion += sLLavePrimariaHeredada
	
	if (iIQonDebug == 1) {	Response.Write("<br /><font color='red' size='-2'><strong>SQLCondicion&nbsp;=" + SQLCondicion+"</strong></font><br />") }
	if (iIQonDebug == 1) {	Response.Write("<br /><font color='red' size='-2'><strong>sLLavePrimaria&nbsp;=" + sLLavePrimaria + "</strong></font><br />") }

	var sCondCamp = SQLCondicion 
	if (sCondCamp != "" && sLLavePrimaria != "") { sCondCamp += " AND " }
	sCondCamp += sLLavePrimaria
	sCondCamp = " WHERE " + sCondCamp
	
var bRecienGuardado = false

if(Modo != "Vuelta" ) {	

	if (Accion == "Guardar") {
	AgregaDebugBD("entre guardando accion = ",Accion )
		bRecienGuardado = true
		//bParametrosDeAjaxaUTF8=true
		AgregaDebugBD("GFINSRT = ",GFINSRT )
		if (GFINSRT == 1) {
			BDInsert(CampoNombre,sTabla,"",0)
			//BDInsert(arrCMPNMBInsertar,sTabla,"",0)
			ParametroCambiaValor("GFINSRT",0)
		} else {
			AgregaDebugBD("sLLavePrimariaCampo = ",sLLavePrimariaCampo )
			AgregaDebugBD("sLLavePrimariaValor = ",sLLavePrimariaValor )
			if (Parametro(sLLavePrimariaCampo,sLLavePrimariaValor) == -1) {  
				//if (Session("Agregar") == 1) {
					AgregaDebugBD("agregando = ","" )
					LlaveABuscar = SiguienteID(sLLavePrimariaCampo,sTabla, SQLCondicion ,0)
					ParametroCambiaValor(sLLavePrimariaCampo, LlaveABuscar)
					BDInsert(CampoNombre,sTabla,"",0)
					//BDInsert(arrCMPNMBInsertar,sTabla,"",0)
					sLLavePrimaria = sLLavePrimariaCampo + " = " + LlaveABuscar
				//}
			} else { 
			AgregaDebugBD("editando = ","" )
				//if (Session("Editar") == 1) { 
					//BDUpdate(arrCMPNMBInsertar,sTabla,sCondCamp,0)
					BDUpdate(CampoNombre,sTabla,sCondCamp,0)
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
		sOtroQry += " AND Sys_ID = " + sysid
		sOtroQry += " AND WgCfg_ID = " + iWgCfgID
		//sOtroQry += " AND Mnu_ID = " + mnuid
		sOtroQry += " Order By MFQ_Orden"
	if (iIQonDebug == 1) {
		Response.Write("<font color='red'><strong>CargadodeDatosviasentenciasSQL&nbsp;" + sOtroQry + "</strong></font><br />")
	}	
	var rsOtroQry = AbreTabla(sOtroQry,1,2) 
	while (!rsOtroQry.EOF){	
		var MFQ_Query = rsOtroQry.Fields.Item("MFQ_Query").Value
		var MFQ_Condicion = rsOtroQry.Fields.Item("MFQ_Condicion").Value
		var MFQ_Parametros = rsOtroQry.Fields.Item("MFQ_Parametros").Value

		if (!EsVacio(MFQ_Parametros) ) {  		              //se extraen los parametros que se envian
			arrOQPP = MFQ_Parametros.split("|")
			for (i=0;i<arrOQPP.length;i++) {	
				var Txt = String(arrOQPP[i])
				var arrCampo = Txt.split(",")
				//pendiente falta poner el tipo de dato N=numero F=fecha T=texto para clavarle unas comillas o el formato de fecha
							  //   N
				var tA = ""
				var tB = ""
				if (arrCampo[3] == "T") {
					var tA = "'"
					var tB = "'"
				}
				var sTmpPP = Parametro(String(arrCampo[1]),String(arrCampo[2]))
				if (sTmpPP != "" && sTmpPP != -1 ) {
					if (MFQ_Condicion != "") { MFQ_Condicion += " AND " }				
					MFQ_Condicion += " " + arrCampo[0] + " = " + tA + "" + sTmpPP + tB
				}
			}
		}
		if (MFQ_Condicion != "") {
				MFQ_Query += " WHERE " + MFQ_Condicion
		} 			
			
		bHayParametros = false
		ParametroCargaDeSQL(MFQ_Query,0)
		rsOtroQry.MoveNext()
	}	
	rsOtroQry.Close()

//Carga la informacion que contendran los objetos
var sConsultaSQL = "SELECT * "
	sConsultaSQL += " FROM " + sTabla
	sConsultaSQL += " WHERE " + sLLavePrimaria
	
	if (SQLCondicion != "" ) { sConsultaSQL += " AND " }
	sConsultaSQL += SQLCondicion
		if (iIQonDebug == 1) {	Response.Write("<br /><font color='red'><strong>sTabla&nbsp;" + sTabla + "</strong></font><br />")	 
		    Response.Write("<font color='red'><strong>sLLavePrimaria&nbsp;" + sLLavePrimaria + "</strong></font><br />")
			Response.Write("<font color='red'><strong>SQLCondicion&nbsp;" + SQLCondicion + "</strong></font><br />")	
			}
		

	if (iIQonDebug == 1) {	Response.Write("<font color='red'><strong>Tabla_A_Manejar&nbsp;" + sConsultaSQL + "</strong></font><br />")	}
	
		//AgregaDebugBD("sql ficha carga inicial",sConsultaSQL )
		bHayParametros = false
		ParametroCargaDeSQL(sConsultaSQL,0)
		
}
GFINSRT = 0
ParametroCambiaValor("GFINSRT", 0)

if (Parametro(sLLavePrimariaCampo,sLLavePrimariaValor) == -1) {
		var Modo = "Editar"
		var Accion =  "Consulta"
		ParametroCambiaValor("Modo", Modo)
		ParametroCambiaValor("Accion", Accion)  //forza a nuevo 

} else {
//	Valido si el registro existe de lo contrario cambio a modo nuevo
	if (Accion != "Vuelta" && !bRecienGuardado) {
		var sSQLCondYE = "" + sLLavePrimaria
		if (sLLavePrimariaHeredada != "" ) { sSQLCondYE += " AND " }
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
		}
	}
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
	Response.Write(ArmaMarco())
	var campocul = ImprimeOcultos()
	Response.Write("<br> " + campocul)
}
%>