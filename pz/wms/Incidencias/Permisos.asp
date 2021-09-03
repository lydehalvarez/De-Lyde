<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%

    var Usu_ID = Parametro("Usu_ID",-1)

    var sCorreo = ""
    var sNombr = ""
    var ID_Unico = 0
    var sSQLIU = ""

    sSQLIU = "select dbo.fn_Usuario_DameIDUnico(-1,-1,-1,-1," + Usu_ID + ",-1) "
   
	var rsUn = AbreTabla(sSQLIU,1,0)
	if (!rsUn.EOF){
		ID_Unico = rsUn.Fields.Item(0).Value
	}
	rsUn.Close()
   
   var sSQL = "select Tipo, ID, Nombre, email from dbo.ufn_Usuario_DameDatos(" + ID_Unico + ")"
   var rsRv = AbreTabla(sSQL,1,0)
   if (!rsRv.EOF){
        sCorreo = rsRv.Fields.Item("email").Value
        sNombr = rsRv.Fields.Item("Nombre").Value
   }
   rsRv.Close()

%>
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="FichaCampoValor">  
  <tr>
    <td colspan="6" class="FichaSubtitulo">Cat&aacute;logo de originaci&oacute;n de incidencias</td>
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
    <td colspan="4">Seleccione el tipo de asunto que <strong><%=sNombr %></strong> puede consultar</td>
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
            <td width="23%" class="TablaEncabezado">Nombre</td>
            <td width="36%" class="TablaEncabezado">Descripci&oacute;n</td>
          </tr>
<%
   
		var sSQL = "SELECT InsO_ID, InsO_Nombre, InsO_Descripcion, InsO_Icono "
		    sSQL += " ,(ISNULL((select 'checked' from Incidencia_Usuario u "
		    sSQL +=           " where u.InU_IDUnico = " + ID_Unico					
		    sSQL +=             " and u.InsO_ID = o.InsO_ID ),'')) as Habilitado "
            sSQL += " from Incidencia_Originacion o "
            sSQL += " Where InsO_Habilitado = 1 "
            sSQL += " order by InsO_Nombre " 

			var rsCTe = AbreTabla(sSQL,1,0)
				while (!rsCTe.EOF){
%>
          <tr >
            <td align="center">
            <input type="checkbox" id="chkSelecc" class="chHab" 
              data-insoid="<%=rsCTe.Fields.Item("InsO_ID").Value%>"
               <%=rsCTe.Fields.Item("Habilitado").Value%> >
            </td>
            <td><% Response.Write(rsCTe.Fields.Item("InsO_Nombre").Value) %></td>
            <td><% Response.Write(rsCTe.Fields.Item("InsO_Descripcion").Value) %></td>
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
    <td>&nbsp;</td>
    <td>&nbsp;</td> 
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
</table>
    
<input id="avUsu_ID"     type="hidden" value="<%=Usu_ID%>" />          
<input id="ID_Unico"   type="hidden" value="<%=ID_Unico%>" /> 
<script language="JavaScript">
<!--

	$(document).ready(function() {
		
		$(".chHab").click(function(event) {
			var o = $(this)
			CambiaEstatus(o.is(':checked'),o.data("insoid"))
        });	

	});
		
		
function CambiaEstatus(Checado,insoid) {
		
	var ckd = (Checado==true) ? 1 : 0;
	
	$.post( "/pz/wms/Incidencias/Incidencias_Ajax.asp"
		  , { Tarea:1,ID_Unico:$("#ID_Unico").val(),InsO_ID:insoid,Chkdo:ckd}
		  , function () {
			var sMensaje = "El registro fue guardado"
		 	//$.gritter.add({position: 'top-right',title: 'Aviso',text: sMensaje,sticky: true,time: 1200});
			Avisa("success","Aviso",sMensaje)
		  }
	);
				
}
	
//-->
</script>