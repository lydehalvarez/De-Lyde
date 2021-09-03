<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
//Response.Charset="utf-8"
//Response.ContentType="text/html; charset=utf-8"

// HA ID: 1 2020-JUN-23 Se crea el Archivo
// HA ID: 2 2020-JUN-25 Se Agrega opcion de Cancelación de Orden de Venta
// HA ID: 3 2020-JUN-26 Se agregan campos a la edición 
// HA ID: 4 2020-JUL-22 Se agregan campos de seguimiento
// HA ID: 5 2020-JUL-27 Se actualiza la información de Bitacora
// HA ID: 6 2020-AGO-04 Se agrega opcion para actualizar el motivo de Envio a Fallido

var rqIntTarea = Parametro("Tarea",0)

switch (parseInt(rqIntTarea)) {
	//Actualizacion de Datos Generales de la Orden de Venta
	case 1: {
		
		var errADGError = 0; 
		
		var rqIntADGOV_ID = Parametro("OV_ID", -1)
		var rqStrADGCalle = decodeURIComponent(Parametro("Calle", ""))   
		var rqStrADGNumeroExterior = decodeURIComponent(Parametro("NumeroExterior", ""))
		var rqStrADGNumeroInterior = decodeURIComponent(Parametro("NumeroInterior", ""))
		var rqStrADGColonia = decodeURIComponent(Parametro("Colonia", ""))
		var rqStrADGDelegacion = decodeURIComponent(Parametro("Delegacion", ""))
		var rqStrADGCiudad = decodeURIComponent(Parametro("Ciudad", ""))
		var rqStrADGEstado = decodeURIComponent(Parametro("Estado", ""))
		var rqStrADGCodigoPostal = decodeURIComponent(Parametro("CodigoPostal", ""))
		var rqStrADGTelefono = decodeURIComponent(Parametro("Telefono", ""))
		var rqStrADGEmail = decodeURIComponent(Parametro("Email", ""))
		
		// HA ID: 3 INI Se agregan campos cachados
		
		var rqStrADGRefDomicilio1 = decodeURIComponent(Parametro("RefDomicilio1", ""))
		var rqStrADGRefDomicilio2 = decodeURIComponent(Parametro("RefDomicilio2", ""))
		var rqStrADGRefPersona = decodeURIComponent(Parametro("RefPersona", ""))
		var rqStrADGRefTelefono = decodeURIComponent(Parametro("RefTelefono", ""))
		var rqStrADGRefComentarios = decodeURIComponent(Parametro("RefComentarios", ""))
		
		// HA ID: 4
		var ssIntIdUnica = Parametro("IDUsuario", -1)
		
		// HA ID: 3 FIN
		
		// HA ID: 4 Se agrega campo ID Unico en Usuario de Cancelacion
		// HA ID: 3 INI Se agregan campos a la consulta
		var sqlADG = "UPDATE Orden_Venta "
			+ "SET OV_UsuarioCambioDireccion = " + ssIntIdUnica + "  "
				+ ", OV_Calle = '" + rqStrADGCalle + "' " 
				+ ", OV_NumeroExterior = '" + rqStrADGNumeroExterior + "' "
				+ ", OV_NumeroInterior = '" + rqStrADGNumeroInterior + "' "
				+ ", OV_CP = '" + rqStrADGCodigoPostal + "' "
				+ ", OV_Colonia = '" + rqStrADGColonia + "' "
				+ ", OV_Delegacion = '" + rqStrADGDelegacion + "' "
				+ ", OV_Ciudad = '" + rqStrADGCiudad + "' "
				+ ", OV_Estado = '" + rqStrADGEstado + "' "
				+ ", OV_Telefono = '" + rqStrADGTelefono + "' "
				+ ", OV_Email = '" + rqStrADGEmail + "' "
				+ ", OV_ReferenciaDomicilio1 = '" + rqStrADGRefDomicilio1 + "' "
				+ ", OV_ReferenciaDomicilio2 = '" + rqStrADGRefDomicilio2 + "' "
				+ ", OV_ReferenciaPersona = '" + rqStrADGRefPersona + "' "
				+ ", OV_ReferenciaTelefono = '" + rqStrADGRefTelefono + "' "
				+ ", OV_ComentarioGeneral = '" + rqStrADGRefComentarios + "' "
			+ "WHERE OV_ID = " + rqIntADGOV_ID + " " 
			
		var sqlHO = "UPDATE Orden_Venta_Historico_Direccion "
			sqlHO += "SET OV_UsuarioCambioDireccion = " + ssIntIdUnica
			sqlHO += " WHERE OV_ID = " + rqIntADGOV_ID
			sqlHO += " AND OV_UsuarioCambioDireccion is null" 
		
		
		try {
		
			Ejecuta(sqlADG, 0)
			Ejecuta(sqlHO, 0)
			
		} catch(err) {
			
			errADGError = 1
			
		}
		
		Response.Write(errADGError)
		
	} break;
	
	// HA ID: 2 INI Bloque de Cancelación de Orden de Venta
	//Cancelación de Orden de Compra
	case 2: {
		
		var errCanError = 0
		
		var rqIntCanOV_ID = Parametro("OV_ID", -1)
		var rqStrCanMotivoCancelacion = decodeURIComponent(Parametro("MotivoCancelacion", ""))
		var rqIntCanIzziCancela = Parametro("IzziCancela", 0)
		
		var ssIntIdUnica = Parametro("IDUsuario", -1)
		
		//rqIntCanOV_ID = 454
		
		var sqlCan = "UPDATE Orden_Venta "
			+ "SET OV_EstatusCG51 = 11 /* Cancelado */ "
				+ ", OV_Cancelada = 1 "
				+ ", OV_CancelacionFecha = GETDATE() "
				+ ", OV_UsuarioIzziCancela = " + rqIntCanIzziCancela + " "
				+ ", OV_UsuarioCancela = " + ssIntIdUnica + " "
				+ ", OV_MotivoCancelacion = '" + rqStrCanMotivoCancelacion + "' "
			+ "WHERE OV_ID = " + rqIntCanOV_ID + " "
		
		try {
		
			Ejecuta(sqlCan, 0) 
			
		} catch(err) {
		
			errCanError = 1
			
		}
		
		Response.Write(errCanError)
		
	} break;
	
	// HA ID: 2 FIN
	//
	case 3: {
		
		var rqIntOV_ID = Parametro("OV_ID", -1)
		
		// HA ID: 5 Se reestructura la consulta de Extración de Datos
		var sqlBit = "SELECT OV_Calle+ ' ' +OV_NumeroExterior+ ' ' + OV_NumeroInterior+ ' ' +OV_Colonia+ ' ' + OV_Delegacion+ ' ' +	OV_Ciudad+ ' ' + OV_Estado	+ ', ' + OV_CP+ ', ' + OV_Pais AS OVH_Observaciones "
				+ ", CONVERT(NVARCHAR(10), OV_FechaCambio, 103) + ' ' + CONVERT(NVARCHAR(50), OV_FechaCambio, 108) + ' hrs' AS OV_FechaCambio "
				+ ", ISNULL(( SELECT Nombre FROM [dbo].tuf_Usuario_Informacion(OV_UsuarioCambioDireccion) ), 'Sistema') AS Usuario "
			+ "FROM Orden_Venta_Historico_Direccion OVH "
			+ "WHERE OVH.OV_ID = " + rqIntOV_ID + " "
			+ "ORDER BY OVH.OV_FechaCambio DESC "
				//+ " AND ( SELECT Nombre FROM [dbo].tuf_Usuario_Informacion(OV_UsuarioCambioDireccion) ) IS NOT NULL "
		
		//Response.Write(sqlBit)
		
		var rsBit = AbreTabla(sqlBit, 1, 0)
		
		// HA ID: 5 INI Se eliminan campos y se sagregan los nuevos respecto a consulta
%>
            <table class="table table-striped">
                <thead>
                    <tr>
                        <th>Fecha</th>
                        <th>Usuario</th>
                        <th>Observaciones</th>
                    </tr>
                </thead>
                <tbody>
<%	
		while( !(rsBit.EOF) ){
			
%>
                    <tr>
                        <td>
                          <%= rsBit("OV_FechaCambio").Value %>
                        </td>
                        <td>
                        	<%= rsBit("Usuario").Value %>
                        </td>
                        <td>
                           <%= rsBit("OVH_Observaciones").Value %>
                        </td>
                    </tr>
<%
			rsBit.MoveNext
		}
		
		rsBit.Close
%>
                </tbody>
            </table>
<%		
		// HA ID: 5 FIN
	} break;
	
	// Guias y rastreo de cada uno de ellas
	case 4: {
		
		var rqIntOV_ID = Parametro("OV_ID", -1)
		
		var sqlPrvR = "SELECT ProG.ProG_FechaRegistro "
				+ ", ProG.ProG_NumeroGuia "
				+ ", CONVERT(NVARCHAR(20), ProvR.ProvR_Fecha,22) AS FECHA "
				+ ", ProvR.ProvR_Fecha "
				+ ", ProvR.ProvR_Evento "
				+ ", ProvR.ProvR_Observaciones "
				+ ", ProvR.ProvR_Localizacion "
			+ "FROM Proveedor_Rastreo ProvR "
				+ "INNER JOIN Proveedor_Guia ProG "
					+ "ON ProvR.ProG_ID = ProG.ProG_ID "
					+ "AND ProvR.Prov_ID = ProG.Prov_ID "
			+ "WHERE ProG.OV_ID = " + rqIntOV_ID + " "
			+ "ORDER BY ProG.ProG_FechaRegistro DESC "
				+ ", ProvR.ProvR_FechaRegisto DESC "
%>
		
<%
  		var rsPrvR = AbreTabla(sqlPrvR, 1, 0)
		
		var strNumeroGuia = ""
		var i = 0
		
		while ( !(rsPrvR.EOF) ){
			++i
			
			//Encabeado e inicio de  Acordeon
			if( strNumeroGuia != rsPrvR("ProG_NumeroGuia").Value ){
%>
			<div class="panel-body">
	        	<div class="panel-group" id="accordionOrdenVenta">
               
					<div class="panel panel-<%= (i == 1) ? "success": "info" %>">
                        <div class="panel-heading">
                            <h5 class="panel-title">
                                <a class="form-group row" data-toggle="collapse" data-parent="#accordionOrdenVenta" href="#collapse<%= i %>">
                                   <i class="fa fa-location-arrow"></i> No. Guia: <%= rsPrvR("ProG_NumeroGuia").Value %>
                                </a>
                            </h5>
                        </div>
                        <div id="collapse<%= i %>" class="panel-collapse collapse in">
                            <div class="panel-body">
                            	<div class="vertical-container dark-timeline" id="vertical-timeline">
<%				
			}
%> 
                                
                                    <div class="vertical-timeline-block">
                                        <div class="vertical-timeline-icon navy-bg">
                                            <i class="fa fa-map-marker"></i>
                                        </div>
                                        <div class="vertical-timeline-content">
                                            <h3><%= rsPrvR("ProvR_Evento").Value %></h3>
                                            <p><%= rsPrvR("ProvR_Observaciones").Value %></p>
                                            <span class="vertical-date small text-muted"> 
                                                <i class="fa fa-calendar"> </i> <%= rsPrvR("FECHA").Value %>
                                                &nbsp;&nbsp; 
                                                <i class="fa fa-map-marker"> </i> <%= rsPrvR("ProvR_Localizacion").Value %>
                                            </span>
                                        </div>
                                    </div>
<%
			strNumeroGuia = rsPrvR("ProG_NumeroGuia").Value
			
			rsPrvR.MoveNext() 
			
			//Pie y final de Acordeon
			if( rsPrvR.EOF || ( !(rsPrvR.EOF) && strNumeroGuia != rsPrvR("ProG_NumeroGuia").Value ) ){
%>
                                </div>
							</div>
                    	</div>
                    </div>
                </div>
<%				
			}
		}
		
		rsPrvR.Close()   
%>                    
		</div>
<%		
	} break;
	
	case 5: {
		
		var rqIntOV_ID = Parametro("OV_ID", -1)
		
		var sqlComPad = "SELECT COMN.Comn_ID "
				+ ", COMN.Comn_Padre "
				+ ", COMN.Comn_Titulo "
				+ ", COMN.Comn_Observacion "
				+ ", COMN.Comn_FechaComentario "
				+ ", ( SELECT Nombre FROM dbo.tuf_Usuario_Informacion( COMN.IDUsuario ) ) AS Nombre "
				+ ", ISNULL(( SELECT RutaImg FROM dbo.tuf_Usuario_Informacion( COMN.IDUsuario ) ) + ( SELECT Imagen FROM dbo.tuf_Usuario_Informacion( COMN.IDUsuario ) ), '') AS RutaImagen "
			+ "FROM Comentario COMN "
			+ "WHERE COMN.OV_ID = " + rqIntOV_ID + " "
				+ "AND Comn_Padre = 0 "
			+ "ORDER BY COMN_ID ASC "
			
		var rsComPad = AbreTabla(sqlComPad, 1, 0)
%>
           <div class="feed-activity-list">
                                                    
                <div class="feed-element">
                    <div class="media-body ">
                        <div class="actions text-right">
                            <a class="btn btn-xs btn-white" data-toggle="modal" data-target="#modalComentario" 
                             onclick="OrdenVentaComentario.VisualizarModal(0)">
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
                             onclick="OrdenVentaComentario.VisualizarModal(<%= rsComPad("Comn_ID").Value %>)" >
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
					+ "WHERE COMN.OV_ID = " + rqIntOV_ID + " "
						+ "AND Comn_Padre = " + intComn_Padre + " "
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
		
		rsComPad.Close
%>                
            </div>
<%		
	} break;
	
	//Agregado de Comentario
	case 6: {
		
		var rqIntIdUsuario = Parametro("IdUsuario", -1)
		
		var rqIntOV_ID = Parametro("OV_ID", -1)
		var rqIntComn_ID = Parametro("Comn_ID", -1)
		
		var rqStrTitulo = decodeURIComponent(Parametro("Titulo", ""))
		var rqStrComentario = decodeURIComponent(Parametro("Comentario", ""))
		
		var errError = 0
		
		var sqlComnIns = "INSERT INTO Comentario( "
				  + "Comn_Padre "
				+ ", Comn_AsuntoCG26 "
				+ ", Comn_EstatusCG27 "
				+ ", Comn_Titulo "
				+ ", Comn_Observacion "
				+ ", Comn_TipoCG28 "
				+ ", Comn_FechaComentario "
				+ ", IDUsuario "
				+ ", OV_ID "
			+ ") "
			+ "VALUES ( "
				  + " " + rqIntComn_ID + " "
				+ ", 4 /*Orden de Venta*/ "
				+ ", 0 /*Ninguno*/ "
				+ ", '" + rqStrTitulo + "' "
				+ ", '" + rqStrComentario + "' "
				+ ", 2 /*Solo una respuesta*/ "
				+ ", GETDATE() "
				+ ", " + rqIntIdUsuario + " "
				+ ", " + rqIntOV_ID + " "
			+ ") "
		
		//Response.Write(sqlComnIns)
		
		try{
			
			Ejecuta(sqlComnIns, 0)
			
		} catch(err){
			
			errError = 1
		}
		
		var jsonComIns = '{'
				+ ' "Error": "' + errError + '" '
			+ '}'
		
		Response.Write(jsonComIns)
		
	} break;
	
	// HA ID: 6 INI Opcion de Actualización de Envio de Fallido
	case 7: {
		
		var rqIntIDUsuario = Parametro("IDUsuario", -1)
		
		var rqIntOV_ID = Parametro("OV_ID", -1)
		var rqIntMFl_ID = Parametro("MotivoFallido", -1)
		
		var errFalError = 0
		
		var sqlMotFal = "UPDATE Orden_Venta "
			+ "SET OV_EstatusCG360 = " + rqIntMFl_ID + " /* Motivo de Fallido */ "
				+ ", OV_FallidoFecha = GETDATE() "
				+ ", OV_FallidoUsuario = " + rqIntIDUsuario + " "
			+ "WHERE OV_ID = " + rqIntOV_ID + " "
		
		try {
		
			Ejecuta(sqlMotFal, 0) 
			
		} catch(err) {
		
			errFalError = 1
			
		}
		
		Response.Write(errFalError)
		
	} break;
	
}

%>