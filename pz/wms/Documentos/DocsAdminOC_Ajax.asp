<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%	

	var Tarea  = Parametro("Tarea",0)
	
	var OV_ID = Parametro("OV_ID",-1)
	var Doc_ID = Parametro("Doc_ID",-1)	
	var Docs_ID = Parametro("Docs_ID",-1)	
	var Doc_Nombre = utf8_decode(Parametro("Doc_Nombre",""))
	var Cargado = Parametro("Cargado",0)	
	var Doc_RutaArchivo = utf8_decode(Parametro("Doc_RutaArchivo",""))
	var Docs_Titulo = utf8_decode(Parametro("Docs_Titulo",""))	
	var Docs_Observaciones = utf8_decode(Parametro("Docs_Observaciones",""))
	var Usu_ID = Parametro("Usu_ID",-1)		
	var Docs_Validado = Parametro("Validado",0)		
	
	var sResultado = ""
	
	switch (parseInt(Tarea)) {
		case 0:
			Response.Write("<br>" + Request.ServerVariables("PATH_INFO") + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[OK]")
			bPuedeVerDebug = true
		    bDebug = true
			bOcurrioError = true
			DespliegaAlPie()
		break; 
		case 1:  //Guardando documento
			try {

				var sSQLACT =  " INSERT INTO Orden_Venta_Documentos (OV_ID, Doc_ID, Docs_ID "
					sSQLACT += ", Docs_Nombre, Docs_RutaArchivo, Docs_Titulo, Docs_Observaciones) " 
					sSQLACT += " VALUES (" + OV_ID + "," + Doc_ID + "," + Docs_ID 
					sSQLACT += ",'" + Doc_Nombre + "'" + " ,'" + Doc_RutaArchivo 
					sSQLACT += "','" + Docs_Titulo + "','" + Docs_Observaciones + "'  )"
					//Response.Write(sSQLACT)
				Ejecuta(sSQLACT,0)
			 
				sResultado = "OK"
				
			} catch(err) {
				sResultado = "ERROR"
			}
		break;	
		case 2:  //Borrando documento de la bd
			try {
	
				var sSQLACT =  " DELETE FROM Orden_Venta_Documentos "	
	                sSQLACT += " WHERE OV_ID = " + OV_ID
					sSQLACT += " AND Doc_ID = " + Doc_ID
					sSQLACT += " AND Docs_ID = " + Docs_ID
					
				Ejecuta(sSQLACT,0)
			 
				sResultado = "OK"
				
			} catch(err) {
				sResultado = "ERROR"
			}
		break;	
		case 3:  //Buscando el siguiente ID
			try {	
						
			 	var sCondicion = " OV_ID = " + OV_ID
					sCondicion += " AND Doc_ID = " + Doc_ID
					//sCondicion += " AND Docs_ID = " + Docs_ID
				sResultado = SiguienteID("Docs_ID","Orden_Venta_Documentos",sCondicion,0)
				
			} catch(err) {
				sResultado = "ERROR"
			}
		break;			
		case 4:  //Borrando documento de la bd
			try {
	
				var sSQLACT =  " UPDATE Orden_Venta_Documentos "	
				    sSQLACT += " SET Docs_Validado = " + Docs_Validado
					sSQLACT += " , Docs_UsuarioValido = " + Usu_ID
	                sSQLACT += " WHERE OV_ID = " + OV_ID
					sSQLACT += " AND Doc_ID = " + Doc_ID
					sSQLACT += " AND Docs_ID = " + Docs_ID
					
				Ejecuta(sSQLACT,0)
			 
				sResultado = "OK"
				
			} catch(err) {
				sResultado = "ERROR"
			}
		break;		
		case 5:  //guardando la informacion de texto
			try {
	
				var sSQLACT =  " UPDATE Orden_Venta_Documentos "	
				    sSQLACT += " SET Docs_Titulo = '" + Docs_Titulo + "'"
					sSQLACT += " , Docs_Observaciones = '" + Docs_Observaciones + "'"
	                sSQLACT += " WHERE OV_ID = " + OV_ID
					sSQLACT += " AND Doc_ID = " + Doc_ID
					sSQLACT += " AND Docs_ID = " + Docs_ID
					
				Ejecuta(sSQLACT,0)
			 
				sResultado = "OK"
				
			} catch(err) {
				sResultado = "ERROR"
			}
		break;	
		}
		
Response.Write(sResultado)
		
%>



