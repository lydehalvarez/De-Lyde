<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../Includes/iqon.asp" -->
<%
//el parametro  son recogidos de la tabla menu_widget del campo MW_Param
//Menu principal
var iMenuID_Home = ParametroDeVentana(SistemaActual, VentanaIndex, "Home", 90)
                   //cual es la pagina principal (home)
				   
var iMnuSigt = ParametroDeVentana(SistemaActual, VentanaIndex, "Menu", 90)
                   //cual es la primera pagina del menu

var bEsUsuario = ParametroDeVentana(SistemaActual, VentanaIndex, "EsUsuario", 0)
                  // 1= usuarios 0 = grupos
				  
var iSistemaATrabajar = ParametroDeVentana(SistemaActual, VentanaIndex, "SistemaATrabajar", SistemaActual) 
var bIQon4Web = ParametroDeVentana(SistemaActual, VentanaIndex, "Debug", 0) == 1

var sMensajegpo = ""
var iUsuarioConGrupo = 0

//var arrMenuID_Home = "0,0,0,0"


//var sSQL = "select top 1 MW_Param from Menu_Widget "
//	sSQL += " where sys_id = " + SistemaActual
//	sSQL += " and Mnu_ID = " + VentanaIndex
//	sSQL += " and Wgt_ID = 13 "
//    sSQL += " ORDER By Mnu_ID "
	
	//if (bIQon4Web){ Response.Write("<br />21)&nbsp;"+sSQL + "<br />") }
	//
	//var rsParam = AbreTabla(sSQL,1,2)
	//if(!rsParam.EOF){ 
	//	arrMenuID_Home = "" + rsParam.Fields.Item("MW_Param").Value
	//} 
	//if (bIQon4Web){ Response.Write("<br />27)&nbsp;parametros "+arrMenuID_Home + "<br />") }	
	//rsParam.Close()
	//if (arrMenuID_Home == "") {
	//	arrMenuID_Home = "'','','',''" 	
	//}
	
	//var arrDatos = ['','','']
	//arrDatos = arrMenuID_Home.split(",");
	//if (!EsVacio(arrDatos[0])) {iMenuID_Home = arrDatos[0] }           //cual es la pagina principal (home)
	
	//if (!EsVacio(arrDatos[1])) {bEsUsuario = arrDatos[1]}          // 1= usuarios 0 = grupos
		
	//if (!EsVacio(arrDatos[2])) {iSistemaATrabajar = arrDatos[2]}
	
	
//obtengo el encabezado para ponerlo junto con todo su ramal
//var sSQL = "select top 1 Mnu_ID from Menu "
//	sSQL += " where Sys_ID = " + iSistemaATrabajar
//	sSQL += " and Mnu_Padre = " + iMenuID_Home
//	sSQL += " and Mnu_Habilitado = 1 and Mnu_EsMenu = 1 "
//    sSQL += " ORDER By Mnu_Orden "
//	
//	if (bIQon4Web){ Response.Write("<br />46)&nbsp;"+sSQL + "<br />") }
//	
//	var rsParam = AbreTabla(sSQL,1,2)
//	if(!rsParam.EOF){ 
//		iMnuSigt = "" + rsParam.Fields.Item("Mnu_ID").Value
//	} 
//	rsParam.Close() 

ParametroCambiaValor("Notifica",0)
//var SistemaActual = Parametro("SistemaActual",0)
//var VentanaIndex  = Parametro("VentanaIndex",0)
var IDUsuario     = Parametro("IDUsuario",0)
var GruID         = Parametro("Gru_ID",-1)
var UsuID         = Parametro("Usu_ID",-1)

