 <%@LANGUAGE="JAVASCRIPT"  CODEPAGE="949"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
	var Ins_ID = Parametro("Ins_ID",-1)
	var Reporta = Parametro("Reporta",-1)
	var Recibe = Parametro("Recibe",-1)

var sSQL = "SELECT *,  dbo.fn_Usuario_DameCorreo( Ins_Usu_Reporta ) as REPORTA "
              	+  " ,CONVERT(VARCHAR(17), i.Ins_FechaAvisoCosto, 103) AS  Ins_FechaAvisoCosto,"
   				+ "  dbo.fn_Usuario_DameCorreo( Ins_Usu_Recibe ) as RECIBE "
				+  " FROM Incidencia i  WHERE Ins_ID = " + Ins_ID 
				
				    var rsIncidencias = AbreTabla(sSQL,1,0)
					
					var InsT_ID = rsIncidencias.Fields.Item("InsT_ID").Value
					var TA_ID = rsIncidencias.Fields.Item("TA_ID").Value
					var Titulo = rsIncidencias.Fields.Item("Ins_Titulo").Value
					var Asunto = rsIncidencias.Fields.Item("Ins_Asunto").Value
					var Emisor = rsIncidencias.Fields.Item("REPORTA").Value
					var Fecha = rsIncidencias.Fields.Item("Ins_FechaRegistro").Value
					var Descripcion = rsIncidencias.Fields.Item("Ins_Descripcion").Value
					var FechaAviso = rsIncidencias.Fields.Item("Ins_FechaAvisoCosto").Value
        
  var sSQL  = " SELECT *,  dbo.fn_CatGral_DameDato(51,t.TA_EstatusCG51) Cat_Nombre,"
  				   + " e.TA_FolioRemision"
       sSQL += " FROM TransferenciaAlmacen t, cliente c, TransferenciaAlmacen_FoliosEKT e, Almacen a "
       sSQL += " WHERE t.Cli_ID=c.Cli_ID AND t.TA_End_Warehouse_ID = a.Alm_ID  AND e.TA_ID=t.TA_ID"   
 	   sSQL += " AND t.TA_ID = " + TA_ID
        var rsTransferencia = AbreTabla(sSQL,1,0)

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
				<p><dt>Fecha Aviso:</dt>
                <%=FechaAviso%></p>
       
         
        </div>
        
    </div>
    
     <table class="table table-hover">
  	  <tbody>

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