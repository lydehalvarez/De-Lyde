<!--#include file="../../Includes/iqon.asp" -->
<%

	var iIQonDebug = 0

	LeerParametrosdeBD()
	
	var SistemaActual = Parametro("SistemaActual",0)
	var VentanaIndex  = Parametro("VentanaIndex",0)
	var IDUsuario = Parametro("IDUsuario",Session("IDUsuario"))
	var UsuarioTpo = Parametro("UsuarioTpo",Session("UsuarioTpo"))
	var SegGrupo = Parametro("SegGrupo",Session("SegGrupo"))
	ParametroCambiaValor("UsuarioTpo",UsuarioTpo)
	ParametroCambiaValor("SegGrupo",SegGrupo)
	var iWgCfgID = Parametro("iWgCfgID",0)
	var AccionDePaginacion = Parametro("AccionDePaginacion",0)
	
//Importante:
// cuando el campo tenga como prefijo una tabla ej clientes.Cli_ID  debera usarse un alias forzosamente

		
	var sC            = String.fromCharCode(34)
	var sWH9          = " width=" + sC + "9" + sC + " height=" + sC + "9" + sC +" "
	var sAL           = " align=" + sC + "left" + sC + " "
	var sAC           = " align=" + sC + "center" + sC + " "
	var sPadding      = " style=" + sC + "padding-right: 5px;padding-left: 5px;" + sC + " "
	var sIniciaTabla  = "<ta" + "ble width=" + sC + "100%" + sC + " border=" + sC + "0" + sC + " cellspacing=" + sC 
		sIniciaTabla  +=  "0" + sC + " cellpadding=" + sC + "0" + sC  + " " 

	var sEncabezado    = ""
	var sPaginacion    = ""
	var iCampos        = -1
	var grdCampo       = new Array(0)         //  estos son los campos que se mostraran en el grid
	var grdNombre      = new Array(0)        //   como es una vista o una consulta pueden ser de varias tablas sin problema
	var grdAlias       = new Array(0)       //    en caso de haber una inconsistencia del tipo campo duplicado entonces se debera usar un alias para los campos
	var grdTipo        = new Array(0)	   //     pero esto solo se pondra en la configuracion no aqui
	var grdAncho       = new Array(0)
	var grdAlineacion  = new Array(0)
	var grdClass       = new Array(0)
	
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
	
	var iCamposBus        = -1
	var grdCampoBus       = new Array(0)
	var grdTipoCampoBus   = new Array(0)
	var grdValorDefBus    = new Array(0)
	var grdValor          = new Array(0)
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
	var iSQLVieneDeBuscador = -1
	var iMGrdTPuedeAgregar = 0
	var iMGrdTPuedeEditar = 1
	var iMGrdTPuedeBorrar = 0
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
	var iPag = 0
	var bLoBusco      = false
	var LlaveABuscar  = 0
	

	IniciaDebugBD()

	//sMnuCondicion = "Mnu_ID = " + VentanaIndex + " and Sys_ID = " + SistemaActual
	//iIniciaSinParametros = BuscaSoloUnDato("Mnu_IniciaSinParametros","Menu",sMnuCondicion,0,2)
	//if (iIniciaSinParametros==1) {
	//	MantenSoloParametrosPermanente()
	//}
	
	
	// ======== LEE LOS CAMPOS QUE FORMAN EL ENCABEZADO Y LOS QUE MOSTRARAN LA INFORMACI�N
	var sATCps = "SELECT * "
		sATCps += " ,ISNULL((Select PP_Nombre "
		sATCps +=           "  from ParametrosPermanentes "
		sATCps +=           " where ParametrosPermanentes.PP_Nombre = MenuGridCampos.MGrd_Campo "
		sATCps +=           "   and Sys_ID = " +  SistemaActual 
		sATCps +=           "   and PP_Habilitado = 1),'No') as PP "  //mapeo los campos contra los parametros permanentes
		sATCps += "  FROM MenuGridCampos "
		sATCps += " WHERE MGrd_Habilitado = 1 "
		sATCps += "   AND Sys_ID = " + SistemaActual
		sATCps += "   AND WgCfg_ID = " + iWgCfgID
		//sATCps += "    AND Mnu_ID = " + VentanaIndex
		sATCps += " ORDER BY MGrd_Orden "	
		if (iIQonDebug == 1) {
			Response.Write("<br><font color='red'><strong>Campos_Encabezado_Info&nbsp;<br>" + sATCps + "</strong></font><br />")
		}

	var rsEnc = AbreTabla(sATCps,1,2)
	while (!rsEnc.EOF){
		if (rsEnc.Fields.Item("MGrd_EsLlave").Value == 1 || rsEnc.Fields.Item("MGrd_EsLlavePrimaria").Value == 1) {
			iCamposLL++
			LLaveCampo[iCamposLL]   = rsEnc.Fields.Item("MGrd_Campo").Value
			LLavePP[iCamposLL]      = rsEnc.Fields.Item("PP").Value
			LLavePK[iCamposLL]      = 0
			LLaveCondicion[iCamposLL] = rsEnc.Fields.Item("MGrd_UsarParaConsulta").Value
			LLaveFormato[iCamposLL] = "N"
			LLaveValor[iCamposLL]   = "" + FiltraVacios(Parametro(String(LLaveCampo[iCamposLL]),""))  //la cargo con el valor que venga volando
			if (!bCpoLL) {
				LLavePK[iCamposLL]  = rsEnc.Fields.Item("MGrd_EsLlavePrimaria").Value    // solo debera ser un campo llave primaria y solo se usara el primero
				if (LLavePK[iCamposLL] == 1 ) {                                         //  que se encuente y sera usado para mandarlo como parametro
					bCpoLL       = true 
					if (!EsVacio("" + rsEnc.Fields.Item("MGrd_Alias").Value)) {
						sqCampoLlave = "" + rsEnc.Fields.Item("MGrd_Alias").Value
						sqCampoLlavePrefijo = LLaveCampo[iCamposLL]                    //prefijo porque en la configuracion puede venir prefijado por la tabla
						sqCampoLlavePrefijo += " as " + sqCampoLlave
					} else {                                                           //pero debera entonces tener un alias
						sqCampoLlave = LLaveCampo[iCamposLL]
						sqCampoLlavePrefijo = LLaveCampo[iCamposLL]
					}
				}
			}
			//Los campos llave siempre son tratados como oculto aunque no se marque como tal
		} else {
			if ( rsEnc.Fields.Item("MGrd_EsCampoOculto").Value == 0 ) {
				iCampos++
				grdCampo[iCampos]      = rsEnc.Fields.Item("MGrd_Campo").Value
				grdNombre[iCampos]     = rsEnc.Fields.Item("MGrd_Nombre").Value
				grdAlias[iCampos]      = FiltraVacios(rsEnc.Fields.Item("MGrd_Alias").Value)
				grdTipo[iCampos]       = rsEnc.Fields.Item("MGrd_TipoCampo").Value
				grdAncho[iCampos]      = rsEnc.Fields.Item("MGrd_AnchoColumna").Value
				grdAlineacion[iCampos] = rsEnc.Fields.Item("MGrd_Alineacion").Value
				grdClass[iCampos]      = rsEnc.Fields.Item("MGrd_Class").Value
			} else { 
				iCamposO++
				ocultoNombre[iCamposO] = rsEnc.Fields.Item("MGrd_Campo").Value
				ocultoParam[iCamposO]  = rsEnc.Fields.Item("MGrd_Alias").Value
				ocultoPP[iCamposO]     = String(rsEnc.Fields.Item("PP").Value)  //guardo en el arrego de los ocultos si es un parametro permanente
			}
		}			
		if (rsEnc.Fields.Item("MGrd_UsarParaOrdenar").Value == 1 ) {
			if (CampoOrden != "" ) { CampoOrden += ", " }
			if (EsVacio("" + rsEnc.Fields.Item("MGrd_Alias").Value)) {
				CampoOrden += rsEnc.Fields.Item("MGrd_Campo").Value
			} else {
				CampoOrden += rsEnc.Fields.Item("MGrd_Alias").Value
			}
		}
		
		rsEnc.MoveNext()
	}

	var sCondicionPorParametro = ""   //  para arreglo de condiciones posicion: 1= campo 2=nombreparametreo 3=ValorDefault 4=formato separado por comas y pipes
	                                 //   ejemplos; Cli_ID,Cli_ID,-1,N|Cont_ID,Cont_ID,-1,N|Dir1_ID,Cli_ID,-1,N este ultimo transfiero a dir1 el valor de cliid		
									//    si el valor viene en -1 no es coniderado como elemento de busqueda en la consulta	
								   //	  NOTA: Solo estos parametros se usaran en el where de la consulta
	
	var sATTb = "SELECT * "
		sATTb += " FROM MenuGridTablas "
		sATTb += " WHERE  Sys_ID = " + SistemaActual
		sATTb += " AND WgCfg_ID = " + iWgCfgID
		//sATTb += " AND Mnu_ID = " + VentanaIndex
		if (iIQonDebug == 1) {
			Response.Write("<font color='red'><strong>TablaAManejar&nbsp;" + sATTb + "</strong></font><br />")
		}

	var rsEncTB = AbreTabla(sATTb,1,2)
	if (!rsEncTB.EOF){
			SQLTabla               = FiltraVacios(rsEncTB.Fields.Item("MGrdT_SQLTabla").Value)
			SQLCondicion           = FiltraVacios(rsEncTB.Fields.Item("MGrdT_SQLCondicion").Value)
			SQLOrden               = FiltraVacios(rsEncTB.Fields.Item("MGrdT_SQLOrden").Value)
			iSQLVieneDeBuscador    = rsEncTB.Fields.Item("MGrdT_VieneDeBuscador").Value
			iMGrdTPuedeAgregar     = rsEncTB.Fields.Item("MGrdT_PuedeAgregar").Value
			iMGrdTPuedeEditar      = rsEncTB.Fields.Item("MGrdT_PuedeEditar").Value
			iMGrdTPuedeBorrar      = rsEncTB.Fields.Item("MGrdT_PuedeBorrar").Value
			sCondicionPorParametro = FiltraVacios(rsEncTB.Fields.Item("MGrdT_CondicionPorParametro").Value)
	}
	rsEncTB.Close()
	
	
	
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
				LLaveCampo[iCamposLL]   = arrCampo[0]
				LLaveCondicion[iCamposLL] = 1
				LLavePP[iCamposLL]      = 0                  //si el parametro fuera permanente seria ignorado y escrito por el parametro condicionado
				LLavePK[iCamposLL]      = 0                  //porque por def el valor cae y si lo obligas es porque necesitas cambiarlo
				LLaveValor[iCamposLL]   = FiltraVacios(Parametro(String(arrCampo[1]),String(arrCampo[2])))   //la cargo con el valor indicado
				LLaveFormato[iCamposLL] = arrCampo[3]	
			}
		}
	}
	
	
	for (t=0;t<LLaveCampo.length;t++) {
		if (!EsVacio(LLaveValor[t]) && LLaveValor[t] != "-1" && LLaveCondicion[t] == 1) {
			if (SQLCondicion != "") {
				SQLCondicion += " AND "
			}
			SQLCondicion += " " + LLaveCampo[t] + " = " + LLaveValor[t]
			//pendiente falta poner el tipo de dato N=numero F=fecha T=texto para clavarle unas comillas o el formato de fecha
		}	
	}
	if (sqCampoLlavePrefijo == "") { Response.Write("<br>Falta configurar el campo llave principal<br>") }
	
	sEncabezado = sIniciaTabla + " class=" + sC + "TablaGeneral" + sC + "><tr class=" + sC + "TablaEncabezado" + sC + ">"
	sEncabezado +="<tr class=" + sC + "TablaEncabezado" + sC + "><td width=" + sC + "20" + sC + " class=" + sC + "TablaEncabezado" + sC + " >No.</td>"

	var sConsultaGral = ""
	for(ig=0;ig<grdCampo.length;ig++){ 
			sEncabezado +="<td width=" + sC + grdAncho[ig] + sC + " "
			sEncabezado +="align=" + sC + grdAlineacion[ig] + sC + " "
			sEncabezado +="class=" + sC + grdClass[ig] + sC + ">"
			sEncabezado += grdNombre[ig] +"</td>"
			if (sConsultaGral != "" ) { sConsultaGral += ", " }
			sConsultaGral += grdCampo[ig]
			if (!EsVacio(grdAlias[ig])) { sConsultaGral += " as " + grdAlias[ig] }
	}
	if (iMGrdTPuedeBorrar == 1 || iMGrdTPuedeEditar == 1) {
		sEncabezado +="<td width=" + sC + "80" + sC + " align=" + sC + "center" + sC + " class=" + sC + "TablaEncabezado" + sC + ">&nbsp;</td>"
	}
	sEncabezado +="</tr>"

	
	var sArCampos = sqCampoLlavePrefijo + ", " + sConsultaGral 
	sConsultaGral = "SELECT " + sqCampoLlavePrefijo + ", " + sConsultaGral  + " "
	sConsultaGral += " FROM " + SQLTabla + " "

	if (EsVacio(SQLCondicion)) {
		SQLCondicion = ""
	}

	//  ==================== VIENE DE ALGUN BUSCADOR ====================

	if (iSQLVieneDeBuscador > -1 && AccionDePaginacion == 0) {

		var sSQLCamposBus  = " SELECT * FROM MenuFichaCampos "
			sSQLCamposBus += " WHERE MFC_Habilitado = 1 "
			sSQLCamposBus += "  AND WgCfg_ID = " + iSQLVieneDeBuscador
			sSQLCamposBus += "  AND Sys_ID = " + SistemaActual
		if (iIQonDebug == 1) {
			Response.Write("<br /><font color='red'><strong>CamposAManejar_SIVIENEDEBUSCADOR&nbsp;<br />" + sSQLCamposBus + "</strong></font><br />")
		}
			
		var rsSQLCamposBus = AbreTabla(sSQLCamposBus,1,2)
		
		while (!rsSQLCamposBus.EOF){
		
				iCamposBus++
				grdCampoBus[iCamposBus]  		= rsSQLCamposBus.Fields.Item("MFC_Campo").Value
				grdTipoCampoBus[iCamposBus] 	= rsSQLCamposBus.Fields.Item("MFC_TipoCampo").Value
				grdValorDefBus[iCamposBus]  	= FiltraVacios(rsSQLCamposBus.Fields.Item("MFC_ValorDefault").Value)
				if ( grdTipoCampoBus[iCamposBus] == 5 && EsVacio(grdValorDefBus[iCamposBus])) {
					grdValorDefBus[iCamposBus] = 0
				}
				grdIDCatGralBus[iCamposBus]     = rsSQLCamposBus.Fields.Item("MFC_IDCatalogoGeneral").Value
				grdCboTablaBus[iCamposBus]      = rsSQLCamposBus.Fields.Item("MFC_ComboTabla").Value
				grdEsBusqEstricta[iCamposBus]	= rsSQLCamposBus.Fields.Item("MFC_EsBusqEstricta").Value
				grdValor[iCamposBus]            = Parametro(grdCampoBus[iCamposBus],grdValorDefBus[iCamposBus])
				
			rsSQLCamposBus.MoveNext()
		}
		
		rsSQLCamposBus.Close()


//1 texto
//2 o ption
//5 check
//7 Catalogo
//4 Combo
//6 Fecha

		var sCondBus = ""

			for(igB=0;igB<grdCampoBus.length;igB++){
				if (grdValor[igB] != "") {
					if (grdTipoCampoBus[igB] == 1 ) {
						if ( sCondBus != "") { sCondBus += " AND " }
						sCondBus += " " + grdCampoBus[igB]
						if (grdEsBusqEstricta[igB] == 1) {
							sCondBus += "= '" + grdValor[igB]  +"' "
						} else {
							sCondBus += " LIKE '%" + grdValor[igB] +"%' "
						}
					}				

					if (grdTipoCampoBus[igB] == 7 || grdTipoCampoBus[igB] == 4) {
						if (grdValor[igB] > -1) {
							if ( sCondBus != "") { sCondBus += " AND " }
							sCondBus += " " +  grdCampoBus[igB]
							sCondBus += " = " + grdValor[igB]
						}
					}	
					
					if (grdTipoCampoBus[igB] == 6) {
						if ( sCondBus != "") { sCondBus += " AND " }
						sCondBus += " " + grdCampoBus[igB]
						if (grdEsBusqEstricta[igB] == 1) {
							sCondBus += " = CONVERT(DATE,'" + grdValor[igB] +"', 105) "
						}
					}				
				
				    if (grdTipoCampoBus[igB] == 5 || grdTipoCampoBus[igB] == 2) {
						if ( sCondBus != "") { sCondBus += " AND " }
						if (grdValor[igB] > 0) {
							sCondBus += " " + grdCampoBus[igB]	
							sCondBus += " = 1 " 
						} else {
							sCondBus += " " + grdCampoBus[igB]	
							sCondBus += " = 0 " 						
						}
					}
	
				}
			}

		if (EsVacio(sCondBus)) { sCondBus = ""  }

		if (sCondBus != "") {
			var stmpep = EscribeParametrosdeBusquedaBD(sCondBus)
			//Response.Write("<br>--------------------------------------------------------------------------------------------<br>")
//			Response.Write("<br> Escribiendo en la BD la consulta calculada -" + stmpep + "-")			
		}

		if (sCondBus != "") {
			if (SQLCondicion != "") { SQLCondicion += " AND " }
			SQLCondicion += sCondBus
		}
	}	
	

