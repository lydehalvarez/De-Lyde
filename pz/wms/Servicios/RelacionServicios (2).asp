<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%
var SerP_ID = Parametro("SerP_ID",-1)

%>
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="FichaCampoValor">  
  <tr>
    <td colspan="6" class="FichaSubtitulo">Configuraci&oacute;n de servicios del paquete</td>
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
    <td colspan="4">Seleccione los servicios que este paquete incluye</td>
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
            <td width="11%" align="center" class="TablaEncabezado">Habilitado</td>
            <td width="7%" class="TablaEncabezado">Clave</td>
            <td width="34%" class="TablaEncabezado">Nombre</td>
            <td width="48%" class="TablaEncabezado">Descripci&oacute;n</td>
          </tr>
<%

		var sSQL = "SELECT Ser_ID, Ser_Clave, Ser_Nombre, Ser_Descripcion "
		    sSQL += " ,(ISNULL((select 'checked' from ServicioPaquete_Configuracion c "	
			sSQL += " where c.SerP_ID = " + SerP_ID
		    sSQL += " and c.Ser_ID = s.Ser_ID),'')) as EnUso "				
            sSQL += " FROM Servicio s " 
            sSQL += " WHERE Ser_Habilitado = 1 "
            sSQL += " order by Ser_ID " 

			var rsSVC = AbreTabla(sSQL,1,0)
				while (!rsSVC.EOF){
%>
          <tr>
            <td align="center">
            <input type="checkbox" id="chkSelecc" class="chHab" 
              data-serid="<%=rsSVC.Fields.Item('Ser_ID').Value%>"
               <%=rsSVC.Fields.Item("EnUso").Value%> >
            </td>
            <td><% Response.Write(rsSVC.Fields.Item("Ser_Clave").Value) %></td>
            <td><% Response.Write(rsSVC.Fields.Item("Ser_Nombre").Value) %></td>
            <td><% Response.Write(rsSVC.Fields.Item("Ser_Descripcion").Value) %></td>
          </tr>
<%
					rsSVC.MoveNext()
				}
				rsSVC.Close() 
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
			CambiaEstatus(o.is(':checked'),o.data("serid"))
        });	

	});
		
		
function CambiaEstatus(Checado,serid) {
		
	var ckd = (Checado==true) ? 1 : 0;
	
	$.post( "/pz/wms/Servicios/Servicios_Ajax.asp"
		  , { Tarea:1,Ser_ID:serid,SerP_ID:<%=SerP_ID%>,Chkdo:ckd}
		  , function () {
			var sMensaje = "El registro fue guardado"
			Avisa("success","Aviso",sMensaje)
		  }
	);
				
}
	
//-->
</script>