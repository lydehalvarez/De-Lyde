<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%
	var Tarea  = Parametro("Tarea",0)

	var AlrS_ID = Parametro("AlrS_ID",-1)
	var Alr_ID = Parametro("Alr_ID",-1)	
	var AlrE_ID = Parametro("AlrE_ID",-1)	
	var ID_Unica = Parametro("ID_Unica",-1)
		
	var sResultado = ""
	
	switch (parseInt(Tarea)) {
		case 0:
			Response.Write("<br>" + Request.ServerVariables("PATH_INFO") + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[OK]")
			bPuedeVerDebug = true
		    bDebug = true
			bOcurrioError = true
			DespliegaAlPie()
		break;
		case 1:  //Tomando propiedad sobre una tarea
			try {
			
				var sSQL = " EXEC PA_Avisos_TomarTareaNueva " + AlrS_ID + "," + Alr_ID 
					sSQL += "," + AlrE_ID + "," + ID_Unica

				Ejecuta(sSQL,0)
			 
				sResultado = "OK"
				
			} catch(err) {
				sResultado = "ERROR"
			}
		break;	
		}
		
Response.Write(sResultado)
		
%>

