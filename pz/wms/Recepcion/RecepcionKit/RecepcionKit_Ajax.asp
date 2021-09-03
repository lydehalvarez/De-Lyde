<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../../Includes/iqon.asp" -->
<%

var Tarea = Parametro("Tarea",0)
var Pt_ID = Parametro("Pt_ID",-1)
var result = -1
var message = ""
var Respuesta = ""

switch (parseInt(Tarea)) {

	case 1:	//Elimina la ubicacion del LPN
		
		var sSQL = "UPDATE  Pallet SET Ubi_ID= -1 WHERE Pt_ID="+Pt_ID
			 if(Ejecuta(sSQL,0)){
				result = 1
				message = "Ubicaci&oacute;n eliminado exitosamente" 
			 }else{
				result = 0
				message = "Error! Intenta de nuevo otra vez" 
	
			 }
		Respuesta = '{"result":'+result+',"message":"'+message+'"}'
	
	break; 
}
Response.Write(Respuesta)
%>