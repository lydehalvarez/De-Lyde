<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../Includes/iqon.asp" -->
<%

var biQ4Web = false

//var sC = String.fromCharCode(34)

function CargaBotones() {

	var sBot = ""
		//Botones 
		sBot = "<div class=" + sC + "form-group" + sC + ">"
		sBot +=      "<div class=" + sC + "col-md-offset-9 col-md-3" + sC + ">"
		sBot +=           "<a class=" + sC + "btn btn-red" + sC + "id=" + sC + "btnLimpiar" + sC + "name=" + sC + "btnLimpiar" + sC + "href=" + sC + "javascript:RecargaEnSiMismo();" + sC + ">Limpiar&nbsp;<i class=" + sC + "fa fa-eraser" + sC + "></i></a>"
		sBot +=           "&nbsp;<a class=" + sC + "btn btn-green btnBuscar" + sC + "name=" + sC + "bt_Buscar" + sC + "id=" + sC + "bt_Buscar" + sC + "onClick='javascript:AcBuscadorBuscar();'>Buscar&nbsp;<i class=" + sC + "fa fa-search" + sC + "></i></a>"
		sBot += 	   "</div>"
		sBot += "</div>"

	return sBot

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
			
	for (i=0;i<Opciones.length;i++) {
		sRespuesta += "<label class='radio-inline'>"
			sRespuesta += "<input type=" + sC + "radio" + sC + " name=" + sC + NombreCaja + sC + " id=" + sC + Opciones[i] 
			sRespuesta += sC + " value=" + sC + ValoresOpc[i] + sC + " " 
			if (ValoresOpc[i] == ValorActual || i==0) { sRespuesta += " checked " }
			sRespuesta += " class=" + sC + EventosClases + sC + " >"
		sRespuesta +=  Opciones[i] + "</label>"
	}
	
	return sRespuesta

}

//checkbox
function CajaSeleccion(NombreCaja,EventosClases,ValorParametro,Valor,Modo) {
	
	var sRespuesta = ""
	
		sRespuesta += "<label class='checkbox-inline'>"
			sRespuesta += "<input name='" + NombreCaja + "' type='checkbox' " + EventosClases
			sRespuesta += " id='" + NombreCaja + "' value='" + Valor + "' "
			if (ValorParametro == Valor ) {
				sRespuesta +=  " checked "
			}
			sRespuesta += " class=" + sC + EventosClases + sC + " >"
		sRespuesta += "</label>"
		
	return sRespuesta
	
}

//combo de una sección catálogo
function ComboSeccionFicha(NombreCombo,Eventos,Seccion,Seleccionado,Conexion,Todos,Orden,Modo,Estilo) {
	
	var sElemento = ""
	var sResultado = ""

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
	
	return sResultado
	
}

