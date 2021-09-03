<%@LANGUAGE="JAVASCRIPT"  CODEPAGE="949"%>
<!--#include file="../../../Includes/iqon.asp" -->		
<%
		  	var Ins_ID = Parametro("Ins_ID",-1)
		  	var InsO_ID = Parametro("InsO_ID",-1)
			var Reporta = Parametro("Reporta",-1)
			var Recibe = Parametro("Recibe",-1)
			var Permiso = Parametro("Permiso",-1)
			var IDUsuario = Parametro("IDUsuario",-1)

				sSQL = "SELECT *, dbo.fn_Usuario_DameNombreUsuario( InsCm_Autor_IDU ) as Autor, InsCm_Autor_IDU  "
                +  " , dbo.fn_Usuario_DameNombreUsuario( Ins_Usu_Recibe ) as RECIBE "
				+ " ,  CONVERT(VARCHAR(20), InsCm_FechaRegistro, 103) AS Fecha "
				+ " ,  CONVERT(VARCHAR(10),ISNULL(InsCm_FechaRegistro ,dateadd(minute,90,InsCm_FechaRegistro)), 108) AS Hora "
				+  " FROM Incidencia i RIGHT OUTER JOIN incidencia_Comentario c ON i.Ins_ID = c.Ins_ID "
				+  " WHERE Ins_Usu_Reporta = " +Reporta+ "AND Ins_Usu_Recibe = " + Recibe
				+ " AND InsCm_Padre = 0 AND c.Ins_ID = "+Ins_ID
				+ " ORDER BY InsCm_FechaRegistro DESC"
					var  rsIncidencias = AbreTabla(sSQL,1,0)
				//	Response.Write(sSQL)
				sSQL = "SELECT IDUnica, Usu_Nombre AS Nombre FROM Usuario u INNER JOIN Seguridad_Indice s ON u.Usu_ID = s.Usu_ID "
						 + "UNION" 
	    				 + " SELECT IDUnica, Emp_Nombre AS Nombre FROM Empleado e INNER JOIN Seguridad_Indice s ON e.Emp_ID = s.Emp_ID "
		   	 		var   rsAsignados = AbreTabla(sSQL,1,0)
					
				if(!rsIncidencias.EOF){
					
				    while (!rsIncidencias.EOF){
					var InsCm_Padre = rsIncidencias.Fields.Item("InsCm_ID").Value
					var Autor = rsIncidencias.Fields.Item("Autor").Value
					var ID_Autor = rsIncidencias.Fields.Item("InsCm_Autor_IDU").Value
					var Atendio = rsIncidencias.Fields.Item("RECIBE").Value
					var Fecha = rsIncidencias.Fields.Item("Fecha").Value
					var Hora = rsIncidencias.Fields.Item("Hora").Value
					var Descripcion = rsIncidencias.Fields.Item("InsCm_Observacion").Value
					var Titulo = rsIncidencias.Fields.Item("InsCm_Titulo").Value
					var Comenzo = rsIncidencias.Fields.Item("Ins_Tarea_FechaAtendida").Value
					var Termino = rsIncidencias.Fields.Item("Ins_Tarea_FechaLiberada").Value

			 sSQL = "SELECT  ISNULL(Usu_RutaImg + Usu_Imagen, '') as foto "
								 		  +"FROM Usuario u INNER JOIN Seguridad_Indice s ON s.Usu_ID=u.Usu_ID "
										  + " WHERE s.IDUnica="+ID_Autor
										
								var rsFoto = AbreTabla(sSQL,1,0)
											
								var Ruta_Imagen=""
								if(!rsFoto.EOF){
								Ruta_Imagen =  rsFoto.Fields.Item("foto").Value
					
								}
								if(Ruta_Imagen==""){
								var Ruta_Imagen =  "/Media/wms/Perfil/avatar.jpg"
								}
	
%>
<div class="timeline-item">
     <div class="row">
		<div class="col-xs-3 date">
            <i class="fa fa-briefcase"></i>
            <%=Fecha%>
            <br/>
            <%=Hora%>
            <br/>
			<small class="text-navy"><%=Autor%></small>
		</div>
			<div class="col-xs-9 content no-top-border">
                <div class="social-feed-box">

                            <!--<div class="pull-right social-action dropdown">
                                <button data-toggle="dropdown" class="dropdown-toggle btn-white">
                                    <i class="fa fa-angle-down"></i>
                                </button>
                                <ul class="dropdown-menu m-t-xs">
                                    <li><a href="#">Config</a></li>
                                </ul>
                            </div>-->
                            <div class="social-avatar">
                       
                                <div class="media-body">
                                    <a href="#"   class="pull-left"><img alt="image" src="<%=Ruta_Imagen%>" width="25px" height="25px"/>
                                   <%=Autor %> </a>
                                   
                               
                                &nbsp  
                                </div>
                            </div>
                            <div class="social-body">
                                <p>
                                   <%=Descripcion%>
                                </p>
								   <small class="text-muted"> <%=Fecha%> &nbsp;<%=Hora%></small>
<!--                                <div class="btn-group">
                                    <button class="btn btn-white btn-xs"><i class="fa fa-thumbs-up"></i> Like this!</button>
                                    <button class="btn btn-white btn-xs"><i class="fa fa-comments"></i> Comment</button>
                                    <button class="btn btn-white btn-xs"><i class="fa fa-share"></i> Share</button>
                                </div>
-->                            </div>
		 <div class="social-footer">
			<%
				sSQL = "SELECT dbo.fn_Usuario_DameNombreUsuario( InsCm_Autor_IDU ) as Autor, InsCm_Autor_IDU ,InsCm_Observacion, InsCm_Padre "
				+ " ,  CONVERT(VARCHAR(10), InsCm_FechaRegistro, 103) AS Fecha "
				+ " ,  CONVERT(VARCHAR(10), InsCm_FechaRegistro, 108) AS Hora "
				+  " FROM Incidencia i RIGHT OUTER JOIN incidencia_Comentario c ON i.Ins_ID = c.Ins_ID "
				+  " WHERE Ins_Usu_Reporta = " +Reporta+ "AND Ins_Usu_Recibe = " + Recibe
				+ " AND InsCm_Padre = " + InsCm_Padre
				+ " ORDER BY InsCm_FechaRegistro ASC"
				
			//Response.Write(sSQL)
		   	  	var rsRespuestas = AbreTabla(sSQL,1,0)
				if(!rsRespuestas.EOF){
					   while (!rsRespuestas.EOF){
						 InsCm_Padre = rsRespuestas.Fields.Item("InsCm_Padre").Value
						 Autor = rsRespuestas.Fields.Item("Autor").Value
 						 ID_Autor = rsRespuestas.Fields.Item("InsCm_Autor_IDU").Value
						 //Atendio = rsRespuestas.Fields.Item("RECIBE").Value
						 Fecha = rsRespuestas.Fields.Item("Fecha").Value
						 Hora = rsRespuestas.Fields.Item("Hora").Value
						 var Comentario = rsRespuestas.Fields.Item("InsCm_Observacion").Value
						 
						  sSQL = "SELECT  ISNULL(Usu_RutaImg + Usu_Imagen, '') as foto "
								 		  +"FROM Usuario u INNER JOIN Seguridad_Indice s ON s.Usu_ID=u.Usu_ID "
										  + " WHERE s.IDUnica="+ID_Autor
										
								var rsFoto = AbreTabla(sSQL,1,0)
								var Ruta_Imagen2=""
								if(!rsFoto.EOF){
								Ruta_Imagen2 =  rsFoto.Fields.Item("foto").Value
								}
								if(Ruta_Imagen2==""){
								var Ruta_Imagen2 =  "/Media/wms/Perfil/avatar.jpg"
								}
	
				%>
							   
									<div class="social-comment">
										<div class="media-body">
									  <a href="#"   class="pull-left"><img alt="image" src="<%=Ruta_Imagen2%>" width="15px" height="35px"/> 
									  	</a>
                                        <a>	<%=Autor%></a>
                                            <span>&nbsp;<%=Comentario%></span>
											<br/>
											<small class="text-muted"> <%=Fecha%> &nbsp;<%=Hora%></small>
										</div>
									</div>
	
								
					  <%	
						rsRespuestas.MoveNext() 
						}
					rsRespuestas.Close()  
				}
				%>
               					  <%
									  if(Permiso>1){
									  %>
                                <div class="social-comment">
                                    <div class="media-body">
                                    
                                      <div class="row col-sm-12 m-b-xs">
                                     
                                      <textarea class="form-control Respuesta<%=InsCm_Padre%>" placeholder="Escribe una respuesta......." onkeydown= "GuardaRespuesta(event, <%=InsCm_Padre%>,<%=Permiso%>)"></textarea>
                                    
                                      </div>
                                       <input type="hidden" value="<%=InsCm_Padre%>" class="agenda" id="InsCm_Padre"/>
                                    </div>
                                </div>
                                  <%
									  }
									  %>
                            </div>
                        </div>
                          
                                </div>
                           </div>
                   </div>          
             <%	
        rsIncidencias.MoveNext() 
        }
    rsIncidencias.Close()  
					}
						
		  if(Permiso>1){
%>   
        <div class="social-comment">
            <div class="media-body">
								
                 <div class="row col-sm-12 m-b-xs">
                    <textarea class="form-control Respuesta" placeholder="Escribe un comentario...." onkeydown= "GuardaRespuesta(event, 0,  <%=Permiso%>)"></textarea>
                </div>
                              
            </div>
        </div>
                                
<%
		  }
