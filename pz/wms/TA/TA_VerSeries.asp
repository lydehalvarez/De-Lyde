<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%

	var TA_ID = Parametro("TA_ID",-1)
	var chkSeries = Parametro("chkSeries",-1)

	var sSQLSeries = " SELECT * "
		sSQLSeries += " ,(SELECT TA_Folio FROM [dbo].[TransferenciaAlmacen] WHERE TA_ID = p.TA_ID) Folio "
		sSQLSeries += " ,(SELECT Pro_Nombre FROM Producto WHERE Pro_ID = p.Pro_ID) Producto "
		sSQLSeries += " FROM TransferenciaAlmacen_Articulo_Picking p "
		sSQLSeries += " WHERE TA_ID = "+TA_ID
		sSQLSeries += " AND TAA_ID IN ("+chkSeries+") "		
		
%>
<div class="animated fadeInRight">
    <div class="ibox-content">
        <table class="table table-striped">
            <thead>
                <th>Partida</th>
                <th>Producto</th>
                <th>Serie</th>
            </thead>
            <tbody> 
                <%
                    var rsSeries = AbreTabla(sSQLSeries,1,0)
                    while(!rsSeries.EOF){ 
                     var TAS_ID = rsSeries.Fields.Item("TAS_ID").Value 
                     var Producto = rsSeries.Fields.Item("Producto").Value 
                     var TAS_Serie = rsSeries.Fields.Item("TAS_Serie").Value 
                %>		
                    <tr>
                        <td><%=TAS_ID%></td>
                        <td><%=Producto%></td>
                        <td><%=TAS_Serie%></td>
                    </tr>
                <%	
                    rsSeries.MoveNext() 
                }
                rsSeries.Close()   
                %>
            </tbody>
        </table>
    </div>
</div>

