<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%

    var bDebugIQ = false
   
    var Tarea = Parametro("Tarea",0)
    var iAud_ID = Parametro("Aud_ID",-1)
    var iAudU_AsignadoA = Parametro("AudU_AsignadoA",0)
    var sArrPTID = Parametro("ArrPtID",-1)

    //Response.Write("sArrPTID: " + sArrPTID + "<br>")   
   
    
    var result = -1
    var message = ""       

    if(bDebugIQ){ Response.Write("Tarea: " + Tarea + " |  " + sArrPTID ) }   
   
    var sResultado = ""

    switch (parseInt(Tarea)) {

        case 0:
   
            Response.Write("<br>" + Request.ServerVariables("PATH_INFO") + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[OK]")
            bPuedeVerDebug = true
            bDebug = true
            bOcurrioError = true
            DespliegaAlPie()
            var sResultado = '{"result":-1,"message":"No entro a ninguna tarea","Tarea":' + Tarea + '}'

        break;

        case 1:

            //Response.Write("Asignado A: " + iAudU_AsignadoA + " | sArrPTID: " + sArrPTID)
   
            try {
   
                var sSQL = "UPDATE Auditorias_Ubicacion SET AudU_AsignadoA = " + iAudU_AsignadoA
                    sSQL += " WHERE Aud_ID = " + iAud_ID
                    sSQL += " AND Pt_ID IN ( " + sArrPTID + ")"
                
                if(bDebugIQ){
   
                   Response.Write("sSQL: " + sSQL) 
   
                } else {
   
                    Ejecuta(sSQL,0)
                }
   
                iResultado = 1
   
			} 
			catch(err) {
				iResultado = 0
			}   
   
        break;


   

    }
   
   Response.Write(sResultado)
   
   
%>   
