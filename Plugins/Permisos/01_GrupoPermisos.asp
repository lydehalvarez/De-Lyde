<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
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
		Renglon += " > " + IDSeg
	Renglon += " </td><td class=\"" + estilo + "\" width=\"71\" height=\"22\" align=\"center\" > "
    if (EspacioLateral > 25 ) {
		segID = segBase + 2 
		Renglon += " <input type=\"checkbox\" name=\"chkSeg\" id=\"chkSeg\" value=\"" 
		Renglon += segID + "\"  " + ArrBuscaValor(arSeg_No,segID," checked ")
		Renglon += " > " + segID
    } else {
		Renglon += "&nbsp;"
	}
    Renglon += " </td> <td class=\"" + estilo + "\" width=\"61\" height=\"22\" align=\"center\" > "
    if (EspacioLateral > 25 ) {
		segID = segBase + 4
		Renglon += " <input type=\"checkbox\" name=\"chkSeg\" id=\"chkSeg\" value=\"" 
		Renglon += segID + "\"  " + ArrBuscaValor(arSeg_No,segID," checked ")
		Renglon += " > " + segID
    } else {
		Renglon += "&nbsp;"
	}
    Renglon += " </td><td class=\"" + estilo + "\" width=\"58\" height=\"22\" align=\"center\" > "
    if (EspacioLateral > 25 ) {
		segID = segBase + 8
		Renglon += " <input type=\"checkbox\" name=\"chkSeg\" id=\"chkSeg\" value=\"" 
		Renglon += segID + "\"  " + ArrBuscaValor(arSeg_No,segID," checked ")
		Renglon += " > " + segID
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
	//Response.Write("<br> ArmaArbol = " + sConsultaGral + "<br>")
	EspacioLateral += 25
	var rsINS = AbreTabla(sConsultaGral,1,2)
	
	while (!rsINS.EOF){
		if (TipoRenglon == "evenRow") {
			TipoRenglon = "oddRow"
		} else {
			TipoRenglon = "evenRow"
		}
		
		var sTitulo = rsINS.Fields.Item("Mnu_Titulo").Value 
		if (bDebugWidgets) { sTitulo +=  " " + rsINS.Fields.Item("Mnu_ID").Value }
		sArbolito += ImprimeRenglon(TipoRenglon,sTitulo,rsINS.Fields.Item("Mnu_IDSeguridad").Value)
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
		//Response.Write("<br> ArmaPrimerRenglon = " + sConsultaGral + "<br>")
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
			EspacioLateral += 25
//		}
		EspacioLateral -= 20
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

function CargaDatos() { %>

<table border="0" cellpadding="0" cellspacing="0" width="100%">
  <tr>
    <td class="FichaBorde" width="2%">&nbsp;</td>
    <td width="96%">
      <table border="0" cellpadding="0" cellspacing="1" width="100%">
        <tr>
          <td align="center" class="GridSubTitulos" height="22">Sección</td>
          <td align="left" colspan="3" height="22">&nbsp; 
<%          CargaComboSeccionesMenu() %>
          </td>
          <td align="right" height="22">&nbsp;</td>
        </tr>
        <tr>
          <td align="center" class="TablaEncabezado" height="22" width="78">Consultar</td>
          <td align="center" class="TablaEncabezado" height="22" width="71">Agregar</td>
          <td align="center" class="TablaEncabezado" height="22" width="61">Borrar</td>
          <td align="center" class="TablaEncabezado" height="22" width="58">Editar</td>
          <td align="right" class="TablaEncabezado" height="22" width="598">&nbsp;</td>
        </tr>
<%        ArmaPrimerRenglon(Parametro("Mnu_ID",0))  
        ArmaArbol(Parametro("Mnu_ID",0))  %>
      </table>
    </td>
    <td class="FichaBorde" width="2%">&nbsp;</td>
  </tr>
</table>

<%
	
}


function DespliegaSeguridad() {  %>

<table border="0" cellpadding="0" cellspacing="0" width="100%">
  <tr>
    <td width="1%">&nbsp;</td>
    <td width="99%"></td>
  </tr>
  <tr>
    <td class="FichaBorde">&nbsp;</td>
    <td>
      <table border="0" cellpadding="0" cellspacing="0" class="TbRedondeada" width="100%">
        <tr>
          <td align="left" valign="top" width="9"></td>
          <td></td>
          <td align="right" valign="top" width="9"></td>
        </tr>
        <tr>
          <td align="left"></td>
          <td align="left" valign="top">
            <table border="0" cellpadding="0" cellspacing="0" width="100%">
              <tr>
                <td align="center" style="padding-right: 1px;padding-left: 1px;" width="15"></td>
                <td align="center" valign="top" width="98%">
                  <table border="0" cellpadding="1" cellspacing="2" width="100%">
                    <tr>
                      <td class="GridSubTitulos" height="25" width="72%">Permisos del Grupo: <%=NombreUsuario%>&nbsp;</td>
                      <td width="28%">
                        <!--  Area de botones y comandos -->
                        <table border="0" cellpadding="0" cellspacing="0" width="100%">
                          <tr>
                            <td class="GridSubTitulos">&nbsp;
                            	<input id="chkTodos" name="chkTodos" onclick="javascript:CheckAll();" type="checkbox">Marcar todos los permisos</td>
                            <td>&nbsp;</td>
                            <td align="right">
                            	<input class="Botones" id="btnGuardar" name="btnGuardar" onclick="javascript:AcFGuardar();" type="button" value="Guardar"></td>
                          </tr>
                        </table>
                      </td>
                    </tr><!--  
//<tr><td height="25" colspan="2">
//El modo entro como " + Parametro("Modo","modovacio") + "  la accion entro como " + Parametro("Accion","accionvacio") 
//</td></tr>
-->
                    <tr>
                      <td colspan="2" height="25"><% CargaDatos() %></td>
                    </tr>
                  </table>
                </td>
                <td align="center" class="padding4" style="padding-right: 1px;padding-left: 1px;" width="15"></td>
              </tr>
            </table>
          </td>
          <td align="right"></td>
        </tr>
        <tr>
          <td align="left" valign="bottom"></td>
          <td></td>
          <td align="right" valign="bottom"></td>
        </tr>
      </table>
    </td>
    <td align="right" class="FichaBorde" width="0%">&nbsp;</td>
  </tr>
</table>

<form>
  <input id="Gru_ID" name="Gru_ID" type="hidden" value="<%=GruID%>"> 
  <input id="Notifica" name="Notifica" type="hidden" value="<%=Parametro("Notifica",0)%>"> 
  <input id="NombreGrupo" name="NombreGrupo" type="hidden" value="<%=NombreUsuario%>"> 
</form>

<%
}


ParametroCambiaValor("Notifica",0)
var SistemaActual = Parametro("SistemaActual",0)
var VentanaIndex  = Parametro("VentanaIndex",0)
var IDUsuario     = Parametro("IDUsuario",0)
var GruID         = Parametro("Gru_ID",-1)
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
	var sys3 = 0
	var sys6 = SistemaActual
	var sys7 = GruID
	var sys2 = 0
	var sys4 = Parametro("Mnu_ID",0)
	var sVal = ""
	var iLargo = 0
	//sys1 permiso
	//sys2 Usu_ID      Usu_ID
	//sys3 id seguridad
	//sys4 seccion mnu_id cbo
	//sys5 completo   
	//sys6 system id
	//sys7 GruID       Gru_ID
	//sys8 iqCliID     iqCli_ID
	
	var sSQL = " Delete From systobjects "
		sSQL  += " WHERE sys7 = " + sys7
		sSQL  += " AND sys6 = " + sys6
		sSQL  += " AND sys4 = " + sys4
		sSQL  += " AND sys8 = " + iqCli_ID
//Response.Write("<br> sCondicion = " + sSQL)
		Ejecuta(sSQL ,2)	


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
				sSQL  += ", -1"
				sSQL  += ", " + sys3
				sSQL  += ", " + sys4
				sSQL  += ", " + arrSeg[i] 
				sSQL  += ", " + sys6 
				sSQL  += ", " + sys7 
				sSQL  += ", " + iqCli_ID 
				sSQL  += " ) "
				
//Response.Write("<br> sCondicion = " + sSQL)
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
	sConsPrimeraVez +=" and Mnu_Padre = 30 and Mnu_EsMenu = 1 )" 


if (Accion == "Consulta" || Accion == "Vuelta" ) {
	var sSQL  = "Select * "
		sSQL += " from systobjects "
		sSQL += " WHERE sys7 = " + GruID
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


var sCondicion = " Gru_ID = " + GruID + " AND Sys_ID = " + SistemaActual + " AND iqCli_ID = " + iqCli_ID
var NombreUsuario = BuscaSoloUnDato("Gru_Nombre","SeguridadGrupo",sCondicion,"",0)
	//Response.Write("<br> sCondicion = " + sCondicion)
	//Response.Write("<br> NombreUsuario = " + NombreUsuario)
	
//		bHayParametros = false
//		ParametroCargaDeSQL(sConsultaSQL,0)

Response.Write(DespliegaSeguridad())

%>