<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->

<%

var Tarea = Parametro("Tarea",0)
var Dev_Folio = Parametro("Dev_Folio","")
var IDUsuario = Parametro("IDUsuario",-1)
var DevC_ID = Parametro("DevC_ID",-1)
var DevS_Serie = Parametro("DevS_Serie",-1)
var Guia = Parametro("Guia",-1)
var sResultado = ""
var result = 0
var message = ""

switch (parseInt(Tarea)) {
		case 1:	
			try {  
				var Existencia = BuscaSoloUnDato("Dev_ID","Devolucion","Dev_Folio = '"+Dev_Folio+"' AND DevC_ID = "+DevC_ID,-1,0) 
				if(Existencia == -1){
					var Dev_ID = "(SELECT ISNULL(MAX(Dev_ID),0)+1 FROM Devolucion)"
					var Devolucion = "INSERT INTO Devolucion(Dev_ID,DevC_ID, Dev_Folio, Dev_TipoIngresoCG355, Dev_Usuario)"
						Devolucion += "VALUES("+Dev_ID+","+DevC_ID+",'"+Dev_Folio+"',1,"+IDUsuario+")"
					
						Ejecuta(Devolucion,0)
					
					result = 1	
					message = Dev_Folio+" folio colocado"
				}else{
					result = -2
					message = Dev_Folio+" el folio ya fue escaneado"
				}
			
			} catch(err) {
				result = -1
				message = "Error al ejecutarcel query"
			}	
			sResultado = '{"result":'+result+',"Folio":"'+FolioLyde+'","message":"'+message+'"}'
		break;		
		case 2:	
			try {  
				var DevC_ID = BuscaSoloUnDato("ISNULL(MAX(DevC_ID),0)+1","Devolucion_Corte","",-1,0) 
				if(DevC_ID > 0){
					var DevolucionCorte = "INSERT INTO Devolucion_Corte(DevC_ID, DevC_Usuario)"
						DevolucionCorte += "VALUES("+DevC_ID+","+IDUsuario+")"
					
					Ejecuta(DevolucionCorte,0)
					
					sResultado = DevC_ID		
				}else{
					sResultado = -1	
				}
			
			} catch(err) {
				sResultado = -1
			}	
		break;		
		case 3:  	
			try {  
				if(DevC_ID != -1){
					var EliminaCorte = "DELETE FROM Devolucion_Corte WHERE DevC_ID = "+DevC_ID
										
						Ejecuta(EliminaCorte,0)
						
					var EliminaDev = "DELETE FROM Devolucion WHERE DevC_ID = "+DevC_ID
										
						Ejecuta(EliminaDev,0)
					
					result = 1		
					message = "Carga cancelada exitosamente"
				}else{
					result = -1
					message = "Error al cancelar el corte"
				}
			
			} catch(err) {
				result = -3
				message = err
			}	
			sResultado = '{"result":'+result+',"message":"'+message+'"}'
		break;		
		case 4:  	
			try {  
			var FolioLyde = ""
			
			FolioLyde = BuscaSoloUnDato("ISNULL(OV_Folio,'')","Orden_Venta","OV_ID = (SELECT OV_ID FROM Orden_Venta_Picking WHERE OVP_Serie = '"+DevS_Serie+"')",-1,0) 
				if(FolioLyde == -1){
					FolioLyde = BuscaSoloUnDato("ISNULL(TA_Folio,'')","TransferenciaAlmacen","TA_ID = (SELECT TA_ID FROM TransferenciaAlmacen_Articulo_Picking WHERE TAS_Serie = '"+DevS_Serie+"')",-1,0) 
				}
				if(FolioLyde != -1){		
					var Existencia = BuscaSoloUnDato("DevS_ID","Devolucion_Serie","DevS_Serie = '"+DevS_Serie+"'",-1,0) 
					if(Existencia == -1){
				
					var DevS_ID = BuscaSoloUnDato("ISNULL(MAX(DevS_ID),0)+1","Devolucion_Serie","",-1,0)
					 
						var insertSerie = "INSERT INTO Devolucion_Serie(DevS_ID,DevS_Serie,DevS_Usuario) "
							insertSerie += "VALUES("+DevS_ID+",'"+DevS_Serie+"',"+IDUsuario+")  "
											
							Ejecuta(insertSerie,0)
						
						result = 1	
					}else{
						result = -2
					}
				}else{
				 result = -1
				}
			} catch(err) {
				result = -3
			}	
			sResultado = '{"result":'+result+',"Folio":"'+FolioLyde+'"}'
		break;
		case 5:	
			try {  
			var identifica = ""
				identifica = BuscaSoloUnDato("OV_Folio","Orden_Venta","OV_TRACKING_NUMBER = '"+Guia+"'",-1,0) 
				if(identifica == -1){
					identifica = BuscaSoloUnDato("TA_Folio","TransferenciaAlmacen","TA_Guia = '"+Guia+"'",-1,0)
				}
				
				if(identifica != -1){					
					result = 1	
					message = "Folio encontrado "+identifica
					FolioLyde = identifica
				}else{
					result = -2
					message = "Lo sentimos no se encontro un folio con la guia "+Guia
				}
			
			} catch(err) {
				result = -1
				message = "Error al ejecutarcel query"
			}	
			sResultado = '{"result":'+result+',"Folio":"'+FolioLyde+'","message":"'+message+'"}'
		break;		
}
Response.Write(sResultado)
%>