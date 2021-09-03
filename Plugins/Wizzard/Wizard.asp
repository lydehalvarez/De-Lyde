<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../Includes/iqon.asp" -->
<%

	var iIQonDebug = 0
	//if (Parametro("IDUsuario",Session("IDUsuario")) == 358) {
//		iIQonDebug = 0
//	}
	LeerParametrosdeBD()

	var SistemaActual = Parametro("SistemaActual",0)
	var VentanaIndex  = Parametro("VentanaIndex",0)
	var IDUsuario     = Parametro("IDUsuario",Session("IDUsuario"))
	var UsuarioTpo    = Parametro("UsuarioTpo",Session("UsuarioTpo"))
	var SegGrupo      = Parametro("SegGrupo",Session("SegGrupo"))
	ParametroCambiaValor("UsuarioTpo",UsuarioTpo)
	ParametroCambiaValor("SegGrupo",SegGrupo)
	var iWgCfgID      = Parametro("iWgCfgID",0)
	var iWgID         = 32 //Parametro("iWgID",0)

	

	var sSQLConfBase = " select MW_Param, MW_PuedeAgregar, MW_PuedeBorrar, MW_PuedeEditar, MW_AlSeleccionarAbrirNuevaVentana "
		sSQLConfBase += " from Menu_Widget "
		sSQLConfBase += " WHERE Sys_ID = " + SistemaActual
		sSQLConfBase += " AND Mnu_ID = "   + VentanaIndex
		sSQLConfBase += " AND Wgt_ID = "   + iWgID
		sSQLConfBase += " AND WgCfg_ID = " + iWgCfgID
	
	var rsConfBase = AbreTabla(sSQLConfBase,1,2)
	if (!rsConfBase.EOF){
	    iAbrirNuevaVentana = rsConfBase.Fields.Item("MW_AlSeleccionarAbrirNuevaVentana").Value
	}
	rsConfBase.Close()

	sGridCompleto += "<input type=" + sC + "hidden" + sC + " name=" + sC + "WgCfg_ID" + sC  
	sGridCompleto += " id=" + sC + "WgCfg_ID" + sC + " value=" + sC
	sGridCompleto +=  iWgCfgID
	sGridCompleto += sC + " > "
	
	sGridCompleto += "<input type=" + sC + "hidden" + sC + " name=" + sC + "Wgt_ID" + sC  
	sGridCompleto += " id=" + sC + "Wgt_ID" + sC + " value=" + sC
	sGridCompleto +=  iWgID
	sGridCompleto += sC + " > "		
	
	sGridCompleto += "<input type=" + sC + "hidden" + sC + " name=" + sC + "SQLC" + sC  
	sGridCompleto += " id=" + sC + "SQLC" + sC + " value=" + sC + SQLCondicion + sC + " > "	
	
	sGridCompleto += "<input type=" + sC + "hidden" + sC + " name=" + sC + "ConBus" + sC  
	sGridCompleto += " id=" + sC + "ConBus" + sC + " value=" + sC + sCondBus + sC + " > "		
	
	
%>