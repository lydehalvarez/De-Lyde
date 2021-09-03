<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../Includes/iqon.asp" -->
<%  
var Tarea  = Parametro("Tarea",0)
var Gru_ID  = Parametro("Gru_ID",-1)
var Usu_ID  = Parametro("Usu_ID",-1)
var Mnu_ID  = Parametro("Mnu_ID",-1)
var Seg_ID  = Parametro("Seg_ID",-1)
var iqCli_ID = Parametro("iqCli_ID",19)
var TipoPermiso = Parametro("TipoPermiso",-1)
var SistemaATrabajar = Parametro("SistemaATrabajar",50)
var Quitar = Parametro("Quitar",-1)
var sUsuConGpo = Parametro("sUsuConGpo",0)

var sSQL = ""
//var TipoRenglon = "oddRow"
var EspacioLateral = 0
var sResultado = ""
var prAgregar = ""
var prBorrar = ""
var prEditar = ""
var prConsulta = ""
   
var bIQon4Web = false   
 
function ArbolDePermisosDeFunciones(idBase, tipo) {

	var sSQL  = "SELECT MW_NombreFuncion, WgCfg_ID, MW_Descripcion, MW_PuedeAgregar, MW_PuedeBorrar"
		sSQL += " , MW_PuedeEditar, Consulta, Agregar, Borrar, Editar "
		sSQL += " FROM dbo.ufn_Permisos_DameArbolFunciones(-1," + idBase + ", " + SistemaATrabajar + ", " + Gru_ID + ", " + iqCli_ID + ") "
		//Response.Write(sSQL)
	var rsPermisos = AbreTabla(sSQL,1,2)	
	EspacioLateral += 5
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

%>
<tr>
	<td align="text-center">
		<label class="checkbox-inline i-checks"><input type="checkbox" class="chSeg" name="Seg" id="Seg" data-idseg="<%=iidseg%>" data-esfn="1" <%=prConsulta%> value="1">&nbsp;</label>
	</td>
	<td align="text-center">
	<% if ( rsPermisos.Fields.Item("MW_PuedeAgregar").Value > 0 ) { %> 
		<label class="checkbox-inline i-checks"><input type="checkbox" class="chSeg" name="Seg" id="Seg" data-idseg="<%=iidseg%>" data-esfn="1" <%=prAgregar%> value="2"></label>
	<% } else { Response.Write("&nbsp;") } %>
	</td>
	<td align="text-center">
	<% if ( rsPermisos.Fields.Item("MW_PuedeBorrar").Value > 0 ) { %>
		<label class="checkbox-inline i-checks"><input type="checkbox" class="chSeg" name="Seg" id="Seg" data-idseg="<%=iidseg%>" data-esfn="1" <%=prBorrar%> value="4"></label>
	<% } else { Response.Write("&nbsp;") } %>
	</td>
	<td align="text-center">
	<% if ( rsPermisos.Fields.Item("MW_PuedeEditar").Value > 0 ) { %>
		<label class="checkbox-inline i-checks"><input type="checkbox" class="chSeg" name="Seg" id="Seg" data-idseg="<%=iidseg%>" data-esfn="1" <%=prEditar%> value="8"></label>
	<% } else { Response.Write("&nbsp;") } %>
	</td>
	<td align="text-left" style="text-indent:<%=EspacioLateral%>em">&nbsp;<strong><% Response.Write(rsPermisos.Fields.Item("MW_NombreFuncion").Value) %></strong></td>
	<td>&nbsp;<%=tipo%></td>
</tr>
 <%
		rsPermisos.MoveNext()
	}
	rsPermisos.Close()  
	EspacioLateral -= 5   
} 
 
  
function DameArbolPermisosExtendidos(idBase) {
//	@iUsuID INT,
//	@iMnuID INT,
//	@iSysID INT,
//	@iGrupoID INT,
//	@iqCliID INT
	
	var sSQL  = "SELECT Seg_ID, Seg_TextoGeneral, TextoAcceso, PAcceso, TextoAgregar, PAgregar, TextoBorrar, PBorrar "
	    sSQL += " , TextoEditar, PEditar, Acceso, Agregar, Borrar, Editar "
		sSQL += " FROM dbo.ufn_Permisos_DameArbolPermisosExtendidos(" + Usu_ID + "," + idBase + ", " + SistemaATrabajar + ", " + Gru_ID + ", " + iqCli_ID + ") "
		if (bIQon4Web){ Response.Write("<br />1&nbsp;:"+sSQL) }
	var rsPermisos = AbreTabla(sSQL,1,2)	
	EspacioLateral += 5
	while (!rsPermisos.EOF) {
		var iidseg = idBase + "." + rsPermisos.Fields.Item("Seg_ID").Value
		prAgregar = ""
		prBorrar = ""
		prEditar = "" 
		prConsulta = ""
		if (rsPermisos.Fields.Item("Acceso").Value == 1) { prConsulta = " checked " }
		if (rsPermisos.Fields.Item("Agregar").Value == 1) { prAgregar = " checked " }
		if (rsPermisos.Fields.Item("Borrar").Value == 1) { prBorrar = " checked " }
		if (rsPermisos.Fields.Item("Editar").Value == 1) { prEditar = " checked " }
%> 
  </tr>
<tr>
	<td>&nbsp;</td>
	<td>&nbsp;</td>
	<td>&nbsp;</td>
	<td>&nbsp;</td>
	<td style="padding-left:<%=EspacioLateral%>px">
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr style="background-color:#E1E1E1;" >
			<td colspan="5" align="left">&nbsp;<% Response.Write(rsPermisos.Fields.Item("Seg_TextoGeneral").Value) %></td>
		  </tr>
		  <tr style="background-color:#E1E1E1;" >
		  <td align="left">&nbsp;&nbsp;&nbsp;</td>
			<td><% if ( rsPermisos.Fields.Item("PAcceso").Value > 0 ) { %>
			<input class="chSeg" name="Seg" id="Seg" data-idseg="<%=iidseg%>" data-esfn="2"  type="checkbox" <%=prConsulta%> value="1">
			&nbsp;<%=rsPermisos.Fields.Item("TextoAcceso").Value%>
	<% } else { Response.Write("&nbsp;") } %>
			</td>
			<td><% if ( rsPermisos.Fields.Item("PAgregar").Value > 0 ) { %>
			<input class="chSeg" name="Seg" id="Seg" data-idseg="<%=iidseg%>" data-esfn="2"  type="checkbox" <%=prAgregar%> value="2">
			&nbsp;<%=rsPermisos.Fields.Item("TextoAgregar").Value%>
	<% } else { Response.Write("&nbsp;") } %></td>
			<td><% if ( rsPermisos.Fields.Item("PBorrar").Value > 0 ) { %>
			<input class="chSeg" name="Seg" id="Seg" data-idseg="<%=iidseg%>" data-esfn="2"  type="checkbox" <%=prBorrar%> value="4">
			&nbsp;<%=rsPermisos.Fields.Item("TextoBorrar").Value%>
	<% } else { Response.Write("&nbsp;") } %></td>
			<td><% if ( rsPermisos.Fields.Item("PEditar").Value > 0 ) { %>
			<input class="chSeg" name="Seg" id="Seg" data-idseg="<%=iidseg%>" data-esfn="2"  type="checkbox" <%=prEditar%> value="8">
			&nbsp;<%=rsPermisos.Fields.Item("TextoEditar").Value%>
	<% } else { Response.Write("&nbsp;") } %></td>
		  </tr>
		  <tr >
			<td height="2" colspan="4" style="background-color:#000000;"></td>
		  </tr>
		</table>
	</td>
	<td>&nbsp;Ext</td>
</tr> 
<%
		rsPermisos.MoveNext()
	}
	rsPermisos.Close()  
	EspacioLateral -= 5   
} 
 
