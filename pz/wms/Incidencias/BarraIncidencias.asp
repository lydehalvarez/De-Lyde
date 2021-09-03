<%@LANGUAGE="JAVASCRIPT"  CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<% 
    var Usuario =  IDUsuario// Parametro("IDUsuario", -1)  
	                                                 //var SegGrupo = Parametro("SegGrupo",-1)
	var Prov_ID = Parametro("Prov_ID",-1)
         
	sSQL1 = "SELECT IncG_ID FROM Incidencia_Grupo_Usuario WHERE Usu_ID="+Usuario+" OR Emp_ID="+Usuario
					var rsGruID = AbreTabla(sSQL1,1,0)

if(Prov_ID==-1){
var sSQL = " SELECT TOP(5)  i.Ins_ID, Ins_Asunto, Ins_Descripcion, i.Ins_FechaRegistro, Ins_Usu_Reporta, Ins_Usu_Recibe, Ins_PuedeVer_ProveedorID,"
				+ " CAST(DATEADD(HOUR, t.InsT_SLAAtencion + t.InsT_SLAResolucion, i.Ins_FechaRegistro) AS NVARCHAR(25)) as fecha, "
	   			+"  dbo.fn_CatGral_DameDato(27,Ins_EstatusCG27) AS Estatus, Ins_EstatusCG27 from Incidencia i" 
				+ " INNER JOIN Incidencia_Tipo t ON i. InsT_ID=t.InsT_ID "
    			+ " LEFT JOIN Incidencia_Involucrados p ON i.Ins_ID=p.Ins_ID"
				+" WHERE ((i.Ins_Usu_Recibe ="+Usuario+"  OR i.Ins_Usu_Reporta = " + Usuario
    	        + " OR i.Ins_Usu_Escalado = " + Usuario 
				if(!rsGruID.EOF){
					sSQL +=    " OR p.Ins_GrupoID = " + rsGruID.Fields.Item("IncG_ID").Value
				}
				sSQL += " OR p.Ins_UsuarioID=" + Usuario+ ") ) AND i.Ins_EstatusCG27 <> 4 "
				+ " AND i.Ins_FechaRegistro >= DATEADD(day,-100,getdate()) and i.Ins_FechaRegistro <= getdate() "
  		//	    + " GROUP BY i.Ins_ID, Ins_Asunto, Ins_Descripcion, i.Ins_FechaRegistro, Ins_Usu_Reporta, Ins_Usu_Recibe, InsT_SLAAtencion,  "
//				+ " InsT_SLAResolucion, Ins_EstatusCG27, Ins_PuedeVer_ProveedorID, Ins_EstatusCG27"
				+ " ORDER BY i.Ins_FechaRegistro DESC"
}else{
	var sSQL = " SELECT TOP(5)  i.Ins_ID, Ins_Asunto, Ins_Descripcion, i.Ins_FechaRegistro, Ins_Usu_Reporta, Ins_Usu_Recibe, Ins_PuedeVer_ProveedorID,"
				+ " CAST(DATEADD(HOUR, t.InsT_SLAAtencion + t.InsT_SLAResolucion, i.Ins_FechaRegistro) AS NVARCHAR(25)) as fecha, "
	   			+"  dbo.fn_CatGral_DameDato(27,Ins_EstatusCG27) AS Estatus, Ins_EstatusCG27 from Incidencia i INNER JOIN Incidencia_Tipo t ON i. InsT_ID=t.InsT_ID "
    			+ " LEFT JOIN Incidencia_Involucrados p ON i.Ins_ID=p.Ins_ID"
				+" WHERE (i.Ins_PuedeVer_ProveedorID ="+Prov_ID+"  OR i.Ins_Usu_Reporta = " + Usuario+ ")  AND i.Ins_EstatusCG27 <> 4 "
				+ " AND i.Ins_FechaRegistro >= DATEADD(day,-100,getdate()) and i.Ins_FechaRegistro <= getdate() "
				+ " GROUP BY i.Ins_ID, Ins_Asunto, Ins_Descripcion, i.Ins_FechaRegistro, Ins_Usu_Reporta, Ins_Usu_Recibe, InsT_SLAAtencion,  "
				+ " InsT_SLAResolucion, Ins_EstatusCG27, Ins_PuedeVer_ProveedorID, Ins_EstatusCG27"
				+ " ORDER BY i.Ins_FechaRegistro DESC"

}
				//Response.Write(sSQL)
				rsIncidencias = AbreTabla(sSQL,1,0)
				
%>
                    <a class="dropdown-toggle count-info"  id= "IncidenciasTotales" data-toggle="dropdown" href="#">
                    </a>

