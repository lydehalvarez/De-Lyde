<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%
	var Inv_ID = Parametro("Inv_ID",-1)
    var Reg = 0

	var sSQL = " SELECT ISNULL(TA_Transportista,'') as TA_Transportista, ISNULL(TA_Guia,'') as TA_Guia , TA_Folio, t.TA_ID "
         + " ,(CONVERT(NVARCHAR(20),t.TA_FechaRegistro,103)) as FECHAELABORACION "
         + " ,(CONVERT(NVARCHAR(20),TA_FechaEntrega,103)) as FECHAENTREGA "
         + " ,dbo.fn_CatGral_DameDato(51,TA_EstatusCG51) as ESTATUS "
         + " ,ISNULL(dbo.fn_CatGral_DameDato(94,TA_TipoDeRutaCG94),'') as TIPORUTA "
         + " ,dbo.fn_CatGral_DameDato(65,TA_TipoTransferenciaCG65) as TIPOTRANSF "
         + " ,(SELECT Alm_Nombre FROM Almacen ao WHERE ao.Alm_ID = t.TA_Start_Warehouse_ID) as ORIGEN "
         + " ,(SELECT Alm_Nombre FROM Almacen ad WHERE ad.Alm_ID = t.TA_End_Warehouse_ID) as DESTINO "
         + " ,(SELECT CASE WHEN Cli_ID = 6 THEN CAST(Tda_ID as NVARCHAR(50)) ELSE Alm_Numero END "
         +     " FROM Almacen ao2 WHERE ao2.Alm_ID = t.TA_End_Warehouse_ID ) AS NUMTIENDA "
         + " FROM TransferenciaAlmacen t, TransferenciaAlmacen_Articulo_Picking pk "
         + " WHERE pk.Inv_ID  = "+Inv_ID
         +   " AND pk.TA_ID = t.TA_ID "	
         + " Order by t.TA_ID DESC"	

	var rsTRA = AbreTabla(sSQL,1,0)

	if(!rsTRA.EOF){%>
<div class="row">
    <h3 class="faq-question">Transferencias</h3>
    <div class="project-list">
      <table class="table table-hover">
        <tbody>
            <tr>
            <th>Folio</th>
            <th>Origen</th>
            <th>Destino</th>
            <th>Fecha</th>
            <th>Estatus</th>
        </tr>
		<%while (!rsTRA.EOF){

%>         
      <tr>
        <td class="project-title copyID"  title='<%=rsTRA.Fields.Item("TA_ID").Value %>'>
        <strong class="textCopy"><%=rsTRA.Fields.Item("TA_Folio").Value%></strong>
            <br><small>Tipo Tra: <%=rsTRA.Fields.Item("TIPOTRANSF").Value%></small>
        </td>
        <td class="project-title">
        <%=rsTRA.Fields.Item("ORIGEN").Value%>
        </td>
        <td class="project-title">
         <%=rsTRA.Fields.Item("DESTINO").Value%>
        </td>
        <td class="project-title">
            <strong>Fecha creaci&oacute;n:</strong>&nbsp;<%=rsTRA.Fields.Item("FECHAELABORACION").Value%>
            <br>
            <strong>Fecha Entrega:</strong>&nbsp;<%=rsTRA.Fields.Item("FECHAENTREGA").Value%>
        </td>
        <td class="project-title" title="Transportista: <%=rsTRA.Fields.Item("TA_Transportista").Value%> Guia: <%=rsTRA.Fields.Item("TA_Guia").Value%>">
         <%=rsTRA.Fields.Item("ESTATUS").Value%>
        </td>
        <td class="project-actions" width="31">
          <a class="btn btn-white btn-sm" href="#" onclick="javascript:CargarTRA(<%=rsTRA.Fields.Item("TA_ID").Value%>);  return false"><i class="fa fa-folder"></i> Ver</a>
        </td>
      </tr>
	<%
        rsTRA.MoveNext() 
        }
    rsTRA.Close()
	%>
   </tbody></table>
   </div>
</div>  
	<%}else{%>
        <div class="row">
            <h3 class="faq-question">Transferencias</h3>
            <h4>Serie no encontrada en algun TRA</h4>
        </div>
		<%}
%>
