function ArmaMenu(iPadre,sEtiqueta) {
	// ROG 30 Junio 2005, widget JD 31 enero 2011
	//Cargado del menu principal
	var sMenu = ""
	var sMenuT = ""
	var sMenuT1 = ""
	var iID = 0
	var sEtiquetaT = ""
	var iContador = 0
	var sCondicion = ""
	var sSQLTMP = ""
	var sSQL = " SELECT * FROM Menu "
		sSQL += " WHERE Mnu_Habilitado = 1 "
		sSQL += " AND Mnu_EsMenu = 1 "  
		sSQL += " AND Mnu_Padre = " + iPadre
		sSQL += " AND Sys_ID = " + SistemaActual		
		sSQL += " ORDER BY Mnu_Orden "
        
//var sSQL = " Select * "
//		sSQL += " from Menu ,systobjects "
//		sSQL += " where Mnu_Padre = " + iPadre
//		sSQL += " and Sys_ID = " + SistemaActual
//		sSQL += " and Mnu_ID = 4 "
//		sSQL += " and sys6 = Sys_ID "
//		sSQL += " and sys3 = Mnu_IDSeguridad "
//		sSQL += " and sys2 = " + IDUsuario
//		sSQL += " and sys4 = Mnu_ID "
//		sSQL += " Order by Mnu_Orden "
//Response.Write("<br />" + sSQL)
	var rsMnu = AbreTabla(sSQL,1,2)
	while (!rsMnu.EOF) { 
		//if (SeguridadPuedeConsultar(rsMnu.Fields.Item("Mnu_IDSeguridad").Value)) {
        if (1==1) {
			iContador++
			if (sMenu != "") { sMenu += "," }
			sMenu += "['" + rsMnu.Fields.Item("Mnu_Titulo").Value + "','"
			//sTemp = RutaExtra + rsMnu.Fields.Item("Mnu_Liga").Value
			//if (EsVacio(sTemp)) {
//				sMenu += "#"
//			} else { 
//				sMenu += sTemp
//			}

			sMenu += "javascript:CambiaVentana(" + SistemaActual + ", " + rsMnu.Fields.Item("Mnu_ID").Value + ")"

			sMenu += "',1,0,"
			//Checa si tiene hijos
			iID = rsMnu.Fields.Item("Mnu_ID").Value
			sCondicion  = " Mnu_Padre = " + iID
			sCondicion += " AND Mnu_Habilitado = 1 AND Mnu_EsMenu = 1 "
			sCondicion += " AND Sys_ID = " + SistemaActual	
			if (BuscaSoloUnDato("COUNT(*)","Menu",sCondicion,0,2) > 0 ) {
				sMenu += "1"
				sEtiquetaT = sEtiqueta + "_" + iContador
				sMenuT1 = ArmaMenu(iID,sEtiquetaT)
				if (sMenuT1 != "") {
					sMenuT = sEtiquetaT
					sMenuT += " = ["
					sMenuT += "[ ],"
					sMenuT += sMenuT1
					sMenuT += "];     "
					sTmpComodin02 += sMenuT
				}
			} else {
				sMenu += "0"
			}
			sMenu += "]"
		}
		rsMnu.MoveNext()
	} 
	rsMnu.Close()
	
	return sMenu
}


function EscribeMenuPrincipal() {

	var mnuID = 0
	SubMenu = ""  //rojo obscuro #4C0013   #CC0000
	var arrMenu = "HM_Array5 = [[300,0,0,'#FFFFFF','#FFFFFF','#DC2423','#7F7F66','#BB0000','#BB0000',1,1,0,1,0,1,'null','null',,true,true,true,],"
	arrMenu += ArmaMenu(0,"HM_Array5")
	arrMenu += "];   "
	
	return arrMenu
}

sTmpComodin01 = EscribeMenuPrincipal()