function ArbolDePermisos(idBase, tipo) {

	var sSQL  = "SELECT Mnu_Titulo, Mnu_ID, Mnu_Padre, Mnu_Descripcion, Mnu_SiguienteVentana , Mnu_idseguridad, Consulta, Editar, Borrar, Agregar"
		sSQL += " FROM dbo.ufn_Permisos_DameRama (" + Usu_ID + ", " + idBase + ", " + SistemaATrabajar + ", " + Gru_ID + ", " + iqCli_ID + ") "
		if (bIQon4Web){ Response.Write("<br />1&nbsp;:"+sSQL) }
	var rsPermisos = AbreTabla(sSQL,1,2)	
	EspacioLateral += 2
	while (!rsPermisos.EOF) {

   var iMnu = rsPermisos.Fields.Item("Mnu_ID").Value
		var iSig = rsPermisos.Fields.Item("Mnu_SiguienteVentana").Value
		var iidseg = rsPermisos.Fields.Item("Mnu_idseguridad").Value
		prAgregar = ""
		prBorrar = ""
		prEditar = "" 
		prConsulta = ""
		if (rsPermisos.Fields.Item("Consulta").Value == 1) { prConsulta = " checked " }
		if (rsPermisos.Fields.Item("Agregar").Value == 1) { prAgregar = " checked " }
		if (rsPermisos.Fields.Item("Borrar").Value == 1) { prBorrar = " checked " }
		if (rsPermisos.Fields.Item("Editar").Value == 1) { prEditar = " checked " }
		
%>
  <tr>
    <td class="text-center">
		<label class="checkbox-inline i-checks"><input type="checkbox" class="chSeg" name="Seg" id="Seg" data-idseg="<%=iidseg%>" data-esfn="0" <%=prConsulta%> value="1"></label>
	</td>
    <td class="text-center">
		<label class="checkbox-inline i-checks"><input type="checkbox" class="chSeg" name="Seg" id="Seg" data-idseg="<%=iidseg%>" data-esfn="0" <%=prAgregar%> value="2"></label>
    </td>
    <td class="text-center">
		<label class="checkbox-inline i-checks"><input type="checkbox" class="chSeg" name="Seg" id="Seg" data-idseg="<%=iidseg%>" data-esfn="0" <%=prBorrar%> value="4"></label>
	</td>
    <td class="text-center">
		<label class="checkbox-inline i-checks"><input type="checkbox" class="chSeg" name="Seg" id="Seg" data-idseg="<%=iidseg%>" data-esfn="0" <%=prEditar%> value="8"></label>
	</td> 
    <td class="text-left" style="text-indent:<%=EspacioLateral%>em">&nbsp;<h4><% Response.Write(rsPermisos.Fields.Item("Mnu_Titulo").Value + " - " + iMnu) %></h5></td>
    <td class="text-center"><h4><%=tipo%></h5></td>
  </tr>
 <%
		//} 
		DameArbolPermisosExtendidos(iMnu) 
		ArbolDePermisosDeFunciones(iMnu,"Fn")
		ArbolDePermisos(iMnu,"Mnu")
		if (iSig > 0) {
			ArbolDePermisos(iSig,"Mnu")
		}
		rsPermisos.MoveNext()
	}
	rsPermisos.Close()  
	EspacioLateral -= 2   
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
<!-- Tabla de permisos {start} -->
<div class="table-responsive">
<table class="table table-bordered table-hover table-striped dataTable" id="tblPermisos" width="100%">
    <thead>
        <tr>
            <th class="text-center"><h4>Consultar</h4></th>
            <th class="text-center"><h4>Agregar</h4></th>
            <th class="text-center"><h4>Borrar</h4></th>
            <th class="text-center"><h4>Editar</h4></th>
            <th class="text-center"><h4>Descripci&oacute;n</h4></th>
            <th class="text-center"><h4>Tipo</h4></th>
            <!--th class="center" width="80">
                <label class="center checkbox-inline">
                    <input type="checkbox" name="CheckTodos" id="CheckTodos" class="grey CheckTodos">
                </label>
            </th-->
        </tr>
    </thead>
	<tbody>
	<%		
        if (Usu_ID > -1 && Gru_ID > -1) {
            Usu_ID = -1
        }
        
        var sSQL  = "SELECT Mnu_Titulo, Mnu_ID, Mnu_Padre, Mnu_Descripcion, Mnu_SiguienteVentana , Mnu_idseguridad, Consulta, Editar, Borrar, Agregar"
            sSQL += " FROM dbo.ufn_Permisos_DameBase (" + Usu_ID + ", " + Mnu_ID + ", " + SistemaATrabajar + ", " + Gru_ID + ", " + iqCli_ID + ") "
        	if (bIQon4Web){ Response.Write("<br />1&nbsp;:"+sSQL) }
			
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
            var iidseg = rsPermisos.Fields.Item("Mnu_idseguridad").Value
    %>
    	<tr>
            <td class="text-center">
                <label class="checkbox-inline i-checks">
                    <input type="checkbox"class="chSeg align-middle" name="Seg" id="Seg" data-idseg="<%=iidseg%>" data-esfn="0" <%=prConsulta%> value="1">
                </label>
            </td>
            <td class="text-center"><label class="checkbox-inline">&nbsp;</label></td>
            <td class="text-center"><label class="checkbox-inline">&nbsp;</label></td>
            <td class="text-center"><label class="checkbox-inline">&nbsp;</label></td> 
            <td style="text-indent:<%=EspacioLateral%>em" class="align-middle"><h4><% Response.Write(rsPermisos.Fields.Item("Mnu_Titulo").Value) %></h4></td>
            <td class="text-center"><h4>Mnu</h4></td>
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
    </tbody>
</table>
</div>
<!-- Tabla de permisos {end} -->
<script language="JavaScript">
<!--

var Indice = -1;

 $(document).ready(function(){

	 
	$('.i-checks').iCheck({
		checkboxClass: 'icheckbox_square-green',
		//radioClass: 'iradio_square-green',
	});
	 

	var idseg = -1;
	var Valor = "";
	var iesfn = 0;

	//$("#chTodos").click(function(){  
	$('.chTodos').on('ifClicked', function(){	
		//alert("clic a chTodos!!!!!!!!!");	
		$('.chSeg').each(function(){
		   var checkbox = $(this);
			//if (!checkbox.is(':checked')) {
				idseg = checkbox.attr('data-idseg');
				iesfn = checkbox.attr('data-esfn');
				Valor = checkbox.val();
				 var Checado = $("#chTodos").is(':checked');
				 //var Checado = $('#chTodos').iCheck('check'); 
				 //console.log(" idseg = " + idseg + " iesfn = " + iesfn + " Valor = " + Valor + " esta checado = " + Checado );
				 //checkbox.attr('checked',Checado);
				 //$('input').iCheck('check'); 
				 if(Checado) {
				 	checkbox.iCheck('uncheck');	 
				 } else {
					checkbox.iCheck('check'); 
				 }
				 //alert(" idseg = " + idseg + " iesfn = " + iesfn + " Valor = " + Valor + " esta checado = " + Checado + " sUsuConGpo = " + $("#sUsuConGpo").val() );
				 GuardaValores(idseg,iesfn,Valor,Checado,0, $("#sUsuConGpo").val()); 
				 
				 if ($("#sUsuConGpo").val() == 1) {
					$("#sUsuConGpo").val(0);
					$("#sGru_ID").val(-1);
					$("#sUsu_ID").val($("#Usu_ID").val());
				 }
				 
			//}
		  // log('El checkbox ' + checkbox.attr('name') + ' está checkeado? ' + checkbox.is(':checked')  );
		});
		//alert($("#chTodos").iCheck('uncheck'));
		//if($(".chTodos").is(':checked')) {
		//$('.micheckbox').is(':checked')
		//alert($(".chTodos").is(':checked'));	
		if(!$(".chTodos").is(':checked')) {	
			sMensaje= "Todos los permisos de esta secci&oacuten fueron habilitados"
		} else {
			sMensaje= "Todos los permisos de esta secci&oacuten fueron revocados"
		}
		//$.jGrowl(sMensaje, { header: 'Aviso', sticky: false, life: 5500, glue:'before'});
		//$.gritter.add({position: 'top-right',title: 'Aviso',text: sMensaje,time: 5500});
		var sMensaje = "El permiso fue otorgado correctamente"							
		toastr.success(sMensaje, "Aviso")
		
	});

	//$(".chSeg").click(function(){
	$('.chSeg').on('ifClicked', function(){	
		//alert("hiciste click......."); 
		//alert("hiciste click " + $(".dvEditable").attr("BDID"));
		//		  Indice = $(".chSeg").index(this); 
		//		  idseg = $(".chSeg:eq("+Indice+")").attr('data-idseg');
		//		  iesfn = $(".chSeg:eq("+Indice+")").attr('data-esfn');
		//		  Valor = $(".chSeg:eq("+Indice+")").val();
		//		  var Checado = $(".chSeg:eq("+Indice+")").is(':checked');
		var checkbox = $(this);
		idseg = checkbox.attr('data-idseg');
		iesfn = checkbox.attr('data-esfn');
		Valor = checkbox.val();
		var Checado = !checkbox.is(':checked');
		//alert(checkbox.is(':checked'));
		//console.log(" indice = " + Indice + " id seg = " + idseg + " valor = " + Valor + " esta checado = " + Checado );
		//alert(" idseg = " + idseg + " iesfn = " + iesfn + " Valor = " + Valor + " esta checado = " + Checado + " sUsuConGpo = " + $("#sUsuConGpo").val() );
		GuardaValores(idseg,iesfn,Valor,Checado,1, $("#sUsuConGpo").val());
		
		if ($("#sUsuConGpo").val() == 1) {
			$("#sUsuConGpo").val(0);
			$("#sGru_ID").val(-1);
			$("#sUsu_ID").val($("#Usu_ID").val());
		}
	});

	 
 });
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
				sSQL  += " AND sys6 = " + SistemaATrabajar
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
						sSQL  += ", " + SistemaATrabajar 
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
				sSQL  += " AND sys6 = " + SistemaATrabajar
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
						sSQL  += ", " + SistemaATrabajar  //6 
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
		case 4:  // un usuario abandona un grupo
			//se marca al usuario de que ya no tiene grupo
			//se copia la seguridad del grupo a usuario
			var iResultado = 0
			//try {
					
				var sSQL = " Update Usuario "
					sSQL += " set Usu_Grupo = -1 "
					sSQL += " where Usu_ID = " + Usu_ID 
					
					//Response.Write(sSQL)
					Ejecuta(sSQL ,0)
					iResultado = 1
					
					var sSQL = " Exec SP_AsignaGrupoAUsuario "
						sSQL +=  Gru_ID
						sSQL += ", " + Usu_ID
						sSQL += ", " + SistemaATrabajar 
						sSQL += ", " + iqCli_ID 
							
					Ejecuta(sSQL ,2)
					Response.Write("<br>" + sSQL)
					iResultado = 2

//				} 
//				catch(err) {
//					iResultado = 0
//				}
		
			break;
		case 5:  // Guardando un permiso extendido
			break;  		
	}
	
	
	

%>	
	
	
	
	
	
	
	
	
	
	