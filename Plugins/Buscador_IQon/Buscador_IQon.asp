<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../Includes/iqon.asp" -->
<%


function CajaSeleccion(NombreCaja,EventosClases,ValorParametro,Valor,Modo) {
var sRespuesta = ""

		sRespuesta += "<input name='" + NombreCaja + "' type='checkbox' " + EventosClases
		sRespuesta += " id='" + NombreCaja + "' value='" + Valor + "' "
		if (ValorParametro == Valor ) {
			sRespuesta +=  " checked "
		}
		sRespuesta +=  " >"

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


		for (i=0;i<Opciones.length;i++) {
			 sRespuesta += "<label><input type=" + sC + "radio" + sC + " name=" + sC + NombreCaja + sC + " id=" + sC + Opciones[i] 
			 sRespuesta += sC + " value=" + sC + ValoresOpc[i] + sC + " " 
			 if (ValoresOpc[i] == ValorActual || i==0) { sRespuesta += " checked " }
			 sRespuesta += " />"
			 sRespuesta +=  Opciones[i] + "</label>"
		}

	
	return sRespuesta
}

function ComboSeccionFicha(NombreCombo,Eventos,Seccion,Seleccionado,Conexion,Todos,Orden,Modo) {
	var sElemento = ""
	var sResultado = ""


		sResultado = "<select name='" + NombreCombo + "' id='" + NombreCombo + "' " + Eventos + " >"
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

	
	return sResultado
	
}


function CargaComboFicha(NombreCombo,Eventos,CampoID,CampoDescripcion,Tabla,Condicion,Orden,Seleccionado,Conexion,Todos,Modo) {
	var sElemento = ""
	var sResultado = ""
	
	if (EsVacio(Seleccionado)) {Seleccionado = -1 }
	

		sResultado = "<select name='" + NombreCombo  +"' id='" + NombreCombo + "' " + Eventos + " >"
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

	return sResultado
}
	
