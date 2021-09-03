<%
//Inicializacion de las variables de seguimiento para control de flujo de pantallas
function ValidaIpParaPermitirDebuguear() {

	var sHostIP = String(Request.ServerVariables("REMOTE_ADDR"))
	var sNombreCookie = "IqOnDebug_" + sHostIP
	var guid = String(Request.Cookies(sNombreCookie))
	try {
		var sABSQL = "select ISNULL((select 1 from DebugIP "
		   sABSQL += " where ip = '" + sHostIP + "' and Llave_GUID = '" + guid + "' ),0)"
	
		var rsAB = AbreTabla(sABSQL,1,2)
		if (!rsAB.EOF) {
		   bPuedeVerDebug = rsAB.Fields.Item(0).Value == 1 
		}
		rsAB.Close()
		bPuedeVerDebug = bPuedeVerDebug && bDebug == 1	
  } catch(err) {
 		var sABSQL = "delete from DebugIP where ip = '" + sHostIP + "' "
		Ejecuta(sABSQL,2)
  }
}

function LocalizaClientePorDominio() {

	//Cargo el sitio principal del dominio
	var sSrvNombre = String(Request.ServerVariables("SERVER_NAME"))
    var sABSQL = "select top 1 * from iqCliente " 
        sABSQL += " where iqCli_Dominio like '%" + sSrvNombre + "%' "
		//sABSQL += " AND iqCli_SitioPrincipal = 1 " 

	var bDebug = 0 

	var rsAB = AbreTabla(sABSQL,1,2)
	if (!rsAB.EOF) {
	    //si lo encontro, entonces se toman los datos
		SistemaActual = rsAB.Fields.Item("Sys_ID").Value
		iqCli_ID = rsAB.Fields.Item("iqCli_ID").Value 
		bDebug = rsAB.Fields.Item("iqCli_Debug").Value
		ParametroCambiaValor("SistemaActual",SistemaActual)
		ParametroCambiaValor("iqCli_ID",iqCli_ID)


		
	} else {
		//Parece que no encontro el dominio, entonces te entregara el principal
		var sABSQL = "select top 1 * from iqCliente " 
			sABSQL += " where iqCli_SitioPrincipal = 1 " 
	 
		var bDebug = 0 
	
		var rsAB = AbreTabla(sABSQL,1,2)
		if (!rsAB.EOF) {
			//si lo encontro, entonces se toman los datos
			SistemaActual = rsAB.Fields.Item("Sys_ID").Value
			iqCli_ID = rsAB.Fields.Item("iqCli_ID").Value 
			bDebug = rsAB.Fields.Item("iqCli_Debug").Value
			ParametroCambiaValor("SistemaActual",SistemaActual)
			ParametroCambiaValor("iqCli_ID",iqCli_ID)
		} else {			
		Response.Write("Ocurrio un error al tratar de buscar el dominio principal")	
		Response.End()
		//Uta llegaste hasta aqui entonces forzamos a que entre con el siguiente sistema
			SistemaActual = 10        //sistema por default
			iqCli_ID = 10
			VentanaIndex = -1
			bDebug = 0
			ParametroCambiaValor("SistemaActual",SistemaActual)
			ParametroCambiaValor("iqCli_ID",iqCli_ID)
			ParametroCambiaValor("VentanaIndex",VentanaIndex)	
			AgregaDebugBD("el domino tuvo que ser forzado","no se encontro en la configuracion")		
		}
	}
	
	
	//una vez encontrado el cliente y el sistema correcto se checa para debuguear y para sleeccionar la primera ventana
	if (bDebug == 1) {
		//si el debug esta habilitado busco las IP que pueden accesar
		 ValidaIpParaPermitirDebuguear()
	} else {
		bPuedeVerDebug = false
	}

	if(VentanaIndex == -1) {
		var sCondicion =  " Sys_ID = " + SistemaActual
			sCondicion += " AND Mnu_Habilitado = 1 "

		VentanaIndex =  BuscaSoloUnDato("min(Mnu_ID)","Menu",sCondicion,0,2)
		ParametroCambiaValor("VentanaIndex",VentanaIndex)	
	}

	return iqCli_ID

}

function UbicaBaseDeDatos(iqCL) {
	
if (EsVacio(iqCL)) {	
	iqCL = -1
}
	
if (iqCL == -1) {
	iqCL = LocalizaClientePorDominio()	
}

    var sABSQL = "select * from dbo.iqCliente "
        sABSQL += " where iqCli_ID = " + iqCL 

	var rsAB = AbreTabla(sABSQL,1,2)
	if (!rsAB.EOF) {
		//Faltaban en la base de datos las conexiones, las coloque pero veo que no existen los usuarios que tienen en la cadena de conexión
		
		arsODBC[0] = rsAB.Fields.Item("iqCli_ConexionStr").Value //datos
		arsODBC[1] = rsAB.Fields.Item("iqCli_ConexionStr1").Value //Log
		arsODBC[2] = sSQLCONStr02  //system
		arsODBC[3] = sSQLCONStr03  //acceso
		arsODBC[4] = rsAB.Fields.Item("iqCli_ConexionManual").Value  //manual		
		arsODBC[5] = rsAB.Fields.Item("iqCli_ConexionStr2").Value //Comunicacion
		arsODBC[6] = rsAB.Fields.Item("iqCli_ConexionQA").Value //QA
		/* 
		if ( EsVacio(rsAB.Fields.Item("iqCli_ConexionManual").Value) ) {
			arsODBC[4] = sSQLCONStr04
		} else {
			arsODBC[4] = rsAB.Fields.Item("iqCli_ConexionManual").Value
		}
		*/
		
	} else {
		//encontro todo mal se buscaran los defaults
		var sSrvNombre = String(Request.ServerVariables("SERVER_NAME"))
		var sABSQL = "select top 1 * from iqCliente " 
			sABSQL += " where iqCli_SitioPrincipal = 1 " 
	 
		var bDebug = 0 
	
		var rsAB = AbreTabla(sABSQL,1,2)
		if (!rsAB.EOF) {
			//si lo encontro, entonces se toman los datos
			SistemaActual = rsAB.Fields.Item("Sys_ID").Value
			iqCli_ID = rsAB.Fields.Item("iqCli_ID").Value 
			bDebug = rsAB.Fields.Item("iqCli_Debug").Value
			ParametroCambiaValor("SistemaActual",SistemaActual)
			ParametroCambiaValor("iqCli_ID",iqCli_ID)
			UbicaBaseDeDatos(iqCli_ID)
		} else {
			Response.Write("Verifique su configuracion no hay sitio default");
		}
	}
//	AgregaDebugBD("UbicaBaseDeDatos",arsODBC[0])		

}
	
//-----------------------------------------------------------------------------------------------------------------------------------------------
// Llenado de las variabes de control de flujo basico del programa


//Response.Write("<br> SistemaActual = " + SistemaActual )
//Response.End()

//es un nuevo acceso y hay que ubicar el sitio principal del dominio
if (SistemaActual < 1 ) {
	iqCli_ID = LocalizaClientePorDominio()
} 
	ValidaIpParaPermitirDebuguear()	
	UbicaBaseDeDatos(iqCli_ID)

%>
