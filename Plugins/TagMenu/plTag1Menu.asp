
function TraeRamas(iPadre,SisAct) {
	var sTabsArmados = ""
	
	var sSQL  = "Select * "
		sSQL += " from Menu "
		sSQL += " WHERE Mnu_Padre = " + iPadre
		sSQL += " AND Mnu_EsMenu = 1 " 
		sSQL += " AND Sys_ID = " + SisAct
		sSQL += " AND Mnu_Habilitado = 1 "
		sSQL += " AND Mnu_Tag1 = 1 " 
		sSQL += " Order by Mnu_Orden " 
	
	var rsTab = AbreTabla(sSQL,1,2)
   // Response.Write(sSQL)
		
		while (!rsTab.EOF){
			sTabsArmados += "<li><a href=\""
			if (EsVacio( rsTab.Fields.Item("Mnu_IDLigaDelTab").Value )) {
				sTabsArmados += "javascript:CambiaVentana(" + SisAct + "," + rsTab.Fields.Item("Mnu_ID").Value + ")"
			} else {
				sTabsArmados += "javascript:CambiaVentana(" + SisAct + "," + rsTab.Fields.Item("Mnu_IDLigaDelTab").Value + ")"
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
				sTabsArmados = "<ul class=\"nav\" id=\"mainNav\" >" + sTabsArmados + "</ul>"
			} else {
				sTabsArmados = "<ul>"  + sTabsArmados + "</ul>"
			}
		}
		
		return sTabsArmados
} 


sContenedorMenuTag1 = TraeRamas(0,SistemaActual) 

