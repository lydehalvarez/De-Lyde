<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%	

	var Tarea  = Parametro("Tarea",0)
	
	var Cli_ID = Parametro("Cli_ID",-1)
	var CliOC_ID = Parametro("CliOC_ID",-1)
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
				
                var sSQL1 =  " INSERT INTO Cliente_OrdenCompra_Documento (Cli_ID, CliOC_ID, Doc_ID "
                    sSQL1 += ", Docs_Nombre, Docs_RutaArchivo, Docs_Titulo, Docs_Observaciones) " 
                    sSQL1 += " VALUES (" + Cli_ID + "," + CliOC_ID + "," + Doc_ID
                    sSQL1 += ",'" + Doc_Nombre + "'" + " ,'" + Doc_RutaArchivo 
                    sSQL1 += "','" + Docs_Titulo + "','" + Docs_Observaciones + "'  )"
                
				Ejecuta(sSQL1,0)
			    //Response.Write(sSQL1)
   
				sResultado = "OK"
				
			} catch(err) {
				sResultado = "ERROR"
			}
		break;	
		case 2:  //Borrando documento de la bd
			try {
	
				var sSQL2 =  " DELETE FROM Cliente_OrdenCompra_Documento "	
	                sSQL2 += " WHERE Cli_ID = " + Cli_ID
					sSQL2 +=   " AND CliOC_ID = " + CliOC_ID
					sSQL2 +=   " AND Doc_ID = " + Doc_ID
					sSQL2 +=   " AND Docs_ID = " + Docs_ID
					
				Ejecuta(sSQL2,0)
			 
				sResultado = "OK"
				
			} catch(err) {
				sResultado = "ERROR"
			}
		break;	
		case 3:  //Buscando el siguiente ID
//			try {	
//						
//			 	var sCondicion = " Cli_ID = " + Cli_ID
//					sCondicion += " AND CliOC_ID = " + CliOC_ID
//					sCondicion += " AND Doc_ID = " + Doc_ID
//					//sCondicion += " AND Docs_ID = " + Docs_ID
//				
//			} catch(err) {
//				sResultado = "ERROR"
//			}
		break;			
		case 4:  //Borrando documento de la bd
			try {
	

				var sSQL4 =  " UPDATE Cliente_OrdenCompra_Documento "	
				    sSQL4 +=    " SET Docs_Validado = " + Docs_Validado
					sSQL4 +=      " , Docs_UsuarioValido = " + Usu_ID
	                sSQL4 +=  " WHERE Cli_ID = " + Cli_ID
					sSQL4 +=    " AND CliOC_ID = " + CliOC_ID
					sSQL4 +=    " AND Doc_ID = " + Doc_ID
					sSQL4 +=    " AND Docs_ID = " + Docs_ID
					
				Ejecuta(sSQL4,0)
			 
				sResultado = "OK"
				
			} catch(err) {
				sResultado = "ERROR"
			}
		break;		
		case 5:  //guardando la informacion de texto
			try {
	

				var sSQL5 =  " UPDATE Cliente_OrdenCompra_Documento "	
				    sSQL5 +=    " SET Docs_Titulo = '" + Docs_Titulo + "'"
					sSQL5 +=      " , Docs_Observaciones = '" + Docs_Observaciones + "'"
	                sSQL5 +=  " WHERE Cli_ID = " + Cli_ID
	                sSQL5 +=    " AND CliOC_ID = " + CliOC_ID
					sSQL5 +=    " AND Doc_ID = " + Doc_ID
					sSQL5 +=    " AND Docs_ID = " + Docs_ID
					
				Ejecuta(sSQL5,0)
			  
				sResultado = "OK"
				
			} catch(err) { 
				sResultado = "ERROR"
			}
		break;	
		}
		
Response.Write(sResultado)
 	
%>



