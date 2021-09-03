<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../Includes/iqon.asp" -->
<%
	
	var ibQ4Web = false
	
	var Tarea = Parametro("Tarea",0)

	var iUsu_ID = Parametro("Usu_ID",-1)	
	var Usu_Nombre = utf8_decode(Parametro("Usu_Nombre",""))
	var Usu_TituloCG8 = Parametro("Usu_TituloCG8",-1)
	var Usu_Usuario = utf8_decode(Parametro("Usu_Usuario",""))
	var Usu_Password = utf8_decode(Parametro("Usu_Password",""))
	var Usu_Padre = Parametro("Usu_Padre",-1)
	var Usu_TipoUsuarioCG61 = Parametro("Usu_TipoUsuarioCG61",-1)
	
	var Usu_FechaInicio = Parametro("Usu_FechaInicio","")
	if (!EsVacio(Usu_FechaInicio)) {
		Usu_FechaInicio = CambiaFormatoFecha(Parametro("Usu_FechaInicio",""),"dd/mm/yyyy",FORMATOFECHASERVIDOR)
	} 
	
	var Usu_FechaFin = Parametro("Usu_FechaFin","")
	if (!EsVacio(Usu_FechaFin)) {
		Usu_FechaFin = CambiaFormatoFecha(Parametro("Usu_FechaFin",""),"dd/mm/yyyy",FORMATOFECHASERVIDOR)
	} 
	
	var Usu_Descripcion = utf8_decode(Parametro("Usu_Descripcion",""))
	
	var Usu_Url = utf8_decode(Parametro("Usu_Url",""))
	var Usu_Email = utf8_decode(Parametro("Usu_Email",""))
	var Usu_Telefono = utf8_decode(Parametro("Usu_Telefono",""))
	
	var Usu_FechaNacimiento = Parametro("Usu_FechaNacimiento","")
	if (!EsVacio(Usu_FechaNacimiento)) {
		Usu_FechaNacimiento = CambiaFormatoFecha(Parametro("Usu_FechaNacimiento",""),"dd/mm/yyyy",FORMATOFECHASERVIDOR)
	} 
	
	var Usu_Skype = utf8_decode(Parametro("Usu_Skype",""))
	var Usu_Twitter = utf8_decode(Parametro("Usu_Twitter",""))
	var Usu_Facebook = utf8_decode(Parametro("Usu_Facebook",""))
	var Usu_GooglePlus = utf8_decode(Parametro("Usu_GooglePlus",""))
	var Usu_Linkedin = utf8_decode(Parametro("Usu_Linkedin",""))

	//[ ======================= Variables para el caso 4 {start} ========================== ]

	var Usu_NombreLogoArchivo = decodeURIComponent(Parametro("Usu_NombreLogoArchivo","")) 
	var Usu_RutaArchivo = utf8_decode(Parametro("Usu_RutaArchivo",""))

	//[ ======================= Variables para el caso 4 {end} ============================ ]

			
	var sResultado = 1
	
	switch (parseInt(Tarea)) {
	
		case 1:
		
			try {
			
				var sCondUsu = ""
				var iUsuID = BuscaSoloUnDato("ISNULL((MAX(Usu_ID) + 1),0)","Usuario",sCondUsu,-1,0)				

				var sInsUsu = " INSERT INTO Usuario "
					sInsUsu += " ( Usu_ID,Usu_Nombre,Usu_Usuario,Usu_TituloCG8,Usu_Padre "
					sInsUsu += " ,Usu_Estatus,Usu_Password,Usu_Grupo,Usu_Habilitado,Usu_TipoUsuarioCG61 "
					sInsUsu += " ,Usu_FechaInicio,Usu_FechaFin,Usu_Descripcion,Usu_Url,Usu_Email "
					sInsUsu += " ,Usu_Telefono,Usu_FechaNacimiento,Usu_Skype,Usu_Twitter,Usu_Facebook "
					sInsUsu += " ,Usu_GooglePlus,Usu_Github,Usu_Linkedin )"
					sInsUsu += " VALUES ("
					sInsUsu += iUsuID + ",'" + Usu_Nombre + "','" + Usu_Usuario + "'," + Usu_TituloCG8 + "," + Usu_Padre + "," 
					sInsUsu += Usu_Estatus + ",'" + Usu_Password + "'," + Usu_Grupo + "," + Usu_Habilitado + "," + Usu_TipoUsuarioCG61 + ",'" 
					sInsUsu += Usu_FechaInicio + "','" + Usu_FechaFin + "','" + Usu_Descripcion + "','" + Usu_Url + "','" + Usu_Email + "','"
					sInsUsu += Usu_Telefono + "','" + Usu_FechaNacimiento + "','" + Usu_Skype + "','" + Usu_Twitter + "','" + Usu_Facebook + "','"   
					sInsUsu += Usu_GooglePlus + "','" + Usu_Github + "','" + Usu_Linkedin + "')" 
					
					if (ibQ4Web) { Response.Write("sInsUsu&nbsp;"+sInsUsu+"<br />") }
					
					Ejecuta(sInsUsu,0)
					
					sResultado = iUsuID			

						
			} catch(err) {
					sResultado = -1 
			}
		
			Response.Write(sResultado)
		
		break;

		case 2:	

			try {
				
				var sActUsu = " UPDATE Usuario "
					
					sActUsu += " SET Usu_Nombre = '" + Usu_Nombre + "'"
					sActUsu += " ,Usu_TituloCG8 = " + Usu_TituloCG8
					sActUsu += " ,Usu_Usuario = '" + Usu_Usuario + "'"
					sActUsu += " ,Usu_Password = '" + Usu_Password + "'"
					sActUsu += " ,Usu_Padre = " + Usu_Padre
					
					sActUsu += " ,Usu_TipoUsuarioCG61 = " + Usu_TipoUsuarioCG61
					sActUsu += " ,Usu_FechaInicio = '" + Usu_FechaInicio + "'"
					sActUsu += " ,Usu_FechaFin = '" + Usu_FechaFin + "'"
					sActUsu += " ,Usu_Descripcion = '" + Usu_Descripcion + "'"

					sActUsu += " ,Usu_Url = '" + Usu_Url + "'"
					sActUsu += " ,Usu_Email = '" + Usu_Email + "'"
					sActUsu += " ,Usu_Telefono = '" + Usu_Telefono + "'"
					
					sActUsu += " ,Usu_FechaNacimiento = '" + Usu_FechaNacimiento + "'"
					sActUsu += " ,Usu_Skype = '" + Usu_Skype + "'"
					sActUsu += " ,Usu_Twitter = '" + Usu_Twitter + "'"
					sActUsu += " ,Usu_Facebook = '" + Usu_Facebook + "'"
					sActUsu += " ,Usu_GooglePlus = '" + Usu_GooglePlus + "'"
					sActUsu += " ,Usu_Linkedin = '" + Usu_Linkedin + "'"

					sActUsu += " WHERE Usu_ID = " + iUsu_ID
					
					
					if (ibQ4Web) { Response.Write("sActUsu&nbsp;"+sActUsu+"<br />") }
					
					Ejecuta(sActUsu,0)
					
					sResultado = iUsu_ID
					
			} 
			catch(err) {
				sResultado = 0
			}
			
			Response.Write(sResultado)		
	
		break;	

		case 3:	

			try {
				
				var sDelUsu = " DELETE FROM Usuario "
					sDelUsu += " WHERE Usu_ID = " + iUsu_ID
					
					if (ibQ4Web) { Response.Write("sDelUsu&nbsp;"+sDelUsu+"<br />") }
					
					Ejecuta(sDelUsu,0)
					
					sResultado = 1
					
			} 
			catch(err) {
				sResultado = 0
			}
			
			Response.Write(sResultado)		
	
		break;	

		//Tarea:4,Usu_ID:$("#Usu_ID").val(),Usu_NombreLogoArchivo:$("#Usu_NombreLogoArchivo").val(),Usu_RutaArchivo:sRutaArch

		case 4:

			try {		

				var sUPD = " UPDATE Usuario "
					sUPD += " SET Usu_RutaArchivo = '" + Usu_RutaArchivo + "'"
					sUPD += ", Usu_NombreLogoArchivo = '" + Usu_NombreLogoArchivo + "'"
					sUPD += " WHERE Usu_ID = " + iUsu_ID
					
					if (ibQ4Web) { Response.Write("sUPD&nbsp;" + sUPD + "<br />") }
		
					Ejecuta(sUPD,0)
		
					sResultado = "OK"
				
			} 
			catch(err) {
					sResultado = "ERROR"	
			}
		
			Response.Write(sResultado)				

		break;




	}	
	
%>	
	