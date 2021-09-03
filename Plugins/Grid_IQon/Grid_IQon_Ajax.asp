<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../Includes/iqon.asp" -->
<%
//var sRQ = Request.QueryString()
//var sRF = Request.Form()
//Response.Write("<br>$RQ " + sRQ)
//Response.Write("<br>$RF " + sRF)

//CargaParametrosDesdeArreglo(String(sRQ))

	var iIQonDebug = 0
	//if (Parametro("IDUsuario",Session("IDUsuario")) == 358) {
//		iIQonDebug = 0
//	}
//Debug_ImprimeParametros("en el plugin de iqon")
//	LeerParametrosdeBD()

	//var SistemaActual = Parametro("SistemaActual",0)
	//var VentanaIndex  = Parametro("VentanaIndex",0)
	//var IDUsuario     = Parametro("IDUsuario",-1)
	//var UsuarioTpo    = Parametro("UsuarioTpo","")
	//var SegGrupo      = Parametro("SegGrupo",0)
	//ParametroCambiaValor("UsuarioTpo",UsuarioTpo)
	//ParametroCambiaValor("SegGrupo",SegGrupo)
if (iIQonDebug == 1) { 
	Response.Write("<br>-----------------------------------------" )
	Response.Write("<br>SistemaActual = " + SistemaActual ) 
	Response.Write("<br>VentanaIndex = " + VentanaIndex ) 
    Response.Write("<br>IDUsuario = " + IDUsuario ) 
	Response.Write("<br>UsuarioTpo = " + UsuarioTpo ) 
	Response.Write("<br>SegGrupo = " + SegGrupo + "<br>") 

}
	//var iWgCfg_ID = String(Session("WgCfg_ID")) //           Parametro("WgCfgID",0)
	var iWgCfg_ID = Parametro("WgCfg_ID",0)
	//ParametroCambiaValor("WgCfg_ID",iWgCfg_ID)
	//var iWgt_ID         = Session("Wgt_ID") //25 //Parametro("iWgt_ID",0)
	if (iWgCfg_ID == 0 ) {
		var sConddv = "Wgt_ID = 25 and Sys_ID = " + SistemaActual + " and Mnu_ID = " + VentanaIndex
		iWgCfg_ID = BuscaSoloUnDato("WgCfg_ID","Menu_Widget",sConddv,0,2)
	}

	var iWgt_ID = Parametro("Wgt_ID",25)
	//ParametroCambiaValor("Wgt_ID",iWgt_ID)
	//var iqCli_ID      = Parametro("iqCli_ID",-1)
//	var AccionDePaginacion = Parametro("AccionDePaginacion",0)

	var strTmp = ""
if (iIQonDebug == 1) { 
	Response.Write("<br>iWgCfg_ID " + iWgCfg_ID ) 
	Response.Write("<br>iWgCfgID " + iWgCfgID ) 
    Response.Write("<br>iWgt_ID " + iWgt_ID + "<br>") 

}
//Importante:
// cuando el campo tenga como prefijo una tabla ej clientes.Cli_ID  debera usarse un alias forzosamente

	var sEncabezado    = ""
	var sPaginacion    = ""
	var iCampos        = -1
