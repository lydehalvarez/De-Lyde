<%

function ArmaMenu(iPadre,sEtiqueta) {
	// ROG 30 Junio 2005
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
		sSQL += " AND Sys_ID = 4xxxxxxx"	pa que falle  a wiwi	
		sSQL += " ORDER BY Mnu_Orden "

	var rsMnu = AbreTabla(sSQL,1,0)
	while (!rsMnu.EOF) {
		//if (BuscaSeg(rsMnu.Fields.Item("Mnu_IDSeguridad").Value,String(sSeg))) {
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

			sMenu += "javascript:CambiaVentana(" + rsMnu.Fields.Item("Mnu_ID").Value + ")"

			sMenu += "',1,0,"
			//Checa si tiene hijos
			iID = rsMnu.Fields.Item("Mnu_ID").Value
			sCondicion  = " Mnu_Padre = " + iID
			sCondicion += " AND Mnu_Habilitado = 1 AND Mnu_EsMenu = 1 "
			sCondicion += " AND Sys_ID = 4"
			if (BuscaSoloUnDato("COUNT(*)","Menu",sCondicion,0,0) > 0 ) {
				sMenu += "1"
				sEtiquetaT = sEtiqueta + "_" + iContador
				sMenuT1 = ArmaMenu(iID,sEtiquetaT)
				if (sMenuT1 != "") {
					sMenuT = sEtiquetaT
					sMenuT += " = ["
					sMenuT += "[ ],"
					sMenuT += sMenuT1
					sMenuT += "];     "
					Response.Write(sMenuT)
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
	SubMenu = ""
	var arrMenu = "HM_Array5 = ["
	arrMenu += "[500,"                          // menu_width
	arrMenu += "0,"                             // left_position
	arrMenu += "0,"                            // top_position
	arrMenu += "'#FFFFFF',"                     // font_color #4A5E77
	arrMenu += "'#FFFFFF',"                     // mouseover_font_color
	arrMenu += "'#4C0013',"                     // background_color yellow #960101 #BB0000
	arrMenu += "'#7F7F66',"                     // mouseover_background_color #CC0000 #BB0000      #07488b   #3E4751
	arrMenu += "'#BB0000',"                     // border_color blue
	arrMenu += "'#BB0000',"                     // separator_color
	arrMenu += "1,"                             // top_is_permanent
	arrMenu += "1,"                             // top_is_horizontal
	arrMenu += "0,"                             // tree_is_horizontal
	arrMenu += "1,"                             // position_under
	arrMenu += "0,"                             // top_more_images_visible
	arrMenu += "1,"                             // tree_more_images_visible
	arrMenu += "'null',"                        // evaluate_upon_tree_show
	arrMenu += "'null',"                        // evaluate_upon_tree_hide
	arrMenu += ","                              // right_to_left
	arrMenu += "true,"                          // display_on_click
	arrMenu += "true,"                          // top_is_variable_width
	arrMenu += "true,"                          // tree_is_variable_width
	arrMenu += "],"
	arrMenu += ArmaMenu(0,"HM_Array5")
	arrMenu += "];   "
	Response.Write(arrMenu)
	
}
%>