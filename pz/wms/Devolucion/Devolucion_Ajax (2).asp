<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->

<%

var Tarea = Parametro("Tarea",0)
var Dev_Folio = Parametro("Dev_Folio","")
var IDUsuario = Parametro("IDUsuario",-1)
var DevC_ID = Parametro("DevC_ID",-1)
var DevS_Serie = Parametro("DevS_Serie",-1)
var sResultado = ""

switch (parseInt(Tarea)) {
		case 1:	
			try {  
				var Existencia = BuscaSoloUnDato("Dev_ID","Devolucion","Dev_Folio = '"+Dev_Folio+"'",-1,0) 
				if(Existencia == -1){
				
				var Dev_ID = "(SELECT ISNULL(MAX(Dev_ID),0)+1 FROM Devolucion)"
				var Devolucion = "INSERT INTO Devolucion(Dev_ID,DevC_ID, Dev_Folio, Dev_TipoIngresoCG355, Dev_Usuario)"
					Devolucion += "VALUES("+Dev_ID+","+DevC_ID+",'"+Dev_Folio+"',1,"+IDUsuario+")"
				
					Ejecuta(Devolucion,0)
					sResultado = 1		
				}else{
					sResultado = -1			
				}
			
			} catch(err) {
				sResultado = -1
			}	
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
					
					sResultado = 1		
				}else{
					sResultado = -1			
				}
			
			} catch(err) {
				sResultado = -1
			}	
		break;		
		case 4:  	
			try {  
			var FolioLyde = ""
			
			FolioLyde = BuscaSoloUnDato("ISNULL(OV_Folio,'')","Orden_Venta","OV_ID = (SELECT OV_ID FROM Orden_Venta_Picking WHERE OVP_Serie = '"+DevS_Serie+"')",-1,0) 
				if(FolioLyde == -1){
					FolioLyde = BuscaSoloUnDato("ISNULL(TA_Folio,'')","TransferenciaAlmacen","TA_ID = (SELECT TOP 1 TA_ID FROM TransferenciaAlmacen_Articulo_Picking WHERE TAS_Serie = '"+DevS_Serie+"' ORDER BY TA_ID DESC)",-1,0) 
				}
				if(FolioLyde != -1){		
					var Existencia = BuscaSoloUnDato("DevS_ID","Devolucion_Serie","DevS_Serie = '"+DevS_Serie+"'",-1,0) 
					if(Existencia == -1){
				
					var DevS_ID = BuscaSoloUnDato("ISNULL(MAX(DevS_ID),0)+1","Devolucion_Serie","",-1,0)
					 
						var insertSerie = "INSERT INTO Devolucion_Serie(DevS_ID,DevC_ID,DevS_Serie,DevS_Usuario) "
							insertSerie += "VALUES("+DevS_ID+","+DevC_ID+",'"+DevS_Serie+"',"+IDUsuario+")  "
											
							Ejecuta(insertSerie,0)
														
						var InventarioUpdate = "UPDATE Inventario" 
							InventarioUpdate += " SET Inv_EstatusCG20 = 1 "
							//InventarioUpdate += " , Alm_ID = 2 "
							InventarioUpdate += " WHERE Inv_Serie = '"+DevS_Serie+"'"
							
							Ejecuta(InventarioUpdate,0)
							
						sResultado = FolioLyde
					}else{
						sResultado = "-1"
					}
				}else{
				sResultado = "-2"
				}
			} catch(err) {
				sResultado = "-3"
			}	
		break;		
}
Response.Write(sResultado)
%>