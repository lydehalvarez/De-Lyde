<!--#include file="../../Includes/iqon.asp" -->
<%

function ImprimeRenglon(TipoRenglon,Texto,IDSeg) {
var segBase = IDSeg * 10
var segID = 0
var estilo = "fontBlack " + TipoRenglon
var Renglon  = "<tr onMouseOver=\"styleSwap(this,'hover','normal','rowHiliten');\" "
    Renglon += " onMouseOut=\"styleSwap(this,'normal','hover','rowHiliten');\">"
    Renglon += " <td class=\"" + estilo + "\" width=\"78\" height=\"22\" align=\"center\" > "
		segID = segBase + 1
		Renglon += " <input type=\"checkbox\" name=\"chkSeg\" id=\"chkSeg\" value=\"" 
		Renglon += segID + "\"  " + ArrBuscaValor(arSeg_No,segID," checked ")
		Renglon += " > " //+ IDSeg
	Renglon += " </td><td class=\"" + estilo + "\" width=\"71\" height=\"22\" align=\"center\" > "
    if (EspacioLateral > 25 ) {
		segID = segBase + 2 
		Renglon += " <input type=\"checkbox\" name=\"chkSeg\" id=\"chkSeg\" value=\"" 
		Renglon += segID + "\"  " + ArrBuscaValor(arSeg_No,segID," checked ")
		Renglon += " > " //+ segID
    } else {
		Renglon += "&nbsp;"
	}
    Renglon += " </td> <td class=\"" + estilo + "\" width=\"61\" height=\"22\" align=\"center\" > "
    if (EspacioLateral > 25 ) {
		segID = segBase + 4
		Renglon += " <input type=\"checkbox\" name=\"chkSeg\" id=\"chkSeg\" value=\"" 
		Renglon += segID + "\"  " + ArrBuscaValor(arSeg_No,segID," checked ")
		Renglon += " > " //+ segID
    } else {
		Renglon += "&nbsp;"
	}
    Renglon += " </td><td class=\"" + estilo + "\" width=\"58\" height=\"22\" align=\"center\" > "
    if (EspacioLateral > 25 ) {
		segID = segBase + 8
		Renglon += " <input type=\"checkbox\" name=\"chkSeg\" id=\"chkSeg\" value=\"" 
		Renglon += segID + "\"  " + ArrBuscaValor(arSeg_No,segID," checked ")
		Renglon += " > " //+ segID
    } else {
		Renglon += "&nbsp;"
	}
    Renglon += " </td><td class=\"" + estilo + "\" height=\"22\" "
	Renglon += " style=\"padding-left:" + EspacioLateral + "\" > "
    if (EspacioLateral == 25 ) {
		Renglon += "<strong>" + Texto + "</strong>"
    } else {
		Renglon += Texto
	}
    Renglon += "&nbsp;</td></tr> "

	return Renglon
}


function ArmaArbol(ID) {

	var sArbolito = ""
	var sConsultaGral = "Select * "
		sConsultaGral += " from Menu "
		sConsultaGral += " where Mnu_Padre = " + ID // + " or Mnu_ID = " + ID + " )"
		sConsultaGral += " and Sys_ID = " + SistemaActual
		sConsultaGral += " Order by Mnu_Orden "
	
	EspacioLateral += 25
	var rsINS = AbreTabla(sConsultaGral,1,2)
	while (!rsINS.EOF){
		if (TipoRenglon == "evenRow") {
			TipoRenglon = "oddRow"
		} else {
			TipoRenglon = "evenRow"
		}
		sArbolito += ImprimeRenglon(TipoRenglon,rsINS.Fields.Item("Mnu_Titulo").Value,rsINS.Fields.Item("Mnu_IDSeguridad").Value)
		sArbolito += ArmaArbol(rsINS.Fields.Item("Mnu_ID").Value)
		if ( rsINS.Fields.Item("Mnu_SiguienteVentana").Value > 0 ) {
			EspacioLateral += 25
			sArbolito += ArmaArbol(rsINS.Fields.Item("Mnu_SiguienteVentana").Value)
			EspacioLateral -= 50
		}
		EspacioLateral -= 25
		rsINS.MoveNext() 
	}
	rsINS.Close()  
	
	return sArbolito
}