//CargaComboFicha(sMFCCampo,sEventos,sLlave,sCampoDescripcion,sTabla,sCondicion,sOrden,Parametro(sMFCCampo,sMFCValorDefault),0,sTodos,"Editar")
function CargaComboFicha(NombreCombo,Eventos,CampoID,CampoDescripcion,Tabla,Condicion,Orden,Seleccionado,Conexion,Todos,Modo,Estilo) {
	
	var sElemento = ""
	var sResultado = ""
	
	if (EsVacio(Seleccionado)) {Seleccionado = -1 }
	//if (Modo == "Editar") {
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
	//} 
	
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
		sATCps += " AND Mnu_ID = " + VentanaIndex //Parametro("VentanaIndex",1)
		sATCps += " ORDER BY MFS_Orden "
		if (biQ4Web) {
			Response.Write("<br /><font color='red' size='1'><strong>"+sATCps +"</strong></font><br />")
		}		

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
				if (biQ4Web) {
					Response.Write("<br /><font color='red' size='1'><strong>"+sFCOcultos+"</strong></font><br />")
				}		
				
		}
	
		sResultado = " <!-- Manejo de las secciones -->"
		
		while (!rsSeccion.EOF){
			
				iSecCont++
				
				sResultado += "<div class=" + sC + rsSeccion.Fields.Item("MFS_Class").Value + sC + ">"
					sResultado += "<label class=" + sC + "col-md-2 control-label" + sC + ">"
					sResultado += "<h4>"+rsSeccion.Fields.Item("MFS_Nombre").Value+"</h4></label>"
				sResultado += "</div>"
				// El orden MFC_Orden lo maneja el campo MFC_Columna
	
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
		
				if (biQ4Web) {
					Response.Write("<br /><font color='red' size='1'><strong>"+sFCHCps+"</strong></font><br />")
				}		

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
						
			var rsCampos = AbreTabla(sFCHCps,1,2)
			//Verficar desde aquí para ver si es necesaria tanta condición!!!
			
			while (!rsCampos.EOF){		//Campos [Inicio]
				iContCol++
				iMFSID = 0 + rsCampos.Fields.Item("MFS_ID").Value
				iMFCID = 0 + rsCampos.Fields.Item("MFC_ID").Value
				iMFCRenglon = 0 + rsCampos.Fields.Item("MFC_Renglon").Value
				iMFCColumna = 0 + rsCampos.Fields.Item("MFC_Columna").Value
				sMFCOrden = "" + rsCampos.Fields.Item("MFC_Orden").Value
				iMFCOffset = 0 + rsCampos.Fields.Item("MFC_Offset").Value
				sMFCAnchoEtiqueta = "" + rsCampos.Fields.Item("MFC_AnchoEtiqueta").Value
				sMFCAnchoCampo = "" + rsCampos.Fields.Item("MFC_AnchoCampo").Value
				iMFCHabilitado = 0 + rsCampos.Fields.Item("MFC_Habilitado").Value
				iMFCTipoCampo = 0 + rsCampos.Fields.Item("MFC_TipoCampo").Value
				iMFCFormato = 0 + rsCampos.Fields.Item("MFC_Formato").Value
				sMFCPlaceHolder = "" + rsCampos.Fields.Item("MFC_PlaceHolder").Value
				sMFCPlaceHolder = IFAnidado(EsVacio(sMFCPlaceHolder),"",sMFCPlaceHolder)
				sMFCEtiqueta = "" + rsCampos.Fields.Item("MFC_Etiqueta").Value
				sMFCCampo = "" + rsCampos.Fields.Item("MFC_Campo").Value
				sMFCValorDefault = "" + rsCampos.Fields.Item("MFC_ValorDefault").Value
				sMFCTextoAyuda = "" + IFAnidado(EsVacio(rsCampos.Fields.Item("MFC_TextoAyuda").Value),"",rsCampos.Fields.Item("MFC_TextoAyuda").Value) 
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
					Response.Write("<br /><font color='red' size='1'><strong>sCondRegCol&nbsp;" + sCondRegCol + "</strong></font><br />")
				}
				
			var iColPorSecReg = BuscaSoloUnDato("MAX(MFC_Columna)","MenuFichaCampos",sCondRegCol,1,2)
			var iRegPorSec = BuscaSoloUnDato("MAX(MFC_Renglon)","MenuFichaCampos",sCondRegCol,1,2)

				if (biQ4Web) {
					Response.Write("<br /><font color='red' size='1'><strong>=============</strong></font><br />")
					Response.Write("<br /><font color='red' size='1'><strong>&nbsp;iColPorSecReg&nbsp;" + iColPorSecReg + "&nbsp;iRegPorSec&nbsp;"+iRegPorSec+"&nbsp;iContCol&nbsp;"+ iContCol +"</strong></font><br />")
					Response.Write("<br /><font color='red' size='1'><strong>iMFCRenglon&nbsp;"+parseInt(iMFCRenglon)+"&nbsp;iContRow&nbsp;"+iContRow+"</strong></font><br />")
				}
				
				if (iMFCRenglon != iContRow) {
					iContRen++
					iContRow = iMFCRenglon
					sResultado += "<div class=" + sC + "form-group" + sC + "><!-- row&nbsp;" + iContRen + " - renglon -->"
					//Response.Write("<br />Entra")
				} 
				
				if (biQ4Web) {
					Response.Write("<br /><font color='red' size='1'><strong>Cerramos el renglon?</strong></font><br />")
					Response.Write("<br /><font color='red' size='1'><strong>iColPorSecReg&nbsp;"+parseInt(iColPorSecReg))
					Response.Write("<br />&nbsp;iContCol&nbsp;"+iContCol+"</strong></font><br />")
				}
				
				if(parseInt(iColPorSecReg) == parseInt(iContCol)) {
					bCierraRow = true
					//iContRow = 0
					iContCol = 0	
				}
				
				
				//Response.Write("<br />&nbsp;bCierraRow&nbsp;"+bCierraRow+"&nbsp;<br />")
				
				sCampo = ""
		
				//Se cargan los campos de la seccion actual
//				if (biQ4Web) {
//					Response.Write("<br /><font color='red' size='2'><strong>iMFCTipoCampo&nbsp;"+parseInt(iMFCTipoCampo)+"</strong></font><br />")
//				}
				
				switch (parseInt(iMFCTipoCampo)) {
				
					case 1:	// 1 = text box
	
						sCampo =  "<input type=" + sC + "text" + sC + " class=" + sC + sMFCClass + sC
						sCampo += " name=" + sC + sMFCCampo + sC 
						sCampo += " id=" + sC + sMFCCampo + sC 
						sCampo +=   " placeholder=" + sC + sMFCPlaceHolder + sC
						sCampo += ">"
						
						if(!EsVacio(sMFCTextoAyuda)){
							//Ayuda
							sCampo += "<span class='help-block'>"
							sCampo += "<i class='fa fa-question-circle'></i>&nbsp;"
							sCampo += sMFCTextoAyuda
							sCampo += "</span>"
						}
						
						break;

				case 2:	// 2 = option
					
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
					
					sCampo = "&nbsp;" + OpcionesFicha(sMFCCampo,Eventos,SarrOpciones,SarrValores,Parametro(sMFCCampo,sMFCValorDefault),Modo)
					
					if(!EsVacio(sMFCTextoAyuda)){
						//Ayuda
						sCampo += "<span class='help-block'>"
						sCampo += "<i class='fa fa-question-circle'></i>&nbsp;"
						sCampo += sMFCTextoAyuda
						sCampo += "</span>"
					}
					sCampo += "<script type=" + sC + "text/javascript" + sC + "> "

							sCampo += " if($('input[type=" + sC + "radio" + sC + "]').length) { "
								sCampo += "$('input[type=" + sC + "radio" + sC + "].grey').iCheck({ "
									sCampo += "radioClass: 'iradio_minimal-grey', "
									sCampo += "increaseArea: '10%' "
								sCampo += "});"
							sCampo += "}"
							
					sCampo += "</script>"
					
					break;
						
				case 3:	// 3 = 
				
					break;
						
				case 4:  // 4 = combo
						 //cubierto en la seccion de un solo procedimiento
						 
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
					
					var sOrden = ""
					if (!EsVacio(sMFCOrden)) {
						sOrden =  " " + sMFCOrden + " "
					}
					
					var sTodos = "Seleccione una opción"
					if (!EsVacio(sMFCLeyendaSelecTodos)) {
						sTodos = sMFCLeyendaSelecTodos
					}
						
					sCampo = "" + CargaComboFicha(sMFCCampo,sEventos,sLlave,sCampoDescripcion,sTabla,sCondicion,sOrden,Parametro(sMFCCampo,sMFCValorDefault),0,sTodos,"Editar",sEstilo) 
					
					if(!EsVacio(sMFCTextoAyuda)){
						//Ayuda
						sCampo += "<span class='help-block'>"
						sCampo += "<i class='fa fa-question-circle'></i>&nbsp;"
						sCampo += sMFCTextoAyuda
						sCampo += "</span>"
					}
					
					break;
					
				case 5:	// 5 = caja seleccion - checkbox
				
					var Eventos = ""
					if (!EsVacio(sMFCClass)) {
						Eventos = "class='" + sMFCClass + "'  "
					}

					sCampo = "" + CajaSeleccion(sMFCCampo,Eventos,Parametro(sMFCCampo,1),1,Modo)
					
					if(!EsVacio(sMFCTextoAyuda)){
						//Ayuda
						sCampo += "<span class='help-block'>"
						sCampo += "<i class='fa fa-question-circle'></i>&nbsp;"
						sCampo += sMFCTextoAyuda
						sCampo += "</span>"
					}
					
					sCampo += "<script type=" + sC + "text/javascript" + sC + "> "

							sCampo += " if($('input[type=" + sC + "checkbox" + sC + "]').length) { "
								sCampo += "$('input[type=" + sC + "checkbox" + sC + "].grey').iCheck({ "
									sCampo += "checkboxClass: 'icheckbox_minimal-grey', "
									sCampo += "increaseArea: '10%' "
								sCampo += "});"
							sCampo += "}"
							
					sCampo += "</script>"

					break;
					
				case 6:	// 6 = fecha
					
					sCampo = "<div class='input-group'>"
						sCampo += "<input name=" + sC + sMFCCampo + sC + " id=" + sC + sMFCCampo + sC
							sCampo += " placeholder=" + sC + sMFCPlaceHolder + sC + " type=" + sC + "text" + sC
							sCampo += " data-date-format=" + sC + "dd/mm/yyyy" + sC + " data-date-viewmode=" + sC + "years" + sC
							sCampo += " class=" + sC + "form-control date-picker" + sC + " value=" + sC
							sCampo += FormatoFecha(Parametro(sMFCCampo,'') ,'UTC a dd/mm/yyyy') + sC
							sCampo += " >"
							sCampo += " <span class=" + sC + "input-group-addon" + sC + " > <i class='fa fa-calendar'></i> </span>"
					sCampo += "</div>"

					if(!EsVacio(sMFCTextoAyuda)){
						//Ayuda
						sCampo += "<span class='help-block'>"
						sCampo += "<i class='fa fa-question-circle'></i>&nbsp;"
						sCampo += sMFCTextoAyuda
						sCampo += "</span>"
					}
					
					sCampo += "<script type=" + sC + "text/javascript" + sC + ">"
						sCampo += "	$(function() {"
			
							sCampo += "	$( " + sC +	"#" + sMFCCampo + sC + " ).datepicker({"
							sCampo += " format: 'dd/mm/yyyy',"
							sCampo += " language: 'es',"
							sCampo += " autoclose: true"
							sCampo += "});"
							
						sCampo += "});"
					sCampo += "</script>" 
				
					break;
					
				case 7:	// 7 = combo Catálogo General
					//cubierto en la sección de un solo procedimiento
					
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
					var sCondicion = " Sys_ID = " + sysid
					if (!EsVacio(sMFCComboCondicion)) {
						sCondicion +=  " AND " + sMFCComboCondicion + " "
					}
					
					var sOrden = ""
					if (!EsVacio(sMFCOrden)) {
						sOrden =  " " + sMFCOrden + " "
					}
					
					var sTodos = "Seleccione una opción"
					if (!EsVacio(sMFCLeyendaSelecTodos)) {
						sTodos = sMFCLeyendaSelecTodos
					}
					
					var sSeccion = "1"
					if (!EsVacio(iMFCIDCatalogoGeneral)) {
						sSeccion = iMFCIDCatalogoGeneral
					}	
					
					sCampo = "" + ComboSeccionFicha(sMFCCampo,sEventos,sSeccion,Parametro(sMFCCampo,sMFCValorDefault),0,sTodos,sOrden,"Editar",sEstilo)
					
					if(!EsVacio(sMFCTextoAyuda)){
						//Ayuda
						sCampo += "<span class='help-block'>"
						sCampo += "<i class='fa fa-question-circle'></i>&nbsp;"
						sCampo += sMFCTextoAyuda
						sCampo += "</span>"
					}
					
					break;
					
				case 8: // 8 = password

					sCampo =  "<input type=" + sC + "password" + sC + " class=" + sC + sMFCClass + sC
					sCampo += " name=" + sC + sMFCCampo + sC 
					sCampo += " id=" + sC + sMFCCampo + sC 
					sCampo += " placeholder=" + sC + sMFCPlaceHolder + sC
					sCampo += ">"
					
					if(!EsVacio(sMFCTextoAyuda)){
						//Ayuda
						sCampo += "<span class='help-block'>"
						sCampo += "<i class='fa fa-question-circle'></i>&nbsp;"
						sCampo += sMFCTextoAyuda
						sCampo += "</span>"
					}
					
					break;
					
				case 9:	// 9 = Text Area
					
					sCampo = "<textarea id=" + sC + sMFCCampo + sC
					sCampo += " name=" + sC + sMFCCampo + sC
					sCampo += " placeholder=" + sC + sMFCPlaceHolder + sC
					sCampo += " class=" + sC + sMFCClass + sC + ">"
					sCampo += "</textarea>"
					
					if(!EsVacio(sMFCTextoAyuda)){
						//Ayuda
						sCampo += "<span class='help-block'>"
						sCampo += "<i class='fa fa-question-circle'></i>&nbsp;"
						sCampo += sMFCTextoAyuda
						sCampo += "</span>"
					}
					
					break;
					
				case 10:					//			10 = Sí / no
					break;
					
				case 11:	//11 = text box doble para rangos
					break;
					
				case 12:	//12 = text box doble para rangos fechas
				/*
					sCampo = " <input type=" + sC + "hidden" + sC  
					sCampo += " name=" + sC + sMFCCampo + sC 
					sCampo += " id=" + sC + sMFCCampo + sC 
					sCampo += " value=" + sC + "" + sC + "> "
					
					sCampo += "<div class='form-group'>"
						//Rango de fecha - Desde
						sCampo += "<div class='col-md-2'>"
							sCampo += "<div class='input-group'>"
								sCampo += "<input name=" + sC + "FechaDesde" + sMFCCampo + sC + " id=" + sC + "FechaDesde" + sMFCCampo + sC
								sCampo += " placeholder=" + sC + sMFCPlaceHolder + sC + " type=" + sC + "text" + sC
								sCampo += " data-date-format=" + sC + "dd/mm/yyyy" + sC + " data-date-viewmode=" + sC + "years" + sC
								sCampo += " class=" + sC + "form-control date-picker" + sC + " value=" + sC
								sCampo += FormatoFecha(Parametro(sMFCCampo,'') ,'UTC a dd/mm/yyyy') + sC
								sCampo += " >"
								sCampo += " <span class=" + sC + "input-group-addon" + sC + " > <i class='fa fa-calendar'></i> </span>"
							sCampo += "</div>"
						sCampo += "</div>"
						//Rango de fecha - Hasta
						sCampo += "<div class='col-md-2'>"
							sCampo += "<div class='input-group'>"
								sCampo += "<input name=" + sC + "FechaHasta" + sMFCCampo + sC + " id=" + sC + "FechaHasta" + sMFCCampo + sC
								sCampo += " placeholder=" + sC + sMFCPlaceHolder + sC + " type=" + sC + "text" + sC
								sCampo += " data-date-format=" + sC + "dd/mm/yyyy" + sC + " data-date-viewmode=" + sC + "years" + sC
								sCampo += " class=" + sC + "form-control date-picker" + sC + " value=" + sC
								sCampo += FormatoFecha(Parametro(sMFCCampo,'') ,'UTC a dd/mm/yyyy') + sC
								sCampo += " >"
								sCampo += " <span class=" + sC + "input-group-addon" + sC + " > <i class='fa fa-calendar'></i> </span>"
							sCampo += "</div>"
						sCampo += "</div>"
						
						//Ayuda
//						sCampo += "<span class='help-block'>"
//						sCampo += "<i class='fa fa-question-circle'></i>&nbsp;"
//						sCampo += sMFCTextoAyuda
//						sCampo += "</span>"
						
					sCampo += "</div>"
					
					
					sCampo += "<script type=" + sC + "text/javascript" + sC + ">"
						sCampo += "	$(function(){"
							sCampo += "	$(" + sC + "#" + "FechaDesde" + sMFCCampo + sC + ").datepicker({"
								sCampo += " format: 'dd/mm/yyyy',"
								sCampo += " language: 'es',"
								sCampo += " autoclose: true"
							sCampo += "});"
					
							sCampo += "	$(" + sC + "#" + "FechaHasta" + sMFCCampo + sC + ").datepicker({"
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
//							sCampo += "	newDate.setDate(newDate.getDate() + 1); "
//							sCampo += "	checkout.setValue(newDate); "
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
					*/
					break;
					
				case 13:
				
					sCampo = "<div id=" + sC + sNombreCampo + sC + " class=" + sC + sMFCClass + sC + "></div>"
					
					break;											




				}
					
						
						sResultado += "<label class=" + sC + "col-md-offset-" + iMFCOffset
						sResultado += " col-md-"+ sMFCAnchoEtiqueta + " control-label" + sC + "id=" + sC + "lbl"+ sMFCCampo + sC + ">"
						sResultado += sMFCEtiqueta  
						sResultado += "</label>"
						
						sResultado += "<div class=" + sC + "col-md-"+ sMFCAnchoCampo + sC + ">"
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
		//Cierre de la tabla de secciones
		//sResultado += "</div>"
		
	return sResultado

}


function ArmaMarco() {
	var sG = ""
	
	sG = "<div class=" + sC + "form-horizontal" + sC + "id=" + sC + "frmBuscador" + sC + "name=" + sC + "frmBuscador" + sC + ">"
	
	sG += CargaBotones()

	sG += CargaDatos()
	
	sG += "</div>"
	
	return sG
	
}

//LimpiaValores()
LeerParametrosdeBD()
EscribeParametrosdeBusquedaBD("")

var sC = String.fromCharCode(34)
var Accion = Parametro("Accion","Consulta")
var Modo = Parametro("Modo","Consulta")

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




