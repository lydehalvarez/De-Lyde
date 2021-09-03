<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
    
<%    
   
    var ibQ4Web = true
    var Tarea = Parametro("Tarea",0)
    var iUsu_ID = Parametro("Usu_ID",-1)
    
    var sUsu_Nombre = decodeURIComponent(Parametro("Usu_Nombre",""))
    var sUsu_Usuario = decodeURIComponent(Parametro("Usu_Usuario",""))
    var sUsu_Password = decodeURIComponent(Parametro("Usu_Password",""))
    var sUsu_Email = decodeURIComponent(Parametro("Usu_Email",""))
    var sUsu_Descripcion = decodeURIComponent(Parametro("Usu_Descripcion",""))
   
    var sCond = ""
         sCond = " Usu_ID = dbo.fn_Usuario_DameIDUsuarioConIDUnico(" + iUsu_ID + ")"
    var sSQL = ""
   
   
	var sResultado = ""

	if (ibQ4Web) { Response.Write("Tarea:" + Tarea + "<br />") }   
   if (ibQ4Web) { Response.Write("iUsu_ID:" + iUsu_ID + "<br />") }   
   
  
   switch (parseInt(Tarea)) {
   
  		case 1:
			//Existe en la tabla 
			var iRegExiste = BuscaSoloUnDato("ISNULL(COUNT(*),0)","Usuario",sCond,0,0)
		    //Response.Write(iRegExiste)
			try {
		
				//Al llegar a este punto es porque el registro existe 
				
				if(parseInt(iRegExiste) > 0) {

					sSQL = "UPDATE Usuario SET Usu_Nombre = '" + sUsu_Nombre + "', Usu_Usuario = '" + sUsu_Usuario + "',"
                    sSQL += "Usu_Password = '" + sUsu_Password + "', Usu_Email = '" + sUsu_Email + "',"
                    sSQL += "Usu_Descripcion = '" + sUsu_Descripcion + " '"
                    sSQL += " WHERE " + sCond
		            if (ibQ4Web) { Response.Write(sSQL + "<br />") }
					Ejecuta(sSQL,0)
						
					sResultado = 1
    
				} else {
						
					sResultado = 0
				}
				
		
			} catch(err) {
				
					sResultado = -1
					
			}		
			
			Response.Write(sResultado)
		
		break; 
   
   
   
   
   
   
   
   }
   
   
   
   
%>
