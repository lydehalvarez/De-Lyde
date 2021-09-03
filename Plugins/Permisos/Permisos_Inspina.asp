<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../Includes/iqon.asp" -->
<%
//Usuario que esta asignando permisos
var IDUsuario = Parametro("IDUsuario",0)
//Usuario o grupo al que se le estan otorgando permisos
var GruID         = Parametro("Gru_ID",-1)
var UsuID         = Parametro("Usu_ID",-1)	
var sMensajegpo   = ""
var iUsuarioConGrupo = 0

var iSistemaATrabajar = ParametroDeVentana(SistemaActual, VentanaIndex, "SistemaATrabajar", SistemaActual) 

var bIQon4Web = ParametroDeVentana(SistemaActual, VentanaIndex, "Debug", 0) == 1

var bEsUsuario = ParametroDeVentana(SistemaActual, VentanaIndex, "EsUsuario", 0) 
                  // 1= usuarios 0 = grupos

//Menu principal
var iMenuID_Home = ParametroDeVentana(SistemaActual, VentanaIndex, "Home", 90)
                   //cual es la pagina principal (home)
				   
var iMnuSigt = ParametroDeVentana(SistemaActual, VentanaIndex, "Menu", 90)
                   //cual es la primera pagina del menu

// cuando es el usuario de un cliente o de un proveedor la base es Cli_ID o Prov_ID
var LlaveBase = ParametroDeVentana(SistemaActual, VentanaIndex, "Llave base", "")
if (bIQon4Web){ 
 Response.Write("16) LlaveBase " + LlaveBase + " SA " + VentanaIndex)
}

if(LlaveBase =="") {
    if (bEsUsuario==1){
        LlaveBase = "Usu_ID"
    } else {
        LlaveBase = "Gru_ID"
    }
}

var ValorLlaveBase = -1
if(LlaveBase != "" ) {
	ValorLlaveBase = Parametro(LlaveBase,-1)
}

// cuando es el usuario de un cliente o de un proveedor la base es Cli_ID o Prov_ID
// pero las llaves del grupo y usuario son Cli_Usu_ID o Cli_Gru_ID    o Prov_Usu_ID o Prov_Gru_ID
var LlaveGrupo = ParametroDeVentana(SistemaActual, VentanaIndex, "Llave del grupo", "")
var ValorLlaveGrupo = -1
if(LlaveGrupo != "" ) {
	ValorLlaveGrupo = Parametro(LlaveGrupo,-1)
}
var LlaveUsuario = ParametroDeVentana(SistemaActual, VentanaIndex, "Llave del usuario", "")
var ValorLlaveUsuario = -1
if(LlaveUsuario != "" ) {
	ValorLlaveUsuario = Parametro(LlaveUsuario,-1)
}

if (bIQon4Web){ 
	Response.Write("<br />21) parametros de entrada") 
	Response.Write("<br />Home) "+iMenuID_Home) 
	Response.Write("<br />Menu) "+iMnuSigt ) 
	Response.Write("<br />EsUsuario) "+bEsUsuario ) 
	Response.Write("<br />IDUsuario) "+IDUsuario) 
	Response.Write("<br />GruID) "+GruID) 
	Response.Write("<br />UsuID) "+UsuID + "<br />") 
}


var sCondicion = ""
if (bEsUsuario==1){
	if(LlaveBase != "" ) {
		sCondicion = " " + LlaveBase + " = " + ValorLlaveBase
	}
	if(sCondicion != "") { sCondicion += " and " }
	sCondicion += " " + LlaveUsuario + " = " + ValorLlaveUsuario
	UsuID = BuscaSoloUnDato("IDUnica","Seguridad_Indice",sCondicion,"-1",0)
} else {
	if(LlaveBase != "" ) {
		sCondicion = " " + LlaveBase + " = " + ValorLlaveBase
	}
    if(LlaveGrupo != ""){
        if(sCondicion != "") { sCondicion += " and " }
        sCondicion += " " + LlaveGrupo + " = " + ValorLlaveGrupo
    }
    if (bIQon4Web){ 
    Response.Write("53) " + sCondicion)
    }
	GruID = BuscaSoloUnDato("IDUnica","Seguridad_Indice",sCondicion,"-1",0)
}
				  
ParametroCambiaValor("Notifica",0)

