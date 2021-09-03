 <%@LANGUAGE="JAVASCRIPT"  CODEPAGE="949"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
	var Ins_ID = Parametro("Ins_ID",-1)
	var Reporta = Parametro("Reporta",-1)
	var Recibe = Parametro("Recibe",-1)

var sSQL = "SELECT *, p.Prov_Nombre,   dbo.fn_Usuario_DameCorreo( Ins_Usu_Reporta ) as REPORTA "
              	+  " , CONVERT(VARCHAR(17), Ins_FechaShipping, 113) AS Ins_FechaShipping,"
   				+ "  dbo.fn_Usuario_DameCorreo( Ins_Usu_Recibe ) as RECIBE "
		        + " ,  dbo.fn_CatGral_DameDato(35,Ins_CierreCG35) Cat_Nombre"
				+	" , Ins_DescripcionCierre"
				+  " FROM Incidencia i INNER JOIN Proveedor p ON p.Prov_ID = i.Prov_ID  WHERE Ins_ID = " + Ins_ID 
				
				    var rsIncidencias = AbreTabla(sSQL,1,0)
					
					var InsT_ID = rsIncidencias.Fields.Item("InsT_ID").Value
					var TA_ID = rsIncidencias.Fields.Item("TA_ID").Value
					var Titulo = rsIncidencias.Fields.Item("Ins_Titulo").Value
					var Asunto = rsIncidencias.Fields.Item("Ins_Asunto").Value
					var Emisor = rsIncidencias.Fields.Item("REPORTA").Value
					var Fecha = rsIncidencias.Fields.Item("Ins_FechaRegistro").Value
					var Descripcion = rsIncidencias.Fields.Item("Ins_Descripcion").Value
					var F_Shipping = rsIncidencias.Fields.Item("Ins_FechaShipping").Value
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
				<p><dt>Fecha Shipping:</dt>
                <%=F_Shipping%></p>
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
  var sSQL  = " SELECT *,  dbo.fn_CatGral_DameDato(51,TA_EstatusCG51) Cat_Nombre "
        sSQL += " FROM TransferenciaAlmacen t, cliente c, Almacen a "
        sSQL += " WHERE t.Cli_ID=c.Cli_ID AND t.TA_End_Warehouse_ID = a.Alm_ID  "   
		sSQL += " AND t.TA_ID = " + TA_ID
        var rsTransferencia = AbreTabla(sSQL,1,0)
    
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
            <small>Registro: <%=rsTransferencia.Fields.Item("TA_FechaRegistro").Value%></small>
        </td>
        <td class="project-title">
            <a href="#"><%=rsTransferencia.Fields.Item("TA_FolioCliente").Value%></a>
            <br/>
            <small> Elaboracion: <%=rsTransferencia.Fields.Item("TA_FechaElaboracion").Value%></small>
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



