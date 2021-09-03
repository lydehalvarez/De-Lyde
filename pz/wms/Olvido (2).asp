<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../Includes/iqon.asp" -->
<% 
	Hoy();
	
	//FormatoMensaje
	var cdoBodyFormatHTML = 0;
	var cdoBodyFormatText = 1; 
	//TipoMail
	var cdoMailFormatMime = 0;
	var cdoMailFormatText = 1; 
/*	
	function MandaMail(DePartede, Para, Asuntillo, Mensaje, FormatoMensaje, TipoMail ) {
	
		var mail1 = Server.CreateObject("CDONTS.NewMail")
			mail1.BodyFormat = FormatoMensaje
			mail1.MailFormat = TipoMail
			mail1.From = DePartede
			mail1.To = Para
			mail1.Subject = Asuntillo
			mail1.Body = Mensaje
			mail1.Importance=1
			mail1.Send()
	}
*/	


	var Tarea   = Parametro("Tarea",0)
	var ibQ4Web = false
		
	var sCon_Correo  = decodeURIComponent(Parametro("email",""))		
	
	var sResultado = 0
	
	var iEncontrado = 0
	var iUsuarioID = -1
	var iTipoUsuario = -1
	var sNombre = ""
	var sContrasena = ""


	switch (parseInt(Tarea)) {
	
		case 1:

			try {
				var sSQL = " SELECT * FROM ufn_Olvido_Contrasena('" + sCon_Correo + "')"
				var rsRS = AbreTabla(sSQL,1,0)
				
				if (!rsRS.EOF) {
					iEncontrado		= rsRS.Fields.Item("Encontrado").Value
					iUsuarioID		= rsRS.Fields.Item("ID").Value
					iTipoUsuario	= rsRS.Fields.Item("TipoUsuario").Value
					sNombre			= rsRS.Fields.Item("Nombre").Value
					sContrasena		= rsRS.Fields.Item("Contrasena").Value
				}
				rsRS.Close()
				
				sResultado = iEncontrado
				
				if(iEncontrado == 1) {
					
					switch (parseInt(iTipoUsuario)) {
						case 0:					//Facilitadores_Usuario
						
							try {
								sSQL  = "UPDATE Facilitadores_Usuario SET FacUsu_Password = '" + sContrasena
								sSQL += "' WHERE Fac_ID = " + iUsuarioID + " AND FacUsu_Usuario = '" + sCon_Correo + "'"
									if (ibQ4Web) { Response.Write(sSQL + "<br />") }
									//Ejecuta(sSQL,0)
							} 
							catch(err) {
								sResultado = 0 
								Response.Write("Hubo un error " + err.Number + "<br>")
							}
				
						break;
				
						case 1:					//Cliente_Usuario
							
							try {
								sSQL  = "UPDATE Cliente_Usuario SET CliUsu_Password = '" + sContrasena
								sSQL += "' WHERE Cli_ID = " + iUsuarioID + " AND CliUsu_Usuario = '" + sCon_Correo + "'"
									if (ibQ4Web) { Response.Write(sSQL + "<br />") }
									//Ejecuta(sSQL,0)
							} 
							catch(err) {
								sResultado = 0 
								Response.Write("Hubo un error " + err.Number + "<br>")
							}
							
						break;
								
						case 2:					//Usuario
				
							try {
								sSQL  = "UPDATE Usuario SET Usu_Password = '" + sContrasena
								sSQL += "' WHERE Usu_ID = " + iUsuarioID + " AND Usu_Usuario = '" + sCon_Correo + "'"
									if (ibQ4Web) { Response.Write(sSQL + "<br />") }
									Ejecuta(sSQL,0)
							} 
							catch(err) {
								sResultado = 0 
								Response.Write("Hubo un error " + err.Number + "<br>")
							}
				
						break;
					}

					var sch = "http://schemas.microsoft.com/cdo/configuration/"
					var myMail = Server.CreateObject("CDO.Message")
					
				   // var objConfig = Server.CreateObject("CDO.Configuration") 
				   
					//Setting the Configuration
					myMail.Configuration.Fields.Item(sch + "sendusing") = 2
					
					//===============================AGT====================================
					
					myMail.Configuration.Fields.Item(sch + "smtpusessl") = true
					myMail.Configuration.Fields.Item(sch + "smtpserver") = "smtp.gmail.com"
					myMail.Configuration.Fields.Item(sch + "smtpserverport") = 465
					myMail.Configuration.Fields.Item(sch + "sendusername") = "soporte@handdia.com"
					myMail.Configuration.Fields.Item(sch + "sendpassword") = "SoporteHanddia17"
					myMail.From = "soporte@handdia.com"
					
					//===============================AGT====================================
					
					myMail.Configuration.Fields.Item(sch + "smtpauthenticate") = 1
					
					myMail.Configuration.Fields.Item (sch + "smtpconnectiontimeout") = 60
					
					myMail.Configuration.Fields.Update()
					
					myMail.Subject = utf8_decode("Recuperación de contraseña")
					
					myMail.To = sCon_Correo
					
					myMail.Cc = ""
					
					myMail.Bcc = ""
					
				var sHTML = "<div class='col-sm-4'>"
					sHTML += "<h1><a href='http://agcorp.ec-soft.com.mx'>"  
					sHTML += "<img src='http://agt.iqon4web.com/Img/agt/LogoAGTcorto.png' alt='Logo' width='125' height='40.87'/></a></h1>"
					sHTML += "</div>"
					sHTML += "<br>"
					sHTML += "<div>"
					sHTML += "<p><small>" + jGre + "&nbsp;" + jHora + "</small></p>"
					sHTML += "</div>"
					sHTML += "<br>"
					sHTML += "<div class='col-sm-4'>"
					sHTML += "Hola " + sNombre + ","
					sHTML += "</div>"
					sHTML += "<br>"
					sHTML += "<br>"
					sHTML += "<div class='col-sm-4'>"
					sHTML += "La contrase&ntilde;a de tu cuenta de AG - ADMON <strong>" + sCon_Correo
					sHTML += "</strong> ha sido modificada en respuesta a tu solicitud de olvido de &eacute;sta,<br><br>"
					sHTML += "Se ha asignado una contrase&ntilde;a temporal, <strong>" + sContrasena + "</strong>, te recomendamos cambiarla dentro de tu perfil."
					sHTML += "</div>"
					sHTML += "<br>"
					sHTML += "<br>"
					sHTML += "<div>"
					sHTML += "<p><small>&copy; AG 2018, todos los derechos reservados</small></p>"
					sHTML += "</div>"
					
					//Response.Write(sHTML)
					
					myMail.HTMLBody = sHTML
					
					myMail.Send()
					
					myMail = null
					
					if (Err.Number == 0){
						Response.Write("Mail enviado")
					} else {
						Response.Write("Error enviado mail. C&oacute;digo: " & Err.Number)
						
						Err.Clear
					}
					
					//MandaMail("webmaster@agt.com",sCon_Correo,"Recuperacion de contraseña",sMensaje,0,0)
					
					//if (ibQ4Web) { Response.Write(sMensaje+"<br />") }
				}
					
			} 
			catch(err) {
				//sResultado = 0 
				//Response.Write("Hubo un error " + err.Number + "<br>")
			}
			
		break;		

	}

	Response.Write(sResultado)

%>

	
	
	