//	var grdCampo       = new Array(0)         //  estos son los campos que se mostraran en el grid
//	var grdNombre      = new Array(0)        //   como es una vista o una consulta pueden ser de varias tablas sin problema
//	var grdAlias       = new Array(0)       //    en caso de haber una inconsistencia del tipo campo duplicado entonces se debera usar un alias para los campos
//	var grdTipo        = new Array(0)	   //     pero esto solo se pondra en la configuracion no aqui
//	var grdAncho       = new Array(0)
//	var grdAlineacion  = new Array(0)
//	var grdClass       = new Array(0)
	
	var iCamposO       = -1                    // los campos ocultos son variables que se quiere mantener en el grid para que sean transferidas a otra ventana al submit
	var ocultoNombre   = new Array(0)         //  pudieran ser llaves pero estos campos NO son considerados en la seccion del where
	var ocultoParam    = new Array(0)        //   para las llaves usar la seccion que sigue, estos son campos del tipo usuario id  sistema id algun estatus 
	var ocultoPP       = new Array(0)	    //    pero no son campos que pudieran pertenecer a una columna ya que no serian unicos
	
	var iCamposLL      = -1                    // Aqui se enumeran los campos que son llave
	var LLaveCampo     = new Array(0)         //  los campos de llave seran colocados como ocultos con el valor general         
	var LLavePP        = new Array(0)        //   la llave primaria sera colocada en cada renglon para distinguir la diferencia
	var LLavePK        = new Array(0)       //    y usarla en las funciones, al hacer submit los ocultos mas esta PK haran la indicacion exacta
	var LLaveValor     = new Array(0)      //     estos campos seran insertados en la seccion del where
	var LLaveFormato   = new Array(0)
	var LLaveCondicion = new Array(0)
	var LLavePrefijo   = new Array(0)
	var LLaveHeredada  = new Array(0)   //esta llave entra por los parametros de condicion y es agregada al arreglo para tomar sus  datos
	                                    //pero no puede ser usada porque es posible que no este en el arreglo de campos del query

	
	var iCamposBus        = -1
	var grdCampoBus       = new Array(0)
	var grdTipoCampoBus   = new Array(0)
	var grdValorDefBus    = new Array(0)
	var grdValor          = new Array(0)
	var grdVisible        = new Array(0)
	var grdIDCatGralBus   = new Array(0)
	var grdCboTablaBus    = new Array(0)
	var grdEsBusqEstricta = new Array(0)
	

	var sLLavePrimariaCampo    = ""
	var sLLavePrimaria         = ""
	var sLLavePrimariaHeredada = ""
	
	var SQLTabla      = ""
	var SQLCondicion  = ""
	var SQLOrden      = ""
	var sConsultaGral = ""
	var MW_NombreDIV = ""
	var iSQLVieneDeBuscador = -1
	var iAbrirNuevaVentana  = 0
	var iMWPuedeSeleccionar = 0
	var iSiguienteVentana = 0
	var CampoOrden    = ""	
	var CampoLlave    = ""
	var bCpoLL        = false
	var sqCampoLlave  = ""
	var sqCampoLlavePrefijo  = ""
	var ig            = 0
	var igr           = 0
	var iRengPintados = 0
	var iUltimoNoRenglon = 0
	var sClassEncabezado = ""
	
	var iRegPorPagina = Parametro("RegPorVentana",RegPorVentana)  
	var iRegistros    = 0
	var iRegistrosImpresos = 0
	var iPagina       = 1
	var iPag          = 0
	var bLoBusco      = false
	var LlaveABuscar  = 0
	
	var arrLLaves  = ""  // estructura=   Campo,Alias,EsPermanente,UsarParaConsulta,EsPrimaria,Tipo
	var arrCampos  = ""  //               Nombre,Campo,Alias,Ancho,Alineacion,Clase,Orden,Tipo,Visible
	var arrOcultos = ""  //               Campo,EsPermanente
	var arrOrden   = ""  //               Campo/Alias,Orden


	var sSQLConfBase = " select MW_Param, MW_NombreDIV, MW_PuedeAgregar, MW_PuedeBorrar, MW_PuedeEditar, MW_AlSeleccionarAbrirNuevaVentana "
		sSQLConfBase += " from Menu_Widget "
		sSQLConfBase += " WHERE Sys_ID = " + SistemaActual
		sSQLConfBase += " AND Mnu_ID = "   + VentanaIndex
		sSQLConfBase += " AND Wgt_ID = "   + iWgt_ID
		sSQLConfBase += " AND WgCfg_ID = " + iWgCfg_ID
	
	var rsConfBase = AbreTabla(sSQLConfBase,1,2)
	if (!rsConfBase.EOF){
	    iAbrirNuevaVentana = rsConfBase.Fields.Item("MW_AlSeleccionarAbrirNuevaVentana").Value
		MW_NombreDIV = rsConfBase.Fields.Item("MW_NombreDIV").Value
	}
	rsConfBase.Close()

	//Para saber si puede seleccionar debemos consultar si se cuenta con el permiso de ir a esa ventana
	//se habilitara una funcion
	var sSQLDtBs = "SELECT * "
		sSQLDtBs += " FROM Menu "
		sSQLDtBs += " WHERE Sys_ID = " + SistemaActual
		sSQLDtBs += " AND Mnu_ID = " + VentanaIndex

	var rsSQLDtBs = AbreTabla(sSQLDtBs,1,2)
	if (!rsSQLDtBs.EOF){
		iSiguienteVentana = rsSQLDtBs.Fields.Item("Mnu_SiguienteVentana").Value
	}
	rsSQLDtBs.Close()
	if (iSiguienteVentana > 0) {
		var sSQLDtBs = "select dbo.ufn_DimeSiElUsuarioTieneAcceso("
			sSQLDtBs += " " + IDUsuario
			sSQLDtBs += ", ''" //+ UsuarioTpo
			sSQLDtBs += ", " + iSiguienteVentana
			sSQLDtBs += ", " + SistemaActual
			sSQLDtBs += ", " + SegGrupo
			sSQLDtBs += ", " + iqCli_ID + " )"
	
		var rsSQLDtBs = AbreTabla(sSQLDtBs,1,2)
		if (!rsSQLDtBs.EOF){
			iMWPuedeSeleccionar = rsSQLDtBs.Fields.Item(0).Value
		}
		rsSQLDtBs.Close()	
	}
	Session("NxSelecct") = iMWPuedeSeleccionar

