
function ArmaBotones() {

	var arrPrm = new Array(0)
	var sTabla = ""

	sTabla = "<table width=\"100%\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" >"
	sTabla += "<tr><td height=\"25\" class=\"AreaDeBotones\">"

//    var sABSQL = "select mw.* "
//        sABSQL += " from Menu_Widget mw "
//        sABSQL += " where mw.Sys_ID = " + SistemaActual
//        sABSQL += " and mw.Mnu_ID = " + VentanaIndex
//        sABSQL += " and mw.Wgt_ID = 11 "

//	var rsAB = AbreTabla(sABSQL,1,2)
//			if (!rsAB.EOF) {
//				saBot = rsAB.Fields.Item("MW_Param").Value
                var saBot = wgParam
				if (!EsVacio(saBot) ) {
                    var arrPrm = saBot.split(",")
                    for (i=0;i<arrPrm.length;i++) {
						var btnLetrero = String(arrPrm[i])
						var btnID = btnLetrero.replace(/ /g,"_")
						
						sTabla += "<input name=\"btn" + btnID + "\" type=\"button\" id=\"btn" + btnID + "\" onClick=\"javascript:Ac" + btnID + "();\" value=\"  " + btnLetrero + "  \">"
                    }
                }
//            }
    //sTabla += "<input name=\"btnSeleccionar\" type=\"button\" id=\"btnSeleccionar\" onClick=\"javascript:btSelecciona();\" value=\"  Buscar  \">"
	sTabla += "</tr></table>"

	return sTabla
}        

swgtBotones  = ArmaBotones()
