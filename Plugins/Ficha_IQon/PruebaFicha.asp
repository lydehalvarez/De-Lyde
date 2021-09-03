<!--#include file="../../Includes/iqon.asp" -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Prueba de Ficha</title>
</head>
<body>
<%
/*******************************************************/
var sysid = 
var iWgCfgID = 
var mnuid = 

var sC = String.fromCharCode(34)


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
			if (iIQonDebug == 0) {
				Response.Write("<font color='red'><strong>Sección&nbsp;" + sATCps + "</strong></font><br />")
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
			if (iIQonDebug == 0) {
				Response.Write("<font color='red'><strong>Campos&nbsp;" + sFCHCps + "</strong></font><br />")
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
			if (iIQonDebug == 0) {
				Response.Write("Etapa de prueba..iMaxColumnas&nbsp;"+ iMaxColumnas+"&nbsp;<br />")
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
							Response.Write("<font color='red' size='-3'><strong>Modo&nbsp;" + Modo + "</strong></font>")
							Response.Write("<br><font color='red'><strong>MFC_TipoCampo&nbsp;" + parseInt(rsCampos.Fields.Item("MFC_TipoCampo").Value) + "</strong></font>")
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
					
						
					//if (iControl == 2) {
					if (iControl == iMaxColumnas) {
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
        
%>        
</body>
</html>