function ArmaPrimerRenglon(ID) {
	var sArbolito = ""
	var sConsultaGral = "Select * "
		sConsultaGral += " from Menu "
		sConsultaGral += " where Mnu_ID = " + ID 
		sConsultaGral += " and Sys_ID = " + SistemaActual
		sConsultaGral += " Order by Mnu_Orden "
	
	EspacioLateral += 25
	var rsINS = AbreTabla(sConsultaGral,1,2)
	while (!rsINS.EOF){
		if (TipoRenglon == "evenRow") {
			TipoRenglon = "oddRow"
		} else {
			TipoRenglon = "evenRow"
		}
		sArbolito += ImprimeRenglon(TipoRenglon,rsINS.Fields.Item("Mnu_Titulo").Value,rsINS.Fields.Item("Mnu_IDSeguridad").Value)
//		sArbolito += ArmaArbol(rsINS.Fields.Item("Mnu_ID").Value)
//		if ( rsINS.Fields.Item("Mnu_SiguienteVentana").Value > 0 ) {
//			EspacioLateral -= 25
//			sArbolito += ArmaArbol(rsINS.Fields.Item("Mnu_SiguienteVentana").Value)
//			EspacioLateral += 25
//		}
		EspacioLateral -= 25
		rsINS.MoveNext() 
	}
	rsINS.Close()  
	
	return sArbolito

}


function CargaComboSeccionesMenu() {

var sElemento = ""

	sElemento = "<select name='Mnu_ID' class='CajasTexto' onChange='javascript:CambiaCombo();' >"

	var CCSQL = "Select Mnu_ID, Mnu_Titulo FROM Menu "
		CCSQL += " Where Mnu_Padre = 0 and Mnu_EsMenu = 1 and Sys_ID = " + SistemaActual
		CCSQL += " Order By Mnu_Orden "
		
	//Response.Write(CCSQL)
	var rsCC = AbreTabla(CCSQL,1,2) 
	while (!rsCC.EOF){
		sElemento += "<option value='" + rsCC.Fields.Item(0).Value + "'"
		if (Parametro("Mnu_ID",-2) == -2) { 
			ParametroCambiaValor("Mnu_ID",rsCC.Fields.Item(0).Value)
		}
		if (Parametro("Mnu_ID",1) == rsCC.Fields.Item(0).Value) { sElemento += " selected " }
		sElemento += ">" + rsCC.Fields.Item(1).Value + "</option>"
		rsCC.MoveNext()
	}
	rsCC.Close()
	sElemento += "</select>"

	return sElemento

}

function CargaDatos() {

var sG = ""
    sG += "<table width=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\"><tr><td width=\"2%\" class=\"FichaBorde\">&nbsp;</td><td width=\"96%\">"
    sG += "<table width=\"100%\" border=\"0\" cellspacing=\"1\" cellpadding=\"0\">"
    sG += "<tr><td height=\"22\" align=\"center\" class=\"GridSubTitulos\">Secci&oacute;n</td><td height=\"22\" colspan=\"3\" align=\"left\">&nbsp;"
   
	sG += CargaComboSeccionesMenu() 
	
    sG += "</td><td height=\"22\" >&nbsp;</td></tr>"
    sG += "<tr><td class=\"TablaEncabezado\" width=\"78\" height=\"22\" align=\"center\">Consultar</td>"
    sG += "<td class=\"TablaEncabezado\" width=\"71\" height=\"22\" align=\"center\">Agregar</td>"
    sG += "<td class=\"TablaEncabezado\" width=\"61\" height=\"22\" align=\"center\">Borrar</td>"
    sG += "<td class=\"TablaEncabezado\" width=\"58\" height=\"22\" align=\"center\">Editar</td>"
    sG += "<td class=\"TablaEncabezado\" width=\"598\" height=\"22\" align=\"right\">&nbsp;</td></tr>"
	sG += ArmaPrimerRenglon(Parametro("Mnu_ID",0))  
	sG += ArmaArbol(Parametro("Mnu_ID",0))  

    sG += "</table></td><td width=\"2%\" class=\"FichaBorde\" >&nbsp;</td></tr></table>"

	return sG
	
}


function DespliegaSeguridad() {

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
	sG += "<tr><td width=\"72%\" height=\"25\" class=\"GridSubTitulos\">Permisos del Usuario: " + NombreUsuario + "&nbsp;</td>"
	sG += "<td width=\"28%\" >"
	
	//Area de botones y comandos
	sG += "<table width=\"100%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\"><tr>"
	sG += "<td class=\"GridSubTitulos\">&nbsp;<input type=\"checkbox\" name=\"chkTodos\" id=\"chkTodos\" onClick=\"javascript:CheckAll();\">Marcar todos los permisos</td>"
	sG += "<td>&nbsp;</td>"
	sG += "<td  align=\"right\"><input name=\"btnGuardar\" type=\"button\" class=\"Botones\" id=\"btnGuardar\" value=\"Guardar\" onClick=\"javascript:AcFGuardar();\" ></td>"
	sG += "</tr></table>"
    sG += "</td></tr>"

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
	sG += "<input type=" + sC + "hidden" + sC + " name=" + sC + "Usu_ID" + sC + " id=" + sC + "Usu_ID" + sC + " value=" + sC + Parametro("Usu_ID",-1) + sC + ">"
	sG += "<input type=" + sC + "hidden" + sC + " name=" + sC + "Notifica" + sC + " id=" + sC + "Notifica" + sC + " value=" + sC + Parametro("Notifica",0) + sC + ">"
    sG += "<input type=" + sC + "hidden" + sC + " name=" + sC + "NombreGrupo" + sC + " id=" + sC + "NombreGrupo" + sC + " value=" + sC + NombreUsuario + sC + ">"
	
	return sG

}


