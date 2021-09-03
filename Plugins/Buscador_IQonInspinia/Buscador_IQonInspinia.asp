<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../Includes/iqon.asp" -->	
<%

var biQ4Web = false

var sC = String.fromCharCode(34)

function CargaBotones() {

	var sBot = ""

		//Botones 

		sBot = "<div class='form-group'>"
		sBot +=  "<div class='col-md-12'>"
		sBot +=    "<div class='row'>"
		sBot +=      "<div class='col-md-offset-6 col-md-5' style='text-align: right;'  >"
		sBot +=      	"<button class='btn btn-danger' id='btnLimpiar' name='btnLimpiar' type='button' onClick='javascript:RecargaEnSiMismo();'>Limpiar&nbsp;<i class='fa fa-eraser'></i></button>"
		sBot +=      	"&nbsp;<button class='btn btn-primary' name='bt_Buscar' id='bt_Buscar' type='button' onClick='javascript:AcBuscadorBuscar();'>Buscar&nbsp;<i class='fa fa-search'></i></button>"  
		sBot += 	 "</div>"				
		sBot +=    "</div>"																														 
		sBot +=  "</div>"
		sBot += "</div>"
		sBot += "<script type='application/javascript'>"
		sBot += "$(document).keypress(function(event){ "
		sBot += " var keycode = (event.keyCode ? event.keyCode : event.which); if(keycode == '13'){ "
		sBot += "AcBuscadorBuscar()"
		sBot += "}});"
		sBot += "</script>"

	return sBot

}


// 2 = option -- Radio
function OpcionesFicha(NombreCaja,EventosClases,SarrOpciones,SarrValores,ValorActual,sOpcAyuda,Modo) {

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

		sRespuesta += "<label class='radio-inline i-checks'>"
		sRespuesta += "<input type='radio' name='" + NombreCaja + "' id='" + NombreCaja + i +"' " 
		sRespuesta += " value='" + ValoresOpc[i] + "' "
		if (ValoresOpc[i] == ValorActual || i==0) { sRespuesta += " checked " }
		sRespuesta += ">"
		sRespuesta += "<i></i>&nbsp;"
		sRespuesta += Opciones[i]
		sRespuesta += "</label>"

	}

	if(!EsVacio(sOpcAyuda)){
		sRespuesta += "<span class='help-block m-b-none'><i class='fa fa-question-circle'></i>"
		sRespuesta += "&nbsp;" + sOpcAyuda
		sRespuesta += "</span>"
	}


	return sRespuesta

}


// 4 = combo	
function CargaComboFicha(NombreCombo,Eventos,CampoID,CampoDescripcion,Tabla,Condicion,Orden,Seleccionado,Conexion,Todos,Modo,Estilo,sOpcAyuda) {

	var sElemento = ""
	var sResultado = ""

	if (EsVacio(Seleccionado)) {Seleccionado = -1 }

	sResultado = "<select name='" + NombreCombo + "' id='" + NombreCombo  +"' " + Eventos 
	sResultado += " class='" + Estilo + "' >"

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


	return sResultado
}


// 5 = checkbox
function CajaSeleccion(NombreCaja,EventosClases,ValorParametro,Valor,Modo,sOpcAyuda) {

	var sRespuesta = ""

		sRespuesta += "<label class='" + EventosClases + "'>"
			sRespuesta += "<input name='" + NombreCaja + "' type='checkbox' " + EventosClases
			sRespuesta += " id='" + NombreCaja + "' value='" + Valor + "' "
			if (ValorParametro == Valor ) {
				sRespuesta +=  " checked "
			}
			//sRespuesta += " class='" + EventosClases + "' >"
			sRespuesta += " >"
		sRespuesta += "</label>"

		if(!EsVacio(sOpcAyuda)){
			sRespuesta += "<span class='help-block m-b-none'><i class='fa fa-question-circle'></i>"
			sRespuesta += "&nbsp;" + sOpcAyuda
			sRespuesta += "</span>"
		}


	return sRespuesta

}


