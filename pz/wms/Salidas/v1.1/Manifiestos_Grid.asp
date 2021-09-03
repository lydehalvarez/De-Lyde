<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
 
    var sSQL  = " SELECT * "
		sSQL += " FROM Orden_Venta v, cliente c,"
        sSQL += " WHERE t.Cli_ID = c.Cli_ID "   
        sSQL += " AND OV_EstatusCG51 = 4 "   
		sSQL += " ORDER BY OV_ID desc"
    
%>
<div class="ibox-title">
    <h3>Ordenes de venta</h3>
</div>    
<div class="project-list">
  <table class="table table-hover">
    <tbody>
        <%
        var rsOV = AbreTabla(sSQL,1,0)
        while (!rsOV.EOF){
	     %>    
      <tr>
         <td class="project-title">
       <%=rsOV.Fields.Item("Cli_Nombre").Value%>
            <br/>
            <small>Transportista: 
			<%
			if(rsOV.Fields.Item("OV_TRACKING_COM").Value)==""){
			%><%=rsOV.Fields.Item("OV_TRACKING_COM2").Value%></small>
			<%
			}
			if(rsOV.Fields.Item("OV_TRACKING_COM2").Value==""){
			%><%=rsOV.Fields.Item("OV_TRACKING_COM").Value%></small>
			<%
			}
		%>
        </td>
        <td class="project-title">
            <a href="#"><%=rsOV.Fields.Item("OV_Folio").Value%></a>
            <br/>
            <small>Registro: <%=rsOV.Fields.Item("OV_FechaRegistro").Value%></small>
        </td>
        <td class="project-title">
            <a href="#"><%=rsOV.Fields.Item("OV_CUSTOMER_SO").Value%></a>
            <br/>
            <small> Elaboracion: <%=rsOV.Fields.Item("OV_FechaElaboracion").Value%></small>
        </td>
        <td class="project-title">
            <a href="#"><%=rsOV.Fields.Item("OV_Estado").Value%></a>
            <br/>
            <small> <%=rsOV.Fields.Item("OV_Ciudad").Value%></small>
        </td>

        <td class="project-actions" width="31">
             <input type="checkbox"value="" class="i-checks ChkRel" onclick="javascript:CargaSerie(<%=rsOV.Fields.Item("OV_ID").Value%>)"> </input> 
        </td>
      </tr>
        <%
            rsOV.MoveNext() 
            }
        rsOV.Close()   
        %>       
    </tbody>
  </table>


</div>
<script type="text/javascript">

$(document).ready(function(){    
		
});
    

</script>    
    