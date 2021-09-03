<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%

var sSQL = " select Cat_ID, Cat_Nombre, Cat_Descripcion "
	sSQL += " from Cat_Catalogo "
	sSQL += " where Sec_ID = " + Sec_ID
	
	var rsRv = AbreTabla(sSQL,1,0)
		if (!rsRv.EOF){
			Cat_ID = rsRv.Fields.Item("Cat_ID").Value
			Cat_Nombre = rsRv.Fields.Item("Cat_Nombre").Value
			Cat_Descripcion = rsRv.Fields.Item("Cat_Descripcion").Value

		}
		rsRv.Close()
	
	
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
            <td width="23%" class="TablaEncabezado">Nombre</td>
            <td width="36%" class="TablaEncabezado">Descripci&oacute;n</td>
          </tr>
<%
        var TipoRenglon = "evenRow"
	  var sSQL = "SELECT 0 as Habilitado "
		    sSQL += " ,(ISNULL((select 'checked' from Incidencia_Usuario u, Cat_Catalogo c "
			sSQL += " where c.ID_Usuario = " + ID_Unico	+"  and c.Cat_ID = u.InU_OriginadoCG251 " 	
			sSQL +=  " and c.InU_OriginadoCG251 = "+ InU_OriginadoCG251 +" ),'')) as Habilitado	"
			sSQL += "FROM Incidencias_Usuario"
//Response.write(sSQL)
			var rsCTe = AbreTabla(sSQL,1,0)
				while (!rsCTe.EOF){

					
					
%>
          <tr >
            <td align="center">
            <input type="checkbox" id="chkSelecc" class="chHab" 
              data-catid="<%=rsCTe.Fields.Item("Cat_ID").Value%>"
            <%=rsCTe.Fields.Item("Habilitado").Value%> >
            </td>
            <td><% Response.Write(rsCTe.Fields.Item("Cat_Nombre").Value) %></td>
            <td><% Response.Write(rsCTe.Fields.Item("Cat_Descripcion").Value) %></td>
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

<script language="JavaScript">
<!--

	$(document).ready(function() {
		
		$(".chHab").click(function(event) {
			var o = $(this)
			CambiaEstatus(o.is(':checked'),o.data("catid"),1)
        });	
		
		});
		
		
function CambiaEstatus(Checado,catid,tp) {
		
	var ckd = (Checado==true) ? 1 : 0;
	
	$.post( "/pz/wms/Usuarios/Usuarios_Ajax.asp"
		  , { Tarea:tp,IDUsuario:$("#IDUsuario").val()
			 ,Cat_ID:catid,Chkdo:ckd}
		  , function () {
			var sMensaje = "El registro fue guardado"
		 	//$.gritter.add({position: 'top-right',title: 'Aviso',text: sMensaje,sticky: true,time: 1200});
			Avisa("success","Aviso",sMensaje)
		  }
	);
				
}
	
//-->
</script>