function CargaBotones() {
	var sBot = ""

	sBot = "<tr><td width=\"72%\" height=\"25\">&nbsp;</td><td width=\"28%\" align=\"right\">&nbsp;&nbsp;&nbsp;&nbsp;"
	sBot += "<input name=\"btnLimpiar\" type=\"reset\" class=\"Botones\" id=\"btnLimpiar\" value=\"Limpiar\" >&nbsp;&nbsp;&nbsp;&nbsp;"
	sBot += "<input name=\"btnBuscar\" type=\"button\" class=\"Botones\" id=\"btnBuscar\" value=\"Buscar\" onClick=\"javascript:AcBuscadorBuscar();\">"
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
			sATCps += " AND Sys_ID = " + SistemaActual
			sATCps += " AND Mnu_ID = " + VentanaIndex //Parametro("VentanaIndex",1)
			sATCps += " ORDER BY MFS_Orden "

		var rsSeccion = AbreTabla(sATCps,1,2)
		if (rsSeccion.EOF){ 
			return ""
		} else {
			//para cargar al final los campos ocultos
			var sFCOcultos = "SELECT * "
				sFCOcultos += " FROM MenuFichaCampos "
				sFCOcultos += " WHERE MFC_Habilitado = 1 "
				sFCOcultos += "  AND Sys_ID = " + SistemaActual
				sFCOcultos += "  AND Mnu_ID = " + rsSeccion.Fields.Item("Mnu_ID").Value
				sFCOcultos += "  AND MFC_EsOculto = 1 "	
			
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
			
			var iRen = 1
			var iCol = 1
			var iColumna = 1
			var sEtiqueta = ""
			var sCampo = ""
			var sNombreCampo = ""
			var sValorDefault = ""
			var sTabla = "" 
			var sCampoDesc = ""
			var sCondicion = "" 
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
						sNombreCampo = "" + rsCampos.Fields.Item("MFC_Campo").Value
						sValorDefault = "" + rsCampos.Fields.Item("MFC_ValorDefault").Value
						sTabla = "" + rsCampos.Fields.Item("MFC_ComboTabla").Value
						sCampoDesc = "" + rsCampos.Fields.Item("MFC_ComboCampoDesc").Value
						sCondicion = "" + rsCampos.Fields.Item("MFC_ComboCondicion").Value
						sOrden = "" + rsCampos.Fields.Item("MFC_Orden").Value
						sLeyendaTodos = "" + rsCampos.Fields.Item("MFC_LeyendaSelecTodos").Value
						
						//Seccion para campos que con solo un parametro hacen la diferencia
						switch (parseInt( rsCampos.Fields.Item("MFC_TipoCampo").Value)) {
							case 4:  // 4 = combo
								var sEventos = ""
								if (!EsVacio(rsCampos.Fields.Item("MFC_EventosJS").Value)) {
									sEventos =  " " + rsCampos.Fields.Item("MFC_EventosJS").Value + " "
								}
								var sCampoDescripcion = rsCampos.Fields.Item("MFC_ComboCampoDesc").Value
								var sTabla  = rsCampos.Fields.Item("MFC_ComboTabla").Value
								var sCondicion = "" 
								if (!EsVacio(rsCampos.Fields.Item("MFC_ComboCondicion").Value)) {
									sCondicion = rsCampos.Fields.Item("MFC_ComboCondicion").Value + " "
								}
								var sOrden = ""
								if (!EsVacio(rsCampos.Fields.Item("MFC_Orden").Value)) {
									sOrden =  " " + rsCampos.Fields.Item("MFC_Orden").Value + " "
								}
								var sTodos = "Seleccione una opción"
								if (!EsVacio(rsCampos.Fields.Item("MFC_LeyendaSelecTodos").Value)) {
									sTodos = rsCampos.Fields.Item("MFC_LeyendaSelecTodos").Value
								}
								sCampo = CargaComboFicha(sNombreCampo,sEventos,sNombreCampo,sCampoDescripcion,sTabla,sCondicion,sOrden,Parametro(sNombreCampo,sValorDefault),0,sTodos,"Editar") 
								break;	
							case 7:    // 7 = combo catalogo general
								var sEventos = ""
								if (!EsVacio(rsCampos.Fields.Item("MFC_EventosJS").Value)) {
									sEventos =  " " + rsCampos.Fields.Item("MFC_EventosJS").Value + " "
								}
								var sCampoDescripcion = rsCampos.Fields.Item("MFC_ComboCampoDesc").Value
								var sTabla  = rsCampos.Fields.Item("MFC_ComboTabla").Value
								var sCondicion = " Sys_ID = " + sysid
								if (!EsVacio(rsCampos.Fields.Item("MFC_ComboCondicion").Value)) {
									sCondicion +=  " AND " + rsCampos.Fields.Item("MFC_ComboCondicion").Value + " "
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
								sCampo = "&nbsp;" + ComboSeccionFicha(sNombreCampo,sEventos,sSeccion,Parametro(sNombreCampo,sValorDefault),0,sTodos,sOrden,"Editar")
								break;				
						}
						//Seccion para campos que es muy diferente la edicion a la consulta
							//Se cargan los campos de la seccion actual
								switch (parseInt( rsCampos.Fields.Item("MFC_TipoCampo").Value)) {
									case 1:						//			1 = text box
										sCampo = "&nbsp;<input name=" + sC +  sNombreCampo + sC 
										sCampo += " type=" + sC + "text" + sC + " class=" + sC + "FichaObjetos" + sC 
										sCampo +=  " id=" + sC +sNombreCampo + sC 
										sCampo += " style=" + sC + "width:90%" + sC 
										sCampo += " maxlength=" + sC + "100" + sC + " >"
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
										sCampo = "&nbsp;" + OpcionesFicha(sNombreCampo,Eventos,SarrOpciones,SarrValores,Parametro(sNombreCampo,sValorDefault),Modo)
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
														    sNombreCampo,Parametro(sNombreCampo,sValorDefault),0,"Seleccione una opción",Modo)
										break;
									case 4:  // 4 = combo
										//cubierto en la seccion de un solo procedimiento
										break;
									case 5:						//			5 = caja seleccion
										var Eventos = ""
										if (!EsVacio(rsCampos.Fields.Item("MFC_Class").Value)) {
											Eventos = "class='" + rsCampos.Fields.Item("MFC_Class").Value + "'  "
										}
										sCampo = "&nbsp;" + CajaSeleccion(sNombreCampo,Eventos,Parametro(sNombreCampo,1),1,Modo)
										break;
									case 6:						//			6 = fecha
										 sCampo = "<script type=" + sC + "text/javascript" + sC + ">"
											sCampo += "	$(function() {"
												sCampo += "	$( " + sC +	"#" + sNombreCampo + sC + " ).datepicker({"
												sCampo += "	changeMonth: true, showOtherMonths: true, selectOtherMonths: true," 
												sCampo += "	changeYear: true, showButtonPanel: true," 
												sCampo += "	showOn:	" + sC + "button" + sC + ","  
												sCampo += "	buttonImage:" + sC + "images/calendar.png" + sC + "," 		
												sCampo += " buttonImageOnly: true "
												sCampo += "});"
											sCampo += "});"
										sCampo += "</script>"  
										sCampo += "&nbsp;<input name=" + sC + sNombreCampo + sC + " type=" + sC + "text" + sC + " class=" + sC + "FichaObjetos" + sC + " id=" + sC + sNombreCampo + sC  + " value=" + sC
										//sCampo += CambiaFormatoFecha(Parametro(sNombreCampo,""),"yyyy-mm-dd","dd/mm/yyyy") 
										sCampo += FormatoFecha(Parametro(sNombreCampo,"") ,"UTC a dd/mm/yyyy")
										sCampo += sC +" size=" + sC + "20" + sC + " maxlength=" + sC + "20" + sC + " />&nbsp;"
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
										sCampo += Parametro(sNombreCampo,sValorDefault) + sC 
										sCampo += " maxlength=" + sC + "100" + sC + " >"
										break;
									case 9:						//			9 = Text Area
										sCampo = "&nbsp;<textarea name=" + sC +  sNombreCampo + sC
										sCampo +=  " id=" + sC + sNombreCampo + sC 
										sCampo += " cols = " + sC + " 45 " + sC + " rows=" + sC + " 5 " + sC + ">"
										sCampo += Parametro(sNombreCampo,sValorDefault)
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
									case 11:	//11 = text box doble para rangos
									    sCampo = "De&nbsp;<input name=" + sC + sNombreCampo + sC 
										sCampo += " type=" + sC + "text" + sC + " class=" + sC + "FichaObjetos" + sC 
										sCampo +=  " id=" + sC + sNombreCampo + sC 
										sCampo += " style=" + sC + "width:45%" + sC 
										sCampo += " maxlength=" + sC + "100" + sC + " value='' >"
										sCampo += "<br>hasta&nbsp;<input name=" + sC + sNombreCampo + sC 
										sCampo += " type=" + sC + "text" + sC + " class=" + sC + "FichaObjetos" + sC 
										sCampo +=  " id=" + sC + sNombreCampo + sC 
										sCampo += " style=" + sC + "width:45%" + sC 
										sCampo += " maxlength=" + sC + "100" + sC + "  value='' >"
										break;
									case 12:	//12 = text box doble para rangos fechas
										sCampo = " <input type=" + sC + "hidden" + sC  
										sCampo += " name=" + sC + sNombreCampo + sC 
										sCampo += " id=" + sC + sNombreCampo + sC 
										sCampo += " value=" + sC + "" + sC + "> "
										
									    sCampo += "Desde&nbsp;<input name=" + sC + "FechaDesde" + sNombreCampo + sC 
										sCampo += " type=" + sC + "text" + sC + " class=" + sC + "FichaObjetos" + sC 
										sCampo +=  " id=" + sC + "FechaDesde" + sNombreCampo + sC 
										sCampo += " style=" + sC + "width:45%" + sC 
										sCampo += " maxlength=" + sC + "100" + sC + " >"
										sCampo += "<br>Hasta&nbsp;&nbsp;<input name=" + sC + "FechaHasta" + sNombreCampo + sC 
										sCampo += " type=" + sC + "text" + sC + " class=" + sC + "FichaObjetos" + sC 
										sCampo +=  " id=" + sC + "FechaHasta" + sNombreCampo + sC 
										sCampo += " style=" + sC + "width:45%" + sC 
										sCampo += " maxlength=" + sC + "100" + sC + " >"
										
										
										sCampo += "<script type=" + sC + "text/javascript" + sC + ">"
											sCampo += "	$(function() {"
												sCampo += "	$( " + sC +	"#" + "FechaDesde" + sNombreCampo + sC + " ).datepicker({"
												sCampo += "	changeMonth: true, showOtherMonths: true, selectOtherMonths: true," 
												sCampo += "	changeYear: true, showButtonPanel: true,"
												sCampo += "	showOn:	" + sC + "button" + sC + ","  
												sCampo += "	buttonImage:" + sC + "images/calendar.png" + sC + "," 		
												sCampo += " buttonImageOnly: true "
												sCampo += "});"
												sCampo += "	$( " + sC +	"#" + "FechaHasta" + sNombreCampo + sC + " ).datepicker({"
												sCampo += "	changeMonth: true, showOtherMonths: true, selectOtherMonths: true," 
												sCampo += "	changeYear: true, showButtonPanel: true,"
												sCampo += "	showOn:	" + sC + "button" + sC + ","  
												sCampo += "	buttonImage:" + sC + "images/calendar.png" + sC + "," 		
												sCampo += " buttonImageOnly: true "
												sCampo += "});"
												
												sCampo += "$(\"#FechaDesde" + sNombreCampo + "\").change(function() { "
												sCampo += "$(\"#FechaHasta" + sNombreCampo + "\").val($(\"#FechaDesde" + sNombreCampo + "\").val());"
												sCampo += "$(\"#" + sNombreCampo + "\").val(  $(\"#FechaDesde" + sNombreCampo + "\").val() + 'sr12' +   $(\"#FechaHasta" + sNombreCampo + "\").val())});"
												sCampo += "$(\"#FechaHasta" + sNombreCampo + "\").change(function() { "
												sCampo += "$(\"#" + sNombreCampo + "\").val(  $(\"#FechaDesde" + sNombreCampo + "\").val() + 'sr12' +   $(\"#FechaHasta" + sNombreCampo + "\").val())});"
											sCampo += "});"
										sCampo += "</script>"  
										/*sCampo += "&nbsp;<input name=" + sC + sNombreCampo + sC + " type=" + sC + "text" + sC + " class=" + sC + "FichaObjetos" + sC + " id=" + sC + sNombreCampo + sC  + " value=" + sC
										//sCampo += CambiaFormatoFecha(Parametro(sNombreCampo,""),"yyyy-mm-dd","dd/mm/yyyy") 
										sCampo += FormatoFecha(Parametro(sNombreCampo,"") ,"UTC a dd/mm/yyyy")
										sCampo += sC +" size=" + sC + "20" + sC + " maxlength=" + sC + "20" + sC + " />&nbsp;"*/
										break;										
										
								}
						bUsado = true
						iVueltas = 0
					} else {
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
		sResultado += "</table>"
		


		var rsOcultos = AbreTabla(sFCOcultos,1,2)
		while (!rsOcultos.EOF){
			sNombreCampo = "" + rsOcultos.Fields.Item("MFC_Campo").Value
			sValorDefault = "" + rsOcultos.Fields.Item("MFC_ValorDefault").Value
			sResultado += "<input type=" + sC + "hidden" + sC + " name=" + sC + sNombreCampo + sC + " value=" + sC + Parametro(sNombreCampo,sValorDefault) + sC + ">"
			rsOcultos.MoveNext()
		}	
		rsOcultos.Close()		 

	//este es el cierre de la seccion de botones	
	
		return sResultado
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
	
//	sG += "<tr><td height=\"25\" colspan=\"2\">"
//	sG += "El modo entro como " + Parametro("Modo","modovacio") + "  la accion entro como " + Parametro("Accion","accionvacio") 
//	sG += "</td></tr>"
	
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
//LimpiaValores()
LeerParametrosdeBD()
EscribeParametrosdeBusquedaBD("")

var sC = String.fromCharCode(34)
var Accion = Parametro("Accion","Consulta")
var Modo = Parametro("Modo","Consulta")

//
//if (Parametro("Accion","") == "Guardar" && Modo == "Editar" ) {
//		ParametroCambiaValor("Modo", "Consulta")
//		ParametroCambiaValor("Accion", "Editar")
//}

var SistemaActual = Parametro("SistemaActual",0)
var VentanaIndex  = Parametro("VentanaIndex",0)
var IDUsuario     = Parametro("IDUsuario",0)

var sCondicionGeneral = ""
var sOrdenadoPor = ""
var sysid = SistemaActual
var mnuid = VentanaIndex

var arCampos = new Array(0)
var MFC_EsOculto = new Array(0)        //para el control de campos ocultos
var MFC_EsPKPrincipal = ""   //Indica que es la llave principal, solo debe haber una
var MFC_EsPK = new Array(0)  //Indica si hay mas llaves en la tabla


	var sLLavePrimaria = ""
	var sLLavePrimariaCampo = ""
	var sLLavePrimariaHeredada = ""
	
	var iPos = 0
	var iPosO = 0
	var sFCHCampos = "SELECT *  "
		sFCHCampos += " FROM MenuFichaCampos "
		sFCHCampos += " WHERE MFC_Habilitado = 1 "
		sFCHCampos += " AND Sys_ID = " + sysid
		sFCHCampos += " AND Mnu_ID = " + mnuid

	var rsCampos = AbreTabla(sFCHCampos,1,2)

	while (!rsCampos.EOF){	
		arCampos[iPos] = rsCampos.Fields.Item("MFC_Campo").Value
		var MFC_EsOculto = rsCampos.Fields.Item("MFC_EsOculto").Value
		if (MFC_EsOculto == 1 ) {
			MFC_EsOculto[iPosO] = arCampos[iPos]
			iPosO++
		}
		iPos++
		rsCampos.MoveNext()
	}	
	rsCampos.Close()	


if(Modo != "Vuelta" ) {	

} 

if (Accion != "Vuelta") { 

}

Response.Write(ArmaMarco())

%>