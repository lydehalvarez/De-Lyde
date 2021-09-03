<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%
var Pro_ID = Parametro("Pro_ID",-1)
var ProR_ID = Parametro("ProR_ID",-1)

var Usu_Siglas = ""
var Usu_Nombre = ""
var Usu_Email = ""
var Emp_ID = 0

var chkHabilitado = 0

%>
<div class="wrapper wrapper-content animated fadeInRight">
	<div class="ibox-content">
		<div class="row">
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="FichaCampoValor">  
  <tr>
    <td>&nbsp;</td>
    <td colspan="3"><h3>
<%
	var sEventos = " class='form-control objCBO' onchange='javascript:CambioRol()' "
	var sCondicion = " Pro_ID = " + Pro_ID

	CargaCombo("xProR_ID",sEventos,"ProR_ID","ProR_Nombre","BPM_Proceso_Rol",sCondicion,"",ProR_ID,0,"Seleccione un roll","Edicion") 
	
%>
    </h3></td>
    <td width="36%">&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td >&nbsp;</td>
    <td width="15%">&nbsp;</td>
    <td width="22%">&nbsp;</td>
    <td width="21%">&nbsp;</td>
    <td width="36%">&nbsp;</td>
    <td>&nbsp;</td>
  </tr>  
  
  <tr>
    <td width="3%">&nbsp;</td>
    <td colspan="4" >
        <table width="100%" class="table table-striped table-bordered table-hover dataTables-example" >
          <tr>
            <td width="7%" align="center" >Habilitado</td>
            <td width="7%" align="center"  >Siglas</td>
            <td width="43%" >Nombre</td>
            <td width="29%" >e-mail</td>
            </tr>
<%
 
		var sSQL = " select e.Emp_ID, Emp_NombreCompleto, Emp_Email "	
		
		    sSQL += " ,(ISNULL((select 'checked' from BPM_Proceso_Rol_Usuario c "
			sSQL +=                   " where c.Emp_ID = e.Emp_ID "
			sSQL +=                   "   and c.Pro_ID = " + Pro_ID 						
			sSQL +=                   "   and c.ProR_ID = " + ProR_ID	
			sSQL +=                   "   and c.ProRU_Habilitado = 1),'')) as Habilitado "
			
            sSQL += " from Empleado e "
            sSQL += " order by Emp_NombreCompleto "
 
			var rsCTe = AbreTabla(sSQL,1,0)
				while (!rsCTe.EOF){
					Usu_Siglas = "" 
					Usu_Nombre = "" + rsCTe.Fields.Item("Emp_NombreCompleto").Value
					Usu_Email = "" + rsCTe.Fields.Item("Emp_Email").Value					
					chkHabilitado = rsCTe.Fields.Item("Habilitado").Value	
					Emp_ID = rsCTe.Fields.Item("Emp_ID").Value

%>
          <tr>
            <td align="center">
              <input type="checkbox" id="chkSelecc" class="chHab" data-usuid="<%=Emp_ID%>" <%=chkHabilitado%> >
            </td>
            <td>&nbsp;<%=Usu_Siglas%></td>
            <td>&nbsp;<%=Usu_Nombre%></td>
            <td>&nbsp;<%=Usu_Email%></td>            
            </tr>
<%
					rsCTe.MoveNext()
				}
				rsCTe.Close() 
%>
        </table>
    </td>
    <td width="3%">&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td colspan="4" >&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td colspan="4" >&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
</table>
</div></div></div>

<script language="JavaScript">
<!--

	$(document).ready(function() {
		
		$(".chHab").click(function(event) {
			var o = $(this)
			CambiaEstatus(o.is(':checked'),o.data("usuid"))
        });	

	});
		
		
function CambiaEstatus(Checado,usuid) {
		
	var ckd = (Checado==true) ? 1 : 0;
	
	$.post( "/pz/agt/Usuarios/Usuarios_Ajax.asp"
		  , { Tarea:9,ID_Unico:usuid,IDUsuario:$("#IDUsuario").val()
		      ,Pro_ID:$("#Pro_ID").val()
			  ,ProR_ID:$("#xProR_ID").val(),Chkdo:ckd}
		  , function () {
			var sMensaje = "El registro fue guardado"
		 	Avisa("success","Aviso",sMensaje)
		  }
	);
				
}


function CambioRol(){
	
	$("#ProR_ID").val($("#xProR_ID").val())
	RecargaEnSiMismo()
	
}
	
//-->
</script>