<ul class="dropdown-menu dropdown-messages sortable-list connectList agile-list ui-sortable">
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
								 iEstatus = rsIncidencias.Fields.Item("Ins_EstatusCG27").Value

								 
        var  ClaseEstatus = "plain"
          switch (parseInt(iEstatus)) {
	 		
	 		case 1:
                 ClaseEstatus = "success"   
            break;    
            case 2:
                ClaseEstatus = "warning"
            break;     
            case 4:
                ClaseEstatus = "primary"
            break;    
            case 3:
                ClaseEstatus = "warning"
            break;   
            case 5:
                ClaseEstatus = "danger"
            break;        
            }   

								 
								 var sSQL = "SELECT  DATEDIFF (Hour, GETDATE(), '"+fecha+"') As Horas "
								 var rsHoras = AbreTabla(sSQL,1,0)

								 var Horas = rsHoras.Fields.Item("Horas").Value
							
								 if(rsIncidencias.Fields.Item("Ins_PuedeVer_ProveedorID").Value == -1||(rsIncidencias.Fields.Item("Ins_PuedeVer_ProveedorID").Value > -1&& reporta!=Usuario)){
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
								if(!rsFoto.EOF){
								Ruta_Imagen =  rsFoto.Fields.Item("foto").Value
								}else{
								var Ruta_Imagen =  "/Media/wms/Perfil/avatar.jpg"
								}
								if(Ruta_Imagen==""){
								var Ruta_Imagen =  "/Media/wms/Perfil/avatar.jpg"
								}
								sSQL="SELECT  dbo.fn_Usuario_DameNombreUsuario( "+recibe+" ) as usuario1, dbo.fn_Usuario_DameNombreUsuario( "+reporta+" ) as usuario2 "
								var rsUsuario = AbreTabla(sSQL,1,0)
								var N_Usuario_Rec =  rsUsuario.Fields.Item("usuario1").Value
								var N_Usuario_Rep =  rsUsuario.Fields.Item("usuario2").Value
								}else{
									var Ruta_Imagen =  "/Media/wms/Perfil/avatar.jpg"
							 }
							 if(Prov_ID==-1){
						 if(rsIncidencias.Fields.Item("Ins_PuedeVer_ProveedorID").Value > -1 && rsIncidencias.Fields.Item("Ins_Usu_Reporta").Value != Usuario){
								   
												
									sSQL = "SELECT Ins_GrupoID FROM Incidencia_Involucrados WHERE Ins_ID = " +  rsIncidencias.Fields.Item("Ins_ID").Value
												var rsGrupo = AbreTabla(sSQL,1,0)
								
									sSQL = "SELECT IncG_ID FROM Incidencia_Grupo_Usuario WHERE Usu_ID="+Usuario+" OR Emp_ID="+Usuario
												var rsGruID = AbreTabla(sSQL,1,0)
												
									if(rsGrupo.Fields.Item("Ins_GrupoID").Value==rsGruID.Fields.Item("IncG_ID").Value){
									
									sSQL = "SELECT IncG_Nombre FROM Incidencia_Grupo WHERE Gru_ID=" +rsGrupo.Fields.Item("Ins_GrupoID").Value
												 rsGrupo = AbreTabla(sSQL,1,0)
								    
						//			sSQL = "SELECT Prov_Nombre FROM Proveedor WHERE Prov_ID =" + rsIncidencias.Fields.Item("Ins_PuedeVer_ProveedorID").Value
//												var rsProveedor = AbreTabla(sSQL,1,0)
									}
									
			   %>



                        

                                <%
						 	if(Horas < 0){
						 %>
						 <li class="danger-element ui-sortable-handle">
                           <div  class="dropdown-messages-box"> 
                    <%
							}else if(Horas < 4 && Horas > 0){
					%>
						<li class="warning-element ui-sortable-handle">
                           <div  class="dropdown-messages-box">
					<%
							}else{
                    %>
							<li>
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
                                    <strong><%=rsProveedor.Fields.Item("Prov_Nombre").Value%></strong><br><%=Titulo%>. <br>
                                    <strong>Estatus:</strong>  <span class="label label-<%=ClaseEstatus%>"> <%=estatus%> </span>
                                    <br>
                                    <small class="text-muted"><%=Fecha%></small></font>
                                </div>
                            </div>
                           
                        </li>
               
                        
<%
				
           }else{
		   %>
            

                                <%
						 	if(Horas < 0){
						 %>
						<li class="danger-element ui-sortable-handle">
                           <div  class="danger-element dropdown-messages-box"> 
                    <%
							}else if(Horas < 4 && Horas > 0){
					%>
						<li class="warning-element ui-sortable-handle">
                           <div  class="dropdown-messages-box">
					<%
							}else{
                    %>
						<li class="warning-element ui-sortable-handle">
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
<%
         	 if(rsIncidencias.Fields.Item("Ins_PuedeVer_ProveedorID").Value > -1 && rsIncidencias.Fields.Item("Ins_Usu_Reporta").Value == Usuario){
							sSQL = "SELECT Prov_Nombre FROM Proveedor WHERE Prov_ID =" + rsIncidencias.Fields.Item("Ins_PuedeVer_ProveedorID").Value
							var rsProveedor = AbreTabla(sSQL,1,0)

							 %>
		                      <strong>Enviado a: <br /><%=rsProveedor.Fields.Item("Prov_Nombre").Value%></strong>
					 	<%
			 }else{
				 
				 if( rsIncidencias.Fields.Item("Ins_Usu_Reporta").Value == Usuario){
						%>
                                    <strong>Enviado a: </strong> <br />
									 <strong><%=N_Usuario_Rec%></strong>
                      <%
				 }else{
			 %>
                                    <strong><%=N_Usuario_Rep%></strong>
			 <%
				 }
			 }
					  %>              
                                    <br><%=Titulo%>. <br>
                                    <strong>Estatus:</strong> <span class="label label-<%=ClaseEstatus%>"> <%=estatus%> </span>
                                    <br>
                                   <strong> <small class="text-muted"><%=Fecha%></small></strong></font>
                                </div>
                            </div>
                           
                        </li>
                      
                        
<%
		   }
							 }else{
								 %>
						<li>

                                <%
						 	if(Horas < 0){
						 %>
                           <div  class="dropdown-messages-box"> 
                    <%
							}else if(Horas < 4 && Horas > 0){
					%>
                           <div  class="dropdown-messages-box">
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
                                <%
						 if(rsIncidencias.Fields.Item("Ins_Usu_Reporta").Value != Usuario){
							sSQL="SELECT  dbo.fn_Usuario_DameNombreUsuario( "+reporta+" ) as usuario "
								var rsUsuario = AbreTabla(sSQL,1,0)
								var N_Usuario =  rsUsuario.Fields.Item("usuario").Value

								%>
                                    <strong>Lyde: <%=N_Usuario%></strong>
                                    <%
						 }else{
							sSQL = "SELECT Prov_Nombre FROM Proveedor WHERE Prov_ID =" + rsIncidencias.Fields.Item("Ins_PuedeVer_ProveedorID").Value
							var rsProveedor = AbreTabla(sSQL,1,0)

							 %>
		                      <strong><%=rsProveedor.Fields.Item("Prov_Nombre").Value%></strong>
					 <%
						 }
					%>
                                    <br><%=Titulo%>. <br>
                                    <strong>Estatus:</strong> <span class="label label-<%=ClaseEstatus%>"> <%=estatus%> </span>
                                    <br>
                                    <small class="text-muted"><%=Fecha%></small></font>
                                </div>
                            </div>
                           
                        </li>
                    
							 
                        <%
                        	 
  }
                            rsIncidencias.MoveNext() 
							}
							rsIncidencias.Close()  
%>
<br />                       
                       <center> <a   class="text-muted btnVerMas"><strong>Ver todas las incidencias </strong></a></center> 

                    </ul>
<script type="application/javascript">

	$(document).ready(function() {
            $("#IncidenciasTotales").load("/pz/wms/Incidencias/BarraLateral_html.asp?Prov_ID="+$("#Prov_ID").val()+"&Usuario="+$("#IDUsuario").val()+"&Tarea=6&SegGrupo="+$("#SegGrupo").val())        
	
	$('.btnVerMas').click(function(e) {
	var Params = "?Prioridad=1"
	   Params += "&IDUsuario=" + $("#IDUsuario").val()
   	   Params += "&SegGrupo=" + $("#SegGrupo").val()

				<%
				if(Prov_ID>-1){
				%>
				Params += "&Prov_ID=" + $("#Prov_ID").val()
               Params += ""//este parametro limpia el cache
                   
			$("#Contenido").load("/pz/wms/Proveedor/Incidencias/CTL_Incidencias.asp" + Params)        
        		<%
				}else{
				%>
			$("#Contenido").load("/pz/wms/Incidencias/CTL_Incidencias.asp" + Params)        
				<%
				}
				%>
});

	});
		   function CargaIncidencia(reporta, recibe, insid){
        
            var Params = "?insid=" + insid
                Params += "&reporta=" + reporta
                Params += "&recibe=" + recibe
                Params += "&IDUsuario=" + $('#IDUsuario').val()
		   	    Params += "&SegGrupo=" + $("#SegGrupo").val()
				<%
				if(Prov_ID>-1){
				%>
				Params += "&Prov_ID=" + $("#Prov_ID").val()
               Params += ""//este parametro limpia el cache
                   
			$("#Contenido").load("/pz/wms/Proveedor/Incidencias/CTL_Incidencias.asp" + Params)        
        		<%
				}else{
				%>
			$("#Contenido").load("/pz/wms/Incidencias/CTL_Incidencias.asp" + Params)        
				<%
				}
				%>
    }

</script>