if (bIQon4Web){ Response.Write("<br />71) bEsUsuario "+ bEsUsuario + "<br />") }
if(bEsUsuario==1) {
	 
	var TablaUsuario = ParametroDeVentana(SistemaActual, VentanaIndex, "Tabla Usuario", "Usuario")
	var TablaGrupo = ParametroDeVentana(SistemaActual, VentanaIndex, "Tabla Grupo", "SeguridadGrupo")
	
	//esta llave no viene como IDUnico
	var Usu_Grupo = BuscaSoloUnDato("Usu_Grupo",TablaUsuario,sCondicion,"-1",0)
	if (bIQon4Web){ Response.Write("<br />81) Usu_Grupo "+ Usu_Grupo + "<br />") }
	if (Usu_Grupo > -1){
		
		iUsuarioConGrupo = 1
		if(LlaveBase != "" ) {
			sCondicion = " " + LlaveBase + " = " + ValorLlaveBase
		}
		if(sCondicion != "") { sCondicion += " and " }
		sCondicion += " " + LlaveGrupo + " = " + Usu_Grupo
		var NombreGrupo = BuscaSoloUnDato("Gru_Nombre",TablaGrupo,sCondicion,"Sin grupo",0)
		//ParametroCambiaValor("Usu_ID",-1)
		sMensajegpo = "El usuario pertenece al grupo <strong>" + NombreGrupo + "</strong> los permisos asignados que se ven ahora son los que se configuraron en el grupo, si modifica algo se separara del grupo heredando todos sus permisos, pero, se convierte a seguridad nivel usuario y los cambios en el grupo ya no aplicaran para este usuario, ya que se salio del grupo"
		
		//buscando llave unica del grupo
	    GruID = BuscaSoloUnDato("IDUnica","Seguridad_Indice",sCondicion,"-1",0)
		//UsuID = -1
		if (bIQon4Web){ Response.Write("<br />99) IDUnico del Grupo "+ GruID + "<br />") }
	}
//} else {
//	var sCondicion = " Gru_ID = " + GruID + " AND Sys_ID = " + SistemaActual + " AND iqCli_ID = " + iqCli_ID
//	var NombreUsuario = BuscaSoloUnDato("Gru_Nombre","SeguridadGrupo",sCondicion,"",0)
//	UsuID = -1
}


var Accion = Parametro("Accion","Consulta")
var Modo = Parametro("Modo","Consulta")
var TipoRenglon = "oddRow"
var EspacioLateral = 0
var chkSeg = Parametro("chkSeg","")
var arrSeg = new Array(0)

function CargaComboSeccionesMenu(IDInicio) {

var sElemento = ""

	sElemento = "<select name='Mnu_ID' id='Mnu_ID' class='CajasTexto' onChange='javascript:CambiaCombo(this);' >" 
	var CCSQL = "Select Mnu_ID, Mnu_Titulo FROM Menu "
		CCSQL += " Where Mnu_Padre = " + IDInicio + " and Mnu_EsMenu = 1 and Sys_ID = " + iSistemaATrabajar
		CCSQL += " and Mnu_Habilitado = 1 "		
		CCSQL += " Order By Mnu_Orden "
		if (bIQon4Web){ 
		Response.Write("<br />111) combo "+CCSQL + "<br />") 
		//AgregaDebugBD("linea 109 CargaComboSeccionesMenu",CCSQL)
		}
	var rsCC = AbreTabla(CCSQL,1,2) 
	while (!rsCC.EOF){
		sElemento += "<option value='" + rsCC.Fields.Item(0).Value + "'"
		sElemento += ">" + rsCC.Fields.Item(1).Value + "</option>"
		rsCC.MoveNext()
	}
	rsCC.Close()
	sElemento += "</select>"

	return sElemento

}


