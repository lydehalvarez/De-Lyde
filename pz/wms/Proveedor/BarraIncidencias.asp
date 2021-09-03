<%@LANGUAGE="JAVASCRIPT"  CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<% 
    var Usuario = Parametro("Usuario", -1)  
	var SegGrupo = Parametro("SegGrupo",-1)


var sSQL = " SELECT TOP(5)  i.Ins_ID, Ins_Asunto, Ins_Descripcion, i.Ins_FechaRegistro, Ins_Usu_Reporta, Ins_Usu_Recibe, CAST(DATEADD(HOUR, t.InsT_SLAAtencion +"
				+" t.InsT_SLAResolucion, i.Ins_FechaRegistro) AS NVARCHAR(25)) as fecha, "
	   			+"  dbo.fn_CatGral_DameDato(27,Ins_EstatusCG27) AS Estatus from Incidencia i INNER JOIN Incidencia_Tipo t ON i. InsT_ID=t.InsT_ID "
    			+ " LEFT JOIN Incidencia_Involucrados p ON i.Ins_ID=p.Ins_ID"
				+" WHERE (i.Ins_Usu_Recibe ="+Usuario+"  OR i.Ins_Usu_Reporta = " + Usuario
    	        + " OR i.Ins_Usu_Escalado = " + Usuario +" OR p.Ins_GrupoID= "+SegGrupo
		 		+ " OR p.Ins_UsuarioID=" + Usuario+ ")  AND i.Ins_EstatusCG27 <> 4 "
  			    + " GROUP BY i.Ins_ID, Ins_Asunto, Ins_Descripcion, i.Ins_FechaRegistro, Ins_Usu_Reporta, Ins_Usu_Recibe, InsT_SLAAtencion,  InsT_SLAResolucion, Ins_EstatusCG27"
				+ " ORDER BY i.Ins_FechaRegistro "
				rsIncidencias = AbreTabla(sSQL,1,0)
				
%>
                    <a class="dropdown-toggle count-info"  id= "IncidenciasTotales" data-toggle="dropdown" href="#">
                    </a>

<ul class="dropdown-menu dropdown-messages">
<%
  while( !(rsIncidencias.EOF)){
								 Titulo = rsIncidencias.Fields.Item("Ins_Asunto").Value
								 Descripcion = rsIncidencias.Fields.Item("Ins_Descripcion").Value
								 Fecha = rsIncidencias.Fields.Item("Ins_FechaRegistro").Value
								 reporta = rsIncidencias.Fields.Item("Ins_Usu_Reporta").Value
								 recibe = rsIncidencias.Fields.Item("Ins_Usu_Recibe").Value
								 insid = rsIncidencias.Fields.Item("Ins_ID").Value
								var fecha = rsIncidencias.Fields.Item("fecha").Value
								 estatus = rsIncidencias.Fields.Item("Estatus").Value
								 
								 var sSQL = "SELECT  DATEDIFF (Hour, GETDATE(), '"+fecha+"') As Horas "
								 var rsHoras = AbreTabla(sSQL,1,0)

								 var Horas = rsHoras.Fields.Item("Horas").Value
								 sSQL = "SELECT  ISNULL(Usu_RutaImg + Usu_Imagen, '') as foto "
								 		  +"FROM Usuario u INNER JOIN Seguridad_Indice s ON s.Usu_ID=u.Usu_ID "
										  + " WHERE s.IDUnica="+reporta
										
								var rsFoto = AbreTabla(sSQL,1,0)
								var Ruta_Imagen=""
								if(!rsFoto.EOF){
								}else{
									 sSQL = "SELECT  ISNULL(Emp_RutaFoto, '') as foto "
								 		  +"FROM Empleado u INNER JOIN Seguridad_Indice s ON s.Emp_ID=u.Emp_ID "
										  + " WHERE s.IDUnica="+reporta
										
								var rsFoto = AbreTabla(sSQL,1,0)	
								}
								Ruta_Imagen =  rsFoto.Fields.Item("foto").Value

								if(Ruta_Imagen==""){
								var Ruta_Imagen =  "/Media/wms/Perfil/avatar.jpg"
								}
								sSQL="SELECT  dbo.fn_Usuario_DameNombreUsuario( "+reporta+" ) as usuario "
								var rsUsuario = AbreTabla(sSQL,1,0)
								var Usuario =  rsUsuario.Fields.Item("usuario").Value

%>

                        <li>

                                <%
						 	if(Horas < 0){
						 %>
                           <div  class="dropdown-messages-box" style="background-color:red"> 
                    <%
							}else if(Horas < 4 && Horas > 0){
					%>
                           <div  class="dropdown-messages-box" style="background-color:yellow">
					<%
							}else{
                    %>
                            <div class="dropdown-messages-box">
                    <%
							}
                    %>
                                   <a href="#" class="pull-left" >
                                    <img alt="image" class="img-circle" src="<%=Ruta_Imagen%>"></a>
                                <div class="media-body"  onclick="CargaIncidencia(<%=reporta%>,<%=recibe%>,<%=insid%>)">
                                    <small class="pull-right">
                         <%
						 	if(Horas < 0){
							%>
                            <font color="#FFFFFF">
                            <%
								Horas = String(Horas)
								Horas = Horas.replace("-", "")
						 %>
                                Vencio hace <%=Horas%> hrs.
                         <%
							}else{
		    			%>
                        
						<font>	    Restan <%=Horas%> hrs.
					<%
                    }
                    %>
 						        </small>
                                    <strong><%=Usuario%></strong><br><%=Titulo%>. <br>
                                    <strong>Estatus:</strong> <%=estatus%> 
                                    <br>
                                    <small class="text-muted"><%=Fecha%></small></font>
                                </div>
                            </div>
                           
                        </li>
                        <li class="divider"></li>
                        
<%
                            rsIncidencias.MoveNext() 
							}
							rsIncidencias.Close()  
%>
<br />                       
                       <center> <a   class="text-muted btnVerMas"><strong>Ver todas las incidencias </strong></a></center> 

                    </ul>
<script type="application/javascript">

	$(document).ready(function() {
            $("#IncidenciasTotales").load("/pz/wms/Incidencias/BarraLateral_html.asp?Usuario="+$("#IDUsuario").val()+"&Tarea=6&SegGrupo="+$("#SegGrupo").val())        
	
	$('.btnVerMas').click(function(e) {
	var Params = "?Prioridad=1"
	   Params += "&IDUsuario=" + $("#IDUsuario").val()
   	   Params += "&SegGrupo=" + $("#SegGrupo").val()


	$("#Contenido").load("/pz/wms/Incidencias/CTL_Incidencias.asp"+Params)
});

	});
		   function CargaIncidencia(reporta, recibe, insid){
        
            var Params = "?insid=" + insid
                Params += "&reporta=" + reporta
                Params += "&recibe=" + recibe
                Params += "&IDUsuario=" + recibe
               Params += ""//este parametro limpia el cache
               
            
			$("#Contenido").load("/pz/wms/Incidencias/CTL_Incidencias.asp" + Params)        
        
    }

</script>