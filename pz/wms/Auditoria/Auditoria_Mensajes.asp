<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
    var Aud_ID = Parametro("Aud_ID",-1)
   
%>                                                   
<div class="feed-activity-list">
    <%
                                  
        var sSQL = "SELECT AudU_AsignadoA, dbo.fn_Usuario_DameUsuario(AudU_AsignadoA) as asignado, AudU_Comentario, AudU_FechaRegistro, Ubi_Nombre "
                 + " FROM Auditorias_Ubicacion au, Ubicacion u "
                 + " WHERE au.Aud_ID = " + Aud_ID
                 + " AND u.Ubi_ID = au.AudU_ID "
                 + " AND au.AudU_Comentario <> '' "
                                     
   
        var Auditor = ""
        var Imagen = ""
        var letra = ""
        var rs = AbreTabla(sSQL,1,0)                             
        var count = 0
        if(!rs.EOF) { 
           while (!rs.EOF){
                   
               Auditor = FiltraVacios(rs.Fields.Item("asignado").Value)
               if (Auditor ==""){
                   letra = "A"
               } else {
                   letra = Auditor.substring(0,1)
               }
               
               Imagen = ""
%>
		<div class="feed-element">
			<a href="#" class="pull-left">
				<%
					if(Imagen == "") {
				%>
					<span><span class="fa fa-user-circle"></span><%=letra %></span>
				<%
					} else {
				%>
					<img class="img-circle" src="<%=Imagen %>">
				<%
					}
				%>
			</a>
			<div class="media-body "> 
				<strong><%=Auditor %></strong> en la ubicaci&oacute;n <strong><%=rs.Fields.Item("Ubi_Nombre").Value %></strong>   <br>
				<small class="text-muted"><%=rs.Fields.Item("AudU_FechaRegistro").Value %></small>
				<div class="well">
					<%=rs.Fields.Item("AudU_Comentario").Value %>
				</div>
			</div>
		</div>
<% 
            rs.MoveNext()
            } 
        } else {  %>
            No hay mensajes
		<% }
        rs.Close()           
           
	 %>
</div>
