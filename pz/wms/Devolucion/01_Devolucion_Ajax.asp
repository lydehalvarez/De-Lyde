<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->

<%

var Tarea = Parametro("Tarea",0)
var Dev_Folio = Parametro("Dev_Folio","")
var IDUsuario = Parametro("IDUsuario",-1)
var DevC_ID = Parametro("DevC_ID",-1)
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
}
Response.Write(sResultado)
%>