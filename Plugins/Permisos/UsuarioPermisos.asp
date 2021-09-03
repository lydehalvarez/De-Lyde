<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../Includes/iqon.asp" -->
<%
//el parametro  son recogidos de la tabla menu_widget del campo MW_Param
//Menu principal
var iMnuPPal = "90,0,2000"   //cual es la pagina principal (home)
var iMnuSigt = 40   //cual es la primera pagina del menu
var bEsUsuario = 0	// 1= usuarios 0 = grupos

var sSQL = "select top 1 MW_Param from Menu_Widget "
	sSQL += " where sys_id = " + SistemaActual
	sSQL += " and Mnu_ID = " + VentanaIndex
	sSQL += " and Wgt_ID = 13 "
    sSQL += " ORDER By Mnu_ID "
    
	var rsParam = AbreTabla(sSQL,1,2)
	if(!rsParam.EOF){ 
		iMnuPPal = "" + rsParam.Fields.Item("MW_Param").Value
	} 
	rsParam.Close()

	var arrDatos = [0,0,0]
	arrDatos = iMnuPPal.split(",");
	iMnuPPal = arrDatos[0]            //cual es la pagina principal (home)
	iMnuSigt = arrDatos[1]            //cual es la primera pagina del menu
	bEsUsuario = arrDatos[2]          // 1= usuarios 0 = grupos
	
//obtengo el encabezado para ponerlo junto con todo su ramal
var sSQL = "select top 1 Mnu_ID from Menu "
	sSQL += " where sys_id = " + SistemaActual
	sSQL += " and Mnu_Padre = " + iMnuPPal
    sSQL += " ORDER By Mnu_Orden "
  
	var rsParam = AbreTabla(sSQL,1,2)
	if(!rsParam.EOF){ 
		iMnuSigt = "" + rsParam.Fields.Item("Mnu_ID").Value
	} 
	rsParam.Close() 


ParametroCambiaValor("Notifica",0)
//var SistemaActual = Parametro("SistemaActual",0)
//var VentanaIndex  = Parametro("VentanaIndex",0)
var IDUsuario     = Parametro("IDUsuario",0)
var GruID         = Parametro("Gru_ID",-1)
var UsuID         = Parametro("Usu_ID",1)

if(bEsUsuario==1) {
	var sCondicion = " Usu_ID = " + UsuID 
	var GruID = BuscaSoloUnDato("Usu_Grupo","Usuario",sCondicion,"-1",0)
	if (GruID>-1){
		UsuID = -1
		ParametroCambiaValor("Usu_ID",-1)
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
		CCSQL += " Where Mnu_Padre = " + IDInicio + " and Mnu_EsMenu = 1 and Sys_ID = " + SistemaActual
		CCSQL += " Order By Mnu_Orden "
	
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

//Debug_ImprimeParametros("Inicio seguridad grupo")
%>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr class="GridSubTitulos">
    <td>Secci&oacute;n</td>
    <td>&nbsp;<% Response.Write(CargaComboSeccionesMenu(iMnuPPal)) %> </td>
    <td colspan="2" align="right"><label for="chTodos">Seleccionar todos </label>
      <input type="checkbox" name="chTodos" id="chTodos" />
   </td>
  </tr>
  <tr>
    <td>&nbsp;</td>
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
	$("#MatrizSeguridad").html('<img src="/images/Ajax_CirculoVerde.gif" width="106" height="98" border="0" class="IconoEspera"/>')
	sMensaje = "Cargando informaci�n";
		$.jGrowl(sMensaje, { header: 'Aviso', sticky: false, life: 2500, glue:'before'});
	 
	$.post("/Plugins/Permisos/GrupoAjax.asp", { Tarea:1, Gru_ID:$("#Gru_ID").val(), Usu_ID:$("#Usu_ID").val(), Mnu_ID:IDMenu},function(data) {
	if (data != "") {
//		var sTmp = String(data);
//		arrDatos = sTmp.split("|");
//		$("#Cue_Nombre").val(arrDatos[0]);
//		if (arrDatos[1] == 1) {
//			$('input[name=Cue_Habilitado]').attr('checked', true);
//		} else {
//			$('input[name=Cue_Habilitado]').attr('checked', false);	
//		}
//		$("#Cue_DescripcionCorta").val(arrDatos[2]);
//		$("#Cue_Descripcion").val(arrDatos[3]);
		$("#MatrizSeguridad").html(data);
		//comprobando si todos estan habilitados
		ValidaChecks();
	} else {
		sMensaje = "Error al cargar los permisos del grupo, avise al administrador";
		$.jGrowl(sMensaje, { header: 'Aviso', sticky: true, life: 2500, glue:'before'});
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
						 GuardaValores(IDSEG,iEsFn,Valor,Checado,0);
					//}
				  // log('El checkbox ' + checkbox.attr('name') + ' est� checkeado? ' + checkbox.is(':checked')  );
				});
				if($("#chTodos").is(':checked')) {
					sMensaje= "Todos los permisos de esta secci�n fueron habilitados"
				} else {
					sMensaje= "Todos los permisos de esta secci�n fueron revocados"
				}
				$.jGrowl(sMensaje, { header: 'Aviso', sticky: false, life: 5500, glue:'before'});
	});
	 
 });
 
 
LlenaConPermisos( <%=iMnuSigt%> )

-->
</script>