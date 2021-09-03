<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%
var Cli_ID = Parametro("Cli_ID",-1)
var Usu_ID = Parametro("Usu_ID",-1)
var Prov_ID = Parametro("Prov_ID",-1)
var Cli_Usu_ID = Parametro("Cli_Usu_ID",-1)
var Prov_Usu_ID = Parametro("Prov_Usu_ID",-1)
var sCorreo = ""
var sNombr = ""
var ID_Unico = 0
var sSQLIU = ""
var Alr_EsParaCorreo = 0
var Alr_EsParaPantalla = 0

var TipoUsuario = ParametroDeVentana(SistemaActual, VentanaIndex, "Tipo de usuario",1)  
                     //1 Usuario del sistema
                     //2 Usuario del cliente
					 //3 Usuario del proveedor

var sSQL = " select Usu_Nombre, Usu_Email   "
if (TipoUsuario == 1) {
	sSQL += " from Usuario "
	sSQL += " where Usu_ID = " + Usu_ID
	
	sSQLIU = "select dbo.fn_Usuario_DameIDUnico(-1,-1,-1,-1," + Usu_ID + ",-1) "
}
if (TipoUsuario == 2) {
	sSQL += " from Cliente_Usuario "
	sSQL += " where Cli_Usu_ID = " + Cli_Usu_ID
	sSQL += " and Cli_ID = " + Cli_ID	
	
	sSQLIU = "select dbo.fn_Usuario_DameIDUnico(" + Cli_ID + "," + Cli_Usu_ID + ",-1,-1,-1,-1) "	
}
if (TipoUsuario == 3) {
	sSQL += " from Deudor_Usuario "
	sSQL += " where Prov_Usu_ID = " + Prov_Usu_ID
	sSQL += " and Prov_ID = " + Prov_ID	
	
	sSQLIU = "select dbo.fn_Usuario_DameIDUnico(-1,-1," + Prov_ID + "," + Prov_Usu_ID + ",-1,-1) "		
}

	var rsRv = AbreTabla(sSQL,1,0)
		if (!rsRv.EOF){
			sCorreo = rsRv.Fields.Item("Usu_Email").Value
			sNombr = rsRv.Fields.Item("Usu_Nombre").Value
		}
		rsRv.Close()
	
	var rsUn = AbreTabla(sSQLIU,1,0)
	if (!rsUn.EOF){
		ID_Unico = rsUn.Fields.Item(0).Value
	}
	rsUn.Close()
	
%>
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="FichaCampoValor">  
  <tr>
    <td colspan="6" class="FichaSubtitulo">Cat&aacute;logo de alertas y avisos</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td width="15%">&nbsp;</td>
    <td width="22%">&nbsp;</td>
    <td width="21%">&nbsp;</td>
    <td width="36%">&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td colspan="4">Seleccione las notificaciones que <%=sNombr %> recibir&aacute; a la cuenta <%=sCorreo%></td>
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
            <td width="7%" align="center" class="TablaEncabezado">Habilitado</td>
            <td width="6%" align="center" class="TablaEncabezado">Mail</td>
            <td width="7%" align="center" class="TablaEncabezado">Pantalla</td>
            <td width="21%" class="TablaEncabezado">Etiqueta</td>
            <td width="23%" class="TablaEncabezado">Nombre</td>
            <td width="36%" class="TablaEncabezado">Descripci&oacute;n</td>
          </tr>
<%
        var TipoRenglon = "evenRow"
		var sSQL = " select Alr_ID, Alr_Nombre, Alr_Descripcion, Alr_Letrero "
		    sSQL += " , Alr_EsParaPantalla, Alr_EsParaCorreo "	
			sSQL += " , 0 as Pantalla, 0 as email, 0 as Habilitado "
		   // sSQL += " ,(ISNULL((select 'checked' from Usuario_Alertamientos c "
