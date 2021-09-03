<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%
var Alr_ID = Parametro("Alr_ID",-1)

var Alr_EsParaCorreo = 0
var Alr_EsParaPantalla = 0
var Alr_Nombre = ""
var Alr_Descripcion = ""
var Alr_Letrero = ""
var AlrS_ID = 0
var Seccion = ""
var Usu_Siglas = ""
var Usu_Nombre = ""
var Usu_Email = ""
var IDUnica = 0

var chkHabilitado = 0
var chkMail = 0
var chkPantalla = 0

var sSQL = "  SELECT Alr_Nombre, Alr_Descripcion, Alr_Letrero, Alr_Ayuda, Alr_MostrarSiEsCero, Alr_Habilitada "
    sSQL += " , Alr_EsParaPantalla, Alr_EsParaCorreo, AlrS_ID "
    sSQL += " ,(SELECT AlrS_Nombre FROM Alertamientos_Seccion a WHERE a.AlrS_ID = Alertamientos.AlrS_ID) as Seccion "	
    sSQL += " FROM Alertamientos "
    sSQL += " WHERE Alr_ID = " + Alr_ID
    sSQL += " AND Alr_VisibleAdmin = 1 "	
	
		
	var rsRv = AbreTabla(sSQL,1,0)
	if (!rsRv.EOF){
		Alr_Nombre = rsRv.Fields.Item("Alr_Nombre").Value
		Alr_Descripcion = rsRv.Fields.Item("Alr_Descripcion").Value
		Alr_Letrero = rsRv.Fields.Item("Alr_Letrero").Value	
		Seccion = rsRv.Fields.Item("Seccion").Value		
		Alr_EsParaCorreo = rsRv.Fields.Item("Alr_EsParaCorreo").Value		
		Alr_EsParaPantalla = rsRv.Fields.Item("Alr_EsParaPantalla").Value	
		AlrS_ID = rsRv.Fields.Item("AlrS_ID").Value								
	}
	rsRv.Close()
	
	
%>
<div class="wrapper wrapper-content animated fadeInRight">
	<div class="ibox-content">
		<div class="row">
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="FichaCampoValor">  
  <tr>
    <td>&nbsp;</td>
    <td colspan="3"><h3><%=Seccion%> - <%=Alr_Nombre%> </h3></td>
    <td width="36%">&nbsp;<%=Alr_Letrero%></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td colspan="4"><%=Alr_Descripcion%></td>
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
            <td width="7%" align="center" >Mail</td>
            <td width="7%" align="center" >Pantalla</td>
            <td width="7%" align="center"  >Siglas</td>
            <td width="43%" >Nombre</td>
            <td width="29%" >e-mail</td>
            </tr>
<%

		var sSQL = " select u.Usu_ID, ISNULL(Usu_Siglas,'') as siglas, Usu_Nombre, Usu_Email, IDUnica "	

            sSQL += " ,(ISNULL((select 'checked' from Usuario_Alertamientos c "
			sSQL +=                   " where c.ID_Usuario = IDUnica "
			sSQL +=                   "   and c.AlrS_ID = " + AlrS_ID 						
			sSQL +=                   "   and c.Alr_ID = " + Alr_ID 	
			sSQL +=                   "   and c.Alr_Pantalla = 1),'')) as Pantalla "
		    sSQL += " ,(ISNULL((select 'checked' from Usuario_Alertamientos c "
			sSQL +=                   " where c.ID_Usuario = IDUnica "
			sSQL +=                   "   and c.AlrS_ID = " + AlrS_ID						
			sSQL +=                   "   and c.Alr_ID = " + Alr_ID 	
			sSQL +=                   "   and c.Alr_Mail = 1),'')) as email "			
		    sSQL += " ,(ISNULL((select 'checked' from Usuario_Alertamientos c "
			sSQL +=                   " where c.ID_Usuario = IDUnica "
			sSQL +=                   "   and c.AlrS_ID = " + AlrS_ID 						
			sSQL +=                   "   and c.Alr_ID = " + Alr_ID	
			sSQL +=                   "   and c.Alr_Habilitado = 1),'')) as Habilitado "
 
            sSQL += " from Usuario u, Seguridad_Indice i "
            sSQL += " where  u.Usu_ID = i.Usu_ID AND u.Usu_Habilitado = 1 "
            sSQL += " order by Usu_Nombre "
 
			var rsCTe = AbreTabla(sSQL,1,0)
				while (!rsCTe.EOF){
					Usu_Siglas = "" + rsCTe.Fields.Item("siglas").Value
					Usu_Nombre = "" + rsCTe.Fields.Item("Usu_Nombre").Value
					Usu_Email = "" + rsCTe.Fields.Item("Usu_Email").Value
					IDUnica = rsCTe.Fields.Item("IDUnica").Value	
					chkHabilitado = rsCTe.Fields.Item("Habilitado").Value
					chkMail = rsCTe.Fields.Item("email").Value
					chkPantalla = rsCTe.Fields.Item("Pantalla").Value		

%>
          <tr>
            <td align="center">
            <input type="checkbox" id="chkSelecc" class="chHab" data-usuid="<%=IDUnica%>" <%=chkHabilitado%> >
            </td>
            <td align="center">
<% if(Alr_EsParaCorreo == 1) { %>
              <input type="checkbox" id="chkSelecc" class="chMail" data-usuid="<%=IDUnica%>" <%=chkMail%> >
<% } else { %> 
              &nbsp;
<% } %>               
            </td>
            <td align="center">
<% if(Alr_EsParaPantalla == 1) { %>            
		  <input type="checkbox" id="chkSelecc" class="chPantalla" data-usuid="<%=IDUnica%>" <%=chkPantalla%> >
<% } else { %> 
		  &nbsp;
<% } %>                       
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
			CambiaEstatus(o.is(':checked'),o.data("usuid"),1)
        });	
		
		$(".chMail").click(function(event) {
			var o = $(this)
			CambiaEstatus(o.is(':checked'),o.data("usuid"),2)
        });	
		
		$(".chPantalla").click(function(event) {
			var o = $(this)
			CambiaEstatus(o.is(':checked'),o.data("usuid"),3)
        });	
		
	});
		
		
function CambiaEstatus(Checado,usuid,tp) {
		
	var ckd = (Checado==true) ? 1 : 0;
	
	$.post( "/pz/agt/Usuarios/Usuarios_Ajax.asp"
		  , { Tarea:tp,ID_Unico:usuid,IDUsuario:$("#IDUsuario").val()
			 ,Alr_ID:<%=Alr_ID%>,AlrS_ID:<%=AlrS_ID%>,Chkdo:ckd}
		  , function () {
			var sMensaje = "El registro fue guardado"
		 	Avisa("success","Aviso",sMensaje)
		  }
	);
				
}
	
//-->
</script>