if(bEsUsuario==1) {
	var sCondicion = " Usu_ID = " + UsuID 
	var GruID = BuscaSoloUnDato("Usu_Grupo","Usuario",sCondicion,"-1",0)
	if (GruID>-1){
		UsuID = -1
		iUsuarioConGrupo = 1
		sCondicion = " Gru_ID = " + GruID 
		var NombreGrupo = BuscaSoloUnDato("Gru_Nombre","SeguridadGrupo",sCondicion,"-1",0)
		ParametroCambiaValor("Usu_ID",-1)
		sMensajegpo = "El usuario pertenece al grupo <strong>" + NombreGrupo + "</strong> los permisos asignados que se ven ahora son los que se configuraron en el grupo, si modifica algo se separara del grupo heredandolo pero se convierte a seguridad nivel usuario y los cambios en el grupo ya no le van a afectar"
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
		CCSQL += " Order By Mnu_Orden "
		if (bIQon4Web){ Response.Write("<br />95) combo "+CCSQL + "<br />") }
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
	//alert(IDMenu);
	//alert("sGru_ID" + $("#sGru_ID").val() + " sUsu_ID" + $("#sUsu_ID").val() + " SistemaATrabajar " + $("#SistemaATrabajar").val() + " Mnu_ID " + IDMenu + " sUsuConGpo " + $("#sUsuConGpo").val());
	$("#MatrizSeguridad").empty();
	$("#MatrizSeguridad").html('<img src="/images/ajax-engranes.gif" width="106" height="98" border="0" class="IconoEspera"/>')
	sMensaje = "Cargando información";
		//$.jGrowl(sMensaje, { header: 'Aviso', sticky: false, life: 2500, glue:'before'});
		//$.jGrowl(sMensaje, { header: 'Aviso', sticky: false, life: 2500, glue:'before' });
		$.gritter.add({
				class_name: '', //'gritter-light', // for light notifications (can be added directly to $.gritter.add too)
				position: 'top-right', // possibilities: bottom-left, bottom-right, top-left, top-right
				//fade_in_speed: 100, // how fast notifications fade in (string or int)
				//fade_out_speed: 100, // how fast the notices fade out
				//time: 3000 // hang on the screen for...
                // (string | mandatory) the heading of the notification
                title: 'Aviso',
                // (string | mandatory) the text inside the notification
                text: sMensaje,
                // (string | optional) the image to display on the left
                image: '',
                // (bool | optional) if you want it to fade out on its own or just sit there
                //sticky: false,
                // (int | optional) the time you want it to be alive for before fading out
                time: 1500
         });
		 
		
	$.post("/Plugins/Permisos/Permisos_v1_Ajax.asp"
	       , { Tarea:1,Gru_ID:$("#sGru_ID").val(),Usu_ID:$("#sUsu_ID").val()
				,SistemaATrabajar:$("#SistemaATrabajar").val()
				,iqCli_ID:$("#iqCli_ID").val()
				,SistemaActual:$("#SistemaActual").val()
				,Mnu_ID:IDMenu,sUsuConGpo:$("#sUsuConGpo").val()}
		  , function(data) {											
			if (String(data) != "") {
				$("#MatrizSeguridad").html(String(data));
				ValidaChecks();
			} else {
				sMensaje = "Error al cargar los permisos del grupo, avise al administrador";
				//$.jGrowl(sMensaje, { header: 'Aviso', sticky: true, life: 2500, glue:'before'});
				$.gritter.add({position: 'top-right',title: 'Aviso',text: sMensaje,time: 2500});
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
							$("#sGru_ID").val(-1);
							$("#sUsu_ID").val($("#Usu_ID").val());
						 }
						 
					//}
				  // log('El checkbox ' + checkbox.attr('name') + ' está checkeado? ' + checkbox.is(':checked')  );
				});
				if($("#chTodos").is(':checked')) {
					sMensaje= "Todos los permisos de esta sección fueron habilitados"
				} else {
					sMensaje= "Todos los permisos de esta sección fueron revocados"
				}
				//$.jGrowl(sMensaje, { header: 'Aviso', sticky: false, life: 5500, glue:'before'});
				$.gritter.add({position: 'top-right',title: 'Aviso',text: sMensaje,time: 5500});
	});

	 
 });
 
 
LlenaConPermisos( $("#Mnu_ID").val() );

-->
</script>