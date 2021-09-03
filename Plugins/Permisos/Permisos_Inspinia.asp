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
   
ParametroCambiaValor("Notifica",0)
   
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
	
}

var Accion = Parametro("Accion","Consulta")
var Modo = Parametro("Modo","Consulta")
var TipoRenglon = "oddRow"
var EspacioLateral = 0
var chkSeg = Parametro("chkSeg","")
var arrSeg = new Array(0)

function CargaComboSeccionesMenu(IDInicio) {

var sElemento = ""

	sElemento = "<select name='Mnu_ID' id='Mnu_ID' class='form-control cboIDMenu' onChange='javascript:CambiaCombo(this);' >" 
	var CCSQL = "SELECT Mnu_ID, Mnu_Titulo FROM Menu "
		CCSQL += " WHERE Mnu_Padre = " + IDInicio + " AND Mnu_EsMenu = 1 AND Sys_ID = " + iSistemaATrabajar
		CCSQL += " AND Mnu_Habilitado = 1 "		
		CCSQL += " ORDER BY Mnu_Orden "
		if (bIQon4Web){ 
			Response.Write("<br />106) combo "+CCSQL + "<br />") 
			AgregaDebugBD("linea 109 CargaComboSeccionesMenu",CCSQL)
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
<div class="ibox">
	<div class="ibox-content">
		<div class="form-horizontal" id="form">
			<% if (sMensajegpo != ""){  %>
			<div class="form-group">
				<label class="col-sm-1 control-label">&nbsp;</label>
				<div class="col-sm-12">
					<!-- Alertas {start} <button class="close" data-dismiss="alert">×</button>-->
					<div class="alert alert-info" id="dvAviso">
						<h2><i class="fa fa-info-circle"></i><strong> Aviso! </strong>&nbsp;<small><%=sMensajegpo%></small>.</h2>
					</div>
					<!-- Alertas {end} -->
				</div>
			</div>
			<% } %>
			<div class="form-group">
				<label class="col-sm-1 control-label"><h4>Secci&oacute;n</h4></label>
				<div class="col-sm-2">
					<%Response.Write(CargaComboSeccionesMenu(iMenuID_Home)) %>
				</div>
				<label class="col-sm-offset-4 col-sm-2 control-label"><h4>Seleccionar todos</h4></label>
				<div class="col-sm-1">
					<label class="checkbox-inline i-checks"> <input type="checkbox" name="chTodos" id="chTodos" class="chTodos">&nbsp;</label>
					<input type="hidden" name="sUsu_ID" id="sUsu_ID" value="<%=UsuID%>" />
					<input type="hidden" name="sGru_ID" id="sGru_ID" value="<%=GruID%>" />
					<input type="hidden" name="SistemaATrabajar" id="SistemaATrabajar" value="<%=iSistemaATrabajar%>" />
					<input type="hidden" name="sUsuConGpo" id="sUsuConGpo" value="<%=iUsuarioConGrupo%>" />     
				</div>
			</div>
		</div>
		<br>
		<div id="MatrizSeguridad"></div>
		<div id="dvError"></div>				
	</div>	
</div>
<style type="text/css">
.IconoEspera {
	text-align:center;
	position:fixed;
	top:50%;
	left:30%;
}
</style>

<script language="javascript" type="text/javascript"> 
				
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

		var sMensaje = "Cargando informaci&oacute;n."
		var sTitulo = "Aviso"	
		toastr.info(sMensaje, sTitulo)	 

		$.post("/Plugins/Permisos/Permisos_InspiniaAjax.asp"
			   , { Tarea:1,Gru_ID:$("#sGru_ID").val(),Usu_ID:$("#sUsu_ID").val()
					,SistemaATrabajar:$("#SistemaATrabajar").val()
					,iqCli_ID:$("#iqCli_ID").val()
					,SistemaActual:$("#SistemaActual").val()
					,Mnu_ID:IDMenu,sUsuConGpo:$("#sUsuConGpo").val()}
				,function(data) {											
					if (String(data) != "") {
						//alert(String(data));
						$("#MatrizSeguridad").html(String(data));
						//comprobando si todos estan habilitados
						ValidaChecks();
					} else {
							var sMensaje = "Error al cargar los permisos del grupo, avise al administrador."
							var sTitulo = "ERROR"	
							toastr.error(sMensaje, sTitulo)	 
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
					toastr.info(sMensaje, "Aviso")	

		});

	});
 
	$('.i-checks').iCheck({
		checkboxClass: 'icheckbox_square-green',
		//radioClass: 'iradio_square-green',
	});

	LlenaConPermisos( $("#Mnu_ID").val() );


	$(".cboIDMenu").select2();				

				
</script>				
<%
bPuedeVerDebug = bIQon4Web
DespliegaAlPie() 
%>				
				
				
				
				
				
				
				
				
				
				
				
				
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	