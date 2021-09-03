<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../../../../Includes/iqon.asp" -->
<%
   
	var Tarea = Parametro("Tarea",-1) 
	var TA_ID = Parametro("TA_ID",-1) 
	var Lot_ID = Parametro("Lot_ID",-1) 
	var Anio = Parametro("Anio",-1) 

	var IDUsuario = Parametro("IDUsuario",-1) 
 

 	var sResultado = ""        
 	var result = 0
 	var message = ""
	var data = ""	
   
	switch (parseInt(Tarea)) {
		case 1:	
//			if(TA_ID != -1){
//					Mov_ID = BuscaSoloUnDato("ISNULL((MAX(Mov_ID)),0)+1","Movimiento","",-1,0)
//			try {
//			
//					var insetMov = "INSERT INTO Movimiento(Mov_ID, Lot_ID, Cli_ID)"
//								+= " VALUES("+Mov_ID+", "+Lot_ID+", 4)"
//	
//	
//					var USQL = " UPDATE TransferenciaAlmacen "
//						USQL += " SET Mov_ID = "+Mov_ID
//						USQL += " WHERE TA_ID = "+TA_ID
//	
//						Ejecuta(USQL, 0)
//						
//					var MovP_ID = "(SELECT ISNULL(MovP_ID,0)+1 FROM Movimiento_Pallet WHERE Mov_ID = "+Mov_ID+")"
//					var MovP_LPN = "P"+Anio+"MF"+
//					var insetMov = "INSERT INTO Movimiento_Pallet(Mov_ID, MovP_ID, MovP_LPN, MovP_Usuario)"
//								+= " VALUES("+Mov_ID+","+MovP_ID+",'"+MovP_LPN+"',)"
//	
//	
//					var USQL = " UPDATE TransferenciaAlmacen "
//						USQL += " SET Mov_ID = "+Mov_ID
//						USQL += " WHERE TA_ID = "+TA_ID
//	
//						Ejecuta(USQL, 0)
//						
//						
//						result = Mov_ID
//						message = "Pallet cargado correctamente"
//				} catch (err) {
//					sResultado = -1
//				}
//			}
		break;
		case 2:
			try{
				var Mov_ID = Parametro("Mov_ID",-1)
				if(Mov_ID == -1){
					var Mov_ID = SiguienteID("Mov_ID","Movimiento","",0)
					var Mov = "INSERT INTO Movimiento(Mov_ID,Cli_ID) "
						Mov += " VALUES("+Mov_ID+",4) "
						
						Ejecuta(Mov, 0)
						
						data = '{"Mov_ID":'+Mov_ID+',"MovP_ID":0}'
				}
				var MovP_ID = SiguienteID("MovP_ID","Movimiento_Pallet","Mov_ID = "+Mov_ID,0)
				var Pallet = "INSERT INTO Movimiento_Pallet(Mov_ID, MovP_ID, MovP_Usuario) "
					Pallet += " VALUES("+Mov_ID+","+MovP_ID+","+IDUsuario+")"
					
					Ejecuta(Pallet, 0)
					
					result = 1
					message = "Tarea ejecutada correctamente"
					data = '{"Mov_ID":'+Mov_ID+',"MovP_ID":'+MovP_ID+'}'

 
			}catch(err){
				
			}
		break;
		case 3: // Cajas
			var numCajas = Parametro("numCajas",-1)
			var Mov_ID = Parametro("Mov_ID",-1)
			var MovP_ID = Parametro("MovP_ID",-1)
			var MovM_ID = SiguienteID("MovM_ID","Movimiento_Pallet_Master","Mov_ID = "+Mov_ID+" AND MovP_ID = "+MovP_ID,0)
				
				for(var i = 1;i<=numCajas;i++){
					
				var Master = "INSERT INTO Movimiento_Pallet_Master(Mov_ID, MovP_ID, MovM_ID,MovM_Usuario) "
					Master += " VALUES("+Mov_ID+","+MovP_ID+","+MovM_ID+","+IDUsuario+")"
					
					Ejecuta(Master, 0)
					MovM_ID++
				}
				result = 1
				message = "Cajas colocadas"
				
		break;
		case 4:
			var Mov_ID = Parametro("Mov_ID",-1)
			var MovP_ID = Parametro("MovP_ID",-1)
			var MovM_ID = Parametro("MovM_ID",-1)
			var MovS_ID = SiguienteID("MovS_ID","Movimineto_Pallet_Master_Serie","Mov_ID = "+Mov_ID+" AND MovP_ID = "+MovP_ID+" AND MovM_ID = "+MovM_ID,0)
			var Serie = Parametro("Serie",-1)
			var Limite = Parametro("Limite",-1)
			
			if(Serie != ""){
				if(Limite >= MovS_ID){
					var Existencia = BuscaSoloUnDato("MovS_ID","Movimineto_Pallet_Master_Serie","MovS_Serie = '"+Serie+"'",-1,0)
					if(Existencia == -1){
						try{
							var SerieInser = "INSERT INTO Movimineto_Pallet_Master_Serie(Mov_ID, MovP_ID, MovM_ID,MovS_ID,MovS_Serie,MovS_Usuario) "
								SerieInser += " VALUES("+Mov_ID+","+MovP_ID+","+MovM_ID+","+MovS_ID+",'"+Serie+"',"+IDUsuario+")"
								
								Ejecuta(SerieInser, 0)
								result = 1
								message = "Serie cargada exitosamente"
								data = '"success"'
						}catch(err){
							result = -1
							message = "Error al insertar"
							data = '"error"'
						}
					}else{
						result = -1
						message = "Serie repetida"
						data = '"error"'
					}
				}else{
					result = 2
					message = "Limite alcanzado"
					data = '"error"'
				}
			}else{
				result = -1
				message = "No hay datos"
				data = '"error"'
			}
		break;
	}
sResultado = '{"result":'+result+',"message":"'+message+'","data":['+data+']}'
Response.Write(sResultado)
%>