//Response.Write("<BR>IDUsuario " + IDUsuario + ", UsuarioTpo " + UsuarioTpo + ", @iMnuIDSiguiente " + IDUsuario + ", SistemaActual " + SistemaActual + ", SegGrupo " + SegGrupo + ", iqCli_ID " + iqCli_ID )
	//IniciaDebugBD()
	
	//Inicializa Tabla de trabajo
	//Carga la informacion existente de el registro basico, si no hubiera la genera
		//iqCli_ID, SysLog_ID y SysLogCat_ID, daran las configuraciones personalizadas y para el generico estaran en -1
		//WgCfgC_ID = 0 es la primera configuracion basica, arriba de 0 son las configuraciones genericas
		
	var bTTConfigurado = false	
	var sSQLTTLlaves = " iqCli_ID = "      + iqCli_ID
		sSQLTTLlaves += " AND Sys_ID = "   + SistemaActual
		sSQLTTLlaves += " AND WgCfg_ID = " + iWgCfg_ID
		sSQLTTLlaves += " AND Mnu_ID = "   + VentanaIndex
		sSQLTTLlaves += " AND Wgt_ID = "   + iWgt_ID
		sSQLTTLlaves += " AND SysLog_ID = -1 "                // se carga la configuracion generica pero se pueden generar configuraciones personalizadeas
		sSQLTTLlaves += " AND SysLogCat_ID = -1 "
		sSQLTTLlaves += " AND WgCfgC_ID = 0 "
	if (iIQonDebug == 1) { Response.Write("<br>sConsultaGral " + sSQLTTLlaves + "<br>") }
	var sSQLTT = " Select * from Widget_Configuracion_Complemento "	
		sSQLTT += " Where " + sSQLTTLlaves
	if (iIQonDebug == 1) {Response.Write("<br />sSQLTT " + sSQLTT)	}
	var rsSQLTT = AbreTabla(sSQLTT,1,2)
	if (!rsSQLTT.EOF){
		bTTConfigurado = true
		arrLLaves  = String(rsSQLTT.Fields.Item("WgCfgC_Atributo1").Value)
		if (EsVacio(arrLLaves)) { bTTConfigurado=false } 
		arrCampos  = String(rsSQLTT.Fields.Item("WgCfgC_Atributo2").Value)
		if (EsVacio(arrCampos)) { bTTConfigurado=false } 
		arrOcultos = String(rsSQLTT.Fields.Item("WgCfgC_Atributo5").Value)
		//if (arrOcultos == "") { bTTConfigurado=false } 
		arrOrden   = String(rsSQLTT.Fields.Item("WgCfgC_Atributo4").Value)
		//if (arrOrden == "") { bTTConfigurado=false } 
	} 
	rsSQLTT.Close()

	//if (iIQonDebug == 1) {Response.Write("<br>bTTConfigurado " + bTTConfigurado + "<br>") }

	if (!bTTConfigurado) {  
		var sSQLTT = " Delete from Widget_Configuracion_Complemento "
			sSQLTT += " Where " + sSQLTTLlaves
		
		Ejecuta(sSQLTT,2)
		//if (iIQonDebug == 1) {Response.Write("<br><br>Inicializando " + sSQLTT + "<br>") }
	
		var sSQLTT = "Insert Into Widget_Configuracion_Complemento "
			sSQLTT += " ( iqCli_ID, Sys_ID, Mnu_ID, SysLog_ID, SysLogCat_ID, Wgt_ID, WgCfg_ID,  WgCfgC_ID ) "
			sSQLTT += " Values ( "
			sSQLTT += iqCli_ID + ", "  + SistemaActual + ", " + VentanaIndex + ", -1, -1, " 
			sSQLTT += iWgt_ID + ", " + iWgCfg_ID + ", 0 " 
			sSQLTT += " ) "
		
		if ( SistemaActual > 0 ) { Ejecuta(sSQLTT,2) }
		
		//if (iIQonDebug == 1) {Response.Write("<br />base de configuracion almacenada " + sSQLTT)	}
	
	
	// ======== LEE LOS CAMPOS QUE FORMAN EL ENCABEZADO Y LOS QUE MOSTRARAN LA INFORMACIÓN

		var sATCps = "SELECT * "
			sATCps += " ,ISNULL((Select PP_Nombre "
			sATCps +=           "  from ParametrosPermanentes "
			sATCps +=           " where ParametrosPermanentes.PP_Nombre = MenuGridCampos.MGrd_Campo "
			sATCps +=           "   and Sys_ID = " +  SistemaActual 
		    sATCps +=           "   and PP_Seccion = (select Mnu_UsarPP from Menu "
		    sATCps +=                                " where Sys_ID = " + SistemaActual
		    sATCps +=                                " and Mnu_ID = " + VentanaIndex + ") " 
			sATCps +=           "   and PP_Habilitado = 1),'No') as PP "  //mapeo los campos contra los parametros permanentes
			sATCps += "  FROM MenuGridCampos "
			sATCps += " WHERE MGrd_Habilitado = 1 "
			sATCps += "   AND Sys_ID = " + SistemaActual
			sATCps += "   AND WgCfg_ID = " + iWgCfg_ID
			//sATCps += "    AND Mnu_ID = " + VentanaIndex
			sATCps += " ORDER BY MGrd_Orden "
				
			if (iIQonDebug == 1) { Response.Write("<br>Campos_Encabezado_Info " + sATCps + "<br />") }
	
		var rsEnc = AbreTabla(sATCps,1,2)
		while (!rsEnc.EOF){
			if (rsEnc.Fields.Item("MGrd_EsLlave").Value == 1 || rsEnc.Fields.Item("MGrd_EsLlavePrimaria").Value == 1) {
				if (arrLLaves != "" ) { arrLLaves += "|" } 
				//Prefijo,Campo,Alias,EsPermanente,UsarParaConsulta,EsPrimaria,Tipo,EsOculta
				arrLLaves += "" + FiltraVacios(rsEnc.Fields.Item("MGrd_TablaPrefijo").Value) + "{"
				arrLLaves += "" + rsEnc.Fields.Item("MGrd_Campo").Value + "{"
				arrLLaves += "" + rsEnc.Fields.Item("MGrd_Alias").Value + "{"
				arrLLaves += "" + rsEnc.Fields.Item("PP").Value + "{"
				arrLLaves += "" + rsEnc.Fields.Item("MGrd_UsarParaConsulta").Value + "{"
				arrLLaves += "" + rsEnc.Fields.Item("MGrd_EsLlavePrimaria").Value + "{" 
				arrLLaves += "" + rsEnc.Fields.Item("MGrd_TipoCampo").Value + "{"
				arrLLaves += "" + rsEnc.Fields.Item("MGrd_EsCampoOculto").Value

			} else {
				if ( rsEnc.Fields.Item("MGrd_EsCampoOculto").Value == 0 ) {
					//Nombre,Prefijo,Campo,Alias,Ancho,Alineacion,Clase,Orden,Tipo,Visible
					iCampos++
					if (arrCampos != "" ) { arrCampos += "|" } 
					arrCampos += "" + rsEnc.Fields.Item("MGrd_Nombre").Value + "{"
					arrCampos += "" + FiltraVacios(rsEnc.Fields.Item("MGrd_TablaPrefijo").Value) + "{"
					arrCampos += "" + rsEnc.Fields.Item("MGrd_Campo").Value + "{"
					arrCampos += "" + rsEnc.Fields.Item("MGrd_Alias").Value + "{"
					arrCampos += "" + rsEnc.Fields.Item("MGrd_AnchoColumna").Value + "{"
					arrCampos += "" + rsEnc.Fields.Item("MGrd_Alineacion").Value + "{"
					arrCampos += "" + rsEnc.Fields.Item("MGrd_Class").Value + "{"
					arrCampos += "" + iCampos + "{"
					arrCampos += "" + rsEnc.Fields.Item("MGrd_TipoCampo").Value + "{"
					arrCampos += "" + rsEnc.Fields.Item("MGrd_Visible").Value 
				} else { 
					//Prefijo,Campo,EsPermanente
					if (arrOcultos != "" ) { arrOcultos += "|" } 
					arrOcultos += "" + FiltraVacios(rsEnc.Fields.Item("MGrd_TablaPrefijo").Value) + "{"
					arrOcultos += "" + rsEnc.Fields.Item("MGrd_Campo").Value + "{"
					arrOcultos += "" + rsEnc.Fields.Item("PP").Value 
				}
			}			
			if (rsEnc.Fields.Item("MGrd_UsarParaOrdenar").Value > 0 ) {
				//Prefijo,Campo,Orden
				if (arrOrden != "" ) { arrOrden += "|" }
				arrOrden += "" + FiltraVacios(rsEnc.Fields.Item("MGrd_TablaPrefijo").Value) + "{"
				arrOrden += "" + rsEnc.Fields.Item("MGrd_Campo").Value + "{"
				arrOrden += "" + rsEnc.Fields.Item("MGrd_UsarParaOrdenar").Value
			}
			
			rsEnc.MoveNext()
		}

		var sSQLTT  = " Update Widget_Configuracion_Complemento Set "
			sSQLTT += "  WgCfgC_Atributo1 = '" + arrLLaves + "'"
			sSQLTT += ", WgCfgC_Atributo2 = '" + arrCampos + "'"
			sSQLTT += ", WgCfgC_Atributo5 = '" + arrOcultos + "'" 
			sSQLTT += ", WgCfgC_Atributo4 = '" + arrOrden + "'"
			sSQLTT += " Where " + sSQLTTLlaves
			//if (iIQonDebug == 1) {Response.Write("<br />Guardando arreglos " + sSQLTT)}
			Ejecuta(sSQLTT,2)
	}	

	if (iIQonDebug == 1) {
		Response.Write("<br /><font color='red'><strong>Arreglos</strong></font><br />")
		Response.Write("<br />Campo,Alias,EsPermanente,UsarParaConsulta,EsPrimaria,Tipo")
		Response.Write("<br />arrLLaves = " + arrLLaves + "<br />")
		
		Response.Write("<br />Nombre,Campo,Alias,Ancho,Alineacion,Clase,Orden,Tipo,Visible")
		Response.Write("<br />arrCampos = " + arrCampos + "<br />")
		
		Response.Write("<br />Campo,EsPermanente")
		Response.Write("<br />arrOcultos = " + arrOcultos + "<br />")
		
		Response.Write("<br />Campo/Alias,Orden")
		Response.Write("<br />arrOrden = " + arrOrden  + "<br />")
	}