//Response.Write("<br>--------------------------------------------------------------------------------------------")
	if (iIQonDebug == 1) {
		Response.Write("<font color='red'><strong>sConsultaGral&nbsp;" + sConsultaGral + "</strong></font><br />")
	}
	if (iIQonDebug == 1) {
		Response.Write("<br> sCondBus -" + sCondBus)
		Response.Write("<br> SQLCondicion -" + SQLCondicion)
	}
	
//Response.Write("<br>--------------------------------------------------------------------------------------------<br><br>")
	if (EsVacio(sCondBus)) {
		sCondBus = LeerParametrosdeBusquedaBD() 
				if (EsVacio(sCondBus)) { sCondBus = ""  }  //esto es porque el wy venia null de pronto 
//Response.Write("<br>condicion de busqueda leida de la bd " + sCondBus )
		
		if (SQLCondicion != "" && sCondBus != "" ) { SQLCondicion += " AND " }  
		SQLCondicion += sCondBus
	}
//Response.Write("<br> sCondBus -" + sCondBus + "-")
//Response.Write("<br> SQLCondicion -" + SQLCondicion + "-")
//Response.Write("<br>--------------------------------------------------------------------------------------------<br><br>")
	if (iIQonDebug == 1) {	
		Response.Write("<br><font color='red'><strong>SQLCondicion&nbsp;" + SQLCondicion + "</strong></font>")
	}
	//  ==================== VIENE DE ALGUN BUSCADOR ====================
	
	if (SQLCondicion != "") {
		sConsultaGral += " WHERE " + SQLCondicion + " "
	}
	
	if (!EsVacio(SQLOrden)) {
		sConsultaGral += " ORDER BY " + SQLOrden + " "
	} else {
		if (!EsVacio(CampoOrden)) {	sConsultaGral += " ORDER BY " + CampoOrden }
	}

		if (Parametro("IDUsuario",0) == 358 || iIQonDebug == 1 ) {
			Response.Write("<br><font color='red'><strong>CONSULTA DEL GRID<br>" + sConsultaGral+ "</strong></font>")
		}
		
		
