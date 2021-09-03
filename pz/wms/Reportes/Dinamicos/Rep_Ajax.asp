<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%>
<!--#include file="../../../Includes/iqon.asp" -->
<%

var Tarea   = Parametro("Tarea",0)
var Cli_ID  = Parametro("Cli_ID",-1)
var sResultado = ""
		

 
switch (parseInt(Tarea)) {
		case 0:
			Response.Write("<br>" + Request.ServerVariables("PATH_INFO") + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[OK]")
			bPuedeVerDebug = true
			bDebug = true
			bOcurrioError = true
			DespliegaAlPie()
		break; 
		
		case 1:	// Carga Proveedores del cliente
			sResultado = '{'
			try {  
				var sSQL = "SELECT CliPrv_ID, CliPrv_Nombre "
					sSQL += " FROM Cliente_Proveedor "
					sSQL += " WHERE Cli_ID = " + Cli_ID
				
				var rsRS = AbreTabla(sSQL,1,0)

				if (!rsRS.EOF){
                    sResultado += '"CliPrv_ID":"' + rsRS.Fields.Item("CliPrv_ID").Value + '"'
                    sResultado += ',"CliPrv_Nombre":"' + rsRS.Fields.Item("CliPrv_Nombre").Value + '"'			    
				}
				rsRS.Close()
 
			} catch(err) {
				sResultado += "error"
			}		
			 
			sResultado += '}'
			Response.Write(sResultado)
		break; 
        
}

%>