//Armado de arreglos

	var arrLLSec  = new Array(0)
	var arrLL     = new Array(0)
	if (iIQonDebug == 1) {Response.Write("<br>arrLLaves " + arrLLaves + "<br>") }
	if (!EsVacio(arrLLaves) ) {
		arrLLSec = arrLLaves.split("|")
		for (j=0;j<arrLLSec.length;j++) {
			var Txt = String(arrLLSec[j])
			var arrLL = Txt.split("{")
			//if (iIQonDebug == 1) {Response.Write("<br />arrLL = " + arrLL  + "<br />")}
			//   0      1     2        3             4               5       6      7
			//Prefijo,Campo,Alias,EsPermanente,UsarParaConsulta,EsPrimaria,Tipo,EsOculta
			LLavePrefijo[j]   = arrLL[0]
			LLaveCampo[j]     = arrLL[1]
			LLavePP[j]        = arrLL[3]
			LLaveCondicion[j] = arrLL[4]
			LLavePK[j]        = arrLL[5]    // solo debera ser un campo llave primaria y solo se usara el primero
			LLaveFormato[j]   = arrLL[6]
			LLaveHeredada[j]  = 0
			LLaveValor[j]     = "" + FiltraVacios(Parametro(String(LLaveCampo[j]),""))  //la cargo con el valor que venga volando
		}
	}
	iCamposLL = LLaveCampo.length - 1
	if (iIQonDebug == 1) {Response.Write("<br />iCamposLL = " + iCamposLL  + "<br />")}

	var sCondicionPorParametro = ""   //  para arreglo de condiciones posicion: 1= campo 2=nombreparametreo 3=ValorDefault 4=formato separado por comas y pipes
	                                 //   ejemplos; Cli_ID,Cli_ID,-1,N|Cont_ID,Cont_ID,-1,N|Dir1_ID,Cli_ID,-1,N este ultimo transfiero a dir1 el valor de cliid		
									//    si el valor viene en -1 no es coniderado como elemento de busqueda en la consulta	
								   //	  NOTA: Solo estos parametros se usaran en el where de la consulta
	
	var sATTb = "SELECT * "
		sATTb += " FROM MenuGridTablas "
		sATTb += " WHERE  Sys_ID = " + SistemaActual
		sATTb += " AND WgCfg_ID = " + iWgCfg_ID
		//sATTb += " AND Mnu_ID = " + VentanaIndex

	if (iIQonDebug == 1) {Response.Write("<br />sATTb = " + sATTb  + "<br />")}
	var rsEncTB = AbreTabla(sATTb,1,2)
	if (!rsEncTB.EOF){
			iSQLVieneDeBuscador    = rsEncTB.Fields.Item("MGrdT_VieneDeBuscador").Value
			if (iIQonDebug == 1) {Response.Write("<br />iSQLVieneDeBuscador = " + iSQLVieneDeBuscador  + "<br />")}
			sCondicionPorParametro = FiltraVacios(rsEncTB.Fields.Item("MGrdT_CondicionPorParametro").Value)	
			if (iIQonDebug == 1) {Response.Write("<br />sCondicionPorParametro = " + sCondicionPorParametro  + "<br />")}
			SQLTabla               = FiltraVacios(rsEncTB.Fields.Item("MGrdT_SQLTabla").Value)
			if (iIQonDebug == 1) {Response.Write("<br />SQLTabla = " + SQLTabla  + "<br />")}
	}
	rsEncTB.Close()
	if (iIQonDebug == 1) {Response.Write("<br />iSQLVieneDeBuscadorII = " + iSQLVieneDeBuscador  + "<br />")}
	var arrCampo      = new Array(0)           //   el valor que puede recibir es el de un oculto de la pagina que le precede o de 
	var arrPrmCPP     = new Array(0)          //    un parametro permanente
	var bEnc = false

	if (!EsVacio(sCondicionPorParametro) ) {
		//se extraen los parametros que se envian
		arrPrmCPP = sCondicionPorParametro.split("|")
		for (j=0;j<arrPrmCPP.length;j++) {
			bEnc = false
			var Txt = String(arrPrmCPP[j])
			var arrCampo = Txt.split(",")
			//se buscan y aplican a el arreglo de llaves
			for (hi=0;hi<LLaveCampo.length;hi++) {	
				if (LLaveCampo[hi] == arrCampo[0]) {
					bEnc = true
					LLaveCondicion[hi] = 1
					var sValTmp = "" + FiltraVacios(Parametro(String(arrCampo[1]),String(arrCampo[2])))
					LLaveValor[hi] = String(sValTmp);
					LLaveFormato[hi] = String(arrCampo[3])
				}
			}
			if (!bEnc) {
				iCamposLL++		
				LLavePrefijo[iCamposLL]   =	""
				LLaveCampo[iCamposLL]   = arrCampo[0]
				LLaveCondicion[iCamposLL] = 1
				LLavePP[iCamposLL]      = "No"               //si el parametro fuera permanente seria ignorado y escrito por el parametro condicionado
				LLavePK[iCamposLL]      = 0                  //porque por del el valor cae y si lo obligas es porque necesitas cambiarlo
				LLaveValor[iCamposLL]   = FiltraVacios(Parametro(String(arrCampo[1]),String(arrCampo[2])))   //la cargo con el valor indicado
				LLaveFormato[iCamposLL] = arrCampo[3]	
				LLaveHeredada[iCamposLL]  = 1
			}
		}
	}
	
	//if (iIQonDebug == 1) {Response.Write("<br />arreglo de llaves OK = " + iCamposLL  + "<br />")}

	for (t=0;t<LLaveCampo.length;t++) {
		if (!EsVacio(LLaveValor[t]) && LLaveValor[t] != "-1" && LLaveCondicion[t] == 1) {
			if (SQLCondicion != "") { SQLCondicion += "|" }
			SQLCondicion += LLaveCampo[t] + ":" + LLaveValor[t]
			//pendiente falta poner el tipo de dato N=numero F=fecha T=texto para clavarle unas comillas o el formato de fecha
		}	
	}
	
