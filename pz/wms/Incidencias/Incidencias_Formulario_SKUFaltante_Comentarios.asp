 <%@LANGUAGE="JAVASCRIPT"  CODEPAGE="949"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
	var Ins_ID = Parametro("Ins_ID",-1)
	var IDUsuario = Parametro("IDUsuario",-1)
	var Reporta = Parametro("Reporta",-1)
	var Recibe = Parametro("Recibe",-1)

var sSQL = "SELECT i.*,  dbo.fn_Usuario_DameCorreo( Ins_Usu_Reporta ) as REPORTA "
   				+ " , dbo.fn_Usuario_DameCorreo( Ins_Usu_Recibe ) as RECIBE "
				+ " ,  dbo.fn_CatGral_DameDato(35,Ins_CierreCG35) Cat_Nombre"
				+	" , Ins_DescripcionCierre"
				+ "  FROM Incidencia i  WHERE Ins_ID = " + Ins_ID 
				
				    var rsIncidencias = AbreTabla(sSQL,1,0)
					
					var InsT_ID = rsIncidencias.Fields.Item("InsT_ID").Value
					var TA_ID = rsIncidencias.Fields.Item("TA_ID").Value
					var Titulo = rsIncidencias.Fields.Item("Ins_Titulo").Value
					var Asunto = rsIncidencias.Fields.Item("Ins_Asunto").Value
					var Emisor = rsIncidencias.Fields.Item("REPORTA").Value
					var Fecha = rsIncidencias.Fields.Item("Ins_FechaRegistro").Value
					var Descripcion = rsIncidencias.Fields.Item("Ins_Descripcion").Value
					var Ins_Cierre =  rsIncidencias.Fields.Item("Cat_Nombre").Value
					var Ins_DescripcionCierre =  rsIncidencias.Fields.Item("Ins_DescripcionCierre").Value
	
%>
<div class="row">
        <div class="col-lg-12">
            <!--Datos de la Orden de compra-->
          <p><dt title=''>T&iacute;tulo:</dt>
                <%=Titulo%></p>
                <p><dt>Asunto:</dt>
                <%=Asunto%></p>
              <p>  <dt title=''>Descripci&oacute;n:</dt>
             	<%=Descripcion%></p>
			  <p>  <dt title=''>Conclusi&oacute;n:</dt>
             	<%=Ins_Cierre%></p>
<%
         		if(Ins_Cierre=="NE Tienda"){
%>
				<p><dt>Nota de entrada:</dt>
                <%=Ins_DescripcionCierre%></p>
<%
				}

				else if(Ins_Cierre=="NE Almacén"){
					sSQL = "SELECT TAF_FolioEntrada FROM TransferenciaAlmacen_FolioEKT WHERE TA_ID="+TA_ID
					var	rsNE = AbreTabla(sSQL,1,0) 
%>
				  <p><dt>Nota de entrada:</dt>
                 <%=rsNE.Fields.Item("TAF_FolioEntrada").value%></p>
<%
				}else{
%>
				<p><dt>Obsevaciones:</dt>
                <%=Ins_DescripcionCierre%></p>
<%
				}
%>
			
         
        </div>
        
    </div>
    
     <table class="table table-hover">
  	  <tbody>
        <%
   var sSQL  = " SELECT *,  dbo.fn_CatGral_DameDato(51,TA_EstatusCG51) Cat_Nombre, e.TA_FolioRemision "
       sSQL += " FROM  TransferenciaAlmacen t inner join cliente c on t.Cli_ID=c.Cli_ID"
				+" inner join Almacen a  on  t.TA_End_Warehouse_ID = a.Alm_ID  left join TransferenciaAlmacen_FoliosEKT e ON e.TA_ID=t.TA_ID "
        sSQL += " WHERE t.TA_ID = " + TA_ID
        var rsTransferencia = AbreTabla(sSQL,1,0)
    //Response.Write(sSQL)
        %>    
      <tr>
         <td class="project-title">
            <a href="#"><%=rsTransferencia.Fields.Item("Cli_Nombre").Value%></a>
            <br/>
            <small>Transportista: <%=rsTransferencia.Fields.Item("TA_Transportista").Value%></small>
        </td>
        <td class="project-title">
            <a href="#"><%=rsTransferencia.Fields.Item("TA_Folio").Value%></a>
            <br/>
            <small>Entrega: <%=rsTransferencia.Fields.Item("TA_FechaEntrega").Value%></small>
        </td>
        <td class="project-title">
            <a href="#"><%=rsTransferencia.Fields.Item("TA_FolioRemision").Value%></a>
            <br/>
            <small> Elaboracion: <%=rsTransferencia.Fields.Item("TA_FechaElaboracion").Value%></small>
        </td>
		<td class="project-title">
            <a href="#"><%=rsTransferencia.Fields.Item("Alm_Numero").Value%></a>
            <br/>
            <small> Tienda: <%=rsTransferencia.Fields.Item("Alm_Nombre").Value%></small>
        </td>
        <td class="project-title">
            <a href="#"><%=rsTransferencia.Fields.Item("Alm_Estado").Value%></a>
            <br/>
            <small> <%=rsTransferencia.Fields.Item("Alm_Ciudad").Value%></small>
        </td>
                <td class="project-title">
            <a href="#">Estatus</a>
            <br/>
            <small> <%=rsTransferencia.Fields.Item("Cat_Nombre").Value%></small>
        </td>
        </tr>
  </tbody>
  </table>
<%
		
			sSQL = "SELECT p.Pro_SKU AS SKU,  i.TA_ID, i.Pro_ID, i.Inv_ID, p.Pro_Nombre AS Producto, iv.Inv_Serie as Serie1 FROM Incidencia_SKU i"
					  + " LEFT JOIN Producto p ON p.Pro_ID=i.Pro_ID"
					  + " LEFT JOIN Inventario iv ON iv.Inv_ID=i.Inv_ID"
					  + " WHERE  i.Ins_ID="+Ins_ID
					  + " GROUP BY p.Pro_SKU, p.Pro_Nombre,  iv.Inv_Serie,  i.TA_ID, i.Pro_ID,  i.Inv_ID "
		        var rsTransferencia = AbreTabla(sSQL,1,0)
		if (!rsTransferencia.EOF){
%>
<table class="table table-hover">
  	  <tbody>
	<th>  <small> SKU faltante </small></th>
	<th>  <small> Modelo faltante </small></th>
	<th>   <small> Serie faltante </small></th>
	<%
        while( !(rsTransferencia.EOF)){
	//		sSQL = "SELECT COUNT(*) AS articulos from TransferenciaAlmacen_Articulo_Picking"
//					+ " where TA_ID ="+TA_ID+" AND Pro_ID="+rsTransferencia.Fields.Item("Pro_ID").Value
//			 var rsSKU = AbreTabla(sSQL,1,0)

	%>
	   <tr>
         <td class="project-title">
            <small>   <%=rsTransferencia.Fields.Item("SKU").Value%> </small> 
        </td>
        <td class="project-title">
             <small>  <%=rsTransferencia.Fields.Item("Producto").Value%>  </small> 
        </td>
		<td class="project-title">
             <small>  <%=rsTransferencia.Fields.Item("Serie1").Value%>  </small> 
        </td>
			
	<!--	<td class="project-title">
        </td>-->
			</tr>
			  <%
					rsTransferencia.MoveNext()
					}
					rsTransferencia.Close()

			%>
  </tbody>
  </table>

<%
		}
%>

