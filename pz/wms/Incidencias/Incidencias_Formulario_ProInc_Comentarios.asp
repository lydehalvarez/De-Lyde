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
					var Titulo = rsIncidencias.Fields.Item("Ins_Titulo").Value
					var Asunto = rsIncidencias.Fields.Item("Ins_Asunto").Value
					var Emisor = rsIncidencias.Fields.Item("REPORTA").Value
					var Fecha = rsIncidencias.Fields.Item("Ins_FechaRegistro").Value
					var Descripcion = rsIncidencias.Fields.Item("Ins_Descripcion").Value
					var Problema = rsIncidencias.Fields.Item("Ins_Problema").Value
					var Causa = rsIncidencias.Fields.Item("Ins_Causa").Value

	
%>
<div class="row">
        <div class="col-lg-12">
            <!--Datos de la Orden de compra-->
             <p><dt>Asunto:</dt>
                <%=Asunto%></p>
                <p><dt title=''>Descripci&oacute;n:</dt>
             <%=Descripcion%></p>
             <p><dt title=''>Causa:</dt>
                <%=Causa%></p>
                
        </div>
        
    </div>
 
   

