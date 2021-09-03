<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../Includes/iqon.asp" -->
<% 
var sClave = Parametro("password","")
var sUsuario = Parametro("username","")
var SA = Parametro("SistemaActual",-1)
var Restriccion = "19,29"
var iqCli_ID = Parametro("iqCli_ID",0)
var IDUsuario = -1
var UsuarioTpo = ""
var UsuTipoUsuarioCG = -1
var sSQL = ""
var sSesion = Session.SessionID	
 
var sResultado = "Largo"

sClave   = sClave.replace(/'/g, "''")
sClave   = sClave.replace(/^\s+|\s+$/g,"");			   
sClave   = sClave.replace(/[^ -~]+/g, "");
sUsuario = sUsuario.replace(/'/g, "''")
sUsuario = sUsuario.replace(/^\s+|\s+$/g,"");   //tim
sUsuario = sUsuario.replace(/[^ -~]+/g, "");    //caracteres invisibles

if (sClave != "" && sUsuario != "") { 
 
	var sqlUSR  = " SELECT * FROM dbo.ufn_ValidaUsuario_Con_iqCli_ID('" + sUsuario + "','" 
	    sqlUSR += sClave + "', " + SA + "," + SA + ") "
//Response.Write(sqlUSR)
	var rsUSR = AbreTabla(sqlUSR,1,0)
	if (!rsUSR.EOF) { 
			bfing = true
		// validar ip, fechas y horarios
		//if( TieneAcceso == 0) { Response.Write("Cuenta Vencida") }
		//if( TieneAcceso == 0) { Response.Write("No tiene acceso") }
			var sIP = ""
				sIP = String(Request.ServerVariables("HTTP_X_FORWARDED_FOR"))
				if (EsVacio(sIP)) {
					sIP = String(Request.ServerVariables("REMOTE_HOST"))
				}
				
			sClave = "**"	
			IDUsuario = rsUSR.Fields.Item("IDUnica").Value   //puede ser usu_id del usuario, cli_id del cliente o del proveedor
			sResultado = "" + rsUSR.Fields.Item("Resultado").Value
			sUsuarioSes = rsUSR.Fields.Item("sUsuarioSes").Value 
			UsuarioTpo = rsUSR.Fields.Item("Usu_TipoUsuario").Value
			UsuTipoUsuarioCG = rsUSR.Fields.Item("Usu_TipoUsuarioCG61").Value
			SegGrupo = rsUSR.Fields.Item("Grupo_ID").Value   
			SistemaActual = rsUSR.Fields.Item("Sys_ID").Value
			iqCli_ID = rsUSR.Fields.Item("iqCli_ID").Value
			
			var sqlUSR = "Insert into UsuarioAcceso ( iqCli_ID, Sys_ID, Usu_ID, UsuA_IP, UsuA_Agente, UsuA_Sesion, UsuA_SesionVigente, UsuA_Grupo ) " 
			    sqlUSR += " Values (" + iqCli_ID + "," + SistemaActual + "," + IDUsuario
			    sqlUSR += ", '" + sIP + "'"
			    sqlUSR += ", '" + String(Request.ServerVariables("HTTP_USER_AGENT")) + "'"
			    sqlUSR += ", '" + String(sSesion) + "'"
//			if (SegIP_ModoAprendizaje) {
//			sqlUSR += ", 1 "
//			} else { 
//			sqlUSR += ", 0 "
//			}
//			sqlUSR += ", " + UsuarioTpo

                sqlUSR += ", 1, " + SegGrupo
			    sqlUSR += " )"
			//Response.Write("Registro de Acceso &nbsp;"+sqlUSR)
			Ejecuta(sqlUSR,3)
			//Response.End()
			//Response.Write("D&nbsp;"+sqlUSR)
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