var sCondBus = ""	
	
	if (iIQonDebug == 1) {
		//Response.Write("<br />417 SQLCondicion = " + SQLCondicion  + "<br />")
		AgregaDebugBD("417 SQLCondicion ",SQLCondicion)	
		}	

	//if (iIQonDebug == 1) {Response.Write("<br />Armando criterios de busqueda con sqCampoLlavePrefijo " + sqCampoLlavePrefijo + "<br />")}

		if ( iSQLVieneDeBuscador > 0 ) {
				var sSQLCamposBus  = " SELECT * FROM MenuFichaCampos "
					sSQLCamposBus += " WHERE MFC_Habilitado = 1 "
					sSQLCamposBus += "  AND WgCfg_ID = " + iSQLVieneDeBuscador
					sSQLCamposBus += "  AND Sys_ID = " + SistemaActual
					
				if (iIQonDebug == 1) {
					//Response.Write("<br />427 Campos de busqueda sSQLCamposBus = " + sSQLCamposBus  + "<br />")
					AgregaDebugBD("427 Campos de busqueda sSQLCamposBus ",sSQLCamposBus)	
					}
				var rsSQLCamposBus = AbreTabla(sSQLCamposBus,1,2)
				
				while (!rsSQLCamposBus.EOF){
					iCamposBus++
					grdCampoBus[iCamposBus]  		= rsSQLCamposBus.Fields.Item("MFC_Campo").Value
					//if (iIQonDebug == 3) {Response.Write("<br />MFC_Campo = " + grdCampoBus[iCamposBus]  + "<br />")}
					grdTipoCampoBus[iCamposBus] 	= rsSQLCamposBus.Fields.Item("MFC_TipoCampo").Value
//					if (grdTipoCampoBus[iCamposBus] == 12 ) { 
//						grdTipoCampoBus[iCamposBus] = rsSQLCamposBus.Fields.Item("MFC_Formato").Value              // Los campos que estan insertados en un div
//					    grdCampoBus[iCamposBus] = rsSQLCamposBus.Fields.Item("MFC_ComboCampoLlave").Value         //  deberan tener en MFC_Formato el tipo de campo que es
//					}
					//if (iIQonDebug == 3) {Response.Write("<br />MFC_TipoCampo = " + grdTipoCampoBus[iCamposBus]  + "<br />")}
					grdValorDefBus[iCamposBus]  	= FiltraVacios(rsSQLCamposBus.Fields.Item("MFC_ValorDefault").Value)
					//if (iIQonDebug == 1) {Response.Write("<br />MFC_ValorDefault = " + grdValorDefBus[iCamposBus]  + "<br />")}
					if ( grdTipoCampoBus[iCamposBus] == 5 && EsVacio(grdValorDefBus[iCamposBus])) {
						grdValorDefBus[iCamposBus] = 0
					}
					grdIDCatGralBus[iCamposBus]     = rsSQLCamposBus.Fields.Item("MFC_IDCatalogoGeneral").Value
					//if (iIQonDebug == 3) {Response.Write("<br />MFC_IDCatalogoGeneral = " + grdIDCatGralBus[iCamposBus]  + "<br />")}
					grdCboTablaBus[iCamposBus]      = rsSQLCamposBus.Fields.Item("MFC_ComboTabla").Value
					//if (iIQonDebug == 3) {Response.Write("<br />MFC_ComboTabla = " + grdCboTablaBus[iCamposBus]  + "<br />")}
					grdEsBusqEstricta[iCamposBus]	= rsSQLCamposBus.Fields.Item("MFC_EsBusqEstricta").Value
					//if (iIQonDebug == 3) {Response.Write("<br />MFC_EsBusqEstricta = " + grdEsBusqEstricta[iCamposBus]  + "<br />")}
					grdValor[iCamposBus]            = Parametro(grdCampoBus[iCamposBus],grdValorDefBus[iCamposBus])
					//if (iIQonDebug == 3) {Response.Write("<br />grdValor = " + grdValor[iCamposBus]  + "<br />")}
					//if (iIQonDebug == 3) {Response.Write("<br />grdCampoBus[iCamposBus] = " + Parametro(grdCampoBus[iCamposBus],grdValorDefBus[iCamposBus])  + "<br />")}	
					rsSQLCamposBus.MoveNext()
				}
				
				rsSQLCamposBus.Close()

				for(igB=0;igB<grdCampoBus.length;igB++){
					if (grdValor[igB] != "") {
						if (grdTipoCampoBus[igB] == 1 ) {
							if ( sCondBus != "") { sCondBus += "|" }
							sCondBus += grdCampoBus[igB]
							if (grdEsBusqEstricta[igB] == 1) {
								sCondBus += ":¬" + grdValor[igB]  +"¬"
							} else {
								sCondBus += ":¬%" + grdValor[igB] +"%¬"
							}
						}				
	
						if (grdTipoCampoBus[igB] == 7 || grdTipoCampoBus[igB] == 4) {
							if (grdValor[igB] > -1) {
								if ( sCondBus != "") { sCondBus += "|" }
								sCondBus += grdCampoBus[igB]
								sCondBus += ":" + grdValor[igB]
							}
						}	
						
						if (grdTipoCampoBus[igB] == 6) {   //el campo receptor tiene la fecha en formato texto
							if ( sCondBus != "") { sCondBus += "|" }
							sCondBus += grdCampoBus[igB]
							if (grdEsBusqEstricta[igB] == 1) {
								//sCondBus += ":CONVERT(DATE,'" + grdValor[igB] +"', 105) " 
								sCondBus += ":td6" + grdValor[igB] +"td6:"
							}
						}					
						
						if (grdTipoCampoBus[igB] == 16) {   //el campo receptor tiene la fecha en formato juliano
							if ( sCondBus != "") { sCondBus += "|" }
							sCondBus += grdCampoBus[igB]
							if (grdEsBusqEstricta[igB] == 1) {
								sCondBus += ":td16" + grdValor[igB] +"td16:"
							}
						}
						if (grdTipoCampoBus[igB] == 17) {   //el campo receptor tiene la fecha en formato date
							if ( sCondBus != "") { sCondBus += "|" }
							sCondBus += " (" + grdCampoBus[igB] + ":td17" + grdValor[igB] + "tdm17" + grdCampoBus[igB] + "tdmd17" + grdValor[igB] + "td17:"
						}						
						if (grdTipoCampoBus[igB] == 18) {   //el campo receptor tiene la fecha en formato datetime
							if ( sCondBus != "") { sCondBus += "|" }
							sCondBus += " (" + grdCampoBus[igB] + ":td18" + grdValor[igB] + "tdm18" + grdCampoBus[igB] + "tdmd18" + grdValor[igB] + "td18:"
						}											
					
						if (grdTipoCampoBus[igB] == 5 || grdTipoCampoBus[igB] == 2) {
							if ( sCondBus != "") { sCondBus += "|" }
							if (grdValor[igB] > 0) {
								sCondBus += grdCampoBus[igB]	
								sCondBus += ":1" 
							} else {
								sCondBus += grdCampoBus[igB]	
								sCondBus += ":0" 						
							}
						}
						
						if (grdTipoCampoBus[igB] == 11 ) {
							var sRango = String(grdValor[igB])
							var sRango = DSITrim(sRango)
							if (DSITrim(sRango) == ",") {
								sRango = ""
							}
							if (sRango != ""){ 
								if ( sCondBus != "") { sCondBus += "|" }
								if (sRango.indexOf(",") == 0 || sRango.indexOf(",") == sRango.length-1 ) {	
									//se envio solo uno de los rangos
									sRango = sRango.replace(/,/gi, "")
									grdValor[igB] = DSITrim(sRango)
									sCondBus += grdCampoBus[igB]
									sCondBus += ":¬" + grdValor[igB]  +"¬"
								} else {
									sRango = sRango.replace(/,/gi, "sr11")
									sCondBus += grdCampoBus[igB]
									sCondBus += ":R11" + sRango  +"R11"
								}
							}
						}	
						
						if (grdTipoCampoBus[igB] == 12 ) {
							if ( sCondBus != "") { sCondBus += "|" }
							sCondBus += grdCampoBus[igB]
//							var sRango = grdValor[igB])
                            sCondBus += ":R12" + grdValor[igB]  +"R12"
						}									
						
					}
						if (iIQonDebug == 1) {Response.Write("<br />544 campo" + grdCampoBus[igB] + " valor = " +  grdValor[igB] + "  sCondBus  " + sCondBus +"<br />")}
				}
		} else {
			sCondBus = ""
			ParametroCambiaValor("ConBus","")
		}

	if (sCondBus == "" ) { sCondBus = Parametro("ConBus","")}
	if (iIQonDebug == 1) {Response.Write("<br />552 sCondBus" + sCondBus +"<br />")}
	
	
