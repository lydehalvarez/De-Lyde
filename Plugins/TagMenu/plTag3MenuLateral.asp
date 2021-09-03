
function TraeRamas(iPadre,SisAct) {
	var sTabsArmados = ""
	
	var sSQL  = "Select * "
		sSQL += " from Menu "
		sSQL += " WHERE Mnu_Padre = " + iPadre
		sSQL += " AND Mnu_EsMenu = 1 " 
		sSQL += " AND Sys_ID = " + SisAct
		sSQL += " AND Mnu_Habilitado = 1 "
		sSQL += " AND Mnu_Tag1 = 3 " 
		sSQL += " Order by Mnu_Orden " 
	
	var rsTab = AbreTabla(sSQL,1,2)
		
		while (!rsTab.EOF){
			sTabsArmados += "<li "
            if (rsTab.Fields.Item("Mnu_ID").Value == VentanaIndex ) {
            	sTabsArmados += " class=\"current\" "
            }
            sTabsArmados += "><a href=\""
            if (!EsVacio( rsTab.Fields.Item("Mnu_Liga").Value )) {
            	sTabsArmados += "javascript:" + rsTab.Fields.Item("Mnu_Liga").Value 
            } else {
                if (EsVacio( rsTab.Fields.Item("Mnu_IDLigaDelTab").Value )) {
                    sTabsArmados += "javascript:CambiaVentana(" + SisAct + "," + rsTab.Fields.Item("Mnu_ID").Value + ")"
                } else {
                    sTabsArmados += "javascript:CambiaVentana(" + SisAct + "," + rsTab.Fields.Item("Mnu_IDLigaDelTab").Value + ")"
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
                sTabsArmados = "<div class=\"columna BarraLateral\"><div id=\"BarraLateralNav\"><div id=\"BarraLateralNavPadding\"><ul class=\"nav\">" + sTabsArmados + "</ul></div></div></div>"
			} else {
				sTabsArmados = "<ul>"  + sTabsArmados + "</ul>"
			}
		}
		
		return sTabsArmados
} 


sContenedorMenuTag3  = TraeRamas(0,SistemaActual) 


//     <div class="columna BarraLateral">
//        <div id="BarraLateralNav">
//            <div id="BarraLateralNavPadding">            
//                <ul class="nav">
//                    <li class="current"><a href="#">Misión, Visión, Principios y Valores</a></li>
//                    <li class=""><a href="#">História</a></li>
//                    <li class=""><a href="#">Curriculum</a></li>
//                    <li class=""><a href="#">Actividades </a></li>
//                    <li class=""><a href="#">Propósitos</a></li>
//                    <li class=""><a href="#">Preguntas Frecuentes (FAQ)</a></li>
//                    <li class=""><a href="#">Dirección y ubicación</a></li>
//                    <li class=""><a href="#">Perfil de nuestros alumnos</a></li>
//                    <li class=""><a href="#">Directorio</a></li>
//                    <li class=""><a href="#">Simbolos</a></li>
//                    <li class=""><a href="#">Instalaciones</a></li>
//                </ul>
//            </div>
//        </div>
//      </div>
