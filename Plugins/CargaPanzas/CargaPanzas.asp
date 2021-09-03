

//ASP que usa el plugin para cargar las variables con los nombres de los archivos
// los archivos a usar son el que contiene el asp ejecutable para el ajax
// y estan en la configuracion del menu

var sWgSQL = "select mw.* , wc.* "
	sWgSQL += " from Menu_Widget mw, Widget_Configuracion wc "
	sWgSQL += " where mw.Sys_ID = " + Parametro("SistemaActual",-1)
	sWgSQL += " and mw.Mnu_ID = " + Parametro("VentanaIndex",-1)
    sWgSQL += " and mw.Wgt_ID = wc.Wgt_ID "
    sWgSQL += " and mw.Sys_ID = wc.Sys_ID and mw.WgCfg_ID = wc.WgCfg_ID "
    sWgSQL += " and mw.MW_Habilitado = 1 and wc.WgCfg_Habilitado = 1 and wc.WgCfg_Borrado = 0 "
    sWgSQL += " and mw.WgCfg_ID = wc.WgCfg_ID "
    sWgSQL += " and mw.Wgt_ID = 10 " 
	sWgSQL += " Order by mw.MW_OrdenDeCargado "
    
    

	try {		
		 var rsWG = AbreTabla(sWgSQL,1,2) 
			if (!rsWG.EOF) {
            	ParametroCambiaValor("WgCfg_ID",rsWG.Fields.Item("WgCfg_ID").Value)
                ParametroCambiaValor("Wgt_ID",10)
           		SerializaParametros()
				//iEsPanza  = rsWG.Fields.Item("MW_EsPanza").Value
                var comodinFuncionDespues = "" + rsWG.Fields.Item("MW_FuncionAlTerminar").Value
				comodinArchivoAjax = "" + rsWG.Fields.Item("WgCfg_PanzaEjecutable").Value 
				comodinNombreDiv = "" + rsWG.Fields.Item("MW_NombreDIV").Value 

//				if (FiltraVacios(rsWG.Fields.Item("WgCfg_JS").Value) != "") {
//					sCargaIncludesDeJavaScript = CargaArchivo("" + rsWG.Fields.Item("WgCfg_JS").Value)
//				}
//				if (FiltraVacios(rsWG.Fields.Item("WgCfg_JQ").Value) != "") {
//					sCodigoParaELJQuery += CargaArchivo("" +rsWG.Fields.Item("WgCfg_JQ").Value)
//				}		
                AgregaDebug("Seguimiento en el plugin de Cargapanzas","================== Seguimiento ===   Cargapanzas  =================================")
                AgregaDebug("Parametro de entrada","SistActual = " + Parametro("SistemaActual",-1) + "  VentIndex = " + Parametro("VentanaIndex",-1))
                AgregaDebug("sWgSQL ",sWgSQL)
                 AgregaDebug("comodinArchivoAjax ",comodinArchivoAjax)
                 AgregaDebug("comodinNombreDiv ",comodinNombreDiv)
                AgregaDebug("Fin Seguimiento en Cargapanzas","===============================================================")
			}
		
		rsWG.Close()
			 
	} catch(err) {
		bOcurrioError = true
		AgregaDebug("Error en el plugin de Cargapanzas","================== ERROR   Cargapanzas  ====================================")
		AgregaDebug("Parametro de entrada","SistActual = " + Parametro("SistemaActual",-1) + "  VentIndex = " + Parametro("VentanaIndex",-1))
		AgregaDebug("Fallo el plugin ",rsWG.Fields.Item("Mnu_ID").Value)
		AgregaDebug("Error description ",err.description)
		AgregaDebug("Error number ",err.number)
		AgregaDebug("Error message ",err.message)	  
		AgregaDebug("Fin Error en Cargapanzas","===============================================================")
	}


