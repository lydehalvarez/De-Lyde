<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%

	var TA_ID = Parametro("TA_ID",-1)
	var chkSeries = Parametro("chkSeries",-1)

	var sSQLSeries = " SELECT * "
        sSQLSeries += " ,(select (Alm_Numero + ' ' + Alm_Nombre) from Inventario i, Almacen a where a.Alm_ID = i.Alm_ID and i.Inv_ID = p.Inv_ID) as Almacen  "
		sSQLSeries += " ,(SELECT dbo.fn_CatGral_DameDato(20,Inv_EstatusCG20) FROM Inventario i WHERE i.Inv_ID = p.Inv_ID) as ESTATUS  "
		sSQLSeries += " ,(SELECT Pro_Nombre FROM Producto WHERE Pro_ID = p.Pro_ID) Producto "
		sSQLSeries += " FROM TransferenciaAlmacen_Articulo_Picking p "
		sSQLSeries += " WHERE TA_ID = "+TA_ID
		sSQLSeries += " AND TAA_ID IN ("+chkSeries+") "		
        sSQLSeries += " ORDER BY TAA_ID, TAS_ID "
		
%>
<div class="animated fadeInRight"> 
    <div class="ibox-content">
        <table class="table table-striped">
            <tbody> 
                <%
                var rsSeries = AbreTabla(sSQLSeries,1,0)
                    while(!rsSeries.EOF){ 
                %>		
                    <tr>
                        <td><%=rsSeries.Fields.Item("Producto").Value%><br>
                         <span class="label label-primary"><%=rsSeries.Fields.Item("ESTATUS").Value %></span> <%=rsSeries.Fields.Item("TAS_Serie").Value%><br>
                         La ubicaci&oacute;n actual de esta serie es:<br>
                         <%=rsSeries.Fields.Item("Almacen").Value%><br>   
                         El hist&oacute;rico de movimiento de esta serie es:<br> 
<%      
     var sSQLh = "  select TA_Folio, Inv_ID, CONVERT(NVARCHAR(12),TAS_FechaRegistro,103) as FechaRegistro "
               + " , dbo.fn_CatGral_DameDato(51,TA_EstatusCG51) as estatus "
               + " from TransferenciaAlmacen_Articulo_Picking p, TransferenciaAlmacen t "
               + " where t.TA_ID = p.TA_ID "
               + " and Inv_ID = " + rsSeries.Fields.Item("Inv_ID").Value
               + " order by TAS_FechaRegistro  "
    
     var rsHser = AbreTabla(sSQLh,1,0)
     while(!rsHser.EOF){ 
           Response.Write("<i class='fa fa-truck'> </i> " + rsHser.Fields.Item("TA_Folio").Value 
                       + " <i class='fa fa-clock-o'> </i> " + rsHser.Fields.Item("FechaRegistro").Value 
                       + " <i class='fa fa-list-alt'> </i> " + rsHser.Fields.Item("estatus").Value + "<br>")
        rsHser.MoveNext() 
        }
    rsHser.Close()  
                             
%>                             
                       </td>
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

