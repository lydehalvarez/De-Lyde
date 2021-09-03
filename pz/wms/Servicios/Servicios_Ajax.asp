<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
	
	var Tarea = Parametro("Tarea",0)
	var Ser_ID = Parametro("Ser_ID",-1)
	var SerP_ID = Parametro("SerP_ID",-1)
    var Chkdo = Parametro("Chkdo",0)
   
	switch (parseInt(Tarea)) {
		case 1:	
 
			try {	

				var sSQL = "DELETE FROM ServicioPaquete_Configuracion "
					sSQL += " WHERE Ser_ID = " + Ser_ID 
					sSQL += " and SerP_ID = " +SerP_ID

				Ejecuta(sSQL,0)		

				if( Chkdo == 1 ) {
					var sSQL = "INSERT INTO ServicioPaquete_Configuracion( Ser_ID, SerP_ID ) " 
						sSQL += " VALUES( " + Ser_ID + ", " + SerP_ID + " ) "

					Ejecuta(sSQL,0)				

				}

				sResultado = "OK"		
			} catch(err) {
				sResultado = "falla"	
			}
 
		break;  
	}
   
	Response.Write(sResultado)
   
%>