%>
	<script type="application/javascript">

   $(document).ready(function(){
	});
		    function GuardaRespuesta(event, inspadre, permiso){
        
				var keyNum = event.which || event.keyCode;
		  
		if(keyNum== 13 ){
			console.log($(".Respuesta").val())
		if(inspadre=="0"){
			var Respuesta = $(".Respuesta").val()
			var Asignado = $("#selAsignar").val()
			
		}else{
			var Respuesta =decodeURIComponent($(".Respuesta"+inspadre).val())
			var Asignado = ""
			console.log($(".selAsignar"+inspadre).val())
		}
		$.post("/pz/wms/Incidencias/Incidencias_Ajax.asp",
		{Ins_ID:$("#Ins_ID").val(),
		InsCm_Padre:inspadre,
		Asignado:Asignado,
		InsCm_Observacion:decodeURIComponent(Respuesta),
		Usuario:$('#IDUsuario').val(),
		Tarea:2
		},
		function(data){
	$("#divComentarios").load("/pz/wms/Incidencias/CTL_Incidencias_Comentarios.asp?Ins_ID="+ $("#Ins_ID").val()+"&Reporta="+$("#Reporta").val()+ "&Recibe="+$("#Recibe").val()+"&Permiso="+ permiso)
        });
		}
		
    }

    
</script>
