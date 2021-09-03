 <%@LANGUAGE="JAVASCRIPT"  CODEPAGE="949"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
	var Ins_ID = Parametro("Ins_ID",-1)
	var Reporta = Parametro("Reporta",-1)
	var Recibe = Parametro("Recibe",-1)

var sSQL = "SELECT *,   dbo.fn_Usuario_DameCorreo( Ins_Usu_Reporta ) as REPORTA "
                +  " , dbo.fn_Usuario_DameCorreo( Ins_Usu_Recibe ) as RECIBE "
				+  " FROM Incidencia WHERE Ins_ID = " + Ins_ID 
				
				    var rsIncidencias = AbreTabla(sSQL,1,0)
					
					var InsT_ID = rsIncidencias.Fields.Item("InsT_ID").Value
					var OV_ID = rsIncidencias.Fields.Item("OV_ID").Value
					var Titulo = rsIncidencias.Fields.Item("Ins_Titulo").Value
					var Asunto = rsIncidencias.Fields.Item("Ins_Asunto").Value
					var Emisor = rsIncidencias.Fields.Item("REPORTA").Value
					var Fecha = rsIncidencias.Fields.Item("Ins_FechaRegistro").Value
					var Descripcion = rsIncidencias.Fields.Item("Ins_Descripcion").Value
					var Problema = rsIncidencias.Fields.Item("Ins_Problema").Value
					var Causa = rsIncidencias.Fields.Item("Ins_Causa").Value

		sSQL = "SELECT InsT_Problema_For_ID FROM Incidencia_Tipo WHERE InsT_ID = " + InsT_ID
		var rsInsNombre = AbreTabla(sSQL,1,0)

		var For_ID=rsInsNombre("InsT_Problema_For_ID").Value
		
%>
<div class="row">
        <div class="col-lg-12">
            <!--Datos de la Orden de compra-->
          <p><dt title=''>T&iacute;tulo:</dt>
                <%=Titulo%></p>
                <p><dt  title=''>Asunto:</dt>
                <%=Asunto%></p>
               <p> <dt title=''>Descripci&oacute;n:</dt>
              <%=Descripcion%></p>
           
        </div>
        
    </div>

 <table class="table table-hover">
    <tbody>
        <%
	    var sSQL  = " SELECT *,  dbo.fn_CatGral_DameDato(51,OV_EstatusCG51) Cat_Nombre  "
		sSQL += " FROM Orden_Venta v, cliente c"
        sSQL += " WHERE v.Cli_ID=c.Cli_ID "   
		sSQL += " AND v.OV_ID =" + OV_ID
			

        var rsOV = AbreTabla(sSQL,1,0)
	     %>    
      <tr>
         <td class="project-title">
       <%=rsOV.Fields.Item("Cli_Nombre").Value%>
            <br/>
            <small>Transportista: 
			<%=rsOV.Fields.Item("OV_TRACKING_COM").Value%></small>
		
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
        <td class="project-title">
            <a href="#">Estatus</a>
            <br/>
            <small> <%=rsOV.Fields.Item("Cat_Nombre").Value%></small>
        </td>
      </tr>
     </tbody>
  </table>
