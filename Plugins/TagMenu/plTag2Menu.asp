
function TraeRamas(iPadre,SisAct) {
	var sTabsArmados = ""
	
	var sSQL  = "Select * "
		sSQL += " from Menu "
		sSQL += " WHERE Mnu_Padre = " + iPadre
		sSQL += " AND Mnu_EsMenu = 1 " 
		sSQL += " AND Sys_ID = " + SisAct
		sSQL += " AND Mnu_Habilitado = 1 "
		sSQL += " AND Mnu_Tag1 = 2 " 
		sSQL += " Order by Mnu_Orden " 
	
	var rsTab = AbreTabla(sSQL,1,2)
		
		while (!rsTab.EOF){
			sTabsArmados += "<li><a href=\""     
            
            if (!EsVacio( rsTab.Fields.Item("Mnu_LigaArchivoACargar").Value ) ) {
            	sTabsArmados += "" + rsTab.Fields.Item("Mnu_LigaArchivoACargar").Value
            } else {
				if (!EsVacio( rsTab.Fields.Item("Mnu_Liga").Value)) {
					sTabsArmados += "" + rsTab.Fields.Item("Mnu_Liga").Value 
				} else {
					if (!EsVacio( rsTab.Fields.Item("Mnu_IDLigaDelTab").Value ) ) {
						sTabsArmados += "javascript:CambiaVentana(" + SisAct + "," + rsTab.Fields.Item("Mnu_IDLigaDelTab").Value + ")"
					} else {
						sTabsArmados += "javascript:CambiaVentana(" + SisAct + "," + rsTab.Fields.Item("Mnu_ID").Value + ")"
					}			
				}
            }		
			sTabsArmados += "\">"  
			sTabsArmados += rsTab.Fields.Item("Mnu_Titulo").Value + "</a>"
			sTabsArmados += TraeRamas( rsTab.Fields.Item("Mnu_ID").Value,SisAct)
			sTabsArmados += "</li>"
			rsTab.MoveNext()
			
		}
		rsTab.Close()
		
		if (sTabsArmados != ""){
			if (iPadre == 0 ) { 
				sTabsArmados = "<ul class=\"nav\" id=\"utilities\" >" + sTabsArmados + "</ul>"
			} else {
				sTabsArmados = "<ul>"  + sTabsArmados + "</ul>"
			}
		}
		
		return sTabsArmados
} 


sContenedorMenuTag2  = TraeRamas(0,SistemaActual) 
