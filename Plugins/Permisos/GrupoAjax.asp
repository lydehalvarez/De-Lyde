<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../Includes/iqon.asp" -->
<%  
var Tarea  = Parametro("Tarea",0)
var Gru_ID  = Parametro("Gru_ID",-1)
var Usu_ID  = Parametro("Usu_ID",-1)
var Mnu_ID  = Parametro("Mnu_ID",-1)
var Seg_ID  = Parametro("Seg_ID",-1)
var TipoPermiso  = Parametro("TipoPermiso",-1)
var Quitar  = Parametro("Quitar",-1)

var sSQL = ""
var TipoRenglon = "oddRow"
var EspacioLateral = 0
var sResultado = ""
var prAgregar = ""
var prBorrar = ""
var prEditar = ""
var prConsulta = ""
 
function ArbolDePermisosDeFunciones(idBase, tipo) {

	var sSQL  = "select MW_NombreFuncion, WgCfg_ID, MW_Descripcion, MW_PuedeAgregar, MW_PuedeBorrar, MW_PuedeEditar, Consulta, Agregar, Borrar, Editar "
		sSQL += " from dbo.ufn_Permisos_DameArbolFunciones(-1," + idBase + ", " + SistemaActual + ", " + Gru_ID + ", " + iqCli_ID + ") "
	
	var rsPermisos = AbreTabla(sSQL,1,2)	
	EspacioLateral += 25
	while (!rsPermisos.EOF) {
		var iIDSeg = rsPermisos.Fields.Item("WgCfg_ID").Value
		prAgregar = ""
		prBorrar = ""
		prEditar = "" 
		prConsulta = ""
		if (rsPermisos.Fields.Item("Consulta").Value == 1) { prConsulta = " checked " }
		if (rsPermisos.Fields.Item("Agregar").Value == 1) { prAgregar = " checked " }
		if (rsPermisos.Fields.Item("Borrar").Value == 1) { prBorrar = " checked " }
		if (rsPermisos.Fields.Item("Editar").Value == 1) { prEditar = " checked " }
			if (TipoRenglon == "evenRow") {
				TipoRenglon = "oddRow"
			} else {
				TipoRenglon = "evenRow"
			}
%>
  <tr class="fontBlack <%=TipoRenglon%>" >
    <td align="center"><input class="chSeg" name="Seg" id="Seg" data-IDSEG="<%=iIDSeg%>" data-EsFn="1" type="checkbox" <%=prConsulta%> value="1"></td>
    <td align="center">
    <% if ( rsPermisos.Fields.Item("MW_PuedeAgregar").Value > 0 ) { %>
   		 <input class="chSeg" name="Seg" id="Seg" data-IDSEG="<%=iIDSeg%>" data-EsFn="1"  type="checkbox" <%=prAgregar%> value="2">
    <% } else { Response.Write("&nbsp;") } %>
    </td>
    <td align="center">
    <% if ( rsPermisos.Fields.Item("MW_PuedeBorrar").Value > 0 ) { %>
    		<input class="chSeg" name="Seg" id="Seg" data-IDSEG="<%=iIDSeg%>" data-EsFn="1"  type="checkbox" <%=prBorrar%> value="4">
    <% } else { Response.Write("&nbsp;") } %>
    </td>
    <td align="center">
    <% if ( rsPermisos.Fields.Item("MW_PuedeEditar").Value > 0 ) { %>
    		<input class="chSeg" name="Seg" id="Seg" data-IDSEG="<%=iIDSeg%>" data-EsFn="1"  type="checkbox" <%=prEditar%> value="8">
    <% } else { Response.Write("&nbsp;") } %>
    </td>
    <td style="padding-left:<%=EspacioLateral%>px">&nbsp;<strong><% Response.Write(rsPermisos.Fields.Item("MW_NombreFuncion").Value) %></strong></td>
    <td>&nbsp;<%=tipo%></td>
  </tr>
 <%
		rsPermisos.MoveNext()
	}
	rsPermisos.Close()  
	EspacioLateral -= 25   
} 
 
 
 
 
function ArbolDePermisos(idBase, tipo) {

	var sSQL  = "select Mnu_Titulo, Mnu_ID, Mnu_Padre, Mnu_Descripcion, Mnu_SiguienteVentana , Mnu_IDSeguridad, Consulta, Editar, Borrar, Agregar"
		sSQL += " from dbo.ufn_Permisos_DameRama (" + Usu_ID + ", " + idBase + ", " + SistemaActual + ", " + Gru_ID + ", " + iqCli_ID + ") "
		
	var rsPermisos = AbreTabla(sSQL,1,2)	
	EspacioLateral += 25
	while (!rsPermisos.EOF) {
		var iMnu = rsPermisos.Fields.Item("Mnu_ID").Value
		//var iMnuP = iMnu * -1
		var iSig = rsPermisos.Fields.Item("Mnu_SiguienteVentana").Value
		var iIDSeg = rsPermisos.Fields.Item("Mnu_IDSeguridad").Value
		prAgregar = ""
		prBorrar = ""
		prEditar = "" 
		prConsulta = ""
		if (rsPermisos.Fields.Item("Consulta").Value == 1) { prConsulta = " checked " }
		if (rsPermisos.Fields.Item("Agregar").Value == 1) { prAgregar = " checked " }
		if (rsPermisos.Fields.Item("Borrar").Value == 1) { prBorrar = " checked " }
		if (rsPermisos.Fields.Item("Editar").Value == 1) { prEditar = " checked " }
		//if ( iMnuP != rsPermisos.Fields.Item("Mnu_Padre").Value) {
			if (TipoRenglon == "evenRow") {
				TipoRenglon = "oddRow"
			} else {  
				TipoRenglon = "evenRow"
			}
%>
  <tr class="fontBlack <%=TipoRenglon%>" >
    <td align="center"><input class="chSeg" name="Seg" id="Seg" data-IDSEG="<%=iIDSeg%>" data-EsFn="0"  type="checkbox" <%=prConsulta%> value="1"></td>
    <td align="center"><input class="chSeg" name="Seg" id="Seg" data-IDSEG="<%=iIDSeg%>" data-EsFn="0"  type="checkbox" <%=prAgregar%> value="2"></td>
    <td align="center"><input class="chSeg" name="Seg" id="Seg" data-IDSEG="<%=iIDSeg%>" data-EsFn="0"  type="checkbox" <%=prBorrar%>  value="4"></td>
    <td align="center"><input class="chSeg" name="Seg" id="Seg" data-IDSEG="<%=iIDSeg%>" data-EsFn="0"  type="checkbox" <%=prEditar%>  value="8"  ></td>
    <td style="padding-left:<%=EspacioLateral%>px">&nbsp;<% Response.Write(rsPermisos.Fields.Item("Mnu_Titulo").Value) %></td>
    <td>&nbsp;<%=tipo%></td>
  </tr>
 <%
		//} 
 		ArbolDePermisos(iMnu,"Mnu")
		ArbolDePermisosDeFunciones(iMnu,"Fn")
		if (iSig > 0) {
			ArbolDePermisos(iSig,"Mnu")
		}
		rsPermisos.MoveNext()
	}
	rsPermisos.Close()  
	EspacioLateral -= 25   
}
 
 
	switch (parseInt(Tarea)) {
		case 0:
			Response.Write("<br>" + Request.ServerVariables("PATH_INFO") + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[OK]")
			bPuedeVerDebug = true
		    bDebug = true
			bOcurrioError = true
			DespliegaAlPie()
		break; 
		case 1:   

%>		
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="8%" align="center" valign="middle">Consultar</td>
    <td width="8%" align="center" valign="middle">Agregar</td>
    <td width="8%" align="center" valign="middle">Borrar</td>
    <td width="8%" align="center" valign="middle">Editar</td>
    <td width="64%" align="left" valign="middle">Descripci&oacute;n</td>
    <td width="4%" align="center" valign="middle">Tipo</td>
  </tr>
<%		

	var sSQL  = "select Mnu_Titulo, Mnu_ID, Mnu_Padre, Mnu_Descripcion, Mnu_SiguienteVentana , Mnu_IDSeguridad, Consulta, Editar, Borrar, Agregar"
		sSQL += " from dbo.ufn_Permisos_DameBase (" + Usu_ID + ", " + Mnu_ID + ", " + SistemaActual + ", " + Gru_ID + ", " + iqCli_ID + ") "

	var rsPermisos = AbreTabla(sSQL,1,2)	
			
	if (!rsPermisos.EOF) {
		prAgregar = ""
		prBorrar = ""
		prEditar = "" 
		prConsulta = ""
		if (rsPermisos.Fields.Item("Consulta").Value == 1) { prConsulta = " checked " }
		if (rsPermisos.Fields.Item("Agregar").Value == 1) { prAgregar = " checked " }
		if (rsPermisos.Fields.Item("Borrar").Value == 1) { prBorrar = " checked " }
		if (rsPermisos.Fields.Item("Editar").Value == 1) { prEditar = " checked " }
		var iSig = rsPermisos.Fields.Item("Mnu_SiguienteVentana").Value
		var iIDSeg = rsPermisos.Fields.Item("Mnu_IDSeguridad").Value
%>
  <tr class="fontBlack <%=TipoRenglon%>" >
    <td align="center"><input class="chSeg" name="Seg" id="Seg" data-IDSEG="<%=iIDSeg%>"  data-EsFn="0" type="checkbox" <%=prConsulta%> value="1"></td>
    <td align="center">&nbsp;</td>
    <td align="center">&nbsp;</td>
    <td align="center">&nbsp;</td>
    <td >&nbsp;<% Response.Write(rsPermisos.Fields.Item("Mnu_Titulo").Value) %></td>
    <td>&nbsp;Mnu</td>
  </tr>
 <%
	}
	rsPermisos.Close()
	ArbolDePermisos(Mnu_ID,"Mnu")
	ArbolDePermisosDeFunciones(Mnu_ID,"Fn")
	if (iSig > 0) {
		ArbolDePermisos(iSig,"Mnu")
	}
%>
</table>
<script language="JavaScript">
<!--
var Indice = -1;

 $(document).ready(function(){
	
	$(".chSeg").click(function(){ 
		  //alert("hiciste click " + $(".dvEditable").attr("BDID"));
//		  Indice = $(".chSeg").index(this); 
//		  IDSEG = $(".chSeg:eq("+Indice+")").attr('data-IDSEG');
//		  iEsFn = $(".chSeg:eq("+Indice+")").attr('data-EsFn');
//		  Valor = $(".chSeg:eq("+Indice+")").val();
//		  var Checado = $(".chSeg:eq("+Indice+")").is(':checked');
		  var checkbox = $(this);
		  IDSEG = checkbox.attr('data-IDSEG');
		  iEsFn = checkbox.attr('data-EsFn');
		  Valor = checkbox.val();
		  var Checado = checkbox.is(':checked');
		  //alert(" indice = " + Indice + " id seg = " + IDSEG + " valor = " + Valor + " esta checado = " + Checado );
		  GuardaValores(IDSEG,iEsFn,Valor,Checado,1);
	});
	 
 });

function GuardaValores(iIDSeguridad ,iEsFuncion ,iValorPermiso ,bChecado ,iAvisa) {
	
	var Quitar = 0
	if (bChecado) { Quitar = 1 }
	
	var iTarea = 2;
	if (parseInt(iEsFuncion) == 1) { iTarea = 3 }
	
	$.post("/Plugins/Permisos/GrupoAjax.asp", 
			{ Tarea:iTarea
			 ,Seg_ID:iIDSeguridad
			 ,TipoPermiso:iValorPermiso
			 ,Quitar:Quitar 
			 ,Gru_ID:$("#Gru_ID").val()
			 ,Mnu_ID:$("#Mnu_ID").val()
			 ,Usu_ID:$("#Usu_ID").val()
			},function(data) {
				if(iAvisa==1) {
					var iresul = parseInt(data)
					if (iresul==0) {
						sMensaje= "Ocurrio un error desconocido al guardar el permiso, notifique al administrador"
						$.jGrowl(sMensaje, { header: 'Error', sticky: true, life: 2500, glue:'before'});
					}
					if (iresul==1) {
						$.jGrowl("El permiso fue revocado correctamente", { header: 'Permiso revocado', sticky: false, life: 2500, glue:'before'});	
					}
					if (iresul==2) {
						$.jGrowl("El permiso fue otorgado correctamente", { header: 'Permiso otorgado', sticky: false, life: 2500, glue:'before'});	
					}	
				}
				ValidaChecks();
	}); 
}


-->
</script>
<%
			break;
		case 2:	
			var iResultado = 0
			try {
				
			var sSQL = " Delete From systobjects "
				sSQL  += " WHERE sys1 = " + TipoPermiso
				sSQL  += " AND sys2 = " + Usu_ID
				sSQL  += " AND sys3 = " + Seg_ID
				sSQL  += " AND sys4 = " + Mnu_ID
				sSQL  += " AND sys5 = -1 "
				sSQL  += " AND sys6 = " + SistemaActual
				sSQL  += " AND sys7 = " + Gru_ID
				sSQL  += " AND sys8 = " + iqCli_ID
				
				Ejecuta(sSQL ,2)
				iResultado = 1
				
				if (Quitar == 1 ) {
					var sSQL = " Insert Into systobjects (sys1, sys2, sys3, sys4, sys5, sys6, sys7, sys8 ) "
						sSQL  += " Values ( " + TipoPermiso
						sSQL  += ", " + Usu_ID
						sSQL  += ", " + Seg_ID 
						sSQL  += ", " + Mnu_ID
						sSQL  += ", -1 "  //id de widgetcfg para seguridad de funciones
						sSQL  += ", " + SistemaActual 
						sSQL  += ", " + Gru_ID 
						sSQL  += ", " + iqCli_ID 
						sSQL  += " ) "
						
						Ejecuta(sSQL ,2)
						iResultado = 2
				}
			} 
			catch(err) {
				iResultado = 0
			}
			Response.Write(iResultado)
			break;  
		case 3:	
			var iResultado = 0
			try {
				
			var sSQL = " Delete From systobjects "
				sSQL  += " WHERE sys1 = " + TipoPermiso
				sSQL  += " AND sys2 = " + Usu_ID
				sSQL  += " AND sys3 = " + Seg_ID
				sSQL  += " AND sys4 = " + Mnu_ID 
				sSQL  += " AND sys5 = -1 "  //WgCfg_ID
				sSQL  += " AND sys6 = " + SistemaActual
				sSQL  += " AND sys7 = " + Gru_ID
				sSQL  += " AND sys8 = " + iqCli_ID
				
				Ejecuta(sSQL ,2)
				iResultado = 1
				
				if (Quitar == 1 ) {
					var sSQL = " Insert Into systobjects (sys1, sys2, sys3, sys4, sys5, sys6, sys7, sys8 ) "
						sSQL  += " Values (" + TipoPermiso
						sSQL  += ", " + Usu_ID
						sSQL  += ", " + Seg_ID 
						sSQL  += ", " + Mnu_ID  //4
						sSQL  += ", -1 " 
						sSQL  += ", " + SistemaActual  //6 
						sSQL  += ", " + Gru_ID 
						sSQL  += ", " + iqCli_ID 
						sSQL  += " ) "
						
						Ejecuta(sSQL ,2)
						iResultado = 2
				}
			} 
			catch(err) {
				iResultado = 0
			}
			Response.Write(iResultado)
			break;
	}
	
	
	

%>