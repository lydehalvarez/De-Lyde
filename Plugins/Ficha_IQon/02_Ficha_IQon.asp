<!--#include file="../../Includes/iqon.asp" -->
<%

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
var Txt =""

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
		sResultado = "<select name='" + NombreCombo + "' " + Eventos + " >"
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
	} else {
		var sCondicion = "  Sec_ID = " + Seccion + " and Cat_ID = " + Seleccionado
		sElemento = BuscaSoloUnDato("Cat_Nombre","Catalogos",sCondicion,"",Conexion)
		sResultado = sElemento
	}
	
	return sResultado
	
}


function CargaComboFicha(NombreCombo,Eventos,CampoID,CampoDescripcion,Tabla,Condicion,Orden,Seleccionado,Conexion,Todos,Modo) {
	var sElemento = ""
	var sResultado = ""
	
	if (EsVacio(Seleccionado)) {Seleccionado = -1 }
	
	if (Modo == "Editar") {
		sResultado = "<select name='"+NombreCombo+"' id='"+NombreCombo+"' " + Eventos +" >"
			if (Todos != "") {
				sElemento = "<option value='-1'"
				if (Seleccionado == -1) { sElemento += " selected " }
				sElemento += ">" + Todos + "</option>"
			}
		var CCSQL = "Select " + CampoID +", " + CampoDescripcion + " FROM " + Tabla
		if (Condicion != "") { CCSQL += " Where " + Condicion }
		if (Orden != "") { CCSQL += " Order By " + Orden }
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
		sBot += "<input name=\"btnGuardar\" type=\"button\" class=\"Botones\" id=\"btnEditar\" value=\"Editar\" onClick=\"javascript:AcFEditar();\">"
	}
    sBot += "</td></tr>"
	
	
	return sBot
}