//Response.Write("<br>SQL Consulta " + sConsultaGral  )		
//Response.Write("<br> sCondBus -" + sCondBus + "-")
//Response.Write("<br> SQLCondicion -" + SQLCondicion + "-")
//Response.Write("<br> SQLOrden -" + SQLOrden + "-")
//Response.Write("<br> campos -" + sArCampos + "-")

//var sCondCE = "Cam_ID = " + CamID + " and " + sLL + " = " + UsuID
var iRegistros = BuscaSoloUnDato("Count(*)",SQLTabla,SQLCondicion,0,0)
//Response.Write("<br>Elementos "  + iRegistros )


iPag = parseInt(iRegistros / iRegPorPagina)
if((iRegistros % iRegPorPagina) > 0) { iPag++ }
//Response.Write("<br>Paginas " + iPag)


var sGridCompleto = ArmaPaginacion(iPag,iRegistros)
	sGridCompleto += sEncabezado
	sGridCompleto += "<div id=" + sC + "ContenidoGrid" + sC + "></div>"
	

Response.Write(sGridCompleto)



function ArmaPaginacion(iPaginas,iRegistros) {
	var sPaginacion = ""

	sPaginacion += "<table width=" + sC + "100%" + sC + " border=" + sC + "0" + sC + " cellpadding=" + sC + "0" + sC + " cellspacing=" + sC + "0" + sC + ">"
	if (iMGrdTPuedeAgregar == 1 && Session("Agregar") == 1) {
		sPaginacion += "<tr><td height=" + sC + "24" + sC + " colspan=" + sC + "11" + sC + " align=" + sC + "right" + sC + ">"
		sPaginacion += "<input type=\"button\" name=\"grbtnNuevo\" id=\"grbtnNuevo\" value=\"Nuevo\" onclick=\"javascript:grSelecciona(-1);\" />"
		sPaginacion += "</td></tr>"
	}
	sPaginacion += "<tr><td height=" + sC + "5" + sC + " colspan=" + sC + "11" + sC + "></td></tr>"
	sPaginacion += "<tr><td height=" + sC + "1" + sC + " colspan=" + sC + "11" + sC + " bgcolor=" + sC + "#000033" + sC + "></td></tr>"
	sPaginacion += "<tr >"
	sPaginacion += "<td width=" + sC + "5%" + sC + " align=" + sC + "left" + sC + " background=" + sC + "/Plugins/Grid_IQon/img/Fondo.jpg" + sC + "><img src=" + sC + "/Plugins/Grid_IQon/img/Boton.jpg" + sC + " width=" + sC + "24" + sC + " height=" + sC + "25" + sC + " /></td>"
	sPaginacion += "<td width=" + sC + "71%" + sC + " height=" + sC + "22" + sC + " align=" + sC + "right" + sC + " background=" + sC + "/Plugins/Grid_IQon/img/Fondo.jpg" + sC + " class=" + sC + "fontBlack" + sC + "> Registros por p&aacute;gina "
	sPaginacion += "<select name=" + sC + "RegPorVentana" + sC + " onchange=" + sC + "AcPaginacion(this.value)" + sC + " class=" + sC + "fontBlack" + sC + ">"
	sPaginacion += "<option value=" + sC + "10" + sC 
	if ( iRegPorPagina <= 10) { sPaginacion += "selected " } 
	sPaginacion += ">10</option><option value=" + sC + "12" + sC 
	if ( iRegPorPagina == 12) { sPaginacion += "selected " } 
	sPaginacion += ">12</option><option value=" + sC + "18" + sC
	if ( iRegPorPagina == 18) { sPaginacion += "selected " } 
	sPaginacion += ">18</option><option value=" + sC + "20" + sC
	if ( iRegPorPagina == 20) { sPaginacion += "selected " } 
	sPaginacion += ">20</option><option value=" + sC + "30" + sC
	if ( iRegPorPagina == 30) { sPaginacion += "selected " } 
	sPaginacion += ">30</option><option value=" + sC + "50" + sC
	if ( iRegPorPagina == 50) { sPaginacion += "selected " } 
	sPaginacion += ">50</option><option value=" + sC + "100" + sC
	if ( iRegPorPagina == 100) { sPaginacion += "selected " } 
	sPaginacion += ">100</option><option value=" + sC + "10000" + sC
	if ( iRegPorPagina > 100) { sPaginacion += "selected " } 
	sPaginacion += ">todos        </option></select>"

	//Parametros necesarios de la p�gina
//	var ParLetra = ""
//		ParLetra += "Letra="+Parametro("Letra","Todas")+ "&" 		
// 	var iCont = 1
	
//	ParLetra += "TR="+iRegistros+ "&"    
	sPaginacion += "<input type=" + sC + "hidden" + sC + " name=" + sC + "TotalRegistros" + sC + " value=" + sC + iRegistros + sC + ">"
	sPaginacion += "<input type=" + sC + "hidden" + sC + " name=" + sC + "PaginaActual" + sC + " value=" + sC + 1 + sC + ">"
	sPaginacion += "<input type=" + sC + "hidden" + sC + " name=" + sC + "TotalPaginas" + sC + " value=" + sC + iPaginas + sC + ">"
	sPaginacion += "<input type=" + sC + "hidden" + sC + " name=" + sC + "AccionDePaginacion" + sC + " value=" + sC + 1 + sC + ">"

	sPaginacion += "<body  class=" + sC + "fontBlack" + sC + "> Total:" + iRegistros
	sPaginacion += "<body  class=" + sC + "fontBlack" + sC + "> &nbsp;Registros&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;"
	sPaginacion += "P&aacute;gina actual&nbsp;&nbsp;"
	sPaginacion += "<select name=" + sC + "IrAPagina" + sC + "  onchange=" + sC + "AcIrAPagina(this.value)" + sC + "  class=" + sC + "fontBlack" + sC + " >"     
	
	for (i = 1; i <= iPaginas; i++) {
		if (1 == i) {
			sPaginacion += "<option value=" + sC + i + sC + " selected >" + i + "</option>"
		} else {
			sPaginacion += "<option value=" + sC + i + sC + " >" + i + "</option>"
		}
	}
	sPaginacion += "</select>"
	sPaginacion += "&nbsp; de &nbsp;" + iPaginas + "&nbsp; P&aacute;ginas&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>"


//	if (iPaginas > 1) {
//		if (iPaginaActual > 1) {
//			var Anterior = parseInt(iPaginaActual) - 1 
//			sPaginacion += "<td width=" + sC + "3%" + sC + " align=" + sC + "left" + sC + " background=" + sC + "/Plugins/Grid_IQon/img/Fondo.jpg" + sC + ">"
//			sPaginacion += "<a href=" + sC + "javascript:AcIrAPagina(1)" + sC + "><img src=" + sC + "/Plugins/Grid_IQon/img/BtnPrimero.gif" + sC + " border=" + sC + "0" + sC + "></a></td>"
//			sPaginacion += "<td width=" + sC + "3%" + sC + " align=" + sC + "left" + sC + " background=" + sC + "/Plugins/Grid_IQon/img/Fondo.jpg" + sC + ">"
//			sPaginacion += "<a href=" + sC + "javascript:AcIrAPagina(" + Anterior + ")" + sC + "><img src=" + sC + "/Plugins/Grid_IQon/img/BtnAnterior.gif" + sC + " border=" + sC + "0" + sC + "></a></td>"
//		} else { 
			sPaginacion += "<td width=" + sC + "3%" + sC + " align=" + sC + "left" + sC + " background=" + sC + "/Plugins/Grid_IQon/img/Fondo.jpg" + sC + ">"
			sPaginacion += "<img src=" + sC + "/Plugins/Grid_IQon/img/BtnPrimero_off.gif" + sC + " border=" + sC + "0" + sC + "></td>"
			sPaginacion += "<td width=" + sC + "3%" + sC + " align=" + sC + "left" + sC + " background=" + sC + "/Plugins/Grid_IQon/img/Fondo.jpg" + sC + ">"
			sPaginacion += "<img src=" + sC + "/Plugins/Grid_IQon/img/BtnAnterior_off.gif" + sC + " border=" + sC + "0" + sC + "></td>"
//		}
//		if (iPaginas > iPaginaActual) { 
//			var Siguiente = parseInt(iPaginaActual) + 1
//			sPaginacion += "<td width=" + sC + "3%" + sC + " align=" + sC + "right" + sC + " background=" + sC + "/Plugins/Grid_IQon/img/Fondo.jpg" + sC + ">"
//			sPaginacion += "<a href=" + sC + "javascript:AcIrAPagina(" + Siguiente + ")" + sC + " ><img src=" + sC + "/Plugins/Grid_IQon/img/BtnSiguiente.gif" + sC + " border=" + sC + "0" + sC + "></a></td>"
//			sPaginacion += "<td width=" + sC + "3%" + sC + " align=" + sC + "right" + sC + " background=" + sC + "/Plugins/Grid_IQon/img/Fondo.jpg" + sC + ">"
//			sPaginacion += "<a href=" + sC + "javascript:AcIrAPagina(" + iPag + ")" + sC + " ><img src=" + sC + "/Plugins/Grid_IQon/img/BtnUltimo.gif" + sC + " border=" + sC + "0" + sC + " ></a></td>"
//		}  else {
			sPaginacion += "<td width=" + sC + "3%" + sC + " align=" + sC + "right" + sC + " background=" + sC + "/Plugins/Grid_IQon/img/Fondo.jpg" + sC + ">"
			sPaginacion += "<img src=" + sC + "/Plugins/Grid_IQon/img/BtnSiguiente_off.gif" + sC + " border=" + sC + "0" + sC + "></td>"
			sPaginacion += "<td width=" + sC + "3%" + sC + " align=" + sC + "right" + sC + " background=" + sC + "/Plugins/Grid_IQon/img/Fondo.jpg" + sC + ">"
			sPaginacion += "<img src=" + sC + "/Plugins/Grid_IQon/img/BtnUltimo_off.gif" + sC + " border=" + sC + "0" + sC + " ></td>"
//		}
//	}

	sPaginacion += "<td width=" + sC + "3%" + sC + " align=" + sC + "right" + sC + " background=" + sC + "/Plugins/Grid_IQon/img/Fondo.jpg" + sC + ">&nbsp;&nbsp;&nbsp;</td></tr>"
	sPaginacion += "<tr><td height=" + sC + "1" + sC + " colspan=" + sC + "11" + sC + " bgcolor=" + sC + "#000033" + sC + " ></td></tr>"
	sPaginacion += "<tr><td height=" + sC + "2" + sC + " colspan=" + sC + "11" + sC + "></td></tr></table>"

	return sPaginacion
}

%>