var sGridllaves = ""
var sGridCompleto = "<div id=" + sC + "ContenidoGrid" + sC + "></div>"
	
//coloco los campos ocultos y llaves	
//   Campo,EsPermanente

	var arrOcSec  = new Array(0)
	var arrOc     = new Array(0)

	if (!EsVacio(arrOcultos) ) {
		arrOcSec = arrOcultos.split("|")
		for (j=0;j<arrOcSec.length;j++) {
			var Txt = String(arrOcSec[j])
			var arrOc = Txt.split("{")
			if (arrOc[1] == 0) {
				sGridllaves += "<input type=" + sC + "hidden" + sC + " name=" + sC + arrOc[0] + sC  
				sGridllaves += " id=" + sC + arrOc[0] + sC + " value=" + sC
				sGridllaves +=  Parametro(String(arrOc[0]),-1)
				sGridllaves += sC + " > "
			}
		}
	}
	for (t=0;t<LLaveCampo.length;t++) {
		if (LLavePP[t] == "No") {
			if (LLaveHeredada[t] == 0) {
				sGridllaves += "<input type=" + sC + "hidden" + sC + " name=" + sC + LLaveCampo[t] + sC  
				sGridllaves += " id=" + sC + LLaveCampo[t] + sC + " value=" + sC
				sGridllaves +=  LLaveValor[t]
				sGridllaves += sC + " > "	
			}
		}	
	}	
	
	
	if (iAbrirNuevaVentana == 1 ) {
		sGridCompleto += "<div id=\"simplemodal-container\" style=\"display:none\"><div id=\"content\"><div id=\"basic-modal\"></div><div id=\"basic-modal-content\"></div>"
		sGridCompleto += "<div style=\"display:none\"><img src=\"/img/x.png\" width=\"25\" height=\"29\" /></div></div></div>"
	}
