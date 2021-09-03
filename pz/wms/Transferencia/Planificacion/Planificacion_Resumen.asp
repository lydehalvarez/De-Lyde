<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../../Includes/iqon.asp" -->
<%
	var TA_ArchivoID = Parametro("TA_ArchivoID",-1);
	
	var Resumen = "SELECT COUNT(*) Cantidad, TA_Orden "
		Resumen += " FROM TransferenciaAlmacen "
		Resumen += " WHERE TA_ArchivoID =  "+TA_ArchivoID
		Resumen += " GROUP BY TA_Orden "
		Resumen += " ORDER BY TA_Orden "
	 var rsResum = AbreTabla(Resumen,1,0)
%>
<table class="table">
    <thead>
        <tr>
            <th width="20%">Prioridad</th>
            <th width="80%">Ordenes por prioridad</th>
        </tr>
    </thead>
    <tbody>
        <%
		var total = 0
            while (!rsResum.EOF){
                var Cantidad = rsResum.Fields.Item("Cantidad").Value 
                var TA_Orden = rsResum.Fields.Item("TA_Orden").Value 
				total = total +Cantidad
        %>
        <tr>
            <td><%=TA_Orden%></td>
            <td><%=Cantidad%></td>
        </tr>
        <%
            Response.Flush()
            rsResum.MoveNext() 
        }
        rsResum.Close()
        %>
        <tr>
            <td>Total</td>
            <td><%=total%></td>
        </tr>
    </tbody>
</table>


