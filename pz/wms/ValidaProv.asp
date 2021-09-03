<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../Includes/iqon.asp" -->
<% 
var sClave = Parametro("password","")
var sUsuario = Parametro("username","")
var SA = 27 //Parametro("SistemaActual",-1)
var Restriccion = "27"
var iqCli_ID = Parametro("iqCli_ID",0)
var IDUsuario = -1
var UsuarioTpo = ""
var UsuTipoUsuarioCG = -1
var sSQL = ""
var sSesion = Session.SessionID	
 
var sResultado = "Largo"
   
sClave   = sClave.replace(/'/g, "''")
sUsuario = sUsuario.replace(/'/g, "''")
   
 
if (sClave != "" && sUsuario != "") { 
 
	var sqlUSR  = " SELECT dbo.ufn_Valida_Transportista('" + sUsuario + "'"
                + ",'" + sClave + "', " + SA + "," + SA + ") as Resultado "

	var rsUSR = AbreTabla(sqlUSR,1,0)
	if (!rsUSR.EOF) { 

			var sIP = ""
				sIP = String(Request.ServerVariables("HTTP_X_FORWARDED_FOR"))
				if (EsVacio(sIP)) {
					sIP = String(Request.ServerVariables("REMOTE_HOST"))
				}
				
			sClave = "**"	
			sResultado = "" + rsUSR.Fields.Item("Resultado").Value
		
			
//			var sqlUSR = "Insert into UsuarioAcceso ( iqCli_ID, Sys_ID, Usu_ID, UsuA_IP, UsuA_Agente, UsuA_Sesion, UsuA_SesionVigente, UsuA_Grupo ) " 
//			    sqlUSR += " Values (" + iqCli_ID + "," + SistemaActual + "," + IDUsuario
//			    sqlUSR += ", '" + sIP + "'"
//			    sqlUSR += ", '" + String(Request.ServerVariables("HTTP_USER_AGENT")) + "'"
//			    sqlUSR += ", '" + String(sSesion) + "'"
//			if (SegIP_ModoAprendizaje) {
//			sqlUSR += ", 1 "
//			} else { 
//			sqlUSR += ", 0 "
//			}
//			sqlUSR += ", " + UsuarioTpo
//
//                sqlUSR += ", 1, " + SegGrupo
//			    sqlUSR += " )"
//			//Response.Write("Registro de Acceso &nbsp;"+sqlUSR)
//			Ejecuta(sqlUSR,3)
//			//Response.End()
//			//Response.Write("D&nbsp;"+sqlUSR)
//			if (SegIP_ModoAprendizaje == false) {
//				var TieneAcceso = BuscaSoloUnDato(" dbo.fun_ValidaIPdeEntrada(1, 1001, " + rsUSR.Fields.Item("Usu_ID").Value +", '" + sIP + "')","ControlAcceso","CA_ID = 1",0,0)
//				if (TieneAcceso == 0) {
//					sResultado = "IP sin Acceso permitido"
//				}
//			} 
				
	}
	rsUSR.Close()
}

	ParametroCambiaValor("Clave","******")
	Response.Write(sResultado)
%>