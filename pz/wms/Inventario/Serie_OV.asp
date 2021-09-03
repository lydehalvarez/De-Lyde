<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->


<%   

	var Inv_ID = Parametro("Inv_ID",-1)

    var sSQL = "SELECT * "
         + " ,dbo.fn_CatGral_DameDato(51,OV_EstatusCG51) as ESTATUS "
         + " ,(CONVERT(NVARCHAR(20),OV_FechaRegistro,103)) as FECHAREGISTRO "
         + " FROM Orden_Venta_Picking p , Orden_Venta v "
         + " WHERE p.OV_ID = v.OV_ID "
         + " AND Inv_ID = "+Inv_ID
         + " Order by v.OV_ID "


        var rsOV = AbreTabla(sSQL,1,0)
		if(!rsOV.EOF){
			while (!rsOV.EOF){

%>         
<div class="row">
    <h3 class="faq-question">Orden de Venta</h3>
    <div class="project-list">
      <table class="table table-hover">
         <tbody>
        <tr>
            <th>Folio</th>
            <th>Folio Cliente</th>
            <th>Fecha</th>
            <th>Estatus</th>
        </tr>
        <tr>
            <td class="project-title textCopy">
            <%=rsOV.Fields.Item("OV_Folio").Value%>
        </td>
        <td class="project-title">
            <%=rsOV.Fields.Item("OV_CUSTOMER_SO").Value%>
        </td>
        <td class="project-title">
             <%=rsOV.Fields.Item("FECHAREGISTRO").Value%>
        </td>
        <td class="project-title">
            <%=rsOV.Fields.Item("ESTATUS").Value%>
        </td>
        <td class="project-actions" width="31">
            <a class="btn btn-white btn-sm" href="#" onclick="javascript:CargarOV(<%=rsOV.Fields.Item("OV_ID").Value%>);  return false"><i class="fa fa-folder"></i> Ver</a>
        </td>
      </tr>
        <%
            rsOV.MoveNext() 
            }
        rsOV.Close()   
%>
       </tbody></table>
       </div>
    </div>   
<%   

		}else{%>
        <div class="row">
            <h3 class="faq-question">Orden de Venta</h3>
            <h4>Serie no encontrada en alguna SO</h4>
        </div>
		<%}
%>
