<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%
    var TA_ID = Parametro("TA_ID", -1)
		
    var sqlComPad = "SELECT COMN.Comn_ID "
            + ", COMN.Comn_Padre "
            + ", COMN.Comn_Titulo "
            + ", COMN.Comn_Observacion "
            + ", COMN.Comn_FechaComentario "
            + ", ( SELECT Nombre FROM dbo.tuf_Usuario_Informacion( COMN.IDUsuario ) ) AS Nombre "
            + ", ISNULL(( SELECT RutaImg FROM dbo.tuf_Usuario_Informacion( COMN.IDUsuario ) ) + ( SELECT Imagen FROM dbo.tuf_Usuario_Informacion( COMN.IDUsuario ) ), '') AS RutaImagen "
        + " FROM Comentario COMN "
        + " WHERE COMN.TA_ID = " + TA_ID  
            + " AND Comn_Padre = 0 "
        + " ORDER BY COMN_ID ASC "
			
		var rsComPad = AbreTabla(sqlComPad, 1, 0)
%>
           <div class="feed-activity-list">
                                                    
                <div class="feed-element">
                    <div class="media-body ">
                        <div class="actions text-right">
                            <a class="btn btn-xs btn-white" data-toggle="modal" data-target="#modalComentario" 
                             onclick="Comentarios.VisualizarModal(0)">
                            	<i class="fa fa-plus"></i> Comentar 
                            </a>
                        </div>
                    </div>
                </div>
<%
		var intComn_ID = ""
		var intComn_Padre = ""
		
		while( !(rsComPad.EOF) ){
			
			var strImgPad = "/Media/wms/Perfil/avatar.png"
			
			intComn_Padre = rsComPad("Comn_ID").Value
			
			if( rsComPad("RutaImagen").Value != "" ){
				strImgPad = rsComPad("RutaImagen").Value
			}
%>
				<div class="feed-element">
                    <a href="#" class="pull-left">
                        <img alt="image" class="img-circle" src="<%= strImgPad %>">
                    </a>
                    <div class="media-body ">
                        <div class="actions pull-right">
                            <a class="btn btn-xs btn-white" data-toggle="modal" data-target="#modalComentario" 
                             onclick="Comentarios.VisualizarModal(<%= rsComPad("Comn_ID").Value %>)" >
                            	<i class="fa fa-comment"></i> Comentar 
                            </a>
                        </div>
                        <strong><%= rsComPad("Nombre").Value %></strong>
                        <br>
                        <small class="text-muted"><%= rsComPad("Comn_FechaComentario").Value %></small>
                        <br>
                        <strong><%= rsComPad("Comn_Titulo").Value %></strong>
                        <div class="well">
                           <%= rsComPad("Comn_Observacion").Value %>															
                        </div>
<%				
				var sqlComHij = "SELECT COMN.Comn_ID "
						+ ", COMN.Comn_Padre "
						+ ", COMN.Comn_Titulo "
						+ ", COMN.Comn_Observacion "
						+ ", COMN.Comn_FechaComentario "
						+ ", ( SELECT Nombre FROM dbo.tuf_Usuario_Informacion( COMN.IDUsuario ) ) AS Nombre "
						+ ", ISNULL(( SELECT RutaImg FROM dbo.tuf_Usuario_Informacion( COMN.IDUsuario ) ) + ( SELECT Imagen FROM dbo.tuf_Usuario_Informacion( COMN.IDUsuario ) ), '') AS RutaImagen "
					+ "FROM Comentario COMN "
					+ "WHERE COMN.TA_ID = " + TA_ID  
						+ "AND Comn_Padre = " + intComn_Padre  
					+ "ORDER BY COMN_ID ASC "
					
				var rsComHij = AbreTabla(sqlComHij, 1 ,0)
				
				while ( !(rsComHij.EOF) ){
					
					var strImgHij = "/Media/wms/Perfil/avatar.png"
					
					if( rsComHij("RutaImagen").Value != "" ){
						strImgHij = rsComHij("RutaImagen").Value
					}
%>
                        <div>
                           
                            <div class="feed-element">
                                <a href="#" class="pull-left">
                                    <img alt="image" class="img-circle" src="<%= strImgHij %>">
                                </a>
                                <div class="media-body ">
                                    <strong><%= rsComHij("Nombre").Value %></strong> 
                                    <br>
                                    <small class="text-muted"><%= rsComHij("Comn_FechaComentario").Value %></small>
                                    <br>
                                    <strong><%= rsComHij("Comn_Titulo").Value %></strong>
                                    <div class="well">
                                       <%= rsComHij("Comn_Observacion").Value %>	
                                    </div>
                                </div>
                            </div>
                        
                        </div>	
<%				
					rsComHij.MoveNext
				}
				
				rsComHij.Close
%>
					</div>
				</div>
<%
			rsComPad.MoveNext()
			
		}
		
		rsComPad.Close() 
%>                
            </div>
