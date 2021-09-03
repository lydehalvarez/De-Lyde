<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../Includes/iqon.asp" -->
<%
   
	var Tarea = Parametro("Tarea",-1) 
	var Tipo = Parametro("Tipo",-1) 
	var ID = Parametro("ID","") 
	var Orden = Parametro("Orden",-1) 
	var TA_ArchivoID = Parametro("TA_ArchivoID",-1) 
	var IDUsuario = Parametro("IDUsuario",-1) 
 
	var result = -1
 	var message = ""
 	var data = ""
 	var sResultado = ""
		
   
	switch (parseInt(Tarea)) {
		case 1:	//Guarda Planificacion
			var condicion = ""
			var Estandar = " WHERE TA_ID in ( "
				Estandar += " SELECT TA_ID "
				Estandar += " FROM TransferenciaAlmacen b, Almacen a "
				Estandar += " WHERE b.TA_End_Warehouse_ID = a.Alm_ID "
				Estandar += " AND b.TA_ArchivoID = "+TA_ArchivoID
				
			switch(parseInt(Tipo)){// dependiendo del tipo hace update
				case -1:	
					condicion = "WHERE TA_Orden = "+ID
				break;  
				case 1:	
					condicion = "WHERE TA_ID in ( "
					condicion += " SELECT TA_ID "
					condicion += " FROM TransferenciaAlmacen b, Almacen a, Cat_Aeropuerto c "
					condicion += " WHERE b.TA_End_Warehouse_ID = a.Alm_ID "
					condicion += " AND b.TA_ArchivoID = "+TA_ArchivoID
					condicion += " AND a.Aer_ID =  c.Aer_ID "
					condicion += " AND c.Edo_ID = "+ID+") "
					
				break;  
				case 2:	
					condicion = Estandar
					condicion += " AND a.Alm_Ruta ="+ID+") "
				break;  
				case 3:	
					condicion = Estandar
					condicion += " AND a.Alm_Region = '"+ID+"') "
				break;  
				case 4:	
					condicion = Estandar
					condicion += " AND a.Alm_TipoDeRutaCG94 = "+ID+") "
				break;  
				case 5:	
					condicion = Estandar
					condicion += " AND a.Tda_ID = "+ID+") "
				break;  
			}
			
			try{
				var UPDATE = "UPDATE TransferenciaAlmacen "
					UPDATE += " SET TA_Orden = " +Orden
					UPDATE += " , TA_PlanificoUsuario = " +IDUsuario
					UPDATE += " , TA_PlanificoFecha = getdate() " 
					UPDATE += " "+condicion
					
					if(Ejecuta(UPDATE,0))
					{
						sResultado = 1
					}else
					{
						sResultado = -1
					}
				
			}catch(err){
				sResultado = -2
			}
			
		break; 
		case 2: //Elimina orden ya establecido
			try{
				var UPDATE = "UPDATE TransferenciaAlmacen "
					UPDATE += " SET TA_Orden = 0 "
					UPDATE += " WHERE TA_ArchivoID = "+TA_ArchivoID
					
					if(Ejecuta(UPDATE,0))
					{
						result = 1
						message = "Se restableci&oacute; correctamente"
					}else
					{
						result = -1
						message = "Ocurri&oacute; un error al tratar de restablecer, vuelve a intentarlo"
					}
				
			}catch(err){
				result = -2
				message = "Error en el query"
			}
			
			sResultado = '{"result":'+result+',"message":"'+message+'"}'
		break; 
		
	}
Response.Write(sResultado)
%>