//			sSQL +=                   " where c.ID_Usuario = " + ID_Unico					
//			sSQL +=                   "   and c.Alr_ID = a.Alr_ID " 	
//			sSQL +=                   "   and c.Alr_Pantalla = 1),'')) as Pantalla "
//		    sSQL += " ,(ISNULL((select 'checked' from Usuario_Alertamientos c "
//			sSQL +=                   " where c.ID_Usuario = " + ID_Unico						
//			sSQL +=                   "   and c.Alr_ID = a.Alr_ID " 	
//			sSQL +=                   "   and c.Alr_Mail = 1),'')) as email "			
//		    sSQL += " ,(ISNULL((select 'checked' from Usuario_Alertamientos c "
//			sSQL +=                   " where c.ID_Usuario = " + ID_Unico					
//			sSQL +=                   "   and c.Alr_ID = a.Alr_ID " 	
//			sSQL +=                   "   and c.Alr_Habilitado = 1),'')) as Habilitado "					
            sSQL += " from Alertamientos"
            sSQL += " where Alr_Habilitada = 1 "
            sSQL += " and Alr_VisibleAdmin = 1 " // and Acc_TipoCG302 = 2 "
			sSQL += " and Sys_ID = " + SistemaActual
            sSQL += " order by Alr_Orden " 

			var rsCTe = AbreTabla(sSQL,1,0)
				while (!rsCTe.EOF){
					if (TipoRenglon == "evenRow") {
						TipoRenglon = "oddRow" 
					} else {
						TipoRenglon = "evenRow"
					}
					Alr_EsParaCorreo = rsCTe.Fields.Item("Alr_EsParaCorreo").Value 
					Alr_EsParaPantalla = rsCTe.Fields.Item("Alr_EsParaPantalla").Value
					
%>
          <tr class="fontBlack <%=TipoRenglon%>" >
            <td align="center">
            <input type="checkbox" id="chkSelecc" class="chHab" 
              data-alrid="<%=rsCTe.Fields.Item("Alr_ID").Value%>"
               <%=rsCTe.Fields.Item("Habilitado").Value%> >
            </td>
            <td align="center">
<% if(Alr_EsParaCorreo == 1) { %>
              <input type="checkbox" id="chkSelecc" class="chMail" 
              data-alrid="<%=rsCTe.Fields.Item("Alr_ID").Value%>"
               <%=rsCTe.Fields.Item("email").Value%> >
<% } else { %> 
              &nbsp;
<% } %>               
            </td>
            <td align="center">
<% if(Alr_EsParaPantalla == 1) { %>            
            <input type="checkbox" id="chkSelecc" class="chPantalla" 
              data-alrid="<%=rsCTe.Fields.Item("Alr_ID").Value%>"
               <%=rsCTe.Fields.Item("Pantalla").Value%> >
<% } else { %> 
              &nbsp;
<% } %>                       
            </td>
            <td><% Response.Write(rsCTe.Fields.Item("Alr_Letrero").Value) %></td>
            <td><% Response.Write(rsCTe.Fields.Item("Alr_Nombre").Value) %></td>
            <td><% Response.Write(rsCTe.Fields.Item("Alr_Descripcion").Value) %></td>
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
<input id="avUsu_ID"     type="hidden" value="<%=Usu_ID%>" />
<input id="avCli_ID"     type="hidden" value="<%=Cli_ID%>" />             
<input id="avProv_ID"     type="hidden" value="<%=Prov_ID%>" />              
<input id="avCli_Usu_ID" type="hidden" value="<%=Cli_Usu_ID%>" />             
<input id="avProv_Usu_ID" type="hidden" value="<%=Prov_Usu_ID%>" /> 
<input id="ID_Unico"   type="hidden" value="<%=ID_Unico%>" /> 
<script language="JavaScript">
<!--

	$(document).ready(function() {
		
		$(".chHab").click(function(event) {
			var o = $(this)
			CambiaEstatus(o.is(':checked'),o.data("alrid"),1)
        });	
		
		$(".chMail").click(function(event) {
			var o = $(this)
			CambiaEstatus(o.is(':checked'),o.data("alrid"),2)
        });	
		
		$(".chPantalla").click(function(event) {
			var o = $(this)
			CambiaEstatus(o.is(':checked'),o.data("alrid"),3)
        });	
		
	});
		
		
function CambiaEstatus(Checado,alrid,tp) {
		
	var ckd = (Checado==true) ? 1 : 0;
	
	$.post( "/pz/wms/Usuarios/Usuarios_Ajax.asp"
		  , { Tarea:tp,ID_Unico:$("#ID_Unico").val(),IDUsuario:$("#IDUsuario").val()
			 ,Alr_ID:alrid,Chkdo:ckd}
		  , function () {
			var sMensaje = "El registro fue guardado"
		 	//$.gritter.add({position: 'top-right',title: 'Aviso',text: sMensaje,sticky: true,time: 1200});
			Avisa("success","Aviso",sMensaje)
		  }
	);
				
}
	
//-->
</script>