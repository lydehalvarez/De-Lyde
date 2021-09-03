
	sCargaFinal = ""

	var sSQLConfBase = " select MW_FuncionAlTerminar "
		sSQLConfBase += " from Menu_Widget "
		sSQLConfBase += " WHERE Sys_ID = " + SistemaActual
		sSQLConfBase += " AND Mnu_ID = "   + VentanaIndex
		sSQLConfBase += " AND Wgt_ID = "   + iWgID
		//sSQLConfBase += " AND WgCfg_ID = " + iWgCfgID

	var rsConfBase = AbreTabla(sSQLConfBase,1,2)
	if (!rsConfBase.EOF){
	    sCargaFinal = rsConfBase.Fields.Item("MW_FuncionAlTerminar").Value
	}
	rsConfBase.Close()

