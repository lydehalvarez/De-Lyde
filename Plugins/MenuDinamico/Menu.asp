<%@LANGUAGE="JAVASCRIPT" CODEPAGE="1252"%> 
<!--#include file="../../Includes/iqon.asp" -->
<%
function ArmaMenu(iPadre,sEtiqueta) {
	// ROG 30 Junio 2005, widget JD 31 enero 2011, ROG 24 Ago 2011
	//Cargado del menu principal
	var sMenu = ""
	var sMenuT = ""
	var sMenuT1 = ""
	var iID = 0
	var sEtiquetaT = ""
	var iContador = 0
	var sCondicion = ""
	var sSQLTMP = ""
	var bConSeguridad = false
 
 if (bConSeguridad) {
    var sSQL = " Select * " // Mnu_IDSeguridad,Mnu_Titulo,Mnu_Liga,Mnu_ID,Mnu_Padre,Mnu_Habilitado,Mnu_EsMenu,Sys_ID 
        sSQL += " from Menu ,systobjects "
        sSQL += " where Mnu_Padre = " + iPadre
        sSQL += " and Sys_ID = " + SistemaActual
        sSQL += " and sys1 = 1 "   //solo valido por los permisos de acceso
        sSQL += " and sys6 = " + SistemaActual
        sSQL += " and sys3 = Mnu_IDSeguridad "
        sSQL += " and sys2 = " + IDUsuario
        sSQL += " and Menu.Mnu_Habilitado = 1 "
        sSQL += " AND Menu.Mnu_EsMenu = 1 " 
        sSQL += " AND Menu.Sys_ID = " + SistemaActual 
        sSQL += " Order by Mnu_Orden "
 } else { 
	var sSQL = " SELECT * FROM Menu "
		sSQL += " WHERE Mnu_Habilitado = 1 "
		sSQL += " AND Mnu_EsMenu = 1 "  
		sSQL += " AND Mnu_Padre = " + iPadre
		sSQL += " AND Sys_ID = " + SistemaActual		
		sSQL += " ORDER BY Mnu_Orden "
}
	var rsMnu = AbreTabla(sSQL,1,2)
	while (!rsMnu.EOF) { 
			iContador++
			if (sMenu != "") { sMenu += "," }
            var sTitMNU = rsMnu.Fields.Item("Mnu_Titulo").Value
            //if (bDebugWidgets) { sTitMNU += " " + rsMnu.Fields.Item("Mnu_ID").Value }
            var Ivz =rsMnu.Fields.Item("Mnu_Tag3").Value
            if (bPuedeVerDebug && Ivz > 0 ) {       
            	for(var i=1;i<=Ivz;i++) {
                	sTitMNU += "*" 
                }
            }
			sMenu += "['" + sTitMNU + "','"
			//sTemp = RutaExtra + rsMnu.Fields.Item("Mnu_Liga").Value
			//if (EsVacio(sTemp)) {
//				sMenu += "#"
//			} else { 
//				sMenu += sTemp
//			}
			//Checa si tiene hijos
			iID = rsMnu.Fields.Item("Mnu_ID").Value
			sCondicion  = " Mnu_Padre = " + iID
			sCondicion += " AND Mnu_Habilitado = 1 AND Mnu_EsMenu = 1 "
			sCondicion += " AND Sys_ID = " + SistemaActual	
			if (BuscaSoloUnDato("COUNT(*)","Menu",sCondicion,0,2) > 0 ) {
                //sMenu += "javascript:CambiaVentana(" + SistemaActual + ", " + rsMnu.Fields.Item("Mnu_ID").Value + ")"
                sMenu += ""
                sMenu += "',1,0,1"
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
                sMenu += "javascript:CambiaVentana(" + SistemaActual + ", " + rsMnu.Fields.Item("Mnu_ID").Value + ")"
                sMenu += "',1,0,0"
			}
			sMenu += "]"

		rsMnu.MoveNext()
	} 
	rsMnu.Close()
	
	return sMenu
}


function EscribeMenuPrincipal() {

	var mnuID = 0
	SubMenu = ""  //rojo obscuro #4C0013   #CC0000
    //'#DC2423','#7F7F66','#BB0000','#BB0000'
    
	var arrMenu = "HM_Array5 = [[300,450,50,'#000000','#FFFFFF','#E2E2E2','#E80000','#BB0000','#BB0000',1,1,0,1,0,1,'null','null',,true,true,true,],"
	arrMenu += ArmaMenu(0,"HM_Array5")
	arrMenu += "];   "
	
	return arrMenu
}

sTmpComodin01 = EscribeMenuPrincipal()

%>