// 7 = combo Catálogo General	
function ComboSeccionFicha(NombreCombo,Eventos,Seccion,Seleccionado,Conexion,Todos,Orden,Modo,Estilo,sOpcAyuda) {

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

		if(!EsVacio(sOpcAyuda)){
			sResultado += "<span class='help-block m-b-none'><i class='fa fa-question-circle'></i>"
			sResultado += "&nbsp;" + sOpcAyuda
			sResultado += "</span>"
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
		sATCps += " AND Mnu_ID = " + VentanaIndex    //Parametro("VentanaIndex",1)
		sATCps += " ORDER BY MFS_Orden "

		if (biQ4Web) {
			Response.Write("<br /><font color='red' size='1'><strong>"+sATCps +"</strong></font><br />")
		}	  

		var rsSeccion = AbreTabla(sATCps,1,2)

		sResultado = " <!-- Manejo de las secciones -->"


		while (!rsSeccion.EOF){

			// ========== Manejo de las secciones involucradas {start}

			//sResultado += "<div class='ibox-content forum-container'>"
				sResultado += "<div class='" + rsSeccion.Fields.Item("MFS_Class").Value + "'>"

					if(!EsVacio(rsSeccion.Fields.Item("MFS_Icono").Value)) {
						sResultado += "<div class='forum-icon'>"
							sResultado += "<i class='" + rsSeccion.Fields.Item("MFS_Icono").Value + "'></i>"
						sResultado += "</div>"
					}

					sResultado += "<a href='#' class='forum-item-title' style='pointer-events: none'><h3>"
					sResultado += rsSeccion.Fields.Item("MFS_Nombre").Value + "</h3></a>"
					sResultado += "<div class='forum-sub-title'>" 
					sResultado += rsSeccion.Fields.Item("MFS_Subtitulo").Value + "</div>"

				sResultado += "</div>"
			//sResultado += "</div>"	

			// ========== Manejo de las secciones involucradas {start}

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

				//Sys_ID - Mnu_ID - WgCfg_ID

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

			//Campos [Inicio]
			while (!rsCampos.EOF){		


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


				//sResultado += "<div class='form-group'><!-- row&nbsp;" + iContRen + " - renglon -->"
				if (biQ4Web) { Response.Write("<br /><font color='red' size='2'><strong>iMFCRenglon&nbsp;"+iMFCRenglon+"&nbsp;iColPorSecReg"+iColPorSecReg+"&nbsp;iRegPorSec&nbsp;"+iRegPorSec+"</strong></font><br>") } 

				if (iMFCRenglon != iContRow) {
					iContRen++
					iContRow = iMFCRenglon
					//sResultado += "<!-- row&nbsp;" + iContRen + " - renglon -->"
					sResultado += "<div class='form-group'>" //{start form-group}
					sResultado += "<div class='col-md-12'>" //{start col-md-12}
					sResultado += "<div class='row'>"	//{start row}

				} 

				if (biQ4Web) { 
					Response.Write("<font color='red' size='2'><strong>M&aacute;ximo - Rows x secci&oacute;n&nbsp;" + iRegPorSec + "&nbsp;M&aacute;ximo - Cols x secci&oacute;n&nbsp;" + iColPorSecReg + "&nbsp;Renglon actual:&nbsp;"+iMFCRenglon+"&nbsp;Contador de renglon:&nbsp;"+iContRow+"</strong></font><br />")  
				}	   


				if(parseInt(iColPorSecReg) == parseInt(iContCol)) {
					bCierraRow = true
					//iContRow = 0
					iContCol = 0	
				}

				if (biQ4Web) {
					Response.Write("<br />&nbsp;<font color='red' size='2'><strong>bCierraRow&nbsp;"+bCierraRow+"&nbsp;</strong></font><br />")
				}

				sCampo = ""

				//Se cargan los campos de la seccion actual
				if (biQ4Web) {
					Response.Write("<br /><font color='red' size='2'><strong>iMFCTipoCampo&nbsp;"+parseInt(iMFCTipoCampo)+"</strong></font><br />")
				}

				//Response.End()

				switch (parseInt(iMFCTipoCampo)) {

					// 1 = text box
					case 1:				

						sCampo += "<label class='col-md-offset-"+iMFCOffset+" col-md-"+sMFCAnchoEtiqueta+" control-label' id='lbl"+sMFCCampo + "'>"+sMFCEtiqueta+"</label>"

						sCampo += "<div class='col-md-"+sMFCAnchoCampo +  "'><input type='text' " 
						sCampo += " placeholder='" + sMFCPlaceHolder + "' " 
						sCampo += " class='" + sMFCClass + "' "
						sCampo += " name='" + sMFCCampo + "' "
						sCampo += " id='" + sMFCCampo + "'>"

							if(!EsVacio(sMFCTextoAyuda)){
								sCampo += "<span class='help-block m-b-none'><i class='fa fa-question-circle'></i>"
								sCampo += "&nbsp;" + sMFCTextoAyuda
								sCampo += "</span>"
							}

						sCampo += "</div>"

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

						if (!EsVacio(sMFCClass)) {
							Eventos = "" + sMFCClass + " "
						}
						if (!EsVacio(sMFCEventosJS)) {
							Eventos += "  " + sMFCEventosJS 
						}


						sCampo += "<label class='col-md-offset-"+iMFCOffset+" col-md-"+sMFCAnchoEtiqueta+" control-label' id='lbl"+sMFCCampo + "'>"+sMFCEtiqueta+"</label>"

						sCampo += "<div class='col-md-"+sMFCAnchoCampo + "' >"
							sCampo += "&nbsp;" + OpcionesFicha(sMFCCampo,Eventos,SarrOpciones,SarrValores,Parametro(sMFCCampo,sMFCValorDefault),sMFCTextoAyuda,Modo)
						sCampo += "</div>"

						sCampo += "<script type='text/javascript'> "

							sCampo += " $('.i-checks').iCheck({ "
								sCampo += " checkboxClass: 'icheckbox_square-green' "
								sCampo += ", radioClass: 'iradio_square-green' "
							sCampo += " }); "

						sCampo += "</script>"


					break;

					// 3 = vacio

					case 3:	

					break;

					// 4 = combo

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

						var sOrden = ""
						if (!EsVacio(sMFCOrden)) {
							sOrden =  " " + sMFCOrden + " "
						}

						var sTodos = "Seleccione una opci&oacute;n"
						if (!EsVacio(sMFCLeyendaSelecTodos)) {
							sTodos = sMFCLeyendaSelecTodos
						}


						sCampo += "<label class='col-md-offset-"+iMFCOffset+" col-md-"+sMFCAnchoEtiqueta+" control-label' id='lbl"+sMFCCampo + "'>"+sMFCEtiqueta+"</label>"


						sCampo += "<div class='col-md-"+sMFCAnchoCampo + "'>"

						sCampo += "" + CargaComboFicha(sMFCCampo,sEventos,sLlave,sCampoDescripcion,sTabla,sCondicion,sOrden,Parametro(sMFCCampo,sMFCValorDefault),0,sTodos,"Editar",sEstilo,sMFCTextoAyuda)


						sCampo += "</div>"

						sCampo += "<script type='text/javascript'> "

						sCampo += "	$(document).ready(function () { "

						sCampo += " $('#"+sMFCCampo+"').select2(); "

						sCampo += " });"

						sCampo += "</script>"


					break;

					// 5 = checkbox

					case 5:

						var Eventos = ""
						if (!EsVacio(sMFCClass)) {
							Eventos = "class='" + sMFCClass + "'  "
						}


						sCampo += "<label class='col-md-offset-"+iMFCOffset+" col-md-"+sMFCAnchoEtiqueta+" control-label' id='lbl"+sMFCCampo + "'>"+sMFCEtiqueta+"</label>"

						sCampo += "<div class='col-md-"+sMFCAnchoCampo + "'>"	

						sCampo += "" + CajaSeleccion(sMFCCampo,Eventos,Parametro(sMFCCampo,1),1,Modo,sMFCTextoAyuda)	

						sCampo += "</div>"

						sCampo += "<script type='text/javascript'> "

							sCampo += " $('.i-checks').iCheck({ "
								sCampo += " checkboxClass: 'icheckbox_square-green' "
								sCampo += ", radioClass: 'iradio_square-green' "
							sCampo += " }); "

						sCampo += "</script>"

					break;

					// 6 = fecha

					case 6:

						sCampo += "<label class='col-md-offset-"+iMFCOffset+" col-md-"+sMFCAnchoEtiqueta+" control-label' id='lbl"+sMFCCampo + "'>"+sMFCEtiqueta+"</label>"

						sCampo += "<div class='col-md-"+sMFCAnchoCampo + "' id='date"+sMFCCampo+"'>"

							sCampo += "<div class='input-group date'>"
								sCampo += "<span class='input-group-addon' > <i class='fa fa-calendar'></i> </span>"
								sCampo += "<input name='" + sMFCCampo + "' id='" +sMFCCampo + "' "
								sCampo += " placeholder='" +sMFCPlaceHolder + "' type='text' " 
								sCampo += " class='form-control' value='"  
								sCampo += FormatoFecha(Parametro(sMFCCampo,'') ,'UTC a dd/mm/yyyy') 
								sCampo += "' >"
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


					break;

					// 7 = combo Catálogo General

					case 7:

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

						var sTodos = "Seleccione una opci&oacute;n"
						if (!EsVacio(sMFCLeyendaSelecTodos)) {
							sTodos = sMFCLeyendaSelecTodos
						}

						var sSeccion = "1"
						if (!EsVacio(iMFCIDCatalogoGeneral)) {
							sSeccion = iMFCIDCatalogoGeneral
						}	


						sCampo += "<label class='col-md-offset-"+iMFCOffset+" col-md-"+sMFCAnchoEtiqueta+" control-label' id='lbl"+sMFCCampo + "'>"+sMFCEtiqueta+"</label>"


						sCampo += "<div class='col-md-"+sMFCAnchoCampo + "' >"

						sCampo += "" + ComboSeccionFicha(sMFCCampo,sEventos,sSeccion,Parametro(sMFCCampo,sMFCValorDefault),0,sTodos,sOrden,"Editar",sEstilo,sMFCTextoAyuda)

						sCampo += "</div>"

						sCampo += "<script type='text/javascript'> "

							sCampo += "	$(document).ready(function () { "

							sCampo += " $('#"+sMFCCampo+"').select2(); "

							sCampo += " });"

						sCampo += "</script>"


					break;

					// 8 = password

					case 8:

						sCampo += "<label class='col-md-offset-"+iMFCOffset+" col-md-"+sMFCAnchoEtiqueta+" control-label' id='lbl"+sMFCCampo + "'>"+sMFCEtiqueta+"</label>"

						sCampo += "<div class='col-md-"+sMFCAnchoCampo + "'><input type='password' " 
						sCampo += " placeholder='" +sMFCPlaceHolder + "' " 
						sCampo += " class='" + sMFCClass + "' "
						sCampo += " name='" + sMFCCampo + "' "
						sCampo += " id='" + sMFCCampo + "'>"

							if(!EsVacio(sMFCTextoAyuda)){
								sCampo += "<span class='help-block m-b-none'><i class='fa fa-question-circle'></i>"
								sCampo += "&nbsp;" + sMFCTextoAyuda
								sCampo += "</span>"
							}

						sCampo += "</div>"

					break;

					// 9 = Text Area	

					case 9:	

						sCampo += "<label class='col-md-offset-"+iMFCOffset+" col-md-"+sMFCAnchoEtiqueta+" control-label' id='lbl"+sMFCCampo + "'>"+sMFCEtiqueta+"</label>"

							sCampo += "<div class='col-md-"+sMFCAnchoCampo + "' >"
							sCampo += "<textarea id='" + sMFCCampo + "' "
							sCampo += " name='" + sMFCCampo + "' "
							sCampo += " placeholder='" + sMFCPlaceHolder + "' "
							sCampo += " class='" + sMFCClass + "'>"
							sCampo += sMFCValorDefault	
							sCampo += "</textarea>"

							if(!EsVacio(sMFCTextoAyuda)){
								sCampo += "<span class='help-block m-b-none'><i class='fa fa-question-circle'></i>"
								sCampo += "&nbsp;" + sMFCTextoAyuda
								sCampo += "</span>"
							}

						sCampo += "</div>"

					break;

					// 	10 = vacio -- Sí / no

					case 10:	


					break;

					//  11 = vacio -- text box doble para rangos

					case 11:	


					break;

					//  12 = text box doble rangos de fechas con datepicker

					case 12:		
						

					break;

					//  13 = div para el manejo de cualquier cosa 

					case 13:

						sCampo = "<div id='" + sMFCCampo + "' class='" + sMFCClass + "'></div>"

					break;											

					//  14 = vacio

					case 14: 
	
					break;
	
					//  15 = vacio

					case 15:  		
	
					break;
	
					//  16 = vacio

					case 16:  		
	
					break;	
					
					//========= Esto solo será para los buscadores dado que se manejan diferentes tipos de fecha [date - datetime]
					//coloque esto porque en en el manejo de las condiciones se maneja este tipo de campo //JD 31/01/2016
	
					case 17:	//  17 / 6 = fecha - tipo campo date
					case 18: 	//  18 / 6 = fecha - tipo campo datetime

						sCampo += "<label class='col-md-offset-"+iMFCOffset+" col-md-"+sMFCAnchoEtiqueta+" control-label' id='lbl"+sMFCCampo + "'>"+sMFCEtiqueta+"</label>"

						sCampo += "<div class='col-md-"+sMFCAnchoCampo + "' id='date"+sMFCCampo + "'>"

							sCampo += "<div class='input-group date'>"
								sCampo += "<span class='input-group-addon' > <i class='fa fa-calendar'></i> </span>"
								sCampo += "<input name='" + sMFCCampo + "' id='" + sMFCCampo +  "' "
								sCampo += " placeholder='" + sMFCPlaceHolder + "' type='text' "  
								sCampo += " class='form-control' value='" 
								sCampo += FormatoFecha(Parametro(sMFCCampo,'') ,'UTC a dd/mm/yyyy') + "' "
								sCampo += " >"
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
	
					break;
	
					// 19 / 12 = text box doble rangos de fechas estilo template
							
					case 19: 	//text box doble rangos de fechas estilo template tipo date
					case 20: 	//text box doble rangos de fechas estilo template tipo datetime
	
						sCampo += "<label class='col-md-offset-"+iMFCOffset+" col-md-"+sMFCAnchoEtiqueta+" control-label' id='lbl"+sMFCCampo + "'>"+sMFCEtiqueta+"</label>"

							sCampo += "<div class='col-md-" + sMFCAnchoCampo + "' id='" + sMFCCampo + "'>"	

								sCampo += "<div class='input-daterange input-group' id='" + sMFCCampo + "'>"

									sCampo += "<input type='text'class='input-sm form-control' " 
									sCampo += " placeholder='" + sMFCPlaceHolder +  "' "
									sCampo += " name='FechaDesde" + sMFCCampo + "' id='FechaDesde" + sMFCCampo +  "' " 
									sCampo += " value='" + FormatoFecha(Parametro(sMFCCampo,'') ,'UTC a dd/mm/yyyy') +  "' " 
									sCampo += " />"
									sCampo += "<span class='input-group-addon'>a</span>"

									sCampo += "<input type='text'class='input-sm form-control' " 
									sCampo += " placeholder='" + sMFCPlaceHolder +  "' "
									sCampo += " name='FechaHasta" + sMFCCampo + "' id='FechaHasta" + sMFCCampo +  "' " 
									sCampo += " value='" + FormatoFecha(Parametro(sMFCCampo,'') ,'UTC a dd/mm/yyyy') +  "' " 
									sCampo += " />"

								sCampo += "</div>"

								if(!EsVacio(sMFCTextoAyuda)){
									sCampo += "<span class='help-block m-b-none'><i class='fa fa-question-circle'></i>"
									sCampo += "&nbsp;" + sMFCTextoAyuda
									sCampo += "</span>"
								}


							sCampo += "</div>"
	
							sCampo += "<script type='text/javascript'> "

							sCampo += " $('#"+sMFCCampo+" .input-daterange').datepicker({ "
								sCampo += " format: 'dd/mm/yyyy',"
								sCampo += " todayBtn: 'linked',"
								sCampo += " language: 'es',"
								sCampo += " keyboardNavigation: false,"
								sCampo += " forceParse: false,"
								sCampo += " todayHighlight: true, "
								sCampo += " autoclose: true "
							sCampo += " }); "

							sCampo += "</script>"
	
					break;
	
	
	
	
	

				}

				sResultado += sCampo


				if(bCierraRow) {
					sResultado += "</div>" //{end row}
					sResultado += "</div>" //{end col-md-12}
					sResultado += "</div>" //{end form-group}
					sResultado += "<div class='hr-line-dashed'></div>"
					//if(iMFCRenglon) {
						/*sResultado += "<div class='row'>"
							sResultado += "<div class='col-md-12'>"
								sResultado += "<div class='hr-line-dashed'>fin</div>"
							sResultado += "</div>"
						sResultado += "</div>"*/
					//}
				}

				rsCampos.MoveNext()

				if (iVueltas > 5) { 
					return "Error al colocar el campo, revise las posiciones de columnas y renglones" 
				}

			}

			rsCampos.Close()	//Campos [Fin]



			rsSeccion.MoveNext()

		}

		rsSeccion.Close()	



   return sResultado

 }


function ArmaMarco() {
	var sG = ""

	//sG = "<div class='ibox-content'>"
	sG = "<div class='ibox-content forum-container'>"								
		sG += "<div class='form-horizontal'id='frmBuscador'name='frmBuscador'>"

		sG += CargaBotones()

		sG += CargaDatos()

		sG += "</div>"

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

