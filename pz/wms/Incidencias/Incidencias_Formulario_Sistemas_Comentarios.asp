 <%@LANGUAGE="JAVASCRIPT"  CODEPAGE="949"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
	var Ins_ID = Parametro("Ins_ID",-1)
	var Reporta = Parametro("Reporta",-1)
	var Recibe = Parametro("Recibe",-1)

var sSQL = "SELECT *,   dbo.fn_Usuario_DameCorreo( Ins_Usu_Reporta ) as REPORTA "
                +  " , dbo.fn_Usuario_DameCorreo( Ins_Usu_Recibe ) as RECIBE "
				+  " FROM Incidencia WHERE Ins_ID = " + Ins_ID 
				
				    var rsIncidencias = AbreTabla(sSQL,1,0)
					
					var InsT_ID = rsIncidencias.Fields.Item("InsT_ID").Value
					var Ventana = rsIncidencias.Fields.Item("Ins_Ventana").Value
					var Asunto = rsIncidencias.Fields.Item("Ins_Asunto").Value
					var Emisor = rsIncidencias.Fields.Item("REPORTA").Value
					var Fecha = rsIncidencias.Fields.Item("Ins_FechaRegistro").Value
					var Descripcion = rsIncidencias.Fields.Item("Ins_Descripcion").Value
					var Accion = rsIncidencias.Fields.Item("Ins_Accion").Value
					var MsjError = rsIncidencias.Fields.Item("Ins_MensajeError").Value

	
%>
<div class="row">
        <div class="col-lg-12">
            <!--Datos de la Orden de compra-->
             <p><dt>Asunto:</dt>
                <%=Asunto%></p>
                <p><dt title=''>Descripci&oacute;n:</dt>
             <%=Descripcion%></p>
             <p><dt title=''>Ventana:</dt>
                <%=Ventana%></p>
             <p><dt title=''>Accion realizada:</dt>
                <%=Accion%></p>
             <p><dt title=''>Mensaje de error:</dt>
                <%=MsjError%></p>
                
        </div>
        
    </div>
 
   

