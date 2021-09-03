<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<!--#include file="./Auditoria_Mensajes-js.asp" -->
<div class="feed-activity-list">
    <%
        var model = getInformation();
		var len = model.length;
		if(len > 0){
			for(var count = 0; count < len; count++) {
				var message = model[count];
		%>
		<div class="feed-element">
			<a href="#" class="pull-left">
				<%
					if(message.Auditor.Image != undefined) {
				%>
					<img class="img-circle" src="<%=message.Auditor.Image%>">
				<%
					} else {
				%>
					<span><span class="fa fa-user-circle"></span><%=message.Auditor.Name.substring(0,1)%></span>
				<%
					}
				%>
			</a>
			<div class="media-body ">
				<!--small class="pull-right">2h ago</small-->
				<strong><%=message.Auditor.Name%></strong> en la ubicaci&oacute;n <strong><%=message.Ubication%></strong>   <br>
				<small class="text-muted"><%=message.RegisterDate%></small>
				<div class="well">
					<%=message.Comment%>
				</div>
			</div>
		</div>
		<% }
		}else{%>
            No hay mensajes
		<% }
	 %>
</div>