function CargaDatos() {
	var sResultado = ""
//comienza tabla de secciones  
		sResultado = "<table width=" + sC + "100%" + sC + " border=" + sC + "0" + sC + " align=" + sC + "left" + sC + " cellpadding=" + sC + "0" + sC + " cellspacing=" + sC + "0" + sC + " class=" + sC + "FichaCampoValor" + sC + "> "
			//aqui se cargan las secciones

		var sATCps = "SELECT * "
			sATCps += " FROM MenuFichaSeccion "
			sATCps += " WHERE MFS_Habilitado = 1 "
			sATCps += " AND Sys_ID = " + sysid
			sATCps += " AND Mnu_ID = " + mnuid
			sATCps += " ORDER BY MFS_Orden "
		if (Parametro("IDUsuario",0) == 358) {
			Response.Write("<span class='Botones'>sATCps&nbsp;" + sATCps + "</span><br />")
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
			sFCHCps += " AND Mnu_ID = " + rsSeccion.Fields.Item("Mnu_ID").Value
			sFCHCps += " AND MFS_ID = " + rsSeccion.Fields.Item("MFS_ID").Value
			sFCHCps += " AND MFC_EsOculto = 0 "
			sFCHCps += " AND MFC_EsPKPrincipal = 0 "
			sFCHCps += " AND MFC_EsPK = 0 "
			sFCHCps += " ORDER BY MFC_Renglon, MFC_Columna "
			if (Parametro("IDUsuario",0) == 358) {
				Response.Write("<span class='Botones'>sFCHCps&nbsp;" + sFCHCps + "</span><br />")
			}
			var iRen = 1
			var iCol = 1
			var iColumna = 1
			var sEtiqueta = ""
			var sCampo = ""
			var sNombreCampo = ""
			var sValorDefault = ""
			var ValorDelCampo = ""
			var sTabla = "" 
			var sCampoLlave = ""
			//var bEsInformativo = ""
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
						iSoloLectura = rsCampos.Fields.Item("MFC_SoloLectura").Value
						var sModoRO = Modo
						if (iSoloLectura == 1) {
							sModoRO = "Consulta"
						}
						//Response.Write("sModoRO&nbsp;" + sModoRO)
//						bEsInformativo = rsCampos.Fields.Item("MFC_EsInformativo").Value
//						if (bEsInformativo == 1) {
//							sModoRO = "Consulta"
//						}
						sEtiqueta = "" + rsCampos.Fields.Item("MFC_Etiqueta").Value
						sNombreCampo = "" + rsCampos.Fields.Item("MFC_Campo").Value
						sValorDefault = "" + rsCampos.Fields.Item("MFC_ValorDefault").Value
						sTabla = "" + rsCampos.Fields.Item("MFC_ComboTabla").Value
						sCampoLlave = "" + rsCampos.Fields.Item("MFC_ComboCampoLlave").Value
						if (EsVacio(sCampoLlave)) {
							sCampoLlave = sNombreCampo
						}
						sCampoDesc = "" + rsCampos.Fields.Item("MFC_ComboCampoDesc").Value
						sCondicion = "" + rsCampos.Fields.Item("MFC_ComboCondicion").Value
						sOrden = "" + rsCampos.Fields.Item("MFC_Orden").Value
						sLeyendaTodos = "" + rsCampos.Fields.Item("MFC_LeyendaSelecTodos").Value
						ValorDelCampo =Parametro( sNombreCampo , sValorDefault  )
						//Seccion para campos que con solo un parametro hacen la diferencia
						switch (parseInt( rsCampos.Fields.Item("MFC_TipoCampo").Value)) {
							case 4:  // 4 = combo
								var sEventos = ""
								if (!EsVacio(rsCampos.Fields.Item("MFC_EventosJS").Value)) {
									sEventos =  " " + rsCampos.Fields.Item("MFC_EventosJS").Value + " "
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
								
								sCampo = CargaComboFicha(sNombreCampo,sEventos,sCampoLlave,sCampoDescripcion,sTabla,sCondicion,sOrden,ValorDelCampo,0,sTodos,sModoRO) 
								break;	
							case 7:    // 7 = combo catalogo general
								var sEventos = ""
								if (!EsVacio(rsCampos.Fields.Item("MFC_EventosJS").Value)) {
									sEventos =  " " + rsCampos.Fields.Item("MFC_EventosJS").Value + " "
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
						}
						
						
						//Seccion para campos que es muy diferente la edicion a la consulta
						//Modo = "Editar"
						if (sModoRO == "Editar") { 
						//Response.Write("<br><font color='red'><strong>Modo&nbsp;" + Modo + "</strong></font>")
						//Response.Write("<br><font color='red'><strong>MFC_TipoCampo&nbsp;" + parseInt(rsCampos.Fields.Item("MFC_TipoCampo").Value) + "</strong></font>")
							//Se cargan los campos de la seccion actual
								switch (parseInt(rsCampos.Fields.Item("MFC_TipoCampo").Value)) {
									case 1:						//			1 = text box
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
										//NombreCombo,Eventos,CampoID,CampoDescripcion,Tabla,Condicion,Orden,Seleccionado,Conexion,Todos,Modo
										sCampo = "&nbsp;" + CargaComboFicha(sNombreCampo,Eventos,sNombreCampo,
														    sCatalogoAUsarCampoDato,sTablaCatalogo,sCatalogoAUsarCondicion,
														    sNombreCampo,ValorDelCampo,0,"Seleccione una opción",sModoRO)
										break;
									case 4:  // 4 = combo
										//cubierto en la seccion de un solo procedimiento
										break;
									case 5:						//			5 = caja seleccion
										var Eventos = ""
										if (!EsVacio(rsCampos.Fields.Item("MFC_Class").Value)) {
											Eventos = "class='" + rsCampos.Fields.Item("MFC_Class").Value + "'  "
										}
										sCampo = "&nbsp;" + CajaSeleccion(sNombreCampo,Eventos,Parametro(sNombreCampo,1),1,sModoRO)
										break;
									case 6:						//			6 = fecha
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
										sCampo += FormatoFecha(Parametro(sNombreCampo,"") ,"UTC a dd/mm/yyyy")
										sCampo += sC +" size=" + sC + "20" + sC + " maxlength=" + sC + "20" + sC + " />&nbsp;"
										//sCampo = ""
										break;
									case 7:						//			7 = combo catalogo general
										//cubierto en la seccion de un solo procedimiento
										break;
									case 8:						//			8 = password
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
										break;
									case 9:						//			9 = Text Area
										sCampo = "&nbsp;<textarea name=" + sC +  sNombreCampo + sC
										sCampo +=  " id=" + sC + sNombreCampo + sC 
										sCampo += " cols = " + sC + " 45 " + sC + " rows=" + sC + " 5 " + sC + ">"
										sCampo += ValorDelCampo
										sCampo += " </textarea>"
										break;
									case 10:					//			10 = Sí / no
//										sCampo = "&nbsp;<input type=" + sC + "radio" + sC + " name=" + sC + sNombreCampo + sC 
//										sCampo +=" id=" + sC + sNombreCampo + "Si" + sC + " value=" + sC + "1" + sC 
//										if(Parametro(sNombreCampo,1)== 1 ) {  sCampo +=" checked " } 
//										sCampo += " />S&iacute;&nbsp;&nbsp;"
//										
//										sCampo += "<input type=" + sC + "radio" + sC + " name=" + sC + sNombreCampo + sC  
//										sCampo += " id=" + sC + sNombreCampo + "No" + sC + " value=" + sC + "0" + sC
//										if(Parametro(sNombreCampo,1)== 0 ) {  sCampo += " checked " }
//										sCampo += " />No "
										
										var Eventos = ""
										if (!EsVacio(rsCampos.Fields.Item("MFC_Class").Value)) {
											Eventos = "class='" + rsCampos.Fields.Item("MFC_Class").Value + "'  "
										}
										sCampo = "&nbsp;" + CajaSeleccion(sNombreCampo,Eventos,Parametro(sNombreCampo,1),1,"Editar")
										break;
									case 11:	//		11 = 	confirmacion de password
										sCampo = ""
										break;
									case 12:	//		12 = 	Hacer un div
										sCampo = "<div name=" + sC +  sNombreCampo + sC 
										sCampo +=  " id=" + sC + sNombreCampo + sC 
										sCampo += " >"
										break;
									default:	//			1 = text box
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
										break;
								}
						} else {
							//Se cargan los campos de la seccion actual
								switch (parseInt( rsCampos.Fields.Item("MFC_TipoCampo").Value)) {
									case 1:						//			1 = text box
										sCampo = "&nbsp;" + ValorDelCampo
										break;
									case 2:						//			2 = option
										if (!EsVacio(rsCampos.Fields.Item("MFC_arrValores").Value)) {
											var Valores = new Array(0)
											var Txt =""
											Txt = String(rsCampos.Fields.Item("MFC_arrValores").Value)     // se explota el contenido para separar las opciones de los valores
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
											Eventos = "class='" + rsCampos.Fields.Item("MFC_Class").Value + "'  "
										}
										if (!EsVacio(rsCampos.Fields.Item("MFC_EventosJS").Value)) {
											Eventos += "  " + rsCampos.Fields.Item("MFC_EventosJS").Value 
										}
										//NombreCombo,Eventos,CampoID,CampoDescripcion,Tabla,Condicion,Orden,Seleccionado,Conexion,Todos,sModoRO
										sCampo = "&nbsp;" + CargaComboFicha(sNombreCampo,Eventos,sNombreCampo,
														    sCatalogoAUsarCampoDato,sTablaCatalogo,sCatalogoAUsarCondicion,
														    sNombreCampo,ValorDelCampo,0,"Sin seleccion",Modo)
										break;
									case 4:  // 4 = combo
										//cubierto en la seccion de un solo procedimiento
										break;
									case 5:						//			5 = caja seleccion
										var Eventos = ""
										if (!EsVacio(rsCampos.Fields.Item("MFC_Class").Value)) {
											Eventos = "class='" + rsCampos.Fields.Item("MFC_Class").Value + "'  "
										}
										sCampo = "&nbsp;" + CajaSeleccion(sNombreCampo,Eventos,Parametro(sNombreCampo,1),1,sModoRO)
										break;
									case 6:						//			6 = fecha
										//sCampo = "&nbsp;" + CambiaFormatoFecha(Parametro(sNombreCampo,""),"yyyy-mm-dd","dd/mm/yyyy") 
										sCampo = "&nbsp;" + FormatoFecha(Parametro(sNombreCampo,"") ,"UTC a dd/mm/yyyy")
										break;
									case 7:						//			7 = combo catalogo general
										//cubierto en la seccion de un solo procedimiento
										break;
									case 8:						//			8 = password
										sCampo = "&nbsp;xxxxx" 
										//+ ValorDelCampo
										break;
									case 9:						//			9 = Text Area
										sCampo = "&nbsp;" + ValorDelCampo
										break;
									case 10:					//			10 = Sí / no
//										if(Parametro(sNombreCampo,0) == 1 ) { 
//												   sCampo = "&nbsp;Sí" 
//										  }  else {
//												   sCampo = "&nbsp;No"
//										 }  
										var Eventos = ""
										if (!EsVacio(rsCampos.Fields.Item("MFC_Class").Value)) {
											Eventos = "class='" + rsCampos.Fields.Item("MFC_Class").Value + "'  "
										}
										sCampo = "&nbsp;" + CajaSeleccion(sNombreCampo,Eventos,Parametro(sNombreCampo,1),1,"Consulta")
										break;
									case 11:						//		11 = 	confirmacion de password
										sCampo = ""
										break;
									case 12:	//		12 = 	Hacer un div
										sCampo = "<div name=" + sC +  sNombreCampo + sC 
										sCampo +=  " id=" + sC + sNombreCampo + sC 
										sCampo += " >"
										break;

										
										
									default:					//			1 = text box
										sCampo = "&nbsp;" + ValorDelCampo
										break;
								}
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
					
					sResultado += "<td width=" + sC + "10%" + sC + " height=" + sC + "18" + sC + " class=" + sC + "FichaCampoTitulo" + sC + ">"
					sResultado += sEtiqueta
					sResultado += "</td>"
					
					sResultado += "<td width=" + sC + "40%" + sC + " class=" + sC + "FichaCampoValor" + sC + ">"
					sResultado += sCampo
					sResultado += "</td>"
					
						
					if (iControl == 2) {
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
		sResultado += "</table>  "


		
	//este es el cierre de la seccion de botones	
	
		return sResultado
}

function ImprimeOcultos() {

	var sCamposOcultos = ""
	
		//para cargar al final los campos ocultos
	var sFCOcultos = "SELECT * "
		sFCOcultos += " FROM MenuFichaCampos "
		sFCOcultos += " WHERE MFC_Habilitado = 1 "
		sFCOcultos += "  AND Sys_ID = " + sysid     // rsSeccion.Fields.Item("Sys_ID").Value
		sFCOcultos += "  AND Mnu_ID = " + mnuid     // rsSeccion.Fields.Item("Mnu_ID").Value
		sFCOcultos += "  AND MFC_EsOculto = 1 "	
		if (Parametro("IDUsuario",0) == 358) {
			//Response.Write("<span class='Botones'>sFCOcultos&nbsp;" + sFCOcultos + "</span><br />")
		}
	var rsOcultos = AbreTabla(sFCOcultos,1,2)

	while (!rsOcultos.EOF){
		sNombreCampo = "" + rsOcultos.Fields.Item("MFC_Campo").Value
		sValorDefault = "" + rsOcultos.Fields.Item("MFC_ValorDefault").Value
		ValorDelCampo = Parametro( sNombreCampo , sValorDefault  )
		if (EsVacio(ValorDelCampo))  { ValorDelCampo = -1 }
		var ppenc = ElParametroEsPermanente(String(sNombreCampo))
		
		if ( ppenc == 0 ) {
			sCamposOcultos += " <input type=" + sC + "hidden" + sC + " name=" + sC + sNombreCampo + sC + " id=" + sC + sNombreCampo + sC +" value=" + sC + ValorDelCampo + sC + "> "
		}	
		rsOcultos.MoveNext()
	}	
		//sCamposOcultos += " <input type=" + sC + "hidden" + sC + " name=" + sC + "VeZ" + sC + " id=" + sC + "VeZ" + sC +" value=" + sC + "1" + sC + "> "

	rsOcultos.Close()

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
	
	
	
	sG += "<tr><td height=\"25\" colspan=\"2\">"
	if (Mensaje != ""){ 
		sG += "<div class=\"ui-widget\">"
		sG += "<div class=\"ui-state-highlight ui-corner-all\" style=\"margin-top: 20px; padding: 0 .7em;\"> "
		sG += "<p><span class=\"ui-icon ui-icon-info\" style=\"float: left; margin-right: .3em;\"></span>"
		sG += "<strong>Aviso</strong> " + Mensaje
		sG += "</p></div></div>"
	}	
//	sG += "<br/><div class=\"ui-widget\">"
//	sG += "<div class=\"ui-state-error ui-corner-all\" style=\"padding: 0 .7em;\"> "
//	sG += "<p><span class=\"ui-icon ui-icon-alert\" style=\"float: left; margin-right: .3em;\"></span> "
//	sG += "<strong>Alert:</strong> Sample ui-state-error style."
//	sG += "</p></div></div>"
	
	//var fch = new Date()
	//sG += "El VPV = " + VPV + " El modo entro como " + Parametro("Modo","modovacio") + "  la accion entro como " + Parametro("Accion","accionvacio") + " " + fch
	
	sG += "</td></tr>"
	
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


if (!bHayParametros) { 	LeerParametrosdeBD() }
	IniciaDebugBD()
var sC = String.fromCharCode(34)
var Accion = Parametro("Accion","Consulta")
var Modo = Parametro("Modo","Consulta")
var Mensaje = ""

var SistemaActual = Parametro("SistemaActual",0)
var VentanaIndex  = Parametro("VentanaIndex",0)
var IDUsuario     = Parametro("IDUsuario",0)


var sTabla = ""
var sCondicionGeneral = ""
var sOrdenadoPor = ""
var sysid = Parametro("SistemaActual",0)
var mnuid = Parametro("VentanaIndex",0)
var arCampos = new Array(0)
var MFC_EsOculto = new Array(0)        //para el control de campos ocultos
var MFC_EsPKPrincipal = ""   //Indica que es la llave principal, solo debe haber una
var MFC_EsPK = new Array(0)  //Indica si hay mas llaves en la tabla
var MFC_YaSeUso = new Array(0)  //Indica si hay mas llaves en la tabla

	var sFCHTabla = "SELECT * "
		sFCHTabla += " FROM MenuFichaTabla "
		sFCHTabla += " WHERE Sys_ID = " + sysid
		sFCHTabla += " AND Mnu_ID = " + mnuid
		sFCHTabla += " AND MFS_ID = 1 "  //campo experimental para poner una tabla diferente por seccion, ahora solo funciona un solo registro por menu

	var rsTabla = AbreTabla(sFCHTabla,1,2) 
	if (!rsTabla.EOF) {	
		sTabla = rsTabla.Fields.Item("MFC_Tabla").Value
		sCondicionGeneral = rsTabla.Fields.Item("MFC_CondicionGeneral").Value
		sOrdenadoPor = rsTabla.Fields.Item("MFC_OrdenadoPor").Value
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
	var sLLavePrimariaHeredada = ""
	
	var iPos = 0
	var iPosO = 0
	var sFCHCampos = "SELECT * "
		sFCHCampos += " FROM MenuFichaCampos "
		sFCHCampos += " WHERE MFC_Habilitado = 1 "
		sFCHCampos += " AND Sys_ID = " + sysid
		sFCHCampos += " AND Mnu_ID = " + mnuid
	
	var rsCampos = AbreTabla(sFCHCampos,1,2) 
	while (!rsCampos.EOF){	
		arCampos[iPos] = rsCampos.Fields.Item("MFC_Campo").Value
		var MFC_EsPK = rsCampos.Fields.Item("MFC_EsPK").Value
		var MFC_EsPKPrincipal = rsCampos.Fields.Item("MFC_EsPKPrincipal").Value
		var MFC_EsOculto = rsCampos.Fields.Item("MFC_EsOculto").Value
		
		MFC_YaSeUso[iPos] = false

		if (MFC_EsPK == 1) {
			sLLavePrimariaCampo = arCampos[iPos]
			sLLavePrimaria = "  " +  arCampos[iPos] + " = " + Parametro(arCampos[iPos],-1) + " "
			//pendiente falta poner el tipo de dato N=numero F=fecha T=texto para clavarle unas comillas o el formato de fecha
			MFC_YaSeUso[iPos] = true
			MFC_EsOculto = 1
		}
		if (MFC_EsPKPrincipal == 1) {
			if (!MFC_YaSeUso[iPos]) {
				if (sLLavePrimariaHeredada != "" ) { sLLavePrimariaHeredada += " AND " }
				sLLavePrimariaHeredada += " " +  arCampos[iPos] + " = " + Parametro(arCampos[iPos],-1) + " "
				MFC_YaSeUso[iPos] = true
				MFC_EsOculto = 1
			}
		}
		if (MFC_EsOculto == 1 ) {
			MFC_EsOculto[iPosO] = arCampos[iPos]
			iPosO++
		}
		iPos++
		rsCampos.MoveNext()
	}	
	rsCampos.Close()	



	var sCondCamp = sLLavePrimariaHeredada 
		if (sCondCamp != "" ) { sCondCamp += " AND " }
		sCondCamp = " WHERE " + sCondCamp + sLLavePrimaria
	
if(Modo != "Vuelta" ) {	
	if (Accion == "Guardar") {
		//bParametrosDeAjaxaUTF8=true
		if (Parametro(sLLavePrimariaCampo,-1) == -1) {  
			//if (Session("Agregar") == 1) {
				LlaveABuscar = SiguienteID(sLLavePrimariaCampo,sTabla, sLLavePrimariaHeredada ,0)
				ParametroCambiaValor(sLLavePrimariaCampo, LlaveABuscar) 
				bDebug = true
				BDInsert(arCampos,sTabla,"",0)
				bDebug = false
				sLLavePrimaria = sLLavePrimariaCampo + " = " + LlaveABuscar
			//}
		} else { 
			//if (Session("Editar") == 1) { 
				BDUpdate(arCampos,sTabla,sCondCamp,0)
			//}
		}			
		Accion = "Consulta"
		Modo = "Consulta"
		Mensaje = "El registro fué guardado correctamente"
		ParametroCambiaValor("Modo", "Consulta")
		ParametroCambiaValor("Accion", "Consulta")
	}	
	if (Accion == "Borrar" ) {
		BDDelete(arCampos,sTabla,sCondCamp,0)
		//Response.Write("sSQLMod&nbsp;" + sSQLMod + "<br>")	
		Mensaje = "El registro fue borrado correctamente"
		Accion = "Consulta"
		Modo = "Borrado"
		ParametroCambiaValor("Accion", "Consulta")
		ParametroCambiaValor("Modo","Borrado")
		//Response.Redirect("Cliente.asp")
	}
} 

if (Accion != "Vuelta") { 

var sConsultaSQL = "SELECT * "
	sConsultaSQL += " FROM " + sTabla
	sConsultaSQL += " WHERE " + sLLavePrimaria
	if (sLLavePrimariaHeredada != "" ) { sConsultaSQL += " AND " }
	sConsultaSQL += sLLavePrimariaHeredada
	AgregaDebugBD("dando la vuelta",sConsultaSQL)
		bHayParametros = false
		ParametroCargaDeSQL(sConsultaSQL,0)
		
}
////wgParam
//Response.Write(sLLavePrimariaCampo)
//Response.Write("<br>>")
//Response.Write(Parametro(sLLavePrimariaCampo,-1))
//Response.Write("<---")
//Response.Write("<br>>")
//Response.Write(FiltraVacios(Parametro(sLLavePrimariaCampo,-1)))
//Response.Write("<br>cccc" +Parametro(sLLavePrimariaCampo,-1))
//Response.Write("<---")
//
//if (FiltraVacios(Parametro(sLLavePrimariaCampo,-1)) == "") {
//		ParametroCambiaValor(sLLavePrimariaCampo,-1)
//}
//Response.Write("<br>xxxxx" +Parametro(sLLavePrimariaCampo,-1))
//Response.Write("<br>xx" +sLLavePrimariaCampo)

if (Parametro(sLLavePrimariaCampo,-1) == -1) {
		var Modo = "Editar"
		var Accion =  "Consulta"
		ParametroCambiaValor("Modo", Modo)
		ParametroCambiaValor("Accion", Accion)  //forza a nuevo 
} else {
//	Valido si el registro existe de lo contrario cambio a modo nuevo
	if (Accion != "Vuelta") {
		var sSQLCondYE = "" + sLLavePrimaria
		if (sLLavePrimariaHeredada != "" ) { sSQLCondYE += " AND " }
		sSQLCondYE += sLLavePrimariaHeredada
	
			var uYaExiste = BuscaSoloUnDato("Count(*)",sTabla,sSQLCondYE,0,0)
		if (uYaExiste == 0) {
			AgregaDebugBD("entro nuevo reg con llave primaria != -1",sSQLCondYE)
			var Modo = "Editar"
			var Accion =  "Consulta"
			ParametroCambiaValor("Modo", Modo)
			ParametroCambiaValor("Accion", Accion)  //forza a nuevo 
		}
	}
}

AgregaDebugBD("Modo = " + Modo,"Accion = " + Accion )
Response.Write(ArmaMarco())
var campocul = ImprimeOcultos()
Response.Write("<br> " + campocul)

%>