%>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<% if (sMensajegpo != ""){  %>
		<tr><td height="25" colspan="3">
		<div class="ui-widget" id="dvAviso">
		<div class="ui-state-highlight ui-corner-all" style="margin-top: 20px; padding: 0 .7em;"> 
		<p><span class="ui-icon ui-icon-info" style="float: left; margin-right: .3em;"></span>
		<strong>Aviso</strong><br /><%=sMensajegpo%>
		</p></div></div>
		</td></tr>	
      <tr class="GridSubTitulos">
        <td>&nbsp;
        </td>
        <td>&nbsp;</td>
        <td colspan="2" align="right">&nbsp;</td>
      </tr>        	
<%	}%>
  <tr class="GridSubTitulos">
    <td colspan="2">Secci&oacute;n&nbsp;<% Response.Write(CargaComboSeccionesMenu(iMenuID_Home)) %></td>
    <td colspan="2" align="right"><label for="chTodos">Seleccionar todos </label>
      <input type="checkbox" name="chTodos" id="chTodos" />
   </td>
  </tr>
  <tr>
    <td>    <input type="hidden" name="sUsu_ID" id="sUsu_ID" value="<%=UsuID%>" />
            <input type="hidden" name="sGru_ID" id="sGru_ID" value="<%=GruID%>" />
            <input type="hidden" name="SistemaATrabajar" id="SistemaATrabajar" value="<%=iSistemaATrabajar%>" />
            <input type="hidden" name="sUsuConGpo" id="sUsuConGpo" value="<%=iUsuarioConGrupo%>" /></td>
    <td>&nbsp;</td>
    <td colspan="2">&nbsp;</td>
  </tr>
  <tr class="GridSubTitulos">
    <td colspan="4"><div id="MatrizSeguridad"></div></td>
  </tr>
  <tr>
    <td></td>
    <td>&nbsp;</td>
    <td colspan="2">&nbsp;</td>
  </tr>
</table>
<div id="dvError"></div>
<style type="text/css">
.IconoEspera {
	text-align:center;
	position:fixed;
	top:50%;
	left:30%;
}
</style>

<script language="JavaScript">
<!--

function CambiaCombo(e) {
	LlenaConPermisos(e.value)
}

function ValidaChecks() {
	var itotalDeChecks = 0;
	var iChecksChecados = 0;
	$('.chSeg').each(function(){
		itotalDeChecks++;
		if ($(this).is(':checked')) {
			iChecksChecados++;	
		}
	});
	$("#chTodos").attr('checked',(itotalDeChecks == iChecksChecados));
}

function LlenaConPermisos(IDMenu) {

	$("#MatrizSeguridad").empty();
	$("#MatrizSeguridad").html('<img src="/images/ajax-engranes.gif" width="106" height="98" border="0" class="IconoEspera"/>')
	
	var sMensaje = "Cargando información."
	var sTitulo = "Aviso"	
	 
	Avisa("info",sTitulo,sMensaje)
		
	$.post("/Plugins/Permisos/Permisos_Ajax.asp"
	       , { Tarea:1,Gru_ID:$("#sGru_ID").val(),Usu_ID:$("#sUsu_ID").val()
				,SistemaATrabajar:$("#SistemaATrabajar").val()
				,iqCli_ID:$("#iqCli_ID").val()
				,SistemaActual:$("#SistemaActual").val()
			    ,MnuID:$("#VentanaIndex").val()
				,Mnu_ID:IDMenu,UsuConGpo:$("#sUsuConGpo").val()}
			,function(data) {											
				if (String(data) != "") {
					//alert(String(data));
					$("#MatrizSeguridad").html(String(data));
					//comprobando si todos estan habilitados
					ValidaChecks();
				} else {
					var sMensaje = "Error al cargar los permisos del grupo, avise al administrador."
					var sTitulo = "ERROR"	
					Avisa("error",sTitulo,sMensaje)
				}
			});
}

var IDSEG = -1;
var Valor = "";
var iEsFn = 0;

 $(document).ready(function(){
	
	$("#chTodos").click(function(){
			$('.chSeg').each(function(){
			   var checkbox = $(this);
				//if (!checkbox.is(':checked')) {
					IDSEG = checkbox.attr('data-IDSEG');
					iEsFn = checkbox.attr('data-EsFn');
					Valor = checkbox.val();
					 var Checado = $("#chTodos").is(':checked');
					 checkbox.attr('checked',Checado);
					 GuardaValores(IDSEG,iEsFn,Valor,Checado,0, $("#sUsuConGpo").val()); 
					 if ($("#sUsuConGpo").val() == 1) {
						$("#sUsuConGpo").val(0);
					 }

				//}
			  // log('El checkbox ' + checkbox.attr('name') + ' está checkeado? ' + checkbox.is(':checked')  ); 
			});
			if($("#chTodos").is(':checked')) {
				sMensaje= "Todos los permisos de esta sección fueron habilitados"
			} else {
				sMensaje= "Todos los permisos de esta sección fueron revocados"
			}
			Avisa("info","Aviso",sMensaje)
	
	});
	 
 });
 
 
LlenaConPermisos( $("#Mnu_ID").val() );

-->
</script>