Response.Write(sGridllaves)		
Response.Write(sGridCompleto)	
%>	
	
<!-- Aqui va la funcion de llamada -->
<script type="text/javascript"> 


function grSelecciona(<%
	var sPrmSerial = "";
	for (t1=0;t1<LLaveCampo.length;t1++) {	
		if (LLaveHeredada[t1] == 0) {
			if ( sPrmSerial != "") {sPrmSerial += ", "}
			sPrmSerial += "prm" + LLaveCampo[t1];
		}
	}
	Response.Write(sPrmSerial) %>) {
	var iVS = 0;
	$("#Accion").val("Consulta");
	<%
	for (t2=0;t2<LLaveCampo.length;t2++) {
		if (LLaveHeredada[t2] == 0) {
			Response.Write("$('#" + LLaveCampo[t2] + "').val(prm" + LLaveCampo[t2] + ");   ")
		}
	}
	%>
	 if (iSigVentana == 0 ) { 
     	iVS = iActualVentana; 
     } else {
		iVS = iSigVentana; 
     }	
	 CambiaVentana(<%=SistemaActual%>,iVS); 
}


</script>

<input type="hidden" name="SQLC"     id="SQLC"     value="<%=SQLCondicion%>" >
<input type="hidden" name="ConBus"   id="ConBus"   value="<%=sCondBus%>" >
<input type="hidden" name="PaginaActual"   id="PaginaActual"   value="1" >
<%
if (iIQonDebug == 1) { 
	Response.Write("<br>sPrmSerial = " + sPrmSerial + "<br>") 

}
%>