if (!bHayParametros) { LeerParametrosdeBD() }

ParametroCambiaValor("Notifica",0)
var SistemaActual = Parametro("SistemaActual",0)
var VentanaIndex  = Parametro("VentanaIndex",0)
var IDUsuario     = Parametro("IDUsuario",0)
var UsuID         = Parametro("Usu_ID",-1)
var NombreUsuario = ""

var sC = String.fromCharCode(34)
var Accion = Parametro("Accion","Consulta")
var Modo = Parametro("Modo","Consulta")
var TipoRenglon = "oddRow"
var EspacioLateral = 0
var chkSeg = Parametro("chkSeg","")
var arrSeg = new Array(0)

if (Accion == "Guardar") {
	var sys1 = 0
	var sys3 = ""
	var sys6 = SistemaActual
	var sys2 = UsuID
	var sys4 = Parametro("Mnu_ID",0)
	var sVal = ""
	var iLargo = 0
	//sys1 permiso
	//sys2 Usu_ID      Usu_ID
	//sys3 permisos
	//sys4 Mnu_Padre   Mnu_ID   systobjects
	//sys5 completo   
	//sys6 system id   Sys_ID
	//sys7 GruID       Gru_ID
	//sys8 iqCliID     iqCli_ID
	
	var sSQL = " Delete From systobjects "
		sSQL  += " WHERE sys2 = " + sys2
		sSQL  += " AND sys6 = " + sys6
		sSQL  += " AND sys4 = " + sys4
		sSQL  += " AND sys8 = " + iqCli_ID

		Ejecuta(sSQL ,2)	

	var sSQL = " Update Usuario Set "
		sSQL  += " Usu_Grupo = -1 "
		sSQL  += " WHERE Usu_ID = " + UsuID
		sSQL  += " AND Sys_ID = " + SistemaActual
		sSQL  += " AND iqCli_ID = " + iqCli_ID

		Ejecuta(sSQL ,0)	

	if (chkSeg != "") {
		ConvierteAAreglo(arrSeg,chkSeg)
		for (i=0;i<=arrSeg.length-1;i++){
			sVal = ""
			sVal = String(arrSeg[ i ])
			iLargo = sVal.length
			sys1 = sVal.substr(iLargo-1,1)
			sys3 = sVal.substr(0,iLargo-1)

			var sSQL = " Insert Into systobjects (sys1, sys2, sys3, sys4, sys5, sys6, sys7, sys8 ) "
				sSQL  += " Values ( " 
				sSQL  += " " + sys1
				sSQL  += ", " + sys2
				sSQL  += ", " + sys3
				sSQL  += ", " + sys4
				sSQL  += ", " + arrSeg[ i ] 
				sSQL  += ", " + sys6
				sSQL  += ", -1"  
				sSQL  += ", " + iqCli_ID 
				sSQL  += " ) "
				Ejecuta(sSQL ,2)	
		}
	}
	ParametroCambiaValor("Notifica",1)
	ParametroCambiaValor("Accion","Consulta")
	ParametroCambiaValor("Modo","Consulta")
	Accion = "Consulta"
	Modo = "Consulta"

}


var arSeg_No = new Array(0)
var sSeg_No = ""

var sConsPrimeraVez ="( select min(Mnu_ID) from Menu where Sys_ID = " + SistemaActual 
	sConsPrimeraVez +=" and Mnu_Padre = 0  and Mnu_EsMenu = 1 )" 


if (Accion == "Consulta" || Accion == "Vuelta" ) {
	var sSQL  = "Select * "
		sSQL += " from systobjects "
		sSQL += " WHERE sys2 = " + UsuID
		sSQL += " AND sys4 = " + Parametro("Mnu_ID",sConsPrimeraVez)
		sSQL += " AND sys6 = " + SistemaActual
		sSQL += " AND sys8 = " + iqCli_ID

	var rsINS = AbreTabla(sSQL,1,2)
	while (!rsINS.EOF){
		if (sSeg_No != "") { sSeg_No += ", " }
		sSeg_No += rsINS.Fields.Item("sys5").Value
		rsINS.MoveNext()
	}
} else {
	sSeg_No = Parametro("chkSeg","")
}
ConvierteAAreglo(arSeg_No,sSeg_No)


var Condicion = " Usu_ID = " + UsuID + " AND Sys_ID = " + SistemaActual + " AND iqCli_ID = " + iqCli_ID
	NombreUsuario = BuscaSoloUnDato("Usu_Nombre","Usuario",Condicion,"",0)


Response.Write(DespliegaSeguridad())

%>